unit umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,

  Dialogs, GLCadencer, GLMaterial, GLWin32Viewer, GLCrossPlatform, Controls,
  BaseClasses, GLScene, AsyncTimer, GLCoordinates, GLObjects, GLKeyboard,
  GLVectorFileObjects, GLHUDObjects, GLFPSMovement, GLNavigator,

  GLFile3DS, jpeg, VectorGeometry, GLShadowPlane;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    matlib: TGLMaterialLibrary;
    cad: TGLCadencer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    AsyncTimer1: TAsyncTimer;
    ff_scn: TGLFreeForm;
    dc_world: TGLDummyCube;
    back: TGLHUDSprite;
    GLFPSMovementManager1: TGLFPSMovementManager;
    GLNavigator1: TGLNavigator;
    ff_mask: TGLFreeForm;
    ff_ani: TGLActor;
    light: TGLLightSource;
    GLShadowPlane1: TGLShadowPlane;
    dc_light: TGLDummyCube;
    light01: TGLLightSource;
    light02: TGLLightSource;
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  Form1: TForm1;

  m_pos: TPoint;
  m_turn: boolean;
  pl: TGLBFPSMovement;
  pl_dy: single;

implementation

{$R *.dfm}


// setup
//
procedure TForm1.FormCreate(Sender: TObject);
var
    m: TGLLibMaterial;
begin

  ff_scn.LoadFromFile( 'scn.3ds' );
  ff_mask.LoadFromFile( 'mask.3ds' );
  ff_mask.BuildOctree;

  vGLFile3DS_EnableAnimation := true;

  ff_ani.LoadFromFile( 'ani.3ds' );
  with ff_ani.Animations.Add do begin
    EndFrame := 99;
    name := 'ani';
  end;
  ff_ani.SwitchToAnimation( 'ani' );

  pl := GetFPSMovement( dc_cam );

  m := matlib.LibMaterialByName( 'fire' );
  if m <> nil then begin
    m.Material.FrontProperties.Emission.SetColor(1,1,1,1);
    m.Material.FrontProperties.Diffuse.SetColor(1,1,1,1);
  end;

end;


// cadProgress
//
procedure TForm1.cadProgress(Sender: TObject; const deltaTime,
  newTime: Double);
var
    spd: single;
    v: TVector;
begin

  back.Width := vp.Width + 2;
  back.Height := vp.Height + 2;
  back.Position.SetPoint( vp.Width div 2, vp.Height div 2, 0 );

  if m_turn then begin
    with mouse.CursorPos do begin
      dc_cam.Turn(( X - screen.width div 2 ) * 0.2 );
      cam.PitchAngle := ClampValue(
        cam.PitchAngle + ( screen.height div 2 - Y ) * 0.2, -90, 90 );
      end;
    if not iskeydown(vk_lbutton) then begin
      m_turn := false;
      showCursor( true );
    end;
    setcursorpos( screen.Width div 2, screen.Height div 2 );
  end;

  spd := 100 * deltaTime;
  if iskeydown( vk_lshift ) then spd := spd * 3;

  if iskeydown( ord( 'W' )) or iskeydown( vk_up ) then
    pl.MoveForward( -1 * spd );
  if iskeydown( ord( 'S' )) or iskeydown( vk_down ) then
    pl.MoveForward( 0.85 * spd );
  if iskeydown( ord( 'A' )) or iskeydown( vk_left ) then
    pl.StrafeHorizontal( 0.7 * spd );
  if iskeydown( ord( 'D' )) or iskeydown( vk_right ) then
    pl.StrafeHorizontal( -0.7 * spd );

  ff_mask.OctreeRayCastIntersect( dc_cam.AbsolutePosition,
    VectorMake( 0, -1, 0 ), @v );

  pl_dy := pl_dy + deltatime;
  if dc_cam.Position.Y - 25 - pl_dy < v[1] then begin
    dc_cam.Position.Y := v[1] + 25;
    pl_dy := 0;
    if iskeydown( vk_space ) then
      pl_dy := -0.65;
  end else
    dc_cam.Position.Y := dc_cam.Position.Y - pl_dy*deltatime * 250;

  light01.Shining := ff_ani.CurrentFrame > 10;
  light01.Position.SetPoint( random * 500 - 1000, 50+random*200, random * 500 );
  light02.Shining := ff_ani.CurrentFrame > 14;
  light02.Position.SetPoint( random * 500 - 1000, 50+random*200, random * 500 );

  vp.Refresh;

  if iskeydown(vk_escape) then
    close;
    //ff_ani.
end;


procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;


procedure TForm1.vpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if button = mbLeft then begin
    m_turn := true;
    setcursorpos( screen.Width div 2, screen.Height div 2 );
    showCursor( false );
  end;

end;


procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  caption := 'RayFire Demo: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

end.
