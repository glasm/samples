object Form1: TForm1
  Left = 196
  Top = 144
  Width = 756
  Height = 544
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 33
    Width = 740
    Height = 473
    Camera = cam
    Buffer.BackgroundColor = 8404992
    Buffer.AmbientColor.Color = {0000803F0000803F0000803F0000803F}
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 144.809783935546900000
    Align = alClient
    OnMouseDown = vpMouseDown
    OnMouseUp = vpMouseUp
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 740
    Height = 33
    BorderWidth = 1
    ButtonHeight = 26
    ButtonWidth = 79
    Caption = 'ToolBar1'
    Color = clBtnFace
    EdgeBorders = [ebBottom]
    Flat = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ShowCaptions = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Caption = ' '#1055#1086#1076#1075#1086#1090#1086#1074#1082#1072' '
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 79
      Top = 0
      Caption = #1055#1091#1089#1082
      ImageIndex = 1
      OnClick = ToolButton2Click
    end
    object ToolButton4: TToolButton
      Left = 158
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 3
      Style = tbsSeparator
    end
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 40
    object dc: TGLDummyCube
      Direction.Coordinates = {0000000000000000FFFF7F3F00000000}
      CubeSize = 1.000000000000000000
      object roc: TGLFreeForm
        Material.FrontProperties.Diffuse.Color = {0000000000000000000000000000803F}
      end
      object sph_planet: TGLSphere
        Material.FrontProperties.Ambient.Color = {0000003F0000003F0000003F0000803F}
        Material.FrontProperties.Shininess = 128
        Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'mars.jpg'
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureFormat = tfRGB16
        Material.Texture.Disabled = False
        Up.Coordinates = {00000000FFFF7F3F0000000000000000}
        Radius = 6.000000000000000000
        Slices = 32
        Stacks = 32
      end
      object sph_targ: TGLSphere
        Material.FrontProperties.Diffuse.Color = {0000803F00000000000000000000803F}
        Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
        Radius = 0.200000002980232200
        Slices = 8
        Stacks = 8
      end
      object cube: TGLCube
        Direction.Coordinates = {000000006C61D83EC903683F00000000}
        PitchAngle = 25.000000000000000000
        Position.Coordinates = {000000009A9919400000A0400000803F}
        Up.Coordinates = {00000000C903683F6C61D8BE00000000}
        CubeSize = {0000803F0000803FCDCCCC3D}
      end
      object txt_s: TGLHUDText
        BitmapFont = GLWindowsBitmapFont1
        Text = '1'
        Alignment = taCenter
        Layout = tlCenter
        ModulateColor.Color = {00000000000000000000803F0000803F}
      end
      object txt_t: TGLHUDText
        BitmapFont = GLWindowsBitmapFont1
        Text = '2'
        Alignment = taCenter
        Layout = tlCenter
        ModulateColor.Color = {0000803F00000000000000000000803F}
      end
      object pt: TGLPoints
        NoZWrite = False
        Static = False
        size = 10.000000000000000000
        Style = psSmooth
        PointParameters.PointParams = {00002041000000430000803F}
      end
    end
    object dc_boom: TGLDummyCube
      Visible = False
      CubeSize = 1.000000000000000000
      object bm_ring: TGLPlane
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'ring.tga'
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
        Height = 1.000000000000000000
        Width = 1.000000000000000000
      end
      object bm_sph: TGLSphere
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Radius = 0.500000000000000000
        Slices = 32
        Stacks = 32
      end
    end
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 75.000000000000000000
        TargetObject = dc_cam
        Position.Coordinates = {000000C100000041000080410000803F}
        object light: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          SpotCutOff = 180.000000000000000000
        end
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    OnProgress = cadProgress
    Left = 8
    Top = 72
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    Interval = 500
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 40
    Top = 40
  end
  object GLWindowsBitmapFont1: TGLWindowsBitmapFont
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Ranges = <
      item
        StartASCII = '1'
        StopASCII = '2'
        StartGlyphIdx = 0
      end>
    Left = 40
    Top = 72
  end
end
