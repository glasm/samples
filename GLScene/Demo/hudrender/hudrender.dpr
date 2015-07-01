program hudrender;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  GLFBO in '..\..\lib\GLFBO.pas',
  GLFBORenderer in '..\..\lib\GLFBORenderer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
