unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,

  GLCrossPlatform, Controls,

  Dialogs, ExtCtrls, BaseClasses, GLScene, GLWin32Viewer, GLVectorFileObjects,
  GLCoordinates, GLObjects, GLFileOBJ, GLFileSTL, StdCtrls, VectorGeometry,
  VectorTypes, AsyncTimer, ToolWin, ActnMan, ActnColorMaps, ActnList,
  PlatformDefaultStyleActnCtrls, ActnCtrls, ActnMenus, ComCtrls, Grids,
  GLBitmapFont, GLWindowsFont, GLRenderContextInfo, GLHUDObjects, GLKeyboard,
  Buttons, GLState, GLMaterial, GLHiddenLineShader, Menus;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    GLScene1: TGLScene;
    cam: TGLCamera;
    dc: TGLDummyCube;
    light: TGLLightSource;
    openDlg: TOpenDialog;
    ff: TGLFreeForm;
    dc_cam: TGLDummyCube;
    at: TAsyncTimer;
    dc_list: TGLDummyCube;
    sph: TGLSphere;
    dc_trg: TGLDummyCube;
    ActionManager1: TActionManager;
    action1: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    XPColorMap1: TXPColorMap;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    sph_pick: TGLSphere;
    Panel2: TPanel;
    SaveDlg: TSaveDialog;
    sph_cur: TGLSphere;
    wbf: TGLWindowsBitmapFont;
    dogl: TGLDirectOpenGL;
    hudtext: TGLHUDText;
    Panel9: TPanel;
    oxline: TGLLines;
    oyline: TGLLines;
    ozline: TGLLines;
    Panel8: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel5: TPanel;
    Edit1: TEdit;
    Panel6: TPanel;
    Edit2: TEdit;
    Panel7: TPanel;
    Edit3: TEdit;
    Edit4: TEdit;
    Panel10: TPanel;
    vp: TGLSceneViewer;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action12: TAction;
    sg: TStringGrid;
    pm: TPopupMenu;
    X1: TMenuItem;
    X2: TMenuItem;
    Y1: TMenuItem;
    Y2: TMenuItem;
    Z1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure import_butClick(Sender: TObject);
    procedure vpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure atTimer(Sender: TObject);
    procedure vpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure vpMouseEnter(Sender: TObject);
    procedure Edit4KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure doglRender(Sender: TObject; var rci: TRenderContextInfo);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure sb1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; ARect: TRect;
      State: TGridDrawState);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure X1Click(Sender: TObject);
    procedure sgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

    ff_name: string; // расположение файла текущей модели
    loc_list: array[0..4] of TGLProxyObject; // датчики элементы осей

    procedure loadFreeForm(fname:string); // загрузка модели
    procedure loadList; // загрузка списка датчиков
    procedure saveList(fname:string = ''); // сохранение списка датчиков

    procedure zoom(d: single); // изменение масштаба сцены
    procedure autoZoom; // масштаб сцены относительно модели
    procedure updPos; // отображение координат выбранного датчика

    function getVector( aV:TVector ): TVector; // преобразование координат

  end;

var
  Form1: TForm1;

  m_pos: TPoint; // координаты мыши на предыдущем кадре
  m_turn: boolean = false; // режим вращения
  m_move: boolean = false; // режим перемещения
  m_obj: TGLProxyObject; // датчик под курсором

  d_move: boolean = false; // режим изменения позиции датчика
  d_pos: TVector3f; // позиция датчика
  d_obj: TGLProxyObject; // выбранный датчик

  sg_cnt: integer; // текущее количество датчиков
  sg_sel: integer; // выбранный датчик


implementation

uses uAbout;


{$R *.dfm}


//
// обрабатываем движение мыши в различных режимах
//
procedure TForm1.atTimer(Sender: TObject);
var
    mx,my,d: single;
    v: TVector;
begin

  if (not m_turn) and (not m_move) and (not d_move) then
    exit;

  // перехват клика мышки за окном
  if ((not iskeydown(VK_RBUTTON)) and m_turn) or
     ((not iskeydown(VK_MBUTTON)) and m_move) then begin
    m_turn := false;
    m_move := false;
    vp.Cursor := 0;
    exit;
    end;

  // изменение координат мыши
  with mouse.CursorPos do begin
    mx := (m_pos.X - X) * 0.2;
    my := (m_pos.Y - Y) * 0.2;
  end;
  m_pos := mouse.CursorPos;

  // вращение камеры по двум осям вокруг объекта
  if m_turn then begin
    dc_cam.TurnAngle := dc_cam.TurnAngle + mx;
    cam.MoveAroundTarget( my, 0 );
  end;

  // перемещение всей сцены параллельно экрану
  if m_move then begin
    d := cam.DistanceToTarget * 0.01; // коэффициент масштаба
    cam.MoveTargetInEyeSpace( 0, mx * d, -my * d );
  end;

  // интерактивное изменение параметров датчика
  if d_move and (d_obj <> nil) then begin

    d := cam.DistanceToTarget; // коэффициент масштаба
    v := d_obj.AbsolutePosition; // текущая позиция датчика

    // меняем выбранный параметр
    v[0] := v[0] + d_pos[0] * my * (d + v[0]) * 0.005;
    v[1] := v[1] + d_pos[1] * my * (d + v[1]) * 0.005;
    v[2] := v[2] + d_pos[2] * my * (d + v[2]) * 0.005;

    d_obj.AbsolutePosition := v; // смещаем датчик
    dc_trg.AbsolutePosition := v; // смещаем его оси
    updPos; // отображаем изменения

  end;

end;


//
// масштаб от колесика мыши
//
procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
    d: single;
begin

  // мышь над окном просмотра
  if not vp.Focused then
    exit;

  zoom( wheeldelta );

end;


//
// нажатие клавиш
//
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  // включение режима надписей [Ctrl]
  if key = vk_control then
    vp.Invalidate;

  // управление камерой
  if key = vk_left then
    dc_cam.TurnAngle := dc_cam.TurnAngle - 5;
  if key = vk_right then
    dc_cam.TurnAngle := dc_cam.TurnAngle + 5;
  if key = vk_up then
    cam.MoveAroundTarget( -5, 0 );
  if key = vk_down then
    cam.MoveAroundTarget( 5, 0 );

end;


//
// нажатие клавиш
//
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if (key = '=') or (key = '+') then zoom( 3 );
  if key = '-' then zoom( -3 );

end;


//
// отключени режима надписей [Ctrl]
//
procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if key = vk_control then
    vp.Invalidate;

end;


//
// загрузка модели
//
procedure TForm1.import_butClick(Sender: TObject);
begin

  if openDlg.Execute then begin

    // загрузка модели
    loadFreeForm( openDlg.FileName );

    // загрузка датчиков
    loadList;

  end;

end;


//
// начало ручного изменения параметра выбранного датчика
//
procedure TForm1.Panel5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  // режим изменения параметров датчика
  d_move := true;

  // указываем меняемый параметр
  d_pos := NullVector;
  d_pos[TPanel(sender).Tag] := 1;

  // сохраняем текушую позицию мыши
  m_pos := mouse.CursorPos;

end;


//
// прекращение изменения параметра датчика
//
procedure TForm1.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  d_move := false;
  saveList;

end;


//
// отработка нажатия кнопки мыши
//
procedure TForm1.vpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    v: TVector;
    i: integer;
    s: string;
    cs: boolean;
    li: TListItem;
begin

  if button = mbLeft then begin

    cs := true;
    i := sg.Cols[0].IndexOfObject(m_obj);
    sg.OnSelectCell( sg, 0, i, cs );
    application.ProcessMessages;

    // новый датчик
    if (m_obj = nil) and sph_pick.Visible then begin

      v := sph_pick.AbsolutePosition;
      d_obj := TGLProxyObject.CreateAsChild( dc_list );
      d_obj.MasterObject := sph_cur;
      d_obj.Absoluteposition := v;
      dc_trg.AbsolutePosition := d_obj.AbsolutePosition;

      i := 1;
      // поиск уникального имени
      repeat
        s := 'датчик_';
        if i < 10 then s := s + '00'
          else if i < 100 then s := s + '0';
        s := s + inttostr(i);
        inc( i );
      until sg.Cols[0].IndexOf( s ) < 1;

      // добавляем датчик
      inc(sg_cnt);
      with sg.Rows[ sg_cnt ] do begin
        Strings[0] := s;
        Objects[0] := d_obj;
      end;
      cs := true;
      sg.OnSelectCell( nil, 0, sg_cnt, cs );
      edit4.Text := s;

      saveList;

    end;

    dc_trg.Visible := d_obj <> nil; // показываем оси датчика

    updPos;

  end;

  // режим перемещения
  if button = mbMiddle then begin
    m_move := true;
    vp.Cursor := crSizeAll;
    end;
  // режим вращения или доп меню
  if button = mbRight then
    if (d_obj <> nil) and (m_obj = d_obj) then begin
      with mouse.CursorPos do
        pm.Popup( x,y );
    end else
      m_turn := true;

  // запоминаем координаты мыши
  m_pos := mouse.CursorPos;

end;


//
// поиск точки пересечения с моделью или наведение на датчик
//
procedure TForm1.vpMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
    mp,pos,norm: TVector;
    i: integer;
    v: TVector;
    obj: TGLProxyObject;
begin

  // модель загружена
  if ff.MeshObjects.Count = 0 then
    exit;

  // преобразуем экранные координаты мыши в оконные
  with vp.ScreenToClient( mouse.CursorPos ) do
    mp := vectormake(x, vp.Height - y, 0);

  // луч от мышки в сцену
  v := vectorNormalize( vp.Buffer.ScreenToVector( mp ));

  // поиск точки для добавления датчика
  sph_pick.Visible := false;
  if ff.OctreeRayCastIntersect(
    vp.Buffer.ScreenToWorld( mp ), v, @pos, @norm ) then begin

    sph_pick.Visible := true;
    sph_pick.AbsolutePosition := pos;
    sph_pick.AbsoluteUp := norm;

  end;

  // ищем датчик для будущего редактирования
  m_obj := nil;
  for i := 1 to sg_cnt do begin

    obj := TGLProxyObject( sg.Objects[0,i] );
    if obj <> nil then
      // пересечение датчика с лучом
      if RayCastIntersectsSphere( vp.Buffer.ScreenToWorld( mp ), v,
        obj.AbsolutePosition, sph.Radius) then
        if m_obj <> nil then begin
          if cam.DistanceTo( obj ) < cam.DistanceTo( m_obj ) then
            m_obj := obj; // сохраняем ближний к камере датчик
        end else
          m_obj := obj; // сохраняем текущий

  end;

  // датчик может быть дальше чем точка пересечения с моделью
  if cam.DistanceTo( sph_pick ) - cam.DistanceTo( m_obj ) < -sph.Radius then
    m_obj := nil;

  // определяем курсор мыши
  if (m_obj <> nil) and (m_obj is TGLProxyObject) then
    vp.Cursor := -21
  else
    vp.Cursor := 0;

end;


//
// завершение режима вращения и перемещения
//
procedure TForm1.vpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  m_turn := false;
  m_move := false;
  vp.Cursor := 0;

end;


//
// выбор осевого датчика
//
procedure TForm1.X1Click(Sender: TObject);
const
    c: array[0..4] of string = ('-X','+X','-Y','+Y','+Z');
var
    i: integer;
begin

  // выбран датчик
  if (d_obj = nil) and (sg_sel > 0) then
    exit;

  with TControl(Sender) do begin

    for i := 1 to sg_cnt do
      if sg.Cells[1, i] = c[Tag] then begin
        sg.Cells[1, i] := '';
        break;
      end;

    loc_list[Tag] := d_obj;
    sg.Cells[1, sg_sel ] := c[Tag];

  end;

  saveList;
  sg.Repaint;

end;


//
// разрешаем масштабирование сцены, но запрещаем перематывание списка
//
procedure TForm1.vpMouseEnter(Sender: TObject);
begin

  vp.SetFocus;

end;


//
// экспорт списка датчиков
//
procedure TForm1.Action2Execute(Sender: TObject);
begin

  if saveDlg.Execute then
    saveList( saveDlg.FileName );

end;


//
// сброс параметров камеры
//
procedure TForm1.Action7Execute(Sender: TObject);
begin

  autoZoom;

end;


//
// окно информации о программе
//
procedure TForm1.About1Click(Sender: TObject);
begin

  form2.showModal;

end;


//
// название датчика
//
procedure TForm1.Edit4KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (d_obj <> nil) and (sg_sel > 0) then begin

    sg.Cells[0, sg_sel] := edit4.Text;
    saveList;

  end;

end;


//
// выход
//
procedure TForm1.Exit1Click(Sender: TObject);
begin

  close;

end;


//
// удаление датчика
//
procedure TForm1.Action5Execute(Sender: TObject);
var
    i: integer;
    s: string;
begin

  // датчик выбран
  if d_obj = nil then
    exit;

  s := sg.Cells[1, sg_sel];
  if s = '-X' then loc_list[0] := nil
  else if s = '+X' then loc_list[1] := nil
  else if s = '-Y' then loc_list[2] := nil
  else if s = '+Y' then loc_list[3] := nil
  else if s = '+Z' then loc_list[4] := nil;

  // удаляем выбранный
  for i := sg_sel to sg.RowCount - 2 do
    sg.Rows[i] := sg.Rows[i + 1];
  dec( sg_cnt );
  FreeAndNil(d_obj);

  dc_trg.Visible := false; // прячем оси датчика
  edit4.Text := '';

  updPos;
  saveList;

end;


//
// удаление всех датчиков
//
procedure TForm1.Action6Execute(Sender: TObject);
const
    msg = 'Датчики будут удалены безвозвратно. Продолжить ?';
var
    i: integer;
begin

  // список не пустой
  if sg.Objects[0,1] = nil then
    exit;

  // подтверждение на удаление
  if (sender <> nil) and (MessageDlg( msg, mtWarning, mbYesNo, 0 ) = mrNo) then
    exit;

  loc_list[0] := nil;
  loc_list[1] := nil;
  loc_list[2] := nil;
  loc_list[3] := nil;
  loc_list[4] := nil;

  // удаляем
  for i := 1 to 99 do begin
    if sg.Objects[0, i] <> nil then
      TGLProxyObject( sg.Objects[0, i] ).Free;
    sg.Rows[i].Text := '';
  end;
  sg_cnt := 0;

  dc_trg.Visible := false; // прячем оси датчика
  edit4.Text := '';

  updPos;
  saveList;

end;


//
// вывод надписей
//
procedure TForm1.doglRender(Sender: TObject; var rci: TRenderContextInfo);
var
    i: integer;
    p: TVector;
    r: single;
    obj: TGLProxyObject;
begin

  if sg.Objects[0,1] = nil then
    exit;

  for i := 1 to sg_cnt do
    if (sg_sel = i) or iskeydown(vk_control) then begin

      obj := TGLProxyObject( sg.Objects[0, i] );
      p := obj.AbsolutePosition;
      p[1] := p[1] + ff.BoundingSphereRadius / 50;
      p := vp.Buffer.WorldToScreen( p );

      hudtext.Position.SetPoint( p[0], vp.Height - p[1], 0 );

      { // размер надписи от расстояния до камеры
      r := ff.BoundingSphereRadius / cam.DistanceTo( obj ) / 50;
      p := vectorscale( XYZHmgVector, 5 * r );
      hudtext.Scale.SetVector( p );
      }

      hudtext.Text := sg.Cells[0,i];
      hudtext.Render( rci );

    end;

  rci.GLStates.DepthFunc := cfAlways;

  if (loc_list[0] <> nil) and (loc_list[1] <> nil) then begin

    oxline.Nodes[0].AsVector := vectorLerp( loc_list[0].AbsolutePosition,
      loc_list[1].AbsolutePosition, 0.5 );
    oxline.Nodes[1].AsVector := loc_list[1].AbsolutePosition;
    oxline.Render( rci );

    end;

  if (loc_list[2] <> nil) and (loc_list[3] <> nil) then begin

    oyline.Nodes[0].AsVector := vectorLerp( loc_list[2].AbsolutePosition,
      loc_list[3].AbsolutePosition, 0.5 );
    oyline.Nodes[1].AsVector := loc_list[3].AbsolutePosition;
    oyline.Render( rci );

    end;

  if (loc_list[0] <> nil) and (loc_list[1] <> nil) and (loc_list[4] <> nil) then begin

    ozline.Nodes[0].AsVector := vectorLerp( loc_list[0].AbsolutePosition,
      loc_list[1].AbsolutePosition, 0.5 );
    ozline.Nodes[1].AsVector := loc_list[4].AbsolutePosition;
    ozline.Render( rci );

    end;

end;


//
// выбор датчика для пересчета локальных координат
//
procedure TForm1.sb1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  panel9.Tag := TControl(Sender).Tag;
  panel9.Show;

end;


//
// "ручная" отрисовка ячеек таблицы
//
procedure TForm1.sgDrawCell(Sender: TObject; ACol, ARow: Integer; aRect: TRect;
  State: TGridDrawState);
var
    s,t: string;
    fs: TFormatSettings;
    v: TVector;
    obj: TGLProxyObject;
begin

  s := '';
  t := '';
  obj := TGLProxyObject(sg.Objects[0,arow]);

  // названия столбцов
  if arow = 0 then begin

    case acol of
      0: s := 'Датчик';
      1: s := 'Ось';
      2: s := 'X';
      3: s := 'Y';
      4: s := 'Z';
    end;

    sg.Canvas.Font.Color := $660000;
    sg.Canvas.Brush.Color := $eeeeee;

  // датчики
  end else begin

    sg.Canvas.Font.Color := 0;
    if arow = sg_sel then // выбранный
      sg.Canvas.Brush.Color := $fff0e0
    else
      sg.Canvas.Brush.Color := $ffffff;

    // первые два столбца просто отображаем
    if acol < 2 then
      s := sg.Cells[acol, arow]

    // в остальных выводим координаты
    else if obj <> nil then begin

      s := format( '%.2f' , [obj.AbsolutePosition[acol - 2]]);

      t := '';
      v := getVector( obj.AbsolutePosition );
      if (acol = 2) and (v[0] <> -99999) then
        t := format( '%.3f' , [v[0]])
      else if (acol = 3) and (v[1] <> -99999) then
        t := format( '%.3f' , [v[1]])
      else if (acol = 4) and (v[2] <> -99999) then
        t := format( '%.3f' , [v[2]]);

    end;

  end;

  // закрашиваем ячейку
  sg.Canvas.FillRect( rect(arect.Left + 1, arect.Top + 1,
    arect.Right - 2, arect.Bottom - 2));

  // первый столбец, выравнивание по левому краю
  if acol = 0 then
    sg.Canvas.TextOut( arect.Left + 2, (arect.Bottom + arect.Top) div 2 - 7, s )
  // второй столбец, выравнивание по центру
  else if acol = 1 then
    sg.Canvas.TextOut(
      (arect.Right + arect.Left - sg.Canvas.TextWidth( s )) div 2,
      (arect.Bottom + arect.Top) div 2 - 7, s )
  // координаты разделяем на две строчки с лправым и левым выравниванием
  else begin
    if arow > 0 then sg.Canvas.Font.Color := $006666;
    sg.Canvas.TextOut( arect.Right - sg.Canvas.TextWidth( s ) - 4, arect.Top + 2, s );
    if arow > 0 then begin
      sg.Canvas.Font.Color := 0;
      sg.Canvas.TextOut( arect.Left + 2, arect.Top + 13, t );
    end;
  end;

  // добавляем рамочку
  sg.Canvas.Pen.Color := $dddddd;
  sg.Canvas.MoveTo( arect.Right - 1, arect.Top + 1 );
  sg.Canvas.LineTo( arect.Right - 1, arect.Bottom - 1 );
  sg.Canvas.LineTo( arect.Left + 1, arect.Bottom - 1 );

end;


//
// вызов дополнительного меню
//
procedure TForm1.sgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    mx,my: integer;
    cs: boolean;
begin

  // дополнительный выбор ячейки правой кнопкой + вызов меню
  if button = mbRight then begin

    sg.MouseToCell(x,y, mx,my);
    cs := true;
    if sg.Objects[0,my] <> nil then begin

      sg.OnSelectCell( sg, 0, my, cs );
      application.ProcessMessages;

      with mouse.CursorPos do
        pm.Popup( x,y );

    end;

  end;

end;


//
// выбор датчика из списка
//
procedure TForm1.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
    obj: TGLProxyObject;
begin

  if (sg.Objects[0, arow] <> nil) and (arow <> sg_sel) then begin
    sg_sel := arow;
    sg.Repaint;
  end;

  // предыдущий датчик
  if (d_obj <> nil) and (sender <> nil) then begin
    d_obj.MasterObject := sph;
    d_obj := nil;
  end;

  // очищаем информацию
  edit4.Text := '';
  updPos;

  if arow > 0 then
    obj := TGLProxyObject( sg.Objects[0, arow] )
  else exit;

  if obj = nil then
    exit;

  d_obj := obj;
  d_obj.MasterObject := sph_cur;
  dc_trg.AbsolutePosition := d_obj.AbsolutePosition;
  dc_trg.Visible := true; // показываем оси датчика

  // заполняем информацию
  edit4.Text := sg.Cells[0, arow];
  updPos;

end;



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



//
// загрузка модели
//
procedure TForm1.loadFreeForm(fname:string);
var
    src: TGLFreeForm;
    i: integer;
    mObj: TMeshObject;
    fg: TFGVertexIndexList;
begin

  // сохраняем имя текущей модели
  ff_name := fname;

  // OBJ просто загружаем, STL оптимизируем (собираем треугольники в группу)
  if lowercase( extractfileext( fname )) = '.obj' then begin

    ff.LoadFromFile( fname );

  end else begin

    src := TGLFreeForm.Create(self);
    src.LoadFromFile( fname );

    ff.MeshObjects.Clear;
    mObj := TMeshObject.CreateOwned( ff.MeshObjects );
    mObj.Mode := momFaceGroups;

    fg := TFGVertexIndexList.CreateOwned( mObj.FaceGroups );
    fg.Mode := fgmmTriangles;

    with src.MeshObjects[0] do begin

      mObj.Vertices.Add( Vertices );
      mObj.Normals.Add ( Normals );

      for i := 0 to Vertices.count - 1 do
        fg.Add( i );

    end;

    ff.StructureChanged;
    src.Free;

  end;

  // центр масс объекта
  ff.AbsolutePosition := NullHmgVector;
  ff.AbsolutePosition := vectornegate( ff.BarycenterAbsolutePosition );

  // ускорение поиска пересечения с поверхностью модели
  ff.BuildOctree(1);

  // автоматический масштаб
  autoZoom;

end;


//
// загрузка списка
//
procedure TForm1.loadList;
var
    i,j: integer;
    tmp,lst: TStringList;
    v: TVector;
    s: string;
    cs: boolean;
    obj: TGLProxyObject;
begin

  // очищаем список датчиков
  Action6Execute( nil );

  // есть ли список рядом с моделью
  if not fileexists( ff_name + '.list' ) then
    exit;

  lst := TStringList.Create;
  tmp := TStringList.Create;

  lst.LoadFromFile( ff_name + '.list' );
  DecimalSeparator := '.';
  for i := 0 to lst.Count - 1 do begin

    tmp.Text := stringReplace( lst[i], ';', #13#10, [rfReplaceAll] );
    if tmp.Count > 3 then begin

      // загружаем числа с '.'
      if (not trystrtofloat( tmp[1], v[0] )) or
         (not trystrtofloat( tmp[2], v[1] )) or
         (not trystrtofloat( tmp[3], v[2] )) then begin

        // или загружаем числа с ','
        DecimalSeparator := ',';
        if (not trystrtofloat( tmp[1], v[0] )) or
           (not trystrtofloat( tmp[2], v[1] )) or
           (not trystrtofloat( tmp[3], v[2] )) then

          // или обнуляем координаты
          v := NullHmgVector;

      end;

      DecimalSeparator := '.';

    end;

    // новый датчик
    obj := TGLProxyObject.CreateAsChild( dc_list );
    obj.Absoluteposition := v;
    obj.MasterObject := sph;

    inc( sg_cnt );
    with sg.Rows[ sg_cnt ] do begin
      Text := tmp[0] + #13#10' '#13#10' '#13#10' '#13#10' ';
      Objects[0] := obj;
    end;

    s := '';
    if tmp.Count > 4 then begin
      s := tmp[4];
      j := -1;
      if s = '+X' then j := 1
        else if s = '-Y' then j := 2
          else if s = '+Y' then j := 3
            else if s = '+Z' then j := 4
              else if s = '-X' then j := 0;
      if j >= 0 then begin
        loc_list[j] := obj;
        sg.Cells[1, sg_cnt] := s;
      end;
    end;

  end;

  tmp.Free;
  lst.Free;

end;


//
// сохранение списка
//
procedure TForm1.saveList(fname:string = '');
var
    i: integer;
    lst: TStringList;
    v: TVector;
    obj: TGLProxyObject;
begin

  lst := TStringList.Create;
  for i := 1 to sg_cnt do begin

      obj := TGLProxyObject( sg.Objects[0, i] );
      // сохранение списка
      if fname = '' then begin
        v := obj.AbsolutePosition;
        lst.Add( sg.Cells[0, i] + format( ';%.6f;%.6f;%.6f;', [v[0],v[1],v[2]] ) +
          sg.Cells[1, i]);
      // экспорт списка
      end else begin
        v := getVector(obj.AbsolutePosition);
        lst.Add( sg.Cells[0, i] + format( ';%.6f;%.6f;%.6f;', [v[0],v[1],v[2]] ));
      end;

    end;

  // сохранение списка или экспорт
  if fname = '' then
    lst.SaveToFile( ff_name + '.list', TEncoding.UTF8 )
  else
    lst.SaveToFile( fname, TEncoding.UTF8 );

  lst.Free;

end;


//
// изменение масштаба сцены
//
procedure TForm1.zoom(d: single);
begin

  if d < 0 then d := 1 / 0.96 else d := 0.96;
  cam.MoveInEyeSpace( cam.DistanceToTarget * (1 - d), 0, 0);

end;


//
// автоматический масштаб сцены относительно габаритов модели
//
procedure TForm1.autoZoom;
begin

  // если модель не пуста
  if ff.MeshObjects.Count = 0 then
    exit;

  // смещаем камеру в центр
  dc_cam.AbsolutePosition := NullHmgVector;

  // масштаб
  with cam.Position do
    SetPoint( vectorScale( vectorNormalize(AsAffineVector),
    ff.BoundingSphereRadius * 3));
  // дальность видимости сцены
  cam.DepthOfView := cam.DistanceToTarget * 5;

  // радиус датчиков
  sph.Radius := ff.BoundingSphereRadius / 80;
  // радиус выбранного датчика
  sph_cur.Radius := ff.BoundingSphereRadius / 60;
  // радиус точки пересечения с моделью
  sph_pick.Radius := sph.Radius * 0.7;

  // туман относительно габаритов
  vp.Buffer.FogEnvironment.FogColor.Alpha := 0.2 / ff.BoundingSphereRadius;

end;


//
// обновление координат выбранного датчика
//
procedure TForm1.updPos;
var
    v: TVector;
    s: string;
    p: integer;
    i: integer;
begin

  edit1.Text := '';
  edit2.Text := '';
  edit3.Text := '';

  // если выбран
  if d_obj = nil then exit;

  // координаты датчика
  v := d_obj.AbsolutePosition;
  edit1.Text := format( '%.3f', [v[0]] );
  edit2.Text := format( '%.3f', [v[1]] );
  edit3.Text := format( '%.3f', [v[2]] );

  // одновляем запись в списке
  i := sg.Cols[0].IndexOfObject( d_obj );
  if i > 0 then begin
    sg.Repaint;
    application.ProcessMessages;
  end;

end;


//
// обновление локальных координат
//
function TForm1.getVector( aV:TVector ): TVector;
var
    v,v0: TVector;
begin

  if (loc_list[0] <> nil) and (loc_list[1] <> nil) then begin
    v0 := vectorLerp( loc_list[0].AbsolutePosition,
      loc_list[1].AbsolutePosition, 0.5);
    result[0] := PointProject( aV, v0,
      VectorNormalize(vectorSubtract( loc_list[1].AbsolutePosition, v0 )));
  end else result[0] := -99999;

  if (loc_list[2] <> nil) and (loc_list[3] <> nil) then begin
    v0 := vectorLerp( loc_list[2].AbsolutePosition,
      loc_list[3].AbsolutePosition, 0.5);
    result[1] := PointProject( aV, v0,
      VectorNormalize(vectorSubtract( loc_list[3].AbsolutePosition, v0 )));
  end else result[1] := -99999;

  if (loc_list[0] <> nil) and (loc_list[1] <> nil) and (loc_list[4] <> nil) then begin
    v0 := vectorLerp( loc_list[0].AbsolutePosition,
      loc_list[1].AbsolutePosition, 0.5);
    result[2] := PointProject( aV, v0,
      VectorNormalize(vectorSubtract( loc_list[4].AbsolutePosition, v0 )));
  end else result[2] := -99999;

end;


end.

