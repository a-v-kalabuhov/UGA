object mstLotDataModule: TmstLotDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 179
  Width = 214
  object ibqOwners: TIBQuery
    Transaction = Transaction
    SQL.Strings = (
      
        'SELECT A.ALLOTMENTS_ID, A.ID, A.FIRMS_ID, A.NAME, A.PERCENT, A.P' +
        'URPOSE, A.PROP_FORMS_ID, A.RENT_PERIOD, B.NAME AS PROP_FORMS_NAM' +
        'E, B.NAME_ACC AS PROP_FORMS_NAME_ACC'
      
        'FROM ALLOTMENT_OWNERS A LEFT JOIN PROP_FORMS B ON A.PROP_FORMS_I' +
        'D=B.ID'
      'WHERE A.ALLOTMENTS_ID=:ID')
    Left = 128
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
  end
  object ibqDocs: TIBQuery
    Transaction = Transaction
    SQL.Strings = (
      'SELECT *'
      'FROM ALLOTMENT_DOCS'
      'WHERE ALLOTMENTS_ID=:ID'
      'ORDER BY DOC_DATE')
    Left = 72
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
  end
  object Transaction: TIBTransaction
    Left = 24
    Top = 80
  end
  object ibqLot: TIBQuery
    Transaction = Transaction
    SQL.Strings = (
      
        'SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.YEAR_NUMBER, A.INFORMAT' +
        'ION, A.CHECKED, A.CANCELLED, A.CANCELLED_INFO, A.ERROR_COORD, A.' +
        'ADDRESS, A.REGIONS_ID, A.DOCUMENTS, A.INFO_LANDSCAPE, A.INFO_REA' +
        'LTY, A.INFO_MONUMENT, A.INFO_MINERALS, A.INFO_FLORA, A.AREA, A.E' +
        'XECUTOR, A.INSERT_NAME, A.INSERT_TIME, B.NAME AS REGIONS_NAME, B' +
        '.NAME_PREP AS REGIONS_NAME_PREP, A.PARENT_NUMBER, A.CHILD_NUMBER' +
        ', A.VERSION, A.DECREE_PREPARED, A.BOUNDARY_PROJECT_PREPARED, A.A' +
        'NNUL_DATE, A.NEW_NUMBER, A.NOMENCLATURA, A.NEIGHBOURS, A.PZ, A.D' +
        'ESCRIPTION, A.ACCOMPLISHMENT_AREA, A.TEMP_BUILDING_AREA,'
      'A.CREATOR, A.LINK_CONSULTANT'
      'FROM ALLOTMENTS A LEFT JOIN REGIONS B ON A.REGIONS_ID=B.ID'
      'WHERE A.ID=:ID')
    Left = 16
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
  end
end
