program naviCube;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uNCube in 'uNCube.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
