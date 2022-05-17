object EzAutoCADImport: TEzAutoCADImport
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object OpenDialog1: TOpenDialog
    DefaultExt = '.dwg'
    Filter = 
      'AutoCAD '#1092#1072#1081#1083#1099' (*.dwg, *.dxf)|*.dwg;*.dxf|AutoCAD '#1088#1080#1089#1091#1085#1086#1082' (*.dwg)' +
      '|*.dwg|AutoCAD '#1092#1072#1081#1083' '#1086#1073#1084#1077#1085#1072' (*.dxf)|*.dxf'
    Options = [ofReadOnly, ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' '#1087#1088#1086#1077#1082#1090#1072
    Left = 64
    Top = 16
  end
  object EzDxfImport1: TEzDxfImport
    ConfirmProjectionSystem = False
    ExplodeBlocks = False
    UseTrueType = True
    ImportBlocks = False
    Left = 144
    Top = 24
  end
end
