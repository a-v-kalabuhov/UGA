object WorkTypesForm: TWorkTypesForm
  Left = 132
  Top = 90
  ActiveControl = Grid
  Caption = #1042#1080#1076#1099' '#1088#1072#1073#1086#1090
  ClientHeight = 244
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    491
    244)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 330
    Top = 211
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 411
    Top = 211
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object Grid: TDBGrid
    Left = 6
    Top = 8
    Width = 480
    Height = 197
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = GridDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'CODE'
        Title.Caption = #1050#1086#1076
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SHORT_NAME'
        Title.Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 345
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRICE'
        Title.Caption = #1062#1077#1085#1072
        Visible = True
      end>
  end
  object Query: TIBQuery
    Database = KisAppModule.Database
    Transaction = KisMainView.Transaction
    SQL.Strings = (
      'SELECT * FROM WORK_TYPES WHERE OFFICES_ID=:OFFICES_ID'
      'ORDER BY ID')
    Left = 296
    Top = 104
    ParamData = <
      item
        DataType = ftInteger
        Name = 'OFFICES_ID'
        ParamType = ptInput
        Value = '1'
      end>
    object QueryID: TSmallintField
      FieldName = 'ID'
    end
    object QueryNAME: TIBStringField
      FieldName = 'NAME'
      Origin = 'WORK_TYPES.NAME'
      Required = True
      Size = 302
    end
    object QueryPRICE: TFloatField
      FieldName = 'PRICE'
      DisplayFormat = '0.00,,'#39#39
    end
    object QueryARGUMENT: TIBStringField
      FieldName = 'ARGUMENT'
      Size = 100
    end
    object QueryCODE: TIBStringField
      FieldName = 'CODE'
      Origin = '"WORK_TYPES"."CODE"'
      Size = 10
    end
    object QuerySHORT_NAME: TIBStringField
      FieldName = 'SHORT_NAME'
      Origin = 'WORK_TYPES.SHORT_NAME'
      Required = True
      Size = 102
    end
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 296
    Top = 136
  end
end
