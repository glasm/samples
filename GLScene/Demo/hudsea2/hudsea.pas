unit hudsea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLCadencer, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene,
  GLHUDObjects, GLObjects, GLCoordinates, GLTexture, AsyncTimer, jpeg;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    GLCamera1: TGLCamera;
    at: TAsyncTimer;
    bot: TGLHUDSprite;
    wave: TGLHUDSprite;
    up: TGLHUDSprite;
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure atTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  clientWidth := 1024;
  clientHeight := 700;

end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := 'HUD Sea: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  bot.Material.TextureEx[0].TextureOffset.X := -newtime / 10;
  wave.Material.TextureEx[0].TextureOffset.X := -newtime / 10;

end;


//
// show
//
procedure TForm1.FormShow;
begin

  cad.Enabled := true;

end;

end.
