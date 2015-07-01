unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLCoordinates, GLObjects, AsyncTimer, GLCadencer, GLUtils,
  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLRenderContextInfo,
  GLContext, GLVectorFileObjects, VectorGeometry, TGA;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    AsyncTimer1: TAsyncTimer;
    dc_cam: TGLDummyCube;
    cam: TGLCamera;
    dogl: TGLDirectOpenGL;
    ff: TGLFreeForm;
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

  InitDGL: boolean;
  GLSL: TGLProgramHandle;

  tree_cnt: integer = 100000;
  world_height: single = 1;
  world_size: single = 40;


implementation

{$R *.dfm}


procedure TForm1.doglRender;
var
    ax,ay: integer;
begin

  if not InitDGL then begin
    if not(gl.ARB_shader_objects and gl.ARB_vertex_program and
           gl.ARB_vertex_shader and gl.ARB_fragment_shader) then begin
      ShowMessage('shader not supported by your hardware');
      Halt;
      end;
    GLSL := TGLProgramHandle.CreateAndAllocate;
    GLSL.AddShader( TGLVertexShaderHandle, LoadAnsiStringFromFile('vp'));
    GLSL.AddShader( TGLFragmentShaderHandle, LoadAnsiStringFromFile('fp'));
    if not GLSL.LinkProgram then raise Exception.Create( GLSL.InfoLog );
    if not GLSL.ValidateProgram then raise Exception.Create( GLSL.InfoLog );
    InitDGL := True;
    end;

  if InitDGL then
    with GLSL do begin
      UseProgramObject;

      Uniform1i['BaseTex'] := 0;
      Uniform4f['cam'] := cam.AbsolutePosition;

      ff.Render( rci );

      EndUseProgramObject;
      end;

end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  caption := 'Forest: ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;

procedure TForm1.cadProgress;
begin

  dc_cam.Turn( deltatime * 10 );

  vp.Invalidate;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    ts: TBitmap;
    mObj: TMeshObject;
    i: integer;

  procedure genTree;
  var
      x,y: integer;
      b: byte;
      v: TVector;
      d: single;
  begin

    repeat
      x := random( ts.Width );
      y := random( ts.Height );
      b := PByteArray( ts.ScanLine[ts.Height - 1 - y] )[x];
      until b > 20;

    setvector( v,
      x * world_size / ts.Width - world_size / 2 + (random - 0.5) * 0.1,
      b * 0.03 * world_height - 5,
      y * world_size / ts.Height - world_size / 2 + (random - 0.5) * 0.1);

    // momTriangles
    with mObj.Vertices do begin Add(v); Add(v); Add(v); end;
    with mObj.TexCoords do begin Add(0,0); Add(0.5,1); Add(1,0); end;
    d := 0.2 + random * 0.1;
    with mObj.Normals do begin Add(d,0,0); Add(0,2.5*d,0); Add(-d,0,0); end;

  end;

begin

  randomize;

  ts := TBitmap.Create;
  ts.LoadFromFile( 'ts.bmp' );

  mObj := TMeshObject.CreateOwned( ff.MeshObjects );
  mObj.Mode := momTriangles;

  for i := 0 to tree_cnt - 1 do
    genTree;

end;

end.
