unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ExtCtrls,

  GLWin32Viewer, GLScene, GLCadencer, GLObjects, GLTexture, AsyncTimer,
  GLHUDObjects, GLShadowVolume, GLContext, GLMaterial, GLKeyboard;


type
  TForm1 = class(TForm)

    procedure FormCreate(Sender: TObject);

  public

    scene: TGLScene;
    cam: TGLCamera;
    cad: TGLCadencer;
    vp: TGLSceneViewer;
    at: TAsyncTimer;

    light: TGLLightSource;

    back: TGLHUDSprite;

    dc: TGLDummyCube;
    pln: TGLPlane;
    sph: TGLSphere;
    cube: TGLCube;

    shad: TGLShadowVolume;

    procedure CadProgress(Sender: TObject; const dt,nt: double);
    procedure vpMouseDown(Sender: TObject; but: TMouseButton;
      sh: TShiftState; X,Y: Integer);
    procedure Time(Sender: TObject);

  end;


var
  Form1: TForm1;

  m_pos: TPoint;
  m_move: boolean;


implementation


{$R *.dfm}


//                                                                   FormCreate
//
procedure TForm1.FormCreate(Sender: TObject);
begin

  scene := TGLScene.Create(self);

  cad := TGLCadencer.Create(self);
    cad.Scene := scene;
    cad.OnProgress := CadProgress;

  vp := TGLSceneViewer.Create(self);
    vp.Parent := self;
    vp.Buffer.BackgroundColor := $ffffff;
    vp.Buffer.ContextOptions := vp.Buffer.ContextOptions +
      [roNoColorBufferClear, roStencilBuffer];
    vp.Buffer.AntiAliasing := aa4x;
    vp.Align := alClient;
    vp.SendToBack;
    vp.OnMouseDown := vpMouseDown;

  back := TGLHUDSprite.CreateAsChild(scene.Objects);
    back.Width := Width;
    back.Height := Height;
    back.Position.SetPoint(Width div 2, Height div 2, 0);
    back.Material.Texture.Image.LoadFromFile('back.bmp');
    back.Material.Texture.Disabled := false;

  light := TGLLightSource.CreateAsChild(scene.Objects);
  light.Position.SetPoint(4, 10, 4);

  dc := TGLDummyCube.CreateAsChild(scene.Objects);

  sph := TGLSphere.CreateAsChild(dc);
    sph.Position.SetPoint(0.2, 1.2, 0);
    sph.Radius := 0.3;
    sph.Slices := 10;
    sph.Stacks := 8;

  cube := TGLCube.CreateAsChild(dc);
    cube.CubeDepth := 0.8;
    cube.CubeHeight := 0.1;
    cube.CubeWidth := 0.8;
    cube.Position.SetPoint(1, 0.2, 0);

  pln := TGLPlane.CreateAsChild(dc);
    pln.Direction.SetVector(0.3, 1, 0.1);
    pln.Width := 3;
    pln.Height := 4;

  cam := TGLCamera.CreateAsChild(dc);
    cam.Position.SetPoint(2, 3, 4);
    cam.FocalLength := 75;
    cam.TargetObject := dc;
    vp.Camera := cam;

  shad := TGLShadowVolume.CreateAsChild(dc);
    shad.Mode := svmDarkening;
    shad.Lights.AddCaster(light);
    shad.Occluders.AddCaster(sph);
    shad.Occluders.AddCaster(cube);

  at := TAsyncTimer.Create(form1);
    at.Interval := 500;
    at.OnTimer := Time;
    at.Enabled := true;

end;


//                                                                  cadProgress
//
procedure TForm1.CadProgress;
begin

  dc.turn(-dt * 10);

  if m_move then begin

    with mouse.CursorPos do
      cam.MoveAroundTarget((m_pos.Y - y) * 0.3, (m_pos.X - x) * 0.3);
    m_pos := mouse.CursorPos;

    // MouseUp
    if not iskeydown(vk_lbutton) then
      m_move := false;

    end;

end;


//                                                                    MouseDown
//
procedure TForm1.vpMouseDown;
begin

  m_pos := mouse.CursorPos;
  m_move := true;

end;


//                                                                        Timer
//
procedure TForm1.Time(Sender:TObject);
begin

  caption := 'runTime: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

end.

