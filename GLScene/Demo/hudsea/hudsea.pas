unit hudsea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  GLCadencer, GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, TGA,
  GLHUDObjects, GLObjects, GLCoordinates, GLTexture, AsyncTimer;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    GLCamera1: TGLCamera;
    ship: TGLHUDSprite;
    sea: TGLHUDSprite;
    at: TAsyncTimer;
    procedure FormResize(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure atTimer(Sender: TObject);
  end;

var
  Form1: TForm1;

  sea_tiles: array[0..10] of TGLTexture;
  sea_curtile: integer;


implementation

{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
var
    i: integer;
begin

  for i := 0 to high( sea_tiles ) do begin
    sea_tiles[i] := TGLTexture.Create( self );
    sea_tiles[i].Disabled := false;
    sea_tiles[i].Image.LoadFromFile( inttostr( i + 1 ) + '.bmp' );
    end;

  sea_curtile := 0;
  sea.Material.Texture := sea_tiles[ sea_curtile ];

  clientWidth := 500;
  clientHeight := 500;

end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := 'HUD Sea: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
const
    vw = 1 / 10; // frequency
begin

  sea.TagFloat := sea.TagFloat + deltatime;
  if sea.TagFloat > vw then begin
    sea.TagFloat := frac( sea.TagFloat / vw ) * vw;
    sea_curtile := (sea_curtile + 1) mod length( sea_tiles );
    sea.Material.Texture := sea_tiles[ sea_curtile ];
    end;

  ship.Position.SetPoint( vp.Width div 2 - 150 * sin( newtime / 5 ),
                          vp.Height div 2 + 150 * cos( newtime / 5 ), 0 );
  ship.Rotation := 90 - (newtime / 5) * 180 / PI;

end;


//
// resize
//
procedure TForm1.FormResize;
begin

  sea.Position.SetPoint( vp.Width div 2, vp.Height div 2, 0 );
  ship.Position.SetPoint( vp.Width div 2, vp.Height div 2, 0 );

end;

end.
