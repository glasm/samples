program gls_lab;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uAbout in 'uAbout.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
