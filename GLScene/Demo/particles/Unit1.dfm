object Form1: TForm1
  Left = 252
  Top = 283
  Width = 616
  Height = 438
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 600
    Height = 400
    Camera = GLCamera1
    Buffer.BackgroundColor = 8404992
    FieldOfView = 151.927505493164100000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 480
    Top = 80
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      Position.Coordinates = {00000000000080BF0000A0400000803F}
    end
    object player: TGLHUDSprite
      Position.Coordinates = {0000964300004843000000000000803F}
      Width = 50.000000000000000000
      Height = 50.000000000000000000
    end
    object GLCube1: TGLCube
      Material.MaterialOptions = [moNoLighting]
      CubeSize = {0000A0400000803F0000803F}
    end
    object dogl: TGLDirectOpenGL
      UseBuildList = False
      OnRender = doglRender
      Blend = True
      object p1: TGLHUDSprite
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'stone.tga'
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
        Position.Coordinates = {0000484200004842000000000000803F}
        Width = 32.000000000000000000
        Height = 32.000000000000000000
      end
      object p2: TGLHUDSprite
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'fire.tga'
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
        Position.Coordinates = {0000C84200004842000000000000803F}
        Width = 32.000000000000000000
        Height = 32.000000000000000000
      end
      object p3: TGLHUDSprite
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'air.tga'
        Material.Texture.TextureMode = tmModulate
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
        Position.Coordinates = {0000164300004842000000000000803F}
        Width = 32.000000000000000000
        Height = 32.000000000000000000
      end
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    Mode = cmApplicationIdle
    SleepLength = 1
    OnProgress = GLCadencer1Progress
    Left = 512
    Top = 80
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    Interval = 500
    OnTimer = AsyncTimer1Timer
    Left = 512
    Top = 112
  end
end
