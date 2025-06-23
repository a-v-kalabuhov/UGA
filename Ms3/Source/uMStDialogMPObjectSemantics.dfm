object mstEditMPObjectSemanticsDialog: TmstEditMPObjectSemanticsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1077#1084#1072#1085#1090#1080#1082#1072' '#1086#1073#1098#1077#1082#1090#1072
  ClientHeight = 579
  ClientWidth = 995
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    995
    579)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 445
    Height = 467
    Caption = #1055#1088#1086#1077#1082#1090
    TabOrder = 0
    DesignSize = (
      445
      467)
    object Label10: TLabel
      Left = 35
      Top = 102
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1087#1088#1086#1077#1082#1090#1072':'
      ExplicitLeft = 31
    end
    object Label11: TLabel
      Left = 55
      Top = 129
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #8470' '#1079#1072#1103#1074#1082#1080':'
      ExplicitLeft = 51
    end
    object Label12: TLabel
      Left = 42
      Top = 156
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080':'
      ExplicitLeft = 38
    end
    object Label7: TLabel
      Left = 75
      Top = 21
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1040#1076#1088#1077#1089':'
      ExplicitLeft = 71
    end
    object Label8: TLabel
      Left = 69
      Top = 48
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1077#1082#1090':'
      ExplicitLeft = 65
    end
    object Label9: TLabel
      Left = 48
      Top = 75
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #8470' '#1087#1088#1086#1077#1082#1090#1072':'
      ExplicitLeft = 44
    end
    object Label2: TLabel
      Left = 59
      Top = 183
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1072#1079#1095#1080#1082':'
      ExplicitLeft = 55
    end
    object Label3: TLabel
      Left = 42
      Top = 234
      Width = 68
      Height = 26
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1077#1082#1090#1085#1072#1103' '#13#10#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object Label4: TLabel
      Left = 8
      Top = 299
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1041#1072#1083#1072#1085#1089#1086#1076#1077#1088#1078#1072#1090#1077#1083#1100':'
      ExplicitLeft = 4
    end
    object Label17: TLabel
      Left = 42
      Top = 329
      Width = 68
      Height = 26
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1085#1077#1089#1083#1072#13#10#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object Label18: TLabel
      Left = 24
      Top = 390
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1085#1072#1085#1077#1089#1077#1085#1080#1103':'
    end
    object Label26: TLabel
      Left = 14
      Top = 417
      Width = 96
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'ID c'#1074#1103#1079#1072#1085#1085#1086#1081' '#1089#1077#1090#1080':'
    end
    object Label27: TLabel
      Left = 69
      Top = 443
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'ID '#1089#1077#1090#1080':'
    end
    object Label30: TLabel
      Left = 253
      Top = 122
      Width = 73
      Height = 26
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#13#10#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103':'
    end
    object edRequestDate: TEdit
      Left = 116
      Top = 153
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 10
      TabOrder = 7
      Text = 'edRequestDate'
      OnKeyPress = edRequestDateKeyPress
    end
    object edAddress: TEdit
      Left = 116
      Top = 18
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 1000
      TabOrder = 0
      Text = 'edAddress'
    end
    object edProjectName: TEdit
      Left = 116
      Top = 45
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 1000
      TabOrder = 1
      Text = 'edProjectName'
    end
    object edDocNumber: TEdit
      Left = 116
      Top = 72
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 12
      TabOrder = 2
      Text = 'edDocNumber'
    end
    object edDocDate: TEdit
      Left = 116
      Top = 99
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 10
      TabOrder = 3
      Text = 'edDocDate'
      OnKeyPress = edDocDateKeyPress
    end
    object edRequestNumber: TEdit
      Left = 116
      Top = 126
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 12
      TabOrder = 5
      Text = 'edRequestNumber'
    end
    object edCustomer: TEdit
      Left = 116
      Top = 180
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      TabOrder = 8
      Text = 'edCustomer'
    end
    object btnSelectCustomer: TButton
      Left = 354
      Top = 207
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 10
      OnClick = btnSelectCustomerClick
    end
    object edExecutor: TEdit
      Left = 116
      Top = 238
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      TabOrder = 11
      Text = 'edExecutor'
    end
    object btnSelectExecutor: TButton
      Left = 354
      Top = 265
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 13
      OnClick = btnSelectExecutorClick
    end
    object edOwner: TEdit
      Left = 116
      Top = 296
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 14
      Text = 'edOwner'
    end
    object edDrawer: TEdit
      Left = 116
      Top = 332
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      TabOrder = 15
      Text = 'edDrawer'
    end
    object btnSelectDrawer: TButton
      Left = 354
      Top = 359
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 17
      OnClick = btnSelectDrawerClick
    end
    object edDrawDate: TEdit
      Left = 116
      Top = 387
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 10
      TabOrder = 18
      Text = 'edDrawDate'
      OnKeyPress = edDrawDateKeyPress
    end
    object btnClearCustomer: TButton
      Left = 273
      Top = 207
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 9
      OnClick = btnClearCustomerClick
    end
    object btnClearExecutor: TButton
      Left = 273
      Top = 265
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 12
      OnClick = btnClearExecutorClick
    end
    object btnClearDrawer: TButton
      Left = 273
      Top = 359
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 16
      OnClick = btnClearDrawerClick
    end
    object edLinkedGuid: TEdit
      Left = 116
      Top = 414
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 36
      TabOrder = 19
      Text = 'edLinkedGuid'
    end
    object edObjGuid: TEdit
      Left = 116
      Top = 440
      Width = 313
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 36
      ParentColor = True
      ReadOnly = True
      TabOrder = 20
      Text = 'edObjGuid'
    end
    object chbConfirmed: TCheckBox
      Left = 332
      Top = 103
      Width = 134
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1099#1081
      TabOrder = 4
    end
    object edConfirmDate: TEdit
      Left = 332
      Top = 126
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 10
      TabOrder = 6
      Text = 'edConfirmDate'
      OnKeyPress = edConfirmDateKeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 459
    Top = 8
    Width = 444
    Height = 563
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 1
    DesignSize = (
      444
      563)
    object Label1: TLabel
      Left = 55
      Top = 21
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label5: TLabel
      Left = 62
      Top = 48
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1083#1072#1089#1089':'
    end
    object Label6: TLabel
      Left = 47
      Top = 200
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1080#1072#1084#1077#1090#1088':'
    end
    object Label13: TLabel
      Left = 56
      Top = 223
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1086#1083'-'#1074#1086
    end
    object Label14: TLabel
      Left = 42
      Top = 233
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1087#1088#1086#1074#1086#1076#1086#1074':'
    end
    object Label15: TLabel
      Left = 46
      Top = 246
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1080#1083#1080' '#1090#1088#1091#1073
    end
    object Label16: TLabel
      Left = 28
      Top = 352
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077':'
    end
    object Label19: TLabel
      Left = 16
      Top = 266
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072':'
    end
    object Label20: TLabel
      Left = 41
      Top = 379
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1052#1072#1090#1077#1088#1080#1072#1083':'
    end
    object Label21: TLabel
      Left = 67
      Top = 406
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1042#1077#1088#1093':'
    end
    object Label22: TLabel
      Left = 73
      Top = 433
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1053#1080#1079':'
    end
    object Label23: TLabel
      Left = 71
      Top = 460
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1085#1086':'
    end
    object Label28: TLabel
      Left = 37
      Top = 529
      Width = 58
      Height = 26
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1090#1072#1090#1091#1089#13#10#1087#1088#1086#1074#1077#1088#1082#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label29: TLabel
      Left = 210
      Top = 200
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1087':'
    end
    object Label32: TLabel
      Left = 210
      Top = 352
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1087':'
    end
    object lSemInfo: TLabel
      Left = 64
      Top = 484
      Width = 31
      Height = 13
      Caption = #1048#1085#1092#1086':'
    end
    object Label33: TLabel
      Left = 28
      Top = 325
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077':'
    end
    object Label31: TLabel
      Left = 41
      Top = 298
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1074#1083#1077#1085#1080#1077':'
    end
    object chbArchived: TCheckBox
      Left = 101
      Top = 76
      Width = 134
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1040#1088#1093#1080#1074#1085#1099#1081
      TabOrder = 2
    end
    object cbProjected: TComboBox
      Left = 101
      Top = 18
      Width = 332
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      Enabled = False
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        #1087#1088#1086#1077#1082#1090#1080#1088#1091#1077#1084#1099#1081
        #1085#1072#1085#1077#1089#1105#1085#1085#1099#1081)
    end
    object chbDismantled: TCheckBox
      Left = 101
      Top = 122
      Width = 134
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1044#1077#1084#1086#1085#1090#1080#1088#1086#1074#1072#1085#1085#1099#1081
      TabOrder = 4
    end
    object cbClass: TComboBox
      Left = 101
      Top = 45
      Width = 332
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      Enabled = False
      ItemHeight = 13
      TabOrder = 1
    end
    object chbUnderground: TCheckBox
      Left = 101
      Top = 145
      Width = 134
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1076#1079#1077#1084#1085#1099#1081
      TabOrder = 5
    end
    object spinDiameter: TJvSpinEdit
      Left = 101
      Top = 197
      Width = 100
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 7
    end
    object spinPipeCount: TJvSpinEdit
      Left = 101
      Top = 230
      Width = 100
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 9
    end
    object spinVoltage: TJvSpinEdit
      Left = 101
      Top = 349
      Width = 100
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 13
    end
    object spinRotation: TJvSpinEdit
      Left = 101
      Top = 263
      Width = 100
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 10
    end
    object edMaterial: TEdit
      Left = 101
      Top = 376
      Width = 332
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 15
      Text = 'edMaterial'
    end
    object edTop: TEdit
      Left = 101
      Top = 403
      Width = 332
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 16
      Text = 'edTop'
    end
    object edBottom: TEdit
      Left = 101
      Top = 430
      Width = 332
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 17
      Text = 'edBottom'
    end
    object edFloor: TEdit
      Left = 101
      Top = 457
      Width = 332
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 18
      Text = 'edFloor'
    end
    object cbCheckState: TComboBox
      Left = 101
      Top = 534
      Width = 332
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 20
      Items.Strings = (
        #1085#1077' '#1087#1088#1086#1074#1077#1088#1103#1083#1089#1103
        #1087#1088#1086#1074#1077#1088#1077#1085
        #1085#1072' '#1087#1088#1086#1074#1077#1088#1082#1077' '#1087#1086#1089#1083#1077' '#1080#1084#1087#1086#1088#1090#1072
        #1085#1072' '#1087#1088#1086#1074#1077#1088#1082#1077' '#1087#1086#1089#1083#1077' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103)
    end
    object chbChecked: TCheckBox
      Left = 101
      Top = 99
      Width = 134
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085
      TabOrder = 3
    end
    object edDiamComment: TEdit
      Left = 240
      Top = 197
      Width = 193
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 8
      Text = 'edDiamComment'
    end
    object edVoltComment: TEdit
      Left = 240
      Top = 349
      Width = 193
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 255
      TabOrder = 14
      Text = 'edVoltComment'
    end
    object mInfo: TMemo
      Left = 101
      Top = 484
      Width = 332
      Height = 44
      Color = clBtnFace
      Lines.Strings = (
        'mInfo')
      ScrollBars = ssVertical
      TabOrder = 19
    end
    object chbSewer: TCheckBox
      Left = 100
      Top = 168
      Width = 134
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1050#1072#1085#1072#1083#1080#1079#1072#1094#1080#1103' '#1085#1072#1087#1086#1088#1085#1072#1103
      TabOrder = 6
    end
    object cbVoltage: TComboBox
      Left = 101
      Top = 322
      Width = 332
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 12
      Items.Strings = (
        '0,4 '#1082#1042
        '6  '#1082#1042
        '10 '#1082#1042
        '20 '#1082#1042
        '35 '#1082#1042
        '60 '#1082#1042
        '110 '#1082#1042
        '220 '#1082#1042
        '300 '#1082#1042
        '330 '#1082#1042
        '400 '#1082#1042
        '500 '#1082#1042
        '600 '#1082#1042
        '750 '#1082#1042
        '800 '#1082#1042
        '1150 '#1082#1042)
    end
    object cbPressure: TComboBox
      Left = 101
      Top = 295
      Width = 332
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 11
      Items.Strings = (
        #1053#1080#1079#1082#1086#1077
        #1057#1088#1077#1076#1085#1077#1077
        #1042#1099#1089#1086#1082#1086#1077)
    end
  end
  object btnOK: TButton
    Left = 912
    Top = 14
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 912
    Top = 71
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 475
    Width = 445
    Height = 96
    Caption = #1057#1087#1088#1072#1074#1082#1072
    TabOrder = 4
    object Label24: TLabel
      Left = 49
      Top = 43
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #8470' '#1089#1087#1088#1072#1074#1082#1080':'
    end
    object Label25: TLabel
      Left = 36
      Top = 70
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1087#1088#1072#1074#1082#1080':'
    end
    object chbHasCertif: TCheckBox
      Left = 116
      Top = 17
      Width = 134
      Height = 17
      Caption = #1057#1087#1088#1072#1074#1082#1072' '#1074#1099#1076#1072#1085#1072
      TabOrder = 0
    end
    object edCertifNumber: TEdit
      Left = 116
      Top = 40
      Width = 97
      Height = 21
      MaxLength = 12
      TabOrder = 1
      Text = 'edCertifNumber'
    end
    object edCertifDate: TEdit
      Left = 116
      Top = 67
      Width = 97
      Height = 21
      MaxLength = 10
      TabOrder = 2
      Text = 'edCertifDate'
      OnKeyPress = edCertifDateKeyPress
    end
  end
end
