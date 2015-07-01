unit u_Main;

interface

uses
  Forms, Dialogs, Windows, Classes, StdCtrls, ExtCtrls, Graphics,

  GLCrossPlatform, Controls,

  GLScene, GLCadencer, GLObjects, GLGeomObjects, GLKeyboard, GLState,
  GLWin32Viewer, GLTexture, GLMaterial, GLCoordinates, BaseClasses,
  VectorGeometry, GLHUDObjects, GLFile3DS, GLRenderContextInfo,
  GLFBORenderer, GLVectorFileObjects, VectorTypes,

  TGA;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    cad: TGLCadencer;
    MatLib: TGLMaterialLibrary;
    dc_cam: TGLDummyCube;
    radar_hud: TGLHUDSprite;
    fbo_map: TGLFBORenderer;
    ffmap: TGLFreeForm;
    dogl: TGLDirectOpenGL;
    sprt: TGLSprite;
    dc_world: TGLDummyCube;
    dogl_map: TGLDirectOpenGL;
    disk_hud: TGLHUDSprite;
    arrow_hud: TGLHUDSprite;
    quest_hud: TGLHUDSprite;
    player_hud: TGLHUDSprite;
    GLSphere: TGLSphere;
    cam_map: TGLCamera;
    dc_map: TGLDummyCube;
    GLDisk1: TGLDisk;
    procedure cadProgress(Sender: TObject; const dt,nt: Double);
    procedure FormCreate(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dogl_mapRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
  private
  public
  end;


  t_vpoint = record
    v0,v1: single;
    end;

var
  Form1: TForm1;

  m_pos: TPoint;
  m_turn,m_move: boolean;
  m_dy,m_dx: t_vpoint;

  sw2,sh2: integer;
  vpsz: TGLSize;
  cam_pos: TAffineVector;

  q_pos: array[0..4] of TAffineVector = ((64, 128, 0), (45, 58, 0),
    (154, 38, 0), (205, 154, 0), (154, 218, 0));

  tex_disk: TGLTexture;


implementation


{$R *.dfm}


//
// formCreate
//
procedure TForm1.FormCreate;
begin

  sw2 := screen.Width div 2;
  sh2 := screen.Height div 2;

  ffmap.LoadFromFile('map.3ds');

end;


//
// cadProgress
//
procedure TForm1.cadProgress;

  function _lerp(var md:t_vpoint): single;
  var
      f: single;
  begin
    f := lerp(md.v0, md.v1, dt * 10);
    result := f - md.v0;
    md.v0 := f;
    end;

begin

  if m_move then
    with vp.ScreenToClient(mouse.CursorPos) do
      radar_hud.Position.SetPoint( x, y, 0);

  if m_turn then
    with mouse.CursorPos do begin

      m_dx.v1 := m_dx.v1 + (X - sw2) * 0.3;
      m_dy.v1 := clampValue(m_dy.v1 + (sh2 - Y) * 0.3, -90, 90);

      if (X <> sw2) or (Y <> sh2) then
        mouse.CursorPos := point(sw2, sh2);

      end;

  dc_cam.Turn( _lerp(m_dx));
  cam.Pitch( _lerp(m_dy));

  setVector(cam_pos, - sin(nt / 4) * 45 - 64, cos(nt / 4) * 60 - 64, 0);
  dc_cam.Position.SetPoint(-cam_pos[0] - 64, 4, -cam_pos[1] - 64);

  if (not iskeydown(vk_lbutton)) and (not iskeydown(vk_rbutton)) then begin

    if m_turn then begin
      mouse.CursorPos := m_pos;
      showCursor(true);
      end;

    m_turn := false;
    m_move := false;

    end;

end;


//
// doglRender
//
procedure TForm1.doglRender;
var
    i: integer;

begin

  for i := 0 to high(q_pos) do begin

    sprt.Position.SetPoint(q_pos[i][0] - 128,
      6 + sin(cad.CurrentTime * 4 + i), q_pos[i][1] - 128);
    sprt.Render(rci);

    end;

  fbo_map.Active := cad.CurrentTime - fbo_map.TagFloat > 1 / 40;
  if fbo_map.Active then begin
    fbo_map.TagFloat := floor(cad.CurrentTime * 40) / 40;
    fbo_map.Render(rci);
    end;
  fbo_map.Active := false;

end;


//
// map
//
procedure TForm1.dogl_mapRender;
const
    cv: TAffineVector = (64, 64, 0);

var
    vpsz: TGLSize;
    a1: integer;
    v: TAffineVector;

begin

  vpsz := rci.viewPortSize;
  with rci.viewPortSize do begin
    cx := fbo_map.Width;
    cy := fbo_map.Height;
    end;

  matlib.LibMaterialByName('map').TextureOffset.SetPoint(
    0.5 - (cam_pos[0] + 128) / 256, (cam_pos[1] + 128) / 256, 0);

  gldisk1.Render(rci);

  for a1 := 0 to high(q_pos) do begin

    v := vectorSubtract(vectorAdd(q_pos[a1], cam_pos), cv);

    if vectorLength(v) < 55 then begin

      quest_hud.Position.SetPoint(vectorAdd(q_pos[a1], cam_pos));
      quest_hud.Render(rci);

      end;

    if vectorLength(v) > 50 then begin

      arrow_hud.Material.FrontProperties.Diffuse.Alpha :=
        clampValue((vectorLength(v) - 50) / 20, 0, 1);
      v := vectorNormalize(v);

      arrow_hud.Position.SetPoint(vectorAdd(vectorScale(v, 40), cv));
      arrow_hud.Rotation := sign(vectordotproduct(v, MinusXVector)) *
        arccos(vectordotproduct(v, MinusYVector)) * 57.296 + 45;
      arrow_hud.Render(rci);

      end;


    end;

  player_hud.Rotation := -m_dx.v0;
  player_hud.Render(rci);

  disk_hud.Render(rci);

  rci.viewPortSize := vpsz;

end;


//
// mouseDown
//
procedure TForm1.vpMouseDown;
begin

  case button of

    mbLeft: m_move := true;

    mbRight: begin
      m_turn := true;
      m_pos := mouse.CursorPos;
      showCursor(false);
      mouse.CursorPos := point(sw2, sh2);
      end;

    end;

end;


end.
