object Form1: TForm1
  Left = 194
  Top = 283
  Width = 725
  Height = 521
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 709
    Height = 483
    Camera = GLCamera1
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow, roNoColorBufferClear]
    FieldOfView = 156.605575561523400000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
    end
    object sea: TGLHUDSprite
      Width = 500.000000000000000000
      Height = 500.000000000000000000
      XTiles = 5
      YTiles = 5
    end
    object ship: TGLHUDSprite
      Material.BlendingMode = bmTransparency
      Material.Texture.ImageClassName = 'TGLPicFileImage'
      Material.Texture.Image.PictureFileName = 'ship.tga'
      Material.Texture.TextureMode = tmReplace
      Material.Texture.Disabled = False
      Width = 32.000000000000000000
      Height = 64.000000000000000000
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object at: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = atTimer
    Left = 72
    Top = 8
  end
end
