unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,

  GLFileASE, uDDSTex,

  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLCadencer,
  GLMaterial, GLCoordinates, GLObjects, GLVectorFileObjects, GLKeyboard,
  VectorGeometry, GLTexture, GLTextureFormat;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    dc_world: TGLDummyCube;
    ff1: TGLFreeForm;
    matLib: TGLMaterialLibrary;
    ff2: TGLFreeForm;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  public

    procedure togModel;

  end;

var
  Form1: TForm1;

  m_zoom: integer;

implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  setcursorpos( screen.Width div 2, screen.Height div 2 );

  DDStex( matlib, 'lmap', 'scn_lmap.dds' ).
    Material.Texture.TextureMode := tmModulate;
  DDStex( matlib, 'col300', 'tex1.dds', 'lmap' );
  DDStex( matlib, 'col210', 'tex2.dds', 'lmap'{, 2});
  DDStex( matlib, 'col120', 'tex3.dds', 'lmap' );
  DDStex( matlib, 'obj130', 'tex5.dds', 'lmap' );
  DDStex( matlib, 'obj240', 'tex4.dds', 'lmap' );

  ff1.MaterialLibrary := matlib;
  ff1.LoadFromFile( 'scn_lmap.ase' );
  ff1.Scale.Scale( 0.2 );

  DDStex(matlib, 'tex', 'scn_stex.dds'{, 1});

  ff2.LoadFromFile( 'scn_stex.ase' );
  ff2.Scale.Scale( 0.2 );
  ff2.Material.MaterialLibrary := matlib;
  ff2.Material.LibMaterialName := 'tex';

  togModel;

end;


//
// FormMouseWheel
//
procedure TForm1.FormMouseWheel;
begin

  inc(m_zoom, sign( WheelDelta ) * 4);

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  cam.AbsolutePosition := vectorsubtract( dc_cam.AbsolutePosition,
    vectorscale( cam.AbsoluteVectorToTarget,
      clampvalue( cam.DistanceToTarget - m_zoom * deltatime * 150, 5, 20 )));
  m_zoom := 0;

  with mouse.CursorPos do
    cam.MoveAroundTarget(( screen.Height div 2 - Y ) * 0.2 + cam.PitchAngle,
                          ( screen.Width div 2 - X ) * 0.2 );
  setcursorpos( screen.Width div 2, screen.Height div 2 );

  if iskeydown( vk_escape ) then close;

end;


//
// key down
//
procedure TForm1.FormKeyDown;
begin

  togModel;

end;


//
// mouse down
//
procedure TForm1.vpMouseDown;
begin

  togModel;

end;


//
// toggle model
//
procedure TForm1.togModel;
begin

  ff1.visible := not ff1.visible;
  ff2.visible := not ff2.visible;

  caption := 'LightMap:';
  if ff1.visible then
    caption := caption + '[texcoords + lightmapcoords, 6 DDS maps] '
  else
    caption := caption + '[single texcoords, 1 DDS map] ';

  caption := caption + ' / press any key to select single/multi texturing';

end;

end.
