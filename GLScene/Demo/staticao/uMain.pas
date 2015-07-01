unit uMain;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, Dialogs, ComCtrls, ExtCtrls,
  Buttons, SysUtils,

  GLWin32Viewer, GLScene, GLFile3DS, GLVectorFileObjects, GLCadencer,
  GLObjects, GLHUDObjects, GLTexture, GLKeyboard, AsyncTimer, VectorGeometry,
  VectorTypes, GLCoordinates, GLCrossPlatform, BaseClasses, GLState,

  uFerma;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    light: TGLLightSource;
    cad: TGLCadencer;
    at: TAsyncTimer;
    model: TGLFreeForm;
    Panel1: TPanel;
    pb: TProgressBar;
    hud: TGLHUDSprite;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label2: TLabel;
    tb: TTrackBar;
    ray_lbl: TLabel;
    Bevel3: TBevel;
    Label3: TLabel;
    cb: TComboBox;
    Button1: TButton;
    th_at: TAsyncTimer;
    cpu_tb: TTrackBar;
    cpu_lbl: TLabel;
    Bevel4: TBevel;
    but_octree: TSpeedButton;
    but_sqrt: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbChange(Sender: TObject);
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vpMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure tbChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure th_atTimer(Sender: TObject);
    procedure cpu_tbChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public

    ferma: TFerma;

    procedure onComplete( ATaskClass:TTaskClass );
    procedure stop;

  end;


var
  Form1: TForm1;

  m_pos: TPoint;
  m_move: boolean;
  m_scale: integer;

  counter: integer = 0;
  pA: TPackA;

implementation

{$R *.dfm}


procedure TForm1.FormShow;
begin

  cad.Enabled := true;

end;


//
// setup
//
procedure TForm1.FormCreate;
begin

  randomize;

  ferma := TFerma.Create(self);
  ferma.onJobComplete := onComplete;

  cpu_tb.Max := ferma.CPUs;
  cpu_tb.Position := cpu_tb.Max;

  cb.OnChange( nil );
  tbChange( nil );
  cpu_tbChange( nil );

end;


procedure TForm1.Button1Click;
var
    i,j: integer;
    v: TVector3f;
begin

  if th_at.Enabled then begin

    ferma.stop;
    stop;
    light.Shining := true;  
    counter := 0;
    exit;
    
  end;

  button1.Caption := 'STOP';

  cad.Enabled := false;
  at.Enabled := false;
  light.Shining := false;  
  counter := GetTickCount;

  // pack
  pA.useOctree := but_octree.Down;
  pA.LnFilter := not but_sqrt.Down;
  setlength( pA.rays, tb.Position * 50 );
  for i := 0 to high(pA.rays) do begin
    RandomPointOnSphere( v );
    setVector( pA.rays[i], model.AbsoluteToLocal( v ));
  end;

  // workers
  ferma.clear;
  ferma.packA := pA;
  ferma.addWorker( TWorkerA, cpu_tb.Position );

  // tasks
  for i := 0 to model.MeshObjects.Count - 1 do
    with model.MeshObjects[i] do
      for j := 0 to vertices.Count - 1 do
        ferma.pushTask( TTaskA.Create( i, j, normals[j], VectorMake(
          VectorAdd( vectorscale( normals[j], 0.001 ), vertices[j]))));

  pb.Position := 0;
  pb.Max := ferma.taskCount;

//  label1.Caption := inttostr( ferma.getWorkerCount( TWorkerA ) );

  ferma.start;

  th_at.Enabled := true;

end;


//
// info
//
procedure TForm1.th_atTimer;
begin

  pb.Position := pb.Max - ferma.taskCount;

end;


//
// on complete
//
procedure TForm1.onComplete( ATaskClass:TTaskClass );
var
    r: TTask;
    i: integer;
begin

  for i := 0 to model.MeshObjects.count - 1 do
    with model.MeshObjects[i] do
      Colors.Count := Vertices.Count;

  while true do begin

    r := ferma.popResult( ATaskClass );
    if r = nil then
      break;
    if r is TTaskA then
      with TTaskA(r), model.MeshObjects[FObj].Colors do begin
        List^[FInd][0] := FCol;
        List^[FInd][1] := FCol;
        List^[FInd][2] := FCol;
      end;

  end;

  model.StructureChanged;
  counter := GetTickCount - counter;

  stop;

end;


//
// stop
//
procedure TForm1.stop;
begin

  cad.Enabled := true;
  at.Enabled := true;

  pb.Position := 0;

  th_at.Enabled := false;
  button1.Caption := 'GEN';

end;


//
// load new model
//
procedure TForm1.cbChange;

  procedure load(mdlName:string; size:single);
  var i:integer;
  begin
    model.LoadFromFile( mdlName );
    model.Scale.Scale( size / model.BoundingSphereRadius );
    pA.modelSize := size;
    pA.modelName := mdlName;
    if fileexists('low_' + mdlName) then
      pA.modelName := 'low_' + mdlName;
  end;

begin

  case cb.ItemIndex of
    0: load('mushroom.3ds', 20);
    1: load('box.3ds', 15);
    2: load('box2.3ds', 15);
    3: load('scene.3ds', 25);
    4: load('tiger.3ds', 20);    
  end;

  pb.Position := 0;
  light.Shining := true;

end;


//
// handling mouse and keyboard
//
procedure TForm1.cadProgress;
begin

  if m_scale <> 0 then begin
    cam.AdjustDistanceToTarget( 1 - m_scale / ( 1 + deltatime) * 0.1 );
    m_scale := 0;
  end;

  if m_move then begin
    with mouse.CursorPos do
      cam.MoveAroundTarget( (m_pos.y - y) / (1 + deltatime),
                            (m_pos.x - x) / (1 + deltatime));
    m_pos := mouse.CursorPos;
  end else
    dc.Turn( -deltatime * 20 );

  with model.Material do
    if iskeydown($57) then PolygonMode := pmLines
      else PolygonMode := pmFill;

end;


//
// remove focus
//
procedure TForm1.vpMouseMove;
begin

  if not vp.Focused then
    vp.SetFocus;

end;


//
// zoom
//
procedure TForm1.vpMouseWheel;
begin

  m_scale := sign(wheeldelta);

end;


//
// start rotation 
//
procedure TForm1.vpMouseDown;
begin

  m_pos := mouse.CursorPos;
  m_move := true;

end;


//
// stop rotation
//
procedure TForm1.vpMouseUp;
begin

  m_move := false;

end;


//
// rays count
//
procedure TForm1.tbChange;
begin

  ray_lbl.Caption := inttostr( tb.Position * 50 );

end;


//
// CPUs count
//
procedure TForm1.cpu_tbChange(Sender: TObject);
begin

  cpu_lbl.Caption := inttostr( cpu_tb.Position );

end;


//
// info
//
procedure TForm1.atTimer;
begin

  caption := format('Static AmbientOcclusion: %.2f / result: %.3f sec',
    [vp.FramesPerSecond, counter / 1000]);
  vp.ResetPerformanceMonitor;

end;


procedure TForm1.FormClose;
begin

  at.Enabled := false;
  th_at.Enabled := false;

end;

end.
