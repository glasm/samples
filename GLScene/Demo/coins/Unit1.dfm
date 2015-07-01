object Form1: TForm1
  Left = 199
  Top = 129
  Width = 704
  Height = 484
  Caption = 'Form1'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    Camera = cam
    Buffer.FogEnvironment.FogStart = 1.000000000000000000
    Buffer.FogEnvironment.FogEnd = 3.000000000000000000
    Buffer.BackgroundColor = clBlack
    FieldOfView = 131.694168090820300000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object DummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
      object Earth: TGLSphere
        Material.FrontProperties.Ambient.Color = {0000000000000000000000000000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Specular.Color = {9A99193F9A99193F9A99193F0000803F}
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'earth.jpg'
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureFormat = tfRGB16
        Material.Texture.Disabled = False
        Direction.Coordinates = {0000803FE81E7C32F4831AB300000000}
        TurnAngle = 90.000000000000000000
        Up.Coordinates = {000000007B096D3F9262C13E00000000}
        Radius = 0.500000000000000000
        Slices = 32
        Stacks = 20
      end
      object Ring: TGLDummyCube
        Direction.Coordinates = {230B13BE88389EBEB7AD703F00000000}
        Up.Coordinates = {6FF6A03E75F4623FBDC8AD3E00000000}
        CubeSize = 1.000000000000000000
      end
    end
    object lamp: TGLLightSource
      ConstAttenuation = 400.000000000000000000
      Position.Coordinates = {00007A440000FA4300007A440000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object cam: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 100.000000000000000000
      TargetObject = DummyCube1
      Position.Coordinates = {0000000000000000000000400000803F}
    end
  end
  object timer: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = timerTimer
    Left = 72
    Top = 8
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
end
