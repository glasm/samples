{: Scripting a Shader with DelphiWebScriptII<p>

   A very simple example of how the GLUserShader and scripting
   components can be used to build a scripted material shader.<p>

   The Tdws2OpenGL1xUnit requires the Tdws2VectorGeometryUnit to be
   associated with the script.
}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, GLCadencer, StdCtrls, GLTexture, GLUserShader, GLWin32Viewer,
  GLScene, GLObjects, AsyncTimer, GLScriptBase, GLScriptDWS2,
  dws2OpenGL1x, dws2VectorGeometry, dws2Comp, GLMaterial, GLCoordinates,
  GLCrossPlatform, BaseClasses, GLRenderContextInfo;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    Panel1: TPanel;
    dws2OpenGL1xUnit1: Tdws2OpenGL1xUnit;
    GLUserShader1: TGLUserShader;
    ShaderScript: TMemo;
    Recompile: TButton;
    Enabled: TCheckBox;
    Label1: TLabel;
    GLCadencer1: TGLCadencer;
    GLCamera1: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLLightSource1: TGLLightSource;
    GLCube1: TGLCube;
    GLMaterialLibrary1: TGLMaterialLibrary;
    dws2VectorGeometryUnit1: Tdws2VectorGeometryUnit;
    AsyncTimer1: TAsyncTimer;
    GLDelphiWebScriptII1: TGLDelphiWebScriptII;
    GLScriptLibrary1: TGLScriptLibrary;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure RecompileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GLUserShader1DoApply(Sender: TObject;
      var rci: TRenderContextInfo);
    procedure GLUserShader1DoUnApply(Sender: TObject; Pass: Integer;
      var rci: TRenderContextInfo; var Continue: Boolean);
    procedure EnabledClick(Sender: TObject);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    mx, my : Integer;
    Compiled : Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShaderScript.Lines.AddStrings(GLScriptLibrary1.Scripts[0].Text);

  // Compile the program when the form is created
  RecompileClick(nil);
end;

procedure TForm1.RecompileClick(Sender: TObject);
begin
  with GLScriptLibrary1.Scripts[0] do begin;
    // Assign the script text from the memo
    Text.Clear;
    Text.AddStrings(ShaderScript.Lines);

    // Compile/Recompiler and then start the script
    Compile;
    Start;
  end;
end;

procedure TForm1.GLUserShader1DoApply(Sender: TObject;
  var rci: TRenderContextInfo);
begin
  // Call the scripted DoApply procedure to handle the shader application
  GLScriptLibrary1.Scripts[0].Call('DoApply',[]);
end;

procedure TForm1.GLUserShader1DoUnApply(Sender: TObject; Pass: Integer;
  var rci: TRenderContextInfo; var Continue: Boolean);
begin
  // Call the scripted DoUnApply function to handle the shader unapplication
  // pass the result of the scripted function to the Continue variable
  Continue:=GLScriptLibrary1.Scripts[0].Call('DoUnApply',[Pass]);
end;

procedure TForm1.EnabledClick(Sender: TObject);
begin
  GLUserShader1.Enabled:=Enabled.Checked;
end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  Form1.Caption:=GLSceneViewer1.FramesPerSecondText;
  GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx:=x;
  my:=y;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    GLCamera1.MoveAroundTarget(my-y, mx-x);
  mx:=x;
  my:=y;
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  GLSceneViewer1.Invalidate;
end;

end.
