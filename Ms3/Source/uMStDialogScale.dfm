object mstScaleDialogForm: TmstScaleDialogForm
  Left = 365
  Top = 165
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1084#1072#1089#1096#1090#1072#1073#1072
  ClientHeight = 79
  ClientWidth = 176
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 10
    Width = 17
    Height = 16
    Caption = '1 :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ComboBox1: TComboBox
    Left = 48
    Top = 7
    Width = 81
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
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
  object btnOK: TButton
    Left = 32
    Top = 48
    Width = 65
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 104
    Top = 48
    Width = 65
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
