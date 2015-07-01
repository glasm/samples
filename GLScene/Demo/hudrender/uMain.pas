unit uMain;

interface

uses
  Forms, Dialogs, Windows, Classes, Controls,

  GLScene, GLCadencer, GLObjects, GLGeomObjects, GLWin32Viewer, GLKeyboard,
  GLVectorFileObjects, GLFile3DS, GLHUDObjects, AsyncTimer,
  GLFBORenderer, GLMaterial, GLCoordinates, GLCrossPlatform, BaseClasses;

type
  TForm1 = class(TForm)
    scene1: TGLScene;
    vp: TGLSceneViewer;
    cam1: TGLCamera;
    cad: TGLCadencer;
    light: TGLLightSource;
    HUDSprt: TGLHUDSprite;
    at: TAsyncTimer;
    MatLib: TGLMaterialLibrary;
    scene2: TGLScene;
    ff_monster: TGLFreeForm;
    cam2: TGLCamera;
    light2: TGLLightSource;
    dc_camtarg: TGLDummyCube;
    tor: TGLTorus;
    fbo: TGLFBORenderer;
    dc_fbo: TGLDummyCube;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure atTimer(Sender: TObject);
  end;

var
  Form1: TForm1;
  m_pos: TPoint;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  with ff_monster do begin
    LoadFromFile( 'monster.3DS' );
    Scale.Scale( 1.5 / BoundingSphereRadius );
  end;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  ff_monster.Turn( -deltatime * 40);

  with mouse.CursorPos do begin
    if iskeydown(VK_LBUTTON) then
      HUDSprt.Position.SetPoint( X - left, Y - top , 0 );
    if iskeydown(VK_RBUTTON) then
      cam1.MoveAroundTarget(( m_pos.y - Y ) * 0.2, ( m_pos.X - X ) * 0.2 );
    end;
  m_pos := mouse.CursorPos;

  vp.Invalidate;

  if iskeydown(vk_escape) then
    close;

end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := 'HUD Render: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

end.
