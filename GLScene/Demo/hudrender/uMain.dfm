object Form1: TForm1
  Left = 668
  Top = 405
  Width = 808
  Height = 627
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object vp: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 792
    Height = 589
    Camera = cam1
    Buffer.BackgroundColor = clBackground
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 151.424514770507800000
    Align = alClient
    TabOrder = 0
  end
  object scene1: TGLScene
    Left = 8
    Top = 8
    object tor: TGLTorus
      Material.PolygonMode = pmLines
      Scale.Coordinates = {0000803F0000803F0000A04100000000}
      MajorRadius = 25.000000000000000000
      MinorRadius = 2.000000000000000000
      Rings = 40
      Sides = 60
      StopAngle = 360.000000000000000000
      Parts = [toSides, toStartDisk, toStopDisk]
    end
    object cam1: TGLCamera
      DepthOfView = 1000.000000000000000000
      FocalLength = 75.000000000000000000
      TargetObject = tor
      Position.Coordinates = {00000000000000000000C8410000803F}
      object light: TGLLightSource
        Ambient.Color = {0000803F0000803F0000803F0000803F}
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {000000000000A041000000000000803F}
        Specular.Color = {0000803F0000803F0000803F0000803F}
        SpotCutOff = 180.000000000000000000
      end
    end
    object fbo: TGLFBORenderer
      Width = 128
      Height = 128
      ColorTextureName = 'monster'
      MaterialLibrary = MatLib
      BackgroundColor.Color = {00000000000000000000000000000000}
      ClearOptions = [coColorBufferClear, coDepthBufferClear]
      Camera = cam2
      RootObject = dc_fbo
      EnabledRenderBuffers = [erbDepth]
      PostGenerateMipmap = False
    end
    object HUDSprt: TGLHUDSprite
      Material.MaterialLibrary = MatLib
      Material.LibMaterialName = 'monster'
      Position.Coordinates = {0000484300004843000000000000803F}
      Width = 128.000000000000000000
      Height = 128.000000000000000000
    end
  end
  object cad: TGLCadencer
    Scene = scene1
    OnProgress = cadProgress
    Left = 40
    Top = 8
  end
  object at: TAsyncTimer
    Enabled = True
    Interval = 500
    OnTimer = atTimer
    ThreadPriority = tpNormal
    Left = 72
    Top = 8
  end
  object MatLib: TGLMaterialLibrary
    Materials = <
      item
        Name = 'monster'
        Tag = 0
        Material.BlendingMode = bmTransparency
        Material.Texture.ImageClassName = 'TGLBlankImage'
        Material.Texture.Image.ColorFormat = 6408
        Material.Texture.TextureMode = tmReplace
        Material.Texture.TextureWrap = twNone
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
      end>
    Left = 40
    Top = 40
  end
  object scene2: TGLScene
    Left = 8
    Top = 40
    object dc_fbo: TGLDummyCube
      CubeSize = 1.000000000000000000
      object light2: TGLLightSource
        Ambient.Color = {0000403F0000403F0000403F0000803F}
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {00000000000000000000C8C20000803F}
        SpotCutOff = 180.000000000000000000
      end
      object ff_monster: TGLFreeForm
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.ImageClassName = 'TGLPicFileImage'
        Material.Texture.Image.PictureFileName = 'monster.bmp'
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
      end
      object dc_camtarg: TGLDummyCube
        Position.Coordinates = {000000003333733F000000000000803F}
        CubeSize = 1.000000000000000000
      end
      object cam2: TGLCamera
        DepthOfView = 400.000000000000000000
        FocalLength = 75.000000000000000000
        TargetObject = dc_camtarg
        Position.Coordinates = {0000000000000000000020C10000803F}
      end
    end
  end
end
