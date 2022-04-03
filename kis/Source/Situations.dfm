inherited SituationsForm: TSituationsForm
  Caption = #1057#1085#1080#1084#1072#1077#1084#1072#1103' '#1089#1080#1090#1091#1072#1094#1080#1103
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  inherited Grid: TkaDBGrid
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    Columns = <
      item
        Expanded = False
        FieldName = 'DOC_NUMBER'
        Title.Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DOC_DATE'
        Title.Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CUSTOMER'
        Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADDRESS'
        Title.Caption = #1040#1076#1088#1077#1089
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'YEAR_NUMBER'
        Title.Caption = #1043#1086#1076' '#1080' '#1085#1086#1084#1077#1088
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'X'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Y'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AZIMUTH'
        Title.Caption = #1040#1079#1080#1084#1091#1090
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EXECUTOR'
        Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ID'
        Title.Caption = #1055#1086#1088#1103#1076#1086#1082' '#1074#1074#1086#1076#1072
        Visible = False
      end>
  end
  inherited ActionList: TActionList
    inherited actShow: TAction
      OnExecute = actShowExecute
    end
  end
  inherited Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
  end
  inherited UpdateSQL: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM T_SITUATION'
      'WHERE ID=:ID')
    ModifySQL.Strings = (
      'UPDATE T_SITUATION'
      'SET'
      'DOC_NUMBER=:DOC_NUMBER,'
      'DOC_DATE=:DOC_DATE,'
      'CUSTOMER=:CUSTOMER,'
      'ADDRESS=:ADDRESS,'
      'X=:X,'
      'Y=:Y,'
      'AZIMUTH=:AZIMUTH,'
      'EXECUTOR=:EXECUTOR,'
      'X_ORIENTIR=:X_ORIENTIR,'
      'Y_ORIENTIR=:Y_ORIENTIR'
      'WHERE ID=:OLD_ID')
    InsertSQL.Strings = (
      'INSERT INTO T_SITUATION(ID, DOC_NUMBER)'
      'VALUES (:ID, :DOC_NUMBER)')
    DeleteSQL.Strings = (
      'DELETE FROM T_SITUATION'
      'WHERE ID=:OLD_ID')
  end
  inherited Query: TIBQuery
    Database = KisAppModule.Database
    AfterInsert = QueryAfterInsert
    SQL.Strings = (
      
        'SELECT ID, DOC_NUMBER, DOC_DATE, CUSTOMER, ADDRESS, X, Y, AZIMUT' +
        'H, YEAR_NUMBER, EXECUTOR, X_ORIENTIR, Y_ORIENTIR'
      'FROM T_SITUATION')
    GeneratorField.Field = 'ID'
    GeneratorField.Generator = 'T_SITUATION_GEN'
    object QueryID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object QueryDOC_NUMBER: TSmallintField
      FieldName = 'DOC_NUMBER'
    end
    object QueryDOC_DATE: TDateTimeField
      FieldName = 'DOC_DATE'
    end
    object QueryCUSTOMER: TIBStringField
      FieldName = 'CUSTOMER'
      Size = 120
    end
    object QueryADDRESS: TIBStringField
      FieldName = 'ADDRESS'
      Size = 120
    end
    object QueryX: TFloatField
      FieldName = 'X'
      DisplayFormat = '0.00'
    end
    object QueryY: TFloatField
      FieldName = 'Y'
      DisplayFormat = '0.00'
    end
    object QueryAZIMUTH: TFloatField
      FieldName = 'AZIMUTH'
      DisplayFormat = '0.00'
    end
    object QueryYEAR_NUMBER: TIBStringField
      FieldKind = fkInternalCalc
      FieldName = 'YEAR_NUMBER'
      ReadOnly = True
      Size = 12
    end
    object QueryEXECUTOR: TIBStringField
      FieldName = 'EXECUTOR'
      Size = 30
    end
    object QueryX_ORIENTIR: TFloatField
      FieldName = 'X_ORIENTIR'
      Origin = '"T_SITUATION"."X_ORIENTIR"'
    end
    object QueryY_ORIENTIR: TFloatField
      FieldName = 'Y_ORIENTIR'
      Origin = '"T_SITUATION"."Y_ORIENTIR"'
    end
  end
  inherited Legend: TkaLegend
    Items = <>
  end
  object ibsMaxNumber: TIBSQL
    Database = KisAppModule.Database
    ParamCheck = True
    SQL.Strings = (
      'SELECT MAX(DOC_NUMBER)'
      'FROM T_SITUATION'
      
        'WHERE EXTRACT(YEAR FROM DOC_DATE)=EXTRACT(YEAR FROM CURRENT_DATE' +
        ')')
    Transaction = Transaction
    Left = 248
    Top = 56
  end
end
