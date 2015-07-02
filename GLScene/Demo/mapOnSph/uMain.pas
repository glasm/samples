unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLCoordinates,
  GLObjects, GLMaterial, GLMesh, jpeg, VectorGeometry, VectorTypes;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    dc_world: TGLDummyCube;
    cam: TGLCamera;
    sph: TGLSphere;
    light: TGLLightSource;
    seg: TGLMesh;
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
  public

    procedure genSegment(m:TGLMesh);

  end;

var
  Form1: TForm1;

  m_turnmode: boolean = false;
  m_oldpos: TPoint;


implementation

{$R *.dfm}


//
// FormCreate
//
procedure TForm1.FormCreate;
begin

  genSegment(seg);

end;


//
// createSegment
//
procedure TForm1.genSegment(m:TGLMesh);
var
  i,j,k: integer;

  procedure addQuad(a,b:integer;d:integer=1);
    function getData(da,db:single):TVertexData;
    begin
      result.textCoord.S := da / 360;
      result.textCoord.T := 1 - (db + 90) / 180;
      da := (360-da) / 57.29578;
      db := db / 57.29578;
      result.coord[0] := (sph.Radius + 0.01)*cos(db)*cos(da);
      result.coord[2] := (sph.Radius + 0.01)*cos(db)*sin(da);
      result.coord[1] := (sph.Radius + 0.01)*sin(db);
      result.normal := {vectorNormalize(}result.coord;
      end;
  begin
    m.Vertices.AddVertex(getData(a,b));
    m.Vertices.AddVertex(getData(a,b+d));
    m.Vertices.AddVertex(getData(a+d,b+d));
    m.Vertices.AddVertex(getData(a+d,b));
    end;

begin

  m.Vertices.Clear;

  k := 3;
  i := 90;
  while i < 180 do begin
    j := 90;
    while j < 180 do begin
      addQuad(i,j,k);
      inc(j,k);
    end;
    inc(i,k);
  end;

{  for i := 90 to 179 do
    for j := 90 to 179 do
      addQuad(i,j,1);}

end;


//
//  vpMouseDown
//
procedure TForm1.vpMouseDown;
begin

  m_turnmode := true;
  m_oldpos := mouse.CursorPos;
  mouse.CursorPos := point(screen.Width div 2, screen.Height div 2);
  showCursor(false);

end;


//
// vpMouseUp
//
procedure TForm1.vpMouseUp;
begin

  m_turnmode := false;
  mouse.CursorPos := m_oldpos;
  showCursor(true);

end;


//
// vpMouseMove
//
procedure TForm1.vpMouseMove;
begin

  if not m_turnmode then
    exit;

  cam.MoveAroundTarget( (screen.Height div 2 - mouse.CursorPos.Y) * 0.2,
    (screen.Width div 2 - mouse.CursorPos.X) * 0.2 );

  mouse.CursorPos := point(screen.Width div 2, screen.Height div 2);

  vp.Repaint;

end;

end.
