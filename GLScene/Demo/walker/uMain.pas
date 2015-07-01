{$APPTYPE CONSOLE} 

unit uMain;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs,

  GLScene, GLCadencer, GLWin32Viewer, GLKeyboard, VectorGeometry, GLNavigator,
  GLTexture, GLObjects, GLGeomObjects, GLFPSMovement, GLHUDObjects, AsyncTimer,
  GLVectorFileObjects, VectorTypes, GLCrossPlatform, Controls, GLParticleFX,
  GLCoordinates, BaseClasses, GLEParticleMasksManager, GLPerlinPFX,
  GLSimpleNavigation, GLMaterial,

  uLog, uDDSTex, GLFile3DS;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    dc: TGLDummyCube;
    cam_player: TGLCamera;
    dc_player: TGLDummyCube;
    ff: TGLFreeForm;
    AsyncTimer1: TAsyncTimer;
    PFXRenderer: TGLParticleFXRenderer;
    dc_emitter: TGLDummyCube;
    pfx1: TGLPerlinPFXManager;
    GLFPSMovementManager1: TGLFPSMovementManager;
    GLNavigator1: TGLNavigator;
    matlib: TGLMaterialLibrary;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public

    procedure loadData;    
    procedure handleMouse;
    procedure handleKeyboard;
    procedure updParticles;

  end;

var
  Form1: TForm1;
  player: TGLBFPSMovement;

  tt: double = 0;
  m_turn: boolean;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  log_tick;
  
  loadData;

  player := GetFPSMovement( dc_player );   

  log( 'form create:', 10 );
  log( format( '%.3f sec', [ log_delta ]));

end;


//
// loadData
//
procedure TForm1.loadData;
begin

  SetCurrentDir('data');

  log('textures:', 10);

  DDStex( matlib, 'detailmap', 'detailmap.dds' );
  DDStex( matlib, 'lightmap', 'lightmap.dds', 'detailmap' );

  log( 'models:', 10 );
  log( 'scn.3ds' );
  ff.LoadFromFile( 'scn.3ds' );
  ff.MeshObjects[0].FaceGroups[0].MaterialName := 'lightmap';
  ff.MaterialLibrary := matlib;
  ff.BuildOctree(2);

  //ff.Scale.Scale( 0.2 );

  log('uploading...', 14);
  vp.Buffer.Render;

end;


//
// handleMouse
//
procedure TForm1.handleMouse;
begin

  if m_turn then begin
    with mouse.CursorPos do begin
      dc_player.Turn(( X - screen.width div 2 ) * 0.2 );
      cam_player.PitchAngle := ClampValue(
        cam_player.PitchAngle + ( screen.height div 2 - Y ) * 0.2, -90, 90 );
      end;
    if not iskeydown(vk_rbutton) then
      m_turn := false;
    setcursorpos( screen.Width div 2, screen.Height div 2 );
  end;

end;


//
// handleKeyboard
//
procedure TForm1.handleKeyboard;
var
    spd: single;
begin

  spd := 600 * vp.LastFrameTime;
  if iskeydown( vk_lshift ) then spd := spd * 3;

  if iskeydown( ord( 'W' )) or iskeydown( vk_up ) then
    player.MoveForward( 1 * spd );
  if iskeydown( ord( 'S' )) or iskeydown( vk_down ) then
    player.MoveForward( -0.85 * spd );
  if iskeydown( ord( 'A' )) or iskeydown( vk_left ) then
    player.StrafeHorizontal( -0.7 * spd );
  if iskeydown( ord( 'D' )) or iskeydown( vk_right ) then
    player.StrafeHorizontal( 0.7 * spd );

end;


//
// updParticles
//
procedure TForm1.updParticles;
const
    d = 1 / 10;
var
    i: integer;
    v: TVector;
begin

  if tt > d then begin
    tt := tt - floor( tt / d ) * d;
    for i := 0 to pfx1.ParticleCount - 1 do
      with pfx1.Particles[i] do
        if ( Tag = 0 ) and ( PosY > 1400 ) then begin
          ff.OctreeRayCastIntersect(
            vectormake(Position), vectormake(Velocity), @v );
          Tag := round( v[1] );
        end
        else
          if abs( Tag - PosY) < 50 then begin
            Tag := 0;
            Velocity := affinevectormake( 0, random * random * 20, 0 );
          end;
  end;

  tt := tt + vp.LastFrameTime;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    v: TVector;
begin

  handleMouse;
  handleKeyboard;

  ff.OctreeRayCastIntersect( dc_player.AbsolutePosition,
    VectorMake( 0, -1, 0 ), @v );
  dc_player.Position.Y := v[1] + 35;

  updParticles;

  if iskeydown(vk_escape) then
    close;

end;


//
// timer
//
procedure TForm1.AsyncTimer1Timer;
begin

  caption := 'RainWalker: ' + vp.FramesPerSecondText(2) + ' / ' +
    inttostr( pfx1.Particles.ItemCount ) + ' particles';
  vp.ResetPerformanceMonitor;

end;


//
// activate
//
procedure TForm1.FormShow;
begin

  cad.Enabled := true;

end;


//
// rotation
//
procedure TForm1.vpMouseDown;
begin

  if button = mbRight then begin
    m_turn := true;
    setcursorpos( screen.Width div 2, screen.Height div 2 );
  end;

end;

end.




