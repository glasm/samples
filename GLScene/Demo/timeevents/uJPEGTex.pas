unit uJPEGTex;

interface

uses

  Classes, SysUtils, GLFileJPEG, GLCompositeImage, GLMaterial, GLTexture;

function getLibMat( matlib:TGLMaterialLibrary; name:string): TGLLibMaterial;
function loadTex( matlib:TGLMaterialLibrary; texName,fileName:string;
  secondTexName:string=''): TGLTexture;

implementation


//
// get TGLLibMaterial
//
function getLibMat;
begin

  result := nil;
  if matlib = nil then exit;

  result := matlib.LibMaterialByName( name );
  if result = nil then begin
    result := matlib.Materials.Add;
    result.Name := name;
    end;

end;


//
// load JPEG texture
//
function loadTex;
var
    mat: TGLLibMaterial; 
begin

  mat := getLibMat( matlib, texName );
  mat.Texture2Name := secondTexName;
  result := mat.Material.Texture;
  result.ImageClassName := 'TGLCompositeImage';
  result.Image.LoadFromFile( fileName );
  result.disabled := false;

end;

end.
