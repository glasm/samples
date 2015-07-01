unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  GLCadencer, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene,
  GLCoordinates, GLObjects, GLGeomObjects, GLHUDObjects, GLKeyboard,
  mmSystem, VectorTypes, VectorGeometry, GLMaterial, ExtCtrls;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc_cam: TGLDummyCube;
    dc_targets: TGLDummyCube;
    back: TGLPlane;
    trg1: TGLPlane;
    trg11: TGLDisk;
    trg12: TGLDisk;
    trg13: TGLDisk;
    trg14: TGLDisk;
    trg2: TGLPlane;
    trg21: TGLDisk;
    GLDisk2: TGLDisk;
    GLDisk3: TGLDisk;
    GLDisk4: TGLDisk;
    GLPlane2: TGLPlane;
    GLDisk5: TGLDisk;
    GLDisk6: TGLDisk;
    GLDisk7: TGLDisk;
    GLDisk8: TGLDisk;
    dc_cursor: TGLDummyCube;
    ctop: TGLHUDSprite;
    cbot: TGLHUDSprite;
    cright: TGLHUDSprite;
    cleft: TGLHUDSprite;
    cur: TGLHUDSprite;
    dc_world: TGLDummyCube;
    pleft: TGLPlane;
    GLLightSource1: TGLLightSource;
    pright: TGLPlane;
    ptop: TGLPlane;
    pbot: TGLPlane;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

  fire: Boolean = false;


implementation

{$R *.dfm}
{$R audio.res}


//
// setup
//
procedure TForm1.FormCreate;
begin

  clientWidth := 960;
  clientHeight := 600;

  randomize;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    m: TPoint;
    isz: Boolean;
    fov: Single;
    obj: TGLBaseSceneObject;
    t: TVector3f;
    p: TVector;
begin

  m := vp.ScreenToClient( Mouse.CursorPos );

  // cursor
  cur.Position.SetPoint( m.X, m.Y, 0 );
  ctop.Position.SetPoint( m.X, m.Y - 20, 0 );
  cbot.Position.SetPoint( m.X, m.Y + 20, 0 );
  cleft.Position.SetPoint( m.X - 20, m.Y, 0 );
  cright.Position.SetPoint( m.X + 20, m.Y, 0 );

  // zoom
  isz := iskeydown( VK_RBUTTON );
  fov := cam.FocalLength;
  if isz and ( fov < 280 ) then
    fov := fov + ( 280 - fov ) / 12
  else
    fov := fov - ( fov - 90 ) / 4;
  cam.FocalLength := fov;

  // fire
  if iskeydown( VK_LBUTTON ) and Active then begin
    if not fire then begin

      fire := true;
      playSound( 'fire', 0, SND_ASYNC or SND_MEMORY or SND_RESOURCE );

      RandomPointOnSphere( t );
      m.X := m.X + trunc( t[0] * 1500 / fov );
      m.Y := m.Y + trunc( t[1] * 1500 / fov );

      obj := vp.Buffer.GetPickedObject( m.X, m.Y );
      if obj = nil then exit;

      obj.RayCastIntersect( cam.AbsolutePosition,
        vectormake( vp.Buffer.PixelRayToWorld( m.X, m.Y )), @p );
      with TGLSphere.CreateAsChild( dc_world ) do begin

        Position.SetPoint( p );
        Radius := 0.1;
        Material.FrontProperties.Diffuse.SetColor( 1, 0, 0 );
        Material.MaterialOptions := [ moNoLighting ]

        end;

    end;
  end else
    fire := false;

  if iskeydown( 27 ) then
    close;

end;

end.
