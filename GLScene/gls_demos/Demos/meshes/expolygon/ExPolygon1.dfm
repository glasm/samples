object Form1: TForm1
  Left = 256
  Top = 188
  Width = 783
  Height = 540
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 767
    Height = 502
    Camera = Camera
    FieldOfView = 118.274116516113300000
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 720
    Top = 40
    object GLLightSource1: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000FAC30000FAC3000048440000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object GLLightSource2: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000FA430000FAC3000048440000803F}
      SpotCutOff = 180.000000000000000000
    end
    object Container: TGLDummyCube
      CubeSize = 100.000000000000000000
    end
    object CameraTarget: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object Camera: TGLCamera
      DepthOfView = 10000.000000000000000000
      FocalLength = 150.000000000000000000
      TargetObject = CameraTarget
      Position.Coordinates = {0000484300007AC4000048430000803F}
      Direction.Coordinates = {000000000000803F0000008000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
      Left = 376
      Top = 240
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'MatSurface'
        Material.FrontProperties.Diffuse.Color = {6666263F0000003F14AEC73E0000803F}
        Tag = 0
      end
      item
        Name = 'MatInner'
        Material.FrontProperties.Diffuse.Color = {C3F5683F5C8F423F6666263F0000803F}
        Tag = 0
      end>
    Left = 720
    Top = 72
  end
end
