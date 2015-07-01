unit u_Main;

interface

uses
  SysUtils, Classes, Controls, Forms, ComCtrls, ExtCtrls, StdCtrls,

  GLWin32Viewer, GLCrossPlatform, GLScene, GLState, GLObjects, GLGeomObjects,
  GLCadencer, GLExtrusion, VectorGeometry, VectorTypes, GeometryBB, GLFile3DS,
  GLVectorFileObjects, GLCoordinates, BaseClasses, GLRenderContextInfo,

  u_Frame, AsyncTimer;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    Panel1: TPanel;
    Panel2: TPanel;
    treeView: TTreeView;
    Splitter1: TSplitter;
    cam: TGLCamera;
    dc_world: TGLDummyCube;
    dc_models: TGLDummyCube;
    dc_cam: TGLDummyCube;
    light: TGLLightSource;
    cad: TGLCadencer;
    GLCube1: TGLCube;
    GLFrustrum1: TGLFrustrum;
    _barrel: TGLRevolutionSolid;
    barrel_1: TGLProxyObject;
    barrel_2: TGLProxyObject;
    barrel_3: TGLProxyObject;
    Panel3: TPanel;
    GLSphere1: TGLSphere;
    sys_dogl: TGLDirectOpenGL;
    dc_scene: TGLDummyCube;
    axis_lines: TGLLines;
    bb_lines: TGLLines;
    GLCube2: TGLCube;
    cube: TGLCube;
    ff: TGLFreeForm;
    frame: TFrame1;
    Memo1: TMemo;
    at: TAsyncTimer;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure treeViewChange(Sender: TObject; Node: TTreeNode);
    procedure sys_doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure vpMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure atTimer(Sender: TObject);
  public

    pick: TGLBaseSceneObject;

    procedure updTreeView;
    procedure addBBox;
    procedure updBBox;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
begin

  vp.Buffer.RenderingContext.Activate;

  updTreeView;

  ff.LoadFromFile('column.3ds');
  ff.Scale.Scale(1.5 / ff.BoundingSphereRadius);

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  dc_scene.Turn(deltatime * 10);

  cube.Roll(75 * deltatime * sin(newtime));
  cube.Turn(deltatime * 50);

end;


//
// tvChange
//
procedure TForm1.treeViewChange;
begin

  pick := TGLBaseSceneObject(node.Data);

  panel3.Caption := pick.name + ': ' + pick.classname;

  frame.ShowParams;

end;


//
// vpMouseDown
//
procedure TForm1.vpMouseDown;
var
    newpick: TGLBaseSceneObject;
    
begin

  newpick := vp.Buffer.GetPickedObject(x,y);
  if newpick is TGLLines then
    exit;

  if newpick = nil then
    treeView.Select(treeView.Items[0])
  else
    treeView.Select(TTreeNode(newpick.TagObject));

end;


//
// updTreeView
//
procedure TForm1.updTreeView;

  procedure GetObject(pnode:TTreeNode; obj:TGLBaseSceneObject);
  var
      a1: integer;
      node: TTreeNode;
  begin

    node := treeView.Items.AddChildObject(pnode, obj.Name, obj);
    obj.TagObject := node;
    for a1 := 0 to obj.Count - 1 do
      GetObject(node, obj.Children[a1]);

    end;

begin

  treeView.Items.Clear;
  GetObject(treeView.TopItem, dc_scene);

end;


//
// updBBox
//
procedure TForm1.updBBox;
var
  v1,v2: TVector3f;

begin

  if pick = nil then exit;

  if bb_lines.Nodes.Count = 0 then addBBox;

  bb_lines.Matrix := pick.AbsoluteMatrix;
  if pick is TGLFreeForm then
    with TGLFreeForm(pick) do begin

      MeshObjects.GetExtents(v1, v2);
      v1 := VectorTransform(v1, pick.Matrix);
      v2 := VectorTransform(v2, pick.Matrix);
      bb_lines.Position.SetPoint(vectorlerp(v1, v2, 0.5));
      bb_lines.Scale.SetVector(pick.BoundingBox(false)[0]);
      bb_lines.Scale.Scale(2);

      end
    else begin

      bb_lines.Scale.SetVector(pick.BoundingBox(false)[0]);
      bb_lines.Scale.Scale(2.1);

      end;

  axis_lines.Matrix := pick.AbsoluteMatrix;

end;


//
// addBBox
//
procedure TForm1.addBBox;
const
  c = 0.5;
  d = 0.3;
  
begin

  with bb_lines.Nodes do begin

    AddNode(c,c,c);AddNode(c,c,d);AddNode(c,c,-c);AddNode(c,c,-d);
    AddNode(-c,c,c);AddNode(-c,c,d);AddNode(-c,c,-c);AddNode(-c,c,-d);
    AddNode(c,-c,c);AddNode(c,-c,d);AddNode(c,-c,-c);AddNode(c,-c,-d);
    AddNode(-c,-c,c);AddNode(-c,-c,d);AddNode(-c,-c,-c);AddNode(-c,-c,-d);

    AddNode(c,c,c);AddNode(c,d,c);AddNode(c,-c,c);AddNode(c,-d,c);
    AddNode(-c,c,c);AddNode(-c,d,c);AddNode(-c,-c,c);AddNode(-c,-d,c);
    AddNode(c,c,-c);AddNode(c,d,-c);AddNode(c,-c,-c);AddNode(c,-d,-c);
    AddNode(-c,c,-c);AddNode(-c,d,-c);AddNode(-c,-c,-c);AddNode(-c,-d,-c);

    AddNode(c,c,c);AddNode(d,c,c);AddNode(-c,c,c);AddNode(-d,c,c);
    AddNode(c,-c,c);AddNode(d,-c,c);AddNode(-c,-c,c);AddNode(-d,-c,c);
    AddNode(c,c,-c);AddNode(d,c,-c);AddNode(-c,c,-c);AddNode(-d,c,-c);
    AddNode(c,-c,-c);AddNode(d,-c,-c);AddNode(-c,-c,-c);AddNode(-d,-c,-c);

    end;

end;


//
// sys_doglRender
//
procedure TForm1.sys_doglRender;
begin

  if pick <> nil then begin

    rci.GLStates.DepthFunc := cfAlways;

    updBBox;
    axis_lines.Render(rci);
    bb_lines.Render(rci);

    end;

end;


//
// atTimer
//
procedure TForm1.atTimer;
begin

  caption := 'SceneNavigator / ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

end.
