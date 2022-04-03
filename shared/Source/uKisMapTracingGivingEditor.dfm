inherited KisMapTracingGivingEditor: TKisMapTracingGivingEditor
  Left = 301
  Top = 192
  Caption = 'KisMapTracingGivingEditor'
  ClientHeight = 275
  ClientWidth = 419
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 15
    Top = 248
  end
  inherited btnOk: TButton
    Left = 263
    Top = 247
  end
  inherited btnCancel: TButton
    Left = 341
    Top = 247
    Default = True
  end
  object gbGive: TGroupBox
    Left = 0
    Top = 0
    Width = 419
    Height = 174
    Align = alTop
    Caption = #1042#1099#1076#1072#1095#1072
    TabOrder = 2
    object Label1: TLabel
      Left = 9
      Top = 16
      Width = 68
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
      FocusControl = edGiveDate
    end
    object Label3: TLabel
      Left = 96
      Top = 16
      Width = 85
      Height = 13
      Caption = #1053#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081
      FocusControl = edPeriod
    end
    object lRecipient: TLabel
      Left = 9
      Top = 69
      Width = 33
      Height = 13
      Caption = #1054#1090#1076#1077#1083
      FocusControl = edOrgname
    end
    object lPersonName: TLabel
      Left = 9
      Top = 125
      Width = 66
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
    end
    object Label2: TLabel
      Left = 216
      Top = 16
      Width = 61
      Height = 13
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      FocusControl = edComment
    end
    object edGiveDate: TEdit
      Left = 8
      Top = 32
      Width = 73
      Height = 21
      Color = clInfoBk
      MaxLength = 10
      TabOrder = 0
    end
    object edPeriod: TEdit
      Left = 95
      Top = 32
      Width = 88
      Height = 21
      Color = clInfoBk
      MaxLength = 2
      TabOrder = 1
      Text = '0'
    end
    object cbOffices: TComboBox
      Left = 8
      Top = 84
      Width = 402
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 3
      Visible = False
    end
    object edOrgname: TEdit
      Left = 8
      Top = 84
      Width = 402
      Height = 21
      TabStop = False
      Color = clBtnFace
      MaxLength = 255
      ReadOnly = True
      TabOrder = 4
    end
    object btnSelectOrg: TButton
      Left = 334
      Top = 109
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 5
    end
    object edContacter: TEdit
      Left = 9
      Top = 141
      Width = 400
      Height = 21
      MaxLength = 100
      TabOrder = 6
      Visible = False
    end
    object cbPeople: TComboBox
      Left = 8
      Top = 141
      Width = 402
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 7
    end
    object edComment: TEdit
      Left = 215
      Top = 32
      Width = 194
      Height = 21
      MaxLength = 100
      TabOrder = 2
    end
    object udPeriod: TUpDown
      Left = 183
      Top = 32
      Width = 15
      Height = 21
      Associate = edPeriod
      Min = 1
      Position = 1
      TabOrder = 8
      TabStop = True
    end
  end
  object gbBack: TGroupBox
    Left = 0
    Top = 174
    Width = 419
    Height = 63
    Align = alTop
    Caption = #1042#1086#1079#1074#1088#1072#1090
    TabOrder = 3
    object Label6: TLabel
      Left = 8
      Top = 16
      Width = 76
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
      FocusControl = edBackDate
    end
    object edBackDate: TEdit
      Left = 8
      Top = 32
      Width = 73
      Height = 21
      Color = clInfoBk
      MaxLength = 10
      TabOrder = 0
    end
  end
end
