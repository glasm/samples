unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLObjects,
  GLSkydome, GLCoordinates, GLSimpleNavigation, VectorTypes, VectorGeometry,

  u_MatUtils;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    GLSkyDome1: TGLSkyDome;
    dc_cam: TGLDummyCube;
    GLSimpleNavigation1: TGLSimpleNavigation;
    GLPlane1: TGLPlane;
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
const
    c1: TVector3b = ( 100, 100, 100 );
    c2: TVector3b = ( 255, 255, 255 );
var
    i: integer;
    v: TVector3f;
begin

  GLSkyDome1.Stars.AddRandomStars( 2500, rgb( 100, 100, 100 ), True );
  GLSkyDome1.Stars.AddRandomStars( 500, c1, c2, 2.5, 3, true );

  for i := GLSkyDome1.Stars.Count - 1 downto 0 do
    if (abs(GLSkyDome1.Stars[i].Dec - 35) < 6) and
       (abs(GLSkyDome1.Stars[i].RA - 135) < 6) then
      GLSkyDome1.Stars.Delete(i);

  DDSTex( GLPlane1.Material.Texture, 'moon_alpha_256.dds' );

end;


//
// resize
//
procedure TForm1.FormResize;
begin

  GLSceneViewer1.FieldOfView := 154;

end;

end.
