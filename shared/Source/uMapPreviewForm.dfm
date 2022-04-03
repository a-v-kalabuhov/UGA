object kaMapPreviewForm: TkaMapPreviewForm
  Left = 58
  Top = 146
  Width = 783
  Height = 540
  Caption = 'kaMapPreviewForm'
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  MinimizeApp = False
  PixelsPerInch = 96
  TextHeight = 14
  object PreviewBox: TEzPreviewBox
    Left = 144
    Top = 72
    Width = 497
    Height = 377
    UseThread = False
    TabOrder = 0
    About = 'EzGIS Version 1.95 (Ene, 2003)'
    GISList = <>
    PaperSize = psPrinter
    PaperWidth = 209.973333333333400000
    PaperHeight = 296.968333333333300000
    Orientation = poPortrait
    ShowPrinterMargins = True
    PaperUnits = suMms
    PrintMode = pmAll
    ShadowBrush.Color = clBlack
    NoPickFilter = []
    SnapToGuidelinesDist = 1.000000000000000000
    ScreenGrid.Step.X = 1.000000000000000000
    ScreenGrid.Step.Y = 1.000000000000000000
    GridInfo.Grid.X = 1.000000000000000000
    GridInfo.Grid.Y = 1.000000000000000000
    GridInfo.GridColor = clMaroon
    GridInfo.DrawAsCross = True
    GridInfo.GridSnap.X = 0.500000000000000000
    GridInfo.GridSnap.Y = 0.500000000000000000
    RubberPen.Color = clRed
    RubberPen.Mode = pmXor
    FlatScrollBar = False
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 775
    Height = 29
    Caption = 'ToolBar'
    TabOrder = 1
  end
  object CmdLine: TEzCmdLine
    Left = 0
    Top = 489
    Width = 775
    Height = 24
    About = 'EzGIS Version 1.95 (Ene, 2003)'
    DrawBoxList = <>
    DynamicUpdate = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Color = clWhite
    Align = alBottom
    TabOrder = 2
    TabStop = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 775
    Height = 30
    Align = alTop
    AutoSize = True
    TabOrder = 3
    object EzHRuler1: TEzHRuler
      Left = 1
      Top = 1
      Width = 773
      Height = 28
      Align = alTop
      About = 'EzGIS Version 1.95 (Ene, 2003)'
      PreviewBox = PreviewBox
      RubberPenColor = clAqua
      MarksColor = clOlive
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 59
    Width = 35
    Height = 430
    Align = alLeft
    AutoSize = True
    TabOrder = 4
    object EzVRuler1: TEzVRuler
      Left = 1
      Top = 1
      Width = 33
      Height = 428
      Align = alLeft
      About = 'EzGIS Version 1.95 (Ene, 2003)'
      PreviewBox = PreviewBox
      MarksColor = clOlive
    end
  end
  object ActionList: TActionList
    Left = 664
    Top = 176
  end
  object MainMenu: TMainMenu
    Left = 664
    Top = 72
  end
end
