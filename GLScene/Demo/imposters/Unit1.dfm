object Form1: TForm1
  Left = 196
  Top = 109
  Width = 718
  Height = 529
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
    Width = 702
    Height = 491
    Camera = cam
    Buffer.BackgroundColor = 15000804
    Buffer.AmbientColor.Color = {0000000000000000000000000000803F}
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 127.901382446289100000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc_world: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      EdgeColor.Color = {00000000000000000000803F0000803F}
      object cam: TGLCamera
        DepthOfView = 1000.000000000000000000
        FocalLength = 120.000000000000000000
        TargetObject = dc_cam
        Position.Coordinates = {000080400000C040000040400000803F}
        Up.Coordinates = {000000800000803F0000000000000000}
      end
    end
    object dogl: TGLDirectOpenGL
      UseBuildList = False
      OnRender = doglRender
      Blend = False
      object ff: TGLFreeForm
        Material.BlendingMode = bmAlphaTest50
        Material.MaterialOptions = [moNoLighting]
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'halo.dds'
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        Material.FaceCulling = fcNoCull
        Visible = False
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    OnTimer = AsyncTimer1Timer
    ThreadPriority = tpNormal
    Left = 72
    Top = 8
  end
end
