unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  GLCadencer, GLWin32Viewer, GLScene, GLObjects, AsyncTimer, GLCrossPlatform,
  GLMaterial, GLVectorFileObjects, GLTimeEventsMgr, GLFileSMD, BaseClasses,
  GLShadowPlane, GLCoordinates, GLTexture,

  uJPEGTex;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc_player: TGLDummyCube;
    dc_cam: TGLDummyCube;
    AsyncTimer1: TAsyncTimer;
    matlib: TGLMaterialLibrary;
    TEMGR: TGLTimeEventsMGR;
    actor: TGLActor;
    light: TGLLightSource;
    light2: TGLLightSource;
    floor: TGLShadowPlane;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure TEMGREvents0Event(event: TTimeEvent);
    procedure FormShow(Sender: TObject);
  end;

var
  Form1: TForm1;

  g_dt: single;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin

  vp.Buffer.RenderingContext.Activate;

  setcurrentdir('media');

  loadTex( matlib, 'buckle.jpg', 'buckle.jpg' );
  loadTex( matlib, 'glass.jpg', 'glass.jpg' );
  loadTex( matlib, 'pants.jpg', 'pants.jpg' ).TextureMode := tmModulate;
  loadTex( matlib, 'skin.jpg', 'skin.jpg' ).TextureMode := tmModulate;

  with actor do begin
    LoadFromFile( 'trinity.smd' );
    scale.Scale( 1.6 / BoundingSphereRadius );
    AddDataFromFile( 'walk.smd' );
    Animations[1].MakeSkeletalTranslationStatic;
    SwitchToAnimation( 'walk' );
    MaterialLibrary := matlib;
    end;

  loadTex( matlib, 'stones', 'stones.jpg' ).TextureMode := tmModulate;
  loadTex( matlib, 'spot', 'spot.jpg', 'stones' );

  floor.Material.LibMaterialName := 'spot';

end;


procedure TForm1.cadProgress;
begin

  g_dt := deltatime;
  with getLibMat( matlib, 'stones' ).TextureOffset do
    y := y - g_dt * ( 2 + sin( newTime * 5.236 - 0.5 )) / 12;

end;


procedure TForm1.AsyncTimer1Timer;
begin

  caption := 'TimeEvents demo: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


procedure TForm1.TEMGREvents0Event;
begin

  case event.ID of
    0: dc_cam.Position.SetPoint( 2, 5, -4 );
    1: dc_cam.Position.SetPoint( -3, 3, -2 );
    2: with actor do begin
      TagFloat := TagFloat + g_dt;
      dc_cam.Position.SetPoint( -3 + TagFloat * 0.7, TagFloat / 6, 5 );
      end;
    3: with TEMGR.Events.Items[2] do begin
      EndTime := EndTime + 20;
      StartTime := StartTime + 20;
      actor.TagFloat := 0;
      end;
    end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;

end.
