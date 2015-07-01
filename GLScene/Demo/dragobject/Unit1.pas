unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,

  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLObjects,
  GLCoordinates, VectorGeometry;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    Scn: TGLSceneViewer;
    cam: TGLCamera;
    light: TGLLightSource;
    GLPlane1: TGLPlane;
    GLCube1: TGLCube;
    dc2: TGLDummyCube;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    dc1: TGLDummyCube;
    shad: TGLPlane;
    procedure ScnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ScnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  public

    LastPickPos: TVector;
    CurrentPick: TGLCustomSceneObject;

    function MouseWorldPos(X,Y: single; movingOnZ: boolean): TVector;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//
// mouse down
//
procedure TForm1.ScnMouseDown;
var
    pick: TGLBaseSceneObject;
begin

  pick := Scn.Buffer.GetPickedObject(X, Y) as TGLCustomSceneObject;

  if (pick <> nil) and (pick.Name <> 'GLCube1') then
    pick := nil;

  if pick <> CurrentPick then begin
    if CurrentPick <> nil then
      CurrentPick.Material.FrontProperties.Emission.SetColor( 0, 0, 0 );
    CurrentPick := TGLCustomSceneObject( pick );
    if CurrentPick <> nil then
      CurrentPick.Material.FrontProperties.Emission.SetColor( 1, 0, 0 );
  end;

  if CurrentPick <> nil then
    LastPickPos := CurrentPick.AbsolutePosition;

end;


//
// mouse move
//
procedure TForm1.ScnMouseMove;
var
    newPos,v: TVector;
begin

  if (not( ssLeft in Shift )) or (CurrentPick = nil) then exit;

  v := dc2.AbsoluteToLocal( MouseWorldPos( X, Y, ssShift in Shift ));
  v[0] := ClampValue( v[0], -15, 15 );
  v[1] := ClampValue( v[1], 0, 10 );
  v[2] := ClampValue( v[2], -15, 15 );

  CurrentPick.Position.SetPoint( v );

  v[1] := 0.1;
  shad.Position.SetPoint( v );

end;


//
// get mouse world pos
//
function TForm1.MouseWorldPos;
var
    v1,v2: TVector;
begin

  SetVector( Result, NullVector );
  if CurrentPick = nil then
    exit;

  SetVector( v1, X, Scn.Height - Y, 0 );

  if movingOnZ then begin
    v2 := dc2.AbsoluteToLocal( cam.AbsoluteVectorToTarget );
    v2[1] := 0;
    v2 := dc2.LocalToAbsolute( VectorNormalize( v2 ));
    Scn.Buffer.ScreenVectorIntersectWithPlane( v1, LastPickPos, v2, result )
  end
  else
    Scn.Buffer.ScreenVectorIntersectWithPlane(
      v1, LastPickPos, CurrentPick.LocalToAbsolute( YHmgVector ), result );

end;


//
// turn
//
procedure TForm1.TrackBar1Change;
begin

  dc2.TurnAngle := TrackBar1.Position + 45;

end;


//
// pitch
//
procedure TForm1.TrackBar2Change;
begin

  dc1.PitchAngle := TrackBar2.Position - 75;

end;

end.
