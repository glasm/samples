object OptionsDlg: TOptionsDlg
  Left = 227
  Top = 132
  BorderStyle = bsNone
  Caption = 'OptionsDlg'
  ClientHeight = 210
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 454
    Height = 210
    Align = alClient
    Brush.Style = bsClear
  end
  object ToolBar1: TToolBar
    Left = 368
    Top = 32
    Width = 81
    Height = 81
    Align = alNone
    ButtonHeight = 24
    ButtonWidth = 75
    Caption = 'ToolBar1'
    Color = clBtnFace
    EdgeBorders = []
    Flat = True
    ParentColor = False
    ShowCaptions = True
    TabOrder = 0
    object TBApply: TToolButton
      Left = 0
      Top = 0
      Caption = '    Apply    '
      ImageIndex = 0
      Wrap = True
      OnClick = TBApplyClick
    end
    object TBSpacer: TToolButton
      Left = 0
      Top = 24
      Enabled = False
      ImageIndex = 1
      Wrap = True
    end
    object TBCancel: TToolButton
      Left = 0
      Top = 48
      Caption = 'Cancel'
      ImageIndex = 2
      OnClick = TBCancelClick
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 353
    Height = 193
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clBtnHighlight
    TabOrder = 1
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 353
      Height = 193
      ActivePage = TSGameplay
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object TSGameplay: TTabSheet
        Caption = 'Gameplay'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 3
        ParentFont = False
        object Label11: TLabel
          Left = 8
          Top = 19
          Width = 49
          Height = 16
          Caption = 'Difficulty'
        end
        object Label12: TLabel
          Left = 8
          Top = 51
          Width = 37
          Height = 16
          Caption = 'Speed'
        end
        object CBDifficulty: TComboBox
          Left = 72
          Top = 16
          Width = 105
          Height = 24
          ItemHeight = 16
          TabOrder = 0
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Please don'#39't hurt me!'
            'Beginner'
            'Normal'
            'Advanced'
            'Ace of Aces')
        end
        object CBSpeed: TComboBox
          Left = 72
          Top = 48
          Width = 105
          Height = 24
          ItemHeight = 16
          ItemIndex = 2
          TabOrder = 1
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Sleepy'
            'Slow'
            'Normal'
            'Fast'
            'Frantic'
            '')
        end
      end
      object TSVideo: TTabSheet
        Caption = 'Video'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        object Label1: TLabel
          Left = 8
          Top = 19
          Width = 32
          Height = 16
          Caption = 'Mode'
        end
        object Label2: TLabel
          Left = 8
          Top = 51
          Width = 69
          Height = 16
          Caption = 'AntiAliasing'
        end
        object Label3: TLabel
          Left = 8
          Top = 96
          Width = 41
          Height = 16
          Caption = 'Quality'
        end
        object Label4: TLabel
          Left = 72
          Top = 96
          Width = 39
          Height = 16
          Caption = 'Terrain'
        end
        object Label5: TLabel
          Left = 72
          Top = 128
          Width = 51
          Height = 16
          Caption = 'Particles'
        end
        object CBVideoMode: TComboBox
          Left = 56
          Top = 16
          Width = 153
          Height = 24
          ItemHeight = 16
          TabOrder = 0
          Text = '800x600 32bit'
          OnChange = CBVideoModeChange
          Items.Strings = (
            '640x480 32bit'
            '800x600 32bit'
            '1024x768 32bit'
            '1280x960 32bit'
            '1600x1200 32bit')
        end
        object CBFSAA: TComboBox
          Left = 104
          Top = 48
          Width = 105
          Height = 24
          ItemHeight = 16
          ItemIndex = 0
          TabOrder = 1
          Text = 'Default'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Default'
            'FSAA 2x'
            'FSAA 4x')
        end
        object CBTerrain: TComboBox
          Left = 136
          Top = 93
          Width = 73
          Height = 24
          ItemHeight = 16
          TabOrder = 2
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Low'
            'Normal'
            'High')
        end
        object CBParticles: TComboBox
          Left = 136
          Top = 125
          Width = 73
          Height = 24
          ItemHeight = 16
          ItemIndex = 1
          TabOrder = 3
          Text = 'Normal'
          OnChange = CBDifficultyChange
          Items.Strings = (
            'Low'
            'Normal'
            'High')
        end
        object CBVSync: TCheckBox
          Left = 224
          Top = 19
          Width = 73
          Height = 17
          Caption = 'VSync'
          TabOrder = 4
          OnClick = CBVideoModeChange
        end
      end
      object TSAudio: TTabSheet
        Caption = 'Audio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 2
        ParentFont = False
        object Label6: TLabel
          Left = 8
          Top = 16
          Width = 88
          Height = 16
          Caption = 'Master Volume'
        end
        object Label9: TLabel
          Left = 8
          Top = 56
          Width = 47
          Height = 16
          Caption = 'Engines'
        end
        object Label7: TLabel
          Left = 8
          Top = 96
          Width = 35
          Height = 16
          Caption = 'Music'
        end
        object Label13: TLabel
          Left = 8
          Top = 136
          Width = 33
          Height = 16
          Caption = 'Voice'
        end
        object TBMasterVolume: TTrackBar
          Left = 112
          Top = 8
          Width = 225
          Height = 33
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 0
          ThumbLength = 15
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object TBEngineVolume: TTrackBar
          Left = 112
          Top = 48
          Width = 225
          Height = 33
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 1
          ThumbLength = 15
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object TBVoiceVolume: TTrackBar
          Left = 112
          Top = 128
          Width = 225
          Height = 33
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 2
          ThumbLength = 15
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object TBMusicVolume: TTrackBar
          Left = 112
          Top = 88
          Width = 225
          Height = 33
          Max = 100
          Frequency = 10
          Position = 80
          TabOrder = 3
          ThumbLength = 15
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
      end
      object TSControls: TTabSheet
        Caption = 'Controls'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        object Label8: TLabel
          Left = 104
          Top = 64
          Width = 62
          Height = 16
          Caption = 'Dead Zone'
        end
        object Label10: TLabel
          Left = 8
          Top = 16
          Width = 55
          Height = 16
          Caption = 'Keyboard'
        end
        object CBJoystick: TCheckBox
          Left = 8
          Top = 64
          Width = 81
          Height = 17
          Caption = 'Joystick'
          TabOrder = 0
          OnClick = CBDifficultyChange
        end
        object TBJoystickDeadzone: TTrackBar
          Left = 168
          Top = 56
          Width = 169
          Height = 33
          Max = 100
          Frequency = 10
          TabOrder = 1
          ThumbLength = 15
          TickMarks = tmBoth
          OnChange = CBDifficultyChange
        end
        object BUConfigureKeyboard: TButton
          Left = 256
          Top = 12
          Width = 75
          Height = 25
          Caption = 'Customize'
          TabOrder = 2
          OnClick = BUConfigureKeyboardClick
        end
        object CBKeyboardLayout: TComboBox
          Left = 104
          Top = 13
          Width = 145
          Height = 24
          ItemHeight = 0
          TabOrder = 3
          Text = 'CBKeyboardLayout'
          OnChange = CBDifficultyChange
        end
      end
    end
  end
end
