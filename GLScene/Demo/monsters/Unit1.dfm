object Form1: TForm1
  Left = 192
  Top = 115
  Width = 783
  Height = 542
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 767
    Height = 504
    Cursor = -1
    Camera = cam
    Buffer.BackgroundColor = clBackground
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 146.851989746093800000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 4
    Top = 4
    object light: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000C8420000C8420000C8420000803F}
      LightStyle = lsParallel
      SpotCutOff = 180.000000000000000000
      SpotDirection.Coordinates = {000000000000803F000080BF00000000}
    end
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 1000.000000000000000000
        FocalLength = 75.000000000000000000
        Position.Coordinates = {0000000000008041000000000000803F}
      end
    end
    object DOGL: TGLDirectOpenGL
      UseBuildList = False
      OnRender = DOGLRender
      Blend = False
      object obj: TGLFreeForm
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {0000003F0000003F0000003F0000803F}
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'default.bmp'
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
        Up.Coordinates = {000000000000803F0000008000000000}
        Visible = False
      end
    end
    object terra: TGLTerrainRenderer
      Material.TextureEx = <
        item
          Texture.ImageClassName = 'TGLPicFileImage'
          Texture.Image.PictureFileName = 'grass.jpg'
          Texture.FilteringQuality = tfAnisotropic
          Texture.Disabled = False
          TextureIndex = 0
          TextureScale.Coordinates = {00000042000000420000803F00000000}
        end
        item
          Texture.ImageClassName = 'TGLPicFileImage'
          Texture.Image.PictureFileName = 'light.bmp'
          Texture.TextureMode = tmModulate
          Texture.Disabled = False
          TextureIndex = 1
        end>
      Direction.Coordinates = {000000000000803F0000000000000000}
      Scale.Coordinates = {0000204100002041CDCC4C3E00000000}
      Up.Coordinates = {0000000000000000000080BF00000000}
      HeightDataSource = hds
      TilesPerTexture = 16.000000000000000000
      QualityDistance = 1000.000000000000000000
      CLODPrecision = 1000
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = cadProgress
    Left = 32
    Top = 4
  end
  object at: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = atTimer
    Left = 60
    Top = 4
  end
  object hds: TGLBitmapHDS
    MaxPoolSize = 0
    Left = 88
    Top = 4
  end
end
