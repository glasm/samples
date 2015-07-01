{$APPTYPE CONSOLE} 

unit u_Main;

interface

uses 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Dialogs,

  GLScene, GLCrossPlatform, Controls, GLObjects, GLCadencer, GLWin32Viewer,
  GLKeyboard, VectorGeometry, GLVectorFileObjects, GLFile3DS, GLMaterial,
  GLTexture, GLCoordinates, BaseClasses, GLFBORenderer, GLRenderContextInfo,
  AsyncTimer, GLGeomObjects,

  uLog, uDDStex;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc_world: TGLDummyCube;
    dc_cam: TGLDummyCube;
    ff: TGLFreeForm;
    matlib: TGLMaterialLibrary;
    cam_m: TGLCamera;
    fbo: TGLFBORenderer;
    dc_targ: TGLDummyCube;
    GLLines1: TGLLines;
    at: TAsyncTimer;
    ff_monster: TGLFreeForm;
    GLLines2: TGLLines;
    GLPlane1: TGLPlane;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fboBeforeRender(Sender: TObject;
      var rci: TRenderContextInfo);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  public

    procedure loadData;
    procedure addCamGeom;

  end;

var
  Form1: TForm1;

  m_pos: TPoint;
  m_turn: boolean;
  

implementation

{$R *.dfm}


//
// formCreate
//
procedure TForm1.FormCreate;
begin

  log_tick;

  loadData;
  addCamGeom;

  log( 'form create:', 10 );
  log( format( '%.3f sec', [ log_delta ]));

end;


//
// loadData
//
procedure TForm1.loadData;
begin

  SetCurrentDir('data');

  log('textures:', 10);

  DDStex( matlib, 'details', 'details.dds' );
  DDStex( matlib, 'texture', 'texture.dds', 'details' );
  DDStex( matlib, 'logo', 'logo.dds' );
  DDStex( matlib, 'monster', 'monster.dds' );


  log('models:', 10);

  log('scn.3ds');
  ff.LoadFromFile('scn.3ds');
  ff.MeshObjects[0].FaceGroups[0].MaterialName := 'monitor';
  ff.MeshObjects[1].FaceGroups[0].MaterialName := 'texture';
  ff.MeshObjects[2].FaceGroups[0].MaterialName := 'logo';
  ff.MaterialLibrary := matlib;

  log('monster.3ds');
  ff_monster.LoadFromFile('monster.3ds');
  ff_monster.Scale.Scale( 1 / ff_monster.BoundingSphereRadius );
  ff_monster.MeshObjects[0].FaceGroups[0].MaterialName := 'monster';
  ff_monster.MaterialLibrary := matlib;


  log('uploading...', 14);
  vp.Buffer.Render;

end;


//
// cadProcess
//
procedure TForm1.cadProgress;
begin

  if m_turn then begin
    dc_cam.Turn((mouse.CursorPos.x - screen.Width div 2) * 0.2);
    cam.PitchAngle := clampValue(
      cam.PitchAngle + (screen.Height div 2 - mouse.CursorPos.y) * 0.2, -89, 89);
    mouse.CursorPos := point( screen.Width div 2, screen.Height div 2 );
    if not iskeydown(vk_rbutton) then
      m_turn := false;
  end;

  if iskeydown(ord('W')) then dc_cam.Move(-deltatime * 10);
  if iskeydown(ord('S')) then dc_cam.Move(deltatime * 10);
  if iskeydown(ord('A')) then dc_cam.Slide(deltatime * 5);
  if iskeydown(ord('D')) then dc_cam.Slide(-deltatime * 5);

  dc_targ.AbsolutePosition :=
    vectorlerp(dc_targ.AbsolutePosition, dc_cam.AbsolutePosition, deltatime);
  GLLines2.AbsoluteDirection := cam_m.AbsoluteVectorToTarget;
  GLLines2.Up.Y := 1;

  if iskeydown(vk_escape) then close;

end;


//
// fps
//
procedure TForm1.atTimer;
begin

  caption := 'Camera: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


//
// activate
//
procedure TForm1.FormShow;
begin

  cad.Enabled := true;

end;


//
// fbo init
//
procedure TForm1.fboBeforeRender;
begin

  GLLines2.Visible := not GLLines2.Visible;
  ff_monster.Visible := not ff_monster.Visible;

end;


//
// addCamGeom
//
procedure TForm1.addCamGeom;
const // camera
  csegs: array[0..635] of single = (
-1,2,1,1,2,1,1,2,1,1,2,-1,1,2,-1,-1,2,-1,-1,2,-1,-0.4,1,-0.4,-0.4,1,-0.4,0.4,
1,-0.4,0.4,1,-0.4,0.4,1,0.4,0.4,1,0.4,-0.4,1,0.4,-0.4,1,0.4,-0.4,1,-0.4,0.4,
-2.4,-0.3,0.4,-1.6,0.8,0.4,-1.6,0.8,-0.4,-1.6,0.8,-0.4,-1.6,0.8,-0.4,-2.4,-0.3,
0.4,-0.3,0.8,-0.4,-0.3,0.8,-0.4,-0.3,0.8,-0.4,-1.6,0.8,0.4,0,0.4,-0.4,0,0.4,
-0.4,0,0.4,-0.4,-0.3,0.8,0.4,0,-0.4,-0.4,0,-0.4,-0.4,0,-0.4,-0.4,1,-0.4,0.4,
-0.3,-0.7,-0.4,-0.3,-0.7,-0.4,-0.3,-0.7,-0.4,0,-0.4,0.4,-2.2,-0.7,-0.4,-2.2,
-0.7,-0.4,-2.2,-0.7,-0.4,-0.3,-0.7,0.4,-2.4,-0.3,-0.4,-2.4,-0.3,-0.4,-2.4,-0.3,
-0.4,-2.2,-0.7,-0.3,-1.58297,2.34174,-0.3,-1.85114,1.9608,-0.3,-1.16025,2.53757,
-0.3,-1.58297,2.34174,-0.3,-0.696253,2.4958,-0.3,-1.16025,2.53757,-0.3,-0.315305,
2.22762,-0.3,-0.696253,2.4958,-0.3,-0.119481,1.8049,-0.3,-0.315305,2.22762,
-0.3,-0.161252,1.3409,-0.3,-0.119481,1.8049,-0.3,-0.429426,0.959957,-0.3,-0.161252,
1.3409,-0.3,-0.852146,0.764133,-0.3,-0.429426,0.959957,-0.3,-1.31614,0.805904,
-0.3,-0.852146,0.764133,-0.3,-3.16054,1.61385,-0.3,-3.42961,1.23353,-0.3,-2.73736,
1.80868,-0.3,-3.16054,1.61385,-0.3,-2.27346,1.76582,-0.3,-2.73736,1.80868,-0.3,
-1.89315,1.49675,-0.3,-2.27346,1.76582,-0.3,-1.69831,1.07358,-0.3,-1.89315,1.49675,
-0.3,-1.74117,0.609677,-0.3,-1.69831,1.07358,-0.3,-2.01024,0.229359,-0.3,-1.74117,
0.609677,-0.3,-2.43342,0.0345264,-0.3,-2.01024,0.229359,-0.3,-2.89731,0.0773855,
-0.3,-2.43342,0.0345264,-0.3,-3.27763,0.346452,-0.3,-2.89731,0.0773855,0.3,
-1.31614,0.805904,0.3,-0.852146,0.764133,0.3,-0.852146,0.764133,0.3,-0.429426,
0.959957,0.3,-0.429426,0.959957,0.3,-0.161252,1.3409,0.3,-0.161252,1.3409,0.3,
-0.119481,1.8049,0.3,-0.119481,1.8049,0.3,-0.315305,2.22762,0.3,-0.315305,2.22762,
0.3,-0.696253,2.4958,0.3,-0.696253,2.4958,0.3,-1.16025,2.53757,0.3,-1.16025,
2.53757,0.3,-1.58297,2.34174,0.3,-1.58297,2.34174,0.3,-1.85114,1.9608,0.3,-1.85114,
1.9608,-0.3,-1.85114,1.9608,-0.3,-1.85114,1.9608,-0.3,-1.89292,1.4968,0.3,-3.47247,
0.769629,0.3,-3.27763,0.346452,0.3,-3.27763,0.346452,0.3,-2.89731,0.0773856,0.3,
-2.89731,0.0773856,0.3,-2.43342,0.0345264,0.3,-2.43342,0.0345264,0.3,-2.01024,
0.229359,0.3,-2.01024,0.229359,0.3,-1.74117,0.609677,0.3,-1.74117,0.609677,0.3,
-1.69831,1.07358,0.3,-1.69831,1.07358,0.3,-1.89292,1.4968,0.3,-1.89292,1.4968,
0.3,-2.27346,1.76582,0.3,-2.27346,1.76582,0.3,-2.73736,1.80868,0.3,-2.73736,
1.80868,0.3,-3.16054,1.61385,0.3,-3.16054,1.61385,0.3,-3.42961,1.23353,0.3,-3.42961,
1.23353,-0.3,-3.42961,1.23353,-0.3,-3.42961,1.23353,-0.3,-3.47247,0.769629,-0.3,
-3.47247,0.769629,0.3,-3.47247,0.769629,-1,2,-1,-1,2,1,1,2,-1,0.4,1,-0.4,1,2,1,
0.4,1,0.4,-1,2,1,-0.4,1,0.4,-0.4,-2.4,-0.3,0.4,-2.4,-0.3,0.4,-1.6,0.8,0.4,-0.3,
0.8,0.4,-0.3,0.8,0.4,0,0.4,0.4,0,0.4,0.4,1,0.4,0.4,1,-0.4,0.4,0,-0.4,0.4,0,-0.4,
0.4,-0.3,-0.7,0.4,-0.3,-0.7,0.4,-2.2,-0.7,0.4,-2.2,-0.7,0.4,-2.4,-0.3,0.3,-1.85114,
1.9608,0.3,-1.89292,1.4968,0.3,-1.58297,2.34174,-0.3,-1.58297,2.34174,0.3,-1.16025,
2.53757,-0.3,-1.16025,2.53757,0.3,-0.696253,2.4958,-0.3,-0.696253,2.4958,0.3,
-0.315305,2.22762,-0.3,-0.315305,2.22762,0.3,-0.119481,1.8049,-0.3,-0.119481,1.8049,
0.3,-0.161252,1.3409,-0.3,-0.161252,1.3409,0.3,-0.429426,0.959957,-0.3,-0.429426,
0.959957,0.3,-0.852146,0.764133,-0.3,-0.852146,0.764133,0.3,-1.31614,0.805904,
-0.3,-1.31614,0.805904,-0.3,-1.69831,1.07358,-0.3,-1.31614,0.805904,0.3,-3.42961,
1.23353,0.3,-3.47247,0.769629,0.3,-3.16054,1.61385,-0.3,-3.16054,1.61385,0.3,
-2.73736,1.80868,-0.3,-2.73736,1.80868,0.3,-2.27346,1.76582,-0.3,-2.27346,1.76582,
0.3,-1.89292,1.4968,-0.3,-1.89315,1.49675,0.3,-1.69831,1.07358,-0.3,-1.69831,
1.07358,0.3,-1.74117,0.609677,-0.3,-1.74117,0.609677,0.3,-2.01024,0.229359,-0.3,
-2.01024,0.229359,0.3,-2.43342,0.0345264,-0.3,-2.43342,0.0345264,0.3,-2.89731,
0.0773856,-0.3,-2.89731,0.0773855,0.3,-3.27763,0.346452,-0.3,-3.27763,0.346452,
-0.3,-3.47247,0.769629,-0.3,-3.27763,0.346452,-0.4,1,0.4,-0.4,0,0.4,0.3,-1.69831,
1.07358,0.3,-1.31614,0.805904,0.4,0,0.4,0.4,0,-0.4,-0.4,0,0.4,-0.4,0,-0.4);
var
    i: integer;
begin

  for i := 0 to length(csegs) div 3 - 1 do
    GLLines2.Nodes.AddNode( csegs[i * 3], csegs[i * 3 + 2], csegs[i * 3 + 1] );

end;


//
// rotation
//
procedure TForm1.vpMouseDown;
begin

  if button = mbRight then begin
    m_turn := true;
    mouse.CursorPos := point( screen.Width div 2, screen.height div 2 );
  end;

end;


//
// resize
//
procedure TForm1.FormResize;
begin

  vp.FieldOfView := 150;

end;

end.
