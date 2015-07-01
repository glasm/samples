unit uMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms,

  GLCrossPlatform, Controls,

  GLScene, GLObjects, GLCoordinates, GLWin32Viewer, BaseClasses,
  GLGeomObjects, GLGraph, GLCadencer, GLHUDObjects, GLMaterial, VectorGeometry,
  GLTeapot, AsyncTimer,

  uNCube;
  

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    GLXYZGrid1: TGLXYZGrid;
    GLXYZGrid2: TGLXYZGrid;
    dc_world: TGLDummyCube;
    GLTorus1: TGLTorus;
    GLLightSource1: TGLLightSource;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    GLCube3: TGLCube;
    GLCube4: TGLCube;
    dc_cam: TGLDummyCube;
    dc_utils: TGLDummyCube;
    cad: TGLCadencer;
    GLTeapot1: TGLTeapot;
    GLCone1: TGLCone;
    AsyncTimer1: TAsyncTimer;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure onActivate(Sender: TObject);
    procedure onDeactivate(Sender: TObject);
  end;

var
  Form1: TForm1;

  ncube: TGLNCube;


implementation

{$R *.dfm}


// setup
//
procedure TForm1.FormCreate(Sender: TObject);
begin

  ncube := TGLNCube.CreateAsChild( GLScene1.Objects );
  ncube.SceneViewer := vp;
  ncube.FPS := 30;

  application.OnActivate := onActivate;
  application.OnDeactivate := onDeactivate;

end;


// cadProgress
//
procedure TForm1.cadProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin

  if ncube.InactiveTime > 5 then begin
    if ncube.InactiveTime < 8 then
      dc_cam.TurnAngle := dc_cam.TurnAngle + (ncube.InactiveTime - 5) * deltatime * 2
    else
      dc_cam.TurnAngle := dc_cam.TurnAngle + deltatime * 6;
  end;

  vp.Refresh;

end;


// timer
//
procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  caption := 'naviCube: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


// show
//
procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;


procedure TForm1.onActivate(Sender: TObject);
begin

  cad.Enabled := true;

end;


procedure TForm1.onDeactivate(Sender: TObject);
begin

  cad.Enabled := false;

end;

end.
