unit ugpuminst;

interface

uses
  Classes, Dialogs, SysUtils,
  GLScene, GLObjects, GLRenderContextInfo, GLVectorFileObjects,
  VectorGeometry, OpenGL1x, OpenGLTokens, OpenGLAdapter, GLContext, GLMaterial;


type TBenchGPUMInst = class( TGLSceneObject )
  private
    FGLSL: TGLProgramHandle;
    FVArr: array of TAffineVector;
    FNArr: array of TAffineVector;
    FTArr: array of TAffineVector;
    FIArr: array of GLUint;
    FBufs: array[0..3] of Cardinal;
  public
    constructor CreateAsChild( aParent:TGLBaseSceneObject ); 
    procedure DoRender( var rci: TRenderContextInfo;
      renderSelf, renderChildren: Boolean); override;
  end;

implementation


constructor TBenchGPUMInst.CreateAsChild( aParent:TGLBaseSceneObject );
var
    i,j,k,cnt: integer;
    fg1: TFGVertexIndexList;
    fg2: TFGVertexNormalTexIndexList;
begin

  inherited CreateAsChild( aParent );


end;


procedure TBenchGPUMInst.DoRender( var rci: TRenderContextInfo;
  renderSelf, renderChildren: Boolean);
begin


end;


end.
