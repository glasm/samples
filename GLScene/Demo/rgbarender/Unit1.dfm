object Form1: TForm1
  Left = 196
  Top = 131
  Width = 870
  Height = 600
  Caption = 'RenderToRGBA'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 854
    Height = 542
    Camera = GLCamera1
    Buffer.BackgroundColor = clLime
    Buffer.AmbientColor.Color = {0000803F0000803F0000803F0000803F}
    Buffer.AntiAliasing = aa8x
    FieldOfView = 159.092758178710900000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object GLDummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLCamera1: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = GLDummyCube1
        Position.Coordinates = {000040400000C040000040410000803F}
        object GLLightSource1: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          SpotCutOff = 180.000000000000000000
        end
      end
    end
    object GLCube1: TGLCube
      CubeSize = {000080400000804000008040}
    end
    object GLCube2: TGLCube
      Material.FrontProperties.Diffuse.Color = {EBE0E03EE4DB5B3F9A93133F0000803F}
      Position.Coordinates = {0000A0C000000000000000000000803F}
      CubeSize = {000080400000804000008040}
    end
    object GLCube3: TGLCube
      Material.FrontProperties.Diffuse.Color = {0000803FF8FEFE3E000000000000803F}
      Position.Coordinates = {0000A04000000000000000000000803F}
      CubeSize = {000080400000804000008040}
    end
    object GLCube4: TGLCube
      Material.FrontProperties.Diffuse.Color = {EBE0E03EE4DB5B3FE4DB5B3F0000803F}
      Position.Coordinates = {000000000000A040000000000000803F}
      CubeSize = {000080400000804000008040}
    end
    object GLCube5: TGLCube
      Material.FrontProperties.Diffuse.Color = {938E0E3F938C0C3EDCD6D63E0000803F}
      Position.Coordinates = {000000000000A0C0000000000000803F}
      CubeSize = {000080400000804000008040}
    end
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 8
    object Save1: TMenuItem
      Caption = 'SaveTo...'
      object sBMP: TMenuItem
        Caption = 'Bitmap'
        OnClick = sBMPClick
      end
      object sTGA: TMenuItem
        Caption = 'Targa'
        OnClick = sBMPClick
      end
      object sPNG: TMenuItem
        Caption = 'PNG'
        OnClick = sBMPClick
      end
    end
  end
end
