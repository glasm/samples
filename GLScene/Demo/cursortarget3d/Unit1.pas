unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  GLScene, GLCadencer, GLObjects, GLGeomObjects, GLWin32Viewer, VectorGeometry,
  VectorTypes, tga, GLCoordinates, GLCrossPlatform, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    Camera: TGLCamera;
    Player: TGLDummyCube;
    Actor: TGLCone;
    cad: TGLCadencer;
    GLLightSource1: TGLLightSource;
    targ: TGLPlane;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

  m_pos: TPoint;
  m_look: boolean;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  cad.FixedDeltaTime := 1 / GetDeviceCaps(getDC(Handle), 116);

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    m: TPoint;
    v: TVector;
begin

  targ.Roll( deltatime * 50 );

  m := vp.ScreenToClient( mouse.CursorPos );
  vp.Buffer.ScreenVectorIntersectWithPlane(
    vectormake( m.X, vp.height - m.Y, 0 ),
    player.AbsolutePosition, player.AbsoluteUp, v );

  targ.AbsolutePosition := v;
  player.PointTo( v, player.AbsoluteUp );

end;

end.
