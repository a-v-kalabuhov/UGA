inherited KisContragentPrivateEditor: TKisContragentPrivateEditor
  Caption = 'KisContragentPrivateEditor'
  ClientHeight = 485
  OnShow = FormShow
  ExplicitHeight = 513
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Top = 453
    Height = 32
    ExplicitTop = 453
    ExplicitHeight = 32
  end
  inherited IDLabel: TLabel
    Left = 1
    Top = 466
    ExplicitLeft = 1
    ExplicitTop = 466
  end
  inherited lComment: TLabel
    Top = 351
    ExplicitTop = 351
  end
  inherited btnOk: TButton
    Top = 454
    TabOrder = 3
    ExplicitTop = 454
  end
  inherited btnCancel: TButton
    Top = 454
    TabOrder = 5
    ExplicitTop = 454
  end
  inherited gbCommon: TGroupBox
    Height = 185
    ExplicitHeight = 185
    inherited lShortName: TLabel
      Left = 24
      Top = 50
      Alignment = taRightJustify
      Visible = True
      ExplicitLeft = 24
      ExplicitTop = 50
    end
    inherited lAddress1: TLabel
      Left = 6
      Top = 81
      Width = 103
      Caption = #1040#1076#1088#1077#1089' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081
      ExplicitLeft = 6
      ExplicitTop = 81
      ExplicitWidth = 103
    end
    inherited lAddress2: TLabel
      Left = 8
      Top = 105
      Width = 101
      Caption = #1040#1076#1088#1077#1089' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081
      ExplicitLeft = 8
      ExplicitTop = 105
      ExplicitWidth = 101
    end
    inherited lINN: TLabel
      Top = 132
      ExplicitTop = 132
    end
    inherited lPhones: TLabel
      Top = 157
      ExplicitTop = 157
    end
    inherited edNameShort: TEdit
      Visible = True
      OnChange = edNameShortChange
    end
    inherited edAddr1: TEdit
      Top = 76
      ExplicitTop = 76
    end
    inherited edAddr2: TEdit
      Top = 103
      ExplicitTop = 103
    end
    inherited btnAddress1: TButton
      Top = 76
      ExplicitTop = 76
    end
    inherited btnAddress2: TButton
      Top = 103
      ExplicitTop = 103
    end
    inherited edINN: TEdit
      Top = 130
      ExplicitTop = 130
    end
    inherited edPhones: TEdit
      Left = 115
      Top = 156
      ExplicitLeft = 115
      ExplicitTop = 156
    end
  end
  inherited mComment: TMemo
    Top = 365
    Height = 82
    TabOrder = 6
    ExplicitTop = 365
    ExplicitHeight = 82
  end
  inherited gbBank: TGroupBox
    Top = 185
    ExplicitTop = 185
    inherited lBank: TLabel
      Top = 22
      ExplicitTop = 22
    end
    inherited lAccountType: TLabel
      Top = 64
      ExplicitTop = 64
    end
    inherited lAccount: TLabel
      Top = 70
      ExplicitTop = 70
    end
    inherited cbKindAccount: TComboBox
      Top = 67
      ExplicitTop = 67
    end
    inherited edBank: TEdit
      Top = 38
      Width = 594
      ExplicitTop = 38
      ExplicitWidth = 594
    end
    inherited edBankAccount: TEdit
      Top = 67
      ExplicitTop = 67
    end
    inherited btnBank: TButton
      Top = 37
      ExplicitTop = 37
    end
  end
  inherited gbPersonDoc: TGroupBox
    Top = 348
    Height = 100
    ExplicitTop = 348
    ExplicitHeight = 100
    inherited Label10: TLabel
      Top = 15
      ExplicitTop = 15
    end
    inherited Label11: TLabel
      Top = 15
      ExplicitTop = 15
    end
    inherited Label12: TLabel
      Top = 15
      ExplicitTop = 15
    end
    inherited Label13: TLabel
      Top = 15
      ExplicitTop = 15
    end
    inherited Label14: TLabel
      Top = 56
      ExplicitTop = 56
    end
    inherited cbDocType: TComboBox
      Top = 30
      ExplicitTop = 30
    end
    inherited edDocNumber: TEdit
      Top = 30
      ExplicitTop = 30
    end
    inherited edDocSerie: TEdit
      Top = 30
      ExplicitTop = 30
    end
    inherited dtpDocDate: TDateTimePicker
      Top = 30
      Color = clWindow
      ExplicitTop = 30
    end
    inherited cbDocOwner: TComboBox
      Top = 70
      ExplicitTop = 70
    end
  end
  object GroupBox1: TGroupBox [9]
    Left = 0
    Top = 289
    Width = 707
    Height = 60
    Align = alTop
    Caption = #1057#1077#1088#1090#1080#1092#1080#1082#1072#1090
    TabOrder = 2
    object Label15: TLabel
      Left = 15
      Top = 15
      Width = 31
      Height = 13
      Caption = #1053#1086#1084#1077#1088
    end
    object Label16: TLabel
      Left = 97
      Top = 15
      Width = 68
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
    end
    object Label17: TLabel
      Left = 193
      Top = 15
      Width = 94
      Height = 13
      Caption = #1042#1080#1076' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080
    end
    object Label18: TLabel
      Left = 349
      Top = 15
      Width = 55
      Height = 13
      Caption = #1050#1077#1084' '#1074#1099#1076#1072#1085
    end
    object dtpCertDate: TDateTimePicker
      Left = 97
      Top = 30
      Width = 75
      Height = 22
      Date = 38077.729268854160000000
      Time = 38077.729268854160000000
      TabOrder = 1
    end
    object edCertNumber: TEdit
      Left = 15
      Top = 31
      Width = 68
      Height = 21
      MaxLength = 20
      TabOrder = 0
    end
    object edBusiness: TEdit
      Left = 193
      Top = 30
      Width = 135
      Height = 21
      MaxLength = 100
      TabOrder = 2
      Text = 'edBusiness'
    end
    object edCertOwner: TComboBox
      Left = 349
      Top = 30
      Width = 350
      Height = 21
      DropDownCount = 15
      ItemHeight = 13
      MaxLength = 150
      TabOrder = 3
      Items.Strings = (
        #1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1094#1080#1077#1081' '#1075'.'#1042#1086#1088#1086#1085#1077#1078#1072
        #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1086#1085#1085#1086#1081' '#1087#1072#1083#1072#1090#1086#1081
        #1048#1052#1053#1057' '#1087#1086' '#1046#1077#1083#1077#1079#1085#1086#1076#1086#1088#1086#1078#1085#1086#1084#1091' '#1088'-'#1085#1091' '#1075'.'#1042#1086#1088#1086#1085#1077#1078
        #1048#1052#1053#1057' '#1087#1086' '#1050#1086#1084#1080#1085#1090#1077#1088#1085#1086#1074#1089#1082#1086#1084#1091' '#1088'-'#1085#1091' '#1075'.'#1042#1086#1088#1086#1085#1077#1078
        #1048#1052#1053#1057' '#1087#1086' '#1051#1077#1074#1086#1073#1077#1088#1077#1078#1085#1086#1084#1091' '#1088'-'#1085#1091' '#1075'.'#1042#1086#1088#1086#1085#1077#1078
        #1048#1052#1053#1057' '#1087#1086' '#1051#1077#1085#1080#1085#1089#1082#1086#1084#1091' '#1088'-'#1085#1091' '#1075'.'#1042#1086#1088#1086#1085#1077#1078
        #1048#1052#1053#1057' '#1087#1086' '#1057#1086#1074#1077#1090#1089#1082#1086#1084#1091' '#1088'-'#1085#1091' '#1075'.'#1042#1086#1088#1086#1085#1077#1078
        #1048#1052#1053#1057' '#1087#1086' '#1062#1077#1085#1090#1088#1072#1083#1100#1085#1086#1084#1091' '#1088'-'#1085#1091' '#1075'.'#1042#1086#1088#1086#1085#1077#1078)
    end
  end
end
