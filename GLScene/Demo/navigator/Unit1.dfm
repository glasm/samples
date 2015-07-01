object Form1: TForm1
  Left = 233
  Top = 410
  Width = 870
  Height = 600
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 854
    Height = 562
    Camera = cam
    Buffer.FogEnvironment.FogColor.Color = {D5D4543FD1D0503FC9C8483F0AD7A33C}
    Buffer.FogEnvironment.FogStart = 10.000000000000000000
    Buffer.FogEnvironment.FogEnd = 1000.000000000000000000
    Buffer.FogEnvironment.FogMode = fmExp2
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    Buffer.FogEnable = True
    FieldOfView = 159.821228027343800000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc_world: TGLDummyCube
      CubeSize = 1.000000000000000000
      object ter: TGLTerrainRenderer
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Direction.Coordinates = {000000000000803F0000000000000000}
        Scale.Coordinates = {00000040000000400000164300000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        HeightDataSource = GLCustomHDS1
        TileSize = 8
        TilesPerTexture = 1.000000000000000000
        QualityDistance = 50.000000000000000000
        QualityStyle = hrsTesselated
        CLODPrecision = 10
      end
    end
    object dc_player: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLExtrusionSolid1: TGLExtrusionSolid
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {00000000000080BE000000000000803F}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Contours = <
          item
            Nodes = <
              item
                X = 0.750000000000000000
              end
              item
                X = 0.250000000000000000
                Y = 1.500000000000000000
              end
              item
                X = -0.250000000000000000
                Y = 1.500000000000000000
              end
              item
                X = -0.750000000000000000
              end
              item
                X = -0.500000000000000000
                Y = -0.500000000000000000
              end
              item
                X = 0.500000000000000000
                Y = -0.500000000000000000
              end
              item
                X = 0.750000000000000000
              end>
          end>
        Parts = [espOutside, espInside, espStartPolygon, espStopPolygon]
        Height = 0.250000000000000000
        MinSmoothAngle = 5.000000000000000000
        object targ: TGLSprite
          Position.Coordinates = {0000000000002041000000000000803F}
          Width = 0.500000000000000000
          Height = 0.500000000000000000
          Rotation = 45.000000000000000000
        end
      end
    end
    object dc_cam: TGLDummyCube
      Position.Coordinates = {000000000000A0400000A0400000803F}
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = dc_target
        Position.Coordinates = {0000000000000000000080BF0000803F}
      end
    end
    object dc_target: TGLDummyCube
      Position.Coordinates = {0000204100000000000020410000803F}
      CubeSize = 1.000000000000000000
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object GLCustomHDS1: TGLCustomHDS
    MaxPoolSize = 0
    OnStartPreparingData = GLCustomHDS1StartPreparingData
    Left = 72
    Top = 8
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    Interval = 500
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 104
    Top = 8
  end
end
