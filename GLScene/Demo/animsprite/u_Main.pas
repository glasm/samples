unit u_Main;

interface

uses
  Windows, SysUtils, Classes, Forms, Controls,

  GLScene, GLCoordinates, GLWin32Viewer, GLCrossPlatform, BaseClasses,
  GLMaterial, GLObjects, GLHUDObjects, GLRenderContextInfo, GLGraph,
  GLAnimatedSprite, GLCadencer, VectorGeometry, GLGeomObjects,

  TGA;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    GLLightSource1: TGLLightSource;
    cam: TGLCamera;
    dc: TGLDummyCube;
    dogl: TGLDirectOpenGL;
    GLXYZGrid1: TGLXYZGrid;
    GLXYZGrid2: TGLXYZGrid;
    anisprt: TGLAnimatedSprite;
    matlib: TGLMaterialLibrary;
    cad: TGLCadencer;
    food: TGLCylinder;
    dc_food: TGLDummyCube;
    procedure FormCreate(Sender: TObject);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  Form1: TForm1;

  dt: double;

  cat_pos: TVector;
  cat_trg: TVector;
  cat_dir: TVector;


implementation


{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
begin

  randomize;
  setvector(cat_pos, 14 * random - 7, 1, 14 * random - 7);
  setvector(cat_trg, 14 * random - 7, 1, 14 * random - 7);
  dc_food.Position.SetPoint(cat_trg);
  setvector(cat_dir, vectornormalize(vectorsubtract(cat_trg, cat_pos)));

end;


//
// vpMouseDown
//
procedure TForm1.vpMouseDown;
begin

  vp.Buffer.ScreenVectorIntersectWithPlaneXZ(
    vectormake(x, vp.Height-y, 0), 1, cat_trg);
  cat_trg[0] := clampValue(cat_trg[0], -7, 7);
  cat_trg[2] := clampValue(cat_trg[2], -7, 7);
  dc_food.Position.SetPoint(cat_trg);

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dt := deltatime;
  vp.Invalidate;

end;


//
// doglRender
//
procedure TForm1.doglRender;
const
    c = 0.7071;
var
    v: TVector;
    a,dp: single;

  procedure setAnimation(i:integer; b:boolean = false);
  begin
    anisprt.AnimationIndex := i;
    anisprt.MirrorU := b;
    end;

begin

  v := vectorAdd(cat_pos, vectorscale(cat_dir, dt*3));
  if vectordistance(cat_pos, cat_trg) < 1 then begin
    setvector(cat_trg, 14 * random - 7, 1, 14 * random - 7);
    dc_food.Position.SetPoint(cat_trg);
    end;

  cat_dir :=
    vectorLerp(cat_dir, vectornormalize(vectorsubtract(cat_trg, cat_pos)), dt);
  addVector(cat_pos, vectorscale(cat_dir, 0.02));
  anisprt.Position.SetPoint(cat_pos);

  a := arccos(VectorAngleCosine(cat_dir, vectormake(-c, 0, -c))) *
    sign(vectordotproduct(cat_dir, vectormake(c, 0, -c))) / cPI * 4 + 4;

  case round(a) of
    1:setAnimation(3);        // left-down
    2:setAnimation(0);        // left
    3:setAnimation(1);        // left-up
    4:setAnimation(2);        // up
    5:setAnimation(1, true);  // right-up
    6:setAnimation(0, true);  // right
    7:setAnimation(3, true);  // right-down
    else setAnimation(4);     // down
    end;

  anisprt.Render(rci);

end;


end.
