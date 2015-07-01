program Project1;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uFerma in 'uFerma.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
