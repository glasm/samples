object Form1: TForm1
  Left = 193
  Top = 130
  Width = 763
  Height = 561
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  DesignSize = (
    747
    523)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton7: TSpeedButton
    Left = 610
    Top = 344
    Width = 32
    Height = 32
    Anchors = [akTop, akRight]
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton7Click
  end
  object SpeedButton8: TSpeedButton
    Left = 610
    Top = 376
    Width = 32
    Height = 32
    Anchors = [akTop, akRight]
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton8Click
  end
  object Label8: TLabel
    Left = 682
    Top = 353
    Width = 7
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object XLabel: TLabel
    Left = 698
    Top = 353
    Width = 6
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 682
    Top = 369
    Width = 7
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object YLabel: TLabel
    Left = 698
    Top = 369
    Width = 6
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 682
    Top = 385
    Width = 7
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ZLabel: TLabel
    Left = 698
    Top = 385
    Width = 6
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 634
    Top = 12
    Width = 28
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Width'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 604
    Top = 36
    Width = 58
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Front Height'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 603
    Top = 60
    Width = 59
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Back Height'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 633
    Top = 84
    Width = 29
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Depth'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 615
    Top = 240
    Width = 47
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'X Rotaion'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label15: TLabel
    Left = 638
    Top = 152
    Width = 24
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Parts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 722
    Top = 8
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '+'
    Layout = blGlyphBottom
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 722
    Top = 19
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Layout = blGlyphBottom
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Tag = 1
    Left = 722
    Top = 33
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '+'
    Layout = blGlyphBottom
    OnClick = SpeedButton1Click
  end
  object SpeedButton4: TSpeedButton
    Tag = 1
    Left = 722
    Top = 43
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Layout = blGlyphBottom
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object SpeedButton5: TSpeedButton
    Tag = 2
    Left = 722
    Top = 56
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '+'
    Layout = blGlyphBottom
    OnClick = SpeedButton1Click
  end
  object SpeedButton6: TSpeedButton
    Tag = 2
    Left = 722
    Top = 67
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Layout = blGlyphBottom
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object SpeedButton9: TSpeedButton
    Tag = 3
    Left = 722
    Top = 80
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '+'
    Layout = blGlyphBottom
    OnClick = SpeedButton1Click
  end
  object SpeedButton10: TSpeedButton
    Tag = 3
    Left = 722
    Top = 91
    Width = 17
    Height = 10
    Anchors = [akTop, akRight]
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Layout = blGlyphBottom
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 11
    Width = 9
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 579
    Height = 506
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnMouseDown = FormMouseDown
    object GLSceneViewer4: TGLSceneViewer
      Left = 1
      Top = 1
      Width = 577
      Height = 504
      Camera = GLCamera1
      Buffer.BackgroundColor = clBlack
      FieldOfView = 157.555084228515600000
      Align = alClient
      OnClick = GLSceneViewer4Click
      OnMouseDown = GLSceneViewer4MouseDown
      OnMouseUp = GLSceneViewer4MouseUp
      TabOrder = 0
    end
  end
  object r0RB: TRadioButton
    Left = 674
    Top = 216
    Width = 41
    Height = 17
    Anchors = [akTop, akRight]
    Caption = '0'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TabStop = True
    OnClick = rRBClick
  end
  object r90RB: TRadioButton
    Left = 674
    Top = 232
    Width = 41
    Height = 17
    Anchors = [akTop, akRight]
    Caption = '90'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = rRBClick
  end
  object r180RB: TRadioButton
    Left = 674
    Top = 248
    Width = 41
    Height = 17
    Anchors = [akTop, akRight]
    Caption = '180'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = rRBClick
  end
  object r270RB: TRadioButton
    Left = 674
    Top = 264
    Width = 41
    Height = 17
    Anchors = [akTop, akRight]
    Caption = '270'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = rRBClick
  end
  object TopCB: TCheckBox
    Left = 674
    Top = 144
    Width = 65
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Top'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 6
    OnClick = PartsCBClick
  end
  object BottomCB: TCheckBox
    Left = 674
    Top = 160
    Width = 65
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Bottom'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 7
    OnClick = PartsCBClick
  end
  object LeftCB: TCheckBox
    Left = 674
    Top = 176
    Width = 65
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Left'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 8
    OnClick = PartsCBClick
  end
  object RightCB: TCheckBox
    Left = 674
    Top = 192
    Width = 65
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Right'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 9
    OnClick = PartsCBClick
  end
  object FrontCB: TCheckBox
    Left = 674
    Top = 112
    Width = 65
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Front'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 10
    OnClick = PartsCBClick
  end
  object BackCB: TCheckBox
    Left = 674
    Top = 128
    Width = 65
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Back'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 11
    OnClick = PartsCBClick
  end
  object Button1: TButton
    Left = 642
    Top = 288
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add 125 cubes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = Button1Click
  end
  object WidthEdit: TEdit
    Left = 674
    Top = 8
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    Text = '1.00'
  end
  object FrontHeightedit: TEdit
    Left = 674
    Top = 32
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    Text = '1.00'
  end
  object BackHeightEdit: TEdit
    Left = 674
    Top = 56
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    Text = '1.00'
  end
  object DepthEdit: TEdit
    Left = 674
    Top = 80
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 16
    Text = '1.00'
  end
  object Memo1: TMemo
    Left = 594
    Top = 416
    Width = 146
    Height = 97
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Movement=Arrows.PgUp,PgDown'
      ''
      'Look=Left button n mouse'
      ''
      'Add=Space '
      ''
      'Remove=Del')
    ParentFont = False
    TabOrder = 17
    WordWrap = False
  end
  object GLScene1: TGLScene
    Left = 72
    Top = 64
    object GLDummyCube2: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLCamera1: TGLCamera
        DepthOfView = 50.000000000000000000
        FocalLength = 50.000000000000000000
        TargetObject = GLDummyCube1
        Position.Coordinates = {00000000000000000000C0C00000803F}
      end
    end
    object GLFreeForm1: TGLFreeForm
      Material.FrontProperties.Diffuse.Color = {0000803FF8FEFE3E000000000000803F}
      Material.Texture.Disabled = False
      Direction.Coordinates = {00000000000000800000803F00000000}
      Scale.Coordinates = {CDCCCC3DCDCCCC3DCDCCCC3D00000000}
      ShowAxes = True
      MaterialLibrary = GLMaterialLibrary1
      LightmapLibrary = GLMaterialLibrary1
    end
    object GLXYZGrid2: TGLXYZGrid
      Position.Coordinates = {00000000B81E05BF000000000000803F}
      LineColor.Color = {CFBC3C3EA19E9E3EA19E9E3E0000803F}
      LineWidth = 0.100000001490116100
      XSamplingScale.Min = -100.000000000000000000
      XSamplingScale.max = 99.000000000000000000
      XSamplingScale.step = 3.000000000000000000
      YSamplingScale.Min = -10.000000000000000000
      YSamplingScale.max = 10.000000000000000000
      YSamplingScale.step = 1.000000000000000000
      ZSamplingScale.Min = -100.000000000000000000
      ZSamplingScale.max = 99.000000000000000000
      ZSamplingScale.step = 3.000000000000000000
      Parts = [gpX, gpZ]
    end
    object GLDummyCube1: TGLDummyCube
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object GLCube1: TGLCube
        Material.FrontProperties.Ambient.Color = {00000000000000000000803F0000803F}
        Material.FrontProperties.Diffuse.Color = {00000000000000000000803F0000803F}
        Material.FrontProperties.Emission.Color = {00000000000000000000803F0000803F}
        Material.FrontProperties.Specular.Color = {00000000000000000000803F0000803F}
        Material.BlendingMode = bmAdditive
        CubeSize = {6666863F6666863F6666863F}
      end
      object GLXYZGrid1: TGLXYZGrid
        Direction.Coordinates = {00000000000000800000803F00000000}
        Position.Coordinates = {0000003F0000003F0000003F0000803F}
        AntiAliased = True
        LineColor.Color = {0000803F000000000000803F0000803F}
        XSamplingScale.Min = -2.019999980926514000
        XSamplingScale.max = 1.009999990463257000
        XSamplingScale.step = 1.009999990463257000
        YSamplingScale.Min = -1.019999980926514000
        YSamplingScale.step = 1.009999990463257000
        ZSamplingScale.Min = -1.019999980926514000
        ZSamplingScale.step = 1.009999990463257000
        Parts = [gpX, gpY, gpZ]
        LinesStyle = glsLine
      end
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    SleepLength = 1
    OnProgress = GLCadencer1Progress
    Left = 72
    Top = 96
  end
  object GLUserInterface1: TGLUserInterface
    MouseSpeed = 20.000000000000000000
    GLNavigator = GLNavigator2
    GLVertNavigator = GLNavigator1
    Left = 496
    Top = 120
  end
  object GLNavigator1: TGLNavigator
    VirtualUp.Coordinates = {000000000000803F000000000000803F}
    MovingObject = GLDummyCube2
    UseVirtualUp = True
    AutoUpdateObject = True
    MaxAngle = 35.000000000000000000
    MinAngle = -80.000000000000000000
    AngleLock = True
    Left = 496
    Top = 152
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 72
    Top = 133
  end
  object GLNavigator2: TGLNavigator
    VirtualUp.Coordinates = {000000000000803F000000000000803F}
    MovingObject = GLDummyCube2
    UseVirtualUp = True
    AutoUpdateObject = True
    Left = 496
    Top = 184
  end
end
