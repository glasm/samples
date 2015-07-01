object Form1: TForm1
  Left = 196
  Top = 131
  Width = 850
  Height = 597
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 834
    Height = 559
    Camera = cam
    Buffer.BackgroundColor = clSilver
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 149.958618164062500000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      EdgeColor.Color = {1283803E1283003F1283003F0000803F}
      object cam: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 75.000000000000000000
        TargetObject = dc_cam
        Position.Coordinates = {0000C04000000041000020410000803F}
      end
    end
    object dogl: TGLDirectOpenGL
      UseBuildList = False
      OnRender = doglRender
      Blend = False
      object ff: TGLFreeForm
        Material.BlendingMode = bmAlphaTest50
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'tree.tga'
        Material.Texture.Disabled = False
        Visible = False
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
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
