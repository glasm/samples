unit Main;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, GLScene,
  GLObjects, GLVectorFileObjects, GLMaterial, GLCadencer, GLSArchiveManager,
  BaseClasses, VectorGeometry,
  GLFileMS3D, TGA, GLFileZLIB, GLCoordinates, GLCrossPlatform,
  GLWin32Viewer;

type

  { TForm1 }

  TForm1 = class(TForm)
    GLCadencer1: TGLCadencer;
    GLCamera: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLFreeForm: TGLFreeForm;
    GLFreeForm1: TGLFreeForm;
    GLLightSource1: TGLLightSource;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLPlane1: TGLPlane;
    GLSArchiveManager1: TGLSArchiveManager;
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

uses
  VectorTypes;

{$R *.dfm}

{ TForm1 }

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
   GLCamera.Position.Rotate(VectorMake(0, 1, 0), deltaTime * 0.1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with GLSArchiveManager1.Archives[0] do
  begin
    LoadFromFile('..\..\Media\Chair.zlib');
    if FileName='' then ShowMessage('Archive Can not be Loaded');
    {: Automatic loading from archive.
       If file is not in archive, then it's loaded from harddrive. }
    GLFreeForm.LoadFromFile('Chair.ms3d');
    {: Direct loading from archive }
    GLFreeForm1.LoadFromStream('Chair.ms3d',GetContent('Chair.ms3d'));
  end;
end;

end.

