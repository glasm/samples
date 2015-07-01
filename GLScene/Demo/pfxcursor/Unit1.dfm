object Form1: TForm1
  Left = 403
  Top = 221
  Width = 777
  Height = 555
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 761
    Height = 517
    Cursor = -1
    Camera = cam
    Buffer.BackgroundColor = clBlack
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 147.641372680664100000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object cur: TGLHUDSprite
      Material.FrontProperties.Diffuse.Color = {000000000000803F000000000000803F}
      Material.BlendingMode = bmTransparency
      Material.MaterialOptions = [moNoLighting]
      Material.Texture.ImageClassName = 'TGLPicFileImage'
      Material.Texture.Image.PictureFileName = 'cur.bmp'
      Material.Texture.ImageAlpha = tiaAlphaFromIntensity
      Material.Texture.TextureMode = tmModulate
      Material.Texture.TextureWrap = twNone
      Material.Texture.Disabled = False
      Position.Coordinates = {00C08A4300C08A43000000000000803F}
      Width = 32.000000000000000000
      Height = 32.000000000000000000
    end
    object dc_cur: TGLDummyCube
      CubeSize = 0.009999999776482582
      VisibleAtRunTime = True
      object dc1: TGLDummyCube
        Visible = False
        CubeSize = 1.000000000000000000
        EffectsData = {
          0458434F4C02010203061254474C536F75726365504658456666656374020202
          00060002000200060470667831050000000000000080FE3F0206020009000000
          00000000BF0000000000000000020008020008050000000000CDCCCCFC3F0500
          00000000CDCCCCFC3F0500000000000AD7A3F83F020002000905000000000000
          000000000902000200020202000600020002000617474C506F696E744C696768
          745046584D616E6167657232050000000000000080FD3F020602000802000802
          0008050000000000CDCCCCFD3F050000000000CDCCCCFC3F0500000000000AD7
          A3F83F0200020009050000000000000000000009020002000202020006000200
          02000617474C506F696E744C696768745046584D616E61676572330500000000
          00000080FF3F0206020008020008020008050000000000000000000005000000
          000000000000000500000000000AD7A3F73F0200020009050000000000000000
          0000090200}
      end
      object dc2: TGLDummyCube
        Visible = False
        CubeSize = 1.000000000000000000
        EffectsData = {
          0458434F4C02010201061254474C536F75726365504658456666656374020202
          00060002000200060470667832050000000000000080FF3F0206020009000000
          00000000400000000000000000020008020008050000000000000080FE3F0500
          00000000CDCCCCFC3F0500000000008FC2F5F83F020102010905000000000000
          00000000090201}
      end
      object dc3: TGLDummyCube
        CubeSize = 1.000000000000000000
        EffectsData = {
          0458434F4C02010201061254474C536F75726365504658456666656374020202
          00060002000200060470667833050000000000000080FF3F0206020008020008
          0200080500000000000000800040050000000000CDCCCCFB3F0500000000000A
          D7A3F73F02000200090500000000000000000000090200}
      end
    end
    object rend: TGLParticleFXRenderer
    end
    object cam: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 75.000000000000000000
      Position.Coordinates = {0000000000000000000000410000803F}
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'plane'
        Tag = 0
        Material.FrontProperties.Emission.Color = {EBE0E03EE4DB5B3F9A93133F0000803F}
      end>
    Left = 40
    Top = 8
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = cadProgress
    Left = 8
    Top = 40
  end
  object pfx1: TGLPointLightPFXManager
    Cadencer = cad
    Renderer = rend
    Friction = 1.000000000000000000
    ColorMode = scmFade
    ParticleSize = 1.000000000000000000
    ColorInner.Color = {0000803F000000000000803F0000803F}
    ColorOuter.Color = {0000803F00000000000000000000803F}
    LifeColors = <
      item
        LifeTime = 5.000000000000000000
        SizeScale = 2.000000000000000000
      end>
    Left = 40
    Top = 40
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 72
    Top = 8
  end
  object GLPointLightPFXManager2: TGLPointLightPFXManager
    Cadencer = cad
    Renderer = rend
    Acceleration.Coordinates = {00000000000040BF0000000000000000}
    Friction = 1.000000000000000000
    ParticleSize = 0.500000000000000000
    ColorInner.Color = {000000000000803F0000803F0000803F}
    ColorOuter.Color = {0000803F0000803F0000803F0000803F}
    LifeColors = <
      item
        LifeTime = 3.000000000000000000
        SizeScale = 0.500000000000000000
        RotateAngle = 0.300000011920929000
      end>
    Left = 40
    Top = 72
  end
  object GLPointLightPFXManager3: TGLPointLightPFXManager
    Cadencer = cad
    Renderer = rend
    Friction = 1.000000000000000000
    ColorMode = scmFade
    ParticleSize = 0.500000000000000000
    ColorInner.Color = {ACC8483ECDCC4C3FACC8483E0000803F}
    ColorOuter.Color = {0000803F0000803F000000000000803F}
    LifeColors = <
      item
        LifeTime = 1.000000000000000000
        SizeScale = 1.000000000000000000
      end>
    Left = 40
    Top = 104
  end
  object pfx2: TGLCustomSpritePFXManager
    Cadencer = cad
    Renderer = rend
    Friction = 1.000000000000000000
    OnPrepareTextureImage = pfx2PrepareTextureImage
    ColorMode = scmFade
    ParticleSize = 0.750000000000000000
    ColorInner.Color = {0000803F1283C03E000000000000803F}
    LifeColors = <
      item
        ColorInner.Color = {0000003F0000003F0000000000000000}
        LifeTime = 0.750000000000000000
        SizeScale = 3.000000000000000000
      end>
    Left = 72
    Top = 40
  end
  object pfx3: TGLCustomSpritePFXManager
    Cadencer = cad
    Renderer = rend
    Acceleration.Coordinates = {000000009A9999BE0000000000000000}
    Friction = 1.000000000000000000
    OnPrepareTextureImage = pfx3PrepareTextureImage
    ParticleSize = 0.750000000000000000
    ColorInner.Color = {0000803FAE47E13D7B142E3F0000803F}
    LifeColors = <
      item
        ColorInner.Color = {CDCC4C3FACC8483E9A99193F00000000}
        LifeTime = 0.750000000000000000
        SizeScale = 3.000000000000000000
        RotateAngle = 0.949999988079071000
      end>
    Left = 104
    Top = 40
  end
end
