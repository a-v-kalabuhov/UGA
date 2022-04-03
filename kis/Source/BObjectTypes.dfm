inherited BObjectTypesForm: TBObjectTypesForm
  Caption = #1058#1080#1087#1099' '#1086#1073#1098#1077#1082#1090#1086#1074
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TkaDBGrid
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Visible = True
      end>
  end
  inherited Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
  end
  inherited UpdateSQL: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM B_OBJECT_TYPES'
      'WHERE ID=:ID')
    ModifySQL.Strings = (
      'UPDATE B_OBJECT_TYPES'
      'SET'
      'NAME=:NAME'
      'WHERE ID=:OLD_ID')
    InsertSQL.Strings = (
      'INSERT INTO B_OBJECT_TYPES'
      '(ID, NAME)'
      'VALUES (:ID, :NAME)')
    DeleteSQL.Strings = (
      'DELETE FROM B_OBJECT_TYPES'
      'WHERE ID=:OLD_ID')
  end
  inherited Query: TIBQuery
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT ID, NAME'
      'FROM B_OBJECT_TYPES')
    GeneratorField.Field = 'ID'
    GeneratorField.Generator = 'B_OBJECT_TYPES_GEN'
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
