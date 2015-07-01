unit uMain;

interface

uses uUtils, pngimage,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLVectorFileObjects, GLObjects, GLCoordinates,
  GLWin32Viewer, Grids, ComCtrls, ExtCtrls, GLCrossPlatform, BaseClasses,
  GLHUDObjects, Menus, ShellCtrls, GLFile3DS, vectortypes, vectorgeometry,
  GLGraph, ToolWin, GLSpaceText, StdCtrls, GLGraphics, Spin, Buttons,
  ImgList, ActnList, ActnMan, ActnCtrls, XPStyleActnCtrls, ActnMenus;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    Panel1: TPanel;
    Panel2: TPanel;
    sg: TStringGrid;
    p_vp: TGLSceneViewer;
    p_cam: TGLCamera;
    p_ff: TGLFreeForm;
    scene: TGLScene;
    vp: TGLSceneViewer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    p_dc: TGLDummyCube;
    Panel3: TPanel;
    tv: TShellTreeView;
    m_vp: TGLMemoryViewer;
    gr: TGLXYZGrid;
    GLPlane1: TGLPlane;
    dc_world: TGLDummyCube;
    Panel4: TPanel;
    tb: TToolBar;
    tb3: TToolButton;
    colorDlg: TColorDialog;
    ToolBar1: TToolBar;
    tb1: TToolButton;
    Panel5: TPanel;
    Memo1: TMemo;
    cb: TComboBox;
    se: TSpinEdit;
    SpeedButton1: TSpeedButton;
    ToolBar2: TToolBar;
    tb5: TToolButton;
    sgl: TStringGrid;
    Panel6: TPanel;
    se_w: TSpinEdit;
    se_h: TSpinEdit;
    Label1: TLabel;
    ImageList1: TImageList;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action3: TAction;
    Action4: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    tb2: TToolButton;
    tb4: TToolButton;
    expDlg: TSaveDialog;
    se_r: TSpinEdit;
    Label2: TLabel;
    ToolBar3: TToolBar;
    tbW: TToolButton;
    tbH: TToolButton;
    Label3: TLabel;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; r: TRect;
      State: TGridDrawState);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure sgEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure vpDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure vpDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tb3Click(Sender: TObject);
    procedure tb1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure vpDblClick(Sender: TObject);
    procedure tb5Click(Sender: TObject);
    procedure se_wChange(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure tb4Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure tbWClick(Sender: TObject);
  private
  public
    z:single;

    prevBmp:TBitmap;
    dragName:string;

    canDrag:boolean;
    drag_obj:TGLCustomSceneObject;
    drag_delta:TVector;

    function GetScale(ff:TGLFreeForm):TVector3f;
  end;

var
  Form1: TForm1;


implementation

uses uNew;

{$R *.dfm}

function TForm1.GetScale(ff:TGLFreeForm):TVector3f;
var v1,v2:TVector3f;
    f:single;
begin

  ff.GetExtents(v1,v2);
  f:=1/VectorDistance(v1,v2);
  setvector(result,f,f,f);

end;

//
//<—— Run ——————————————————————————————————————————————————————————————————«««—
//
procedure TForm1.FormCreate(Sender: TObject);
begin

  z:=0;
  memo1.Text:='';
  m_vp.Buffer.BackgroundAlpha:=0;

  prevBmp:=TBitmap.Create;
  prevBmp.Height:=40;

  tv.Root:=extractfiledir(application.ExeName)+'\data';
  //dataInit('data');

  with cb.Items do begin
    Clear;
    AddStrings(screen.Fonts);
    cb.ItemIndex:=0;//IndexOfName('Verdana');
    end;

end;

procedure TForm1.tvChange(Sender: TObject; Node: TTreeNode);
var sr:TSearchRec;
    lst:TStringList;
begin

  if tv.Root<>'C:\' then begin

    setcurrentdir(tv.Path);

    lst:=TStringList.Create;
    if FindFirst('*.3ds', faAnyFile-faDirectory, sr)=0 then begin
      lst.Add(sr.name);
      while FindNext(sr)=0 do lst.Add(sr.name);
      FindClose(sr);
      end;

    if fileexists('prev.bmp')then prevBmp.LoadFromFile('prev.bmp')
      else prevBmp.Width:=0;

    sg.Repaint;
    p_ff.visible:=false;

    end;

end;

procedure TForm1.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
  r: TRect; State: TGridDrawState);
begin

  if acol+arow*5<prevBmp.Width div 40 then
    bitblt(sg.Canvas.Handle,acol*41,arow*41,40,40,
           prevBmp.Canvas.Handle,(acol+arow*5)*40,0,srccopy)
  else sg.Canvas.FillRect(rect(acol*41,arow*41,40+acol*41,40+arow*41));

end;

procedure TForm1.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);

begin

  if acol+arow*5<prevBmp.Width div 40 then begin
    p_ff.LoadFromFile(format('%.2d.3ds',[acol+arow*5+1]));
    //p_ff.Scale.SetVector(getScale(p_ff));
    p_ff.visible:=true;
    end
  else p_ff.visible:=false;

end;

procedure TForm1.sgStartDrag(Sender: TObject; var DragObject: TDragObject);
var s:string;
begin

  panel6.Visible:=false;
  with sg.Selection do
    s:=format('%.2d.3ds',[Left+Top*5+1]);
  if fileexists(s)then dragName:=s;

end;

procedure TForm1.sgEndDrag(Sender, Target: TObject; X, Y: Integer);
begin

  dragName:='';

end;

procedure TForm1.vpDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

  accept:=dragName<>'';

end;

procedure TForm1.vpDragDrop(Sender, Source: TObject; X, Y: Integer);
var v:TVector;
begin

  if dragName<>'' then
    with TGLFreeForm(dc_world.AddNewChild(TGLFreeForm))do begin
      LoadFromFile(dragName);
      v:=vp.Buffer.ScreenToVector(x, vp.Height-y);
      v[2]:=z;z:=z+0.01;
      Position.SetPoint(v);
      Scale.Scale(0.01);
      end;
  dragName:='';

end;

procedure TForm1.sgMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin

  setcurrentdir(tv.Path);

  if shift=[ssleft]then
    sg.BeginDrag(true);

end;

procedure TForm1.vpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var obj:TGLBaseSceneObject;
    v:TVector;
begin

  obj:=vp.Buffer.GetPickedObject(x,y);
  canDrag:=(obj is TGLFreeForm)or(obj is TGLSpaceText);

  if canDrag then begin
    drag_obj:=TGLFreeForm(obj);
    v:=vp.Buffer.ScreenToVector(x,vp.Height-y);
    setVector(drag_delta, obj.Position.X-v[0], obj.Position.Y-v[1], 0);
    end
  else drag_obj:=nil;

  panel6.Visible:=drag_obj is TGLFreeForm;
  if drag_obj is TGLFreeForm then
    with TGLFreeForm(drag_obj)do begin
      se_w.Value:=abs(round(Scale.X*5000));
      se_h.Value:=abs(round(Scale.Y*5000));
      se_r.Value:=round(RollAngle);
      tbW.Down:=Scale.X<0;
      tbH.Down:=Scale.Y<0;
      end;

  tb.Visible:=canDrag;
  vp.SetFocus;

end;

procedure TForm1.vpMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var v:TVector;
begin

  if canDrag then begin
    v:=vectorAdd(vp.Buffer.ScreenToVector(x, vp.Height-y), drag_delta);
    if drag_obj is TGLFreeForm then v[2]:=0.5 else v[2]:=5;
    drag_obj.Position.SetPoint(v);
    end;

end;

procedure TForm1.vpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  canDrag:=false;

end;

procedure TForm1.tb3Click(Sender: TObject);
  procedure Color(obj:TGLCustomSceneObject);
  begin
    with obj.Material.FrontProperties.Emission do begin
      colorDlg.Color:=AsWinColor;
      if colorDlg.Execute then AsWinColor:=colorDlg.Color;
      end
    end;
begin

  if sender=tb2 then Color(glplane1)
    else Color(drag_obj);

end;

procedure TForm1.tb1Click(Sender: TObject);
begin

  panel5.Visible:=not panel5.Visible;
  if panel5.Visible then memo1.SetFocus;

end;

procedure TForm1.Exit1Click(Sender: TObject);
begin

  close;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if(key=vk_delete)and(drag_obj<>nil)and(not panel5.Visible)then
    drag_obj.Free;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin

  with TGLSpaceText(dc_world.AddNewChild(TGLSpaceText))do begin
    if(panel5.Tag*memo1.Tag<>0)then
      Position.SetPoint(panel5.Tag*0.001, memo1.Tag*0.001, 1);
    Font.Charset:=RUSSIAN_CHARSET;
    Font.Name:=cb.Text;
    TextHeight:=se.Value/10;
    Text:=memo1.Text;
    Extrusion:=2;
    end;
  panel5.Visible:=false;
  panel5.Tag:=0;
  memo1.Tag:=0;

end;

procedure TForm1.vpDblClick(Sender: TObject);
begin

  if drag_obj is TGLSpaceText then
    with TGLSpaceText(drag_obj)do begin
      se.Value:=round(textHeight*10);
      cb.Text:=Font.Name;
      memo1.Text:=Text;
      panel5.Tag:=round(Position.X*1000);
      memo1.Tag:=round(Position.Y*1000);
      Free;
      panel5.Visible:=true;
      end;

end;

procedure TForm1.tb5Click(Sender: TObject);
begin

  sgl.Visible:=not sgl.Visible;

end;

procedure TForm1.se_wChange(Sender: TObject);
var i:integer;
begin

  if(sender=se_w)and(se_w.Text<>'')then begin
    i:=se_w.Value;
    if i<25 then i:=25;
    if i>200 then i:=200;
    TGLFreeForm(drag_obj).Scale.X:=i*0.0002;
    end;
  if(sender=se_h)and(se_h.Text<>'')then begin
    i:=se_h.Value;
    if i<25 then i:=25;
    if i>200 then i:=200;
    TGLFreeForm(drag_obj).Scale.Y:=i*0.0002;
    end;
  if(sender=se_r)and(se_r.Text<>'')then begin
    i:=se_r.Value;
    TGLFreeForm(drag_obj).RollAngle:=i;
    end;

end;

procedure TForm1.Action3Execute(Sender: TObject);
var img:TPNGObject;
    bmp1,bmp2:TGLBitmap;
    bmpG1,bmpG2:TGLBitmap;
    a1,a2:integer;
    pb1,pb2:PByteArray;
    f:single;
    Alpha:boolean;
begin

  expDlg.InitialDir:=extractfiledir(application.ExeName);
  if expDlg.Execute then begin

    Alpha:=glplane1.Material.FrontProperties.Emission.AsWinColor and $ffffff=$ffffff;

    m_vp.Width:=round(glplane1.Width)*100;
    m_vp.Height:=round(glplane1.Height)*100;

    bmp1:=TBitmap.Create;bmp1.PixelFormat:=pf24bit;
    bmp1.Width:=m_vp.Width;
    bmp1.Height:=m_vp.Height;

    bmp2:=TBitmap.Create;bmp2.PixelFormat:=pf24bit;
    bmp2.Width:=m_vp.Width shr 2;
    bmp2.Height:=m_vp.Height shr 2;

    bmpG1:=TBitmap.Create;bmpG1.PixelFormat:=pf24bit;
    bmpG1.Width:=m_vp.Width;
    bmpG1.Height:=m_vp.Height;

    bmpG2:=TBitmap.Create;bmpG2.PixelFormat:=pf24bit;
    bmpG2.Width:=bmp2.Width;
    bmpG2.Height:=bmp2.Height;

    glplane1.Visible:=false;gr.Visible:=false;f:=cam.FocalLength;
    m_vp.Buffer.BackgroundColor:=glplane1.Material.FrontProperties.Emission.AsWinColor;
    cam.FocalLength:=100/maxFloat(glplane1.Width,glplane1.Height);
    m_vp.Buffer.RenderToBitmap(bmp1);
    gr.Visible:=true;glplane1.Visible:=true;cam.FocalLength:=f;

    if Alpha then begin
      for a2:=0 to bmp1.Height-1 do begin
        pb1:=bmp1.ScanLine[a2];
        pb2:=bmpG1.ScanLine[a2];
        for a1:=0 to bmp1.Width-1 do begin
          if(pb1[a1*3]+pb1[a1*3+1]+pb1[a1*3+2]=765)then begin
            pb2[a1*3]:=0;pb2[a1*3+1]:=0;pb2[a1*3+2]:=0;
            end
          else begin
            pb2[a1*3]:=255;pb2[a1*3+1]:=255;pb2[a1*3+2]:=255;
            end;
          end;
        end;

      stretch(bmpG1,bmpG2,4);
      end;

    stretch(bmp1,bmp2,4);

    img:=TPNGObject.Create;
    img.Assign(bmp2);

    if Alpha then begin
      img.CreateAlpha;
      for a2:=0 to img.Height-1 do begin
        pb1:=bmpG2.ScanLine[a2];
        for a1:=0 to img.Width-1 do
          img.AlphaScanline[a2][a1]:=pb1[a1*3];
        end;
      end;

    img.SaveToFile(expDlg.FileName);

    bmp1.Free;bmp2.Free;
    bmpG1.Free;bmpG2.Free;

    end;

end;

procedure TForm1.tb4Click(Sender: TObject);
begin

  gr.Visible:=tb4.Down;

end;

procedure TForm1.Action1Execute(Sender: TObject);
begin

  form2.ShowModal;

end;

procedure TForm1.tbWClick(Sender: TObject);
begin

  if sender=tbW then
    with TGLFreeForm(drag_obj)do
      if tbW.Down then Scale.X:=-abs(Scale.X)
      else Scale.X:=abs(Scale.X);
  if sender=tbH then
    with TGLFreeForm(drag_obj)do
      if tbH.Down then Scale.Y:=-abs(Scale.Y)
      else Scale.Y:=abs(Scale.Y);

  with TGLFreeForm(drag_obj)do
    if(Scale.X<0)xor(Scale.Y<0)then
      NormalsOrientation:=mnoInvert
    else NormalsOrientation:=mnoDefault;

end;

end.
