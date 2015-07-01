unit AudioUtils;

interface
   uses XCollection,GLCollision, Geometry, Dialogs, Math,
       SysUtils, GLObjects,  Windows, GLVectorFileObjects,
       GLHUDObjects, GLTexture;

  procedure loadMainMenuAudio;
  procedure play_MainMenuAudioTrack(idx:byte;volume_level:Smallint;is_looping:boolean);
  // enemies and MH
  procedure play_HerosAudioTrack(idx:byte;volume_level:Smallint;playIt,is_looping:boolean);
  procedure stopAllGameSounds;
  procedure shuffleMainThema(volume_level:Smallint);
  procedure playTM(idx: byte;volume_level:Smallint; playIt,looping: boolean);
  procedure changeVolumeLevel(idx:byte;new_volume_level:Smallint);
  
implementation
  uses Unit1, GLScene, Forms, MainMenu, DXSounds;

procedure loadMainMenuAudio;
begin
 with fMainMenu do begin
    // process RunTime load
    with DXWaveListMainMenu do begin
      //-- 0 Main Theme A
      Items.Add;
      Items[0].Wave.LoadFromFile('base_theme.wav');

      //-- 1 Main Theme B
      Items.Add;
      Items[1].Wave.LoadFromFile('base_theme2.wav');

      //-- 2 Main Theme C
      Items.Add;
      Items[2].Wave.LoadFromFile('base_theme3.wav');

      //-- 3 Main Theme D
      Items.Add;
      Items[3].Wave.LoadFromFile('base_theme4.wav');

      //-- 4 Main Theme E
      Items.Add;
      Items[4].Wave.LoadFromFile('base_theme5.wav');

      //-- 5 Btn Click
      Items.Add;
      Items[5].Wave.LoadFromFile('btn_click_A.wav');

      //-- 6  some item pick
      Items.Add;
      Items[6].Wave.LoadFromFile('item_pick.wav');

      //-- 7  some item drop
      Items.Add;
      Items[7].Wave.LoadFromFile('item_drop.wav');

      //-- 8
      Items.Add;
      //Items[8].Wave.LoadFromFile('btn_click_A.wav');

      //-- 9
      Items.Add;
      //Items[9].Wave.LoadFromFile('btn_click_A.wav');

      //-- 10
      Items.Add;
      //Items[10].Wave.LoadFromFile('btn_click_A.wav');

      //-- 11 spider walk
      Items.Add;
      Items[11].Wave.LoadFromFile('EA_walk.wav');

      //-- 12 spider pain
      Items.Add;
      Items[12].Wave.LoadFromFile('EA_pain.wav');

      //-- 13 spider lightning + chain
      Items.Add;
      Items[13].Wave.LoadFromFile('lightning.wav');

      //-- 14 spider nova
      Items.Add;
      Items[14].Wave.LoadFromFile('nova.wav');

      //-- 15 spider build web
      Items.Add;
      Items[15].Wave.LoadFromFile('build_web.wav');

      //-- 16 spider destroy web
      Items.Add;
      Items[16].Wave.LoadFromFile('destroy_web.wav');

      //-- 17 cell drink
      Items.Add;
      Items[17].Wave.LoadFromFile('cell_drink.wav');

      //-- 18 web teleport
      Items.Add;
      Items[18].Wave.LoadFromFile('web_teleport.wav');

      //-- 19 death
      Items.Add;
      //Items[19].Wave.LoadFromFile('EA_death.wav');

      // ALIEN
      //-- 20 alien walk
      Items.Add;
      Items[20].Wave.LoadFromFile('EB_walk.wav');

      //-- 21 alien fireball throw
      Items.Add;
      Items[21].Wave.LoadFromFile('EB_fireball_throw.wav');

      //-- 22 alien fire
      Items.Add;
      Items[22].Wave.LoadFromFile('EB_fire.wav');

      //-- 23 alien pain
      Items.Add;
      Items[23].Wave.LoadFromFile('EB_pain.wav');

      //-- 24 alien death
      Items.Add;
      Items[24].Wave.LoadFromFile('EB_death.wav');

      //-- 25 alien death
      Items.Add;
      //Items[25].Wave.LoadFromFile('EB_death.wav');

      // BUG EC
      //-- 26 bug walk
      Items.Add;
      Items[26].Wave.LoadFromFile('EC_walk.wav');

      //-- 27 bug bite
      Items.Add;
      Items[27].Wave.LoadFromFile('EC_bite.wav');

      //-- 28 bug pain
      Items.Add;
      Items[28].Wave.LoadFromFile('EC_pain.wav');

      //-- 29 bug death
      Items.Add;
      Items[29].Wave.LoadFromFile('EC_death.wav');

      //-- 30 bug death
      Items.Add;
      //Items[30].Wave.LoadFromFile('EB_death.wav');

      // INSECT ED
      //-- 31 insect walk
      Items.Add;
      Items[31].Wave.LoadFromFile('ED_walk.wav');

      //-- 32 insect smack
      Items.Add;
      Items[32].Wave.LoadFromFile('ED_smack.wav');

      //-- 33 insect pain
      Items.Add;
      Items[33].Wave.LoadFromFile('ED_pain.wav');

      //-- 34 insect death
      Items.Add;
      Items[34].Wave.LoadFromFile('ED_death.wav');

      //-- 35 insect death
      Items.Add;
      //Items[35].Wave.LoadFromFile('EB_death.wav');

      // FROG EE
      //-- 36 frog walk
      Items.Add;
      Items[36].Wave.LoadFromFile('EE_walk.wav');

      //-- 37 frog acidball throw
      Items.Add;
      Items[37].Wave.LoadFromFile('EE_acidball_throw.wav');

      //-- 38 frog pain
      Items.Add;
      Items[38].Wave.LoadFromFile('EE_pain.wav');

      //-- 39 frog death
      Items.Add;
      Items[39].Wave.LoadFromFile('EE_death.wav');

      //-- 40 frog death
      Items.Add;
      //Items[40].Wave.LoadFromFile('EE_death.wav');

      // DRIO EF
      //-- 41 drio walk
      Items.Add;
      Items[41].Wave.LoadFromFile('EF_walk.wav');

      //-- 42 drio laserball throw
      Items.Add;
      Items[42].Wave.LoadFromFile('EF_laserball_throw.wav');

      //-- 43 drio pain
      Items.Add;
      Items[43].Wave.LoadFromFile('EF_pain.wav');

      //-- 44 drio death
      Items.Add;
      Items[44].Wave.LoadFromFile('EF_death.wav');

      //-- 45 drio death
      Items.Add;
      //Items[45].Wave.LoadFromFile('EF_death.wav');

      // OKTA EG
      //-- 46 okta walk
      Items.Add;
      Items[46].Wave.LoadFromFile('EG_walk.wav');

      //-- 47 okta laserball throw
      Items.Add;
      Items[47].Wave.LoadFromFile('EG_attack.wav');

      //-- 48 okta pain
      Items.Add;
      Items[48].Wave.LoadFromFile('EG_pain.wav');

      //-- 49 okta death
      Items.Add;
      Items[49].Wave.LoadFromFile('EG_death.wav');

      //-- 50 okta death
      Items.Add;
      //Items[50].Wave.LoadFromFile('EG_death.wav');

      //Initialize;
    end; // with wave list
  end; // with fmain
end;

procedure play_MainMenuAudioTrack(idx:byte;volume_level:Smallint;is_looping:boolean);
begin
  with fMainMenu do begin
    // play some if allowed
    if(allow_global_audio) then begin
      with DXWaveListMainMenu do begin
        // Play by index
        // rewind
        Items[idx].Restore;
        // volume min..max [-10000..0]
        Items[idx].Volume:=volume_level;
        Items[idx].Looped:=is_looping;
        // dont wait to play
        Items[idx].Play(false);
      end; // with wave list
    end; // if audio allowed
  end; // with Form1
end;

procedure play_HerosAudioTrack(idx:byte;volume_level:Smallint;playIt,is_looping:boolean);
begin
  with fMainMenu do begin
    // play some if allowed
    if(allow_global_audio) then begin
      if(playIt) then begin
        // play the sound
        with DXWaveListMainMenu do begin
          // Play by index
          // rewind
          Items[idx].Restore;
          // volume min..max [-10000..0]
          Items[idx].Volume:=volume_level;
          Items[idx].Looped:=is_looping;
          // dont wait to play
          Items[idx].Play(false);
        end; // with wave list
       end
       else
       begin
         // stop the sound
         DXWaveListMainMenu.Items[idx].Stop;
       end;

    end; // if audio allowed
  end; // with Form1
end;

procedure stopAllGameSounds;
var
  i:byte;
begin
  for i:= 5 to fMainMenu.DXWaveListMainMenu.Items.Count-1 do begin
    with fMainMenu.DXWaveListMainMenu do begin
      // Stop all
      Items[i].Stop;
    end; // with wave list
  end; // for all
end;

procedure shuffleMainThema(volume_level:Smallint);
var
  ran:byte;
  buffered,A,B:String;
  playing:array[3..5] of boolean;
begin
  // track interval 30 sec.
  // thema 1 and 2 always playing
  ran:=RandomRange(31,59);
  buffered:=IntToStr(ran);
  A:=Copy(buffered,1,1);  // track id
  B:=Copy(buffered,2,1);  // if odd play

  // if odd stop 3,4,5 first
  // else Don't and then choose play
  if odd(StrToInt(B)) then begin
    // stop all
    playTM(3-1,volume_level,false,false);
    playTM(4-1,volume_level,false,false);
    playTM(5-1,volume_level,false,false);

    playing[3]:=false;
    playing[4]:=false;
    playing[5]:=false;
    // play A
    playTM(StrToInt(A)-1,volume_level,true,false);
    playing[StrToInt(A)]:=true;
  end
  else
  begin
    // check is already playing
    if(playing[StrToInt(A)]) then begin
      // stop A
      playTM(StrToInt(A)-1,volume_level,false,false);
      // play A
      playTM(StrToInt(A)-1,volume_level,true,false);
      playing[StrToInt(A)]:=true;
    end
    else
    begin
      // just play it
      playTM(StrToInt(A)-1,volume_level,true,false);
      playing[StrToInt(A)]:=true;
    end; // if playing

  end; // if odd
end;

procedure playTM(idx: byte;volume_level:Smallint; playIt,looping: boolean);
begin
  with fMainMenu do begin
    if(allow_global_audio) then begin
      if (playIt) then begin
        DXWaveListMainMenu.Items[idx].Restore;
        DXWaveListMainMenu.Items[idx].Volume:=volume_level;
        DXWaveListMainMenu.Items[idx].Looped:=looping;
        DXWaveListMainMenu.Items[idx].Play(false);
      end
      else
      begin
        DXWaveListMainMenu.Items[idx].Stop;
      end;
    end; // if allowd
  end; // with
end;

procedure changeVolumeLevel(idx:byte;new_volume_level:Smallint);
begin
  with fMainMenu do begin
    if(allow_global_audio) then begin
      DXWaveListMainMenu.Items[idx].Volume:=new_volume_level;
    end; // if allowd
  end; // with
end;

end.
