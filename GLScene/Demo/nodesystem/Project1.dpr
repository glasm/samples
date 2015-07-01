program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {main_form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmain_form, main_form);
  Application.Run;
end.
