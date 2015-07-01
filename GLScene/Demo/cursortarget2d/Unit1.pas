unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls,

  GLScene, GLObjects, GLHUDObjects, GLCadencer, GLWin32Viewer,
  GLCrossPlatform, GLCoordinates, BaseClasses, VectorGeometry;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    GLCamera1: TGLCamera;
    player: TGLHUDSprite;
    target: TGLHUDSprite;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  cad.FixedDeltaTime := 1 / GetDeviceCaps( getDC(Handle), VREFRESH );

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    p: TPoint;
    v: TVector;

  function getAngle(v:TVector): single;
  begin
    result := sign( vectordotproduct( v, vectormake( -1, 0, 0 ))) *
      arccos( vectordotproduct( v, vectormake( 0, -1, 0 ))) * 57.296;
  end;

begin

  p := screentoclient( mouse.CursorPos );
  target.Position.SetPoint( p.X, p.Y, 0 );
  target.Rotation := -newtime * 50;

  v := vectornormalize( vectorsubtract(target.AbsolutePosition,
                                       player.AbsolutePosition ));

  player.Position.Translate( vectorscale( v, deltatime * 50 ));
  player.Rotation := getAngle( v );

end;

end.
