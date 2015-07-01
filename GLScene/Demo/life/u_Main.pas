unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,
  Dialogs, Menus, ComCtrls, ToolWin, ExtDlgs, ExtCtrls, StdCtrls, Buttons, Spin,

  GLCrossPlatform, Controls,

  GLGraphics, GLCadencer, GLTexture, GLWin32Viewer, GLScene, GLObjects,
  AsyncTimer, GLUtils, GLHUDObjects, GLCoordinates, BaseClasses;


type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    hudMap: TGLHUDSprite;
    at: TAsyncTimer;
    opendlg: TOpenPictureDialog;
    savedlg: TSavePictureDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    Label4: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Label5: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    p_fps: TPanel;
    Label1: TLabel;
    Edit4: TEdit;
    UpDown4: TUpDown;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    but_run: TSpeedButton;
    cb: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure atTimer(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
    procedure FormResize(Sender: TObject);

  public

    procedure Init(a_Width,a_Height: integer);
    procedure SetPixel(a_Xpos,a_Ypos: integer; a_Get: boolean);
    procedure resizeMap;

  end;


var

  Form1: TForm1;

  mapsz: TPoint;

  br: boolean;
  ma: single;

  buf: array[0..1] of TGLImage;
  bufi: integer = 0;


implementation


{$R *.dfm}


//                                                                   FormCreate
//
procedure TForm1.FormCreate;
begin

  // create default map 32x32
  Init(32, 32);

  openDlg.InitialDir := extractfilepath(paramStr(0)) + 'maps';
  saveDlg.InitialDir := openDlg.InitialDir;

end;


//                                                                         RGBA
//
function RGBA(r,g,b: Byte): TGLPixel32;
begin

  result.r := r;
  result.g := g;
  result.b := b;
  result.a := 255;

end;


//                                                                         Init
//
procedure TForm1.Init(a_Width,a_Height: integer);
var
    a1,a2: integer;
    bmp: TBitmap;

begin

  bufi := 0;
  mapsz := point(a_Width, a_Height);

  // prepare buf's
  if assigned(buf[0]) then buf[0].Free;
  buf[0] := TGLImage.Create;
  if assigned(buf[1]) then buf[1].Free;
  buf[1] := TGLImage.Create;

  bmp := TBitmap.Create;
  bmp.Width := a_Width;
  bmp.Height := a_Height;

  // fill buf's
  for a1 := 0 to a_Width - 1 do
    for a2 := 0 to a_Height - 1 do
      if (a1 xor a2) and 1 > 0 then
        bmp.Canvas.Pixels[a1,a2] := $ffffff
      else
        bmp.Canvas.Pixels[a1,a2] := $e0e0e0;
  buf[0].Assign(bmp);
  buf[1].Assign(bmp);

  bmp.Free;

  hudMap.Width := a_Width;
  hudMap.Height := a_Height;
  hudMap.Material.Texture.Image.Assign(buf[0]);

  resizeMap;

end;


//                                                                     SetPixel
//
procedure TForm1.SetPixel(a_Xpos,a_Ypos: integer; a_Get: boolean);
var
    sx,sy,p,a: integer;

begin

  // convert coords
  sx := round((a_Xpos - hudMap.Position.x + hudMap.Width / 2 - ma/2) / ma);
  sy := round((hudMap.Height / 2 + hudMap.Position.y - a_Ypos - ma/2) / ma);

  // correct coords
  if sx < 0 then sx := 0;
  if sx > mapsz.X - 1 then
    sx := mapsz.X - 1;
  if sy < 0 then sy := 0;
  if sy > mapsz.Y - 1 then
    sy := mapsz.Y - 1;

  p := sy * mapsz.X + sx;

  // get point state or draw
  if a_Get then
    br := buf[bufi].Data[p].r > 0;
  if br then
    buf[bufi].Data[p] := RGBA(0, 0, 0)
  else begin
    a := 255 - 31 * ((sx xor sy) and 1);
    buf[bufi].Data[p] := RGBA(a, a, a);
    end;

  hudMap.Material.Texture.Image.Assign(buf[bufi]);

end;


//                                                                    loadImage
//
procedure TForm1.resizeMap;
begin

  // find min size
  if vp.Width > vp.Height then
    ma := vp.Height
  else
    ma := vp.Width;

  // proportion
  if mapsz.X > mapsz.Y then
    ma := ma / mapsz.X
  else
    ma := ma / mapsz.Y;

  hudMap.Width := ma * mapsz.X;
  hudMap.Height := ma * mapsz.Y;

end;


//                                                                        Timer
//
procedure TForm1.atTimer(Sender: TObject);
var
    a1,a2,a3,a4,p: integer;
    c: boolean;

  function GetN(x,y: integer): integer;

    function Get(x,y: integer): boolean;
    begin

      // border check
      if not cb.Checked then begin
        if x < 0 then x := mapsz.X - 1;
        if x > mapsz.X - 1 then x := 0;
        if y < 0 then y := mapsz.Y - 1;
        if y > mapsz.Y - 1 then y := 0;
        result := buf[bufi].Data[y * mapsz.X + x].r = 0;
        end
      else
        if (x >= 0) and (x < mapsz.X) and (y >= 0) and (y < mapsz.Y) then
          result := buf[bufi].Data[y * mapsz.X + x].r = 0
        else result := false;

      end;

  begin

    result := 0;

    if Get(x - 1, y - 1) then inc(result);
    if Get(x - 1, y) then inc(result);
    if Get(x - 1, y + 1) then inc(result);
    if Get(x, y - 1) then inc(result);
    if Get(x, y + 1) then inc(result);
    if Get(x + 1, y - 1) then inc(result);
    if Get(x + 1, y) then inc(result);
    if Get(x + 1, y + 1) then inc(result);

    end;

begin

  if not but_run.Down then exit;

  // main loop
  for a1 := 0 to mapsz.X - 1 do
    for a2 := 0 to mapsz.Y - 1 do begin

      a3 := GetN(a1, a2);
      a4 := 255 - 31 * ((a1 xor a2) and 1);

      p := a2 * mapsz.X + a1;

      // main algorithm
      if buf[bufi].Data[p].r = 0 then
        c := (a3 = 2) or (a3 = 3)
      else
        c := a3 = 3;

      if c then buf[1-bufi].Data[p] := RGBA(0, 0, 0)
        else buf[1-bufi].Data[p] := RGBA(a4, a4, a4);

      end;

  bufi := 1 - bufi;
  hudMap.Material.Texture.Image.Assign(buf[bufi]);

end;


//                                                                    loadImage
//
procedure TForm1.Button1Click(Sender: TObject);
var
    a1,a2,p: integer;
    bmp: TBitmap;

begin

  if not opendlg.Execute then exit;

  bufi := 0;

  bmp := TBitmap.Create;
  bmp.LoadFromFile(opendlg.FileName);

  mapsz := point(bmp.Width, bmp.Height);
  buf[0].Assign(bmp);
  buf[1].Assign(bmp);

  bmp.Free;

  hudMap.Width := mapsz.X;
  hudMap.Height := mapsz.Y;

  for a1 := 0 to mapsz.X - 1 do
    for a2 := 0 to mapsz.Y - 1 do begin

      p := a2 * mapsz.X + a1;
      with buf[bufi] do
        if (Data[p].r + Data[p].g + Data[p].b) < 192 then
          Data[p] := RGBA(0, 0, 0)
        else
          if (a1 xor a2) and 1 = 1 then
            Data[p] := RGBA(224, 224, 224)
          else
            Data[p] := RGBA(255, 255, 255);

      end;

  hudMap.Material.Texture.Image.Assign(buf[bufi]);

  resizeMap;

end;


//                                                                    saveImage
//
procedure TForm1.Button2Click(Sender: TObject);
var
    bmp: TBitmap;

begin

  if not savedlg.Execute then exit;

  bmp := TBitmap.Create;
  bmp.PixelFormat := pf1bit;
  buf[bufi].AssignToBitmap(bmp);
  bmp.SaveToFile(savedlg.FileName);
  bmp.Free;

end;


//                                                                    MouseDown
//
procedure TForm1.vpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if button = mbLeft then
    SetPixel(x, y, true);

end;


//                                                                    MouseMove
//
procedure TForm1.vpMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin

  if shift = [ssleft] then
    SetPixel(x, y, false);

end;


//                                                                     newWidth
//
procedure TForm1.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin

  edit2.Text := inttostr(32 shl updown2.Position);

end;


//                                                                     newImage
//
procedure TForm1.Button3Click(Sender: TObject);
begin

  Init(strtoint(edit2.Text), strtoint(edit3.Text));

end;


//                                                                    newHeight
//
procedure TForm1.UpDown3Click(Sender: TObject; Button: TUDBtnType);
begin

  edit3.Text := inttostr(32 shl updown3.Position);

end;


//                                                                  newInterval
//
procedure TForm1.UpDown4Click(Sender: TObject; Button: TUDBtnType);
begin

  with UpDown4 do
    if Position <= 10 then
      at.Interval := 1000 div Position
    else
      at.Interval := (20 - Position) * 10 + 1;

end;


//                                                                   FormResize
//
procedure TForm1.FormResize(Sender: TObject);
begin

  hudMap.Position.SetPoint(vp.Width div 2, vp.Height div 2, 0);
  resizeMap;

end;


//                                                                    FormClose
//
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  at.Enabled := false;
  buf[0].Free;
  buf[1].Free;

end;


end.

