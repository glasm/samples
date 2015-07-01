{: "Earth" Demo.<p>

   See accompanying Readme.txt for user instructions.<p>

   The atmospheric effect is rendered in GLDirectOpenGL1Render, which essentially
   renders a disk, with color of the vertices computed via ray-tracing. Not that
   the tesselation of the disk has been hand-optimized so as to reduce CPU use
   while retaining quality. On anything >1 GHz, the rendering is fill-rate
   limited on a GeForce 4 Ti 4200.<p>

   Stars support is built into the TGLSkyDome, but constellations are rendered
   via a TGLLines, which is filled in the LoadConstellationLines method.<p>

   Eric Grange<br>
   http://glscene.org
}
unit Unit1;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  GLScene,
  GLObjects,
  GLWin32Viewer,
  GLSkydome,
  GLTexture,
  ExtCtrls,
  GLCadencer,
  GLLensFlare,
  GLTexCombineShader,
  GLMaterial,
  GLCoordinates,
  GLCrossPlatform,
  BaseClasses,
  GLRenderContextInfo,
  GLColor,
  GLState;

type
  TForm1 = class(TForm)
    GLScene: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    GLCamera: TGLCamera;
    SPEarth: TGLSphere;
    LSSun: TGLLightSource;
    GLDirectOpenGL1: TGLDirectOpenGL;
    GLCadencer: TGLCadencer;
    Timer1: TTimer;
    SPMoon: TGLSphere;
    DCEarthSystem: TGLDummyCube;
    DCMoon: TGLDummyCube;
    GLLensFlare1: TGLLensFlare;
    GLMaterialLibrary: TGLMaterialLibrary;
    EarthCombiner: TGLTexCombineShader;
    GLCameraControler: TGLCamera;
    GLSkyDome: TGLSkyDome;
    ConstellationLines: TGLLines;
    procedure FormCreate(Sender: TObject);
    procedure GLDirectOpenGL1Render(Sender: TObject; var rci: TRenderContextInfo);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencerProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure GLSceneViewerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLSceneViewerDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GLSceneViewerBeforeRender(Sender: TObject);
  private
    { Private declarations }
    procedure LoadConstellationLines;
  public
    { Public declarations }
    constellationsAlpha: Single;
    timeMultiplier: Single;
    mx, my, dmx, dmy: Integer;
    highResResourcesLoaded: Boolean;
    cameraTimeSteps: Single;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{$IFNDEF VER130}
{$WARN UNIT_PLATFORM OFF}
{$ENDIF}

uses
  FileCtrl,
  GLUtils,
  JPEG,
  OpenGLTokens,
  VectorGeometry,
  GLContext,
  GLTextureFormat;
// accurate movements left for later... or the astute reader
// USolarSystem;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));

  GLSkyDome.Bands.Clear;
  if FileExists('Yale_BSC.stars') then
    GLSkyDome.Stars.LoadStarsFile('Yale_BSC.stars');

  LoadConstellationLines;

  timeMultiplier := 1;
end;

procedure TForm1.GLSceneViewerBeforeRender(Sender: TObject);
begin
  GLLensFlare1.PreRender(Sender as TGLSceneBuffer);
  // if no multitexturing or no combiner support, turn off city lights
  if GL.ARB_multitexture and GL.ARB_texture_env_combine then
  begin
    GLMaterialLibrary.Materials[0].Shader := EarthCombiner;
    GLMaterialLibrary.Materials[0].Texture2Name := 'earthNight';
  end
  else
  begin
    GLMaterialLibrary.Materials[0].Shader := nil;
    GLMaterialLibrary.Materials[0].Texture2Name := '';
  end;
end;

procedure TForm1.GLDirectOpenGL1Render(Sender: TObject; var rci: TRenderContextInfo);
const
  // unrealisticly thick atmospheres look better :)
  cAtmosphereRadius: Single = 0.55;
  // use value slightly lower than actual radius, for antialiasing effect
  cPlanetRadius: Single = 0.495;
  cLowAtmColor: TColorVector = (1, 1, 1, 1);
  cHighAtmColor: TColorVector = (0, 0, 1, 1);
  cOpacity: Single = 5;
  cIntDivTable: array[2..20] of Single =
    (1 / 2, 1 / 3, 1 / 4, 1 / 5, 1 / 6, 1 / 7, 1 / 8, 1 / 9, 1 / 10,
    1 / 11, 1 / 12, 1 / 13, 1 / 14, 1 / 15, 1 / 16, 1 / 17, 1 / 18, 1 / 19, 1 / 20);
var
  radius, invAtmosphereHeight: Single;
  sunPos, eyePos, lightingVector: TVector;
  diskNormal, diskRight, diskUp: TVector;

  function AtmosphereColor(const rayStart, rayEnd: TVector): TColorVector;
  var
    i, n: Integer;
    atmPoint, normal: TVector;
    altColor: TColorVector;
    alt, rayLength, contrib, decay, intensity, invN: Single;
  begin
    Result := clrTransparent;
    rayLength := VectorDistance(rayStart, rayEnd);
    n := Round(3 * rayLength * invAtmosphereHeight) + 2;
    if n > 10 then
      n := 10;
    invN := cIntDivTable[n]; //1/n;
    contrib := rayLength * invN * cOpacity;
    decay := 1 - contrib * 0.5;
    contrib := contrib * (1 / 1.1);
    for i := n - 1 downto 0 do
    begin
      VectorLerp(rayStart, rayEnd, i * invN, atmPoint);
      // diffuse lighting normal
      normal := VectorNormalize(atmPoint);
      // diffuse lighting intensity
      intensity := VectorDotProduct(normal, lightingVector) + 0.1;
      if PInteger(@intensity)^ > 0 then
      begin
        // sample on the lit side
        intensity := intensity * contrib;
        alt := (VectorLength(atmPoint) - cPlanetRadius) * invAtmosphereHeight;
        VectorLerp(cLowAtmColor, cHighAtmColor, alt, altColor);
        Result[0] := Result[0] * decay + altColor[0] * intensity;
        Result[1] := Result[1] * decay + altColor[1] * intensity;
        Result[2] := Result[2] * decay + altColor[2] * intensity;
      end
      else
      begin
        // sample on the dark sid
        Result[0] := Result[0] * decay;
        Result[1] := Result[1] * decay;
        Result[2] := Result[2] * decay;
      end;
    end;
    Result[3] := n * contrib * cOpacity * 0.1;
  end;

  function ComputeColor(var rayDest: TVector; mayHitGround: Boolean): TColorVector;
  var
    ai1, ai2, pi1, pi2: TVector;
    rayVector: TVector;
  begin
    rayVector := VectorNormalize(VectorSubtract(rayDest, eyePos));
    if RayCastSphereIntersect(eyePos, rayVector, NullHmgPoint, cAtmosphereRadius, ai1, ai2) > 1 then
    begin
      // atmosphere hit
      if mayHitGround and (RayCastSphereIntersect(eyePos, rayVector, NullHmgPoint, cPlanetRadius, pi1, pi2) > 0) then
      begin
        // hit ground
        Result := AtmosphereColor(ai1, pi1);
      end
      else
      begin
        // through atmosphere only
        Result := AtmosphereColor(ai1, ai2);
      end;
      rayDest := ai1;
    end
    else
      Result := clrTransparent;
  end;

const
  cSlices = 60;
var
  i, j, k0, k1: Integer;
  cosCache, sinCache: array[0..cSlices] of Single;
  pVertex, pColor: PVectorArray;
begin
  sunPos := LSSun.AbsolutePosition;
  eyepos := GLCamera.AbsolutePosition;

  diskNormal := VectorNegate(eyePos);
  NormalizeVector(diskNormal);
  diskRight := VectorCrossProduct(GLCamera.AbsoluteUp, diskNormal);
  NormalizeVector(diskRight);
  diskUp := VectorCrossProduct(diskNormal, diskRight);
  NormalizeVector(diskUp);

  invAtmosphereHeight := 1 / (cAtmosphereRadius - cPlanetRadius);
  lightingVector := VectorNormalize(sunPos); // sun at infinity
  PrepareSinCosCache(sinCache, cosCache, 0, 360);

  GetMem(pVertex, 2 * (cSlices + 1) * SizeOf(TVector));
  GetMem(pColor, 2 * (cSlices + 1) * SizeOf(TVector));

  rci.GLStates.DepthWriteMask := False;
  rci.GLStates.Disable(stLighting);
  rci.GLStates.Enable(stBlend);
  rci.GLStates.SetBlendFunc(bfSrcAlpha, bfOneMinusSrcAlpha);
  for i := 0 to 13 do
  begin
    if i < 5 then
      radius := cPlanetRadius * Sqrt(i * (1 / 5))
    else
      radius := cPlanetRadius + (i - 5.1) * (cAtmosphereRadius - cPlanetRadius) * (1 / 6.9);
    radius := SphereVisibleRadius(VectorLength(eyePos), radius);
    k0 := (i and 1) * (cSlices + 1);
    k1 := (cSlices + 1) - k0;
    for j := 0 to cSlices do
    begin
      VectorCombine(diskRight, diskUp,
        cosCache[j] * radius, sinCache[j] * radius,
        pVertex[k0 + j]);
      if i < 13 then
        pColor[k0 + j] := ComputeColor(pVertex[k0 + j], i <= 7);
      if i = 0 then
        Break;
    end;

    if i > 1 then
    begin
      if i = 13 then
      begin
        GL.Begin_(GL_QUAD_STRIP);
        for j := cSlices downto 0 do
        begin
          GL.Color4fv(@pColor[k1 + j]);
          GL.Vertex3fv(@pVertex[k1 + j]);
          GL.Color4fv(@clrTransparent);
          GL.Vertex3fv(@pVertex[k0 + j]);
        end;
        GL.End_;
      end
      else
      begin
        GL.Begin_(GL_QUAD_STRIP);
        for j := cSlices downto 0 do
        begin
          GL.Color4fv(@pColor[k1 + j]);
          GL.Vertex3fv(@pVertex[k1 + j]);
          GL.Color4fv(@pColor[k0 + j]);
          GL.Vertex3fv(@pVertex[k0 + j]);
        end;
        GL.End_;
      end;
    end
    else if i = 1 then
    begin
      GL.Begin_(GL_TRIANGLE_FAN);
      GL.Color4fv(@pColor[k1]);
      GL.Vertex3fv(@pVertex[k1]);
      for j := k0 + cSlices downto k0 do
      begin
        GL.Color4fv(@pColor[j]);
        GL.Vertex3fv(@pVertex[j]);
      end;
      GL.End_;
    end;
  end;
  rci.GLStates.DepthWriteMask := True;

  FreeMem(pVertex);
  FreeMem(pColor);
end;

procedure TForm1.LoadConstellationLines;
var
  sl, line: TStrings;
  pos1, pos2: TAffineVector;

  function LonLatToPos(lon, lat: Single): TAffineVector;
  var
    f: Single;
  begin
    SinCos(lat * (PI / 180), Result[1], f);
    SinCos(lon * (360 / 24 * PI / 180), f,
      Result[0], Result[2]);
  end;

var
  i: Integer;
begin
  sl := TStringList.Create;
  line := TStringList.Create;

  sl.LoadFromFile('Constellations.dat');

  for i := 0 to sl.Count - 1 do
  begin
    line.CommaText := sl[i];
    pos1 := LonLatToPos(StrToFloatDef(line[0], 0), StrToFloatDef(line[1], 0));
    ConstellationLines.AddNode(pos1);
    pos2 := LonLatToPos(StrToFloatDef(line[2], 0), StrToFloatDef(line[3], 0));
    ConstellationLines.AddNode(pos2);
  end;

  sl.Free;
  line.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Caption := Format('%.1f FPS', [GLSceneViewer.FramesPerSecond]);
  GLSceneViewer.ResetPerformanceMonitor;
end;

procedure TForm1.GLCadencerProgress(Sender: TObject; const deltaTime,
  newTime: Double);
//var
//   d : Double;
//   p : TAffineVector;
begin
  //   d:=GMTDateTimeToJulianDay(Now-2+newTime*timeMultiplier);
     // make earth rotate
  SPEarth.TurnAngle := SPEarth.TurnAngle + deltaTime * timeMultiplier;

  {   p:=ComputePlanetPosition(cSunOrbitalElements, d);
     ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius));
     LSSun.Position.AsAffineVector:=p; }

     // moon rotates on itself and around earth (not sure about the rotation direction!)

  {   p:=ComputePlanetPosition(cMoonOrbitalElements, d);
     ScaleVector(p, 0.5*cAUToKilometers*(1/cEarthRadius)); }

  DCMoon.TurnAngle := DCMoon.TurnAngle + deltaTime * timeMultiplier / 29.5;
  SPMoon.TurnAngle := 180 - DCMoon.TurnAngle;

  // honour camera movements
  if (dmy <> 0) or (dmx <> 0) then
  begin
    GLCameraControler.MoveAroundTarget(ClampValue(dmy * 0.3, -5, 5),
      ClampValue(dmx * 0.3, -5, 5));
    dmx := 0;
    dmy := 0;
  end;
  // this gives us smoother camera movements
  cameraTimeSteps := cameraTimeSteps + deltaTime;
  while cameraTimeSteps > 0.005 do
  begin
    GLCamera.Position.AsVector := VectorLerp(GLCamera.Position.AsVector,
      GLCameraControler.Position.AsVector,
      0.05);
    cameraTimeSteps := cameraTimeSteps - 0.005;
  end;
  // smooth constellation appearance/disappearance
  with ConstellationLines.LineColor do
    if Alpha <> constellationsAlpha then
    begin
      Alpha := ClampValue(Alpha + Sign(constellationsAlpha - Alpha) * deltaTime, 0, 0.5);
      ConstellationLines.Visible := (Alpha > 0);
    end;
end;

procedure TForm1.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx := x;
  my := y;
end;

procedure TForm1.GLSceneViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssLeft] then
  begin
    dmx := dmx + (mx - x);
    dmy := dmy + (my - y);
  end
  else if Shift = [ssRight] then
    GLCamera.FocalLength := GLCamera.FocalLength * Power(1.05, (my - y) * 0.1);
  mx := x;
  my := y;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  f: Single;
begin
  if (WheelDelta > 0) or (GLCameraControler.Position.VectorLength > 0.90) then
  begin
    f := Power(1.05, WheelDelta * (1 / 120));
    GLCameraControler.AdjustDistanceToTarget(f);
  end;
  Handled := True;
end;

procedure TForm1.GLSceneViewerDblClick(Sender: TObject);
begin
  GLSceneViewer.OnMouseMove := nil;
  if WindowState = wsMaximized then
  begin
    WindowState := wsNormal;
    BorderStyle := bsSizeToolWin;
  end
  else
  begin
    BorderStyle := bsNone;
    WindowState := wsMaximized;
  end;
  GLSceneViewer.OnMouseMove := GLSceneViewerMouseMove;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);

  procedure LoadHighResTexture(libMat: TGLLibMaterial; const fileName: string);
  begin
    if FileExists(fileName) then
    begin
      libMat.Material.Texture.Compression := tcStandard;
      libMat.Material.Texture.Image.LoadFromFile(fileName);
    end;
  end;

begin
  case Key of
    #27: Close;
    'm', 'M':
      begin
        GLCamera.MoveTo(SPMoon);
        GLCameraControler.MoveTo(SPMoon);
        GLCamera.TargetObject := SPMoon;
        GLCameraControler.TargetObject := SPMoon;
      end;
    'e', 'E':
      begin
        GLCamera.MoveTo(DCEarthSystem);
        GLCameraControler.MoveTo(DCEarthSystem);
        GLCamera.TargetObject := DCEarthSystem;
        GLCameraControler.TargetObject := DCEarthSystem;
      end;
    'h': if not highResResourcesLoaded then
      begin
        GLSceneViewer.Cursor := crHourGlass;
        try
          if DirectoryExists('HighResPack') then
            ChDir('HighResPack');
          with GLMaterialLibrary do
          begin
            LoadHighResTexture(Materials[0], 'land_ocean_ice_4096.jpg');
            LoadHighResTexture(Materials[1], 'land_ocean_ice_lights_4096.jpg');
            LoadHighResTexture(Materials[2], 'moon_2048.jpg');
          end;
          if FileExists('Hipparcos_9.0.stars') then
          begin
            GLSkyDome.Stars.Clear;
            GLSkyDome.Stars.LoadStarsFile('Hipparcos_9.0.stars');
            GLSkyDome.StructureChanged;
          end;
          GLSceneViewer.Buffer.AntiAliasing := aa2x;
        finally
          GLSceneViewer.Cursor := crDefault;
        end;
        highResResourcesLoaded := True;
      end;
    'c': constellationsAlpha := 0.5 - constellationsAlpha;
    '0'..'9': timeMultiplier := Power(Integer(Key) - Integer('0'), 3);
  end;
end;

end.

