program MathTest;

uses
  Forms,
  u_MainMathTest in 'u_MainMathTest.pas' {Form1},
  uMath in 'src\uMath.pas',
  uVMath in 'src\uVMath.pas',
  uATimer in 'src\uATimer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
