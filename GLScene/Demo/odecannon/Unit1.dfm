object Form1: TForm1
  Left = 301
  Top = 185
  Width = 801
  Height = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GLSViewer: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 793
    Height = 581
    Camera = GLCam
    Buffer.ContextOptions = [roDoubleBuffer, roStencilBuffer, roRenderToWindow]
    FieldOfView = 168.207901000976600000
    Align = alClient
    OnMouseDown = GLSViewerMouseDown
    OnMouseMove = GLSViewerMouseMove
    OnMouseUp = GLSViewerMouseUp
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 33
    TabOrder = 1
    object Bevel1: TBevel
      Left = 72
      Top = 4
      Width = 249
      Height = 25
    end
    object Bevel2: TBevel
      Left = 4
      Top = 4
      Width = 65
      Height = 25
    end
    object Label1: TLabel
      Left = 450
      Top = 8
      Width = 43
      Height = 13
      Caption = 'Height: 2'
    end
    object Bevel3: TBevel
      Left = 328
      Top = 4
      Width = 281
      Height = 25
    end
    object Bevel4: TBevel
      Left = 616
      Top = 4
      Width = 65
      Height = 25
    end
    object TrackBarWall: TTrackBar
      Left = 504
      Top = 8
      Width = 97
      Height = 17
      Max = 6
      Min = 1
      PageSize = 1
      Position = 3
      TabOrder = 0
      TabStop = False
      ThumbLength = 10
      OnChange = TrackBarWallChange
    end
    object CheckBoxDelete: TCheckBox
      Left = 624
      Top = 8
      Width = 49
      Height = 17
      TabStop = False
      Caption = 'Delete'
      TabOrder = 1
      OnClick = CheckBoxDeleteClick
    end
    object CheckBoxWall: TCheckBox
      Left = 336
      Top = 8
      Width = 41
      Height = 17
      TabStop = False
      Caption = 'Wall'
      TabOrder = 2
      OnClick = CheckBoxWallClick
    end
    object CheckBrick: TCheckBox
      Left = 80
      Top = 8
      Width = 49
      Height = 17
      TabStop = False
      Caption = 'Bricks'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = CheckBrickClick
    end
    object CheckPlusMinus: TCheckBox
      Left = 8
      Top = 8
      Width = 57
      Height = 17
      Caption = 'Switch'
      TabOrder = 4
      OnClick = CheckPlusMinusClick
    end
    object CheckBoxTraverse: TCheckBox
      Left = 264
      Top = 8
      Width = 49
      Height = 17
      Caption = 'Desk'
      TabOrder = 5
      OnClick = CheckBoxTraverseClick
    end
    object CheckBoxDoor: TCheckBox
      Left = 144
      Top = 8
      Width = 49
      Height = 17
      Caption = 'Door'
      TabOrder = 6
      OnClick = CheckBoxDoorClick
    end
    object CheckBoxWindow: TCheckBox
      Left = 200
      Top = 8
      Width = 57
      Height = 17
      Caption = 'Window'
      TabOrder = 7
      OnClick = CheckBoxWindowClick
    end
    object CheckBoxPanel: TCheckBox
      Left = 392
      Top = 8
      Width = 49
      Height = 17
      Caption = 'Panel'
      TabOrder = 8
      OnClick = CheckBoxPanelClick
    end
  end
  object PanelFire: TPanel
    Tag = 32
    Left = 0
    Top = 32
    Width = 73
    Height = 217
    TabOrder = 2
    Visible = False
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 58
      Height = 13
      Caption = 'Gun powder'
    end
    object TrackBarPowder: TTrackBar
      Left = 10
      Top = 24
      Width = 55
      Height = 136
      Enabled = False
      Max = 100
      Orientation = trVertical
      PageSize = 5
      Frequency = 5
      Position = 50
      TabOrder = 0
      TabStop = False
      ThumbLength = 40
      TickMarks = tmBoth
      TickStyle = tsNone
    end
    object ButtonFire: TButton
      Left = 8
      Top = 160
      Width = 57
      Height = 49
      Caption = 'Fire'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonFireClick
    end
  end
  object GLScene1: TGLScene
    Left = 4
    Top = 284
    object GLDCcam: TGLDummyCube
      Position.Coordinates = {000000000000803F000000000000803F}
      CubeSize = 1.000000000000000000
      object GLCam: TGLCamera
        DepthOfView = 512.000000000000000000
        FocalLength = 30.000000000000000000
        TargetObject = GLDCcam
        Position.Coordinates = {000000000000A0400000A0400000803F}
      end
    end
    object GLDCODEplane: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object GLDCconst: TGLDummyCube
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object GLDCconst2: TGLDummyCube
        OnProgress = GLDCconst2Progress
        CubeSize = 1.000000000000000000
        VisibleAtRunTime = True
      end
    end
    object GLLine: TGLLines
      Visible = False
      LineWidth = 3.000000000000000000
      Nodes = <
        item
        end
        item
          X = 1.000000000000000000
          Z = 1.000000000000000000
        end>
      NodesAspect = lnaCube
      Options = []
    end
    object GLShadowPlane: TGLShadowPlane
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {0000000000000000000080BF00000000}
      Height = 128.000000000000000000
      Width = 128.000000000000000000
      XTiles = 128
      YTiles = 128
      NoZWrite = False
      ShadowingObject = GLDCBaseShadow
      ShadowedLight = GLLight
    end
    object GLXYZGrid1: TGLXYZGrid
      Position.Coordinates = {000000000AD7233C000000000000803F}
      LineColor.Color = {B1A8A83EB1A8A83EB1A8A83E0000803F}
      XSamplingScale.Min = -64.000000000000000000
      XSamplingScale.Max = 64.000000000000000000
      XSamplingScale.Origin = 0.500000000000000000
      XSamplingScale.Step = 1.000000000000000000
      YSamplingScale.Step = 1.000000000000000000
      ZSamplingScale.Min = -64.000000000000000000
      ZSamplingScale.Max = 64.000000000000000000
      ZSamplingScale.Origin = 0.500000000000000000
      ZSamplingScale.Step = 1.000000000000000000
      Parts = [gpX, gpZ]
    end
    object GLDClight: TGLDummyCube
      OnProgress = GLDClightProgress
      CubeSize = 1.000000000000000000
      object GLLight: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {0000A041000048420000A0410000803F}
        LightStyle = lsOmni
        SpotCutOff = 180.000000000000000000
      end
    end
    object GLArrowLine1: TGLArrowLine
      Material.FrontProperties.Diffuse.Color = {CDCC0C3FEC51B83DEC51B83D0000803F}
      Up.Coordinates = {0000803F000000000000008000000000}
      Visible = False
      BottomRadius = 0.100000001490116100
      Height = 1.000000000000000000
      TopRadius = 0.100000001490116100
      TopArrowHeadHeight = 0.500000000000000000
      TopArrowHeadRadius = 0.200000002980232200
      BottomArrowHeadHeight = 0.500000000000000000
      BottomArrowHeadRadius = 0.200000002980232200
      object GLArrowLine2: TGLArrowLine
        Direction.Coordinates = {00000000000080BF0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        BottomRadius = 0.100000001490116100
        Height = 1.000000000000000000
        TopRadius = 0.100000001490116100
        TopArrowHeadHeight = 0.500000000000000000
        TopArrowHeadRadius = 0.200000002980232200
        BottomArrowHeadHeight = 0.500000000000000000
        BottomArrowHeadRadius = 0.200000002980232200
      end
    end
    object GLDCblasts: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object GLDCcamMIG21targ2: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object GLDCBaseShadow: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLDCcannon: TGLDummyCube
        Up.Coordinates = {000000000000803F0000008000000000}
        Visible = False
        CubeSize = 1.000000000000000000
        object GLCylinderAxis: TGLCylinder
          Direction.Coordinates = {000000000000803F0000000000000000}
          Position.Coordinates = {000000000000003F000000000000803F}
          Up.Coordinates = {0000803F000000000000008000000000}
          BottomRadius = 0.100000001490116100
          Height = 1.100000023841858000
          TopRadius = 0.100000001490116100
          object GLAnnulusWheelR: TGLAnnulus
            Position.Coordinates = {000000000000003F000000000000803F}
            BottomRadius = 0.500000000000000000
            Height = 0.100000001490116100
            Stacks = 1
            BottomInnerRadius = 0.449999988079071000
            TopInnerRadius = 0.449999988079071000
            TopRadius = 0.500000000000000000
            object GLCubeCannonR1: TGLCube
              CubeSize = {6666663FCDCC4C3DCDCC4C3D}
            end
            object GLCubeCannonR2: TGLCube
              CubeSize = {CDCC4C3DCDCC4C3D6666663F}
            end
            object GLCubeCannonR3: TGLCube
              Direction.Coordinates = {7D49323F0000000004B6373F00000000}
              Up.Coordinates = {000000000000803F0000008000000000}
              CubeSize = {6666663FCDCC4C3DCDCC4C3D}
            end
            object GLCubeCannonR4: TGLCube
              Direction.Coordinates = {6ECE12BF000000002FB9513F00000000}
              CubeSize = {6666663FCDCC4C3DCDCC4C3D}
            end
          end
          object GLAnnulusWheelL: TGLAnnulus
            Position.Coordinates = {00000000000000BF000000000000803F}
            BottomRadius = 0.500000000000000000
            Height = 0.100000001490116100
            Stacks = 1
            BottomInnerRadius = 0.449999988079071000
            TopInnerRadius = 0.449999988079071000
            TopRadius = 0.500000000000000000
            object GLCubeCannonL1: TGLCube
              CubeSize = {6666663FCDCC4C3DCDCC4C3D}
            end
            object GLCubeCannonL2: TGLCube
              CubeSize = {CDCC4C3DCDCC4C3D6666663F}
            end
            object GLCubeCannonL3: TGLCube
              Direction.Coordinates = {7D49323F0000000004B6373F00000000}
              Up.Coordinates = {000000000000803F0000008000000000}
              CubeSize = {6666663FCDCC4C3DCDCC4C3D}
            end
            object GLCubeCannonL4: TGLCube
              Direction.Coordinates = {6ECE12BF000000002FB9513F00000000}
              CubeSize = {6666663FCDCC4C3DCDCC4C3D}
            end
          end
          object GLCylinderBarrel1: TGLCylinder
            Position.Coordinates = {CDCC4CBE00000000CDCC4C3E0000803F}
            Up.Coordinates = {0000803F000000000000008000000000}
            BottomRadius = 0.200000002980232200
            Height = 1.000000000000000000
            TopRadius = 0.300000011920929000
            object GLCamCannon: TGLCamera
              DepthOfView = 100.000000000000000000
              FocalLength = 50.000000000000000000
              TargetObject = GLDCcamCannon
              Position.Coordinates = {0000000000004040000040400000803F}
            end
            object GLCylinderBarrel2: TGLCylinder
              Position.Coordinates = {00000000000000BF000000000000803F}
              BottomRadius = 0.250000000000000000
              Height = 0.200000002980232200
              TopRadius = 0.250000000000000000
            end
            object GLCylinderBarrel3: TGLCylinder
              Position.Coordinates = {000000006666263F000000000000803F}
              BottomRadius = 0.300000011920929000
              Height = 0.300000011920929000
              TopRadius = 0.100000001490116100
            end
            object GLDCcamCannon: TGLDummyCube
              Position.Coordinates = {00000000000000C00000803F0000803F}
              CubeSize = 1.000000000000000000
            end
          end
        end
      end
      object ODEObjects: TGLDummyCube
        CubeSize = 1.000000000000000000
      end
      object GLDCMIG21: TGLDummyCube
        Direction.Coordinates = {FFFF7F3F000000000000000000000000}
        Position.Coordinates = {000000000000A041000000000000803F}
        Visible = False
        CubeSize = 1.000000000000000000
        object GLDCcamMIG21targ: TGLDummyCube
          Position.Coordinates = {0000000000000000000080BF0000803F}
          CubeSize = 1.000000000000000000
        end
        object GLDCcamMIG21orig: TGLDummyCube
          Position.Coordinates = {00000000000020410000803F0000803F}
          CubeSize = 1.000000000000000000
        end
        object GLCylinderMIG21: TGLCylinder
          Direction.Coordinates = {00000000FFFF7F3F0000000000000000}
          Up.Coordinates = {0000000000000000FFFF7FBF00000000}
          BottomRadius = 0.500000000000000000
          Height = 2.000000000000000000
          TopRadius = 0.500000000000000000
          Parts = [cySides]
          object GLCylinderMIG22: TGLCylinder
            Position.Coordinates = {000000000000A03F000000000000803F}
            BottomRadius = 0.500000000000000000
            Height = 0.500000000000000000
            TopRadius = 0.400000005960464500
            Parts = [cySides, cyTop]
            object GLConeMIG23: TGLCone
              BottomRadius = 0.300000011920929000
              Height = 1.500000000000000000
              Parts = [coSides]
            end
          end
          object GLCylinderMIG24: TGLCylinder
            Position.Coordinates = {00000000000000C0000000000000803F}
            BottomRadius = 0.200000002980232200
            Height = 2.000000000000000000
            TopRadius = 0.500000000000000000
            Parts = [cySides, cyBottom]
          end
          object GLCubeMIG26: TGLCube
            Direction.Coordinates = {26FD063F908459BF0000000000000000}
            Position.Coordinates = {9A99B9BFCDCC4CBF000000000000803F}
            Up.Coordinates = {0000000000000000FFFF7F3F00000000}
            CubeSize = {00004040CDCCCC3DCDCC8C3F}
          end
          object GLCubeMIG27: TGLCube
            Direction.Coordinates = {26FD063F9084593F0000000000000000}
            Position.Coordinates = {9A99B93FCDCC4CBF000000000000803F}
            Up.Coordinates = {00000080000000000000803F00000000}
            CubeSize = {00004040CDCCCC3DCDCC8C3F}
          end
          object GLCubeMIG28: TGLCube
            Direction.Coordinates = {26FD063F908459BF0000000000000000}
            Position.Coordinates = {000000BF9A9939C0000000000000803F}
            Up.Coordinates = {0000000000000000FFFF7F3F00000000}
            CubeSize = {0000803FCDCCCC3D0000003F}
          end
          object GLCubeMIG29: TGLCube
            Direction.Coordinates = {26FD063F9084593F0000000000000000}
            Position.Coordinates = {0000003F9A9939C0000000000000803F}
            Up.Coordinates = {00000080000000000000803F00000000}
            CubeSize = {0000803FCDCCCC3D0000003F}
          end
          object GLCubeMIG30: TGLCube
            Direction.Coordinates = {00000000DA149CBE96D0733F00000000}
            Position.Coordinates = {00000000CDCC2CC03333B33E0000803F}
            Up.Coordinates = {0000000095D0733FD9149C3E00000000}
            CubeSize = {CDCCCC3D9A99193F0000803F}
          end
          object GLSphereMIG25: TGLSphere
            Material.FrontProperties.Diffuse.Color = {EBE0E03E9A93133FE4DB5B3F0000003F}
            Material.BlendingMode = bmTransparency
            Position.Coordinates = {00000000000000006666E63E0000803F}
            Scale.Coordinates = {0000803F000000400000803F00000000}
            Radius = 0.300000011920929000
          end
        end
      end
    end
    object GLCamMIG21track: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 90.000000000000000000
    end
    object GLCamMIG21: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 90.000000000000000000
      TargetObject = GLDCcamMIG21targ
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    SleepLength = 1
    OnProgress = GLCadencer1Progress
    Left = 68
    Top = 284
  end
  object GLODEManager1: TGLODEManager
    Solver = osmQuickStep
    Iterations = 1
    MaxContacts = 8
    Visible = False
    VisibleAtRunTime = False
    Left = 36
    Top = 284
  end
  object MainMenu1: TMainMenu
    Left = 100
    Top = 284
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load...'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save...'
        OnClick = Save1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 16472
        OnClick = Exit1Click
      end
    end
    object Build1: TMenuItem
      Caption = 'Edit'
      object Simulation1: TMenuItem
        AutoCheck = True
        Caption = 'Simulation'
        Checked = True
        ShortCut = 16467
      end
      object Showgrid1: TMenuItem
        Caption = 'Show grid'
        Checked = True
        ShortCut = 16455
        OnClick = Showgrid1Click
      end
      object Clearall1: TMenuItem
        Caption = 'Clear all'
        ShortCut = 46
        OnClick = Clearall1Click
      end
    end
    object Attack1: TMenuItem
      Caption = 'Attack'
      object Cannon1: TMenuItem
        Caption = 'Cannon'
        ShortCut = 16451
        OnClick = Cannon1Click
      end
      object MIG211: TMenuItem
        Caption = 'MIG 21'
        ShortCut = 16461
        OnClick = MIG211Click
      end
      object Backtoediting1: TMenuItem
        Caption = 'Back to editing'
        Enabled = False
        OnClick = Backtoediting1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Contents1: TMenuItem
        Caption = 'Contents'
        OnClick = Contents1Click
      end
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object AsyncTimer1: TAsyncTimer
    Enabled = True
    OnTimer = AsyncTimer1Timer
    Left = 100
    Top = 252
  end
  object OpenDialog1: TOpenDialog
    Filter = 'ODEditor files|*.odf'
    InitialDir = '.'
    Left = 36
    Top = 252
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'ODEditor Files|*.odf'
    InitialDir = '.'
    Left = 68
    Top = 252
  end
  object GLFire: TGLFireFXManager
    FireDir.Coordinates = {00000000000000000000000000000000}
    InitialDir.Coordinates = {00000000000000000000000000000000}
    Cadencer = GLCadencer1
    FireDensity = 1.000000000000000000
    FireEvaporation = 0.860000014305114700
    FireRadius = 1.000000000000000000
    Disabled = True
    Paused = False
    ParticleInterval = 0.100000001490116100
    UseInterval = True
    Left = 4
    Top = 252
  end
end
