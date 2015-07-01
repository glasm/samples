unit u_Game;


interface


uses

   Classes, Forms, SysUtils,

   GLCrossPlatform, BaseClasses, GLScene, VectorGeometry, VectorTypes,
   GLObjects, GLGraph, GLMesh,

   u_Levels;


type

  t_layer = array[-2..2] of array[-2..2] of integer;

  c_Game = class(TComponent)
  private

    f_plpos: TPoint;
    f_pldmg: single;
    f_plspd: single;
    f_plsdz: single;
    f_pllvs: integer;

    f_map: array of t_layer;
    f_varr: array of TVector3f;
    f_lvl: integer;

    procedure _fadeDmg(d: single);
    procedure _progress(s: TObject; const d,n: double);
    procedure _init;
    procedure _load(n: integer);
    procedure _redrawMap;
    procedure _redrawGrid;
    procedure _wallTest;
    procedure _updLProg;
    procedure _updLives;

  public

    constructor Create(a_Owner: TComponent); override;
    destructor Destroy; override;

    procedure Run;
    procedure Over;

    procedure stepLeft;
    procedure stepRight;
    procedure stepUp;
    procedure stepDown;

  end;


implementation

uses

  u_Main;


const
  f1: array[1..3] of single = (1.501, 2.501, 2.501);
  f2: array[1..3] of single = (1.501, 1.501, 2.501);
  i1: array[1..3] of integer = (1, 1, 2);
  i2: array[1..3] of integer = (1, 2, 2);


//
// constructor
//
constructor c_Game.Create;
begin

  inherited Create(a_Owner);

  mform.cad.OnProgress := _Progress;

  f_plpos := point(0, 0);
  f_pldmg := 0;
  f_plspd := 1;
  f_plsdz := 0;
  f_lvl := 1;

end;


//
// destructor
//
destructor c_Game.Destroy;
begin


  inherited;

end;


//
// _fadeDmg
//
procedure c_Game._fadeDmg(d: single);
var
    c: integer;

begin

  c := rgb(32 + round(f_pldmg * 100), 16, 0);
  mform.Color := c;
  with mform.vp.Buffer do begin
    BackgroundColor := c;
    with FogEnvironment.FogColor do begin
      AsWinColor := c;
      Alpha := 0.08;
      end;
    end;

  f_pldmg := f_pldmg - d * 4;
  if f_pldmg < 0 then
    f_pldmg := 0;

end;


//
// _Progress
//
procedure c_Game._Progress;

  function _lerp(var x0:single; x1:single; k:single = 1): single;
  var
      x2: single;
  begin
    x2 := Lerp(x0, x1, clampValue(d * k, 0, 1));
    result := x2 - x0;
    x0 := x2;
    end;

var
    f: single;

begin

  _fadeDmg(d);

  if f_pllvs < 0 then
    if f_pldmg = 0 then Over
      else exit;

  with mform.cam.Position do
    Z := Z - f_plspd * d;
  _lerp(f_plspd, 12, 1/6);

  with mform.cam.Position do begin
    f := x;
    _lerp(f, f_plpos.x, 4);
    x := f;
    f := y;
    _lerp(f, f_plpos.y, 4);
    y := f;
    end;

  _wallTest;
  _updLProg;
  _updLives;

  if -mform.cam.Position.z/3 > length(f_map) then
    _load(f_lvl mod 3 + 1);

end;


//
// _init
//
procedure c_Game._init;
begin

  f_plspd := 1;
  f_pllvs := 4;
  f_plsdz := 0;
  mform.img_left.Tag := -1;
  f_plpos := point(0,0);
  mform.cam.Position.SetPoint(0,0,30);

end;


//
// _Load
//
procedure c_Game._Load;
var
    s: TStringList;
    a1,a2,a3,k: integer;
    p: TPoint;
    b: word;

begin

  f_lvl := n;
  _init;

  s := TStringList.Create;

  s.CommaText := g_lvl[n];
  setlength(f_map, s.Count);

  // count
  b := 0;
  for a1 := 0 to high(f_map) do
    for a2 := 1 to length(s[a1]) do
      inc(b);

  setLength(f_varr, b);
  k := 0;

  // decode
  for a1 := 0 to high(f_map) do begin

    for a2 := -2 to 2 do
      for a3 := -2 to 2 do
        f_map[a1][a2][a3] := 0;

    for a2 := 1 to length(s[a1]) do begin

      b := ord(s[a1][a2]);
      if b < $5a then
        dec(b, $41)
      else
        dec(b, $61);

      case f_lvl of
        1: p := point(b mod 3 - 1, 1 - b div 3);
        2: p := point(b mod 3 - 1, 2 - b div 3);
        3: p := point(b mod 5 - 2, 2 - b div 5);
        end;

      if ord(s[a1][a2]) < $5a then f_map[a1][p.x][p.y] := -1
        else f_map[a1][p.x][p.y] := 1;

      setVector(f_varr[k], p.X, p.Y, -a1 * 3);
      inc(k);

      end;
    end;

  _redrawMap;
  _redrawGrid;

  s.Free;

end;


//
// _redrawMap
//
procedure c_Game._redrawMap;
var
  a1: integer;
  v: TVector3f;
  c: TVector;
  d: single;
  varr: array of TVertexData;

begin

  setLength(varr, length(f_varr)*4);

  for a1 := 0 to high(f_varr) do begin

    setvector(v, f_varr[a1]);

    if f_map[-round(v[2]/3)][round(v[0])][round(v[1])] < 0 then begin
      setvector(c, 0, 0.8, 1, 0.85);
      d := 0.4;
      end
    else begin
      setvector(c, 1, 1, 1, 0.85);
      d := 0.5;
      end;

    setvector(varr[a1*4 + 0].coord, v[0] - d, v[1] - d, v[2]);
    setvector(varr[a1*4 + 1].coord, v[0] - d, v[1] + d, v[2]);
    setvector(varr[a1*4 + 2].coord, v[0] + d, v[1] + d, v[2]);
    setvector(varr[a1*4 + 3].coord, v[0] + d, v[1] - d, v[2]);

    setvector(varr[a1*4 + 0].color, c);
    setvector(varr[a1*4 + 1].color, c);
    setvector(varr[a1*4 + 2].color, c);
    setvector(varr[a1*4 + 3].color, c);

    end;

  mform.mesh.Vertices.Clear;

  for a1 := high(varr) downto 0 do
    mform.mesh.Vertices.AddVertex(varr[a1]);

end;


//
// _redrawGrid
//
procedure c_Game._redrawGrid;
begin

  with mform.wl do begin
    Position.SetPoint(-f2[f_lvl], 0, 0);
    with YSamplingScale do begin
      min := -f1[f_lvl];
      max := f1[f_lvl];
      end;
    end;

  with mform.wr do begin
    Position.SetPoint(f2[f_lvl], 0, 0);
    with YSamplingScale do begin
      min := -f1[f_lvl];
      max := f1[f_lvl];
      end;
    end;

  with mform.wt do begin
    Position.SetPoint(0, f1[f_lvl], 0);
    with XSamplingScale do begin
      min := -f2[f_lvl];
      max := f2[f_lvl];
      end;
    end;

  with mform.wb do begin
    Position.SetPoint(0, -f1[f_lvl], 0);
    with XSamplingScale do begin
      min := -f2[f_lvl];
      max := f2[f_lvl];
      end;
    end;

  with mform.lines do begin
    Nodes[0].x := -i1[f_lvl] - 0.5;
    Nodes[0].y := i2[f_lvl] + 0.5;
    Nodes[1].x := -i1[f_lvl] - 0.5;
    Nodes[1].y := i2[f_lvl] + 0.5;
    Nodes[2].x := i1[f_lvl] + 0.5;
    Nodes[2].y := i2[f_lvl] + 0.5;
    Nodes[3].x := i1[f_lvl] + 0.5;
    Nodes[3].y := i2[f_lvl] + 0.5;
    Nodes[4].x := -i1[f_lvl] - 0.5;
    Nodes[4].y := -i2[f_lvl] - 0.5;
    Nodes[5].x := -i1[f_lvl] - 0.5;
    Nodes[5].y := -i2[f_lvl] - 0.5;
    Nodes[6].x := i1[f_lvl] + 0.5;
    Nodes[6].y := -i2[f_lvl] - 0.5;
    Nodes[7].x := i1[f_lvl] + 0.5;
    Nodes[7].y := -i2[f_lvl] - 0.5;
    end;

end;


//
// _wallTest
//
procedure c_Game._wallTest;
var
    a1,a2,a3: integer;

begin

  if (f_pldmg > 0) or (mform.cam.position.z > 0) or
     (mform.cam.position.z > f_plsdz) then exit;

  a3 := -round(mform.cam.position.z/3);

  for a1 := -2 to 2 do
    for a2 := -2 to 2 do
      with mform.cam do
        if distanceto(affinevectormake(a1, a2, 0.3 - a3*3)) < 0.6 then
          case f_map[a3][a1][a2] of
            1: begin
               f_plspd := 4;
               f_plsdz := position.z - 2;
               dec(f_pllvs);
               if f_pllvs < 0 then f_pldmg := 2
                 else f_pldmg := 1;
               end;
           -1: begin
               f_plspd := 2;
               f_plsdz := position.z - 2;
               end;
            end;

end;


//
// _updLProg
//
procedure c_Game._updLProg;
var
    a1,a2,p: integer;

begin

  p := round(clampvalue(- 13/3 * mform.cam.Position.z / length(f_map), 0, 13));

  with mform.img_left do
    if Tag <> p then begin

      Canvas.Brush.Color := $0;
      Canvas.FillRect(Canvas.ClipRect);
      Canvas.Brush.Color := $bbc6cb;

      Tag := p;

      if p < 5 then a2 := p
        else a2 := 5;
      for a1 := 0 to a2-1 do begin
        Canvas.FillRect(rect(0, 85 - 18*a1, 13, 72 - 18*a1));
        Canvas.FillRect(rect(72, 18*a1, 85, 18*a1 + 13));
        end;

      if p < 8 then a2 := p - 5
        else a2 := 3;
      for a1 := 0 to a2-1 do begin
        Canvas.FillRect(rect(18 + 18*a1, 0, 31 + 18*a1, 13));
        Canvas.FillRect(rect(54 - 18*a1, 72, 67 - 18*a1, 85));
        end;

      if p < 11 then a2 := p - 8
        else a2 := 3;
      for a1 := 0 to a2-1 do begin
        Canvas.FillRect(rect(54, 18 + 18*a1, 67, 31 + 18*a1));
        Canvas.FillRect(rect(18, 54 - 18*a1, 31, 67 - 18*a1));
        end;

      if p > 11 then begin
        Canvas.FillRect(rect(36, 18, 49, 31));
        Canvas.FillRect(rect(36, 54, 49, 67));
        end;

      if p = 13 then
        Canvas.FillRect(rect(36, 36, 49, 49));

      end;

end;


//
// _updLives
//
procedure c_Game._updLives;
begin

  with mform.img_right do
    if Tag <> f_pllvs then begin

      Canvas.Brush.Color := $0;
      Canvas.FillRect(Canvas.ClipRect);
      Canvas.Brush.Color := $bbc6cb;

      Tag := f_pllvs;

      if Tag > 0 then
        Canvas.FillRect(rect(45,45, 85,85));
      if Tag > 1 then
        Canvas.FillRect(rect(0,45, 40,85));
      if Tag > 2 then
        Canvas.FillRect(rect(45,0, 85,40));
      if Tag > 3 then
        Canvas.FillRect(rect(0,0, 40,40));

      end;

end;


//
// Run
//
procedure c_Game.Run;
begin

  _load(f_lvl);

  g_state := ps_Play;

  mform.cad.Enabled := true;
  mform.vp.Visible := true;

  mform.img_left.Visible := true;
  mform.img_right.Visible := true;

end;


//
// Over
//
procedure c_Game.Over;
begin

  g_state := ps_Start;

  mform.vp.Visible := false;
  mform.cad.Enabled := false;

  mform.img_left.Visible := false;
  mform.img_right.Visible := false;

end;


//
// stepLeft
//
procedure c_Game.stepLeft;
begin

  if f_plpos.x > -i1[f_lvl] then
    dec(f_plpos.x);

end;


//
// stepRight
//
procedure c_Game.stepRight;
begin

  if f_plpos.x < i1[f_lvl] then
    inc(f_plpos.x);

end;


//
// stepUp
//
procedure c_Game.stepUp;
begin

  if f_plpos.y < i2[f_lvl] then
    inc(f_plpos.y);

end;


//
// stepDown
//
procedure c_Game.stepDown;
begin

  if f_plpos.y > -i2[f_lvl] then
    dec(f_plpos.y);

end;

end.


