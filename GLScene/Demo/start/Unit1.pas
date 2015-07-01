unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ComCtrls, 

  jpeg, tga,

  GLCadencer, GLWin32Viewer, GLScene, GLObjects, GLVectorFileObjects,
  GLFile3DS, Vectortypes, VectorGeometry, AsyncTimer, GLBitmapFont,
  GLWindowsFont, GLHUDObjects, GLCoordinates, GLCrossPlatform, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    sph_planet: TGLSphere;
    light: TGLLightSource;
    cube: TGLCube;
    roc: TGLFreeForm;
    AsyncTimer1: TAsyncTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    dc_cam: TGLDummyCube;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    txt_s: TGLHUDText;
    txt_t: TGLHUDText;
    sph_targ: TGLSphere;
    pt: TGLPoints;
    dc_boom: TGLDummyCube;
    bm_ring: TGLPlane;
    bm_sph: TGLSphere;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  public

    procedure rprogress(dt:single);

  end;

var
  Form1: TForm1;
  pusk: boolean;

  m_pos: TPoint;
  m_turn: boolean;

  rstate: integer = 0;
  rdt: single = 0;
  bdt: single = 0;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  randomize;
  roc.LoadFromFile('r.3ds');

  ToolButton1Click(nil);

end;


//
// rocket flight
//
procedure TForm1.rprogress(dt:single);
var
    v: TVector3f;

  function GetPos(t:double):TVector;
  var j:integer; v1,v2: TVector3f;
  begin
    j := floor( t / 2 );
    t := ( t - j * 2 ) / 2;
    with pt.Positions do begin
      v1 := vectorsubtract(vectorscale(
        vectoradd( Items[j], Items[j+1] ), 0.5), Items[j+1] );
      v2 := vectorsubtract(vectorscale(
        vectoradd( Items[j+1], Items[j+2] ), 0.5), Items[j+1] );
      v := vectornormalize(
        vectorsubtract( vectorscale( v2, t ), vectorscale( v1, 1 - t )));
      result := vectormake( vectoradd( Items[j+1], vectoradd(
        vectorscale( v1, ( 1 - t ) * ( 1 - t )), vectorscale( v2, t * t ))));
    end;
  end;
  
begin

  rdt := rdt + dt;
  roc.AbsolutePosition := GetPos( rdt );
  roc.Up.SetVector( v );

  // hit
  if vectorlength(vectorsubtract( roc.AbsolutePosition,
    sph_targ.AbsolutePosition )) < 0.5 then begin

    rdt := 0;
    roc.Visible := false;
    sph_targ.Visible := false;

    dc_boom.Visible := true;
    bdt := 0;
    bm_ring.Position := sph_targ.Position;
    bm_ring.Direction := sph_targ.Position;
    bm_sph.Position := bm_ring.Position;
    
  end;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    j: integer;
    v: TVector3f;

  function GetPos(pos:double):TVector;
  var v1,v2: TVector3f;
  begin
    j := floor( pos / 2 );
    pos := ( pos - j * 2 ) / 2;
    with pt.Positions do begin
      v1 := vectorsubtract(vectorscale(
        vectoradd( Items[j], Items[j+1] ), 0.5), Items[j+1] );
      v2 := vectorsubtract(vectorscale(
        vectoradd( Items[j+1], Items[j+2] ), 0.5), Items[j+1] );
      v := vectornormalize(
        vectorsubtract( vectorscale( v2, pos ), vectorscale( v1, 1 - pos )));
      result := vectormake( vectoradd( Items[j+1],
        vectoradd( vectorscale( v1, ( 1 - pos ) * ( 1 - pos )),
        vectorscale( v2, pos * pos ))));
    end;
  end;

var
    m: TPoint;
begin

  if m_turn then begin
    m := mouse.CursorPos;
    cam.MoveAroundTarget( m_pos.Y - m.Y, m_pos.X - m.X );
    m_pos := m;
  end;

  if rstate = 1 then
    rprogress( deltatime );

  if dc_boom.Visible then begin
    bm_ring.Height := dc_boom.TagFloat;
    bm_ring.Width := dc_boom.TagFloat;
    bm_ring.Material.FrontProperties.Diffuse.Alpha:=1/(1+power(dc_boom.TagFloat,2));
    bm_sph.Radius:=dc_boom.TagFloat*0.1;
    bm_sph.Material.FrontProperties.Diffuse.Alpha:=1/(1+power(dc_boom.TagFloat,2));
    dc_boom.TagFloat:=dc_boom.TagFloat+deltatime;
    end;

  // captions
  v := vp.Buffer.WorldToScreen( cube.Position.AsAffineVector );
  txt_s.Position.SetPoint( v[0], vp.Height - v[1] - 32, 0 );
  v := vp.Buffer.WorldToScreen( sph_targ.Position.AsAffineVector );
  txt_t.Position.SetPoint( v[0], vp.Height - v[1] - 32, 0 );

  vp.Invalidate;

end;


//
// init
//
procedure TForm1.ToolButton1Click;
var
    i,j: integer;
    f1,f2:single;
    v: TVector3f;
    v1,v2,v3,n: TVector;
begin

  rstate := 0;
  rdt := 0;
  bdt := 0;

  // start
  RandomPointOnSphere( v );
  cube.Position.SetPoint(vectorscale(v,6));
  cube.Direction.SetVector(v);
  with roc do begin
    Position := cube.Position;
    Up := cube.Direction;
    visible := true;
  end;

  // target
  repeat
    RandomPointOnSphere( v );
    sph_targ.Position.SetPoint( vectorscale( v, 6 ));
    sph_targ.Up.SetVector( vectornegate( v ));
    sph_targ.Visible := true;
    f1 := VectorAngleCosine( cube.Position.AsAffineVector, v );
    until ( f1 < 0.95 ) and ( f1 > -0.95 );
  dc_boom.Visible := false;

  // track
  v1 := roc.AbsolutePosition;
  v2 := sph_targ.AbsolutePosition;
  with pt.Positions do begin

    Clear;
    f2 := arccos( f1 );
    j := floor( 3.5 * f2 ) + 1;
    n := vectorcrossproduct( v2, v1 );
    v3 := vectorscale( vectornormalize( v1 ), 7 );
    RotateVector( v3, n, f2 / 2 / j );

    for i := 0 to j - 1 do begin
      if i = 0 then
        Add( vectoradd( v1, vectorsubtract( v1, v3 )));
      Add( v3 );
      if i = j - 1 then
        Add( vectoradd( v2, vectorsubtract( v2, v3 )));
      RotateVector( v3, n, f2 / j );
    end;

  end;

end;


//
// launch
//
procedure TForm1.ToolButton2Click;
begin

  pt.Visible := false;
  rstate := 1;

end;


//
// start mouse rotation
//
procedure TForm1.vpMouseDown;
begin

  m_turn := true;
  m_pos := mouse.CursorPos;

end;


//
// stop mouse rotation
//
procedure TForm1.vpMouseUp;
begin

  m_turn := false;

end;


//
// timer
//
procedure TForm1.AsyncTimer1Timer;
begin

  caption := vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

procedure TForm1.FormResize(Sender: TObject);
begin

  vp.FieldOfView := 145;

end;

end.
