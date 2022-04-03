object StreetForm: TStreetForm
  Left = 16
  Top = 17
  ActiveControl = dbeName
  BorderStyle = bsDialog
  Caption = #1059#1083#1080#1094#1072
  ClientHeight = 418
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 8
    Top = 83
    Width = 112
    Height = 13
    Caption = #1057#1090#1072#1088#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object Label3: TLabel
    Left = 8
    Top = 45
    Width = 30
    Height = 13
    Caption = #1056#1072#1081#1086#1085
  end
  object Label4: TLabel
    Left = 188
    Top = 45
    Width = 42
    Height = 13
    Caption = #1055#1086#1089#1077#1083#1086#1082
  end
  object Label5: TLabel
    Left = 376
    Top = 83
    Width = 44
    Height = 13
    Caption = #1059#1076#1072#1083#1077#1085#1072
  end
  object Label6: TLabel
    Left = 8
    Top = 121
    Width = 49
    Height = 13
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object Label7: TLabel
    Left = 429
    Top = 83
    Width = 40
    Height = 13
    Caption = #1054#1096#1080#1073#1082#1072
  end
  object Label8: TLabel
    Left = 376
    Top = 8
    Width = 18
    Height = 13
    Caption = #1058#1080#1087
  end
  object btnOk: TButton
    Left = 8
    Top = 392
    Width = 70
    Height = 23
    Caption = '&'#1054#1050
    TabOrder = 10
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 84
    Top = 391
    Width = 71
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 11
  end
  object dbeName: TDBEdit
    Left = 8
    Top = 23
    Width = 362
    Height = 21
    DataField = 'NAME'
    DataSource = StreetsForm.DataSource
    TabOrder = 0
  end
  object dbeNameOld: TDBEdit
    Left = 8
    Top = 98
    Width = 362
    Height = 21
    DataField = 'NAME_LATER'
    DataSource = StreetsForm.DataSource
    TabOrder = 3
  end
  object dbeRegionsName: TDBLookupComboBox
    Left = 8
    Top = 60
    Width = 174
    Height = 21
    DataField = 'REGIONS_ID'
    DataSource = StreetsForm.DataSource
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsRegions
    TabOrder = 1
  end
  object dbeVillagesName: TDBLookupComboBox
    Left = 188
    Top = 60
    Width = 174
    Height = 21
    DataField = 'VILLAGES_ID'
    DataSource = StreetsForm.DataSource
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsVillages
    TabOrder = 2
  end
  object dbeKillState: TDBEdit
    Left = 376
    Top = 98
    Width = 47
    Height = 21
    DataField = 'KILL_STATE'
    DataSource = StreetsForm.DataSource
    TabOrder = 4
  end
  object dbmAbout: TDBMemo
    Left = 8
    Top = 135
    Width = 543
    Height = 99
    DataField = 'ABOUT'
    DataSource = StreetsForm.DataSource
    ScrollBars = ssBoth
    TabOrder = 7
    WordWrap = False
  end
  object dbeError: TDBEdit
    Left = 429
    Top = 98
    Width = 47
    Height = 21
    DataField = 'ERROR'
    DataSource = StreetsForm.DataSource
    TabOrder = 5
  end
  object dbcbUga: TDBCheckBox
    Left = 489
    Top = 98
    Width = 46
    Height = 16
    Caption = #1059#1043#1040
    DataField = 'UGA'
    DataSource = StreetsForm.DataSource
    TabOrder = 6
    ValueChecked = '1'
    ValueUnchecked = '0'
  end
  object gbCreateDoc: TGroupBox
    Left = 8
    Top = 241
    Width = 543
    Height = 69
    Caption = #1057#1086#1079#1076#1072#1074#1096#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
    TabOrder = 8
    object edtCreateDoc: TEdit
      Left = 8
      Top = 15
      Width = 527
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object btnCreateSelect: TButton
      Left = 8
      Top = 37
      Width = 70
      Height = 24
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 1
      OnClick = btnCreateSelectClick
    end
    object btnCreateDetail: TButton
      Left = 83
      Top = 37
      Width = 71
      Height = 24
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
      TabOrder = 2
      OnClick = btnCreateDetailClick
    end
    object btnCreateClear: TButton
      Left = 158
      Top = 37
      Width = 71
      Height = 24
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 3
      OnClick = btnCreateClearClick
    end
  end
  object gbKillDoc: TGroupBox
    Left = 8
    Top = 317
    Width = 543
    Height = 68
    Caption = #1059#1076#1072#1083#1080#1074#1096#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
    TabOrder = 9
    object edtKillDoc: TEdit
      Left = 8
      Top = 15
      Width = 527
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object btnKillSelect: TButton
      Left = 8
      Top = 37
      Width = 70
      Height = 24
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 1
      OnClick = btnKillSelectClick
    end
    object btnKillClear: TButton
      Left = 158
      Top = 37
      Width = 71
      Height = 24
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 3
      OnClick = btnKillClearClick
    end
    object btnKillDetail: TButton
      Left = 83
      Top = 37
      Width = 71
      Height = 24
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086
      TabOrder = 2
      OnClick = btnKillDetailClick
    end
  end
  object btnBuildings: TButton
    Left = 482
    Top = 392
    Width = 70
    Height = 23
    Caption = #1057#1090#1088#1086#1077#1085#1080#1103
    TabOrder = 12
    OnClick = btnBuildingsClick
  end
  object dbeMarking: TDBLookupComboBox
    Left = 376
    Top = 23
    Width = 175
    Height = 21
    DataField = 'STREET_MARKING_ID'
    DataSource = StreetsForm.DataSource
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsMarking
    TabOrder = 13
  end
  object ibqDecrees: TIBQuery
    Database = KisAppModule.Database
    Transaction = AllotmentForm.ibtrReports
    SQL.Strings = (
      
        'SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.INT_NUMBER, A.INT_DATE,' +
        ' A.HEADER, A.CHECKED, A.CONTENT, A.YEAR_NUMBER, A.DECREE_TYPES_I' +
        'D, B.NAME AS DECREE_TYPES_NAME'
      
        'FROM DECREES A LEFT JOIN DECREE_TYPES B ON A.DECREE_TYPES_ID=B.I' +
        'D'
      'WHERE A.ID=:ID')
    Left = 264
    Top = 176
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ID'
        ParamType = ptUnknown
      end>
  end
  object ibqMarking: TIBQuery
    Database = KisAppModule.Database
    Transaction = AllotmentForm.ibtrReports
    SQL.Strings = (
      'SELECT ID, NAME FROM STREET_MARKING'
      'ORDER BY NAME')
    Left = 328
    Top = 56
  end
  object ibqVillages: TIBQuery
    Database = KisAppModule.Database
    Transaction = AllotmentForm.ibtrReports
    SQL.Strings = (
      'SELECT ID, NAME FROM VILLAGES'
      'ORDER BY NAME')
    Left = 296
    Top = 56
  end
  object ibqRegions: TIBQuery
    Database = KisAppModule.Database
    Transaction = AllotmentForm.ibtrReports
    SQL.Strings = (
      'SELECT ID, NAME FROM REGIONS'
      'ORDER BY NAME')
    Left = 264
    Top = 56
  end
  object dsRegions: TDataSource
    DataSet = ibqRegions
    Left = 264
    Top = 96
  end
  object dsVillages: TDataSource
    DataSet = ibqVillages
    Left = 296
    Top = 96
  end
  object dsMarking: TDataSource
    DataSet = ibqMarking
    Left = 328
    Top = 96
  end
end
