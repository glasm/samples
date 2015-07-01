object ConfigControls: TConfigControls
  Left = 144
  Top = 101
  BorderStyle = bsNone
  Caption = 'ConfigControls'
  ClientHeight = 407
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBtnText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 16
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 508
    Height = 407
    Align = alClient
    Brush.Style = bsClear
  end
  object LATitle: TLabel
    Left = 8
    Top = 8
    Width = 142
    Height = 16
    Caption = 'Controls Configuration'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 41
    Height = 14
    Caption = 'Function'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 192
    Top = 40
    Width = 73
    Height = 14
    Alignment = taCenter
    Caption = 'Primary Control'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 304
    Top = 40
    Width = 90
    Height = 14
    Caption = 'Secondary Control'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ToolBar1: TToolBar
    Left = 424
    Top = 64
    Width = 81
    Height = 177
    Align = alNone
    ButtonHeight = 24
    ButtonWidth = 75
    Caption = 'ToolBar1'
    Color = clBtnFace
    EdgeBorders = []
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
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
    object TToolButton
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
      Wrap = True
      OnClick = TBCancelClick
    end
    object TToolButton
      Left = 0
      Top = 72
      ImageIndex = 3
      Wrap = True
    end
    object TToolButton
      Left = 0
      Top = 96
      ImageIndex = 4
      Wrap = True
    end
    object TBLoad: TToolButton
      Left = 0
      Top = 120
      Caption = 'Load'
      ImageIndex = 5
      Wrap = True
      OnClick = TBLoadClick
    end
    object TBSave: TToolButton
      Left = 0
      Top = 144
      Caption = 'Save'
      ImageIndex = 6
      OnClick = TBSaveClick
    end
  end
  object ListBox: TListBox
    Left = 8
    Top = 56
    Width = 409
    Height = 340
    Style = lbOwnerDrawFixed
    BorderStyle = bsNone
    Color = clBtnHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 20
    ParentFont = False
    TabOrder = 1
    OnDblClick = ListBoxDblClick
    OnDrawItem = ListBoxDrawItem
    OnMouseDown = ListBoxMouseDown
  end
  object OpenDialog: TOpenDialog
    Filter = 'Controls Configuration (*.keys)|*.keys'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 192
    Top = 8
  end
  object SaveDialog: TSaveDialog
    Filter = 'Controls Configuration (*.keys)|*.keys'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 232
    Top = 8
  end
end
