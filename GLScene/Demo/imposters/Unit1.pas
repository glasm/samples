unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLObjects, GLCadencer, GLWin32Viewer,
  GLKeyboard, GLVectorFileObjects, GLRenderContextInfo, GLUtils,
  dds, GLContext, OpenGL1x, GLCrossPlatform, VectorGeometry, AsyncTimer,

  ComCtrls, ExtCtrls, GLCoordinates, BaseClasses, StdCtrls;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc_world: TGLDummyCube;
    dc_cam: TGLDummyCube;
    AsyncTimer1: TAsyncTimer;
    dogl: TGLDirectOpenGL;
    ff: TGLFreeForm;
    procedure FormCreate(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
  private
  public

    procedure GenFreeForm;

  end;

var
  Form1: TForm1;

  tcount: integer = 2000;
  glsl: TGLProgramHandle;
  InitDGL: boolean;

  _m: array of single;
  _v: array of TVector;


implementation

{$R *.dfm}

procedure TForm1.GenFreeForm;
var
    i: integer;
    MObj: TMeshObject;
    FG: TFGVertexIndexList;
    v: TVector;
    c,a: single;

  function GetNewPos:TVector;
  begin
    setvector( result, random * 20 - 10, 0, random * 20 - 10 );
    end;

begin

  ff.MeshObjects.Clear;

  MObj := TMeshObject.CreateOwned( ff.MeshObjects );
  MObj.Mode := momFaceGroups;
  FG := TFGVertexIndexList.CreateOwned( MObj.FaceGroups );
  FG.Mode := fgmmQuads;

  randomize;

  for i := 0 to tcount - 1 do begin
    v := GetNewPos;

    with MObj.Vertices do begin
      Add(v); Add(v); Add(v); Add(v);
    end;
    c := 0.18; //+random*0.06;
    a := ( random - 0.5 ) * 6.284;
    with MObj.Normals do begin
      Add( -c, -2 * c, a ); Add( -c, 2 * c, a );
      Add( c, 2 * c, a ); Add( c, -2 * c, a );
    end;
    with MObj.TexCoords do begin
      Add( 0, 0 ); Add( 0, 1 ); Add( 1, 1 ); Add( 1, 0 );
    end;
    FG.Add( i * 4 );
    FG.Add( i * 4 + 1 );
    FG.Add( i * 4 + 2 );
    FG.Add( i * 4 + 3 );
    end;

  ff.StructureChanged;

end;


procedure TForm1.FormCreate;
begin

  GenFreeForm;
  setlength( _m, tcount );

end;

procedure TForm1.cadProgress;
begin

  cam.MoveAroundTarget( 0, deltatime * 5 );

end;

procedure TForm1.AsyncTimer1Timer;
begin

  caption := 'FFImposters › ' + vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

procedure TForm1.doglRender;
begin

  if not InitDGL then begin
    if not(gl.ARB_shader_objects and gl.ARB_vertex_program and
      gl.ARB_vertex_shader and gl.ARB_fragment_shader)then begin
      ShowMessage('shader not supported by your hardware');
      Halt;
      end;
    GLSL := TGLProgramHandle.CreateAndAllocate;
    GLSL.AddShader(TGLVertexShaderHandle, LoadAnsiStringFromFile('vp'));
    GLSL.AddShader(TGLFragmentShaderHandle, LoadAnsiStringFromFile('fp'));
    if not GLSL.LinkProgram then raise Exception.Create(GLSL.InfoLog);
    if not GLSL.ValidateProgram then raise Exception.Create(GLSL.InfoLog);
    CheckOpenGLError;
    InitDGL := True;
    end;

  if InitDGL then
    with GLSL do begin
      UseProgramObject;
      Uniform1i['BaseTex']:=0;
      Uniform4f['cam'] := cam.AbsolutePosition;

      ff.Render(rci);

      EndUseProgramObject;
      end;

end;

end.


