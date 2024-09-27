object mstMasterPlanModule: TmstMasterPlanModule
  OldCreateOrder = False
  Height = 285
  Width = 667
  object IBTransaction1: TIBTransaction
    DefaultDatabase = MStIBXMapMngr.dbKis
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    AutoStopAction = saCommit
    Left = 32
    Top = 16
  end
  object IBQuery1: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = IBTransaction1
    SQL.Strings = (
      'SELECT '
      
        '       PRJS.ID AS PROJECT_ID, PRJS.ADDRESS, PRJS.DOC_NUMBER, PRJ' +
        'S.DOC_DATE, PRJS.CONFIRMED, PRJS.CONFIRM_DATE,'
      
        '       LINES.ID AS LINE_ID, LINES.INFO, LINES.DIAMETER, LINES.VO' +
        'LTAGE,'
      '       LAYERS.ID AS LAYER_ID, LAYERS.NAME AS LAYER_NAME,'
      '       ORGS2.NAME AS CUSTOMER, ORGS1.NAME AS EXECUTOR'
      'FROM'
      '    PROJECT_LINES LINES'
      '    LEFT JOIN'
      
        '    PROJECT_LAYERS LAYERS ON (LINES.PROJECT_LAYERS_ID = LAYERS.I' +
        'D)'
      '    LEFT JOIN'
      '    PROJECTS PRJS ON (LINES.PROJECTS_ID = PROJECTS.ID)'
      '    LEFT JOIN'
      '    LICENSED_ORGS ORGS1 ON (PRJS.EXECUTOR_ORGS_ID = ORGS1.ID)'
      '    LEFT JOIN'
      '    LICENSED_ORGS ORGS2 ON (PRJS.CUSTOMER_ORGS_ID = ORGS2.ID)')
    UpdateObject = IBUpdateSQL1
    Left = 72
    Top = 16
  end
  object IBUpdateSQL1: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT '
      
        '       PRJS.ID AS PROJECT_ID, PRJS.ADDRESS, PRJS.DOC_NUMBER, PRJ' +
        'S.DOC_DATE, PRJS.CONFIRMED, PRJS.CONFIRM_DATE,'
      
        '       LINES.ID AS LINE_ID, LINES.INFO, LINES.DIAMETER, LINES.VO' +
        'LTAGE,'
      '       LAYERS.ID AS LAYER_ID, LAYERS.NAME AS LAYER_NAME,'
      '       ORGS2.NAME AS CUSTOMER, ORGS1.NAME AS EXECUTOR'
      'FROM'
      '    PROJECT_LINES LINES'
      '    LEFT JOIN'
      
        '    PROJECT_LAYERS LAYERS ON (LINES.PROJECT_LAYERS_ID = LAYERS.I' +
        'D)'
      '    LEFT JOIN'
      '    PROJECTS PRJS ON (LINES.PROJECTS_ID = PROJECTS.ID)'
      '    LEFT JOIN'
      '    LICENSED_ORGS ORGS1 ON (PRJS.EXECUTOR_ORGS_ID = ORGS1.ID)'
      '    LEFT JOIN'
      '    LICENSED_ORGS ORGS2 ON (PRJS.CUSTOMER_ORGS_ID = ORGS2.ID)'
      'WHERE '
      '    PRJS.ID=:PROJECT_ID')
    Left = 104
    Top = 16
  end
end
