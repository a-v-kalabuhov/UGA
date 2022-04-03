inherited SignaturesForm: TSignaturesForm
  Left = 282
  Top = 335
  Caption = #1055#1086#1076#1087#1080#1089#1080
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TkaDBGrid
    Columns = <
      item
        Expanded = False
        FieldName = 'SIGNATURE'
        Title.Caption = #1055#1086#1076#1087#1080#1089#1100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DOC_ORDER'
        Title.Caption = #1055#1086#1088#1103#1076#1086#1082
        Visible = True
      end>
  end
  inherited Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
  end
  inherited UpdateSQL: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM SIGNATURES'
      'WHERE SIGNATURE=:SIGNATURE')
    ModifySQL.Strings = (
      'UPDATE SIGNATURES'
      'SET SIGNATURE=:SIGNATURE,'
      'DOC_ORDER=:DOC_ORDER'
      'WHERE SIGNATURE=:OLD_SIGNATURE')
    InsertSQL.Strings = (
      'INSERT INTO SIGNATURES'
      '(SIGNATURE, DOC_ORDER)'
      'VALUES (:SIGNATURE, :DOC_ORDER)')
    DeleteSQL.Strings = (
      'DELETE FROM SIGNATURES'
      'WHERE SIGNATURE=:OLD_SIGNATURE')
  end
  inherited Query: TIBQuery
    Database = KisAppModule.Database
    AfterInsert = QueryAfterInsert
    SQL.Strings = (
      'SELECT SIGNATURE, DOC_ORDER'
      'FROM SIGNATURES')
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
