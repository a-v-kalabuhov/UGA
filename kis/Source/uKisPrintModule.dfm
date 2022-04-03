object KisPrintModule: TKisPrintModule
  OldCreateOrder = False
  Height = 526
  Width = 339
  object frReport: TfrReport
    InitialZoom = pzDefault
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    RebuildPrinter = False
    Left = 56
    Top = 8
    ReportForm = {19000000}
  end
  object frDesigner: TfrDesigner
    Left = 56
    Top = 72
  end
  object frDataSet: TfrDBDataSet
    Left = 56
    Top = 128
  end
  object RTFExport: TfrRTFExport
    ShowDialog = False
    ScaleX = 1.000000000000000000
    ScaleY = 1.000000000000000000
    KillEmptyLines = False
    ExportFrames = True
    ExportBitmaps = True
    Left = 56
    Top = 184
  end
  object DialogControls: TfrDialogControls
    Left = 56
    Top = 248
  end
  object CSVExport: TfrCSVExport
    ScaleX = 1.000000000000000000
    ScaleY = 1.000000000000000000
    Delimiter = ';'
    Left = 56
    Top = 304
  end
  object frDataSetAdditional: TfrDBDataSet
    Left = 56
    Top = 360
  end
  object ShapeObject: TfrShapeObject
    Left = 56
    Top = 416
  end
  object UserDataset: TfrUserDataset
    Left = 200
    Top = 16
  end
  object RtfAdvExport: TfrRtfAdvExport
    Left = 200
    Top = 72
  end
  object frCheckBoxObject: TfrCheckBoxObject
    Left = 200
    Top = 128
  end
end
