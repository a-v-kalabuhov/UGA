inherited RegionsForm: TRegionsForm
  Left = 13
  Top = 107
  Width = 517
  Height = 299
  Caption = #1056#1072#1081#1086#1085#1099
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 509
  end
  inherited Grid: TkaDBGrid
    Width = 509
    Height = 230
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NAME_PREP'
        Title.Caption = #1055#1088#1077#1076#1083#1086#1078#1085#1099#1081' '#1087#1072#1076#1077#1078' ('#1075#1076#1077'?)'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ID'
        Title.Caption = #1055#1086#1088#1103#1076#1086#1082' '#1074#1074#1086#1076#1072
        Visible = False
      end>
  end
  inherited Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
  end
  inherited UpdateSQL: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM REGIONS'
      'WHERE ID=:ID')
    ModifySQL.Strings = (
      'UPDATE REGIONS SET'
      'NAME=:NAME,'
      'NAME_PREP=:NAME_PREP'
      'WHERE ID=:OLD_ID')
    InsertSQL.Strings = (
      'INSERT INTO REGIONS'
      '(ID, NAME, NAME_PREP)'
      'VALUES (:ID, :NAME, :NAME_PREP)')
    DeleteSQL.Strings = (
      'DELETE FROM REGIONS'
      'WHERE ID=:OLD_ID')
  end
  inherited Query: TIBQuery
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT ID, NAME, NAME_PREP'
      'FROM REGIONS')
    GeneratorField.Field = 'ID'
    GeneratorField.Generator = 'REGIONS_GEN'
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
