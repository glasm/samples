object Form1: TForm1
  Left = 364
  Top = 463
  Width = 753
  Height = 531
  Caption = 'naviCube'
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
    Width = 737
    Height = 493
    Camera = cam
    Buffer.BackgroundColor = 12303291
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    Buffer.AntiAliasing = aa6x
    FieldOfView = 159.308502197265600000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc_utils: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLXYZGrid1: TGLXYZGrid
        LineColor.Color = {1283003F1283003F1283003F9A99193F}
        XSamplingScale.Min = -8.000000000000000000
        XSamplingScale.max = 8.000000000000000000
        XSamplingScale.step = 1.000000000000000000
        YSamplingScale.step = 0.100000001490116100
        ZSamplingScale.Min = -8.000000000000000000
        ZSamplingScale.max = 8.000000000000000000
        ZSamplingScale.step = 1.000000000000000000
        Parts = [gpX, gpZ]
      end
      object GLXYZGrid2: TGLXYZGrid
        Position.Coordinates = {000000000AD7233C000000000000803F}
        LineColor.Color = {1283003F1283003F1283003F9A99193F}
        XSamplingScale.Min = -8.000000000000000000
        XSamplingScale.max = 8.000000000000000000
        XSamplingScale.step = 8.000000000000000000
        YSamplingScale.step = 0.100000001490116100
        ZSamplingScale.Min = -8.000000000000000000
        ZSamplingScale.max = 8.000000000000000000
        ZSamplingScale.step = 8.000000000000000000
        Parts = [gpX, gpZ]
      end
      object dc_cam: TGLDummyCube
        Position.Coordinates = {0000803F0000803F0000803F0000803F}
        CubeSize = 1.000000000000000000
        EdgeColor.Color = {0000803F000000000000803F0000803F}
        VisibleAtRunTime = True
        object cam: TGLCamera
          DepthOfView = 100.000000000000000000
          FocalLength = 45.000000000000000000
          TargetObject = dc_cam
          Position.Coordinates = {0000000000000000000000410000803F}
          object GLLightSource1: TGLLightSource
            ConstAttenuation = 1.000000000000000000
            SpotCutOff = 180.000000000000000000
          end
        end
      end
    end
    object dc_world: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLTorus1: TGLTorus
        Position.Coordinates = {00000000000000000000A0C00000803F}
        MajorRadius = 2.000000000000000000
        MinorRadius = 0.500000000000000000
        StopAngle = 360.000000000000000000
        Parts = [toSides, toStartDisk, toStopDisk]
      end
      object GLCube1: TGLCube
        Position.Coordinates = {0000C0BF00000000000020400000803F}
        CubeSize = {000000400000803F00000040}
        object GLTeapot1: TGLTeapot
          Material.FrontProperties.Diffuse.Color = {48E15A3F48E15A3FE7FB693F0000803F}
          Position.Coordinates = {000000000000003F000000000000803F}
          Scale.Coordinates = {00000040000000400000004000000000}
        end
      end
      object GLCube2: TGLCube
        Position.Coordinates = {0000C03F00000000000020400000803F}
        CubeSize = {000000400000803F00000040}
      end
      object GLCube3: TGLCube
        Position.Coordinates = {0000C0BF000000000000B0400000803F}
        CubeSize = {000000400000803F00000040}
      end
      object GLCube4: TGLCube
        Position.Coordinates = {0000C03F000000000000B0400000803F}
        CubeSize = {000000400000803F00000040}
        object GLCone1: TGLCone
          Material.FrontProperties.Diffuse.Color = {0000803F83C04A3FA8C64B3F0000803F}
          Position.Coordinates = {000000000000403F000000000000803F}
          Normals = nsFlat
          BottomRadius = 0.699999988079071000
          Height = 0.500000000000000000
          Slices = 4
          Stacks = 1
        end
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
    Interval = 800
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpIdle
    Left = 72
    Top = 8
  end
end
