unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,

  GLCoordinates, GLWin32Viewer, GLScene, GLCadencer, GLObjects, GLTexture,
  GLVectorFileObjects, GLGeomObjects, GLMaterial, GLCrossPlatform, BaseClasses,
  GLGraph, VectorTypes,

  jpeg, math;
  

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    ff: TGLFreeForm;
    GLFrustrum1: TGLFrustrum;
    GLLightSource1: TGLLightSource;
    GLCube1: TGLCube;
    GLCylinder1: TGLCylinder;
    GLCylinder2: TGLCylinder;
    GLXYZGrid1: TGLXYZGrid;
    procedure cadProgress(Sender:TObject; const deltaTime,newTime:Double);
  public
    procedure TurnPlane(f:TGLFreeForm);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  ff.Roll(-deltatime * 30);
  TurnPlane(ff);

end;


//
// TurnPlane
//
procedure TForm1.TurnPlane;
const
    pi2 = 1.5707963268;
    c1: array[0..3] of TVector3f = ((3,-3,0), (3,3,0), (-3,3,0), (-3,-3,0));
    c2: array[0..3] of TVector2f = ((0,0), (1,0), (1,1), (0,1));

var
    mObj: TMeshObject;
    fGroup: TFGVertexIndexList;
    i: integer;
    t: single;

begin

  f.MeshObjects.Clear;
  mObj := TMeshObject.CreateOwned(f.MeshObjects);
  mObj.Mode := momFaceGroups;

  fGroup := TFGVertexIndexList.CreateOwned(mObj.FaceGroups);
  fGroup.Mode := fgmmQuads;

  t := -cad.CurrentTime / 5;
  for i := 0 to 3 do begin
    mObj.Vertices.Add(c1[i]);
    mObj.TexCoords.Add(c2[i]);
    mObj.LightMapTexCoords.Add(
      (1 + cos(t - pi2 * i) - cos(t - pi2 * (i + 1))) / 2,
      (1 + cos(t - pi2 * i) + cos(t - pi2 * (i + 1))) / 2);
    fGroup.Add(i);
    end;

  f.StructureChanged;

end;


end.
