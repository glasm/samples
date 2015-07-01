unit u_MatUtils;


interface

uses

  Windows, ExtCtrls, Classes, SysUtils,

  GLScene, GLFileDDS, GLFileJPEG, GLFilePNG, GLFileBMP, GLFileTGA,
  GLCompositeImage, GLMultisampleImage, GLMaterial, GLGraphics,
  GLTexture, GLTextureFormat;



{ get or create material }
function GetOrCreateLibMaterial(a_MaterialLibrary: TGLMaterialLibrary;
    a_MaterialName: string): TGLLibMaterial;


{ to MaterialLibrary.Materials[].Material.Texture }
function LoadTex(a_MatLib: TGLMaterialLibrary; a_TexName: string;
    a_FileName: string; a_DDSLevel: integer = 0): TGLTexture; overload;
function LoadTex(a_MatLib: TGLMaterialLibrary; a_TexName: string;
    a_Stream: TStream; a_StreamPos: int64 = 0;
    a_DDSLevel: integer = 0): TGLTexture; overload;

{ to Object.Material.Texture }
function LoadTex(a_Object: TGLSceneObject; a_FileName: string;
    a_DDSLevel: integer = 0): TGLTexture; overload;
function LoadTex(a_Object: TGLSceneObject; a_Stream: TStream;
    a_StreamPos: int64 = 0; a_DDSLevel: integer = 0): TGLTexture; overload;

{ to Texture }
function LoadTex(a_Texture: TGLTexture; a_FileName: string;
    a_DDSLevel: integer = 0): TGLTexture; overload;
function LoadTex(a_Texture: TGLTexture; a_Stream: TStream;
    a_StreamPos: int64 = 0; a_DDSLevel: integer = 0): TGLTexture; overload;


implementation



//                                                       GetOrCreateLibMaterial
//
function GetOrCreateLibMaterial(a_MaterialLibrary: TGLMaterialLibrary;
  a_MaterialName: string): TGLLibMaterial;
begin

  result := nil;
  if a_MaterialLibrary = nil then exit;

  result := a_MaterialLibrary.LibMaterialByName(a_MaterialName);
  if result = nil then begin
    result := a_MaterialLibrary.Materials.Add;
    result.Name := a_MaterialName;
    end;

end;


//                                                                      LoadTex
//
function LoadTex(a_MatLib: TGLMaterialLibrary; a_TexName: string;
  a_FileName: string; a_DDSLevel: integer = 0): TGLTexture;
begin

  with GetOrCreateLibMaterial(a_MatLib, a_TexName) do
    result := LoadTex(Material.Texture, a_FileName, a_DDSLevel);

end;


//                                                                      LoadTex
//
function LoadTex(a_MatLib: TGLMaterialLibrary; a_TexName: string;
  a_Stream: TStream; a_StreamPos: int64 = 0;
  a_DDSLevel: integer = 0): TGLTexture;
begin

  with GetOrCreateLibMaterial(a_MatLib, a_TexName) do
    result := LoadTex(Material.Texture, a_Stream, a_StreamPos, a_DDSLevel);

end;


//                                                                      LoadTex
//
function LoadTex(a_Object: TGLSceneObject; a_FileName: string;
  a_DDSLevel: integer = 0): TGLTexture;
begin

  result := LoadTex(a_Object.Material.Texture, a_FileName, a_DDSLevel);

end;


//                                                                      LoadTex
//
function LoadTex(a_Object: TGLSceneObject; a_Stream: TStream;
  a_StreamPos: int64 = 0; a_DDSLevel: integer = 0): TGLTexture;
begin

  result := LoadTex(a_Object.Material.Texture,
    a_Stream, a_StreamPos, a_DDSLevel);

end;


//                                                                      LoadTex
//
function LoadTex(a_Texture: TGLTexture; a_FileName: string;
  a_DDSLevel: integer = 0): TGLTexture;
var
    def: TGLDDSDetailLevels;

begin

  def := vDDSDetailLevel;
  case a_DDSLevel of
    1: vDDSDetailLevel := ddsMediumDet;
    2: vDDSDetailLevel := ddsLowDet;
    else vDDSDetailLevel := ddsHighDet;
    end;

  if fileexists(a_FileName) then
    with a_Texture do begin
      ImageClassName := 'TGLCompositeImage';
      FilteringQuality := tfAnisotropic;
      Image.LoadFromFile(a_FileName);
      disabled := false;
      end;
  result := a_Texture;

  vDDSDetailLevel := def;

end;


//                                                                      LoadTex
//
function LoadTex(a_Texture: TGLTexture; a_Stream: TStream;
  a_StreamPos: int64 = 0; a_DDSLevel:integer = 0): TGLTexture;
var
    def: TGLDDSDetailLevels;
    c: cardinal;
    img: TGLBaseImage;

begin

  result := a_Texture;
  if a_Stream = nil then exit;

  def := vDDSDetailLevel;
  case a_DDSLevel of
    1: vDDSDetailLevel := ddsMediumDet;
    2: vDDSDetailLevel := ddsLowDet;
    else vDDSDetailLevel := ddsHighDet;
    end;

  if a_StreamPos >= 0 then
    a_Stream.Position := a_StreamPos;
  a_Stream.ReadBuffer(c, 4);
  a_Stream.Position := a_Stream.Position - 4;

  if c and $ffff = $4d42 then
    img := TGLBMPImage.Create
  else if c and $ffff = $d8ff then
    img := TGLJPEGImage.Create
  else if c = $474e5089 then
    img := TGLPNGImage.Create
  else if c and $ffffff = $534444 then
    img := TGLDDSImage.Create
  else if c and $ffffff = $020000 then
    img := TGLTGAImage.Create;

  if img <> nil then
    try
      img.LoadFromStream(a_Stream);
    finally
      with a_Texture do begin
        ImageClassName := 'TGLCompositeImage';
        FilteringQuality := tfAnisotropic;
        disabled := false;
        Image.Assign(img);
        img.Free;
        end;
    end;

  vDDSDetailLevel := def;

end;


end.


