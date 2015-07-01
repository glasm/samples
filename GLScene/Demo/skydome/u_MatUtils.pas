unit u_MatUtils;

interface

uses
  Windows, ExtCtrls, Classes, SysUtils,

  GLFileDDS, GLCompositeImage, GLMultisampleImage, GLMaterial, GLTexture;

// get or create material in material library
function GetOrCreateLibMaterial(a_MaterialLibrary:TGLMaterialLibrary;
    a_MaterialName:string):TGLLibMaterial;

// load DDS to texture
function DDStex(a_MatLib:TGLMaterialLibrary; a_TexName,a_DDSFileName:string;
    a_SecondTexName:string=''; a_DDSLevel:integer=0):TGLLibMaterial; overload;
function DDStex(a_TextureEx:TGLTextureExItem; a_DDSFileName:string;
    a_DDSLevel:integer=0):TGLTextureExItem; overload;
function DDStex(a_Texture:TGLTexture; a_DDSFileName:string;
  a_DDSLevel:integer=0):TGLTexture; overload;


implementation


function GetOrCreateLibMaterial(a_MaterialLibrary: TGLMaterialLibrary;
    a_MaterialName:string):TGLLibMaterial;
// ----------------------------------------------------- GetOrCreateLibMaterial
begin

  result:=nil;
  if a_MaterialLibrary=nil then exit;

  result:=a_MaterialLibrary.LibMaterialByName(a_MaterialName);
  if result=nil then begin
    result:=a_MaterialLibrary.Materials.Add;
    result.Name:=a_MaterialName;
    end;

end;


function DDStex(a_MatLib:TGLMaterialLibrary; a_TexName,a_DDSFileName:string;
    a_SecondTexName:string=''; a_DDSLevel:integer=0):TGLLibMaterial;
// --------------------------------------------------------------------- DDStex
begin

  result:=GetOrCreateLibMaterial(a_MatLib, a_TexName);
  result.Texture2Name:=a_SecondTexName;
  DDSTex(result.Material.Texture, a_DDSFileName, a_DDSLevel);

end;


function DDStex(a_TextureEx:TGLTextureExItem; a_DDSFileName:string;
    a_DDSLevel:integer=0):TGLTextureExItem;
// --------------------------------------------------------------------- DDStex
begin

  DDSTex(a_TextureEx.Texture, a_DDSFileName, a_DDSLevel);
  result:=a_TextureEx;

end;


function DDStex(a_Texture:TGLTexture; a_DDSFileName:string;
    a_DDSLevel:integer=0):TGLTexture;
// --------------------------------------------------------------------- DDStex
var def:TGLDDSDetailLevels;
begin

  def:=vDDSDetailLevel;
  case a_DDSLevel of
    1:vDDSDetailLevel:=ddsMediumDet;
    2:vDDSDetailLevel:=ddsLowDet;
    else vDDSDetailLevel:=ddsHighDet;
    end;

  with a_Texture do begin
    ImageClassName:='TGLCompositeImage';
    if fileexists(a_DDSFileName) then
      Image.LoadFromFile(a_DDSFileName);
    disabled:=false;
    end;
  result:=a_Texture;

  vDDSDetailLevel:=def;

end;


end.
