inherited KisContragentPersonEditor: TKisContragentPersonEditor
  Left = 90
  Top = 138
  Caption = 'KisContragentPersonEditor'
  ClientHeight = 448
  ClientWidth = 707
  Font.Charset = DEFAULT_CHARSET
  ExplicitWidth = 713
  ExplicitHeight = 476
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Top = 422
    Width = 707
    Height = 26
    AutoSize = False
    ExplicitTop = 388
    ExplicitWidth = 707
    ExplicitHeight = 26
  end
  inherited IDLabel: TLabel
    Left = 8
    Top = 427
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 450
  end
  inherited lComment: TLabel
    Left = 573
    Top = 291
    ExplicitLeft = 573
    ExplicitTop = 291
  end
  inherited btnOk: TButton
    Top = 415
    Anchors = [akRight, akBottom]
    ExplicitTop = 415
  end
  inherited btnCancel: TButton
    Top = 415
    Anchors = [akRight, akBottom]
    TabOrder = 3
    ExplicitTop = 415
  end
  inherited gbCommon: TGroupBox
    Width = 707
    Height = 177
    ExplicitWidth = 707
    ExplicitHeight = 177
    inherited lName: TLabel
      Left = 74
      Width = 35
      Alignment = taRightJustify
      Caption = #1060'.'#1048'.'#1054'.'
      ExplicitLeft = 74
      ExplicitWidth = 35
    end
    inherited lShortName: TLabel
      Top = 35
      Visible = False
      ExplicitTop = 35
    end
    inherited lAddress1: TLabel
      Left = 27
      Top = 53
      Width = 81
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
      ExplicitLeft = 27
      ExplicitTop = 53
      ExplicitWidth = 81
    end
    inherited lAddress2: TLabel
      Top = 77
      Width = 96
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
      ExplicitTop = 77
      ExplicitWidth = 96
    end
    inherited lINN: TLabel
      Left = 87
      Top = 106
      Alignment = taRightJustify
      ExplicitLeft = 87
      ExplicitTop = 106
    end
    inherited lPhones: TLabel
      Left = 56
      Top = 132
      Alignment = taRightJustify
      ExplicitLeft = 56
      ExplicitTop = 132
    end
    inherited edName: TEdit
      OnChange = edNameChange
    end
    inherited edNameShort: TEdit
      Visible = False
    end
    inherited edAddr1: TEdit
      Top = 48
      Color = clWindow
      ExplicitTop = 48
    end
    inherited edAddr2: TEdit
      Top = 75
      TabOrder = 4
      ExplicitTop = 75
    end
    inherited btnAddress1: TButton
      Top = 48
      TabOrder = 3
      TabStop = True
      ExplicitTop = 48
    end
    inherited btnAddress2: TButton
      Top = 75
      TabStop = True
      ExplicitTop = 75
    end
    inherited edINN: TEdit
      Left = 115
      Top = 102
      ExplicitLeft = 115
      ExplicitTop = 102
    end
    inherited edPhones: TEdit
      Left = 114
      Top = 130
      ExplicitLeft = 114
      ExplicitTop = 130
    end
  end
  inherited mComment: TMemo
    Left = 573
    Top = 306
    Width = 132
    Height = 96
    TabOrder = 5
    ExplicitLeft = 573
    ExplicitTop = 306
    ExplicitWidth = 132
    ExplicitHeight = 96
  end
  inherited gbBank: TGroupBox
    Top = 177
    Width = 707
    ExplicitTop = 177
    ExplicitWidth = 707
    inherited cbKindAccount: TComboBox
      Left = 47
      Top = 63
      ExplicitLeft = 47
      ExplicitTop = 63
    end
    inherited edBank: TEdit
      Left = 11
      ExplicitLeft = 11
    end
    inherited edBankAccount: TEdit
      Left = 276
      ExplicitLeft = 276
    end
    inherited btnBank: TButton
      Left = 614
      Top = 36
      Width = 83
      ExplicitLeft = 614
      ExplicitTop = 36
      ExplicitWidth = 83
    end
  end
  object gbPersonDoc: TGroupBox [8]
    Left = -2
    Top = 287
    Width = 569
    Height = 115
    Caption = #1044#1086#1082#1091#1084#1077#1085#1090', '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1103#1102#1097#1080#1081' '#1083#1080#1095#1085#1086#1089#1090#1100
    TabOrder = 1
    object Label10: TLabel
      Left = 15
      Top = 22
      Width = 76
      Height = 13
      Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      FocusControl = cbDocType
    end
    object Label11: TLabel
      Left = 265
      Top = 22
      Width = 31
      Height = 13
      Caption = #1053#1086#1084#1077#1088
      FocusControl = edDocNumber
    end
    object Label12: TLabel
      Left = 140
      Top = 22
      Width = 31
      Height = 13
      Caption = #1057#1077#1088#1080#1103
      FocusControl = edDocSerie
    end
    object Label13: TLabel
      Left = 389
      Top = 22
      Width = 67
      Height = 13
      Caption = #1050#1086#1075#1076#1072' '#1074#1099#1076#1072#1085
      FocusControl = dtpDocDate
    end
    object Label14: TLabel
      Left = 15
      Top = 67
      Width = 55
      Height = 13
      Caption = #1050#1077#1084' '#1074#1099#1076#1072#1085
    end
    object cbDocType: TComboBox
      Left = 15
      Top = 37
      Width = 112
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object edDocNumber: TEdit
      Left = 265
      Top = 37
      Width = 112
      Height = 21
      MaxLength = 10
      TabOrder = 2
      Text = 'edDocNumber'
    end
    object edDocSerie: TEdit
      Left = 140
      Top = 37
      Width = 112
      Height = 21
      MaxLength = 10
      TabOrder = 1
      Text = 'edDocSerie'
    end
    object dtpDocDate: TDateTimePicker
      Left = 389
      Top = 37
      Width = 172
      Height = 22
      Date = 38025.707334884260000000
      Time = 38025.707334884260000000
      Color = clInfoBk
      TabOrder = 3
    end
    object cbDocOwner: TComboBox
      Left = 15
      Top = 82
      Width = 546
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = 'cbDocOwner'
    end
  end
end
