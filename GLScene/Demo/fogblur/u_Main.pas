unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls,

  GLCrossPlatform, BaseClasses, GLScene, GLCoordinates, GLObjects, GLMaterial,
  GLWin32Viewer, GLCadencer, GLPolyhedron, VectorGeometry, VectorTypes,
  GLHUDObjects, GLFBORenderer, GLCustomShader, GLSLShader, GLRenderContextInfo,

  TGA;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    dc_trg: TGLDummyCube;
    cad: TGLCadencer;
    cube: TGLCube;
    sky: TGLSphere;
    light: TGLLightSource;
    dodec: TGLDodecahedron;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    vp: TGLSceneViewer;
    hud_shad: TGLHUDSprite;
    hud_blurS: TGLHUDSprite;
    matlib: TGLMaterialLibrary;
    mvp: TGLMemoryViewer;
    dc_obj: TGLDummyCube;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button4: TButton;
    hud_blurF: TGLHUDSprite;
    fbo_blurF: TGLFBORenderer;
    dc_blurS: TGLDummyCube;
    dc_blurF: TGLDummyCube;
    Button5: TButton;
    dc_blurG: TGLDummyCube;
    fbo_blurG_pass1: TGLFBORenderer;
    hud_blurG_pass1: TGLHUDSprite;
    fbo_blurG_pass2: TGLFBORenderer;
    glsl_blurG_dx: TGLSLShader;
    hud_blurG_pass2: TGLHUDSprite;
    glsl_blurG_dy: TGLSLShader;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    GLCube3: TGLCube;
    GLCube4: TGLCube;
    dc_sph1: TGLDummyCube;
    GLSphere1: TGLSphere;
    dc_sph2: TGLDummyCube;
    GLSphere2: TGLSphere;
    hud_logo: TGLHUDSprite;
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure glsl_blurG_dxApply(Shader: TGLCustomGLSLShader);
    procedure glsl_blurG_dyApply(Shader: TGLCustomGLSLShader);
  public

    fade_fog: boolean;
    delta_fog: single;
    fade_hud: boolean;
    delta_hud: single;

    fade_blurS: boolean;
    delta_blurS: single;
    fade_blurF: boolean;
    delta_blurF: single;
    fade_blurG: boolean;
    delta_blurG: single;

    procedure fade(var delta:single; spd:single; f:boolean);

    procedure updFog(s:single);
    procedure updHUD(s:single);

    procedure updBlurS(s:single);
    procedure updBlurF(s:single);
    procedure updBlurG(s:single);

  end;

var
  Form1: TForm1;

  tw: integer = 128;
  th: integer = 64;


implementation

{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
begin

  clientWidth := 700;
  clientHeight := 400 + panel2.Height;

  fade_fog := false;
  delta_fog := 0;
  fade_hud := false;
  delta_hud := 0;
  fade_blurS := false;
  delta_blurS := 0;
  fade_blurF := false;
  delta_blurF := 0;
  fade_blurG := false;
  delta_blurG := 0;

  mvp.Width := tw;
  mvp.Height := th;

  fbo_blurF.Width := tw;
  fbo_blurF.Height := th;

  fbo_blurG_pass1.Width := tw * 2;
  fbo_blurG_pass1.Height := th * 2;
  fbo_blurG_pass2.Width := tw * 2;
  fbo_blurG_pass2.Height := th * 2;

end;


//
// FormShow
//
procedure TForm1.FormShow;
begin

  cad.Enabled := true;

end;


//
// Button1Click
//
procedure TForm1.Button1Click;
begin

  panel1.Visible := sender <> SpeedButton1;
  fade_fog := sender = Button1;
  fade_hud := sender = Button2;
  fade_blurS := sender = Button3;
  fade_blurF := sender = Button4;
  fade_blurG := sender = Button5;

  if fade_hud or fade_blurS or fade_blurF or fade_blurG then
    delta_fog := 0;
  if fade_fog or fade_blurS or fade_blurF or fade_blurG then
    delta_hud := 0;
  if fade_fog or fade_hud or fade_blurF or fade_blurG then
    delta_blurS := 0;
  if fade_fog or fade_hud or fade_blurS or fade_blurG then
    delta_blurF := 0;
  if fade_fog or fade_hud or fade_blurS or fade_blurF then
    delta_blurG := 0;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dc_cam.Turn(deltatime * 5);
  dodec.Turn(deltatime * 25);
  dc_sph1.Roll(deltatime * 70);
  dc_sph2.Pitch(deltatime * 70);

  updFog(deltatime * 2);

  hud_shad.Visible := (delta_hud > 0)
    or (delta_blurS > 0) or (delta_blurF > 0) or (delta_blurG > 0);

  updHUD(deltatime * 2);
  updBlurS(deltatime * 2);
  updBlurF(deltatime * 2);
  updBlurG(deltatime * 2);

end;


//
// fade
//
procedure TForm1.fade(var delta:single; spd:single; f:boolean);
begin

  if f and (delta < 1) then
    delta := MinFloat(delta + spd, 1)
  else if not f and (delta > 0) then
    delta := MaxFloat(delta - spd * 2, 0);

end;



//
// updFog
//
procedure TForm1.updFog;
begin

  fade(delta_fog, s, fade_fog);

  vp.Buffer.FogEnable := delta_fog > 0;
  if delta_fog > 0 then
    with vp.Buffer.FogEnvironment do begin
      FogStart := 100 - delta_fog * 500;
      FogEnd := 800 - delta_fog * 500;
      end;

end;

//
// updHUD
//
procedure TForm1.updHUD;
var
    g: single;

begin

  fade(delta_hud, s, fade_hud);

  if delta_hud > 0 then begin

    g := 1 - delta_hud * 0.7;
    hud_shad.Material.FrontProperties.Diffuse.SetColor(g, g, g, 1);

    end;

end;


//
// updBlurS
//
procedure TForm1.updBlurS;
var
    g: single;

begin

  fade(delta_blurS, s, fade_blurS);

  dc_blurS.Visible := delta_blurS > 0;
  if delta_blurS > 0 then begin

    g := 1 - delta_blurS * 0.4;
    hud_shad.Material.FrontProperties.Diffuse.SetColor(g, g, g, 1);

    with matlib.LibMaterialByName('simple_blur').Material do begin

      mvp.Render(dc_obj);
      mvp.CopyToTexture(Texture);
      FrontProperties.Diffuse.Alpha := delta_blurS;

      end;

    end;

end;


//
// updBlurF
//
procedure TForm1.updBlurF;
var
    g: single;

begin

  fade(delta_blurF, s, fade_blurF);

  dc_blurF.Visible := delta_blurF > 0;
  if delta_blurF > 0 then begin

    g := 1 - delta_blurF * 0.4;
    hud_shad.Material.FrontProperties.Diffuse.SetColor(g, g, g, 1);

    with matlib.LibMaterialByName('fast_blur').Material do
      FrontProperties.Diffuse.Alpha := delta_blurF;

    end;

end;


//
// updBlurG
//
procedure TForm1.updBlurG;
var
    g: single;

begin

  fade(delta_blurG, s, fade_blurG);

  dc_blurG.Visible := delta_blurG > 0;
  if delta_blurG > 0 then begin

    g := 1 - delta_blurG * 0.4;
    hud_shad.Material.FrontProperties.Diffuse.SetColor(g, g, g, 1);

    end;

end;


//
// glsl_blurG_dxApply
//
procedure TForm1.glsl_blurG_dxApply;
begin

  Shader.Param['sz'].AsFloat := 0.5 / tw * delta_blurG;

end;


//
// glsl_blurG_dyApply
//
procedure TForm1.glsl_blurG_dyApply;
begin

  Shader.Param['sz'].AsFloat := 0.5 / th * delta_blurG;

end;


end.
