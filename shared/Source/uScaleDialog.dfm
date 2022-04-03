object frmSetScale: TfrmSetScale
  Left = 363
  Top = 165
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1084#1072#1089#1096#1090#1072#1073#1072
  ClientHeight = 118
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 26
    Width = 17
    Height = 16
    Caption = '1 :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ComboBox1: TComboBox
    Left = 40
    Top = 23
    Width = 145
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 0
    Text = '100'
    Items.Strings = (
      '100'
      '500'
      '1000'
      '2000 '
      '5000'
      '10000')
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 128
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
