object Form1: TForm1
  Left = 192
  Top = 106
  Width = 870
  Height = 600
  Caption = 'Wires'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 854
    Height = 562
    Camera = cam
    FieldOfView = 159.821228027343800000
    Align = alClient
    OnMouseDown = vpMouseDown
    OnMouseMove = vpMouseMove
    OnMouseUp = vpMouseUp
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLCube1: TGLCube
        Position.Coordinates = {0000804000000000000000000000803F}
        CubeSize = {000000409A99993E00000041}
      end
      object GLCube2: TGLCube
        Position.Coordinates = {000080C000000000000000000000803F}
        CubeSize = {000000409A99993E00000041}
      end
      object c11: TGLCube
        Position.Coordinates = {00004040000000000000803F0000803F}
        CubeSize = {0000003F0000003F0000003F}
      end
      object c12: TGLCube
        Position.Coordinates = {0000404000000000000000000000803F}
        CubeSize = {0000003F0000003F0000003F}
      end
      object c13: TGLCube
        Position.Coordinates = {0000404000000000000080BF0000803F}
        CubeSize = {0000003F0000003F0000003F}
      end
      object c21: TGLCube
        Position.Coordinates = {000040C0000000000000803F0000803F}
        CubeSize = {0000003F0000003F0000003F}
      end
      object c22: TGLCube
        Position.Coordinates = {000040C000000000000000000000803F}
        CubeSize = {0000003F0000003F0000003F}
      end
      object c23: TGLCube
        Position.Coordinates = {000040C000000000000080BF0000803F}
        CubeSize = {0000003F0000003F0000003F}
      end
    end
    object wire: TGLLines
      LineColor.Color = {9A93133FEBE0E03EE4DB5B3F0000803F}
      LineWidth = 2.000000000000000000
      Nodes = <
        item
        end
        item
        end>
      NodesAspect = lnaInvisible
      Options = []
    end
    object cam: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = dc
      Position.Coordinates = {000080400000A0400000C0400000803F}
      object light: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    FixedDeltaTime = 0.020000000000000000
    Mode = cmApplicationIdle
    SleepLength = 1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
end
