unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,

  GLCadencer, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLObjects,
  GLCoordinates, VectorGeometry, VectorTypes, GLRenderContextInfo, GLState,
  GLHUDObjects, GLGeomObjects,

  TGA;


type

  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dogl: TGLDirectOpenGL;
    dc_cam: TGLDummyCube;
    tor: TGLTorus;
    light: TGLLightSource;
    dc_scene: TGLDummyCube;
    sph: TGLSphere;
    hud_back: TGLHUDSprite;
    hud_ball: TGLHUDSprite;
    procedure doglRender(Sender:TObject; var rci:TRenderContextInfo);
    procedure cadProgress(Sender:TObject; const deltaTime,newTime:Double);
    procedure FormResize(Sender:TObject);
    procedure FormKeyDown(Sender:TObject; var Key:Word; Shift:TShiftState);
  end;


const
  cap = 'HUD test / press F2,F3 or F1: ';


var
  Form1: TForm1;
  dt: single;

  blst: array of record
    pos,vel,col: TVector3f;
    d: single;
    end;


implementation

{$R *.dfm}



//
// cadProgress
//
procedure TForm1.cadProgress;
var
    nt: single;

begin

  dt := deltatime;
  nt := newtime/2.6;

  tor.ResetAndPitchTurnRoll(
    -sin(nt/2) * cos(nt/3) * 400,
    -cos(nt) * cos(nt/4) * 500, 0);

  sph.Turn(dt * 2);

end;


//
// FormResize
//
procedure TForm1.FormResize;
var
    i: integer;

begin

  hud_back.Position.SetPoint(vp.Width div 2, vp.Height div 2, 0);

  randomize;
  setLength(blst, (vp.Width + vp.Height) div 40);
  for i := 0 to high(blst) do
    with blst[i] do begin

      d := 30 + random * 50;

      setvector(pos,
        d + random * (vp.Width - 2 * d),
        d + random * (vp.Height - 2 * d), 0);

      RandomPointOnSphere(vel);
      scalevector(vel, 200 + random * 500);
      vel[2] := 0;

      setvector(col,
        0.5 + random * 0.5,
        0.5 + random * 0.5,
        0.5 + random * 0.5);

      end;

end;


//
// doglRender
//
procedure TForm1.doglRender;
var
    i: integer;
    dp: TVector3f;

begin

  for i := 0 to high(blst) do
    with blst[i] do begin

      hud_ball.Width := d;
      hud_ball.Height := d;

      dp := vectorScale(vel, dt);
      if (pos[0] + dp[0] < d / 2) or (pos[0] + dp[0] > vp.Width - d / 2) then
        vel[0] := -vel[0];
      if (pos[1] + dp[1] < d / 2) or (pos[1] + dp[1] > vp.Height - d / 2) then
        vel[1] := -vel[1];

      addVector(pos, vectorscale(vel, dt));
      hud_ball.Position.SetPoint(pos);

      hud_ball.Material.FrontProperties.Diffuse.
        SetColor(col[0], col[1], col[2]);

      hud_ball.Render(rci);

      end;

end;


//
// FormKeyDown
//
procedure TForm1.FormKeyDown;
var
    k: integer;

begin

  if key = vk_f1 then begin
    k := 1;
    caption := cap + 'default';
    end
  else if key = vk_f2 then begin
    k := 2;
    caption := cap + 'GLScene1.ObjectsSorting = osNone';
    end
  else if key = vk_f3 then begin
    k := 3;
    caption := cap + 'dogl.Blend = true';
    end
  else exit;

  if k = 2 then GLScene1.ObjectsSorting := osNone
    else GLScene1.ObjectsSorting := osInherited;

  if k = 3 then dogl.Blend := true
    else dogl.Blend := false

end;

end.
