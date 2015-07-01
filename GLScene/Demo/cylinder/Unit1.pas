unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,

  GLWin32Viewer, GLScene, AsyncTimer, GLCadencer, GLObjects, GLGeomObjects,
  GLTexture, GLMaterial, GLCoordinates, GLCrossPlatform, BaseClasses,
  GLRenderContextInfo, GLCompositeImage, GLFileDDS, VectorGeometry;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    Panel1: TPanel;
    stop1: TButton;
    go: TButton;
    cad: TGLCadencer;
    GLCamera1: TGLCamera;
    cyl1: TGLCylinder;
    GLLightSource1: TGLLightSource;
    GLPlane1: TGLPlane;
    dogl: TGLDirectOpenGL;
    cyl2: TGLCylinder;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure stop1Click(Sender: TObject);
    procedure goClick(Sender: TObject);
  private
  public
  end;

  TCyl = record
    angle: single;
    fix: boolean;
  end;

var
  Form1: TForm1;

  dt: single;
  cyl: array[0..2] of TCyl;
  cyl_rottime: single = 10;

  cyl1_mat,cyl2_mat: TMatrix;


implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  setCurrentDir( 'data' );
  cyl1.Material.Texture.Image.LoadFromFile( 't1.dds' );
  cyl2.Material.Texture.Image.LoadFromFile( 't2.dds' );  

  randomize;
  goClick( nil );

  // VSync
  cad.FixedDeltaTime := 1 / GetDeviceCaps(getDC(Handle), 116);

  // save matrix
  cyl1_mat := cyl1.Matrix;
  cyl2_mat := cyl2.Matrix;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dt := deltatime;
  vp.Invalidate;

end;


//
// doglRender
//
procedure TForm1.doglRender;
var
    i: integer;
begin

  for i := 0 to high(cyl) do begin

    if cyl_rottime < i + 1 then begin

      cyl[i].angle := cyl[i].angle + dt * 700;

      cyl2.Matrix := cyl2_mat; // restore matrix
      cyl2.RotateAbsolute( cyl[i].angle, 0, 0 );
      cyl2.Position.X := -4 + i * 4;
      cyl2.Render(rci);

    end else begin

      if not cyl[i].fix then begin
        cyl[i].angle := round( cyl[i].angle / 45 ) * 45 + 22.5;
        cyl[i].fix := true;
      end;

      cyl1.Matrix := cyl1_mat; // restore matrix
      cyl1.RotateAbsolute( cyl[i].angle, 0, 0 );
      cyl1.Position.X := -4 + i * 4;
      cyl1.Render(rci);

    end;

  end;

  cyl_rottime := cyl_rottime + dt;

  if cyl_rottime > 5 then
    cad.Enabled := false;

end;


//
// stop
//
procedure TForm1.stop1Click;
begin

  cyl_rottime := 1;

end;


//
// go
//
procedure TForm1.goClick(Sender: TObject);
var
    i: integer;
begin

  for i := 0 to high(cyl) do begin
    cyl[i].angle := random * 360;
    cyl[i].fix := false;
  end;
  cyl_rottime := -1;

  cad.Enabled := true;

end;


end.
