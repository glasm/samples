{: Basic terrain rendering demo.<p>

   This demo showcases the TerrainRenderer, some of the SkyDome features
   and bits of 3D sound 'cause I got carried over ;)<br>
   The terrain HeightData is provided by a TGLBitmapHDS (HDS stands for
   "Height Data Source"), and displayed by a TTerrainRenderer.<p>

   The base terrain renderer uses a hybrid ROAM/brute-force approach to
   rendering terrain, by requesting height data tiles, then rendering them
   using either triangle strips (for those below "QualityDistance") or ROAM
   tessellation.<br>
   Note that if the terrain is wrapping in this sample (to reduce the required
   datasets size), the engine is *not* aware of it and does not exploit this
   fact in any way: it considers just an infinite terrain.<p>

   Controls:<ul>
   <li>Direction keys move the came nora (shift to speedup)
   <li>PageUp/PageDown move the camera up and down
   <li>Orient the camera freely by holding down the left button
   <li>Toggle wireframe mode with 'w'
   <li>Increase/decrease the viewing distance with '+'/'-'.
   <li>Increase/decrease CLOD precision with '*' and '/'.
   <li>Increase/decrease QualityDistance with '9' and '8'.
   <li>'n' turns on 'night' mode, 'd' turns back to 'day' mode.
   <li>Toggle star twinkle with 't' (night mode only) 
   </ul><p>

   When increasing the range, or moving after having increased the range you
   may notice a one-time slowdown, this originates in the base height data
   being duplicated to create the illusion of an "infinite" terrain (at max
   range the visible area covers 1024x1024 height samples, and with tiles of
   size 16 or less, this is a lot of tiles to prepare).
}
unit Unit1;

interface



uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GLScene, GLTerrainRenderer, GLObjects, GLMisc, jpeg, GLHeightData,
  ExtCtrls, GLCadencer, StdCtrls, GLTexture, GLHUDObjects, GLBitmapFont,
  GLSkydome, GLWin32Viewer, Geometry, GLzBuffer,
  GLVectorFileObjects, AsyncTimer,GLMovement, GLScreen, GLGraph, ComCtrls,
  DataModule, Utillities, GLExtrusion, GLFireFX, Buttons, GLCollision,
  GLThorFX,
  NebulaPath, NebulaPathEA, GLParticleFX,
  MainMenu, AudioUtils, GLMultiPolygon, GLContext;


const
  
  enemA=1; { ishta-pan spider dalak } {4} {total enemies count not exceed 6 }
  enemB=1; { algo-pan alien} {2}
  enemC=1; { algo-pan bug} {2}
  enemD=1; { algo-pan insect} {2}
  enemE=1; { algo-pan frog} {2}
  enemF=1; { algo-pan drio} {2}
  enemG=1; { algo-pan okta} {2}

  ea_critical_life=20;
  MH_chain_distance=30;
  MH_nova_distance=40;
type
  terrCell=packed record
    //walkable:boolean;
    itemId:byte;
    itemRotation:byte;
end; // terrCell

type
  shrineCoord=packed record
    Xcoord:Integer;
    Ycoord:Integer;
end;

type EB_FireConv=array[1..5] of TSphere;



type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLBitmapHDS1: TGLBitmapHDS;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    DCMainHero: TDummyCube;
    TerrainRenderer1: TTerrainRenderer;
    Timer1: TTimer;
    GLCadencer1: TGLCadencer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    BitmapFont1: TBitmapFont;
    HUDTextFPS: THUDText;
    ArrowLine1: TArrowLine;
    Sphere1: TSphere;
    ArrowLine2: TArrowLine;
    AsyncTimer1: TAsyncTimer;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Actor1: TActor;
    DummyCubeWater: TDummyCube;
    subWaterPlane: TPlane;
    topWaterPlane: TPlane;
    GLMLSubWaterTx: TGLMaterialLibrary;
    DCBasePlantA: TDummyCube;
    GLMLHudSprites: TGLMaterialLibrary;
    GLMLBaseRockTxA: TGLMaterialLibrary;
    DCBasePlantD: TDummyCube;
    Pipe1: TPipe;
    Pipe2: TPipe;
    Pipe3: TPipe;
    FreeForm1: TFreeForm;
    DCBasePlantB: TDummyCube;
    FreeForm2: TFreeForm;
    DCBasePlantC: TDummyCube;
    FreeForm3: TFreeForm;
    DCBasePlantE: TDummyCube;
    Pipe4: TPipe;
    DCShrineA: TDummyCube;
    Pipe5: TPipe;
    Pipe6: TPipe;
    Pipe7: TPipe;
    Sphere2: TSphere;

    DCShrineB: TDummyCube;
    Pipe8: TPipe;
    Pipe9: TPipe;
    Pipe10: TPipe;
    Sphere3: TSphere;

    DCShrineC: TDummyCube;
    Pipe11: TPipe;
    Pipe12: TPipe;
    Pipe13: TPipe;
    Sphere4: TSphere;
     
    GLFireFXManager1: TGLFireFXManager;
    DCBaseEnemyA: TDummyCube;
    Actor2: TActor;
    AsyncTimer2: TAsyncTimer;
    SpeedButton1: TSpeedButton;
    DCEnemies: TDummyCube;
    GLMLHeroesTx: TGLMaterialLibrary;
    CollisionManager1: TCollisionManager;
    AsyncTimer3: TAsyncTimer;
    Timer2: TTimer;
    HUDTextUserTyped: THUDText;
    GLLightSource2: TGLLightSource;
    GLFireFXMHShrineManager: TGLFireFXManager;
    GLPolygonPFXManager1: TGLPolygonPFXManager;
    GLParticleFXRenderer1: TGLParticleFXRenderer;
    DCMHFX: TDummyCube;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    GLFireFXManager2: TGLFireFXManager;
    GLFireFXManager3: TGLFireFXManager;
    DCSpiderWeb: TDummyCube;
    webLines: TLines;
    Button2: TButton;
    ScrollBar1: TScrollBar;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    DCCellsLife: TDummyCube;
    spxBaseCellLife: TSphere;
    spxBaseCellCoreLife: TSphere;

    DCCellsEnergy: TDummyCube;
    spxBaseCellEnergy: TSphere;
    spxBaseCellCoreEnergy: TSphere;

    Label3: TLabel;
    DCHUDTop: TDummyCube;
    DCPowerSphere: TDummyCube;
    spxPowerSphereCore: TSphere;
    DCLevelPortal: TDummyCube;
    PortalPipeA: TPipe;
    PortalPipeB: TPipe;
    PortalPipeC: TPipe;
    PortalPipeD: TPipe;
    PortalPipeBody: TPipe;
    PortalSpx: TSphere;
    GLFireFXPortalManager: TGLFireFXManager;
    PortalAura: TPlane;
    spxPowerSphereShell: TSphere;
    spxPowerSphereAura: TPlane;
    DCArmorA: TDummyCube;
    spxArmorABase: TSphere;
    spxArmorAtop: TSphere;
    spxArmorAleft: TSphere;
    spxArmorAbottom: TSphere;
    spxArmorAright: TSphere;
    DCWeaponA: TDummyCube;
    pipeWeaponA_base: TPipe;
    pWA_A: TPipe;
    pWA_B: TPipe;
    pWA_C: TPipe;
    Pipe14: TPipe;
    Pipe15: TPipe;
    Pipe16: TPipe;
    Pipe17: TPipe;
    Pipe18: TPipe;
    Pipe19: TPipe;
    Pipe20: TPipe;
    Pipe21: TPipe;
    Pipe22: TPipe;
    Pipe23: TPipe;
    PipeESpiral: TPipe;
    DCBasePlantF: TDummyCube;
    PipeFBase: TPipe;
    Pipe25: TPipe;
    Pipe24: TPipe;
    Pipe26: TPipe;
    Pipe27: TPipe;
    MultiPolygon1: TMultiPolygon;
    MultiPolygon2: TMultiPolygon;
    MultiPolygon3: TMultiPolygon;
    MultiPolygon4: TMultiPolygon;
    DCBasePlantG: TDummyCube;
    PipeGBase: TPipe;
    DCBasePlantH: TDummyCube;
    PipeHBase: TPipe;
    DCBasePlantI: TDummyCube;
    PipeIBase: TPipe;
    DCBasePlantJ: TDummyCube;
    PipeJBase: TPipe;
    DCBasePlantK: TDummyCube;
    PipeKBase: TPipe;
    Pipe30: TPipe;
    Pipe31: TPipe;
    MultiPolygon5: TMultiPolygon;
    MultiPolygon6: TMultiPolygon;
    Pipe28: TPipe;
    Pipe29: TPipe;
    Pipe32: TPipe;
    Pipe33: TPipe;
    HUDTextInfo: THUDText;
    Pipe34: TPipe;
    Pipe35: TPipe;
    Sphere5: TSphere;
    Pipe36: TPipe;
    Pipe37: TPipe;
    Pipe38: TPipe;
    Pipe39: TPipe;
    Pipe40: TPipe;
    Pipe41: TPipe;
    Pipe42: TPipe;
    Pipe43: TPipe;
    Pipe44: TPipe;
    Pipe45: TPipe;
    Pipe46: TPipe;
    Pipe47: TPipe;
    Pipe48: TPipe;
    Pipe49: TPipe;
    Pipe50: TPipe;
    Pipe51: TPipe;
    Pipe52: TPipe;
    Pipe53: TPipe;
    Pipe54: TPipe;
    Pipe55: TPipe;
    
    
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

    function CalcMainHeroNormal(x1,y1,z1,x2,y2,z2,x3,y3,z3:single):TVector;
    
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function CalcMainHeroRollAngle(tarX,tarY:integer): Integer;

      function CalcEARollAngle(tarX,tarY,EA_i:integer): Integer;
      function CalcEBRollAngle(tarX,tarY,EA_i:integer): Integer;
      function CalcECRollAngle(tarX,tarY,EA_i:integer): Integer;
      function CalcEDRollAngle(tarX,tarY,EA_i:integer): Integer;
      function CalcEERollAngle(tarX,tarY,EA_i:integer): Integer;
      function CalcEFRollAngle(tarX,tarY,EA_i:integer): Integer;
      function CalcEGRollAngle(tarX,tarY,EA_i:integer): Integer;

    procedure AsyncTimer2Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);

    procedure CollisionManager1Collision(Sender: TObject; object1,
      object2: TGLBaseSceneObject);
    procedure AsyncTimer3Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    ///////////////
    startWaterTxIndex:byte;
    MHwalktgX:Integer;
    MHwalktgY:Integer;
    lockCM_1:boolean;
    MHCollision:boolean;
    EAvisioCount:byte;
    pickedObject:TGLBaseSceneObject;
    pickedObj:String;
    ///////////////
    procedure PathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyAPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyBPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyCPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyDPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyEPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyFPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyGPathTravelStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);

    procedure EnemyBFireBallStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyEAcidBallStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);
    procedure EnemyFLaserBallStop(Sender: TObject; Path: TGLMovementPath; var Looped: Boolean);

    procedure EnemyAStop(i:integer);

    procedure PathTravelStart;
    procedure AddPlantsA;
    procedure AddPlantsB;
    procedure AddPlantsC;
    procedure AddPlantsD;
    procedure AddPlantsE;
    procedure AddShrinesA;
    procedure AddShrinesB;
    procedure AddShrinesC;

    procedure LoadSubWaterTx;
    procedure ChangeWatTex;
    procedure AddTerrainItems(mode:byte);

    procedure viewChild(curX,curY:Integer);
    procedure removeChild(curX,curY:Integer);

    procedure viewStartChild(curX,curY:Integer);

    procedure setMHtargetPoint(tgX,tgY:Integer);

    function calcDistanceS(x1,y1,x2,y2:Single):Single;

    procedure swapEATrace;
    procedure swapEBTrace;
    procedure swapECTrace;
    procedure swapEDTrace;
    procedure swapEETrace;
    procedure swapEFTrace;
    procedure swapEGTrace;

    procedure proceedEAFireDistance;
    procedure proceedEBFireDistance;
    procedure proceedECFireDistance;
    procedure proceedEDFireDistance;
    procedure proceedEEFireDistance;
    procedure proceedEFFireDistance;
    procedure proceedEGFireDistance;

    procedure ProcessEAComplexPathfinding(spX,spZ:Integer);
    procedure ProcessEAComplexPathfindingAuto(spX,spZ:Integer);

    // alien
    procedure ProcessEBComplexPathfinding(spX,spZ:Integer);
    // bug
    procedure ProcessECComplexPathfinding(spX,spZ:Integer);
    // insect
    procedure ProcessEDComplexPathfinding(spX,spZ:Integer);
    // frog
    procedure ProcessEEComplexPathfinding(spX,spZ:Integer);
    // drio
    procedure ProcessEFComplexPathfinding(spX,spZ:Integer);
    // okta
    procedure ProcessEGComplexPathfinding(spX,spZ:Integer);

    procedure ProcessMHPathfinding(X,Y:Integer);

    function isEnemyANearby(posX,posY:integer):boolean;
    procedure EAfindPathOnCollision(obj:TGLBaseSceneObject);

    procedure killEA(id:byte);
    procedure killEB(id:byte);
    procedure killEC(id:byte);
    procedure killED(id:byte);
    procedure killEE(id:byte);
    procedure killEF(id:byte);
    procedure killEG(id:byte);

    procedure getUnderMouseObject(Sender: TObject);
    procedure MHAttackUnderMouseObject(X,Y:Integer);

    procedure proceedShrineALightEffect(curX,curY:Integer);
    procedure proceedShrineBLightEffect(curX,curY:Integer);
    procedure proceedShrineCLightEffect(curX,curY:Integer);

    procedure MHLightningStrikePrepare(tarX,tarY,Y :Integer);
    procedure MHChainLightningStrikePrepare(idx:byte);

    procedure EAExplodePrepare(ea_index:Integer;mode:String);
    procedure EBExplodePrepare(eb_index:Integer;mode:String);
    procedure ECExplodePrepare(ec_index:Integer;mode:String);
    procedure EDExplodePrepare(ed_index:Integer;mode:String);
    procedure EEExplodePrepare(ee_index:Integer;mode:String);
    procedure EFExplodePrepare(ef_index:Integer;mode:String);
    procedure EGExplodePrepare(eg_index:Integer;mode:String);

    procedure MHImplosion(tarX,tarY,Y :Integer);

    procedure MHExplodePrepare;
    procedure MHLaserExplodePrepare;

    function calcMHtoEnemyDamage(weapon:String):Smallint;
    procedure calcMHEnvironmentDamage();

    procedure EAfightMH(ea_index:byte);
    procedure EBfightMH(eb_index:byte);
    procedure ECfightMH(ec_index:byte);
    procedure EDfightMH(ed_index:byte);
    procedure EEfightMH(ee_index:byte);
    procedure EFfightMH(ef_index:byte);
    procedure EGfightMH(eg_index:byte);

    procedure EALightningStrike(ea_index: Integer);
    procedure EBFireBallStrike(eb_index: Integer);
    procedure EBFireBallRecall(eb_index,idx: Integer);
    procedure EBFireBallThrow(eb_index,idx: Integer);
    procedure EBFireBallPrepare(eb_index,idx: Integer);

    procedure EEAcidBallStrike(ee_index: Integer);
    procedure EEAcidBallThrow(ee_index: Integer);
    procedure EEAcidBallRecall(ee_index: Integer);
    procedure EEAcidBallPrepare(ee_index: Integer);

    procedure EFLaserBallStrike(ef_index: Integer);
    procedure EFLaserBallRecall(ef_index: Integer);
    procedure EFLaserBallPrepare(ef_index: Integer);

    procedure EGOktaBallStrike(eg_index: Integer);

    function calcEnemyToMHDamage(weapon:String):Smallint;

    procedure killMH;

    procedure processEALightningFX;

    procedure deathEA(ix:Integer);
    procedure deathEB(ix:Integer);
    procedure deathEC(ix:Integer);
    procedure deathED(ix:Integer);
    procedure deathEE(ix:Integer);
    procedure deathEF(ix:Integer);
    procedure deathEG(ix:Integer);

    procedure proceedDeathEA;
    procedure proceedDeathEB;
    procedure proceedDeathEC;
    procedure proceedDeathED;
    procedure proceedDeathEE;
    procedure proceedDeathEF;
    procedure proceedDeathEG;

    procedure removeEA(ix:byte);
    procedure removeEB(ix:byte);
    procedure removeEC(ix:byte);
    procedure removeED(ix:byte);
    procedure removeEE(ix:byte);
    procedure removeEF(ix:byte);
    procedure removeEG(ix:byte);

    procedure writeWat;
    procedure loadWat;

    procedure generateMHDarkArray;

  public
    { Déclarations publiques }
    mx, my : Integer;
    mx2, my2 : Integer;
    diffX, diffY, portal_X,portal_Y, power_spx_X, power_spx_Y: integer;
    fullScreen,intersect : Boolean;
    FCamHeight : Single;
    terrObs:packed array[-4161..968,624..5446] of terrCell;

    MH_dark_random:array[0..15] of byte;

    MHWebCount:byte;
    MH_web_drop_interval:byte;

    // full 20
    shrinesA:array[1..8] of shrineCoord;
    // life 21
    shrinesB:array[1..4] of shrineCoord;
    // mana 22
    shrinesC:array[1..4] of shrineCoord;

    enemiesTypeA:array[1..enemA]of TActor;
    enemiesTypeA_core:array[1..enemA]of TSphere;

    enemiesTypeB:array[1..enemB]of TActor;
    // fireBall conveir
    enemiesTypeB_fireconv:array[1..enemB]of EB_FireConv;

    enemiesTypeC:array[1..enemC]of TActor;
    enemiesTypeD:array[1..enemD]of TActor;

    enemiesTypeE:array[1..enemE]of TActor;
    enemiesTypeE_core:array[1..enemE]of TSphere;

    enemiesTypeF:array[1..enemF]of TActor;
    enemiesTypeF_core:array[1..enemF]of TSphere;

    enemiesTypeG:array[1..enemG]of TActor;
    enemiesTypeG_core:array[1..enemG]of TSphere;

    MHWebs:array[1..8]of TLines;

    //eActorA:TFileStream;
    //eActorATx:TFileStream;
    //buffATx:TMemoryStream;
    //buffAT:TMemoryStream;
    //imgATx:TGLTextureImage;
    MHRelease:boolean;
    EARelease:boolean;

    ccc:boolean;
    allow_MH_full_fill,allow_MH_life_fill,allow_MH_mana_fill:boolean;
    spx_isUnderWater:boolean;
    MHRollAngle:Integer;

    // fog environment var
    global_f_start, global_f_end: Single;
    darknessizing_scene:boolean;
    //---- global MH lightning effect
    endStrike:boolean;
    GLThor:TGLThorFXManager;
    strike: TGLBThorFX;

    // HUD Sprites
    hud_top,hud_top_text_box, hud_top_life, hud_top_mana,
    hud_top_ornament,
    hud_top_RTLife,hud_top_RTLifeCore,
    hud_top_RTMana,hud_top_RTManaCore,
    hud_top_RTPowerSpx,hud_top_RTPowerSpxCore,
    hud_inv , hud_hero,
    hud_inv_ornament_A,hud_inv_ornament_B,
    hud_inv_ornament_C,hud_inv_ornament_D,
    hud_inv_ornament_E,hud_inv_ornament_F,
    hud_hero_ornament_A,hud_hero_ornament_B,
    hud_hero_ornament_C,hud_hero_ornament_D,
    hud_hero_ornament_E,hud_hero_ornament_F,
    hud_MH_wear_base,
    hud_inv_closeBtn_Up,hud_inv_closeBtn_Down,
    hud_hero_closeBtn_Up,hud_hero_closeBtn_Down,
    hud_top_RTArmorACore,hud_top_RTArmorA,
    hud_top_RTWeaponACore,hud_top_RTWeaponA,
    hud_hero_lab_exp, hud_hero_lab_def,
    hud_hero_lab_att, hud_hero_lab_mana,
    hud_hero_lab_life,hud_hero_lab_spell,
    hud_hero_lab_lev,hud_hero_lab_level,
    hud_hero_lab_points,
    hud_objectives_base, hud_obj_ornament_A,hud_obj_ornament_B,
    hud_obj_ornament_C, hud_obj_ornament_D,hud_obj_ornament_E,
    hud_obj_ornament_F, hud_obj_ornament_G, hud_obj_ornament_H,
    hud_obj_text_area, hud_obj_closeBtn_Up,
    hud_obj_closeBtn_Down,hud_hero_levelUp_base,
    hud_hero_levelUp_base_pic_up,hud_hero_levelUp_base_pic_down:THUDSprite;

    hud_inv_carrier:array[1..12] of MH_inv_cell;
    hud_inv_wearable:array[1..7] of MH_inv_cell;
    hud_menu_spells:array[1..5] of MH_menu_spells;
    hud_menu_windows:array[1..5] of MH_menu_windows;
    hud_inv_webs:array[1..8] of MH_menu_webs;
    hud_inv_spells:array[1..5,1..4] of MH_inv_spells;
    hud_menu_exit:array[1..2] of MH_menu_windows;

    hud_top_life_view_base,hud_top_mana_view_base:MH_view_cell;
    // HUD Text
    hud_hero_text_exp,hud_hero_text_def,
    hud_hero_text_att,hud_hero_text_mana,hud_hero_text_life,
    hud_hero_text_spell,hud_hero_text_lev,hud_hero_text_level,
    hud_hero_text_points,
    hud_obj_text_caption, hud_hero_levelUp_base_text:THUDText;
    // movable items
    movable_item_drop_needed:boolean;
    spells_menu_isDown:boolean;
    windows_menu_isDown:boolean;
    exit_menu_isDown:boolean;
    pick_move_itemX, pick_move_itemY:Integer;
    pick_move_item_ID,picked_spell_id, picked_window_id,picked_exit_id,
    hud_inv_base_state, hud_hero_base_state:byte;

    // MH
    MHstrikePeriod:Integer;
    MH_LifeMana_step:Real;
    MH_level_up_points:byte;

    // spells
    BaseLightningCost:Smallint;
    BaseChainLightningCost:Smallint;
    BaseNovaCost:Smallint;
    BaseBuildWebCost:Smallint;
    BaseDestroyWebCost:Smallint;

    ShrineALightPeriod : boolean;
    ShrineBLightPeriod : boolean;
    ShrineCLightPeriod : boolean;
    game_paused:boolean;
    MHchain:boolean;
    MHchainCount:byte;
    MH_in_nova_strike:boolean;

    user_typed_msg:String;

    function calcDistance(x1,y1,x2,y2:Integer):Integer;

    procedure darknesizeScene(f_Start, f_End: Single);
    procedure InitAndLoad(mode:byte);
    function getTRheight(posX,posY:Integer):Integer;

    procedure MHLightningStrike(tarX,tarY,Y, TargetTag :Integer);
    procedure MHChainLightningStrike(tarX,tarY,Y, TargetTag :Integer);
    procedure MHNovaStrike;

    procedure fightEA(id:byte);
    procedure fightEB(id:byte);
    procedure fightEC(id:byte);
    procedure fightED(id:byte);
    procedure fightEE(id:byte);
    procedure fightEF(id:byte);
    procedure fightEG(id:byte);

    procedure EAChainExplodePrepare(ea_index:Integer;mode:String);
    procedure EBChainExplodePrepare(eb_index:Integer;mode:String);
    procedure ECChainExplodePrepare(ec_index:Integer;mode:String);
    procedure EDChainExplodePrepare(ed_index:Integer;mode:String);
    procedure EEChainExplodePrepare(ee_index:Integer;mode:String);
    procedure EFChainExplodePrepare(ef_index:Integer;mode:String);
    procedure EGChainExplodePrepare(eg_index:Integer;mode:String);

    procedure destroyChild;
    //-------------------------------
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses Keyboard, OpenGL12,GLCrossPlatform, VectorLists, Math;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //InitAndLoad(0);
end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
var
   speed ,Y1,Y2,Yn1,Yn2, Ynn, f_start, f_end: Single;
   v : TAffineVector;
   ix, iy, iz , EBroll, step : Integer;
   path : TVector;
   i,j, MHx, MHy:Integer;
   Movement:TGLMovement;
   //pickObject:TGLBaseSceneObject;
   //ss:String;
begin

   viewChild(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));
   removeChild(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));

   // handle keypresses
   if IsKeyDown(VK_SHIFT) then
      speed:=5*deltaTime
   else speed:=deltaTime;

   //------------------------------------
   with GLCamera1.Position do begin
     {
     if IsKeyDown(VK_UP) then begin
       DCMainHero.Position.X:=(DCMainHero.Position.X+(-X*speed));
       DCMainHero.Position.Y:=0;
       DCMainHero.Position.Z:=(DCMainHero.Position.Z+(-Z*speed));
     end;
     if IsKeyDown(VK_DOWN) then begin
       DCMainHero.Position.X:=(DCMainHero.Position.X+(X*speed));
       DCMainHero.Position.Y:=0;
       DCMainHero.Position.Z:=(DCMainHero.Position.Z+(Z*speed));
     end;
     
     if IsKeyDown(VK_LEFT) then begin
       DCMainHero.Position.X:=(DCMainHero.Position.X+(-Z*speed));
       DCMainHero.Position.Y:=0;
       DCMainHero.Position.Z:=(DCMainHero.Position.Z+(X*speed));
     end;
     if IsKeyDown(VK_RIGHT) then begin
       DCMainHero.Position.X:=(DCMainHero.Position.X+(Z*speed));
       DCMainHero.Position.Y:=0;
       DCMainHero.Position.Z:=(DCMainHero.Position.Z+(-X*speed));
     end;  }
     if IsKeyDown(VK_PRIOR) then
       FCamHeight:=FCamHeight+10*speed;
     if IsKeyDown(VK_NEXT) then
       FCamHeight:=FCamHeight-10*speed;

   end; // with Camera Position

   // don't drop through terrain!
   with DCMainHero.Position do begin
      Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+FCamHeight;
      Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+FCamHeight;
      Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+FCamHeight;
   end; // with DCMH position

   if( (round(DCMainHero.Position.Y)<-15) and
           (TerrainRenderer1.InterpolatedHeight(VectorMake(Sphere1.Position.X,0,Sphere1.Position.Z))<-15) ) then begin
     Movement:= GetOrCreateMovement(DCMainHero);
     Movement.ClearPaths;
     Movement.StopPathTravel;
   end; // Water Collision

   ArrowLine2.Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(DCMainHero.Position.X,DCMainHero.Position.Y,DCMainHero.Position.Z,
         (DCMainHero.Position.X-2),Y1,DCMainHero.Position.Z,
         DCMainHero.Position.X,Y2,DCMainHero.Position.Z+2)) ;

   Actor1.Up.AsVector:=VectorNormalize(CalcMainHeroNormal(DCMainHero.Position.X,DCMainHero.Position.Y,DCMainHero.Position.Z,
         (DCMainHero.Position.X-2),Y1,DCMainHero.Position.Z,
         DCMainHero.Position.X,Y2,DCMainHero.Position.Z+2)) ;

   Actor1.Direction.AsVector:=ArrowLine2.Direction.AsVector;


   MHRollAngle:=CalcMainHeroRollAngle
        (round(Sphere1.Position.X),round(Sphere1.Position.Z));
        Actor1.Roll(MHRollAngle);

   for i:=1 to enemB do begin
     if not(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeB[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+FCamHeight + 7;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+FCamHeight + 7;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+FCamHeight + 7;
       end;

       EBroll:=CalcEBRollAngle
         (round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i );

       enemiesTypeB[i].RollAngle:=EBroll;

     end; // if deathAnimation needed

     // EB conv movement
     if not(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
       for j:= 1 to 5 do begin
         with enemiesTypeB_fireconv[i][j].Position do begin
           X := enemiesTypeB[i].Position.X;
           Z := enemiesTypeB[i].Position.Z;
           Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+ 15;
         end; // with
       end; // for j
     end; // if not fight

     // check the end frame of death animation
     if ((enemiesTypeB[i].CurrentFrame=189)and
           (enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeB[i].AnimationMode:=aamNone;
     end;

   end; // for enemies type B

   //ProcessEnemiesA;
   for i:=1 to enemA do begin
     if not(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeA[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+FCamHeight;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+FCamHeight;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+FCamHeight;
       end;

       enemiesTypeA[i].Up.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeA[i].Position.X,enemiesTypeA[i].Position.Y,enemiesTypeA[i].Position.Z,
         (enemiesTypeA[i].Position.X-2),Y1,enemiesTypeA[i].Position.Z,
         enemiesTypeA[i].Position.X,Y2,enemiesTypeA[i].Position.Z+2)) ;
       enemiesTypeA[i].Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeA[i].Position.X,enemiesTypeA[i].Position.Y,enemiesTypeA[i].Position.Z,
         (enemiesTypeA[i].Position.X-2),Y1,enemiesTypeA[i].Position.Z,
         enemiesTypeA[i].Position.X,Y2,enemiesTypeA[i].Position.Z+2)) ;

       if not(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).flee) then begin
         enemiesTypeA[i].Roll(CalcEARollAngle
           (round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i ));
       end
       else
       begin
         enemiesTypeA[i].Roll(CalcEARollAngle
           (round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i )+180);
       end; // flee roll

     end; // if deathAnimation needed

    // EA core movement
     with enemiesTypeA_core[i].Position do begin
       X := enemiesTypeA[i].Position.X;
       Z := enemiesTypeA[i].Position.Z;
       Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+FCamHeight;
     end;

     // check the end frame of death animation
     if ((enemiesTypeA[i].CurrentFrame=183)and
           (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeA[i].AnimationMode:=aamNone;
     end;
     
   end; // for enemies type A

    //ProcessEnemiesC;
   for i:=1 to enemC do begin
     if not(enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeC[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+3;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+3;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+3;
       end;

       enemiesTypeC[i].Up.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeC[i].Position.X,enemiesTypeC[i].Position.Y,enemiesTypeC[i].Position.Z,
         (enemiesTypeC[i].Position.X-2),Y1,enemiesTypeC[i].Position.Z,
         enemiesTypeC[i].Position.X,Y2,enemiesTypeC[i].Position.Z+2)) ;
       enemiesTypeC[i].Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeC[i].Position.X,enemiesTypeC[i].Position.Y,enemiesTypeC[i].Position.Z,
         (enemiesTypeC[i].Position.X-2),Y1,enemiesTypeC[i].Position.Z,
         enemiesTypeC[i].Position.X,Y2,enemiesTypeC[i].Position.Z+2)) ;

       enemiesTypeC[i].Roll(CalcECRollAngle
         (round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i ));

     end; // if deathAnimation needed

     // check the end frame of death animation
     if ((enemiesTypeC[i].CurrentFrame=177)and
           (enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeC[i].AnimationMode:=aamNone;
     end;

   end; // for enemies type C

   //ProcessEnemiesD;
   for i:=1 to enemD do begin
     if not(enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeD[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+8;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+8;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+8;
       end;

       enemiesTypeD[i].Up.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeD[i].Position.X,enemiesTypeD[i].Position.Y,enemiesTypeD[i].Position.Z,
         (enemiesTypeD[i].Position.X-2),Y1,enemiesTypeD[i].Position.Z,
         enemiesTypeD[i].Position.X,Y2,enemiesTypeD[i].Position.Z+2)) ;
       enemiesTypeD[i].Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeD[i].Position.X,enemiesTypeD[i].Position.Y,enemiesTypeD[i].Position.Z,
         (enemiesTypeD[i].Position.X-2),Y1,enemiesTypeD[i].Position.Z,
         enemiesTypeD[i].Position.X,Y2,enemiesTypeD[i].Position.Z+2)) ;


       EBroll:=CalcEDRollAngle(round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i );
       enemiesTypeD[i].Roll(EBroll);
     end; // if deathAnimation needed

     // check the end frame of death animation
     if ((enemiesTypeD[i].CurrentFrame=197)and
           (enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeD[i].AnimationMode:=aamNone;
     end;
   end; // for enemies type D

   //ProcessEnemiesE;
   for i:=1 to enemE do begin
     if not(enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeE[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+8;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+8;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+8;
       end;

       enemiesTypeE[i].Up.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeE[i].Position.X,enemiesTypeE[i].Position.Y,enemiesTypeE[i].Position.Z,
         (enemiesTypeE[i].Position.X-2),Y1,enemiesTypeE[i].Position.Z,
         enemiesTypeE[i].Position.X,Y2,enemiesTypeE[i].Position.Z+2)) ;
       enemiesTypeE[i].Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeE[i].Position.X,enemiesTypeE[i].Position.Y,enemiesTypeE[i].Position.Z,
         (enemiesTypeE[i].Position.X-2),Y1,enemiesTypeE[i].Position.Z,
         enemiesTypeE[i].Position.X,Y2,enemiesTypeE[i].Position.Z+2)) ;

       EBroll:=CalcEERollAngle(round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i );
       enemiesTypeE[i].Roll(EBroll);
     end; // if deathAnimation needed

     // EE core movement
     if not(enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
       with enemiesTypeE_core[i].Position do begin
         X := enemiesTypeE[i].Position.X;
         Z := enemiesTypeE[i].Position.Z;
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+6;
       end; // with
     end; // if not

     // check the end frame of death animation
     if ((enemiesTypeE[i].CurrentFrame=184)and
           (enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeE[i].AnimationMode:=aamNone;
     end;
   end; // for enemies type E

   //ProcessEnemiesF;
   for i:=1 to enemF do begin
     if not(enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeF[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+5;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+5;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+5;
       end;

       enemiesTypeF[i].Up.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeF[i].Position.X,enemiesTypeF[i].Position.Y,enemiesTypeF[i].Position.Z,
         (enemiesTypeF[i].Position.X-2),Y1,enemiesTypeF[i].Position.Z,
         enemiesTypeF[i].Position.X,Y2,enemiesTypeF[i].Position.Z+2)) ;
       enemiesTypeF[i].Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeF[i].Position.X,enemiesTypeF[i].Position.Y,enemiesTypeF[i].Position.Z,
         (enemiesTypeF[i].Position.X-2),Y1,enemiesTypeF[i].Position.Z,
         enemiesTypeF[i].Position.X,Y2,enemiesTypeF[i].Position.Z+2)) ;

       enemiesTypeF[i].Roll(CalcEFRollAngle(round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i ));
     end; // if deathAnimation needed

     // EF core movement
     if not(enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
       with enemiesTypeF_core[i].Position do begin
         X := enemiesTypeF[i].Position.X;
         Z := enemiesTypeF[i].Position.Z;
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+6;
       end; // with
     end; // if not

     // check the end frame of death animation
     if ((enemiesTypeF[i].CurrentFrame=196)and
           (enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeF[i].AnimationMode:=aamNone;
     end;
   end; // for enemies type F

   //ProcessEnemiesG;
   for i:=1 to enemG do begin
     if not(enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then begin
       with enemiesTypeG[i].Position do begin
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+8;
         Y1:=TerrainRenderer1.InterpolatedHeight(VectorMake(X-2,0,Z))+8;
         Y2:=TerrainRenderer1.InterpolatedHeight(VectorMake(X,0,Z+2))+8;
       end;

       enemiesTypeG[i].Up.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeG[i].Position.X,enemiesTypeG[i].Position.Y,enemiesTypeG[i].Position.Z,
         (enemiesTypeG[i].Position.X-2),Y1,enemiesTypeG[i].Position.Z,
         enemiesTypeG[i].Position.X,Y2,enemiesTypeG[i].Position.Z+2)) ;
       enemiesTypeG[i].Direction.AsVector:=VectorNormalize(CalcMainHeroNormal(enemiesTypeG[i].Position.X,enemiesTypeG[i].Position.Y,enemiesTypeG[i].Position.Z,
         (enemiesTypeG[i].Position.X-2),Y1,enemiesTypeG[i].Position.Z,
         enemiesTypeG[i].Position.X,Y2,enemiesTypeG[i].Position.Z+2)) ;

       enemiesTypeG[i].Roll(CalcEGRollAngle(round(DCMainHero.Position.X),round(DCMainHero.Position.Z),i ));
     end; // if deathAnimation needed

     // EG core movement
     if not(enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
       with enemiesTypeG_core[i].Position do begin
         X := enemiesTypeG[i].Position.X;
         Z := enemiesTypeG[i].Position.Z;
         Y:=TerrainRenderer1.InterpolatedHeight(AsVector)+6;
       end; // with
     end; // if not

     // check the end frame of death animation
     if ((enemiesTypeG[i].CurrentFrame=181)and
           (enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) then begin
       enemiesTypeG[i].AnimationMode:=aamNone;
     end;
   end; // for enemies type G

   // --- process MH Lightning strike effect
   if endStrike then begin
     if (MHstrikePeriod < 15) then begin
       // ---- solar effect
       if(odd(MHstrikePeriod)) then begin
         f_start:=global_f_start;
         f_end:=global_f_end;
         if not(darknessizing_scene) then begin
           darknessizing_scene:=true;
           darknesizeScene((f_start+MH_dark_random[MHstrikePeriod]),(f_end+MH_dark_random[MHstrikePeriod]));
         end;
       end;
       // ----
       inc(MHstrikePeriod);
     end
     else
     begin
       MHstrikePeriod:=0;
       darknesizeScene(global_f_start,global_f_end);
       darknessizing_scene:=false;
       endStrike:=false;
       strike.Free;
       GLThor.Free;
       play_HerosAudioTrack(13,fMainMenu.global_game_volume_level,false,false);
     end;
   end;
   //-----------------------------------------
   processMHNovaAnimation;
   // process MH Chain
   processMHChainLightningAnimation;
   // process EA strike FX
   processEALightningFX;
   // --------------------
   proceedShrineALightEffect(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));
   proceedShrineBLightEffect(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));
   proceedShrineCLightEffect(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));
   // change HUD bars
   changeMHLifeBar;
   changeMHManaBar;
   /////////////////////////
   GLSceneViewer1.Invalidate;
   if proceedMHPortalEntrance(round(DCMainHero.Position.X),round(DCMainHero.Position.Z),portal_X,portal_Y) then
     Exit;
   if IsKeyDown(VK_ESCAPE) then begin
     MainMenu.fMainMenu.current_level:=0;
     MainMenu.fMainMenu.MH_exp:=1;
     GLCadencer1.Enabled:=false;
     MainMenu.fMainMenu.showMainMenuActionButtons;
     MainMenu.fMainMenu.main_menu_current_state:= 'main_menu';
     Hide;
     MainMenu.fMainMenu.Refresh;
     MainMenu.fMainMenu.writeInErrorLog(2,'');
     stopAllGameSounds;
     destroyChild;
  end;
end;

// Standard mouse rotation & FPS code below

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  v : TAffineVector;
  ix, iy, iz : Integer;
  sphX, sphY: Integer;
  sphereCollision:boolean;
  i,j:Integer;
begin
  printTextBarInfo('EMPTY',0);     
  //HUDText2.Text:='XY: '+IntToStr(round(DCMainHero.Position.X))+':'+IntToStr(round(DCMainHero.Position.Z));
  // proceed spells menu click
  if Button = mbLeft then begin
    if processTopMenuSpells_MouseDown(X,Y) then begin
      Exit;
    end; // if result
    // proceed windows menu click
    if processTopMenuWindows_MouseDown(X,Y) then begin
      Exit;
    end; // if result
    // proceed save exit menu click
    if processTopMenuSaveAndExit_MouseDown(X,Y) then begin
      Exit;
    end;
  end; // if mbLeft

  // proceed windows menu click
  //if Button = mbLeft then begin

  //end; // if mbLeft

  if Button = mbRight then begin
    processTopMenuView_MouseDown(X,Y);
  end;

  if (Y >= 60) then begin
   mx:=x;
   my:=y;

   if Button = mbRight then begin

     // fill life / mana cells
     if not(movable_item_drop_needed) then begin
       if (hud_inv.Visible)and(hud_inv_base_state=1) then begin
         if((X > 490)and(X < 788)and(Y > 495)and(Y < 595)) then begin
           processMovableFromCarrierFill(X,Y);
           Exit;
         end; // in area
       end; // if visible
     end; // if not

     v:=GLSceneViewer1.Buffer.PixelRayToWorld(x, y);
     // convert to heightfield local coordinates
     v:=DCMainHero.LocalToAbsolute(v);
     // convert that local coords to grid pos
     ix:=Round(v[0]);
     iy:=Round(v[1]);
     iz:=Round(v[2]);

     Sphere1.Position.X:=((ix))-DCMainHero.Position.X;
     Sphere1.Position.Y:=(TerrainRenderer1.InterpolatedHeight(Sphere1.Position.AsVector)+1);    //iy+3;
     Sphere1.Position.Z:=iz+(-1*DCMainHero.Position.Z);
     MHAttackUnderMouseObject(round(Sphere1.Position.X),round(Sphere1.Position.Z));
     processTextBarInfoPortal(round(Sphere1.Position.X),round(Sphere1.Position.Z));
   end
   else
   begin
     processTextBarInfoPortal(round(Sphere1.Position.X),round(Sphere1.Position.Z));
     if processMovableItemToInventory(movable_item_drop_needed,
            X,Y, pick_move_item_ID, pick_move_itemX, pick_move_itemY) then begin
       Exit;
     end; // if

     if processWebsTeleportClick(X,Y) then begin
       Exit;
     end; // if web teleport btn

     if processSpellUpgradeClick(X,Y) then begin
       Exit;
     end; // if spell upgrade btn

     // objective close
     if (hud_objectives_base.Visible) then begin
       if ( (X > 376)and(X < 422)and(Y > 391)and(Y < 437) ) then begin
         hud_obj_closeBtn_Down.Visible:=true;
         hud_obj_closeBtn_Up.Visible:=false;
         Exit;
       end; // if over close btn
     end;  // if obj visible

     // level up close
     if (hud_hero_levelUp_base.Visible) then begin
       if ( (X > 146)and(X < 173)and(Y > 186)and(Y < 212) ) then begin
         hud_hero_levelUp_base_pic_down.Visible:=true;
         hud_hero_levelUp_base_pic_up.Visible:=false;
         Exit;
       end; // if over close btn
     end;  // if level up visible

     // inv close
     if ( (X > 418)and(X < 460)and(Y > 387)and(Y < 429) ) then begin
       if (hud_inv.Visible) then begin
         hud_inv_closeBtn_Down.Visible:=true;
         hud_inv_closeBtn_Up.Visible:=false;
         Exit;
       end;
     end; // if over close btn

     // hero close
     if ( (X > 339)and(X < 381)and(Y > 387)and(Y < 429) ) then begin
       if (hud_hero.Visible) then begin
         hud_hero_closeBtn_Down.Visible:=true;
         hud_hero_closeBtn_Up.Visible:=false;
         Exit;
       end;
     end; // if over close btn

     // get absolute 3D coordinates of the point below the mouse
     v:=GLSceneViewer1.Buffer.PixelRayToWorld(x, y);
     // convert to heightfield local coordinates
     v:=DCMainHero.LocalToAbsolute(v);
     // convert that local coords to grid pos
     ix:=Round(v[0]);
     iy:=Round(v[1]);
     iz:=Round(v[2]);

     Sphere1.Position.X:=((ix))-DCMainHero.Position.X;
     Sphere1.Position.Y:=(TerrainRenderer1.InterpolatedHeight(Sphere1.Position.AsVector)+1);    //iy+3;
     Sphere1.Position.Z:=iz+(-1*DCMainHero.Position.Z);

     lockCM_1:=true;
     MHwalktgX:=round(Sphere1.Position.X);
     MHwalktgY:=round(Sphere1.Position.Z);

     //CollisionManager2.CheckCollisions;
     sphereCollision:=false;
     MHCollision:=false;
     for j:= (MHwalktgY-10) to (MHwalktgY+10) do begin
       for i:= (MHwalktgX-10) to (MHwalktgX+10) do begin
         if(terrObs[i,j].itemId<>0) then begin
           sphereCollision:=true;
           sphX:=i;
           sphY:=j;
           break;
         end; // if
       end; // for i
     end; // for j

     if (sphereCollision) then begin
       setMHtargetPoint(sphX, sphY); // set MHCollision to true
     end; // if collision

     lockCM_1:=false;

     if(TerrainRenderer1.InterpolatedHeight(Sphere1.Position.AsVector)<-22) then
       spx_isUnderWater:=true
     else
       spx_isUnderWater:=false;

     if not(checkIsUnderMouseMovableItem(round(Sphere1.Position.X),round(Sphere1.Position.Z))) then begin
       ProcessMHPathfinding(1,1);
     end
     else
     begin
       processMovableItemPick(pick_move_item_ID, pick_move_itemX, pick_move_itemY);
     end;  // else
   end; // if is left
  end // if Y >=60
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  // movables
  if movable_item_drop_needed then begin
    processMovableItem_MouseMove(pick_move_item_ID,X,Y);
  end; // if

  if (Y >=60) then begin
    if ssLeft in Shift then begin
      GLCamera1.MoveAroundTarget(0, mx-x);
      mx:=x;
      my:=y;
      GLCadencer1.Progress;
      GLSceneViewer1.Refresh;
    end; // shift
  end; // if Y >=60
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

   HUDTextFPS.Text:='PIG: ' +
                          Format('%.1f FPS - %d',
                         [GLSceneViewer1.FramesPerSecond, TerrainRenderer1.LastTriangleCount]);

   MHShrinesFill;
   // shuffle
   if (Timer1.Tag < 30) then begin
     Timer1.Tag:=(Timer1.Tag + 1);
   end
   else
   begin
     Timer1.Tag:=0;
     shuffleMainThema(fMainMenu.global_maintheme_volume_level);
   end;

   if (HUDTextInfo.Text <> '')and(odd(Timer1.Tag)) then
     printTextBarInfo('EMPTY',0);

   GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if((Key <> #8)and(Key <> #13))and(Length(user_typed_msg) <= 26) then
    user_typed_msg:=user_typed_msg + UpperCase(Key);

  case Key of
    'i', 'I' : begin
      if not HUDTextUserTyped.Visible then
        invokeInventoryWindow(true);
    end;

    'w', 'W' : begin
      if not HUDTextUserTyped.Visible then
        invokeWebsWindow(true);
    end;

    'h', 'H' : begin
      if not HUDTextUserTyped.Visible then
        invokeHeroWindow(true);
    end;

    's', 'S' : begin
      if not HUDTextUserTyped.Visible then
        invokeSpellsWindow(true);
    end;
  end; // case
end;

function TForm1.CalcMainHeroNormal(x1, y1, z1, x2, y2, z2, x3, y3,
  z3: single): TVector;
  var
    A,B,C:single;
begin
  A:=( ((y2-y1)*(z3-z1)) - ((y3-y1)*(z2-z1)) );
  B:=( ((z2-z1)*(x3-x1)) - ((z3-z1)*(x2-x1)) );
  C:=( ((x2-x1)*(y3-y1)) - ((x3-x1)*(y2-y1)) );

  Result:=VectorMake(A,B,C);
end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
  // update hero props
  if (hud_inv.Visible)and(hud_inv_base_state=2) then begin
     update_hud_inv_webs;
   end; // if

   if (hud_hero.Visible)and(hud_hero_base_state=1) then begin
     update_hud_hero_values;
   end; // if

   if (hud_hero.Visible)and(hud_hero_base_state=2) then begin
     update_hud_hero_spells;
   end; // if

  if HUDTextUserTyped.Visible then
    HUDTextUserTyped.Text:=':' + user_typed_msg;

  // proceed water surface
  ChangeWatTex;
  // process portal entrance
  //proceedMHPortalEntrance(round(DCMainHero.Position.X),round(DCMainHero.Position.Z),portal_X,portal_Y);
end;

procedure TForm1.AddPlantsA;
var
   i,ranX,ranY, ranRotation : Integer;
begin
  // clear obs array
  for i:=1 to 16000 do begin
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY)) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,3,ranRotation);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //RestoreDefaultMode;
end;

procedure TForm1.ChangeWatTex;
begin
  if(startWaterTxIndex=25) then begin
    startWaterTxIndex:=0;
  end;
  startWaterTxIndex:=(startWaterTxIndex + 1);
  subWaterPlane.Material.LibMaterialName:='subwaterX'+IntToStr(startWaterTxIndex);
end;

procedure TForm1.LoadSubWaterTx;
begin
  GLMLSubWaterTx.Materials[0].Material.Texture.Image.LoadFromFile('wat_1.bmp');
  GLMLSubWaterTx.Materials[1].Material.Texture.Image.LoadFromFile('wat_2.bmp');
  GLMLSubWaterTx.Materials[2].Material.Texture.Image.LoadFromFile('wat_3.bmp');
  GLMLSubWaterTx.Materials[3].Material.Texture.Image.LoadFromFile('wat_4.bmp');
  GLMLSubWaterTx.Materials[4].Material.Texture.Image.LoadFromFile('wat_5.bmp');
  GLMLSubWaterTx.Materials[5].Material.Texture.Image.LoadFromFile('wat_6.bmp');
  GLMLSubWaterTx.Materials[6].Material.Texture.Image.LoadFromFile('wat_7.bmp');
  GLMLSubWaterTx.Materials[7].Material.Texture.Image.LoadFromFile('wat_8.bmp');
  GLMLSubWaterTx.Materials[8].Material.Texture.Image.LoadFromFile('wat_9.bmp');
  GLMLSubWaterTx.Materials[9].Material.Texture.Image.LoadFromFile('wat_10.bmp');
  GLMLSubWaterTx.Materials[10].Material.Texture.Image.LoadFromFile('wat_11.bmp');
  GLMLSubWaterTx.Materials[11].Material.Texture.Image.LoadFromFile('wat_12.bmp');
  GLMLSubWaterTx.Materials[12].Material.Texture.Image.LoadFromFile('wat_13.bmp');
  GLMLSubWaterTx.Materials[13].Material.Texture.Image.LoadFromFile('wat_14.bmp');
  GLMLSubWaterTx.Materials[14].Material.Texture.Image.LoadFromFile('wat_15.bmp');
  GLMLSubWaterTx.Materials[15].Material.Texture.Image.LoadFromFile('wat_16.bmp');
  GLMLSubWaterTx.Materials[16].Material.Texture.Image.LoadFromFile('wat_17.bmp');
  GLMLSubWaterTx.Materials[17].Material.Texture.Image.LoadFromFile('wat_18.bmp');
  GLMLSubWaterTx.Materials[18].Material.Texture.Image.LoadFromFile('wat_19.bmp');
  GLMLSubWaterTx.Materials[19].Material.Texture.Image.LoadFromFile('wat_20.bmp');
  GLMLSubWaterTx.Materials[20].Material.Texture.Image.LoadFromFile('wat_21.bmp');
  GLMLSubWaterTx.Materials[21].Material.Texture.Image.LoadFromFile('wat_22.bmp');
  GLMLSubWaterTx.Materials[22].Material.Texture.Image.LoadFromFile('wat_23.bmp');
  GLMLSubWaterTx.Materials[23].Material.Texture.Image.LoadFromFile('wat_24.bmp');
  GLMLSubWaterTx.Materials[24].Material.Texture.Image.LoadFromFile('wat_25.bmp');
end;

procedure TForm1.PathTravelStop(Sender: TObject; Path: TGLMovementPath;
  var Looped: Boolean);
begin
  Actor1.SwitchToAnimation('stand',true);
  play_HerosAudioTrack(11,fMainMenu.global_game_volume_level,false,false);
  MHRelease:=true;
end;

procedure TForm1.PathTravelStart;
begin
  // nothing yet
end;

function TForm1.CalcMainHeroRollAngle(tarX, tarY: integer): Integer;
var
  m, A , B:Integer;
  alphaTg:real;
begin
  //result(tng_Alpha)=((y2-y1) / (x2-x1));
  //-------------------------------------
  A:=(tarY-round(DCMainHero.Position.Z));
  B:=(tarX-round(DCMainHero.Position.X));
  
  if(A=0) then begin
    if(tarX >= round(DCMainHero.Position.X) ) then begin
      result:=0;
      exit;
    end
    else
    begin
      result:=-180;  
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(DCMainHero.Position.Z) ) then begin
      result:=90;
      exit;
    end
    else
    begin
      result:=-90;
      exit;
    end;
  end; // if B = 0

  //-------------------------------------
 
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg)))+90;

  if(tarX > DCMainHero.Position.X) then begin
    m:=m+180;
  end;
  result:=(m+90);
end;

procedure TForm1.AddPlantsD;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  // clear obs array
  for i:=1 to 2000 do begin //16000
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY)) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,1,ranRotation);
    // save to array
    fMainMenu.M_plants_D[i].posX:=ranX;
    fMainMenu.M_plants_D[i].posY:=ranY;
    fMainMenu.M_plants_D[i].itemId:=1;
    fMainMenu.M_plants_D[i].itemRotation:=ranRotation;
    //
  end;
end;

procedure TForm1.AddTerrainItems(mode:byte);
begin
  // clear obs array
  terrObsClear;
  generateMHDarkArray;
  // add portal to next level FIRST
  if fMainmenu.auto_level_generation then begin
    AddLevelPortal;
    SetLevelPortal_prop(portal_X,portal_Y);
     // add PowerSpx SECOND
    AddLevelPowerSphere;
    SetLevelPowerSphere_prop;

    AddShrinesA; // full
    AddShrinesB; // life
    AddShrinesC; // mana

    AddPlantsD; //1
    AddPlantsE; //2
    AddPlantsF; //3
    SetPlantsF_prop;
    AddPlantsG; //4
    SetPlantsG_prop;
    AddPlantsH; //5
    AddPlantsI; //6
    AddPlantsJ; //7
    SetPlantsJ_prop;
    AddPlantsK; //8

    AddCellsLife;
    AddCellsEnergy;
    AddArmorA;
    SetArmorA_prop;
    AddWeaponA;

    AddEnemiesA;
    SetEnemiesA_prop;
    AddEnemiesB;
    SetEnemiesB_prop;
    AddEnemiesC;
    SetEnemiesC_prop;
    AddEnemiesD;
    SetEnemiesD_prop;
    AddEnemiesE;
    SetEnemiesE_prop;
    AddEnemiesF;
    SetEnemiesF_prop;
    AddEnemiesG;
    SetEnemiesG_prop;
    fMainMenu.saveGeneratedLevel(0);
  end
  else
  begin
    // load from maps
    fMainMenu.loadGeneratedLevel(fMainMenu.current_level);
      SetLevelPortal_prop(portal_X,portal_Y);

    loadLevelFromMaps(0);
      SetLevelPowerSphere_prop;

    if (mode = 2) then begin
      //fMainMenu.loadUserGame;
      loadLevelFromSave(2);
    end; // if 2 load save
  end;

end;

procedure TForm1.AddPlantsB;
var
   i,ranX,ranY : Integer;
   proxy : TGLProxyObject;
begin
  // spawn some more using proxy objects
  for i:=1 to 20 do begin
    //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      // create a new proxy and set its MasterObject property
      proxy:=TGLProxyObject(DCBasePlantB.AddNewChild(TGLProxyObject));
      with proxy do begin
         ProxyOptions:=[pooObjects];
         MasterObject:=FreeForm2;
         // retrieve reference attitude
         Direction:=FreeForm2.Direction;
         Up:=FreeForm2.Up;
         Scale.SetVector(0.5,1,0.5);
         RollAngle:=RandomRange(1,350);
         Position.SetPoint(ranX,
         TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))+2,
         ranY);
         TransformationChanged;
      end;
   end;
end;

procedure TForm1.AddPlantsC;
begin
  //
end;

procedure TForm1.AddPlantsE;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  // clear obs array
  for i:=1 to 2000 do begin
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY)) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,2,ranRotation);
    // save to array
    fMainMenu.M_plants_E[i].posX:=ranX;
    fMainMenu.M_plants_E[i].posY:=ranY;
    fMainMenu.M_plants_E[i].itemId:=2;
    fMainMenu.M_plants_E[i].itemRotation:=ranRotation;
    //
  end;
end;

procedure TForm1.AddShrinesA;
var
   i,j, ranX,ranY : Integer;
   ranRotation:byte;
begin
   for i:=1 to 8 do begin
     // sector 1
     if(i=1) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-2551,-2451);
         ranY:=RandomRange(2144,2244);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[1].Xcoord:=ranX;
           shrinesA[1].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[1].posX:=ranX;
           fMainMenu.M_shrines_A[1].posY:=ranY;
           fMainMenu.M_shrines_A[1].itemId:=20;
           fMainMenu.M_shrines_A[1].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 1

     // sector 2
     if(i=2) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-1646,-1546);
         ranY:=RandomRange(2144,2244);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[2].Xcoord:=ranX;
           shrinesA[2].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[2].posX:=ranX;
           fMainMenu.M_shrines_A[2].posY:=ranY;
           fMainMenu.M_shrines_A[2].itemId:=20;
           fMainMenu.M_shrines_A[2].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 2

     // sector 3
     if(i=3) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-742,-642);
         ranY:=RandomRange(2144,2244);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[3].Xcoord:=ranX;
           shrinesA[3].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[3].posX:=ranX;
           fMainMenu.M_shrines_A[3].posY:=ranY;
           fMainMenu.M_shrines_A[3].itemId:=20;
           fMainMenu.M_shrines_A[3].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 3

     // sector 4
     if(i=4) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-2551,-2451);
         ranY:=RandomRange(2994,3094);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[4].Xcoord:=ranX;
           shrinesA[4].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[4].posX:=ranX;
           fMainMenu.M_shrines_A[4].posY:=ranY;
           fMainMenu.M_shrines_A[4].itemId:=20;
           fMainMenu.M_shrines_A[4].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 4

     // sector 5
     if(i=5) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-742,-642);
         ranY:=RandomRange(2994,3094);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[5].Xcoord:=ranX;
           shrinesA[5].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[5].posX:=ranX;
           fMainMenu.M_shrines_A[5].posY:=ranY;
           fMainMenu.M_shrines_A[5].itemId:=20;
           fMainMenu.M_shrines_A[5].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 5

     // sector 6
     if(i=6) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-2551,-2451);
         ranY:=RandomRange(3844,3944);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[6].Xcoord:=ranX;
           shrinesA[6].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[6].posX:=ranX;
           fMainMenu.M_shrines_A[6].posY:=ranY;
           fMainMenu.M_shrines_A[6].itemId:=20;
           fMainMenu.M_shrines_A[6].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 6

     // sector 7
     if(i=7) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-1646,-1546);
         ranY:=RandomRange(3844,3944);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[7].Xcoord:=ranX;
           shrinesA[7].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[7].posX:=ranX;
           fMainMenu.M_shrines_A[7].posY:=ranY;
           fMainMenu.M_shrines_A[7].itemId:=20;
           fMainMenu.M_shrines_A[7].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 7

     // sector 8
     if(i=8) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-742,-642);
         ranY:=RandomRange(3844,3944);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,20,ranRotation);
           shrinesA[8].Xcoord:=ranX;
           shrinesA[8].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_A[8].posX:=ranX;
           fMainMenu.M_shrines_A[8].posY:=ranY;
           fMainMenu.M_shrines_A[8].itemId:=20;
           fMainMenu.M_shrines_A[8].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 8

   end; // for all 8
end;

procedure TForm1.AsyncTimer2Timer(Sender: TObject);
begin
  // process enemies actions
  swapEATrace;
  swapEBTrace;

  swapECTrace;
  swapEDTrace;
  swapEETrace;

  swapEFTrace;
  swapEGTrace;

    
  proceedEAFireDistance;
  proceedEBFireDistance;
  
  proceedECFireDistance;
  proceedEDFireDistance;
  proceedEEFireDistance;

  proceedEFFireDistance;
  proceedEGFireDistance;
end;

procedure TForm1.EnemyAPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  //enemiesTypeA[StrToInt((Sender as TGLMovement).Name)].SwitchToAnimation('stand',true);
  // enemiesTypeA[i].SwitchToAnimation('stand',true);
  play_HerosAudioTrack(11,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('cur ' + IntToStr(fMainMenu.current_level));
end;

procedure TForm1.EnemyAStop(i: integer);
begin
  enemiesTypeA[i].SwitchToAnimation('stand',true);
end;

procedure TForm1.removeChild(curX, curY: Integer);
var
  c,i,j:Integer;
begin
  for c:= DCBasePlantD.ComponentCount downto 1 do begin
    i:=round(DCBasePlantD.Children[c].Position.X);
    j:=round(DCBasePlantD.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantD.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantE.ComponentCount downto 1 do begin
    i:=round(DCBasePlantE.Children[c].Position.X);
    j:=round(DCBasePlantE.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantE.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantF.ComponentCount downto 1 do begin
    i:=round(DCBasePlantF.Children[c].Position.X);
    j:=round(DCBasePlantF.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantF.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantG.ComponentCount downto 1 do begin
    i:=round(DCBasePlantG.Children[c].Position.X);
    j:=round(DCBasePlantG.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantG.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantH.ComponentCount downto 1 do begin
    i:=round(DCBasePlantH.Children[c].Position.X);
    j:=round(DCBasePlantH.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantH.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantI.ComponentCount downto 1 do begin
    i:=round(DCBasePlantI.Children[c].Position.X);
    j:=round(DCBasePlantI.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantI.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantJ.ComponentCount downto 1 do begin
    i:=round(DCBasePlantJ.Children[c].Position.X);
    j:=round(DCBasePlantJ.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantJ.Children[c].Free;

    end; // if not in area
  end; // for

  //////////////////////////////
  for c:= DCBasePlantK.ComponentCount downto 1 do begin
    i:=round(DCBasePlantK.Children[c].Position.X);
    j:=round(DCBasePlantK.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCBasePlantK.Children[c].Free;

    end; // if not in area
  end; // for

  /////////// ShrineA ///////////////////
  for c:= DCShrineA.ComponentCount downto 1 do begin
    i:=round(DCShrineA.Children[c].Position.X);
    j:=round(DCShrineA.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCShrineA.Children[c].Free;

    end; // if not in area
  end; // for

  /////////// ShrineB ///////////////////
  for c:= DCShrineB.ComponentCount downto 1 do begin
    i:=round(DCShrineB.Children[c].Position.X);
    j:=round(DCShrineB.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCShrineB.Children[c].Free;

    end; // if not in area
  end; // for

  /////////// ShrineC ///////////////////
  for c:= DCShrineC.ComponentCount downto 1 do begin
    i:=round(DCShrineC.Children[c].Position.X);
    j:=round(DCShrineC.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCShrineC.Children[c].Free;

    end; // if not in area
  end; // for

  // LifeCells
  for c:= DCCellsLife.ComponentCount downto 1 do begin
    i:=round(DCCellsLife.Children[c].Position.X);
    j:=round(DCCellsLife.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCCellsLife.Children[c].Free;

    end; // if not in area
  end; // for

  // EnergyCells
  for c:= DCCellsEnergy.ComponentCount downto 1 do begin
    i:=round(DCCellsEnergy.Children[c].Position.X);
    j:=round(DCCellsEnergy.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCCellsEnergy.Children[c].Free;

    end; // if not in area
  end; // for

  // ArmorA
  for c:= DCArmorA.ComponentCount downto 1 do begin
    i:=round(DCArmorA.Children[c].Position.X);
    j:=round(DCArmorA.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCArmorA.Children[c].Free;

    end; // if not in area
  end; // for

  // WeaponA
  for c:= DCWeaponA.ComponentCount downto 1 do begin
    i:=round(DCWeaponA.Children[c].Position.X);
    j:=round(DCWeaponA.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCWeaponA.Children[c].Free;
    end; // if not in area
  end; // for


  // PowerSpx
  for c:= DCPowerSphere.ComponentCount downto 1 do begin
    i:=round(DCPowerSphere.Children[c].Position.X);
    j:=round(DCPowerSphere.Children[c].Position.Z);
    if( (i>(curX+100))or(i<curX-100)or(j>(curY+100))or(j<curY-100) ) then begin
      DCPowerSphere.Children[c].Free;

    end; // if not in area
  end; // for
end;

procedure TForm1.viewChild(curX, curY: Integer);
var
  i,j,e : Integer;
   proxy : TGLProxyObject;
   scalY:byte;
begin
  for j:=(curY-100) to (curY+100) do begin
    for i:=(curX-100) to (curX+100) do begin
      //
      if(terrObs[i,j].itemId=1) then begin
        if not(checkChildD(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantD.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe1;
            Tag:=1;
            // retrieve reference attitude
            Direction:=Pipe1.Direction;
            Up:=Pipe1.Up;
            /////////////////////////////////
            Randomize;
            scalY:=RandomRange(7,9);
            Scale.SetVector(0.8,StrToFloat('0,' + IntToStr(scalY)),0.8);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);

            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j)),
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=1

      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=2) then begin
        if not(checkChildE(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantE.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe4;
            // retrieve reference attitude
            Direction:=Pipe4.Direction;
            Up:=Pipe4.Up;
            Scale.SetVector(1,1.5,1);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=2

      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=3) then begin
        if not(checkChildF(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantF.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=PipeFBase;
            // retrieve reference attitude
            Direction:=PipeFBase.Direction;
            Up:=PipeFBase.Up;
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=3

      ///////////////////// G /////////////////////////
      if(terrObs[i,j].itemId=4) then begin
        if not(checkChildG(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantG.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=PipeGBase;
            Direction:=PipeGBase.Direction;
            Up:=PipeGBase.Up;
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=4

      ///////////////////// H /////////////////////////
      if(terrObs[i,j].itemId=5) then begin
        if not(checkChildH(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantH.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=PipeHBase;
            // retrieve reference attitude
            Direction:=PipeHBase.Direction;
            Up:=PipeHBase.Up;
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=5

      ///////////////////// I /////////////////////////
      if(terrObs[i,j].itemId=6) then begin
        if not(checkChildI(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantI.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=PipeIBase;
            // retrieve reference attitude
            Direction:=PipeIBase.Direction;
            Up:=PipeIBase.Up;
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=6

      ///////////////////// J /////////////////////////
      if(terrObs[i,j].itemId=7) then begin
        if not(checkChildJ(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantJ.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=PipeJBase;
            // retrieve reference attitude
            Direction:=PipeJBase.Direction;
            Up:=PipeJBase.Up;
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=7

      ///////////////////// K /////////////////////////
      if(terrObs[i,j].itemId=8) then begin
        if not(checkChildK(i,j)) then begin
          proxy:=TGLProxyObject(DCBasePlantK.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=PipeKBase;
            // retrieve reference attitude
            Direction:=PipeKBase.Direction;
            Up:=PipeKBase.Up;
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j)),
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=8

      /////////////////// 20 ShrineA ///////////////////////////
      if(terrObs[i,j].itemId=20) then begin
        if not(checkChildShrineA(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineA.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe5;
            // retrieve reference attitude
            Direction:=Pipe5.Direction;
            Up:=Pipe5.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=20

      /////////////////// 20 ShrineB ///////////////////////////
      if(terrObs[i,j].itemId=21) then begin
        if not(checkChildShrineB(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineB.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe8;
            // retrieve reference attitude
            Direction:=Pipe8.Direction;
            Up:=Pipe8.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=21

      /////////////////// 22 ShrineC ///////////////////////////
      if(terrObs[i,j].itemId=22) then begin
        if not(checkChildShrineC(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineC.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe11;
            // retrieve reference attitude
            Direction:=Pipe11.Direction;
            Up:=Pipe11.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=22

      //////////////////////////// life cells /////////////////////////
      if(terrObs[i,j].itemId=150) then begin
        if not(checkChildCellLife(i,j)) then begin
          proxy:=TGLProxyObject(DCCellsLife.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxBaseCellLife;
            // retrieve reference attitude
            Direction:=spxBaseCellLife.Direction;
            Up:=spxBaseCellLife.Up;
            Scale.SetVector(1,4,1);
            TurnAngle:=terrObs[i,j].itemRotation;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+5,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=150

      //////////////////////////// mana cells /////////////////////////
      if(terrObs[i,j].itemId=151) then begin
        if not(checkChildCellEnergy(i,j)) then begin
          proxy:=TGLProxyObject(DCCellsEnergy.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxBaseCellEnergy;
            // retrieve reference attitude
            Direction:=spxBaseCellEnergy.Direction;
            Up:=spxBaseCellEnergy.Up;
            Scale.SetVector(1,4,1);
            TurnAngle:=terrObs[i,j].itemRotation;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+5,
            j);

            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=151

      ////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=160) then begin
        if not(checkChildArmorA(i,j)) then begin
          proxy:=TGLProxyObject(DCArmorA.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxArmorABase;
            // retrieve reference attitude
            Direction:=spxArmorABase.Direction;
            Up:=spxArmorABase.Up;
            Scale.SetVector(1,0.5,1);
            TurnAngle:=terrObs[i,j].itemRotation;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+2,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=160

      /////////////////// WeaponA ///////////////////////////
      if(terrObs[i,j].itemId=180) then begin
        if not(checkChildWeaponA(i,j)) then begin
          proxy:=TGLProxyObject(DCWeaponA.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=pipeWeaponA_base;
            // retrieve reference attitude
            Direction:=pipeWeaponA_base.Direction;
            Up:=pipeWeaponA_base.Up;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+5,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=180

      ///////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=190) then begin
        if not(checkChildPowerSpx(i,j)) then begin
          proxy:=TGLProxyObject(DCPowerSphere.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxPowerSphereCore;
            // retrieve reference attitude
            Direction:=spxPowerSphereCore.Direction;
            Up:=spxPowerSphereCore.Up;
            Scale.SetVector(1,1,1);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+2,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=190

      /////////////////////////  enemy A /////////////////////
      ////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=50) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemA do begin
            with enemiesTypeA[e] do begin
              if ( (not(enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EA');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).flee:=false;
                enemiesTypeA[e].TagFloat:=(50 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'A') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=50

      /////////////////////////  enemy B /////////////////////
      ////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=51) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemB do begin
            with enemiesTypeB[e] do begin
              if ( (not(enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EB');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeB[e].TagFloat:=(60 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'B') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=51 alien

      /////////////////////////  enemy C /////////////////////
      ///////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=52) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemC do begin
            with enemiesTypeC[e] do begin
              if ( (not(enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EC');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeC[e].TagFloat:=(70 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'C') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=52 bug

      /////////////////////////  enemy D /////////////////////
      ////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=53) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemD do begin
            with enemiesTypeD[e] do begin
              if ( (not(enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+8,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('ED');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeD[e].TagFloat:=(80 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'D') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=53 insect

      /////////////////////////  enemy E /////////////////////
      ////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=54) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemE do begin
            with enemiesTypeE[e] do begin
              if ( (not(enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EE');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeE[e].TagFloat:=(90 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'E') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=54 frog

      /////////////////////////  enemy F /////////////////////
      ////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=55) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemF do begin
            with enemiesTypeF[e] do begin
              if ( (not(enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EF');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeF[e].TagFloat:=(100 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'F') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=55 drio

      /////////////////////////  enemy G /////////////////////
      ////////////////////////////////////////////////////////
      if(terrObs[i,j].itemId=56) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemG do begin
            with enemiesTypeG[e] do begin
              if ( (not(enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EG');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeG[e].TagFloat:=(110 + e);

                Break;
              end; // if fired
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'G') then
               terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=56 okta
      //------------------------------------------------------------------------
    end; // for
  end; // for
end;

procedure TForm1.viewStartChild(curX, curY: Integer);
var
  i,j, e : Integer;
  proxy : TGLProxyObject;
  scalY:byte;
begin
  for j:=(curY-100) to (curY+100) do begin
    for i:=(curX-100) to (curX+100) do begin
      //
      if(terrObs[i,j].itemId=1) then begin
        proxy:=TGLProxyObject(DCBasePlantD.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects,pooEffects];
          MasterObject:=Pipe1;
          Tag:=1;
          // retrieve reference attitude
          Direction:=Pipe1.Direction;
          Up:=Pipe1.Up;
          Randomize;
          scalY:=RandomRange(7,9);
          Scale.SetVector(0.8,StrToFloat('0,' + IntToStr(scalY)),0.8);
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j)),
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=1

      ///////////// Plant E ////////////////////////////////////////
      if(terrObs[i,j].itemId=2) then begin
        proxy:=TGLProxyObject(DCBasePlantE.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=Pipe4;
          // retrieve reference attitude
          Direction:=Pipe4.Direction;
          Up:=Pipe4.Up;
          /////////////////////////////////
          Scale.SetVector(1,1.5,1);
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=2

      ///////////// Plant F ////////////////////////////////////////
      if(terrObs[i,j].itemId=3) then begin
        proxy:=TGLProxyObject(DCBasePlantF.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=PipeFBase;
          // retrieve reference attitude
          Direction:=PipeFBase.Direction;
          Up:=PipeFBase.Up;
          /////////////////////////////////
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=3

      ///////////// Plant G ////////////////////////////////////////
      if(terrObs[i,j].itemId=4) then begin
        proxy:=TGLProxyObject(DCBasePlantG.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=PipeGBase;
          // retrieve reference attitude
          Direction:=PipeGBase.Direction;
          Up:=PipeGBase.Up;
          /////////////////////////////////
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=4

      ///////////// Plant H ////////////////////////////////////////
      if(terrObs[i,j].itemId=5) then begin
        proxy:=TGLProxyObject(DCBasePlantH.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=PipeHBase;
          // retrieve reference attitude
          Direction:=PipeHBase.Direction;
          Up:=PipeHBase.Up;
          /////////////////////////////////
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=5

      ///////////// Plant I ////////////////////////////////////////
      if(terrObs[i,j].itemId=6) then begin
        proxy:=TGLProxyObject(DCBasePlantI.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=PipeIBase;
          // retrieve reference attitude
          Direction:=PipeIBase.Direction;
          Up:=PipeIBase.Up;
          /////////////////////////////////
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=6

      ///////////// Plant J ////////////////////////////////////////
      if(terrObs[i,j].itemId=7) then begin
        proxy:=TGLProxyObject(DCBasePlantJ.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=PipeJBase;
          // retrieve reference attitude
          Direction:=PipeJBase.Direction;
          Up:=PipeJBase.Up;
          /////////////////////////////////
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-4,
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=7

      ///////////// Plant K ////////////////////////////////////////
      if(terrObs[i,j].itemId=8) then begin
        proxy:=TGLProxyObject(DCBasePlantK.AddNewChild(TGLProxyObject));
        with proxy do begin
          ProxyOptions:=[pooObjects];
          MasterObject:=PipeKBase;
          // retrieve reference attitude
          Direction:=PipeKBase.Direction;
          Up:=PipeKBase.Up;
          /////////////////////////////////
          TurnAngle:=terrObs[i,j].itemRotation;
          Position.SetPoint(i,
          TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j)),
          j);
          TransformationChanged;
        end; // with
      end;  // if itemId=8

      /////////////////// 20 ShrineA ///////////////////////////
      if(terrObs[i,j].itemId=20) then begin
        if not(checkChildShrineA(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineA.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe5;
            // retrieve reference attitude
            Direction:=Pipe5.Direction;
            ////////////////////////////////
            Up:=Pipe5.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=20

      /////////////////// 21 ShrineB ///////////////////////////
      if(terrObs[i,j].itemId=21) then begin
        if not(checkChildShrineB(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineB.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe8;
            // retrieve reference attitude
            Direction:=Pipe8.Direction;
            ////////////////////////////////
            Up:=Pipe8.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=21

      /////////////////// 22 ShrineC ///////////////////////////
      if(terrObs[i,j].itemId=22) then begin
        if not(checkChildShrineC(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineC.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe11;
            // retrieve reference attitude
            Direction:=Pipe11.Direction;
            Up:=Pipe11.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=22

      ///////////////////// Cells life //////////////////////////////
      if(terrObs[i,j].itemId=150) then begin
        if not(checkChildCellLife(i,j)) then begin
          proxy:=TGLProxyObject(DCCellsLife.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxBaseCellLife;
            // retrieve reference attitude
            Direction:=spxBaseCellLife.Direction;
            Up:=spxBaseCellLife.Up;
            Scale.SetVector(1,4,1);
            TurnAngle:=terrObs[i,j].itemRotation;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+5,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=150

      ///////////////////// Cells energy //////////////////////////////
      if(terrObs[i,j].itemId=151) then begin
        if not(checkChildCellEnergy(i,j)) then begin
          proxy:=TGLProxyObject(DCCellsEnergy.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxBaseCellEnergy;
            // retrieve reference attitude
            Direction:=spxBaseCellEnergy.Direction;
            Up:=spxBaseCellEnergy.Up;
            Scale.SetVector(1,4,1);
            TurnAngle:=terrObs[i,j].itemRotation;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+5,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=151

      ///////////////////// Weapon A //////////////////////////////
      if(terrObs[i,j].itemId=180) then begin
        if not(checkChildWeaponA(i,j)) then begin
          proxy:=TGLProxyObject(DCWeaponA.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=pipeWeaponA_Base;
            // retrieve reference attitude
            Direction:=pipeWeaponA_Base.Direction;
            Up:=pipeWeaponA_Base.Up;
            TurnAngle:=terrObs[i,j].itemRotation;
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+5,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=180

      /////////////////// 20 ShrineA ///////////////////////////
      if(terrObs[i,j].itemId=20) then begin
        if not(checkChildShrineA(i,j)) then begin
          proxy:=TGLProxyObject(DCShrineA.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=Pipe5;
            // retrieve reference attitude
            Direction:=Pipe5.Direction;
            Up:=Pipe5.Up;
            Scale.SetVector(2,2,2);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))-10,
            j);
            TurnAngle:=terrObs[i,j].itemRotation; //RandomRange(1,350);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=180

      ///////////////////// Power spx //////////////////////////////
      if(terrObs[i,j].itemId=190) then begin
        if not(checkChildPowerSpx(i,j)) then begin
          proxy:=TGLProxyObject(DCPowerSphere.AddNewChild(TGLProxyObject));
          with proxy do begin
            ProxyOptions:=[pooObjects];
            MasterObject:=spxPowerSphereCore;
            // retrieve reference attitude
            Direction:=spxPowerSphereCore.Direction;
            Up:=spxPowerSphereCore.Up;
            Scale.SetVector(1,1,1);
            Position.SetPoint(i,
            TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+2,
            j);
            TransformationChanged;
          end; // with
        end; // in area
      end;  // if itemId=190

      ///////////// Enemy A ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=50) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemA do begin
            with enemiesTypeA[e] do begin
              if ( (not(enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;

                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EA');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).flee:=false;
                enemiesTypeA[e].TagFloat:=(50 + e);

                break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'A') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=50

      ///////////// Enemy B ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=51) then begin
        if checkIsBorderArea(curX,curY,i,j) then begin
          for e:= 1 to enemB do begin
            with enemiesTypeB[e ] do begin
              if ( (not(enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeB[ e {EAvisioCount}].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EB');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeB[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeB[e].TagFloat:=(60 + e);

                Break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'B') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=51 alien

      ///////////// Enemy C ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=52) then begin
        if checkIsBorderArea(curX,curY,i,j)   then begin
          for e:= 1 to enemC do begin
            with enemiesTypeC[e] do begin
              if ( (not(enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EC');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeC[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeC[e].TagFloat:=(70 + e);

                Break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'C') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=52 bug

      //////////// Enemy D ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=53) then begin
        if checkIsBorderArea(curX,curY,i,j)   then begin
          for e:= 1 to enemD do begin
            with enemiesTypeD[e] do begin
              if ( (not(enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+8,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('ED');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeD[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeD[e].TagFloat:=(80 + e);

                Break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'D') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=53 insect

      //////////// Enemy E ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=54) then begin
        if checkIsBorderArea(curX,curY,i,j)   then begin
          for e:= 1 to enemE do begin
            with enemiesTypeE[e] do begin
              if ( (not(enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EE');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeE[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeE[e].TagFloat:=(90 + e);

                Break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'E') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=54 frog

      //////////// Enemy F ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=55) then begin
        if checkIsBorderArea(curX,curY,i,j)   then begin
          for e:= 1 to enemF do begin
            with enemiesTypeF[e] do begin
              if ( (not(enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EF');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeF[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeF[e].TagFloat:=(100 + e);

                Break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'F') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=55 drio

      //////////// Enemy G ////////////////////////////////////////
      //////////////////////////////////////////////
      if(terrObs[i,j].itemId=56) then begin
        if checkIsBorderArea(curX,curY,i,j)   then begin
          for e:= 1 to enemG do begin
            with enemiesTypeG[e] do begin
              if ( (not(enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).fired))and
              (not(enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded)) )
              then begin
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).fired:=true;
                Position.SetPoint(i,
                TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))+FCamHeight,
                j);
                //////////////////////////////////
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).nextPositionX:=i;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).nextPositionZ:=j;

                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).oldPositionX:=i;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=j;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).Life:=initEnemyInfoLife('EG');
                Visible:=true;
                Position.X:=i;
                Position.Z:=j;

                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).isAlive:=true;
                enemyInfo(enemiesTypeG[e].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
                enemiesTypeG[e].TagFloat:=(110 + e);

                Break;
              end ;// IF FIRED
            end; // with
          end; // if enemA
        end // in area
        else begin
          if isInvalidEnemyValue(i,j,'G') then
            terrObs[i,j].itemId:=0;
        end;
      end;  // if itemId=56 okta
      //-----------------------------------------------------------------------
    end; // for
  end; // for
end;

procedure TForm1.CollisionManager1Collision(Sender: TObject; object1,
  object2: TGLBaseSceneObject);
begin
  //
end;

procedure TForm1.setMHtargetPoint(tgX, tgY: Integer);
var
  currentDistance,firstDistance,i,j,MHx,MHy,tg_X,tg_Y, abs_dist:Integer;
begin
  // set walk target coordinates for MH
  MHx:=round(DCMainHero.Position.X);
  MHy:=round(DCMainHero.Position.Z);

  abs_dist:=calcDistance(MHx,MHy,tgX,tgY);
  if (abs_dist > 25) then begin
    firstDistance:=calcDistance(MHx,MHy,tgX-10,tgY-10);

    for j:= (tgY-10) to (tgY+10) do begin
      for i:= (tgX-10) to (tgX+10) do begin
        currentDistance:=calcDistance(MHx,MHy,i,j);
        if(currentDistance <= firstDistance) then begin
           firstDistance:=currentDistance;
           tg_X:=i;
           tg_Y:=j;
        end; // if
      end; // for i
    end;  // for j
    MHwalktgX:=tg_X;
    MHwalktgY:=tg_Y;

    MHCollision:=true;
  end  // dist > 25
  else
  begin
    firstDistance:=calcDistance(MHx,MHy,tgX-10,tgY-10);

    for j:= (tgY-10) to (tgY+10) do begin
      for i:= (tgX-10) to (tgX+10) do begin
        currentDistance:=calcDistance(MHx,MHy,i,j);
        if(currentDistance >= firstDistance) then begin
           firstDistance:=currentDistance;
           tg_X:=i;
           tg_Y:=j;
        end; // if
      end; // for i
    end;  // for j
    MHwalktgX:=tg_X;
    MHwalktgY:=tg_Y;
    MHCollision:=true;
  end;
end;

function TForm1.calcDistance(x1, y1, x2, y2: Integer): Integer;
begin
  // calc Distance between PointA(x1,y1) and PointB (x2,y2)
  Result:=round(sqrt( sqr((x2-x1)) + sqr((y2-y1)) ));
end;

procedure TForm1.AsyncTimer3Timer(Sender: TObject);
var
  tm_X, tm_Y:Integer;
begin
  /// auto click
  tm_X:=RandomRange(1,799);
  tm_Y:=RandomRange(1,599);
  GLSceneViewer1MouseDown(Sender,mbLeft,[ssAlt],tm_X,tm_Y);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  i:Integer;
begin
  if(MHRelease) then begin
    ProcessEAComplexPathfindingAuto(1,1);
  end;

  //-------------------
  if (MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
  //  EA fight
  for i :=1 to enemA do begin
    if (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

    // check critical life for escape procedure
    if not(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).flee) then begin
      if(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).Life <= ea_critical_life) then begin
        
        enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).flee:=true;
        ProcessEAComplexPathfinding(1,1);
      end; // if critical life
    end; // if not already checked

    if ( (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).goFight)and
         (not enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).flee)) then begin
      EALightningStrike(i);

      EAfightMH(i);

      end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for

  // ---------------------------------------------------------------------------
  //  EB fight

  for i :=1 to enemB do begin
    if (enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

        if (enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
          //enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
          EBFireBallStrike(i);

          EBfightMH(i);

        end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for

  // ---------------------------------------------------------------------------
  //  EC fight

  for i :=1 to enemC do begin
    if (enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

        if (enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
          ECfightMH(i);
        end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for
   //HUDText2.Text:=IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life);

  // ---------------------------------------------------------------------------
  //  ED fight

  for i :=1 to enemD do begin
    if (enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

        if (enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
          EDfightMH(i);
        end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for

  // ---------------------------------------------------------------------------
  //  EE fight

  for i :=1 to enemE do begin
    if (enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

        if (enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
          enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
          EEAcidBallStrike(i);
          EEfightMH(i);
        end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for

  // ---------------------------------------------------------------------------
  //  EF fight

  for i :=1 to enemF do begin
    if (enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

        if (enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
          enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
          EFLaserBallStrike(i);
          EFfightMH(i);
        end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for

  // ---------------------------------------------------------------------------
  //  EG fight

  for i :=1 to enemG do begin
    if (enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      if (enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).fired) then begin

        if (enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin

          EGOktaBallStrike(i);
          EGfightMH(i);
          
          
        end; // EA fired
    end; //  EA isAlive
    end; // go fight
  end; // for
  //////////////////////////////////////////////////
  end; // if MH alive
  //-------------------
       
  proceedDeathEA;
  proceedDeathEB;
  proceedDeathEC;
  proceedDeathED;
  proceedDeathEE;
  proceedDeathEF;
  proceedDeathEG;

  calcMHEnvironmentDamage;

  if(MH_web_drop_interval=250) then begin
    MH_web_drop_interval:=1;
  end
  else
  begin
    inc(MH_web_drop_interval);
    processMHWebDropping(MH_web_drop_interval);
  end;
end;

procedure TForm1.swapEATrace;
var
  i,oldX,oldZ,newX,newZ:Integer;
begin
  // set enemy position dynamic
  for i:=1 to enemA do begin
    if (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).fired) then begin
      oldX:=enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
      oldZ:=enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
      newX:=round(enemiesTypeA[i].Position.X);
      newZ:=round(enemiesTypeA[i].Position.Z);
      if((oldX<>newX)or(oldZ<>newZ)) then begin
        enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
        enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
        terrObs[oldX, oldZ].itemId:=0;
        terrObs[newX, newZ].itemId:=50;
      end; // if
    end;
  end; // for
end;

procedure TForm1.proceedEAFireDistance;
var
  i,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
 //
  for i:=1 to enemA do begin

  if(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeA[i].Position.X);
    enemyY:=round(enemiesTypeA[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);

    if(calc_dist<=25) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
          end;

      if not(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeA[i]);
        Movement.OnPathTravelStop := EnemyAPathTravelStop;
        Movement.ClearPaths;

        if(enemiesTypeA[i].CurrentAnimation<>'taunt') then begin
          enemiesTypeA[i].SwitchToAnimation('taunt',true);

        end; // if animation
      end; // at fire dist
    end // if
    else begin
      enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 25
   end; // if alive
  end; // for
end;

procedure TForm1.ProcessEAComplexPathfinding(spX,spZ:Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin

  /////////////////////////////////////////////////////////////////////////////
   // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemA do begin

   if (enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeA[ii].Position.X);
   centerY:=round(enemiesTypeA[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

      if not (enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).flee) then begin

     if (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25) then begin


   Movement   := GetOrCreateMovement(enemiesTypeA[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyAPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;
   //drawmapblockEA(0,0,200,200,0);
   // get MH current position
   // get enemy current position





   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;

   Path := Movement.AddPath;
   // Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeA[ii]);
  Node.Speed := 16.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 16.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeA[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeA[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
   play_HerosAudioTrack(11,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }

         //end; // if not flee
       end //  if calc distance >25
         /////////////////////////
         else begin

           //if not(enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).flee) then begin
           if(enemiesTypeA[ii].CurrentAnimation<>'taunt') then begin
             enemiesTypeA[ii].SwitchToAnimation('taunt',true);
           end; // animation
           //end; // if not flee

           //-------------------------------------------------
           {
           if (enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).flee) then begin
            Movement   := GetOrCreateMovement(enemiesTypeA[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyAPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;
   //drawmapblockEA(0,0,200,200,0);
   // get MH current position
   // get enemy current position





   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

    // chose some escape point -----
     if ( (MH_centerX_local<100)and(MH_centerY_local<100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,7,7);
     end;
     if ( (MH_centerX_local >= 100)and(MH_centerY_local<100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,193,7);
     end;
     if ( (MH_centerX_local<100)and(MH_centerY_local >= 100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,7,193);
     end;
     if ( (MH_centerX_local >= 100)and(MH_centerY_local >= 100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,193,193);
     end;
    // -----------------------------

    // err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);

     enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).flee:=false;

   end;

   Path := Movement.AddPath;
   // Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeA[ii]);
  Node.Speed := 16.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 16.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeA[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeA[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path



   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
  Movement.StartPathTravel;
  end; // if err=1




       //end //  if calc distance >25

          end; // if Flee
          }
           //-------------------------------------------------
         end; // else calcdistance


      end
      else
      begin //  flee
        Movement   := GetOrCreateMovement(enemiesTypeA[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyAPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;




   err:=0;
   EAnoEmptyPath:=false;
   //drawmapblockEA(0,0,200,200,0);
   // get MH current position
   // get enemy current position





   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

    // chose some escape point -----
     if ( (MH_centerX_local<100)and(MH_centerY_local<100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,7,7);
     end;
     if ( (MH_centerX_local >= 100)and(MH_centerY_local<100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,193,7);
     end;
     if ( (MH_centerX_local<100)and(MH_centerY_local >= 100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,7,193);
     end;
     if ( (MH_centerX_local >= 100)and(MH_centerY_local >= 100) ) then begin

       err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,193,193);
     end;
    // -----------------------------

    // err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   //err:=2;
   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
     if(enemiesTypeA[ii].CurrentAnimation<>'stand') then begin
       enemiesTypeA[ii].SwitchToAnimation('stand',true);
     end; // animation
     //enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).flee:=false;
     enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).Life:=(ea_critical_life + 1);
     enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).flee:=false;
     Exit;
   end;

   Path := Movement.AddPath;
   // Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeA[ii]);
  Node.Speed := 16.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 16.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeA[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeA[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeA[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path



   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
   play_HerosAudioTrack(11,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1




       //end //  if calc distance >25

         // end; // if Flee

      end; // else - flee



    end // if EA in area

        //-----

        else begin

            killEA(50+ii);
            

         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies

end;

function TForm1.isEnemyANearby(posX, posY: integer): boolean;
var
  i:Integer;
begin
  // check if enemies A start points are to close each other
  Result:=false;
  for i:= 1 to enemA do begin
    if not Assigned(enemiesTypeA[i]) then begin
      Result:=true;
      exit;
    end;
    if (calcDistance(posX,posY,round(enemiesTypeA[i].Position.X),round(enemiesTypeA[i].Position.Z))>=30) then begin
      Result:=true;
      exit;
    end; // if distant
  end; // for all

end;

procedure TForm1.EAfindPathOnCollision(obj:TGLBaseSceneObject);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  centerX,centerY,i,j,tgX,tgY,x1,y1,to_i,to_j,to_iw,to_jw,tg_X,tg_Y,
  firstDistance,currentDistance:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
  //
  //Proceed Pathfinding
  //dummy;
  if(EARelease) then begin


  Movement   := GetOrCreateMovement(obj);
  Movement.OnPathTravelStop := PathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;
  EARelease:=false;
  /////////////////////
   err:=0;
   //mhPosition -50 .. +50
   drawmapblock(0,0,100,100,0);
   // get MH current position
   centerX:=round(obj.Position.X);
   centerY:=round(obj.Position.Z);

   for j := (centerY-50) to (centerY+49) do begin
     for i := (centerX-50) to (centerX+49) do begin
       // some additional walkability processing

       if((terrObs[i,j].itemId=1)or(terrObs[i,j].itemId=50)) then
       begin
         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-50))-6;
         to_j:=(j-(centerY-50))-6;
         to_iw:=to_i+12;
         to_jw:=to_j+12;
         if((to_i in [0..100])and(to_j in [0..100])and(to_iw in [0..100])and(to_jw in [0..100])) then begin
           drawmapblock( to_i, to_j,12,12,1);
         //drawmapblock(  (i-(centerX-50))-6,(j-(centerY-50))-6,12,12,1);
         end; // if in range
       end; // if id=1

     end; //for i
   end; //for j

   //// find local target
   tg_X:=round(Sphere1.Position.X);
   tg_Y:=round(Sphere1.Position.Z);

  firstDistance:=calcDistance(centerX-50,centerY-50,tg_X,tg_Y);
  //obsticallity:=false;

  for j:= (centerY-50) to (centerY+50) do begin
    for i:= (centerX-50) to (centerX+50) do begin
       currentDistance:=calcDistance(i,j,tg_X,tg_Y);
      if(currentDistance <= firstDistance) then begin
         firstDistance:=currentDistance;
         tg_X:=i;
         tg_Y:=j;
      end; // if

    end; // for ii
  end;  // for j
   tgX:=(tg_X)-(centerX-50);
   tgY:=(tg_Y)-(centerY-50);

   if( (tgX in[1..99]) and (tgY in[1..99])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpath(100,100,50,50,tgX,tgY); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   //////////////////////////////////////////////////////
   if(err=1) then begin

    //Create a movement, a path and the first node of the path




  Path := Movement.AddPath;
  Path.ShowPath := True;

  //Path.PathSplineMode
  //Path.Looped := True;
  Node       := Path.AddNodeFromObject(obj);
  Node.Speed := 16.0;
   //----------
    EAnoEmptyPath:=false;
   for i:=0 to pathlength[0]-1 do
    begin
    if(odd(i)) then begin
    x1 := readpathx2(0,i);
    y1 := readpathy2(0,i);

    x1:=(x1-50) + centerX;
    y1:=(y1-50) + centerY;
    //----------------- to memo

    Node       := Path.AddNode;
    Node.Speed := 16.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
    EAnoEmptyPath:=true;
    end; // if odd i
    end; // adding nodes



  //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        //Actor1.SwitchToAnimation('run',true);
      end;

  Movement.StartPathTravel;

  end; // if err=1

  ///////////////////////////////////////////////////////////////////////////
  end; // release
end;

function TForm1.calcDistanceS(x1, y1, x2, y2: Single): Single;
begin
  // calc Distance between PointA(x1,y1) and PointB (x2,y2)
  Result:=(sqrt( sqr((x2-x1)) + sqr((y2-y1)) ));
end;

procedure TForm1.ProcessEAComplexPathfindingAuto(spX, spZ: Integer);
var
  centerX,centerY,i,j,to_i,to_j,to_iw,to_jw:Integer;
  //start, lap:Double;
begin
  //////////////////////////////////////////////////////////////////////////////
  /////////////////////
 // start:=GetTickCount;
  
   drawmapblockEA(0,0,200,200,0);
   // get MH current position
   centerX:=round(DCMainHero.Position.X);
   centerY:=round(DCMainHero.Position.Z);




   for j := (centerY-100) to (centerY+99) do begin
     for i := (centerX-100) to (centerX+99) do begin
       // some additional walkability processing


      if(TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))<-22) then begin

         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-100))-1;
         to_j:=(j-(centerY-100))-1;
         to_iw:=to_i+2;
         to_jw:=to_j+2;
         if((to_i in [0..200])and(to_j in [0..200])and(to_iw in [0..200])and(to_jw in [0..200])) then begin
           drawmapblockEA( to_i, to_j,2,2,1);
         //drawmapblock(  (i-(centerX-50))-6,(j-(centerY-50))-6,12,12,1);
         end; // if in range
       end; // if id=1


      // some additional walkability processing




       if((terrObs[i,j].itemId=1)or(terrObs[i,j].itemId=50)or
          (terrObs[i,j].itemId=2)or(terrObs[i,j].itemId=3)or
          (terrObs[i,j].itemId=4)or(terrObs[i,j].itemId=5)or
          (terrObs[i,j].itemId=6)or(terrObs[i,j].itemId=7)or
          (terrObs[i,j].itemId=8)or
          (terrObs[i,j].itemId=51)or
          (terrObs[i,j].itemId=54)or(terrObs[i,j].itemId=55)or
          (terrObs[i,j].itemId=20)or(terrObs[i,j].itemId=21)or
          (terrObs[i,j].itemId=22)or(terrObs[i,j].itemId=40)or
          (terrObs[i,j].itemId=56)) then
       begin
         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-100))-6;
         to_j:=(j-(centerY-100))-6;
         to_iw:=to_i+12;
         to_jw:=to_j+12;
         if((to_i in [0..200])and(to_j in [0..200])and(to_iw in [0..200])and(to_jw in [0..200])) then begin
           drawmapblockEA( to_i, to_j,12,12,1);
         //drawmapblock(  (i-(centerX-50))-6,(j-(centerY-50))-6,12,12,1);
         end; // if in range
       end; // if id=1

       //*************************
        if((terrObs[i,j].itemId=52)or(terrObs[i,j].itemId=53)) then
       begin
         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-100))-4;
         to_j:=(j-(centerY-100))-4;
         to_iw:=to_i+8;
         to_jw:=to_j+8;
         if((to_i in [0..200])and(to_j in [0..200])and(to_iw in [0..200])and(to_jw in [0..200])) then begin
           drawmapblockEA( to_i, to_j,8,8,1);
         //drawmapblock(  (i-(centerX-50))-6,(j-(centerY-50))-6,12,12,1);
         end; // if in range
       end; // if id=52
       //*************************
     end; //for i
   end; //for j

   // clear MH terrain position
   drawmapblockEA( 98, 98,4,4,0);




    ProcessEAComplexPathfinding(1,1);
      ProcessEBComplexPathfinding(1,1);
        ProcessECComplexPathfinding(1,1);
          ProcessEDComplexPathfinding(1,1);
            ProcessEEComplexPathfinding(1,1);
              ProcessEFComplexPathfinding(1,1);
                ProcessEGComplexPathfinding(1,1);
   //lap:=(GetTickCount-start);
  //Label1.Caption:=('exit' + FloatToStr(lap) + ' .ms');
  //ShowMessage('exit' + FloatToStr(lap) + ' .ms');

  //////////////////////////////////////////////////////////////////////////////
end;

procedure TForm1.ProcessMHPathfinding(X, Y: Integer);
var
  to_i,to_j,to_iw,to_jw:Integer;
  
  MHnoEmptyPath:boolean;
  Movement: TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;

  centerX,centerY,i,j,tgX,tgY,x1,y1, tgX_wat,tgY_wat:Integer;
  err:byte;
  //start,lap:Double;
begin
  //start:=GetTickCount;
  //Proceed Pathfinding
  Movement   := GetOrCreateMovement(DCMainHero);
  Movement.OnPathTravelStop := PathTravelStop;
  Movement.ClearPaths;
  Movement.StopPathTravel;
  MHRelease:=false;
  /////////////////////
  err:=0;
   //mhPosition -100 .. +100
  drawmapblockEA(0,0,200,200,0);
  // get MH current position
  centerX:=round(DCMainHero.Position.X);
  centerY:=round(DCMainHero.Position.Z);

  for j := (centerY-100) to (centerY+99) do begin
    for i := (centerX-100) to (centerX+99) do begin

      // some water walkability processing
      if(TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j))<-22) then begin

         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-100))-1;
         to_j:=(j-(centerY-100))-1;
         to_iw:=to_i+2;
         to_jw:=to_j+2;
         if((to_i in [0..200])and(to_j in [0..200])and(to_iw in [0..200])and(to_jw in [0..200])) then begin
           drawmapblockEA( to_i, to_j,2,2,1);
         //drawmapblock(  (i-(centerX-50))-6,(j-(centerY-50))-6,12,12,1);
         end; // if in range
       end; // if id=1
      // some additional walkability processing
     
      if((terrObs[i,j].itemId=1)or(terrObs[i,j].itemId=50)or
         (terrObs[i,j].itemId=2)or(terrObs[i,j].itemId=3)or
         (terrObs[i,j].itemId=4)or(terrObs[i,j].itemId=5)or
         (terrObs[i,j].itemId=6)or(terrObs[i,j].itemId=7)or
         (terrObs[i,j].itemId=8)or
         (terrObs[i,j].itemId=51)or
         (terrObs[i,j].itemId=54)or(terrObs[i,j].itemId=55)or
         (terrObs[i,j].itemId=20)or(terrObs[i,j].itemId=21)or
         (terrObs[i,j].itemId=22)or(terrObs[i,j].itemId=40)or
         (terrObs[i,j].itemId=56)) then
      begin
         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-100))-6;
         to_j:=(j-(centerY-100))-6;
         to_iw:=to_i+12;
         to_jw:=to_j+12;
         if((to_i in [0..200])and(to_j in [0..200])and(to_iw in [0..200])and(to_jw in [0..200])) then begin
           drawmapblockEA( to_i, to_j,12,12,1);
         end; // if in range
       end; // if id=1

       //*************** blyskaci
       if((terrObs[i,j].itemId=52)or(terrObs[i,j].itemId=53)) then
      begin
         // add some obsticle cell block for plant D
         to_i:=(i-(centerX-100))-4;
         to_j:=(j-(centerY-100))-4;
         to_iw:=to_i+8;
         to_jw:=to_j+8;
         if((to_i in [0..200])and(to_j in [0..200])and(to_iw in [0..200])and(to_jw in [0..200])) then begin
           drawmapblockEA( to_i, to_j,8,8,1);
         end; // if in range
       end; // if id=52
       //***************

     end; //for i
   end; //for j

   // clear MH terrain position
   drawmapblockEA( 98, 98,4,4,0);

   tgX:=(MHwalktgX)-(centerX-100);
   tgY:=(MHwalktgY)-(centerY-100);

   if( (tgX in[1..199]) and (tgY in[1..199])) then begin

     //--------------------
     if (spx_isUnderWater) then begin
     // sector 1
     if ( (tgX <= 100)and(tgY <= 100) ) then begin
       for j:=tgY to 100 do begin
         for i:=tgX to 100 do begin
           // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
         end; // i
         // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
       end; // j
     end; // if sec 1

     // sector 2
     if ( (tgX > 100)and(tgY <= 100) ) then begin
       for j:=tgY to 100 do begin
         for i:=tgX downto 100 do begin
           // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
         end; // i
         // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
       end; // j
     end; // if sec 2

     // sector 3
     if ( (tgX <= 100)and(tgY > 100) ) then begin
       for j:=tgY downto 100 do begin
         for i:=tgX to 100 do begin
           // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
         end; // i
         // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
       end; // j
     end; // if sec 3

     // sector 4
     if ( (tgX > 100)and(tgY > 100) ) then begin
       for j:=tgY downto 100 do begin
         for i:=tgX downto 100 do begin
           // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
         end; // i
         // find clear point to modify target
           if ( walkabilityEA[i,j] = 0) then begin
             tgX_wat:=i;
             tgY_wat:=j;
             Break;
           end; // if walkability
       end; // j
     end; // if sec 4

     tgX:=tgX_wat;
     tgY:=tgY_wat;

     end; // if spx under water
     //--------------------

     err := findpathEA(200,200,100,100,tgX,tgY); // if=1 ok
     //HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   //////////////////////////////////////////////////////
   if(err=1) then begin
   //Create a movement, a path and the first node of the path
  Path := Movement.AddPath;
  //Path.ShowPath := True;
  Node       := Path.AddNodeFromObject(DCMainHero);
  Node.Speed := 16.0;
  //----------
  MHnoEmptyPath:=false;

  for i:=0 to pathlengthEA[0]-1 do begin
    if(odd(i)) then begin
      x1 := readpathx2EA(0,i);
      y1 := readpathy2EA(0,i);
      //----------------- fill path
      if((i>=15)and( (x1 in [7..193])and(y1 in [7..193]) ) ) then begin
        drawmapblockEA( (x1-6), (y1-6),12,12,1);
      end; // if
      //-----------------
      x1:=(x1-100) + centerX;
      y1:=(y1-100) + centerY;

      Node       := Path.AddNode;
      Node.Speed := 16.0;

      Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
      Node.RotationAsVector := VectorMake(0, 0, 0);
      MHnoEmptyPath:=true;
    end; // if odd i
  end; // adding nodes

  //Activatived the current path
  Movement.ActivePathIndex := 0;
    if (MHnoEmptyPath) then begin
      Actor1.SwitchToAnimation('run',true);
      play_HerosAudioTrack(11,fMainMenu.global_game_volume_level,true,true);
    end;



  //------------------------------
  ProcessEAComplexPathfinding(1,1);
    ProcessEBComplexPathfinding(1,1);
      ProcessECComplexPathfinding(1,1);
        ProcessEDComplexPathfinding(1,1);
          ProcessEEComplexPathfinding(1,1);
            ProcessEFComplexPathfinding(1,1);
              ProcessEGComplexPathfinding(1,1);

  Movement.StartPathTravel;


       //lap:=(GetTickCount-start);
       //Label1.Caption:=('exit' + FloatToStr(lap) + ' .ms');

  end; // if err=1
  
end;

procedure TForm1.killEA(id:byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
  //



  for i:=1 to enemA do begin

    if(round(enemiesTypeA[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeA[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeA[i].Position.X);
    Z:=round(enemiesTypeA[i].Position.Z);

    enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeA[i].Visible:=false;

      enemiesTypeA[i].TagFloat:=0;

    enemiesTypeA[i].Position.SetPoint(-5000,0,-5000);
     // dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;

    end; // if exact
    {
    if(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
      inc(indexTagFloatChange);
      enemiesTypeA[i].TagFloat:= (50 + indexTagFloatChange);
    end; // if  alive
     }
  end;

end;

procedure TForm1.getUnderMouseObject(Sender: TObject);
begin
  pickedObject := GLSceneViewer1.Buffer.GetPickedObject(mx,my);
  {
  if Assigned(pickedObject) then begin
      if MHRelease then begin
        HUDText2.Text:=UpperCase(pickedObject.ClassName);
        //oldPick:=pickedObject;
      end
      else HUDText2.Text:='';
    end;
    }
  if Assigned(pickedObject) then

        //HUDText2.Text:=UpperCase(pickedObject.ClassName);
        pickedObj:=UpperCase(pickedObject.ClassName)

      else pickedObj:='';

end;

function TForm1.CalcEARollAngle(tarX, tarY , EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
  //round(enemiesTypeA[EA_i].Position.X
  //-------------------------------------
  A:=(tarY-round(enemiesTypeA[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeA[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeA[EA_i].Position.X) ) then begin
      result:=0;
      exit;
    end
    else
    begin
      result:=-180;
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeA[EA_i].Position.Z) ) then begin
      result:=90;
      exit;
    end
    else
    begin
      result:=-90;
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg)))+90;

  if(tarX > enemiesTypeA[EA_i].Position.X ) then begin
    m:=m+180;
  end;
  result:=(m+90);
  //HUDText2.Text:=' fin : ' +IntToStr(result);
end;

procedure TForm1.MHLightningStrike(tarX, tarY, Y, TargetTag: Integer);
var
  i:Integer;
begin
  //
  if not(endStrike) then begin
    GLThor:=TGLThorFXManager.Create(self);
    GLThor.Cadencer:=GLCadencer1;
    // thor parameters
    GLThor.Core:=false;
    GLThor.Glow:=true;
    GLThor.GlowSize:= 0.7;
    // inner color
    GLThor.InnerColor.Alpha:= 0.1;
    GLThor.InnerColor.Blue:= 1;
    GLThor.InnerColor.Green:= 1;
    GLThor.InnerColor.Red:= 1;
    // details - points to use
    GLThor.Maxpoints:= 512;
    // outer color- contur
    GLThor.OuterColor.Alpha:= 0;
    GLThor.OuterColor.Blue:= 0.9;
    GLThor.OuterColor.Green:= 0.2;
    GLThor.OuterColor.Red:= 0.2;
    // wildness
    GLThor.Wildness:= 8;

    GLThor.Target.X:= tarX;
    GLThor.Target.Z:= tarY;
    GLThor.Target.Y:= Y;

     //Label8.Caption:=IntToStr(DCMainHero.Effects.Count);
     
    strike:= TGLBThorFX.Create(DCMainHero.Effects);
    strike.Manager:=GLThor;
    DCMainHero.Effects.Add(strike);


     /// ---
      for i:=1 to enemA do begin

       if(round(enemiesTypeA[i].TagFloat)=TargetTag) then begin
         
         EAExplodePrepare(i,'normal');
          {

          GLImplosionFXRenderer:= TGLParticleFXRenderer.Create(GLScene1.Objects);
          GLImplosionFXRenderer.Parent:= GLScene1.Objects;
          GLImplosionFXRenderer.ZWrite:=true;

          GLEAImplosion := TGLPolygonPFXManager.Create(self);


            GLEAImplosion.NbSides:=10;
            GLEAImplosion.ParticleSize:=0.8;  //0.8;


          GLEAImplosion.Cadencer:=GLCadencer1;
          GLEAImplosion.Renderer:= GLImplosionFXRenderer;

          MHImplosion:= TGLSourcePFXEffect.Create(enemiesTypeA[i].Effects);
                // MHImplosion.ParticleInterval:=10;

          MHImplosion.Manager:=GLEAImplosion;
          enemiesTypeA[i].Effects.Add(MHImplosion);


       // enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).ExpolisionEffectANeeded:=true;

        with GetOrCreateSourcePFX(enemiesTypeA[i]) do begin

         DispersionMode:= sdmIsotropic;
         VelocityDispersion:=5;

         Burst(GLCadencer1.CurrentTime, 300);
         VelocityDispersion:=0;
         //Burst(GLCadencer1.CurrentTime, 0);
         end; //with
          }
       end; // if exact target
      end; // for all

       for i:=1 to enemB do begin
         if(round(enemiesTypeB[i].TagFloat)=TargetTag) then begin
           EBExplodePrepare(i,'normal');
         end; // if exact
       end; // for all
     /// ---
       for i:=1 to enemC do begin
         if(round(enemiesTypeC[i].TagFloat)=TargetTag) then begin
           ECExplodePrepare(i,'normal');
         end; // if exact
       end; // for all
     //--------------------
     /// ---
       for i:=1 to enemD do begin
         if(round(enemiesTypeD[i].TagFloat)=TargetTag) then begin
           EDExplodePrepare(i,'normal');
         end; // if exact
       end; // for all
     //--------------------
     /// ---
       for i:=1 to enemE do begin
         if(round(enemiesTypeE[i].TagFloat)=TargetTag) then begin
           EEExplodePrepare(i,'normal');
         end; // if exact
       end; // for all
     //--------------------
     /// ---
       for i:=1 to enemF do begin
         if(round(enemiesTypeF[i].TagFloat)=TargetTag) then begin
           EFExplodePrepare(i,'normal');
         end; // if exact
       end; // for all
     //--------------------
     /// ---
       for i:=1 to enemG do begin
         if(round(enemiesTypeG[i].TagFloat)=TargetTag) then begin
           EGExplodePrepare(i,'normal');
         end; // if exact
       end; // for all
     //--------------------

    MHstrikePeriod:=0;
      play_HerosAudioTrack(13,fMainMenu.global_game_volume_level,true,true);
    endStrike:=true;
  end;

end;

procedure TForm1.darknesizeScene(f_Start, f_End: Single);
begin
  // more dark
  //GLCamera1.DepthOfView:=GLCamera1.DepthOfView/1.2;
   with GLSceneViewer1.Buffer.FogEnvironment do begin
      FogEnd:= f_End;
      FogStart:= f_Start;
   end;

  GLSceneViewer1.Buffer.BackgroundColor:=clBlack;

  with GLSceneViewer1.Buffer.FogEnvironment do begin
    FogColor.AsWinColor:=clBlack;
    // FogStart:=-FogStart; // Fog is used to make things darker
  end;

end;



procedure TForm1.ProcessEBComplexPathfinding(spX, spZ: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
  // alien pathfinding

   // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemB do begin

   if (enemyInfo(enemiesTypeB[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeB[ii].Position.X);
   centerY:=round(enemiesTypeB[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeB[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

     if(calcDistance(centerX,centerY,MH_centerX,MH_centerY)>35) then begin

   Movement   := GetOrCreateMovement(enemiesTypeB[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyBPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;


   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;

   Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeB[ii]);
  Node.Speed := 26.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 26.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeB[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeB[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeB[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
    play_HerosAudioTrack(20,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }


       end //  if calc distance >25
         /////////////////////////
         else begin
           if(enemiesTypeB[ii].CurrentAnimation<>'point') then begin
             enemiesTypeB[ii].SwitchToAnimation('point',true);
           end; // animation
         end; // else calcdistance

    end // if EA in area

        //-----

        else begin
          killEB(60+ii);
          
         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies

end;

procedure TForm1.killEB(id: byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
  // alien
  for i:=1 to enemB do begin

    if(round(enemiesTypeB[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeB[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeB[i].Position.X);
    Z:=round(enemiesTypeB[i].Position.Z);

    enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeB[i].Visible:=false;

      enemiesTypeB[i].TagFloat:=0;

    enemiesTypeB[i].Position.SetPoint(-5000,0,-5000);
    //dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;
    end; // if exact

  end;
end;

function TForm1.CalcEBRollAngle(tarX, tarY, EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
  //-------------------------------------
  A:=(tarY-round(enemiesTypeB[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeB[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeB[EA_i].Position.X) ) then begin
      result:= -270;
      exit;
    end
    else
    begin
      result:= -90;
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeB[EA_i].Position.Z) ) then begin
      result:=0;
      exit;
    end
    else
    begin
      result:= -180;
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  if((A<>0)and(B<>0)) then begin
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg))) + 45;//+90;

  if(tarX > enemiesTypeB[EA_i].Position.X ) then begin
    m:=m+180;
  end;
    result:=-(m + 45);
  end; // if not null
end;

procedure TForm1.swapEBTrace;
var
  i,oldX,oldZ,newX,newZ: Integer;
begin
  //  aliens
  // set enemy position dynamic
  for i:=1 to enemB do begin

       if (enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).fired) then begin


    oldX:=enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
    oldZ:=enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
    newX:=round(enemiesTypeB[i].Position.X);
    newZ:=round(enemiesTypeB[i].Position.Z);
    if((oldX<>newX)or(oldZ<>newZ)) then begin
      enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
      enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
      terrObs[oldX, oldZ].itemId:=0;
      terrObs[newX, newZ].itemId:=51;
    end; // if

       end;

  end; // for
end;

procedure TForm1.proceedEBFireDistance;
var
  i,j,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
  // alien
  {
  for i:=1 to enemB do begin
    // get current enemy position
    enemyX:=round(enemiesTypeB[i].Position.X);
    enemyY:=round(enemiesTypeB[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=35) then begin
      if not(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeB[i]);
        Movement.OnPathTravelStop := EnemyAPathTravelStop;
        Movement.ClearPaths;
        if(enemiesTypeB[i].CurrentAnimation<>'point') then begin
          enemiesTypeB[i].SwitchToAnimation('point',true);
        end; // if animation
      end; // at fire dist
    end; // if
  end; // for
  }
  for i:=1 to enemB do begin

  if(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeB[i].Position.X);
    enemyY:=round(enemiesTypeB[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=35) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            if not(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
              enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
            end;

            enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
               enemiesTypeB[i].Interval:=100;
          end;

      if not(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeB[i]);
        Movement.OnPathTravelStop := EnemyBPathTravelStop;;
        Movement.ClearPaths;

        if(enemiesTypeB[i].CurrentAnimation<>'point') then begin
          enemiesTypeB[i].SwitchToAnimation('point',true);



        end; // if animation
      end; // at fire dist
    end // if
    else begin
      //---------------------

      for j :=1 to 5 do begin
      enemiesTypeB_fireconv[i][j].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j))) then
        Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j)).Free;
      end; // for

      //---------------------
        enemiesTypeB[i].Interval:=150;
      enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 35


   end; // if alive
  end; // for


end;

procedure TForm1.InitAndLoad(mode: byte);
begin
  Form1.Cursor:=Screen.Cursors[0];
  GLSceneViewer1.Cursor:=Screen.Cursors[0];
  EAvisioCount:=0;
  
  if mode <> 2 then
    inc(fMainMenu.current_level);
   
   if (fMainMenu.allow_game_vsync) then
     Form1.GLSceneViewer1.VSync:=vsmSync
   else
     Form1.GLSceneViewer1.VSync:=vsmNoSync;
   {
   if (fMainMenu.allow_game_antialiasing) then begin
     Form1.GLSceneViewer1.Buffer.BeginUpdate;
     Form1.GLSceneViewer1.Buffer.AntiAliasing:=aa2xHQ;
     Form1.GLSceneViewer1.Buffer.EndUpdate;
   end
   else
     Form1.GLSceneViewer1.Buffer.AntiAliasing:=aaDefault;
    }

   startWaterTxIndex:=0;
   MHRollAngle:=0;
   pick_move_item_ID:=0;
   picked_spell_id:=0;
   picked_window_id:=0;
   picked_exit_id:=0;
   hud_inv_base_state:=0;
   hud_hero_base_state:=0;
   spells_menu_isDown:=false;
   windows_menu_isDown:=false;
   exit_menu_isDown:=false;
   game_paused:=false;
   MH_level_up_points:=0;
   
   initFind;
   initFindEA;

   /////////////////////////////////////////////////
   GLMLHeroesTx.Materials[0].Material.Texture.Image.LoadFromFile('skin_MH.jpg');
   GLMLHeroesTx.Materials[1].Material.Texture.Image.LoadFromFile('wat_1.bmp');
   Actor1.Material.Texture.Image:=GLMLHeroesTx.Materials[0].Material.Texture.Image;

   initEnemyInfoBase;

    // Load Actor into GLScene
   Actor1.LoadFromFile('tris.md2');

   if(mode=2) then begin
     // load form save
     fMainMenu.loadUserGame;
   end;

   initMHInfoBase(fMainMenu.MH_exp);
   MH_LifeMana_step:=(228 / MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);

   Actor1.Scale.SetVector(0.3, 0.3, 0.1, 0);
   /// Load Enemy Actor

   Actor2.LoadFromFile('tris.md2');
   Actor2.Scale.SetVector(0.3, 0.3, 0.1, 0);

   // Define animation properties
   Actor1.AnimationMode:=aamLoop;
   Actor1.SwitchToAnimation('stand');  // stand
   Actor1.FrameInterpolation:=afpLinear;

   Actor1.Roll(0);
   // Define animation properties
   Actor2.AnimationMode:=aamLoop;
   Actor2.SwitchToAnimation('stand');  // stand
   Actor2.FrameInterpolation:=afpLinear;
   Actor2.Roll(0);

   // power Spx and HUD Sprite
   GLMLHudSprites.Materials[0].Material.Texture.Image.LoadFromFile('power_sphereA.bmp');
   // aura lens
   GLMLHudSprites.Materials[1].Material.Texture.Image.LoadFromFile('aura_lens.jpg');
   // Armor A
   GLMLHudSprites.Materials[2].Material.Texture.Image.LoadFromFile('armor_A_Tx.jpg');
   // Leaf A
   GLMLHudSprites.Materials[3].Material.Texture.Image.LoadFromFile('leaf_A.bmp');


   GLBitmapHDS1.MaxPoolSize:=8*1024*1024;
   // specify height map data
   GLBitmapHDS1.Picture.LoadFromFile(getMainSelfNameForLevel(fMainMenu.current_level)); //'self_01.bmp'
   // load the texture maps
   GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile(getMainTextureNameForLevel(fMainMenu.current_level));//'TextureMap.jpg'
   GLMaterialLibrary1.Materials[1].Material.Texture.Image.LoadFromFile(getBumpTextureNameForLevel(fMainMenu.current_level)); //'clover.jpg'

   LoadSubWaterTx;
   TerrainRenderer1.TilesPerTexture:=1;

   // load Bitmap Font
   BitmapFont1.Glyphs.LoadFromFile('darkgold_font.bmp');
   subWaterPlane.Material.Texture.Image:=GLMLSubWaterTx.Materials[0].Material.Texture.Image;

   // Could've been done at design time, but it the, it hurts the eyes ;)
   GLSceneViewer1.Buffer.BackgroundColor:=clWhite;

   MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon:='lightning';
   // Move camera starting point to an interesting hand-picked location

   MHRelease:=true;
   EARelease:=true;

   // Initial camera height offset (controled with pageUp/pageDown)
   setInitialCameraPosition;

   FCamHeight:=3;

   intersect:=false;
   MHchain:=false;
   MHchainCount:=0;
   MH_in_nova_strike:=false;

   AddTerrainItems(mode);
   //clearMHstartLocation(fMainMenu.MH_start_X,fMainMenu.MH_start_Y);
     DCMainHero.Position.X:=fMainMenu.MH_start_X;
   DCMainHero.Position.Z:=fMainMenu.MH_start_Y;

   Sphere1.Position.X:=fMainMenu.MH_start_X;//-884;
   Sphere1.Position.Z:=fMainMenu.MH_start_Y;//1344;

   ccc:=false;
   allow_MH_full_fill:=false;
   allow_MH_life_fill:=false;
   allow_MH_mana_fill:=false;
   spx_isUnderWater:=false;
   MHWebCount:=0;
   MH_web_drop_interval:=1;

   webLines.Roll(0);
   initWebs;

   global_f_start:=38.76;
   global_f_end:=125.97;

   darknesizeScene(global_f_start,global_f_end);
   // Add some sprites
   AddHUDSpriteTopBase(mode);
   // add objectives
   AddHUDSpriteObjectiveBase;
   AddHudSpriteInvBase(mode);

   movable_item_drop_needed:=false;

   showHudObjectivesBase;
   /////////////////////
   GLCadencer1.Enabled:=true;

     if (mode=2) then
       fMainMenu.restoreWebsFromSave;
   viewStartChild(fMainMenu.MH_start_X,fMainMenu.MH_start_Y);
end;

procedure TForm1.proceedShrineALightEffect(curX, curY: Integer);
var
  i,j,c,counter:Integer;
  f_start,f_end, step:Single;
  proceed:boolean;
begin
  // shrine area solar blink
  counter:=0;
  proceed:=false;

  //for c:= DCShrineA.ComponentCount downto 1 do begin
  for c:=1 to 8 do begin
    i:=shrinesA[c].Xcoord;
    j:=shrinesA[c].Ycoord;
    step:=calcDistance(curX, curY, i, j);
    if (step <= 60 ) then begin
      proceed:=true;
      Break;
    end;
  end; // all shrines

    //i:=round(DCShrineA.Children[c].Position.X);
    //j:=round(DCShrineA.Children[c].Position.Z);
    //if (calcDistance(curX, curY, i, j) <= 60 ) then begin
    if (proceed) then begin
       //ShowMessage('shrine : ' + IntToStr(c));
         GLFireFXMHShrineManager.InnerColor.Blue:=0;
         GLFireFXMHShrineManager.InnerColor.Green:=1;
         GLFireFXMHShrineManager.InnerColor.Red:=1;

         GLFireFXMHShrineManager.OuterColor.Blue:=0;
         GLFireFXMHShrineManager.OuterColor.Green:=0.5;
         GLFireFXMHShrineManager.OuterColor.Red:=1;
       //-----
          GLFireFXMHShrineManager.Disabled:=false;
            allow_MH_full_fill:=true;
          inc(counter);
          ShrineALightPeriod:=true;
          if(odd(counter)) then begin
          f_start:=global_f_start;
          f_end:=global_f_end;
          // 6
          //step := calcDistance(curX, curY, i, j);
          step:= (  ((61-step) / 4 )*((61-step) / 10 ) + RandomRange(0,5));
          //RandomRange(1,29);
          darknesizeScene((f_start+step),(f_end+step));
          end;

    end // if  in area
    else
    begin
      if(ShrineALightPeriod) then begin
        darknesizeScene(global_f_start,global_f_end);
          allow_MH_full_fill:=false;
        GLFireFXMHShrineManager.Disabled:=true;
        ShrineALightPeriod:=false;
        Exit;
      end; // need
    end;

  //end; // for all


end;



procedure TForm1.MHLightningStrikePrepare(tarX, tarY, Y: Integer);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
    GLBeforeFire.FireBurst:=2;
    GLBeforeFire.FireCrown:=0;
    GLBeforeFire.FireDensity:=100000;

    GLBeforeFire.MaxParticles:=2048;

    GLBeforeFire.NoZWrite:=false;

    GLBeforeFire.InnerColor.Alpha:=1;
    GLBeforeFire.OuterColor.Alpha:=1;

    GLBeforeFire.FireDir.X:=0;
    GLBeforeFire.FireDir.Y:=0.2;
    GLBeforeFire.FireDir.Z:=0;

    GLBeforeFire.InitialDir.X:=0;
    GLBeforeFire.InitialDir.Y:=5;
    GLBeforeFire.InitialDir.Z:=0;

    GLBeforeFire.ParticleInterval:=0.0001;
    GLBeforeFire.ParticleLife:=2;
    GLBeforeFire.ParticleSize:=1; //0.5;

    //GLBeforeFire.FireEvaporation:=;
    GLBeforeFire.FireRadius:=1;

    GLBeforeFire.Paused:=false;
    GLBeforeFire.UseInterval:=true;

    MHBeforeStrikeFire:= TGLBFireFX.Create(DCMainHero.Effects);
    MHBeforeStrikeFire.Manager:=GLBeforeFire;
    DCMainHero.Effects.Add(MHBeforeStrikeFire);

   /// MHstrikePeriod:=0;
   // endStrike:=true;
end;

procedure TForm1.MHImplosion(tarX, tarY, Y: Integer);
var
  GLImpolsionFire:TGLFireFXManager;
  MHImpolsionFire:TGLBFireFX;
begin
 // prepare strike event animation
  GLImpolsionFire:=TGLFireFXManager.Create(self);
  GLImpolsionFire.Cadencer:=GLCadencer1;
  // params
  GLImpolsionFire.FireBurst:=5;
  GLImpolsionFire.FireCrown:=1;
  GLImpolsionFire.FireDensity:=10;

  GLImpolsionFire.MaxParticles:=1024;

  //GLImpolsionFire.NoZWrite:=false;

  GLImpolsionFire.InnerColor.Alpha:=1;
  GLImpolsionFire.InnerColor.Red:=0.8;
  GLImpolsionFire.InnerColor.Green:=0.8;
  GLImpolsionFire.InnerColor.Blue:=1;

  GLImpolsionFire.OuterColor.Alpha:=1;
  GLImpolsionFire.InnerColor.Red:=0.1;
  GLImpolsionFire.InnerColor.Green:=0.1;
  GLImpolsionFire.InnerColor.Blue:=0.8;

  GLImpolsionFire.FireDir.X:=0;
  GLImpolsionFire.FireDir.Y:=0.2;
  GLImpolsionFire.FireDir.Z:=0;

  GLImpolsionFire.InitialDir.X:=0;
  GLImpolsionFire.InitialDir.Y:=5;
  GLImpolsionFire.InitialDir.Z:=0;

  GLImpolsionFire.ParticleInterval:=0.01;
  GLImpolsionFire.ParticleLife:=3; // 3
  GLImpolsionFire.ParticleSize:=15; //15

  //GLBeforeFire.FireEvaporation:=;
  GLImpolsionFire.FireRadius:=5;

  GLImpolsionFire.Paused:=false;
  GLImpolsionFire.UseInterval:=true;

  MHImpolsionFire:= TGLBFireFX.Create(Actor1.Effects);
  MHImpolsionFire.Manager:=GLImpolsionFire;
  Actor1.Effects.Add(MHImpolsionFire);


  GLImpolsionFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLImpolsionFire.Disabled:=True;
end;

procedure TForm1.EAExplodePrepare(ea_index:Integer; mode:String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeA[ea_index].Effects.IndexOfName('EAExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeA[ea_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EAExplodeA')) then
    Form1.FindComponent('EAExplodeA').Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EAExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeA[ea_index].Effects);
  MHBeforeStrikeFire.Name:='EAExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeA[ea_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;

  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EAExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeA[ea_index].Effects);
  MHBeforeStrikeFire.Name:='EAExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeA[ea_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode


end;


procedure TForm1.MHExplodePrepare;
var
  GLMHExplodeA:TGLFireFXManager;
  MHGLExplodeFireA:TGLBFireFX;
    fx_id:Integer;
begin
  // explode FX

  fx_id:=Actor1.Effects.IndexOfName('MHExplodeAEffect');
  if(fx_id <> -1) then
    Actor1.Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('MHExplodeA')) then
    Form1.FindComponent('MHExplodeA').Free;

  // prepare strike event animation
  GLMHExplodeA:=TGLFireFXManager.Create(self);
  GLMHExplodeA.Name:='MHExplodeA';
  GLMHExplodeA.Cadencer:=GLCadencer1;
  // params
  GLMHExplodeA.FireBurst:=5;
  GLMHExplodeA.FireCrown:=1;
  GLMHExplodeA.FireDensity:=10;

  GLMHExplodeA.MaxParticles:=1024;

  //GLMHExplodeA.NoZWrite:=false;

  GLMHExplodeA.InnerColor.Alpha:=1;
  GLMHExplodeA.InnerColor.Red:=0.8;
  GLMHExplodeA.InnerColor.Green:=0.8;
  GLMHExplodeA.InnerColor.Blue:=1;

  GLMHExplodeA.OuterColor.Alpha:=1;
  GLMHExplodeA.InnerColor.Red:=0.1;
  GLMHExplodeA.InnerColor.Green:=0.1;
  GLMHExplodeA.InnerColor.Blue:=0.8;

  GLMHExplodeA.FireDir.X:=0;
  GLMHExplodeA.FireDir.Y:=0.2;
  GLMHExplodeA.FireDir.Z:=0;

  GLMHExplodeA.InitialDir.X:=0;
  GLMHExplodeA.InitialDir.Y:=5;
  GLMHExplodeA.InitialDir.Z:=0;

  GLMHExplodeA.ParticleInterval:=0.01;
  GLMHExplodeA.ParticleLife:=3;
  GLMHExplodeA.ParticleSize:=15;


  GLMHExplodeA.FireRadius:=5;

  GLMHExplodeA.Paused:=false;
  GLMHExplodeA.UseInterval:=true;

  MHGLExplodeFireA:= TGLBFireFX.Create(Actor1.Effects);
    MHGLExplodeFireA.Name:='MHExplodeAEffect';
  MHGLExplodeFireA.Manager:=GLMHExplodeA;
  Actor1.Effects.Add(MHGLExplodeFireA);


  GLMHExplodeA.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLMHExplodeA.Disabled:=True;

end;

procedure TForm1.fightEA(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;

begin
  // MH fight against EA
    {Life type is Smallint -32768..32767}
  for i:=1 to enemA do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeA[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeA[i].CurrentAnimation<>'pain3') then begin
          oldAnimation:=enemiesTypeA[i].CurrentAnimation;
          enemiesTypeA[i].SwitchToAnimation('pain3',true);
          play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathEA(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathEA(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeA[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies

end;

function TForm1.calcMHtoEnemyDamage(weapon: String): Smallint;
begin
  with fMainMenu do begin
    // calc Damage
    if(weapon = 'lightning') then begin
      // single damage only
      Result:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack; // * 1;
    end; // if attackWeapon = lightning
    // calc Damage
    if(weapon = 'chain_lightning') then begin
     // mass damage
     Result:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack; // * 1;
    end; // if attackWeapon = chain lightning
    // calc Damage
    if(weapon = 'nova') then begin
     // mass damage
     Result:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack; // * 1;
    end; // if attackWeapon = nova
  end; // with
end;

procedure TForm1.EAfightMH(ea_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin
  // EA fight
  // check is enemy alive first
  {
    if(enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).Life <= ea_critical_life) then begin
    enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).flee:=true;
    Exit;
  end;
   // if not(enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).striking) then begin
   }

      // EA lightning strike and Explode FX
     // EALightningStrike(ea_index);
     // enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).striking:=true;
      MHExplodePrepare;

      // MH calc damage
      // switch MH to pain animation

        if((Actor1.CurrentAnimation <> 'pain3')and(Actor1.CurrentFrame <> 182)) then begin
          //oldAnimation:=Actor1.CurrentAnimation;
          //Actor1.SwitchToAnimation('pain3',true);
          Actor1.CurrentFrame:=182;
          play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch
        

        // fight the enemy
        oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

        if(oldMHLife > 0) then begin
          EADamage := calcEnemyToMHDamage('lightning');
          if (oldMHLife <= EADamage) then begin
            killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

          end
          else begin
            MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
          end;
         end
         else begin
           killMH;
         end;


        // rollback previous enemy animation
        // Actor1.SwitchToAnimation(oldAnimation,true);


      //enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).striking:=false;
   // end; // if striking

 // end; // if enemy alive

end;

procedure TForm1.EALightningStrike(ea_index: Integer);
var
  GLEAThor:TGLThorFXManager;
  EAstrike: TGLBThorFX;
begin

  

  if not(enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).striking) then begin
   { enemiesTypeA_core[ea_index].Effects.Clear;

  if Assigned(Form1.FindComponent('GLEAThor' + IntToStr(ea_index))) then
    Form1.FindComponent('GLEAThor' + IntToStr(ea_index)).Free;

   }

  // EA lightning strike animation;
      GLEAThor:=TGLThorFXManager.Create(self);
    GLEAThor.Name:='GLEAThor' + IntToStr(ea_index);

    GLEAThor.Cadencer:=GLCadencer1;
    // thor parameters
    GLEAThor.Core:=false;
    GLEAThor.Glow:=true;
    GLEAThor.GlowSize:=0.7; //0.7;

    // inner color
    GLEAThor.InnerColor.Alpha:= 0.1;
    GLEAThor.InnerColor.Blue:= 1;
    GLEAThor.InnerColor.Green:= 1;
    GLEAThor.InnerColor.Red:= 1;
    // details - points to use
    GLEAThor.Maxpoints:= 512;
    // outer color- contur
    GLEAThor.OuterColor.Alpha:= 0;
    GLEAThor.OuterColor.Blue:= 0.9;
    GLEAThor.OuterColor.Green:= 0.2;
    GLEAThor.OuterColor.Red:= 0.2;
    // wildness
    GLEAThor.Wildness:= 8;



     { pink floyd
    GLEAThor.Target.X:= (Actor1.Position.X - enemiesTypeA[ea_index].Position.X);
    GLEAThor.Target.Z:= (Actor1.Position.Z - enemiesTypeA[ea_index].Position.Z);
    GLEAThor.Target.Y:= (Actor1.Position.Y - enemiesTypeA[ea_index].Position.Y);
     
     v:=DCMainHero.LocalToAbsolute(v);
         //GLSceneViewer1.Buffer.
      // convert that local coords to grid pos
      ix:=Round(v[0]);
      iy:=Round(v[1]);
      iz:=Round(v[2]);
      }
      {
    GLEAThor.Target.X:=round(enemiesTypeA[ea_index].Position.X-DCMainHero.Position.X);
    GLEAThor.Target.Z:=round(enemiesTypeA[ea_index].Position.Z-DCMainHero.Position.Z);
    GLEAThor.Target.Y:=round(enemiesTypeA[ea_index].Position.Y-DCMainHero.Position.Y);
       }
    GLEAThor.Target.X:=round(DCMainHero.Position.X-enemiesTypeA[ea_index].Position.X);
    GLEAThor.Target.Z:=round(DCMainHero.Position.Z-enemiesTypeA[ea_index].Position.Z);
    GLEAThor.Target.Y:=round(DCMainHero.Position.Y-enemiesTypeA[ea_index].Position.Y);

    Label1.Caption:=IntToStr(round(GLEAThor.Target.X))+' / '+IntToStr(round(GLEAThor.Target.Z));
    Label7.Caption:=IntToStr(round(enemiesTypeA[ea_index].Position.X))+' / '+IntToStr(round(enemiesTypeA[ea_index].Position.Z));
    Label2.Caption:=IntToStr(round(DCMainHero.Position.X))+' / '+IntToStr(round(DCMainHero.Position.Z));
    {
    EAstrike:= TGLBThorFX.Create(enemiesTypeA[ea_index].Effects);
    EAstrike.Name:='EAStrike' + IntToStr(ea_index);
    EAstrike.Manager:=GLEAThor;
    enemiesTypeA[ea_index].Effects.Add(EAstrike);
    }



    EAstrike:= TGLBThorFX.Create(enemiesTypeA_core[ea_index].Effects);
    EAstrike.Name:='EAStrike' + IntToStr(ea_index);

    EAstrike.Manager:=GLEAThor;
    enemiesTypeA_core[ea_index].Effects.Add(EAstrike);
    


    // init EA strike period counter 
    enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).strikePeriod:=0;
    
    enemyInfo(enemiesTypeA[ea_index].Behaviours.GetByClass(enemyInfo)).striking:=true;
    play_HerosAudioTrack(13,fMainMenu.global_game_volume_level,true,true);
  end;
end;

function TForm1.calcEnemyToMHDamage(weapon: String): Smallint;
begin
  with fMainMenu do begin
  // calc EA damage
  if(weapon = 'lightning') then begin
   // single damage only
   // calc Damage
   Result:=(EABaseAttack*current_level);
  end; // if attackWeapon = lightning


  // calc EA damage
  if(weapon = 'fire_ball') then begin
   // single damage only
   // calc Damage
   Result:=(EBBaseAttack*current_level);
  end; // if attackWeapon = lightning

  // calc EA damage
  if(weapon = 'fire_ball_ground') then begin
   // single damage only
   // calc Damage
   Result:=(EBBaseAttack*current_level);
  end; // if attackWeapon = lightning

  // calc EC damage
  if(weapon = 'bug_bait') then begin
   // single damage only
   // calc Damage
   Result:=(ECBaseAttack*current_level);
  end; // if attackWeapon = lightning

  // calc ED damage
  if(weapon = 'insect_bait') then begin
   // single damage only
   // calc Damage
   Result:=(EDBaseAttack*current_level);
  end; // if attackWeapon = lightning

  // calc EE damage
  if(weapon = 'acid_ball') then begin
   // single damage only
   // calc Damage
   Result:=(EEBaseAttack*current_level);
  end; // if attackWeapon = lightning

  // calc EF damage
  if(weapon = 'laser_ball') then begin
   // single damage only
   // calc Damage
   Result:=(EFBaseAttack*current_level);
  end; // if attackWeapon = lightning

  // calc EG damage
  if(weapon = 'okta_nova') then begin
   // single damage only
   // calc Damage
   Result:=(EGBaseAttack*current_level);
  end; // if attackWeapon = lightning
  end; // with
end;

procedure TForm1.killMH;
begin
  // game over
  MHExplodePrepare;


  MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive:=false;
  MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=0;

  //////
  MainMenu.fMainMenu.current_level:=0;
  MainMenu.fMainMenu.MH_exp:=1;
  GLCadencer1.Enabled:=false;
  MainMenu.fMainMenu.showFailedCondition;
  MainMenu.fMainMenu.main_menu_current_state:= 'failed_condition';
  Hide;
  MainMenu.fMainMenu.Refresh;
  MainMenu.fMainMenu.writeInErrorLog(2,'');
  /////
  stopAllGameSounds;
  destroyChild;

end;

procedure TForm1.processEALightningFX;
var
  i, step:Shortint;
  f_start, f_end: Single;
begin
  // EA strike FX cadencer control
  for i:= 1 to enemA do begin
     // --- process MH Lightning strike effect called inside CadencerProgress
   if enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).striking then begin



    if (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).strikePeriod< 10) then begin
      // ---- solar effect
        if(odd(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).strikePeriod)) then begin
          f_start:=global_f_start;
          f_end:=global_f_end;
          // 6
          //step := RandomRange(1,19);
            step:=  MH_dark_random[enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).strikePeriod];
            
          if not(darknessizing_scene) then begin
            darknessizing_scene:=true;
            darknesizeScene((f_start+step),(f_end+step));
          end;

        end;
      // ----
      inc(enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).strikePeriod);


    end
    else
    begin
      enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=0;
        darknesizeScene(global_f_start,global_f_end);

        darknessizing_scene:=false;

      enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).striking:=false;
      // enemiesTypeA[i].Effects.Clear;

        enemiesTypeA_core[i].Effects.Clear;
        if Assigned(Form1.FindComponent('GLEAThor' + IntToStr(i))) then
          Form1.FindComponent('GLEAThor' + IntToStr(i)).Free;
       //? strike.Free; Cube.Effects[0].Free; Cube.Effects.Delete(0);
       //? GLThor.Free;
       play_HerosAudioTrack(13,fMainMenu.global_game_volume_level,false,false);
    end;
  end;
  //-----------------------------------------
 end; // for all enemies A

end;

procedure TForm1.deathEA(ix: Integer);
var
  Movement:TGLMovement;
begin
  //
  // fightEA- killEA must be replaced with deathEA ;

  // for i:=1 to enemA do begin

  //  if(round(enemiesTypeA[i].TagFloat)=ea_index) then begin

   enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
   enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

   if (enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).flee) then begin
     Movement   := GetOrCreateMovement(enemiesTypeA[ix]);
     Movement.Name:=IntToStr(ix);
     Movement.OnPathTravelStop := EnemyAPathTravelStop;
     Movement.ClearPaths;
     Movement.StopPathTravel;

     enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).flee:=false;
   end;
   //  deathAnimationNeeded must be set false in killEA / transperansy must be rollbacked

   // big explosion before
   if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
     EAExplodePrepare(ix,'death');
   end;

   if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
     EAChainExplodePrepare(ix,'death');
   end;

   if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
     EAChainExplodePrepare(ix,'death');
   end;

   // calc MH Experience
   calcMHExperience(fMainMenu.EABaseLife);

   if(enemiesTypeA[ix].CurrentAnimation<>'death1') then begin



            //ShowMessage('death animation');
          enemiesTypeA[ix].SwitchToAnimation('death1',true);
          // stop animation

          // set alpha to 0.8;

          // get some of FCamHeight down
          enemiesTypeA[ix].Position.Y:=(enemiesTypeA[ix].Position.Y - 1);


          enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;


          enemiesTypeA[ix].Material.BlendingMode:=bmTransparency;


        end; // animation switch

   // after some period killEA Timer=1000ms controled transperancy
   // when alpha =0 then killEA

  // end; // if exact
  // end; // for all
end;

procedure TForm1.proceedDeathEA;
var
  i, EA_alpha:Integer;
begin
  // death EA body transperancy control must be in timer=1000 ms
    for i:= 1 to enemA do begin
      if (enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then         begin




        EA_alpha:=round(enemiesTypeA[i].Material.FrontProperties.Diffuse.Alpha*10);

        //enemiesTypeA[i].Material.FrontProperties.Specular.Alpha:=0.2;


        if (enemiesTypeA[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);

          dec(EA_alpha);



          enemiesTypeA[i].Material.FrontProperties.Diffuse.Alpha:=(EA_alpha / 10);



        end // if Alpha >0
        else
        begin
          //ShowMessage(' remove EA ');
          enemyInfo(enemiesTypeA[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeEA(i);
          //enemiesTypeA[i].Material.FrontProperties.Ambient.Alpha:=1;
          //enemiesTypeA[i].Material.FrontProperties.Emission.Alpha:=1;
          //enemiesTypeA[i].Material.FrontProperties.Diffuse.Alpha:=1;
          //enemiesTypeA[i].Material.FrontProperties.Specular.Alpha:=1;

        end;


        end; // if trancperancy process is needed


    end; // for all enemies

end;

procedure TForm1.removeEA(ix: byte);
var
  X,Z:Integer;
  Movement: TGLMovement;
begin
  // same as killEA
  Movement   := GetOrCreateMovement(enemiesTypeA[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeA[ix].Position.X);
    Z:=round(enemiesTypeA[ix].Position.Z);

    enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeA[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeA[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeA[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeA[ix].AnimationMode:=aamLoop;
    enemiesTypeA[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeA[ix].TagFloat:=0;

    enemiesTypeA[ix].Position.SetPoint(-5000,0,-5000);

    terrObs[X, Z].itemId:=0;
end;

procedure TForm1.fightEB(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;
begin
  // MH fight EB
  // MH fight against EA
    {Life type is Smallint -32768..32767}
  for i:=1 to enemB do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeB[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeB[i].CurrentAnimation<>'pain') then begin
          oldAnimation:=enemiesTypeB[i].CurrentAnimation;
          enemiesTypeB[i].SwitchToAnimation('pain',true);
          play_HerosAudioTrack(23,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathEB(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathEB(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeB[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies


end;

procedure TForm1.deathEB(ix: Integer);
var
  i:byte;
begin
  // death EB
  enemyInfo(enemiesTypeB[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
  enemyInfo(enemiesTypeB[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

    enemiesTypeB[ix].Interval:=150;

  // big explosion before
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
    EBExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    EBChainExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    EBChainExplodePrepare(ix,'death');
  end;

  // recall FireBall
  for i:= 1 to 5 do begin
    EBFireBallRecall(ix,i);
  end; // for all

  // calc MH Experience
  calcMHExperience(fMainMenu.EBBaseLife);
  play_HerosAudioTrack(24,fMainMenu.global_game_volume_level,true,false);

  if(enemiesTypeB[ix].CurrentAnimation<>'deathb') then begin
    enemiesTypeB[ix].SwitchToAnimation('deathb',true);

    enemiesTypeB[ix].Position.Y:=(enemiesTypeB[ix].Position.Y - 3);
    enemyInfo(enemiesTypeB[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;
    enemiesTypeB[ix].Material.BlendingMode:=bmTransparency;

  end; // animation switch
  enemyDropItem('B',ix,round(enemiesTypeB[ix].Position.X),round(enemiesTypeB[ix].Position.Z));
end;

procedure TForm1.EBExplodePrepare(eb_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin

  fx_id:=enemiesTypeB[eb_index].Effects.IndexOfName('EBExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeB[eb_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EBExplodeA')) then
    Form1.FindComponent('EBExplodeA').Free;

  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EBExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeB[eb_index].Effects);
  MHBeforeStrikeFire.Name:='EBExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeB[eb_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EBExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeB[eb_index].Effects);
  MHBeforeStrikeFire.Name:='EBExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeB[eb_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode

end;

procedure TForm1.proceedDeathEB;
var
  i, EB_alpha:Integer;
begin
  // death EB body transperancy control must be in timer=1000 ms
    for i:= 1 to enemB do begin
      if (enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then         begin




        EB_alpha:=round(enemiesTypeB[i].Material.FrontProperties.Diffuse.Alpha*10);

        //enemiesTypeA[i].Material.FrontProperties.Specular.Alpha:=0.2;


        if (enemiesTypeB[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);

          dec(EB_alpha);



          enemiesTypeB[i].Material.FrontProperties.Diffuse.Alpha:=(EB_alpha / 10);



        end // if Alpha >0
        else
        begin
          //ShowMessage(' remove EA ');
          enemyInfo(enemiesTypeB[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeEB(i);
          //enemiesTypeA[i].Material.FrontProperties.Ambient.Alpha:=1;
          //enemiesTypeA[i].Material.FrontProperties.Emission.Alpha:=1;
          //enemiesTypeA[i].Material.FrontProperties.Diffuse.Alpha:=1;
          //enemiesTypeA[i].Material.FrontProperties.Specular.Alpha:=1;

        end;


        end; // if trancperancy process is needed


    end; // for all enemies

end;

procedure TForm1.removeEB(ix: byte);
var
  Movement: TGLMovement;
begin
  // same as killEB
  Movement   := GetOrCreateMovement(enemiesTypeB[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;
    //X:=round(enemiesTypeB[ix].Position.X);
    //Z:=round(enemiesTypeB[ix].Position.Z);

    enemyInfo(enemiesTypeB[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeB[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeB[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeB[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeB[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeB[ix].AnimationMode:=aamLoop;
    enemiesTypeB[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeB[ix].TagFloat:=0;

    enemiesTypeB[ix].Position.SetPoint(-5000,0,-5000);
    // drop items do it
   // terrObs[X, Z].itemId:=0;

end;

procedure TForm1.EBFireBallStrike(eb_index: Integer);
begin
  //  fire ball attack of EB
    //strikePeriod:=enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod;

  Randomize;

   if (enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod=8) then begin
     //strikePeriod:=1;
     enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
     Exit;
   end;

   if (enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod>=3) then begin // 3
     //recall(strikePeriod-2);   // 2
     EBFireBallRecall(eb_index,(enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod-2));
   end; // >3

   if (enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod=2) then begin // 3
     //recall(5);   // 2
     EBFireBallRecall(eb_index,5);
   end; // >3

   if(enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod = 6) then begin
     //trow(1);
     EBFireBallThrow(eb_index,1);
     enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod:=2;
     //inc(strikePeriod);
     Exit;
   end;

   //trow(strikePeriod);
   EBFireBallThrow(eb_index,enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod);
   inc(enemyInfo(enemiesTypeB[eb_index].Behaviours.GetByClass(enemyInfo)).strikePeriod);

end;

procedure TForm1.EBfightMH(eb_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin
  // EB fight

  //MHExplodePrepare;


        // fight the enemy
        oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

        if(oldMHLife > 0) then begin
          EADamage := calcEnemyToMHDamage('fire_ball');
          if (oldMHLife <= EADamage) then begin
            killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

          end
          else begin
            MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
          end;
         end
         else begin
           killMH;
         end;

end;

procedure TForm1.EBFireBallRecall(eb_index,idx: Integer);
begin
  // set conv coord back to Enemy first
  //enemiesTypeB_fireconv[eb_index][idx].Effects.Clear;

  enemiesTypeB_fireconv[eb_index][idx].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx))) then
    Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx)).Free;

    enemiesTypeB_fireconv[eb_index][idx].Tag:=0;

    with enemiesTypeB_fireconv[eb_index][idx].Position do begin
     X := enemiesTypeB[eb_index].Position.X;
     Z := enemiesTypeB[eb_index].Position.Z;
     Y:=TerrainRenderer1.InterpolatedHeight(AsVector) + 15;

     end;


end;

procedure TForm1.EBFireBallThrow(eb_index,idx: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  
  MH_centerX,MH_centerY,ranX,ranY:Integer;
begin
  // set attribute "striking"to true and check in Cadencer to prevent core_B moving
    Randomize;
    ranX:=RandomRange(1,3);
    ranY:=RandomRange(1,3);



    MH_centerX:=round(DCMainHero.Position.X);
    MH_centerY:=round(DCMainHero.Position.Z);

  //  EBFireBallPrepare(eb_index, idx);

   Movement   := GetOrCreateMovement(enemiesTypeB_fireconv[eb_index][idx]);
   Movement.Name:=(IntToStr(eb_index) + '#' + IntToStr(idx));
   Movement.OnPathTravelStop := EnemyBFireBallStop; //coreBPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;
  //Movement.OnPathTravelStop := EnemyBFireBallStop;
  EBFireBallPrepare(eb_index, idx);

     Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeB_fireconv[eb_index][idx]);
  Node.Speed := 50.0;  //50

    Node       := Path.AddNode;
    Node.Speed := 50.0;

    Node.PositionAsVector := VectorMake((MH_centerX+ranX),
       TerrainRenderer1.InterpolatedHeight(VectorMake((MH_centerX+ranX), 0, (MH_centerY+ranY))) + FCamHeight + 5,
       (MH_centerY+ranY));
    Node.RotationAsVector := VectorMake(0, 0, 0);





    //Activatived the current path
  Movement.ActivePathIndex := 0;
     play_HerosAudioTrack(21,fMainMenu.global_game_volume_level,true,false);
  Movement.StartPathTravel;

  Randomize;
  enemiesTypeB[eb_index].CurrentFrame:=RandomRange(126,132);

end;

procedure TForm1.EBFireBallPrepare(eb_index, idx: Integer);
var
  GLEBFireBall:TGLFireFXManager;
  EBGLExplodeFire:TGLBFireFX;

  //MHDummyFXSphere: TSphere;
begin
 // explode FX
  // clear FX

  //enemiesTypeB_fireconv[eb_index][idx].Effects.Clear;
  enemiesTypeB_fireconv[eb_index][idx].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx))) then
    Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx)).Free;

  // prepare strike event animation
  GLEBFireBall:=TGLFireFXManager.Create(self);
  GLEBFireBall.Name:='GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx);
  GLEBFireBall.Cadencer:=GLCadencer1;
  // params
  GLEBFireBall.FireBurst:=2;
  GLEBFireBall.FireCrown:=0.5;
  GLEBFireBall.FireDensity:=4;

  GLEBFireBall.MaxParticles:=256;

  //GLMHExplodeA.NoZWrite:=false;

  GLEBFireBall.InnerColor.Alpha:=1;
  GLEBFireBall.InnerColor.Red:=1;
  GLEBFireBall.InnerColor.Green:=1;
  GLEBFireBall.InnerColor.Blue:=0;

  GLEBFireBall.OuterColor.Alpha:=1;
  GLEBFireBall.OuterColor.Red:=0.8;
  GLEBFireBall.OuterColor.Green:=0.1;
  GLEBFireBall.OuterColor.Blue:=0.1;

  {
  GLEBFireBall.FireDir.X:=0;
  GLEBFireBall.FireDir.Y:=0.2;
  GLEBFireBall.FireDir.Z:=0;

  GLEBFireBall.InitialDir.X:=0;
  GLEBFireBall.InitialDir.Y:=5;
  GLEBFireBall.InitialDir.Z:=0;
  }

  GLEBFireBall.ParticleInterval:=0.01;
  GLEBFireBall.ParticleLife:=3;
  GLEBFireBall.ParticleSize:=1;


  GLEBFireBall.FireRadius:=0.5;

  GLEBFireBall.Paused:=false;
  GLEBFireBall.UseInterval:=true;

  EBGLExplodeFire:= TGLBFireFX.Create(enemiesTypeB_fireconv[eb_index][idx].Effects);
  EBGLExplodeFire.Manager:=GLEBFireBall;
  enemiesTypeB_fireconv[eb_index][idx].Effects.Add(EBGLExplodeFire);


  //GLEBFireBall.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  //GLEBFireBall.Disabled:=True;


end;

procedure TForm1.EnemyBFireBallStop(Sender: TObject; Path: TGLMovementPath;
  var Looped: Boolean);
var
  input:String;
  eb_index, idx:Integer;
  //GLEBFireBallGround:TGLFireFXManager;
  //EBGLExplodeFireGround:TGLBFireFX;
begin
  input:=(Sender as TGLMovement).Name;
  eb_index:=StrToInt(Copy(input,1,Pos('#',input)-1));
  idx:=StrToInt(Copy(input,Pos('#',input) + 1,Length(input)));

  play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);

  if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx))) then begin
    with TGLFireFXManager(Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx))) do begin

  enemiesTypeB_fireconv[eb_index][idx].Tag:=1;
      // params
  FireBurst:=5;
  FireCrown:=5;
  FireDensity:=5; //4

  MaxParticles:=256; // 256

  InnerColor.Alpha:=1;
  InnerColor.Red:=1;
  InnerColor.Green:=1;
  InnerColor.Blue:=0.3;

  OuterColor.Alpha:=1;
  OuterColor.Red:=0.8;
  OuterColor.Green:=0.2;
  OuterColor.Blue:=0.3;

  ParticleInterval:=0.0001;
  ParticleLife:=5; //3
  ParticleSize:=6;

  FireRadius:=3.5;

    end; // with
  end;

  {
  if (GetOrCreateFireFX(enemiesTypeB_fireconv[eb_index][idx]).Manager <> nil)then begin
     ShowMessage(' it is');
  with GetOrCreateFireFX(enemiesTypeB_fireconv[eb_index][idx]).Manager do begin

    FireBurst:=16;
  end;

  end;
  }

 // ShowMessage(' it is NIL');
{
  input:=(Sender as TGLMovement).Name;
  eb_index:=StrToInt(Copy(input,1,Pos('#',input)-1));
  idx:=StrToInt(Copy(input,Pos('#',input) + 1,Length(input)));
  //enemiesTypeA[StrToInt((Sender as TGLMovement).Name)].SwitchToAnimation('stand',true);
  //enemiesTypeB_fireconv
  // EB fire ball on ground
  enemiesTypeB_fireconv[eb_index][idx].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx))) then
    Form1.FindComponent('GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx)).Free;

  //GLEBFireBall.Name:='GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx);
  // prepare strike event animation
  GLEBFireBallGround:=TGLFireFXManager.Create(self);
  GLEBFireBallGround.Name:='GLEBFireBall' + IntToStr(eb_index) + IntToStr(idx);
  GLEBFireBallGround.Cadencer:=GLCadencer1;
  // params
  GLEBFireBallGround.FireBurst:=6;
  GLEBFireBallGround.FireCrown:=3;
  GLEBFireBallGround.FireDensity:=6;

  GLEBFireBallGround.MaxParticles:=256;

  //GLMHExplodeA.NoZWrite:=false;

  GLEBFireBallGround.InnerColor.Alpha:=1;
  GLEBFireBallGround.InnerColor.Red:=1;
  GLEBFireBallGround.InnerColor.Green:=1;
  GLEBFireBallGround.InnerColor.Blue:=0;

  GLEBFireBallGround.OuterColor.Alpha:=1;
  GLEBFireBallGround.OuterColor.Red:=0.8;
  GLEBFireBallGround.OuterColor.Green:=0.1;
  GLEBFireBallGround.OuterColor.Blue:=0.1;


  GLEBFireBallGround.ParticleInterval:=0.01;
  GLEBFireBallGround.ParticleLife:=3;
  GLEBFireBallGround.ParticleSize:=1.5;


  GLEBFireBallGround.FireRadius:=2; // 0.5

  GLEBFireBallGround.Paused:=false;
  GLEBFireBallGround.UseInterval:=true;

  EBGLExplodeFireGround:= TGLBFireFX.Create(enemiesTypeB_fireconv[eb_index][idx].Effects);
  EBGLExplodeFireGround.Manager:=GLEBFireBallGround;
  enemiesTypeB_fireconv[eb_index][idx].Effects.Add(EBGLExplodeFireGround);
 //  end; // if assigned
 }
end;

procedure TForm1.calcMHEnvironmentDamage;
var
  eb_index,idx,dist, MHx, MHy, FBx, FBy:Integer;
  oldMHLife, EADamage:Smallint;
begin

  // Fire Ball ground damage
  for eb_index:=1 to enemB do begin
      for idx:= 1 to 5 do begin

         // check if balls are ground and enough near to MH
         // add tag swich on sphere 0-false / 1 -true for OnGround detection
         // set tag to 0-false in stopPathTravel procedure

        if ( enemiesTypeB_fireconv[eb_index][idx].tag=1 ) then begin

          // get MH current coordinates
            //play_HerosAudioTrack(22,fMainMenu.global_game_volume_level,true,false);
          MHx:=round(DCMainHero.Position.X);
          MHy:=round(DCMainHero.Position.Z);

          // get FB current coordinates
          FBx:=round(enemiesTypeB_fireconv[eb_index][idx].Position.X);
          FBy:=round(enemiesTypeB_fireconv[eb_index][idx].Position.Z);

          dist := calcDistance(MHx, MHy, FBx, FBy);
            if(dist<=10) then begin

              // fight the enemy
        oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

          //MainMenu.fMainMenu.Memo1.Lines.Add('environment ');
          
        if(oldMHLife > 0) then begin
          EADamage := calcEnemyToMHDamage('fire_ball_ground');
          if (oldMHLife <= EADamage) then begin
            killMH; 

          end
          else begin
            MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
          end;
         end
         else begin
           killMH;
         end;




            end; // calc distance

         end; // if onGround
           //play_HerosAudioTrack(22,fMainMenu.global_game_volume_level,false,false);
      end; // for fireballs
    end; // for all enemies

    //HUDText2.Text:=IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life);
end;

procedure TForm1.MHAttackUnderMouseObject(X, Y: Integer);
begin
  // get text for text-bar
  processTextBarInfo(X,Y);
  // lightning
  processMHLightning(X,Y);
  // chain lightning
  processMHChainLightning;
  // nova
  processMHNova;
  // build web
  processMHBuildWeb;
  // destroy web
  processMHDestroyWeb(X,Y);
end;

procedure TForm1.writeWat;
var
  F:TFileStream;
  Path:String;
  start, lap:Double;
  i,j:Integer;
begin
  //
  //ShowMessage('enter');
  start:=GetTickCount;
  //-------------------
  for j :=624 to 5446 do begin
    for i :=(-4161) to 968 do begin
    Application.ProcessMessages;
      if((round(TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j)))< -22)) then
        terrObs[i,j].itemId:=250
      else
        terrObs[i,j].itemId:=0;

    end; // i
    Label1.Caption:=IntToStr(j);
  end; // j
  //-------------------




  path:='params.wat';

  F:=TFileStream.Create(path, fmCreate);
  try
    F.WriteBuffer(terrObs[-4161,624], SizeOf(terrObs));
  finally
    F.Free;
  end;

  lap:=(GetTickCount-start);

  ShowMessage('exit' + FloatToStr(lap) + ' .ms');

end;

procedure TForm1.loadWat;
var
  F:TFileStream;
  Path:String;
  //start, lap:Double;
begin
  //
  //start:=GetTickCount;
  //-------------------

  //-------------------




  path:='level_1.wat';

  F:=TFileStream.Create(path, fmOpenRead);
  try
    F.ReadBuffer(terrObs[-4161,624], SizeOf(terrObs));
  finally
    F.Free;
  end;

  //lap:=(GetTickCount-start);

  //ShowMessage('exit' + FloatToStr(lap) + ' .ms');
end;

procedure TForm1.generateMHDarkArray;
var
  step,i:byte;
begin
  //
  for i:=0 to 15 do begin
    Randomize;
    step := RandomRange(1,19);
    MH_dark_random[i]:=step;
  end;
end;

procedure TForm1.destroyChild;
var
  c,i,j:Integer;
  Movement:TGLMovement;
begin
  // free some children
  try
  Timer1.Enabled:=false;
  AsyncTimer1.Enabled:=false;
  AsyncTimer2.Enabled:=false;
  Timer2.Enabled:=false;


  //MainMenu.fMainMenu.Memo1.Lines.Add('plantD ' +IntToStr(DCBasePlantD.ComponentCount));
  // free all  DCBasePlantD children
  for c:= DCBasePlantD.ComponentCount downto 0 do begin
    DCBasePlantD.Children[c].Free;
   // MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  //MainMenu.fMainMenu.Memo1.Lines.Add('plantE ' +IntToStr(DCBasePlantE.ComponentCount));
  // free all  DCBasePlantE children
  for c:= DCBasePlantE.ComponentCount downto 0 do begin
    DCBasePlantE.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCBasePlantF children
  for c:= DCBasePlantF.ComponentCount downto 0 do begin
    DCBasePlantF.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCBasePlantG children
  for c:= DCBasePlantG.ComponentCount downto 0 do begin
    DCBasePlantG.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCBasePlantH children
  for c:= DCBasePlantH.ComponentCount downto 0 do begin
    DCBasePlantH.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCBasePlantI children
  for c:= DCBasePlantI.ComponentCount downto 0 do begin
    DCBasePlantI.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCBasePlantJ children
  for c:= DCBasePlantJ.ComponentCount downto 0 do begin
    DCBasePlantJ.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCBasePlantK children
  for c:= DCBasePlantK.ComponentCount downto 0 do begin
    DCBasePlantK.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  //MainMenu.fMainMenu.Memo1.Lines.Add('shrine ' +IntToStr(DCShrineA.ComponentCount));
  // free all  DCShrineA children
  for c:= DCShrineA.ComponentCount downto 0 do begin
    DCShrineA.Children[c].Effects.Clear;
    DCShrineA.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCShrineB children
  for c:= DCShrineB.ComponentCount downto 0 do begin
    DCShrineB.Children[c].Effects.Clear;
    DCShrineB.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCShrineC children
  for c:= DCShrineC.ComponentCount downto 0 do begin
    DCShrineC.Children[c].Effects.Clear;
    DCShrineC.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCCellsLife children
  for c:= DCCellsLife.ComponentCount downto 0 do begin
    DCCellsLife.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCCellsEnergy children
  for c:= DCCellsEnergy.ComponentCount downto 0 do begin
    DCCellsEnergy.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCArmorA children
  for c:= DCArmorA.ComponentCount downto 0 do begin
    DCArmorA.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCWeaponA children
  for c:= DCWeaponA.ComponentCount downto 0 do begin
    DCWeaponA.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCPowerSphere children
  for c:= DCPowerSphere.ComponentCount downto 0 do begin
    DCPowerSphere.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  // free all  DCSpiderWeb children
  for c:= DCSpiderWeb.ComponentCount downto 1 do begin
    DCSpiderWeb.Children[c].Free;
  end; // for

  // free all  DCHUDTop children
  for c:= (DCHUDTop.ComponentCount-1) downto 0 do begin
    DCHUDTop.Children[c].Free;
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
  end; // for

  //MainMenu.fMainMenu.Memo1.Lines.Add('path start kill ');
  for i:= 1 to enemB do begin
    for j:= 1 to 5 do begin


      enemiesTypeB_fireconv[i][j].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j))) then
        Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j)).Free;


    Movement   := GetOrCreateMovement(enemiesTypeB_fireconv[i][j]);
    Movement.ClearPaths;
    Movement.StopPathTravel;
    end;
  end;

  for i:= 1 to enemE do begin

    enemiesTypeE_core[i].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEEAcidBall' + IntToStr(i))) then
        Form1.FindComponent('GLEEAcidBall' + IntToStr(i)).Free;

    Movement   := GetOrCreateMovement(enemiesTypeE_core[i]);
    Movement.ClearPaths;
    Movement.StopPathTravel;
  end; // for E

  for i:= 1 to enemF do begin

    enemiesTypeF_core[i].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEFLaserBall' + IntToStr(i))) then
        Form1.FindComponent('GLEFLaserBall' + IntToStr(i)).Free;

    Movement   := GetOrCreateMovement(enemiesTypeF_core[i]);
    Movement.ClearPaths;
    Movement.StopPathTravel;
  end; // for F

  for i:= 1 to enemG do begin
    enemiesTypeG_core[i].Effects.Clear;
    if Assigned(Form1.FindComponent('GLEGOktaBall' + IntToStr(i))) then
      Form1.FindComponent('GLEGOktaBall' + IntToStr(i)).Free;
  end; //  for all
  //MainMenu.fMainMenu.Memo1.Lines.Add('path end kill ');


  // free all  DCEnemies children
  for c:= (DCEnemies.ComponentCount-1) downto 0 do begin
    DCEnemies.Children[c].Behaviours.Clear;
    DCEnemies.Children[c].Effects.Clear;
    DCEnemies.Children[c].Free;

    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c));
    //MainMenu.fMainMenu.Memo1.Lines.Add('free ' +IntToStr(c)+ ' / '+DCEnemies.Children[c].ClassName);
  end; // for

    Actor1.Behaviours.Clear;
    Actor1.Effects.Clear;
    DCMainHero.Behaviours.Clear;
    DCMainHero.Effects.Clear;
  finally
    TerrainRenderer1.HeightDataSource:=nil;
    FreeAndNil(Form1);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //
  DCMainHero.Position.X:=StrToInt(Edit1.Text);
  DCMainHero.Position.Y:=0;
  DCMainHero.Position.Z:=StrToInt(Edit2.Text);
end;

procedure TForm1.AddShrinesB;
var
   i,j, ranX,ranY : Integer;
   ranRotation:byte;
begin
  // Life 21
  for i:=1 to 4 do begin
     // sector 1
     if(i=1) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-1931,-1831);
         ranY:=RandomRange(2144,2244);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,21,ranRotation);
           shrinesB[1].Xcoord:=ranX;
           shrinesB[1].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_B[1].posX:=ranX;
           fMainMenu.M_shrines_B[1].posY:=ranY;
           fMainMenu.M_shrines_B[1].itemId:=21;
           fMainMenu.M_shrines_B[1].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 1

     // sector 2
     if(i=2) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-2551,-2451);
         ranY:=RandomRange(2728,2828);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,21,ranRotation);
           shrinesB[2].Xcoord:=ranX;
           shrinesB[2].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_B[2].posX:=ranX;
           fMainMenu.M_shrines_B[2].posY:=ranY;
           fMainMenu.M_shrines_B[2].itemId:=21;
           fMainMenu.M_shrines_B[2].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 2

     // sector 3
     if(i=3) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-742,-642);
         ranY:=RandomRange(2728,2828);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,21,ranRotation);
           shrinesB[3].Xcoord:=ranX;
           shrinesB[3].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_B[3].posX:=ranX;
           fMainMenu.M_shrines_B[3].posY:=ranY;
           fMainMenu.M_shrines_B[3].itemId:=21;
           fMainMenu.M_shrines_B[3].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 3

     // sector 4
     if(i=4) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-1931,-1831);
         ranY:=RandomRange(3844,3944);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,21,ranRotation);
           shrinesB[4].Xcoord:=ranX;
           shrinesB[4].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_B[4].posX:=ranX;
           fMainMenu.M_shrines_B[4].posY:=ranY;
           fMainMenu.M_shrines_B[4].itemId:=21;
           fMainMenu.M_shrines_B[4].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 4

  end; // for all   
end;

procedure TForm1.proceedShrineBLightEffect(curX, curY: Integer);
var
  i,j,c,counter:Integer;
  f_start,f_end, step:Single;
  proceed:boolean;
begin
  // Life
  // shrine area solar blink
  counter:=0;
  proceed:=false;

  //for c:= DCShrineA.ComponentCount downto 1 do begin
  for c:=1 to 4 do begin
    i:=shrinesB[c].Xcoord;
    j:=shrinesB[c].Ycoord;
    step:=calcDistance(curX, curY, i, j);
    if (step <= 60 ) then begin
      proceed:=true;
      Break;
    end;
  end; // all shrines

    //i:=round(DCShrineA.Children[c].Position.X);
    //j:=round(DCShrineA.Children[c].Position.Z);
    //if (calcDistance(curX, curY, i, j) <= 60 ) then begin
    if (proceed) then begin
       //ShowMessage('shrine : ' + IntToStr(c));

         GLFireFXMHShrineManager.InnerColor.Blue:=0;
         GLFireFXMHShrineManager.InnerColor.Green:=0;
         GLFireFXMHShrineManager.InnerColor.Red:=1;

         GLFireFXMHShrineManager.OuterColor.Blue:=0.5;
         GLFireFXMHShrineManager.OuterColor.Green:=0.5;
         GLFireFXMHShrineManager.OuterColor.Red:=0.8;

       //-----
          GLFireFXMHShrineManager.Disabled:=false;
            allow_MH_life_fill:=true;
          inc(counter);
          ShrineBLightPeriod:=true;
          if(odd(counter)) then begin
          f_start:=global_f_start;
          f_end:=global_f_end;
          // 6
          //step := calcDistance(curX, curY, i, j);
          step:= (  ((61-step) / 4 )*((61-step) / 10 ) + RandomRange(0,5));
          //RandomRange(1,29);
          darknesizeScene((f_start+step),(f_end+step));
          end;

    end // if  in area
    else
    begin
      if(ShrineBLightPeriod) then begin
        darknesizeScene(global_f_start,global_f_end);
          allow_MH_life_fill:=false;
        GLFireFXMHShrineManager.Disabled:=true;
        ShrineBLightPeriod:=false;
        Exit;
      end; // need
    end;
end;

procedure TForm1.AddShrinesC;
var
   i,j, ranX,ranY : Integer;
   ranRotation:byte;
begin
  // Mana 22
  // Life 21
  for i:=1 to 4 do begin
     // sector 1
     if(i=1) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-1362,-1262);
         ranY:=RandomRange(2144,2244);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,22,ranRotation);
           shrinesC[1].Xcoord:=ranX;
           shrinesC[1].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_C[1].posX:=ranX;
           fMainMenu.M_shrines_C[1].posY:=ranY;
           fMainMenu.M_shrines_C[1].itemId:=22;
           fMainMenu.M_shrines_C[1].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 1

     // sector 2
     if(i=2) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-2551,-2451);
         ranY:=RandomRange(3261,3361);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,22,ranRotation);
           shrinesC[2].Xcoord:=ranX;
           shrinesC[2].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_C[2].posX:=ranX;
           fMainMenu.M_shrines_C[2].posY:=ranY;
           fMainMenu.M_shrines_C[2].itemId:=22;
           fMainMenu.M_shrines_C[2].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 2

     // sector 3
     if(i=3) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-742,-642);
         ranY:=RandomRange(3261,3361);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,22,ranRotation);
           shrinesC[3].Xcoord:=ranX;
           shrinesC[3].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_C[3].posX:=ranX;
           fMainMenu.M_shrines_C[3].posY:=ranY;
           fMainMenu.M_shrines_C[3].itemId:=22;
           fMainMenu.M_shrines_C[3].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 3

     // sector 4
     if(i=4) then begin
       for j:=1 to 100 do begin
         fMainMenu.update_loading_progress;
         Randomize;
         ranX:=RandomRange(-1362,-1262);
         ranY:=RandomRange(3844,3944);
         ranRotation:=RandomRange(0,250);
         if(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY)) < -21) then begin
           Continue;
         end // if water level
         else
         begin
           terrObsFillCell(ranX,ranY,22,ranRotation);
           shrinesC[4].Xcoord:=ranX;
           shrinesC[4].Ycoord:=ranY;
           // save to array
           fMainMenu.M_shrines_C[4].posX:=ranX;
           fMainMenu.M_shrines_C[4].posY:=ranY;
           fMainMenu.M_shrines_C[4].itemId:=22;
           fMainMenu.M_shrines_C[4].itemRotation:=ranRotation;
           //
           Break;
         end;
       end; // for j
     end; // if 4

  end; // for all
end;

procedure TForm1.proceedShrineCLightEffect(curX, curY: Integer);
var
  i,j,c,counter:Integer;
  f_start,f_end, step:Single;
  proceed:boolean;
begin
  // mana 22
  // Life
  // shrine area solar blink
  counter:=0;
  proceed:=false;

  //for c:= DCShrineA.ComponentCount downto 1 do begin
  for c:=1 to 4 do begin
    i:=shrinesC[c].Xcoord;
    j:=shrinesC[c].Ycoord;
    step:=calcDistance(curX, curY, i, j);
    if (step <= 60 ) then begin
      proceed:=true;
      Break;
    end;
  end; // all shrines

    //i:=round(DCShrineA.Children[c].Position.X);
    //j:=round(DCShrineA.Children[c].Position.Z);
    //if (calcDistance(curX, curY, i, j) <= 60 ) then begin
    if (proceed) then begin
       //ShowMessage('shrine : ' + IntToStr(c));

         GLFireFXMHShrineManager.InnerColor.Blue:=1;
         GLFireFXMHShrineManager.InnerColor.Green:=0;
         GLFireFXMHShrineManager.InnerColor.Red:=0;

         GLFireFXMHShrineManager.OuterColor.Blue:=0.9;
         GLFireFXMHShrineManager.OuterColor.Green:=0.9;
         GLFireFXMHShrineManager.OuterColor.Red:=0.6;

       //-----
          GLFireFXMHShrineManager.Disabled:=false;
            allow_MH_mana_fill:=true;
          inc(counter);
          ShrineCLightPeriod:=true;
          if(odd(counter)) then begin
          f_start:=global_f_start;
          f_end:=global_f_end;
          // 6
          //step := calcDistance(curX, curY, i, j);
          step:= (  ((61-step) / 4 )*((61-step) / 10 ) + RandomRange(0,5));
          //RandomRange(1,29);
          darknesizeScene((f_start+step),(f_end+step));
          end;

    end // if  in area
    else
    begin
      if(ShrineCLightPeriod) then begin
        darknesizeScene(global_f_start,global_f_end);
          allow_MH_mana_fill:=false;
        GLFireFXMHShrineManager.Disabled:=true;
        ShrineCLightPeriod:=false;
        Exit;
      end; // need
    end;
end;

function TForm1.getTRheight(posX, posY: Integer): Integer;
begin
  //interpolated
  Result:=round(TerrainRenderer1.InterpolatedHeight(VectorMake(posX,0,posY)));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//
 //if IsKeyDown(VK_ESCAPE) then
   //begin
     GLCadencer1.Enabled:=false;

     //GLCadencer1.Destroy;
     //GLCadencer1.OnProgress:=nil;
     //MainMenu.fMainMenu.Memo1.Visible:=true;
     MainMenu.fMainMenu.Show;
     GLCadencer1.Enabled:=false;
     //Close;
     // FreeAndNil(GLCadencer1);
     destroyChild;
     //Exit;
     //Form1.Free;
  // end;

end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  //webLines.Roll(StrToInt(Edit1.Text));
   MHWebs[1].Roll(StrToInt(Edit1.Text));
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
   enemiesTypeC[1].RollAngle:=(StrToInt(Edit2.Text));
end;

procedure TForm1.ProcessECComplexPathfinding(spX, spZ: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
  // bug pathfinding

   // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemC do begin

   if (enemyInfo(enemiesTypeC[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeC[ii].Position.X);
   centerY:=round(enemiesTypeC[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeC[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

     if(calcDistance(centerX,centerY,MH_centerX,MH_centerY)>8) then begin

   Movement   := GetOrCreateMovement(enemiesTypeC[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyCPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;


   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
          // clear MH terrain position
          // drawmapblockEA( 96, 96,10,10,0);  // 94, 94,12,12,0

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
           if(enemiesTypeC[ii].CurrentAnimation<>'wave') then begin
             enemiesTypeC[ii].SwitchToAnimation('wave',true);
           end; // animation
   end;

   Path := Movement.AddPath;
   //Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeC[ii]);
  Node.Speed := 16.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-5 do begin
     //for i:=(pathlengthEA[0]-15) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       //fMainMenu.Memo1.Lines.Add('ec:'+IntToStr(ii)+'x: '+ IntToStr(x1)+' y1;'+ IntToStr(y1));
       // draw EA trace
       if( {( ((pathlengthEA[0]-1)-i)>=10) and} (x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-4), (y1-4),8,8,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 16.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps
          drawmapblockEA( 98, 98,4,4,0);
    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeC[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeC[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeC[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
    play_HerosAudioTrack(26,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }


       end //  if calc distance >25
         /////////////////////////
         else begin
           if(enemiesTypeC[ii].CurrentAnimation<>'attack') then begin
             enemiesTypeC[ii].SwitchToAnimation('attack',true);
           end; // animation
         end; // else calcdistance

    end // if EA in area

        //-----

        else begin
          killEC(70+ii);
          
         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies
end;

procedure TForm1.killEC(id: byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
  // bug
  for i:=1 to enemC do begin

    if(round(enemiesTypeC[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeC[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeC[i].Position.X);
    Z:=round(enemiesTypeC[i].Position.Z);

    enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeC[i].Visible:=false;

      enemiesTypeC[i].TagFloat:=0;

    enemiesTypeC[i].Position.SetPoint(-5000,0,-5000);
    //dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;
    end; // if exact

  end;
end;

procedure TForm1.swapECTrace;
var
  i,oldX,oldZ,newX,newZ: Integer;
begin
  //  bugs
  // set enemy position dynamic
  for i:=1 to enemC do begin

       if (enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).fired) then begin


    oldX:=enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
    oldZ:=enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
    newX:=round(enemiesTypeC[i].Position.X);
    newZ:=round(enemiesTypeC[i].Position.Z);
    if((oldX<>newX)or(oldZ<>newZ)) then begin
      enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
      enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
      terrObs[oldX, oldZ].itemId:=0;
      terrObs[newX, newZ].itemId:=52;
    end; // if

       end;

  end; // for
end;

procedure TForm1.proceedECFireDistance;
var
  i,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
  for i:=1 to enemC do begin

  if(enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeC[i].Position.X);
    enemyY:=round(enemiesTypeC[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=8) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            if not(enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
              enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
            end;

            enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
              //enemiesTypeC[i].Interval:=100;
          end;

      if not(enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeC[i]);
        Movement.OnPathTravelStop := EnemyCPathTravelStop;
        Movement.ClearPaths;

        if(enemiesTypeC[i].CurrentAnimation<>'attack') then begin
          enemiesTypeC[i].SwitchToAnimation('attack',true);



        end; // if animation
      end; // at fire dist
    end // if
    else begin
      //---------------------
      {
      for j :=1 to 5 do begin
      enemiesTypeB_fireconv[i][j].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j))) then
        Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j)).Free;
      end; // for
       }
      //---------------------
        //enemiesTypeC[i].Interval:=150;
      enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 15


   end; // if alive
  end; // for
end;

function TForm1.CalcECRollAngle(tarX, tarY, EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
    //-------------------------------------
  A:=(tarY-round(enemiesTypeC[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeC[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeC[EA_i].Position.X) ) then begin
      result:= 0;
      //ShowMessage('-270');
      Label3.Caption:=IntToStr(-270);
      exit;
    end
    else
    begin
      result:= 180;
      //ShowMessage('-90');
      Label3.Caption:=IntToStr(-90);
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeC[EA_i].Position.Z) ) then begin
      result:=90;
      //ShowMessage('0');
      Label3.Caption:=IntToStr(0);
      exit;
    end
    else
    begin
      result:=-90;
      //ShowMessage('-180');
      Label3.Caption:=IntToStr(-180);
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  if((A<>0)and(B<>0)) then begin
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg))) + 90;//+ 45;//+90;

  if(tarX > enemiesTypeC[EA_i].Position.X ) then begin
    m:=m+180; //+180
  end;
    result:=(m + 90);
  end; // if not null
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Memo1.Lines.Clear;
  enemiesTypeD[1].RollAngle:=ScrollBar1.Position;
  Memo1.Lines.add(IntToStr(ScrollBar1.Position));
end;

procedure TForm1.fightEC(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;
begin
  // MH fight against EA
    {Life type is Smallint -32768..32767}
  for i:=1 to enemC do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeC[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeC[i].CurrentAnimation<>'pain') then begin
          oldAnimation:=enemiesTypeC[i].CurrentAnimation;
          enemiesTypeC[i].SwitchToAnimation('pain',true);
          play_HerosAudioTrack(28,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathEC(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathEC(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeC[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies
end;

procedure TForm1.deathEC(ix: Integer);
var
  Movement:TGLMovement;
begin
  enemyInfo(enemiesTypeC[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
  enemyInfo(enemiesTypeC[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

      Movement   := GetOrCreateMovement(enemiesTypeC[ix]);
      Movement.StopPathTravel;
      Movement.ClearPaths;

  // big explosion before
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
    ECExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    ECChainExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    ECChainExplodePrepare(ix,'death');
  end;

   // calc MH Experience
   calcMHExperience(fMainMenu.ECBaseLife);
   play_HerosAudioTrack(29,fMainMenu.global_game_volume_level,true,false);

   if(enemiesTypeC[ix].CurrentAnimation<>'crdeath') then begin

   enemiesTypeC[ix].SwitchToAnimation('crdeath',true);

   // get some of FCamHeight down
   enemiesTypeC[ix].Position.Y:=(enemiesTypeC[ix].Position.Y - 1);
   enemyInfo(enemiesTypeC[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;
   enemiesTypeC[ix].Material.BlendingMode:=bmTransparency;
   end; // animation switch

end;

procedure TForm1.ECExplodePrepare(ec_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  //
  fx_id:=enemiesTypeC[ec_index].Effects.IndexOfName('ECExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeC[ec_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('ECExplodeA')) then
    Form1.FindComponent('ECExplodeA').Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='ECExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeC[ec_index].Effects);
  MHBeforeStrikeFire.Name:='ECExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeC[ec_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='ECExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeC[ec_index].Effects);
  MHBeforeStrikeFire.Name:='ECExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeC[ec_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.proceedDeathEC;
var
  i, EC_alpha:Integer;
begin
    // death EA body transperancy control must be in timer=1000 ms
    for i:= 1 to enemC do begin
      if (enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then  begin
        EC_alpha:=round(enemiesTypeC[i].Material.FrontProperties.Diffuse.Alpha*10);
        if (enemiesTypeC[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);
          dec(EC_alpha);
          enemiesTypeC[i].Material.FrontProperties.Diffuse.Alpha:=(EC_alpha / 10);
        end // if Alpha >0
        else
        begin
          enemyInfo(enemiesTypeC[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeEC(i);
        end;
      end; // if trancperancy process is needed
    end; // for all enemies
end;

procedure TForm1.removeEC(ix: byte);
var
  X,Z:Integer;
  Movement: TGLMovement;
begin
  // same as killEC
  Movement   := GetOrCreateMovement(enemiesTypeC[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeC[ix].Position.X);
    Z:=round(enemiesTypeC[ix].Position.Z);

    enemyInfo(enemiesTypeC[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeC[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeC[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeC[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeC[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeC[ix].AnimationMode:=aamLoop;
    enemiesTypeC[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeC[ix].TagFloat:=0;

    enemiesTypeC[ix].Position.SetPoint(-5000,0,-5000);

    terrObs[X, Z].itemId:=0;
end;

function TForm1.CalcEDRollAngle(tarX, tarY, EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
  //
     //-------------------------------------
  A:=(tarY-round(enemiesTypeD[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeD[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeD[EA_i].Position.X) ) then begin
      result:= 0;
      //ShowMessage('-270');
      Label3.Caption:=IntToStr(-270);
      exit;
    end
    else
    begin
      result:= 180;
      //ShowMessage('-90');
      Label3.Caption:=IntToStr(-90);
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeD[EA_i].Position.Z) ) then begin
      result:=90;
      //ShowMessage('0');
      Label3.Caption:=IntToStr(0);
      exit;
    end
    else
    begin
      result:=-90;
      //ShowMessage('-180');
      Label3.Caption:=IntToStr(-180);
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  if((A<>0)and(B<>0)) then begin
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg))) + 90;//+ 45;//+90;

  if(tarX > enemiesTypeD[EA_i].Position.X ) then begin
    m:=m+180; //+180
  end;
    result:=(m + 90);
  end; // if not null
end;

function TForm1.CalcEERollAngle(tarX, tarY, EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
       //-------------------------------------
  A:=(tarY-round(enemiesTypeE[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeE[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeE[EA_i].Position.X) ) then begin
      result:= 0;
      //ShowMessage('-270');
      Label3.Caption:=IntToStr(-270);
      exit;
    end
    else
    begin
      result:= 180;
      //ShowMessage('-90');
      Label3.Caption:=IntToStr(-90);
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeE[EA_i].Position.Z) ) then begin
      result:=90;
      //ShowMessage('0');
      Label3.Caption:=IntToStr(0);
      exit;
    end
    else
    begin
      result:=-90;
      //ShowMessage('-180');
      Label3.Caption:=IntToStr(-180);
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  if((A<>0)and(B<>0)) then begin
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg))) + 90;//+ 45;//+90;

  if(tarX > enemiesTypeE[EA_i].Position.X ) then begin
    m:=m+180; //+180
  end;
    result:=(m + 90);
  end; // if not null
end;

function TForm1.CalcEFRollAngle(tarX, tarY, EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
  //-------------------------------------
  A:=(tarY-round(enemiesTypeF[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeF[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeF[EA_i].Position.X) ) then begin
      result:= 0;
      //ShowMessage('-270');
      Label3.Caption:=IntToStr(-270);
      exit;
    end
    else
    begin
      result:= 180;
      //ShowMessage('-90');
      Label3.Caption:=IntToStr(-90);
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeF[EA_i].Position.Z) ) then begin
      result:=90;
      //ShowMessage('0');
      Label3.Caption:=IntToStr(0);
      exit;
    end
    else
    begin
      result:=-90;
      //ShowMessage('-180');
      Label3.Caption:=IntToStr(-180);
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  if((A<>0)and(B<>0)) then begin
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg))) + 90;//+ 45;//+90;

  if(tarX > enemiesTypeF[EA_i].Position.X ) then begin
    m:=m+180; //+180
  end;
    result:=(m + 90);
  end; // if not null
end;

function TForm1.CalcEGRollAngle(tarX, tarY, EA_i: integer): Integer;
var
  m,A,B:Integer;
  alphaTg:real;
begin
  //-------------------------------------
  A:=(tarY-round(enemiesTypeG[EA_i].Position.Z));
  B:=(tarX-round(enemiesTypeG[EA_i].Position.X));

  if(A=0) then begin
    if(tarX >= round(enemiesTypeG[EA_i].Position.X) ) then begin
      result:= 0;
      //ShowMessage('-270');
      Label3.Caption:=IntToStr(-270);
      exit;
    end
    else
    begin
      result:= 180;
      //ShowMessage('-90');
      Label3.Caption:=IntToStr(-90);
      exit;
    end;
  end; // if A = 0

  if(B=0) then begin
    if(tarY >= round(enemiesTypeG[EA_i].Position.Z) ) then begin
      result:=90;
      //ShowMessage('0');
      Label3.Caption:=IntToStr(0);
      exit;
    end
    else
    begin
      result:=-90;
      //ShowMessage('-180');
      Label3.Caption:=IntToStr(-180);
      exit;
    end;
  end; // if B = 0

  //-------------------------------------

  if((A<>0)and(B<>0)) then begin
  alphaTg:=(A / B);

  m:=round(RadToDeg(ArcTan(alphaTg))) + 90;//+ 45;//+90;

  if(tarX > enemiesTypeG[EA_i].Position.X ) then begin
    m:=m+180; //+180
  end;
    result:=(m + 90);
  end; // if not null
end;

procedure TForm1.ProcessEDComplexPathfinding(spX, spZ: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
  // insect pathfinding

   // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemD do begin

   if (enemyInfo(enemiesTypeD[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeD[ii].Position.X);
   centerY:=round(enemiesTypeD[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeD[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

     if(calcDistance(centerX,centerY,MH_centerX,MH_centerY)>8) then begin

   Movement   := GetOrCreateMovement(enemiesTypeD[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyDPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;


   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
          // clear MH terrain position
          // drawmapblockEA( 96, 96,10,10,0);  // 94, 94,12,12,0

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
           if(enemiesTypeD[ii].CurrentAnimation<>'bpoint') then begin
             enemiesTypeD[ii].SwitchToAnimation('bpoint',true);
           end; // animation
   end;

   Path := Movement.AddPath;
   //Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeD[ii]);
  Node.Speed := 16.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-5 do begin
     //for i:=(pathlengthEA[0]-15) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       //fMainMenu.Memo1.Lines.Add('ec:'+IntToStr(ii)+'x: '+ IntToStr(x1)+' y1;'+ IntToStr(y1));
       // draw EA trace
       if( {( ((pathlengthEA[0]-1)-i)>=10) and} (x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-4), (y1-4),8,8,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 16.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps
          drawmapblockEA( 98, 98,4,4,0);
    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeD[ii].CurrentAnimation<>'brun') then begin
            enemyInfo(enemiesTypeD[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeD[ii].SwitchToAnimation('brun',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
    play_HerosAudioTrack(31,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }


       end //  if calc distance >25
         /////////////////////////
         else begin
           if(enemiesTypeD[ii].CurrentAnimation<>'btaunt') then begin
             enemiesTypeD[ii].SwitchToAnimation('btaunt',true);
           end; // animation
         end; // else calcdistance

    end // if EA in area

        //-----

        else begin
          killED(80+ii);
          
         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies
end;

procedure TForm1.killED(id: byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
  // insect
  for i:=1 to enemD do begin

    if(round(enemiesTypeD[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeD[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeD[i].Position.X);
    Z:=round(enemiesTypeD[i].Position.Z);

    enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeD[i].Visible:=false;

      enemiesTypeD[i].TagFloat:=0;

    enemiesTypeD[i].Position.SetPoint(-5000,0,-5000);
    //dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;
    end; // if exact

  end;
end;

procedure TForm1.swapEDTrace;
var
  i,oldX,oldZ,newX,newZ: Integer;
begin
  //  insect
  // set enemy position dynamic
  for i:=1 to enemD do begin

       if (enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).fired) then begin


    oldX:=enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
    oldZ:=enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
    newX:=round(enemiesTypeD[i].Position.X);
    newZ:=round(enemiesTypeD[i].Position.Z);
    if((oldX<>newX)or(oldZ<>newZ)) then begin
      enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
      enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
      terrObs[oldX, oldZ].itemId:=0;
      terrObs[newX, newZ].itemId:=53;
    end; // if

       end;

  end; // for
end;

procedure TForm1.proceedEDFireDistance;
var
  i,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
   for i:=1 to enemD do begin

  if(enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeD[i].Position.X);
    enemyY:=round(enemiesTypeD[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=8) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            if not(enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
              enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
            end;

            enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
              enemiesTypeD[i].Interval:=80;
          end;

      if not(enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeD[i]);
        Movement.OnPathTravelStop := EnemyDPathTravelStop;
        Movement.ClearPaths;

        if(enemiesTypeD[i].CurrentAnimation<>'btaunt') then begin
          enemiesTypeD[i].SwitchToAnimation('btaunt',true);



        end; // if animation
      end; // at fire dist
    end // if
    else begin
      //---------------------
      {
      for j :=1 to 5 do begin
      enemiesTypeB_fireconv[i][j].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j))) then
        Form1.FindComponent('GLEBFireBall' + IntToStr(i) + IntToStr(j)).Free;
      end; // for
       }
      //---------------------
        enemiesTypeD[i].Interval:=140;
      enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 15


   end; // if alive
  end; // for
end;

procedure TForm1.ECfightMH(ec_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin
   if((Actor1.CurrentAnimation <> 'pain3')and(Actor1.CurrentFrame <> 182)) then begin
     Actor1.CurrentFrame:=182;
     play_HerosAudioTrack(27,fMainMenu.global_game_volume_level,true,false);
     play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
   end; // animation switch

   // fight the enemy
  oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

  if(oldMHLife > 0) then begin
    EADamage := calcEnemyToMHDamage('bug_bait');
    if (oldMHLife <= EADamage) then begin
      killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

    end
    else begin
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
    end;
   end
   else begin
     killMH;
   end;
end;

procedure TForm1.EDfightMH(ed_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin
   if((Actor1.CurrentAnimation <> 'pain3')and(Actor1.CurrentFrame <> 182)) then begin
     Actor1.CurrentFrame:=182;
     play_HerosAudioTrack(32,fMainMenu.global_game_volume_level,true,false);
     play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
   end; // animation switch
   // fight the enemy
  oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

  if(oldMHLife > 0) then begin
    EADamage := calcEnemyToMHDamage('insect_bait');
    if (oldMHLife <= EADamage) then begin
      killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

    end
    else begin
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
    end;
   end
   else begin
     killMH;
   end;
end;

procedure TForm1.proceedDeathED;
var
  i, ED_alpha:Integer;
begin
  // death ED body transperancy control must be in timer=1000 ms
    for i:= 1 to enemD do begin
      if (enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then  begin
        ED_alpha:=round(enemiesTypeD[i].Material.FrontProperties.Diffuse.Alpha*10);
        if (enemiesTypeD[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);
          dec(ED_alpha);
          enemiesTypeD[i].Material.FrontProperties.Diffuse.Alpha:=(ED_alpha / 10);
        end // if Alpha >0
        else
        begin
          enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeED(i);
        end;
      end; // if trancperancy process is needed
    end; // for all enemies
end;

procedure TForm1.removeED(ix: byte);
var
  X,Z:Integer;
  Movement: TGLMovement;
begin
  // same as killED
  Movement   := GetOrCreateMovement(enemiesTypeD[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeD[ix].Position.X);
    Z:=round(enemiesTypeD[ix].Position.Z);

    enemyInfo(enemiesTypeD[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeD[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeD[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeD[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeD[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeD[ix].AnimationMode:=aamLoop;
    enemiesTypeD[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeD[ix].TagFloat:=0;

    enemiesTypeD[ix].Position.SetPoint(-5000,0,-5000);

    terrObs[X, Z].itemId:=0;
end;

procedure TForm1.fightED(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;
begin
  // MH fight against ED
    {Life type is Smallint -32768..32767}
  for i:=1 to enemD do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeD[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeD[i].CurrentAnimation<>'bpain1') then begin
          oldAnimation:=enemiesTypeD[i].CurrentAnimation;
          enemiesTypeD[i].SwitchToAnimation('bpain1',true);
          play_HerosAudioTrack(33,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathED(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeD[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathED(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeD[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies
end;

procedure TForm1.deathED(ix: Integer);
var
  Movement:TGLMovement;
begin
  enemyInfo(enemiesTypeD[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
  enemyInfo(enemiesTypeD[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

      Movement   := GetOrCreateMovement(enemiesTypeD[ix]);
      Movement.StopPathTravel;
      Movement.ClearPaths;

  // big explosion before
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
    EDExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    EDChainExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    EDChainExplodePrepare(ix,'death');
  end;
   // calc MH Experience
   calcMHExperience(fMainMenu.EDBaseLife);
   play_HerosAudioTrack(34,fMainMenu.global_game_volume_level,true,false);

   if(enemiesTypeD[ix].CurrentAnimation<>'bdeath3') then begin

   enemiesTypeD[ix].SwitchToAnimation('bdeath3',true);

   // get some of FCamHeight down
   enemiesTypeD[ix].Position.Y:=(enemiesTypeD[ix].Position.Y - 1);
   enemyInfo(enemiesTypeD[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;
   enemiesTypeD[ix].Material.BlendingMode:=bmTransparency;
   end; // animation switch
end;

procedure TForm1.EDExplodePrepare(ed_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  //
  fx_id:=enemiesTypeD[ed_index].Effects.IndexOfName('EDExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeD[ed_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EDExplodeA')) then
    Form1.FindComponent('EDExplodeA').Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EDExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeD[ed_index].Effects);
  MHBeforeStrikeFire.Name:='EDExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeD[ed_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EDExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeD[ed_index].Effects);
  MHBeforeStrikeFire.Name:='ECExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeD[ed_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.ProcessEEComplexPathfinding(spX, spZ: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
  // frog pathfinding

   // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemE do begin

   if (enemyInfo(enemiesTypeE[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeE[ii].Position.X);
   centerY:=round(enemiesTypeE[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeE[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

     if(calcDistance(centerX,centerY,MH_centerX,MH_centerY)>35) then begin

   Movement   := GetOrCreateMovement(enemiesTypeE[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyEPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;


   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;

   Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeE[ii]);
  Node.Speed := 26.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 26.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeE[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeE[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeE[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
     play_HerosAudioTrack(36,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }


       end //  if calc distance >25
         /////////////////////////
         else begin
           if(enemiesTypeE[ii].CurrentAnimation<>'crdeath') then begin
             enemiesTypeE[ii].SwitchToAnimation('crdeath',true);
           end; // animation
         end; // else calcdistance

    end // if EA in area

        //-----

        else begin
          killEE(90+ii);
          
         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies
end;

procedure TForm1.killEE(id: byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
  // frog
  for i:=1 to enemE do begin

    if(round(enemiesTypeE[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeE[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeE[i].Position.X);
    Z:=round(enemiesTypeE[i].Position.Z);

    enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeE[i].Visible:=false;

      enemiesTypeE[i].TagFloat:=0;

    enemiesTypeE[i].Position.SetPoint(-5000,0,-5000);
    //dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;
    end; // if exact

  end;
end;

procedure TForm1.swapEETrace;
var
  i,oldX,oldZ,newX,newZ: Integer;
begin
  //  frog
  // set enemy position dynamic
  for i:=1 to enemE do begin

       if (enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).fired) then begin


    oldX:=enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
    oldZ:=enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
    newX:=round(enemiesTypeE[i].Position.X);
    newZ:=round(enemiesTypeE[i].Position.Z);
    if((oldX<>newX)or(oldZ<>newZ)) then begin
      enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
      enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
      terrObs[oldX, oldZ].itemId:=0;
      terrObs[newX, newZ].itemId:=54;
    end; // if

       end;

  end; // for
end;

procedure TForm1.proceedEEFireDistance;
var
  i,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
   for i:=1 to enemE do begin

  if(enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeE[i].Position.X);
    enemyY:=round(enemiesTypeE[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=35) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            if not(enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
              enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=0;
            end;

            enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
              enemiesTypeE[i].Interval:=120;
          end;

      if not(enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeE[i]);
        Movement.OnPathTravelStop := EnemyEPathTravelStop;
        Movement.ClearPaths;

        if(enemiesTypeE[i].CurrentAnimation<>'crdeath') then begin
          enemiesTypeE[i].SwitchToAnimation('crdeath',true);



        end; // if animation
      end; // at fire dist
    end // if
    else begin
      //---------------------


      enemiesTypeE_core[i].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEEAcidBall' + IntToStr(i))) then
        Form1.FindComponent('GLEEAcidBall' + IntToStr(i)).Free;


      //---------------------
        enemiesTypeE[i].Interval:=140;
      enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 15


   end; // if alive
  end; // for
end;

procedure TForm1.EEfightMH(ee_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin

     // fight the enemy
  oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

  if(oldMHLife > 0) then begin
    EADamage := calcEnemyToMHDamage('acid_ball');
    if (oldMHLife <= EADamage) then begin
      killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

    end
    else begin
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
    end;
   end
   else begin
     killMH;
   end;
end;

procedure TForm1.proceedDeathEE;
var
  i, EE_alpha:Integer;
begin
    // death ED body transperancy control must be in timer=1000 ms
    for i:= 1 to enemE do begin
      if (enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then  begin
        EE_alpha:=round(enemiesTypeE[i].Material.FrontProperties.Diffuse.Alpha*10);
        if (enemiesTypeE[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);
          dec(EE_alpha);
          enemiesTypeE[i].Material.FrontProperties.Diffuse.Alpha:=(EE_alpha / 10);
        end // if Alpha >0
        else
        begin
          enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeEE(i);
        end;
      end; // if trancperancy process is needed
    end; // for all enemies
end;

procedure TForm1.removeEE(ix: byte);
var
  X,Z:Integer;
  Movement: TGLMovement;
begin
    // same as killED
  Movement   := GetOrCreateMovement(enemiesTypeE[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeE[ix].Position.X);
    Z:=round(enemiesTypeE[ix].Position.Z);

    enemyInfo(enemiesTypeE[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeE[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeE[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeE[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeE[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeE[ix].AnimationMode:=aamLoop;
    enemiesTypeE[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeE[ix].TagFloat:=0;

    enemiesTypeE[ix].Position.SetPoint(-5000,0,-5000);

    terrObs[X, Z].itemId:=0;
end;

procedure TForm1.fightEE(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;
begin
    // MH fight against ED
    {Life type is Smallint -32768..32767}
  for i:=1 to enemE do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeE[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeE[i].CurrentAnimation<>'bpain1') then begin
          oldAnimation:=enemiesTypeE[i].CurrentAnimation;
          enemiesTypeE[i].SwitchToAnimation('bpain1',true);
          play_HerosAudioTrack(38,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathEE(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeE[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathEE(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeE[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies
end;

procedure TForm1.deathEE(ix: Integer);
begin
  enemyInfo(enemiesTypeE[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
  enemyInfo(enemiesTypeE[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

  // recall AcidBall
  EEAcidBallRecall(ix);

  // big explosion before
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
    EEExplodePrepare(ix,'death');
  end;
  
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    EEChainExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    EEChainExplodePrepare(ix,'death');
  end;

   // calc MH Experience
   calcMHExperience(fMainMenu.EEBaseLife);
   play_HerosAudioTrack(39,fMainMenu.global_game_volume_level,true,false);

   if(enemiesTypeE[ix].CurrentAnimation<>'death2') then begin

   enemiesTypeE[ix].SwitchToAnimation('death2',true);

   // get some of FCamHeight down
   enemiesTypeE[ix].Position.Y:=(enemiesTypeE[ix].Position.Y - 5);
   enemyInfo(enemiesTypeE[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;
   enemiesTypeE[ix].Material.BlendingMode:=bmTransparency;
   end; // animation switch
end;

procedure TForm1.EEExplodePrepare(ee_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeE[ee_index].Effects.IndexOfName('EEExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeE[ee_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EEExplodeA')) then
    Form1.FindComponent('EEExplodeA').Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EEExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeE[ee_index].Effects);
  MHBeforeStrikeFire.Name:='EEExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeE[ee_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EEExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeE[ee_index].Effects);
  MHBeforeStrikeFire.Name:='EEExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeE[ee_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EEAcidBallStrike(ee_index: Integer);
begin
  //  acid ball attack of EE frog
 // if (enemyInfo(enemiesTypeE[ee_index].Behaviours.GetByClass(enemyInfo)).strikePeriod=1) then begin
    EEAcidBallThrow(ee_index);
 //   enemyInfo(enemiesTypeE[ee_index].Behaviours.GetByClass(enemyInfo)).strikePeriod:=2;
 //   Exit;
 // end; // if strike=1

  {if (enemyInfo(enemiesTypeE[ee_index].Behaviours.GetByClass(enemyInfo)).strikePeriod=2) then begin
    EEAcidBallRecall(ee_index);
    enemyInfo(enemiesTypeE[ee_index].Behaviours.GetByClass(enemyInfo)).strikePeriod:=1;
  end; }
end;

procedure TForm1.EEAcidBallRecall(ee_index: Integer);
begin
  enemiesTypeE_core[ee_index].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEEAcidBall' + IntToStr(ee_index))) then
    Form1.FindComponent('GLEEAcidBall' + IntToStr(ee_index)).Free;

   // enemiesTypeE_core[ee_index].Tag:=0;

    with enemiesTypeE_core[ee_index].Position do begin
     X := enemiesTypeE[ee_index].Position.X;
     Z := enemiesTypeE[ee_index].Position.Z;
     Y:=TerrainRenderer1.InterpolatedHeight(AsVector) + 6;

     end;
end;

procedure TForm1.EEAcidBallThrow(ee_index: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;

  MH_centerX,MH_centerY,ranX,ranY:Integer;
begin
  if(enemiesTypeE_core[ee_index].Tag=1) then begin
    EEAcidBallRecall(ee_index);
    enemiesTypeE_core[ee_index].Tag:=0;
  end; // if

      Randomize;
    ranX:=RandomRange(1,3);
    ranY:=RandomRange(1,3);



    MH_centerX:=round(DCMainHero.Position.X);
    MH_centerY:=round(DCMainHero.Position.Z);

  //  EBFireBallPrepare(eb_index, idx);

   Movement   := GetOrCreateMovement(enemiesTypeE_core[ee_index]);
   Movement.Name:=(IntToStr(ee_index) + '#' + 'EE');
   Movement.OnPathTravelStop := EnemyEAcidBallStop; //coreBPathTravelStop;
  Movement.ClearPaths;
  Movement.StopPathTravel;
  //Movement.OnPathTravelStop := EnemyBFireBallStop;
  EEAcidBallPrepare(ee_index);

  Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeE_core[ee_index]);
  Node.Speed := 50.0;  //50

    Node       := Path.AddNode;
    Node.Speed := 50.0;

    Node.PositionAsVector := VectorMake((MH_centerX+ranX),
       TerrainRenderer1.InterpolatedHeight(VectorMake((MH_centerX+ranX), 0, (MH_centerY+ranY))) + FCamHeight + 5,
       (MH_centerY+ranY));
    Node.RotationAsVector := VectorMake(0, 0, 0);

  //Activatived the current path
  Movement.ActivePathIndex := 0;
    play_HerosAudioTrack(37,fMainMenu.global_game_volume_level,true,false);
  Movement.StartPathTravel;

  Randomize;
  enemiesTypeE[ee_index].CurrentFrame:=RandomRange(173,176);

end;

procedure TForm1.EEAcidBallPrepare(ee_index: Integer);
var
  GLEBFireBall:TGLFireFXManager;
  EBGLExplodeFire:TGLBFireFX;
begin
   enemiesTypeE_core[ee_index].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEEAcidBall' + IntToStr(ee_index))) then
    Form1.FindComponent('GLEEAcidBall' + IntToStr(ee_index)).Free;

  // prepare strike event animation
  GLEBFireBall:=TGLFireFXManager.Create(self);
  GLEBFireBall.Name:='GLEEAcidBall' + IntToStr(ee_index);
  GLEBFireBall.Cadencer:=GLCadencer1;
  // params
  GLEBFireBall.FireBurst:=2;
  GLEBFireBall.FireCrown:=0.5;
  GLEBFireBall.FireDensity:=4;

  GLEBFireBall.MaxParticles:=256;

  //GLMHExplodeA.NoZWrite:=false;

  GLEBFireBall.InnerColor.Alpha:=1;
  GLEBFireBall.InnerColor.Red:=0.1;
  GLEBFireBall.InnerColor.Green:=1;
  GLEBFireBall.InnerColor.Blue:=0.1;

  GLEBFireBall.OuterColor.Alpha:=1;
  GLEBFireBall.OuterColor.Red:=0.3;
  GLEBFireBall.OuterColor.Green:=0.6;
  GLEBFireBall.OuterColor.Blue:=0.1;

  {
  GLEBFireBall.FireDir.X:=0;
  GLEBFireBall.FireDir.Y:=0.2;
  GLEBFireBall.FireDir.Z:=0;

  GLEBFireBall.InitialDir.X:=0;
  GLEBFireBall.InitialDir.Y:=5;
  GLEBFireBall.InitialDir.Z:=0;
  }

  GLEBFireBall.ParticleInterval:=0.01;
  GLEBFireBall.ParticleLife:=3;
  GLEBFireBall.ParticleSize:=1;


  GLEBFireBall.FireRadius:=0.5;

  GLEBFireBall.Paused:=false;
  GLEBFireBall.UseInterval:=true;

  EBGLExplodeFire:= TGLBFireFX.Create(enemiesTypeE_core[ee_index].Effects);
  EBGLExplodeFire.Manager:=GLEBFireBall;
  enemiesTypeE_core[ee_index].Effects.Add(EBGLExplodeFire);
end;

procedure TForm1.EnemyEAcidBallStop(Sender: TObject; Path: TGLMovementPath;
  var Looped: Boolean);
var
  input:String;
  ee_index:Integer;
begin
   if((Actor1.CurrentAnimation <> 'pain3')and(Actor1.CurrentFrame <> 182)) then begin
     Actor1.CurrentFrame:=182;
     play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
   end; // animation switch

  input:=(Sender as TGLMovement).Name;
  ee_index:=StrToInt(Copy(input,1,Pos('#',input)-1));

  if Assigned(Form1.FindComponent('GLEEAcidBall' + IntToStr(ee_index))) then begin
    with TGLFireFXManager(Form1.FindComponent('GLEEAcidBall' + IntToStr(ee_index))) do begin

      RingExplosion(8, 10, 10, XVector, ZVector); {8,10,1}
    end; // with
  end; // if

  enemiesTypeE_core[ee_index].Tag:=1;
end;

procedure TForm1.MHLaserExplodePrepare;
var
  GLMHExplodeA:TGLFireFXManager;
  MHGLExplodeFireA:TGLBFireFX;
    fx_id:Integer;
begin
  // after frog attack
  // explode FX

  fx_id:=Actor1.Effects.IndexOfName('MHLaserExplodeAEffect');
  if(fx_id <> -1) then
    Actor1.Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('MHLaserExplodeA')) then
    Form1.FindComponent('MHLaserExplodeA').Free;

  // prepare strike event animation
  GLMHExplodeA:=TGLFireFXManager.Create(self);
  GLMHExplodeA.Name:='MHLaserExplodeA';
  GLMHExplodeA.Cadencer:=GLCadencer1;
  // params
  GLMHExplodeA.FireBurst:=5;
  GLMHExplodeA.FireCrown:=1;
  GLMHExplodeA.FireDensity:=10;

  GLMHExplodeA.MaxParticles:=1024;

  //GLMHExplodeA.NoZWrite:=false;

  GLMHExplodeA.InnerColor.Alpha:=1;
  GLMHExplodeA.InnerColor.Red:=0.8;
  GLMHExplodeA.InnerColor.Green:=0.3;
  GLMHExplodeA.InnerColor.Blue:=0.3;

  GLMHExplodeA.OuterColor.Alpha:=1;
  GLMHExplodeA.InnerColor.Red:=0.5;
  GLMHExplodeA.InnerColor.Green:=0.1;
  GLMHExplodeA.InnerColor.Blue:=0.3;

  GLMHExplodeA.FireDir.X:=0;
  GLMHExplodeA.FireDir.Y:=0.2;
  GLMHExplodeA.FireDir.Z:=0;

  GLMHExplodeA.InitialDir.X:=0;
  GLMHExplodeA.InitialDir.Y:=5;
  GLMHExplodeA.InitialDir.Z:=0;

  GLMHExplodeA.ParticleInterval:=0.01;
  GLMHExplodeA.ParticleLife:=3;
  GLMHExplodeA.ParticleSize:=15;


  GLMHExplodeA.FireRadius:=5;

  GLMHExplodeA.Paused:=false;
  GLMHExplodeA.UseInterval:=true;

  MHGLExplodeFireA:= TGLBFireFX.Create(Actor1.Effects);
    MHGLExplodeFireA.Name:='MHLaserExplodeAEffect';
  MHGLExplodeFireA.Manager:=GLMHExplodeA;
  Actor1.Effects.Add(MHGLExplodeFireA);

      //GLMHExplodeA.IsotropicExplosion(8,10,1);
  GLMHExplodeA.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLMHExplodeA.Disabled:=True;
end;

procedure TForm1.ProcessEFComplexPathfinding(spX, spZ: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
  // drio pathfinding
  // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemF do begin

   if (enemyInfo(enemiesTypeF[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeF[ii].Position.X);
   centerY:=round(enemiesTypeF[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeF[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

     if(calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25) then begin

   Movement   := GetOrCreateMovement(enemiesTypeF[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyFPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;


   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
     if(enemiesTypeF[ii].CurrentAnimation<>'Flip') then begin
       enemiesTypeF[ii].SwitchToAnimation('Flip',true);
     end; // animation
   end;

   Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeF[ii]);
  Node.Speed := 26.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 26.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeF[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeF[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeF[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
     play_HerosAudioTrack(41,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }


       end //  if calc distance >25
         /////////////////////////
         else begin
           if(enemiesTypeF[ii].CurrentAnimation<>'crattack') then begin
             enemiesTypeF[ii].SwitchToAnimation('crattack',true);
           end; // animation
         end; // else calcdistance

    end // if EA in area

        //-----

        else begin
          killEF(100+ii);
          
         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies
end;

procedure TForm1.killEF(id: byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
  // frog
  for i:=1 to enemF do begin

    if(round(enemiesTypeF[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeF[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeF[i].Position.X);
    Z:=round(enemiesTypeF[i].Position.Z);

    enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeF[i].Visible:=false;

      enemiesTypeF[i].TagFloat:=0;

    enemiesTypeF[i].Position.SetPoint(-5000,0,-5000);
    //dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;
    end; // if exact

  end;
end;

procedure TForm1.swapEFTrace;
var
  i,oldX,oldZ,newX,newZ: Integer;
begin
  //  drio
  // set enemy position dynamic
  for i:=1 to enemF do begin

       if (enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).fired) then begin


    oldX:=enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
    oldZ:=enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
    newX:=round(enemiesTypeF[i].Position.X);
    newZ:=round(enemiesTypeF[i].Position.Z);
    if((oldX<>newX)or(oldZ<>newZ)) then begin
      enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
      enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
      terrObs[oldX, oldZ].itemId:=0;
      terrObs[newX, newZ].itemId:=55;
    end; // if

       end;

  end; // for
end;

procedure TForm1.proceedEFFireDistance;
var
  i,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
   for i:=1 to enemF do begin

  if(enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeF[i].Position.X);
    enemyY:=round(enemiesTypeF[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=25) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            if not(enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
              enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=0;
            end;

            enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
              enemiesTypeF[i].Interval:=120;
          end;

      if not(enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeF[i]);
        Movement.OnPathTravelStop := EnemyFPathTravelStop;
        Movement.ClearPaths;

        if(enemiesTypeF[i].CurrentAnimation<>'crattack') then begin
          enemiesTypeF[i].SwitchToAnimation('crattack',true);



        end; // if animation
      end; // at fire dist
    end // if
    else begin
      //---------------------


      enemiesTypeF_core[i].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEFLaserBall' + IntToStr(i))) then
        Form1.FindComponent('GLEFLaserBall' + IntToStr(i)).Free;


      //---------------------
        enemiesTypeF[i].Interval:=140;
      enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 15


   end; // if alive
  end; // for
end;

procedure TForm1.EFfightMH(ef_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin
       // fight the enemy
  oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

  if(oldMHLife > 0) then begin
    EADamage := calcEnemyToMHDamage('laser_ball');
    if (oldMHLife <= EADamage) then begin
      killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

    end
    else begin
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
    end;
   end
   else begin
     killMH;
   end;
end;

procedure TForm1.proceedDeathEF;
var
  i, EF_alpha:Integer;
begin
      // death ED body transperancy control must be in timer=1000 ms
    for i:= 1 to enemF do begin
      if (enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then  begin
        EF_alpha:=round(enemiesTypeF[i].Material.FrontProperties.Diffuse.Alpha*10);
        if (enemiesTypeF[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);
          dec(EF_alpha);
          enemiesTypeF[i].Material.FrontProperties.Diffuse.Alpha:=(EF_alpha / 10);
        end // if Alpha >0
        else
        begin
          enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeEF(i);
        end;
      end; // if trancperancy process is needed
    end; // for all enemies
end;

procedure TForm1.removeEF(ix: byte);
var
  X,Z:Integer;
  Movement: TGLMovement;
begin
      // same as killEF
  Movement   := GetOrCreateMovement(enemiesTypeF[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeF[ix].Position.X);
    Z:=round(enemiesTypeF[ix].Position.Z);

    enemyInfo(enemiesTypeF[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeF[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeF[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeF[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeF[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeF[ix].AnimationMode:=aamLoop;
    enemiesTypeF[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeF[ix].TagFloat:=0;

    enemiesTypeF[ix].Position.SetPoint(-5000,0,-5000);

    terrObs[X, Z].itemId:=0;
end;

procedure TForm1.fightEF(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;
begin
      // MH fight against ED
    {Life type is Smallint -32768..32767}
  for i:=1 to enemF do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeF[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeF[i].CurrentAnimation<>'pain3') then begin
          oldAnimation:=enemiesTypeF[i].CurrentAnimation;
          enemiesTypeF[i].SwitchToAnimation('pain3',true);
          play_HerosAudioTrack(43,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathEF(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeF[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathEF(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeF[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies
end;

procedure TForm1.deathEF(ix: Integer);
begin
  enemyInfo(enemiesTypeF[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
  enemyInfo(enemiesTypeF[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

  // recall LaserBall
  EFLaserBallRecall(ix);

  // big explosion before
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
    EFExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    EFChainExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    EFChainExplodePrepare(ix,'death');
  end;

   // calc MH Experience
   calcMHExperience(fMainMenu.EFBaseLife);
   play_HerosAudioTrack(44,fMainMenu.global_game_volume_level,true,false);

   if(enemiesTypeF[ix].CurrentAnimation<>'death3') then begin

   enemiesTypeF[ix].SwitchToAnimation('death3',true);

   // get some of FCamHeight down
   enemiesTypeF[ix].Position.Y:=(enemiesTypeF[ix].Position.Y - 1);
   enemyInfo(enemiesTypeF[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;
   enemiesTypeF[ix].Material.BlendingMode:=bmTransparency;
   end; // animation switch
end;

procedure TForm1.EFExplodePrepare(ef_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeF[ef_index].Effects.IndexOfName('EFExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeF[ef_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EFExplodeA')) then
    Form1.FindComponent('EFExplodeA').Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EFExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeF[ef_index].Effects);
  MHBeforeStrikeFire.Name:='EFExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeF[ef_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EFExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeF[ef_index].Effects);
  MHBeforeStrikeFire.Name:='EFExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeF[ef_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EFLaserBallStrike(ef_index: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;

  MH_centerX,MH_centerY:Integer;
begin
  if(enemiesTypeF_core[ef_index].Tag=1) then begin
    EFLaserBallRecall(ef_index);
    enemiesTypeF_core[ef_index].Tag:=0;
  end; // if

   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);

   Movement   := GetOrCreateMovement(enemiesTypeF_core[ef_index]);
   Movement.Name:=(IntToStr(ef_index) + '#' + 'EF');
   Movement.OnPathTravelStop := EnemyFLaserBallStop; //coreBPathTravelStop;
  Movement.ClearPaths;
  Movement.StopPathTravel;

  EFLaserBallPrepare(ef_index);

  Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeF_core[ef_index]);
  Node.Speed := 100.0;  //50

    Node       := Path.AddNode;
    Node.Speed := 50.0;

    Node.PositionAsVector := VectorMake((MH_centerX),
       TerrainRenderer1.InterpolatedHeight(VectorMake((MH_centerX), 0, (MH_centerY))) + FCamHeight + 5,
       (MH_centerY));
    Node.RotationAsVector := VectorMake(0, 0, 0);

  //Activatived the current path
  Movement.ActivePathIndex := 0;
    play_HerosAudioTrack(42,fMainMenu.global_game_volume_level,true,false);
  Movement.StartPathTravel;

  //Randomize;
  //enemiesTypeF[ef_index].CurrentFrame:=RandomRange(173,176);
end;

procedure TForm1.EFLaserBallRecall(ef_index: Integer);
begin
  enemiesTypeF_core[ef_index].Effects.Clear;


  if Assigned(Form1.FindComponent('GLEFLaserBall' + IntToStr(ef_index))) then
    Form1.FindComponent('GLEFLaserBall' + IntToStr(ef_index)).Free;



    with enemiesTypeF_core[ef_index].Position do begin
     X := enemiesTypeF[ef_index].Position.X;
     Z := enemiesTypeF[ef_index].Position.Z;
     Y:=TerrainRenderer1.InterpolatedHeight(AsVector) + 6;

     end;
end;

procedure TForm1.EnemyFLaserBallStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
var
  input:String;
  ef_index:Integer;
begin
   if((Actor1.CurrentAnimation <> 'pain3')and(Actor1.CurrentFrame <> 182)) then begin
     Actor1.CurrentFrame:=182;
     play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
   end; // animation switch

  input:=(Sender as TGLMovement).Name;
  ef_index:=StrToInt(Copy(input,1,Pos('#',input)-1));
  MHLaserExplodePrepare;
  enemiesTypeF_core[ef_index].Tag:=1;
end;

procedure TForm1.EFLaserBallPrepare(ef_index: Integer);
var
  GLEBFireBall:TGLFireFXManager;
  EBGLExplodeFire:TGLBFireFX;
begin
     enemiesTypeF_core[ef_index].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEFLaserBall' + IntToStr(ef_index))) then
    Form1.FindComponent('GLEFLaserBall' + IntToStr(ef_index)).Free;

  // prepare strike event animation
  GLEBFireBall:=TGLFireFXManager.Create(self);
  GLEBFireBall.Name:='GLEFLaserBall' + IntToStr(ef_index);
  GLEBFireBall.Cadencer:=GLCadencer1;
  // params
  GLEBFireBall.FireBurst:=2; //2
  GLEBFireBall.FireCrown:=0.5;  //0.5
  GLEBFireBall.FireDensity:=4; //4

  GLEBFireBall.MaxParticles:=256;

  //GLMHExplodeA.NoZWrite:=false;

  GLEBFireBall.InnerColor.Alpha:=1;
  GLEBFireBall.InnerColor.Red:=1;
  GLEBFireBall.InnerColor.Green:=0.1;
  GLEBFireBall.InnerColor.Blue:=0.1;

  GLEBFireBall.OuterColor.Alpha:=1;
  GLEBFireBall.OuterColor.Red:=0.6;
  GLEBFireBall.OuterColor.Green:=0.1;
  GLEBFireBall.OuterColor.Blue:=0.3;

  {
  GLEBFireBall.FireDir.X:=0;
  GLEBFireBall.FireDir.Y:=0.2;
  GLEBFireBall.FireDir.Z:=0;

  GLEBFireBall.InitialDir.X:=0;
  GLEBFireBall.InitialDir.Y:=5;
  GLEBFireBall.InitialDir.Z:=0;
  }

  GLEBFireBall.ParticleInterval:=0.01;
  GLEBFireBall.ParticleLife:=3;
  GLEBFireBall.ParticleSize:=1; //1


  GLEBFireBall.FireRadius:=0.5; //0.5

  GLEBFireBall.Paused:=false;
  GLEBFireBall.UseInterval:=true;

  EBGLExplodeFire:= TGLBFireFX.Create(enemiesTypeF_core[ef_index].Effects);
  EBGLExplodeFire.Manager:=GLEBFireBall;
  enemiesTypeF_core[ef_index].Effects.Add(EBGLExplodeFire);

  GLEBFireBall.RingExplosion(10, 1, 10, XVector, ZVector);
  //GLEBFireBall.IsotropicExplosion(7, 10, 1);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  GLCadencer1.Enabled:=false;
end;

procedure TForm1.ProcessEGComplexPathfinding(spX, spZ: Integer);
var
  Movement:TGLMovement;
  Path:     TGLMovementPath;
  Node:     TGLPathNode;
  i,ii,
  MH_centerX, MH_centerY, MH_centerX_local, MH_centerY_local,
  x1, y1, centerX, centerY:Integer;
  err:byte;
  EAnoEmptyPath:boolean;
begin
    // okta pathfinding
  // proceed if sp coord <> old sp coord
   MH_centerX:=round(DCMainHero.Position.X);
   MH_centerY:=round(DCMainHero.Position.Z);
   // process All enemies
   for ii:= 1 to enemG do begin

   if (enemyInfo(enemiesTypeG[ii].Behaviours.GetByClass(enemyInfo)).fired) then begin

   centerX:=round(enemiesTypeG[ii].Position.X);
   centerY:=round(enemiesTypeG[ii].Position.Z);



   if( (centerX >= (MH_centerX-99))and(centerX <= (MH_centerX+99))and
       (centerY >= (MH_centerY-99))and(centerY <= (MH_centerY+99))and
      // (calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25)and
       (enemyInfo(enemiesTypeG[ii].Behaviours.GetByClass(enemyInfo)).isAlive) ) then begin

     if(calcDistance(centerX,centerY,MH_centerX,MH_centerY)>25) then begin

   Movement   := GetOrCreateMovement(enemiesTypeG[ii]);
   Movement.Name:=IntToStr(ii);
   Movement.OnPathTravelStop := EnemyGPathTravelStop;



  Movement.ClearPaths;
  Movement.StopPathTravel;

   err:=0;
   EAnoEmptyPath:=false;


   MH_centerX_local:=(centerX)-(MH_centerX-100);
   MH_centerY_local:=(centerY)-(MH_centerY-100);
   /////////////////////////////////////////////
   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,0);
   end;
   /////////////////////////////////////////////

   if( (MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin

  // if (walkability[tgX,tgY]=0) then begin
     err := findpathEA(200,200,MH_centerX_local,MH_centerY_local,100,100); // if=1 ok
    // HudText1.Text:=(IntToStr(err));
   end; // if target is ok

   if((err=2)and(MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
     if(enemiesTypeG[ii].CurrentAnimation<>'jump') then begin
       enemiesTypeG[ii].SwitchToAnimation('jump',true);
     end; // animation
   end;

   Path := Movement.AddPath;
   //  Path.ShowPath := True;


  Node       := Path.AddNodeFromObject(enemiesTypeG[ii]);
  Node.Speed := 26.0;
   //////////////////////////////////////////////////////
   if(err=1) then begin
     for i:=0 to pathlengthEA[0]-15 do begin
     //for i:=(pathlengthEA[0]-12) downto 1   do begin
       x1 := readpathx2EA(0,i);
       y1 := readpathy2EA(0,i);
       // draw EA trace
       if((x1 in [7..193])and(y1 in [7..193])) then begin
         drawmapblockEA( (x1-6), (y1-6),12,12,1);
       end;
       x1:=(x1-100) + MH_centerX;
       y1:=(y1-100) + MH_centerY;

       Node       := Path.AddNode;
    Node.Speed := 26.0;
    //TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1))
    Node.PositionAsVector := VectorMake(x1,TerrainRenderer1.InterpolatedHeight(VectorMake(x1, 0, y1)) , y1);
    Node.RotationAsVector := VectorMake(0, 0, 0);
       EAnoEmptyPath:=true;


     end; // for all steps

    //Activatived the current path
  Movement.ActivePathIndex := 0;
      if (EAnoEmptyPath) then begin
        if(enemiesTypeG[ii].CurrentAnimation<>'run') then begin
            enemyInfo(enemiesTypeG[ii].Behaviours.GetByClass(enemyInfo)).atFireDistance:=false;
          enemiesTypeG[ii].SwitchToAnimation('run',true);
        end; // animation
      end; // no empty path

         { else begin
             killEA(50+ii);
             HUDText2.Text:='EMPTY EA ' + IntToStr(50+ii);
           end; }

   //ShowMessage('EA start' + IntToStr(ii));
   /////////////////////////////////////////////
   if((MH_centerX_local in[7..193]) and (MH_centerY_local in[7..193])) then begin
     drawmapblockEA( (MH_centerX_local-6), (MH_centerY_local-6),12,12,1);
   end;
   /////////////////////////////////////////////
    play_HerosAudioTrack(46,fMainMenu.global_game_volume_level,true,true);
  Movement.StartPathTravel;
  end; // if err=1

          { else begin
             killEA(50+ii);
             HUDText2.Text:='ERROR EA ' + IntToStr(50+ii);
           end;  }


       end //  if calc distance >25
         /////////////////////////
         else begin
           if(enemiesTypeG[ii].CurrentAnimation<>'attack') then begin
             enemiesTypeG[ii].SwitchToAnimation('attack',true);
           end; // animation
         end; // else calcdistance

    end // if EA in area

        //-----

        else begin
          killEG(110+ii);
          
         end;
          //HUDText2.Text:='EA'+HUDText2.Text + IntToStr(ii);
          //dec(EAvisioCount);

    end; // fired
   end; // for all enemies
end;

procedure TForm1.killEG(id: byte);
var
  i,X,Z:Integer;
  Movement: TGLMovement;
begin
    // frog
  for i:=1 to enemG do begin

    if(round(enemiesTypeG[i].TagFloat)=id) then begin

    Movement   := GetOrCreateMovement(enemiesTypeG[i]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    X:=round(enemiesTypeG[i].Position.X);
    Z:=round(enemiesTypeG[i].Position.Z);

    enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeG[i].Visible:=false;

      enemiesTypeG[i].TagFloat:=0;

    enemiesTypeG[i].Position.SetPoint(-5000,0,-5000);
    //dec(EAvisioCount);
    terrObs[X, Z].itemId:=0;
    end; // if exact

  end;
end;

procedure TForm1.swapEGTrace;
var
  i,oldX,oldZ,newX,newZ: Integer;
begin
    //  okta
  // set enemy position dynamic
  for i:=1 to enemG do begin

       if (enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).fired) then begin


    oldX:=enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).oldPositionX;
    oldZ:=enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ;
    newX:=round(enemiesTypeG[i].Position.X);
    newZ:=round(enemiesTypeG[i].Position.Z);
    if((oldX<>newX)or(oldZ<>newZ)) then begin
      enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).oldPositionX:=newX;
      enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).oldPositionZ:=newZ;
      terrObs[oldX, oldZ].itemId:=0;
      terrObs[newX, newZ].itemId:=56;
    end; // if

       end;

  end; // for
end;

procedure TForm1.proceedEGFireDistance;
var
  i,enemyX,enemyY,MHx_coord,MHy_coord,calc_dist:Integer;
  Movement:TGLMovement;
begin
     for i:=1 to enemG do begin

  if(enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

    // get current enemy position
    enemyX:=round(enemiesTypeG[i].Position.X);
    enemyY:=round(enemiesTypeG[i].Position.Z);
    // get current MH position
    MHx_coord:=round(DCMainHero.Position.X);
    MHy_coord:=round(DCMainHero.Position.Z);
    // calc Distance between
    calc_dist:=calcDistance(enemyX,enemyY,MHx_coord,MHy_coord);



    if(calc_dist<=25) then begin
      /// fight main hero
          if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
            //EAfightMH(i);
            if not(enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).goFight) then begin
              enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).strikePeriod:=0;
            end;

            enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).goFight:=true;
              enemiesTypeG[i].Interval:=120;
          end;

      if not(enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).atFireDistance) then begin
        enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).atFireDistance:=true;
        Movement   := GetOrCreateMovement(enemiesTypeG[i]);
        Movement.OnPathTravelStop := EnemyGPathTravelStop;
        Movement.ClearPaths;

        if(enemiesTypeG[i].CurrentAnimation<>'attack') then begin
          enemiesTypeG[i].SwitchToAnimation('attack',true);



        end; // if animation
      end; // at fire dist
    end // if
    else begin
      //---------------------


      enemiesTypeG_core[i].Effects.Clear;
      if Assigned(Form1.FindComponent('GLEGOktaBall' + IntToStr(i))) then
        Form1.FindComponent('GLEGOktaBall' + IntToStr(i)).Free;


      //---------------------
        enemiesTypeG[i].Interval:=140;
      enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).goFight:=false;
    end; // calc_dest > 15


   end; // if alive
  end; // for
end;

procedure TForm1.EGfightMH(eg_index: byte);
var
  oldMHLife, EADamage:Smallint;
begin
         // fight the enemy
  oldMHLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life;

  if(oldMHLife > 0) then begin
    EADamage := calcEnemyToMHDamage('okta_nova');
    if (oldMHLife <= EADamage) then begin
      killMH; { set Life := 0; inside killMH set death animation to 'death1' before kill }

    end
    else begin
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(oldMHLife - EADamage);
    end;
   end
   else begin
     killMH;
   end;
end;

procedure TForm1.proceedDeathEG;
var
  i, EG_alpha:Integer;
begin
   // death ED body transperancy control must be in timer=1000 ms
    for i:= 1 to enemG do begin
      if (enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded) then  begin
        EG_alpha:=round(enemiesTypeG[i].Material.FrontProperties.Diffuse.Alpha*10);
        if (enemiesTypeG[i].Material.FrontProperties.Diffuse.Alpha >0) then begin
          // dec(EA_alpha from 0.8 to 0);
          dec(EG_alpha);
          enemiesTypeG[i].Material.FrontProperties.Diffuse.Alpha:=(EG_alpha / 10);
        end // if Alpha >0
        else
        begin
          enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;
          removeEG(i);
        end;
      end; // if trancperancy process is needed
    end; // for all enemies
end;

procedure TForm1.removeEG(ix: byte);
var
  Movement: TGLMovement;
begin
        // same as killEF
  Movement   := GetOrCreateMovement(enemiesTypeG[ix]);
    Movement.StopPathTravel;
    Movement.ClearPaths;


    //X:=round(enemiesTypeG[ix].Position.X);
    //Z:=round(enemiesTypeG[ix].Position.Z);

    enemyInfo(enemiesTypeG[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
    enemyInfo(enemiesTypeG[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;
    enemiesTypeG[ix].Visible:=false;

    // Restore Alpha
    enemyInfo(enemiesTypeG[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=false;

    enemiesTypeG[ix].Material.BlendingMode:=bmOpaque;
    enemiesTypeG[ix].AnimationMode:=aamLoop;
    enemiesTypeG[ix].Material.FrontProperties.Diffuse.Alpha:=1;

    // set deathAnimationNeeded:=false;

      enemiesTypeG[ix].TagFloat:=0;

    enemiesTypeG[ix].Position.SetPoint(-5000,0,-5000);

    //terrObs[X, Z].itemId:=0;
    
end;

procedure TForm1.fightEG(id: byte);
var
  i:Integer;
  oldAnimation:String;
  oldEnemyLife, MHDamage :Smallint;
begin
        // MH fight against ED
    {Life type is Smallint -32768..32767}
  for i:=1 to enemG do begin

    { if MH attack weapon isnt MASSIVE type - attack single enemy}
    if(true{enemyInfo(DCMainHero.Behaviours.GetByClass(enemyInfo)).attackWeapon='lightning'}) then begin

    if(round(enemiesTypeG[i].TagFloat)=id) then begin
      if(enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).isAlive) then begin

        // switch enemy to pain animation
        if(enemiesTypeG[i].CurrentAnimation<>'pain3') then begin
          oldAnimation:=enemiesTypeG[i].CurrentAnimation;
          enemiesTypeG[i].SwitchToAnimation('pain3',true);
          play_HerosAudioTrack(48,fMainMenu.global_game_volume_level,true,false);
        end; // animation switch


        // fight the enemy
        oldEnemyLife:=enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).Life;

        if(oldEnemyLife > 0) then begin
          MHDamage := calcMHtoEnemyDamage('lightning');
          if (oldEnemyLife <= MHDamage) then begin
            //killEA(id); { set Life := 0; inside killEA set death animation to 'death1' before kill }
            deathEG(i);
            Exit;
          end
          else begin
            enemyInfo(enemiesTypeG[i].Behaviours.GetByClass(enemyInfo)).Life:=(oldEnemyLife - MHDamage);
          end;
         end
         else begin
           //killEA(id);
           deathEG(i);
           Exit;
         end;


        // rollback previous enemy animation
        enemiesTypeG[i].SwitchToAnimation(oldAnimation,true);


      end; // if alive
    end; // if exact

  end; // if attackWeapon = lightning

  end; // for all enemies
end;

procedure TForm1.deathEG(ix: Integer);
begin
  enemyInfo(enemiesTypeG[ix].Behaviours.GetByClass(enemyInfo)).fired:=false;
  enemyInfo(enemiesTypeG[ix].Behaviours.GetByClass(enemyInfo)).isAlive:=false;

  enemiesTypeG_core[ix].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEGOktaBall' + IntToStr(ix))) then
    Form1.FindComponent('GLEGOktaBall' + IntToStr(ix)).Free;

  // big explosion before
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
    EGExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    EGChainExplodePrepare(ix,'death');
  end;

  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    EGChainExplodePrepare(ix,'death');
  end;
   // calc MH Experience
   calcMHExperience(fMainMenu.EGBaseLife);
   play_HerosAudioTrack(49,fMainMenu.global_game_volume_level,true,false);

   if(enemiesTypeG[ix].CurrentAnimation<>'death1') then begin

   enemiesTypeG[ix].SwitchToAnimation('death1',true);

   // get some of FCamHeight down
   enemiesTypeG[ix].Position.Y:=(enemiesTypeG[ix].Position.Y - 3);
   enemyInfo(enemiesTypeG[ix].Behaviours.GetByClass(enemyInfo)).deathAnimationNeeded:=true;
   enemiesTypeG[ix].Material.BlendingMode:=bmTransparency;
   end; // animation switch
   enemyDropItem('G',ix,round(enemiesTypeG[ix].Position.X),round(enemiesTypeG[ix].Position.Z));
end;

procedure TForm1.EGExplodePrepare(eg_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
    fx_id:=enemiesTypeG[eg_index].Effects.IndexOfName('EGExplodeAEffect');
  if(fx_id <> -1) then
    enemiesTypeG[eg_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EGExplodeA')) then
    Form1.FindComponent('EGExplodeA').Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EGExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeG[eg_index].Effects);
  MHBeforeStrikeFire.Name:='EGExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeG[eg_index].Effects.Add(MHBeforeStrikeFire);

    
  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EGExplodeA';
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeG[eg_index].Effects);
  MHBeforeStrikeFire.Name:='EGExplodeAEffect';
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeG[eg_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EGOktaBallStrike(eg_index: Integer);
var
  GLEBFireBall:TGLFireFXManager;
  EBGLExplodeFire:TGLBFireFX;
  skip:boolean;
begin
     enemiesTypeG_core[eg_index].Effects.Clear;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('GLEGOktaBall' + IntToStr(eg_index))) then
    Form1.FindComponent('GLEGOktaBall' + IntToStr(eg_index)).Free;

  // prepare strike event animation
  GLEBFireBall:=TGLFireFXManager.Create(self);
  GLEBFireBall.Name:='GLEGOktaBall' + IntToStr(eg_index);
  GLEBFireBall.Cadencer:=GLCadencer1;
  // params
  GLEBFireBall.FireBurst:=5; //2
  GLEBFireBall.FireCrown:=5;  //0.5
  GLEBFireBall.FireDensity:=5; //4

  GLEBFireBall.MaxParticles:=256; //256

  //GLMHExplodeA.NoZWrite:=false;

  GLEBFireBall.InnerColor.Alpha:=1;
  GLEBFireBall.InnerColor.Red:=1;
  GLEBFireBall.InnerColor.Green:=0.8;
  GLEBFireBall.InnerColor.Blue:=0.7;

  GLEBFireBall.OuterColor.Alpha:=1;
  GLEBFireBall.OuterColor.Red:=0.5;
  GLEBFireBall.OuterColor.Green:=0.1;
  GLEBFireBall.OuterColor.Blue:=0.4;

  GLEBFireBall.ParticleInterval:=0.01; //0.01
  GLEBFireBall.ParticleLife:=3; //3
  GLEBFireBall.ParticleSize:=3; //1


  GLEBFireBall.FireRadius:=0.5; //0.5

  GLEBFireBall.Paused:=false;
  GLEBFireBall.UseInterval:=true;

  EBGLExplodeFire:= TGLBFireFX.Create(enemiesTypeG_core[eg_index].Effects);
  EBGLExplodeFire.Manager:=GLEBFireBall;
  enemiesTypeG_core[eg_index].Effects.Add(EBGLExplodeFire);

    play_HerosAudioTrack(47,fMainMenu.global_game_volume_level,true,false);
  GLEBFireBall.RingExplosion(11, 12, 10, XVector, ZVector);

  if not skip then begin
    if((Actor1.CurrentAnimation <> 'pain3')and(Actor1.CurrentFrame <> 182)) then begin
      Actor1.CurrentFrame:=182;
      play_HerosAudioTrack(12,fMainMenu.global_game_volume_level,true,false);
    end; // animation switch
    skip:=true;
  end
  else
  begin
    skip:=false;
  end;
end;

procedure TForm1.MHChainLightningStrike(tarX,tarY,Y, TargetTag :Integer);
var
  GLChainThor:TGLThorFXManager;
  chainStrike:TGLBThorFX;
begin
  // chain lightning
  //  if not (MHchain) then begin
    GLChainThor:=TGLThorFXManager.Create(self);
    inc(MHchainCount);
    GLChainThor.Name:='MHChain'+IntToStr(MHchainCount);
    GLChainThor.Cadencer:=GLCadencer1;
    // thor parameters
    GLChainThor.Core:=false;
    GLChainThor.Glow:=true;
    GLChainThor.GlowSize:= 0.7;
    // inner color
    GLChainThor.InnerColor.Alpha:= 0.1;
    GLChainThor.InnerColor.Blue:= 1;
    GLChainThor.InnerColor.Green:= 1;
    GLChainThor.InnerColor.Red:= 1;
    // details - points to use
    GLChainThor.Maxpoints:= 512;
    // outer color- contur
    GLChainThor.OuterColor.Alpha:= 0;
    GLChainThor.OuterColor.Blue:= 0.9;
    GLChainThor.OuterColor.Green:= 0.2;
    GLChainThor.OuterColor.Red:= 0.2;
    // wildness
    GLChainThor.Wildness:= 8;

    GLChainThor.Target.X:= tarX;
    GLChainThor.Target.Z:= tarY;
    GLChainThor.Target.Y:= Y;

     //Label8.Caption:=IntToStr(DCMainHero.Effects.Count);

    chainStrike:= TGLBThorFX.Create(DCMainHero.Effects);
    chainStrike.Manager:=GLChainThor;
    DCMainHero.Effects.Add(chainStrike);
    play_HerosAudioTrack(13,fMainMenu.global_game_volume_level,true,true);
end;



procedure TForm1.MHChainLightningStrikePrepare(idx: byte);
begin
{
    GLChainThor:=TGLThorFXManager.Create(self);
    GLChainThor.Name:='MHChainManager'+IntToStr(idx);
    GLChainThor.Cadencer:=GLCadencer1;
    // thor parameters
    GLChainThor.Core:=false;
    GLChainThor.Glow:=true;
    GLChainThor.GlowSize:= 0.7;
    // inner color
    GLChainThor.InnerColor.Alpha:= 0.1; //0.1
    GLChainThor.InnerColor.Blue:= 1;
    GLChainThor.InnerColor.Green:= 1;
    GLChainThor.InnerColor.Red:= 1;
    // details - points to use
    GLChainThor.Maxpoints:= 512;
    // outer color- contur
    GLChainThor.OuterColor.Alpha:= 0; //0
    GLChainThor.OuterColor.Blue:= 0.9;
    GLChainThor.OuterColor.Green:= 0.2;
    GLChainThor.OuterColor.Red:= 0.2;
    // wildness
    GLChainThor.Wildness:= 8;

    GLChainThor.Target.X:= -10;
    GLChainThor.Target.Z:= 10;
    //GLChainThor.Target.Y:= Y;

     //Label8.Caption:=IntToStr(DCMainHero.Effects.Count);

    chainStrike:= TGLBThorFX.Create(MH_chain_base[idx].Effects);
    chainStrike.Manager:=GLChainThor;
    MH_chain_base[idx].Effects.Add(chainStrike);
 }
end;

procedure TForm1.EAChainExplodePrepare(ea_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeA[ea_index].Effects.IndexOfName('EAExplodeAEffect'+IntToStr(ea_index));
  if(fx_id <> -1) then
    enemiesTypeA[ea_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EAExplodeA'+IntToStr(ea_index))) then
    Form1.FindComponent('EAExplodeA'+IntToStr(ea_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EAExplodeA'+IntToStr(ea_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeA[ea_index].Effects);
  MHBeforeStrikeFire.Name:='EAExplodeAEffect'+IntToStr(ea_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeA[ea_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EAExplodeA'+IntToStr(ea_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeA[ea_index].Effects);
  MHBeforeStrikeFire.Name:='EAExplodeAEffect'+IntToStr(ea_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeA[ea_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode


end;

procedure TForm1.EBChainExplodePrepare(eb_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeB[eb_index].Effects.IndexOfName('EBExplodeAEffect'+IntToStr(eb_index));
  if(fx_id <> -1) then
    enemiesTypeB[eb_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EBExplodeA'+IntToStr(eb_index))) then
    Form1.FindComponent('EBExplodeA'+IntToStr(eb_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EBExplodeA'+IntToStr(eb_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeB[eb_index].Effects);
  MHBeforeStrikeFire.Name:='EBExplodeAEffect'+IntToStr(eb_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeB[eb_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EBExplodeA'+IntToStr(eb_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeB[eb_index].Effects);
  MHBeforeStrikeFire.Name:='EBExplodeAEffect'+IntToStr(eb_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeB[eb_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.ECChainExplodePrepare(ec_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeC[ec_index].Effects.IndexOfName('ECExplodeAEffect'+IntToStr(ec_index));
  if(fx_id <> -1) then
    enemiesTypeC[ec_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('ECExplodeA'+IntToStr(ec_index))) then
    Form1.FindComponent('ECExplodeA'+IntToStr(ec_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='ECExplodeA'+IntToStr(ec_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeC[ec_index].Effects);
  MHBeforeStrikeFire.Name:='ECExplodeAEffect'+IntToStr(ec_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeC[ec_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='ECExplodeA'+IntToStr(ec_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeC[ec_index].Effects);
  MHBeforeStrikeFire.Name:='ECExplodeAEffect'+IntToStr(ec_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeC[ec_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EDChainExplodePrepare(ed_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeD[ed_index].Effects.IndexOfName('EDExplodeAEffect'+IntToStr(ed_index));
  if(fx_id <> -1) then
    enemiesTypeD[ed_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EDExplodeA'+IntToStr(ed_index))) then
    Form1.FindComponent('EDExplodeA'+IntToStr(ed_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EDExplodeA'+IntToStr(ed_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeD[ed_index].Effects);
  MHBeforeStrikeFire.Name:='EDExplodeAEffect'+IntToStr(ed_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeD[ed_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EDExplodeA'+IntToStr(ed_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeD[ed_index].Effects);
  MHBeforeStrikeFire.Name:='EDExplodeAEffect'+IntToStr(ed_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeD[ed_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EEChainExplodePrepare(ee_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeE[ee_index].Effects.IndexOfName('EEExplodeAEffect'+IntToStr(ee_index));
  if(fx_id <> -1) then
    enemiesTypeE[ee_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EEExplodeA'+IntToStr(ee_index))) then
    Form1.FindComponent('EEExplodeA'+IntToStr(ee_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EEExplodeA'+IntToStr(ee_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeE[ee_index].Effects);
  MHBeforeStrikeFire.Name:='EEExplodeAEffect'+IntToStr(ee_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeE[ee_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EEExplodeA'+IntToStr(ee_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeE[ee_index].Effects);
  MHBeforeStrikeFire.Name:='EEExplodeAEffect'+IntToStr(ee_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeE[ee_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EFChainExplodePrepare(ef_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeF[ef_index].Effects.IndexOfName('EFExplodeAEffect'+IntToStr(ef_index));
  if(fx_id <> -1) then
    enemiesTypeF[ef_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EFExplodeA'+IntToStr(ef_index))) then
    Form1.FindComponent('EFExplodeA'+IntToStr(ef_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EFExplodeA'+IntToStr(ef_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeF[ef_index].Effects);
  MHBeforeStrikeFire.Name:='EFExplodeAEffect'+IntToStr(ef_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeF[ef_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EFExplodeA'+IntToStr(ef_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeF[ef_index].Effects);
  MHBeforeStrikeFire.Name:='EFExplodeAEffect'+IntToStr(ef_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeF[ef_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.EGChainExplodePrepare(eg_index: Integer; mode: String);
var
  GLBeforeFire:TGLFireFXManager;
  MHBeforeStrikeFire:TGLBFireFX;
  fx_id:Integer;
begin
  fx_id:=enemiesTypeG[eg_index].Effects.IndexOfName('EGExplodeAEffect'+IntToStr(eg_index));
  if(fx_id <> -1) then
    enemiesTypeG[eg_index].Effects[fx_id].Free;

  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('EGExplodeA'+IntToStr(eg_index))) then
    Form1.FindComponent('EGExplodeA'+IntToStr(eg_index)).Free;


  if (mode='normal') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EGExplodeA'+IntToStr(eg_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=15;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5;

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  //Label8.Caption:=IntToStr(enemiesTypeA[ea_index].Effects.Count);

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeG[eg_index].Effects);
  MHBeforeStrikeFire.Name:='EGExplodeAEffect'+IntToStr(eg_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeG[eg_index].Effects.Add(MHBeforeStrikeFire);


  GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // normal mode

  if (mode='death') then begin
  // prepare strike event animation
  GLBeforeFire:=TGLFireFXManager.Create(self);
  GLBeforeFire.Name:='EGExplodeA'+IntToStr(eg_index);
  GLBeforeFire.Cadencer:=GLCadencer1;
  // params
  GLBeforeFire.FireBurst:=5;
  GLBeforeFire.FireCrown:=1;
  GLBeforeFire.FireDensity:=10;

  GLBeforeFire.MaxParticles:=1024;

  //GLBeforeFire.NoZWrite:=false;

  GLBeforeFire.InnerColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.8;
  GLBeforeFire.InnerColor.Green:=0.8;
  GLBeforeFire.InnerColor.Blue:=1;

  GLBeforeFire.OuterColor.Alpha:=1;
  GLBeforeFire.InnerColor.Red:=0.1;
  GLBeforeFire.InnerColor.Green:=0.1;
  GLBeforeFire.InnerColor.Blue:=0.8;

  GLBeforeFire.FireDir.X:=0;
  GLBeforeFire.FireDir.Y:=0.2;
  GLBeforeFire.FireDir.Z:=0;

  GLBeforeFire.InitialDir.X:=0;
  GLBeforeFire.InitialDir.Y:=5;
  GLBeforeFire.InitialDir.Z:=0;

  GLBeforeFire.ParticleInterval:=0.01;
  GLBeforeFire.ParticleLife:=3;
  GLBeforeFire.ParticleSize:=10;

  //GLBeforeFire.FireEvaporation:=;
  GLBeforeFire.FireRadius:=5; //5

  GLBeforeFire.Paused:=false;
  GLBeforeFire.UseInterval:=true;

  MHBeforeStrikeFire:= TGLBFireFX.Create(enemiesTypeG[eg_index].Effects);
  MHBeforeStrikeFire.Name:='EGExplodeAEffect'+IntToStr(eg_index);
  MHBeforeStrikeFire.Manager:=GLBeforeFire;
  enemiesTypeG[eg_index].Effects.Add(MHBeforeStrikeFire);

  GLBeforeFire.IsotropicExplosion(8,10,3);
  //GLBeforeFire.RingExplosion(8, 10, 1, XVector, YVector);
  // stop the fire trail
  GLBeforeFire.Disabled:=True;
  end; // death mode
end;

procedure TForm1.MHNovaStrike;
var
  GLMHNova:TGLFireFXManager;
  GLMHNovaStrike:TGLBFireFX;
  fx_id:Integer;
begin
  // nova
  if not (MH_in_nova_strike) then begin
  //DCMainHero.Effects.Clear;
  fx_id:=DCMainHero.Effects.IndexOfName('MHNovaStrikeFX');
  if(fx_id <> -1) then
    DCMainHero.Effects[fx_id].Free;
  //enemiesTypeA_core[i].Effects.Clear;
  if Assigned(Form1.FindComponent('MHNovaStrike')) then
    Form1.FindComponent('MHNovaStrike').Free;

  // prepare strike event animation
  GLMHNova:=TGLFireFXManager.Create(self);
  GLMHNova.Name:='MHNovaStrike';
  GLMHNova.Cadencer:=GLCadencer1;
  // params
  GLMHNova.FireBurst:=10; //2
  GLMHNova.FireCrown:=10;  //0.5
  GLMHNova.FireDensity:=10; //4

  GLMHNova.MaxParticles:=256; //256

  //GLMHExplodeA.NoZWrite:=false;

  GLMHNova.InnerColor.Alpha:=1;
  GLMHNova.InnerColor.Red:=0.9;
  GLMHNova.InnerColor.Green:=0.8;
  GLMHNova.InnerColor.Blue:=0.9;

  GLMHNova.OuterColor.Alpha:=1;
  GLMHNova.OuterColor.Red:=0.5;
  GLMHNova.OuterColor.Green:=0.6;
  GLMHNova.OuterColor.Blue:=0.8;

  GLMHNova.ParticleInterval:=0.01; //0.01
  GLMHNova.ParticleLife:=3; //3
  GLMHNova.ParticleSize:=3; //1


  GLMHNova.FireRadius:=0.5; //0.5

  GLMHNova.Paused:=false;
  GLMHNova.UseInterval:=true;

  GLMHNovaStrike:= TGLBFireFX.Create(DCMainHero.Effects);
  GLMHNovaStrike.Name:='MHNovaStrikeFX';
  GLMHNovaStrike.Manager:=GLMHNova;
  DCMainHero.Effects.Add(GLMHNovaStrike);

  GLMHNova.RingExplosion(11, 12, 10, XVector, ZVector);

  MHstrikePeriod:=0;
  MH_in_nova_strike:=true;
 end; // if in nova
end;

procedure TForm1.GLSceneViewer1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // close obj
  if (hud_objectives_base.Visible)and(hud_obj_closeBtn_Down.Visible) then begin
    hud_obj_closeBtn_Up.Visible:=true;
    hud_obj_closeBtn_Down.Visible:=false;
    hideHudObjectivesBase;

    play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
    
  end; // if obj

  // level up close
  if (hud_hero_levelUp_base.Visible)and(hud_hero_levelUp_base_pic_down.Visible) then begin
    //if ( (X > 146)and(X < 173)and(Y > 186)and(Y < 212) ) then begin
      hud_hero_levelUp_base_pic_up.Visible:=true;
      hud_hero_levelUp_base_pic_down.Visible:=false;
      hideHudLevelUp;
      play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
    //end; // if over close btn
  end;  // if level up visible

  // close inv
    if (hud_inv.Visible)and(hud_inv_closeBtn_Down.Visible) then begin
      if(hud_inv_base_state=1) then begin
        hud_inv_closeBtn_Up.Visible:=true;
        hud_inv_closeBtn_Down.Visible:=false;
        hud_inv_base_state:=0;
        hideHudInvCarrier;
        hideHudInvOrnaments;
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        hud_inv.Visible:=false;
      end; // if inv

      if(hud_inv_base_state=2) then begin
        hud_inv_closeBtn_Up.Visible:=true;
        hud_inv_closeBtn_Down.Visible:=false;
        hud_inv_base_state:=0;
        hideHudInvWebs;
        hideHudInvOrnaments;
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        hud_inv.Visible:=false;
      end; // if inv
    end;
  //end; // if over inv close btn

  //if ( (X > 339)and(X < 381)and(Y > 387)and(Y < 429) ) then begin
    if (hud_hero.Visible)and(hud_hero_closeBtn_Down.Visible) then begin
      if(hud_hero_base_state=1) then begin
        hud_hero_closeBtn_Up.Visible:=true;
        hud_hero_closeBtn_Down.Visible:=false;
        hud_hero_base_state:=0;
        hideHudHeroOrnaments;
        hideHudHeroLabels;
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        hud_hero.Visible:=false;
      end; // 1

      if(hud_hero_base_state=2) then begin
        hud_hero_closeBtn_Up.Visible:=true;
        hud_hero_closeBtn_Down.Visible:=false;
        hud_hero_base_state:=0;
        hideHudHeroOrnaments;
        hideHudInvSpells;
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        hud_hero.Visible:=false;
      end; // 2
    end; // if visible
  //end; // if over hero close btn
  //---- spells menu ----------
  processTopMenuSpells_MouseUp(X,Y);
  //----- windows menu --------
  processTopMenuWindows_MouseUp(X,Y);
  //----- webs teleport -------
  processWebsTeleport_MouseUp(X,Y);
  //----- exit menu     -------
  processTopMenuSaveAndExit_MouseUp(X,Y);
end;

procedure TForm1.EnemyBPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  play_HerosAudioTrack(20,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.EnemyCPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  play_HerosAudioTrack(26,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.EnemyDPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  play_HerosAudioTrack(31,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.EnemyEPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  play_HerosAudioTrack(36,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.EnemyFPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  play_HerosAudioTrack(41,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.EnemyGPathTravelStop(Sender: TObject;
  Path: TGLMovementPath; var Looped: Boolean);
begin
  play_HerosAudioTrack(46,fMainMenu.global_game_volume_level,false,false);
  EARelease:=true;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  buff:String;
begin
  if(Key=VK_BACK) then begin
    buff:=user_typed_msg;
    buff:=Copy(buff,1,Length(buff)-1);
    user_typed_msg:=buff;
  end;

  if IsKeyDown(VK_RETURN) then begin
    if(hud_objectives_base.Visible) then begin
      hideHudObjectivesBase;
      Exit;
    end;

    if(HUDTextUserTyped.Visible) then begin
      // hide it
      HUDTextUserTyped.Visible:=false;
      parseUserTyped(Key);
    end
    else
    begin
      user_typed_msg:='';
      HUDTextUserTyped.Visible:=true;
    end;
  end; // if return
end;

end.


