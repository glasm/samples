unit Unit1;

interface

uses
  SysUtils, Classes, Graphics, Forms, Controls,

  GLCadencer, GLWin32Viewer, GLScene, AsyncTimer, jpeg, GLObjects,
  GLVectorFileObjects, GLFile3DS, VectorGeometry, GLTexture,
  GLCoordinates, GLCrossPlatform, BaseClasses, GLRenderContextInfo;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    at: TAsyncTimer;
    ff: TGLFreeForm;
    dc_cam: TGLDummyCube;
    dogl: TGLDirectOpenGL;
    procedure atTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
  end;

  TTRS=record
    pos: TVector;
    rot,rotd,scale: single;
  end;

var
  Form1:TForm1;

  lst: array[0..99] of TTRS;


implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
var
    i: integer;
begin

  randomize;

  ff.LoadFromFile( 'horse.3ds' );
  ff.Scale.Scale( 2 / ff.BoundingSphereRadius );

  for i := 0 to high(lst) do begin
    setvector( lst[i].pos, round( random * 40 - 20 ), 0, round( random * 40 ));
    lst[i].rot := random( 100 );
    lst[i].rotd := random - 0.5;
    lst[i].scale := 1 + (random - 0.5) / 3;
  end;
  
end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dc_cam.Turn( deltatime * 10 );

end;


//
// doglRender
//
procedure TForm1.doglRender;
var
    i: integer;
    m: TMatrix;
begin

  m := ff.Matrix;
  
  for i := 0 to high(lst) do
    with lst[i] do
    if not isvolumeclipped( pos, scale, rci.rcci.frustum ) then begin
      ff.Matrix := m;
      ff.Position.SetPoint( pos );
      ff.Roll( rot );
      rot := rot + rotd * vp.LastFrameTime * 100;
      ff.Scale.Scale( scale );
      ff.Render(rci);
    end;

  ff.Matrix := m;
  
end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := 'MultiFreeForm: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

end.


