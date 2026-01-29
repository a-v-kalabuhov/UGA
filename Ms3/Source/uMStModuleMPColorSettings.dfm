object mstMPColorSettingsModule: TmstMPColorSettingsModule
  OldCreateOrder = False
  Height = 278
  Width = 286
  object ibtLineColors: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = MStIBXMapMngr.dbKis
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommit
    Left = 32
    Top = 22
  end
  object ibqLineColors: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = ibtLineColors
    AutoCalcFields = False
    SQL.Strings = (
      'SELECT *'
      'FROM '
      '     MASTER_PLAN_LAYERS'
      'ORDER BY ID')
    Left = 32
    Top = 70
    object ibqLineColorsID: TIntegerField
      FieldName = 'ID'
      Origin = '"MASTER_PLAN_LAYERS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ibqLineColorsNAME: TIBStringField
      FieldName = 'NAME'
      Origin = '"MASTER_PLAN_LAYERS"."NAME"'
      Required = True
      Size = 255
    end
    object ibqLineColorsIS_GROUP: TSmallintField
      FieldName = 'IS_GROUP'
      Origin = '"MASTER_PLAN_LAYERS"."IS_GROUP"'
    end
    object ibqLineColorsGROUP_ID: TIntegerField
      FieldName = 'GROUP_ID'
      Origin = '"MASTER_PLAN_LAYERS"."GROUP_ID"'
    end
    object ibqLineColorsLINE_COLOR: TIBStringField
      FieldName = 'LINE_COLOR'
      Origin = '"MASTER_PLAN_LAYERS"."LINE_COLOR"'
      OnGetText = ibqLineColorsLINE_COLORGetText
      Size = 10
    end
  end
  object updLineColors: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM '
      '     MASTER_PLAN_LAYERS'
      'WHERE ID=:ID')
    ModifySQL.Strings = (
      'UPDATE MASTER_PLAN_LAYERS'
      'SET LINE_COLOR = :LINE_COLOR'
      'WHERE ID = :ID')
    Left = 32
    Top = 118
  end
  object dsLineColors: TDataSource
    DataSet = ibqLineColors
    Left = 32
    Top = 182
  end
  object ibqLineEdging: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = ibtLineColors
    AutoCalcFields = False
    SQL.Strings = (
      'SELECT *'
      'FROM '
      '     MASTER_PLAN_OBJECT_STATUSES'
      'ORDER BY ID')
    UpdateObject = updLineEdging
    Left = 120
    Top = 70
    object ibqLineEdgingID: TIntegerField
      FieldName = 'ID'
      Origin = '"MASTER_PLAN_OBJECT_STATUSES"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ibqLineEdgingNAME: TIBStringField
      FieldName = 'NAME'
      Origin = '"MASTER_PLAN_OBJECT_STATUSES"."NAME"'
      Size = 25
    end
    object ibqLineEdgingHAS_BACKCOLOR: TSmallintField
      FieldName = 'HAS_BACKCOLOR'
      Origin = '"MASTER_PLAN_OBJECT_STATUSES"."HAS_BACKCOLOR"'
    end
    object ibqLineEdgingBACKCOLOR: TIntegerField
      FieldName = 'BACKCOLOR'
      Origin = '"MASTER_PLAN_OBJECT_STATUSES"."BACKCOLOR"'
      OnGetText = ibqLineEdgingBACKCOLORGetText
    end
  end
  object updLineEdging: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  ID,'
      '  NAME,'
      '  HAS_BACKCOLOR,'
      '  BACKCOLOR'
      'from MASTER_PLAN_OBJECT_STATUSES '
      'where'
      '  ID = :ID')
    ModifySQL.Strings = (
      'update MASTER_PLAN_OBJECT_STATUSES'
      'set'
      '  BACKCOLOR = :BACKCOLOR,'
      '  HAS_BACKCOLOR = :HAS_BACKCOLOR'
      'where'
      '  ID = :OLD_ID')
    InsertSQL.Strings = (
      '')
    DeleteSQL.Strings = (
      '')
    Left = 120
    Top = 118
  end
  object dsLineEdging: TDataSource
    DataSet = ibqLineEdging
    Left = 120
    Top = 182
  end
  object ColorDialog1: TColorDialog
    CustomColors.Strings = (
      'aaa')
    Options = [cdFullOpen, cdAnyColor]
    Left = 120
    Top = 22
  end
end
