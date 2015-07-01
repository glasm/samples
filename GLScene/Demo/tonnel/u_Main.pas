unit u_Main;


interface


uses

  Windows, Messages, Classes, Controls, Forms, ExtCtrls,

  GLCoordinates, GLScene, GLObjects, GLGraph, GLCrossPlatform,
  BaseClasses, GLWin32Viewer, GLVectorFileObjects, GLCadencer, GLMesh,

  u_Game;


type

  Tmform = class(TForm)
    pnl_Pause: TPanel;
    pnl_Start: TPanel;
    pnl_Exit: TPanel;
    wl: TGLXYZGrid;
    scn: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc_wall: TGLDummyCube;
    lines: TGLLines;
    wr: TGLXYZGrid;
    wt: TGLXYZGrid;
    wb: TGLXYZGrid;
    mesh: TGLMesh;
    img_left: TImage;
    img_right: TImage;
    procedure FormCreate(Sender: TObject);
    procedure OnRestart(Sender: TObject);
    procedure OnPause(Sender: TObject);
    procedure OnResume(Sender: TObject);
    procedure WMEnterSizeMove(var M: TMessage); message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var M: TMessage); message WM_EXITSIZEMOVE;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnl_StartClick(Sender: TObject);
    procedure pnl_ExitClick(Sender: TObject);
  end;

  t_ProgState = (ps_Start, ps_Play, ps_Pause);


var
  mform: Tmform;

  g_state: t_ProgState = ps_Start;
  g_game: c_Game;
  g_lives: array[0..3] of TPanel;


implementation

{$R *.dfm}


//
// FormCreate
//
procedure Tmform.FormCreate;
begin

  ClientWidth := 800;
  ClientHeight := 600;

  pnl_pause.BoundsRect := rect(300, 10, 500, 50);
  pnl_start.BoundsRect := rect(300, 260, 500, 300);
  pnl_exit.BoundsRect := rect(300, 310, 500, 350);
  img_left.BoundsRect := rect(35, 465, 120, 551);
  img_right.BoundsRect := rect(680, 465, 765, 551);
  vp.BoundsRect := rect(150, 50, 650, 550);

  Application.OnMinimize := OnPause;
  Application.OnRestore := OnResume;
  Application.OnActivate := OnResume;
  Application.OnDeactivate := OnPause;

  g_game := c_Game.Create(self);

end;


//
// exit
//
procedure Tmform.pnl_ExitClick;
begin

  close;

end;


//
// start
//
procedure Tmform.pnl_StartClick;
begin

  g_game.Run;

end;


//
//  OnRestart
//
procedure Tmform.OnRestart;
begin

  g_state := ps_Start;
  pnl_Start.Visible := true;

end;


//
// OnPause
//
procedure Tmform.OnPause;
begin

  if g_state = ps_Play then begin
    g_state := ps_Pause;
    pnl_Pause.Visible := true;
    cad.Enabled := false;
    end;

end;


//
// OnResume
//
procedure Tmform.OnResume;
begin

  if g_state = ps_Pause then begin
    g_state := ps_Play;
    pnl_Pause.Visible := false;
    cad.Enabled := true;
    end;

end;


//
// WMEnterSizeMove
//
procedure Tmform.WMEnterSizeMove;
begin

  OnPause(nil);

  inherited;

end;


//
// WMExitSizeMove
//
procedure Tmform.WMExitSizeMove;
begin

  OnResume(nil);

  inherited;

end;


//
// FormKeyDown
//
procedure Tmform.FormKeyDown;
begin

  if key = vk_pause then
    if g_state = ps_Pause then onResume(nil)
      else onPause(nil);

  if key = vk_escape then
    if g_state = ps_Start then close
    else begin
      onResume(nil);
      g_game.Over;
      end;

  if (key = vk_return) or (key = vk_space) then
    if g_state = ps_Start then
      g_game.Run
    else if g_state = ps_Pause then
      onResume(nil);


  if (key = vk_left) or (key = ord('A')) then
    g_game.stepLeft;

  if (key = vk_right) or (key = ord('D')) then
    g_game.stepRight;

  if (key = vk_Up) or (key = ord('W')) then
    g_game.stepUp;

  if (key = vk_Down) or (key = ord('S')) then
    g_game.stepDown;


end;

end.
