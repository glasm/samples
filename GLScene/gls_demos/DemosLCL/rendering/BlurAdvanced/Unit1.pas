// This demo is part of the GLSCene project
// Advanced GLBlur demo
// by Marcus Oblak
unit Unit1;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLLCLViewer, GLScene, GLObjects, GLHUDObjects,
  GLGeomObjects, GLCadencer, ExtCtrls, GLBlur, GLTexture, ComCtrls,
  StdCtrls, GLCrossPlatform, GLMaterial, GLCoordinates, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLCube1: TGLCube;
    GLLightSource1: TGLLightSource;
    GLDummyCube1: TGLDummyCube;
    GLAnnulus1: TGLAnnulus;
    GLBlur1: TGLBlur;
    Timer1: TTimer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    Panel1: TPanel;
    edtAdvancedBlurAmp: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtAdvancedBlurPasses: TEdit;
    trkAdvancedBlurHiClamp: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    trkAdvancedBlurLoClamp: TTrackBar;
    Label5: TLabel;
    Bevel1: TBevel;
    GLSphere1: TGLSphere;
    TorusImpostor: TGLTorus;
    Memo1: TMemo;
    GLTorus2: TGLTorus;
    procedure Timer1Timer(Sender: TObject);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: double);
    procedure edtAdvancedBlurAmpChange(Sender: TObject);
    procedure trkAdvancedBlurHiClampChange(Sender: TObject);
    procedure trkAdvancedBlurLoClampChange(Sender: TObject);
    procedure edtAdvancedBlurPassesChange(Sender: TObject);
    procedure GLBlur1BeforeTargetRender(Sender: TObject);
    procedure GLBlur1AfterTargetRender(Sender: TObject);
  private
    { Private declarations }
    mx, my: integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  FileUtil;

procedure TForm1.FormCreate(Sender: TObject);
var
  path: UTF8String;
  p: integer;
begin
  path := ExtractFilePath(ParamStrUTF8(0));
  p := Pos('DemosLCL', path);
  Delete(path, p + 5, Length(path));
  path := IncludeTrailingPathDelimiter(path) + 'media';
  SetCurrentDirUTF8(path);
  // Blur GLDummyCube1and it's children
  GLBlur1.TargetObject := GLDummyCube1;
  // point to GLDummyCube1
  GLCamera1.TargetObject := GLDummyCube1;
  // load materials
  with GLMaterialLibrary1 do
  begin
    Materials[0].Material.Texture.Image.LoadFromFile('beigemarble.jpg');
    Materials[1].Material.Texture.Image.LoadFromFile('moon.bmp');
  end;
end;


procedure TForm1.GLBlur1BeforeTargetRender(Sender: TObject);
begin
  TorusImpostor.Visible := True; // GLBlur1 must render the Torusimpostor
end;

procedure TForm1.GLBlur1AfterTargetRender(Sender: TObject);
begin
  TorusImpostor.Visible := False; // GLSCeneViewer1 must NOT render the Torusimpostor
end;


procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime, newTime: double);
begin
  GLSceneViewer1.Invalidate;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if (ssRight in Shift) and (y > 10) then
    GLCamera1.AdjustDistanceToTarget(my / y);
  if ssLeft in Shift then
    GLCamera1.MoveAroundTarget(my - y, mx - x);
  mx := x;
  my := y;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Caption := GLSceneViewer1.FramesPerSecondText(0);
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.trkAdvancedBlurHiClampChange(Sender: TObject);
begin
  GLBlur1.AdvancedBlurHiClamp := trkAdvancedBlurHiClamp.Position;
end;

procedure TForm1.trkAdvancedBlurLoClampChange(Sender: TObject);
begin
  GLBlur1.AdvancedBlurLowClamp := trkAdvancedBlurLoClamp.Position;
end;


procedure TForm1.edtAdvancedBlurAmpChange(Sender: TObject);
begin
  GLBlur1.AdvancedBlurAmp := StrToFloat(edtAdvancedBlurAmp.Text);
end;



procedure TForm1.edtAdvancedBlurPassesChange(Sender: TObject);
begin
  GLBlur1.AdvancedBlurPasses := StrToInt(edtAdvancedBlurPasses.Text);
end;


end.
