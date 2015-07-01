unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  GLScene, GLWin32Viewer, Menus, GLGeomObjects, GLObjects, GLCoordinates,
  GLCrossPlatform, BaseClasses, VectorGeometry,

  TGA, pngimage;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    MainMenu1: TMainMenu;
    Save1: TMenuItem;
    sBMP: TMenuItem;
    sTGA: TMenuItem;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    GLCube3: TGLCube;
    GLCube4: TGLCube;
    GLCube5: TGLCube;
    sPNG: TMenuItem;
    procedure sBMPClick(Sender: TObject);
  public

    procedure renderToBuf;

  end;

var
  Form1: TForm1;

  bufw,bufb: TBitmap;

implementation

{$R *.dfm}


//
// renderToBuf
//
procedure TForm1.renderToBuf;
begin

  vp.Buffer.BackgroundColor := $ffffff;
  vp.Buffer.Render;
  bufw := vp.Buffer.CreateSnapShotBitmap;
  //bufw.SaveToFile( 'w.bmp' );

  vp.Buffer.BackgroundColor := 0;
  vp.Buffer.Render;
  bufb := vp.Buffer.CreateSnapShotBitmap;
  //bufb.SaveToFile( 'b.bmp' );

  vp.Buffer.BackgroundColor := $00ff00;
  vp.Buffer.Render;

end;


//
// save
//
procedure TForm1.sBMPClick(Sender: TObject);
var
    i,j: integer;
    pw,pb,pr,pa: PByteArray;
    f: single;
    bmp: TBitmap;
    tga: TTGAImage;
    png: TPNGObject;
begin

  renderToBuf;

  bmp := TBitmap.Create;
  bmp.PixelFormat := pf32bit;
  bmp.Transparent := true;
  bmp.Width := vp.Width;
  bmp.Height := vp.Height;

  for j := 0 to bufw.Height - 1 do begin
    pw := bufw.ScanLine[ j ];
    pb := bufb.ScanLine[ j ];
    pr := bmp.ScanLine[ j ];
    for i := 0 to bufw.Width - 1 do begin
      // alpha
      pr[i * 4 + 3] := pb[i * 4 + 1] - pw[i * 4 + 1] + 255;
      // color
      f := 255 / pr[i * 4 + 3];
      pr[i * 4] := round( clampValue( pb[i * 4] * f, 0, 255 ));
      pr[i * 4 + 1] := round( clampValue( pb[i * 4 + 1] * f, 0, 255 ));
      pr[i * 4 + 2] := round( clampValue( pb[i * 4 + 2] * f, 0, 255 ));
    end;
  end;

  if sender = sBMP then
    bmp.SaveToFile( 'rgba.bmp' )
  else if sender = sTGA then begin
    tga := TTGAImage.Create;
    tga.Assign( bmp );
    tga.SaveToFile( 'rgba.tga' );
    tga.Free;
  end
  else if sender = sPNG then begin
    png := TPNGObject.Create;
    png.Assign( bmp );
    png.CreateAlpha;
    for j := 0 to png.Height - 1 do begin
      pr := bmp.ScanLine[ j ];
      pa := png.AlphaScanline[ j ];
      for i := 0 to png.Width - 1 do
        pa[i] := pr[i * 4 + 3];
    end;
    png.SaveToFile( 'rgba.png' );
    png.Free;
  end;

  bmp.Free;

end;

end.
