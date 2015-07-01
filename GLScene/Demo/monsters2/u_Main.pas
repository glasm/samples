unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  GLWin32Viewer, GLScene, GLObjects, GLCadencer, GLTexture, vectorgeometry,
  vectortypes, GLVectorFileObjects, AsyncTimer, GLGeomObjects, GLKeyboard,
  GLCoordinates, GLRenderContextInfo, GLCrossPlatform, BaseClasses, GLDCE,
  GLMaterial, GLSkyBox, GLHUDObjects,

  jpeg, tga, GLFile3DS, StdCtrls, Buttons, GLBitmapFont, GLWindowsFont,
  GLFileWAV, GLSound, GLSMWaveOut;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    DOGL: TGLDirectOpenGL;
    mob: TGLFreeForm;
    ff: TGLFreeForm;
    dce: TGLDCEManager;
    sky: TGLSkyBox;
    matlib: TGLMaterialLibrary;
    cur: TGLHUDSprite;
    spot: TGLPlane;
    menu: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    scores: TLabel;
    flash: TGLSprite;
    blood: TGLSprite;
    cur_score: TGLResolutionIndependantHUDText;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    cur_live: TGLResolutionIndependantHUDText;
    Image1: TImage;
    sndlib: TGLSoundLibrary;
    wout: TGLSMWaveOut;
    at: TAsyncTimer;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure DOGLRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure atTimer(Sender: TObject);
  public

    procedure initMob(n:integer);
    procedure genBlood(n:TVector);

    procedure updControl;
    procedure updDCE;
    procedure resMob;    

    procedure runMenu;
    procedure runGame;

  end;


type

  t_Monster = record
  pos,dir: TVector;
  ct,en: single;
  end;

  t_State = (st_Menu, st_Game);


var
  Form1: TForm1;

  mob_arr: array[0..999] of t_Monster;
  mob_blood: array[0..999] of TVector;
  mob_bloodind: integer = 0;
  mob_cnt: integer;
  mob_res: single;

  pl_dce: TGLDCEDynamic;
  pl_run: boolean = false;
  pl_score: integer;
  pl_mobs: integer;

  dt: single = 0;
  dce_dt: single = 0;

  state: t_State = st_Menu;



implementation

{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
begin

  randomize;

  ff.LoadFromFile('scn.3ds');
  ff.BuildOctree(1);

  mob.LoadFromFile('monster.3ds');
  mob.Scale.Scale(4 / mob.BoundingSphereRadius);

  pl_dce := getOrCreateDCEDynamic(dc_cam);

  runMenu;

end;


//
// initMob
//
procedure TForm1.initMob(n:integer);
var
    v,vn: TVector;
    av: TVector3f;

begin

  repeat
    setvector(v, random * 520 - 140, random * 300 - 200, random * 500 - 240);
    until ff.RayCastIntersect(v, vectormake(0, -1, 0), @v, @vn) and (vn[1] > 0);

  setvector(mob_arr[n].pos, v);

  RandomPointOnSphere(av);
  setvector(mob_arr[n].dir, VectorNormalize(av));

  mob_arr[n].ct := cad.CurrentTime;
  mob_arr[n].en := 2;

end;


//
// genBlood
//
procedure TForm1.genBlood(n:TVector);
var
    i,j: integer;
    v: TVector;
    av: TVector3f;

begin

  n[1] := n[1] + 3;
  for i := 0 to 50 do begin

    RandomPointOnSphere(av);
    if ff.OctreeRayCastIntersect(n, vectormake(av), @v) then
      if VectorNorm(vectorsubtract(v, n)) < 800 then begin
        mob_blood[mob_bloodind] := v;
        mob_bloodind := (mob_bloodind + 1) mod length(mob_blood);
        end;

    end;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  if not vp.Visible then exit;

  dt := deltatime;

  updControl;
  updDCE;

  resMob;

end;


//
// updControl
//
procedure TForm1.updControl;
begin

  with mouse.CursorPos, cam, screen do begin
    dc_cam.Turn( (X - (width div 2)) * 0.2 );
    PitchAngle := clampvalue( PitchAngle + ((height div 2) - Y) * 0.2, -90, 90);
    setcursorpos(width div 2, height div 2);
    end;

end;


//
// updDCE
//
procedure TForm1.updDCE;
var
    v: TVector3f;
    spd,f: single;

begin

  dce_dt := dce_dt + dt;
  if dce_dt > 0.02 then begin

    setvector(v, 0,0,0);

    if iskeydown(ord('W')) or iskeydown(vk_up) then
      v := vectornegate(vectoradd(v, dc_cam.AbsoluteAffineDirection));
    if iskeydown(ord('S')) or iskeydown(vk_down) then
      v := vectoradd(v, dc_cam.AbsoluteAffineDirection);
    if iskeydown(ord('A')) or iskeydown(vk_left) then
      v := vectoradd(v, affinevectormake(dc_cam.AbsoluteLeft));
    if iskeydown(ord('D')) or iskeydown(vk_right) then
      v := vectoradd(v, affinevectormake(dc_cam.AbsoluteRight));

    if vectorlength(v) = 0 then pl_run := false
    else if iskeydown(ord('X')) then
      pl_run := true;

    if iskeydown(vk_lshift) or pl_run then spd := 20
      else spd := 10;

    v := vectorscale(vectorNormalize(v), spd);
    v[1] := -25;
    pl_dce.Move(v, 0.1);


    ff.OctreeRayCastIntersect(dc_cam.AbsolutePosition, vectormake(0, -1, 0), @v);
    f := dc_cam.AbsolutePosition[1] - v[1];
    if f < 10 then
      dc_cam.AbsolutePosition := vectormake(v[0], v[1] + 10, v[2]);

    dce.Step(dce_dt);
    dce_dt := frac(dce_dt / 0.02) * 0.02;

    end;

end;


//
// resMob
//
procedure TForm1.resMob;
begin

  if mob_cnt = length(mob_arr) then exit;

  mob_res := mob_res - dt;
  if mob_res < 0 then begin

    initMob(mob_cnt);
    inc(mob_cnt);
    mob_res := mob_cnt / 2;

    end;

end;


//
// runMenu
//
procedure TForm1.runMenu;
begin

  vp.Visible := false;
  menu.visible := true;

end;


//
// runGame
//
procedure TForm1.runGame;
var
    i:integer;

begin

  menu.visible := false;
  vp.Visible := true;

  mob_cnt := 0;
  mob_res := 0;

  pl_score := 0;
  pl_mobs := 0;
  cur_score.Text := '0 ';

  for i := 0 to high(mob_blood) do
    setvector(mob_blood[i], 0, 1000, 0);

end;


//
// DOGLRender
//
procedure TForm1.DOGLRender;
var
    i: integer;
    v: TVector;
    f: single;

begin

  for i := 0 to mob_cnt - 1 do
    with mob,mob_arr[i] do begin

      if en > 1 then begin

        if en > 1.5 then f := (2 - en) * 40
          else f := (en - 1) * 40;

        flash.Height := f;
        flash.Width := f;
        flash.Position.SetPoint(pos[0], pos[1] + 4, pos[2]);
        flash.Render(rci);

        en := en - dt;

        if en > 1.5 then
          continue;

        end;

      v := vectorsubtract(dc_cam.AbsolutePosition, mob_arr[i].pos);
      if VectorNorm(v) < 5000 then
        dir := VectorLerp(dir, VectorNormalize(v), dt);

      Direction.SetVector(dir);
      Up.SetVector(0, 1, 0);
      Position.SetPoint(pos);
      Render(rci);

      spot.Position.SetPoint(pos[0], pos[1] + 0.01, pos[2]);
      spot.Render(rci);

      end;

  for i := 0 to high(mob_blood) do begin
    blood.Position.SetPoint(mob_blood[i]);
    blood.Render(rci);
    end;
  
end;


//
// FormResize
//
procedure TForm1.FormResize;
begin

  cur.Position.SetPoint(clientWidth div 2, clientHeight div 2, 0);

  menu.Left := clientWidth div 2 - 300;
  menu.Top := clientHeight div 2 - 240;

end;


//
// FormKeyDown
//
procedure TForm1.FormKeyDown;
begin

  if key = vk_escape then
    if state = st_Game then runMenu
      else close;

end;


//
// exit
//
procedure TForm1.BitBtn2Click;
begin

  close;

end;


//
// start
//
procedure TForm1.BitBtn1Click;
begin

  runGame;

end;


//
// fire
//
procedure TForm1.vpMouseDown;
var
    i: integer;
    vs,vr: TVector;

begin

  sndlib.Samples[2].PlayOnWaveOut;

  vs := cam.AbsolutePosition;
  vr := cam.AbsoluteVectorToTarget;

  for i := 0 to mob_cnt - 1 do
    with mob_arr[i] do begin

      if RayCastIntersectsSphere(vs, vr,
        vectormake(pos[0], pos[1] + 2, pos[2]), 10) then begin
        genBlood(pos);
        en := en - 0.2 - random / 5;
        pl_score := pl_score + 5;
        cur_score.Text := inttostr(pl_score) + ' ';
        end;

      if RayCastIntersectsSphere(vs, vr,
        vectormake(pos[0], pos[1] + 4, pos[2]), 1) then begin
        genBlood(pos);
        en := en - 0.4 - random / 5;
        pl_score := pl_score + 15;
        cur_score.Text := inttostr(pl_score) + ' ';
        end;

      if en < 0 then begin
        initMob(i);
        inc(pl_mobs);
        if pl_mobs mod 5 = 0 then
          mob_res := 0;
        end;

      end;

  cam.PitchAngle := cam.PitchAngle + 0.2 + random;
  dc_cam.TurnAngle := dc_cam.TurnAngle + random * 2 - 1;   

end;

procedure TForm1.atTimer(Sender: TObject);
begin

  caption := 'Monsters2 (UNFINISHED): ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

end.
