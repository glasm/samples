object Form1: TForm1
  Left = 197
  Top = 129
  Width = 979
  Height = 563
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 963
    Height = 525
    Camera = cam
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow, roNoColorBufferClear]
    FieldOfView = 142.150711059570300000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object GLEarthSkyDome1: TGLEarthSkyDome
      Direction.Coordinates = {000000330000803F0000000000000000}
      RollAngle = -10.000000000000000000
      Up.Coordinates = {D2D0313E990029B25D1C7CBF00000000}
      Bands = <>
      Stars = <>
      SunElevation = 45.000000000000000000
      Turbidity = 5.000000000000000000
      ExtendedOptions = []
      Slices = 48
      Stacks = 24
    end
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 500.000000000000000000
        FocalLength = 90.000000000000000000
        Direction.Coordinates = {00000000000000000000803F00000000}
        Up.Coordinates = {000000000000803F0000008000000000}
        object light: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          Position.Coordinates = {000000000000A040000000000000803F}
          SpotCutOff = 180.000000000000000000
        end
      end
    end
    object terra: TGLTerrainRenderer
      Direction.Coordinates = {000000000000803F0000000000000000}
      Position.Coordinates = {000040C300000000000040430000803F}
      Scale.Coordinates = {00004040000040400000803F00000000}
      Up.Coordinates = {0000000000000000000080BF00000000}
      HeightDataSource = hds
      TileSize = 64
      TilesPerTexture = 2.000000000000000000
      QualityDistance = 1000.000000000000000000
      CLODPrecision = 2000
      OcclusionTesselate = totTesselateAlways
    end
    object GLDummyCube1: TGLDummyCube
      Position.Coordinates = {00000000000000000000A0400000803F}
      Up.Coordinates = {000000000000803F0000008000000000}
      CubeSize = 1.000000000000000000
      EdgeColor.Color = {000000000000003F0000003F0000803F}
      VisibleAtRunTime = True
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object hds: TGLBitmapHDS
    InfiniteWrap = False
    MaxPoolSize = 0
    Left = 8
    Top = 40
  end
  object at: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = atTimer
    Left = 40
    Top = 40
  end
end
