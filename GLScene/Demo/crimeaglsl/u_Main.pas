{$APPTYPE CONSOLE}

unit u_Main;

interface

uses

  Windows, SysUtils, Classes, Forms, Graphics, Controls, ShellApi,
  StdCtrls, ExtCtrls, Dialogs,

  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLMaterial, AsyncTimer,
  GLCoordinates, GLObjects, GLHUDObjects, GLCadencer, GLRenderContextInfo,
  GLContext, OpenGLAdapter, OpenGLTokens, GLTexture, VectorGeometry, GLUtils,

  uLog, uDDStex, GLMesh;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    cad: TGLCadencer;
    dogl: TGLDirectOpenGL;
    at: TAsyncTimer;
    vp: TGLSceneViewer;
    matlib: TGLMaterialLibrary;
    back: TGLPlane;
    stat: TGLPlane;
    mob: TGLPlane;
    mesh: TGLMesh;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure atTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public

    procedure loadData;
    procedure addMobs;

  end;

  t_mob = packed record
    px,py,time: single;
    end;


const
  g_tx = 136/2048;
  g_ty = 138/4096;


var
  Form1: TForm1;

  arr: array[0..999] of t_mob;

  useShader: boolean;
  glsl: TGLProgramHandle;
  initDGL: boolean;


implementation


{$R *.dfm}


//
// setup
//
procedure TForm1.FormCreate;
begin

  log_tick;

  loadData;
  
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

  DDStex( matlib, 'dirt', 'dirt.dds' );
  DDStex( matlib, 'stat', 'stat.dds' );

  // link to material (matlib not working in ver 1.1+)
  mesh.Material := DDStex( matlib, 'mob', 'mob.dds' ).Material;
  with matlib.LibMaterialByName('mob') do
    TextureScale.SetPoint(g_tx, g_ty, 0);

  log('add mobs...', 10);
  addMobs;

  log('uploading...', 14);
  vp.Buffer.Render;

end;


//
// addMobs
//
procedure TForm1.addMobs;
var
    i: integer;
    f: single;

  function v(x,y,z,s,t,time:single): TVertexData;
  begin
    setVector( result.coord, x, y, z );
    setVector( result.normal, time, 0, 0 );
    result.textCoord.S := s;
    result.textCoord.T := t;
  end;

begin

  randomize;
  mesh.Vertices.Clear;
  mesh.BeginUpdate;
  for i := 0 to high(arr) do
    with arr[i] do begin

      px := 8 * (random * 2 - 1);
      py := 10 * (0.6 - i / length(arr));
      time := random * 342;

      with mesh.Vertices do begin
        AddVertex( v( px - 0.5, py - 0.5, -py, 0, 1 - g_ty, time ));
        AddVertex( v( px + 0.5, py - 0.5, -py, g_tx, 1 - g_ty, time ));
        AddVertex( v( px + 0.5, py + 0.5, -py, g_tx, 1, time ));
        AddVertex( v( px - 0.5, py + 0.5, -py, 0, 1, time ));
      end;

    end;
  mesh.EndUpdate;

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

  vp.Invalidate;

end;


//
// doglRender
//
procedure TForm1.doglRender;

  procedure newFrame(f: integer);
  begin
    with matlib.LibMaterialByName('mob').TextureOffset do
      setPoint((f mod 15) * g_tx, 1 - (f div 15 + 1) * g_ty, 0);
  end;

var
    i: integer;
begin

  if not initDGL then begin
    if not(gl.ARB_shader_objects and gl.ARB_fragment_shader) then begin
      ShowMessage('shader not supported by your hardware');
      Halt;
      end;
    glsl := TGLProgramHandle.CreateAndAllocate;
    glsl.AddShader( TGLVertexShaderHandle, LoadAnsiStringFromFile('vp'));
    glsl.AddShader( TGLFragmentShaderHandle, LoadAnsiStringFromFile('fp'));
    if not glsl.LinkProgram then raise Exception.Create( glsl.InfoLog );
    if not glsl.ValidateProgram then raise Exception.Create( glsl.InfoLog );
    initDGL := True;
    end;

  if initDGL then begin

    if useShader then begin // mesh + GLSL
      glsl.UseProgramObject;
      glsl.Uniform1i['BaseTex'] := 0;
      glsl.Uniform1f['time'] := cad.CurrentTime;
      mesh.Render( rci );
      glsl.EndUseProgramObject;
    end
    else begin // sprites
      for i := 0 to high(arr) do
        with arr[i] do begin
          mob.Position.SetPoint( px, py, -py );
          newFrame(round((time + cad.CurrentTime) * 10 - 0.5) mod 342);
          mob.Render(rci);
        end;
    end;

  end;

end;


//
// timer
//
procedure TForm1.atTimer;
begin

  caption := 'Crimea[';
  if useShader then
    caption := caption + inttostr(length(arr) * 2) + ' triangles'
  else
    caption := caption + inttostr(length(arr)) + ' sprites';
  caption := caption + ']: ' + vp.FramesPerSecondText(2) +
    ' / press F1 to change mode';
  vp.ResetPerformanceMonitor;

end;


//
// keyDown
//
procedure TForm1.FormKeyDown;
begin

  if key = vk_f1 then
    useShader := not useShader;

end;

end.
