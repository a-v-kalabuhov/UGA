object mstParametersModule: TmstParametersModule
  OldCreateOrder = False
  Height = 150
  Width = 215
  object trKis: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    Left = 16
    Top = 16
  end
  object ibqParameters: TIBQuery
    Transaction = trKis
    SQL.Strings = (
      'SELECT * FROM PARAMETERS')
    Left = 64
    Top = 16
  end
  object ibqWatermark: TIBQuery
    Transaction = trKis
    SQL.Strings = (
      'SELECT * FROM WATERMARK_PARAMETERS')
    Left = 136
    Top = 16
  end
end
