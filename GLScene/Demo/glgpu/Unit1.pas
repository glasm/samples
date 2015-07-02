unit Unit1;

interface

uses
  Windows, GLCadencer, GLVectorFileObjects, GLScene, GLObjects,
  StdCtrls, Buttons, Controls, ExtCtrls, ComCtrls, Classes, Forms,
  GLWin32Viewer, GLFileMD5, GlFileObj,GLGeomObjects, GLCrossPlatform, GLCoordinates,
  BaseClasses, GLMaterial, GLCustomShader, GLSLShader, AsyncTimer,
  GLRenderContextInfo;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    vp: TGLSceneViewer;
    Actor1: TGLActor;
    GLCadencer1: TGLCadencer;
    StatusBar1: TStatusBar;
    GLSLShader1: TGLSLShader;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLFreeForm1: TGLFreeForm;
    dogl: TGLDirectOpenGL;
    AsyncTimer1: TAsyncTimer;
    procedure vpMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	 procedure vpMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure GLSLShader1Apply(Shader: TGLCustomGLSLShader);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
  private
    mdx, mdy : Integer;
  end;

var
  Form1: TForm1;
  i: integer;

implementation

{$R *.DFM}

uses VectorGeometry, SysUtils, Jpeg, tga;

procedure TForm1.FormCreate(Sender: TObject);
const model='bobu';

begin

 vp.Buffer.RenderingContext.Activate;

 //load shader program
 GLSLShader1.LoadShaderPrograms('skin_vp.glsl','skin_fp.glsl');

 //load textures
 with GLMaterialLibrary1.AddTextureMaterial('bob','bob_body.tga') do shader:=GLSLShader1;
 with GLMaterialLibrary1.AddTextureMaterial('bob2','bob_body.tga')do begin
  material.MaterialOptions:=[moNoLighting];
  material.Texture.Disabled:=false;
 end;

 //load MD5 mesh + MD5 animation into GLActor
 PrepareMD5forHWskinning:=false;
 Actor1.LoadFromFile(model+'.md5mesh');
 Actor1.AddDataFromFile(model+'.md5anim');

 //load static MD5 mesh to GLFreeForm
 PrepareMD5forHWskinning:=true;
 GLFreeForm1.LoadFromFile(model+'.md5mesh');

 //////

 Actor1.Material.MaterialLibrary:=GLMaterialLibrary1;
 Actor1.Material.LibMaterialName:='bob2'; //only texture
 Actor1.MeshObjects.UseVBO:=false;
 Actor1.interval:=80;
 Actor1.AnimationMode:=aamLoop;

 //GLFreeForm1.MeshObjects.UseVBO:=true;
 GLFreeForm1.Material.MaterialLibrary:=GLMaterialLibrary1;
 GLFreeForm1.Material.LibMaterialName:='bob'; //with shader GPU animation

 //scene arrange
 Actor1.slide(-3);
 GLFreeForm1.slide(2);
 GLFreeForm1.move(2);
 GLCamera1.AdjustDistanceToTarget(2);
end;


procedure TForm1.vpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	// store mouse coordinates when a button went down
	mdx:=x; mdy:=y;
end;

procedure TForm1.vpMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
	// (we're moving around the parent and target dummycube)
   if Shift<>[] then
      GLCamera1.MoveAroundTarget(mdy-y, mdx-x);
	mdx:=x; mdy:=y;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
	// Note that 1 wheel-step induces a WheelDelta of 120,
	// this code adjusts the distance to target with a 10% per wheel-step ratio
	GLCamera1.AdjustDistanceToTarget(Power(1.1, WheelDelta/120));
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
 // GLSceneViewer1.vykresli;
end;

procedure TForm1.GLSLShader1Apply(Shader: TGLCustomGLSLShader);
begin
 with shader do begin           
  Param['tex0'].AsInteger := 0;

  for i:=0 to actor1.Skeleton.BoneCount-2 do
   Param['skinMatrices['+inttostr(i)+']'].AsMatrix4f:=actor1.Skeleton.BoneByID(i).GlobalMatrix;

 end;
end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  caption := vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

procedure TForm1.doglRender(Sender: TObject; var rci: TRenderContextInfo);
var
    i: integer;
begin

  randseed := 100;
  // benchmark
  {for i := 0 to 1000 do begin
    //Actor1.position.SetPoint( random*2, random*2, random*2 );
    //Actor1.Render( rci );
    GLFreeForm1.position.SetPoint( random*2, random*2, random*2 );
    GLFreeForm1.Render( rci );
  end;}

end;

end.
