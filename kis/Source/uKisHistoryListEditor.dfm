inherited KisMapHistoryEditor: TKisMapHistoryEditor
  Left = 256
  Top = 166
  Caption = 'KisMapHistoryEditor'
  ClientHeight = 560
  ClientWidth = 529
  Position = poDesktopCenter
  OnShow = FormShow
  ExplicitTop = 1
  ExplicitWidth = 535
  ExplicitHeight = 592
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 31
    Top = 533
    ExplicitLeft = 31
    ExplicitTop = 533
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
    FocusControl = edOrderNumber
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 48
    Width = 133
    Height = 13
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1088#1072#1073#1086#1090
    FocusControl = edDateOfWorks
  end
  object Label13: TLabel [3]
    Left = 8
    Top = 130
    Width = 146
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1087#1086#1083#1077#1074#1099#1093' '#1088#1072#1073#1086#1090
    FocusControl = edWorksExecutor
  end
  object Label14: TLabel [4]
    Left = 8
    Top = 173
    Width = 160
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1095#1077#1088#1090#1077#1078#1085#1099#1093' '#1088#1072#1073#1086#1090
    FocusControl = edDraftWorksExecutor
  end
  object Label15: TLabel [5]
    Left = 8
    Top = 214
    Width = 244
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1100#1085#1080#1082' '#1087#1072#1088#1090#1080#1080' ('#1075#1088#1091#1087#1087#1099'), '#1087#1088#1080#1085#1103#1074#1096#1080#1081' '#1088#1072#1073#1086#1090#1091
    FocusControl = edChief
  end
  object Label16: TLabel [6]
    Left = 8
    Top = 89
    Width = 167
    Height = 13
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1082#1080' '#1088#1072#1073#1086#1090' '#1075#1077#1086#1089#1083#1091#1078#1073#1086#1081
    FocusControl = edDateOfAccept
  end
  inherited btnOk: TButton
    Left = 365
    Top = 527
    TabOrder = 2
    ExplicitLeft = 365
    ExplicitTop = 527
  end
  inherited btnCancel: TButton
    Left = 446
    Top = 527
    TabOrder = 3
    ExplicitLeft = 446
    ExplicitTop = 527
  end
  object edOrderNumber: TEdit [9]
    Left = 8
    Top = 24
    Width = 73
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 0
    Text = 'edOrderNumber'
  end
  object edDateOfWorks: TEdit [10]
    Left = 8
    Top = 64
    Width = 73
    Height = 21
    Color = clInfoBk
    TabOrder = 1
  end
  object gbArea: TGroupBox [11]
    Left = 8
    Top = 256
    Width = 513
    Height = 265
    Caption = #1055#1083#1086#1097#1072#1076#1100' '#1089#1098#1077#1084#1082#1080
    TabOrder = 4
    object Label3: TLabel
      Left = 16
      Top = 16
      Width = 122
      Height = 13
      Caption = #1047#1072#1089#1090#1088#1086#1077#1085#1072#1103' '#1090#1077#1088#1088#1080#1090#1086#1088#1080#1103
    end
    object Label6: TLabel
      Left = 272
      Top = 16
      Width = 140
      Height = 13
      Caption = #1053#1077#1079#1072#1089#1090#1088#1086#1077#1085#1085#1072#1103' '#1090#1077#1088#1088#1080#1090#1086#1088#1080#1103
    end
    object Label9: TLabel
      Left = 16
      Top = 142
      Width = 226
      Height = 13
      Caption = #1054#1073#1089#1083#1077#1076#1086#1074#1072#1085#1080#1077' '#1080' '#1089#1098#1077#1084#1082#1072' '#1090#1077#1082#1091#1097#1080#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      FocusControl = edCurrentChangesMapping
    end
    object Label10: TLabel
      Left = 16
      Top = 172
      Width = 273
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072' '#1074#1085#1086#1074#1100' '#1074#1099#1089#1090#1088#1086#1077#1085#1085#1085#1099#1093' '#1079#1076#1072#1085#1080#1081
      FocusControl = edNewlyBuildingMapping
    end
    object Label11: TLabel
      Left = 16
      Top = 202
      Width = 222
      Height = 13
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072' '#1080#1085#1078#1077#1085#1077#1088#1085#1099#1093' '#1089#1077#1090#1077#1081
      FocusControl = edEnginNetMapping
    end
    object Label12: TLabel
      Left = 16
      Top = 232
      Width = 238
      Height = 13
      Caption = #1042#1089#1077#1075#1086'___________________________________'
      FocusControl = edTotalSum
    end
    object Panel1: TPanel
      Left = 16
      Top = 32
      Width = 225
      Height = 97
      TabOrder = 0
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 122
        Height = 13
        Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
        FocusControl = edHorizMapping
      end
      object Label5: TLabel
        Left = 8
        Top = 48
        Width = 88
        Height = 13
        Caption = #1042#1099#1089#1086#1090#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
        FocusControl = edHighRiseMapping
      end
      object edHighRiseMapping: TEdit
        Left = 8
        Top = 64
        Width = 201
        Height = 21
        MaxLength = 20
        TabOrder = 1
        Text = 'edHighRiseMapping'
      end
      object edHorizMapping: TEdit
        Left = 8
        Top = 24
        Width = 201
        Height = 21
        TabOrder = 0
        Text = 'edHorizMapping'
      end
    end
    object Panel2: TPanel
      Left = 272
      Top = 32
      Width = 225
      Height = 97
      TabOrder = 1
      object Label7: TLabel
        Left = 8
        Top = 8
        Width = 106
        Height = 13
        Caption = #1052#1077#1085#1079#1091#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
        FocusControl = edMensMapping
      end
      object Label8: TLabel
        Left = 8
        Top = 48
        Width = 134
        Height = 13
        Caption = #1058#1072#1093#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1089#1098#1077#1084#1082#1072
        FocusControl = edTacheomMapping
      end
      object edMensMapping: TEdit
        Left = 8
        Top = 24
        Width = 201
        Height = 21
        MaxLength = 20
        TabOrder = 0
        Text = 'edMensMapping'
      end
      object edTacheomMapping: TEdit
        Left = 8
        Top = 64
        Width = 201
        Height = 21
        MaxLength = 20
        TabOrder = 1
        Text = 'edTacheomMapping'
      end
    end
    object edCurrentChangesMapping: TEdit
      Left = 296
      Top = 140
      Width = 201
      Height = 21
      Color = clInfoBk
      MaxLength = 20
      TabOrder = 2
      Text = 'edCurrentChangesMapping'
    end
    object edNewlyBuildingMapping: TEdit
      Left = 296
      Top = 168
      Width = 201
      Height = 21
      MaxLength = 20
      TabOrder = 3
      Text = 'edNewlyBuildingMapping'
    end
    object edEnginNetMapping: TEdit
      Left = 264
      Top = 196
      Width = 233
      Height = 21
      Color = clInfoBk
      MaxLength = 20
      TabOrder = 4
      Text = 'edEnginNetMapping'
    end
    object edTotalSum: TEdit
      Left = 264
      Top = 224
      Width = 233
      Height = 21
      Color = clInfoBk
      MaxLength = 20
      TabOrder = 5
      Text = 'edTotalSum'
    end
  end
  object edWorksExecutor: TEdit [12]
    Left = 8
    Top = 144
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 100
    TabOrder = 5
    Text = 'edWorksExecutor'
  end
  object edDraftWorksExecutor: TEdit [13]
    Left = 8
    Top = 187
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 100
    TabOrder = 6
    Text = 'edDraftWorksExecutor'
  end
  object edChief: TEdit [14]
    Left = 8
    Top = 229
    Width = 329
    Height = 21
    Color = clInfoBk
    MaxLength = 100
    TabOrder = 7
    Text = 'edChief'
  end
  object edDateOfAccept: TEdit [15]
    Left = 8
    Top = 104
    Width = 73
    Height = 21
    Color = clInfoBk
    TabOrder = 8
  end
  object gbGraphics: TGroupBox [16]
    Left = 344
    Top = 8
    Width = 177
    Height = 217
    Caption = #1043#1088#1072#1085#1080#1094#1099' '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1099#1093' '#1088#1072#1073#1086#1090
    TabOrder = 9
    object imgSurvey: TImage
      Left = 8
      Top = 16
      Width = 161
      Height = 161
    end
    object btnSetMap: TButton
      Left = 8
      Top = 184
      Width = 161
      Height = 25
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 0
    end
  end
end
