{: Advanced Demo for the GLScene Portal Renderer.<p>

   This example is quite big since it include a small "maze editor" : the grid
   defines walls and open areas, ala Wolfenstein maps, and the viewer displays
   the result interactively.<p>

   The portal mesh generation has been compacted in BBProcess but does not
   generate a "perfect" portal mesh, indeed it is some kind of a worst case
   situation since there are many more portals than actual polygons.<p>

   The GLScene portal object can handle all kind of polygonal descriptions,
   with not necessarily convex polygons, and non necessarily closed areas.
   It is optimized for T&L accelerated cards ie. only an ultra-basic culling is
   performed. It hasn't been tested on many map styles or 3D boards yet, but this
   approach just tramples any "classic" (CPU-intensive) portal renderers on my
   GeForce... not sure how it will scale, though.
}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, GLScene, GLTexture, GLVectorFileObjects, GLTextureFormat,
  GLObjects, ExtCtrls, GLCadencer, GLPortal, GLWin32Viewer, GLCrossPlatform,
  GLMaterial, GLCoordinates, BaseClasses, GLDCE, 
  VectorGeometry, VectorTypes;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    Label2: TLabel;
    BUForward: TButton;
    BUTurnLeft: TButton;
    BUTurnRight: TButton;
    BUBackward: TButton;
    SGMap: TStringGrid;
    GLMaterialLibrary1: TGLMaterialLibrary;
    BBProcess: TButton;
    GLLightSource1: TGLLightSource;
    DummyCube1: TGLDummyCube;
    GLCamera1: TGLCamera;
    Timer1: TTimer;
    cad: TGLCadencer;
    Portal1: TGLPortal;
    Label3: TLabel;
    CBAuto: TCheckBox;
    CBFog: TCheckBox;
    GLDCEManager1: TGLDCEManager;
    procedure FormCreate(Sender: TObject);
    procedure BBProcessClick(Sender: TObject);
    procedure BUTurnLeftClick(Sender: TObject);
    procedure BUTurnRightClick(Sender: TObject);
    procedure BUForwardClick(Sender: TObject);
    procedure BUBackwardClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure cadProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure SGMapSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure CBFogClick(Sender: TObject);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Dйclarations privйes }
  public
    { Dйclarations publiques }
    portalCount, triangleCount : Integer;
  end;

var
  Form1: TForm1;

  player_dce: TGLDCEDynamic;
  dt_dce: single = 0;


implementation

{$R *.DFM}

uses JPeg, GLKeyboard;

procedure TForm1.FormCreate(Sender: TObject);
var
   i : Integer;
begin
   for i:=0 to 15 do
      SGMap.Cells[i, i]:='X';
   SGMap.Cells[8, 8]:='';
   SGMap.Col:=8;
   SGMap.Row:=12;
   with GLMaterialLibrary1 do begin
      AddTextureMaterial('gnd', 'walkway.jpg').
        Material.Texture.FilteringQuality := tfAnisotropic;
      with AddTextureMaterial('wall', 'rawwall.jpg') do begin
         TextureScale.Y:=3;
         Material.Texture.FilteringQuality := tfAnisotropic;
      end;
   end;
   BBProcessClick(Self);

   player_dce := getOrCreateDCEDynamic(dummycube1);

end;

procedure TForm1.BBProcessClick(Sender: TObject);
var
   x, y, n : Integer;
   h : Single;
   sector : TSectorMeshObject;
   poly : TFGPolygon;

   dc: TGLDummyCube;
   dc_dce: TGLDCEStatic;

begin
   h:=3;
   portalCount:=0;
   triangleCount:=0;

   Portal1.MeshObjects.Clear;

   // удаляем физические стены
   Portal1.DeleteChildren;

   for x:=-7 to 8 do for y:=-7 to 8 do begin

      sector:=TSectorMeshObject.CreateOwned(Portal1.MeshObjects);
      with sector.Vertices do begin
         n:=Count;
         Add(x, 0, y); Add(x+1, 0, y); Add(x+1, 0, y+1); Add(x, 0, y+1);
         Add(x, h, y); Add(x+1, h, y); Add(x+1, h, y+1); Add(x, h, y+1);
      end;
      with sector.TexCoords do begin
         Add(0, 0, 0); Add(1, 0, 0); Add(1, 1, 0); Add(0, 1, 0);
      end;

      // ground
      Sector.Normals.Add(0, 1, 0);
      if SGMap.Cells[x+7, y+7]='' then begin
         poly:=TFGPolygon.CreateOwned(sector.FaceGroups);
         with poly do begin
            MaterialName:='gnd';
            Add(n+0, 0, 0); Add(n+3, 0, 3); Add(n+2, 0, 2); Add(n+1, 0, 1);
         end;
      end else begin

         // добавляем объект...
         dc := TGLDummyCube.CreateAsChild(portal1);
         dc.Position.SetPoint(x+0.5, 1, y+0.5);
         //dc.VisibleAtRunTime := true;

         // ...и физическую оболочку
         dc_dce := getOrCreateDCEStatic(dc);
         dc_dce.Manager := GLDCEManager1;
         dc_dce.Shape := csBox;

      end;

      // front wall
      Sector.Normals.Add(0, 0, 1);
      if (y=-7) or (SGMap.Cells[x+7, y-1+7]<>'') then begin
         poly:=TFGPolygon.CreateOwned(sector.FaceGroups);
         poly.MaterialName:='wall';
         Inc(triangleCount, 2);
      end else begin
         poly:=TFGPortalPolygon.CreateOwned(sector.FaceGroups);
         TFGPortalPolygon(poly).DestinationSectorIndex:=(x+7)*16+(y-1+7);
         Inc(portalCount);
      end;
      with poly do begin
         Add(n+0, 1, 3); Add(n+1, 1, 2); Add(n+5, 1, 1); Add(n+4, 1, 0);
      end;

      // left wall
      Sector.Normals.Add(1, 0, 0);
      if (x=-7) or (SGMap.Cells[x-1+7, y+7]<>'') then begin
         poly:=TFGPolygon.CreateOwned(sector.FaceGroups);
         poly.MaterialName:='wall';
         Inc(triangleCount, 2);
      end else begin
         poly:=TFGPortalPolygon.CreateOwned(sector.FaceGroups);
         TFGPortalPolygon(poly).DestinationSectorIndex:=(x-1+7)*16+(y+7);
         Inc(portalCount);
      end;
      with poly do begin
         Add(n+4, 2, 1); Add(n+7, 2, 0); Add(n+3, 2, 3); Add(n+0, 2, 2);
      end;

      // right wall
      Sector.Normals.Add(-1, 0, 0);
      if (x=8) or (SGMap.Cells[x+1+7, y+7]<>'') then begin
         poly:=TFGPolygon.CreateOwned(sector.FaceGroups);
         poly.MaterialName:='wall';
         Inc(triangleCount, 2);
      end else begin
         poly:=TFGPortalPolygon.CreateOwned(sector.FaceGroups);
         TFGPortalPolygon(poly).DestinationSectorIndex:=(x+1+7)*16+(y+7);
         Inc(portalCount);
      end;
      with poly do begin
         Add(n+1, 3, 3); Add(n+2, 3, 2); Add(n+6, 3, 1); Add(n+5, 3, 0);
      end;

      // back wall
      Sector.Normals.Add(0, 0, 1);
      if (y=8) or (SGMap.Cells[x+7, y+1+7]<>'') then begin
         poly:=TFGPolygon.CreateOwned(sector.FaceGroups);
         poly.MaterialName:='wall';
         Inc(triangleCount, 2);
      end else begin
         poly:=TFGPortalPolygon.CreateOwned(sector.FaceGroups);
         TFGPortalPolygon(poly).DestinationSectorIndex:=(x+7)*16+(y+1+7);
         Inc(portalCount);
      end;
      with poly do begin
         Add(n+3, 4, 2); Add(n+7, 4, 1); Add(n+6, 4, 0); Add(n+2, 4, 3);
      end;

   end;
   Portal1.StructureChanged;
end;

procedure TForm1.BUTurnLeftClick(Sender: TObject);
begin
   DummyCube1.Turn(-15);
   GLCamera1.TransformationChanged;
end;

procedure TForm1.BUTurnRightClick(Sender: TObject);
begin
   DummyCube1.Turn(+15);
   GLCamera1.TransformationChanged;
end;

procedure TForm1.BUForwardClick(Sender: TObject);
begin
   DummyCube1.Move(-0.25);
   GLCamera1.TransformationChanged;
end;

procedure TForm1.BUBackwardClick(Sender: TObject);
begin
   DummyCube1.Move(0.25);
   GLCamera1.TransformationChanged;
end;


//
// timer
//
procedure TForm1.Timer1Timer;
begin

   Caption := Format('%.2f FPS - %d Portals - %d Triangles',
      [GLSceneViewer1.FramesPerSecond, portalCount, triangleCount]);
   GLSceneViewer1.ResetPerformanceMonitor;
   
end;


//
// cadProgress
//
procedure TForm1.cadProgress;
begin

   if IsKeyDown(ord('A')) or IsKeyDown(ord('Q')) or IsKeyDown(vk_left) then
      glcamera1.Turn(-150 * deltaTime)
   else
   if IsKeyDown(ord('D')) or IsKeyDown(ord('E')) or IsKeyDown(vk_right) then
      glcamera1.Turn(150 * deltaTime);

  if IsKeyDown(ord('Z')) or IsKeyDown(ord('W')) or IsKeyDown(vk_up) then
    player_dce.ApplyAccel(vectorscale(glcamera1.AbsoluteAffineDirection, 200))
  else
  if IsKeyDown(ord('S')) or IsKeyDown(vk_down) then
    player_dce.ApplyAccel(vectorscale(glcamera1.AbsoluteAffineDirection, -100));


{   if IsKeyDown('Z') or IsKeyDown('W') then
      DummyCube1.Move(-3*deltaTime)
   else if IsKeyDown('S') then
      DummyCube1.Move(3*deltaTime);
   if IsKeyDown('A') or IsKeyDown('Q') then
      DummyCube1.Turn(-60*deltaTime)
   else if IsKeyDown('D') or IsKeyDown('E') then
      DummyCube1.Turn(60*deltaTime);
}
//   GLCamera1.TransformationChanged;

  GLSceneViewer1.Invalidate;

  dt_dce := dt_dce + deltatime;
  if dt_dce > 0.01 then begin
    GLDCEManager1.Step(dt_dce);
    dt_dce := 0;
    end;

end;

procedure TForm1.SGMapSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
   if CBAuto.Checked then BBProcessClick(Self);
end;

procedure TForm1.CBFogClick(Sender: TObject);
begin
   if CBFog.Checked then
      GLCamera1.DepthOfView:=11
   else GLCamera1.DepthOfView:=100;
   GLSceneViewer1.Buffer.FogEnable:=CBFog.Checked;
end;


//
// setFocus
//
procedure TForm1.GLSceneViewer1MouseMove;
begin

  GLSceneViewer1.SetFocus;

end;

end.
