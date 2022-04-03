inherited KisMap500Editor: TKisMap500Editor
  Left = 209
  Top = 184
  ActiveControl = edNomenclature
  Caption = 'KisMap500Editor'
  ClientHeight = 487
  ClientWidth = 498
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 504
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 63
    Top = 457
    ExplicitLeft = 63
    ExplicitTop = 457
  end
  inherited btnOk: TButton
    Left = 334
    Top = 455
    ExplicitLeft = 334
    ExplicitTop = 455
  end
  inherited btnCancel: TButton
    Left = 415
    Top = 455
    Default = True
    ExplicitLeft = 415
    ExplicitTop = 455
  end
  object pcMap500: TPageControl [3]
    Left = 0
    Top = 0
    Width = 498
    Height = 449
    ActivePage = tbMapCase
    Align = alTop
    TabOrder = 2
    object tbMapCase: TTabSheet
      Caption = #1055#1083#1072#1085#1096#1077#1090
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 8
        Top = 0
        Width = 73
        Height = 13
        Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
      end
      object Label2: TLabel
        Left = 200
        Top = 0
        Width = 76
        Height = 13
        Caption = #1043#1086#1076' '#1079#1072#1074#1077#1076#1077#1085#1080#1103
        FocusControl = edOriginYear
      end
      object Label3: TLabel
        Left = 8
        Top = 40
        Width = 182
        Height = 13
        Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103', '#1079#1072#1074#1086#1076#1080#1074#1096#1072#1103' '#1087#1083#1072#1085#1096#1077#1090
        FocusControl = cbOriginOrg
      end
      object Label4: TLabel
        Left = 8
        Top = 80
        Width = 77
        Height = 13
        Caption = #1058#1080#1087' '#1087#1086#1076#1086#1089#1085#1086#1074#1099
        FocusControl = edBasisType
      end
      object Label5: TLabel
        Left = 152
        Top = 80
        Width = 36
        Height = 13
        Caption = #1057#1090#1072#1090#1091#1089
        FocusControl = cbStatus
      end
      object Label6: TLabel
        Left = 264
        Top = 80
        Width = 107
        Height = 13
        Caption = #1044#1072#1090#1072' '#1072#1085#1085#1091#1083#1080#1088#1086#1074#1072#1085#1080#1103
        FocusControl = edAnnulDate
      end
      object Label7: TLabel
        Left = 288
        Top = 0
        Width = 84
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1087#1083#1072#1085#1096#1077#1090#1072
        FocusControl = edNumber
      end
      object edOriginYear: TEdit
        Left = 200
        Top = 16
        Width = 57
        Height = 21
        Color = clInfoBk
        TabOrder = 3
      end
      object cbOriginOrg: TComboBox
        Left = 8
        Top = 56
        Width = 478
        Height = 21
        Color = clInfoBk
        ItemHeight = 0
        MaxLength = 300
        Sorted = True
        TabOrder = 5
      end
      object edBasisType: TComboBox
        Left = 8
        Top = 96
        Width = 137
        Height = 21
        Color = clInfoBk
        ItemHeight = 0
        MaxLength = 50
        TabOrder = 6
      end
      object cbStatus: TCheckBox
        Left = 152
        Top = 95
        Width = 97
        Height = 23
        TabStop = False
        Caption = #1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1077#1085
        Checked = True
        State = cbChecked
        TabOrder = 7
        OnClick = cbStatusClick
      end
      object edAnnulDate: TEdit
        Left = 264
        Top = 96
        Width = 73
        Height = 21
        TabOrder = 8
      end
      object cbScanStatus: TCheckBox
        Left = 392
        Top = 98
        Width = 97
        Height = 17
        Caption = #1054#1090#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085
        TabOrder = 9
      end
      object edNumber: TEdit
        Left = 288
        Top = 16
        Width = 57
        Height = 21
        Color = clInfoBk
        MaxLength = 10
        TabOrder = 4
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 120
        Width = 489
        Height = 297
        Caption = #1057#1087#1080#1089#1086#1082' '#1074#1099#1076#1072#1095#1080
        TabOrder = 10
        object dbgGivenMapList: TDBGrid
          Left = 2
          Top = 15
          Width = 485
          Height = 242
          Align = alTop
          DataSource = dsGivenMap
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = dbgGivenMapListExit
          Columns = <
            item
              Expanded = False
              FieldName = 'ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MAP_500_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'DATE_OF_BACK'
              Title.Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088'.'
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATE_OF_GIVE'
              Title.Caption = #1044#1072#1090#1072' '#1074#1099#1076'.'
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DEFINITION_NUMBER'
              Title.Caption = #8470' '#1088#1072#1079#1088#1077#1096'-'#1103
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'GIVEN_OBJECT'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'HOLDER'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'HOLDER_NAME'
              Title.Caption = #1050#1086#1084#1091' '#1074#1099#1076#1072#1085
              Width = 96
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PEOPLE_NAME'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
              Width = 30
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ORDERS_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'LICENSED_ORGS_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'PEOPLE_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'PERSON_WHO_GIVE'
              Title.Caption = #1042#1099#1076#1072#1083
              Width = 108
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PERSON_WHO_GIVE_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'TERM_OF_GIVE'
              Title.Caption = #1057#1088#1086#1082
              Width = 34
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ADDRESS'
              Title.Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1088#1072#1073#1086#1090
              Width = 134
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OFFICES_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'ORDER_NUMBER'
              Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
              Width = 75
              Visible = True
            end>
        end
        object btnGiveMap: TButton
          Left = 192
          Top = 264
          Width = 107
          Height = 25
          Caption = #1042#1099#1076#1072#1090#1100' '#1087#1083#1072#1085#1096#1077#1090
          TabOrder = 1
          OnClick = btnGiveMapClick
        end
        object btnDeleteGivenMap: TButton
          Left = 400
          Top = 264
          Width = 75
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnDeleteGivenMapClick
        end
        object btnBack: TButton
          Left = 312
          Top = 264
          Width = 75
          Height = 25
          Caption = #1055#1088#1080#1085#1103#1090#1100
          TabOrder = 3
        end
      end
      object edNomenclature: TEdit
        Left = 8
        Top = 16
        Width = 36
        Height = 21
        CharCase = ecUpperCase
        Color = clInfoBk
        MaxLength = 6
        TabOrder = 0
        OnKeyDown = edNomenclatureKeyDown
        OnKeyPress = edNomenclatureKeyPress
      end
      object edNom2: TEdit
        Left = 43
        Top = 16
        Width = 36
        Height = 21
        CharCase = ecUpperCase
        Color = clInfoBk
        MaxLength = 6
        TabOrder = 1
        OnKeyDown = edNom2KeyDown
        OnKeyPress = edNom2KeyPress
      end
      object edNom3: TEdit
        Left = 78
        Top = 16
        Width = 28
        Height = 21
        CharCase = ecUpperCase
        Color = clInfoBk
        MaxLength = 2
        TabOrder = 2
        OnKeyPress = edNom3KeyPress
      end
    end
    object tbHistory: TTabSheet
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1087#1083#1072#1085#1096#1077#1090#1072
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 490
        Height = 421
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object dbgHistoryList: TDBGrid
          Left = 2
          Top = 2
          Width = 486
          Height = 274
          Align = alTop
          DataSource = dsMapHistory
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = dbgHistoryListExit
          Columns = <
            item
              Expanded = False
              FieldName = 'ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MAP_500_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'CHIEF'
              Title.Caption = #1053#1072#1095#1072#1083#1100#1085#1080#1082' '#1087#1072#1088#1090#1080#1080
              Width = 103
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CURRENT_CHANGES_MAPPING'
              Title.Caption = #1054#1073#1089#1083#1077#1076#1086#1074#1072#1085#1080#1077' '#1080' '#1089#1098#1077#1084#1082#1072' '#1090#1077#1082#1091#1097#1080#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'DATE_OF_ACCEPT'
              Title.Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1082#1080' '#1088#1072#1073#1086#1090' '#1075#1077#1086#1089#1083#1091#1078#1073#1086#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'DATE_OF_WORKS'
              Title.Caption = #1044#1072#1090#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1088#1072#1073#1086#1090
              Width = 137
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DRAFT_WORKS_EXECUTOR'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1095#1077#1088#1090#1077#1078#1085#1099#1093' '#1088#1072#1073#1086#1090
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'ENGIN_NET_MAPPING'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072' '#1080#1085#1078#1077#1085#1077#1088#1085#1099#1093' '#1089#1077#1090#1077#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'HIGH_RISE_MAPPING'
              Title.Caption = #1042#1099#1089#1086#1090#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'HORIZONTAL_MAPPING'
              Title.Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MENS_MAPPING'
              Title.Caption = #1052#1077#1085#1079#1091#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'NEWLY_BUILDING_MAPPING'
              Title.Caption = #1057#1098#1077#1084#1082#1072' '#1074#1085#1086#1074#1100' '#1074#1099#1089#1090#1088#1086#1077#1085#1085#1099#1093' '#1079#1076#1072#1085#1080#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'ORDER_NUMBER'
              Title.Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
              Width = 72
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TACHEOMETRIC_MAPPING'
              Title.Caption = #1058#1072#1093#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'TOTAL_SUM'
              Title.Caption = #1042#1089#1077#1075#1086
              Width = 32
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'WORKS_EXECUTOR'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1087#1086#1083#1077#1074#1099#1093' '#1088#1072#1073#1086#1090
              Width = 153
              Visible = True
            end>
        end
        object btnAddHistory: TButton
          Left = 232
          Top = 288
          Width = 75
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnAddHistoryClick
        end
        object btnDeleteHistory: TButton
          Left = 312
          Top = 288
          Width = 75
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnDeleteHistoryClick
        end
        object btnEditHistory: TButton
          Left = 392
          Top = 288
          Width = 75
          Height = 25
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 3
        end
        object Panel2: TPanel
          Left = 8
          Top = 280
          Width = 137
          Height = 137
          TabOrder = 4
          object pbPreview: TPaintBox
            Left = 1
            Top = 1
            Width = 135
            Height = 135
            Align = alClient
          end
        end
      end
    end
    object tbScan: TTabSheet
      Caption = #1057#1087#1080#1089#1086#1082' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgScanningList: TDBGrid
        Left = 0
        Top = 0
        Width = 490
        Height = 369
        Align = alTop
        DataSource = dsScanning
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = dbgScanningListExit
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'MAP_500_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'DATE_OF_SCAN'
            Title.Caption = #1044#1072#1090#1072
            Width = 47
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OFFICES_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ORDER_NUMBER'
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OFFICE_NAME'
            Title.Caption = #1054#1090#1076#1077#1083
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'WORK_TYPE'
            Title.Caption = #1042#1080#1076' '#1088#1072#1073#1086#1090#1099
            Width = 145
            Visible = True
          end>
      end
      object btnAddScan: TButton
        Left = 248
        Top = 384
        Width = 75
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnAddScanClick
      end
      object btnDeleteScan: TButton
        Left = 328
        Top = 384
        Width = 75
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
        OnClick = btnDeleteScanClick
      end
      object btnEditScann: TButton
        Left = 408
        Top = 384
        Width = 75
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 3
      end
    end
  end
  object dsGivenMap: TDataSource
    Left = 236
    Top = 336
  end
  object dsMapHistory: TDataSource
    Left = 276
    Top = 336
  end
  object dsScanning: TDataSource
    Left = 316
    Top = 344
  end
end
