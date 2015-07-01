unit uNCube;

interface

uses
  Windows, Forms, Controls, Classes, Graphics, sysutils,                                  

  GLScene, GLObjects, GLHUDObjects, GLGeomObjects, GLMaterial, GLTexture,
  GLTextureFormat, VectorGeometry, GLKeyboard, GLContext, BaseClasses,
  GLWin32Viewer, GLRenderContextInfo;


type
  TGLNCube = class(TGLBaseSceneObject)
  private

    FDelta,FFps,FTimer,FInactiveTime: single;
    FCube: TGLDummyCube;
    FSel: integer;
    FSelPos: TVector;
    FCam,FNavCam: TGLCamera;
    FHud: TGLHUDSprite;
    FMem: TGLMemoryViewer;
    FViewer: TGLSceneViewer;
    FReady,FMouse: boolean;

    FMouseRotation: boolean;
    FMousePos: TPoint;

    FPosAnimationStart: TVector;
    FPosAnimationEnd: TVector;

  public

    constructor CreateAsChild( aParentOwner: TGLBaseSceneObject ); reintroduce;
    procedure DoProgress( const pt: TProgressTimes ); override;
    procedure DoRender( var ARci: TRenderContextInfo;
      ARenderSelf, ARenderChildren: Boolean); override;

    property SceneViewer: TGLSceneViewer read FViewer write FViewer;
    property Camera: TGLCamera read FCam write FCam;
    property FPS: single read FFps write FFps;

    property ActiveMouse: boolean read FMouse write FMouse;
    property InactiveTime: single read FInactiveTime write FInactiveTime;

  end;

var
  sW2,sH2: integer;


implementation


// constructor
//
constructor TGLNCube.CreateAsChild( aParentOwner: TGLBaseSceneObject );

  procedure genTex(s:string;m:TGLMaterial);
  var
      bmp:TBitmap;
  begin               
    bmp := TBitmap.Create;
    bmp.Width := 64;
    bmp.Height := 64;
    with bmp.Canvas do begin
      Font.Name := 'Verdana';
      Font.Size := 10;
      TextOut( 32 - TextWidth(s) div 2, 24, s );
    end;
    m.FrontProperties.Diffuse.SetColor( 1,1,1 );
    m.Texture.Image.Assign( bmp );
    m.Texture.Disabled := false;
    m.Texture.FilteringQuality := tfAnisotropic;
    m.Texture.TextureMode := tmModulate;
    bmp.Free;
  end;

  procedure setColor(m:TGLMaterial;c:single);
  begin
    m.FrontProperties.Diffuse.SetColor( c,c,1 );
  end;

  procedure addPlane(t:integer;ttl:string;c,x,y,z,dx,dy,dz:single);
  begin
    with TGLPlane.CreateAsChild( FCube ) do begin
      tag := t;
      tagfloat := c;
      Position.SetPoint( x, y, z );
      Direction.SetVector( dx, dy, dz );
      genTex( ttl, Material );
    end;
  end;

  procedure addCube(t:integer;c,x,y,z,sx,sy,sz:single);
  begin
    with TGLCube.CreateAsChild( FCube ) do begin
      tag := t;
      tagfloat := c;
      Position.SetPoint( x, y, z );
      Scale.SetVector( sx, sy, sz );
      setColor( Material, c );
    end;
  end;

begin

  inherited CreateAsChild( aParentOwner );

  FDelta := 2;
  FFps := 30;
  FTimer := 10;
  FMouse := true;
  FInactiveTime := 0;

  FHud := TGLHUDSprite.CreateAsChild( self );
  FHud.Width := 128;
  FHud.Height := 128;
  FHud.Material.BlendingMode := bmTransparency;
  with FHud.Material.Texture do begin
    Disabled := false;
    ImageClassName := 'TGLBlankImage';
    MinFilter := miNearest;
    TGLBlankImage(Image).Width := 128;
    TGLBlankImage(Image).Height := 128;
    TextureMode := tmReplace;
  end;
  FHud.Position.SetPoint( -200, 50, 0 );

  FNavCam := TGLCamera.CreateAsChild( self );
  FNavCam.FocalLength := 55;
  FNavCam.TargetObject := self;

  FMem := TGLMemoryViewer.Create( aParentOwner );
  FMem.Width := 128;
  FMem.Height := 128;
  FMem.Camera := FNavCam;
  with FMem.Buffer do begin
    BackgroundAlpha := 0;
    Antialiasing := aa6x;
    ContextOptions := [roDestinationAlpha];
    Lighting := false;
  end;

  FCube := TGLDummyCube.CreateAsChild( self );
  FCube.Visible := false;

  with TGLDisk.CreateAsChild( FCube ) do begin
    Position.SetPoint( 0, -0.805, 0 );
    Direction.SetVector( 0, 1, 0 );
    InnerRadius := 0.9;
    OuterRadius := 1.3;
    Slices := 60;
    Loops := 1;
    setColor( Material, 0.6 );
  end;

  with TGLDisk.CreateAsChild( FCube ) do begin
    Position.SetPoint( 0, -0.8, 0 );
    Direction.SetVector( 0, 1, 0 );
    InnerRadius := 0.95;
    OuterRadius := 1.25;
    Slices := 60;
    Loops := 1;
    setColor( Material, 1 );
  end;

  addPlane( 0,'FRONT',1, 0,0,0.7, 0,0,1 );
  addPlane( 1,'RIGHT',1, 0.7,0,0, 1,0,0 );
  addPlane( 2,'LEFT',1, -0.7,0,0, -1,0,0 );
  addPlane( 3,'BACK',1, 0,0,-0.7, 0,0,-1 );
  addPlane( 4,'TOP',1, 0,0.7,0, 0,1,0 );
  addPlane( 5,'BOTTOM',1, 0,-0.7,0, 0,-1,0 );

  addCube( 6, 0.9, 0,0.6,0.6, 1,0.2,0.2 );
  addCube( 7, 0.9, 0,0.6,-0.6, 1,0.2,0.2 );
  addCube( 8, 0.9, 0,-0.6,0.6, 1,0.2,0.2 );
  addCube( 9, 0.9, 0,-0.6,-0.6, 1,0.2,0.2 );

  addCube( 10, 0.9, 0.6,0.6,0, 0.2,0.2,1 );
  addCube( 11, 0.9, 0.6,-0.6,0, 0.2,0.2,1 );
  addCube( 12, 0.9, -0.6,0.6,0, 0.2,0.2,1 );
  addCube( 13, 0.9, -0.6,-0.6,0, 0.2,0.2,1 );

  addCube( 14, 0.9, 0.6,0,0.6, 0.2,1,0.2 );
  addCube( 15, 0.9, 0.6,0,-0.6, 0.2,1,0.2 );
  addCube( 16, 0.9, -0.6,0,0.6, 0.2,1,0.2 );
  addCube( 17, 0.9, -0.6,0,-0.6, 0.2,1,0.2 );

  addCube( 18, 0.8, 0.6,0.6,0.6, 0.2,0.2,0.2 );
  addCube( 19, 0.8, 0.6,0.6,-0.6, 0.2,0.2,0.2 );
  addCube( 20, 0.8, 0.6,-0.6,0.6, 0.2,0.2,0.2 );
  addCube( 21, 0.8, -0.6,0.6,0.6, 0.2,0.2,0.2 );
  addCube( 22, 0.8, 0.6,-0.6,-0.6, 0.2,0.2,0.2 );
  addCube( 23, 0.8, -0.6,-0.6,0.6, 0.2,0.2,0.2 );
  addCube( 24, 0.8, -0.6,0.6,-0.6, 0.2,0.2,0.2 );
  addCube( 25, 0.8, -0.6,-0.6,-0.6, 0.2,0.2,0.2 );

end;


// DoProgress
//
procedure TGLNCube.DoProgress( const pt: TProgressTimes );
const
    tb: array[0..1]of array[0..3] of TVector = (
    ((0,20,1,0),(1,20,0,0),(0,20,-1,0),(-1,20,0,0)),
    ((0,-20,1,0),(1,-20,0,0),(0,-20,-1,0),(-1,-20,0,0)));
var
    mp: TPoint;
    mover: boolean;
    i: integer;
    v0,v1,v2,v: TVector;
    obj: TGLBaseSceneObject;

  procedure moveTo( trgv: TVector );
  begin
    FPosAnimationStart := FCam.Position.AsVector;
    FPosAnimationEnd := FCam.TargetObject.AbsoluteToLocal(
      VectorScale( VectorNormalize( trgv ), FCam.DistanceToTarget ));
    FDelta := 0;
  end;

begin

  mp := FViewer.ScreenToClient( mouse.CursorPos );
  mover := (mp.X > FHud.Position.X - 64) and (mp.X < FHud.Position.X + 64) and
    (mp.Y > FHud.Position.Y - 64) and (mp.Y < FHud.Position.Y + 64);

  // mouse Down/Up
  if FDelta > 1 then begin

    if iskeydown(VK_LBUTTON) and (not FMouseRotation) then begin

      // selection > start auto rotation
      if mover and (FSel >= 0) then begin

        v := FCam.AbsoluteVectorToTarget;
        v[1] := 0;
        if v[0] < 0 then i := -1 else i := 1;

        i := round((arccos(VectorAngleCosine( v, ZHmgPoint )) * i + PI) / PI * 2) mod 4;

        if (FSel = 4) or (FSel = 5) then moveTo( tb[FSel-4][i] )
          else moveTo( FSelPos );

        FInactiveTime := 0;

      end // start manual rotation
      else if FMouse then begin

        FMouseRotation := true;
        FMousePos := mouse.CursorPos;
        showCursor(false);
        mouse.CursorPos := point( sW2, sH2 );

        FInactiveTime := 0;

      end;
    end;

    // stop rotation, restore cursor
    if (not iskeydown(VK_LBUTTON)) and FMouseRotation and FMouse then begin

      showCursor(true);
      FMouseRotation := false;
      mouse.CursorPos := FMousePos;

      FInactiveTime := 0;

    end;

  end
  // auto rotation progress
  else begin

    FDelta := FDelta + pt.deltaTime * 2;

    v := VectorLerp( FPosAnimationStart, FPosAnimationEnd,
      FDelta * FDelta * ( 3 - 2 * FDelta ));
    v := VectorScale( VectorNormalize( v ), VectorLength( FPosAnimationStart ));
    if FDelta < 1 then FCam.Position.SetPoint( v )
      else FCam.Position.SetPoint( FPosAnimationEnd );

    v := VectorScale( VectorNormalize( v ), 10 );
    if FDelta < 1 then v := VectorScale( VectorNormalize( v ), 10 )
      else v := VectorScale( VectorNormalize( FPosAnimationEnd ), 10 );
    FNavCam.Position.SetPoint( v );

    for i := 2 to FCube.Count - 1 do
      with TGLSceneObject( FCube.Children[i] ) do
        Material.FrontProperties.Diffuse.SetColor( TagFloat, TagFloat, 1 );

    FInactiveTime := 0;

  end;

  FSel := -1;

  // manual rotation progress
  if FMouseRotation and FMouse then begin

    mp := mouse.CursorPos;
    if FCam <> nil then
      FCam.MoveAroundTarget( (sH2 - mp.Y) * 0.2, (sW2 - mp.X) * 0.2 );
      FNavCam.MoveAroundTarget( (sH2 - mp.Y) * 0.2, (sW2 - mp.X) * 0.2 );
    mouse.CursorPos := point( sW2, sH2 );

    FInactiveTime := 0;

  end
  else if FReady then begin

    // selection
    if mover and (FDelta > 1) then begin

      v0 := FNavCam.AbsolutePosition;
      v1 := FMem.Buffer.ScreenToVector(
        mp.X - round(FHud.Position.X) + 64, round(FHud.Position.Y) - mp.Y + 64 );
      setVector( v2, 99999, 99999, 99999 );

      obj := nil;
      for i := 2 to FCube.Count - 1 do
      with TGLSceneObject( FCube.Children[i] ) do begin
        Material.FrontProperties.Diffuse.SetColor( TagFloat, TagFloat, 1 );
        if RayCastIntersect( v0, v1, @v ) then
          if VectorDistance2( v2, v0 ) > VectorDistance2( v, v0 ) then begin
            setVector( v2, v );
            FSel := FCube.Children[i].Tag;
            FSelPos := FCube.Children[i].Position.AsVector;
            obj := FCube.Children[i];
          end;
      end;

      if FSel >= 0 then begin
        FViewer.cursor := -21;
        TGLSceneObject(obj).Material.FrontProperties.Diffuse.SetColor( 1, 0.6, 0 );
      end
      else FViewer.cursor := 0;

    end;

    v := VectorScale( VectorNormalize( FCam.AbsoluteVectorToTarget ), 10 );
    FNavCam.Position.SetPoint( VectorNegate(v) );

    FInactiveTime := FInactiveTime + pt.deltatime;

  end;

  // rendering
  FTimer := FTimer + pt.deltaTime;
  if FTimer > 1/FFps then  begin
    FTimer := FTimer - floor(FTimer * FFps) / FFps;
    FMem.Render( FCube );
    FMem.CopyToTexture( FHud.Material.Texture );
    FReady := true;
  end;

end;


// DoRender (setup)
//
procedure TGLNCube.DoRender( var ARci: TRenderContextInfo;
  ARenderSelf, ARenderChildren: Boolean);
begin

  inherited;

  if (FCam = nil) and (scene.CurrentGLCamera <> nil) then begin
    FCam := scene.CurrentGLCamera;
    FNavCam.Position.SetPoint(
      VectorScale( VectorNormalize( FCam.Position.AsVector ), 10 ));
  end;

  if FViewer <> nil then
    FHud.Position.SetPoint( FViewer.Width - 80, 50, 0 );

end;


initialization

  sW2 := screen.Width div 2;
  sH2 := screen.Height div 2;

end.
