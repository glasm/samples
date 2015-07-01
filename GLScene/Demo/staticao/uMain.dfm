object Form1: TForm1
  Left = 193
  Top = 132
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object vp: TGLSceneViewer
    Left = 0
    Top = 41
    Width = 900
    Height = 559
    Camera = cam
    Buffer.BackgroundColor = clWhite
    Buffer.AmbientColor.Color = {0000803F0000803F0000803F0000803F}
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow, roNoColorBufferClear]
    Buffer.AntiAliasing = aaNone
    FieldOfView = 144.302505493164100000
    Align = alClient
    OnMouseDown = vpMouseDown
    OnMouseMove = vpMouseMove
    OnMouseUp = vpMouseUp
    OnMouseWheel = vpMouseWheel
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 41
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 587
      Top = 12
      Width = 34
      Height = 18
      Caption = 'CPUs:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 576
      Top = 8
      Width = 2
      Height = 25
    end
    object Bevel2: TBevel
      Left = 392
      Top = 8
      Width = 2
      Height = 25
    end
    object Label2: TLabel
      Left = 403
      Top = 12
      Width = 32
      Height = 18
      Caption = 'Rays:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentFont = False
    end
    object ray_lbl: TLabel
      Left = 496
      Top = 21
      Width = 66
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 240
      Top = 8
      Width = 2
      Height = 25
    end
    object Label3: TLabel
      Left = 251
      Top = 12
      Width = 39
      Height = 18
      Caption = 'Scene:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentFont = False
    end
    object cpu_lbl: TLabel
      Left = 656
      Top = 21
      Width = 66
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentFont = False
    end
    object Bevel4: TBevel
      Left = 736
      Top = 8
      Width = 2
      Height = 25
    end
    object but_octree: TSpeedButton
      Left = 744
      Top = 8
      Width = 57
      Height = 25
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Octree'
      Flat = True
    end
    object but_sqrt: TSpeedButton
      Left = 807
      Top = 8
      Width = 41
      Height = 25
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'Sqrt'
      Flat = True
    end
    object SpeedButton3: TSpeedButton
      Left = 848
      Top = 8
      Width = 41
      Height = 25
      AllowAllUp = True
      GroupIndex = 2
      Down = True
      Caption = 'Ln'
      Flat = True
    end
    object pb: TProgressBar
      Left = 82
      Top = 7
      Width = 151
      Height = 28
      Smooth = True
      TabOrder = 0
    end
    object tb: TTrackBar
      Left = 440
      Top = 7
      Width = 129
      Height = 16
      Hint = 'Rays per vertex '
      Max = 100
      Min = 1
      ParentShowHint = False
      Position = 2
      ShowHint = True
      TabOrder = 1
      ThumbLength = 14
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = tbChange
    end
    object cb: TComboBox
      Left = 294
      Top = 8
      Width = 91
      Height = 26
      ItemHeight = 18
      ItemIndex = 0
      TabOrder = 2
      Text = 'mushroom'
      OnChange = cbChange
      Items.Strings = (
        'mushroom'
        'box'
        'box2'
        'scene'
        'tiger')
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 65
      Height = 25
      Caption = 'GEN'
      TabOrder = 3
      OnClick = Button1Click
    end
    object cpu_tb: TTrackBar
      Left = 624
      Top = 7
      Width = 105
      Height = 16
      Hint = 'count of used CPUs'
      Max = 100
      Min = 1
      ParentShowHint = False
      Position = 5
      ShowHint = True
      TabOrder = 4
      ThumbLength = 14
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = cpu_tbChange
    end
  end
  object GLScene1: TGLScene
    Left = 4
    Top = 48
    object hud: TGLHUDSprite
      Material.Texture.Image.Picture.Data = {
        07544269746D617036040000424D360400000000000036000000280000000100
        000000010000010018000000000000040000130B0000130B0000000000000000
        000083790000807000006C7000006C720000696100006F6B00006F8000006C8D
        00006A920000758A000080840000829100007D890000738B0000778300008B8C
        0000839100008399000083A200008DA8000094AC0000A0B70000A5C90000A4CB
        0000ABC10000B4CE0000B5CC0000ACDB0000A6E50000A0E800008FFB000094FF
        000092F600008AF200008FFE000095FA000091EF00009BEE0000AEE90000A8F4
        0000A3F00000A8DC0000AAD90000ACCE0000A5D900009ADB000093DD00008DD3
        000092CA00008DCE000087D8000089D5000091C700008FC5000094CB000095BA
        00008CC000008AB8000089C400007FD0000080CE00007ED1000080DD000073D6
        00006AC5000068BF000069C000005EBB00005CC2000066B6000070B8000083B5
        00008CB100007EB1000081A30500869303008B8B0300878A1A00888C1600827E
        140085732800907C240094952C0092993700899A3800959F3A009E9435009993
        39009F8B25009C8B25008E973300899C3E008A944D00879C440089A2440092A4
        26008EA71E009BA92100A99F1400B1A52400AEA41E00AFAD2500BAA72100C29E
        1500C29F0F00C8B00000C0B20200C1AF0000CCA00000D9A40000CDAB0000CEA4
        0B00D2980300D4A20E00DCA11800D7A31900CAA11F00C79B2900BA913400B295
        2800A4902F00A09F32009EAE2E009EAD320098AE2E009FB12900ADAB1D00A8AF
        2200A9B53100A7B82C009FAE4300A4A44A00A9A74000ABB84000A1BC3700A6B0
        2B00B0B12100B4B12E00B6B92100B6AB1100BD950A00C0920000D6900000D88E
        0100D19C1200E0A42100E5AB2200DEB12E00E4BB2400E3B31C00D5BD0900CDB5
        0700D4B60400CEC20500D5BD1000D6BA0700D3C50500D8C80000E7C90000FBC1
        0000FFCD0000FFCC0000FFC60000FFAC0000FFA80D00FFB11A00FFB91500FFC1
        2000FFBB2F00FFC02C00FFCD2900FFC52F00FFD02200FFCE1F00FFC92D00FFCB
        2900FFDA2C00FFDB2D00FFD62800FFDA1D00FFD11100FFDB1500FFDE1000FFD9
        1700FFE92200FFE82500FFDE1B00FFDA1800FFE12300FFED1F00FFE12E00FFD9
        3A00FFCC3700FFD13E00FFC63F00FFBC3800FFB43500FFB13400FFBD3C00FFBE
        4100FFB64500FFB54500FF9B4000FF9B3B00FF9E3600FF9B3C00FF8C3300FF94
        3500FF994500FF9E3800FFA43700FF9C2300FF9E1500FFA80A00FF950500FF93
        1200FF910E00FF911C00FF862300FF873200FF953700FFA83B00FFB34800FFB0
        2C00FFAD3000FFA82600FFA81300FFB11900FFAC2100FFAF3000FFAC3100FFAD
        3F00FFBF3800FFB93000FFA94000FFA94700FFAE5B00FFA06200FF986E00FF8A
        7400FF806C00FF7C7800FF6F6E00FF636700FF6E7300FF657800FF597D00FF4E
        7C00FF4C8300FF467B00FF477D00FF418B00FF468600FF449D00FF4A9D00FF4A
        A300}
      Material.Texture.Disabled = False
      Position.Coordinates = {0000E14300009643000000000000803F}
      Width = 900.000000000000000000
      Height = 600.000000000000000000
    end
    object dc: TGLDummyCube
      CubeSize = 1.000000000000000000
      object model: TGLFreeForm
        Material.FrontProperties.Ambient.Color = {9A99193E9A99193E9A99193E0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
      end
      object light: TGLLightSource
        Ambient.Color = {0000003F0000003F0000003F0000803F}
        ConstAttenuation = 1.000000000000000000
        Position.Coordinates = {0000204200004842000070420000803F}
        LightStyle = lsOmni
        SpotCutOff = 180.000000000000000000
      end
    end
    object cam: TGLCamera
      DepthOfView = 400.000000000000000000
      FocalLength = 90.000000000000000000
      TargetObject = dc
      Position.Coordinates = {0000F0410000A041000020420000803F}
    end
  end
  object cad: TGLCadencer
    Scene = GLScene1
    Enabled = False
    OnProgress = cadProgress
    Left = 36
    Top = 48
  end
  object at: TAsyncTimer
    Enabled = True
    Interval = 800
    OnTimer = atTimer
    ThreadPriority = tpNormal
    Left = 68
    Top = 48
  end
  object th_at: TAsyncTimer
    Interval = 16
    OnTimer = th_atTimer
    ThreadPriority = tpNormal
    Left = 100
    Top = 48
  end
end
