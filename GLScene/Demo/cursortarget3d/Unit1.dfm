object Form1: TForm1
  Left = 197
  Top = 132
  Width = 800
  Height = 600
  Caption = 'CursorTarget'
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
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 784
    Height = 562
    Camera = Camera
    Buffer.ContextOptions = [roDoubleBuffer]
    FieldOfView = 150.111785888671900000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object Player: TGLDummyCube
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object Actor: TGLCone
        Direction.Coordinates = {00000000000080BF0000000000000000}
        PitchAngle = -90.000000000000000000
        Up.Coordinates = {00000000000000000000803F00000000}
        BottomRadius = 0.500000000000000000
        Height = 1.000000000000000000
      end
    end
    object targ: TGLPlane
      Material.FrontProperties.Diffuse.Color = {0000803F00000000000000000000803F}
      Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
      Material.BlendingMode = bmTransparency
      Material.Texture.ImageClassName = 'TGLPicFileImage'
      Material.Texture.Image.PictureFileName = 'tp.tga'
      Material.Texture.MinFilter = miLinear
      Material.Texture.TextureMode = tmModulate
      Material.Texture.TextureWrap = twNone
      Material.Texture.TextureFormat = tfRGBA16
      Material.Texture.Disabled = False
      Direction.Coordinates = {000000000000803F0000000000000000}
      ShowAxes = True
      Up.Coordinates = {0000000000000000000080BF00000000}
      Height = 1.000000000000000000
      Width = 1.000000000000000000
    end
    object Camera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 75.000000000000000000
      TargetObject = Player
      Position.Coordinates = {0000000000002041000080BF0000803F}
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    SleepLength = 1
    OnProgress = cadProgress
    Left = 8
    Top = 40
  end
end
