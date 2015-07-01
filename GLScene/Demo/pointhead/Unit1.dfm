object Form1: TForm1
  Left = 452
  Top = 128
  Width = 656
  Height = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Camera = cam_1
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 156.463424682617200000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 4
    Top = 4
    object light_1: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000A0400000A0400000A0400000803F}
      SpotCutOff = 180.000000000000000000
    end
    object dc_world: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLPoints1: TGLPoints
        NoZWrite = False
        Static = True
        size = 2.000000000000000000
      end
    end
    object dc_meshes: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object cam_1: TGLCamera
      DepthOfView = 1000.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = dc_world
      Position.Coordinates = {00000040000000400000C0400000803F}
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Mode = cmApplicationIdle
    OnProgress = cadProgress
    Left = 4
    Top = 32
  end
  object at: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = atTimer
    Left = 32
    Top = 4
  end
end
