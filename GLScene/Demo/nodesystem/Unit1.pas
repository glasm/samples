 {
 { Author : Robert W.
 { Date   : 06-03-2004

  ******************************************************************************
 { Description :
 {       This demo is here to show how it's possible to create landscapes using
 {       a Terrain-Node System and saving the Landscape information. I studied
 {       this technique with Gas Powered Games Dungeon Siege and I ported it
 {       to Glscene. For any questions ask :  robert_wst@hotmail.com
 }
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Dialogs,
  ExtCtrls, GLScene, GLVectorFileObjects,vectorgeometry, GLObjects,
  GLWin32Viewer, GLKeyboard, Menus, StdCtrls, GLFile3ds, FileCtrl, AsyncTimer, GLTexture,
  GLGraph, ComCtrls, Jpeg, GLMaterial, GLCoordinates, GLCrossPlatform, Controls,
  BaseClasses;

type
  Tmain_form = class(TForm)
    main_scene: TGLScene;
    main_viewer: TGLSceneViewer;
    glcam: TGLCamera;
    cam_cube: TGLDummyCube;
    nodes: TGLDummyCube;
    preview_mesh: TGLFreeForm;
    main_light: TGLLightSource;
    control_panel: TPanel;
    Label1: TLabel;
    pre_scene: TGLScene;
    pre_viewer: TGLSceneViewer;
    Label2: TLabel;
    file_menu: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    pre_cam: TGLCamera;
    pre_mesh: TGLFreeForm;
    pre_light: TGLLightSource;
    node_filelist: TFileListBox;
    gltimer: TAsyncTimer;
    pre_materials: TGLMaterialLibrary;
    glgrid: TGLXYZGrid;
    status_bar: TStatusBar;
    controls_memo: TMemo;
    node_materials: TGLMaterialLibrary;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    New1: TMenuItem;
    node_plot: TMemo;
    open_dialog: TOpenDialog;
    save_dialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure node_filelistChange(Sender: TObject);
    procedure main_viewerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure main_viewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure main_viewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure gltimerTimer(Sender: TObject);
    procedure node_filelistKeyPress(Sender: TObject; var Key: Char);
    procedure Undo1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure save_dialogCanClose(Sender: TObject; var CanClose: Boolean);
    procedure Load1Click(Sender: TObject);
    procedure open_dialogCanClose(Sender: TObject; var CanClose: Boolean);
    procedure New1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure add_node(position:tglcoordinates;rollangle:single;meshfile:string);
  end;

var
  main_form: Tmain_form;

implementation

{$R *.dfm}
var
//Camera-movements
 mx,my:integer;
//Mouse-Buttons
 rmb,lmb,mmb:boolean;
//Rollangle of the Node
 roll_node:single;

procedure Tmain_form.FormCreate(Sender: TObject);
begin
// Set path's for Textures and 3DS-Files
 node_filelist.Directory := extractfilepath(application.ExeName)+'art\nodes';
 node_materials.TexturePaths := extractfilepath(application.ExeName)+'art\bitmaps';
 pre_materials.TexturePaths := extractfilepath(application.ExeName)+'art\bitmaps';
 node_filelist.Selected[0] := true;
//Load the First Node
 pre_mesh.LoadFromFile(node_filelist.FileName);
 preview_mesh.LoadFromFile(node_filelist.FileName);
 roll_node:=0;
end;

procedure Tmain_form.node_filelistChange(Sender: TObject);
begin
//Selecting Terrain-Node
 pre_mesh.LoadFromFile(node_filelist.FileName);
 preview_mesh.LoadFromFile(node_filelist.FileName);
end;

procedure Tmain_form.main_viewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//Mouse-buttons check
 if button = mbright then  rmb := true;
 if button = mbmiddle then  mmb := true;
 if button = mbleft then  lmb := true;
 mx:=x; my:=y;
end;

procedure Tmain_form.main_viewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
//Move the camera
 if rmb = true then begin
  cam_cube.Position.X := cam_cube.Position.X-((x-mx)/5);
  cam_cube.Position.z := cam_cube.Position.z-((y-my)/5);
  glcam.Position.X := glcam.Position.X-((x-mx)/5);
  glcam.Position.z := glcam.Position.z-((y-my)/5);
 end;
 if mmb = true then glcam.MoveAroundTarget(y-my,0);
 if shift<>[] then begin
  Caption:='Terrain Nodes '+Format('%.2f FPS', [main_viewer.FramesPerSecond]);
  main_viewer.ResetPerformanceMonitor;
 end;
 mx:=x; my:=y;
end;

procedure Tmain_form.main_viewerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//Release Mousebuttons
 rmb := false; mmb := false; lmb := false;
end;

procedure Tmain_form.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
//Zoom Camera
 if wheeldelta > 0 then
 glcam.AdjustDistanceToTarget(0.98)
 else glcam.AdjustDistanceToTarget(1.02)
end;

procedure Tmain_form.gltimerTimer(Sender: TObject);
begin
//Preview Window Animation
 pre_mesh.roll(2);
end;

procedure Tmain_form.node_filelistKeyPress(Sender: TObject; var Key: Char);
begin
//Moving the preview-node
 if iskeydown('a') then preview_mesh.Position.X :=preview_mesh.Position.X+2;
 if iskeydown('d') then preview_mesh.Position.X :=preview_mesh.Position.X-2;
 if iskeydown('w') then preview_mesh.Position.z :=preview_mesh.Position.z+2;
 if iskeydown('s') then preview_mesh.Position.z :=preview_mesh.Position.z-2;
//Adjust altitude of  the preview-node
 if iskeydown('q') then preview_mesh.Position.y :=preview_mesh.Position.y+2;
 if iskeydown('e') then preview_mesh.Position.y :=preview_mesh.Position.y-2;
//Rotating the preview-node
 if iskeydown('r') then begin
  preview_mesh.Roll(90);
  if roll_node = 360 then roll_node :=0;
  roll_node := roll_node +90;
 end;
//Place the node and write coords to script
 if iskeydown(vk_space) then begin
  with tglfreeform(nodes.AddNewChild(tglfreeform)) do begin
   name := 'node'+inttostr(nodes.Count);
   position := preview_mesh.Position;
   direction := Preview_mesh.Direction;
   up := preview_mesh.up;
   scale.Scale(0.1);
   add_node(position,roll_node,node_filelist.FileName);

  end;
//Applying material to the node
  tglfreeform(nodes.FindChild('node'+inttostr(nodes.Count),true)).materiallibrary := node_materials;
  tglfreeform(nodes.FindChild('node'+inttostr(nodes.Count),true)).LoadFromFile(node_filelist.FileName);
 end;
end;

procedure Tmain_form.add_node(position:tglcoordinates;rollangle:single;meshfile:string);
begin
//Attach node to script
 node_plot.Lines.Add('[Node]'+'='+floattostr(position.X)+'°'+floattostr(position.y)+'+'+floattostr(position.z)+'"'
                                 +floattostr(rollangle)+'*'+extractfilename(node_filelist.FileName));
end;

procedure Tmain_form.Undo1Click(Sender: TObject);
begin
//Undo node
 nodes.FindChild('node'+inttostr(nodes.Count),true).Free;
 node_plot.Lines.Delete(node_plot.Lines.Count-1);
end;

procedure Tmain_form.Save1Click(Sender: TObject);
begin
 save_dialog.Execute;
end;


procedure Tmain_form.save_dialogCanClose(Sender: TObject;
  var CanClose: Boolean);
begin
//Save Landscape
 node_plot.Lines.SaveToFile(save_dialog.FileName);
end;

procedure Tmain_form.Load1Click(Sender: TObject);
begin
 open_dialog.Execute;
end;

procedure Tmain_form.open_dialogCanClose(Sender: TObject;
  var CanClose: Boolean);
var px,py,pz,ra,fln:integer;lcount,scount:integer;current_node:string;
begin
//Loading a Landscapescript
 node_plot.Lines.LoadFromFile(open_dialog.FileName);
 nodes.DeleteChildren;
 for lcount := 0 to node_plot.Lines.Count-1 do
 if copy(node_plot.Lines.Strings[lcount],0,6) = '[Node]' then begin
  current_node:=node_plot.Lines.Strings[lcount];
  for scount := 0 to length(current_node) do begin
   if copy(current_node,scount,1) = '=' then px:=scount+1;
   if copy(current_node,scount,1) = '°' then py:=scount+1;
   if copy(current_node,scount,1) = '+' then pz:=scount+1;
   if copy(current_node,scount,1) = '"' then ra:=scount+1;
   if copy(current_node,scount,1) = '*' then fln:=scount+1;
  end;
  with tglfreeform(nodes.AddNewChild(tglfreeform)) do begin
   name := 'node'+inttostr(nodes.Count);
   position.SetPoint(  strtofloat(copy(current_node,px,py-px-1)),  strtofloat(copy(current_node,py,pz-py-1)),  strtofloat(copy(current_node,pz,ra-pz-1)));
   scale.Scale(0.1);
   pitch(90);
   roll(strtofloat(copy(current_node,ra,fln-ra-1)));
  end;
  tglfreeform(nodes.FindChild('node'+inttostr(nodes.Count),true)).materiallibrary := node_materials;
  tglfreeform(nodes.FindChild('node'+inttostr(nodes.Count),true)).LoadFromFile(node_filelist.Directory+'\'+copy(current_node,fln,length(current_node)-fln+1));
 end;
end;

procedure Tmain_form.New1Click(Sender: TObject);
begin
//Reset Node-System
nodes.DeleteChildren;
node_plot.Lines.Clear;
end;

procedure Tmain_form.Close1Click(Sender: TObject);
begin
//Close Program
 close;
end;

end.
