inherited AddressWorksForm: TAddressWorksForm
  Caption = #1042#1080#1076#1099' '#1072#1076#1088#1077#1089#1085#1099#1093' '#1088#1072#1073#1086#1090
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TkaDBGrid
    Columns = <
      item
        Expanded = False
        FieldName = 'WORK_NAME'
        Title.Caption = #1042#1080#1076' '#1088#1072#1073#1086#1090#1099
        Visible = True
      end>
  end
  inherited UpdateSQL: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM ADDRESS_WORKS'
      'WHERE WORK_NAME=:WORK_NAME')
    ModifySQL.Strings = (
      'UPDATE ADDRESS_WORKS'
      'SET WORK_NAME=:WORK_NAME'
      'WHERE WORK_NAME=:OLD_WORK_NAME')
    InsertSQL.Strings = (
      'INSERT INTO ADDRESS_WORKS'
      '(WORK_NAME)'
      'VALUES (:WORK_NAME)')
    DeleteSQL.Strings = (
      'DELETE FROM ADDRESS_WORKS'
      'WHERE WORK_NAME=:WORK_NAME')
  end
  inherited Query: TIBQuery
    SQL.Strings = (
      'SELECT WORK_NAME'
      'FROM ADDRESS_WORKS')
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
