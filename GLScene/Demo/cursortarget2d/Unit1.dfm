object Form1: TForm1
  Left = 192
  Top = 120
  Width = 616
  Height = 438
  Caption = 'CursorTarget'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 600
    Height = 400
    Cursor = -1
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    FieldOfView = 151.927505493164100000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object target: TGLHUDSprite
      Material.FrontProperties.Diffuse.Color = {000000000000803F000000000000803F}
      Material.MaterialOptions = [moNoLighting]
      Material.Texture.ImageClassName = 'TGLPicFileImage'
      Material.Texture.Image.PictureFileName = 'cursor.bmp'
      Material.Texture.MinFilter = miLinear
      Material.Texture.TextureMode = tmModulate
      Material.Texture.Disabled = False
      Position.Coordinates = {000096430000C842000000000000803F}
      Width = 32.000000000000000000
      Height = 32.000000000000000000
    end
    object player: TGLHUDSprite
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Material.BlendingMode = bmTransparency
      Material.MaterialOptions = [moNoLighting]
      Material.Texture.ImageClassName = 'TGLPicFileImage'
      Material.Texture.Image.PictureFileName = 'arrow.bmp'
      Material.Texture.ImageAlpha = tiaAlphaFromIntensity
      Material.Texture.MinFilter = miLinear
      Material.Texture.TextureMode = tmModulate
      Material.Texture.Disabled = False
      Position.Coordinates = {0000964300004843000000000000803F}
      Width = 32.000000000000000000
      Height = 32.000000000000000000
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Mode = cmApplicationIdle
    SleepLength = 1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
end
