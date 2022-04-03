object mstOrdersDataModule: TmstOrdersDataModule
  OldCreateOrder = False
  Height = 150
  Width = 241
  object trKis: TIBTransaction
    Left = 24
    Top = 80
  end
  object ibqOrders: TIBQuery
    Transaction = trKis
    SQL.Strings = (
      'SELECT ID, ORDER_NUMBER, ORDER_DATE, OBJECT_ADDRESS'
      'FROM ORDERS'
      
        'WHERE (PEOPLE_ID=:PEOPLE_ID) AND (CLOSED <> 1) AND (CANCELLED <>' +
        ' 1)'
      'ORDER BY ORDER_DATE, ORDER_NUMBER, OBJECT_ADDRESS')
    Left = 24
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PEOPLE_ID'
        ParamType = ptUnknown
      end>
  end
  object ibqMaps: TIBQuery
    Transaction = trKis
    SQL.Strings = (
      'SELECT ID, NOMENCLATURE'
      'FROM ORDER_MAPS'
      'WHERE (ORDERS_ID=:ORDERS_ID)'
      'ORDER BY NOMENCLATURE')
    Left = 72
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ORDERS_ID'
        ParamType = ptUnknown
      end>
  end
end
