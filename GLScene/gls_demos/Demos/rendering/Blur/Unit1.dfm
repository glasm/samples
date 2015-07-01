object Form1: TForm1
  Left = 290
  Top = 175
  Caption = 'Form1'
  ClientHeight = 462
  ClientWidth = 518
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
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 45
    Width = 518
    Height = 417
    Camera = GLCamera1
    Buffer.FogEnvironment.FogColor.Color = {1283003F1283003F0000803F0000803F}
    Buffer.FogEnvironment.FogStart = 1.000000000000000000
    Buffer.FogEnvironment.FogEnd = 3.000000000000000000
    Buffer.BackgroundColor = clBlack
    Buffer.AmbientColor.Color = {0000000000000000000000000000803F}
    FieldOfView = 153.029327392578100000
    Align = alClient
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 45
    Align = alTop
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 4
      Width = 54
      Height = 13
      Caption = 'Blur Preset:'
    end
    object Label2: TLabel
      Left = 216
      Top = 4
      Width = 61
      Height = 13
      Caption = 'Render Size:'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 20
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'pNone (no change)'
      OnClick = ComboBox1Click
      Items.Strings = (
        'pNone (no change)'
        'pGlossy'
        'pBeastView'
        'pOceanDepth'
        'pDream'
        'pOverBlur'
        'pAdvancedBlur')
    end
    object ComboBox2: TComboBox
      Left = 216
      Top = 20
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 5
      TabOrder = 1
      Text = '256'
      OnChange = ComboBox2Change
      Items.Strings = (
        '8'
        '16'
        '32'
        '64'
        '128'
        '256'
        '512')
    end
  end
  object GLScene1: TGLScene
    ObjectsSorting = osRenderFarthestFirst
    Left = 188
    Top = 48
    object GLLightSource1: TGLLightSource
      Ambient.Color = {BEC0403FBEC0403FBEC0403F0000803F}
      ConstAttenuation = 1.000000000000000000
      Diffuse.Color = {BEC0403FBEC0403FBEC0403F0000803F}
      Position.Coordinates = {56551B40F9FF2D40F6FF3B400000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object GLCube1: TGLCube
      Material.MaterialLibrary = GLMaterialLibrary1
      Material.LibMaterialName = 'LibMaterial'
      Direction.Coordinates = {82B16B3E068E77BF3986DFBD00000000}
      PitchAngle = -95.500000000000000000
      Position.Coordinates = {DB9FEC3E806395BE509F213F0000803F}
      TurnAngle = 6.500000000000000000
      Up.Coordinates = {DD7324BEE3EB17BE6BCE793F00000000}
    end
    object GLSphere1: TGLSphere
      Material.MaterialLibrary = GLMaterialLibrary1
      Material.LibMaterialName = 'LibMaterial'
      Position.Coordinates = {6E3D38BF0A5515BE733C1CBF0000803F}
      Radius = 0.500000000000000000
    end
    object GLDummyCube1: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      NearPlaneBias = 0.100000001490116100
      TargetObject = GLDummyCube1
      Position.Coordinates = {41A38A3F6847033F2894FA3F0000803F}
      Direction.Coordinates = {A5C4F6BE96EA77BE3E9257BF00000000}
      Up.Coordinates = {B74DF6BD4B62783F582A57BE00000000}
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'LibMaterial'
        Material.Texture.ImageClassName = 'TGLCompositeImage'
        Material.Texture.Image.Width = 256
        Material.Texture.Image.Height = 256
        Material.Texture.Image.Depth = 0
        Material.Texture.TextureMode = tmModulate
        Material.Texture.Disabled = False
        Tag = 0
      end>
    Left = 228
    Top = 48
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    SleepLength = 0
    OnProgress = GLCadencer1Progress
    Left = 268
    Top = 48
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 308
    Top = 48
  end
end
