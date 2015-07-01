unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  jpeg,

  GLCadencer, GLCoordinates, GLScene, GLObjects, GLWin32Viewer, AsyncTimer,
  GLKeyboard, GLColor, GLMaterial, GLCrossPlatform, BaseClasses, GLGeomObjects,
  VectorGeometry;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    DummyCube1: TGLDummyCube;
    Earth: TGLSphere;
    Ring: TGLDummyCube;
    lamp: TGLLightSource;
    cam: TGLCamera;
    timer: TAsyncTimer;
    cad: TGLCadencer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure timerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  Form1: TForm1;
  fog: single = 0;

  clist: array of TGLCylinder;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
var
    i: integer;
    f1,f2: single;
begin

  setLength( clist, 256 );
  for i := 0 to high(clist) do begin

    clist[i] := TGLCylinder( ring.AddNewChild( TGLCylinder ));
    with clist[i].Material do begin
      FaceCulling := fcnocull;
      with FrontProperties do begin
        Diffuse.Color := clrbrightgold;
        Ambient.Color := clrblack;
        Emission.Color := clrgray50;
      end;
    end;
    clist[i].Slices := 32;
    clist[i].Height := 0.1;

    f1 := random(628) / 100;
    f2 := random(1000) / 5000;
    clist[i].Position.SetPoint(sin(f1) * (0.8 + f2), 0, cos(f1) * (0.8 + f2));
    clist[i].Scale.Scale( 0.05 );
    clist[i].TagFloat := 40 + random( 100 );
    clist[i].Pitch( clist[i].TagFloat * random( 100 ));
    clist[i].Roll( random( 1000 ));

  end;

end;


//
// resize
//
procedure TForm1.FormResize;
begin

  vp.FieldOfView := 145;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    i: integer;
begin

  lamp.ConstAttenuation :=
    clampValue( lamp.ConstAttenuation * (1 - deltatime), 1, 400);

  earth.Turn( -5 * deltatime );
  ring.Turn( 10 * deltatime );

  for i := 1 to high(clist) do
    clist[i].Pitch( clist[i].TagFloat * deltatime );

  if iskeydown(vk_escape) then
    close;

end;


//
// timer
//
procedure TForm1.timerTimer;
begin

  caption := 'Coins: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


//
// show
//
procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;

end.
