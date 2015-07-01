{ ODEditor
based on SIMPLE demo from GLScene demos.
Jan Zizka, 2004, zizajan@centrum.cz 
}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, shellapi,

  GLODEManager, GLScene, GLObjects, GLCadencer, GLWin32Viewer, GLShadowPlane,
  VectorGeometry, GLKeyboard,  GLTexture, GLGraph, AsyncTimer,
  GLGeomObjects, GLFireFX,  GLCoordinates, GLCrossPlatform,
  BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSViewer: TGLSceneViewer;
    GLCadencer1: TGLCadencer;
    GLCam: TGLCamera;
    GLDCcam: TGLDummyCube;
    GLLight: TGLLightSource;
    ODEObjects: TGLDummyCube;
    Panel1: TPanel;
    GLODEManager1: TGLODEManager;
    GLShadowPlane: TGLShadowPlane;
    GLDCconst: TGLDummyCube;
    GLDClight: TGLDummyCube;
    GLDCconst2: TGLDummyCube;
    CheckPlusMinus: TCheckBox;
    CheckBoxWall: TCheckBox;
    TrackBarWall: TTrackBar;
    CheckBoxDelete: TCheckBox;
    CheckBrick: TCheckBox;
    GLLine: TGLLines;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Build1: TMenuItem;
    Clearall1: TMenuItem;
    Attack1: TMenuItem;
    Cannon1: TMenuItem;
    MIG211: TMenuItem;
    Help1: TMenuItem;
    CheckBoxTraverse: TCheckBox;
    CheckBoxDoor: TCheckBox;
    CheckBoxWindow: TCheckBox;
    GLDCODEplane: TGLDummyCube;
    GLXYZGrid1: TGLXYZGrid;
    Showgrid1: TMenuItem;
    AsyncTimer1: TAsyncTimer;
    Bevel1: TBevel;
    Bevel2: TBevel;
    CheckBoxPanel: TCheckBox;
    Label1: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GLDCcannon: TGLDummyCube;
    GLCylinderAxis: TGLCylinder;
    GLAnnulusWheelR: TGLAnnulus;
    GLAnnulusWheelL: TGLAnnulus;
    GLCubeCannonR1: TGLCube;
    GLCubeCannonR2: TGLCube;
    GLCubeCannonL1: TGLCube;
    GLCubeCannonL2: TGLCube;
    GLCylinderBarrel1: TGLCylinder;
    GLCylinderBarrel2: TGLCylinder;
    GLCylinderBarrel3: TGLCylinder;
    GLDCcamCannon: TGLDummyCube;
    GLCamCannon: TGLCamera;
    PanelFire: TPanel;
    Label2: TLabel;
    TrackBarPowder: TTrackBar;
    ButtonFire: TButton;
    Backtoediting1: TMenuItem;
    GLArrowLine1: TGLArrowLine;
    GLArrowLine2: TGLArrowLine;
    GLCubeCannonR3: TGLCube;
    GLCubeCannonR4: TGLCube;
    GLCubeCannonL3: TGLCube;
    GLCubeCannonL4: TGLCube;
    GLDCBaseShadow: TGLDummyCube;
    Contents1: TMenuItem;
    About1: TMenuItem;
    GLDCMIG21: TGLDummyCube;
    GLCylinderMIG21: TGLCylinder;
    GLCylinderMIG22: TGLCylinder;
    GLConeMIG23: TGLCone;
    GLCylinderMIG24: TGLCylinder;
    GLSphereMIG25: TGLSphere;
    GLCubeMIG26: TGLCube;
    GLCubeMIG27: TGLCube;
    GLCubeMIG28: TGLCube;
    GLCubeMIG29: TGLCube;
    GLCubeMIG30: TGLCube;
    Simulation1: TMenuItem;
    GLDCcamMIG21targ: TGLDummyCube;
    GLCamMIG21: TGLCamera;
    GLFire: TGLFireFXManager;
    GLDCblasts: TGLDummyCube;
    GLDCcamMIG21orig: TGLDummyCube;
    GLDCcamMIG21targ2: TGLDummyCube;
    GLCamMIG21track: TGLCamera;
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure GLSViewerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLDClightProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure GLDCconst2Progress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure CheckPlusMinusClick(Sender: TObject);
    procedure CheckBoxDeleteClick(Sender: TObject);
    procedure CheckBoxWallClick(Sender: TObject);
    procedure CheckBrickClick(Sender: TObject);
    procedure GLSViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CheckBoxTraverseClick(Sender: TObject);

    procedure CheckBoxDoorClick(Sender: TObject);
    procedure CheckBoxWindowClick(Sender: TObject);
    procedure TrackBarWallChange(Sender: TObject);
    procedure Clearall1Click(Sender: TObject);
    procedure Showgrid1Click(Sender: TObject);
    procedure AsyncTimer1Timer(Sender: TObject);
    procedure CheckBoxPanelClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Cannon1Click(Sender: TObject);
    procedure Backtoediting1Click(Sender: TObject);
    procedure ButtonFireClick(Sender: TObject);
//    procedure TrackBarPowderChange(Sender: TObject);
    procedure MIG211Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
  private
    procedure FireCannon;
    procedure ClearScene;
    procedure FireBomb;
    { Private declarations }
  public
    { Public declarations }
    GLODEPlane1 : TGLODEStatic;
    oldx,oldy,wallStartX,wallStartZ : integer;
    //easyProgress: double;
    oldPick: TGLBaseSceneObject;
    offSet,offset2,diffX,diffZ: single;
    build: (singl,brickN,brickW,brickS,brickE);
    bomb: TGLCylinder;
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}
function getGrid(X,Y:integer):TVector;
var
v,v2:Tvector;
begin
        setvector(v,x,Form1.GLSViewer.Height-y,0);
        Form1.GLSViewer.Buffer.ScreenVectorIntersectWithPlaneXZ(v, 0, v2);
        v2[0]:=trunc(v2[0]);
        v2[1]:=0.5;
        v2[2]:=trunc(v2[2]);
        result:=v2;
end;

procedure TForm1.FormCreate(Sender: TObject);
var dummy : TGLBaseSceneObject;
    dyn : TGLODEDynamic;
begin
  offset:=0.5;
  GLODEManager1.Gravity.Y:=-9.81;

  dummy:=GLDCODEplane.AddNewChild(TGLDummyCube);
  dummy.Position.SetPoint(0,0,0);
  dummy.Direction.SetVector(0,1,0);

  GLODEPlane1:=TGLODEStatic.Create(dummy.Behaviours);
  with GLODEPlane1 do begin
    Manager:=GLODEManager1;
    AddNewElement(TODEElementPlane);
    Surface.SurfaceMode:=[];
    Surface.Bounce:=0;
    Surface.Bounce_Vel:=0;
    end;

end;

procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
const
  cStep = 0.001;
var
  i,ii : integer;
  blast: TGLDummyCube;

    procedure CamBack;
    begin
    GLDCcamMIG21targ2.Tag:=0;
    GLCamMIG21.TargetObject:=GLDCcamMIG21targ;
    end;

begin
ii:=Trunc(deltaTime/cStep);
if ii>15 then ii:=15;
if i<1 then i:=1;
if Simulation1.Checked then for i:=0 to ii do GLODEManager1.Step(cStep);
GLArrowLine1.TagFloat:=GLArrowLine1.TagFloat+deltatime;
if GLArrowLine1.TagFloat>0.05 then
    begin
    GLArrowLine1.TagFloat:=0;
    if iskeydown(VK_NEXT) and (trackbarpowder.Position<99) then trackbarpowder.Position:=trackbarpowder.Position+2;
    if iskeydown(VK_PRIOR) and (trackbarpowder.Position>1) then trackbarpowder.Position:=trackbarpowder.Position-2;
    end;
if GLDCcannon.Visible then
    begin
    GLDCcannon.TagFloat:=GLDCcannon.TagFloat-deltatime;
    if iskeydown(VK_UP) and not iskeydown(VK_SHIFT) then
        begin
        GLDCcannon.TagFloat:=GLDCcannon.TagFloat+2*deltatime;
        end;

    if iskeydown(VK_DOWN) and not iskeydown(VK_SHIFT) then
        begin
        GLDCcannon.TagFloat:=GLDCcannon.TagFloat-2*deltatime;
        //GLDCcannon.Move(deltatime*5);
        //GLAnnulusWheelL.Turn(-deltatime*500);
        //GLAnnulusWheelR.Turn(-deltatime*500);
        end;
    
    if GLDCcannon.TagFloat<0 then GLDCcannon.TagFloat:=0;
    if GLDCcannon.TagFloat>1 then GLDCcannon.TagFloat:=1;
    GLAnnulusWheelL.Turn(deltatime*500*GLDCcannon.TagFloat);
    GLAnnulusWheelR.Turn(deltatime*500*GLDCcannon.TagFloat);
    GLDCcannon.Move(-deltatime*5*GLDCcannon.TagFloat);
    if iskeydown(VK_SHIFT) and iskeydown(VK_UP) then
        begin
        if GLCylinderBarrel1.Direction.X<0.7 then GLCylinderBarrel1.Direction.X:=GLCylinderBarrel1.Direction.X+deltatime/5;
        end;
    if iskeydown(VK_SHIFT) and iskeydown(VK_DOWN) then
        begin
        if GLCylinderBarrel1.Direction.X>-0.2 then GLCylinderBarrel1.Direction.X:=GLCylinderBarrel1.Direction.X-deltatime/5;
        end;
    if iskeydown(VK_LEFT) then
        begin
        GLDCcannon.Turn(-deltatime*50);
        GLAnnulusWheelL.Turn(-deltatime*75);
        GLAnnulusWheelR.Turn(deltatime*75);
        end;
    if iskeydown(VK_RIGHT) then
        begin
        GLDCcannon.Turn(deltatime*50);
        GLAnnulusWheelL.Turn(deltatime*75);
        GLAnnulusWheelR.Turn(-deltatime*75);
        end;
    if iskeydown(VK_F5) then GLSviewer.Camera:=GLCam;
    if iskeydown(VK_F6) then GLSviewer.Camera:=GLCamCannon;
    end;
/////////////////////////////
if GLDCMIG21.Visible then
    begin
    if not assigned(bomb) then
        begin
        if GLDCcamMIG21targ2.Tag=0 then GLCamMIG21.Position.AsVector:=GLDCcamMIG21orig.AbsolutePosition;
        //GLCamMIG21.TargetObject:=GLDCcamMIG21targ;
        end
        else
        begin
        GLDCcamMIG21targ2.Tag:=1;
        GLDCcamMIG21targ2.Position.AsVector:=bomb.Position.AsVector;
        GLCamMIG21.Position.Y:=GLDCcamMIG21targ2.Position.Y+10;
        GLCamMIG21.TargetObject:=GLDCcamMIG21targ2;
        end;
    GLCamMIG21track.TargetObject:=GLCamMIG21.TargetObject;
    if iskeydown(VK_UP) and not iskeydown(VK_SHIFT) then
        begin
        if GLDCMIG21.Position.Y<50 then GLDCMIG21.Position.Y:=GLDCMIG21.Position.Y+deltatime*10;
        CamBack;
        end;
    if iskeydown(VK_DOWN) and not iskeydown(VK_SHIFT) then
        begin
        GLDCMIG21.Position.Y:=GLDCMIG21.Position.Y-deltatime*10;
        if GLDCMIG21.Position.Y<1 then GLDCMIG21.Position.Y:=1;
        CamBack;
        end;
    if iskeydown(VK_SHIFT) and iskeydown(VK_UP) then
        begin
        if GLDCcamMIG21orig.Position.Z>1 then GLDCcamMIG21orig.Position.Z:=GLDCcamMIG21orig.Position.Z-deltatime*10;
        end;
    if iskeydown(VK_SHIFT) and iskeydown(VK_DOWN) then
        begin
        if GLDCcamMIG21orig.Position.Z<10 then GLDCcamMIG21orig.Position.Z:=GLDCcamMIG21orig.Position.Z+deltatime*10;
        end;
    if GLCylinderMIG21.TurnAngle<0 then GLCylinderMIG21.TurnAngle:=GLCylinderMIG21.TurnAngle+deltatime*50;
    if GLCylinderMIG21.TurnAngle>0 then GLCylinderMIG21.TurnAngle:=GLCylinderMIG21.TurnAngle-deltatime*50;
    if iskeydown(VK_LEFT) then
        begin
        if GLCylinderMIG21.TurnAngle>-90 then GLCylinderMIG21.TurnAngle:=GLCylinderMIG21.TurnAngle-deltatime*100;
        CamBack;
        end;
    if iskeydown(VK_RIGHT) then
        begin
        if GLCylinderMIG21.TurnAngle<90 then GLCylinderMIG21.TurnAngle:=GLCylinderMIG21.TurnAngle+deltatime*100;
        CamBack;
        end;
    GLDCMIG21.Turn(deltatime*GLCylinderMIG21.TurnAngle);
    GLDCMIG21.Move(-deltatime*5);
    if GLDCMIG21.Position.X<-64 then GLDCMIG21.Position.X:=-64;
    if GLDCMIG21.Position.X>64 then GLDCMIG21.Position.X:=64;
    if GLDCMIG21.Position.Z<-64 then GLDCMIG21.Position.Z:=-64;
    if GLDCMIG21.Position.Z>64 then GLDCMIG21.Position.Z:=64;
    if iskeydown(VK_F5) then GLSviewer.Camera:=GLCam;
    if iskeydown(VK_F6) then
        begin
        GLSviewer.Camera:=GLCamMIG21;
        CamBack;
        end;
    if iskeydown(VK_F7) then
        begin
        GLCamMIG21track.Position.AsVector:=GLcam.Position.AsVector;
        GLSviewer.Camera:=GLCamMIG21track;
        end;
    if assigned(bomb) then
        begin
        if bomb.Position.Y<1 then
            begin
            GLDCblasts.DeleteChildren;
            blast:=TGLDummyCube(ODEObjects.AddNewChild(TGLDummyCube));
            with blast do
              begin
              Position.AsVector:=bomb.Position.AsVector;
               with TGLODEDynamic.Create(Behaviours) do begin
                Manager:=GLODEManager1;
                with TODEElementSphere(AddNewElement(TODEElementSphere)) do begin
                Position.SetPoint(0,0,0);
                Radius:=(100-TrackBarPowder.Position)/10;
                end;
               end;
              end;
               with TGLDummyCube(GLDCblasts.AddNewChild(TGLDummyCube)) do
                begin
                position.AsVector:=bomb.Position.AsVector;
                with TGLBFireFX.Create(Effects) do Manager:=GLFire;
                end;
                GLFire.Disabled:=false;
                GLFire.IsotropicExplosion((100-trackbarpowder.Position)/10,(100-trackbarpowder.Position)/10,(100-trackbarpowder.Position)/100+0.1,256);
                GLFire.Disabled:=true;         
            bomb:=nil;
            //ClearScene;
            //blast.Free;
            end;
        end;
    end;

//Form1.Caption:=inttostr(trunc(GLCylinderBarrel1.Direction.X*100));
end;

procedure TForm1.GLSViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
newPick: TGLBaseSceneObject;
newCube: TGLCube;
begin
if ssRight in Shift then
    begin
    {
    if Checkboxwall.Checked or checkboxtraverse.Checked or checkboxpanel.Checked then
    begin
    CheckBrick.Checked:=true;
    CheckBoxdelete.Checked:=false;
    CheckBoxwall.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxWindow.Checked:=false;
    Checkboxpillar.Checked:=false;
    checkboxpanel.Checked:=false;
    end;
    }
    if build=singl then begin build:=brickN; Exit; end;
    if build=brickN then begin build:=brickE; Exit; end;
    if build=brickE then begin build:=brickS; Exit; end;
    if build=brickS then begin build:=brickW; Exit; end;
    if build=brickW then begin build:=singl; Exit; end;
    end;
if ssLeft in Shift then
    begin
    if checkBoxwall.Checked or checkboxtraverse.Checked or checkboxpanel.Checked or checkboxtraverse.Checked then
        begin
        GLLine.Nodes[0].AsVector:=GLDCconst2.AbsolutePosition;//getGrid(x,y);
        GLLine.Visible:=true;
        Exit;
        end;
    if checkboxdelete.Checked then
        begin
        newPick:=GLSViewer.Buffer.GetPickedObject(x,y);
        if (assigned(newPick)) and (newPick.Parent=ODEobjects) then
            begin
            newPick.Behaviours[0].Free;
            newPick.DeleteChildren;
            newPick.Free;
            oldPick:=nil;
            end;
        end;
    if checkbrick.Checked then with TGLCube(ODEObjects.AddNewChild(TGLCube)) do begin
        Position.AsVector:=GLDCconst2.AbsolutePosition; //.SetPoint(Random,Random+3,Random);
        CubeWidth:=GLDCconst2.Scale.X;
        CubeHeight:=1;
        CubeDepth:=GLDCconst2.Scale.Z;
        //Material.FrontProperties.Diffuse.Color:=VectorMake(0.5*Random+0.5, 0.5*Random+0.5, 0.5*Random+0.5, 0.5*Random+0.5);

        with TGLODEDynamic.Create(Behaviours) do begin
        Manager:=GLODEManager1;
            with TODEElementBox(AddNewElement(TODEElementBox)) do begin
            Position.SetPoint(0,0,0);
            Surface.SurfaceMode:=[];
            BoxWidth:=CubeWidth;
            BoxHeight:=CubeHeight;
            BoxDepth:=CubeDepth;
            end;
        end;
      end;

/////////////////////start door
    if checkboxDoor.Checked then
        begin
        if (GLDCconst2.Scale.X=1) and (GLDCconst2.Scale.Z=1) then Exit;
        newCube:= TGLCube(ODEObjects.AddNewChild(TGLCube));
        with newCube do begin
        Position.AsVector:=GLDCconst2.AbsolutePosition; //.SetPoint(Random,Random+3,Random);
        Position.Y:=Position.Y+1.4;
        CubeWidth:=GLDCconst2.Scale.X;
        CubeHeight:=0.2;
        CubeDepth:=GLDCconst2.Scale.Z;
        Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
        Tag:=1;
        with TGLODEDynamic.Create(Behaviours) do begin
        Manager:=GLODEManager1;
            with TODEElementBox(AddNewElement(TODEElementBox)) do begin
            Position.SetPoint(0,-0.9,0);
            Surface.SurfaceMode:=[];
            BoxWidth:=CubeWidth;
            BoxHeight:=2;
            BoxDepth:=CubeDepth;
            end;
          end;
        if newCube.CubeWidth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,0);
                CubeWidth:=1.95;
                CubeHeight:=1.99;
                CubeDepth:=0.2;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(-0.89,-0.9,0);
                CubeWidth:=0.2;
                CubeHeight:=1.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0.89,-0.9,0);
                CubeWidth:=0.2;
                CubeHeight:=1.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            end;
        if newCube.CubeDepth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,0);
                CubeWidth:=0.2;
                CubeHeight:=1.99;
                CubeDepth:=1.95;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,-0.89);
                CubeWidth:=0.99;
                CubeHeight:=1.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,0.89);
                CubeWidth:=0.99;
                CubeHeight:=1.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            end;
        end;
      end;
    end;                     ////////////end door
/////////////////start window
    if checkboxwindow.Checked then
        begin
        if (GLDCconst2.Scale.X=1) and (GLDCconst2.Scale.Z=1) then Exit;
        newCube:= TGLCube(ODEObjects.AddNewChild(TGLCube));
        with newCube do begin
        Position.AsVector:=GLDCconst2.AbsolutePosition; //.SetPoint(Random,Random+3,Random);
        Position.Y:=Position.Y+0.4;
        CubeWidth:=GLDCconst2.Scale.X;
        CubeHeight:=0.2;
        CubeDepth:=GLDCconst2.Scale.Z;
        Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
        Tag:=2;
        with TGLODEDynamic.Create(Behaviours) do begin
        Manager:=GLODEManager1;
            with TODEElementBox(AddNewElement(TODEElementBox)) do begin
            Position.SetPoint(0,-0.4,0);
            Surface.SurfaceMode:=[];
            BoxWidth:=CubeWidth;
            BoxHeight:=1;
            BoxDepth:=CubeDepth;
            end;
          end;
        if newCube.CubeWidth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.8,0);
                CubeWidth:=1.95;
                CubeHeight:=0.2;
                CubeDepth:=1;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(-0.89,-0.4,0);
                CubeWidth:=0.2;
                CubeHeight:=0.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0.89,-0.4,0);
                CubeWidth:=0.2;
                CubeHeight:=0.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=1.98;
                CubeHeight:=0.1;
                CubeDepth:=0.1;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=0.1;
                CubeHeight:=0.99;
                CubeDepth:=0.1;
                end;
            end;
        if newCube.CubeDepth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.8,0);
                CubeWidth:=1;
                CubeHeight:=0.2;
                CubeDepth:=1.95;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,-0.89);
                CubeWidth:=0.99;
                CubeHeight:=0.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0.89);
                CubeWidth:=0.99;
                CubeHeight:=0.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=0.1;
                CubeHeight:=0.1;
                CubeDepth:=1.98;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=0.1;
                CubeHeight:=0.99;
                CubeDepth:=0.1;
                end;
            end;
        end;
      end;  //////////////end window
end;

procedure TForm1.GLSViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
v2: TVector;
showDC: boolean;
newPick:TGLBaseSceneObject;
//diffX,diffZ: double;
begin
showDc:=false;
  if iskeydown(VK_SHIFT) then
    begin
    GLDCcam.Move((oldy-y)*0.01*GLcam.DistanceToTarget); GLDCcam.Slide((oldx-x)*0.01*GLcam.DistanceToTarget);
    showDC:=true;
    end;
  if iskeydown(VK_CONTROL) then
    begin
    GLDCcam.Turn((oldx-x)*0.5);
    GLCam.Position.Y:=GLcam.Position.Y-(oldy-y)*0.05;
    if GLCam.Position.Y<0.1 then GLCam.Position.Y:=0.1;
    if GLCam.Position.Y>20 then GLCam.Position.Y:=20;
    showDC:=true;
    end;
    if showDC then
        begin
        GLDCcam.VisibleAtRunTime:=true;
        GLDCconst2.VisibleAtRunTime:=false;
        end else
        begin
        GLDCcam.VisibleAtRunTime:=false;
        GLDCconst2.VisibleAtRunTime:=true;
        end;
    oldX:=x; oldy:=y;
    v2:=getGrid(x,y);

    //if not checkboxwall.Checked then
   {newPick:=GLSViewer.Buffer.GetPickedObject(x,y);
    if assigned(newPick) then
        begin
        if (newPick.Parent=ODEObjects) then
            begin
            setVector(v2,newPick.position.asvector);
            if newPick is TGLCube then
            with newPick as TGLCube do
                begin
                v2[1]:=v2[1]+0.5+CubeHeight/2;
                if CubeWidth=2 then v2[0]:=v2[0]+offset;
                if CubeDepth=2 then v2[2]:=v2[2]+offset;
                if CubeWidth>2 then
                    begin
                    if offset2>CubeWidth-0.5 then offset2:=0;
                    v2[0]:=v2[0]-CubeWidth/2+0.5+offset2;
                    end;
                if CubeDepth>2 then
                    begin
                    if offset2>CubeDepth-0.5 then offset2:=0;
                    v2[2]:=v2[2]-CubeDepth/2+0.5+offset2;
                    end;
                end;
            if newPick<>oldPick then
                begin
                if assigned(oldPick) and (oldPick is TGLCube) then TGLCube(oldPick).Material.FrontProperties.Emission.AsWinColor:=0;
                if newPick is TGLCube then TGLCube(newPick).Material.FrontProperties.Emission.AsWinColor:=$ff;
                oldPick:=newPick;
                end;
            end else if (assigned(oldPick)) and (oldPick is TGLCube) then
                begin
                TGLCube(oldPick).Material.FrontProperties.Emission.AsWinColor:=0;
                oldPick:=nil;
                end;
        end ;
    }
    if v2[0]<-63 then v2[0]:=-63;
    if v2[2]<-63 then v2[2]:=-63;
    if v2[0]>63 then v2[0]:=63;
    if v2[2]>63 then v2[2]:=63;
    GLDCconst.Position.X:=v2[0];
    GLDCconst.Position.Z:=v2[2];
    GLDCconst.Position.Y:=v2[1];//0.5+pickPos;
if checkboxwall.Checked or checkboxpanel.Checked then
    begin
    GLLine.Nodes[1].AsVector:=GLDCconst2.AbsolutePosition;//getGrid(x,y);
    if GLLine.Nodes[1].X>GLLine.Nodes[0].X then diffX:=GLLine.Nodes[1].X-GLLine.Nodes[0].X else diffX:=GLLine.Nodes[0].X-GLLine.Nodes[1].X;
    if GLLine.Nodes[1].Z>GLLine.Nodes[0].Z then diffZ:=GLLine.Nodes[1].Z-GLLine.Nodes[0].Z else diffZ:=GLLine.Nodes[0].Z-GLLine.Nodes[1].Z;
    if diffX>diffZ then GLLine.Nodes[1].Z:=GLLine.Nodes[0].Z else GLLine.Nodes[1].X:=GLLine.Nodes[0].X;
    end;
if checkboxtraverse.Checked then GLLine.Nodes[1].AsVector:=GLDCconst2.AbsolutePosition;

end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
GLCam.AdjustDistanceToTarget(Power(1.1, WheelDelta/240));
end;

procedure TForm1.GLDClightProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
GLDClight.Turn(deltaTime/10);
end;

procedure TForm1.GLDCconst2Progress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
case build of
    singl: begin GLDCconst2.Scale.X:=1; GLDCconst2.Scale.Z:=1; GLDCconst2.Position.X:=0; GLDCconst2.Position.Z:=0; end;
    brickN: begin GLDCconst2.Scale.X:=1; GLDCconst2.Scale.Z:=2; GLDCconst2.Position.X:=0; GLDCconst2.Position.Z:=0.5; end;
    brickE: begin GLDCconst2.Scale.X:=2; GLDCconst2.Scale.Z:=1; GLDCconst2.Position.X:=-0.5; GLDCconst2.Position.Z:=0; end;
    brickS: begin GLDCconst2.Scale.X:=1; GLDCconst2.Scale.Z:=2; GLDCconst2.Position.X:=0; GLDCconst2.Position.Z:=-0.5; end;
    brickW: begin GLDCconst2.Scale.X:=2; GLDCconst2.Scale.Z:=1; GLDCconst2.Position.X:=0.5; GLDCconst2.Position.Z:=0; end;
    end;
end;

procedure TForm1.CheckPlusMinusClick(Sender: TObject);
begin
if offset=0.5 then offset:=-0.5 else offset:=0.5;
offset2:=offset2+1;
end;

procedure TForm1.CheckBoxDeleteClick(Sender: TObject);
begin
if checkboxdelete.Checked then
    begin
    CheckBoxwall.Checked:=false;
    Checkbrick.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxWindow.Checked:=false;
    CheckBoxPanel.Checked:=false;
    GLDCconst2.Visible:=false;
    end else GLDCconst2.Visible:=true;
checkplusminus.SetFocus;
end;

procedure TForm1.CheckBoxWallClick(Sender: TObject);
begin
if checkboxwall.Checked then
    begin
    CheckBoxdelete.Checked:=false;
    Checkbrick.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxWindow.Checked:=false;
    CheckBoxPanel.Checked:=false;
    end;
checkplusminus.SetFocus;
build:=singl;
end;

procedure TForm1.CheckBrickClick(Sender: TObject);
begin
if checkbrick.Checked then
    begin
    CheckBoxdelete.Checked:=false;
    CheckBoxwall.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxWindow.Checked:=false;
    CheckBoxPanel.Checked:=false;
    end;
checkplusminus.SetFocus;
end;

procedure TForm1.CheckBoxTraverseClick(Sender: TObject);
begin
if checkboxtraverse.Checked then
    begin
    CheckBoxdelete.Checked:=false;
    CheckBoxwall.Checked:=false;
    Checkbrick.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxWindow.Checked:=false;
    CheckBoxPanel.Checked:=false;
    end;
checkplusminus.SetFocus;
build:=singl;
end;

procedure TForm1.CheckBoxDoorClick(Sender: TObject);
begin
if checkboxdoor.Checked then
    begin
    CheckBoxdelete.Checked:=false;
    CheckBoxwall.Checked:=false;
    Checkbrick.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxWindow.Checked:=false;
    CheckBoxPanel.Checked:=false;
    end;
checkplusminus.SetFocus;
end;

procedure TForm1.CheckBoxWindowClick(Sender: TObject);
begin
if checkboxwindow.Checked then
    begin
    CheckBoxdelete.Checked:=false;
    CheckBoxwall.Checked:=false;
    Checkbrick.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxPanel.Checked:=false;
    end;
checkplusminus.SetFocus;
end;

procedure TForm1.CheckBoxPanelClick(Sender: TObject);
begin
if checkboxpanel.Checked then
    begin
    CheckBoxdelete.Checked:=false;
    CheckBoxwall.Checked:=false;
    Checkbrick.Checked:=false;
    CheckBoxDoor.Checked:=false;
    CheckBoxTraverse.Checked:=false;
    CheckBoxWindow.Checked:=false;
    end;
checkplusminus.SetFocus;
build:=singl;
end;

procedure TForm1.TrackBarWallChange(Sender: TObject);
begin
Label1.Caption:='Height: '+inttostr(trackbarwall.Position);
checkplusminus.SetFocus;
end;

procedure TForm1.GLSViewerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
Lstart,Lend,i,wallH: integer;
v2: TVector;
safeX,safeZ: double;
canbuild,canbuild2: boolean;
begin
if checkboxwall.Checked then
    begin      ///start wall
GLLine.Visible:=false;
canbuild:=false; canbuild2:=true;
if diffX>diffZ then
    begin
    if GLLine.Nodes[0].X<=GLLine.Nodes[1].X then
        begin
        Lstart:=trunc(GLLine.Nodes[0].X); Lend:=trunc(GLLine.Nodes[1].X);
        end
        else
        begin
        Lstart:=trunc(GLLine.Nodes[1].X); Lend:=trunc(GLLine.Nodes[0].X);
        end;
    for wallH:=0 to TrackBarWall.Position-1 do
      begin
      canbuild2:= not canbuild2;
      canbuild:=canbuild2;
      for i:=Lstart to Lend do
        begin
        canbuild:= not canbuild;
        if canbuild then
            begin
            with TGLCube(ODEObjects.AddNewChild(TGLCube)) do begin
            Position.X:=i+0.5;
            Position.Z:=GLLine.Nodes[0].Z;
            Position.Y:=GLLine.Nodes[0].Y+wallH;
            CubeWidth:=2;
            CubeHeight:=1;
            CubeDepth:=1;
            with TGLODEDynamic.Create(Behaviours) do begin
            Manager:=GLODEManager1;
                with TODEElementBox(AddNewElement(TODEElementBox)) do begin
                Position.SetPoint(0,0,0);
                Surface.SurfaceMode:=[];
                BoxWidth:=CubeWidth;
                BoxHeight:=CubeHeight;
                BoxDepth:=CubeDepth;
                Surface.SurfaceMode:=[];
                Surface.Bounce:=0;
                Surface.Bounce_Vel:=0;
                end;
            end;
           end;
          end;
        end;
      end;
    end
    else
    begin
    if GLLine.Nodes[0].Z<=GLLine.Nodes[1].Z then
        begin
        Lstart:=trunc(GLLine.Nodes[0].Z); Lend:=trunc(GLLine.Nodes[1].Z);
        end
        else
        begin
        Lstart:=trunc(GLLine.Nodes[1].Z); Lend:=trunc(GLLine.Nodes[0].Z);
        end;
    for wallH:=0 to TrackBarWall.Position-1 do
      begin
      canbuild2:= not canbuild2;
      canbuild:=canbuild2;
      for i:=Lstart to Lend do
        begin
        canbuild:= not canbuild;
        if canbuild then
            begin
            with TGLCube(ODEObjects.AddNewChild(TGLCube)) do begin
            Position.Z:=i+0.5;
            Position.X:=GLLine.Nodes[0].X;
            Position.Y:=GLLine.Nodes[0].Y+wallH;
            CubeWidth:=1;
            CubeHeight:=1;
            CubeDepth:=2;
            with TGLODEDynamic.Create(Behaviours) do begin
            Manager:=GLODEManager1;
                with TODEElementBox(AddNewElement(TODEElementBox)) do begin
                Position.SetPoint(0,0,0);
                BoxWidth:=CubeWidth;
                BoxHeight:=CubeHeight;
                BoxDepth:=CubeDepth;
                Surface.SurfaceMode:=[];
                Surface.Bounce:=0;
                Surface.Bounce_Vel:=0;
                end;
              end;
            end;
         end;
        end;
      end;
    end;
    end;////end Wall

if checkboxtraverse.Checked then
    begin      ///start desk

GLLine.Visible:=false;
    begin
    if GLLine.Nodes[0].X<=GLLine.Nodes[1].X then
        begin
        Lstart:=trunc(GLLine.Nodes[0].X); Lend:=trunc(GLLine.Nodes[1].X);
        end
        else
        begin
        Lstart:=trunc(GLLine.Nodes[1].X); Lend:=trunc(GLLine.Nodes[0].X);
        end;
        for i:=Lstart to Lend do
        begin
            with TGLCube(ODEObjects.AddNewChild(TGLCube)) do begin
            Position.X:=i;
            if GLLine.Nodes[0].Z>GLLine.Nodes[1].Z then
                begin
                Position.Z:=GLLine.Nodes[1].Z+(GLLine.Nodes[0].Z-GLLine.Nodes[1].Z)/2;
                CubeDepth:=GLLine.Nodes[0].Z-GLLine.Nodes[1].Z+1;
                end
                else
                begin
                Position.Z:=GLLine.Nodes[0].Z+(GLLine.Nodes[1].Z-GLLine.Nodes[0].Z)/2;
                CubeDepth:=GLLine.Nodes[1].Z-GLLine.Nodes[0].Z+1;
                end;
            Position.Y:=GLLine.Nodes[0].Y;
            CubeWidth:=1;
            CubeHeight:=1;
            
            with TGLODEDynamic.Create(Behaviours) do begin
            Manager:=GLODEManager1;
                with TODEElementBox(AddNewElement(TODEElementBox)) do begin
                Position.SetPoint(0,0,0);
                Surface.SurfaceMode:=[];
                BoxWidth:=CubeWidth;
                BoxHeight:=CubeHeight;
                BoxDepth:=CubeDepth;
                end;
            end;
          end;
        end;
      end;
    end;////end desk

if checkboxpanel.Checked then
    begin      ///start panel

GLLine.Visible:=false;
if diffX>diffZ then
    begin
    if GLLine.Nodes[0].X<=GLLine.Nodes[1].X then
        begin
        safeZ:=GLLine.Nodes[0].X; safeX:=GLLine.Nodes[1].X;
        end
        else
        begin
        safeZ:=GLLine.Nodes[1].X; safeX:=GLLine.Nodes[0].X;
        end;
            with TGLCube(ODEObjects.AddNewChild(TGLCube)) do begin
            Position.X:=(safeX-safeZ) / 2 +safeZ;
            Position.Z:=GLLine.Nodes[0].Z;
            Position.Y:=GLLine.Nodes[0].Y+TrackBarWall.Position/2-0.5;
            CubeWidth:=safeX-safeZ+1;
            CubeHeight:=TrackBarWall.Position;
            CubeDepth:=1;
            with TGLODEDynamic.Create(Behaviours) do begin
            Manager:=GLODEManager1;
                with TODEElementBox(AddNewElement(TODEElementBox)) do begin
                Position.SetPoint(0,0,0);
                Surface.SurfaceMode:=[];
                BoxWidth:=CubeWidth;
                BoxHeight:=CubeHeight;
                BoxDepth:=CubeDepth;
                end;
            end;
           end;
    end
    else
    begin
    if GLLine.Nodes[0].Z<=GLLine.Nodes[1].Z then
        begin
        safeZ:=GLLine.Nodes[0].Z; safeX:=GLLine.Nodes[1].Z;
        end
        else
        begin
        safeZ:=GLLine.Nodes[1].Z; safeX:=GLLine.Nodes[0].Z;
        end;
            with TGLCube(ODEObjects.AddNewChild(TGLCube)) do begin
            Position.Z:=(safeX-safeZ) / 2 +safeZ;
            Position.X:=GLLine.Nodes[0].X;
            Position.Y:=GLLine.Nodes[0].Y+TrackBarWall.Position/2-0.5;
            CubeWidth:=1;
            CubeHeight:=TrackBarWall.Position;
            CubeDepth:=safeX-safeZ+1;
            with TGLODEDynamic.Create(Behaviours) do begin
            Manager:=GLODEManager1;
                with TODEElementBox(AddNewElement(TODEElementBox)) do begin
                Position.SetPoint(0,0,0);
                Surface.SurfaceMode:=[];
                BoxWidth:=CubeWidth;
                BoxHeight:=CubeHeight;
                BoxDepth:=CubeDepth;
                end;
              end;
            end;
        end;
    end;////end panel
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
if MessageDlg('Do you really wan to quit?',mtConfirmation,[mbYes, mbNo],0)=mrYes then Close;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
Panel1.Width:=Form1.Width-8;
end;

procedure TForm1.Clearall1Click(Sender: TObject);
var
i: integer ;
begin
for i:=ODEObjects.Count-1 downto 0 do
    begin
    if assigned(ODEObjects.Children[i].Behaviours[0]) then ODEObjects.Children[i].Behaviours[0].Free;
    ODEObjects.Children[i].DeleteChildren;
    ODEObjects.Children[i].Free;
    end;
end;

procedure TForm1.Showgrid1Click(Sender: TObject);
begin
Showgrid1.Checked:= not Showgrid1.Checked;
GLXYZgrid1.Visible:=Showgrid1.Checked;
end;

procedure TForm1.AsyncTimer1Timer(Sender: TObject);
begin
Form1.Caption:='ODEditor / '+inttostr(ODEobjects.Count)+' Objects / Simulation: ';
if Simulation1.Checked then Form1.Caption:=Form1.Caption+'ON' else Form1.Caption:=Form1.Caption+'OFF';
   //GLSViewer.ResetPerformanceMonitor;
end;

procedure TForm1.Save1Click(Sender: TObject);
var
line: string;
txtF: TextFile;
i: integer;
begin
if SaveDialog1.Execute then
begin
AssignFile(txtF,SaveDialog1.FileName);
Rewrite(txtF);
for i:=0 to ODEobjects.Count-1 do
    begin
    with ODEobjects.Children[i] as TGLCube do
        begin
        line:=inttostr(trunc(Position.X*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(Position.Y*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(Position.Z*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(Direction.X*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(Direction.Y*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(Direction.Z*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(CubeWidth*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(CubeHeight*1000000));
        writeln(txtF,line);
        line:=inttostr(trunc(CubeDepth*1000000));
        writeln(txtF,line);
        line:=inttostr(Tag);
        writeln(txtF,line);
        end;
    end;
CloseFile(txtF);
end;
end;

procedure TForm1.Load1Click(Sender: TObject);
var
line: string;
txtF: TextFile;
newCube: TGLCube;
begin
if ODEobjects.Count>0 then if MessageDlg('Your scene contains objects.'+#13+'Do you want to delete them?',mtConfirmation,[mbYes, mbNo],0)=mrYes then Clearall1.Click;
if OpenDialog1.Execute then
begin
AssignFile(txtF,OpenDialog1.FileName);
Reset(txtF);
repeat
newCube:=TGLCube(ODEobjects.AddNewChild(TGLCube)) ;
with newCube do
    begin
    readln(txtF,line);
    Position.X:=strtoint(line)/1000000;
    readln(txtF,line);
    Position.Y:=strtoint(line)/1000000;
    readln(txtF,line);
    Position.Z:=strtoint(line)/1000000;
    readln(txtF,line);
    Direction.X:=strtoint(line)/1000000;
    readln(txtF,line);
    Direction.Y:=strtoint(line)/1000000;
    readln(txtF,line);
    Direction.Z:=strtoint(line)/1000000;
    readln(txtF,line);
    CubeWidth:=strtoint(line)/1000000;
    readln(txtF,line);
    CubeHeight:=strtoint(line)/1000000;
    readln(txtF,line);
    CubeDepth:=strtoint(line)/1000000;
    readln(txtF,line);
    Tag:=strtoint(line);
///////////////////////////////////////////
    if tag=0 then
    begin

        with TGLODEDynamic.Create(Behaviours) do begin
        Manager:=GLODEManager1;
        Surface.SurfaceMode:=[];
            with TODEElementBox(AddNewElement(TODEElementBox)) do begin
            Position.SetPoint(0,0,0);

            BoxWidth:=CubeWidth;
            BoxHeight:=CubeHeight;
            BoxDepth:=CubeDepth;
            end;
        end;
    end;
    if tag=1 then
    begin
    Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
        with TGLODEDynamic.Create(Behaviours) do begin
        Manager:=GLODEManager1;
        
            with TODEElementBox(AddNewElement(TODEElementBox)) do begin
            Position.SetPoint(0,-0.9,0);
            Surface.SurfaceMode:=[];
            BoxWidth:=CubeWidth;
            BoxHeight:=2;
            BoxDepth:=CubeDepth;
            end;
          end;
        if newCube.CubeWidth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,0);
                CubeWidth:=1.95;
                CubeHeight:=1.99;
                CubeDepth:=0.2;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(-0.89,-0.9,0);
                CubeWidth:=0.2;
                CubeHeight:=1.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0.89,-0.9,0);
                CubeWidth:=0.2;
                CubeHeight:=1.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            end;
        if newCube.CubeDepth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,0);
                CubeWidth:=0.2;
                CubeHeight:=1.99;
                CubeDepth:=1.95;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,-0.89);
                CubeWidth:=0.99;
                CubeHeight:=1.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.9,0.89);
                CubeWidth:=0.99;
                CubeHeight:=1.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            end;
        end;
        if tag=2 then
        begin
        Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
        with TGLODEDynamic.Create(Behaviours) do begin
        Manager:=GLODEManager1;
            with TODEElementBox(AddNewElement(TODEElementBox)) do begin
            Position.SetPoint(0,-0.4,0);
            Surface.SurfaceMode:=[];
            BoxWidth:=CubeWidth;
            BoxHeight:=1;
            BoxDepth:=CubeDepth;
            end;
          end;
        if newCube.CubeWidth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.8,0);
                CubeWidth:=1.95;
                CubeHeight:=0.2;
                CubeDepth:=1;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(-0.89,-0.4,0);
                CubeWidth:=0.2;
                CubeHeight:=0.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0.89,-0.4,0);
                CubeWidth:=0.2;
                CubeHeight:=0.99;
                CubeDepth:=0.99;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=1.98;
                CubeHeight:=0.1;
                CubeDepth:=0.1;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=0.1;
                CubeHeight:=0.99;
                CubeDepth:=0.1;
                end;
            end;
        if newCube.CubeDepth=2 then
            begin
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.8,0);
                CubeWidth:=1;
                CubeHeight:=0.2;
                CubeDepth:=1.95;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,-0.89);
                CubeWidth:=0.99;
                CubeHeight:=0.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0.89);
                CubeWidth:=0.99;
                CubeHeight:=0.99;
                CubeDepth:=0.2;
                Material.FrontProperties.Diffuse.Color:=VectorMake(0.2,0.2,0.2,0.2);
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=0.1;
                CubeHeight:=0.1;
                CubeDepth:=1.98;
                end;
            with TGLCube(newCube.AddNewChild(TGLCube)) do
                begin
                Position.SetPoint(0,-0.4,0);
                CubeWidth:=0.1;
                CubeHeight:=0.99;
                CubeDepth:=0.1;
                end;
            end;
        end;
    end;
until eof(txtF);
closefile(txtF);
end;
end;

procedure TForm1.Cannon1Click(Sender: TObject);
begin
backtoediting1.Enabled:=true;
Panel1.Visible:=false;
PanelFire.Visible:=true;
GLDCMIG21.Visible:=false;
GLDCcannon.Visible:=true;
GLSviewer.Camera:=GLcamCannon;
ButtonFire.SetFocus;
ClearScene;
end;

procedure TForm1.Backtoediting1Click(Sender: TObject);
begin
backtoediting1.Enabled:=false;
Panel1.Visible:=true;
PanelFire.Visible:=false;
GLSviewer.Camera:=GLcam;
GLDCcannon.Visible:=false;
GLDCMIG21.Visible:=false;
ClearScene;
end;

procedure TForm1.FireCannon;
var
f: taffinevector;
newBall: TGLSphere;
//newODE: TODEElementSphere;
begin
newBall:=TGLSphere(ODEObjects.AddNewChild(TGLSphere));
  with newBall do begin
    Position.AsVector:=GLCylinderBarrel2.AbsolutePosition;
    GLArrowLine1.Position.AsVector:=GLCylinderBarrel2.AbsolutePosition;
    GLArrowLine1.Direction.AsVector:=GLCylinderBarrel1.AbsoluteDirection;
    GLArrowLine1.Up.AsVector:=GLCylinderBarrel1.AbsoluteUp;
    Direction.AsVector:=GLArrowLine2.absolutedirection;
    Up.AsVector:=GLArrowLine2.absoluteup;
    Radius:=0.2;
    with TGLODEDynamic.Create(Behaviours) do begin
    Manager:=GLODEManager1;
      with TODEElementSphere(AddNewElement(TODEElementSphere)) do begin
      Position.SetPoint(0,0,0);
      Radius:=0.2;
      Direction.AsVector:=newball.absolutedirection;
      Up.AsVector:=newball.absoluteup;
      setvector(f,newball.direction.x*500*(100-TrackBarPowder.position),newball.direction.y*500*(100-TrackBarPowder.position),newball.direction.z*500*(100-TrackBarPowder.position));
      //vectorscale(f,10000);
      AddForce(f);
      end;
    end;
  end;
end;

procedure TForm1.ButtonFireClick(Sender: TObject);
begin
if GLDCcannon.Visible then FireCannon;
if GLDCMIG21.Visible then FireBomb;
end;

procedure TForm1.ClearScene;
var
i: integer;
begin
for i:=ODEobjects.Count-1 downto 0 do
    begin
    if not (ODEobjects.Children[i] is TGLCube) then
        begin
        ODEobjects.Children[i].Behaviours[0].Free;
        ODEobjects.Children[i].Free;
        end;
    end;
end;

//procedure TForm1.TrackBarPowderChange(Sender: TObject);
//begin
//ButtonFire.SetFocus;
//end;

procedure TForm1.MIG211Click(Sender: TObject);
begin
backtoediting1.Enabled:=true;
Panel1.Visible:=false;
PanelFire.Visible:=true;
GLDCcannon.Visible:=false;
GLDCMIG21.Visible:=true;
GLSviewer.Camera:=GLcamMIG21;
ButtonFire.SetFocus;
ClearScene;
end;

procedure TForm1.FireBomb;
var
f: taffinevector;
newBomb: TGLCylinder;
//newODE: TODEElementCapsule;
begin
clearscene;
GLDCcamMIG21targ2.Tag:=0;
GLCamMIG21.Position.AsVector:=GLDCcamMIG21orig.AbsolutePosition;
newBomb:=TGLCylinder(ODEObjects.AddNewChild(TGLCylinder));
  with newBomb do begin
    Position.AsVector:=GLDCMIG21.Position.asvector;
    Position.Y:=Position.Y-1;
    BottomRadius:=(100-trackbarpowder.Position)/200+0.1;
    TopRadius:=BottomRadius;
    Height:=1;
    with TGLCylinder(newbomb.AddNewChild(TGLCylinder)) do
        begin
        Position.Y:=-0.6;
        BottomRadius:=newBomb.BottomRadius/2;
        TopRadius:=newBomb.BottomRadius;
        Height:=0.2;
        end;
    with TGLCylinder(newbomb.AddNewChild(TGLCylinder)) do
        begin
        Position.Y:=0.6;
        BottomRadius:=newBomb.BottomRadius*0.2;
        TopRadius:=newBomb.BottomRadius*0.8;
        Height:=0.2;
        end;
    with TGLODEDynamic.Create(Behaviours) do begin
    Manager:=GLODEManager1;
      with TODEElementCapsule(AddNewElement(TODEElementCapsule)) do begin
      Position.SetPoint(0,0,0);
      Radius:=newBomb.BottomRadius;
      Length:=newbomb.Height;
      end;
    end;
  end;
bomb:=newBomb;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
Form2.ShowModal;
end;

procedure TForm1.Contents1Click(Sender: TObject);
begin
ShellExecute(handle,'open','help.html',nil,nil,SW_SHOWNORMAL);
end;

end.
