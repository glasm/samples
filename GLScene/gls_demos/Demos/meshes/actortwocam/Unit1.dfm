object Form1: TForm1
  Left = 77
  Top = 70
  Width = 665
  Height = 442
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 25
    Width = 657
    Height = 388
    Camera = GLCamera2
    Buffer.BackgroundColor = clGreen
    Align = alClient
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label3: TLabel
      Left = 352
      Top = 6
      Width = 76
      Height = 14
      Caption = 'F7 Third Person'
    end
    object Label4: TLabel
      Left = 448
      Top = 6
      Width = 83
      Height = 14
      Caption = 'F8 First Person'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 332
      Height = 14
      Caption = 
        'Move with arrow keys, strafe with CTRL, run with SHIFT, ESC to e' +
        'xit'
    end
    object CBMouseLook: TCheckBox
      Left = 552
      Top = 4
      Width = 97
      Height = 17
      Caption = '&Mouse Look'
      TabOrder = 0
      OnClick = CBMouseLookClick
    end
  end
  object GLScene1: TGLScene
    ObjectsSorting = osNone
    Left = 40
    Top = 32
    object SkyDome1: TGLSkyDome
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {E9DC72BF000000009BE8A13E00000000}
      Bands = <
        item
          StartColor.Color = {0000803F0000803F0000803F0000803F}
          StopAngle = 15
        end
        item
          StartAngle = 15
          StopAngle = 90
          StopColor.Color = {938C0C3E938C0C3E938E0E3F0000803F}
          Stacks = 4
        end>
      Stars = <>
    end
    object Disk1: TGLDisk
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      Material.Texture.MinFilter = miLinear
      Material.Texture.MappingTCoordinates.Coordinates = {000000000000803F0000000000000000}
      Material.Texture.Disabled = False
      Loops = 1
      OuterRadius = 80
      Slices = 7
      SweepAngle = 360
    end
    object GLLightSource2: TGLLightSource
      ConstAttenuation = 1
      Position.Coordinates = {0000704200003443000000000000803F}
      LightStyle = lsOmni
      SpotCutOff = 180
    end
    object DummyCube1: TGLDummyCube
      Direction.Coordinates = {00000000000000800000803F00000000}
      CubeSize = 1
      object FreeForm1: TGLFreeForm
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {0000803F0000803F000000000000803F}
        Scale.Coordinates = {0AD7A33CCDCCCC3C4260E53C00000000}
        Up.Coordinates = {00000000000000000000803F00000000}
        Material.FrontProperties.Diffuse.Color = {0AD7633FD7A3F03ECDCC4C3E0000803F}
        Material.Texture.MappingTCoordinates.Coordinates = {000000000000803F0000000000000000}
        NormalsOrientation = mnoInvert
      end
    end
    object DummyCube2: TGLDummyCube
      Direction.Coordinates = {00000000000000800000803F00000000}
      Position.Coordinates = {000000000000803F000000000000803F}
      CubeSize = 0.100000001490116
      object GLCamera2: TGLCamera
        DepthOfView = 500
        FocalLength = 100
        Position.Coordinates = {000000000000003F000000000000803F}
        Direction.Coordinates = {00000080000000000000803F00000000}
        Left = 320
        Top = 192
      end
      object Actor1: TGLActor
        Direction.Coordinates = {000000800000803F0000000000000000}
        Up.Coordinates = {0000803F000000000000000000000000}
        Visible = False
        Material.FrontProperties.Emission.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.MappingTCoordinates.Coordinates = {000000000000803F0000000000000000}
        Material.Texture.Disabled = False
        Interval = 100
        object Actor2: TGLActor
          Direction.Coordinates = {00000080000000000000803F00000000}
          Material.Texture.MinFilter = miLinear
          Material.Texture.MappingTCoordinates.Coordinates = {000000000000803F0000000000000000}
          Material.Texture.Disabled = False
          Interval = 100
        end
      end
      object DummyCube3: TGLDummyCube
        CubeSize = 1
        object GLCamera1: TGLCamera
          DepthOfView = 1000
          FocalLength = 200
          TargetObject = DummyCube2
          Position.Coordinates = {00000000000040400000A0C10000803F}
          Direction.Coordinates = {00000000000000800000803F00000000}
        end
      end
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    SleepLength = 0
    OnProgress = GLCadencer1Progress
    Left = 8
    Top = 32
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 64
  end
  object GLNavigator1: TGLNavigator
    VirtualUp.Coordinates = {000000000000803F000000000000803F}
    MovingObject = DummyCube2
    UseVirtualUp = True
    AutoUpdateObject = False
    AngleLock = False
    Left = 40
    Top = 64
  end
  object GLUserInterface1: TGLUserInterface
    InvertMouse = False
    MouseSpeed = 20
    GLNavigator = GLNavigator1
    Left = 40
    Top = 96
  end
end
