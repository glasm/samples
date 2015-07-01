unit Utillities;

interface
  uses XCollection,GLCollision, Geometry, Dialogs, Math,
       SysUtils, GLObjects,  Windows, GLVectorFileObjects,
       GLHUDObjects, GLTexture, GLMovement, AudioUtils, Classes;


  { 0 - free cell
  01..Plants..19 / 20..Shrines&LevelPortals..49 / 50..Enemies..79 / 80..webs..149
  150..Artifacts&Spheres..199 }
  
  type
    enemyInfo=class(TGLBCollision)//(TXCollectionItem)
      public

      isAlive:boolean;
      hasTarget:boolean;
      fired:boolean;
      atFireDistance:boolean;
      fleshTargetX:Integer;
      fleshTargetZ:Integer;
       /////////////////////
      oldPositionX:Integer;
      oldPositionZ:Integer;
      /////////////////////
      nextPositionX:Integer;
      nextPositionZ:Integer;
      SSN:byte;
      Life:Smallint;
      striking:boolean;
      goFight:boolean;
      strikePeriod:Shortint;
      deathAnimationNeeded:boolean;
      flee:boolean;

      ExpolisionEffectANeeded:boolean;
  end;

  type
    plantInfo=class(TGLBCollision)//(TXCollectionItem)
      public
      curPosX:Integer;
      curPosZ:Integer;
      test:Integer;
  end;

  type
    MHInfo=class(TGLBCollision)//(TXCollectionItem)
      public

      isAlive:boolean;
      SSN:byte;
      //
      Life:Smallint;
      Mana:Smallint;
      Attack:Smallint;
      //
      MHBaseLife:Smallint;
      MHBaseMana:Smallint;
      MHBaseAttack:Smallint;
      MHBaseDefence:Smallint;
      //
      MHExp:Integer;
      MH_current_level:byte;
      //
      attackWeapon:String;
  end;

  type
    WebInfo=class(TGLBCollision)//(TXCollectionItem)
      public

      isFree:boolean;
      Life:Smallint;
      dropInterval:byte;
      friendlyName:String;
      //dropQuantity:byte;
  end;

  type
    chainLightningEnemy=record
    posX,posY,posZ:Integer;
    typ:byte;
  end;

  type
    MH_inv_cell=record
    posX,posY:Integer;
    itemID:byte;
    WearArtifactType:byte;
    hud_pic,
    hud_item_pic,
    hud_item_pic_core:THUDSprite;
  end;

  type
    MH_menu_spells=record
    posX,posY:Integer;
    posX_visio,posY_visio:Integer;
    spell_name:String;
    hud_spell_pic_up,
    hud_spell_pic_down:THUDSprite;
  end;

  type
    MH_menu_windows=record
    posX,posY:Integer;
    window_name:String;
    hud_window_pic_up,
    hud_window_pic_down:THUDSprite;
  end;

  type
    MH_menu_webs=record
    posX,posY, posX_visio,posY_visio:Integer;
    window_name:String;
    hud_webs_pic,
    hud_webs_pic_up,
    hud_webs_pic_down,
    hud_webs_pic_disabled:THUDSprite;
    hud_webs_text:THUDText;
  end;

  type
    MH_inv_spells=record
    posX,posY:Integer;
    spell_name:String;
    disabled:boolean;
    upgraded:boolean;
    hud_spell_pic_up,
    hud_spell_pic_down,
    hud_spell_pic_up_disabled,
    hud_spell_pic_down_disabled:THUDSprite;
  end;

  type
    MH_view_cell=record
    posX,posY:Integer;
    hud_pic,
    hud_item_pic,
    hud_item_pic_core:THUDSprite;
  end;


  procedure terrObsClear;
  procedure clearMHstartLocation(posX,posY:Integer);
  function isPlantDNearby(posX,posY:integer):boolean;
  
  procedure terrObsFillCell(posX,posY:integer;fillId,fillRotation:byte);

  function checkChildD(i,j:Integer):boolean;
  function checkChildE(i,j:Integer):boolean;
  function checkChildF(i,j:Integer):boolean;
  function checkChildG(i,j:Integer):boolean;
  function checkChildH(i,j:Integer):boolean;
  function checkChildI(i,j:Integer):boolean;
  function checkChildJ(i,j:Integer):boolean;
  function checkChildK(i,j:Integer):boolean;

    function checkChildCellLife(i,j:Integer):boolean;
    function checkChildCellEnergy(i,j:Integer):boolean;
    function checkChildArmorA(i,j:Integer):boolean;
   function checkChildWeaponA(i,j:Integer):boolean;

    function checkChildPowerSpx(i,j:Integer):boolean;
  
  function checkChildShrineA(i,j:Integer):boolean;
  function checkChildShrineB(i,j:Integer):boolean;
  function checkChildShrineC(i,j:Integer):boolean;

  function checkChildEnemyA(i,j:Integer):boolean;

  function checkIsSameEnemyA(i,j:Integer):boolean;

  function checkIsBorderArea(curX,curY,i,j:Integer):boolean;

  function checkLocalAreaIsClearEA(centerX,centerY,absX,absY:Integer):boolean;

  function isInvalidEnemyValue(i,j:Integer; Etype:char):boolean;

  procedure MHBuildWeb(posX,posY,posZ:integer);

  function checkWebVertexesHeight(posX,posZ:Integer):boolean;

  function checkWebToLocalRestriction(posX,posZ:Integer):boolean;

  procedure initWebs;

  function getFirstFreeMHWeb:byte;

  function getMHfriendlySpellName(MH_spell:String):String;
  function getMHfriendlyWebName(idx:byte):String;
  function getUnderMHWeb(mh_posX,mh_posY:Integer):byte;

  procedure MHAttackUnderMouseWeb(X, Y: Integer);

  procedure MHfreeMouseSelectedWeb(idx:byte);

  procedure AddCellsLife;
  procedure AddCellsEnergy;
  procedure AddArmorA;
  procedure SetArmorA_prop;
  procedure AddWeaponA;

  procedure AddLevelPowerSphere;
  procedure SetLevelPowerSphere_prop;
  procedure AddLevelPortal;
  procedure SetLevelPortal_prop(ranX,ranY:Integer);

  procedure AddPlantsF;
  procedure SetPlantsF_prop;
  procedure AddPlantsG;
  procedure SetPlantsG_prop;
  procedure AddPlantsH;
  procedure AddPlantsI;
  procedure AddPlantsJ;
  procedure SetPlantsJ_prop;
  procedure AddPlantsK;

  procedure AddEnemiesA;
  procedure SetEnemiesA_prop;
  procedure AddEnemiesB;
  procedure SetEnemiesB_prop;
  procedure AddEnemiesC;
  procedure SetEnemiesC_prop;
  procedure AddEnemiesD;
  procedure SetEnemiesD_prop;
  procedure AddEnemiesE;
  procedure SetEnemiesE_prop;
  procedure AddEnemiesF;
  procedure SetEnemiesF_prop;
  procedure AddEnemiesG;
  procedure SetEnemiesG_prop;

  // Add Sprite Top Base
  procedure AddHUDSpriteTopBase(mode:byte);
  procedure AddHUDSpriteObjectiveBase;

  procedure AddHUDSpriteTopMenu(mode:byte);
  // Top Spells Menu
  procedure AddHUDSpriteTopMenuSpells(mode:byte);
  procedure AddHUDSpriteTopMenuWindows;

  procedure AddHUDSpriteTopMenuSaveAndExit;

  procedure swapSpellWithFirst(idx:byte);
  procedure swapWindowWithFirst(idx:byte);
  procedure showMenuChoosenWindow(wnd_name:String);

  function processTopMenuSpells_MouseDown(posX,posY:Integer):boolean;
  function processTopMenuSpells_MouseUp(posX,posY:Integer):boolean;

  procedure processTopMenuView_MouseDown(posX,posY:Integer);
  procedure removeCellFromInventory(idx:byte);

  function processTopMenuWindows_MouseDown(posX,posY:Integer):boolean;
  function processTopMenuWindows_MouseUp(posX,posY:Integer):boolean;

  function processTopMenuSaveAndExit_MouseDown(posX,posY:Integer):boolean;
  function processTopMenuSaveAndExit_MouseUp(posX,posY:Integer):boolean;
  procedure processSaveAndExitMenu(id_name:String);

  procedure processMHChainLightningAnimation;
  procedure processMHNovaAnimation;
  // MH Attack under mouse
  procedure processMHLightning(X, Y: Integer);
  procedure processMHChainLightning;
  procedure processMHNova;
  procedure processMHBuildWeb;
  procedure processMHDestroyWeb(X,Y:Integer);
  function proceedMHPortalEntrance(MHx_coord,MHy_coord,X_portal_coord,Y_portal_coord:Integer):boolean;
  function checkMHpowerSpxPresence:boolean;
  procedure MHgoToNextLevel;

  procedure pause_game;
  procedure printTextBarInfo(enemy_type:String;idx:byte);
  procedure processTextBarInfo(X,Y:Integer);
  procedure processTextBarInfoPortal(X,Y:Integer);
  procedure resume_game;

  procedure changeMHLifeBar;
  procedure changeMHManaBar;

  // HUD Sprites movable items
  procedure AddHudSpriteRTLife(xPos,yPos:Integer);
  procedure AddHudSpriteRTMana(xPos,yPos:Integer);
  procedure AddHudSpriteRTPowerSpx(xPos,yPos:Integer);

  // HUD Carrier
  procedure AddHudCarrierRTItem(idx:byte;xPos,yPos:Integer;itemID:byte);
  procedure AddHudWearRTItem(idx:byte;xPos,yPos:Integer;itemID:byte);
  procedure AddHudSpriteRTArmorA(xPos,yPos:Integer);
  procedure AddHudSpriteRTWeaponA(xPos,yPos:Integer);

  procedure AddHudSpriteLevelUp;

  // HUD Sprites Inventory
  procedure AddHudSpriteInvBase(mode:byte);
  procedure showHudInvOrnaments;
  procedure showHudHeroOrnaments;
  procedure showHudInvCarrier;
  procedure showHudInvWebs;

  procedure showHudHeroLabels;
  procedure showHudObjectivesBase;
  procedure showHudLevelUp;

  procedure hideHudInvOrnaments;
  procedure hideHudHeroOrnaments;
  procedure hideHudInvCarrier;
  procedure hideHudInvWebs;

  procedure hideHudHeroLabels;
  procedure hideHudObjectivesBase;
  procedure hideHudLevelUp;

  procedure AddHudSpriteInvCarrier;
  procedure AddHudSpriteTopLifeView;
  procedure AddHudSpriteTopManaView;

  procedure AddHudSpriteInvWebs;

  procedure AddHudSpriteInvSpells;
  procedure showHudInvSpells;
  procedure hideHudInvSpells;

  procedure AddHudSpriteHeroLabels;
  procedure AddHudSpriteInvWearableBase;
  procedure AddHudSpriteInvCloseBtn;
  procedure AddHudSpriteHeroCloseBtn;

  procedure AddHudSpriteInvWearCells;


  function calcIsEnoughMHEnergy(mode:String):boolean;
  function checkIsUnderMouseMovableItem(X, Y: Integer):boolean;
  procedure getUnderMousePicketObjectsList;

  procedure processMovableItemPick(itemID:byte;item_posX,item_posY:Integer);
  procedure processMovableItemOnTerrainDrop(itemID:byte;item_posX,item_posY:Integer);
  procedure processMovableItem_MouseMove(itemID:byte;curr_item_posX,curr_item_posY:Integer);
  procedure processMovableItemOnCarrierDrop(itemID:byte;item_posX,item_posY:Integer);
  procedure processMovableItemOnWearDrop(itemID:byte;item_posX,item_posY:Integer);
  function processMovableItemToInventory(drop_needed:boolean;X,Y:Integer;pick_move_item_ID:byte;itemX,itemY:Integer):boolean;
  function processWebsTeleportClick(X,Y:Integer):boolean;
  function processSpellUpgradeClick(X,Y:Integer):boolean;


  procedure processWebsTeleport_MouseUp(X,Y:Integer);

  procedure processSpellUpgrade_MouseUp(X,Y:Integer);

  procedure processMovableFromCarrierFill(X,Y:Integer);

  function getUnderMouseCarrierCellIndex(posX,posY:Integer):byte;
  function getUnderMouseWearCellIndex(posX,posY:Integer):byte;
  function getUnderMouseSpellMenuCellIndex(posX,posY:Integer):byte;
  function getUnderMouseWindowsMenuCellIndex(posX,posY:Integer):byte;
  function getUnderMouseExitMenuCellIndex(posX,posY:Integer):byte;

  function getItemBonus(idx:byte):byte;
  function getObjectiveText:String;

  function isTopMenuUpgradedSpell(idx:byte):boolean;

  function getUnderMouseCarrierCellContent(cell_idx:byte):byte;
  function getUnderMouseWearCellContent(cell_idx:byte):byte;

  function getUnderMouseWebsCellIndex(posX,posY:Integer):byte;
  function getUnderMouseSpellCellIndex(posX,posY:Integer):TVector;

  procedure teleportMHtoWeb(idx:byte);

  procedure deleteMovableHUDSprite;
  procedure deleteMovableHUDSpriteByName(st_name1,st_name2:String);

  procedure enemyDropItem(en:char; idx, X,Y:Integer);

  procedure setDropPointOnTerrain;
  procedure processMovableItemFromCarrierOnTerrainDrop(X,Y:Integer);
  procedure processMovableItemFromWearOnTerrainDrop(X,Y:Integer);
  // init
  procedure setInitialCameraPosition;
  procedure initEnemyInfoBase;
  function initEnemyInfoLife(e_type:String):Smallint;
  procedure initMHInfoBase(gained_exp:Integer);
  procedure calcMHExperience(E_base_life:Smallint);
  procedure calcMHLevel;

  procedure update_hud_hero_values;
  procedure update_hud_hero_spells;
  procedure update_hud_inv_webs;
  procedure update_hud_top_view;

  procedure update_wear_items_properties(toAdd:boolean;cell_idx,item_idx,wear_type:byte);
  procedure changeAllEnemiesBaseAttackOnClick(asc:boolean; wear_type:byte);
  procedure changeMHBaseAttackOnClick(asc:boolean; wear_type:byte);
  procedure changeMHBaseLifeOnClick(asc:boolean; wear_type:byte);
  procedure changeMHBaseManaOnClick(asc:boolean; wear_type:byte);
  procedure changeMHBaseDefence(asc:boolean; quant:byte);


  procedure MHdrinkCell(idx:byte);
  procedure MHShrinesFill;
  // windows
  procedure invokeInventoryWindow(closing:boolean);
  procedure invokeWebsWindow(closing:boolean);

  procedure invokeHeroWindow(closing:boolean);
  procedure invokeSpellsWindow(closing:boolean);

  // MH Webs dropping
  procedure processMHWebDropping(web_interval:byte);
  function checkCellAreaIsClear(posX,posY:Integer):boolean;

  // parse
  procedure parseUserTyped(var Key: Word);
  // next level
  function getMainTextureNameForLevel(curr_lev:byte):String;
  function getBumpTextureNameForLevel(curr_lev:byte):String;
  function getMainSelfNameForLevel(curr_lev:byte):String;

  procedure buff_MH_Inventory;
  procedure restore_MH_Inventory_from_buff;

  procedure loadLevelFromMaps(idx:byte);
  procedure loadLevelFromSave(idx:byte);
  procedure restoreWebAreasFromSave(idx:byte);
  procedure restorePowerSpxFromSave(needed:boolean);

implementation
  uses Unit1, GLScene, Forms, MainMenu;

procedure terrObsClear;
var
  i,j:integer;
begin

  for j :=624 to 5446 do begin
    for i :=(-4161) to 968 do begin
     //Form1.terrObs[i,j].walkable:=true;
     Form1.terrObs[i,j].itemId:=0;
     Form1.terrObs[i,j].itemRotation:=0;
    end; // for
  end; // for

  {
  for j :=624 to 5446 do begin
    for i :=(-4161) to 968 do begin
      if((round(Form1.TerrainRenderer1.InterpolatedHeight(VectorMake(i,0,j)))< -22)) then begin
        Form1.terrObs[i,j].itemId:=250;
        Form1.terrObs[i,j].itemRotation:=0; ShowMessage('below');
      end
      else
      begin
        Form1.terrObs[i,j].itemId:=0;
        Form1.terrObs[i,j].itemRotation:=0; ShowMessage('above');
      end; // else
    end; // for
  end; // for
   }
end;

procedure clearMHstartLocation(posX,posY:Integer);
var
  i,j:Integer;
begin
  for j :=(posY-8) to (posY+8) do begin
    for i :=(posX-8) to (posX+8) do begin
     //Form1.terrObs[i,j].walkable:=true;
     Form1.terrObs[i,j].itemId:=0;
     Form1.terrObs[i,j].itemRotation:=0;
    end; // for
  end; // for
end;

function isPlantDNearby(posX, posY: integer): boolean;
var
  i,j:Integer;
begin
  Result:=false;
  ////////////////////////////////////////
  if( (posX>=-4112)and(posX<919)and(posY>673)and(posY<5397) ) then begin
    for j :=(posY-29) to (posY+29) do begin
      for i :=(posX-29) to (posX+29) do begin
        if(Form1.terrObs[i,j].itemId<>0) then
        begin
          Result:=true;
          exit;
        end; //if
      end; // for
    end; // for
  end
  else
  begin
    Result:=true;
  end; // if in array range
end;

function checkLocalAreaIsClearEA(centerX,centerY,absX,absY:Integer):boolean;
var
  i,j:Integer;
begin
  Result:=true;
  // 1
  if( (centerX=(absX-1))and(centerY=(absY-1)) ) then begin

    for j:= (centerY-12) to (centerY) do begin
      for i:= (centerX-12) to (centerX) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 1

  // 2
  if( (centerX=absX)and(centerY=(absY-1)) ) then begin

    for j:= (centerY-12) to (centerY) do begin
      for i:= (centerX-6) to (centerX+6) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 2

  // 3
  if( (centerX=(absX+1))and(centerY=(absY-1)) ) then begin

    for j:= (centerY-12) to (centerY) do begin
      for i:= (centerX) to (centerX+12) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 3

  // 4
  if( (centerX=(absX-1))and(centerY=absY) ) then begin

    for j:= (centerY-6) to (centerY+6) do begin
      for i:= (centerX-12) to (centerX) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 4

  // 5
  if( (centerX=(absX+1))and(centerY=absY) ) then begin

    for j:= (centerY-6) to (centerY+6) do begin
      for i:= (centerX) to (centerX+12) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 5

  // 6
  if( (centerX=(absX-1))and(centerY=(absY+1)) ) then begin

    for j:= (centerY) to (centerY+12) do begin
      for i:= (centerX-12) to (centerX) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 6

  // 7
  if( (centerX=absX)and(centerY=(absY+1)) ) then begin

    for j:= (centerY) to (centerY+12) do begin
      for i:= (centerX-6) to (centerX+6) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 7

  // 8
  if( (centerX=(absX+1))and(centerY=(absY+1)) ) then begin

    for j:= (centerY) to (centerY+12) do begin
      for i:= (centerX) to (centerX+12) do begin
        if( (Form1.terrObs[i,j].itemId=1)or(Form1.terrObs[i,j].itemId=50)) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // i
    end; // j

  end; // if 8
  /////////////////////////////////////////////////////////
  {
  Result:=true;
  for j:= (centerY-6) to (centerY+6) do begin
    for i:= (centerX-6) to (centerX+6) do begin
      if not( (i>=(centerX-1))and(i<=(centerX+1))and
              (j>=(centerY-1))and(j<=(centerY+1)) ) then begin
        if(Form1.terrObs[i,j].itemId<>0) then
          begin
            Result:=false;
            Break;
          end; //if obs
      end; // if not so close to center
    end; // for i
  end; // for j
  }
end; // function

procedure terrObsFillCell(posX,posY:integer;fillId,fillRotation:byte);
begin
  if(fillId=1) then begin
    //Form1.terrObs[posX,posY].walkable:=false;
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=2) then begin
    //Form1.terrObs[posX,posY].walkable:=false;
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=3) then begin
    // plant F
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=4) then begin
    // plant G
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=5) then begin
    // plant H
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=6) then begin
    // plant I
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=7) then begin
    // plant J
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=8) then begin
    // plant K
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=20) then begin
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=21) then begin
    // life shrineB
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=22) then begin
    // mana shrineC
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=40) then begin
    // portal feet
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;
  {
  if(fillId=41) then begin
    // portal center
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;
   }
  if(fillId=50) then begin
   // EA spider
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=51) then begin
   // EB alien
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=52) then begin
   // EC bug
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=53) then begin
   // ED insect
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=54) then begin
   // EE frog
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=55) then begin
   // EF drio
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=56) then begin
   // EF okta
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=80) then begin
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=150) then begin
    // life cells
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=151) then begin
    // energy cells
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=160) then begin
    // armorA
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=180) then begin
    // weapon A
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=190) then begin
    // power spx
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=fillRotation;
  end;

  if(fillId=250) then begin
    Form1.terrObs[posX,posY].itemId:=fillId;
    Form1.terrObs[posX,posY].itemRotation:=0;
  end;
end;

function checkChildD(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantD.ComponentCount do begin
    if((round(Form1.DCBasePlantD.Children[c].Position.X)=i)and(round(Form1.DCBasePlantD.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;


function checkChildE(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantE.ComponentCount do begin
    if((round(Form1.DCBasePlantE.Children[c].Position.X)=i)and(round(Form1.DCBasePlantE.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildF(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantF.ComponentCount do begin
    if((round(Form1.DCBasePlantF.Children[c].Position.X)=i)and(round(Form1.DCBasePlantF.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildG(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantG.ComponentCount do begin
    if((round(Form1.DCBasePlantG.Children[c].Position.X)=i)and(round(Form1.DCBasePlantG.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildH(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantH.ComponentCount do begin
    if((round(Form1.DCBasePlantH.Children[c].Position.X)=i)and(round(Form1.DCBasePlantH.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildI(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantI.ComponentCount do begin
    if((round(Form1.DCBasePlantI.Children[c].Position.X)=i)and(round(Form1.DCBasePlantI.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildJ(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantJ.ComponentCount do begin
    if((round(Form1.DCBasePlantJ.Children[c].Position.X)=i)and(round(Form1.DCBasePlantJ.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildK(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCBasePlantK.ComponentCount do begin
    if((round(Form1.DCBasePlantK.Children[c].Position.X)=i)and(round(Form1.DCBasePlantK.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildCellLife(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCCellsLife.ComponentCount do begin
    if((round(Form1.DCCellsLife.Children[c].Position.X)=i)and(round(Form1.DCCellsLife.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildCellEnergy(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCCellsEnergy.ComponentCount do begin
    if((round(Form1.DCCellsEnergy.Children[c].Position.X)=i)and(round(Form1.DCCellsEnergy.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if
  end; // for children
end;

function checkChildArmorA(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCArmorA.ComponentCount do begin
    if((round(Form1.DCArmorA.Children[c].Position.X)=i)and(round(Form1.DCArmorA.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if
  end; // for children
end;

function checkChildWeaponA(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCWeaponA.ComponentCount do begin
    if((round(Form1.DCWeaponA.Children[c].Position.X)=i)and(round(Form1.DCWeaponA.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if
  end; // for children
end;

function checkChildPowerSpx(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCPowerSphere.ComponentCount do begin
    if((round(Form1.DCPowerSphere.Children[c].Position.X)=i)and(round(Form1.DCPowerSphere.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildShrineA(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCShrineA.ComponentCount do begin
    if((round(Form1.DCShrineA.Children[c].Position.X)=i)and(round(Form1.DCShrineA.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildShrineB(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCShrineB.ComponentCount do begin
    if((round(Form1.DCShrineB.Children[c].Position.X)=i)and(round(Form1.DCShrineB.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if
      
  end; // for children
end;

function checkChildShrineC(i,j:Integer):boolean;
var
  c:Integer;
begin
  Result:=false;
  for c:= 1 to Form1.DCShrineC.ComponentCount do begin
    if((round(Form1.DCShrineC.Children[c].Position.X)=i)and(round(Form1.DCShrineC.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
end;

function checkChildEnemyA(i,j:Integer):boolean;
var
  c:Integer;
begin
  {
  Result:=false;
  for c:= 1 to Form1.DCBaseEnemyA.ComponentCount do begin
    if((round(Form1.DCBaseEnemyA.Children[c].Position.X)=i)and(round(Form1.DCBaseEnemyA.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children
   }
  Result:=false;
  for c:=0 to (enemA-1) do begin
    if((round(Form1.DCEnemies.Children[c].Position.X)=i)and(round(Form1.DCEnemies.Children[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children

end;

function checkIsSameEnemyA(i,j:Integer):boolean;
var
  c:Integer;
begin

  Result:=false;
  for c:= 1 to enemA do begin
    if((round( Form1.enemiesTypeA[c].Position.X)=i)and(round( Form1.enemiesTypeA[c].Position.Z)=j)) then begin
      Result:=true;
      exit;
    end; // if

  end; // for children

end;

function checkIsBorderArea(curX,curY,i,j:Integer):boolean;
begin
  Result:=false;
  if not((j > (curY-80))and(j < (curY+80))and(i > (curX-80))and(i < (curX+80))) then begin
    Result:=true;
  end; // if

end;

function isInvalidEnemyValue(i,j:Integer; Etype:char):boolean;
var
  x:Integer;
begin
  Result:=true;
  case Etype of
    'A': begin
           for x:= 1 to enemA do begin
             if((enemyInfo(Form1.enemiesTypeA[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeA[x].Position.X)=i)and(round( Form1.enemiesTypeA[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'A'

    'B': begin
           for x:= 1 to enemB do begin
             if((enemyInfo(Form1.enemiesTypeB[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeB[x].Position.X)=i)and(round( Form1.enemiesTypeB[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'B'

    'C': begin
           for x:= 1 to enemC do begin
             if((enemyInfo(Form1.enemiesTypeC[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeC[x].Position.X)=i)and(round( Form1.enemiesTypeC[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'C'

    'D': begin
           for x:= 1 to enemD do begin
             if((enemyInfo(Form1.enemiesTypeD[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeD[x].Position.X)=i)and(round( Form1.enemiesTypeD[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'D'

     'E': begin
           for x:= 1 to enemE do begin
             if((enemyInfo(Form1.enemiesTypeE[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeE[x].Position.X)=i)and(round( Form1.enemiesTypeE[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'E'

     'F': begin
           for x:= 1 to enemF do begin
             if((enemyInfo(Form1.enemiesTypeF[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeF[x].Position.X)=i)and(round( Form1.enemiesTypeF[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'F'

     'G': begin
           for x:= 1 to enemG do begin
             if((enemyInfo(Form1.enemiesTypeG[x].Behaviours.GetByClass(enemyInfo)).fired)and
                (round( Form1.enemiesTypeG[x].Position.X)=i)and(round( Form1.enemiesTypeG[x].Position.Z)=j)) then begin
               Result:=false;
               exit;
             end; // if
           end // for

         end; // case 'G'
  end; // case
end;

procedure MHBuildWeb(posX,posY,posZ:integer);
var
  alpha,tolerance,x1, currIDX:Integer;
  R,x,y:real;
  start, lap:Double;
begin

  start:=GetTickCount;
  with Form1 do begin
    // check Web Restrictions
    if( (MHWebCount < 8) and
       checkWebVertexesHeight(posX,posZ)and
       checkWebToLocalRestriction(posX,posZ)) then begin

    currIDX:=getFirstFreeMHWeb;
    with MHWebs[currIDX] do begin

      Nodes.Clear;
      NodesAspect:=lnaInvisible;
      Position.X:=posX;
      Position.Y:=posY;
      Position.Z:=posZ;

      LineColor.Alpha:=0.3;
      LineColor.Red:=1;   // RGB(1,1,1)
      LineColor.Green:=1;
      LineColor.Blue:=1;

      //SplineMode:=lsmCubicSpline;

      Direction:=webLines.Direction;
      Up:=webLines.Up;
      RollAngle:=0;


      // spiral lines -------------------------
      R:=0.003; // 0.001
      for alpha := 1 to 7200 do begin
        x:=cos(DegToRad(alpha))*R;
        y:=sin(DegToRad(alpha))*R;
        if( (odd(round(x)))and(odd(round(y))) ) then
        // add less nodes
          AddNode(x,y,
          (getTRheight(round(posX-x),round(posZ+y))-posY) + 2 );

        R:=R+0.003;
      end; // for alpha
      //----------------------------------------
      // radial lines
      for alpha := 1 to 17 do begin
        Randomize;
        tolerance:=RandomRange(-5,5);
        MHWebs[currIDX].Nodes.Add;
        for x1:= (-25+tolerance) to (25+tolerance) do begin
          if (odd(x1)) then begin
            if(alpha <> 90) then begin
              Y:=round(tan(DegToRad(alpha*10))*x1);
              // clamp Y to fit some quad
              if( (Y > (-25+tolerance))and(Y < (25+tolerance)) ) then
                AddNode(x1,Y,(getTRheight(round(posX-x1),round(posZ+y))-posY) + 2);
            end; // if alpha
          end; // if odd
        end; //for line

      end; // for alpha
      //----------------------------------------

      Roll(23);
      WebInfo(MHWebs[currIDX].Behaviours.GetByClass(WebInfo)).dropInterval:=RandomRange(100,200);
      WebInfo(MHWebs[currIDX].Behaviours.GetByClass(WebInfo)).isFree:=false;
      WebInfo(MHWebs[currIDX].Behaviours.GetByClass(WebInfo)).friendlyName:=getMHfriendlyWebName(currIDX);
      Visible:=true;
      inc(MHWebCount);
      TransformationChanged;
    end; // with web

  terrObsFillCell(posX,posZ,80,0);
  play_HerosAudioTrack(15,fMainMenu.global_game_volume_level,true,false);
  end; // if restrictions
  end; // with Form1

  lap:=(GetTickCount-start);
  //ShowMessage('exit ' + FloatToStr(lap) + ' .ms');
end;

function checkWebVertexesHeight(posX,posZ:Integer):boolean;
var
  A,B,C,D:Integer;
begin
  Result:=false;
  with Form1 do begin
    A:=getTRheight(round(posX-25),round(posZ-25));
    B:=getTRheight(round(posX+25),round(posZ-25));
    C:=getTRheight(round(posX-25),round(posZ+25));
    D:=getTRheight(round(posX+25),round(posZ+25));
  end; // with

  if( (A > -22)and(B > -22)and(C > -22)and(D > -22) ) then
    Result:=true;
end;

function checkWebToLocalRestriction(posX,posZ:Integer):boolean;
var
  i,j:Integer;
begin
  Result:=true;
  for j:=(posZ-40) to (posZ+40) do begin
    for i:=(posX-40) to (posX+40) do begin
      if (Form1.terrObs[i,j].itemId in[20,21,22,50,51,52,53,54,55,56] )or
         (Form1.terrObs[i,j].itemId in[80..149] )then begin
        Result:=false;
        Exit;
      end; // if obst
    end; // for i
  end; // for j  
end;

procedure initWebs;
var
  i:byte;
  spec:WebInfo;
begin
  with Form1 do begin
    for i:= 1 to 8 do begin
      MHWebs[i]:=TLines(DCSpiderWeb.AddNewChild(TLines));
      with MHWebs[i] do begin

        Nodes.Clear;
        NodesAspect:=lnaInvisible;
        Position.X:=-5000;
        Position.Y:=-5000;
        Position.Z:=0;

        LineColor.Alpha:=0.3;
        LineColor.Red:=1;
        LineColor.Green:=1;
        LineColor.Blue:=1;

        Direction:=webLines.Direction;
        Up:=webLines.Up;
        RollAngle:=0;

        spec:=WebInfo.Create(MHWebs[i].Behaviours);
        spec.isFree:=true;
        spec.Life:=250;
        Behaviours.Add(spec);
        Visible:=false;

        TransformationChanged;
      end; // with web
   end; // for all webs

  end; // with Form1
end;

function getFirstFreeMHWeb:byte;
var
  i:byte;
begin
  Result:=1;
  with Form1 do begin
    for i:= 1 to 8 do begin
      if (WebInfo(MHWebs[i].Behaviours.GetByClass(WebInfo)).isFree) then begin
        Result:=i;
        Break;
      end; // if free
    end; // for all webs

  end; // with Form1
end;

function getMHfriendlySpellName(MH_spell:String):String;
begin
  Result:='NONE';
  with Form1 do begin
    if(MH_spell='lightning') then begin
      Result:='LIGHTNING';
    end;

    if(MH_spell='chain_lightning') then begin
      Result:='MAS-LIGHTNING';
    end;

    if(MH_spell='nova') then begin
      Result:='NOVA';
    end;

    if(MH_spell='build_web') then begin
      Result:='BUILD WEB';
    end;

    if(MH_spell='destroy_web') then begin
      Result:='DESTROY WEB';
    end;

  end; // with
end;

function getMHfriendlyWebName(idx:byte):String;
begin
  with Form1 do begin
    case idx of
      1:begin
        Result:='WEB-KARAPELIT';
      end; //1
      2:begin
        Result:='WEB-DONCHEVU';
      end; //2
      3:begin
        Result:='WEB-JIGLARCY';
      end; //3
      4:begin
        Result:='WEB-SUVOROVU';
      end; //4
      5:begin
        Result:='WEB-GRUDOVO';
      end; //5
      6:begin
        Result:='WEB-ZEBIN';
      end; //6
      7:begin
        Result:='WEB-TOLBUHIN';
      end; //7
      8:begin
        Result:='WEB-AGROPOLIS';
      end; //8
    end; // case
  end; // with
end;

function getUnderMHWeb(mh_posX,mh_posY:Integer):byte;
var
  i:byte;
  web_posX, web_posY, calc_dist:Integer;
begin
  // dist 25
  Result:=0; // no web
  with Form1 do begin
    for i:= 1 to 8 do begin
      if (MHWebCount >= 1)and(MHWebCount <= 8) then begin
        if not(WebInfo(MHWebs[i].Behaviours.GetByClass(WebInfo)).isFree) then begin
          web_posX:=round(MHWebs[i].Position.X);
          web_posY:=round(MHWebs[i].Position.Z);
          calc_dist:=calcDistance(web_posX,web_posY,mh_posX,mh_posY);
          if (calc_dist < 25) then begin
            // return web id
            Result:=i;
            break;
          end; // dist
        end; // if not
      end; // if in range  
    end; // for
  end; // with form1
end;

procedure MHAttackUnderMouseWeb(X, Y: Integer);
var
  i,j,k:Integer;
begin
  with Form1 do begin
    for j:=(Y-20) to (Y+20) do begin
      for i:=(X-20) to (X+20) do begin
        if (terrObs[i,j].itemId=80) then begin
        // check each MHWebs for exact match
          for k:=1 to 8 do begin
            if((round(MHWebs[k].Position.X))=i)and
               ((round(MHWebs[k].Position.Z))=j) then begin
              // Remove web
              MHfreeMouseSelectedWeb(k);
              // clear web cell

              terrObs[i,j].itemId:=0;
              play_HerosAudioTrack(16,fMainMenu.global_game_volume_level,true,false);
              Exit;
            end; // if exact
          end; // for all MHWebs
        end; // if id=80
      end; // for i
    end; // for j
  end; // with form1  

end;

procedure MHfreeMouseSelectedWeb(idx:byte);
begin
  with Form1 do begin
    if (MHWebCount >= 1) then begin
      if not(WebInfo(MHWebs[idx].Behaviours.GetByClass(WebInfo)).isFree) then begin
        MHWebs[idx].Visible:=false;
        dec(MHWebCount);
          //ShowMessage('webidx: ' + IntToStr(idx));
        WebInfo(MHWebs[idx].Behaviours.GetByClass(WebInfo)).isFree:=true;
      end; // if exist on map
    end; // if (MHWebCount);
  end; // with form1
end;

procedure processMHWebDropping(web_interval:byte);
var
  idx:byte;
  wPosX, wPosZ, xOffset, yOffset:Integer;
begin
  with Form1 do begin
    if (MHWebCount >= 1) then begin
    for idx:= 1 to 8 do begin
      if not(WebInfo(MHWebs[idx].Behaviours.GetByClass(WebInfo)).isFree) then begin
        // check timer = interval
        if(WebInfo(MHWebs[idx].Behaviours.GetByClass(WebInfo)).dropInterval=web_interval) then begin
                    // dropping if web is Empty
          wPosX:=round(MHWebs[idx].Position.X);
          wPosZ:=round(MHWebs[idx].Position.Z);
          // check cell
          Randomize;
          xOffset:=RandomRange(-15,15);
          yOffset:=RandomRange(-15,15);
          // checkCellAreaIsClear
          if not checkCellAreaIsClear((wPosX+xOffset), (wPosZ+yOffset)) then begin
            // choose life or energy cell to drop
            if(xOffset >= 0) then begin
              // life cell
              terrObsFillCell((wPosX+xOffset),(wPosZ+yOffset),150,RandomRange(1,250));
            end
            else
            begin
              // energy cell
              terrObsFillCell((wPosX+xOffset),(wPosZ+yOffset),151,RandomRange(1,250));
            end; // choose cell
          end; // if cell area
        end; // if intreval

      end; // if exist on map
      end; // for all
    end; // if (MHWebCount);
  end; // with form1
end;

function checkCellAreaIsClear(posX,posY:Integer):boolean;
var
  i,j:Integer;
begin
  Result:=false;
  if( (posX>=-4112)and(posX<919)and(posY>673)and(posY<5397) ) then begin
    for j :=(posY-5) to (posY+5) do begin
      for i :=(posX-5) to (posX+5) do begin
        if(Form1.terrObs[i,j].itemId<>0) then
        begin
          Result:=true;
          exit;
        end; //if
      end; // for
    end; // for
  end // if in array range
  else
  begin
    Result:=true;
  end;
end;

procedure AddCellsLife;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  for i:=1 to 1000 do begin //1000
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY))or
      (Form1.getTRheight(round(ranX),round(ranY))<=-22) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,150,ranRotation);
    // save to array
    fMainMenu.M_life_cells[i].posX:=ranX;
    fMainMenu.M_life_cells[i].posY:=ranY;
    fMainMenu.M_life_cells[i].itemId:=150;
    fMainMenu.M_life_cells[i].itemRotation:=ranRotation;
    //
  end;
end;

procedure AddCellsEnergy;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  for i:=1 to 1000 do begin //1000
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY))or
      (Form1.getTRheight(round(ranX),round(ranY))<=-22) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,151,ranRotation);
    // save to array
    fMainMenu.M_mana_cells[i].posX:=ranX;
    fMainMenu.M_mana_cells[i].posY:=ranY;
    fMainMenu.M_mana_cells[i].itemId:=151;
    fMainMenu.M_mana_cells[i].itemRotation:=ranRotation;
    //
  end;
end;

procedure AddArmorA;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  for i:=1 to 500 do begin //500
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY))or
      (Form1.getTRheight(round(ranX),round(ranY))<=-22) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,160,ranRotation);
    // save to array
    fMainMenu.M_armor_A[i].posX:=ranX;
    fMainMenu.M_armor_A[i].posY:=ranY;
    fMainMenu.M_armor_A[i].itemId:=160;
    fMainMenu.M_armor_A[i].itemRotation:=ranRotation;
    //
  end;
end;

procedure SetArmorA_prop;
begin
  with Form1 do begin
    with spxArmorABase do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[2].Material.Texture.Image;
      Material.Texture.Disabled:=false;
      Radius:=2;
      ///Scale.SetVector(1,0.5,1);
      Position.SetPoint(5000,
      TerrainRenderer1.InterpolatedHeight(VectorMake(5000,0,5000))+2,
      5000);
    end; // with spx

    with spxArmorAtop do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[2].Material.Texture.Image;
      Material.Texture.Disabled:=false;
      Radius:=1;
      Scale.SetVector(2,0.5,1);
      TurnAngle:=45;
      Position.SetPoint(2,0,2);
    end; // with top

    with spxArmorAleft do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[2].Material.Texture.Image;
      Material.Texture.Disabled:=false;
      Radius:=1;
      Scale.SetVector(2,0.5,1);
      TurnAngle:=135;
      Position.SetPoint(-2,0,2);
    end; // with left

    with spxArmorAbottom do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[2].Material.Texture.Image;
      Material.Texture.Disabled:=false;
      Radius:=1;
      Scale.SetVector(2,0.5,1);
      TurnAngle:=135;
      Position.SetPoint(2,0,-2);
    end; // with bottom

    with spxArmorAright do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[2].Material.Texture.Image;
      Material.Texture.Disabled:=false;
      Radius:=1;
      Scale.SetVector(2,0.5,1);
      TurnAngle:=45;
      Position.SetPoint(-2,0,-2);
    end; // with right
  end; // with
end;

procedure AddWeaponA;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    for i:=1 to 500 do begin //500
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-4161,968);
    ranY:=RandomRange(642,5446);
    ranRotation:=RandomRange(0,250);
    if(isPlantDNearby(ranX,ranY))or
      (Form1.getTRheight(round(ranX),round(ranY))<=-22) then begin
      Continue;
    end;
    terrObsFillCell(ranX,ranY,180,ranRotation);
    // save to array
    fMainMenu.M_weapon_A[i].posX:=ranX;
    fMainMenu.M_weapon_A[i].posY:=ranY;
    fMainMenu.M_weapon_A[i].itemId:=180;
    fMainMenu.M_weapon_A[i].itemRotation:=ranRotation;
    //
  end;
  end; // with form1
end;

procedure AddLevelPowerSphere;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    for i:=1 to 1000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-3161,-100);
      ranY:=RandomRange(1642,4446);
      ranRotation:=0;
      if(isPlantDNearby(ranX,ranY))or
        (Form1.getTRheight(round(ranX),round(ranY))<=-22) then begin
        Continue;
      end
      else
      begin
        terrObsFillCell(ranX,ranY,190,ranRotation);
        power_spx_X:=ranX;
        power_spx_Y:=ranY;
        break;
      end; // if
    end; // for
  end;  // with Form1
end;

procedure SetLevelPowerSphere_prop;
begin
  with Form1 do begin
    // set PowerSphere position DCPowerSphere
    with spxPowerSphereCore do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      Material.Texture.Disabled:=false;
      Radius:=2;
      Position.SetPoint(5000,
      TerrainRenderer1.InterpolatedHeight(VectorMake(5000,0,5000))+2,
      5000);
    end; // with spx

    // set PowerSphere position DCPowerSphere
    with spxPowerSphereShell do begin
      Radius:=2.5;
      // set some props
      Material.BlendingMode:=bmAdditive;
      // amb
      Material.FrontProperties.Ambient.Alpha:=0.3;
      Material.FrontProperties.Ambient.Red:=0.2;
      Material.FrontProperties.Ambient.Green:=0.2;
      Material.FrontProperties.Ambient.Blue:=0.2;
      // dif
      Material.FrontProperties.Diffuse.Alpha:=0.8;
      Material.FrontProperties.Diffuse.Red:=1;
      Material.FrontProperties.Diffuse.Green:=1;
      Material.FrontProperties.Diffuse.Blue:=1;
      // emis
      Material.FrontProperties.Emission.Alpha:=0.3;
      Material.FrontProperties.Emission.Red:=0.9;
      Material.FrontProperties.Emission.Green:=0.9;
      Material.FrontProperties.Emission.Blue:=0.9;
      Material.FrontProperties.Shininess:=1;
    end; // with spx

    // set PowerSphere position DCPowerSphere
    with spxPowerSphereAura do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      Material.Texture.Disabled:=false;
    end; // with spx
  end; // with
end;

procedure AddLevelPortal;
var
  i,ranX,ranY,ranRotation : Integer;
begin
  // da se dobavi v AddTerrainItems kato pyrvo
  with Form1 do begin
  for i:=1 to 1000 do begin
    fMainMenu.update_loading_progress;
    Randomize;
    ranX:=RandomRange(-3161,-100);
    ranY:=RandomRange(1642,4446);
    ranRotation:=0;
    if(isPlantDNearby(ranX,ranY))or
      (Form1.getTRheight(round(ranX),round(ranY))<=-22) then begin
      Continue;
    end
    else
    begin
      // fill portal center and portal feet differently
      terrObsFillCell(ranX,ranY,41,ranRotation);
      portal_X:=ranX;
      portal_Y:=ranY;
      break;
    end; // if
  end; // for
  end;  // with Form1
end;

procedure SetLevelPortal_prop(ranX,ranY:Integer);
var
  portHeight:Integer;
begin
  with Form1 do begin
    // get avg Structure height
    portHeight:=round(TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))+1);
    // portal PipeA
    with PortalPipeA do begin
      Scale.SetVector(1,1,1);
      TurnAngle:=0;
      Position.SetPoint(ranX-15,portHeight,ranY-15);
      terrObsFillCell(ranX-15,ranY-15,40,0);
    end; // PortalPipeA

    // portal PipeB
    with PortalPipeB do begin
      Scale.SetVector(1,1,1);
      TurnAngle:=265;
      Position.SetPoint(ranX+15,portHeight,ranY-15);
      terrObsFillCell(ranX+15,ranY-15,40,0);
    end; // PortalPipeB

    // portal PipeC
    with PortalPipeC do begin
      Scale.SetVector(1,1,1);
      TurnAngle:=95;
      Position.SetPoint(ranX-15,portHeight,ranY+15);
      terrObsFillCell(ranX-15,ranY+15,40,0);
    end; // PortalPipeC

    // portal PipeD
    with PortalPipeD do begin
      Scale.SetVector(1,1,1);
      TurnAngle:=180;
      Position.SetPoint(ranX+15,portHeight,ranY+15);
      terrObsFillCell(ranX+15,ranY+15,40,0);
    end; // PortalPipeD

    // portal Pipebody
    with PortalPipeBody do begin
      Scale.SetVector(1,1,1);
      //TurnAngle:=180;
      Position.SetPoint(ranX-1,portHeight,ranY-1);
      //terrObsFillCell(ranX+15,ranY+15,40,0);
    end; // PortalPipeD

    with PortalSpx do begin
      Position.SetPoint(ranX-1,portHeight+5,ranY-1);
    end; // PortalSpx

    // portal Aura
    with PortalAura do begin
      Position.SetPoint(ranX-1,portHeight+5,ranY-1);
    end; // PortalAura
  end; // with
end;

procedure AddPlantsF;
var
  i,ranX,ranY,ranRotation:Integer;
begin
  for i:=1 to 2000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY)) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,3,ranRotation);
      // save to array
      fMainMenu.M_plants_F[i].posX:=ranX;
      fMainMenu.M_plants_F[i].posY:=ranY;
      fMainMenu.M_plants_F[i].itemId:=3;
      fMainMenu.M_plants_F[i].itemRotation:=ranRotation;
      //
  end; // for
end;

procedure SetPlantsF_prop;
begin
  with Form1 do begin
    with MultiPolygon1 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[3].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmObjectLinear;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 1

    with MultiPolygon2 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[3].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmObjectLinear;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 2

    with MultiPolygon3 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[3].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmObjectLinear;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 3

    with MultiPolygon4 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[3].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmObjectLinear;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 4
  end; // with form1
end;

procedure AddPlantsG;
var
  i,ranX,ranY,ranRotation:Integer;
begin
  for i:=1 to 2000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY)) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,4,ranRotation);
      // save to array
      fMainMenu.M_plants_G[i].posX:=ranX;
      fMainMenu.M_plants_G[i].posY:=ranY;
      fMainMenu.M_plants_G[i].itemId:=4;
      fMainMenu.M_plants_G[i].itemRotation:=ranRotation;
      //
  end; // for
end;

procedure SetPlantsG_prop;
begin
  with Form1 do begin
    with MultiPolygon5 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[3].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmObjectLinear;
      //Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 5

    with MultiPolygon6 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[3].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmObjectLinear;
      //Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 6
  end; // with form1
end;

procedure AddPlantsH;
var
  i,ranX,ranY,ranRotation:Integer;
begin
  for i:=1 to 2000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY)) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,5,ranRotation);
      // save to array
      fMainMenu.M_plants_H[i].posX:=ranX;
      fMainMenu.M_plants_H[i].posY:=ranY;
      fMainMenu.M_plants_H[i].itemId:=5;
      fMainMenu.M_plants_H[i].itemRotation:=ranRotation;
      //
  end; // for
end;

procedure AddPlantsI;
var
  i,ranX,ranY,ranRotation:Integer;
begin
  for i:=1 to 2000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY)) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,6,ranRotation);
      // save to array
      fMainMenu.M_plants_I[i].posX:=ranX;
      fMainMenu.M_plants_I[i].posY:=ranY;
      fMainMenu.M_plants_I[i].itemId:=6;
      fMainMenu.M_plants_I[i].itemRotation:=ranRotation;
      //
  end; // for
end;

procedure AddPlantsJ;
var
  i,ranX,ranY,ranRotation:Integer;
begin
  for i:=1 to 2000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY)) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,7,ranRotation);
      // save to array
      fMainMenu.M_plants_J[i].posX:=ranX;
      fMainMenu.M_plants_J[i].posY:=ranY;
      fMainMenu.M_plants_J[i].itemId:=7;
      fMainMenu.M_plants_J[i].itemRotation:=ranRotation;
      //
  end; // for
end;

procedure SetPlantsJ_prop;
begin
  with Form1 do begin
    with Sphere5 do begin
      Material.Texture.Image:=GLMLHudSprites.Materials[2].Material.Texture.Image;
      Material.Texture.MappingMode:=tmmUser;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.Disabled:=false;
    end; // with 1
  end; // with form1
end;

procedure AddPlantsK;
var
  i,ranX,ranY,ranRotation:Integer;
begin
  for i:=1 to 2000 do begin
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY)) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,8,ranRotation);
      // save to array
      fMainMenu.M_plants_K[i].posX:=ranX;
      fMainMenu.M_plants_K[i].posY:=ranY;
      fMainMenu.M_plants_K[i].itemId:=8;
      fMainMenu.M_plants_K[i].itemRotation:=ranRotation;
      //
  end; // for
end;

procedure AddEnemiesA;
var
   i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
      for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,50,ranRotation);
      // save to array
      fMainMenu.M_enemy_A[i].posX:=ranX;
      fMainMenu.M_enemy_A[i].posY:=ranY;
      fMainMenu.M_enemy_A[i].itemId:=50;
      fMainMenu.M_enemy_A[i].itemRotation:=ranRotation;
      //
      end;
  end; // with
end;

procedure SetEnemiesA_prop;
var
  i:byte;
  spec:enemyInfo;
  ranX, ranY:Integer;
begin
  with Form1 do begin
    for i:=1 to enemA do begin
      //  choose random point x:[-4161: 968]  y:[642:5446]
        Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
        enemiesTypeA[i]:=TActor(DCEnemies.AddNewChild(TActor));
       // enemy:=Actor2;
        with enemiesTypeA[i] do begin
        LoadFromFile('tris.md2');
        Material.Texture.Image.LoadFromFile('skin_EA.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.3, 0.3, 0.1, 0);

        spec:=enemyInfo.Create(enemiesTypeA[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('EA');
        Behaviours.Add(spec);

        Tag:=50;

        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('stand',true);

       TransformationChanged;
       end;

       enemiesTypeA_core[i]:=TSphere(DCEnemies.AddNewChild(TSphere));

      with enemiesTypeA_core[i] do begin

        Scale.SetVector(1, 1, 1, 0);
        Radius:=0.01;
        Tag:=50;
        Roll(0);
        Visible:=true;

       TransformationChanged;
     end; // with

   end;
  end; // with
end;

procedure AddEnemiesB;
var
   i,j,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
      // alien enemy
  for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,51,ranRotation);
      // save to array
      fMainMenu.M_enemy_B[i].posX:=ranX;
      fMainMenu.M_enemy_B[i].posY:=ranY;
      fMainMenu.M_enemy_B[i].itemId:=51;
      fMainMenu.M_enemy_B[i].itemRotation:=ranRotation;
      //
  end;
  end;  // with
end;

procedure SetEnemiesB_prop;
var
  i,j:byte;
  spec:enemyInfo;
  ranX,ranY : Integer;
begin
  with Form1 do begin
   for i:=1 to enemB do begin
     //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);

        enemiesTypeB[i]:=TActor(DCEnemies.AddNewChild(TActor));
       // enemy:=Actor2;
        with enemiesTypeB[i] do begin
        LoadFromFile('alien_tris.md2');
        Material.Texture.Image.LoadFromFile('alien_skin_A.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.25, 0.25, 0.25, 0);

        spec:=enemyInfo.Create(enemiesTypeB[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('EB');;

        Behaviours.Add(spec);

        Tag:=60;

        Interval:=150;
        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('stand',true);

       TransformationChanged;
       end;

     // proceed EB conv
     for j:= 1 to 5 do begin
       enemiesTypeB_fireconv[i][j]:=TSphere(DCEnemies.AddNewChild(TSphere));
        with enemiesTypeB_fireconv[i][j] do begin
          Scale.SetVector(1, 1, 1, 0);
          Radius:= 0.001;//0.001;
          Tag:=0; //50
          Roll(0);
          Visible:=true;

         TransformationChanged;
       end; // with
     end; // for j

   end; // for all
  end; // with
end;

procedure AddEnemiesC;
var
   i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    // bug enemy
  for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,52,ranRotation);
      // save to array
      fMainMenu.M_enemy_C[i].posX:=ranX;
      fMainMenu.M_enemy_C[i].posY:=ranY;
      fMainMenu.M_enemy_C[i].itemId:=52;
      fMainMenu.M_enemy_C[i].itemRotation:=ranRotation;
      //
  end;
  end; // with
end;

procedure SetEnemiesC_prop;
var
  i:byte;
  spec:enemyInfo;
  ranX,ranY: Integer;
begin
  with Form1 do begin
    for i:=1 to enemC do begin
      //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);

      enemiesTypeC[i]:=TActor(DCEnemies.AddNewChild(TActor));

        with enemiesTypeC[i] do begin
        LoadFromFile('bug_tris.md2');
        Material.Texture.Image.LoadFromFile('bug_skinA.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.16, 0.16, 0.16, 0);

        spec:=enemyInfo.Create(enemiesTypeC[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('EC');;

        Behaviours.Add(spec);

        Tag:=70;

        Interval:=80;
        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('stand',true);

       TransformationChanged;
       end;

   end; // for all
  end; // with
end;

procedure AddEnemiesD;
var
   i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    // insect enemy
  for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,53,ranRotation);
      // save to array
      fMainMenu.M_enemy_D[i].posX:=ranX;
      fMainMenu.M_enemy_D[i].posY:=ranY;
      fMainMenu.M_enemy_D[i].itemId:=53;
      fMainMenu.M_enemy_D[i].itemRotation:=ranRotation;
      //
  end;
  end; // with
end;

procedure SetEnemiesD_prop;
var
  i:byte;
  spec:enemyInfo;
  ranX,ranY: Integer;
begin
  with Form1 do begin
    for i:=1 to enemD do begin
      //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);

      enemiesTypeD[i]:=TActor(DCEnemies.AddNewChild(TActor));

        with enemiesTypeD[i] do begin
        LoadFromFile('insect_tris.md2');
        Material.Texture.Image.LoadFromFile('insect_skinA.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.25, 0.25, 0.25, 0);

        spec:=enemyInfo.Create(enemiesTypeD[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('ED');;

        Behaviours.Add(spec);

        Tag:=80;

        Interval:=140;
        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('bstnd',true);

       TransformationChanged;
       end;
   end; // for all
  end; //with
end;

procedure AddEnemiesE;
var
   i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    // frog enemy
  for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,54,ranRotation);
      // save to array
      fMainMenu.M_enemy_E[i].posX:=ranX;
      fMainMenu.M_enemy_E[i].posY:=ranY;
      fMainMenu.M_enemy_E[i].itemId:=54;
      fMainMenu.M_enemy_E[i].itemRotation:=ranRotation;
      //
  end;
  end; // with
end;

procedure SetEnemiesE_prop;
var
  i:byte;
  spec:enemyInfo;
  ranX,ranY: Integer;
begin
  with Form1 do begin
    for i:=1 to enemE do begin
      //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);

      enemiesTypeE[i]:=TActor(DCEnemies.AddNewChild(TActor));

        with enemiesTypeE[i] do begin
        LoadFromFile('frog_tris.md2');
        Material.Texture.Image.LoadFromFile('frog_skinA.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.25, 0.25, 0.25, 0);

        spec:=enemyInfo.Create(enemiesTypeE[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('EE');;

        Behaviours.Add(spec);

        Tag:=90;

        Interval:=80;
        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('stand',true);

       TransformationChanged;
       end;

      enemiesTypeE_core[i]:=TSphere(DCEnemies.AddNewChild(TSphere));

      with enemiesTypeE_core[i] do begin
        Scale.SetVector(1, 1, 1, 0);
        Radius:=0.0001; //0.01
        Tag:=50;
        Roll(0);
        Visible:=true;

        TransformationChanged;
     end; // with
   end; // for all
  end;
end;

procedure AddEnemiesF;
var
   i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    // drio enemy
  for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,55,ranRotation);
      // save to array
      fMainMenu.M_enemy_F[i].posX:=ranX;
      fMainMenu.M_enemy_F[i].posY:=ranY;
      fMainMenu.M_enemy_F[i].itemId:=55;
      fMainMenu.M_enemy_F[i].itemRotation:=ranRotation;
      //
  end;
  end; // with
end;

procedure SetEnemiesF_prop;
var
  i:byte;
  spec:enemyInfo;
  ranX,ranY: Integer;
begin
  with Form1 do begin
    for i:=1 to enemF do begin
      //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);

      enemiesTypeF[i]:=TActor(DCEnemies.AddNewChild(TActor));

        with enemiesTypeF[i] do begin
        LoadFromFile('drio_tris.md2');
        Material.Texture.Image.LoadFromFile('drio_skinA.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.25, 0.25, 0.25, 0);

        spec:=enemyInfo.Create(enemiesTypeF[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('EF');;

        Behaviours.Add(spec);

        Tag:=100;

        Interval:=80;
        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('stand',true);

       TransformationChanged;
       end;

       enemiesTypeF_core[i]:=TSphere(DCEnemies.AddNewChild(TSphere));

      with enemiesTypeF_core[i] do begin
        Scale.SetVector(1, 1, 1, 0);
        Radius:=0.0001; //0.01
        Tag:=50;
        Roll(0);
        Visible:=true;

        TransformationChanged;
     end; // with
    end; // for all
  end;
end;

procedure AddEnemiesG;
var
   i,ranX,ranY,ranRotation : Integer;
begin
  with Form1 do begin
    // okta enemy
  for i:=1 to 2000 do begin   //16000
      fMainMenu.update_loading_progress;
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);
      ranRotation:=RandomRange(0,250);
      if(isPlantDNearby(ranX,ranY))or
        (TerrainRenderer1.InterpolatedHeight(VectorMake(ranX,0,ranY))<= -22) then begin
        Continue;
      end;
      terrObsFillCell(ranX,ranY,56,ranRotation);
      // save to array
      fMainMenu.M_enemy_G[i].posX:=ranX;
      fMainMenu.M_enemy_G[i].posY:=ranY;
      fMainMenu.M_enemy_G[i].itemId:=56;
      fMainMenu.M_enemy_G[i].itemRotation:=ranRotation;
      //
  end;
  end; // with
end;

procedure SetEnemiesG_prop;
var
  i:byte;
  spec:enemyInfo;
  ranX,ranY: Integer;
begin
  with Form1 do begin
    for i:=1 to enemG do begin
      //  choose random point x:[-4161: 968]  y:[642:5446]
      Randomize;
      ranX:=RandomRange(-4161,968);
      ranY:=RandomRange(642,5446);

      enemiesTypeG[i]:=TActor(DCEnemies.AddNewChild(TActor));

        with enemiesTypeG[i] do begin
        LoadFromFile('okta_tris.md2');
        Material.Texture.Image.LoadFromFile('okta_skinA.jpg');
        Material.Texture.Disabled:=false;
        Direction:=Actor2.Direction;
        Up:=Actor2.Up;
        Scale.SetVector(0.25, 0.25, 0.25, 0);

        spec:=enemyInfo.Create(enemiesTypeG[i].Behaviours);
        spec.isAlive:=true;
        spec.fired:=false;
        spec.hasTarget:=false;
        spec.oldPositionX:=ranX;
        spec.oldPositionZ:=ranY;
        spec.Life:=initEnemyInfoLife('EG');;

        Behaviours.Add(spec);

        Tag:=110;

        Interval:=80;
        Roll(0);
        AnimationMode:=aamLoop;
        SwitchToAnimation('stand',true);

       TransformationChanged;
       end;

      enemiesTypeG_core[i]:=TSphere(DCEnemies.AddNewChild(TSphere));

      with enemiesTypeG_core[i] do begin
        Scale.SetVector(1, 1, 1, 0);
        Radius:=0.0001; //0.01
        Tag:=50;
        Roll(0);
        Visible:=true;

        TransformationChanged;
     end; // with
   end; // for all
  end; // with
end;

procedure AddHUDSpriteTopBase(mode:byte);
begin
  with Form1 do begin
    //hud_top:THUDSprite

  hud_top:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_10.bmp');
    // set position and dimension
    Position.X:=400;
    Position.Y:=128;
    Height:=257; // 256
    Width:=800;
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  ///////////////////////////////
  // life
  hud_top_life:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_life do begin
    // load image BMP 256x128
    Material.Texture.Image.LoadFromFile('life_sprite.bmp');
    // set position and dimension
    Position.X:=38; // 38
    Position.Y:=0;  // 0
    Height:=80;     // 80
    Width:=228;     // 228

    Rotation:=-90;

    Material.FrontProperties.Ambient.Alpha:=0.7;
    Material.FrontProperties.Ambient.Red:=1;
    Material.FrontProperties.Ambient.Green:=0;
    Material.FrontProperties.Ambient.Blue:=0;

    Material.FrontProperties.Diffuse.Alpha:=0.7;
    Material.FrontProperties.Diffuse.Red:=1;
    Material.FrontProperties.Diffuse.Green:=0;
    Material.FrontProperties.Diffuse.Blue:=0;

    Material.FrontProperties.Emission.Alpha:=0.7;
    Material.FrontProperties.Emission.Red:=1;
    Material.FrontProperties.Emission.Green:=0;
    Material.FrontProperties.Emission.Blue:=0;

    Material.FrontProperties.Shininess:=10;

    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmAdditive;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;

    TransformationChanged;
  end; // with

  ///////////////////////////////
  // mana
  hud_top_mana:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_mana do begin
    // load image BMP 256x128
    Material.Texture.Image.LoadFromFile('energy_sprite.bmp');
    // set position and dimension
    Position.X:=760;
    Position.Y:=0;
    Height:=80;
    Width:=228;

    Rotation:=90;

    Material.FrontProperties.Ambient.Alpha:=0.7;
    Material.FrontProperties.Ambient.Red:=0;
    Material.FrontProperties.Ambient.Green:=0;
    Material.FrontProperties.Ambient.Blue:=1;

    Material.FrontProperties.Diffuse.Alpha:=0.7;
    Material.FrontProperties.Diffuse.Red:=0;
    Material.FrontProperties.Diffuse.Green:=0;
    Material.FrontProperties.Diffuse.Blue:=1;

    Material.FrontProperties.Emission.Alpha:=0.7;
    Material.FrontProperties.Emission.Red:=0;
    Material.FrontProperties.Emission.Green:=0;
    Material.FrontProperties.Emission.Blue:=1;

    Material.FrontProperties.Shininess:=10;

    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmAdditive;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  ///////////////////////////////

  ///////////////////////////////
  //hud_top:THUDSprite
  // ornament A
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
    //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
    // set position and dimension
    Position.X:=90; // 160
    Position.Y:=80;  // 50
    Height:=400;
    Width:=400;


    Rotation:=-90;
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
    //TransformationChanged;
  end; // with


  // ornament B
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14.bmp');
    // set position and dimension
    Position.X:=200;
    Position.Y:=40;
    Height:=360;
    Width:=360;

    //Rotation:=180; // -180
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  //hud_top:THUDSprite
  // ornament C
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14.bmp');
    // set position and dimension
    Position.X:=80;
    Position.Y:=100;
    Height:=512;
    Width:=512;

    Rotation:=-180;
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  // ornament E
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14.bmp');
    // set position and dimension
    Position.X:=300;
    Position.Y:=40;
    Height:=340;
    Width:=340;

    //Rotation:=180; // -180
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  //----------------------------------------------------------------
  // right side ornaments
    //hud_top:THUDSprite
  // ornament A
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14_r.bmp');
    // set position and dimension
    Position.X:=710; // 160
    Position.Y:=80;  // 50
    Height:=400;
    Width:=400;


    Rotation:=90;
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
  end; // with


  // ornament B
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14_r.bmp');
    // set position and dimension
    Position.X:=600;
    Position.Y:=40;
    Height:=360;
    Width:=360;

    //Rotation:=180; // -180
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  //hud_top:THUDSprite
  // ornament C
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14_r.bmp');
    // set position and dimension
    Position.X:=720;
    Position.Y:=100;
    Height:=512;
    Width:=512;

    Rotation:=-180;
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  // ornament E
  hud_top_ornament:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  with hud_top_ornament do begin
    // load image BMP
    Material.Texture.Image.LoadFromFile('base_14_r.bmp');
    // set position and dimension
    Position.X:=500;
    Position.Y:=40;
    Height:=340;
    Width:=340;

    //Rotation:=180; // -180
    // set proper transperancy
    Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
    Material.BlendingMode:=bmTransparency;  // uses GLTexture
    Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    Material.Texture.TextureFormat:=tfDefault; //tfRGBA
    Material.Texture.TextureMode:=tmModulate;
    Material.Texture.TextureWrap:=twBoth; //None
    // allow texture
    Material.Texture.Disabled:=false;
  end; // with

  //------------ ornament right

  // box
  hud_top_text_box:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_top_text_box do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        // set X
        Position.X:=400;
        Position.Y:=28;


        Height:=50;
        Width:=300;
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
    AddHUDSpriteTopMenu(mode);
  end; // with
end;

procedure AddHUDSpriteObjectiveBase;
var
  startX, startY:Integer;
begin
    with Form1 do begin
    // objectives
    startX:=400;
    startY:=300;
    hud_objectives_base:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_objectives_base do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('objectives_base.bmp');
      // set position and dimension
      Position.X:=startX;  //656 - 36
      Position.Y:=startY;
      Height:=512; // 426
      Width:=512;  // 513

      //Rotation:=90; // -180
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end; // with

    // ornament A
    hud_obj_ornament_A:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_A do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-200; // 160
      Position.Y:=startY-60;  // 50
      Height:=400;
      Width:=400;

      Rotation:=90;
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
    end; // with



    // ornament B
    hud_obj_ornament_B:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_B do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-200; // 160
      Position.Y:=startY+60;  // 50
      Height:=400;
      Width:=400;

      Rotation:=90;
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
    end; // with

    // ornament C
    hud_obj_ornament_C:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_C do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+200; // 160
      Position.Y:=startY-60;  // 50
      Height:=400;
      Width:=400;


      Rotation:=-90;
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
    end; // with



    // ornament D
    hud_obj_ornament_D:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_D do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+200; // 160
      Position.Y:=startY+60;  // 50
      Height:=400;
      Width:=400;


      Rotation:=-90;
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
    end; // with

    // horizontal top
    // ornament E
    hud_obj_ornament_E:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_E do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-130; // 160
      Position.Y:=startY-120;  // 50
      Height:=400;
      Width:=400;

      //Rotation:=90;
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
    end; // with



    // ornament F
    hud_obj_ornament_F:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_F do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+130; // 160
      Position.Y:=startY-120;  // 50
      Height:=400;
      Width:=400;

      //Rotation:=90;
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
    end; // with

    // ornament G
    hud_obj_ornament_G:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_G do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX-130; // 160
      Position.Y:=startY+123;  // 50
      Height:=400;
      Width:=400;

      Rotation:=180;
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
    end; // with



    // ornament H
    hud_obj_ornament_H:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_obj_ornament_H do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=startX+130; // 160
      Position.Y:=startY+123;  // 50
      Height:=400;
      Width:=400;

      Rotation:=180;
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
    end; // with

    // Text Memo
    hud_obj_text_area:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_obj_text_area do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('text_area_A.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=startY;
        Height:=200; // 50
        Width:=360;
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

      // Objective text
      hud_obj_text_caption:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_obj_text_caption do begin
        // load image BMP
        Alignment:=taCenter;
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=(startX+5);
        Position.Y:=(startY-80);
        Text:=getObjectiveText;
        Visible:=false;
      end;// with

      // close btn
      hud_obj_closeBtn_Up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_obj_closeBtn_Up do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_up.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        Position.X:=startX;
        Position.Y:=startY+115;

        Height:=50;
        Width:=50;
        //Rotation:=-90;
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

      hud_obj_closeBtn_Down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_obj_closeBtn_Down do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_down.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        Position.X:=startX;
        Position.Y:=startY+115;

        Height:=50;
        Width:=50;
        //Rotation:=-90;
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
  end; // with Form1
end;

procedure AddHUDSpriteTopMenu(mode:byte);
begin
  AddHUDSpriteTopMenuSpells(mode);
  AddHUDSpriteTopMenuWindows;

  AddHudSpriteTopLifeView;
  AddHudSpriteTopManaView;

  AddHUDSpriteTopMenuSaveAndExit;
end;

procedure AddHUDSpriteTopMenuSpells(mode:byte);
var
  i:byte;
  pic_fname_up, pic_fname_down, sp_name:String;
  startX, startY:Integer;
begin
  startX:=580;
  startY:=28;
  with Form1 do begin
    // lightning spell btn up
    for i:=1 to 5 do begin
      case i of
        1: begin
          pic_fname_up:='light_btn_up.bmp';
          pic_fname_down:='light_btn_down.bmp';
          sp_name:='lightning';
        end;
        2: begin
          pic_fname_up:='chain_light_btn_up.bmp';
          pic_fname_down:='chain_light_btn_down.bmp';
          sp_name:='chain_lightning';
        end;
        3: begin
          pic_fname_up:='nova_btn_up.bmp';
          pic_fname_down:='nova_btn_down.bmp';
          sp_name:='nova';
        end;
        4: begin
          pic_fname_up:='buildweb_btn_up.bmp';
          pic_fname_down:='buildweb_btn_down.bmp';
          sp_name:='build_web';
        end;
        5: begin
          pic_fname_up:='destroyweb_btn_up.bmp';
          pic_fname_down:='destroyweb_btn_down.bmp';
          sp_name:='destroy_web';
        end;
      end; // case


    hud_menu_spells[i].hud_spell_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_menu_spells[i].hud_spell_pic_up do begin
      // load image BMP
      hud_menu_spells[i].spell_name:=sp_name;
      Material.Texture.Image.LoadFromFile(pic_fname_up); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=580; //400
      Position.Y:=28;
        hud_menu_spells[i].posX:=startX;
        hud_menu_spells[i].posY:=(startY + (i*50)-50);
      Height:=50;
      Width:=50; // 300
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
    hud_menu_spells[i].hud_spell_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_menu_spells[i].hud_spell_pic_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile(pic_fname_down); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=580; //400
      Position.Y:=28;
      Height:=50;
      Width:=50; // 300
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

  if (mode=0) then
    hud_menu_spells[1].hud_spell_pic_up.Visible:=true;
  end; // with Form1
end;

procedure AddHUDSpriteTopMenuWindows;
var
  i:byte;
  pic_fname_up, pic_fname_down, wnd_name:String;
  startX, startY:Integer;
begin
  startX:=220; // 580
  startY:=28;
  with Form1 do begin
    // lightning spell btn up
    for i:=1 to 5 do begin
      case i of
        1: begin
          pic_fname_up:='drop_menu_btn_up.bmp';
          pic_fname_down:='drop_menu_btn_down.bmp';
          wnd_name:='dropper';
        end;
        2: begin
          pic_fname_up:='inv_menu_btn_up.bmp';
          pic_fname_down:='inv_menu_btn_down.bmp';
          wnd_name:='inventory';
        end;
        3: begin
          pic_fname_up:='hero_menu_btn_up.bmp';
          pic_fname_down:='hero_menu_btn_down.bmp';
          wnd_name:='hero';
        end;
        4: begin
          pic_fname_up:='webs_menu_btn_up.bmp';
          pic_fname_down:='webs_menu_btn_down.bmp';
          wnd_name:='webs';
        end;
        5: begin
          pic_fname_up:='spells_menu_btn_up.bmp';
          pic_fname_down:='spells_menu_btn_down.bmp';
          wnd_name:='spells';
        end;
      end; // case


    hud_menu_windows[i].hud_window_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_menu_windows[i].hud_window_pic_up do begin
      // load image BMP
      hud_menu_windows[i].window_name:=wnd_name;
      Material.Texture.Image.LoadFromFile(pic_fname_up); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=220; //580
      Position.Y:=28;
        hud_menu_windows[i].posX:=startX;
        hud_menu_windows[i].posY:=(startY + (i*50)-50);
      Height:=50;
      Width:=50; // 300
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
    hud_menu_windows[i].hud_window_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_menu_windows[i].hud_window_pic_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile(pic_fname_down); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=220; //580
      Position.Y:=28;
      Height:=50;
      Width:=50; // 300
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

  hud_menu_windows[1].hud_window_pic_up.Visible:=true;
  end; // with Form1
end;

procedure AddHUDSpriteTopMenuSaveAndExit;
var
  i, temp_height, temp_width:byte;
  pic_fname_up, pic_fname_down, wnd_name:String;
  startX, startY, temp_pos_X , temp_pos_Y:Integer;
begin
  startX:=400; // 580
  startY:=48; //28
  with Form1 do begin
    for i:=1 to 2 do begin
      case i of
        1: begin
          pic_fname_up:='exited_up.bmp';
          pic_fname_down:='exited_down.bmp';
          wnd_name:='dropper';
          temp_height:=16;
          temp_width:=16;
          temp_pos_X:=startX;
          temp_pos_Y:=(startY + (i*16)-16);
        end;
        2: begin
          pic_fname_up:='save_exit_btn_up.bmp';
          pic_fname_down:='save_exit_btn_down.bmp';
          wnd_name:='save_exit';
          temp_height:=50;
          temp_width:=200; //242
          temp_pos_X:=startX;
          temp_pos_Y:=(startY + 20 +(i*16)-16);
        end;
      end; // case


    hud_menu_exit[i].hud_window_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_menu_exit[i].hud_window_pic_up do begin
      // load image BMP
      hud_menu_exit[i].window_name:=wnd_name;
      Material.Texture.Image.LoadFromFile(pic_fname_up); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX; //580
      Position.Y:=startY;
        hud_menu_exit[i].posX:=temp_pos_X;
        hud_menu_exit[i].posY:=temp_pos_Y; // temp_height
      Height:=temp_height; // 32
      Width:=temp_width;  // 32
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
    hud_menu_exit[i].hud_window_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_menu_exit[i].hud_window_pic_down do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile(pic_fname_down); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      // set X
      Position.X:=startX; //580
      Position.Y:=startY;
      Height:=temp_height;
      Width:=temp_width; // 300
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

  hud_menu_exit[1].hud_window_pic_up.Visible:=true;
  end; // with Form1
end;

procedure swapSpellWithFirst(idx:byte);
var
  buff_hud_spell_pic_up, buff_hud_spell_pic_down:THUDSprite;
  buff_spell_name:String;
begin
  with Form1 do begin
  try
  // buffer idx spell props
  buff_spell_name:=hud_menu_spells[idx].spell_name;
  buff_hud_spell_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  buff_hud_spell_pic_up.Visible:=false;

  buff_hud_spell_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
  buff_hud_spell_pic_down.Visible:=false;

  buff_hud_spell_pic_up.Assign(hud_menu_spells[idx].hud_spell_pic_up);
  buff_hud_spell_pic_down.Assign(hud_menu_spells[idx].hud_spell_pic_down);

  hud_menu_spells[idx].spell_name:=hud_menu_spells[1].spell_name;
  hud_menu_spells[idx].hud_spell_pic_up.Assign(hud_menu_spells[1].hud_spell_pic_up);
  hud_menu_spells[idx].hud_spell_pic_down.Assign(hud_menu_spells[1].hud_spell_pic_down);

  with hud_menu_spells[1] do begin
    spell_name:=buff_spell_name;
    hud_spell_pic_up.Assign(buff_hud_spell_pic_up);
    hud_spell_pic_down.Assign(buff_hud_spell_pic_down);
  end; // with

  // print
  if (hud_menu_spells[1].spell_name='lightning') then
    printTextBarInfo('LIGHTNING',0);

  if (hud_menu_spells[1].spell_name='chain_lightning') then
    printTextBarInfo('CHAIN LIGHTNING',0);

  if (hud_menu_spells[1].spell_name='nova') then
    printTextBarInfo('NOVA',0);

  if (hud_menu_spells[1].spell_name='build_web') then
    printTextBarInfo('BUILD WEB',0);

  if (hud_menu_spells[1].spell_name='destroy_web') then
    printTextBarInfo('DESTROY WEB',0);

  // change MH spell
  MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon:=hud_menu_spells[1].spell_name;
  // free buffer
  finally
    buff_hud_spell_pic_up.Free;
    buff_hud_spell_pic_down.Free;
  end;
  end; // with form1
end;

procedure swapWindowWithFirst(idx:byte);
begin
  if (idx=2) then begin
    // show inv
    printTextBarInfo('INV',0);
    showMenuChoosenWindow('inventory');
  end;
  if (idx=3) then begin
    // show hero
    printTextBarInfo('HERO',0);
    showMenuChoosenWindow('hero');
  end;
  if (idx=4) then begin
    // show webs
    printTextBarInfo('WEBS',0);
    showMenuChoosenWindow('webs');
  end;
  if (idx=5) then begin
    // show webs
    printTextBarInfo('SPELLS',0);
    showMenuChoosenWindow('spells');
  end;

end;

procedure showMenuChoosenWindow(wnd_name:String);
begin
  with Form1 do begin
    // ---------------
    if (wnd_name='inventory') then begin
      // show inventory
      invokeInventoryWindow(true);
    end; // if inv
    //----------------
    if (wnd_name='hero') then begin
      // show hero
      invokeHeroWindow(true);
    end; // if hero
    //----------------
    //----------------
    if (wnd_name='webs') then begin
      // show webs
      invokeWebsWindow(true);
    end; // if hero
    //----------------
    if (wnd_name='spells') then begin
      // show webs
      invokeSpellsWindow(true);
    end; // if hero
    //----------------

  end; // with form1
end;

function processTopMenuSpells_MouseDown(posX,posY:Integer):boolean;
var
  X,Y:Integer;
  spell_id, i:byte;
begin
  Result:=false;
  X:=posX;
  Y:=posY;
  with Form1 do begin
    if not(spells_menu_isDown) then begin
      if ((X > 555)and(X < 605)and(Y > 3)and(Y < 53)) then begin
        // dropped
        hud_menu_spells[1].hud_spell_pic_down.Visible:=true;
        hud_menu_spells[1].hud_spell_pic_up.Visible:=false;
        Result:=true;
      end; // if in
    end
    else
    begin
      // choose
      spell_id:=getUnderMouseSpellMenuCellIndex(X,Y);
      if (spell_id > 0) then begin
        //HUDText2.Text:='ID: '+IntToStr(spell_id);
        picked_spell_id:=spell_id;
        hud_menu_spells[spell_id].hud_spell_pic_down.Visible:=true;
        hud_menu_spells[spell_id].hud_spell_pic_up.Visible:=false;
        Result:=true;
      end; // if >0
      if (spell_id = 0) then begin
        // close Spells and let go
        for i := 2 to 5 do begin
          // set drop down position
          with hud_menu_spells[i].hud_spell_pic_down do begin
            Position.Y:=28; //hud_menu_spells[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_spells[i].hud_spell_pic_up do begin
            Position.Y:=28;//hud_menu_spells[i].posY;
            Visible:=false;
          end; // with up
        end;  // for
        spells_menu_isDown:=false;
      end; // if =0
    end; // if not
  end; //with
end;

function processTopMenuWindows_MouseDown(posX,posY:Integer):boolean;
var
  X,Y:Integer;
  window_id, i:byte;
begin
  Result:=false;
  X:=posX;
  Y:=posY;
  with Form1 do begin
    if not(windows_menu_isDown) then begin
      // if ((X > 555)and(X < 605)and(Y > 3)and(Y < 53)) then begin
      if ((X > 195)and(X < 245)and(Y > 3)and(Y < 53)) then begin
        // dropped
        hud_menu_windows[1].hud_window_pic_down.Visible:=true;
        hud_menu_windows[1].hud_window_pic_up.Visible:=false;
        Result:=true;
      end; // if in
    end
    else
    begin
      // choose
      window_id:=getUnderMouseWindowsMenuCellIndex(X,Y);
      if (window_id > 0) then begin
        //HUDText2.Text:='ID: '+IntToStr(spell_id);
        picked_window_id:=window_id;
        hud_menu_windows[window_id].hud_window_pic_down.Visible:=true;
        hud_menu_windows[window_id].hud_window_pic_up.Visible:=false;
        Result:=true;
      end; // if >0
      if (window_id = 0) then begin
        // close Spells and let go
        for i := 2 to 5 do begin
          // set drop down position
          with hud_menu_windows[i].hud_window_pic_down do begin
            Position.Y:=hud_menu_windows[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_windows[i].hud_window_pic_up do begin
            Position.Y:=hud_menu_windows[i].posY;
            Visible:=false;
          end; // with up
        end;  // for
        windows_menu_isDown:=false;
      end; // if =0
    end; // if not
  end; //with
end;

function processTopMenuSpells_MouseUp(posX,posY:Integer):boolean;
var
  X,Y,startX,startY:Integer;
  spell_id,i,j:byte;
begin
  Result:=false;
  X:=posX;
  Y:=posY;
  with Form1 do begin
    if(hud_menu_spells[1].hud_spell_pic_down.Visible)and
    (hud_menu_spells[2].hud_spell_pic_up.Visible) then begin
      if(spells_menu_isDown) then begin
        // hide it
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        for i := 2 to 5 do begin
          with hud_menu_spells[i].hud_spell_pic_down do begin
            Position.Y:=28; //hud_menu_spells[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_spells[i].hud_spell_pic_up do begin
            Position.Y:=28; //hud_menu_spells[i].posY;
            Visible:=false;
          end; // with up
        end;  // for
        hud_menu_spells[1].hud_spell_pic_up.Visible:=true;
        hud_menu_spells[1].hud_spell_pic_down.Visible:=false;
        spells_menu_isDown:=false;
      end; // if menu down
    end; // if

    if(hud_menu_spells[1].hud_spell_pic_down.Visible)and
      (hud_menu_spells[2].hud_spell_pic_up.Visible=false) then begin
      if not(spells_menu_isDown) then begin
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        hud_menu_spells[1].hud_spell_pic_up.Visible:=true;
        hud_menu_spells[1].hud_spell_pic_down.Visible:=false;
        // drop down show all dropped spells
        startX:=580;
        startY:=28;
        j:=0;
        for i := 1 to 5 do begin
          if isTopMenuUpgradedSpell(i) then begin
            inc(j);

            hud_menu_spells[i].posX_visio:=startX;
            hud_menu_spells[i].posY_visio:=(startY + (j*50)-50);

            with hud_menu_spells[i].hud_spell_pic_down do begin
              Position.Y:=hud_menu_spells[i].posY_visio;
              Visible:=false;
            end; // with down
            with hud_menu_spells[i].hud_spell_pic_up do begin
              Position.Y:=hud_menu_spells[i].posY_visio;
              Visible:=true;
            end; // with up

          end; // if is

        end;  // for

        if (j>1) then
          spells_menu_isDown:=true;
        //Showmessage('j: '+IntToStr(j));
      end; // if not drop
    end; // if

    // if spells menu is dropped
    if (hud_menu_spells[2].hud_spell_pic_down.Visible)or
     (hud_menu_spells[3].hud_spell_pic_down.Visible)or
     (hud_menu_spells[4].hud_spell_pic_down.Visible)or
     (hud_menu_spells[5].hud_spell_pic_down.Visible) then begin
      // check exact cell and up-ed it
      spell_id:=getUnderMouseSpellMenuCellIndex(X,Y);
      if (spell_id <> 0) then begin
        picked_spell_id:=spell_id;
        hud_menu_spells[spell_id].hud_spell_pic_up.Visible:=true;
        hud_menu_spells[spell_id].hud_spell_pic_down.Visible:=false;
      end; // if <>0
      // hide it
      play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
      for i := 1 to 5 do begin
        with hud_menu_spells[i].hud_spell_pic_down do begin
          Position.Y:=28;//hud_menu_spells[i].posY;
          Visible:=false;
        end; // with down
        with hud_menu_spells[i].hud_spell_pic_up do begin
          Position.Y:=28;//hud_menu_spells[i].posY;
          Visible:=false;
        end; // with up
      end;  // for
      spells_menu_isDown:=false;
      if(spell_id <> 0) then
        fMainMenu.buff_last_spell_id:=spell_id; 
        swapSpellWithFirst(spell_id);
      // show first and up-ed it
      hud_menu_spells[1].hud_spell_pic_up.Visible:=true;
    end; // if true
  end; // for Form1
end;

procedure processTopMenuView_MouseDown(posX,posY:Integer);
begin
  with Form1 do begin
    //update_hud_top_view;
    // life view
    if( (posX > 105)and(posX < 155)and(posY > 3)and(posY < 53)) then begin
      if(hud_top_life_view_base.hud_item_pic_core.Visible) then begin
        // delete from inv
        removeCellFromInventory(150);
        // fill life
        MHdrinkCell(150);
        // update
        update_hud_top_view;
      end; // if visible
    end; // if in area

    // life view
    if( (posX > 645)and(posX < 695)and(posY > 3)and(posY < 53)) then begin
      if(hud_top_mana_view_base.hud_item_pic_core.Visible) then begin
        // delete from inv
        removeCellFromInventory(151);
        // fill mana
        MHdrinkCell(151);
        // update
        update_hud_top_view;
      end; // if visible
    end; // if in area
  end;
end;

procedure removeCellFromInventory(idx:byte);
var
  i:byte;
begin
  with Form1 do begin
    for i:= 12 downto 1 do begin
      if(hud_inv_carrier[i].itemID = idx) then begin
        // there is life cell
        // remove sprite
        deleteMovableHUDSpriteByName(hud_inv_carrier[i].hud_item_pic.name,
        hud_inv_carrier[i].hud_item_pic_core.name);
        // index=0
        hud_inv_carrier[i].itemID:=0;
        Exit;
      end; // if life cell
    end; // for
  end; // with form1
end;

function processTopMenuWindows_MouseUp(posX,posY:Integer):boolean;
var
  X,Y:Integer;
  window_id,i:byte;
begin
  Result:=false;
  X:=posX;
  Y:=posY;
  with Form1 do begin
    if(hud_menu_windows[1].hud_window_pic_down.Visible)and
    (hud_menu_windows[2].hud_window_pic_up.Visible) then begin
      if(windows_menu_isDown) then begin
        // hide it
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        for i := 2 to 5 do begin
          with hud_menu_windows[i].hud_window_pic_down do begin
            Position.Y:=hud_menu_windows[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_windows[i].hud_window_pic_up do begin
            Position.Y:=hud_menu_windows[i].posY;
            Visible:=false;
          end; // with up
        end;  // for
        hud_menu_windows[1].hud_window_pic_up.Visible:=true;
        hud_menu_windows[1].hud_window_pic_down.Visible:=false;
          showMenuChoosenWindow(hud_menu_windows[1].window_name);
        windows_menu_isDown:=false;
      end; // if menu down
    end; // if

    if(hud_menu_windows[1].hud_window_pic_down.Visible)and
      (hud_menu_windows[2].hud_window_pic_up.Visible=false) then begin
      if not(windows_menu_isDown) then begin
        hud_menu_windows[1].hud_window_pic_up.Visible:=true;
        hud_menu_windows[1].hud_window_pic_down.Visible:=false;

        // drop down show all dropped spells
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        for i := 1 to 5 do begin
          with hud_menu_windows[i].hud_window_pic_down do begin
            Position.Y:=hud_menu_windows[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_windows[i].hud_window_pic_up do begin
            Position.Y:=hud_menu_windows[i].posY;
            Visible:=true;
          end; // with up
        end;  // for
          showMenuChoosenWindow(hud_menu_windows[1].window_name);
        windows_menu_isDown:=true;
      end; // if not drop
    end; // if

    // if spells menu is dropped
    if (hud_menu_windows[2].hud_window_pic_down.Visible)or
     (hud_menu_windows[3].hud_window_pic_down.Visible)or
     (hud_menu_windows[4].hud_window_pic_down.Visible)or
     (hud_menu_windows[5].hud_window_pic_down.Visible) then begin
      // check exact cell and up-ed it
      window_id:=getUnderMouseWindowsMenuCellIndex(X,Y);
      if (window_id <> 0) then begin
        picked_window_id:=window_id;
        hud_menu_windows[window_id].hud_window_pic_up.Visible:=true;
        hud_menu_windows[window_id].hud_window_pic_down.Visible:=false;
      end; // if <>0
      // hide it
      play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
      for i := 1 to 5 do begin
        with hud_menu_windows[i].hud_window_pic_down do begin
          Position.Y:=28;//hud_menu_spells[i].posY;
          Visible:=false;
        end; // with down
        with hud_menu_windows[i].hud_window_pic_up do begin
          Position.Y:=28;//hud_menu_spells[i].posY;
          Visible:=false;
        end; // with up
      end;  // for
      windows_menu_isDown:=false;
      swapWindowWithFirst(window_id);
      // show first and up-ed it
      hud_menu_windows[1].hud_window_pic_up.Visible:=true;
    end; // if true
  end; // for Form1
end;

function processTopMenuSaveAndExit_MouseDown(posX,posY:Integer):boolean;
var
  X,Y:Integer;
  i,exit_id:byte;
begin
  Result:=false;
  X:=posX;
  Y:=posY;
  with Form1 do begin
    if not(exit_menu_isDown) then begin
      // if ((X > 555)and(X < 605)and(Y > 3)and(Y < 53)) then begin
      if ((X > 392)and(X < 408)and(Y > 40)and(Y < 56)) then begin
        // dropped
        hud_menu_exit[1].hud_window_pic_down.Visible:=true;
        hud_menu_exit[1].hud_window_pic_up.Visible:=false;
        Result:=true;
      end; // if in
    end
    else
    begin
      // choose
      exit_id:=getUnderMouseExitMenuCellIndex(X,Y);
      if (exit_id > 0) then begin
        //HUDText2.Text:='ID: '+IntToStr(spell_id);
        picked_exit_id:=exit_id;
        hud_menu_exit[exit_id].hud_window_pic_down.Visible:=true;
        hud_menu_exit[exit_id].hud_window_pic_up.Visible:=false;
        Result:=true;
      end; // if >0
      if (exit_id = 0) then begin
        // close Spells and let go
        for i := 2 to 2 do begin
          // set drop down position
          with hud_menu_exit[i].hud_window_pic_down do begin
            //Position.Y:=hud_menu_exit[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_exit[i].hud_window_pic_up do begin
            //Position.Y:=hud_menu_exit[i].posY;
            Visible:=false;
          end; // with up
        end;  // for
        exit_menu_isDown:=false;
      end; // if =0
    end; // if not
  end; //with
end;

function processTopMenuSaveAndExit_MouseUp(posX,posY:Integer):boolean;
var
  X,Y:Integer;
  i, exit_id:byte;
begin
  Result:=false;
  X:=posX;
  Y:=posY;
  with Form1 do begin
    if(hud_menu_exit[1].hud_window_pic_down.Visible)and
    (hud_menu_exit[2].hud_window_pic_up.Visible) then begin
      if(exit_menu_isDown) then begin
        // hide it
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        for i := 2 to 2 do begin
          with hud_menu_exit[i].hud_window_pic_down do begin
            //Position.Y:=hud_menu_exit[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_exit[i].hud_window_pic_up do begin
            //Position.Y:=hud_menu_exit[i].posY;
            Visible:=false;
          end; // with up
        end;  // for
        hud_menu_exit[1].hud_window_pic_up.Visible:=true;
        hud_menu_exit[1].hud_window_pic_down.Visible:=false;
          //showMenuChoosenWindow(hud_menu_windows[1].window_name);
        exit_menu_isDown:=false;
      end; // if menu down
    end; // if

    if(hud_menu_exit[1].hud_window_pic_down.Visible)and
      (hud_menu_exit[2].hud_window_pic_up.Visible=false) then begin
      if not(windows_menu_isDown) then begin
        hud_menu_exit[1].hud_window_pic_up.Visible:=true;
        hud_menu_exit[1].hud_window_pic_down.Visible:=false;

        // drop down show all dropped spells
        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        for i := 2 to 2 do begin
          with hud_menu_exit[i].hud_window_pic_down do begin
            Position.Y:=hud_menu_exit[i].posY;
            Visible:=false;
          end; // with down
          with hud_menu_exit[i].hud_window_pic_up do begin
            Position.Y:=hud_menu_exit[i].posY;
            Visible:=true;
          end; // with up
        end;  // for
          //processSaveAndExitMenu(hud_menu_exit[i].window_name);
        exit_menu_isDown:=true;
      end; // if not drop
    end; // if

    // if spells menu is dropped
    if (hud_menu_exit[2].hud_window_pic_down.Visible){or or} then begin
      // check exact cell and up-ed it
      exit_id:=getUnderMouseExitMenuCellIndex(X,Y);
      if (exit_id <> 0) then begin
        picked_exit_id:=exit_id;
        hud_menu_exit[exit_id].hud_window_pic_up.Visible:=true;
        hud_menu_exit[exit_id].hud_window_pic_down.Visible:=false;
      end; // if <>0
      // hide it
      play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
      for i := 1 to 2 do begin
        with hud_menu_exit[i].hud_window_pic_down do begin
          //Position.Y:=28;//hud_menu_spells[i].posY;
          Visible:=false;
        end; // with down
        with hud_menu_exit[i].hud_window_pic_up do begin
          //Position.Y:=28;//hud_menu_spells[i].posY;
          Visible:=false;
        end; // with up
      end;  // for
      exit_menu_isDown:=false;
      //swapWindowWithFirst(window_id);
      // show first and up-ed it
      hud_menu_exit[1].hud_window_pic_up.Visible:=true;
      processSaveAndExitMenu(hud_menu_exit[exit_id].window_name);
    end; // if true
  end; // for Form1
end;

procedure processSaveAndExitMenu(id_name:String);
begin
  with Form1 do begin
    if(id_name='save_exit') then begin
      // save the game
      MainMenu.fMainMenu.saveUserGame;
      // exit
      MainMenu.fMainMenu.current_level:=0;
      MainMenu.fMainMenu.MH_exp:=1;
      fMainMenu.buff_last_spell_id:=1;
      GLCadencer1.Enabled:=false;
      MainMenu.fMainMenu.showMainMenuActionButtons;
      MainMenu.fMainMenu.main_menu_current_state:= 'main_menu';
      Hide;
      MainMenu.fMainMenu.Refresh;
      MainMenu.fMainMenu.writeInErrorLog(2,'');
      stopAllGameSounds;
      destroyChild;
    end;
  end; // with
end;

procedure processMHChainLightningAnimation;
var
  i:Integer;
  f_start, f_end: Single;
begin
  with Form1 do begin
  // --- process MH ChainLightning strike effect
    if MHChain then begin
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

      inc(MHstrikePeriod);
    end
    else
    begin
      MHstrikePeriod:=0;
      darknesizeScene(global_f_start,global_f_end);
      darknessizing_scene:=false;
      for i:= 0 to MHchainCount do begin
        if Assigned(Form1.FindComponent('MHChain' + IntToStr(i))) then begin
          Form1.FindComponent('MHChain' + IntToStr(i)).Free;
        end; // if assigned
      end; // for all
      MHchainCount:=0;
      MHChain:=false;
      play_HerosAudioTrack(13,fMainMenu.global_game_volume_level,false,false);
    end;
  end;
  end; // with
end;

procedure processMHNovaAnimation;
var
  fx_id:Integer;
begin
  with Form1 do begin
// process MH Nova Effect
  if MH_in_nova_strike then begin
    if (MHstrikePeriod < 25) then begin
      inc(MHstrikePeriod);
    end
    else
    begin
      MHstrikePeriod:=0;
      MH_in_nova_strike:=false;
      fx_id:=DCMainHero.Effects.IndexOfName('MHNovaStrikeFX');
      if(fx_id <> -1) then
        DCMainHero.Effects[fx_id].Free;

      if Assigned(Form1.FindComponent('MHNovaStrike')) then
        Form1.FindComponent('MHNovaStrike').Free;
    end;
  end;
  //------------------------
  end; // with
end;

procedure processMHLightning(X, Y: Integer);
var
  i,j,k:Integer;
begin
  with Form1 do begin
    if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='lightning') then begin
  for j:=(Y-3) to (Y+3) do begin
    for i:=(X-3) to (X+3) do begin

      //- EA -----------------------
       if (terrObs[i,j].itemId=50) then begin

         // check each EA for exact match
         for k:=1 to enemA do begin

           if((round(enemiesTypeA[k].Position.X))=i)and((round(enemiesTypeA[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeA[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeA[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeA[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeA[k].TagFloat));

             fightEA(round(enemiesTypeA[k].TagFloat));

             Exit;
             end; // if mana
           end; // if exact

         end; // for all EA

       end; // if id=50
      //----------------------------

      //- EB -----------------------
       if (terrObs[i,j].itemId=51) then begin

         // check each EB for exact match
         for k:=1 to enemB do begin

           if((round(enemiesTypeB[k].Position.X))=i)and((round(enemiesTypeB[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeB[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeB[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeB[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeB[k].TagFloat));

             fightEB(round(enemiesTypeB[k].TagFloat));

             Exit;
             end; // if mana
           end; // if exact

         end; // for all EB

       end; // if id=51
      //----------------------------
      //- EC -----------------------
       if (terrObs[i,j].itemId=52) then begin

         // check each EC for exact match
         for k:=1 to enemC do begin

           if((round(enemiesTypeC[k].Position.X))=i)and((round(enemiesTypeC[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeC[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeC[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeC[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeC[k].TagFloat));

             fightEC(round(enemiesTypeC[k].TagFloat));

             Exit;
             end; // if mana
           end; // if exact

         end; // for all EB

       end; // if id=52
      //----------------------------
      //- ED -----------------------
       if (terrObs[i,j].itemId=53) then begin

         // check each ED for exact match
         for k:=1 to enemD do begin

           if((round(enemiesTypeD[k].Position.X))=i)and((round(enemiesTypeD[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeD[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeD[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeD[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeD[k].TagFloat));

             fightED(round(enemiesTypeD[k].TagFloat));

             Exit;
             end; // if mana
           end; // if exact

         end; // for all EB

       end; // if id=53
      //----------------------------
      //- EE -----------------------
       if (terrObs[i,j].itemId=54) then begin

         // check each ED for exact match
         for k:=1 to enemE do begin

           if((round(enemiesTypeE[k].Position.X))=i)and((round(enemiesTypeE[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeE[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeE[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeE[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeE[k].TagFloat));

             fightEE(round(enemiesTypeE[k].TagFloat));

             Exit;
             end;  // if mana
           end; // if exact

         end; // for all EE

       end; // if id=54
      //----------------------------
      //- EF -----------------------
       if (terrObs[i,j].itemId=55) then begin

         // check each ED for exact match
         for k:=1 to enemF do begin

           if((round(enemiesTypeF[k].Position.X))=i)and((round(enemiesTypeF[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeF[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeF[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeF[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeF[k].TagFloat));

             fightEF(round(enemiesTypeF[k].TagFloat));

             Exit;
             end; // if mana
           end; // if exact

         end; // for all EE

       end; // if id=55
      //----------------------------
      //- EG -----------------------
       if (terrObs[i,j].itemId=56) then begin

         // check each ED for exact match
         for k:=1 to enemG do begin

           if((round(enemiesTypeG[k].Position.X))=i)and((round(enemiesTypeG[k].Position.Z))=j) then begin

             if calcIsEnoughMHEnergy('lightning') then begin
             MHLightningStrike((round(enemiesTypeG[k].Position.X-DCMainHero.Position.X)),
                             (round(enemiesTypeG[k].Position.Z-DCMainHero.Position.Z)),
                             (round(enemiesTypeG[k].Position.Y-DCMainHero.Position.Y)),
                              round(enemiesTypeG[k].TagFloat));

             fightEG(round(enemiesTypeG[k].TagFloat));

             Exit;
             end; // if mana
           end; // if exact

         end; // for all EE

       end; // if id=55
      //----------------------------

    end; // for i
  end; // for j

  end; // if attack weapon = lightning
  end; // with
end;

procedure processMHChainLightning;
var
  i,j,k,MHx,MHy:Integer;
  cancelChain:boolean;
begin
  with Form1 do begin
    // chain lightning
  if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='chain_lightning') then begin
    if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
      cancelChain:=true;
      MHx:=round(DCMainHero.Position.X);
      MHy:=round(DCMainHero.Position.Z);

      if not (MHchain) then begin

        for j:= MHy-MH_chain_distance to MHy+MH_chain_distance do begin
          for i:= MHx-MH_chain_distance to MHx+MH_chain_distance do begin
            // if EA -----------------------------
            if (terrObs[i,j].itemId=50) then begin
              cancelChain:=false;
              for k:=1 to enemA do begin
                if((round(enemiesTypeA[k].Position.X))=i)and((round(enemiesTypeA[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeA[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeA[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeA[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeA[k].TagFloat));

                  EAChainExplodePrepare(k, 'normal');
                  fightEA(round(enemiesTypeA[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all EA
            end; // if 50
            ///////////////////---------------------
            // if EB -----------------------------
            if (terrObs[i,j].itemId=51) then begin
              cancelChain:=false;
              for k:=1 to enemB do begin
                if((round(enemiesTypeB[k].Position.X))=i)and((round(enemiesTypeB[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeB[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeB[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeB[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeB[k].TagFloat));

                  EBChainExplodePrepare(k, 'normal');
                  fightEB(round(enemiesTypeB[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all EB
            end; // if 51
            ///////////////////---------------------
            // if EC -----------------------------
            if (terrObs[i,j].itemId=52) then begin
              cancelChain:=false;
              for k:=1 to enemC do begin
                if((round(enemiesTypeC[k].Position.X))=i)and((round(enemiesTypeC[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeC[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeC[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeC[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeC[k].TagFloat));

                  ECChainExplodePrepare(k, 'normal');
                  fightEC(round(enemiesTypeC[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all EC
            end; // if 52
            ///////////////////---------------------
            // if ED -----------------------------
            if (terrObs[i,j].itemId=53) then begin
              cancelChain:=false;
              for k:=1 to enemD do begin
                if((round(enemiesTypeD[k].Position.X))=i)and((round(enemiesTypeD[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeD[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeD[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeD[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeD[k].TagFloat));

                  EDChainExplodePrepare(k, 'normal');
                  fightED(round(enemiesTypeD[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all ED
            end; // if 53
            ///////////////////---------------------
            // if EE -----------------------------
            if (terrObs[i,j].itemId=54) then begin
              cancelChain:=false;
              for k:=1 to enemE do begin
                if((round(enemiesTypeE[k].Position.X))=i)and((round(enemiesTypeE[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeE[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeE[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeE[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeE[k].TagFloat));

                  EEChainExplodePrepare(k, 'normal');
                  fightEE(round(enemiesTypeE[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all EE
            end; // if 54
            ///////////////////---------------------
            // if EF -----------------------------
            if (terrObs[i,j].itemId=55) then begin
              cancelChain:=false;
              for k:=1 to enemF do begin
                if((round(enemiesTypeF[k].Position.X))=i)and((round(enemiesTypeF[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeF[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeF[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeF[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeF[k].TagFloat));

                  EFChainExplodePrepare(k, 'normal');
                  fightEF(round(enemiesTypeF[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all EF
            end; // if 55
            ///////////////////---------------------
            // if EF -----------------------------
            if (terrObs[i,j].itemId=56) then begin
              cancelChain:=false;
              for k:=1 to enemG do begin
                if((round(enemiesTypeG[k].Position.X))=i)and((round(enemiesTypeG[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('chain_lightning') then begin
                  MHChainLightningStrike((round(enemiesTypeG[k].Position.X-DCMainHero.Position.X)),
                                   (round(enemiesTypeG[k].Position.Z-DCMainHero.Position.Z)),
                                   (round(enemiesTypeG[k].Position.Y-DCMainHero.Position.Y)),
                                    round(enemiesTypeG[k].TagFloat));

                  EGChainExplodePrepare(k, 'normal');
                  fightEG(round(enemiesTypeG[k].TagFloat));
                  end; // if
                end; // if exact
              end; // for all EG
            end; // if 56
            ///////////////////---------------------


          end; // for i
        end; // for j

        if not (cancelChain) then begin
          MHstrikePeriod:=0;
          MHchain:=true;
        end;
      end; // if not MHchain
      //-------------------------

    end; // if MH alive
  end; // if chain lightning
  end; // with
end;

procedure processMHNova;
var
  i,j,k,MHx,MHy:Integer;
  cancelChain:boolean;
begin
  with Form1 do begin
    if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='nova') then begin
    if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
      cancelChain:=true;
      MHx:=round(DCMainHero.Position.X);
      MHy:=round(DCMainHero.Position.Z);

      if not (MH_in_nova_strike) then begin
      for j:= MHy-MH_nova_distance to MHy+MH_nova_distance do begin
          for i:= MHx-MH_nova_distance to MHx+MH_nova_distance do begin
            // if EA -----------------------------
            if (terrObs[i,j].itemId=50) then begin
              //cancelChain:=false;
              for k:=1 to enemA do begin
                if((round(enemiesTypeA[k].Position.X))=i)and((round(enemiesTypeA[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('nova') then begin
                    fightEA(round(enemiesTypeA[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all EA
            end; // if 50
            ///////////////////---------------------
            // if EB -----------------------------
            if (terrObs[i,j].itemId=51) then begin
              //cancelChain:=false;
              for k:=1 to enemB do begin
                if((round(enemiesTypeB[k].Position.X))=i)and((round(enemiesTypeB[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('nova') then begin
                    fightEB(round(enemiesTypeB[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all EB
            end; // if 51
            ///////////////////---------------------
            // if EC -----------------------------
            if (terrObs[i,j].itemId=52) then begin
              //cancelChain:=false;
              for k:=1 to enemC do begin
                if((round(enemiesTypeC[k].Position.X))=i)and((round(enemiesTypeC[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('nova') then begin
                    fightEC(round(enemiesTypeC[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all EC
            end; // if 52
            ///////////////////---------------------
            // if ED -----------------------------
            if (terrObs[i,j].itemId=53) then begin
              //cancelChain:=false;
              for k:=1 to enemD do begin
                if((round(enemiesTypeD[k].Position.X))=i)and((round(enemiesTypeD[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('nova') then begin
                    fightED(round(enemiesTypeD[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all ED
            end; // if 53
            ///////////////////---------------------
            // if EE -----------------------------
            if (terrObs[i,j].itemId=54) then begin
              //cancelChain:=false;
              for k:=1 to enemE do begin
                if((round(enemiesTypeE[k].Position.X))=i)and((round(enemiesTypeE[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('nova') then begin
                    fightEE(round(enemiesTypeE[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all EE
            end; // if 54
            ///////////////////---------------------
            // if EF -----------------------------
            if (terrObs[i,j].itemId=55) then begin
              //cancelChain:=false;
              for k:=1 to enemF do begin
                if((round(enemiesTypeF[k].Position.X))=i)and((round(enemiesTypeF[k].Position.Z))=j) then begin

                  if calcIsEnoughMHEnergy('nova') then begin
                    fightEF(round(enemiesTypeF[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all EF
            end; // if 55
            ///////////////////---------------------
            // if EF -----------------------------
            if (terrObs[i,j].itemId=56) then begin
              //cancelChain:=false;
              for k:=1 to enemG do begin
                if((round(enemiesTypeG[k].Position.X))=i)and((round(enemiesTypeG[k].Position.Z))=j) then begin
                  
                  if calcIsEnoughMHEnergy('nova') then begin
                    fightEG(round(enemiesTypeG[k].TagFloat));
                    cancelChain:=false;
                  end; // if
                end; // if exact
              end; // for all EG
            end; // if 56
            ///////////////////---------------------


          end; // for i
        end; // for j
        if not (cancelChain) then begin
          MHstrikePeriod:=0;
          MH_in_nova_strike:=false;
          MHNovaStrike;
          play_HerosAudioTrack(14,fMainMenu.global_game_volume_level,true,false);
        end; // if not cancel
      end; // if not in strike
    end; // if MH alive
  end; // if nova
  end; // with
end;

procedure processMHBuildWeb;
begin
  with Form1 do begin
    // close webs
    if (hud_inv.Visible)and(hud_inv_base_state=2) then begin
      invokeWebsWindow(true);
    end;
    if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='build_web')and
      (MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).isAlive) then begin
      if calcIsEnoughMHEnergy('build_web') then begin
        // build web
        MHBuildWeb(round(DCMainHero.Position.X),round(DCMainHero.Position.Y),round(DCMainHero.Position.Z));
      end; // if is mana
    end; // if magic
  end; // with
end;

procedure processMHDestroyWeb(X,Y:Integer);
begin
  with Form1 do begin
    if(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon='destroy_web') then begin
      if calcIsEnoughMHEnergy('destroy_web') then begin
        // destroy web
        MHAttackUnderMouseWeb(X,Y);
      end; // if is mana
    end; // if magic
  end; // with
end;

function proceedMHPortalEntrance(MHx_coord,MHy_coord,X_portal_coord,Y_portal_coord:Integer):boolean;
var
  calc_dist:Integer;
begin
  // da se izvika v procedure TForm1.AsyncTimer1Timer
  Result:=false;
  with Form1 do begin
    // get distance
    calc_dist:=calcDistance(X_portal_coord,Y_portal_coord,MHx_coord,MHy_coord);
    if (calc_dist <= 5) then begin
      // check hero wearable and inventory for power Spx
      if(checkMHpowerSpxPresence) then begin
        // go to next level
        Result:=true;
        MHgoToNextLevel;
      end
      else
      begin
        // show warning no power spx present
        printTextBarInfo('no_power_spx',0);
      end; // else

    end; // if close enough
  end;
end;

function checkMHpowerSpxPresence:boolean;
var
  i:byte;
  result_Inv, result_Wear:boolean;
begin
  Result:=false;
  result_Inv:=false;
  result_Wear:=false;

  with Form1 do begin
    for i:= 12 downto 1 do begin
      if(hud_inv_carrier[i].itemID = 190) then begin
        // there is powerSpx
        result_Inv:=true;
        break;
      end; // if power spx
    end; // for inv

    for i:= 1 to 7 do begin
      if(hud_inv_wearable[i].itemID = 190) then begin
        result_Wear:=true;
      end; // if power spx
    end; // for all wear cells

    Result:=(result_Inv or result_Wear);
  end; // with form1
end;

procedure MHgoToNextLevel;
begin
  with Form1 do begin
    // exit
    if (MainMenu.fMainMenu.current_level < 3) then begin
      // buff MH level
      MainMenu.fMainMenu.MH_current_level:= MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MH_current_level;
      // buff some items
      buff_MH_Inventory;
      MainMenu.fMainMenu.main_menu_current_state:='loading';
      MainMenu.fMainMenu.showLoadingProgress;
      Hide;
      MainMenu.fMainMenu.Refresh;
      MainMenu.fMainMenu.writeInErrorLog(2,'');
      stopAllGameSounds;
      destroyChild;
      MainMenu.fMainMenu.go_next_level:=true;
    end // if < 6
    else
    begin
      // game over victory
      MainMenu.fMainMenu.current_level:=0;
      GLCadencer1.Enabled:=false;
      MainMenu.fMainMenu.showVictoryCondition;
      MainMenu.fMainMenu.main_menu_current_state:= 'victory_condition';
      Hide;
      MainMenu.fMainMenu.Refresh;
      MainMenu.fMainMenu.writeInErrorLog(2,'');
      /////
      stopAllGameSounds;
      destroyChild;
    end;
  end;
end;

procedure pause_game;
begin
  with Form1 do begin
    Timer1.Enabled:=false;
    AsyncTimer1.Enabled:=false;
    AsyncTimer2.Enabled:=false;
    Timer2.Enabled:=false;
    game_paused:=true;
  end; // with
end;

procedure printTextBarInfo(enemy_type:String;idx:byte);
begin
  ////
  { ishta-pan spider dalak }
  { algo-pan alien} {2}
  { buga-pan bug} {2}
  { insa-pan insect} {2}
  { fago-pan frog} {2}
  { dria-pan drio} {2}
  { okta-pan okta} {2}
  ////
  with Form1 do begin
    if(enemy_type='EMPTY') then begin
      // clear otput
      HUDTextInfo.Text:='';
    end; // if empty
    //--------------------------
    if(enemy_type='EA') then begin
      if (enemyInfo(enemiesTypeA[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='ISHTA-PAN ' +
          IntToStr(enemyInfo(enemiesTypeA[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.EABaseLife*fMainMenu.current_level);
      end;
    end; // if ea
    //--------------------------
    if(enemy_type='EB') then begin
      if (enemyInfo(enemiesTypeB[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='ALGO-PAN ' +
          IntToStr(enemyInfo(enemiesTypeB[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.EBBaseLife*fMainMenu.current_level);
      end;
    end; // if eb
    //--------------------------
    if(enemy_type='EC') then begin
      if (enemyInfo(enemiesTypeC[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='BUGA-PAN ' +
          IntToStr(enemyInfo(enemiesTypeC[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.ECBaseLife*fMainMenu.current_level);
      end;
    end; // if ec
    //--------------------------
    if(enemy_type='ED') then begin
      if (enemyInfo(enemiesTypeD[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='INSA-PAN ' +
          IntToStr(enemyInfo(enemiesTypeD[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.EDBaseLife*fMainMenu.current_level);
      end;
    end; // if ed
    //--------------------------
    if(enemy_type='EE') then begin
      if (enemyInfo(enemiesTypeE[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='FAGO-PAN ' +
          IntToStr(enemyInfo(enemiesTypeE[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.EEBaseLife*fMainMenu.current_level);
      end;
    end; // if ee
    //--------------------------
    if(enemy_type='EF') then begin
      if (enemyInfo(enemiesTypeF[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='DRIA-PAN ' +
          IntToStr(enemyInfo(enemiesTypeF[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.EFBaseLife*fMainMenu.current_level);
      end;
    end; // if ef
    //--------------------------
    if(enemy_type='EG') then begin
      if (enemyInfo(enemiesTypeG[idx].Behaviours.GetByClass(enemyInfo)).isAlive) then begin
        // set output text
        HUDTextInfo.Text:='OKTA-PAN ' +
          IntToStr(enemyInfo(enemiesTypeG[idx].Behaviours.GetByClass(enemyInfo)).Life)+
          ':' + IntToStr(fMainMenu.EGBaseLife*fMainMenu.current_level);
      end;
    end; // if eg

    // WINDOWS
    if(enemy_type='INV') then begin
      HUDTextInfo.Text:='INVENTORY (I)';
    end; // if inv

    if(enemy_type='HERO') then begin
      HUDTextInfo.Text:='HERO (H)';
    end; // if hero

    if(enemy_type='WEBS') then begin
      HUDTextInfo.Text:='WEBS (W)';
    end; // if webs

    if(enemy_type='SPELLS') then begin
      HUDTextInfo.Text:='SPELLS (S)';
    end; // if spells

    // SPELLS
    if(enemy_type='LIGHTNING') then begin
      HUDTextInfo.Text:='LIGHTNING';
    end; // if LIGHTNING

    if(enemy_type='CHAIN LIGHTNING') then begin
      HUDTextInfo.Text:='MAS LIGHTNING';
    end; // if CHAIN LIGHTNING

    if(enemy_type='NOVA') then begin
      HUDTextInfo.Text:='NOVA';
    end; // if NOVA

    if(enemy_type='BUILD WEB') then begin
      HUDTextInfo.Text:='BUILD WEB';
    end; // if BUILD WEB

    if(enemy_type='DESTROY WEB') then begin
      HUDTextInfo.Text:='DESTROY WEB';
    end; // if DESTROY WEB

    // movable items
    if(enemy_type='life_cell') then begin
      HUDTextInfo.Text:='LIFE CELL';
    end; // if life cell

    if(enemy_type='mana_cell') then begin
      HUDTextInfo.Text:='MANA CELL';
    end; // if mana cell

    if(enemy_type='armor_A') then begin
      HUDTextInfo.Text:='ARMOR LOW CLASS';
    end; // if armor A

    if(enemy_type='weapon_A') then begin
      HUDTextInfo.Text:='WEAPON LOW CLASS';
    end; // if weapon A

    if(enemy_type='power_spx') then begin
      HUDTextInfo.Text:='POWER SPHERE';
    end; // if power spx
    //////
    // level portal
    if(enemy_type='level_portal') then begin
      HUDTextInfo.Text:='LEVEL PORTAL';
    end; // if power spx

    if(enemy_type='no_power_spx') then begin
      HUDTextInfo.Text:='NO POWER SPHERE'; //18 SYMBOLS
    end; // if power spx
    //----------------------------------
  end; // with
end;

procedure processTextBarInfo(X,Y:Integer);
var
  i,j:Integer;
  k:byte;
begin
  with Form1 do begin
    for j:=(Y-3) to (Y+3) do begin
      for i:=(X-3) to (X+3) do begin
        //- EA -----------------------
       if (terrObs[i,j].itemId=50) then begin
         // check each EA for exact match
         for k:=1 to enemA do begin
           if((round(enemiesTypeA[k].Position.X))=i)and((round(enemiesTypeA[k].Position.Z))=j) then begin
             printTextBarInfo('EA',k);
             Exit;
           end; // if exact
         end; // for all EA
       end; // if id=50
      //----------------------------

      //- EB -----------------------
       if (terrObs[i,j].itemId=51) then begin
         // check each EB for exact match
         for k:=1 to enemB do begin
           if((round(enemiesTypeB[k].Position.X))=i)and((round(enemiesTypeB[k].Position.Z))=j) then begin
             printTextBarInfo('EB',k);
             Exit;
           end; // if exact
         end; // for all EB
       end; // if id=51
      //----------------------------
      //- EC -----------------------
       if (terrObs[i,j].itemId=52) then begin
         // check each EC for exact match
         for k:=1 to enemC do begin
           if((round(enemiesTypeC[k].Position.X))=i)and((round(enemiesTypeC[k].Position.Z))=j) then begin
             printTextBarInfo('EC',k);
             Exit;
           end; // if exact
         end; // for all EB
       end; // if id=52
      //----------------------------
      //- ED -----------------------
       if (terrObs[i,j].itemId=53) then begin
         // check each ED for exact match
         for k:=1 to enemD do begin
           if((round(enemiesTypeD[k].Position.X))=i)and((round(enemiesTypeD[k].Position.Z))=j) then begin
             printTextBarInfo('ED',k);
             Exit;
           end; // if exact
         end; // for all EB
       end; // if id=53
      //----------------------------
      //- EE -----------------------
       if (terrObs[i,j].itemId=54) then begin
         // check each ED for exact match
         for k:=1 to enemE do begin
           if((round(enemiesTypeE[k].Position.X))=i)and((round(enemiesTypeE[k].Position.Z))=j) then begin
             printTextBarInfo('EE',k);
             Exit;
           end; // if exact
         end; // for all EE
       end; // if id=54
      //----------------------------
      //- EF -----------------------
       if (terrObs[i,j].itemId=55) then begin
         // check each ED for exact match
         for k:=1 to enemF do begin
           if((round(enemiesTypeF[k].Position.X))=i)and((round(enemiesTypeF[k].Position.Z))=j) then begin
             printTextBarInfo('EF',k);
             Exit;
           end; // if exact
         end; // for all EE
       end; // if id=55
      //----------------------------
      //- EG -----------------------
       if (terrObs[i,j].itemId=56) then begin
         // check each ED for exact match
         for k:=1 to enemG do begin
           if((round(enemiesTypeG[k].Position.X))=i)and((round(enemiesTypeG[k].Position.Z))=j) then begin
             printTextBarInfo('EG',k);
             Exit;
           end; // if exact
         end; // for all EE
       end; // if id=56
      //----------------------------

    end; // for i
    end; // for j
  end; // with
end;

procedure processTextBarInfoPortal(X,Y:Integer);
var
  i,j:Integer;
begin
  with Form1 do begin
    for j:=(Y-15) to (Y+15) do begin
      for i:=(X-15) to (X+15) do begin
        if (terrObs[i,j].itemId=40) then begin
          // check for portal id
          printTextBarInfo('level_portal',0);
          Exit;
        end; // if id=41
      end; // i
    end; // j
  end; // with  
end;

procedure resume_game;
begin
  with Form1 do begin
    Timer1.Enabled:=true;
    AsyncTimer1.Enabled:=true;
    AsyncTimer2.Enabled:=true;
    Timer2.Enabled:=true;
    game_paused:=false;
  end; // with
end;

procedure changeMHLifeBar;
begin
  // call in CadencerOnProgerss
  // stepK:=0.0076 228 / 32000
  with Form1 do begin
    hud_top_life.Width:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life*MH_LifeMana_step);
  end; // with Form1
end;

procedure changeMHManaBar;
begin
  // stepK:=0.0076
  // on cadenserProgress after Shrine EFX
  // add Mana field in MHInfo
  with Form1 do begin
    hud_top_mana.Width:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana*MH_LifeMana_step);
  end; // with Form1
end;

procedure AddHudSpriteRTLife(xPos,yPos:Integer);
begin
  with Form1 do begin
    hud_top_RTLifeCore:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTLifeCore do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite_core';
      Material.Texture.Image.LoadFromFile('life_cell.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_top_RTLife:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTLife do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite';
      Material.Texture.Image.LoadFromFile('life_cell.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50;
      Width:=50;

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=1;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=0;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=1;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=0;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=1;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=0;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end; // with Form
end;

procedure AddHudSpriteRTMana(xPos,yPos:Integer);
begin
  with Form1 do begin
    hud_top_RTManaCore:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTManaCore do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite_core';
      Material.Texture.Image.LoadFromFile('mana_cell.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_top_RTMana:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTMana do begin
      // load image BMP
      Name:='picked_movable_item_HUDSprite';
      Material.Texture.Image.LoadFromFile('mana_cell.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50; // 64
      Width:=50;  // 64

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=0;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=1;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=0;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=1;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=0;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=1;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end; // with
end;

procedure AddHudSpriteRTPowerSpx(xPos,yPos:Integer);
begin
  with Form1 do begin
    hud_top_RTPowerSpxCore:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTPowerSpxCore do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite_core';
      Material.Texture.Image.LoadFromFile('power_spx.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_top_RTPowerSpx:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTPowerSpx do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite';
      Material.Texture.Image.LoadFromFile('power_spx.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50; // 64
      Width:=50;  // 64

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=0.5;
      Material.FrontProperties.Ambient.Green:=0.5;
      Material.FrontProperties.Ambient.Blue:=0.5;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=0.8;
      Material.FrontProperties.Diffuse.Green:=0.8;
      Material.FrontProperties.Diffuse.Blue:=0.8;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=0.8;
      Material.FrontProperties.Emission.Green:=0.8;
      Material.FrontProperties.Emission.Blue:=0.8;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end; // with
end;

procedure AddHudCarrierRTItem(idx:byte;xPos,yPos:Integer;itemID:byte);
var
  pic_name:String;
begin
  with Form1 do begin
    case itemID of
      150: begin
        pic_name:='life_cell.bmp';
        printTextBarInfo('life_cell',0);
      end;
      151: begin
        pic_name:='mana_cell.bmp';
        printTextBarInfo('mana_cell',0);
      end;
      160: begin
        pic_name:='armor_A.bmp';
        printTextBarInfo('armor_A',0);
      end;
      180: begin
        pic_name:='weapon_A.bmp';
        printTextBarInfo('weapon_A',0);
      end;
      190: begin
        pic_name:='power_spx.bmp';
        printTextBarInfo('power_spx',0);
      end;
    end; // case
    hud_inv_carrier[idx].hud_item_pic_core:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_carrier[idx].hud_item_pic_core do begin
      // load image BMP
      Name:='carrier_hud_item_pic_core_' + IntToStr(idx);
      Material.Texture.Image.LoadFromFile(pic_name);
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_inv_carrier[idx].hud_item_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_carrier[idx].hud_item_pic do begin
      // load image BMP
      Name:='carrier_hud_item_pic_' + IntToStr(idx);
      Material.Texture.Image.LoadFromFile(pic_name);
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50;
      Width:=50;

      case itemID of
      150: begin
        Material.FrontProperties.Ambient.Alpha:=0.7;
        Material.FrontProperties.Ambient.Red:=1;
        Material.FrontProperties.Ambient.Green:=0;
        Material.FrontProperties.Ambient.Blue:=0;

        Material.FrontProperties.Diffuse.Alpha:=0.7;
        Material.FrontProperties.Diffuse.Red:=1;
        Material.FrontProperties.Diffuse.Green:=0;
        Material.FrontProperties.Diffuse.Blue:=0;

        Material.FrontProperties.Emission.Alpha:=0.7;
        Material.FrontProperties.Emission.Red:=1;
        Material.FrontProperties.Emission.Green:=0;
        Material.FrontProperties.Emission.Blue:=0;
      end;
      151,180: begin
        Material.FrontProperties.Ambient.Alpha:=0.7;
        Material.FrontProperties.Ambient.Red:=0;
        Material.FrontProperties.Ambient.Green:=0;
        Material.FrontProperties.Ambient.Blue:=1;

        Material.FrontProperties.Diffuse.Alpha:=0.7;
        Material.FrontProperties.Diffuse.Red:=0;
        Material.FrontProperties.Diffuse.Green:=0;
        Material.FrontProperties.Diffuse.Blue:=1;

        Material.FrontProperties.Emission.Alpha:=0.7;
        Material.FrontProperties.Emission.Red:=0;
        Material.FrontProperties.Emission.Green:=0;
        Material.FrontProperties.Emission.Blue:=1;
      end;
      160,190: begin
        Material.FrontProperties.Ambient.Alpha:=0.7;
        Material.FrontProperties.Ambient.Red:=0.8;
        Material.FrontProperties.Ambient.Green:=0.8;
        Material.FrontProperties.Ambient.Blue:=0.8;

        Material.FrontProperties.Diffuse.Alpha:=0.7;
        Material.FrontProperties.Diffuse.Red:=0.7;
        Material.FrontProperties.Diffuse.Green:=0.7;
        Material.FrontProperties.Diffuse.Blue:=0.7;

        Material.FrontProperties.Emission.Alpha:=0.7;
        Material.FrontProperties.Emission.Red:=0.5;
        Material.FrontProperties.Emission.Green:=0.5;
        Material.FrontProperties.Emission.Blue:=0.5;
      end;
      end; // case

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end;
end;

procedure AddHudWearRTItem(idx:byte;xPos,yPos:Integer;itemID:byte);
var
  pic_name:String;
begin
  with Form1 do begin
    case itemID of
      150: begin
        pic_name:='life_cell.bmp';
        printTextBarInfo('life_cell',0);
      end;
      151: begin
        pic_name:='mana_cell.bmp';
        printTextBarInfo('mana_cell',0);
      end;
      160: begin
        pic_name:='armor_A.bmp';
        printTextBarInfo('armor_A',0);
      end;
      180: begin
        pic_name:='weapon_A.bmp';
        printTextBarInfo('weapon_A',0);
      end;
      190: begin
        pic_name:='power_spx.bmp';
        printTextBarInfo('power_spx',0);
      end;
    end; // case
    hud_inv_wearable[idx].hud_item_pic_core:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_wearable[idx].hud_item_pic_core do begin
      // load image BMP
      Name:='wear_hud_item_pic_core_' + IntToStr(idx);
      Material.Texture.Image.LoadFromFile(pic_name);
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_inv_wearable[idx].hud_item_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_wearable[idx].hud_item_pic do begin
      // load image BMP
      Name:='wear_hud_item_pic_' + IntToStr(idx);
      Material.Texture.Image.LoadFromFile(pic_name);
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50;
      Width:=50;

      case itemID of
      150: begin
        Material.FrontProperties.Ambient.Alpha:=0.7;
        Material.FrontProperties.Ambient.Red:=1;
        Material.FrontProperties.Ambient.Green:=0;
        Material.FrontProperties.Ambient.Blue:=0;

        Material.FrontProperties.Diffuse.Alpha:=0.7;
        Material.FrontProperties.Diffuse.Red:=1;
        Material.FrontProperties.Diffuse.Green:=0;
        Material.FrontProperties.Diffuse.Blue:=0;

        Material.FrontProperties.Emission.Alpha:=0.7;
        Material.FrontProperties.Emission.Red:=1;
        Material.FrontProperties.Emission.Green:=0;
        Material.FrontProperties.Emission.Blue:=0;
      end;
      151,180: begin
        Material.FrontProperties.Ambient.Alpha:=0.7;
        Material.FrontProperties.Ambient.Red:=0;
        Material.FrontProperties.Ambient.Green:=0;
        Material.FrontProperties.Ambient.Blue:=1;

        Material.FrontProperties.Diffuse.Alpha:=0.7;
        Material.FrontProperties.Diffuse.Red:=0;
        Material.FrontProperties.Diffuse.Green:=0;
        Material.FrontProperties.Diffuse.Blue:=1;

        Material.FrontProperties.Emission.Alpha:=0.7;
        Material.FrontProperties.Emission.Red:=0;
        Material.FrontProperties.Emission.Green:=0;
        Material.FrontProperties.Emission.Blue:=1;
      end;
      160, 190: begin
        Material.FrontProperties.Ambient.Alpha:=0.7;
        Material.FrontProperties.Ambient.Red:=0.8;
        Material.FrontProperties.Ambient.Green:=0.8;
        Material.FrontProperties.Ambient.Blue:=0.8;

        Material.FrontProperties.Diffuse.Alpha:=0.7;
        Material.FrontProperties.Diffuse.Red:=0.7;
        Material.FrontProperties.Diffuse.Green:=0.7;
        Material.FrontProperties.Diffuse.Blue:=0.7;

        Material.FrontProperties.Emission.Alpha:=0.7;
        Material.FrontProperties.Emission.Red:=0.5;
        Material.FrontProperties.Emission.Green:=0.5;
        Material.FrontProperties.Emission.Blue:=0.5;
      end;
      end; // case

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end;
end;

procedure AddHudSpriteRTArmorA(xPos,yPos:Integer);
begin
  with Form1 do begin
    hud_top_RTArmorACore:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTArmorACore do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite_core';
      Material.Texture.Image.LoadFromFile('armor_A.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_top_RTArmorA:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTArmorA do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite';
      Material.Texture.Image.LoadFromFile('armor_A.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50; // 64
      Width:=50;  // 64

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=0.5;
      Material.FrontProperties.Ambient.Green:=0.5;
      Material.FrontProperties.Ambient.Blue:=0.5;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=0.8;
      Material.FrontProperties.Diffuse.Green:=0.8;
      Material.FrontProperties.Diffuse.Blue:=0.8;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=0.8;
      Material.FrontProperties.Emission.Green:=0.8;
      Material.FrontProperties.Emission.Blue:=0.8;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end; // with
end;

procedure AddHudSpriteRTWeaponA(xPos,yPos:Integer);
begin
    with Form1 do begin
    hud_top_RTWeaponACore:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTWeaponACore do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite_core';
      Material.Texture.Image.LoadFromFile('weapon_A.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=30;
      Width:=30;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with

    hud_top_RTWeaponA:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_RTWeaponA do begin
      // load image BMP
        Name:='picked_movable_item_HUDSprite';
      Material.Texture.Image.LoadFromFile('weapon_A.bmp');
      // set position and dimension
      Position.X:=xPos;
      Position.Y:=yPos;
      Height:=50; // 64
      Width:=50;  // 64

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=0;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=1;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=0;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=1;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=0;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=1;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
    end; // with
  end; // with
end;

procedure AddHudSpriteLevelUp;
var
  startX, startY:Integer;
begin
    with Form1 do begin
     // items carrier
    startX:=85; //160
    startY:=200; // 580
      // MH Exp label
      hud_hero_levelUp_base:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_levelUp_base do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=startY;
        Height:=30; // 50
        Width:=150;
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

      // level up caption
      hud_hero_levelUp_base_text:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_levelUp_base_text do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=(startX-69);
        Position.Y:=(startY-7);
        Text:='LEVEL UP';
        Visible:=false;
      end;// with

      // level up btn up
      hud_hero_levelUp_base_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_levelUp_base_pic_up do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_up.bmp');
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX+75;
        Position.Y:=startY;

        Height:=30;
        Width:=30;
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

      // level up btn down
      hud_hero_levelUp_base_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_levelUp_base_pic_down do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_down.bmp');
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=(startX+75);
        Position.Y:=startY;

        Height:=30;
        Width:=30;
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
  end; // with Form1
end;

procedure AddHudSpriteInvBase(mode:byte);
begin
  // da se addne on Formload s visible=false then in RT switch it
  with Form1 do begin
    // inv
    hud_inv:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('inv_base.bmp');
      // set position and dimension
      Position.X:=620;  //656 - 36
      Position.Y:=344;
      Height:=512; // 426
      Width:=513;  // 400

      //Rotation:=90; // -180
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end; // with

    // ornament A
    hud_inv_ornament_A:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_ornament_A do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=455; // 160
      Position.Y:=470;  // 50
      Height:=200;
      Width:=200;


      Rotation:=-90;
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
    end; // with

    // ornament B
    hud_inv_ornament_B:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_ornament_B do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=455; // 160
      Position.Y:=350;  // 50
      Height:=200;
      Width:=200;


      Rotation:=-90;
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
    end; // with

    // ornament C
    hud_inv_ornament_C:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_ornament_C do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=440; // 160
      Position.Y:=540;  // 50
      Height:=400;
      Width:=400;


      Rotation:=-90;
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
    end; // with



    // ornament D
    hud_inv_ornament_D:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_ornament_D do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=440; // 160
      Position.Y:=280;  // 50
      Height:=400;
      Width:=400;


      Rotation:=-90;
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
    end; // with

    // ornament E
    hud_inv_ornament_E:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_ornament_E do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=680; // 160
      Position.Y:=270;  // 50
      Height:=400;
      Width:=400;
      //Rotation:=-90;
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
    end; // with

    // ornament F
    hud_inv_ornament_F:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_inv_ornament_F do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=580; // 160
      Position.Y:=270;  // 50
      Height:=400;
      Width:=400;
      //Rotation:=-90;
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
    end; // with

    //-----------------------------------------------------
    // character
    hud_hero:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('inv_base_l.bmp');
      // set position and dimension
      Position.X:=174;
      Position.Y:=344;
      Height:=512;
      Width:=512;

      //Rotation:=180; // -180
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end; // with

    // ornament A
    hud_hero_ornament_A:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero_ornament_A do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=345; // 455
      Position.Y:=470;  // 50
      Height:=200;
      Width:=200;


      Rotation:=90; // -90
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
    end; // with

    // ornament B
    hud_hero_ornament_B:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero_ornament_B do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=345; // 160
      Position.Y:=350;  // 50
      Height:=200;
      Width:=200;


      Rotation:=90; //-90
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
    end; // with

    // ornament C
    hud_hero_ornament_C:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero_ornament_C do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=360; // 440
      Position.Y:=535;  // 540
      Height:=400;
      Width:=400;


      Rotation:=90;
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
    end; // with



    // ornament D
    hud_hero_ornament_D:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero_ornament_D do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=360; // 160
      Position.Y:=275;  // 280
      Height:=400;
      Width:=400;


      Rotation:=90;
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
    end; // with

    // ornament E
    hud_hero_ornament_E:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero_ornament_E do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=120; // 680
      Position.Y:=270;  // 50
      Height:=400;
      Width:=400;
      //Rotation:=-90;
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
    end; // with

    // ornament F
    hud_hero_ornament_F:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_hero_ornament_F do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('base_14_r.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      // set position and dimension
      Position.X:=220; // 580
      Position.Y:=270;  // 50
      Height:=400;
      Width:=400;
      //Rotation:=-90;
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
    end; // with

    // add some inv items
    AddHudSpriteInvCarrier;
    AddHudSpriteInvWearableBase;

    AddHudSpriteInvCloseBtn;
    AddHudSpriteInvWearCells;
    // add some hero items
    AddHudSpriteHeroLabels;
    AddHudSpriteHeroCloseBtn;
    // add some webs items
    AddHudSpriteInvWebs;

    // add some inv-spells
    AddHudSpriteInvSpells;
    // add level up panel
    AddHudSpriteLevelUp;

    // some restore if load or next
    if (mode in[1,2]) then
      restore_MH_Inventory_from_buff;
  end; // form1
end;

procedure showHudInvOrnaments;
begin
  with Form1 do begin
    hud_inv_ornament_A.Visible:=true;
    hud_inv_ornament_B.Visible:=true;
    hud_inv_ornament_C.Visible:=true;
    hud_inv_ornament_D.Visible:=true;
    hud_inv_ornament_E.Visible:=true;
    hud_inv_ornament_F.Visible:=true;
    hud_MH_wear_base.Visible:=true;
    hud_inv_closeBtn_Up.Visible:=true;
  end;
end;

procedure showHudHeroOrnaments;
begin
  with Form1 do begin
    hud_hero_ornament_A.Visible:=true;
    hud_hero_ornament_B.Visible:=true;
    hud_hero_ornament_C.Visible:=true;
    hud_hero_ornament_D.Visible:=true;
    hud_hero_ornament_E.Visible:=true;
    hud_hero_ornament_F.Visible:=true;
    //hud_MH_wear_base.Visible:=true;
    hud_hero_closeBtn_Up.Visible:=true;
  end;
end;

procedure showHudInvCarrier;
var
  i:byte;
begin
  with Form1 do begin
    for i:= 1 to 12 do begin
      hud_inv_carrier[i].hud_pic.Visible:=true;
      if(hud_inv_carrier[i].itemID <> 0) then begin
        // there is item
        hud_inv_carrier[i].hud_item_pic.Visible:=true;
        hud_inv_carrier[i].hud_item_pic_core.Visible:=true;
      end; // if
    end; // for
    for i:=1 to 7 do begin
      hud_inv_wearable[i].hud_pic.Visible:=true;
      if(hud_inv_wearable[i].itemID <> 0) then begin
        // there is item
        hud_inv_wearable[i].hud_item_pic.Visible:=true;
        hud_inv_wearable[i].hud_item_pic_core.Visible:=true;
      end; // if
    end; // for
  end; // with form1
end;

procedure showHudInvWebs;
var
  i, j, web_id:byte;
  startX,startY:Integer;
begin
  with Form1 do begin

    startX:=620;
    startY:=300;
    j:=0;

    for i:= 1 to 8 do begin
      if (MHWebCount >= 1)and(MHWebCount <= 8) then begin
        if not(WebInfo(MHWebs[i].Behaviours.GetByClass(WebInfo)).isFree) then begin
          web_id:=getUnderMHWeb(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));
          if (web_id <> 0) then begin// no web
            inc(j);
            hud_inv_webs[i].posX_visio:=startX;
            hud_inv_webs[i].posY_visio:=(startY+(j*35));

            with hud_inv_webs[i].hud_webs_pic do begin
              Position.X:=hud_inv_webs[i].posX_visio;
              Position.Y:=hud_inv_webs[i].posY_visio;
              Visible:=true;
            end;
            with hud_inv_webs[i].hud_webs_text do begin
              Position.X:=(hud_inv_webs[i].posX_visio - 117);
              Position.Y:=(hud_inv_webs[i].posY_visio - 7);
              Text:=(WebInfo(MHWebs[i].Behaviours.GetByClass(WebInfo)).friendlyName);
              Visible:=true;
            end;
            with hud_inv_webs[i].hud_webs_pic_down do begin
              Position.X:=(hud_inv_webs[i].posX_visio + 140);
              Position.Y:=hud_inv_webs[i].posY_visio;
              //
            end;
            with hud_inv_webs[i].hud_webs_pic_up do begin
              Position.X:=(hud_inv_webs[i].posX_visio + 140);
              Position.Y:=hud_inv_webs[i].posY_visio;
              if (web_id <> i) then
                Visible:=true;
            end;
            with hud_inv_webs[i].hud_webs_pic_disabled do begin
              Position.X:=(hud_inv_webs[i].posX_visio + 140);
              Position.Y:=hud_inv_webs[i].posY_visio;
              if (web_id = i) then
                Visible:=true;
            end;

          end // if <>0
          else
          begin
            // there is no web under
            inc(j);
            hud_inv_webs[i].posX_visio:=startX;
            hud_inv_webs[i].posY_visio:=(startY+(j*35));

            with hud_inv_webs[i].hud_webs_pic do begin
              Position.X:=hud_inv_webs[i].posX_visio;
              Position.Y:=hud_inv_webs[i].posY_visio;
              Visible:=true;
            end;
            with hud_inv_webs[i].hud_webs_text do begin
              Position.X:=(hud_inv_webs[i].posX_visio - 117);
              Position.Y:=(hud_inv_webs[i].posY_visio - 7);
              Text:=(WebInfo(MHWebs[i].Behaviours.GetByClass(WebInfo)).friendlyName);
              Visible:=true;
            end;
            with hud_inv_webs[i].hud_webs_pic_down do begin
              Position.X:=(hud_inv_webs[i].posX_visio + 140);
              Position.Y:=hud_inv_webs[i].posY_visio;
              //
            end;
            with hud_inv_webs[i].hud_webs_pic_up do begin
              Position.X:=(hud_inv_webs[i].posX_visio + 140);
              Position.Y:=hud_inv_webs[i].posY_visio;
            end;
            with hud_inv_webs[i].hud_webs_pic_disabled do begin
              Position.X:=(hud_inv_webs[i].posX_visio + 140);
              Position.Y:=hud_inv_webs[i].posY_visio;
              Visible:=true;
            end;

          end;// disable all
        end; // if not free
      end; //if in [1..8]
    end; // for all

  end; // with form1
end;

procedure showHudHeroLabels;
begin
  with Form1 do begin
    hud_hero_lab_exp.Visible:=true;
    hud_hero_lab_def.Visible:=true;
    hud_hero_lab_att.Visible:=true;
    hud_hero_lab_mana.Visible:=true;
    hud_hero_lab_life.Visible:=true;
    hud_hero_lab_spell.Visible:=true;
    hud_hero_lab_lev.Visible:=true;
    hud_hero_lab_level.Visible:=true;

    hud_hero_text_exp.Visible:=true;
    hud_hero_text_def.Visible:=true;
    hud_hero_text_att.Visible:=true;
    hud_hero_text_mana.Visible:=true;
    hud_hero_text_life.Visible:=true;
    hud_hero_text_spell.Visible:=true;
    hud_hero_text_lev.Visible:=true;
    hud_hero_text_level.Visible:=true;
  end; // with form1
end;

procedure showHudObjectivesBase;
begin
  with Form1 do begin
    pause_game;
    hud_objectives_base.Visible:=true;

    hud_obj_ornament_A.Visible:=true;
    hud_obj_ornament_B.Visible:=true;
    hud_obj_ornament_C.Visible:=true;
    hud_obj_ornament_D.Visible:=true;
    hud_obj_ornament_E.Visible:=true;
    hud_obj_ornament_F.Visible:=true;
    hud_obj_ornament_G.Visible:=true;
    hud_obj_ornament_H.Visible:=true;

    hud_obj_text_area.Visible:=true;
    // set text
    hud_obj_text_caption.Visible:=true;
    hud_obj_closeBtn_Up.Visible:=true;

  end; // with form1
end;

procedure showHudLevelUp;
begin
  with Form1 do begin
    hud_hero_levelUp_base.Visible:=true;
    hud_hero_levelUp_base_pic_up.Visible:=true;
    hud_hero_levelUp_base_text.Visible:=true;
  end; // with form1
end;

procedure hideHudInvOrnaments;
begin
  with Form1 do begin
    hud_inv_ornament_A.Visible:=false;
    hud_inv_ornament_B.Visible:=false;
    hud_inv_ornament_C.Visible:=false;
    hud_inv_ornament_D.Visible:=false;
    hud_inv_ornament_E.Visible:=false;
    hud_inv_ornament_F.Visible:=false;
    hud_MH_wear_base.Visible:=false;
    hud_inv_closeBtn_Up.Visible:=false;
  end;
end;

procedure hideHudHeroOrnaments;
begin
  with Form1 do begin
    hud_hero_ornament_A.Visible:=false;
    hud_hero_ornament_B.Visible:=false;
    hud_hero_ornament_C.Visible:=false;
    hud_hero_ornament_D.Visible:=false;
    hud_hero_ornament_E.Visible:=false;
    hud_hero_ornament_F.Visible:=false;
    //hud_MH_wear_base.Visible:=false;
    hud_hero_closeBtn_Up.Visible:=false;
  end;
end;

procedure hideHudInvCarrier;
var
  i:byte;
begin
  with Form1 do begin
    for i:= 1 to 12 do begin
      hud_inv_carrier[i].hud_pic.Visible:=false;
      if(hud_inv_carrier[i].itemID <> 0) then begin
        // there is item
        hud_inv_carrier[i].hud_item_pic.Visible:=false;
        hud_inv_carrier[i].hud_item_pic_core.Visible:=false;
      end; // if
    end; // for
    for i:=1 to 7 do begin
      hud_inv_wearable[i].hud_pic.Visible:=false;
      if(hud_inv_wearable[i].itemID <> 0) then begin
        // there is item
        hud_inv_wearable[i].hud_item_pic.Visible:=false;
        hud_inv_wearable[i].hud_item_pic_core.Visible:=false;
      end; // if
    end; // for
  end; // with form1
end;

procedure hideHudInvWebs;
var
  i:byte;
begin
  with Form1 do begin
    for i:= 1 to 8 do begin
      if(hud_inv_webs[i].hud_webs_pic.Visible) then begin
      hud_inv_webs[i].hud_webs_pic.Visible:=false;
      hud_inv_webs[i].hud_webs_text.Visible:=false;
      hud_inv_webs[i].hud_webs_pic_up.Visible:=false;
      hud_inv_webs[i].hud_webs_pic_disabled.Visible:=false;
      end;
    end; // for
  end; // with form1
end;

procedure hideHudHeroLabels;
begin
  with Form1 do begin
    hud_hero_lab_exp.Visible:=false;
    hud_hero_lab_def.Visible:=false;
    hud_hero_lab_att.Visible:=false;
    hud_hero_lab_mana.Visible:=false;
    hud_hero_lab_life.Visible:=false;
    hud_hero_lab_spell.Visible:=false;
    hud_hero_lab_lev.Visible:=false;
    hud_hero_lab_level.Visible:=false;

    hud_hero_text_exp.Visible:=false;
    hud_hero_text_def.Visible:=false;
    hud_hero_text_att.Visible:=false;
    hud_hero_text_mana.Visible:=false;
    hud_hero_text_life.Visible:=false;
    hud_hero_text_spell.Visible:=false;
    hud_hero_text_lev.Visible:=false;
    hud_hero_text_level.Visible:=false;
  end; // with form1
end;

procedure hideHudObjectivesBase;
begin
  with Form1 do begin
    resume_game;
    hud_obj_ornament_A.Visible:=false;
    hud_obj_ornament_B.Visible:=false;
    hud_obj_ornament_C.Visible:=false;
    hud_obj_ornament_D.Visible:=false;
    hud_obj_ornament_E.Visible:=false;
    hud_obj_ornament_F.Visible:=false;
    hud_obj_ornament_G.Visible:=false;
    hud_obj_ornament_H.Visible:=false;

    hud_obj_text_area.Visible:=false;
    hud_obj_text_caption.Visible:=false;

    hud_obj_closeBtn_Up.Visible:=false;


    hud_objectives_base.Visible:=false;
  end; // with form1
end;

procedure hideHudLevelUp;
begin
  with Form1 do begin
    hud_hero_levelUp_base.Visible:=false;
    hud_hero_levelUp_base_pic_up.Visible:=false;
    hud_hero_levelUp_base_text.Visible:=false;
  end; // with form1
end;

procedure AddHudSpriteInvCarrier;
var
  i:byte;
  startX, startY:Integer;
begin
  with Form1 do begin
    // items carrier
    startX:=465;
    startY:=520;
    for i:= 1 to 12 do begin
      hud_inv_carrier[i].hud_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_carrier[i].hud_pic do begin
        // load image BMP

        Material.Texture.Image.LoadFromFile('inv_cell.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        // set X
        if(i < 7) then begin
          Position.X:=(startX + (i*50));
          hud_inv_carrier[i].posX:=(startX + (i*50))-25;
        end
        else
        begin
          Position.X:=(startX + ((i-6)*50));
          hud_inv_carrier[i].posX:=(startX + ((i-6)*50))-25;
        end;
        // set Y
        if(i < 7) then begin
          Position.Y:=startY;
          hud_inv_carrier[i].posY:=startY-25;
        end
        else
        begin
          Position.Y:=startY + 50;
          hud_inv_carrier[i].posY:=(startY + 50)-25;
        end;

        Height:=50;
        Width:=50;
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
  end; // with Form1
end;

procedure AddHudSpriteTopLifeView;
begin
  with Form1 do begin
    // items carrier life cell

    hud_top_life_view_base.hud_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_life_view_base.hud_pic do begin
      // load image BMP

      Material.Texture.Image.LoadFromFile('inv_cell.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      Position.X:=130; //220
      Position.Y:=28;
      Height:=50;
      Width:=50;
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
      //Visible:=false;
    end;// with

    hud_top_life_view_base.hud_item_pic_core:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_life_view_base.hud_item_pic_core do begin
      // load image BMP

      Material.Texture.Image.LoadFromFile('life_cell.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      Position.X:=130; //220
      Position.Y:=28;
      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_top_life_view_base.hud_item_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_life_view_base.hud_item_pic do begin
      // load image BMP
      Material.Texture.Image.LoadFromFile('life_cell.bmp');
      // set position and dimension
      Position.X:=130; //220
      Position.Y:=28;
      Height:=50;
      Width:=50;

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=1;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=0;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=1;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=0;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=1;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=0;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end; // with
  end; // with Form1
end;

procedure AddHudSpriteTopManaView;
begin
  with Form1 do begin
    // items carrier life cell

    hud_top_mana_view_base.hud_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_mana_view_base.hud_pic do begin
      // load image BMP

      Material.Texture.Image.LoadFromFile('inv_cell.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      Position.X:=670; //220
      Position.Y:=28;
      Height:=50;
      Width:=50;
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
      //Visible:=false;
    end;// with

    hud_top_mana_view_base.hud_item_pic_core:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_mana_view_base.hud_item_pic_core do begin
      // load image BMP

      Material.Texture.Image.LoadFromFile('mana_cell.bmp'); //base_14.bmp
      //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
      Position.X:=670; //220
      Position.Y:=28;
      Height:=30;
      Width:=30;
      //Rotation:=-90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmTransparency;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with

    hud_top_mana_view_base.hud_item_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_top_mana_view_base.hud_item_pic do begin
      // load image BMP

      Material.Texture.Image.LoadFromFile('mana_cell.bmp');
      // set position and dimension
      Position.X:=670; //220
      Position.Y:=28;
      Height:=50; // 64
      Width:=50;  // 64

      Material.FrontProperties.Ambient.Alpha:=0.7;
      Material.FrontProperties.Ambient.Red:=0;
      Material.FrontProperties.Ambient.Green:=0;
      Material.FrontProperties.Ambient.Blue:=1;

      Material.FrontProperties.Diffuse.Alpha:=0.7;
      Material.FrontProperties.Diffuse.Red:=0;
      Material.FrontProperties.Diffuse.Green:=0;
      Material.FrontProperties.Diffuse.Blue:=1;

      Material.FrontProperties.Emission.Alpha:=0.7;
      Material.FrontProperties.Emission.Red:=0;
      Material.FrontProperties.Emission.Green:=0;
      Material.FrontProperties.Emission.Blue:=1;

      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault;
      Material.Texture.TextureMode:=tmModulate;
      Material.Texture.TextureWrap:=twBoth;
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end; // with
  end; // with Form1
end;

procedure AddHudSpriteInvWebs;
var
  i:byte;
  startX, startY:Integer;
begin
  with Form1 do begin
    // webs list
    startX:=620;
    startY:=300;
    for i:= 1 to 8 do begin
      hud_inv_webs[i].hud_webs_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_webs[i].hud_webs_pic do begin
        // load image BMP

        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        hud_inv_webs[i].posX:=startX;
        Position.Y:=startY+(i*35);
        hud_inv_webs[i].posY:=(startY+(i*35));


        Height:=30;
        Width:=250;
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

      // MH Exp caption
      hud_inv_webs[i].hud_webs_text:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_inv_webs[i].hud_webs_text do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=startX-117;
        Position.Y:=(startY+(i*35)-7);
        Text:='WEB KARAPELIT';
        Visible:=false;
      end;// with

      hud_inv_webs[i].hud_webs_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_webs[i].hud_webs_pic_up do begin
        // load image BMP

        Material.Texture.Image.LoadFromFile('buildweb_btn_up.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX+140;
        Position.Y:=startY+(i*35);

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

      hud_inv_webs[i].hud_webs_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_webs[i].hud_webs_pic_down do begin
        // load image BMP

        Material.Texture.Image.LoadFromFile('buildweb_btn_down.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        //hud_inv_webs[i].posX:=startX;
        Position.Y:=startY+(i*35);
        //hud_inv_webs[i].posY:=startY-25;


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

      hud_inv_webs[i].hud_webs_pic_disabled:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_webs[i].hud_webs_pic_disabled do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('disabled_web_btn.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=startY+(i*35);

        Height:=30;
        Width:=30;
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
end;

procedure AddHudSpriteInvSpells;
var
  i,j:byte;
  startX, startY:Integer;
  pic_fname_up, pic_fname_down,pic_fname_up_dis,
  pic_fname_down_dis, sp_name:String;
begin
  with Form1 do begin
    
    startX:=160;
    startY:=335;

    // add points to distribute
    // MH Exp label
      hud_hero_lab_points:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_points do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=startY;
        Height:=30; // 50
        Width:=310;
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

      // MH Exp caption
      hud_hero_text_points:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_points do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-7);
        Text:='UPGRADE POINTS  ';
        Visible:=false;
      end;// with
    
    // set spell block cells
    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        // load pic ------

      case j of
        1: begin
          // first row
          case i of
            1: begin
              pic_fname_up:='light_btn_up.bmp';
              pic_fname_down:='light_btn_down.bmp';
              pic_fname_up_dis:='light_btn_up_dis.bmp';
              pic_fname_down_dis:='light_btn_down_dis.bmp';
              sp_name:='lightning';
            end;
            2: begin
              pic_fname_up:='chain_light_btn_up.bmp';
              pic_fname_down:='chain_light_btn_down.bmp';
              pic_fname_up_dis:='chainlight_btn_up_dis.bmp';
              pic_fname_down_dis:='chainlight_btn_down_dis.bmp';
              sp_name:='chain_lightning';
            end;
            3: begin
              pic_fname_up:='nova_btn_up.bmp';
              pic_fname_down:='nova_btn_down.bmp';
              pic_fname_up_dis:='nova_btn_up_dis.bmp';
              pic_fname_down_dis:='nova_btn_down_dis.bmp';
              sp_name:='nova';
            end;
            4: begin
              //
              sp_name:='';
            end;
            5: begin
              //
              sp_name:='';
            end;
          end; // case i

        end;
        2: begin
          case i of
            1: begin
              pic_fname_up:='buildweb_btn_up.bmp';
              pic_fname_down:='buildweb_btn_down.bmp';
              pic_fname_up_dis:='buildweb_btn_up_dis.bmp';
              pic_fname_down_dis:='buildweb_btn_down_dis.bmp';
              sp_name:='build_web';
            end;
            2: begin
              pic_fname_up:='destroyweb_btn_up.bmp';
              pic_fname_down:='destroyweb_btn_down.bmp';
              pic_fname_up_dis:='destroyweb_btn_up_dis.bmp';
              pic_fname_down_dis:='destroyweb_btn_down_dis.bmp';
              sp_name:='destroy_web';
            end;
            3: begin
              //
              sp_name:='';
            end;
            4: begin
              //
              sp_name:='';
            end;
            5: begin
              //
              sp_name:='';
            end;
          end; // case i
        end;

        3: begin
          case i of
            1: begin
              //
              sp_name:='';
            end;
            2: begin
              //
              sp_name:='';
            end;
            3: begin
              //
              sp_name:='';
            end;
            4: begin
              //
              sp_name:='';
            end;
            5: begin
              //
              sp_name:='';
            end;
          end; // case i
        end; // j 3

        4: begin
          case i of
            1: begin
              //
              sp_name:='';
            end;
            2: begin
              //
              sp_name:='';
            end;
            3: begin
              //
              sp_name:='';
            end;
            4: begin
              //
              sp_name:='';
            end;
            5: begin
              //
              sp_name:='';
            end;
          end; // case i
        end; // j 4

        5: begin
          case i of
            1: begin
              //
              sp_name:='';
            end;
            2: begin
              //
              sp_name:='';
            end;
            3: begin
              //
              sp_name:='';
            end;
            4: begin
              //
              sp_name:='';
            end;
            5: begin
              //
              sp_name:='';
            end;
          end; // case i
        end; // j 5
      end; // case j
        //---------

      if (sp_name = '') then Continue;

      hud_inv_spells[i,j].hud_spell_pic_up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_spells[i,j].hud_spell_pic_up do begin
        // load image BMP
        hud_inv_spells[i,j].spell_name:=sp_name;
        Material.Texture.Image.LoadFromFile(pic_fname_up); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=(startX+(i*60)-185);
          hud_inv_spells[i,j].posX:=(startX+(i*60)-185);
        Position.Y:=(startY+(j*60)-10);
          hud_inv_spells[i,j].posY:=(startY+(j*60)-10);


          Height:=50;
          Width:=50;
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

        hud_inv_spells[i,j].hud_spell_pic_down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
        with hud_inv_spells[i,j].hud_spell_pic_down do begin
          // load image BMP

          Material.Texture.Image.LoadFromFile(pic_fname_down); //base_14.bmp
          //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
          // set position and dimension
          Position.X:=(startX+(i*60)-185);
          Position.Y:=(startY+(j*60)-10);
          Height:=50;
          Width:=50;
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

        hud_inv_spells[i,j].hud_spell_pic_up_disabled:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
        with hud_inv_spells[i,j].hud_spell_pic_up_disabled do begin
          // load image BMP

          Material.Texture.Image.LoadFromFile(pic_fname_up_dis); //base_14.bmp
          //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
          // set position and dimension
          Position.X:=(startX+(i*60)-185);
          Position.Y:=(startY+(j*60)-10);
          Height:=50;
          Width:=50;
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

        hud_inv_spells[i,j].hud_spell_pic_down_disabled:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
        with hud_inv_spells[i,j].hud_spell_pic_down_disabled do begin
          // load image BMP

          Material.Texture.Image.LoadFromFile(pic_fname_down_dis); //base_14.bmp
          //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
          // set position and dimension
          Position.X:=(startX+(i*60)-185);
          Position.Y:=(startY+(j*60)-10);
          Height:=50;
          Width:=50;
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

      end; // for i
    end; // for j

  // lightning done
  hud_inv_spells[1,1].upgraded:=true;
  end;// with form
end;

procedure showHudInvSpells;
var
  i,j:byte;
begin
  with Form1 do begin
    hud_hero_lab_points.Visible:=true;
    hud_hero_text_points.Visible:=true;

    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        if (hud_inv_spells[i,j].spell_name = '') then Continue;

          if (hud_inv_spells[i,j].upgraded) then begin
            // show down dis pic
            hud_inv_spells[i,j].hud_spell_pic_down_disabled.Visible:=true;
            Continue;
          end;

          if (MH_level_up_points = 0) then begin
            // show up dis pic
            hud_inv_spells[i,j].hud_spell_pic_up_disabled.Visible:=true;
            Continue;
          end;

          hud_inv_spells[i,j].hud_spell_pic_up.Visible:=true;


      end; // for i
    end; // for j

  end; // with form1
end;

procedure hideHudInvSpells;
var
  i,j :byte;
begin
  with Form1 do begin
    hud_hero_lab_points.Visible:=false;
    hud_hero_text_points.Visible:=false;

    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        if (hud_inv_spells[i,j].spell_name = '') then Continue;

        hud_inv_spells[i,j].hud_spell_pic_up.Visible:=false;
        hud_inv_spells[i,j].hud_spell_pic_down.Visible:=false;
        hud_inv_spells[i,j].hud_spell_pic_up_disabled.Visible:=false;
        hud_inv_spells[i,j].hud_spell_pic_down_disabled.Visible:=false;

      end; // for i
    end; // for j
   
  end; // with form1
end;

procedure AddHudSpriteHeroLabels;
var
  startX, startY:Integer;
begin
  with Form1 do begin
    // items carrier
    startX:=160; //160
    startY:=580; // 580
      // MH Exp label
      hud_hero_lab_exp:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_exp do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=startY;
        Height:=30; // 50
        Width:=310;
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

      // MH Exp caption
      hud_hero_text_exp:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_exp do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-7);
        hud_hero_text_exp.Text:='EXPERIENCE ';
        Visible:=false;
      end;// with

      // MH Defence label
      hud_hero_lab_def:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_def do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-35);
        Height:=30;
        Width:=310;
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

      // MH def caption
      hud_hero_text_def:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_def do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-35-7);
        hud_hero_text_def.Text:='DEFENCE  ';
        Visible:=false;
      end;// with

      // MH Attack label
      hud_hero_lab_att:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_att do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-70);
        Height:=30;
        Width:=310;
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

      // MH att caption
      hud_hero_text_att:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_att do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-70-7);
        hud_hero_text_att.Text:='ATTACK   ';
        Visible:=false;
      end;// with

      // MH Mana label
      hud_hero_lab_mana:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_mana do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-105);
        Height:=30;
        Width:=310;
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

      // MH mana caption
      hud_hero_text_mana:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_mana do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-105-7);
        hud_hero_text_mana.Text:='MANA     ';
        Visible:=false;
      end;// with

      // MH Life label
      hud_hero_lab_life:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_life do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-140);
        Height:=30;
        Width:=310;
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

      // MH life caption
      hud_hero_text_life:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_life do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-140-7);
        hud_hero_text_life.Text:='LIFE     ';
        Visible:=false;
      end;// with

      // MH spell label
      hud_hero_lab_spell:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_spell do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-175);
        Height:=30;
        Width:=310;
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

      // MH spell caption
      hud_hero_text_spell:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_spell do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-175-7);
        Text:='SPELL ';
        Visible:=false;
      end;// with

      // MH level label
      hud_hero_lab_lev:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_lev do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-210);
        Height:=30;
        Width:=310;
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

      // MH level caption
      hud_hero_text_lev:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_lev do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-210-7);
        Text:='HERO LEVEL ';
        Visible:=false;
      end;// with

      // MH Map level label
      hud_hero_lab_level:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_lab_level do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('top_text_base.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        Position.X:=startX;
        Position.Y:=(startY-245);
        Height:=30;
        Width:=310;
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

      // MH level caption
      hud_hero_text_level:=THUDText(DCHUDTop.AddNewChild(THUDText));
      with hud_hero_text_level do begin
        // load image BMP
        BitmapFont:=BitmapFont1;
        Scale.SetVector(0.5,0.5,0.5);
        // set position and dimension
        Position.X:=13;
        Position.Y:=(startY-245-7);
        Text:='MAP LEVEL  ';
        Visible:=false;
      end;// with

  end; // with Form1
end;

procedure AddHudSpriteInvWearableBase;
var
  startX,startY:Integer;
begin
  with Form1 do begin
    // items carrier
    startX:=640;
    startY:=400;
    hud_MH_wear_base:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
    with hud_MH_wear_base do begin
      // load image BMP

      Material.Texture.Image.LoadFromFile('MH_wear_base.bmp'); //base_14.bmp
      Position.X:=startX;
      Position.Y:=startY;

      Height:=300;
      Width:=300;
      Rotation:=90;
      // set proper transperancy
      Material.MaterialOptions := Material.MaterialOptions + [moIgnoreFog,moNoLighting];
      Material.BlendingMode:=bmAdditive;//bmTransparency;  // uses GLTexture
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
      Material.Texture.TextureFormat:=tfDefault; //tfRGBA
      Material.Texture.TextureMode:=tmModulate; // tmBlend;
      Material.Texture.TextureWrap:=twBoth; //None
      // allow texture
      Material.Texture.Disabled:=false;
      Visible:=false;
    end;// with
  end; // with form1
end;

procedure AddHudSpriteInvCloseBtn;
var
  startX,startY:Integer;
begin
  with Form1 do begin
    startX:=440;
    startY:=410;
    hud_inv_closeBtn_Up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_closeBtn_Up do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_up.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        Position.X:=startX;
        Position.Y:=startY;

        Height:=50;
        Width:=50;
        //Rotation:=-90;
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

      hud_inv_closeBtn_Down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_closeBtn_Down do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_down.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        Position.X:=startX;
        Position.Y:=startY;

        Height:=50;
        Width:=50;
        //Rotation:=-90;
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
end;

procedure AddHudSpriteHeroCloseBtn;
var
  startX, startY:Integer;
begin
  with Form1 do begin
    startX:=360; // 440
    startY:=410; // 410
    hud_hero_closeBtn_Up:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_closeBtn_Up do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_up.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        Position.X:=startX;
        Position.Y:=startY;

        Height:=50; ///50
        Width:=50;
        //Rotation:=-90;
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

      hud_hero_closeBtn_Down:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_hero_closeBtn_Down do begin
        // load image BMP
        Material.Texture.Image.LoadFromFile('close_inv_btn_down.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        Position.X:=startX;
        Position.Y:=startY;

        Height:=50;
        Width:=50;
        //Rotation:=-90;
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
end;

procedure AddHudSpriteInvWearCells;
var
  i:byte;
begin
  with Form1 do begin
    // items wear
    for i:= 1 to 7 do begin
      hud_inv_wearable[i].hud_pic:=THUDSprite(DCHUDTop.AddNewChild(THUDSprite));
      with hud_inv_wearable[i].hud_pic do begin
        // load image BMP

        Material.Texture.Image.LoadFromFile('inv_cell.bmp'); //base_14.bmp
        //Material.Texture.Image:=GLMLHudSprites.Materials[0].Material.Texture.Image;
        // set position and dimension
        case i of
          1: begin // bottom left
            // set X
            Position.X:=565;
            hud_inv_wearable[i].posX:=(565-25);
            // setY
            Position.Y:=460;
            hud_inv_wearable[i].posY:=(460-25);
          end; // 1
          2: begin
            // set X
            Position.X:=645;
            hud_inv_wearable[i].posX:=(645-25);
            // setY
            Position.Y:=460;
            hud_inv_wearable[i].posY:=(460-25);
          end; // 2
          3: begin
            // set X
            Position.X:=715;
            hud_inv_wearable[i].posX:=(715-25);
            // setY
            Position.Y:=460;
            hud_inv_wearable[i].posY:=(460-25);
          end; // 3
          4: begin // center
            // set X
            Position.X:=665; //665
            hud_inv_wearable[i].posX:=(665-25);
            // setY
            Position.Y:=400;
            hud_inv_wearable[i].posY:=(400-25);
          end; // 4
          5: begin // top left
            // set X
            Position.X:=565; //645
            hud_inv_wearable[i].posX:=(565-25);
            // setY
            Position.Y:=340; // 320
            hud_inv_wearable[i].posY:=(340-25);
          end; // 5
          6: begin // top left
            // set X
            Position.X:=645; //645
            hud_inv_wearable[i].posX:=(645-25);
            // setY
            Position.Y:=340;
            hud_inv_wearable[i].posY:=(340-25);
          end; // 6
          7: begin // top left
            // set X
            Position.X:=715; //645
            hud_inv_wearable[i].posX:=(715-25);
            // setY
            Position.Y:=340;
            hud_inv_wearable[i].posY:=(340-25);
          end; // 7
        end; // case


        Height:=50;
        Width:=50;
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
  end; // with
end;

function calcIsEnoughMHEnergy(mode:String):boolean;
var
  ManaCost, MHMana:smallint;
begin
  // in processMHLight before each MHLigSrike
  with Form1 do begin
    Result:=false;
    if (mode='lightning') then begin
      // get current mana cost
      ManaCost:=(BaseLightningCost);
      MHMana:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      if ((MHMana-ManaCost) >= 0) then begin
        // can cast the magic
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(MHMana-ManaCost);
        Result:=true;
        Exit;
      end; // if >0
    end; // if lightning

    if (mode='chain_lightning') then begin
      // get current mana cost
      ManaCost:=(BaseChainLightningCost);
      MHMana:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      if ((MHMana-ManaCost) >= 0) then begin
        // can cast the magic
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(MHMana-ManaCost);
        Result:=true;
        Exit;
      end; // if >0
    end; // if chain lightning

    if (mode='nova') then begin
      // get current mana cost
      ManaCost:=(BaseNovaCost);
      MHMana:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      if ((MHMana-ManaCost) >= 0) then begin
        // can cast the magic
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(MHMana-ManaCost);
        Result:=true;
        Exit;
      end; // if >0
    end; // if nova

    if (mode='build_web') then begin
      // get current mana cost
      ManaCost:=(BaseBuildWebCost);
      MHMana:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      if ((MHMana-ManaCost) >= 0) then begin
        // can cast the magic
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(MHMana-ManaCost);
        Result:=true;
        Exit;
      end; // if >0
    end; // if nova

    if (mode='destroy_web') then begin
      // get current mana cost
      ManaCost:=(BaseDestroyWebCost);
      MHMana:=round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      if ((MHMana-ManaCost) >= 0) then begin
        // can cast the magic
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(MHMana-ManaCost);
        Result:=true;
        Exit;
      end; // if >0
    end; // if nova

  end; // with Form1
end;

function checkIsUnderMouseMovableItem(X, Y: Integer):boolean;
var
  i,j:Integer;
begin
  Result:=false;
  with Form1 do begin
    for j:=(Y-2) to (Y+2) do begin
      for i:=(X-2) to (X+2) do begin
        //- Life cell -----------------------
        if (terrObs[i,j].itemId=150) then begin
          pick_move_item_ID:=150;
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Result:=true;
          Exit;
        end; // if
        //------------------------------------
        //- Mana cell -----------------------
        if (terrObs[i,j].itemId=151) then begin
          pick_move_item_ID:=151;
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Result:=true;
          Exit;
        end; // if
        //------------------------------------
        //- Armor A  -----------------------
        if (terrObs[i,j].itemId=160) then begin
          pick_move_item_ID:=160;
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Result:=true;
          Exit;
        end; // if
        //- Weapon A  -----------------------
        if (terrObs[i,j].itemId=180) then begin
          pick_move_item_ID:=180;
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Result:=true;
          Exit;
        end; // if
        //- Power Spx  -----------------------
        if (terrObs[i,j].itemId=190) then begin
          pick_move_item_ID:=190;
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Result:=true;
          Exit;
        end; // if
        //------------------------------------
      end;  //for i
    end; // for j
  end; // with 
end;

procedure getUnderMousePicketObjectsList;
begin
  {
  // TRect
  rc.top:=Y;
  rc.left:=X;
  rc.Right:=X+10;
  rc.Bottom:=Y+10;

  pl:=GLSceneViewer1.Buffer.GetPickedObjects(rc);
  i:=pl.Count;
  i:=pl.FindObject(hud_inv_closeBtn_Up);
  i:=(pl.Hit[i]).Tag;
  Showmessage(IntToStr(i));
  }
end;

procedure processMovableItemPick(itemID:byte;item_posX,item_posY:Integer);
var
  i,j,c:Integer;
begin
  with Form1 do begin
    // life cell pick--------------------
    if(itemID=150) then begin
      play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
      // show sprite cell
      AddHudSpriteRTLife(mx,my);
      // show inv sprite
      movable_item_drop_needed:=true;
      // show inv sprite
         //hud_inv.Position.Y:=344;
         //showHudInvOrnaments;
         //  showHudInvCarrier;
         //hud_inv.Visible:=true;
         invokeInventoryWindow(false);
         printTextBarInfo('life_cell',0);
      // clear terrain cell-- pick_move_itemX pick_move_itemY
      terrObs[item_posX,item_posY].itemId:=0;
      for c:= DCCellsLife.ComponentCount downto 0 do begin
        i:=round(DCCellsLife.Children[c].Position.X);
        j:=round(DCCellsLife.Children[c].Position.Z);
        if( (i=item_posX)and(j=item_posY) ) then begin
          DCCellsLife.Children[c].Free;
        end; // if not in area
      end; // for
      Exit;
    end; // if 150
    //----------------------------------

    // mana cell pick--------------------
    if(itemID=151) then begin
      play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
      // show sprite cell
      AddHudSpriteRTMana(mx,my);
      // show inv sprite
      movable_item_drop_needed:=true;
      // show inv sprite
        //hud_inv.Position.Y:=344;
        // showHudInvOrnaments;
        //   showHudInvCarrier;
        //hud_inv.Visible:=true;
        invokeInventoryWindow(false);
        printTextBarInfo('mana_cell',0);
      // clear terrain cell-- pick_move_itemX pick_move_itemY
      terrObs[item_posX,item_posY].itemId:=0;
      for c:= DCCellsEnergy.ComponentCount downto 0 do begin
        i:=round(DCCellsEnergy.Children[c].Position.X);
        j:=round(DCCellsEnergy.Children[c].Position.Z);
        if( (i=item_posX)and(j=item_posY) ) then begin
          DCCellsEnergy.Children[c].Free;
        end; // if not in area
      end; // for
      Exit;
    end; // if 151

    // ArmorA pick--------------------
    if(itemID=160) then begin
      play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
      // show sprite cell
      AddHudSpriteRTArmorA(mx,my);
      // show inv sprite
      movable_item_drop_needed:=true;
      // show inv sprite
         //hud_inv.Position.Y:=344;
         //showHudInvOrnaments;
         //  showHudInvCarrier;
          //hud_inv.Visible:=true;
          invokeInventoryWindow(false);
          printTextBarInfo('armor_A',0);
      // clear terrain cell-- pick_move_itemX pick_move_itemY
      terrObs[item_posX,item_posY].itemId:=0;
      for c:= DCArmorA.ComponentCount downto 0 do begin
        i:=round(DCArmorA.Children[c].Position.X);
        j:=round(DCArmorA.Children[c].Position.Z);
        if( (i=item_posX)and(j=item_posY) ) then begin
          DCArmorA.Children[c].Free;
        end; // if not in area
      end; // for
      Exit;
    end; // if 160
    //----------------------------------

    // WeaponA pick--------------------
    if(itemID=180) then begin
      play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
      // show sprite cell
      AddHudSpriteRTWeaponA(mx,my);
      // show inv sprite
      movable_item_drop_needed:=true;

      invokeInventoryWindow(false);
      printTextBarInfo('weapon_A',0);
      // clear terrain cell-- pick_move_itemX pick_move_itemY
      terrObs[item_posX,item_posY].itemId:=0;
      for c:= DCWeaponA.ComponentCount downto 0 do begin
        i:=round(DCWeaponA.Children[c].Position.X);
        j:=round(DCWeaponA.Children[c].Position.Z);
        if( (i=item_posX)and(j=item_posY) ) then begin
          DCWeaponA.Children[c].Free;
        end; // if not in area
      end; // for
      Exit;
    end; // if 180
    //----------------------------------

    // power spx pick--------------------
    if(itemID=190) then begin
      play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
      // show sprite cell
      AddHudSpriteRTPowerSpx(mx,my);
      // show inv sprite
      movable_item_drop_needed:=true;
      // show inv sprite

      invokeInventoryWindow(false);
      printTextBarInfo('power_spx',0);
      // clear terrain cell-- pick_move_itemX pick_move_itemY
      terrObs[item_posX,item_posY].itemId:=0;
      for c:= DCPowerSphere.ComponentCount downto 0 do begin
        i:=round(DCPowerSphere.Children[c].Position.X);
        j:=round(DCPowerSphere.Children[c].Position.Z);
        if( (i=item_posX)and(j=item_posY) ) then begin
          DCPowerSphere.Children[c].Free;
        end; // if not in area
      end; // for
      Exit;
    end; // if 190
    //----------------------------------
  end; // with Form1
end;

procedure processMovableItemOnTerrainDrop(itemID:byte;item_posX,item_posY:Integer);
begin
  with Form1 do begin
    // life cell drop--------------------
    if(itemID=150) then begin
      play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
      // drop it on terrain
      movable_item_drop_needed:=false;
      hud_top_RTLife.Visible:=false;
      hud_top_RTLifeCore.Visible:=false;
        deleteMovableHUDSprite;
          setDropPointOnTerrain;
      terrObsFillCell(pick_move_itemX,pick_move_itemY,150,0);
      Exit;
    end; // if 150
    //----------------------------------

    // mana cell drop--------------------
    if(itemID=151) then begin
      play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
      // drop it on terrain
      movable_item_drop_needed:=false;
      hud_top_RTMana.Visible:=false;
      hud_top_RTManaCore.Visible:=false;
        deleteMovableHUDSprite;
          setDropPointOnTerrain;
      terrObsFillCell(pick_move_itemX,pick_move_itemY,151,0);
      Exit;
    end; // if 151
    //----------------------------------

    // Armor A drop--------------------
    if(itemID=160) then begin
      play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
      // drop it on terrain
      movable_item_drop_needed:=false;
      hud_top_RTArmorA.Visible:=false;
      hud_top_RTArmorACore.Visible:=false;
        deleteMovableHUDSprite;
          setDropPointOnTerrain;
      terrObsFillCell(pick_move_itemX,pick_move_itemY,160,0);
      Exit;
    end; // if 160
    //----------------------------------

    // Weapon A drop--------------------
    if(itemID=180) then begin
      play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
      // drop it on terrain
      movable_item_drop_needed:=false;
      hud_top_RTWeaponA.Visible:=false;
      hud_top_RTWeaponACore.Visible:=false;
        deleteMovableHUDSprite;
          setDropPointOnTerrain;
      terrObsFillCell(pick_move_itemX,pick_move_itemY,180,0);
      Exit;
    end; // if 180
    //----------------------------------

    // Power Spx drop--------------------
    if(itemID=190) then begin
      play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
      // drop it on terrain
      movable_item_drop_needed:=false;
      hud_top_RTPowerSpx.Visible:=false;
      hud_top_RTPowerSpxCore.Visible:=false;
        deleteMovableHUDSprite;
          setDropPointOnTerrain;
      terrObsFillCell(pick_move_itemX,pick_move_itemY,190,0);
        power_spx_X:=pick_move_itemX;
        power_spx_Y:=pick_move_itemY;
      Exit;
    end; // if 190
    //----------------------------------
  end; // with Form1
end;

procedure processMovableItem_MouseMove(itemID:byte;curr_item_posX,curr_item_posY:Integer);
begin
  with Form1 do begin
    // life cell --------------------
    if(itemID=150) then begin
      // core
      hud_top_RTLifeCore.Position.X:=curr_item_posX;
      hud_top_RTLifeCore.Position.Y:=curr_item_posY;
      // shell
      hud_top_RTLife.Position.X:=curr_item_posX;
      hud_top_RTLife.Position.Y:=curr_item_posY;
    end; // if 150
    //----------------------------------

    // mana cell --------------------
    if(itemID=151) then begin
      // core
      hud_top_RTManaCore.Position.X:=curr_item_posX;
      hud_top_RTManaCore.Position.Y:=curr_item_posY;
      // shell
      hud_top_RTMana.Position.X:=curr_item_posX;
      hud_top_RTMana.Position.Y:=curr_item_posY;
    end; // if 151
    //----------------------------------

    // Armor A --------------------
    if(itemID=160) then begin
      // core
      hud_top_RTArmorACore.Position.X:=curr_item_posX;
      hud_top_RTArmorACore.Position.Y:=curr_item_posY;
      // shell
      hud_top_RTArmorA.Position.X:=curr_item_posX;
      hud_top_RTArmorA.Position.Y:=curr_item_posY;
    end; // if 160
    //----------------------------------

    // Weapon A --------------------
    if(itemID=180) then begin
      // core
      hud_top_RTWeaponACore.Position.X:=curr_item_posX;
      hud_top_RTWeaponACore.Position.Y:=curr_item_posY;
      // shell
      hud_top_RTWeaponA.Position.X:=curr_item_posX;
      hud_top_RTWeaponA.Position.Y:=curr_item_posY;
    end; // if 180
    //----------------------------------
    // power --------------------
    if(itemID=190) then begin
      // core
      hud_top_RTPowerSpxCore.Position.X:=curr_item_posX;
      hud_top_RTPowerSpxCore.Position.Y:=curr_item_posY;
      // shell
      hud_top_RTPowerSpx.Position.X:=curr_item_posX;
      hud_top_RTPowerSpx.Position.Y:=curr_item_posY;
    end; // if 151
    //----------------------------------
  end; // with Form1
end;

procedure processMovableItemOnCarrierDrop(itemID:byte;item_posX,item_posY:Integer);
var
  cell_id, cell_content:byte;
begin
  with Form1 do begin
    // life cell drop--------------------
    if(itemID=150) then begin
      // get carrir cell index
      cell_id:=getUnderMouseCarrierCellIndex(item_posX,item_posY);
      if (cell_id <> 0) then begin
        // we have proper cell so check is empty MH_inv_carrier[].item  =0;
        cell_content:=getUnderMouseCarrierCellContent(cell_id);
        if (cell_content=0) then begin
          // we can drop item in empty cell
          play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
          // drop it on carrier
          movable_item_drop_needed:=false;
          hud_top_RTLife.Visible:=false;
          hud_top_RTLifeCore.Visible:=false;
          // get cell coordinates and invoke sprite
          item_posX:=round(hud_inv_carrier[cell_id].posX)+25;
          item_posY:=round(hud_inv_carrier[cell_id].PosY)+25;
          // add item picture
          AddHudCarrierRTItem(cell_id, item_posX, item_posY,itemID);
          // set item id
          hud_inv_carrier[cell_id].itemID:=itemID;
          // delete movable HUD Sprite
          deleteMovableHUDSprite;
            update_hud_top_view;
        end; // cell content
      end; // if cell id <> 0
      Exit;
    end; // if 150
    //-----------------------------------
    // mana cell drop--------------------
    if(itemID=151) then begin
      // get carrir cell index
      cell_id:=getUnderMouseCarrierCellIndex(item_posX,item_posY);
      if (cell_id <> 0) then begin
        // we have proper cell so check is empty MH_inv_carrier[].item  =0;
        cell_content:=getUnderMouseCarrierCellContent(cell_id);
        if (cell_content=0) then begin
          // we can drop item in empty cell
          play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
          // drop it on carrier
          movable_item_drop_needed:=false;
          hud_top_RTMana.Visible:=false;
          hud_top_RTManaCore.Visible:=false;
          // get cell coordinates and invoke sprite
          item_posX:=round(hud_inv_carrier[cell_id].posX)+25;
          item_posY:=round(hud_inv_carrier[cell_id].PosY)+25;
          // add item picture
          AddHudCarrierRTItem(cell_id, item_posX, item_posY,itemID);
          // set item id
          hud_inv_carrier[cell_id].itemID:=itemID;
          // delete movable HUD Sprite
          deleteMovableHUDSprite;
            update_hud_top_view;
        end; // cell content
      end; // if cell id <> 0
      Exit;
    end; // if 151
    //-----------------------------------
    // armor A drop--------------------
    if(itemID=160) then begin
      // get carrir cell index
      cell_id:=getUnderMouseCarrierCellIndex(item_posX,item_posY);
      if (cell_id <> 0) then begin
        // we have proper cell so check is empty MH_inv_carrier[].item  =0;
        cell_content:=getUnderMouseCarrierCellContent(cell_id);
        if (cell_content=0) then begin
          // we can drop item in empty cell
          play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
          // drop it on carrier
          movable_item_drop_needed:=false;
          hud_top_RTArmorA.Visible:=false;
          hud_top_RTArmorACore.Visible:=false;
          // get cell coordinates and invoke sprite
          item_posX:=round(hud_inv_carrier[cell_id].posX)+25;
          item_posY:=round(hud_inv_carrier[cell_id].PosY)+25;
          // add item picture
          AddHudCarrierRTItem(cell_id, item_posX, item_posY,itemID);
          // set item id
          hud_inv_carrier[cell_id].itemID:=itemID;
          // delete movable HUD Sprite
          deleteMovableHUDSprite;
        end; // cell content
      end; // if cell id <> 0
      Exit;
    end; // if 160
    //-----------------------------------

    // weapon A drop--------------------
    if(itemID=180) then begin
      // get carrir cell index
      cell_id:=getUnderMouseCarrierCellIndex(item_posX,item_posY);
      if (cell_id <> 0) then begin
        // we have proper cell so check is empty MH_inv_carrier[].item  =0;
        cell_content:=getUnderMouseCarrierCellContent(cell_id);
        if (cell_content=0) then begin
          // we can drop item in empty cell
          play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
          // drop it on carrier
          movable_item_drop_needed:=false;
          hud_top_RTWeaponA.Visible:=false;
          hud_top_RTWeaponACore.Visible:=false;
          // get cell coordinates and invoke sprite
          item_posX:=round(hud_inv_carrier[cell_id].posX)+25;
          item_posY:=round(hud_inv_carrier[cell_id].PosY)+25;
          // add item picture
          AddHudCarrierRTItem(cell_id, item_posX, item_posY,itemID);
          // set item id
          hud_inv_carrier[cell_id].itemID:=itemID;
          // delete movable HUD Sprite
          deleteMovableHUDSprite;
        end; // cell content
      end; // if cell id <> 0
      Exit;
    end; // if 180
    //-----------------------------------

    // power spx drop--------------------
    if(itemID=190) then begin
      // get carrir cell index
      cell_id:=getUnderMouseCarrierCellIndex(item_posX,item_posY);
      if (cell_id <> 0) then begin
        // we have proper cell so check is empty MH_inv_carrier[].item  =0;
        cell_content:=getUnderMouseCarrierCellContent(cell_id);
        if (cell_content=0) then begin
          // we can drop item in empty cell
          play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
          // drop it on carrier
          movable_item_drop_needed:=false;
          hud_top_RTPowerSpx.Visible:=false;
          hud_top_RTPowerSpxCore.Visible:=false;
          // get cell coordinates and invoke sprite
          item_posX:=round(hud_inv_carrier[cell_id].posX)+25;
          item_posY:=round(hud_inv_carrier[cell_id].PosY)+25;
          // add item picture
          AddHudCarrierRTItem(cell_id, item_posX, item_posY,itemID);
          // set item id
          hud_inv_carrier[cell_id].itemID:=itemID;
          // delete movable HUD Sprite
          deleteMovableHUDSprite;
        end; // cell content
      end; // if cell id <> 0
      Exit;
    end; // if 151
    //-----------------------------------
  end; // with
end;

procedure processMovableItemOnWearDrop(itemID:byte;item_posX,item_posY:Integer);
var
  cell_id, cell_content:byte;
begin
  with Form1 do begin
    // use item_posX,item_posY to resolve / weapon / armor / cell
    //  150..Artifacts&Spheres..199
    // cells 150,151   [150..159]
    // armor           [160..179]
    // weapon 190 (ps) [180..190]
    // get carrir cell index
    cell_id:=getUnderMouseWearCellIndex(item_posX,item_posY);
    if (cell_id <> 0) then begin
      // we have proper cell so check is empty MH_inv_carrier[].item  =0;
      cell_content:=getUnderMouseWearCellContent(cell_id);
      if (cell_content=0) then begin
        // armors ----------------------
        if(itemID in[160..179]) then begin
          // it is some armor item center cell only
          if (cell_id=4) then begin
            // drop it on carrier
            if (itemID=160) then begin
              // ArmorA
              play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
              movable_item_drop_needed:=false;
              hud_top_RTArmorA.Visible:=false;
              hud_top_RTArmorACore.Visible:=false;
              // get cell coordinates and invoke sprite
              item_posX:=round(hud_inv_wearable[cell_id].posX)+25;
              item_posY:=round(hud_inv_wearable[cell_id].PosY)+25;
              // add item picture
              AddHudWearRTItem(cell_id, item_posX, item_posY,itemID);
              // set item id
              hud_inv_wearable[cell_id].itemID:=itemID;
              // delete movable HUD Sprite
              deleteMovableHUDSprite;
              update_wear_items_properties(true,4,160,getItemBonus(160));
            end; // if exact 160
          end; // if center wear cell 4
        end; // if item armor
        //------------------------------
        // weapons ----------------------
        if(itemID in[180..190]) then begin
          // it is some armor item not center cell
          if (cell_id <> 4) then begin
            // drop it on carrier
            if (itemID=180) then begin
              // weapon A
              play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
              movable_item_drop_needed:=false;
              hud_top_RTWeaponA.Visible:=false;
              hud_top_RTWeaponACore.Visible:=false;
              // get cell coordinates and invoke sprite
              item_posX:=round(hud_inv_wearable[cell_id].posX)+25;
              item_posY:=round(hud_inv_wearable[cell_id].PosY)+25;
              // add item picture
              AddHudWearRTItem(cell_id, item_posX, item_posY,itemID);
              // set item id
              hud_inv_wearable[cell_id].itemID:=itemID;
              // delete movable HUD Sprite
              deleteMovableHUDSprite;
              update_wear_items_properties(true,1,180,getItemBonus(180));
            end; // if weaponA

            if (itemID=190) then begin
              // power Spx
              play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
              movable_item_drop_needed:=false;
              hud_top_RTPowerSpx.Visible:=false;
              hud_top_RTPowerSpxCore.Visible:=false;
              // get cell coordinates and invoke sprite
              item_posX:=round(hud_inv_wearable[cell_id].posX)+25;
              item_posY:=round(hud_inv_wearable[cell_id].PosY)+25;
              // add item picture
              AddHudWearRTItem(cell_id, item_posX, item_posY,itemID);
              // set item id
              hud_inv_wearable[cell_id].itemID:=itemID;
              // delete movable HUD Sprite
              deleteMovableHUDSprite;
              update_wear_items_properties(true,1,190,getItemBonus(190));
            end; // if power spx

          end; // if center wear cell 4
        end; // if item weapon
        //------------------------------
      end; // cell content
    end; // if cell id <> 0
  end; // with Form1
end;

function processMovableItemToInventory(drop_needed:boolean;X,Y:Integer;pick_move_item_ID:byte;itemX,itemY:Integer):boolean;
begin
  Result:=false;
  with Form1 do begin
    if (movable_item_drop_needed) then begin
      if not((X > 492)and(X < 787)and(Y > 320)and(Y < 591)) then begin
        // drop it on terrain
        processMovableItemOnTerrainDrop(pick_move_item_ID, pick_move_itemX, pick_move_itemY);
        Result:=true;
        Exit;
      end
      else
      begin
        if ((hud_inv.Visible)and(hud_inv_base_state=1)) then begin
          // drop it in inv carrier
          processMovableItemOnCarrierDrop(pick_move_item_ID,X,Y);
          processMovableItemOnWearDrop(pick_move_item_ID,X,Y);
          Result:=true;
          Exit;
        end
        else
        begin
          processMovableItemOnTerrainDrop(pick_move_item_ID, pick_move_itemX, pick_move_itemY);
          Result:=true;
          Exit;
        end;
      end;
    end; // if movable_item_drop_needed

    if not(movable_item_drop_needed) then begin
      if ((X > 492)and(X < 787)and(Y > 320)and(Y < 591))and(hud_inv.Visible)and
          (hud_inv_base_state=1) then begin
        processMovableItemFromCarrierOnTerrainDrop(X,Y);
        processMovableItemFromWearOnTerrainDrop(X,Y);
        Result:=true;
        Exit;
      end; // if
    end; // if not movable_item_drop_needed
  end; // with Form1
end;

function processWebsTeleportClick(X,Y:Integer):boolean;
var
  web_id:byte;
  Movement:TGLMovement;
begin
  Result:=false;
  with Form1 do begin
    if ((hud_inv.Visible)and(hud_inv_base_state=2)) then begin
      web_id:=getUnderMouseWebsCellIndex(X,Y);
      if (web_id <> 0) then begin
        if not(hud_inv_webs[web_id].hud_webs_pic_disabled.Visible) then begin
          hud_inv_webs[web_id].hud_webs_pic_down.Visible:=true;
          hud_inv_webs[web_id].hud_webs_pic_up.Visible:=false;
          play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
          Movement:= GetOrCreateMovement(DCMainHero);
          Movement.ClearPaths;
          Movement.StopPathTravel;
          Result:=true;
        end
        else
        begin
          // stop walk
          Movement:= GetOrCreateMovement(DCMainHero);
          Movement.ClearPaths;
          Movement.StopPathTravel;
          Result:=true;
        end;
      end; // if <>0
    end; // if state=2
  end; // with Form1
end;

function processSpellUpgradeClick(X,Y:Integer):boolean;
var
  sp_id:TVector;
  Movement:TGLMovement;
  i,j:byte;
begin
  Result:=false;
  with Form1 do begin
    if ((hud_hero.Visible)and(hud_hero_base_state=2)) then begin
      sp_id:=getUnderMouseSpellCellIndex(X,Y);
      if (round(sp_id[1]) <> 0) then begin
        if (MH_level_up_points > 0) then begin
          i:=round(sp_id[2]);
          j:=round(sp_id[3]);
          if not(hud_inv_spells[i,j].upgraded) then begin
            // close level up panel
            hideHudLevelUp;
            play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
            hud_inv_spells[i,j].hud_spell_pic_down_disabled.Visible:=true;
            hud_inv_spells[i,j].hud_spell_pic_up.Visible:=false;
            dec(MH_level_up_points);
            hud_inv_spells[i,j].upgraded:=true;
            // stop walk
            Movement:= GetOrCreateMovement(DCMainHero);
            Movement.ClearPaths;
            Movement.StopPathTravel;
            Result:=true;
          end; // if not
        end
        else
        begin
          // stop walk
          Movement:= GetOrCreateMovement(DCMainHero);
          Movement.ClearPaths;
          Movement.StopPathTravel;
          Result:=true; 
        end; // if level points
      end; // if <>0
    end; // if state=2
  end; // with Form1
end;

procedure processWebsTeleport_MouseUp(X,Y:Integer);
var
  web_id:byte;
begin
  with Form1 do begin
    if ((hud_inv.Visible)and(hud_inv_base_state=2)) then begin
      // check is over web
      web_id:=getUnderMouseWebsCellIndex(X,Y);
      if (web_id <> 0) then begin
        if (hud_inv_webs[web_id].hud_webs_pic_down.Visible)and
           (hud_inv_webs[web_id].hud_webs_pic_disabled.Visible=false) then begin

          hud_inv_webs[web_id].hud_webs_pic_up.Visible:=true;
          hud_inv_webs[web_id].hud_webs_pic_down.Visible:=false;
          // teleport it
          teleportMHtoWeb(web_id);
          // hide inv webs
          invokeWebsWindow(true);
        end;
      end; // if <>0
    end; // if not movable_item_drop_needed
  end; // with Form1
end;

procedure processSpellUpgrade_MouseUp(X,Y:Integer);
var
  sp_id:TVector;
  i,j:byte;
begin
  with Form1 do begin
    if ((hud_hero.Visible)and(hud_hero_base_state=2)) then begin
      // check is over web
      sp_id:=getUnderMouseSpellCellIndex(X,Y);
      if (round(sp_id[1]) <> 0) then begin
        i:=round(sp_id[2]);
        j:=round(sp_id[3]);

        play_MainMenuAudioTrack(5,fMainMenu.global_controls_volume_level,false);
        hud_inv_spells[i,j].hud_spell_pic_up.Visible:=true;
        hud_inv_spells[i,j].hud_spell_pic_down.Visible:=false;
      end; // if <>0
    end; // if not movable_item_drop_needed
  end; // with Form1
end;

procedure processMovableFromCarrierFill(X,Y:Integer);
var
  cell_id,cell_content:byte;
begin
  with Form1 do begin
    // get carrir cell index
  cell_id:=getUnderMouseCarrierCellIndex(X,Y);
    if (cell_id <> 0) then begin
      cell_content:=getUnderMouseCarrierCellContent(cell_id);
      if (cell_content <> 0) then begin
        // resolve cell content
        case cell_content of
          150: begin
            // if life cell --------------
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // fill MH Life
            MHdrinkCell(150);
            update_hud_top_view;
            //----------------------------
          end; // case 150
          151: begin
            // if mana cell --------------
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // fill NH Mana
            MHdrinkCell(151);
            update_hud_top_view;
            //----------------------------
          end; // case 151
        end; // case
      end; // if cell content
    end; // if cell
  end;
end;

function getUnderMouseCarrierCellIndex(posX,posY:Integer):byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  with Form1 do begin
    for i:= 1 to 12 do begin
      borderX:=hud_inv_carrier[i].posX;
      borderY:=hud_inv_carrier[i].posY;
      if( (posX >= borderX)and(posX < (borderX+50))and
          (posY >= borderY)and(posY < (borderY+50)) ) then begin
        // cursor in exact i cell
        Result:=i;
        Exit;
      end;
    end; // for all cells
  end; //with
end;

function getUnderMouseWearCellIndex(posX,posY:Integer):byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  with Form1 do begin
    for i:= 1 to 7 do begin
      borderX:=hud_inv_wearable[i].posX;
      borderY:=hud_inv_wearable[i].posY;
      if( (posX >= borderX)and(posX < (borderX+50))and
          (posY >= borderY)and(posY < (borderY+50)) ) then begin
        // cursor in exact i cell
        Result:=i;
        Exit;
      end;
    end; // for all cells
  end; //with
end;

function getUnderMouseSpellMenuCellIndex(posX,posY:Integer):byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  with Form1 do begin
    for i:= 1 to 5 do begin
      borderX:=(hud_menu_spells[i].posX_visio-25);
      borderY:=(hud_menu_spells[i].posY_visio-25);
      if( (posX >= borderX)and(posX < (borderX+50))and
          (posY >= borderY)and(posY < (borderY+50)) ) then begin
        // cursor in exact i cell
        Result:=i;
        Exit;
      end;
    end; // for all cells
  end; //with
end;

function getUnderMouseWindowsMenuCellIndex(posX,posY:Integer):byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  with Form1 do begin
    for i:= 1 to 5 do begin
      borderX:=(hud_menu_windows[i].posX-25);
      borderY:=(hud_menu_windows[i].posY-25);
      if( (posX >= borderX)and(posX < (borderX+50))and
          (posY >= borderY)and(posY < (borderY+50)) ) then begin
        // cursor in exact i cell
        Result:=i;
        Exit;
      end;
    end; // for all cells
  end; //with
end;

function getUnderMouseExitMenuCellIndex(posX,posY:Integer):byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  with Form1 do begin
    for i:= 1 to 2 do begin
      case i of
        1: begin
          borderX:=(hud_menu_exit[i].posX-8);
          borderY:=(hud_menu_exit[i].posY-8);
          if( (posX >= borderX)and(posX < (borderX+16))and
            (posY >= borderY)and(posY < (borderY+16)) ) then begin
            // cursor in exact i cell
            Result:=i;
            Exit;
          end;
        end; // 1
        2: begin  {242,50}
          borderX:=(hud_menu_exit[i].posX-100);
          borderY:=(hud_menu_exit[i].posY-25);
          if( (posX >= borderX)and(posX < (borderX+200))and
            (posY >= borderY)and(posY < (borderY+50)) ) then begin
            // cursor in exact i cell
            Result:=i;
            Exit;
          end;
        end; // 2
      end; // case
    end; // for all cells
  end; //with
end;

function getItemBonus(idx:byte):byte;
begin
  Result:=0;
  case idx of
    160: begin
      // armor A
      // decrease E*BaseAttack
      Result:=(2);
      Exit;
    end; // 160
    180: begin
      // weapon A
      // increase MHBaseAttack
      Result:=(2);
      Exit;
    end; // 180
    190: begin
      // power spx
      // increase MHBaseLife / Mana
      Result:=20;
      Exit;
    end; // 190
  end; // case
end;

function getObjectiveText:String;
begin
  Result:='';
  with fMainMenu do begin
    case current_level of
      1: begin
        Result:='MISSION OBJECTIVES -' +
                #13#10 +  #13#10 +
                'FIND THE POWER SPHERE'+
                #13#10 + #13#10 +
                'AND THE LEVEL PORTAL' +
                #13#10 + #13#10 +
                'GOOD LUCK !';
        Exit;
      end;
      2: begin
        Result:='MISSION OBJECTIVES -' +
                #13#10 +  #13#10 +
                'FIND THE POWER SPHERE'+
                #13#10 + #13#10 +
                'AND THE LEVEL PORTAL' +
                #13#10 + #13#10 +
                'GOOD LUCK !';
        Exit;
      end;
      3: begin
        Result:='MISSION OBJECTIVES -' +
                #13#10 +  #13#10 +
                'FIND THE POWER SPHERE'+
                #13#10 + #13#10 +
                'AND THE LEVEL PORTAL' +
                #13#10 + #13#10 +
                'GOOD LUCK !';
        Exit;
      end;
      4: begin
        Result:='MISSION OBJECTIVES -' +
                #13#10 +  #13#10 +
                'FIND THE POWER SPHERE'+
                #13#10 + #13#10 +
                'AND THE LEVEL PORTAL' +
                #13#10 + #13#10 +
                'GOOD LUCK !';
        Exit;
      end;
      5: begin
        Result:='MISSION OBJECTIVES -' +
                #13#10 +  #13#10 +
                'FIND THE POWER SPHERE'+
                #13#10 + #13#10 +
                'AND THE LEVEL PORTAL' +
                #13#10 + #13#10 +
                'GOOD LUCK !';
        Exit;
      end;
      6: begin
        Result:='MISSION OBJECTIVES -' +
                #13#10 +  #13#10 +
                'FIND THE POWER SPHERE'+
                #13#10 + #13#10 +
                'AND THE LEVEL PORTAL' +
                #13#10 + #13#10 +
                'GOOD LUCK !';
        Exit;
      end;
    end; // case
  end; // with
end;

function isTopMenuUpgradedSpell(idx:byte):boolean;
begin
  Result:=false;
  with Form1 do begin
    if(hud_menu_spells[idx].spell_name='lightning') then begin
      Result:=true;
      Exit;
    end; // if lightn

    if(hud_menu_spells[idx].spell_name='chain_lightning') then begin
      Result:=hud_inv_spells[2,1].upgraded;
      Exit;
    end; // if chain lightn

    if(hud_menu_spells[idx].spell_name='nova') then begin
      Result:=hud_inv_spells[3,1].upgraded;
      Exit;
    end; // if nova

    if(hud_menu_spells[idx].spell_name='build_web') then begin
      Result:=hud_inv_spells[1,2].upgraded;
      Exit;
    end; // if build

    if(hud_menu_spells[idx].spell_name='destroy_web') then begin
      Result:=hud_inv_spells[2,2].upgraded;
      Exit;
    end; // if destroy

  end; // with form1
end;

function getUnderMouseCarrierCellContent(cell_idx:byte):byte;
begin
  with Form1 do begin
    Result:=hud_inv_carrier[cell_idx].itemID;
  end; // with
end;

function getUnderMouseWearCellContent(cell_idx:byte):byte;
begin
  with Form1 do begin
    Result:=hud_inv_wearable[cell_idx].itemID;
  end; // with
end;

function getUnderMouseWebsCellIndex(posX,posY:Integer):byte;
var
  i, borderX, borderY:Integer;
begin
  Result:=0;
  with Form1 do begin
    for i:= 1 to 8 do begin
      if(hud_inv_webs[i].hud_webs_pic.Visible) then begin
        borderX:=(hud_inv_webs[i].posX_visio + 125);
        borderY:=(hud_inv_webs[i].posY_visio - 15);
      // ShowMessage('coord  '+IntToStr(borderX)+' : '+IntToStr(borderY));
        if( (posX >= borderX)and(posX < (borderX+30))and
          (posY >= borderY)and(posY < (borderY+30)) ) then begin
          // cursor in exact i cell
          Result:=i;
          Exit;
        end; // if in area
      end; // if visible
    end; // for all cells
  end; //with
end;

function getUnderMouseSpellCellIndex(posX,posY:Integer):TVector;
var
  i,j, borderX, borderY:Integer;
  v:TVector;
begin
  v[1]:=0;
  Result:=v;
  with Form1 do begin
    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        if(hud_inv_spells[i,j].spell_name <> '') then begin
          borderX:=(hud_inv_spells[i,j].posX - 25);
          borderY:=(hud_inv_spells[i,j].posY - 25);
        // ShowMessage('coord  '+IntToStr(borderX)+' : '+IntToStr(borderY));
          if( (posX >= borderX)and(posX < (borderX+50))and
            (posY >= borderY)and(posY < (borderY+50)) ) then begin
            // cursor in exact i cell
            v[1]:=1; // if 1 there is some cell
            v[2]:=i;
            v[3]:=j;
            Result:=v; //j
            Exit;
          end; // if in area
        end; // if visible
      end; // for i
    end; // for j
  end; //with
end;

procedure teleportMHtoWeb(idx:byte);
begin
  with Form1 do begin
    if not(WebInfo(MHWebs[idx].Behaviours.GetByClass(WebInfo)).isFree) then begin
      play_HerosAudioTrack(18,fMainMenu.global_game_volume_level,true,false);
      DCMainHero.Position.X:=round(MHWebs[idx].Position.X);
      DCMainHero.Position.Z:=round(MHWebs[idx].Position.Z);
    end; // if not
  end; // with form1
end;

procedure deleteMovableHUDSprite;
var
  c:Integer;
begin
  with Form1 do begin
    // da se izvika pri procedure processMovableItemOnTerrainDrop
    // sled terrObsFillCell(item_posX,item_posY,150,0);
    // Remove movable sprite
    for c:= (DCHUDTop.ComponentCount-1) downto 1 do begin
      if( (DCHUDTop.Children[c].Name='picked_movable_item_HUDSprite')or
          (DCHUDTop.Children[c].Name='picked_movable_item_HUDSprite_core') ) then begin
        DCHUDTop.Children[c].Free;
      end; // if
    end; // for
  end; // with
end;

procedure deleteMovableHUDSpriteByName(st_name1,st_name2:String);
var
  c:Integer;
begin
  with Form1 do begin
    // da se izvika pri procedure processMovableItemOnTerrainDrop
    // sled terrObsFillCell(item_posX,item_posY,150,0);
    // Remove movable sprite
    for c:= (DCHUDTop.ComponentCount-1) downto 1 do begin
      if( (DCHUDTop.Children[c].Name=trim(st_name1) )or
          (DCHUDTop.Children[c].Name=trim(st_name2) ) ) then begin
        DCHUDTop.Children[c].Free;
      end; // if
    end; // for
  end; // with
end;

procedure enemyDropItem(en:char; idx, X,Y:Integer);
var
  item_id:byte;
begin
  with Form1 do begin
    case en of
      'B': begin
        // alien
        if odd(X) then
          item_id:=150
        else
          item_id:=151;
        terrObsFillCell(X,Y,item_id,0);
        play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
        Exit;
      end; // b

      'G': begin
        // okta
        if odd(Y) then
          item_id:=150
        else
          item_id:=151;
        terrObsFillCell(X,Y,item_id,0);
        play_HerosAudioTrack(7,fMainMenu.global_game_volume_level,true,false);
        Exit;
      end; // g

    end; // case
  end; // with
end;

procedure setDropPointOnTerrain;
var
  posX, posY, i, j:Integer;
begin
  with Form1 do begin
    posX:=round(DCMainHero.Position.X);
    posY:=round(DCMainHero.Position.Z);
    // area A
    for j := (posY+5) to (posY+50) do begin
      for i := (posX-5) downto (posX-50) do begin
        if not checkCellAreaIsClear(i,j) then begin
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Exit;
        end; // if clear
      end; // for i
    end; // for j
    // area B
    for j := (posY+5) to (posY+50) do begin
      for i := (posX+5) to (posX+50) do begin
        if not checkCellAreaIsClear(i,j) then begin
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Exit;
        end; // if clear
      end; // for i
    end; // for j
    // area C
    for j := (posY-5) downto (posY-50) do begin
      for i := (posX-5) downto (posX-50) do begin
        if not checkCellAreaIsClear(i,j) then begin
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Exit;
        end; // if clear
      end; // for i
    end; // for j
    // area D
    for j := (posY-5) downto (posY-50) do begin
      for i := (posX-5) to (posX+50) do begin
        if not checkCellAreaIsClear(i,j) then begin
          pick_move_itemX:=i;
          pick_move_itemY:=j;
          Exit;
        end; // if clear
      end; // for i
    end; // for j
  end; // with
end;

procedure processMovableItemFromCarrierOnTerrainDrop(X,Y:Integer);
var
  cell_id, cell_content:byte;
begin
  with Form1 do begin
  // get carrir cell index
  cell_id:=getUnderMouseCarrierCellIndex(X,Y);
    if (cell_id <> 0) then begin
      cell_content:=getUnderMouseCarrierCellContent(cell_id);
      if (cell_content <> 0) then begin
        // resolve cell content
        case cell_content of
          150: begin
            // if life cell --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTLife(X,Y);
            pick_move_item_ID:=150;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            update_hud_top_view;
            //----------------------------
          end; // case 150
          151: begin
            // if mana cell --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTMana(X,Y);
            pick_move_item_ID:=151;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            update_hud_top_view;
            //----------------------------
          end; // case 151

          160: begin
            // if armor A  --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTArmorA(X,Y);
            pick_move_item_ID:=160;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            //----------------------------
          end; // case 160

          180: begin
            // if weapon A  --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTWeaponA(X,Y);
            pick_move_item_ID:=180;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            //----------------------------
          end; // case 180

          190: begin
            // if power spx cell --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTPowerSpx(X,Y);
            pick_move_item_ID:=190;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_carrier[cell_id].hud_item_pic.name,
            hud_inv_carrier[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_carrier[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            //----------------------------
          end; // case 190

        end; // case
      end; // if cell content
    end; // if cell
  end; // with
end;

procedure processMovableItemFromWearOnTerrainDrop(X,Y:Integer);
var
  cell_id, cell_content:byte;
begin
  with Form1 do begin
  // get wear cell index
  cell_id:=getUnderMouseWearCellIndex(X,Y);
    if (cell_id <> 0) then begin
      cell_content:=getUnderMouseWearCellContent(cell_id);
      if (cell_content <> 0) then begin
        // resolve cell content
        case cell_content of
          150: begin
            // if life cell --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTLife(X,Y);
            pick_move_item_ID:=150;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_wearable[cell_id].hud_item_pic.name,
            hud_inv_wearable[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_wearable[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            //----------------------------
          end; // case 150
          151: begin
            // if mana cell --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTMana(X,Y);
            pick_move_item_ID:=151;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_wearable[cell_id].hud_item_pic.name,
            hud_inv_wearable[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_wearable[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
            //----------------------------
          end; // case 151

          160: begin
            // if Armor A --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTArmorA(X,Y);
            pick_move_item_ID:=160;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_wearable[cell_id].hud_item_pic.name,
            hud_inv_wearable[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_wearable[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
              update_wear_items_properties(false,4,160,getItemBonus(160));
            //----------------------------
          end; // case 160

          180: begin
            // if weapon A --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTWeaponA(X,Y);
            pick_move_item_ID:=180;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_wearable[cell_id].hud_item_pic.name,
            hud_inv_wearable[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_wearable[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
              update_wear_items_properties(false,1,180,getItemBonus(180));
            //----------------------------
          end; // case 180

          190: begin
            // if power spx cell --------------
            play_HerosAudioTrack(6,fMainMenu.global_game_volume_level,true,false);
            // add RT Sprite
            AddHudSpriteRTPowerSpx(X,Y);
            pick_move_item_ID:=190;
            // remove sprite
            deleteMovableHUDSpriteByName(hud_inv_wearable[cell_id].hud_item_pic.name,
            hud_inv_wearable[cell_id].hud_item_pic_core.name);
            // empty cell id
            hud_inv_wearable[cell_id].itemID:=0;
            // we must drop it so movable_item_drop_needed:=true
            movable_item_drop_needed:=true;
              update_wear_items_properties(false,1,190,getItemBonus(190));
            //----------------------------
          end; // case 190

        end; // case
      end; // if cell content
    end; // if cell
  end;
end;

procedure setInitialCameraPosition;
begin
  with Form1 do begin
    GLCamera1.Position.X:=11; // 6 - 11
    GLCamera1.Position.Y:=47; //40 - 47
    GLCamera1.Position.Z:=-16; // -11 - -16
  end; // form1
end;

procedure initEnemyInfoBase;
begin
  with Form1,fMainMenu do begin
  //enemA=1; { ishta-pan spider dalak } {4} {total enemies should not exceed 6 }
  //enemB=1; { algo-pan alien} {2}
  //enemC=1; { budago-pan bug} {2}
  //enemD=1; { insaka-pan insect} {2}
  //enemE=1; { fago-pan frog} {2}
  //enemF=1; { drio-pan drio} {2}
  //enemG=1; { okta-pan okta} {2}

  // spider
  EABaseLife:=60;
  EABaseAttack:=10;
  // alien
  EBBaseLife:=90;
  EBBaseAttack:=15;
  // bug
  ECBaseLife:=40;
  ECBaseAttack:=5;
  // insect
  EDBaseLife:=50;
  EDBaseAttack:=5;
  // frog
  EEBaseLife:=70;
  EEBaseAttack:=10;
  // drio
  EFBaseLife:=80;
  EFBaseAttack:=15;
  // okta
  EGBaseLife:=100;
  EGBaseAttack:=20;
  end;
end;

function initEnemyInfoLife(e_type:String):Smallint;
begin
  // uses AddEnemyTypeA spec.Life
  // uses viewStartChild enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).Life:=50;
  // uses viewChild enemyInfo(enemiesTypeA[e].Behaviours.GetByClass(enemyInfo)).Life:=50;
  // BaseLife / BaseAttack
  //Life*current_level;
  //Attack*current_level;
  with Form1,fMainMenu do begin
  if(e_type='EA') then begin
    Result:=(EABaseLife*current_level);
    Exit;
  end;

  if(e_type='EB') then begin
    Result:=(EBBaseLife*current_level);
    Exit;
  end;

  if(e_type='EC') then begin
    Result:=(ECBaseLife*current_level);
    Exit;
  end;

  if(e_type='ED') then begin
    Result:=(EDBaseLife*current_level);
    Exit;
  end;

  if(e_type='EE') then begin
    Result:=(EEBaseLife*current_level);
    Exit;
  end;

  if(e_type='EF') then begin
    Result:=(EFBaseLife*current_level);
    Exit;
  end;

  if(e_type='EG') then begin
    Result:=(EGBaseLife*current_level);
    Exit;
  end;

  end; // with
end;

procedure initMHInfoBase(gained_exp:Integer);
var
  MH_Base_Life, MH_Base_Mana, MH_Base_Attack :Smallint;
  MHspec:MHInfo;
  MH_curr_lev:byte;  //MH_current_level:byte;
begin
  // shrinite da fillvat ako Life < BaseLife
  with Form1,fMainMenu do begin
  // check if there is any gained exp >10
  if (gained_exp > 10) then
    MH_exp:=gained_exp
  else
    MH_exp:=1;

  if (MH_current_level > 1) then
    MH_curr_lev:=MH_current_level
  else
    MH_curr_lev:=1;
  // MHBaseAttack:=(MHBaseAttack + round(MHExp / 100000));
  // MHBaseLife:=((MHBaseLife*current_level) + round(MHExp / 10000));
  // MHBaseLife is the max life

  // spells
  BaseLightningCost:=10;
  BaseChainLightningCost:=10;
  BaseNovaCost:=10;
  BaseBuildWebCost:=10;
  BaseDestroyWebCost:=10;
  
  // life 200  attack 20
  MH_Base_Life:=((600*current_level) + round(MH_exp / 10000));
  MH_Base_Mana:=((600*current_level) + round(MH_exp / 10000));
  MH_Base_Attack:=((20*current_level) + round(MH_exp / 100000));


    MHspec:=MHInfo.Create(Actor1.Behaviours);
    MHspec.isAlive:=true;
    // base     
    MHspec.MHBaseLife:=MH_Base_Life;
    MHspec.MHBaseMana:=MH_Base_Mana; // 30000
    MHspec.MHBaseAttack:=MH_Base_Attack;
    // current
    MHspec.Life:=MH_Base_Life;
    MHspec.Mana:=MH_Base_Mana;
    MHspec.Attack:=MH_Base_Attack;
    MHspec.MHBaseDefence:=0;
    MHspec.MHExp:=MH_exp;
      MHspec.MH_current_level:=MH_curr_lev;//MH_current_level;
    Actor1.Behaviours.Add(MHspec);
  end; // with
end;

procedure calcMHExperience(E_base_life:Smallint);
begin
  // Calc Experience
  // da se izvika v death EA-G
  // MHexp init :=1 in init&load

  with Form1,fMainMenu do begin

    // calc exp
    MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHExp:=
    round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHExp+(E_base_life-(  (current_level*10)*(E_base_life / 100)  )));
    // update gained_exp
    MH_exp:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHExp;

    // calc attack
    MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack:=
    round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack+round(MH_exp / 100000) );

    // calc life
    MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife:=
    round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife+round(MH_exp / 10000) );

    // calc mana
    MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana:=
    round(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana+round(MH_exp / 10000) );

    // change the step
    MH_LifeMana_step:=(228 / MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);
  end;

  calcMHLevel;
end;

procedure calcMHLevel;
var
  MH_exp_loc:Integer;
  MH_current_level_loc:byte;
begin
  // base k step MH_base_exp_step:=5000; Integer *2 on each level
  // MH_level_up_points:=0; byte
  // da se dobavi MH_current_level:=1; v initMHInfoBase
  with Form1,fMainMenu do begin
    // get exp
    MH_exp_loc:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHExp;
    MH_current_level_loc:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MH_current_level;
    //
    if(MH_exp_loc >= MH_base_exp_step)and(MH_current_level_loc=1) then begin
      // first level up
      MH_base_exp_step:=(MH_base_exp_step*2);
      MH_level_up_points:=1;
      // show panel
      showHudLevelUp;
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MH_current_level:=2;
      // show level up panel
    end; // if

    if(MH_exp_loc >= MH_base_exp_step)and(MH_current_level_loc > 1) then begin
      // level up
      MH_base_exp_step:=(MH_base_exp_step*2);
      inc(MH_level_up_points);
      // show panel
      showHudLevelUp;
      inc(MH_current_level);
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MH_current_level:=MH_current_level;
      // show level up panel
    end; // if

  end; // with
end;

procedure update_hud_hero_values;
begin
  with Form1, fMainMenu do begin
    hud_hero_text_exp.Text:='EXPERIENCE ' +
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHExp);

    hud_hero_text_def.Text:='DEFENCE  ' +
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseDefence);

    hud_hero_text_att.Text:='ATTACK   ' +
      //IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Attack)+':'+
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack);

    hud_hero_text_mana.Text:='MANA     ' +
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana)+':'+
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana);

    hud_hero_text_life.Text:='LIFE     ' +
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life)+':'+
      IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);

    hud_hero_text_spell.Text:='SPELL ' +
      getMHfriendlySpellName(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).attackWeapon);

    hud_hero_text_level.Text:='MAP LEVEL  ' + IntToStr(current_level);

    hud_hero_text_lev.Text:='HERO LEVEL ' + IntToStr(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MH_current_level);


  end; // with
end;

procedure update_hud_hero_spells;
var
  i,j:byte;
begin
  with Form1 do begin
    // spell upgrade
    hud_hero_text_points.Text:='UPGRADE POINTS  ' + IntToStr(MH_level_up_points);
    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        if (hud_inv_spells[i,j].spell_name = '') then Continue;

          if (hud_inv_spells[i,j].upgraded) then begin
            // show down dis pic
            hud_inv_spells[i,j].hud_spell_pic_down_disabled.Visible:=true;
            Continue;
          end;

          if (MH_level_up_points = 0) then begin
            // show up dis pic
            hud_inv_spells[i,j].hud_spell_pic_up_disabled.Visible:=true;
            Continue;
          end;
          hud_inv_spells[i,j].hud_spell_pic_up_disabled.Visible:=false;
          hud_inv_spells[i,j].hud_spell_pic_up.Visible:=true;
      end; // for i
    end; // for j
  end; // with form1
end;

procedure update_hud_inv_webs;
var
  i,web_id :byte;
begin
  with Form1 do begin
    for i:= 1 to 8 do begin
      if (MHWebCount >= 1)and(MHWebCount <= 8) then begin
        if not(WebInfo(MHWebs[i].Behaviours.GetByClass(WebInfo)).isFree) then begin
          web_id:=getUnderMHWeb(round(DCMainHero.Position.X), round(DCMainHero.Position.Z));
          if (web_id <> 0) then begin// no web
            with hud_inv_webs[i].hud_webs_pic_up do begin
              if (web_id <> i) then begin
                hud_inv_webs[i].hud_webs_pic_disabled.Visible:=false;
                Visible:=true;
              end; // if <>
            end;

            with hud_inv_webs[i].hud_webs_pic_disabled do begin
              if (web_id = i) then
                Visible:=true;
            end;

          end // if <>0
          else
          begin
            // there is no web under
            with hud_inv_webs[i].hud_webs_pic_disabled do begin
              Visible:=true;
            end;
          end;// disable all
        end; // if not free
      end; //if in [1..8]
    end; // for all

  end; // with form1
end;

procedure update_hud_top_view;
var
  i:byte;
  life_cell,mana_cell:boolean;
begin
  with Form1 do begin
    life_cell:=false;
    mana_cell:=false;
    for i:= 1 to 12 do begin
      if(hud_inv_carrier[i].itemID = 150) then begin
        // there is life cell
        life_cell:=true;
        if not(hud_top_life_view_base.hud_item_pic_core.Visible) then begin
          hud_top_life_view_base.hud_item_pic_core.Visible:=true;
          hud_top_life_view_base.hud_item_pic.Visible:=true;
        end; // if not visible
      end; // if life cell

      if(hud_inv_carrier[i].itemID = 151) then begin
        // there is mana cell
        mana_cell:=true;
        if not(hud_top_mana_view_base.hud_item_pic_core.Visible) then begin
          hud_top_mana_view_base.hud_item_pic_core.Visible:=true;
          hud_top_mana_view_base.hud_item_pic.Visible:=true;
        end; // if not visible
      end; // if life cell

    end; // for
    // check empty
    if not(life_cell) then begin
      if (hud_top_life_view_base.hud_item_pic_core.Visible) then begin
        hud_top_life_view_base.hud_item_pic_core.Visible:=false;
        hud_top_life_view_base.hud_item_pic.Visible:=false;
      end; // if not visible
    end;

    if not(mana_cell) then begin
      if (hud_top_mana_view_base.hud_item_pic_core.Visible) then begin
        hud_top_mana_view_base.hud_item_pic_core.Visible:=false;
        hud_top_mana_view_base.hud_item_pic.Visible:=false;
      end; // if not visible
    end;
  end; // with Form1
end;

procedure update_wear_items_properties(toAdd:boolean;cell_idx,item_idx,wear_type:byte);
begin
  with Form1 do begin
    if(toAdd) then begin
      if (cell_idx = 4) then begin
        // item is armor so get armor props
        case item_idx of
          160: begin
            // Armor A
            changeAllEnemiesBaseAttackOnClick(false,wear_type);
            
          end; // 160

        end; // case
      end; // if = 4 armor

      if (cell_idx <> 4) then begin
        // item is weapon so get weapon props
        case item_idx of
          180: begin
            // weapon A
            changeMHBaseAttackOnClick(true,wear_type);

          end; // 180
          190: begin
            // PowerSpx
            changeMHBaseLifeOnClick(true,wear_type);
            changeMHBaseManaOnClick(true,wear_type)
          end; // 190
        end; // case  
      end; // if <> 4 weapon
    end
    else
    begin
      // remove item
      if (cell_idx = 4) then begin
        // item is armor so get armor props
        case item_idx of
          160: begin
            // Armor A
            changeAllEnemiesBaseAttackOnClick(true,wear_type);

          end; // 160

        end; // case
      end; // if = 4 armor

      if (cell_idx <> 4) then begin
        // item is armor so get armor props
        case item_idx of
          180: begin
            // Weapon A
            changeMHBaseAttackOnClick(false,wear_type);

          end; // 180
          190: begin
            // PowerSpx
            changeMHBaseLifeOnClick(false,wear_type);
            changeMHBaseManaOnClick(false,wear_type);
          end; // 190
        end; // case
      end; // if <> 4 weapon
      //------------
    end; // else
  end; // with Form1
end;

procedure changeAllEnemiesBaseAttackOnClick(asc:boolean; wear_type:byte);
begin
  with Form1, fMainMenu do begin
    {
    if (wear_type > 0) then begin

      if(asc) then begin
        // increase
        EABaseAttack:=round( EABaseAttack +((100 -(100 - wear_type)) / wear_type) );
        EBBaseAttack:=round( EBBaseAttack +((100 -(100 - wear_type)) / wear_type) );
        ECBaseAttack:=round( ECBaseAttack +((100 -(100 - wear_type)) / wear_type) );
        EDBaseAttack:=round( EDBaseAttack +((100 -(100 - wear_type)) / wear_type) );
        EEBaseAttack:=round( EEBaseAttack +((100 -(100 - wear_type)) / wear_type) );
        EFBaseAttack:=round( EFBaseAttack +((100 -(100 - wear_type)) / wear_type) );
        EGBaseAttack:=round( EGBaseAttack +((100 -(100 - wear_type)) / wear_type) );
        changeMHBaseDefence(false, wear_type);
      end // if asc
      else
      begin
        // decrease
        EABaseAttack:=round( EABaseAttack -((EABaseAttack*wear_type) / 100) );
        EBBaseAttack:=round( EBBaseAttack -((EBBaseAttack*wear_type) / 100) );
        ECBaseAttack:=round( ECBaseAttack -((ECBaseAttack*wear_type) / 100) );
        EDBaseAttack:=round( EDBaseAttack -((EDBaseAttack*wear_type) / 100) );
        EEBaseAttack:=round( EEBaseAttack -((EEBaseAttack*wear_type) / 100) );
        EFBaseAttack:=round( EFBaseAttack -((EFBaseAttack*wear_type) / 100) );
        EGBaseAttack:=round( EGBaseAttack -((EGBaseAttack*wear_type) / 100) );
        changeMHBaseDefence(true, wear_type);
      end; // else
    end; // if <>0
    }
    if (wear_type > 0) then begin

      if(asc) then begin
        // increase
        EABaseAttack:=round( EABaseAttack + wear_type);
        EBBaseAttack:=round( EBBaseAttack + wear_type);
        ECBaseAttack:=round( ECBaseAttack + wear_type);
        EDBaseAttack:=round( EDBaseAttack + wear_type);
        EEBaseAttack:=round( EEBaseAttack + wear_type);
        EFBaseAttack:=round( EFBaseAttack + wear_type);
        EGBaseAttack:=round( EGBaseAttack + wear_type);
        changeMHBaseDefence(false, wear_type);
      end // if asc
      else
      begin
        // decrease
        EABaseAttack:=round( EABaseAttack - wear_type);
        EBBaseAttack:=round( EBBaseAttack - wear_type);
        ECBaseAttack:=round( ECBaseAttack - wear_type);
        EDBaseAttack:=round( EDBaseAttack - wear_type);
        EEBaseAttack:=round( EEBaseAttack - wear_type);
        EFBaseAttack:=round( EFBaseAttack - wear_type);
        EGBaseAttack:=round( EGBaseAttack - wear_type);
        changeMHBaseDefence(true, wear_type);
      end; // else
    end; // if <>0
  end; // with Form1
end;

procedure changeMHBaseAttackOnClick(asc:boolean; wear_type:byte);
var
  MH_BaseAttack:Smallint;
begin
  with Form1 do begin
    {
    if (wear_type > 0) then begin
    // get MH base attack
    MH_BaseAttack:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack;
    if(asc) then begin
      // increase
      MH_BaseAttack:=round(MH_BaseAttack +((MH_BaseAttack*wear_type) div 100) );
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack:=MH_BaseAttack;

    end // if asc
    else
    begin
      // decrease
      MH_BaseAttack:=round(MH_BaseAttack - ((MH_BaseAttack*wear_type) div 100) );
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack:=MH_BaseAttack;//(MH_BaseAttack-base_attack_diff);
    end; // else
    end; // if <>0
    }
    if (wear_type > 0) then begin
    // get MH base attack
    MH_BaseAttack:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack;
    if(asc) then begin
      // increase
      MH_BaseAttack:=round(MH_BaseAttack + wear_type);
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack:=MH_BaseAttack;

    end // if asc
    else
    begin
      // decrease
      MH_BaseAttack:=round(MH_BaseAttack - wear_type);
      MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseAttack:=MH_BaseAttack;//(MH_BaseAttack-base_attack_diff);
    end; // else
    end; // if <>0
  end; // with Form1
end;

procedure changeMHBaseLifeOnClick(asc:boolean; wear_type:byte);
var
  MH_BaseLife:Smallint;
begin
  with Form1 do begin
    if (wear_type > 0) then begin
      // get MH base life
      MH_BaseLife:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife;
      if(asc) then begin
        // increase
        MH_BaseLife:=round(MH_BaseLife + wear_type);
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife:=MH_BaseLife;

      end // if asc
      else
      begin
        // decrease
        MH_BaseLife:=round(MH_BaseLife - wear_type);
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife:=MH_BaseLife;//(MH_BaseAttack-base_attack_diff);
      end; // else
      // update step
      MH_LifeMana_step:=(228 / MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);
    end; // if <>0
  end; // with Form1
end;

procedure changeMHBaseManaOnClick(asc:boolean; wear_type:byte);
var
  MH_BaseMana:Smallint;
begin
  with Form1 do begin
    if (wear_type > 0) then begin
      // get MH base mana
      MH_BaseMana:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana;
      if(asc) then begin
        // increase
        MH_BaseMana:=round(MH_BaseMana + wear_type);
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana:=MH_BaseMana;

      end // if asc
      else
      begin
        // decrease
        MH_BaseMana:=round(MH_BaseMana - wear_type);
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana:=MH_BaseMana;//(MH_BaseAttack-base_attack_diff);
      end; // else
      // update step
      MH_LifeMana_step:=(228 / MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);
    end; // if <>0
  end; // with Form1
end;

procedure changeMHBaseDefence(asc:boolean; quant:byte);
var
  base_def:byte;
begin
  with Form1, fMainMenu do begin
    if (quant > 0) then begin

      if(asc) then begin
        // increase
        inc(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseDefence, quant);
      end // if asc
      else
      begin
        // decrease
        base_def:=MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseDefence;
        if((base_def - quant) <= 0) then begin
          // negative diff so set zero
          MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseDefence:=0;
        end
        else
        begin
          dec(base_def,quant);
          MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseDefence:=base_def;
        end;
      end; // else
    end; // if <>0
  end; // with Form1
end;

procedure MHdrinkCell(idx:byte);
var
  life_to_add,life_diff, mh_life, max_life,
  mana_to_add,mana_diff, mh_mana, max_mana:Smallint;
begin
  with Form1,fMainMenu do begin
    case idx of
      150: begin
        play_HerosAudioTrack(17,fMainMenu.global_game_volume_level,true,false);
        mh_life:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life);
        max_life:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);
        life_to_add:=(max_life div 2);
        life_diff:=(max_life - mh_life);
        if (life_diff > life_to_add) then begin
          MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(mh_life + life_to_add);
        end
        else
        begin
          MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=max_life;
        end; // if diff
      end;  // life

      151: begin
        play_HerosAudioTrack(17,fMainMenu.global_game_volume_level,true,false);
        mh_mana:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
        max_mana:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana);
        mana_to_add:=(max_mana div 2);
        mana_diff:=(max_mana - mh_mana);
        if (mana_diff > mana_to_add) then begin
          MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(mh_mana + mana_to_add);
        end
        else
        begin
          MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=max_mana;
        end; // if diff
      end;  // life
    end; // case
  end; // with form1
end;

procedure MHShrinesFill;
var
  mh_life, max_life,
  mh_mana, max_mana:Smallint;
begin
  with Form1,fMainMenu do begin
    if(allow_MH_full_fill) then begin
      mh_life:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life);
      max_life:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);

      mh_mana:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      max_mana:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana);
      // fill some life
      if( (mh_life + (10*current_level) ) < max_life) then begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(mh_life + (10*current_level));
      end
      else
      begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=max_life;
      end;

      // fill some mana
      if( (mh_mana + (10*current_level) ) < max_mana) then begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(mh_mana + (10*current_level));
      end
      else
      begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=max_mana;
      end;
      Exit;
    end; // life and mana

    if(allow_MH_life_fill) then begin
      mh_life:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life);
      max_life:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseLife);

      // fill some life
      if( (mh_life + (10*current_level) ) < max_life) then begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=(mh_life + (10*current_level));
      end
      else
      begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Life:=max_life;
      end;
      Exit;
    end; // life fill

    if(allow_MH_mana_fill) then begin
      mh_mana:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana);
      max_mana:=(MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).MHBaseMana);

      // fill some mana
      if( (mh_mana + (10*current_level) ) < max_mana) then begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=(mh_mana + (10*current_level));
      end
      else
      begin
        MHInfo(Actor1.Behaviours.GetByClass(MHInfo)).Mana:=max_mana;
      end;
      Exit;
    end; // mana fill

  end; // with form1
end;

procedure invokeInventoryWindow(closing:boolean);
begin
  with Form1 do begin
       if (hud_inv_base_state=1)and(closing) then begin
          hud_inv_base_state:=0;
           hideHudInvCarrier;
           hideHudInvOrnaments;
         hud_inv.Visible:=false;
       end
       else
       begin
         if (hud_inv_base_state=2) then begin
           // close webs first
           hud_inv_base_state:=1;
            hideHudInvWebs;
            hud_inv.Position.Y:=344;
            showHudInvCarrier;
            //hideHudInvOrnaments;
            //hud_inv.Visible:=false;
         end
         else
         begin
         hud_inv_base_state:=1;
         hud_inv.Position.Y:=344;
           showHudInvOrnaments;
           showHudInvCarrier;
         hud_inv.Visible:=true;
         end;
       end;
  end; // with Form1
end;

procedure invokeWebsWindow(closing:boolean);
begin
  with Form1 do begin
    if (hud_inv_base_state=2)and(closing) then begin
         hud_inv_base_state:=0;
           hideHudInvWebs;
           hideHudInvOrnaments;
         hud_inv.Visible:=false;
       end
       else
       begin
         if (hud_inv_base_state=1) then begin
           // close inventory first
           hud_inv_base_state:=2;
            hideHudInvCarrier;
            //hideHudInvOrnaments;
            //hud_inv.Visible:=false;
            hud_inv.Position.Y:=344;
            //showHudInvOrnaments;
           showHudInvWebs;
         end
         else
         begin
           hud_inv_base_state:=2;
           hud_inv.Position.Y:=344;
           showHudInvOrnaments;
           showHudInvWebs;
           hud_inv.Visible:=true;
         end;
       end;
  end; // with form1
end;

procedure invokeHeroWindow(closing:boolean);
begin
  with Form1 do begin
    if (hud_hero_base_state=1)and(closing) then begin
      hud_hero_base_state:=0;
      hideHudHeroLabels;
      hideHudHeroOrnaments;
      hud_hero.Visible:=false;
    end
    else
    begin
      if (hud_hero_base_state=2) then begin
        // close webs first
        hud_hero_base_state:=1;
        hideHudInvSpells;
        hud_hero.Position.Y:=344;
        showHudHeroLabels;
        //hideHudInvOrnaments;
        //hud_inv.Visible:=false;
      end
      else
      begin
        hud_hero_base_state:=1;
        hud_hero.Position.Y:=344;
        showHudHeroOrnaments;
        //showHudInvSpells;
        showHudHeroLabels;
        hud_hero.Visible:=true;
      end;
    end;
  end; // with Form1
end;

procedure invokeSpellsWindow(closing:boolean);
begin
  with Form1 do begin
    if (hud_hero_base_state=2)and(closing) then begin
      hud_hero_base_state:=0;
      hideHudInvSpells;
      hideHudHeroOrnaments;
      hud_hero.Visible:=false;
    end
    else
    begin
      if (hud_hero_base_state=1) then begin
        // close inventory first
        hud_hero_base_state:=2;
        hideHudHeroLabels;
        //hideHudInvOrnaments;
        //hud_inv.Visible:=false;
        hud_hero.Position.Y:=344;
        //showHudInvOrnaments;
        showHudInvSpells;
      end
      else
      begin
        hud_hero_base_state:=2;
        hud_hero.Position.Y:=344;
        showHudHeroOrnaments;
        //showHudHeroLabels;
        showHudInvSpells;
        hud_hero.Visible:=true;
      end;
    end;
  end; // with form1
end;

procedure parseUserTyped(var Key: Word);
begin
  with Form1 do begin
    //------------
    if(user_typed_msg='SHOW FPS') then begin
      HUDTextFPS.Visible:=true;
    end;

    if(Form1.user_typed_msg='HIDE FPS') then begin
      HUDTextFPS.Visible:=false;
    end;

    //------------
    if(user_typed_msg='GO TO PORTAL') then begin
      DCMainHero.Position.X:=portal_X+6;
      DCMainHero.Position.Z:=portal_Y+6;
    end;

    if(Form1.user_typed_msg='GO TO SPHERE') then begin
      DCMainHero.Position.X:=power_spx_X+6;
      DCMainHero.Position.Z:=power_spx_Y+6;
    end;

    if(Form1.user_typed_msg='GIVE ME POINTS') then begin
      MH_level_up_points:=4;
    end;
    // clear it
    user_typed_msg:='';
  end; // with
end;

function getMainTextureNameForLevel(curr_lev:byte):String;
begin
  case curr_lev of
    1:begin
      Result:='TextureMap.jpg';
      Exit;
    end; // 1
    2:begin
      Result:='TextureMap2.jpg';
      Exit;
    end; // 2
    3:begin
      Result:='TextureMap3.jpg';
      Exit;
    end; // 3
    4:begin
      Result:='TextureMap.jpg';
      Exit;
    end; // 4
    5:begin
      Result:='TextureMap.jpg';
      Exit;
    end; // 5
    6:begin
      Result:='TextureMap.jpg';
      Exit;
    end; // 6

  end; // case
end;

function getBumpTextureNameForLevel(curr_lev:byte):String;
begin
  case curr_lev of
    1:begin
      Result:='clover.jpg';
      Exit;
    end; // 1
    2:begin
      Result:='clover.jpg';
      Exit;
    end; // 2
    3:begin
      Result:='clover.jpg';
      Exit;
    end; // 3
    4:begin
      Result:='clover.jpg';
      Exit;
    end; // 4
    5:begin
      Result:='clover.jpg';
      Exit;
    end; // 5
    6:begin
      Result:='clover.jpg';
      Exit;
    end; // 6

  end; // case
end;

function getMainSelfNameForLevel(curr_lev:byte):String;
begin
  case curr_lev of
    1:begin
      Result:='self_01.bmp';
      Exit;
    end; // 1
    2:begin
      Result:='self_02.bmp';
      Exit;
    end; // 2
    3:begin
      Result:='self_03.bmp';
      Exit;
    end; // 3
    4:begin
      Result:='self_01.bmp';
      Exit;
    end; // 4
    5:begin
      Result:='self_01.bmp';
      Exit;
    end; // 5
    6:begin
      Result:='self_01.bmp';
      Exit;
    end; // 6

  end; // case
end;

procedure buff_MH_Inventory;
var
  i,j:byte;
begin
  with Form1 do begin
    ///
    fMainMenu.buff_MH_level_up_points:=MH_level_up_points;
    ///
    for i:=1 to 12 do begin
      fMainMenu.buff_hud_inv_carrier[i]:=hud_inv_carrier[i].itemID;
      if i in [1..7] then
        fMainMenu.buff_hud_inv_wearable[i]:=hud_inv_wearable[i].itemID;
      if i in [1..5] then
        //fMainMenu.buff_hud_menu_spells[i]:=hud_menu_spells[i].
    end; // for
    ///
    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        if (hud_inv_spells[i,j].spell_name <> '') then begin
          fMainMenu.buff_hud_inv_spells[i,j]:= hud_inv_spells[i,j].upgraded;
        end; // if
      end; // i
    end; //j
    ///    
  end; // with
end;

procedure restore_MH_Inventory_from_buff;
var
  i,j:byte;
  item_posX,item_posY:Integer;
begin
  with Form1 do begin
    ///
    MH_level_up_points:=fMainMenu.buff_MH_level_up_points;
    ///
    for i:=1 to 12 do begin
      // get position
      item_posX:=round(hud_inv_carrier[i].posX)+25;
      item_posY:=round(hud_inv_carrier[i].PosY)+25;
      // add item picture
      if (fMainMenu.buff_hud_inv_carrier[i] <> 0) then begin
        AddHudCarrierRTItem(i, item_posX, item_posY,fMainMenu.buff_hud_inv_carrier[i]);
        // set item id
        hud_inv_carrier[i].itemID:=fMainMenu.buff_hud_inv_carrier[i];
        // hide items
        hud_inv_carrier[i].hud_item_pic_core.Visible:=false;
        hud_inv_carrier[i].hud_item_pic.Visible:=false;
        // update_
      end;
      // wearable
      if i in [1..7] then begin
        // get position
        item_posX:=round(hud_inv_wearable[i].posX)+25;
        item_posY:=round(hud_inv_wearable[i].PosY)+25;
        if (fMainMenu.buff_hud_inv_wearable[i] <> 0) then begin
          AddHudWearRTItem(i, item_posX, item_posY,fMainMenu.buff_hud_inv_wearable[i]);
          // set item id
          hud_inv_wearable[i].itemID:=fMainMenu.buff_hud_inv_wearable[i];
          // hide items
          hud_inv_wearable[i].hud_item_pic_core.Visible:=false;
          hud_inv_wearable[i].hud_item_pic.Visible:=false;
          update_wear_items_properties(true,i,hud_inv_wearable[i].itemID,getItemBonus(hud_inv_wearable[i].itemID));
        end;
      end; // if wear
    end; // for

    ///
    for j:= 1 to 4 do begin
      for i:= 1 to 5 do begin
        if (hud_inv_spells[i,j].spell_name <> '') then begin
          hud_inv_spells[i,j].upgraded:=fMainMenu.buff_hud_inv_spells[i,j];
        end; // if
      end; // i
    end; //j
    ///
    swapSpellWithFirst(fMainMenu.buff_last_spell_id);
    hud_menu_spells[1].hud_spell_pic_up.Visible:=true;
  end; // with
  update_hud_top_view;
end;

procedure loadLevelFromMaps(idx:byte);
var
  i:Integer;
begin
  // portal
  // spx
  terrObsFillCell(Form1.power_spx_X,Form1.power_spx_Y,190,0);
  // shrines ------------------
  for i:=1 to 8 do begin
    terrObsFillCell(fMainMenu.M_shrines_A[i].posX,fMainMenu.M_shrines_A[i].posY,
                    fMainMenu.M_shrines_A[i].itemId,fMainMenu.M_shrines_A[i].itemRotation);

    Form1.shrinesA[i].Xcoord:=fMainMenu.M_shrines_A[i].posX;
    Form1.shrinesA[i].Ycoord:=fMainMenu.M_shrines_A[i].posY;

    if ((i >= 1)and(i <=4)) then begin
      // B
      terrObsFillCell(fMainMenu.M_shrines_B[i].posX,fMainMenu.M_shrines_B[i].posY,
                    fMainMenu.M_shrines_B[i].itemId,fMainMenu.M_shrines_B[i].itemRotation);

      Form1.shrinesB[i].Xcoord:=fMainMenu.M_shrines_B[i].posX;
      Form1.shrinesB[i].Ycoord:=fMainMenu.M_shrines_B[i].posY;
      // C
      terrObsFillCell(fMainMenu.M_shrines_C[i].posX,fMainMenu.M_shrines_C[i].posY,
                    fMainMenu.M_shrines_C[i].itemId,fMainMenu.M_shrines_C[i].itemRotation);

      Form1.shrinesC[i].Xcoord:=fMainMenu.M_shrines_C[i].posX;
      Form1.shrinesC[i].Ycoord:=fMainMenu.M_shrines_C[i].posY;
    end; // in 4
  end; // for shrines
  //---------------------------

  // plants -------------------
  for i:=1 to 2000 do begin
    terrObsFillCell(fMainMenu.M_plants_D[i].posX,fMainMenu.M_plants_D[i].posY,
                    fMainMenu.M_plants_D[i].itemId,fMainMenu.M_plants_D[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_E[i].posX,fMainMenu.M_plants_E[i].posY,
                    fMainMenu.M_plants_E[i].itemId,fMainMenu.M_plants_E[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_F[i].posX,fMainMenu.M_plants_F[i].posY,
                    fMainMenu.M_plants_F[i].itemId,fMainMenu.M_plants_F[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_G[i].posX,fMainMenu.M_plants_G[i].posY,
                    fMainMenu.M_plants_G[i].itemId,fMainMenu.M_plants_G[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_H[i].posX,fMainMenu.M_plants_H[i].posY,
                    fMainMenu.M_plants_H[i].itemId,fMainMenu.M_plants_H[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_I[i].posX,fMainMenu.M_plants_I[i].posY,
                    fMainMenu.M_plants_I[i].itemId,fMainMenu.M_plants_I[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_J[i].posX,fMainMenu.M_plants_J[i].posY,
                    fMainMenu.M_plants_J[i].itemId,fMainMenu.M_plants_J[i].itemRotation);

    terrObsFillCell(fMainMenu.M_plants_K[i].posX,fMainMenu.M_plants_K[i].posY,
                    fMainMenu.M_plants_K[i].itemId,fMainMenu.M_plants_K[i].itemRotation);
  end; // for plants
  SetPlantsF_prop;
  SetPlantsG_prop;
  SetPlantsJ_prop;
  //---------------------------

  // movables -----------------
  for i:=1 to 1000 do begin
    terrObsFillCell(fMainMenu.M_life_cells[i].posX,fMainMenu.M_life_cells[i].posY,
                    fMainMenu.M_life_cells[i].itemId,fMainMenu.M_life_cells[i].itemRotation);

    terrObsFillCell(fMainMenu.M_mana_cells[i].posX,fMainMenu.M_mana_cells[i].posY,
                    fMainMenu.M_mana_cells[i].itemId,fMainMenu.M_mana_cells[i].itemRotation);

    if ((i >= 1)and(i <=500)) then begin
      terrObsFillCell(fMainMenu.M_armor_A[i].posX,fMainMenu.M_armor_A[i].posY,
                    fMainMenu.M_armor_A[i].itemId,fMainMenu.M_armor_A[i].itemRotation);

      terrObsFillCell(fMainMenu.M_weapon_A[i].posX,fMainMenu.M_weapon_A[i].posY,
                    fMainMenu.M_weapon_A[i].itemId,fMainMenu.M_weapon_A[i].itemRotation);
    end; // in 500
  end; // for movables
  SetArmorA_prop;
  //---------------------------

  // enemies-------------------
  for i:=1 to 2000 do begin
    terrObsFillCell(fMainMenu.M_enemy_A[i].posX,fMainMenu.M_enemy_A[i].posY,
                    fMainMenu.M_enemy_A[i].itemId,fMainMenu.M_enemy_A[i].itemRotation);

    terrObsFillCell(fMainMenu.M_enemy_B[i].posX,fMainMenu.M_enemy_B[i].posY,
                    fMainMenu.M_enemy_B[i].itemId,fMainMenu.M_enemy_B[i].itemRotation);

    terrObsFillCell(fMainMenu.M_enemy_C[i].posX,fMainMenu.M_enemy_C[i].posY,
                    fMainMenu.M_enemy_C[i].itemId,fMainMenu.M_enemy_C[i].itemRotation);

    terrObsFillCell(fMainMenu.M_enemy_D[i].posX,fMainMenu.M_enemy_D[i].posY,
                    fMainMenu.M_enemy_D[i].itemId,fMainMenu.M_enemy_D[i].itemRotation);

    terrObsFillCell(fMainMenu.M_enemy_E[i].posX,fMainMenu.M_enemy_E[i].posY,
                    fMainMenu.M_enemy_E[i].itemId,fMainMenu.M_enemy_E[i].itemRotation);

    terrObsFillCell(fMainMenu.M_enemy_F[i].posX,fMainMenu.M_enemy_F[i].posY,
                    fMainMenu.M_enemy_F[i].itemId,fMainMenu.M_enemy_F[i].itemRotation);

    terrObsFillCell(fMainMenu.M_enemy_G[i].posX,fMainMenu.M_enemy_G[i].posY,
                    fMainMenu.M_enemy_G[i].itemId,fMainMenu.M_enemy_G[i].itemRotation);
  end; // for enemies
  SetEnemiesA_prop;
  SetEnemiesB_prop;
  SetEnemiesC_prop;
  SetEnemiesD_prop;
  SetEnemiesE_prop;
  SetEnemiesF_prop;
  SetEnemiesG_prop;
  //---------------------------
end;

procedure loadLevelFromSave(idx:byte);
var
  curX, curY,i,j:Integer;
begin
  with Form1 do begin
    if (idx=2) then begin
      curX:=fMainMenu.MH_start_X;
      curY:=fMainMenu.MH_start_Y;
      for j:=(curY-100) to (curY+100) do begin
        for i:=(curX-100) to (curX+100) do begin
          // fill movable
          //if (fMainMenu.local_terr[(i-(curX-100)) , (j-(curY-100))] in [150..190])and(terrObs[i,j].itemId=0) then
            terrObs[i,j].itemId:=fMainMenu.local_terr[(i-(curX-100)) , (j-(curY-100))];
        end; // for i
    end; // for j

    restoreWebAreasFromSave(0);
    restorePowerSpxFromSave(fMainMenu.power_spx_restoration_needed);
    end; // if 2
  end; // with
end;

procedure restoreWebAreasFromSave(idx:byte);
var
  curX, curY,i,j:Integer;
  c:byte;
begin
  with Form1 do begin
    for c:=1 to 8 do begin
      if not fMainMenu.buff_MH_webs[c].isFree then begin

        curX:=fMainMenu.buff_MH_webs[c].posX;
        curY:=fMainMenu.buff_MH_webs[c].posZ;
        for j:=(curY-100) to (curY+100) do begin
          for i:=(curX-100) to (curX+100) do begin
            terrObs[i,j].itemId:=fMainMenu.local_terr_webs[c,(i-(curX-100)) , (j-(curY-100))];
          end; // for i
        end; // for j
      end; // if
    end; // for c
  end; // with
end;

procedure restorePowerSpxFromSave(needed:boolean);
begin
  // clear from maps
  terrObsFillCell(Form1.power_spx_X, Form1.power_spx_Y,0,0);
  if needed then begin
    Form1.power_spx_X:= fMainMenu.buff_power_spx_X;
    Form1.power_spx_Y:= fMainMenu.buff_power_spx_Y;
    terrObsFillCell(fMainMenu.buff_power_spx_X, fMainMenu.buff_power_spx_Y,190,0);
  end; // if
end;

end.
