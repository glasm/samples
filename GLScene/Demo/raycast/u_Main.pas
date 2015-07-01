unit u_Main;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, 
  StdCtrls, ExtCtrls, Buttons,

  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLVectorFileObjects,
  GLCadencer, GLObjects, GLCoordinates, VectorGeometry,

  u_Graph, GLFileOBJ;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    ff: TGLFreeForm;
    pts: TGLPoints;
    cad: TGLCadencer;
    Panel1: TPanel;
    Image1: TImage;
    Image5: TImage;
    fps_lbl: TLabel;
    ray1: TSpeedButton;
    ray2: TSpeedButton;
    Label1: TLabel;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure ray1Click(Sender: TObject);
  private

    graph: c_FPSGraph;

  end;

const
  ray_cnt = 4000;
  ray_start: TVector = (0, 2.5, 0, 0);

var
  Form1: TForm1;


implementation

{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
begin

  clientWidth := 1024;
  clientHeight := 512 + 48;

  ff.LoadFromFile('scn.obj');
  ff.Scale.Scale(4 / ff.BoundingSphereRadius);
  ff.BuildOctree(2);

  graph := c_FPSGraph.CreateAsChild(glscene1.Objects);
  graph.interval := 25;

  panel1.DoubleBuffered := true;

  ray1Click(ray1);

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dc.Turn(-deltatime * 10);

  fps_lbl.Caption := format('%.2f', [graph.fps]);

end;


//
// ray1Click
//
procedure TForm1.ray1Click;
var
    i: integer;
    v: TVector;

begin

  pts.Positions.Clear;

  for i := 1 to ray_cnt do begin

    SetVector( v, dc.LocalToAbsolute(VectorSubtract(
      vectormake( random*8 - 3, -2, random*8 - 4 ), ray_start )));

    if sender = ray1 then begin
      if ff.RayCastIntersect( ray_start, v, @v )then
        pts.Positions.Add(dc.AbsoluteToLocal( v ));
      end
    else
      if ff.OctreeRayCastIntersect( ray_start, v, @v )then
        pts.Positions.Add(dc.AbsoluteToLocal( v ));

    end;

end;

end.
