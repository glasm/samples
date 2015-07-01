unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DateUtils,

  GLWin32Viewer, AsyncTimer, GLCrossPlatform, BaseClasses, GLScene,
  GLObjects, GLCoordinates, GLGeomObjects, GLState, GLGraph, GLCadencer;


type
  TForm1 = class(TForm)
    Panel1: TPanel;
    AsyncTimer1: TAsyncTimer;
    GLScene1: TGLScene;
    cam: TGLCamera;
    dc_cam: TGLDummyCube;
    GLCube1: TGLCube;
    light1: TGLLightSource;
    dc_light: TGLDummyCube;
    dc_world: TGLDummyCube;
    GLCylinder1: TGLCylinder;
    dc_views: TGLDummyCube;
    cam1: TGLCamera;
    cam2: TGLCamera;
    cam3: TGLCamera;
    GLSphere1: TGLSphere;
    pos_r: TImage;
    pos_t: TImage;
    pos_c: TImage;
    dc_helpers: TGLDummyCube;
    cam_grid: TGLXYZGrid;
    vp: TGLSceneViewer;
    Shape1: TShape;
    xy_grid: TGLXYZGrid;
    vp2: TGLSceneViewer;
    vp1: TGLSceneViewer;
    vp3: TGLSceneViewer;
    yz_grid: TGLXYZGrid;
    xz_grid: TGLXYZGrid;
    procedure FormResize(Sender: TObject);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure vp1BeforeRender(Sender: TObject);
    procedure vp1AfterRender(Sender: TObject);
    procedure vp2BeforeRender(Sender: TObject);
    procedure vp2AfterRender(Sender: TObject);
    procedure vp3BeforeRender(Sender: TObject);
    procedure vp3AfterRender(Sender: TObject);
  public

    procedure showScn(mv,v1,v2,v3: boolean);

  end;

type
  TScnMod = (scnTurn,scnMove);

var
  Form1: TForm1;

  xAlign: single = 0.5;
  yAlign: single = 0.5;

  scnMod: set of TScnMod;

  
implementation

{$R *.dfm}


// resize
//
procedure TForm1.FormResize(Sender: TObject);
var
    w,w2,h2: integer;
begin

  w := clientWidth - panel1.width;
  w2 := round((clientWidth - panel1.width) * xAlign);
  h2 := round(clientHeight * yAlign);

  vp1.BoundsRect := rect( 3, 3, w2 - 4, h2 - 4 );
  vp2.BoundsRect := rect( w2 + 3, 3, w - 4, h2 - 4 );
  vp3.BoundsRect := rect( 3, h2 + 3, w2 - 4, clientHeight - 4 );

  vp.BoundsRect := rect( w2 + 3, h2 + 3, w - 4, clientHeight - 4 );
  shape1.BoundsRect := rect( w2, h2, w - 1, clientHeight - 1 );

  pos_r.BoundsRect := rect( w2 - 4, 3, w2 + 3, clientHeight - 4 );
  pos_t.BoundsRect := rect( 3, h2 - 4, w - 4, h2 + 3 );
  pos_c.BoundsRect := rect( w2 - 4, h2 - 4, w2 + 3, h2 + 3 );

end;


// timer1
//
procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  if scnMod <> [] then begin

    if scnTurn in scnMod then begin



    end;

  end;
              

  glcube1.Position.Y := sin( GetTickCount / 1000 );
  glsphere1.Position.Z := cos( GetTickCount / 600 );

  vp.Refresh;
  vp1.Refresh;
  vp2.Refresh;
  vp3.Refresh;

end;


// showScn
//
procedure TForm1.showScn(mv,v1,v2,v3: boolean);
begin

  if not mv then begin
    glcube1.Material.PolygonMode := pmLines;
    glcylinder1.Material.PolygonMode := pmLines;
    glsphere1.Material.PolygonMode := pmLines;
    light1.Shining := false;
    cam_grid.visible := false;
  end else begin
    glcube1.Material.PolygonMode := pmFill;
    glcylinder1.Material.PolygonMode := pmFill;
    glsphere1.Material.PolygonMode := pmFill;
    light1.Shining := true;
    cam_grid.visible := true;
  end;

  xz_grid.Visible := v1;  
  xy_grid.Visible := v2;
  yz_grid.Visible := v3;

end;

procedure TForm1.vp1BeforeRender(Sender: TObject);
begin

  showScn(false, true, false, false);

end;

procedure TForm1.vp1AfterRender(Sender: TObject);
begin

  showScn(true, false, false, false);

end;

procedure TForm1.vp2BeforeRender(Sender: TObject);
begin

  showScn(false, false, true, false);

end;

procedure TForm1.vp2AfterRender(Sender: TObject);
begin

  showScn(true, false, false, false);

end;

procedure TForm1.vp3BeforeRender(Sender: TObject);
begin

  showScn(false, false, false, true);

end;

procedure TForm1.vp3AfterRender(Sender: TObject);
begin

  showScn(true, false, false, false);

end;

end.
