program Utapan;

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  Unit1 in 'Unit1.pas' {Form1},
  DataModule in 'DataModule.pas' {DM: TDataModule},
  Utillities in 'Utillities.pas',
  NebulaPath in 'NebulaPath.pas',
  NebulaPathEA in 'NebulaPathEA.pas',
  MainMenu in 'MainMenu.pas' {fMainMenu},
  AudioUtils in 'AudioUtils.pas';

{$R *.RES}

  var
  hMutex: THandle;
  FoundWnd: THandle;
  ModuleName: string;

function EnumWndProc (hwnd: THandle;Param: Cardinal): Bool; stdcall;
var
  ClassName, WinModuleName: string;
  WinInstance: THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (ClassName);
  if ClassName = TForm1.ClassName then
  begin
    // get the module name of the target window
    SetLength (WinModuleName, 200);
    WinInstance := GetWindowLong (hwnd, GWL_HINSTANCE);
    GetModuleFileName (WinInstance,
      PChar (WinModuleName), Length (WinModuleName));
    WinModuleName := PChar(WinModuleName); // adjust length

    // compare module names
    if WinModuleName = ModuleName then
    begin
      FoundWnd := Hwnd;
      Result := False; // stop enumeration
    end;
  end;
end;

begin
  // check if mutex already exists
  HMutex := CreateMutex (nil, False, 'Utapan_pig_v1');
  if WaitForSingleObject (hMutex, 0) <> wait_TimeOut then
  begin
  //----------------------

  Application.Initialize;
  DecimalSeparator:=',';
  Application.Title := 'Utapan';
  Application.CreateForm(TfMainMenu, fMainMenu);
  Application.CreateForm(TDM, DM);
  Application.Run;

  //----------------------
  end
    else
  begin
    Application.MessageBox('There is a running instance of Utapan','Utapan');

  end;

end.
