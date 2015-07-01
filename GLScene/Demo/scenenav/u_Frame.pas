unit u_Frame;

interface


uses
  SysUtils, Classes, Forms, StdCtrls, TypInfo,

  GLScene,GLObjects,GLGeomObjects;


type
  TFrame1 = class(TFrame)
    procedure edKeyPress(Sender: TObject; var Key: Char);
    procedure edChange(Sender: TObject);
  public
    lastpick: TGLBaseSceneObject;
    procedure ShowParams;
  end;

implementation

uses u_Main;


{$R *.dfm}


//
// ShowParams
//
procedure TFrame1.ShowParams;

  procedure addLabel(x,y:integer; cap:string);
  var lbl: TLabel;
  begin
    lbl := TLabel.Create(self);
    lbl.Left := x;
    lbl.Top := y;
    lbl.Caption := cap;
    lbl.Parent := self;
    end;

  procedure addSpin(x,y,w:integer; prm:string; prm2:string = '');
  var ed: TEdit;
      param: PPropInfo;
  begin
    ed := TEdit.Create(self);
    ed.Parent := self;
    ed.Hint := prm;
    ed.Left := x;
    ed.Top := y;
    ed.Width := w;
    ed.Height := 20;
    ed.OnKeyPress := edKeyPress;
    ed.OnChange := edChange;
    param := GetPropInfo(form1.pick, pchar(prm));
    if param <> nil then begin
      if param.PropType^.Kind = tkInteger then
        ed.Tag := 10
      else if param.PropType^.Kind = tkFloat then
        ed.Tag := 11;
      case ed.Tag of
        10:ed.Text := inttostr(GetOrdProp(form1.pick, param));
        11:ed.Text := format('%.4f', [GetFloatProp(form1.pick, param)]);
        end;
      end;
    end;

var
    i:integer;

begin

  with form1 do begin

    if (lastpick <> pick) or (pick = nil) then
      for i := self.ControlCount - 1 downto 0 do
        self.Controls[i].Free
    else exit;

    lastpick := pick;
    if pick = nil then exit;

    if pick is TGLCube then begin

      addLabel(10, 10, 'Width:');
      addSpin(120, 8, 64, 'CubeWidth');
      addLabel(10, 30, 'Depth:');
      addSpin(120, 28, 64, 'CubeDepth');
      addLabel(10, 50, 'Height:');
      addSpin(120, 48, 64, 'CubeHeight');

      end
    else if pick is TGLSphere then begin

      addLabel(10, 10, 'Radius:');
      addSpin(120, 8, 64, 'Radius');
      addLabel(10, 30, 'Slices:');
      addSpin(120, 28, 64, 'Slices');
      addLabel(10, 50, 'Stacks:');
      addSpin(120, 48, 64, 'Stacks');

      end
    else if pick is TGLFrustrum then begin

      addLabel(10, 10, 'Base Width:');
      addSpin(120, 8, 64, 'BaseWidth');
      addLabel(10, 30, 'Base Depth:');
      addSpin(120, 28, 64, 'BaseDepth');
      addLabel(10, 50, 'Apex Height:');
      addSpin(120, 48, 64, 'ApexHeight');
      addLabel(10, 70, 'Height:');
      addSpin(120, 68, 64, 'Height');

      end;

    end;

end;


//
// edKeyPress
//
procedure TFrame1.edKeyPress;
begin

  case key of
    '0'..'9',',','-',#13,#8:;
    else key:=#0;
    end;

end;


//
// edChange
//
procedure TFrame1.edChange;
var
    param: PPropInfo;
    i: integer;
    f: single;

begin

  with TEdit(sender) do begin

    param := GetPropInfo(form1.pick, pchar(Hint));
    if param <> nil then begin

      case Tag of
        10:begin
          if not trystrtoint(Text, i) then
            i := 0;
          SetOrdProp(form1.pick, param, i);
          end;
        11:begin
          if not trystrtofloat(Text, f) then
            f := 0;
          SetFloatProp(form1.pick, param, f);
          end;
        end;
      end;

    end;

end;

end.
