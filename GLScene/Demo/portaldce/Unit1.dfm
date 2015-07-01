object Form1: TForm1
  Left = 202
  Top = 135
  Width = 922
  Height = 460
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    906
    422)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 75
    Height = 18
    Caption = 'Maze Map'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 304
    Top = 8
    Width = 61
    Height = 18
    Caption = '3D View'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 312
    Width = 241
    Height = 42
    Caption = 
      'To modify map, edit cells with keyboard :'#13#10'- any non-empty cell ' +
      'is a wall'#13#10'- click '#39'process'#39' to commit changes or check '#39'auto'#39
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object GLSceneViewer1: TGLSceneViewer
    Left = 296
    Top = 32
    Width = 609
    Height = 409
    Camera = GLCamera1
    Buffer.FogEnvironment.FogColor.Color = {00000000000000008180003F0000803F}
    Buffer.FogEnvironment.FogStart = 1.000000000000000000
    Buffer.FogEnvironment.FogEnd = 10.000000000000000000
    Buffer.BackgroundColor = clNavy
    Buffer.AmbientColor.Color = {0000803F0000803F0000803F0000803F}
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow]
    FieldOfView = 152.521591186523400000
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object BUForward: TButton
    Left = 96
    Top = 360
    Width = 89
    Height = 25
    Caption = 'Forward (Z/W)'
    TabOrder = 1
    OnClick = BUForwardClick
  end
  object BUTurnLeft: TButton
    Left = 8
    Top = 376
    Width = 81
    Height = 25
    Caption = 'Turn Left (Q/A)'
    TabOrder = 2
    OnClick = BUTurnLeftClick
  end
  object BUTurnRight: TButton
    Left = 192
    Top = 376
    Width = 89
    Height = 25
    Caption = 'TurnRight (E/D)'
    TabOrder = 3
    OnClick = BUTurnRightClick
  end
  object BUBackward: TButton
    Left = 96
    Top = 392
    Width = 89
    Height = 25
    Caption = 'Backward (S)'
    TabOrder = 4
    OnClick = BUBackwardClick
  end
  object SGMap: TStringGrid
    Left = 8
    Top = 32
    Width = 272
    Height = 272
    BorderStyle = bsNone
    ColCount = 16
    DefaultColWidth = 16
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 16
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    ScrollBars = ssNone
    TabOrder = 5
    OnSetEditText = SGMapSetEditText
  end
  object BBProcess: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 17
    Caption = 'Process'
    TabOrder = 6
    OnClick = BBProcessClick
  end
  object CBAuto: TCheckBox
    Left = 152
    Top = 8
    Width = 41
    Height = 17
    Caption = 'Auto'
    TabOrder = 7
  end
  object CBFog: TCheckBox
    Left = 848
    Top = 8
    Width = 49
    Height = 17
    Caption = 'Fog'
    TabOrder = 8
    OnClick = CBFogClick
  end
  object GLScene1: TGLScene
    Left = 488
    object GLLightSource1: TGLLightSource
      Ambient.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {000048420000C8420000C8420000803F}
      SpotCutOff = 180.000000000000000000
    end
    object DummyCube1: TGLDummyCube
      Position.Coordinates = {00000000000000000000C0400000803F}
      CubeSize = 1.000000000000000000
      BehavioursData = {
        0458434F4C02010201060D54474C44434544796E616D69630201020006000200
        060D474C4443454D616E616765723102000909090F000000400F000000000205
        02000200099A99993E9A99993E9A99993E00000000}
      object GLCamera1: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 50.000000000000000000
        NearPlaneBias = 0.200000002980232200
        Position.Coordinates = {000000000000003F000000000000803F}
        Up.Coordinates = {000000800000803F0000000000000000}
        Left = 264
        Top = 144
      end
    end
    object Portal1: TGLPortal
      Position.Coordinates = {00000000000000BF000000000000803F}
      MaterialLibrary = GLMaterialLibrary1
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 528
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 568
  end
  object cad: TGLCadencer
    Scene = GLScene1
    OnProgress = cadProgress
    Left = 448
  end
  object GLDCEManager1: TGLDCEManager
    WorldScale = 1.000000000000000000
    MovimentScale = 1.000000000000000000
    StandardiseLayers = ccsCollisionStandard
    ManualStep = True
    Left = 448
    Top = 64
  end
end
