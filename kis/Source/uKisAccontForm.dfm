inherited KisAccountForm: TKisAccountForm
  Left = 239
  Top = 317
  Caption = ''
  ClientHeight = 226
  ClientWidth = 514
  Font.Charset = DEFAULT_CHARSET
  KeyPreview = True
  Position = poOwnerFormCenter
  OnKeyUp = FormKeyUp
  ExplicitWidth = 520
  ExplicitHeight = 258
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 63
    Top = 197
    ExplicitLeft = 63
    ExplicitTop = 197
  end
  inherited btnOk: TButton
    Left = 359
    Top = 196
    Height = 24
    TabOrder = 2
    ExplicitLeft = 359
    ExplicitTop = 196
    ExplicitHeight = 24
  end
  inherited btnCancel: TButton
    Left = 438
    Top = 196
    Height = 24
    TabOrder = 3
    ExplicitLeft = 438
    ExplicitTop = 196
    ExplicitHeight = 24
  end
  object GroupBox1: TGroupBox [3]
    Left = 0
    Top = 0
    Width = 513
    Height = 116
    Caption = #1041#1072#1085#1082
    TabOrder = 0
    object Label1: TLabel
      Left = 304
      Top = 19
      Width = 69
      Height = 13
      Caption = #1053#1072#1081#1090#1080' '#1087#1086' '#1041#1048#1050
    end
    object edBIK: TEdit
      Left = 384
      Top = 16
      Width = 69
      Height = 21
      Color = clInfoBk
      MaxLength = 9
      TabOrder = 1
      OnChange = edBIKChange
      OnKeyPress = edNumberKeyPress
      OnKeyUp = edBIKKeyUp
    end
    object btnFind: TButton
      Left = 455
      Top = 15
      Width = 50
      Height = 23
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 2
    end
    object mBank: TMemo
      Left = 8
      Top = 43
      Width = 497
      Height = 66
      Color = clBtnFace
      Lines.Strings = (
        'mBank')
      ReadOnly = True
      TabOrder = 3
    end
    object btnSelect: TButton
      Left = 8
      Top = 15
      Width = 75
      Height = 23
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox [4]
    Left = 0
    Top = 116
    Width = 513
    Height = 72
    Caption = #1057#1095#1077#1090
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 20
      Width = 50
      Height = 13
      Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
    end
    object Label3: TLabel
      Left = 88
      Top = 20
      Width = 63
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
    end
    object cbType: TComboBox
      Left = 8
      Top = 34
      Width = 73
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        #1083'\'#1089#1095#1077#1090
        #1088'\'#1089#1095#1077#1090)
    end
    object edNumber: TEdit
      Left = 88
      Top = 34
      Width = 140
      Height = 21
      Color = clInfoBk
      MaxLength = 20
      TabOrder = 1
      OnKeyPress = edNumberKeyPress
    end
    object cbDefault: TCheckBox
      Left = 241
      Top = 27
      Width = 264
      Height = 35
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1074#1086' '#1074#1089#1077#1093' '#1079#1072#1082#1072#1079#1072#1093' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      TabOrder = 2
      WordWrap = True
    end
  end
end
