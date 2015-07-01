program tonnel;

uses
  Forms,
  u_Main in 'u_Main.pas' {mform},
  u_Levels in 'u_Levels.pas',
  u_Game in 'u_Game.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmform, mform);
  Application.Run;
end.
