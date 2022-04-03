object mstOrderListForm: TmstOrderListForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1054#1090#1082#1088#1099#1090#1099#1077' '#1079#1072#1082#1072#1079#1099
  ClientHeight = 337
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    567
    337)
  PixelsPerInch = 96
  TextHeight = 13
  object lblOrders: TLabel
    Left = 8
    Top = 8
    Width = 93
    Height = 13
    Caption = #1054#1090#1082#1088#1099#1090#1099#1077' '#1079#1072#1082#1072#1079#1099
  end
  object lWarn: TLabel
    Left = 480
    Top = 96
    Width = 79
    Height = 52
    Caption = #1042#1099#1073#1088#1072#1085#1099' '#13#10#1087#1083#1072#1085#1096#1077#1090#1099', '#13#10#1082#1086#1090#1086#1088#1099#1093' '#1085#1077#1090' '#13#10#1074' '#1079#1072#1082#1072#1079#1077'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object grdOrders: TJvgStringGrid
    Left = 8
    Top = 24
    Width = 320
    Height = 305
    Cursor = crArrow
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultRowHeight = 20
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSelect]
    TabOrder = 0
    OnSelectCell = grdOrdersSelectCell
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = []
    ExtOptions = [fsgTabThroughCells]
    EditorFont.Charset = DEFAULT_CHARSET
    EditorFont.Color = clWindowText
    EditorFont.Height = -11
    EditorFont.Name = 'Tahoma'
    EditorFont.Style = []
    ColWidths = (
      64
      64
      64
      64
      64)
  end
  object grdMaps: TJvgStringGrid
    Left = 353
    Top = 24
    Width = 121
    Height = 305
    Cursor = crArrow
    Anchors = [akTop, akRight, akBottom]
    ColCount = 1
    DefaultColWidth = 80
    DefaultRowHeight = 20
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSelect]
    TabOrder = 1
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = []
    ExtOptions = [fsgHottrack, fsgMemoEditor, fsgWordWrap, fsgCellHeightAutoSize, fsgTabThroughCells]
    EditorFont.Charset = DEFAULT_CHARSET
    EditorFont.Color = clWindowText
    EditorFont.Height = -11
    EditorFont.Name = 'Tahoma'
    EditorFont.Style = []
    OnGetCellStyle = grdMapsGetCellStyle
    ColWidths = (
      121)
  end
  object btnOK: TButton
    Left = 484
    Top = 24
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 484
    Top = 55
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
