unit MainMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  GLScreen, jpeg, ExtCtrls, AppEvnts,
  Utillities , GLHUDObjects, GLTexture, GLMisc, GLScene, GLWin32Viewer,
  GLObjects, AudioUtils, DXSounds,GLContext, GLCadencer, AsyncTimer;

const global_sound_step=200;

type
    main_menu_actions=record
    posX,posY:Integer;
    action_name:String;
    hud_action_pic_up,
    hud_action_pic_down:THUDSprite;
end;

type
    MH_opt_cell=record
    posX,posY:Integer;
    opt_level:Integer;
    hud_pic,
    hud_item_pic:THUDSprite;
end;

type
  item_cell=packed record
    posX,posY:Integer;
    itemId:byte;
    itemRotation:byte;
end; // terrCell

type
  MH_web=packed record
    posX,posZ,posY:Integer;
    isFree:boolean;
end; // terrCell

type
  TfMainMenu = class(TForm)
    Image1: TImage;
    ErrorLog: TMemo;
    GLSceneViewerMainMenu: TGLSceneViewer;
    GLSceneMainMenu: TGLScene;
    DCMainMenu: TDummyCube;
    GLCameraMainMenu: TGLCamera;
    ApplicationEvents1: TApplicationEvents;
    DXSound1: TDXSound;
    DXWaveListMainMenu: TDXWaveList;
    GLMLMainMenu: TGLMaterialLibrary;
    AsyncTimer1: TAsyncTimer;
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewerMainMenuMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMainMenuMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AsyncTimer1Timer(Sender: TObject);
  private
    { Private declarations }
    app_error_count:Integer;
    focused_action:byte;
  public
    { Public declarations }
    // current level
    current_level:byte;

    go_next_level:boolean;

    progress_counter:Integer;

    auto_level_generation:boolean;

    MH_base_exp_step:Integer;

    // main menu
    main_menu_current_state:String;
    // some audio
    allow_global_audio:boolean;
    global_controls_volume_level:Smallint;
    global_maintheme_volume_level:Smallint;
    global_game_volume_level:Smallint;

    allow_game_vsync:boolean;
    allow_game_antialiasing:boolean;

    // enemies props
    EABaseLife, EABaseAttack,
    EBBaseLife, EBBaseAttack,
    ECBaseLife, ECBaseAttack,
    EDBaseLife, EDBaseAttack,
    EEBaseLife, EEBaseAttack,
    EFBaseLife, EFBaseAttack,
    EGBaseLife, EGBaseAttack:Smallint;

    // some options
    hud_music_carrier:array[1..10] of MH_opt_cell;
    hud_sound_carrier:array[1..10] of MH_opt_cell;
    hud_mute_carrier:MH_opt_cell;
    hud_vsync_carrier:MH_opt_cell;
    hud_anti_carrier:MH_opt_cell;
    // MH gained exp
    MH_exp:Integer;
    MH_current_level:byte;

    //MH start location
    MH_start_X, MH_start_Y:Integer;
    // MH buff
    buff_MH_level_up_points:byte;
    buff_last_spell_id:byte;
    buff_hud_inv_carrier:array[1..12] of byte;
    buff_hud_inv_wearable:array[1..7] of byte;
    buff_hud_menu_spells:array[1..5] of byte;
    buff_hud_inv_spells:array[1..5,1..4] of boolean;

    // some level arrays shrines
    // full 20
    M_shrines_A:array[1..8] of item_cell;
    // life 21
    M_shrines_B:array[1..4] of item_cell;
    // mana 22
    M_shrines_C:array[1..4] of item_cell;

    // some level arrays plants
    M_plants_D:array[1..2000] of item_cell;
    M_plants_E:array[1..2000] of item_cell;
    M_plants_F:array[1..2000] of item_cell;
    M_plants_G:array[1..2000] of item_cell;
    M_plants_H:array[1..2000] of item_cell;
    M_plants_I:array[1..2000] of item_cell;
    M_plants_J:array[1..2000] of item_cell;
    M_plants_K:array[1..2000] of item_cell;

    // some movables arrays
    M_life_cells:array[1..1000] of item_cell;
    M_mana_cells:array[1..1000] of item_cell;
    M_armor_A:array[1..500] of item_cell;
    M_weapon_A:array[1..500] of item_cell;

    // some level arrays enemies
    M_enemy_A:array[1..2000] of item_cell;
    M_enemy_B:array[1..2000] of item_cell;
    M_enemy_C:array[1..2000] of item_cell;
    M_enemy_D:array[1..2000] of item_cell;
    M_enemy_E:array[1..2000] of item_cell;
    M_enemy_F:array[1..2000] of item_cell;
    M_enemy_G:array[1..2000] of item_cell;

    // local MH area
    local_terr:array[0..201,0..201] of byte;

    // MH webs
    buff_MH_webs:array[1..8] of MH_web;

    // local webs area
    local_terr_webs:array[1..8,0..201,0..201] of byte;

    // power spx
    buff_power_spx_X, buff_power_spx_Y:Integer;
    power_spx_restoration_needed:boolean;

    // some sprites
    hud_comp_name,
    hud_load_background,
    hud_load_progress,
    hud_marker_A, hud_marker_B,
    hud_credits_text,
    hud_credits_btn_up,
    hud_credits_btn_down,
    hud_failed_condition,
    hud_failed_btn_up,
    hud_failed_btn_down,
    hud_victory_condition,
    hud_victory_btn_up,
    hud_victory_btn_down,
    hud_options_music_text,
    hud_options_music_min_text,
    hud_options_music_max_text,
    hud_options_music_mute_text,
    hud_options_sound_text,
    hud_options_sound_min_text,
    hud_options_sound_max_text,
    hud_options_vsync_text,
    hud_options_anti_text,
    hud_options_btn_up,
    hud_options_btn_down:THUDSprite;
    // main menu btns
    hud_menu_menu_actions:array[1..5] of main_menu_actions;
    hud_single_menu_actions:array[1..3] of main_menu_actions;

    procedure AddMainMenuActionButtons;
    procedure showMainMenuActionButtons;
    procedure hideMainMenuActionButtons;

    procedure AddMainMenuCompanyName;

    procedure AddLoadingProgress;
    procedure showLoadingProgress;
    procedure hideLoadingProgress;

    procedure AddCredits;
    procedure showCredits;
    procedure hideCredits;

    procedure AddOptions;
    procedure showOptions;
    procedure hideOptions;

    procedure AddHudSpriteMusicCarrier;
    procedure showHudMusicCarrier;
    procedure hideHudMusicCarrier;
    procedure AddHudSpriteSoundCarrier;
    procedure showMusicPositor;
    procedure AddHudSpriteMuteCarrier;
    procedure AddHudSpriteVSyncCarrier;
    procedure AddHudSpriteAntiCarrier;

    procedure processMusicCarrierClick(item_posX,item_posY:Integer);
    procedure processSoundCarrierClick(item_posX,item_posY:Integer);
    procedure processMuteCarrierClick;
    procedure processVSyncCarrierClick;
    procedure processAntiCarrierClick;

    function getUnderMusicCarrierCellIndex(posX,posY:Integer):byte;
    function getUnderSoundCarrierCellIndex(posX,posY:Integer):byte;

    procedure AddFailedCondition;
    procedure showFailedCondition;
    procedure hideFailedCondition;

    procedure AddVictoryCondition;
    procedure showVictoryCondition;
    procedure hideVictoryCondition;

    procedure AddKeyMarkers;
    procedure hideKeyMarkers;
    procedure showKeyMarkers;
    procedure positionMarkers(idx: byte);

    procedure AddLoadOrNewMenuActionButtons;
    procedure showLoadOrNewMenuActionButtons;
    procedure hideLoadOrNewMenuActionButtons;
    function getUnderMouseLoadOrNewMenuBtnActIndex(posX,posY: Integer): byte;
    procedure processLoadOrNewMenu_Action(act: byte);

    function getUnderMouseMainMenuBtnActIndex(posX,posY:Integer):byte;
    function processMainMenuBtnAct_MouseDown(posX,posY:Integer):boolean;
    function processMainMenuBtnAct_MouseUp(posX,posY:Integer):boolean;
    procedure processMainMenu_Action(act:byte);

    procedure process_Action_single(mode:byte);

    procedure process_Action_options;

    procedure process_Action_credits;

    procedure process_Action_exit;

    procedure update_loading_progress;

    // log
    procedure writeInErrorLog(section:byte; Msg:String);
    procedure saveErrorLog;

    // file version
    function TonGetFileVersion(const FileName: String;BlockCount: Word = 4): String;
    procedure TonGetFileVersionNumbers(const FileName: String;
                                       var Major, Minor, Release, Build: integer);

    // save to level file
    procedure saveGeneratedLevel(idx:byte);
    procedure loadGeneratedLevel(idx:byte);
    procedure saveUserGame;
    procedure loadUserGame;
    procedure saveWebAreas(idx:byte);


    procedure restoreWebsFromSave;
  end;

var
  fMainMenu: TfMainMenu;

implementation
  uses Unit1;
{$R *.dfm}

procedure TfMainMenu.FormCreate(Sender: TObject);
var
  cur:TCursor;
begin
  // check if supported
  //isOpen
  // init on form create used GLScreen
  if ((Screen.Width<>800)or(Screen.Height<>600)) then begin
      SetFullscreenMode(GetIndexFromResolution(800,600,24));
  end; // if Screen res

  // set dir
  SetCurrentDir(ExtractFilePath(Application.ExeName)+'\Resources');

  // set cursor
  Screen.Cursors[0]:=LoadCursorFromFile('3d_utp.cur');
  fMainMenu.Cursor:=Screen.Cursors[0];
  GLSceneViewerMainMenu.Cursor:=Screen.Cursors[0];
  // set MH Exp
  MH_exp:=1;
  // exp step x2 each level up
  MH_base_exp_step:=1000; // change in new game 1000
  // set MH level
  MH_current_level:=1;
  // set MH start location
  MH_start_X:=-884;
  MH_start_Y:=1344;
  // set current level
  current_level:=0;
  // set go next
  go_next_level:=false;
  // last used spell
  buff_last_spell_id:=1;
  // set error count
  app_error_count:=0;
  // auto level
  auto_level_generation:=false; // false
  // set default key action
  focused_action:=1;
  // log it
  writeInErrorLog(5,'');
  // load and set prop some audio
  loadMainMenuAudio;
  allow_global_audio:=true;
  global_controls_volume_level:=0;
  global_maintheme_volume_level:=-400;
  global_game_volume_level:=-400;

  allow_game_vsync:=false;
  allow_game_antialiasing:=false;

  //load some pics
  GLMLMainMenu.Materials[0].Material.Texture.Image.LoadFromFile('power_spx.bmp');
  // show menu
  AddMainMenuActionButtons;
  AddLoadOrNewMenuActionButtons;
  AddMainMenuCompanyName;
  AddKeyMarkers;
  AddLoadingProgress;
  AddCredits;
  AddFailedCondition;
  AddVictoryCondition;
  AddOptions;

  positionMarkers(focused_action);
  showMainMenuActionButtons;
  //showOptions;

  main_menu_current_state:= 'main_menu';
  play_MainMenuAudioTrack(0,global_maintheme_volume_level,true);
  play_MainMenuAudioTrack(1,global_maintheme_volume_level,true);
end;

procedure TfMainMenu.AddMainMenuActionButtons;
var
  i:byte;
  pic_fname_up, pic_fname_down, act_name:String;
  startX, startY:Integer;
begin
    // uses Utillities , GLHUDObjects, GLTexture
  startX:=400;
  startY:=-10;

  for i:=1 to 5 do begin
      case i of
        1: begin
          pic_fname_up:='main_menu_base_btn_up_sp.bmp';
          pic_fname_down:='main_menu_base_btn_down_sp.bmp';
          act_name:='single player';
        end;
        2: begin
          pic_fname_up:='main_menu_base_btn_up_mp.bmp';
          pic_fname_down:='main_menu_base_btn_down_mp.bmp';
          act_name:='multi player';
        end;
        3: begin
          pic_fname_up:='main_menu_base_btn_up_op.bmp';
          pic_fname_down:='main_menu_base_btn_down_op.bmp';
          act_name:='options';
        end;
        4: begin
          pic_fname_up:='main_menu_base_btn_up_cr.bmp';
          pic_fname_down:='main_menu_base_btn_down_cr.bmp';
          act_name:='credits';
        end;
        5: begin
          pic_fname_up:='main_menu_base_btn_up_ex.bmp';
          pic_fname_down:='main_menu_base_btn_down_ex.bmp';
          act_name:='exit';
        end;
      end; // case


    hud_menu_menu_actions[i].hud_action_pic_up:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_menu_menu_actions[i].hud_action_pic_up do begin
      // load image BMP
      hud_menu_menu_actions[i].action_name:=act_name;
      Material.Texture.Image.LoadFromFile(pic_fname_up); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX;
      Position.Y:=(startY + (i*55));
        hud_menu_menu_actions[i].posX:=startX;
        hud_menu_menu_actions[i].posY:=(startY + (i*55));
      Height:=50;
      Width:=400; // 300
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    // lightning spell btn down
    hud_menu_menu_actions[i].hud_action_pic_down:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_menu_menu_actions[i].hud_action_pic_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile(pic_fname_down); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX;
      Position.Y:=(startY + (i*55));
      Height:=50;
      Width:=400; // 300
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
  end; // for
end;

procedure TfMainMenu.showMainMenuActionButtons;
var
  i:byte;
begin
  for i:= 1 to 5 do begin
    hud_menu_menu_actions[i].hud_action_pic_up.Visible:=true;
  end; // for
  showKeyMarkers;
end;

procedure TfMainMenu.GLSceneViewerMainMenuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  processMainMenuBtnAct_MouseDown(X,Y);
end;

procedure TfMainMenu.GLSceneViewerMainMenuMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  processMainMenuBtnAct_MouseUp(X,Y);
end;

function TfMainMenu.getUnderMouseMainMenuBtnActIndex(posX,
  posY: Integer): byte;
var
  i, borderX, borderY:Integer;
begin
  // get btn to act
  Result:=0;
  for i:= 1 to 5 do begin
    borderX:=(hud_menu_menu_actions[i].posX-150);
    borderY:=(hud_menu_menu_actions[i].posY-25);
    if( (posX >= borderX)and(posX < (borderX+300))and
        (posY >= borderY)and(posY < (borderY+50)) ) then begin
      // cursor in exact i cell
      Result:=i;
      Exit;
    end;
  end; // for all cells
end;

function TfMainMenu.processMainMenuBtnAct_MouseDown(posX,
  posY: Integer): boolean;
var
  act_id:byte;  
begin
  // choose
  Result:=false;
  if (main_menu_current_state = 'main_menu') then begin
    act_id:=getUnderMouseMainMenuBtnActIndex(posX,posY);
    if (act_id > 0) then begin
      //picked_window_id:=window_id;
      hud_menu_menu_actions[act_id].hud_action_pic_down.Visible:=true;
      hud_menu_menu_actions[act_id].hud_action_pic_up.Visible:=false;
      Result:=true;
      Exit;
    end; // if >0
  end; // if MM

  if (main_menu_current_state = 'new_or_load') then begin
    act_id:=getUnderMouseLoadOrNewMenuBtnActIndex(posX,posY);
    if (act_id > 0) then begin
      //picked_window_id:=window_id;
      hud_single_menu_actions[act_id].hud_action_pic_down.Visible:=true;
      hud_single_menu_actions[act_id].hud_action_pic_up.Visible:=false;
      Result:=true;
      Exit;
    end; // if >0
  end; // if Load new

  if (main_menu_current_state = 'credits') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_credits_btn_down.Visible:=true;
      hud_credits_btn_up.Visible:=false;
      Result:=true;
      Exit;
    end; // if btn area
  end; // if credits

  if (main_menu_current_state = 'failed_condition') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_failed_btn_down.Visible:=true;
      hud_failed_btn_up.Visible:=false;
      Result:=true;
      Exit;
    end; // if btn area
  end; // if failed

  if (main_menu_current_state = 'victory_condition') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_victory_btn_down.Visible:=true;
      hud_victory_btn_up.Visible:=false;
      Result:=true;
      Exit;
    end; // if btn area
  end; // if victory

  if (main_menu_current_state = 'options') then begin
    if((posX > 45)and(posX < 375)and(posY > 35)and(posY < 65)) then
      //ShowMessage(IntToStr(posX)+' : '+IntToStr(posY));
      processMusicCarrierClick(posX,posY);

    if((posX > 45)and(posX < 375)and(posY > 105)and(posY < 135)) then
      processSoundCarrierClick(posX,posY);

    if((posX > 275)and(posX < 305)and(posY > 145)and(posY < 175)) then
      processMuteCarrierClick;

    if((posX > 727)and(posX < 757)and(posY > 5)and(posY < 35)) then
      processVSyncCarrierClick;

    if((posX > 727)and(posX < 757)and(posY > 75)and(posY < 105)) then
      processAntiCarrierClick;
      
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_options_btn_down.Visible:=true;
      hud_options_btn_up.Visible:=false;
      // save options
      Result:=true;
      Exit;
    end; // if btn area
  end; // if options

end;

function TfMainMenu.processMainMenuBtnAct_MouseUp(posX,
  posY: Integer): boolean;
var
  act_id:byte;  
begin
  // choose
  Result:=false;
  if (main_menu_current_state = 'main_menu') then begin
    act_id:=getUnderMouseMainMenuBtnActIndex(posX,posY);
    if (act_id > 0) then begin
      //picked_window_id:=window_id;
      hud_menu_menu_actions[act_id].hud_action_pic_up.Visible:=true;
      hud_menu_menu_actions[act_id].hud_action_pic_down.Visible:=false;
        play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      processMainMenu_Action(act_id);
      Result:=true;
      Exit;
    end; // if >0
  end; // if MM

  if (main_menu_current_state = 'new_or_load') then begin
    act_id:=getUnderMouseLoadOrNewMenuBtnActIndex(posX,posY);
    if (act_id > 0) then begin
      //picked_window_id:=window_id;
      hud_single_menu_actions[act_id].hud_action_pic_up.Visible:=true;
      hud_single_menu_actions[act_id].hud_action_pic_down.Visible:=false;
        play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      processLoadOrNewMenu_Action(act_id);
      Result:=true;
      Exit;
    end; // if >0
  end; // if Load new

  if (main_menu_current_state = 'credits') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_credits_btn_up.Visible:=true;
      hud_credits_btn_down.Visible:=false;
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      //process back to MM action
      hideCredits;
      main_menu_current_state:= 'main_menu';
      GLSceneViewerMainMenu.Invalidate;
      showMainMenuActionButtons;
      GLSceneViewerMainMenu.Invalidate;
      Result:=true;
      Exit;
    end // if btn area
    else
    begin
      // only button
      hud_credits_btn_up.Visible:=true;
      hud_credits_btn_down.Visible:=false;
      //play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      Exit;
    end;
  end; // if credits

  if (main_menu_current_state = 'failed_condition') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_failed_btn_up.Visible:=true;
      hud_failed_btn_down.Visible:=false;
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      //process back to MM action
      hideFailedCondition;
      main_menu_current_state:= 'main_menu';
      GLSceneViewerMainMenu.Invalidate;
      showMainMenuActionButtons;
      GLSceneViewerMainMenu.Invalidate;
      Result:=true;
      Exit;
    end // if btn area
    else
    begin
      // only button
      hud_failed_btn_up.Visible:=true;
      hud_failed_btn_down.Visible:=false;
      //play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      Exit;
    end;
  end; // if failed

  if (main_menu_current_state = 'victory_condition') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_victory_btn_up.Visible:=true;
      hud_victory_btn_down.Visible:=false;
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      //process back to MM action
      hideVictoryCondition;
      main_menu_current_state:= 'main_menu';
      GLSceneViewerMainMenu.Invalidate;
      showMainMenuActionButtons;
      GLSceneViewerMainMenu.Invalidate;
      Result:=true;
      Exit;
    end // if btn area
    else
    begin
      // only button
      hud_victory_btn_up.Visible:=true;
      hud_victory_btn_down.Visible:=false;
      //play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      Exit;
    end;
  end; // if failed

  if (main_menu_current_state = 'options') then begin
    if((posX > 250)and(posX < 550)and(posY > 225)and(posY < 275)) then begin
      hud_options_btn_up.Visible:=true;
      hud_options_btn_down.Visible:=false;
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      //process back to MM action
      hideOptions;
      main_menu_current_state:= 'main_menu';
      GLSceneViewerMainMenu.Invalidate;
      showMainMenuActionButtons;
      GLSceneViewerMainMenu.Invalidate;
      Result:=true;
      Exit;
    end // if btn area
    else
    begin
      // only button
      hud_options_btn_up.Visible:=true;
      hud_options_btn_down.Visible:=false;
      //play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      Exit;
    end;
  end; // if options
end;

procedure TfMainMenu.processMainMenu_Action(act: byte);
begin
  // start operation from menu
  case act of
    1:begin
      if (main_menu_current_state = 'main_menu') then begin
        {
        main_menu_current_state:='loading';
        hideMainMenuActionButtons;
        GLSceneViewerMainMenu.Invalidate;
        showLoadingProgress;

        GLSceneViewerMainMenu.Invalidate;
        Refresh;
        process_Action_single(0);
        }
        main_menu_current_state:='new_or_load';
        hideMainMenuActionButtons;
        GLSceneViewerMainMenu.Invalidate;
        showLoadOrNewMenuActionButtons;
        GLSceneViewerMainMenu.Invalidate;
      end; // if state
    end; // sp
    
    2:begin

    end; // mp

    3:begin
      if (main_menu_current_state = 'main_menu') then begin
        hideMainMenuActionButtons;
        main_menu_current_state:='options';
        GLSceneViewerMainMenu.Invalidate;
        showOptions;
        GLSceneViewerMainMenu.Invalidate;
      end; // if state
    end; // options

    4:begin
      if (main_menu_current_state = 'main_menu') then begin
        hideMainMenuActionButtons;
        main_menu_current_state:='credits';
        GLSceneViewerMainMenu.Invalidate;
        showCredits;
        GLSceneViewerMainMenu.Invalidate;
      end; // if state
    end; // credits

    5:begin
      if (main_menu_current_state = 'main_menu') then begin
        main_menu_current_state:='exit';
        process_Action_exit;
      end; // if state
    end; // mp
  end;// case  
end;

procedure TfMainMenu.process_Action_single(mode:byte);
begin
  // single player
  Form1:=TForm1.Create(Self);
  Form1.Name:='UtpGameForm';
  progress_counter:=0;
  //0 new game if mode=1 is next level // 2 load from save
  Form1.InitAndLoad(mode);

  Form1.Show;

  writeInErrorLog(3,'');
  hideLoadingProgress;
end;

procedure TfMainMenu.hideMainMenuActionButtons;
var
  i:byte;
begin
  for i:= 1 to 5 do begin
    hud_menu_menu_actions[i].hud_action_pic_up.Visible:=false;
  end; // for
  hideKeyMarkers;
end;

procedure TfMainMenu.process_Action_exit;
begin
  Close;
end;

procedure TfMainMenu.saveErrorLog;
var
  attributes:word;
  ReadOnly:boolean;
begin
    // if file exist
  if FileExists('error_log.txt') then begin
    // check for RO
    Attributes := FileGetAttr('error_log.txt');
    ReadOnly := (Attributes and SysUtils.faReadOnly) = faReadOnly;
    if not ReadOnly then begin
      ErrorLog.Lines.SaveToFile('error_log.txt');
    end; // if RO
  end
  else
  begin
    // direct save
    ErrorLog.Lines.SaveToFile('error_log.txt');
  end;
end;

procedure TfMainMenu.writeInErrorLog(section: byte; Msg: String);
var
  str_error_base, str_app_exit_base,
  str_app_enter_base, str_game_exit_base,
  str_game_enter_base:String;
begin
  str_error_base:= #13#10 + '--------------------------------------------------' + #13#10 +
                   '>> [ ' + IntToStr(app_error_count) + ' ] [ ' + DateTimeToStr(Now) + ' ] ' + #13#10 +
                   '>> Msg: ' + Msg +
                   #13#10 + '--------------------------------------------------';

  str_app_exit_base:= #13#10 + '--------------------------------------------------' + #13#10 +
                   '>> EXIT APPLICATION [ ' + DateTimeToStr(Now) + ' ] ' +
                   #13#10 + '--------------------------------------------------';
                   
  str_app_enter_base:= #13#10 + '--------------------------------------------------' + #13#10 +
                   '>> ENTER APPLICATION [ ' + DateTimeToStr(Now) + ' ] ' + 'Version: ' + TonGetFileVersion(Application.ExeName,4) +
                   #13#10 + '--------------------------------------------------';

  str_game_exit_base:= #13#10 + '--------------------------------------------------' + #13#10 +
                   '>> EXIT GAME WINDOW [ ' + DateTimeToStr(Now) + ' ] ' +
                   #13#10 + '--------------------------------------------------';

  str_game_enter_base:= #13#10 + '--------------------------------------------------' + #13#10 +
                   '>> ENTER GAME WINDOW [ ' + DateTimeToStr(Now) + ' ] ' +
                   #13#10 + '--------------------------------------------------';

  case section of
    1: begin
      ErrorLog.Lines.Add(str_error_base);
    end; // 1 error
    2: begin
      ErrorLog.Lines.Add(str_game_exit_base);
    end; // 2 exit game Wnd
    3: begin
      ErrorLog.Lines.Add(str_game_enter_base);
    end; // 3 enter game Wnd
    4: begin
      ErrorLog.Lines.Add(str_app_exit_base);
    end; // 4 exit app
    5: begin
      ErrorLog.Lines.Add(str_app_enter_base);
    end; // 5 enter app
  end; // case
end;

procedure TfMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  writeInErrorLog(4,'');
  saveErrorLog;
end;

procedure TfMainMenu.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  Inc(app_error_count);
    //ShowMessage(E.Message);
  writeInErrorLog(1, E.Message);
end;

procedure TfMainMenu.AddMainMenuCompanyName;
var
  startX,startY:Integer;
begin
  startX:=56;
  startY:=284;

  hud_comp_name:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_comp_name do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('comp_name.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX;
      Position.Y:=startY;

      Height:=32;
      Width:=128; // 300
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
    end;// with
end;

procedure TfMainMenu.AddLoadingProgress;
var
  startX, startY:Integer;
begin
  startX:=400;
  startY:=60;

  hud_load_background:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_load_background do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('load_background.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 100);
      Height:=32; //256
      Width:=256;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    // add progress line
    hud_load_progress:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_load_progress do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('load_progress.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 116);
      Height:=1;
      Width:=256; //256
      // set some redness
      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=1;
      Material.FrontProperties.Ambient.Green:=1;
      Material.FrontProperties.Ambient.Blue:=1;
      //
      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=1;
      Material.FrontProperties.Diffuse.Green:=1;
      Material.FrontProperties.Diffuse.Blue:=1;
      //
      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=1;
      Material.FrontProperties.Emission.Green:=1;
      Material.FrontProperties.Emission.Blue:=1;
      //
      Material.FrontProperties.Shininess:=10;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.hideLoadingProgress;
begin
  hud_load_background.Visible:=false;
  hud_load_progress.Visible:=false;
end;

procedure TfMainMenu.showLoadingProgress;
begin
  hud_load_background.Visible:=true;
  //hud_load_progress.Visible:=true;
end;

procedure TfMainMenu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if (Key = VK_ESCAPE) then begin
    //ShowMessage(BoolToStr(allow_game_vsync,true) + BoolToStr(allow_game_antialiasing)); 
  end; // exit

  if (main_menu_current_state = 'main_menu') then begin
    if (Key = VK_UP) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      if(focused_action = 1) then begin
        focused_action:=5;
      end
      else
      begin
        dec(focused_action);
      end;
    end; // up

    if (Key = VK_DOWN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      if(focused_action = 5) then begin
        focused_action:=1;
      end
      else
      begin
        inc(focused_action);
      end;
    end; // down

    if (Key = VK_RETURN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      if (focused_action in [1..5]) then
        processMainMenu_Action(focused_action);
    end; // enter
    //
    positionMarkers(focused_action);
    Exit;
  end; // if MM

  if (main_menu_current_state = 'new_or_load') then begin
    if (Key = VK_UP) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      if(focused_action = 1) then begin
        focused_action:=3;
      end
      else
      begin
        dec(focused_action);
      end;
    end; // up

    if (Key = VK_DOWN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      if(focused_action = 3) then begin
        focused_action:=1;
      end
      else
      begin
        inc(focused_action);
      end;
    end; // down

    if (Key = VK_RETURN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      if (focused_action in [1..3]) then
        processLoadOrNewMenu_Action(focused_action);
    end; // enter
    //
    positionMarkers(focused_action);
    Exit;
  end; // if new load

  if (main_menu_current_state = 'credits') then begin
    if (Key = VK_RETURN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      // go to MM
      hud_credits_btn_down.Visible:=false;
      //process back to MM action
      hideCredits;
      main_menu_current_state:= 'main_menu';
      showMainMenuActionButtons;
    end; // enter
    //
    positionMarkers(focused_action);
    Exit;
  end; // if credits

  if (main_menu_current_state = 'failed_condition') then begin
    if (Key = VK_RETURN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      // go to MM
      hud_failed_btn_down.Visible:=false;
      //process back to MM action
      hideFailedCondition;
      main_menu_current_state:= 'main_menu';
      showMainMenuActionButtons;
    end; // enter
    //
    positionMarkers(focused_action);
    Exit;
  end; // if failed

  if (main_menu_current_state = 'victory_condition') then begin
    if (Key = VK_RETURN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      // go to MM
      hud_victory_btn_down.Visible:=false;
      //process back to MM action
      hideVictoryCondition;
      main_menu_current_state:= 'main_menu';
      showMainMenuActionButtons;
    end; // enter
    //
    positionMarkers(focused_action);
    Exit;
  end; // if victory

  if (main_menu_current_state = 'options') then begin
    if (Key = VK_RETURN) then begin
      play_MainMenuAudioTrack(5,global_controls_volume_level,false);
      // go to MM
      hud_options_btn_down.Visible:=false;
      //process back to MM action
      hideOptions;
      main_menu_current_state:= 'main_menu';
      showMainMenuActionButtons;
    end; // enter
    //
    positionMarkers(focused_action);
    Exit;
  end; // if credits
end;

procedure TfMainMenu.AddKeyMarkers;
var
  startX, startY:Integer;
begin
    startX:=400;
  startY:=30;
    // add 4 ornaments
  hud_marker_A:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_marker_A do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-180;
      Position.Y:=(startY);
      Height:=200;
      Width:=200;
      // set some redness
      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=1;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=0;
      //
      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=1;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=0;
      //
      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=1;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=0;
      //
      Material.FrontProperties.Shininess:=10;
      //Rotation:=-90;
      //Rotation:=180;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------

    hud_marker_B:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_marker_B do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+180;
      Position.Y:=(startY);
      Height:=200;
      Width:=200;
      // set some redness
      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=1;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=0;
      //
      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=1;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=0;
      //
      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=1;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=0;
      //
      Material.FrontProperties.Shininess:=10;
      //Rotation:=-90;
      //Rotation:=180;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
end;

procedure TfMainMenu.hideKeyMarkers;
begin
  hud_marker_A.Visible:=false;
  hud_marker_B.Visible:=false;
end;

procedure TfMainMenu.showKeyMarkers;
begin
  hud_marker_A.Visible:=true;
  hud_marker_B.Visible:=true;
end;

procedure TfMainMenu.positionMarkers(idx: byte);
var
  startX,startY:Integer;
begin
  startX:=400;
  startY:=-10;

  hud_marker_A.Position.Y:=(hud_menu_menu_actions[idx].posY - 5);
  hud_marker_B.Position.Y:=(hud_menu_menu_actions[idx].posY - 5);
end;

function TfMainMenu.TonGetFileVersion(const FileName: String;
  BlockCount: Word): String;
var
  iBufSize: DWORD;
  iRes: DWORD;
  pBuf: Pointer;
  pFileInfo: Pointer;
  iVer: Array[1..4] of Word;
begin
    Result := '';
  if (BlockCount < 1) or (BlockCount > 4) then
    BlockCount := 4;
  iBufSize := GetFileVersionInfoSize(PChar(FileName), iRes);
  if (iBufSize > 0) then begin
    GetMem(pBuf, iBufSize);
    try
      GetFileVersionInfo(PChar(FileName), 0, iBufSize, pBuf);
      VerQueryValue(pBuf, '\', pFileInfo, iRes);
      iRes := PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS;
      iVer[1] := HiWord(iRes);
      iVer[2] := LoWord(iRes);
      iRes := PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS;
      iVer[3] := HiWord(iRes);
      iVer[4] := LoWord(iRes);
    finally
      FreeMem(pBuf);
    end;

    for iRes := 1 to BlockCount do begin
      if iRes = 1 then
        Result := IntToStr(iVer[iRes])
      else
        Result := Result + '.' + Format('%.d', [iVer[iRes]]);
    end;
  end;
end;

procedure TfMainMenu.TonGetFileVersionNumbers(const FileName: String;
  var Major, Minor, Release, Build: integer);
var
  iBufSize: DWORD;
  iRes: DWORD;
  pBuf: Pointer;
  pFileInfo: Pointer;
begin
  iBufSize := GetFileVersionInfoSize(PChar(FileName), iRes);
  if (iBufSize > 0) then begin
    GetMem(pBuf, iBufSize);
    try
      GetFileVersionInfo(PChar(FileName), 0, iBufSize, pBuf);
      VerQueryValue(pBuf, '\', pFileInfo, iRes);
      iRes := PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS;
      Major := HiWord(iRes);
      Minor := LoWord(iRes);
      iRes := PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS;
      Release := HiWord(iRes);
      Build := LoWord(iRes);
    finally
      FreeMem(pBuf);
    end;
  end;
end;

procedure TfMainMenu.process_Action_credits;
begin
  //
end;

procedure TfMainMenu.process_Action_options;
begin
  //
end;

procedure TfMainMenu.AddCredits;
var
  startX, startY:Integer;
begin
  startX:=400;
  startY:=110;

  hud_credits_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_credits_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('credits.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=startY;
      Height:=200; //256
      Width:=600;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    // add ok buttons
    hud_credits_btn_up:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_credits_btn_up do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_up_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 140); //130
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_credits_btn_down:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_credits_btn_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_down_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 140);
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.hideCredits;
begin
  hud_credits_text.Visible:=false;
  hud_credits_btn_up.Visible:=false;
end;

procedure TfMainMenu.showCredits;
begin
  hud_credits_text.Visible:=true;
  hud_credits_btn_up.Visible:=true;
end;

procedure TfMainMenu.AddFailedCondition;
var
  startX, startY:Integer;
begin
  startX:=400; //400
  startY:=160;

  hud_failed_condition:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_failed_condition do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('mission_failed.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=startY;
      Height:=32; //256
      Width:=300;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    // add ok buttons
    hud_failed_btn_up:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_failed_btn_up do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_up_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 90); // 40
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_failed_btn_down:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_failed_btn_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_down_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 90);
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.hideFailedCondition;
begin
  hud_failed_condition.Visible:=false;
  hud_failed_btn_up.Visible:=false;
end;

procedure TfMainMenu.showFailedCondition;
begin
  hud_failed_condition.Visible:=true;
  hud_failed_btn_up.Visible:=true;
end;

procedure TfMainMenu.AddVictoryCondition;
var
  startX, startY:Integer;
begin
  startX:=400; //400
  startY:=160;

  hud_victory_condition:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_victory_condition do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('victory.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=startY;
      Height:=32; //256
      Width:=300;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    // add ok buttons
    hud_victory_btn_up:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_victory_btn_up do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_up_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 90); // 40
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_victory_btn_down:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_victory_btn_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_down_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 90);
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.hideVictoryCondition;
begin
  hud_victory_condition.Visible:=false;
  hud_victory_btn_up.Visible:=false;
end;

procedure TfMainMenu.showVictoryCondition;
begin
  hud_victory_condition.Visible:=true;
  hud_victory_btn_up.Visible:=true;
end;

procedure TfMainMenu.AddOptions;
var
  startX, startY:Integer;
begin
  startX:=400;
  startY:=110;

  hud_options_music_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_music_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('music.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-174;
      Position.Y:=startY-90;
      Height:=32; //256
      Width:=128;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    AddHudSpriteMusicCarrier;

    hud_options_music_min_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_music_min_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('min.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-358;
      Position.Y:=startY-60;
      Height:=32; //256
      Width:=64;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    hud_options_music_max_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_music_max_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('max.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+10;
      Position.Y:=startY-60;
      Height:=32; //256
      Width:=64;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    // sound -------------
    hud_options_sound_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_sound_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('sound.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-174;
      Position.Y:=startY-20;
      Height:=32; //256
      Width:=128;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    AddHudSpriteSoundCarrier;

    hud_options_sound_min_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_sound_min_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('min.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-358;
      Position.Y:=startY+10;
      Height:=32; //256
      Width:=64;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    hud_options_sound_max_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_sound_max_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('max.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+10;
      Position.Y:=startY+10;
      Height:=32; //256
      Width:=64;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //
    // mute --------------------
     hud_options_music_mute_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_music_mute_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('mute.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-174;
      Position.Y:=startY+50;
      Height:=32; //256
      Width:=128;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    AddHudSpriteMuteCarrier;

    // add ok buttons
    hud_options_btn_up:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_btn_up do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_up_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 140); //130
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_options_btn_down:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_btn_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('main_menu_base_btn_down_ok.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX;
      Position.Y:=(startY + 140);
      Height:=50;
      Width:=400;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

  // video options

  hud_options_vsync_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_vsync_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('v_sync.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+204; //174
      Position.Y:=startY-90;
      Height:=32; //256
      Width:=256;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    AddHudSpriteVSyncCarrier;

    hud_options_anti_text:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_options_anti_text do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('anti.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+217;
      Position.Y:=startY-20;
      Height:=32; //256
      Width:=256;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
    //--------------------
    AddHudSpriteAntiCarrier;
end;

procedure TfMainMenu.hideOptions;
begin
  // music
  hud_options_music_text.Visible:=false;
  hud_options_music_min_text.Visible:=false;
  hud_options_music_max_text.Visible:=false;
  hud_options_music_mute_text.Visible:=false;
  // sound
  hud_options_sound_text.Visible:=false;
  hud_options_sound_min_text.Visible:=false;
  hud_options_sound_max_text.Visible:=false;
  //
  hud_options_vsync_text.Visible:=false;
  hud_options_anti_text.Visible:=false;
  
  hud_options_btn_up.Visible:=false;
  hideHudMusicCarrier;
end;

procedure TfMainMenu.showOptions;
begin
  // music
  hud_options_music_text.Visible:=true;
  hud_options_music_min_text.Visible:=true;
  hud_options_music_max_text.Visible:=true;
  hud_options_music_mute_text.Visible:=true;
  // sound
  hud_options_sound_text.Visible:=true;
  hud_options_sound_min_text.Visible:=true;
  hud_options_sound_max_text.Visible:=true;
  //
  hud_options_vsync_text.Visible:=true;
  hud_options_anti_text.Visible:=true;

  hud_options_btn_up.Visible:=true;
  showHudMusicCarrier;
end;

procedure TfMainMenu.AddHudSpriteMusicCarrier;
var
  i:byte;
  startX, startY:Integer;
begin
  // music carrier
  // hud_inv_carrier:array[1..10] of MH_inv_cell; da se copy i da se dobavi cell_volume_level:Smallint;
  startX:=60;
  startY:=50;
  for i:= 1 to 10 do begin
    hud_music_carrier[i].hud_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_music_carrier[i].hud_pic do begin
    // load image BMP
      Material.Texture.Image.LoadFromFile('inv_cell.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=(startX + (i*30));
      hud_music_carrier[i].posX:=(startX + (i*30))-15;
      // set Y
      Position.Y:=startY;
      hud_music_carrier[i].posY:=startY-15;

      hud_music_carrier[i].opt_level:= -( (global_sound_step*10)-(global_sound_step*i) );

      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_music_carrier[i].hud_item_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_music_carrier[i].hud_item_pic do begin
    // load image BMP
      Material.Texture.Image:=GLMLMainMenu.Materials[0].Material.Texture.Image;
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=(startX + (i*30));
      Position.Y:=startY;
      Height:=25;
      Width:=25;

      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None

      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
  end; // for
end;

procedure TfMainMenu.showHudMusicCarrier;
var
  i:byte;
begin
  // check step level
  for i:= 1 to 10 do begin
    hud_music_carrier[i].hud_pic.Visible:=true;
  end; // for

  for i:=1 to 10 do begin
    hud_sound_carrier[i].hud_pic.Visible:=true;
  end; // for

  hud_mute_carrier.hud_pic.Visible:=true;
  hud_mute_carrier.hud_item_pic.Visible:= not allow_global_audio;
  //
  hud_vsync_carrier.hud_pic.Visible:=true;
  hud_vsync_carrier.hud_item_pic.Visible:= allow_game_vsync;

  hud_anti_carrier.hud_pic.Visible:=true;
  hud_anti_carrier.hud_item_pic.Visible:= allow_game_antialiasing;

  showMusicPositor;
end;

procedure TfMainMenu.hideHudMusicCarrier;
var
  i:byte;
begin
  // check step level
  for i:= 1 to 10 do begin
    hud_music_carrier[i].hud_pic.Visible:=false;
    hud_music_carrier[i].hud_item_pic.Visible:=false;
  end; // for

  for i:=1 to 10 do begin
    hud_sound_carrier[i].hud_pic.Visible:=false;
    hud_sound_carrier[i].hud_item_pic.Visible:=false;
  end; // for

  hud_mute_carrier.hud_pic.Visible:=false;
  hud_mute_carrier.hud_item_pic.Visible:=false;

  hud_vsync_carrier.hud_pic.Visible:=false;
  hud_vsync_carrier.hud_item_pic.Visible:= false;

  hud_anti_carrier.hud_pic.Visible:=false;
  hud_anti_carrier.hud_item_pic.Visible:= false;
end;

procedure TfMainMenu.AddHudSpriteSoundCarrier;
var
  i:byte;
  startX, startY:Integer;
begin
  // sound carrier
  // hud_inv_carrier:array[1..10] of MH_inv_cell; da se copy i da se dobavi cell_volume_level:Smallint;
  startX:=60;
  startY:=120;
  for i:= 1 to 10 do begin
    hud_sound_carrier[i].hud_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_sound_carrier[i].hud_pic do begin
    // load image BMP
      Material.Texture.Image.LoadFromFile('inv_cell.bmp');
      // set X
      Position.X:=(startX + (i*30));
      hud_sound_carrier[i].posX:=(startX + (i*30))-15;
      // set Y
      Position.Y:=startY;
      hud_sound_carrier[i].posY:=startY-15;

      hud_sound_carrier[i].opt_level:= -( (global_sound_step*10)-(global_sound_step*i) );

      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_sound_carrier[i].hud_item_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_sound_carrier[i].hud_item_pic do begin
    // load image BMP
      Material.Texture.Image:=GLMLMainMenu.Materials[0].Material.Texture.Image;
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=(startX + (i*30));
      Position.Y:=startY;
      Height:=25;
      Width:=25;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
  end; // for
end;

procedure TfMainMenu.processMusicCarrierClick(item_posX,
  item_posY: Integer);
var
  i, cell_id:byte;
begin
  cell_id:=getUnderMusicCarrierCellIndex(item_posX,item_posY);
  if (cell_id <> 0) then begin
    // change cell
    global_maintheme_volume_level:=hud_music_carrier[cell_id].opt_level;
    // hide all first
    for i:= 1 to 10 do begin
      hud_music_carrier[i].hud_item_pic.Visible:=false;
    end; // for
    hud_music_carrier[cell_id].hud_item_pic.Visible:=true;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    // change volume
    changeVolumeLevel(0, global_maintheme_volume_level);
    changeVolumeLevel(1, global_maintheme_volume_level);

  end;
end;

function TfMainMenu.getUnderMusicCarrierCellIndex(posX,
  posY: Integer): byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  hud_music_carrier[10].posX:=345;
  hud_music_carrier[10].posY:=35;
  for i:= 1 to 10 do begin
    borderX:=hud_music_carrier[i].posX;
    borderY:=hud_music_carrier[i].posY;
    if( (posX >= borderX)and(posX < (borderX+30))and
        (posY >= borderY)and(posY < (borderY+30)) ) then begin
      // cursor in exact i cell
      Result:=i;
      break;//Exit;
    end;
  end; // for all cells
end;

procedure TfMainMenu.showMusicPositor;
var
  i:byte;
begin
  // check step level
  for i:= 1 to 10 do begin
    if(hud_music_carrier[i].opt_level=global_maintheme_volume_level) then begin
      hud_music_carrier[i].hud_item_pic.Visible:=true;
    end; // if
  end; // for

  for i:= 1 to 10 do begin
    if(hud_sound_carrier[i].opt_level=global_game_volume_level) then begin
      hud_sound_carrier[i].hud_item_pic.Visible:=true;
    end; // if
  end; // for
  
end;

procedure TfMainMenu.processSoundCarrierClick(item_posX,
  item_posY: Integer);
var
  i, cell_id:byte;
begin
  cell_id:=getUnderSoundCarrierCellIndex(item_posX,item_posY);
  if (cell_id <> 0) then begin
    // change cell
    global_game_volume_level:=hud_sound_carrier[cell_id].opt_level;
    // hide all first
    for i:= 1 to 10 do begin
      hud_sound_carrier[i].hud_item_pic.Visible:=false;
    end; // for
    hud_sound_carrier[cell_id].hud_item_pic.Visible:=true;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
  end;
end;

function TfMainMenu.getUnderSoundCarrierCellIndex(posX,
  posY: Integer): byte;
var
  i, borderX, borderY:Integer;  
begin
  Result:=0;
  for i:= 1 to 10 do begin
    borderX:=hud_sound_carrier[i].posX;
    borderY:=hud_sound_carrier[i].posY;
    if( (posX >= borderX)and(posX < (borderX+30))and
        (posY >= borderY)and(posY < (borderY+30)) ) then begin
      // cursor in exact i cell
      Result:=i;
      Exit;
    end;
  end; // for all cells  
end;

procedure TfMainMenu.AddHudSpriteMuteCarrier;
var
  i:byte;
  startX, startY:Integer;
begin
    // sound carrier
  // hud_inv_carrier:array[1..10] of MH_inv_cell; da se copy i da se dobavi cell_volume_level:Smallint;
  startX:=226;
  startY:=160;
    hud_mute_carrier.hud_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_mute_carrier.hud_pic do begin
    // load image BMP
      Material.Texture.Image.LoadFromFile('inv_cell.bmp');
      // set X
      Position.X:=(startX + 64);
      hud_sound_carrier[i].posX:=(startX + 64)-15;
      // set Y
      Position.Y:=startY;
      hud_sound_carrier[i].posY:=startY-15;

      hud_sound_carrier[i].opt_level:= 0;

      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_mute_carrier.hud_item_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_mute_carrier.hud_item_pic do begin
    // load image BMP
      Material.Texture.Image:=GLMLMainMenu.Materials[0].Material.Texture.Image;
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=(startX + 64);
      Position.Y:=startY;
      Height:=25;
      Width:=25;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.processMuteCarrierClick;
begin
  if(hud_mute_carrier.hud_item_pic.Visible) then begin
    hud_mute_carrier.hud_item_pic.Visible:=false;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    //unmute it
    allow_global_audio:=true;
    //play MT
    play_MainMenuAudioTrack(0,global_maintheme_volume_level,true);
    play_MainMenuAudioTrack(1,global_maintheme_volume_level,true);
  end // if
  else
  begin
    hud_mute_carrier.hud_item_pic.Visible:=true;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    // stop playing MT
    play_HerosAudioTrack(0, global_maintheme_volume_level, false,true);
    play_HerosAudioTrack(1, global_maintheme_volume_level, false,true);
    // mute it
    allow_global_audio:=false;
  end;
end;

procedure TfMainMenu.AddHudSpriteVSyncCarrier;
var
  startX, startY:Integer;
begin
  // vsync carrier
  // hud_inv_carrier:array[1..10] of MH_inv_cell; da se copy i da se dobavi cell_volume_level:Smallint;
  startX:=666; // 576
  startY:=20;
    hud_vsync_carrier.hud_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_vsync_carrier.hud_pic do begin
    // load image BMP
      Material.Texture.Image.LoadFromFile('inv_cell.bmp');
      // set X
      Position.X:=(startX + 76);
      hud_vsync_carrier.posX:=(startX + 76)-15;
      // set Y
      Position.Y:=startY;
      hud_vsync_carrier.posY:=startY-15;

      hud_vsync_carrier.opt_level:= 0;

      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_vsync_carrier.hud_item_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_vsync_carrier.hud_item_pic do begin
    // load image BMP
      Material.Texture.Image:=GLMLMainMenu.Materials[0].Material.Texture.Image;
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=(startX + 76);
      Position.Y:=startY;
      Height:=25;
      Width:=25;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.processVSyncCarrierClick;
begin
  if(hud_vsync_carrier.hud_item_pic.Visible) then begin
    hud_vsync_carrier.hud_item_pic.Visible:=false;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    allow_game_vsync:=false;
  end // if
  else
  begin
    hud_vsync_carrier.hud_item_pic.Visible:=true;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    allow_game_vsync:=true;
  end;
end;

procedure TfMainMenu.AddHudSpriteAntiCarrier;
var
  startX, startY:Integer;
begin
    // vsync carrier
  // hud_inv_carrier:array[1..10] of MH_inv_cell; da se copy i da se dobavi cell_volume_level:Smallint;
  startX:=666; // 226
  startY:=90;
    hud_anti_carrier.hud_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_anti_carrier.hud_pic do begin
    // load image BMP
      Material.Texture.Image.LoadFromFile('inv_cell.bmp');
      // set X
      Position.X:=(startX + 76);
      hud_anti_carrier.posX:=(startX + 76)-15;
      // set Y
      Position.Y:=startY;
      hud_anti_carrier.posY:=startY-15;

      hud_anti_carrier.opt_level:= 0;

      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_anti_carrier.hud_item_pic:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_anti_carrier.hud_item_pic do begin
    // load image BMP
      Material.Texture.Image:=GLMLMainMenu.Materials[0].Material.Texture.Image;
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=(startX + 76);
      Position.Y:=startY;
      Height:=25;
      Width:=25;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
end;

procedure TfMainMenu.processAntiCarrierClick;
begin
  if(hud_anti_carrier.hud_item_pic.Visible) then begin
    hud_anti_carrier.hud_item_pic.Visible:=false;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    allow_game_antialiasing:=false;
  end // if
  else
  begin
    hud_anti_carrier.hud_item_pic.Visible:=true;
    play_MainMenuAudioTrack(5,global_controls_volume_level,false);
    allow_game_antialiasing:=true;
  end;
end;

procedure TfMainMenu.update_loading_progress;
begin
  //inc(progress_counter);
end;

procedure TfMainMenu.AsyncTimer1Timer(Sender: TObject);
begin
  if go_next_level then begin
    go_next_level:=false;
    MH_start_X:=-884;
    MH_start_Y:=1344;
    process_Action_single(1);
  end;
end;

procedure TfMainMenu.saveGeneratedLevel(idx: byte);
var
  F:TFileStream;
  path:String;
begin
  path:=ExtractFilePath(Application.ExeName) + '\Maps\level1.utl';
  F:=TFileStream.Create(path,fmCreate);
  try
    // portal
    F.WriteBuffer(Form1.portal_X,SizeOf(Form1.portal_X));
    F.WriteBuffer(Form1.portal_Y,SizeOf(Form1.portal_Y));
    // spx
    F.WriteBuffer(Form1.power_spx_X,SizeOf(Form1.power_spx_X));
    F.WriteBuffer(Form1.power_spx_Y,SizeOf(Form1.power_spx_Y));
    // shrines
    F.WriteBuffer(M_shrines_A[1],SizeOf(M_shrines_A));
    F.WriteBuffer(M_shrines_B[1],SizeOf(M_shrines_B));
    F.WriteBuffer(M_shrines_C[1],SizeOf(M_shrines_C));
    // plants
    F.WriteBuffer(M_plants_D[1],SizeOf(M_plants_D));
    F.WriteBuffer(M_plants_E[1],SizeOf(M_plants_E));
    F.WriteBuffer(M_plants_F[1],SizeOf(M_plants_F));
    F.WriteBuffer(M_plants_G[1],SizeOf(M_plants_G));
    F.WriteBuffer(M_plants_H[1],SizeOf(M_plants_H));
    F.WriteBuffer(M_plants_I[1],SizeOf(M_plants_I));
    F.WriteBuffer(M_plants_J[1],SizeOf(M_plants_J));
    F.WriteBuffer(M_plants_K[1],SizeOf(M_plants_K));
    // movables
    F.WriteBuffer(M_life_cells[1],SizeOf(M_life_cells));
    F.WriteBuffer(M_mana_cells[1],SizeOf(M_mana_cells));
    F.WriteBuffer(M_armor_A[1],SizeOf(M_armor_A));
    F.WriteBuffer(M_weapon_A[1],SizeOf(M_weapon_A));
    // enemies
    F.WriteBuffer(M_enemy_A[1],SizeOf(M_enemy_A));
    F.WriteBuffer(M_enemy_B[1],SizeOf(M_enemy_B));
    F.WriteBuffer(M_enemy_C[1],SizeOf(M_enemy_C));
    F.WriteBuffer(M_enemy_D[1],SizeOf(M_enemy_D));
    F.WriteBuffer(M_enemy_E[1],SizeOf(M_enemy_E));
    F.WriteBuffer(M_enemy_F[1],SizeOf(M_enemy_F));
    F.WriteBuffer(M_enemy_G[1],SizeOf(M_enemy_G));
  finally
    F.Free;
  end;
end;

procedure TfMainMenu.loadGeneratedLevel(idx: byte);
var
  F:TFileStream;
  path:String;
begin
  path:=ExtractFilePath(Application.ExeName) + '\Maps\level' + IntToStr(idx) + '.utl';
  F:=TFileStream.Create(path,fmOpenRead);
  try
    // portal
    F.ReadBuffer(Form1.portal_X,SizeOf(Form1.portal_X));
    F.ReadBuffer(Form1.portal_Y,SizeOf(Form1.portal_Y));
    // spx
    F.ReadBuffer(Form1.power_spx_X,SizeOf(Form1.power_spx_X));
    F.ReadBuffer(Form1.power_spx_Y,SizeOf(Form1.power_spx_Y));
    // shrines
    F.ReadBuffer(M_shrines_A[1],SizeOf(M_shrines_A));
    F.ReadBuffer(M_shrines_B[1],SizeOf(M_shrines_B));
    F.ReadBuffer(M_shrines_C[1],SizeOf(M_shrines_C));
    // plants
    F.ReadBuffer(M_plants_D[1],SizeOf(M_plants_D));
    F.ReadBuffer(M_plants_E[1],SizeOf(M_plants_E));
    F.ReadBuffer(M_plants_F[1],SizeOf(M_plants_F));
    F.ReadBuffer(M_plants_G[1],SizeOf(M_plants_G));
    F.ReadBuffer(M_plants_H[1],SizeOf(M_plants_H));
    F.ReadBuffer(M_plants_I[1],SizeOf(M_plants_I));
    F.ReadBuffer(M_plants_J[1],SizeOf(M_plants_J));
    F.ReadBuffer(M_plants_K[1],SizeOf(M_plants_K));
    // movables
    F.ReadBuffer(M_life_cells[1],SizeOf(M_life_cells));
    F.ReadBuffer(M_mana_cells[1],SizeOf(M_mana_cells));
    F.ReadBuffer(M_armor_A[1],SizeOf(M_armor_A));
    F.ReadBuffer(M_weapon_A[1],SizeOf(M_weapon_A));
    // enemies
    F.ReadBuffer(M_enemy_A[1],SizeOf(M_enemy_A));
    F.ReadBuffer(M_enemy_B[1],SizeOf(M_enemy_B));
    F.ReadBuffer(M_enemy_C[1],SizeOf(M_enemy_C));
    F.ReadBuffer(M_enemy_D[1],SizeOf(M_enemy_D));
    F.ReadBuffer(M_enemy_E[1],SizeOf(M_enemy_E));
    F.ReadBuffer(M_enemy_F[1],SizeOf(M_enemy_F));
    F.ReadBuffer(M_enemy_G[1],SizeOf(M_enemy_G));
  finally
    F.Free;
  end;
end;

procedure TfMainMenu.saveUserGame;
var
  i,j,curX,curY:Integer;
  F:TFileStream;
  path:String;
  c:byte;
begin
  // get MH coords
  with Form1 do begin
    curX:=round(DCMainHero.Position.X);
    curY:=round(DCMainHero.Position.Z);

    // buff some props
    buff_MH_Inventory;
    MH_current_level:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MH_current_level;
    // webs
    for c:=1 to 8 do begin
      buff_MH_webs[c].isFree:=true;
      if not WebInfo(MHWebs[c].Behaviours.GetByClass(WebInfo)).isFree then begin
        buff_MH_webs[c].posX:=round(MHWebs[c].Position.X);
        buff_MH_webs[c].posZ:=round(MHWebs[c].Position.Z);
        buff_MH_webs[c].posY:=round(MHWebs[c].Position.Y);
        buff_MH_webs[c].isFree:=false;
      end; // if
    end; // for

    saveWebAreas(0);
    // ---------------
    power_spx_restoration_needed:= not checkMHpowerSpxPresence;

    path:=ExtractFilePath(Application.ExeName) + '\Save\savepoint.uts';
    F:=TFileStream.Create(path,fmCreate);
             //ErrorLog.Lines.Clear;
    for j:=(curY-100) to (curY+100) do begin
      for i:=(curX-100) to (curX+100) do begin
        // clear it first
        local_terr[(i-(curX-100)) , (j-(curY-100))]:=0;
        // buffer it if movable
        if not(terrObs[i,j].itemId in [80]) then
          local_terr[(i-(curX-100)) , (j-(curY-100))]:=terrObs[i,j].itemId;
          //--
          //ErrorLog.Lines.Add('X: ' + IntToStr((i-(curX-100))) + '  Y:' +
          //  IntToStr((j-(curY-100))) + '  id:' +  IntToStr(local_terr[(i-(curX-100)) , (j-(curY-100))])  );

          //--
      end; // for i
    end; // for j
     //ErrorLog.Lines.SaveToFile('save.txt');

  try
    // hero coords
    F.WriteBuffer(curX,SizeOf(curX));
    F.WriteBuffer(curY,SizeOf(curY));
    // local area
    F.WriteBuffer(local_terr[0,0],SizeOf(local_terr));
    // hero level up points
    F.WriteBuffer(buff_MH_level_up_points,SizeOf(buff_MH_level_up_points));
    // hero carrier
    F.WriteBuffer(buff_hud_inv_carrier[1],SizeOf(buff_hud_inv_carrier));
    // hero wear
    F.WriteBuffer(buff_hud_inv_wearable[1],SizeOf(buff_hud_inv_wearable));
    // hero spells menu
    F.WriteBuffer(buff_hud_inv_spells[1,1],SizeOf(buff_hud_inv_spells));
    // hero experience
    F.WriteBuffer(MH_exp,SizeOf(MH_exp));
    // hero current level
    F.WriteBuffer(MH_current_level,SizeOf(MH_current_level));
    // hero last spell used
    F.WriteBuffer(buff_last_spell_id, SizeOf(buff_last_spell_id));
    // hero base exo step
    F.WriteBuffer(MH_base_exp_step, SizeOf(MH_base_exp_step));
    // webs count
    F.WriteBuffer(buff_MH_webs[1], SizeOf(buff_MH_webs));
    // webs areas
    F.WriteBuffer(local_terr_webs[1,0,0], SizeOf(local_terr_webs));
    // spx
    F.WriteBuffer(Form1.power_spx_X,SizeOf(Form1.power_spx_X));
    F.WriteBuffer(Form1.power_spx_Y,SizeOf(Form1.power_spx_Y));
    F.WriteBuffer(power_spx_restoration_needed,SizeOf(power_spx_restoration_needed));
    // play level
    F.WriteBuffer(current_level, SizeOf(current_level));

  finally
    F.Free;
  end; // finally
  end; // with
end;

procedure TfMainMenu.AddLoadOrNewMenuActionButtons;
var
  i:byte;
  pic_fname_up, pic_fname_down, act_name:String;
  startX, startY:Integer;
begin
  startX:=400;
  startY:=-10;

  for i:=1 to 3 do begin
      case i of
        1: begin
          pic_fname_up:='new_game_base_btn_up.bmp';
          pic_fname_down:='new_game_base_btn_down.bmp';
          act_name:='new_game';
        end;
        2: begin
          pic_fname_up:='load_game_base_btn_up.bmp';
          pic_fname_down:='load_game_base_btn_down.bmp';
          act_name:='load_game';
        end;
        3: begin
          pic_fname_up:='main_menu_base_btn_up_ex.bmp';
          pic_fname_down:='main_menu_base_btn_down_ex.bmp';
          act_name:='exit_to_MM';
        end;
      end; // case


    hud_single_menu_actions[i].hud_action_pic_up:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_single_menu_actions[i].hud_action_pic_up do begin
      // load image BMP
      hud_single_menu_actions[i].action_name:=act_name;
      Material.Texture.Image.LoadFromFile(pic_fname_up); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX;
      Position.Y:=(startY + (i*55));
        hud_single_menu_actions[i].posX:=startX;
        hud_single_menu_actions[i].posY:=(startY + (i*55));
      Height:=50;
      Width:=400; // 300
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    // lightning spell btn down
    hud_single_menu_actions[i].hud_action_pic_down:=THUDSprite(DCMainMenu.AddNewChild(THUDSprite));
    with hud_single_menu_actions[i].hud_action_pic_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile(pic_fname_down); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX;
      Position.Y:=(startY + (i*55));
      Height:=50;
      Width:=400; // 300
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmOpaque;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaDefault;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmDecal;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
  end; // for
end;

procedure TfMainMenu.showLoadOrNewMenuActionButtons;
var
  i:byte;
begin
  for i:= 1 to 3 do begin
    hud_single_menu_actions[i].hud_action_pic_up.Visible:=true;
  end; // for
  showKeyMarkers;
end;

procedure TfMainMenu.hideLoadOrNewMenuActionButtons;
var
  i:byte;
begin
  for i:= 1 to 3 do begin
    hud_single_menu_actions[i].hud_action_pic_up.Visible:=false;
  end; // for
  hideKeyMarkers;
end;

function TfMainMenu.getUnderMouseLoadOrNewMenuBtnActIndex(posX,
  posY: Integer): byte;
var
  i, borderX, borderY:Integer;
begin
  // get btn to act
  Result:=0;
  for i:= 1 to 3 do begin
    borderX:=(hud_single_menu_actions[i].posX-150);
    borderY:=(hud_single_menu_actions[i].posY-25);
    if( (posX >= borderX)and(posX < (borderX+300))and
        (posY >= borderY)and(posY < (borderY+50)) ) then begin
      // cursor in exact i cell
      Result:=i;
      Exit;
    end;
  end; // for all cells
end;

procedure TfMainMenu.processLoadOrNewMenu_Action(act: byte);
var
  path:String;
begin
  // start operation from menu
  case act of
    1:begin
      if (main_menu_current_state = 'new_or_load') then begin
        main_menu_current_state:='loading';
        // some init
        // set MH Exp
        MH_exp:=1;
        // exp step x2 each level up
        MH_base_exp_step:=1000; // 1000
        // set MH level
        MH_current_level:=1;
        // set MH start location
        MH_start_X:=-884;
        MH_start_Y:=1344;
        // set current level
        current_level:=0;
        //hideMainMenuActionButtons;
        hideLoadOrNewMenuActionButtons;
        GLSceneViewerMainMenu.Invalidate;
        showLoadingProgress;

        GLSceneViewerMainMenu.Invalidate;
        Refresh;
        process_Action_single(0);
      end; // if state
    end; // sp

    2:begin
      // load game
      if (main_menu_current_state = 'new_or_load') then begin
        // check for save file
        path:=ExtractFilePath(Application.ExeName) + '\Save\savepoint.uts';
        if FileExists(path) then begin
          main_menu_current_state:='loading';
          //hideMainMenuActionButtons;
          hideLoadOrNewMenuActionButtons;
          GLSceneViewerMainMenu.Invalidate;
          showLoadingProgress;

          GLSceneViewerMainMenu.Invalidate;
          Refresh;
          process_Action_single(2);
        end; // if exist
      end; // if
    end; // 2

    3:begin
      // exit to MM
      if (main_menu_current_state = 'new_or_load') then begin
        hideLoadOrNewMenuActionButtons;
        main_menu_current_state:='main_menu';
        GLSceneViewerMainMenu.Invalidate;
        showMainMenuActionButtons;
        GLSceneViewerMainMenu.Invalidate;
      end; // if state
    end; // options

  end;// case
end;

procedure TfMainMenu.loadUserGame;
var
  i,j,curX,curY:Integer;
  F:TFileStream;
  path:String;
begin
  // check for savepoint.uts exists
  path:=ExtractFilePath(Application.ExeName) + '\Save\savepoint.uts';
  if not FileExists(path) then
    Exit;

    F:=TFileStream.Create(path,fmOpenRead);

  try
    {
    // MH coord
    F.ReadBuffer(MH_start_X,SizeOf(MH_start_X));
    F.ReadBuffer(MH_start_Y,SizeOf(MH_start_Y));
    // local area
    F.ReadBuffer(local_terr[0,0],SizeOf(local_terr));
    }
    // hero coords
    F.ReadBuffer(MH_start_X,SizeOf(MH_start_X));
    F.ReadBuffer(MH_start_Y,SizeOf(MH_start_Y));
    // local area
    F.ReadBuffer(local_terr[0,0],SizeOf(local_terr));
    // hero level up points
    F.ReadBuffer(buff_MH_level_up_points,SizeOf(buff_MH_level_up_points));
    // hero carrier
    F.ReadBuffer(buff_hud_inv_carrier[1],SizeOf(buff_hud_inv_carrier));
    // hero wear
    F.ReadBuffer(buff_hud_inv_wearable[1],SizeOf(buff_hud_inv_wearable));
    // hero spells menu
    F.ReadBuffer(buff_hud_inv_spells[1,1],SizeOf(buff_hud_inv_spells));
    // hero experience
    F.ReadBuffer(MH_exp,SizeOf(MH_exp));
    // hero current level
    F.ReadBuffer(MH_current_level,SizeOf(MH_current_level));
    // hero last spell used
    F.ReadBuffer(buff_last_spell_id, SizeOf(buff_last_spell_id));
    // hero base exo step
    F.ReadBuffer(MH_base_exp_step, SizeOf(MH_base_exp_step));
    // webs count
    F.ReadBuffer(buff_MH_webs[1], SizeOf(buff_MH_webs));
    // webs areas
    F.ReadBuffer(local_terr_webs[1,0,0], SizeOf(local_terr_webs));
    // spx
    F.ReadBuffer(buff_power_spx_X,SizeOf(buff_power_spx_X));
    F.ReadBuffer(buff_power_spx_Y,SizeOf(buff_power_spx_Y));
    F.ReadBuffer(power_spx_restoration_needed,SizeOf(power_spx_restoration_needed));
    // play level
    F.ReadBuffer(current_level, SizeOf(current_level));
  finally
    F.Free;
  end; // finally
  //end; // with
end;

procedure TfMainMenu.restoreWebsFromSave;
var
  i:byte;
begin
  // invoke after initWebs in InitAndLoad
  for i:=1 to 8 do begin
    if not buff_MH_webs[i].isFree then begin
      // build web
      MHBuildWeb(buff_MH_webs[i].posX, buff_MH_webs[i].posY, buff_MH_webs[i].posZ);
    end // if
  end; // for
end;

procedure TfMainMenu.saveWebAreas(idx: byte);
var
  i,j,curX, curY:Integer;
  c:byte;
begin
  // save terra near each web
  for c:=1 to 8 do begin
    if not WebInfo(Form1.MHWebs[c].Behaviours.GetByClass(WebInfo)).isFree then begin
      // ---------------
      curX:=round(Form1.MHWebs[c].Position.X);
      curY:=round(Form1.MHWebs[c].Position.Z);
      
      for j:=(curY-100) to (curY+100) do begin
        for i:=(curX-100) to (curX+100) do begin
          // clear it first
          local_terr_webs[c,(i-(curX-100)) , (j-(curY-100))]:=0;
          // buffer it if movable
          if not(Form1.terrObs[i,j].itemId in [80]) then
            local_terr_webs[c,(i-(curX-100)) , (j-(curY-100))]:=Form1.terrObs[i,j].itemId;
        end; // for i
      end; // for j
      // --------------
    end; // if
  end; // for
end;

end.
