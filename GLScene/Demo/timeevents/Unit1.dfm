object Form1: TForm1
  Left = 196
  Top = 119
  Width = 808
  Height = 627
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
    Width = 792
    Height = 589
    Camera = cam
    Buffer.FogEnvironment.FogColor.Color = {D5D4543FD1D0503FC9C8483F0AD7A33C}
    Buffer.FogEnvironment.FogStart = 10.000000000000000000
    Buffer.FogEnvironment.FogEnd = 1000.000000000000000000
    Buffer.FogEnvironment.FogMode = fmExp2
    Buffer.BackgroundColor = clBlack
    Buffer.AmbientColor.Color = {0000803F0000803F0000803F0000803F}
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    Buffer.FogEnable = True
    FieldOfView = 151.424514770507800000
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 8
    Top = 8
    object dc_player: TGLDummyCube
      CubeSize = 1.000000000000000000
      object actor: TGLActor
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        AnimationMode = aamLoop
        Interval = 100
      end
      object light: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {000000000000A0400000A0C00000803F}
        SpotCutOff = 180.000000000000000000
      end
      object light2: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {000000000000A0400000A0C00000803F}
        SpotCutOff = 180.000000000000000000
      end
    end
    object dc_cam: TGLDummyCube
      CubeSize = 1.000000000000000000
      object cam: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 75.000000000000000000
        TargetObject = actor
      end
    end
    object floor: TGLShadowPlane
      Material.MaterialLibrary = matlib
      Direction.Coordinates = {000000000000803F0000000000000000}
      Position.Coordinates = {000000000000C0BF0000C03F0000803F}
      Up.Coordinates = {0000000000000000000080BF00000000}
      Height = 5.000000000000000000
      Width = 5.000000000000000000
      ShadowingObject = actor
      ShadowedLight = light
      ShadowColor.Color = {0000000000000000000000009A99193F}
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
    Left = 8
    Top = 40
  end
  object matlib: TGLMaterialLibrary
    Left = 72
    Top = 8
  end
  object TEMGR: TGLTimeEventsMGR
    Cadencer = cad
    Events = <
      item
        Name = 'e1'
        Period = 20.000000000000000000
        EventType = etPeriodic
        OnEvent = TEMGREvents0Event
      end
      item
        Name = 'e2'
        StartTime = 5.000000000000000000
        Period = 20.000000000000000000
        EventType = etPeriodic
        OnEvent = TEMGREvents0Event
      end
      item
        Name = 'e3'
        StartTime = 10.000000000000000000
        EndTime = 20.000000000000000000
        EventType = etContinuous
        OnEvent = TEMGREvents0Event
      end
      item
        Name = 'restart'
        StartTime = 20.000000000000000000
        Period = 20.000000000000000000
        EventType = etPeriodic
        OnEvent = TEMGREvents0Event
      end>
    Left = 40
    Top = 40
  end
end
