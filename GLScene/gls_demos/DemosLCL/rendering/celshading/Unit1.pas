unit Unit1;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLCadencer, GLLCLViewer, GLVectorFileObjects,
  AsyncTimer, GLCelShader, GLGeomObjects, GLTexture, GLObjects,
  GLCrossPlatform, GLMaterial, GLCoordinates, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLActor1: TGLActor;
    AsyncTimer1: TAsyncTimer;
    GLTexturedCelShader: TGLCelShader;
    GLColoredCelShader: TGLCelShader;
    GLTorus1: TGLTorus;
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure FormCreate(Sender: TObject);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: double);
  private
    { Private declarations }
  public
    { Public declarations }
    mx, my, lx, ly: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  GLFileMD2, GLKeyboard, FileUtil, LCLType;

procedure TForm1.FormCreate(Sender: TObject);
var
  r: single;
  path: UTF8String;
  p: integer;
begin
  path := ExtractFilePath(ParamStrUTF8(0));
  p := Pos('DemosLCL', path);
  Delete(path, p + 5, Length(path));
  path := IncludeTrailingPathDelimiter(path) + 'media';
  SetCurrentDirUTF8(path);

  GLActor1.LoadFromFile('waste.md2');
  r := GLActor1.BoundingSphereRadius;
  GLActor1.Scale.SetVector(2.5 / r, 2.5 / r, 2.5 / r);
  GLActor1.AnimationMode := aamLoop;
  GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile('wastecell.jpg');
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  mx := x;
  my := y;
  lx := x;
  ly := y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  mx := x;
  my := y;
end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  Form1.Caption := Format('Cel Shading Demo - %.2f FPS', [GLSceneViewer1.FramesPerSecond]);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime, newTime: double);
begin
  if IsKeyDown(VK_LBUTTON) then
  begin
    GLCamera1.MoveAroundTarget(ly - my, lx - mx);
    lx := mx;
    ly := my;
  end;

  GLTorus1.TurnAngle := 15 * Sin(newTime * 5);
  GLTorus1.PitchAngle := 15 * Cos(newTime * 5);
end;

end.

