object Form1: TForm1
  Left = 196
  Top = 146
  Width = 758
  Height = 421
  Caption = 'Grass'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 742
    Height = 383
    Camera = cam
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 120.093391418457000000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object back: TGLSphere
      Material.FrontProperties.Diffuse.Color = {8716D93E39B4C83ECDCC8C3E0000803F}
      Scale.Coordinates = {0000A0400000803F0000803F00000000}
      NormalDirection = ndInside
      Radius = 50.000000000000000000
    end
    object dc_pl: TGLDummyCube
      Position.Coordinates = {0000A0C00000C03F000000000000803F}
      CubeSize = 1.000000000000000000
      object GLPlane1: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane5: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Position.Coordinates = {0000000000000000000080BF0000803F}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane4: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Position.Coordinates = {0000000000000000000000BF0000803F}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane3: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Position.Coordinates = {00000000000000000000803F0000803F}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane2: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Position.Coordinates = {00000000000000000000003F0000803F}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane6: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Direction.Coordinates = {0000803F000000002EBD3BB300000000}
        TurnAngle = 90.000000000000000000
        Up.Coordinates = {00000000FFFF7F3F0000000000000000}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane7: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Direction.Coordinates = {0000803F000000002EBD3BB300000000}
        Position.Coordinates = {0000803F00000000000000000000803F}
        TurnAngle = 90.000000000000000000
        Up.Coordinates = {00000000FFFF7F3F0000000000000000}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane8: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Direction.Coordinates = {0000803F000000002EBD3BB300000000}
        Position.Coordinates = {0000003F00000000000000000000803F}
        TurnAngle = 90.000000000000000000
        Up.Coordinates = {00000000FFFF7F3F0000000000000000}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane9: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Direction.Coordinates = {0000803F000000002EBD3BB300000000}
        Position.Coordinates = {000000BF00000000000000000000803F}
        TurnAngle = 90.000000000000000000
        Up.Coordinates = {00000000FFFF7F3F0000000000000000}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
      object GLPlane10: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        ObjectsSorting = osNone
        Direction.Coordinates = {0000803F000000002EBD3BB300000000}
        Position.Coordinates = {000080BF00000000000000000000803F}
        TurnAngle = 90.000000000000000000
        Up.Coordinates = {00000000FFFF7F3F0000000000000000}
        Height = 2.000000000000000000
        Width = 8.000000000000000000
      end
    end
    object dc_ff: TGLDummyCube
      Position.Coordinates = {0000404000000000000000000000803F}
      CubeSize = 1.000000000000000000
      object GLPlane11: TGLPlane
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'dirt'
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Height = 6.000000000000000000
        Width = 12.000000000000000000
        XTiles = 2
      end
      object ff: TGLFreeForm
        Material.MaterialLibrary = matlib
        Material.LibMaterialName = 'grass'
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
      end
    end
    object dc_cam: TGLDummyCube
      Position.Coordinates = {000000000000803F000000000000803F}
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 120.000000000000000000
        FocalLength = 110.354576110839800000
        SceneScale = 2.000000000000000000
        TargetObject = dc_cam
        Position.Coordinates = {00000000000040410000A0410000803F}
        object light: TGLLightSource
          ConstAttenuation = 1.000000000000000000
          SpotCutOff = 180.000000000000000000
        end
      end
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    SleepLength = 1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object matlib: TGLMaterialLibrary
    Materials = <
      item
        Name = 'grass'
        Tag = 0
        Material.BackProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.BackProperties.Emission.Color = {6666E63E6666E63E6666E63E0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {6666E63E6666E63E6666E63E0000803F}
        Material.BlendingMode = bmAlphaTest50
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        Material.FaceCulling = fcNoCull
      end
      item
        Name = 'dirt'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.TextureMode = tmModulate
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
      end>
    Left = 72
    Top = 8
  end
end
