object ConfigForm: TConfigForm
  Left = 223
  Top = 274
  ActiveControl = edtDatabase
  BorderStyle = bsDialog
  Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103
  ClientHeight = 161
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 9
    Top = 9
    Width = 81
    Height = 17
    Caption = '&'#1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
    FocusControl = edtDatabase
  end
  object Label2: TLabel
    Left = 9
    Top = 64
    Width = 152
    Height = 17
    Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1085#1072#1089#1090#1088#1086#1077#1082
  end
  object btnOk: TButton
    Left = 9
    Top = 128
    Width = 86
    Height = 29
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 101
    Top = 128
    Width = 85
    Height = 29
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object edtDatabase: TEdit
    Left = 9
    Top = 27
    Width = 358
    Height = 25
    MaxLength = 255
    TabOrder = 0
  end
  object btnBrowse: TButton
    Left = 375
    Top = 27
    Width = 86
    Height = 29
    Caption = #1055#1086'&'#1082#1072#1079#1072#1090#1100
    TabOrder = 1
    OnClick = btnBrowseClick
  end
  object edIniPath: TEdit
    Left = 9
    Top = 82
    Width = 358
    Height = 25
    Color = clScrollBar
    Enabled = False
    TabOrder = 4
  end
end
