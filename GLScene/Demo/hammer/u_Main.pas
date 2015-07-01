unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLCadencer, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene,
  GLCoordinates, GLObjects, GLGeomObjects, VectorGeometry, VectorTypes,
  GLHUDObjects, GLBitmapFont, GLWindowsFont;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    GLSphere1: TGLSphere;
    light: TGLLightSource;
    GLCylinder1: TGLCylinder;
    dc_ham: TGLDummyCube;
    GLCylinder2: TGLCylinder;
    GLCube1: TGLCube;
    dc_targ: TGLDummyCube;
    hud_txt: TGLHUDText;
    wndfont: TGLWindowsBitmapFont;
    hud_txt2: TGLHUDText;
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  end;

var
  Form1: TForm1;

  h_spd: single = 0;
  h_move: boolean;
  h_score: integer = 0;


implementation

{$R *.dfm}


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    da,f: single;
    v: TVector;

  procedure updScore;
  var s: integer;
  begin
    s := round(h_spd * 1000);
    if s > 300 then begin
      if s > h_score then begin
        h_score := s;
        hud_txt.Text := inttostr(s);
        end;
      hud_txt2.Text := inttostr(s);
      end;
    end;

begin

  if h_move then begin

    with vp.ScreenToClient(mouse.CursorPos) do
      setvector(v, X, vp.Height - Y, 0);
    vp.Buffer.ScreenVectorIntersectWithPlane(
      v, dc_ham.AbsolutePosition, dc_ham.AbsoluteDirection, v);
    dc_targ.AbsolutePosition := v;

    v := VectorSubtract(v, dc_ham.AbsolutePosition);
    da := arccos(VectorAngleCosine(dc_ham.AbsoluteLeft, v)) / 1.5708 - 1;

    f := dc_ham.RollAngle + Lerp(0, -da * 57, deltatime * 8);
    h_spd := dc_ham.RollAngle - f;
    if f < -60 then h_spd := 0;

    end
  else begin

    h_spd := h_spd + deltatime * 2;
    f := dc_ham.RollAngle - h_spd;

    if f < -60 then updScore;
    if (f < -60) or (f > 0) then h_spd := 0;

    end;

  dc_ham.RollAngle := ClampValue(f, -60, 0);

end;


//
// vpMouseMove
//
procedure TForm1.vpMouseMove;
var
  obj: TGLBaseSceneObject;

begin

  obj := vp.Buffer.GetPickedObject(x,y);
  if obj = GLCube1 then vp.Cursor := -21
    else vp.Cursor := 0;

end;


//
// vpMouseDown
//
procedure TForm1.vpMouseDown;
var
  obj: TGLBaseSceneObject;

begin

  obj := vp.Buffer.GetPickedObject(x,y);
  if obj = GLCube1 then
    h_move := true;

end;


//
// vpMouseUp
//
procedure TForm1.vpMouseUp;
begin

  h_move := false;

end;


//
// FormResize
//
procedure TForm1.FormResize(Sender: TObject);
begin

  hud_txt.Position.X := vp.Width - 20;
  hud_txt2.Position.X := vp.Width - 22;

end;

end.
