object Form1: TForm1
  Left = 541
  Top = 166
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 413
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SceneViewer: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 505
    Height = 413
    Camera = Camera
    Buffer.FogEnvironment.FogColor.Color = {9CC4403FFED4583F48E17A3F0000803F}
    Buffer.FogEnvironment.FogStart = 3500.000000000000000000
    Buffer.FogEnvironment.FogEnd = 10000.000000000000000000
    Buffer.BackgroundColor = 16242626
    Buffer.ContextOptions = [roDoubleBuffer, roStencilBuffer, roRenderToWindow, roDestinationAlpha, roNoColorBufferClear]
    Buffer.FogEnable = True
    Buffer.Lighting = False
    Buffer.AntiAliasing = aaNone
    FieldOfView = 152.777770996093800000
    Align = alClient
    TabOrder = 0
  end
  object GLScene: TGLScene
    ObjectsSorting = osNone
    Left = 8
    Top = 8
    object GLRenderPoint: TGLRenderPoint
    end
    object DOInitializeReflection: TGLDirectOpenGL
      UseBuildList = False
      OnRender = DOInitializeReflectionRender
      Blend = False
    end
    object EarthSkyDome: TGLEarthSkyDome
      Direction.Coordinates = {000000000000803F0100003300000000}
      RollAngle = 45.000000000000000000
      Up.Coordinates = {F30435BFF404B532F30435BF00000000}
      Bands = <>
      Stars = <>
      SunElevation = 30.000000000000000000
      Turbidity = 20.000000000000000000
      SunZenithColor.Color = {0000803F0000803F0000803F0AD7233C}
      SunDawnColor.Color = {0000803F0000803F0000403F0AD7233C}
      HazeColor.Color = {6666663F3333733F0000803F0000803F}
      SkyColor.Color = {6666E63E6666263F0000803F6666663F}
      NightColor.Color = {0000000000000000000000000000803F}
      DeepColor.Color = {9CC4403FFED4583F48E17A3F0000803F}
      ExtendedOptions = []
      Slices = 48
      Stacks = 24
    end
    object Light: TGLLightSource
      Ambient.Color = {CDCC4C3FCDCC4C3FCDCC4C3F0000803F}
      ConstAttenuation = 1.000000000000000000
      LightStyle = lsParallel
      SpotCutOff = 180.000000000000000000
      SpotDirection.Coordinates = {00000000000000000000803F00000000}
    end
    object Terrain: TGLTerrainRenderer
      Direction.Coordinates = {000000000000803F0000000000000000}
      Position.Coordinates = {0000C0450080A2430000C0C50000803F}
      Scale.Coordinates = {00004041000040410000C04000000000}
      Up.Coordinates = {00000000000000800000803F00000000}
      HeightDataSource = GLHeightTileFileHDS
      TileSize = 32
      TilesPerTexture = 32.000000000000000000
      MaterialLibrary = MLTerrain
      QualityDistance = 250.000000000000000000
      QualityStyle = hrsTesselated
      MaxCLODTriangles = 165536
      CLODPrecision = 15
      OnGetTerrainBounds = TerrainGetTerrainBounds
    end
    object DOClassicWaterPlane: TGLDirectOpenGL
      UseBuildList = False
      OnRender = DOClassicWaterPlaneRender
      Blend = False
    end
    object DOGLSLWaterPlane: TGLDirectOpenGL
      UseBuildList = False
      OnRender = DOGLSLWaterPlaneRender
      Blend = False
    end
    object RenderTrees: TGLParticleFXRenderer
      ZCull = False
      BlendingMode = bmTransparency
    end
    object DOTrees: TGLDirectOpenGL
      UseBuildList = False
      OnRender = DOTreesRender
      Blend = False
    end
    object GLHUDText1: TGLHUDText
      Position.Coordinates = {0000A0410000A041000000000000803F}
      BitmapFont = GLWindowsBitmapFont1
      ModulateColor.Color = {48E13A3F0AD7233E8FC2753F0000803F}
    end
    object Camera: TGLCamera
      DepthOfView = 10000.000000000000000000
      FocalLength = 50.000000000000000000
      Direction.Coordinates = {0000803F000000000000000000000000}
      Up.Coordinates = {000000000000803F0000008000000000}
    end
  end
  object MLTrees: TGLMaterialLibrary
    Left = 208
    Top = 8
  end
  object MLTerrain: TGLMaterialLibrary
    Left = 104
    Top = 8
  end
  object GLCadencer: TGLCadencer
    Scene = GLScene
    OnProgress = GLCadencerProgress
    Left = 8
    Top = 40
  end
  object GLWindowsBitmapFont1: TGLWindowsBitmapFont
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Left = 40
    Top = 8
  end
  object SIBTree: TGLStaticImposterBuilder
    RenderPoint = GLRenderPoint
    BackColor.Color = {0000803E0000003F0000000000000000}
    BuildOffset.Coordinates = {000000009A99193F000000000000803F}
    ImposterOptions = [impoBlended, impoAlphaTest, impoPerspectiveCorrection]
    ImposterReference = irBottom
    AlphaTreshold = 0.500000000000000000
    OnImposterLoaded = SIBTreeImposterLoaded
    Coronas = <
      item
        Samples = 13
        Elevation = -15.000000000000000000
      end
      item
        Samples = 13
      end
      item
        Samples = 13
        Elevation = 15.000000000000000000
      end
      item
        Samples = 13
        Elevation = 28.000000000000000000
      end
      item
        Samples = 12
        Elevation = 40.000000000000000000
      end>
    SampleSize = 128
    SamplingRatioBias = 1.149999976158142000
    SamplesAlphaScale = 5.000000000000000000
    Left = 208
    Top = 40
  end
  object PFXTrees: TGLCustomPFXManager
    Cadencer = GLCadencer
    Renderer = RenderTrees
    OnCreateParticle = PFXTreesCreateParticle
    Friction = 1.000000000000000000
    BlendingMode = bmTransparency
    OnBeginParticles = PFXTreesBeginParticles
    OnRenderParticle = PFXTreesRenderParticle
    OnEndParticles = PFXTreesEndParticles
    OnProgress = PFXTreesProgress
    OnGetParticleCountEvent = PFXTreesGetParticleCountEvent
    ParticleSize = 1.000000000000000000
    LifeColors = <
      item
        LifeTime = 3.000000000000000000
        SizeScale = 1.000000000000000000
      end>
    Left = 208
    Top = 72
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 72
  end
  object MLWater: TGLMaterialLibrary
    Materials = <
      item
        Name = 'Water'
        Material.BackProperties.Diffuse.Color = {CDCC4C3ECDCCCC3ECDCC4C3FCDCCCC3E}
        Material.FrontProperties.Diffuse.Color = {CDCC4C3E0000003F0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'media\caustics.bmp'
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureFormat = tfLuminance
        Material.Texture.Disabled = False
        Material.FaceCulling = fcNoCull
        Tag = 0
      end
      item
        Name = 'WaterBump'
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'media\caustics.bmp'
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureFormat = tfRGB
        Material.Texture.Disabled = False
        Tag = 0
      end>
    Left = 152
    Top = 8
  end
  object GLHeightTileFileHDS: TGLHeightTileFileHDS
    HTFFileName = 'media\volcano.htf'
    InfiniteWrap = False
    MinElevation = -7000
    MaxPoolSize = 0
    DefaultHeight = -9999.000000000000000000
    Left = 152
    Top = 40
  end
end
