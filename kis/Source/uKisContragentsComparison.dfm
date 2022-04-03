object FmContragentsComparison: TFmContragentsComparison
  Left = 172
  Top = 409
  BorderStyle = bsDialog
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1074
  ClientHeight = 457
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbNewContragent: TGroupBox
    Left = 0
    Top = 0
    Width = 331
    Height = 407
    Caption = #1053#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090
    TabOrder = 0
    object ValueListEditorNew: TValueListEditor
      Left = 2
      Top = 15
      Width = 327
      Height = 390
      Align = alClient
      DisplayOptions = []
      FixedCols = 1
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      TabOrder = 0
      OnDrawCell = ValueListEditorNewDrawCell
      RowHeights = (
        18)
    end
  end
  object gbOldContragent: TGroupBox
    Left = 333
    Top = 0
    Width = 331
    Height = 407
    Caption = #1057#1090#1072#1088#1099#1081' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090
    TabOrder = 1
    object ValueListEditorOld: TValueListEditor
      Left = 2
      Top = 15
      Width = 327
      Height = 390
      Align = alClient
      DisplayOptions = []
      FixedCols = 1
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
      TabOrder = 0
      OnDrawCell = ValueListEditorOldDrawCell
      ColWidths = (
        159
        160)
    end
  end
  object btnSaveNew: TButton
    Left = 7
    Top = 414
    Width = 99
    Height = 39
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
    ModalResult = 1
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    WordWrap = True
  end
  object btnBackToOld: TButton
    Left = 550
    Top = 414
    Width = 107
    Height = 39
    Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1089#1090#1072#1088#1086#1084#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
    ModalResult = 2
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    WordWrap = True
  end
end
