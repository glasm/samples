program scenenav;

uses
  Forms,
  u_Main in 'u_Main.pas' {Form1},
  u_Frame in 'u_Frame.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
