unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLCadencer, GLWin32Viewer, GLScene, GLObjects,
  VectorGeometry, GLKeyboard, GLTerrainRenderer, GLGeomObjects, GLMultiPolygon,
  GLExtrusion, AsyncTimer, GLHeightData, GLCoordinates, GLCrossPlatform,
  BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cad: TGLCadencer;
    cam: TGLCamera;
    dc_world: TGLDummyCube;
    dc_player: TGLDummyCube;
    dc_cam: TGLDummyCube;
    dc_target: TGLDummyCube;
    ter: TGLTerrainRenderer;
    GLCustomHDS1: TGLCustomHDS;
    GLExtrusionSolid1: TGLExtrusionSolid;
    targ: TGLSprite;
    AsyncTimer1: TAsyncTimer;
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure GLCustomHDS1StartPreparingData(heightData: THeightData);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public

    procedure createMap;

  end;

var
  Form1: TForm1;
  _m: array of array of single;
  dx,dz: double;

implementation

{$R *.dfm}


procedure TForm1.FormCreate;
begin

  createMap;

end;


procedure TForm1.createMap;
var
    i,j,k: integer;
    x,y,d: integer;
    f: single;
begin

  SetLength( _m, 256, 256);

  randomize;

  // generate landscape [fractal]
  for i := 0 to 7 do
    for j := 0 to 7 do
      _m[i shl 5, j shl 5] := (random - 0.5) * 256;
  for k := 0 to 4 do begin
    d := 16 shr k;
    for i := 0 to (1 shl(k + 3)) - 1 do
      for j := 0 to (1 shl(k + 3)) - 1 do begin

        f := (random - 0.5) * (128 shr k);
        x := d + i shl(5 - k);
        y := j shl(5 - k);
        _m[x, y] := (_m[x - d, y] + _m[(x + d) and 255, y]) / 2 + f;

        f := (random - 0.5) * (128 shr k);
        x := i shl(5 - k);
        y := d + j shl(5 - k);
        _m[x, y] := (_m[x, y - d] + _m[x, (y + d) and 255]) / 2 + f;

        f := (random - 0.5) * (128 shr k);
        x := d + i shl(5 - k);
        y := d + j shl(5 - k);
        _m[x, y] := (_m[x - d, y - d] + _m[x - d, (y + d) and 255] +
          _m[(x + d) and 255, y - d] + _m[(x + d) and 255,
          (y + d) and 255]) / 4 + f;

        end;
    end;

  // turn to planet type
  for i := 0 to 255 do
    for j := 0 to 255 do
      _m[i,j] := power(1.011, power((_m[i,j] + 384) * 0.101, 1.61));

end;


procedure TForm1.cadProgress;
var
    v: TVector;
    f: single;
begin

  // height
  v := VectorSubtract( dc_target.AbsolutePosition,
    VectorScale( dc_target.AbsoluteDirection, dz * 20 + 10 ));
  dc_target.Position.Y := dc_target.Position.Y +
    (10 - dc_target.Position.Y + ter.InterpolatedHeight(v)) * deltatime;

  // move
  if (iskeydown(vk_up) or iskeydown(ord('W'))) and (dz < 1) then
    dz := dz + deltatime / (0.1 + dz * dz)
  else dz := dz * (1 - deltatime * 2);
  dc_target.Move( -dz * deltatime * 40);

  // turn
  if (iskeydown(vk_left) or iskeydown(ord('A'))) and (dx < 2) then
    dx := dx + deltatime / (0.1 + dx * dx / 2);
  if (iskeydown(vk_right) or iskeydown(ord('A'))) and(dx > -2) then
    dx := dx - deltatime / (0.1 + dx * dx / 2);

  dx := dx * (1 - deltatime);

  dc_target.Turn( -dx * deltatime * 50);
  dc_player.AbsoluteDirection := dc_target.AbsoluteDirection;
  dc_player.RollAngle := dx * 45;

  // interpolation
  f := dc_cam.DistanceTo( dc_target.AbsolutePosition );
  if abs(f - 4) > 0.1 then
    dc_cam.Position.Translate( VectorScale( VectorSubtract(
      dc_target.AbsolutePosition, dc_cam.AbsolutePosition ),
      (f - 4) * deltatime ));
  if abs(dc_cam.Position.y - dc_target.Position.Y - 0.5) > 0.1 then
    dc_cam.Position.Y := dc_cam.Position.Y -
      (dc_cam.Position.y - dc_target.Position.y - 0.5) * deltatime * 10;

  f := dc_player.DistanceTo( dc_target.AbsolutePosition );
  if abs(f - 1) > 0.1 then
    dc_player.Position.Translate( VectorScale( VectorSubtract(
      dc_target.AbsolutePosition, dc_player.AbsolutePosition ),
      (f - 1) * deltatime * 2 ));

  dc_cam.PointTo( dc_target.AbsolutePosition, vectormake( 0, 1, 0 ));

  vp.Invalidate;
  if iskeydown(vk_escape)then
    close;

end;


procedure TForm1.GLCustomHDS1StartPreparingData;
var
    i,j:Integer;
    ln: PSingleArray;
begin

   heightData.DataState := hdsPreparing;
   with heightData do begin

     Allocate(hdtSingle);
     for i := ytop to ytop + size - 1 do begin
       ln := SingleRaster[i - ytop];
       for j := xleft to xleft + size - 1 do
         ln[j - xleft] := _m[j and 255, i and 255] * 0.1;
     end;
     
   end;

end;


procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin

  caption := vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;


procedure TForm1.FormShow(Sender: TObject);
begin

  cad.Enabled := true;

end;

end.

