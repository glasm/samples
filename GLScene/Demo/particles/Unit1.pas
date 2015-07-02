unit Unit1;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,

  tga,

  GLWin32Viewer, GLCrossPlatform, BaseClasses, GLScene, GLCadencer,
  GLCoordinates, GLObjects, GLHUDObjects, AsyncTimer, GLRenderContextInfo;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    player: TGLHUDSprite;
    GLCamera1: TGLCamera;
    dogl: TGLDirectOpenGL;
    p1: TGLHUDSprite;
    AsyncTimer1: TAsyncTimer;
    GLCube1: TGLCube;
    p2: TGLHUDSprite;
    p3: TGLHUDSprite;
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure FormCreate(Sender: TObject);
  end;

type

  t_stone = record
    posx,posy: single;    // позиция
    vel: single;          // скорость частицы
    time: single;         // смещение частицы
    end;

  t_fire = record
    posx,posy: single;    // позиция
    vel: single;          // скорость частицы
    size: single;         // размер частицы
    time: single;         // смещение частицы
    end;

  t_air = record
    posx,posy: single;    // позиция
    size: single;         // размер частицы
    time: single;         // смещение частицы
    color: cardinal;      // смещение частицы
    end;


const
  pl_RX = 50;             // радиус X кольца
  pl_RY = 70;             // радиус Y кольца

  stone_DX = 10;          // разброс позиции по X
  stone_DY = 10;          // разброс позиции по Y

  fire_DX = 10;           // разброс позиции по X
  fire_DY = 10;           // разброс позиции по Y

  air_DX = 10;            // разброс позиции по X
  air_DY = 10;            // разброс позиции по Y


var
  Form1: TForm1;

  sarr: array[0..29] of t_stone;
  farr: array[0..69] of t_fire;
  aarr: array[0..49] of t_air;

  dt: single;


implementation

{$R *.dfm}


//
//
function newStone: t_stone;
var
    a: single;

begin

  a := random * 2 * 3.1415926535;
  result.posx := pl_RX * sin(a) + stone_DX * random - stone_DX / 2;
  result.posy := pl_RY * cos(a) + stone_DX * random - stone_DX / 2;
  result.vel := random / 2 + 0.5;
  result.time := random;

end;


//
//
function newFire: t_fire;
var
    a: single;

begin

  a := random * 2 * 3.1415926535;
  result.posx := pl_RX * sin(a) + fire_DX * random - fire_DX / 2;
  result.posy := pl_RY * cos(a) + fire_DX * random - fire_DX / 2;
  result.size := random / 2 + 1;
  result.vel := random + 0.5;
  result.time := random;

end;


//
//
function newAir: t_air;

  function c:byte;
  begin
    result := 128 + round(128 * random - 0.5);
    end;

var
    a: single;

begin

  a := random * 2 * 3.1415926535;
  result.posx := pl_RX * sin(a) + air_DX * random - air_DX / 2;
  result.posy := pl_RY * cos(a) + air_DX * random - air_DX / 2;
  result.size := random / 3 + 1;
  result.time := random;
  result.color := c + (c shl 8) + (c shl 16);

end;




procedure TForm1.AsyncTimer1Timer;
begin

  caption := vp.FramesPerSecondText(2);
  vp.ResetPerformanceMonitor;

end;

procedure TForm1.GLCadencer1Progress;
begin

  dt := deltatime;

  vp.invalidate;

end;


//                                                                   FormCreate
//
procedure TForm1.FormCreate(Sender: TObject);
var
    i: integer;

begin

  for i := 0 to high(sarr) do
    sarr[i] := newStone;

  for i := 0 to high(farr) do
    farr[i] := newFire;

  for i := 0 to high(aarr) do
    aarr[i] := newAir;

end;


//                                                                   doglRender
//
procedure TForm1.doglRender;

  function _stone(x:single):single;
  begin
    result := 1 - x*x*x;
    end;

  function _fire(x:single):single;
  begin
    result := (x-x*x) * 4;
    end;

  function _air(x:single):single;
  begin
    x := 1 - x;
    result := (x*x - x*x*x) * 6;
    end;

var
    i: integer;

begin

  // stones
  for i := 0 to high(sarr) do
    with sarr[i] do begin

      time := time + dt;
      if time > 1 then
        sarr[i] := newStone;

      posy := posy + vel * dt / (1 - time) * 20;

      p1.Material.FrontProperties.Diffuse.Alpha := _stone(time);
      p1.Position.SetPoint(player.Position.AsVector);
      p1.Translate(posx - 150, posy, 0);

      p1.Render(rci);

      end;

  // fire
  for i := 0 to high(farr) do
    with farr[i] do begin

      time := time + dt;
      if time > 1 then
        farr[i] := newFire;

      posy := posy - vel * dt * 40;

      p2.Position.SetPoint(player.Position.AsVector);
      p2.Translate(posx, posy, 0);

      p2.Width := 32 * size * _fire(time);
      p2.Height := p2.Width;

      p2.Render(rci);

      end;

  // air
  for i := 0 to high(aarr) do
    with aarr[i] do begin

      time := time + dt;
      if time > 1 then
        aarr[i] := newAir;

      p3.Material.FrontProperties.Diffuse.AsWinColor := color;
      p3.Position.SetPoint(player.Position.AsVector);
      p3.Translate(posx + 150, posy, 0);

      p3.Width := 32 * size * _air(time);
      p3.Height := p3.Width;

      p3.Render(rci);

      end;

end;




end.


