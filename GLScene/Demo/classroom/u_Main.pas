unit u_Main;

interface

uses
  Windows, SysUtils, Classes, Forms, Controls,

  u_MatUtils, GLFile3DS,

  GLScene, GLCoordinates, GLWin32Viewer, GLCrossPlatform, BaseClasses,
  GLObjects, GLRenderContextInfo, GLCadencer, VectorGeometry, GLGeomObjects,
  GLVectorFileObjects;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    GLLightSource1: TGLLightSource;
    cam: TGLCamera;
    dc_trg: TGLDummyCube;
    dogl: TGLDirectOpenGL;
    cad: TGLCadencer;
    dc_room: TGLDummyCube;
    dc_mons: TGLDummyCube;
    GLCube1: TGLCube;
    GLCube2: TGLCube;
    GLCube3: TGLCube;
    procedure FormCreate(Sender: TObject);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
  end;

const
  upd_deltatime = 0.75;

var
  Form1: TForm1;

  ff_mon: TGLFreeForm;
  ff_scrn_lst: array[0..7] of TGLFreeForm;


implementation


{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
var
    i: integer;

begin

  ff_mon := TGLFreeForm.CreateAsChild(dogl);
  ff_mon.LoadFromFile('mon.3ds');
  ff_mon.Direction.SetVector(0, 1, 0);
  ff_mon.Visible := false;

  randomize;
  for i := 0 to high(ff_scrn_lst) do begin

    ff_scrn_lst[i] := TGLFreeForm.CreateAsChild(dc_mons);
    ff_scrn_lst[i].LoadFromFile('screen.3ds');
    ff_scrn_lst[i].Direction.SetVector(0, 1, 0);
    ff_scrn_lst[i].TagFloat := -(random * 4 + 2);

    loadTex(ff_scrn_lst[i], '0.jpg');

    if i < 3 then begin
      ff_scrn_lst[i].Position.SetPoint(-10, 0, 6 - 6*i);
      ff_scrn_lst[i].Roll(-90);
      end
    else if i < 5 then begin
      ff_scrn_lst[i].Position.SetPoint(3 - 6*(i-3), 0, -14);
      end
    else begin
      ff_scrn_lst[i].Position.SetPoint(10, 0, 6 - 6*(i-5));
      ff_scrn_lst[i].Roll(90);
      end;

    end;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    i: integer;
    f: single;

begin

  for i := 0 to high(ff_scrn_lst) do begin

    f := ff_scrn_lst[i].TagFloat + deltatime / (upd_deltatime + 0.001);

    if (f > 0) and (floor(ff_scrn_lst[i].TagFloat) <> floor(f)) then
      loadTex(ff_scrn_lst[i], format('%d.jpg', [floor(f) mod 4+1]));
      
    ff_scrn_lst[i].TagFloat := f;

    end;

end;


//
// doglRender
//
procedure TForm1.doglRender;
var
    i: integer;

begin

  for i := 0 to high(ff_scrn_lst) do begin
    ff_mon.Matrix := ff_scrn_lst[i].Matrix;
    ff_mon.Render(rci);
    end;

end;


end.
