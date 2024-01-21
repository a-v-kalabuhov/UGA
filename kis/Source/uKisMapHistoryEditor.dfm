inherited KisMapHistoryEditor: TKisMapHistoryEditor
  Left = 256
  Top = 166
  BorderStyle = bsSizeable
  Caption = 'KisMapHistoryEditor'
  ClientHeight = 606
  ClientWidth = 899
  Constraints.MinHeight = 597
  Constraints.MinWidth = 839
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 915
  ExplicitHeight = 644
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 25
    Top = 578
    Margins.Bottom = 0
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 25
    ExplicitTop = 578
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 8
    Width = 95
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103
    FocusControl = edOrderNumber
  end
  object Label2: TLabel [2]
    Left = 117
    Top = 8
    Width = 101
    Height = 13
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1080#1079#1074'. '#1088#1072#1073#1086#1090
    FocusControl = edDateOfWorks
  end
  object Label13: TLabel [3]
    Left = 8
    Top = 92
    Width = 146
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1087#1086#1083#1077#1074#1099#1093' '#1088#1072#1073#1086#1090
    FocusControl = edWorksExecutor
  end
  object Label14: TLabel [4]
    Left = 8
    Top = 135
    Width = 160
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1095#1077#1088#1090#1077#1078#1085#1099#1093' '#1088#1072#1073#1086#1090
    FocusControl = edDraftWorksExecutor
  end
  object Label15: TLabel [5]
    Left = 8
    Top = 176
    Width = 140
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
    FocusControl = edChief
  end
  object Label16: TLabel [6]
    Left = 233
    Top = 8
    Width = 104
    Height = 13
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1082#1080' '#1088#1072#1073#1086#1090
    FocusControl = edDateOfAccept
  end
  object Label7: TLabel [7]
    Left = 8
    Top = 215
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
    FocusControl = edMensMapping
  end
  object lOrg: TLabel [8]
    Left = 8
    Top = 51
    Width = 157
    Height = 13
    Caption = #1051#1080#1094#1077#1085#1079#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    FocusControl = edOrg
  end
  object lOrgId: TLabel [9]
    Left = 592
    Top = 578
    Width = 30
    Height = 13
    Caption = 'lOrgId'
    Visible = False
  end
  inherited btnOk: TButton
    Left = 734
    Top = 573
    Anchors = [akRight, akBottom]
    Default = True
    TabOrder = 10
    ExplicitLeft = 734
    ExplicitTop = 573
  end
  inherited btnCancel: TButton
    Left = 815
    Top = 573
    Anchors = [akRight, akBottom]
    TabOrder = 11
    ExplicitLeft = 815
    ExplicitTop = 573
  end
  object edOrderNumber: TEdit [12]
    Left = 8
    Top = 24
    Width = 95
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 0
    Text = 'edOrderNumber'
  end
  object edDateOfWorks: TEdit [13]
    Left = 117
    Top = 24
    Width = 101
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 1
  end
  object gbArea: TGroupBox [14]
    Left = 8
    Top = 258
    Width = 329
    Height = 310
    Caption = #1055#1083#1086#1097#1072#1076#1100' '#1089#1098#1077#1084#1082#1080
    TabOrder = 8
    object Label9: TLabel
      Left = 8
      Top = 137
      Width = 226
      Height = 13
      Caption = #1054#1073#1089#1083#1077#1076#1086#1074#1072#1085#1080#1077' '#1080' '#1089#1098#1077#1084#1082#1072' '#1090#1077#1082#1091#1097#1080#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      FocusControl = edCurrentChangesMapping
    end
    object Label10: TLabel
      Left = 8
      Top = 179
      Width = 273
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072' '#1074#1085#1086#1074#1100' '#1074#1099#1089#1090#1088#1086#1077#1085#1085#1085#1099#1093' '#1079#1076#1072#1085#1080#1081
      FocusControl = edNewlyBuildingMapping
    end
    object Label11: TLabel
      Left = 8
      Top = 222
      Width = 222
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072' '#1080#1085#1078#1077#1085#1077#1088#1085#1099#1093' '#1089#1077#1090#1077#1081
      FocusControl = edEnginNetMapping
    end
    object Label12: TLabel
      Left = 8
      Top = 265
      Width = 28
      Height = 13
      Caption = #1042#1089#1077#1075#1086
      FocusControl = edTotalSum
    end
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 122
      Height = 13
      Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
      FocusControl = edHorizMapping
    end
    object Label5: TLabel
      Left = 8
      Top = 56
      Width = 88
      Height = 13
      Caption = #1042#1099#1089#1086#1090#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
      FocusControl = edHighRiseMapping
    end
    object Label8: TLabel
      Left = 8
      Top = 96
      Width = 134
      Height = 13
      Caption = #1058#1072#1093#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1089#1098#1077#1084#1082#1072
      FocusControl = edTacheomMapping
    end
    object edCurrentChangesMapping: TEdit
      Left = 8
      Top = 152
      Width = 313
      Height = 21
      Color = clInfoBk
      MaxLength = 300
      TabOrder = 3
      Text = 'edCurrentChangesMapping'
    end
    object edNewlyBuildingMapping: TEdit
      Left = 8
      Top = 195
      Width = 313
      Height = 21
      MaxLength = 300
      TabOrder = 4
      Text = 'edNewlyBuildingMapping'
    end
    object edEnginNetMapping: TEdit
      Left = 8
      Top = 238
      Width = 313
      Height = 21
      Color = clInfoBk
      MaxLength = 900
      TabOrder = 5
      Text = 'edEnginNetMapping'
    end
    object edTotalSum: TEdit
      Left = 8
      Top = 280
      Width = 313
      Height = 21
      Color = clInfoBk
      MaxLength = 300
      TabOrder = 6
      Text = 'edTotalSum'
    end
    object edHorizMapping: TEdit
      Left = 8
      Top = 29
      Width = 313
      Height = 21
      MaxLength = 300
      TabOrder = 0
      Text = 'edHorizMapping'
    end
    object edHighRiseMapping: TEdit
      Left = 8
      Top = 69
      Width = 313
      Height = 21
      MaxLength = 300
      TabOrder = 1
      Text = 'edHighRiseMapping'
    end
    object edTacheomMapping: TEdit
      Left = 8
      Top = 110
      Width = 313
      Height = 21
      MaxLength = 300
      TabOrder = 2
      Text = 'edTacheomMapping'
    end
  end
  object edWorksExecutor: TEdit [15]
    Left = 8
    Top = 106
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 300
    TabOrder = 5
    Text = 'edWorksExecutor'
  end
  object edDraftWorksExecutor: TEdit [16]
    Left = 8
    Top = 149
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 300
    TabOrder = 6
    Text = 'edDraftWorksExecutor'
  end
  object edChief: TEdit [17]
    Left = 8
    Top = 191
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 300
    TabOrder = 7
    Text = 'edChief'
  end
  object edDateOfAccept: TEdit [18]
    Left = 233
    Top = 24
    Width = 104
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 2
  end
  object gbGraphics: TGroupBox [19]
    Left = 343
    Top = 8
    Width = 552
    Height = 560
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1043#1088#1072#1085#1080#1094#1099' '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1099#1093' '#1088#1072#1073#1086#1090
    TabOrder = 9
    object imgSurvey: TImage
      Left = 9
      Top = 16
      Width = 535
      Height = 535
      Stretch = True
    end
  end
  object edMensMapping: TEdit [20]
    Left = 8
    Top = 230
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 1000
    TabOrder = 12
    Text = 'edMensMapping'
  end
  object btnSetMap: TButton [21]
    Left = 343
    Top = 573
    Width = 137
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1075#1088#1072#1085#1080#1094#1099
    TabOrder = 13
  end
  object edOrg: TEdit [22]
    Left = 8
    Top = 65
    Width = 248
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = 'edOrg'
    OnChange = edOrgChange
  end
  object btnOrg: TButton [23]
    Left = 262
    Top = 63
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 4
  end
end
