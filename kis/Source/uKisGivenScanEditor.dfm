inherited KisGivenScanEditor: TKisGivenScanEditor
  Left = 350
  Top = 174
  Caption = 'KisGivenScanEditor'
  ClientHeight = 452
  ClientWidth = 421
  Position = poDesktopCenter
  OnShow = FormShow
  ExplicitWidth = 427
  ExplicitHeight = 484
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 16
    Top = 424
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 16
    ExplicitTop = 345
  end
  inherited btnOk: TButton
    Left = 257
    Top = 419
    Anchors = [akRight, akBottom]
    Default = True
    TabOrder = 3
    ExplicitLeft = 257
    ExplicitTop = 395
  end
  inherited btnCancel: TButton
    Left = 338
    Top = 419
    Anchors = [akRight, akBottom]
    Cancel = True
    TabOrder = 4
    ExplicitLeft = 338
    ExplicitTop = 395
  end
  object gbSender: TGroupBox [3]
    Left = 0
    Top = 153
    Width = 421
    Height = 144
    Align = alTop
    Caption = #1050#1086#1084#1091' '#1074#1099#1076#1072#1085
    TabOrder = 1
    object Label4: TLabel
      Left = 113
      Top = 13
      Width = 33
      Height = 13
      Caption = #1054#1090#1076#1077#1083
      FocusControl = edOrgname
    end
    object Label5: TLabel
      Left = 113
      Top = 69
      Width = 66
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      FocusControl = cbPeople
    end
    object edOrgname: TEdit
      Left = 113
      Top = 28
      Width = 297
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
    object cbPeople: TComboBox
      Left = 113
      Top = 85
      Width = 297
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 6
    end
    object RadBtnOrgs: TRadioButton
      Left = 6
      Top = 30
      Width = 91
      Height = 17
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      TabOrder = 0
    end
    object RadBtnMP: TRadioButton
      Left = 6
      Top = 87
      Width = 75
      Height = 17
      Caption = #1052#1055' "'#1059#1043#1040'"'
      TabOrder = 3
    end
    object edContacter: TEdit
      Left = 113
      Top = 85
      Width = 297
      Height = 21
      MaxLength = 100
      TabOrder = 4
      Visible = False
    end
    object btnSelectOrg: TButton
      Left = 334
      Top = 53
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 2
    end
    object cbOffices: TComboBox
      Left = 113
      Top = 28
      Width = 297
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 1
      Visible = False
    end
    object CheckBox1: TCheckBox
      Left = 112
      Top = 121
      Width = 297
      Height = 17
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1089#1088#1072#1079#1091' '#1087#1086#1089#1083#1077' '#1074#1099#1076#1072#1095#1080
      TabOrder = 7
    end
  end
  object gbBack: TGroupBox [4]
    Left = 0
    Top = 297
    Width = 421
    Height = 118
    Align = alTop
    Caption = #1042#1086#1079#1074#1088#1072#1090
    TabOrder = 2
    ExplicitTop = 271
    object Label6: TLabel
      Left = 8
      Top = 16
      Width = 76
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
      FocusControl = edDateOfBack
    end
    object Label2: TLabel
      Left = 113
      Top = 17
      Width = 37
      Height = 13
      Caption = #1055#1088#1080#1085#1103#1083
      FocusControl = cbWhoTakedBack
    end
    object Label12: TLabel
      Left = 112
      Top = 69
      Width = 66
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
    end
    object edDateOfBack: TEdit
      Left = 8
      Top = 32
      Width = 73
      Height = 21
      Color = clInfoBk
      TabOrder = 0
    end
    object cbWhoTakedBack: TComboBox
      Left = 113
      Top = 32
      Width = 297
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 1
    end
    object edContacterBack: TEdit
      Left = 112
      Top = 85
      Width = 297
      Height = 21
      MaxLength = 100
      TabOrder = 2
      Visible = False
    end
    object cbPeopleBack: TComboBox
      Left = 113
      Top = 85
      Width = 297
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object gbGive: TGroupBox [5]
    Left = 0
    Top = 0
    Width = 421
    Height = 153
    Align = alTop
    Caption = #1042#1099#1076#1072#1095#1072
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 16
      Width = 68
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
      FocusControl = edDateOfGive
    end
    object Label3: TLabel
      Left = 168
      Top = 16
      Width = 85
      Height = 13
      Caption = #1053#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081
      FocusControl = edTermOfGive
    end
    object Label10: TLabel
      Left = 8
      Top = 58
      Width = 55
      Height = 13
      Caption = #1050#1090#1086' '#1074#1099#1076#1072#1083
      FocusControl = cbPersonWhoGive
    end
    object Label9: TLabel
      Left = 8
      Top = 102
      Width = 128
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1088#1072#1073#1086#1090
      FocusControl = edAddress
    end
    object Label7: TLabel
      Left = 264
      Top = 16
      Width = 95
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103
      FocusControl = edDefinitionNumber
    end
    object Label8: TLabel
      Left = 89
      Top = 16
      Width = 68
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
      FocusControl = edOrderNumber
    end
    object edDateOfGive: TEdit
      Left = 8
      Top = 32
      Width = 73
      Height = 21
      Color = clInfoBk
      TabOrder = 0
    end
    object cbPersonWhoGive: TComboBox
      Left = 8
      Top = 72
      Width = 398
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 4
    end
    object edTermOfGive: TEdit
      Left = 167
      Top = 32
      Width = 88
      Height = 21
      Color = clInfoBk
      TabOrder = 2
      Text = 'edTermOfGive'
    end
    object edAddress: TEdit
      Left = 8
      Top = 119
      Width = 398
      Height = 21
      Color = clInfoBk
      TabOrder = 5
      Text = 'edAddress'
    end
    object edDefinitionNumber: TEdit
      Left = 263
      Top = 32
      Width = 96
      Height = 21
      Color = clInfoBk
      MaxLength = 10
      TabOrder = 3
      Text = 'edDefinitionNumber'
    end
    object edOrderNumber: TEdit
      Left = 89
      Top = 32
      Width = 70
      Height = 21
      Color = clInfoBk
      TabOrder = 1
      Text = 'edOrderNumber'
    end
  end
end
