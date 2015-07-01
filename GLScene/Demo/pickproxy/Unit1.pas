unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, 

  GLFile3DS,

  GLScene, GLObjects, GLWin32Viewer, GLCrossPlatform, GLCadencer, GLColor,
  GLVectorFileObjects, GLCoordinates, BaseClasses, GLProxyObjects,
  GLKeyboard, AsyncTimer;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc_world: TGLDummyCube;
    dc_model: TGLDummyCube;
    cad: TGLCadencer;
    ff_G: TGLFreeForm;
    ff_L: TGLFreeForm;
    ff_S: TGLFreeForm;
    light: TGLLightSource;
    at: TAsyncTimer;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure atTimer(Sender: TObject);
  private
  public

    pick: TGLBaseSceneObject;
    pickInfo: AnsiString;

    procedure fillScene;
    procedure SelectObj( obj:TGLBaseSceneObject );

  end;


var
  Form1: TForm1;

  m_pos: TPoint;
  m_move: boolean;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  ff_G.LoadFromFile('g.3ds');
  ff_L.LoadFromFile('l.3ds');
  ff_S.LoadFromFile('s.3ds');

  fillScene;

end;


procedure TForm1.fillScene;
var
    i: integer;
    gc,lc,sc: integer;
begin

  randomize;

  gc := 0;
  lc := 0;
  sc := 0;

  // proxy
  for i := 0 to 10 + random(10) do
    with TGLColorProxy.CreateAsChild(dc_world) do begin
      case random(3) of
        0: begin
          MasterObject := ff_G;
          name := 'G_' + inttostr( gc );
          inc( gc );
          end;
        1: begin
          MasterObject := ff_L;
          name := 'L_' + inttostr( lc );
          inc( lc );
          end;
        2: begin
          MasterObject := ff_S;
          name := 'S_' + inttostr( sc );
          inc( sc );
          end;
      end;
      Position.SetPoint( random(24) - 12, -random(6), random(24) - 12 );
      TurnAngle := random(360);
      Scale.Scale( 0.5 + random );
    end;

  // spheres
  for i := 0 to 3 + random(3) do
    with TGLSphere( dc_world.AddNewChild( TGLSphere )) do begin
      name := 'sph_' + inttostr(i);
      Position.SetPoint( random(30) - 15, random(8) - 4, random(30) - 15 );
      Radius := 0.5 + random;
    end;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  if m_move then begin

    with mouse.CursorPos do
      cam.MoveAroundTarget(( m_pos.Y - y ) * 0.3, ( m_pos.X - x ) * 0.3 );
    m_pos := mouse.CursorPos;

    if not iskeydown( vk_rbutton ) then
      m_move := false;

  end;

  vp.Refresh;

end;


//
// selection
//
procedure TForm1.SelectObj;
var
    i: integer;
    sub: TGLBaseSceneObject;
begin

  if obj = pick then exit;

  for i := 0 to dc_world.Count - 1 do begin
    sub := dc_world.Children[i];

    if sub = obj then begin
      if sub is TGLColorProxy then
        TGLColorProxy(sub).FrontColor.Emission.SetColor( 0, 0.5, 0, 1)
      else
      if sub is TGLCustomSceneObject then
        TGLCustomSceneObject(sub).Material.FrontProperties.
          Emission.SetColor( 0, 0, 0.5, 1 );
    end
    else    
    if sub = pick then begin

      if sub is TGLColorProxy then
        TGLColorProxy(sub).FrontColor.Emission.SetColor( 0, 0, 0, 1 )
      else
      if sub is TGLCustomSceneObject then
        TGLCustomSceneObject(sub).Material.FrontProperties.
          Emission.SetColor( 0, 0, 0, 1 );
    end;
  end;

  pick := obj;

end;


//
// pick or rotation 
//
procedure TForm1.vpMouseDown;
begin

  if shift = [ssright] then begin
    m_pos := mouse.CursorPos;
    m_move := true;
  end;

  if shift = [ssleft] then begin
    SelectObj( vp.Buffer.getpickedobject( x, y ));
    if pick <> nil then
      pickInfo := pick.ClassName + ': ' + pick.Name
    else
      pickInfo := '';
  end;

end;


//
// fps
//
procedure TForm1.atTimer;
begin

  Caption := 'PickProxy: ' + vp.FramesPerSecondText(2) + ' ' + pickInfo;
  vp.ResetPerformanceMonitor;

end;

end.
