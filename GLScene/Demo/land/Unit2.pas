unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  Jpeg,

  GLScene, GLCadencer, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLKeyboard,
  GLTerrainRenderer, GLCoordinates, GLHeightData, GLObjects, AsyncTimer,
  VectorGeometry, GLMaterial, GLContext, GLTexture, GLSkydome, ExtCtrls;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    hds: TGLBitmapHDS;
    cam: TGLCamera;
    light: TGLLightSource;
    dc_cam: TGLDummyCube;
    at: TAsyncTimer;
    terra: TGLTerrainRenderer;
    GLDummyCube1: TGLDummyCube;
    GLEarthSkyDome1: TGLEarthSkyDome;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public

    procedure handleMouse(dt:single);
    procedure handleKeyboard(dt:single);    

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

  hds.Picture.LoadFromFile('hmap.bmp');

  // diffuse
  with terra.Material.TextureEx.Add do begin
    TextureScale.SetPoint( 8, 8, 1 );
    Texture.Image.LoadFromFile( 'grass.jpg' );
    Texture.Disabled := false;
    end;
  // + lightmap
  with terra.Material.TextureEx.Add do begin
    Texture.Image.LoadFromFile( 'lmap.jpg' );
    Texture.TextureMode := tmModulate;
    Texture.Disabled := false;
    end;

  showcursor(false);

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  if not Active then exit;

  handleMouse(deltatime);
  handleKeyboard(deltatime);

  vp.Invalidate;

end;


//
// handleMouse
//
procedure TForm1.handleMouse;
begin

  with mouse.CursorPos do begin
    dc_cam.TurnAngle := dc_cam.TurnAngle - (x - screen.Width div 2) * 0.2;
    cam.PitchAngle := cam.PitchAngle - (y - screen.Height div 2) * 0.2;
    end;

  mouse.CursorPos := point(screen.Width div 2, screen.Height div 2);

end;


//
// handleKeyboard
//
procedure TForm1.handleKeyboard;
var
    spd,f: single;
begin

  spd := 30 * dt;
  if iskeydown(VK_SHIFT) then spd := spd * 5;

  f := 0;
  if IsKeyDown(VK_UP) or iskeydown(ord('W')) then f := f + spd;
  if IsKeyDown(VK_DOWN) or iskeydown(ord('S')) then f := f - spd;
  dc_cam.Position.Translate(
    vectorScale(cam.AbsoluteVectorToTarget, f));

  f := 0;
  if IsKeyDown(VK_LEFT) or iskeydown(ord('A')) then f := f + spd;
  if IsKeyDown(VK_RIGHT) or iskeydown(ord('D')) then f := f - spd;
  dc_cam.Position.Translate(
    vectorScale(cam.AbsoluteRight, f));

  if IsKeyDown(VK_ESCAPE) then Close;

end;


//
// show
//
procedure TForm1.FormShow;
begin

  mouse.CursorPos := point(screen.Width div 2, screen.Height div 2);
  cad.Enabled := true;

end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := 'Land: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


end.
