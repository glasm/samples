unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  uDDStex, jpeg,

  GLScene, GLWin32Viewer, GLCadencer, GLObjects, GLTexture, GLMaterial,
  GLCoordinates, GLCrossPlatform, BaseClasses, GLVectorFileObjects, GLFile3DS;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    cad: TGLCadencer;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc_pl: TGLDummyCube;
    GLPlane1: TGLPlane;
    matlib: TGLMaterialLibrary;
    light: TGLLightSource;
    back: TGLSphere;
    GLPlane2: TGLPlane;
    GLPlane3: TGLPlane;
    GLPlane4: TGLPlane;
    GLPlane5: TGLPlane;
    GLPlane6: TGLPlane;
    GLPlane7: TGLPlane;
    GLPlane8: TGLPlane;
    GLPlane9: TGLPlane;
    GLPlane10: TGLPlane;
    dc_cam: TGLDummyCube;
    dc_ff: TGLDummyCube;
    ff: TGLFreeForm;
    GLPlane11: TGLPlane;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
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

  ff.LoadFromFile( 'grass.3ds' );
  ff.Scale.Scale( 8 / ff.BoundingSphereRadius );

  DDSTex( matlib, 'grass', 'grass.dds' );
  DDSTex( matlib, 'dirt', 'dirt.dds' );

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dc_pl.Turn( deltatime * 10 );
  dc_ff.Turn( deltatime * 10 );

end;


//
// resize
//
procedure TForm1.FormResize;
begin

  vp.FieldOfView := 145;

end;

end.
