object Form2: TForm2
  Left = 727
  Top = 582
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 182
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 50
    Top = 8
    Width = 100
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'ODEditor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 50
    Top = 48
    Width = 100
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'by Jan Zizka '
  end
  object Label3: TLabel
    Left = 50
    Top = 64
    Width = 100
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '2004'
  end
  object Label4: TLabel
    Left = 50
    Top = 104
    Width = 100
    Height = 13
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'www.glscene.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnMouseDown = Label4MouseDown
  end
  object Label5: TLabel
    Left = 50
    Top = 78
    Width = 100
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'zizajan@centrum.cz'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 50
    Top = 120
    Width = 100
    Height = 13
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'http://ode.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnMouseDown = Label6MouseDown
  end
  object Panel1: TPanel
    Left = 25
    Top = 32
    Width = 150
    Height = 2
    TabOrder = 0
  end
  object Button1: TButton
    Left = 50
    Top = 144
    Width = 100
    Height = 25
    Caption = 'Back'
    TabOrder = 1
    OnClick = Button1Click
  end
end
