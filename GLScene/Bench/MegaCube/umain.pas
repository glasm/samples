unit umain;

interface

uses

  SysUtils, Windows, Classes, Controls, Forms, StdCtrls, ExtCtrls, Graphics,

  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLObjects, GLMaterial,
  GLHUDObjects, GLCoordinates, GLMesh, GLVectorFileObjects, GLCadencer,
  GLRenderContextInfo, AsyncTimer, VectorTypes, VectorGeometry, openGL1x,
  GLTexture, GLContext, GLColor,

  GLFile3DS, GLFileDDS, GLCompositeImage,

  ucpuinst, ugpuinst, uglfreeform,
  
  u_simpleVBO, GLFeedback;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    cam: TGLCamera;
    dc_cam: TGLDummyCube;
    Bevel1: TBevel;
    dogl: TGLDirectOpenGL;
    GLFreeForm: TGLFreeForm;
    GLMesh: TGLMesh;
    cad: TGLCadencer;
    at: TAsyncTimer;
    back: TGLHUDSprite;
    vp: TGLSceneViewer;
    Button1: TButton;
    rb1: TRadioButton;
    rb2: TRadioButton;
    dc_world: TGLDummyCube;
    tmp_obj: TGLFreeForm;
    rb3: TRadioButton;
    rb4: TRadioButton;
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure cadProgress(Sender: TObject; const deltaTime,newTime: Double);
    procedure atTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
  public

    cpuinst_obj: TBenchCPUInst;
    gpuinst_obj: TBenchGPUInst;
    freeform_obj: TBenchGLFreeForm;

    vbo: c_simpleVBO;

    cap: string;

    test_num: integer;
    test_dt: integer;
    test_res: array[0..3] of single;
    test_pb: array[0..3] of TImage;
    test_cap: array[0..3] of TLabel;


    procedure createGeometry;
    procedure fill_GLMesh;
    procedure fill_GLFreeForm;
    procedure fill_VBO;

  end;

const

    q0 = 7;
    q1 = q0 * 2 + 1;
    qcnt = q1 * q1 * q1 * 6 * 4;

var
  Form1: TForm1;

  fps: array[0..5] of TPoint = ((x:0;y:0),(x:0;y:0),(x:0;y:0),(x:0;y:0),(x:0;y:0),(x:0;y:0));
  predelta: integer = 2;
  cur: integer = 0;

  quads: array[0..qcnt-1] of TVertexData;
  vlist: array[0..(qcnt div 3)-1] of TVector3f;
  nlist: array[0..5] of TVector3f =
    ((1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1));
  tlist: array[0..3] of TTexPoint =
    ((s:0;t:0),(s:1;t:0),(s:1;t:1),(s:1;t:1));
  vilst: array[0..qcnt-1] of integer;
  nilst: array[0..qcnt-1] of integer;
  tilst: array[0..qcnt-1] of integer;


implementation


{$R *.dfm}


// setup
//
procedure TForm1.FormCreate(Sender: TObject);

  procedure att(i:integer; p:TImage; c:TLabel);
  begin
    test_res[i] := 0;
    test_pb[i] := p;
    test_cap[i] := c;
    end;

begin

  cad.FixedDeltaTime := 1 / GetDeviceCaps(getDC(Handle), 116);

  vp.Buffer.RenderingContext.Activate;
  vp.width := 824;

  clientWidth := 1024;
  clientHeight := 512;

  tmp_obj.LoadFromFile( 'cube.3ds' );
  with tmp_obj.Material do begin
    with TextureEx[0].Texture do begin
      Image.LoadFromFile( 'logo.dds' );
      Disabled := false;
    end;
    with TextureEx[1].Texture do begin
      Image.LoadFromFile( 'shad.dds' );
      Disabled := false;
    end;
  end;

  cpuinst_obj := TBenchCPUInst.CreateAsChild( dogl, tmp_obj );
  //cpuinst_obj.Visible := false;

  gpuinst_obj := TBenchGPUInst.CreateAsChild( dogl, tmp_obj );
  gpuinst_obj.Visible := false;

  freeform_obj := TBenchGLFreeForm.CreateAsChild( dogl, tmp_obj );
  freeform_obj.Visible := false;




  //cap := 'MegaCube / cubes: ' + inttostr(qcnt div 24) +', triangles: ' +
  //  inttostr(qcnt div 2);

  {test_num := 0;
  test_dt := 21;

  att(0, pb_1 ,cnt_1);
  att(1, pb_2 ,cnt_2);
  att(2, pb_3 ,cnt_3);
  att(3, pb_4 ,cnt_4);

  DoubleBuffered := true;


  createGeometry;

  fill_GLMesh;
  fill_GLFreeForm;
  fill_VBO;}

end;


//
// cadProgress
//
procedure TForm1.cadProgress;
var
    dt: integer;
begin

  dc_cam.TurnAngle := -newtime*10;

  if predelta < 0 then begin
    dt := round(100/vp.LastFrameTime);
    fps[cur].X := (dt*9 + fps[cur].X) div 10;
    if dt > fps[cur].Y then
      fps[cur].Y := dt;
  end;


end;


//
// doglRender
//
procedure TForm1.doglRender;
var
    i,j,k: integer;

begin

  case cur of
    //0: gpuinst_obj.Render( rci );
   // 1: cpuinst_obj.Render( rci );

    -1: {for i := -q0 to q0 do
        for j := -q0 to q0 do
          for k := -q0 to q0 do
            with GLCube do begin
              position.SetPoint(i, j, k);
              Render(rci);
              end;}
    //1: GLMesh.Render(rci);
    //0: GLFreeForm.Render(rci);
    //3: VBO.Render(rci);
    end;

end;


//
// atTimer
//
procedure TForm1.atTimer;
var
    dt: integer;
begin

  dec(predelta);
  if predelta >= 0 then exit;

  canvas.FillRect( rect( 32,40+cur*72,160,80+cur*70 ));
  canvas.Font.Color := $00eeff;
  canvas.TextOut( 33,40+cur*72, format('AVR: %.2f',[fps[cur].X/100]));
  canvas.TextOut( 33,60+cur*72, format('MAX: %.2f',[fps[cur].Y/100]));

//  caption := cap + ' / fps: ' + format('%.2f', [vp.FramesPerSecond]);
  vp.ResetPerformanceMonitor;

{
  dec(test_dt);
  test_res[test_num] := test_res[test_num] + vp.FramesPerSecond;
  test_pb[test_num].Width := 8 * (21 - test_dt);
  test_cap[test_num].Caption := inttostr(round(test_res[test_num]));

  caption := cap + ' / fps: ' + format('%.2f', [vp.FramesPerSecond]);
  vp.ResetPerformanceMonitor;

  if test_dt = 0 then begin
    inc(test_num);
    test_dt := 21;
    end;

  if ((test_num = 3) and (VBO = nil)) or (test_num = 4) then begin
    caption := cap + ' / OK';
    at.Enabled := false;
    cad.Enabled := false;
    end;
}
end;


//
// genGeometry
//
procedure TForm1.createGeometry;
const
    d = 0.25;
var
    i,j,k,q: integer;
    ii,vi: integer;

  procedure _addVertices;
  var vc: array[0..7] of TVector3f;
  begin
    setvector(vc[0], i - d, j - d, k - d);
    setvector(vc[1], i - d, j - d, k + d);
    setvector(vc[2], i - d, j + d, k - d);
    setvector(vc[3], i - d, j + d, k + d);
    setvector(vc[4], i + d, j - d, k - d);
    setvector(vc[5], i + d, j - d, k + d);
    setvector(vc[6], i + d, j + d, k - d);
    setvector(vc[7], i + d, j + d, k + d);
    setvector( vlist[vi + 0], i - d, j - d, k - d);
    setvector( vlist[vi + 1], i - d, j - d, k + d);
    setvector( vlist[vi + 2], i - d, j + d, k - d);
    setvector( vlist[vi + 3], i - d, j + d, k + d);
    setvector( vlist[vi + 4], i + d, j - d, k - d);
    setvector( vlist[vi + 5], i + d, j - d, k + d);
    setvector( vlist[vi + 6], i + d, j + d, k - d);
    setvector( vlist[vi + 7], i + d, j + d, k + d);
    quads[q + 00].coord := vc[0]; quads[q + 01].coord := vc[2];
    quads[q + 02].coord := vc[6]; quads[q + 03].coord := vc[4];
    quads[q + 04].coord := vc[0]; quads[q + 05].coord := vc[1];
    quads[q + 06].coord := vc[3]; quads[q + 07].coord := vc[2];
    quads[q + 08].coord := vc[1]; quads[q + 09].coord := vc[5];
    quads[q + 10].coord := vc[7]; quads[q + 11].coord := vc[3];
    quads[q + 12].coord := vc[4]; quads[q + 13].coord := vc[6];
    quads[q + 14].coord := vc[7]; quads[q + 15].coord := vc[5];
    quads[q + 16].coord := vc[2]; quads[q + 17].coord := vc[3];
    quads[q + 18].coord := vc[7]; quads[q + 19].coord := vc[6];
    quads[q + 20].coord := vc[1]; quads[q + 21].coord := vc[4];
    quads[q + 22].coord := vc[5]; quads[q + 23].coord := vc[1];
    vilst[ii + 00] := vi + 0; vilst[ii + 01] := vi + 2;
    vilst[ii + 02] := vi + 6; vilst[ii + 03] := vi + 4;
    vilst[ii + 04] := vi + 0; vilst[ii + 05] := vi + 1;
    vilst[ii + 06] := vi + 3; vilst[ii + 07] := vi + 2;
    vilst[ii + 08] := vi + 1; vilst[ii + 09] := vi + 5;
    vilst[ii + 10] := vi + 7; vilst[ii + 11] := vi + 3;
    vilst[ii + 12] := vi + 4; vilst[ii + 13] := vi + 6;
    vilst[ii + 14] := vi + 7; vilst[ii + 15] := vi + 5;
    vilst[ii + 16] := vi + 2; vilst[ii + 17] := vi + 3;
    vilst[ii + 18] := vi + 7; vilst[ii + 19] := vi + 6;
    vilst[ii + 20] := vi + 1; vilst[ii + 21] := vi + 4;
    vilst[ii + 22] := vi + 5; vilst[ii + 23] := vi + 1;
    end;

  procedure _addNormals;
  var i:integer;
  begin
    for i := 0 to 3 do begin
      quads[q + i + 00].normal := MinusZVector;
      quads[q + i + 04].normal := MinusXVector;
      quads[q + i + 08].normal := ZVector;
      quads[q + i + 12].normal := XVector;
      quads[q + i + 16].normal := YVector;
      quads[q + i + 20].normal := MinusYVector;
      end;
    end;

  procedure _addTexCoords;
  var i:integer;
  begin
    for i := 0 to 5 do begin
      quads[q + i * 4 + 0].textCoord := NullTexPoint;
      quads[q + i * 4 + 1].textCoord := YTexPoint;
      quads[q + i * 4 + 2].textCoord := XYTexPoint;
      quads[q + i * 4 + 3].textCoord := XTexPoint;
      end;
    end;

begin

  for i := -q0 to q0 do
    for j := -q0 to q0 do
      for k := -q0 to q0 do begin

        q := (q1 * ((i + q0) * q1 + (j + q0)) + k + q0) * 24;
        vi := (q1 * ((i + q0) * q1 + (j + q0)) + k + q0) * 8;
        ii := (q1 * ((i + q0) * q1 + (j + q0)) + k + q0) * 24;

        _addVertices;
        _addNormals;
        _addTexCoords;

        end;

end;


//
// fill_GLMesh
//
procedure TForm1.fill_GLMesh;
var
    i: integer;
begin

  GLMesh.BeginUpdate;
  with GLMesh.Vertices do begin
    Clear;
    Capacity := length(quads);
    for i := 0 to high(quads) do
      AddVertex(quads[i]);
    end;
  GLMesh.EndUpdate;

end;


//
// fill_GLFreeForm
//
procedure TForm1.fill_GLFreeForm;
var
    i: integer;
    MObj: TMeshObject;
    FG: TFGVertexIndexList;
//    FG: TFGVertexNormalTexIndexList;
begin

  MObj := TMeshObject.CreateOwned(GLFreeForm.MeshObjects);
  MObj.Mode := momFaceGroups;
  FG := TFGVertexIndexList.CreateOwned(MObj.FaceGroups);
  //FG := TFGVertexNormalTexIndexList.CreateOwned(MObj.FaceGroups);
  FG.Mode := fgmmQuads;

{  with Mobj do begin

    Vertices.Capacity := length(vlist);
    for i := 0 to high(vlist) do
      Vertices.Add( vlist[i] );

    for i := 0 to high(vilst) do
      FG.VertexIndices.Add( vilst[i] );
    for i := 0 to high(vilst) do begin
      FG.NormalIndices.Add( 0, 0 ); FG.NormalIndices.Add( 0, 0 );
      FG.NormalIndices.Add( 1, 1 ); FG.NormalIndices.Add( 1, 1 );
      FG.NormalIndices.Add( 2, 2 ); FG.NormalIndices.Add( 2, 2 );
      FG.NormalIndices.Add( 3, 3 ); FG.NormalIndices.Add( 3, 3 );
      FG.NormalIndices.Add( 4, 4 ); FG.NormalIndices.Add( 4, 4 );
      FG.NormalIndices.Add( 5, 5 ); FG.NormalIndices.Add( 5, 5 );
    end;
    for i := 0 to high(vilst) do begin
      FG.TexCoordIndices.Add( 0, 0 ); FG.TexCoordIndices.Add( 0, 0 );
      FG.TexCoordIndices.Add( 1, 1 ); FG.TexCoordIndices.Add( 1, 1 );
      FG.TexCoordIndices.Add( 2, 2 ); FG.TexCoordIndices.Add( 2, 2 );
      FG.TexCoordIndices.Add( 3, 3 ); FG.TexCoordIndices.Add( 3, 3 );
      FG.TexCoordIndices.Add( 4, 4 ); FG.TexCoordIndices.Add( 4, 4 );
      FG.TexCoordIndices.Add( 5, 5 ); FG.TexCoordIndices.Add( 5, 5 );
    end;

  end;}


  FG.Mode := fgmmQuads;

  with Mobj do begin

    Vertices.Capacity := length(quads);
    Normals.Capacity := length(quads);
    TexCoords.Capacity := length(quads);

    for i := 0 to high(quads) do begin
      with quads[i] do begin
        Vertices.Add(coord);
        Normals.Add(normal);
        TexCoords.Add(textCoord);
        end;
      FG.Add(i);
      end;

    end;

end;


//
// fill_VBO
//
procedure TForm1.fill_VBO;
begin

 { if gl.ARB_vertex_buffer_object then begin

    VBO := c_simpleVBO.CreateAsChild(dogl, @quads, qcnt);
    with VBO.Material do begin
      FrontProperties.Diffuse.SetColor(1, 1, 1, 1);
      MaterialLibrary := matlib;
      LibMaterialName := 'logo';
      end;
    VBO.Visible := false;

    end
  else cnt_4.Caption := ' ---';
  }
end;


procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;
  at.Enabled := true;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  GLFreeForm.SaveToFile( 'qwe.ase' );

end;

procedure TForm1.rb2Click(Sender: TObject);
begin

  cpuinst_obj.Visible := sender = rb1;
  gpuinst_obj.Visible := sender = rb2;
  freeform_obj.Visible := sender = rb3;
 // vbo_obj.Visible := sender = rb4;
  cur := TControl(sender).tag;

end;

end.

