inherited KisContragentEditor: TKisContragentEditor
  Left = 241
  Top = 159
  Caption = 'KisContragentEditor'
  ClientHeight = 685
  ClientWidth = 709
  Icon.Data = {
    0000010001002020100001000400E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000EEE00EE00EE00000000000000
    0000000EE0EE00E0E000000000000000000000000EE08F000000000000000000
    000000000008F800000000000000000000000000008F00000000000000000000
    000000000008F8F8000000000000000000000000000F8F800000000000000000
    000000000008F8F8000000000000000000000000008F8F8F8000000000000000
    000000000000F8C8000000000000000000000000000F8F000000000000000000
    000000000078F8F000000000000000000000000000007F000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFE003FFFFC003FFFFE007FFFFF01FFFFFF80FFFFFF007FFFFF007FFFFE0
    07FFFFC003FFFFC007FFFFC00FFFFFC00FFFFFC01FFFFFE00FFFFFF01FFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = True
  Position = poMainFormCenter
  ExplicitWidth = 715
  ExplicitHeight = 713
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 0
    Top = 672
    Width = 709
    Align = alBottom
    ExplicitLeft = 0
    ExplicitTop = 672
  end
  object IDLabel: TLabel [1]
    Left = 89
    Top = 659
    Width = 36
    Height = 13
    Caption = 'IDLabel'
  end
  object lComment: TLabel [2]
    Left = 13
    Top = 376
    Width = 67
    Height = 13
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
    FocusControl = mComment
  end
  inherited btnOk: TButton
    Left = 545
    Top = 652
    TabOrder = 2
    ExplicitLeft = 545
    ExplicitTop = 652
  end
  inherited btnCancel: TButton
    Left = 626
    Top = 652
    Default = True
    ExplicitLeft = 626
    ExplicitTop = 652
  end
  object gbCommon: TGroupBox [5]
    Left = 0
    Top = 0
    Width = 709
    Height = 161
    Align = alTop
    Caption = #1054#1073#1097#1080#1077' '#1089#1074#1077#1076#1077#1085#1080#1103
    TabOrder = 0
    object lName: TLabel
      Left = 12
      Top = 24
      Width = 73
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FocusControl = edName
    end
    object lShortName: TLabel
      Left = 12
      Top = 50
      Width = 86
      Height = 13
      Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085'.'
      FocusControl = edNameShort
    end
    object lAddress1: TLabel
      Left = 12
      Top = 78
      Width = 103
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081
      FocusControl = btnAddress1
    end
    object lAddress2: TLabel
      Left = 12
      Top = 107
      Width = 101
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081
      FocusControl = btnAddress2
    end
    object lINN: TLabel
      Left = 291
      Top = 136
      Width = 21
      Height = 13
      Caption = #1048#1053#1053
      FocusControl = edINN
    end
    object lPhones: TLabel
      Left = 54
      Top = 135
      Width = 52
      Height = 13
      Caption = #1058#1077#1083#1077#1092#1086#1085#1099
      FocusControl = edPhones
    end
    object edName: TEdit
      Left = 115
      Top = 21
      Width = 580
      Height = 21
      Color = clInfoBk
      MaxLength = 500
      TabOrder = 0
    end
    object edNameShort: TEdit
      Left = 115
      Top = 48
      Width = 580
      Height = 21
      Color = clInfoBk
      MaxLength = 120
      TabOrder = 1
    end
    object edAddr1: TEdit
      Left = 115
      Top = 76
      Width = 495
      Height = 21
      Color = clInfoBk
      MaxLength = 120
      ReadOnly = True
      TabOrder = 2
      OnKeyUp = edAddr1KeyUp
    end
    object edAddr2: TEdit
      Left = 115
      Top = 105
      Width = 495
      Height = 21
      MaxLength = 120
      ReadOnly = True
      TabOrder = 3
      OnKeyUp = edAddr2KeyUp
    end
    object btnAddress1: TButton
      Left = 620
      Top = 75
      Width = 76
      Height = 22
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 4
      TabStop = False
    end
    object btnAddress2: TButton
      Left = 620
      Top = 105
      Width = 76
      Height = 22
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 5
      TabStop = False
    end
    object edINN: TEdit
      Left = 323
      Top = 133
      Width = 90
      Height = 21
      MaxLength = 12
      TabOrder = 6
      OnKeyPress = EditNumberField
    end
    object edPhones: TEdit
      Left = 115
      Top = 133
      Width = 140
      Height = 21
      MaxLength = 30
      TabOrder = 7
    end
  end
  object mComment: TMemo [6]
    Left = 13
    Top = 392
    Width = 76
    Height = 79
    Lines.Strings = (
      'mComment')
    MaxLength = 1000
    TabOrder = 3
  end
  object gbBank: TGroupBox [7]
    Left = 0
    Top = 161
    Width = 709
    Height = 104
    Align = alTop
    Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1088#1077#1082#1074#1080#1079#1080#1090#1099
    TabOrder = 4
    object lBank: TLabel
      Left = 12
      Top = 20
      Width = 106
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1073#1072#1085#1082#1072
    end
    object lAccountType: TLabel
      Left = 12
      Top = 63
      Width = 29
      Height = 26
      Caption = #1058#1080#1087' '#13#10#1089#1095#1077#1090#1072
      FocusControl = cbKindAccount
    end
    object lAccount: TLabel
      Left = 206
      Top = 71
      Width = 63
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
      FocusControl = edBankAccount
    end
    object cbKindAccount: TComboBox
      Left = 44
      Top = 68
      Width = 142
      Height = 21
      Style = csDropDownList
      Color = clBtnFace
      Enabled = False
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 0
      Text = #1056'/'#1089#1095#1077#1090
      Items.Strings = (
        #1051'/'#1089#1095#1077#1090
        #1056'/'#1089#1095#1077#1090)
    end
    object edBank: TEdit
      Left = 12
      Top = 36
      Width = 597
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      OnKeyUp = edBankKeyUp
    end
    object edBankAccount: TEdit
      Left = 277
      Top = 68
      Width = 140
      Height = 21
      Color = clBtnFace
      MaxLength = 20
      ReadOnly = True
      TabOrder = 2
      Text = '9999999999999999999999'
      OnKeyPress = EditNumberField
    end
    object btnBank: TButton
      Left = 622
      Top = 75
      Width = 75
      Height = 22
      Caption = #1057#1087#1080#1089#1086#1082' '#1089#1095#1077#1090#1086#1074
      TabOrder = 3
      TabStop = False
    end
  end
end
