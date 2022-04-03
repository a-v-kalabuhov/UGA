object mstStatDataModule: TmstStatDataModule
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ibqPeople: TIBQuery
    Transaction = trKis
    SQL.Strings = (
      'SELECT ID, FULL_NAME, OFFICES_ID FROM PEOPLE ORDER BY FULL_NAME')
    Left = 16
    Top = 24
  end
  object ibqOffices: TIBQuery
    Transaction = trKis
    SQL.Strings = (
      'SELECT ID, NAME FROM OFFICES ORDER BY NAME')
    Left = 64
    Top = 24
  end
  object ibqStats: TIBQuery
    Transaction = trGeo
    Left = 112
    Top = 24
  end
  object trKis: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    Left = 32
    Top = 72
  end
  object trGeo: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    Left = 112
    Top = 72
  end
end
