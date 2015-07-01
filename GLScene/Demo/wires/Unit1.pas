unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLObjects, GLWin32Viewer, GLCrossPlatform,
  VectorGeometry, GLCadencer, GLCoordinates, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    GLCube1: TGLCube;
    light: TGLLightSource;
    GLCube2: TGLCube;
    c11: TGLCube;
    c12: TGLCube;
    c13: TGLCube;
    c21: TGLCube;
    c22: TGLCube;
    c23: TGLCube;
    wire: TGLLines;
    cad: TGLCadencer;
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
  end;

var
  Form1: TForm1;

  lastpick,pick,select: TGLCustomSceneObject;


implementation

{$R *.dfm}

procedure TForm1.vpMouseMove;
begin

  pick := TGLCustomSceneObject( vp.Buffer.GetPickedObject( x, y ));

  if pick <> lastpick then begin

    if (lastpick <> nil) and (lastpick <> select) then
      lastpick.Material.FrontProperties.Emission.SetColor( 0, 0, 0, 1);

    if (pick <> nil) and (pick.Name[1] = 'c') then
      pick.Material.FrontProperties.Emission.SetColor( 1, 0, 0, 1);

    lastpick := pick;

  end;

  if pick <> nil then
    vp.cursor := -21
  else
    vp.cursor := 0;

end;


procedure TForm1.vpMouseDown;
begin

  if pick <> nil then begin
    select := pick;
    wire.Nodes[0].AsVector := select.AbsolutePosition;
    wire.Nodes[1].AsVector := wire.Nodes[0].AsVector;
    wire.visible := true;
  end;

end;


procedure TForm1.vpMouseUp;
begin

  if select <> nil then begin
    select.Material.FrontProperties.Emission.SetColor( 0, 0, 0, 1);
    select := nil;
    if pick = nil then
      wire.visible := false;
  end;

end;


procedure TForm1.cadProgress;
var
    v: TVector;
    p: TPoint;
begin

  if select <> nil then
    if (select <> nil) and (pick <> nil) and (select <> pick) then
      wire.Nodes[1].AsVector := pick.AbsolutePosition
    else begin
      p := screentoclient( mouse.CursorPos );
      vp.Buffer.ScreenVectorIntersectWithPlaneXZ(
        vectormake( p.x, clientheight - p.y, 0), 0, v);
      wire.Nodes[1].AsVector := v;
      end;

end;

end.
