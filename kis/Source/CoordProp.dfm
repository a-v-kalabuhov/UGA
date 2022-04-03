object CoordPropForm: TCoordPropForm
  Left = 252
  Top = 228
  ActiveControl = cbLatinNumber
  BorderStyle = bsDialog
  Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099': '#1089#1074#1086#1081#1089#1090#1074#1072
  ClientHeight = 258
  ClientWidth = 278
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
  object btnOk: TButton
    Left = 33
    Top = 217
    Width = 93
    Height = 30
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 151
    Top = 217
    Width = 93
    Height = 30
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object gbShow: TGroupBox
    Left = 10
    Top = 10
    Width = 159
    Height = 198
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100
    TabOrder = 0
    object cbLatinNumber: TCheckBox
      Left = 10
      Top = 20
      Width = 139
      Height = 21
      Caption = '&'#1051#1072#1090#1080#1085#1089#1082#1080#1081' '#1085#1086#1084#1077#1088
      TabOrder = 0
    end
    object cbLength: TCheckBox
      Left = 10
      Top = 49
      Width = 70
      Height = 21
      Caption = '&'#1044#1083#1080#1085#1091
      TabOrder = 1
    end
    object cbAzimuth: TCheckBox
      Left = 10
      Top = 79
      Width = 80
      Height = 21
      Caption = '&'#1040#1079#1080#1084#1091#1090
      TabOrder = 2
    end
    object cbOnPoint: TCheckBox
      Left = 10
      Top = 108
      Width = 80
      Height = 21
      Caption = '&'#1053#1072' '#1090#1086#1095#1082#1091
      TabOrder = 3
    end
    object cbInformation: TCheckBox
      Left = 10
      Top = 138
      Width = 109
      Height = 21
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1102
      TabOrder = 4
    end
    object chbNeighbours: TCheckBox
      Left = 10
      Top = 167
      Width = 109
      Height = 21
      Caption = #1057#1084#1077#1078#1085#1080#1082#1086#1074
      TabOrder = 5
    end
  end
  object btnFont: TButton
    Left = 177
    Top = 118
    Width = 93
    Height = 31
    Caption = '&'#1064#1088#1080#1092#1090
    TabOrder = 2
    OnClick = btnFontClick
  end
  object rgView: TRadioGroup
    Left = 177
    Top = 10
    Width = 93
    Height = 80
    Caption = #1042#1080#1076
    ItemIndex = 0
    Items.Strings = (
      #1042#1080#1076' 1'
      #1042#1080#1076' 2')
    TabOrder = 1
  end
  object FontDialog: TFontDialog
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Left = 104
    Top = 88
  end
end
