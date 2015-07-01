{:
  GLSL Shader Component Demo<p>

  A demo that shows how to use the TGLSLShader component.

  Version history:
    30/03/07 - DaStr - Cleaned up "uses" section
    20/03/07 - DaStr - Initial version


}
unit uMainForm;

interface

{$I GLScene.inc}

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Controls, Forms, ExtCtrls, StdCtrls,

  // GLScene
  GLTexture, GLCadencer, GLWin32Viewer, GLScene, GLObjects,
  GLGraph, VectorLists, VectorTypes, VectorGeometry, GLSLShader,
  GLGeomObjects, GLVectorFileObjects, GLSimpleNavigation, GLCustomShader,
  GLCrossPlatform, GLMaterial, GLCoordinates, BaseClasses,

  // FileFormats
  TGA, GLFileMD2, GLFileMS3D, GLFile3DS, JPEG, DDSImage;

type
  TGLSLTestForm = class(TForm)
    Scene: TGLScene;
    Viewer: TGLSceneViewer;
    Cadencer: TGLCadencer;
    Camera: TGLCamera;
    Light:  TGLLightSource;
    LightCube: TGLDummyCube;
    GLSphere1: TGLSphere;
    GLXYZGrid1: TGLXYZGrid;
    GLArrowLine1: TGLArrowLine;
    Panel1: TPanel;
    LightMovingCheckBox: TCheckBox;
    GUICube: TGLDummyCube;
    WorldCube: TGLDummyCube;
    Fighter: TGLActor;
    Teapot: TGLActor;
    Sphere_big: TGLActor;
    Sphere_little: TGLActor;
    MaterialLibrary: TGLMaterialLibrary;
    ShadeEnabledCheckBox: TCheckBox;
    TurnPitchrollCheckBox: TCheckBox;
    GLSLShader: TGLSLShader;
    GLSimpleNavigation1: TGLSimpleNavigation;
    procedure FormCreate(Sender: TObject);
    procedure CadencerProgress(Sender: TObject; const deltaTime, newTime: double);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LightCubeProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure ShadeEnabledCheckBoxClick(Sender: TObject);
    procedure GLSLShaderApply(Shader: TGLCustomGLSLShader);
    procedure GLSLShaderInitialize(Shader: TGLCustomGLSLShader);
    procedure GLSLShaderUnApply(Shader: TGLCustomGLSLShader;
      var ThereAreMorePasses: Boolean);
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  GLSLTestForm:  TGLSLTestForm;

implementation

{$R *.dfm}

procedure TGLSLTestForm.FormCreate(Sender: TObject);
const
  FILE_PATH = '..\..\media\';
begin
  // First load models.
  Fighter.LoadFromFile(FILE_PATH + 'waste.md2'); //Fighter
  Fighter.SwitchToAnimation(0, True);
  Fighter.AnimationMode := aamLoop;
  Fighter.Scale.Scale(3);

  Teapot.LoadFromFile(FILE_PATH + 'Teapot.3ds'); //Teapot (no texture coordinates)
  Teapot.Scale.Scale(0.8);

  Sphere_big.LoadFromFile(FILE_PATH + 'Sphere_big.3DS'); //Sphere_big
  Sphere_big.Scale.Scale(70);

  Sphere_little.LoadFromFile(FILE_PATH + 'Sphere_little.3ds'); //Sphere_little
  Sphere_little.Scale.Scale(4);

  // Then load textures.
  MaterialLibrary.LibMaterialByName('Earth').Material.Texture.Image.LoadFromFile(FILE_PATH + 'Earth.jpg');

  // Shader.
  GLSLShader.LoadShaderPrograms('Shaders/Shader.Vert', 'Shaders/Shader.Frag');
  GLSLShader.Enabled := True;
end;

procedure TGLSLTestForm.ShadeEnabledCheckBoxClick(Sender: TObject);
begin
  GLSLShader.Enabled := ShadeEnabledCheckBox.Checked;
end;

procedure TGLSLTestForm.GLSLShaderApply(Shader: TGLCustomGLSLShader);
begin
  with Shader do
  begin
    Param['DiffuseColor'].AsVector4f := VectorMake(1, 1, 1, 1);
    Param['AmbientColor'].AsVector4f := VectorMake(0.2, 0.2, 0.2, 1);
    Param['LightIntensity'].AsVector1f := 1;
    Param['MainTexture'].AsTexture2D[0] := MaterialLibrary.LibMaterialByName('Earth').Material.Texture;
  end;
end;

procedure TGLSLTestForm.GLSLShaderInitialize(Shader: TGLCustomGLSLShader);
begin
  with Shader do
  begin
    // Nothing.
  end;
end;

procedure TGLSLTestForm.GLSLShaderUnApply(Shader: TGLCustomGLSLShader;
  var ThereAreMorePasses: Boolean);
begin
  with Shader do
  begin
    // Nothing.
  end;
end;

procedure TGLSLTestForm.CadencerProgress(Sender: TObject; const deltaTime, newTime: double);
begin
  Viewer.Invalidate;

  if TurnPitchrollCheckBox.Checked then
  begin
    Sphere_big.Pitch(40 * deltaTime);
    Sphere_big.Turn(40 * deltaTime);
    Sphere_little.Roll(40 * deltaTime);
  end;
end;


procedure TGLSLTestForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Cadencer.Enabled := False;
end;


procedure TGLSLTestForm.LightCubeProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  if LightMovingCheckBox.Checked then
    LightCube.MoveObjectAround(Camera.TargetObject, sin(NewTime) * deltaTime * 10, deltaTime * 20);
end;

end.


