unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLCadencer, GLTexture, GLWin32Viewer, GLScene, VectorGeometry,
  GLGraphics, GLKeyboard,
  GLParticleFX, GLObjects, GLHUDObjects, AsyncTimer, GLPerlinPFX,
  GLMaterial, GLCoordinates, GLCrossPlatform, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLMaterialLibrary1: TGLMaterialLibrary;
    cad: TGLCadencer;
    pfx1: TGLPointLightPFXManager;
    cam: TGLCamera;
    cur: TGLHUDSprite;
    dc_cur: TGLDummyCube;
    AsyncTimer1: TAsyncTimer;
    rend: TGLParticleFXRenderer;
    dc1: TGLDummyCube;
    dc2: TGLDummyCube;
    GLPointLightPFXManager2: TGLPointLightPFXManager;
    GLPointLightPFXManager3: TGLPointLightPFXManager;
    pfx2: TGLCustomSpritePFXManager;
    vp: TGLSceneViewer;
    dc3: TGLDummyCube;
    pfx3: TGLCustomSpritePFXManager;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure pfx2PrepareTextureImage(Sender: TObject;
      destBmp32: TGLImage; var texFormat: Integer);
    procedure pfx3PrepareTextureImage(Sender: TObject;
      destBmp32: TGLImage; var texFormat: Integer);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.cadProgress;
var
    m: TPoint;
    v: TVector;
begin

  with mouse.CursorPos do
    cur.Position.SetPoint( x - left, y - top, 0 );
  cur.Rotation := cur.Rotation - deltatime * 50;

  v := cur.AbsolutePosition;
  v[1] := vp.Height - v[1];
  vp.Buffer.ScreenVectorIntersectWithPlaneXY( v, 0, v );
  dc_cur.AbsolutePosition := v;

  dc1.Visible := iskeydown(vk_lbutton);
  dc2.Visible := iskeydown(vk_rbutton);
  dc3.Visible := iskeydown(vk_mbutton);

end;


//
// skull
//
procedure TForm1.pfx2PrepareTextureImage;
var
    bmp: TBitmap;
begin

  bmp := TBitmap.Create;
  bmp.LoadFromFile( 'skull.bmp' );
  destBmp32.Assign( bmp );
  bmp.Free;

end;


//
// rose
//
procedure TForm1.pfx3PrepareTextureImage;
var
    bmp: TBitmap;
begin

  bmp := TBitmap.Create;
  bmp.LoadFromFile( 'rose.bmp' );
  destBmp32.Assign( bmp );
  bmp.Free;

end;


//
// fps
//
procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  caption := 'PFX Cursor Demo: ' + vp.FramesPerSecondText(2) +
    ' / use the mouse';
  vp.ResetPerformanceMonitor;

end;

procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;

end.

