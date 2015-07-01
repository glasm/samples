object Form1: TForm1
  Left = 255
  Top = 353
  BorderStyle = bsToolWindow
  Caption = 'Cylinder'
  ClientHeight = 573
  ClientWidth = 862
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
    Width = 862
    Height = 496
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 177.690002441406300000
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 496
    Width = 862
    Height = 77
    Align = alBottom
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 1
    object stop1: TButton
      Left = 8
      Top = 6
      Width = 73
      Height = 65
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = stop1Click
    end
    object go: TButton
      Left = 784
      Top = 6
      Width = 73
      Height = 65
      Caption = 'GO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = goClick
    end
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dogl: TGLDirectOpenGL
      UseBuildList = False
      OnRender = doglRender
      Blend = False
      object cyl1: TGLCylinder
        TagFloat = 1.000000000000000000
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.ImageClassName = 'TGLCompositeImage'
        Material.Texture.Image.Width = 256
        Material.Texture.Image.Height = 256
        Material.Texture.Image.Depth = 0
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {000040C000000000000000000000803F}
        Up.Coordinates = {000080BF000000000000008000000000}
        Visible = False
        BottomRadius = 3.819720029830933000
        Height = 3.000000000000000000
        Slices = 64
        TopRadius = 3.819720029830933000
        Parts = [cySides]
      end
      object cyl2: TGLCylinder
        TagFloat = 1.000000000000000000
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.ImageClassName = 'TGLCompositeImage'
        Material.Texture.Image.Width = 256
        Material.Texture.Image.Height = 256
        Material.Texture.Image.Depth = 0
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
        Direction.Coordinates = {000000000000803F0000000000000000}
        Position.Coordinates = {000040C000000000000000000000803F}
        Up.Coordinates = {000080BF000000000000008000000000}
        Visible = False
        BottomRadius = 3.819720029830933000
        Height = 3.000000000000000000
        Slices = 64
        TopRadius = 3.819720029830933000
        Parts = [cySides]
      end
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 5.000000000000000000
      CameraStyle = csOrthogonal
      Position.Coordinates = {0000000000000000000020410000803F}
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        LightStyle = lsParallel
        SpotCutOff = 180.000000000000000000
      end
    end
    object GLPlane1: TGLPlane
      Material.FrontProperties.Diffuse.Color = {EBE0E03EE4DB5B3F9A93133F0000803F}
      Material.FrontProperties.Emission.Color = {EBE0E03EE4DB5B3F9A93133F0000803F}
      Material.MaterialOptions = [moNoLighting]
      Position.Coordinates = {00000000000000000000A0400000803F}
      Height = 0.100000001490116100
      Width = 12.000000000000000000
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    SleepLength = 1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
end
