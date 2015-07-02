object Form1: TForm1
  Left = 236
  Top = 127
  Width = 776
  Height = 609
  Caption = 'mapOnSph'
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
    Width = 760
    Height = 571
    Camera = cam
    Buffer.AmbientColor.Color = {0000003F0000003F0000003F0000803F}
    FieldOfView = 145.006500244140600000
    Align = alClient
    OnMouseDown = vpMouseDown
    OnMouseMove = vpMouseMove
    OnMouseUp = vpMouseUp
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object cam: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 90.000000000000000000
      TargetObject = dc_world
      Position.Coordinates = {0000A0410000F041000020420000803F}
      object light: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
    object dc_world: TGLDummyCube
      CubeSize = 1.000000000000000000
      object sph: TGLSphere
        Material.FrontProperties.Ambient.Color = {0000003F0000003F0000003F0000803F}
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'map.jpg'
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        ShowAxes = True
        Radius = 15.000000000000000000
        Slices = 64
        Stacks = 32
      end
      object seg: TGLMesh
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'seg.jpg'
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        Mode = mmQuads
        VertexMode = vmVNT
      end
    end
  end
end
