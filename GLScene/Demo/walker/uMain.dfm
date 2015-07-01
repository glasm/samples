object Form1: TForm1
  Left = 191
  Top = 125
  Width = 793
  Height = 551
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 777
    Height = 513
    Camera = cam_player
    Buffer.BackgroundColor = 13290186
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 141.330383300781300000
    Align = alClient
    OnMouseDown = vpMouseDown
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc: TGLDummyCube
      CubeSize = 1.000000000000000000
      object dc_emitter: TGLDummyCube
        Position.Coordinates = {0080BB440000FA44000096430000803F}
        CubeSize = 1.000000000000000000
        EffectsData = {
          0458434F4C02010201061254474C536F75726365504658456666656374020202
          00060002000200060470667831050000000000000080FF3F0206020009000000
          00000048C3000000000000000002000802000900007A450000000000C05A4500
          0000000500000000000000C80540050000000000000080FF3F0500000000006F
          1283F53F02000200090500000000000000000000080200}
      end
      object ff: TGLFreeForm
        Material.MaterialLibrary = matlib
        Up.Coordinates = {000000000000803F0000008000000000}
      end
    end
    object PFXRenderer: TGLParticleFXRenderer
      ZSortAccuracy = saLow
    end
    object dc_player: TGLDummyCube
      CubeSize = 5.000000000000000000
      VisibleAtRunTime = True
      BehavioursData = {
        0458434F4C02010201060F54474C424650534D6F76656D656E74020006000200
        020002000F0000204108080615474C4650534D6F76656D656E744D616E616765
        7231}
      object cam_player: TGLCamera
        DepthOfView = 10000.000000000000000000
        FocalLength = 90.000000000000000000
        Position.Coordinates = {0000000000003443000000000000803F}
        Direction.Coordinates = {00000000000000000000803F00000000}
        Up.Coordinates = {000000000000803F0000008000000000}
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    Mode = cmApplicationIdle
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 8
    Top = 40
  end
  object pfx1: TGLPerlinPFXManager
    Cadencer = cad
    Renderer = PFXRenderer
    Acceleration.Coordinates = {000000000000C8C20000000000000000}
    Friction = 1.000000000000000000
    BlendingMode = bmTransparency
    Smoothness = 1.000000000000000000
    Brightness = 1.000000000000000000
    Gamma = 1.000000000000000000
    SpritesPerTexture = sptOne
    ParticleSize = 4.000000000000000000
    ColorInner.Color = {00000000000000000000000000000000}
    LifeColors = <
      item
        ColorInner.Color = {0000000000000000000000000000803F}
        ColorOuter.Color = {0000000000000000000000000000803F}
        LifeTime = 5.000000000000000000
        SizeScale = 2.000000000000000000
      end>
    Left = 40
    Top = 40
  end
  object GLFPSMovementManager1: TGLFPSMovementManager
    Navigator = GLNavigator1
    Scene = GLScene1
    DisplayTime = 0
    MovementScale = 4.000000000000000000
    Left = 72
    Top = 8
    MapsData = {
      0458434F4C02010201061454474C4D6170436F6C6C656374696F6E4974656D02
      0006000200020006026666}
  end
  object GLNavigator1: TGLNavigator
    Left = 72
    Top = 40
  end
  object matlib: TGLMaterialLibrary
    Materials = <
      item
        Name = 'detailmap'
        Tag = 0
        Material.Texture.TextureMode = tmModulate
        Material.Texture.FilteringQuality = tfAnisotropic
        TextureScale.Coordinates = {0000A0420000A0420000A04200000000}
      end
      item
        Name = 'lightmap'
        Tag = 0
        Material.Texture.FilteringQuality = tfAnisotropic
      end>
    Left = 104
    Top = 8
  end
end
