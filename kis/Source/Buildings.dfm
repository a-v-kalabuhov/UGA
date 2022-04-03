object BuildingsForm: TBuildingsForm
  Left = 346
  Top = 170
  ActiveControl = edtFind
  BorderStyle = bsDialog
  Caption = #1057#1090#1088#1086#1077#1085#1080#1103
  ClientHeight = 368
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnAdd: TSpeedButton
    Left = 224
    Top = 226
    Width = 70
    Height = 23
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    OnClick = btnAddClick
  end
  object btnDelete: TSpeedButton
    Left = 224
    Top = 256
    Width = 70
    Height = 24
    Caption = #1059#1076#1072#1083#1080#1090#1100
    OnClick = btnDeleteClick
  end
  object Label1: TLabel
    Left = 16
    Top = 3
    Width = 89
    Height = 13
    Caption = #1058#1077#1082#1089#1090' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
  end
  object edtFind: TEdit
    Left = 14
    Top = 18
    Width = 95
    Height = 21
    TabOrder = 0
    OnChange = edtFindChange
  end
  object btnOk: TButton
    Left = 224
    Top = 15
    Width = 70
    Height = 23
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 224
    Top = 45
    Width = 70
    Height = 24
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object Grid: TDBGrid
    Left = 2
    Top = 41
    Width = 217
    Height = 309
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyPress = GridKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MARKING_NAME'
        Title.Caption = #1057#1086#1082#1088'.'
        Width = 93
        Visible = True
      end>
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 349
    Width = 297
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object btnSave: TButton
    Left = 224
    Top = 294
    Width = 70
    Height = 23
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object btnDontAdd: TButton
    Left = 224
    Top = 323
    Width = 70
    Height = 24
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 6
    OnClick = btnDontAddClick
  end
  object Query: TIBQuery
    Database = KisAppModule.Database
    Transaction = Transaction
    AfterCancel = QueryAfterPost
    AfterInsert = QueryAfterInsert
    AfterPost = QueryAfterPost
    BeforeDelete = QueryBeforeDelete
    BeforeEdit = QueryBeforeInsert
    BeforeInsert = QueryBeforeInsert
    SQL.Strings = (
      'SELECT A.*, B.SHORT_NAME '
      'FROM BUILDINGS A, BUILDING_MARKING B'
      'WHERE A.STREETS_ID=:STREETS_ID AND A.MARKING_ID=B.ID'
      'ORDER BY A.NAME')
    UpdateObject = UpdateSQL
    GeneratorField.Field = 'ID'
    GeneratorField.Generator = 'BUILDINGS_GEN'
    Left = 32
    Top = 104
    ParamData = <
      item
        DataType = ftInteger
        Name = 'STREETS_ID'
        ParamType = ptUnknown
        Value = '7'
      end>
    object QuerySTREETS_ID: TIntegerField
      FieldName = 'STREETS_ID'
      Origin = 'BUILDINGS.STREETS_ID'
      Required = True
    end
    object QueryNAME: TIBStringField
      FieldName = 'NAME'
      Origin = '"BUILDINGS"."NAME"'
      Size = 10
    end
    object QueryMARKING_ID: TIntegerField
      FieldName = 'MARKING_ID'
      Origin = 'BUILDINGS.MARKING_ID'
      Required = True
    end
    object QueryMARKING_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'MARKING_NAME'
      LookupDataSet = ibqMarking
      LookupKeyFields = 'ID'
      LookupResultField = 'NAME'
      KeyFields = 'MARKING_ID'
      Size = 10
      Lookup = True
    end
    object QuerySHORT_NAME: TIBStringField
      FieldName = 'SHORT_NAME'
      Origin = 'BUILDING_MARKING.SHORT_NAME'
      Size = 10
    end
    object QueryID: TIntegerField
      FieldName = 'ID'
      Origin = 'BUILDINGS.ID'
      Required = True
    end
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 32
    Top = 168
  end
  object UpdateSQL: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  STREETS_ID,'
      '  NAME,'
      '  MARKING_ID,'
      '  ID'
      'from BUILDINGS '
      'where'
      '  ID = :ID')
    ModifySQL.Strings = (
      'update BUILDINGS'
      'set'
      '  STREETS_ID = :STREETS_ID,'
      '  NAME = :NAME,'
      '  MARKING_ID = :MARKING_ID'
      'where'
      '  ID = :OLD_ID')
    InsertSQL.Strings = (
      'insert into BUILDINGS'
      '  (ID, STREETS_ID, NAME, MARKING_ID)'
      'values'
      '  (:ID, :STREETS_ID, :NAME, :MARKING_ID)')
    DeleteSQL.Strings = (
      'delete from BUILDINGS'
      'where'
      '  ID = :OLD_ID')
    Left = 32
    Top = 136
  end
  object ibqMarking: TIBQuery
    Database = KisAppModule.Database
    Transaction = Transaction
    AfterCancel = QueryAfterPost
    AfterInsert = QueryAfterInsert
    AfterPost = QueryAfterPost
    BeforeDelete = QueryBeforeDelete
    BeforeEdit = QueryBeforeInsert
    BeforeInsert = QueryBeforeInsert
    SQL.Strings = (
      'SELECT *'
      'FROM BUILDING_MARKING'
      'ORDER BY SHORT_NAME')
    Left = 72
    Top = 104
    object ibqMarkingID: TIntegerField
      FieldName = 'ID'
      Origin = 'BUILDING_MARKING.ID'
      Required = True
    end
    object ibqMarkingSHORT_NAME: TIBStringField
      FieldName = 'SHORT_NAME'
      Origin = 'BUILDING_MARKING.SHORT_NAME'
      Size = 10
    end
    object ibqMarkingNAME: TIBStringField
      FieldName = 'NAME'
      Origin = 'BUILDING_MARKING.NAME'
      Size = 30
    end
  end
  object Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 160
    Top = 8
  end
end
