program obj_GLSkyDome;

uses
  Forms,
  u_MatUtils in 'u_MatUtils.pas',
  u_Main in 'u_Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
