unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  GLWin32Viewer, GLScene, GLObjects, GLCadencer, OpenGL1x,
  GLTexture, vectorgeometry, vectortypes, GLVectorFileObjects, GLFile3DS,
  AsyncTimer, GLGeomObjects, GLTerrainRenderer, GLHeightData, jpeg,
  GLKeyboard, GLCoordinates, GLRenderContextInfo,
  GLCrossPlatform, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    DOGL: TGLDirectOpenGL;
    obj: TGLFreeForm;
    at: TAsyncTimer;
    light: TGLLightSource;
    terra: TGLTerrainRenderer;
    hds: TGLBitmapHDS;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure DOGLRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure FormShow(Sender: TObject);
  private
  public
  end;

type TMonster=record
  pos:TVector;
  vel:single;
  end;

var
  Form1: TForm1;
  _m: array[0..100] of TMonster;

  _dt: single=0;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
var
    i: integer;
    a,r: single;
begin

  hds.Picture.LoadFromFile( 'hmap.bmp' );

  obj.LoadFromFile( 'monster.3ds' );
  obj.Scale.Scale( 4 / obj.BoundingSphereRadius );

  randomize;
  for i := 0 to high(_m) do begin
    a := random * 6.2832;
    r := 100 + random(800);
    setvector( _m[i].pos, r * sin(a), 0, r * cos(a));
    _m[i].vel := 3 + random;
  end;

  setcursorpos( width div 2, height div 2 );

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    spd: single;
begin

  _dt := deltatime;

  with mouse.CursorPos, cam, screen do begin
    dc_cam.Turn(( X - (width div 2)) * 0.2);
    PitchAngle := clampvalue(PitchAngle + ((height div 2) - Y) * 0.2, -90, 90);
    setcursorpos( width div 2, height div 2 );
  end;

  if iskeydown(vk_lshift) then spd := 200 * _dt
    else spd := 50 * _dt;

  if iskeydown(ord('W')) or iskeydown(vk_up) then dc_cam.Move( -1 * spd );
  if iskeydown(ord('S')) or iskeydown(vk_down) then dc_cam.Move( 0.85 * spd );
  if iskeydown(ord('A')) or iskeydown(vk_left) then dc_cam.Slide( 0.7 * spd );
  if iskeydown(ord('D')) or iskeydown(vk_right) then dc_cam.Slide( -0.7 * spd );

  dc_cam.Position.y := terra.InterpolatedHeight( dc_cam.AbsolutePosition );

  if iskeydown(vk_escape) then close;

end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


//
// DOGLRender
//
procedure TForm1.DOGLRender;
var
    i: integer;
    v1,v2: TVector;
begin

  for i := 0 to high(_m) do begin

    // direction
    v1 := vectorsubtract( dc_cam.AbsolutePosition, _m[i].pos );
    v1 := vectornormalize( vectormake( v1[0], 0, v1[2] ));
    // velocity
    v1 := vectorscale( v1, _m[i].vel * _dt * 10 );
    v2 := vectoradd( _m[i].pos, v1 );
    // distance
    if vectorlength( vectorsubtract( dc_cam.AbsolutePosition, v2 )) > 25 then
      setvector( _m[i].pos, v2 );

    // render
    with obj do begin
      Direction.SetVector( v1 );
      Up.SetVector( 0, 1, 0 );
      _m[i].pos[1] := terra.InterpolatedHeight( _m[i].pos );
      Position.SetPoint( _m[i].pos );
      Render( rci );
    end;

  end;

end;


procedure TForm1.FormShow;
begin

  cad.Enabled := true;

end;

end.
