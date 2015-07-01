object main_form: Tmain_form
  Left = 262
  Top = 254
  Width = 916
  Height = 699
  Caption = 'Terrain Nodes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = file_menu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object main_viewer: TGLSceneViewer
    Left = 161
    Top = 0
    Width = 739
    Height = 622
    Camera = glcam
    Buffer.BackgroundColor = 16744448
    Buffer.ShadeModel = smSmooth
    FieldOfView = 161.733230590820300000
    Align = alClient
    OnMouseDown = main_viewerMouseDown
    OnMouseMove = main_viewerMouseMove
    OnMouseUp = main_viewerMouseUp
    TabOrder = 0
  end
  object control_panel: TPanel
    Left = 0
    Top = 0
    Width = 161
    Height = 622
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 184
      Width = 80
      Height = 13
      Caption = 'Available Nodes:'
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 38
      Height = 13
      Caption = 'Preview'
    end
    object pre_viewer: TGLSceneViewer
      Left = 8
      Top = 24
      Width = 145
      Height = 145
      Camera = pre_cam
      Buffer.BackgroundColor = clBlack
      Buffer.ShadeModel = smSmooth
      FieldOfView = 110.815422058105500000
      TabOrder = 0
    end
    object node_filelist: TFileListBox
      Left = 8
      Top = 200
      Width = 145
      Height = 249
      ItemHeight = 13
      TabOrder = 1
      OnChange = node_filelistChange
      OnKeyPress = node_filelistKeyPress
    end
    object controls_memo: TMemo
      Left = 8
      Top = 456
      Width = 145
      Height = 177
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'Nodeplace Controls:'
        ''
        'Move Planar:'
        'A / S / D / W'
        ''
        'Move Height:'
        'Q / E'
        ''
        'Rotate:'
        'R'
        ''
        'Place Node:'
        'Space')
      ReadOnly = True
      TabOrder = 2
    end
  end
  object status_bar: TStatusBar
    Left = 0
    Top = 622
    Width = 900
    Height = 19
    Panels = <>
  end
  object node_plot: TMemo
    Left = 160
    Top = 0
    Width = 529
    Height = 137
    TabOrder = 3
    Visible = False
  end
  object main_scene: TGLScene
    Left = 184
    Top = 8
    object main_light: TGLLightSource
      Ambient.Color = {D7A3703ED7A3703ED7A3703E0000803F}
      ConstAttenuation = 0.600000023841857900
      Position.Coordinates = {0000484300004843000048430000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object cam_cube: TGLDummyCube
      CubeSize = 1.000000000000000000
      VisibleAtRunTime = True
    end
    object nodes: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object preview_mesh: TGLFreeForm
      Direction.Coordinates = {000000000000803F2EBD3BB300000000}
      PitchAngle = 90.000000000000000000
      Scale.Coordinates = {CDCCCC3DCDCCCC3DCDCCCC3D00000000}
      Up.Coordinates = {000000002EBD3BB3000080BF00000000}
      MaterialLibrary = node_materials
    end
    object glgrid: TGLXYZGrid
      Direction.Coordinates = {000000000000803F2EBD3BB300000000}
      PitchAngle = 90.000000000000000000
      Position.Coordinates = {00000000CDCC4CBD000000000000803F}
      Up.Coordinates = {000000002EBD3BB3000080BF00000000}
      LineColor.Color = {0000803FC1CA413FA69B043F0000803F}
      XSamplingScale.Min = -100.000000000000000000
      XSamplingScale.max = 100.000000000000000000
      XSamplingScale.step = 2.000000000000000000
      YSamplingScale.Min = -100.000000000000000000
      YSamplingScale.max = 100.000000000000000000
      YSamplingScale.step = 2.000000000000000000
      ZSamplingScale.step = 0.100000001490116100
    end
    object glcam: TGLCamera
      DepthOfView = 500.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = cam_cube
      Position.Coordinates = {000000000000A0410000A0C10000803F}
    end
  end
  object pre_scene: TGLScene
    Left = 16
    Top = 32
    object pre_mesh: TGLFreeForm
      Direction.Coordinates = {000000000000803F2EBD3BB300000000}
      PitchAngle = 90.000000000000000000
      Scale.Coordinates = {CDCCCC3DCDCCCC3DCDCCCC3D00000000}
      Up.Coordinates = {000000002EBD3BB3000080BF00000000}
      AutoCentering = [macCenterZ]
      MaterialLibrary = pre_materials
    end
    object pre_light: TGLLightSource
      ConstAttenuation = 0.800000011920929000
      Position.Coordinates = {0000F0410000F0410000A0410000803F}
      SpotCutOff = 180.000000000000000000
    end
    object pre_cam: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = pre_mesh
      Position.Coordinates = {0000404100004041000040410000803F}
    end
  end
  object file_menu: TMainMenu
    Left = 184
    Top = 40
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        ShortCut = 16465
        OnClick = Close1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Undo1: TMenuItem
        Caption = 'Undo'
        ShortCut = 16474
        OnClick = Undo1Click
      end
    end
  end
  object gltimer: TAsyncTimer
    Enabled = True
    Interval = 50
    OnTimer = gltimerTimer
    ThreadPriority = tpNormal
    Left = 248
    Top = 8
  end
  object pre_materials: TGLMaterialLibrary
    Left = 48
    Top = 32
  end
  object node_materials: TGLMaterialLibrary
    Left = 216
    Top = 8
  end
  object open_dialog: TOpenDialog
    Filter = 'Node Compilation (*.ncf)|*.ncf'
    Title = 'Load Nodes'
    OnCanClose = open_dialogCanClose
    Left = 216
    Top = 40
  end
  object save_dialog: TSaveDialog
    Filter = 'Node Compilation (*.ncf)|*.ncf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Nodes'
    OnCanClose = save_dialogCanClose
    Left = 248
    Top = 40
  end
end
