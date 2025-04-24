object mstClientMainForm: TmstClientMainForm
  Left = 35
  Top = 238
  Caption = #1055#1083#1072#1085#1096#1077#1090#1086#1093#1088#1072#1085#1080#1083#1080#1097#1077' 2.2'
  ClientHeight = 756
  ClientWidth = 1055
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter3: TSplitter
    Left = 850
    Top = 0
    Width = 5
    Height = 737
    Align = alRight
    ExplicitLeft = 876
    ExplicitHeight = 637
  end
  object Label3: TLabel
    Left = 488
    Top = 200
    Width = 31
    Height = 13
    Caption = 'Label3'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 737
    Width = 1055
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 200
      end
      item
        Width = 150
      end>
  end
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 850
    Height = 737
    Align = alClient
    Caption = 'pnMain'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 251
      Top = 52
      Width = 6
      Height = 660
      OnMoved = Splitter1Moved
      ExplicitHeight = 560
    end
    object ToolBar1: TToolBar
      Left = 1
      Top = 1
      Width = 848
      Height = 26
      AutoSize = True
      ButtonWidth = 24
      Color = cl3DLight
      Customizable = True
      DockSite = True
      DragKind = dkDock
      EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
      Images = ImageList
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Action = acZoomIn
        Grouped = True
      end
      object ToolButton2: TToolButton
        Left = 24
        Top = 0
        Action = acZoomOut
        Grouped = True
      end
      object ToolButton4: TToolButton
        Left = 48
        Top = 0
        Action = acZoomRect
      end
      object ToolButton23: TToolButton
        Left = 72
        Top = 0
        Action = acZoomSelect
      end
      object ToolButton15: TToolButton
        Left = 96
        Top = 0
        Action = acZoomPrev
      end
      object ToolButton11: TToolButton
        Left = 120
        Top = 0
        Action = acZoomAll
      end
      object ToolButton7: TToolButton
        Left = 144
        Top = 0
        Width = 8
        Caption = 'ToolButton7'
        ImageIndex = 7
        Style = tbsSeparator
      end
      object ToolButton5: TToolButton
        Left = 152
        Top = 0
        Action = acScroll
      end
      object ToolButton6: TToolButton
        Left = 176
        Top = 0
        Action = acSelect
      end
      object ToolButton8: TToolButton
        Left = 200
        Top = 0
        Width = 8
        Caption = 'ToolButton8'
        ImageIndex = 13
        Style = tbsSeparator
      end
      object tbLoadLots: TToolButton
        Left = 208
        Top = 0
        Action = acLoadLots
      end
      object tbLotProperties: TToolButton
        Left = 232
        Top = 0
        Action = acLotProperties
      end
      object tbLotsToTree: TToolButton
        Left = 256
        Top = 0
        Action = acLotInfo
      end
      object ToolButton22: TToolButton
        Left = 280
        Top = 0
        Action = acCoord
      end
      object tbMeasures: TToolButton
        Left = 304
        Top = 0
        Action = acCalc
      end
      object tbAerial: TToolButton
        Left = 328
        Top = 0
        Action = acAerial
      end
      object tbShowInvisibleLots: TToolButton
        Left = 352
        Top = 0
        Action = acShowInvisible
      end
      object tbReloadMaps: TToolButton
        Left = 376
        Top = 0
        Action = acReloadMaps
        Caption = 'o'
      end
      object ToolButton27: TToolButton
        Left = 400
        Top = 0
        Width = 8
        Caption = 'ToolButton27'
        ImageIndex = 23
        Style = tbsSeparator
      end
      object tbPrintPrepare: TToolButton
        Left = 408
        Top = 0
        Action = acPrintPrepare
      end
      object ToolButton21: TToolButton
        Left = 432
        Top = 0
        Width = 9
        Caption = 'ToolButton21'
        ImageIndex = 12
        Style = tbsSeparator
      end
      object tbExit: TToolButton
        Left = 441
        Top = 0
        Action = acExit
      end
    end
    object CmdLine: TEzCmdLine
      Left = 1
      Top = 712
      Width = 848
      Height = 24
      DrawBoxList = <
        item
          DrawBox = DrawBox
          Current = True
        end>
      ShowMeasureInfoWindow = False
      DynamicUpdate = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      Color = clWhite
      Align = alBottom
      TabOrder = 1
      TabStop = False
      Visible = False
      OnActionChange = CmdLineActionChange
      OnAfterCommand = CmdLineAfterCommand
    end
    object pnLeft: TPanel
      Left = 1
      Top = 52
      Width = 250
      Height = 660
      Align = alLeft
      TabOrder = 2
      object Splitter2: TSplitter
        Left = 1
        Top = 323
        Width = 248
        Height = 5
        Cursor = crVSplit
        Align = alTop
        OnMoved = Splitter1Moved
      end
      object TreeView: TTreeView
        Left = 1
        Top = 23
        Width = 248
        Height = 300
        Align = alTop
        BevelEdges = []
        BevelKind = bkTile
        BorderStyle = bsNone
        Color = clInfoBk
        HideSelection = False
        Images = ObjectsImageList
        Indent = 19
        MultiSelectStyle = []
        ParentShowHint = False
        PopupMenu = pmObjects
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        ToolTips = False
        OnChange = TreeViewChange
        OnClick = TreeViewClick
        OnMouseDown = TreeViewMouseDown
        OnMouseMove = TreeViewMouseMove
      end
      object ListView: TListView
        Left = 1
        Top = 353
        Width = 248
        Height = 306
        Align = alClient
        BevelEdges = []
        BorderStyle = bsNone
        Columns = <
          item
            Caption = #8470
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = 'X'
            Width = 70
          end
          item
            Alignment = taCenter
            Caption = 'Y'
            Width = 70
          end
          item
            Caption = #1044#1083#1080#1085#1072', '#1084
          end
          item
            Caption = #1040#1079#1080#1084#1091#1090', '#1075#1088#1072#1076'.'
          end>
        ColumnClick = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmCoords
        SmallImages = ImageList
        TabOrder = 1
        ViewStyle = vsReport
      end
      object ToolBar2: TToolBar
        Left = 1
        Top = 1
        Width = 248
        Height = 22
        Caption = 'ToolBar2'
        Images = ImageList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        object ToolButton13: TToolButton
          Left = 0
          Top = 0
          Action = acTreeClear
        end
        object ToolButton26: TToolButton
          Left = 23
          Top = 0
          Action = acTreeRemoveCurrent
        end
        object ToolButton24: TToolButton
          Left = 46
          Top = 0
          Action = acTreeLocate
        end
        object ToolButton29: TToolButton
          Left = 69
          Top = 0
          Action = acLotProperties
        end
        object ToolButton36: TToolButton
          Left = 92
          Top = 0
          Action = acTreeOnOfContour
        end
      end
      object ToolBar3: TToolBar
        Left = 1
        Top = 328
        Width = 248
        Height = 25
        Caption = 'ToolBar3'
        EdgeBorders = [ebTop, ebBottom]
        Images = ImageList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        object ToolButton40: TToolButton
          Left = 0
          Top = 0
          Action = acCopySelected
        end
        object ToolButton37: TToolButton
          Left = 23
          Top = 0
          Action = acCopyAll
        end
        object ToolButton42: TToolButton
          Left = 46
          Top = 0
          Action = acPastePoints
        end
        object ToolButton41: TToolButton
          Left = 69
          Top = 0
          Width = 8
          Caption = 'ToolButton41'
          ImageIndex = 39
          Style = tbsSeparator
        end
        object ToolButton45: TToolButton
          Left = 77
          Top = 0
          Action = acInsertPoint
        end
        object ToolButton43: TToolButton
          Left = 100
          Top = 0
          Action = acDeletePoint
        end
        object ToolButton44: TToolButton
          Left = 123
          Top = 0
          Action = acEditPoint
        end
        object ToolButton50: TToolButton
          Left = 146
          Top = 0
          Width = 8
          Caption = 'ToolButton50'
          ImageIndex = 44
          Style = tbsSeparator
        end
        object ToolButton51: TToolButton
          Left = 154
          Top = 0
          Action = acSavePointList
        end
      end
    end
    object pnCenter: TPanel
      Left = 257
      Top = 52
      Width = 592
      Height = 660
      Align = alClient
      Caption = 'pnCenter'
      TabOrder = 3
      object DrawBox: TEzDrawBox
        Left = 1
        Top = 52
        Width = 590
        Height = 607
        BorderStyle = bsNone
        UseThread = False
        Align = alClient
        TabOrder = 0
        DefaultScaleUnits = suMms
        StackedSelect = False
        SymbolMarker = 1
        SnapToGuidelinesDist = 1.000000000000000000
        ScreenGrid.Step.X = 1.000000000000000000
        ScreenGrid.Step.Y = 1.000000000000000000
        ShowMapExtents = False
        ShowLayerExtents = False
        GridInfo.Grid.X = 1.000000000000000000
        GridInfo.Grid.Y = 1.000000000000000000
        GridInfo.GridColor = clMaroon
        GridInfo.DrawAsCross = True
        GridInfo.GridSnap.X = 0.500000000000000000
        GridInfo.GridSnap.Y = 0.500000000000000000
        RubberPen.Color = clRed
        RubberPen.Mode = pmXor
        FlatScrollBar = False
        OnEndRepaint = DrawBoxEndRepaint
        OnMouseMove2D = DrawBoxMouseMove2D
        OnMouseDown2D = DrawBoxMouseDown2D
        OnMouseUp2D = DrawBoxMouseUp2D
        OnBeforeInsert = DrawBoxBeforeInsert
        OnAfterInsert = DrawBoxAfterInsert
        OnBeforeSelect = DrawBoxBeforeSelect
        OnAfterSelect = DrawBoxAfterSelect
        OnZoomChange = DrawBoxZoomChange
        OnCustomClick = DrawBoxCustomClick
      end
      object tbReport: TToolBar
        Left = 1
        Top = 26
        Width = 590
        Height = 26
        Color = cl3DLight
        EdgeBorders = [ebTop, ebBottom]
        Images = ImageList
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Transparent = False
        Visible = False
        object ToolButton28: TToolButton
          Left = 0
          Top = 0
          Width = 8
          Caption = 'ToolButton28'
          ImageIndex = 0
          Style = tbsSeparator
        end
        object tbPrintReport: TToolButton
          Left = 8
          Top = 0
          Action = acReportPrint
        end
        object tbCancelReport: TToolButton
          Left = 31
          Top = 0
          Action = acReportCancel
        end
        object tbPrinterSetUp: TToolButton
          Left = 54
          Top = 0
          Action = acReportPrinterSetUp
        end
        object ToolButton25: TToolButton
          Left = 77
          Top = 0
          Action = acReportPageSetup
          Visible = False
        end
        object ToolButton30: TToolButton
          Left = 100
          Top = 0
          Width = 12
          Caption = 'ToolButton30'
          ImageIndex = 0
          Style = tbsSeparator
        end
        object ToolButton31: TToolButton
          Left = 112
          Top = 0
          Action = acReportPageVisibility
        end
        object ToolButton32: TToolButton
          Left = 135
          Top = 0
          Action = acReportPrevPage
        end
        object ToolButton33: TToolButton
          Left = 158
          Top = 0
          Action = acReportNextPage
        end
        object ToolButton38: TToolButton
          Left = 181
          Top = 0
          Width = 11
          Caption = 'ToolButton38'
          ImageIndex = 66
          Style = tbsSeparator
        end
        object ToolButton34: TToolButton
          Left = 192
          Top = 0
          Action = acReportNumbersVisibility
        end
        object tbReportLines: TToolButton
          Left = 215
          Top = 0
          Action = acReportLotParams
        end
        object tbPointSize: TToolButton
          Left = 238
          Top = 0
          Action = acReportPointSize
        end
        object tbReportFont: TToolButton
          Left = 261
          Top = 0
          Action = acReportFont
        end
        object tbReportTableSettings: TToolButton
          Left = 284
          Top = 0
          Action = acReportTableSettings
        end
        object tbReportEditTable: TToolButton
          Left = 307
          Top = 0
          Action = acReportEditTable
        end
        object tbReportMoveArea: TToolButton
          Left = 330
          Top = 0
          Action = acReportMovePrintArea
        end
        object ToolButton35: TToolButton
          Left = 353
          Top = 0
          Action = acReportEditPrintArea
        end
        object cbReportScale: TComboBox
          Left = 376
          Top = 0
          Width = 72
          Height = 21
          Hint = #1052#1072#1089#1096#1090#1072#1073' '#1086#1090#1095#1077#1090#1072
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbReportScaleChange
          Items.Strings = (
            '1:500'
            '1:1000'
            '1:2000'
            '1:5000'
            '1:10000'
            '1:20000')
        end
        object ToolButton39: TToolButton
          Left = 448
          Top = 0
          Width = 11
          Caption = 'ToolButton39'
          ImageIndex = 66
          Style = tbsSeparator
        end
        object tbReportAddText: TToolButton
          Left = 459
          Top = 0
          Action = acReportAddText
        end
        object tbReportDeleteText: TToolButton
          Left = 482
          Top = 0
          Action = acReportDeleteText
        end
        object tbReportMoveText: TToolButton
          Left = 505
          Top = 0
          Action = acReportMoveText
        end
        object tbReportRotateText: TToolButton
          Left = 528
          Top = 0
          Action = acReportRotateText
        end
        object tbReportEditText: TToolButton
          Left = 551
          Top = 0
          Action = acReportEditText
        end
      end
      object tbSnaps: TToolBar
        Left = 1
        Top = 1
        Width = 590
        Height = 25
        Color = clMenu
        Customizable = True
        DockSite = True
        DragKind = dkDock
        EdgeBorders = [ebTop, ebBottom]
        Images = ImageList
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Visible = False
        object ToolButton20: TToolButton
          Left = 0
          Top = 0
          Width = 8
          Caption = 'ToolButton20'
          ImageIndex = 19
          Style = tbsSeparator
        end
        object ToolButton3: TToolButton
          Tag = 2
          Left = 8
          Top = 0
          Action = acSnapCenter
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton10: TToolButton
          Tag = 9
          Left = 31
          Top = 0
          Action = acSnapEnd
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton14: TToolButton
          Tag = 3
          Left = 54
          Top = 0
          Action = acSnapIntersect
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton16: TToolButton
          Tag = 1
          Left = 77
          Top = 0
          Action = acSnapMiddle
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton17: TToolButton
          Tag = 4
          Left = 100
          Top = 0
          Action = acSnapPerendicular
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton18: TToolButton
          Tag = 5
          Left = 123
          Top = 0
          Action = acSnapTangent
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton19: TToolButton
          Tag = 6
          Left = 146
          Top = 0
          Action = acSnapNearestVertex
          AllowAllUp = True
          Grouped = True
        end
        object ToolButton9: TToolButton
          Left = 169
          Top = 0
          Width = 8
          Caption = 'ToolButton9'
          ImageIndex = 19
          Style = tbsSeparator
        end
        object tbAccuDraw: TToolButton
          Left = 177
          Top = 0
          Action = acAccuDraw
        end
      end
    end
    object tbSearch: TToolBar
      AlignWithMargins = True
      Left = 1
      Top = 27
      Width = 848
      Height = 22
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      AutoSize = True
      Caption = 'tbSearch'
      Images = ImageList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      object ToolButton12: TToolButton
        Left = 0
        Top = 0
        Action = acMapByName
      end
      object ToolButton46: TToolButton
        Left = 23
        Top = 0
        Action = acFindAddress
      end
      object ToolButton47: TToolButton
        Left = 46
        Top = 0
        Action = acGoToPoint
      end
      object ToolButton48: TToolButton
        Left = 69
        Top = 0
        Action = acFindLotByAddress
      end
      object ToolButton49: TToolButton
        Left = 92
        Top = 0
        Action = acFindNomenNet
      end
      object Label1: TLabel
        Left = 115
        Top = 0
        Width = 67
        Height = 22
        Caption = '      '#1055#1083#1072#1085#1096#1077#1090':'
        Layout = tlCenter
      end
      object edtFastFindMap: TEdit
        Left = 182
        Top = 0
        Width = 60
        Height = 22
        TabOrder = 0
        Text = #1054'-X-1'
        OnEnter = edtFastFindMapEnter
        OnKeyPress = edtFastFindMapKeyPress
      end
      object tbFastFindMap: TToolButton
        Left = 242
        Top = 0
        Hint = #1053#1072#1081#1090#1080' '#1087#1083#1072#1085#1096#1077#1090' '#1087#1086' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1077
        Caption = #1053#1072#1081#1090#1080
        ImageIndex = 83
        OnClick = tbFastFindMapClick
      end
      object Label2: TLabel
        Left = 265
        Top = 0
        Width = 61
        Height = 22
        Caption = '        '#1054#1090#1074#1086#1076':'
        Layout = tlCenter
      end
      object edtFastFindLot: TEdit
        Left = 326
        Top = 0
        Width = 184
        Height = 22
        TabOrder = 1
        Text = #1072#1076#1088#1077#1089
        OnEnter = edtFastFindLotEnter
        OnKeyPress = edtFastFindLotKeyPress
      end
      object tbFastFindLot: TToolButton
        Left = 510
        Top = 0
        Hint = #1053#1072#1081#1090#1080' '#1086#1090#1074#1086#1076' '#1087#1086' '#1072#1076#1088#1077#1089#1091
        Caption = 'tbFastFindLot'
        ImageIndex = 83
        OnClick = tbFastFindLotClick
      end
    end
  end
  object pnRight: TPanel
    Left = 855
    Top = 0
    Width = 200
    Height = 737
    Align = alRight
    TabOrder = 2
    object LayersListBox: TCheckListBox
      Left = 1
      Top = 1
      Width = 198
      Height = 232
      Align = alTop
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 0
      Visible = False
    end
    object vstLayers: TVirtualStringTree
      Left = 1
      Top = 233
      Width = 198
      Height = 503
      Align = alClient
      CheckImageKind = ckSystemFlat
      Color = clInfoBk
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      NodeDataSize = 4
      TabOrder = 1
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      Columns = <>
    end
  end
  object MainMenu: TMainMenu
    Images = ImageList
    Left = 16
    Top = 256
    object miLayers: TMenuItem
      Caption = #1050#1072#1088#1090#1072
      object miCityLine: TMenuItem
        Action = acZoomIn
      end
      object miRegions: TMenuItem
        Action = acZoomOut
      end
      object miStreets: TMenuItem
        Action = acZoomRect
      end
      object N18: TMenuItem
        Action = acZoomSelect
      end
      object miZoomPrev: TMenuItem
        Action = acZoomPrev
      end
      object miZoomAll: TMenuItem
        Action = acZoomAll
      end
      object N5: TMenuItem
        Action = acSetScale
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N9: TMenuItem
        Action = acSelect
      end
      object miMaps: TMenuItem
        Action = acScroll
      end
      object N3: TMenuItem
        Action = acCalc
      end
      object N20: TMenuItem
        Action = acSnaps
        AutoCheck = True
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miAerial: TMenuItem
        Action = acAerial
      end
      object N45: TMenuItem
        Caption = '-'
      end
    end
    object N40: TMenuItem
      Caption = #1057#1083#1086#1080
      object acLayers1: TMenuItem
        Action = acLayers
      end
      object DXF1: TMenuItem
        Action = acExportToDXF
      end
      object N41: TMenuItem
        Action = acLayerBrowser
      end
    end
    object miFind: TMenuItem
      Caption = #1055#1086#1080#1089#1082
      object miLot: TMenuItem
        Action = acFindLotByAddress
        Caption = #1054#1090#1074#1086#1076' '#1087#1086' '#1072#1076#1088#1077#1089#1091
      end
      object miFindAdre: TMenuItem
        Action = acFindAddress
      end
      object N19: TMenuItem
        Action = acGoToPoint
      end
      object N21: TMenuItem
        Action = acMapByName
      end
      object N13001: TMenuItem
        Action = acFindNomenNet
      end
      object N42: TMenuItem
        Caption = #1050#1080#1086#1089#1082#1080
      end
    end
    object N46: TMenuItem
      Caption = #1055#1088#1086#1077#1082#1090#1099
      object N47: TMenuItem
        Action = acProjectAdd
      end
      object N49: TMenuItem
        Action = acProjectAdd2
      end
      object N48: TMenuItem
        Action = acProjectFindByAddress
      end
      object N50: TMenuItem
        Action = acProjectBrowse
        Caption = 'C'#1087#1080#1089#1086#1082' '#1087#1088#1086#1077#1082#1090#1086#1074'...'
      end
      object miProjectNetTypes: TMenuItem
        Caption = #1058#1080#1087#1099' '#1089#1077#1090#1077#1081
      end
      object midmif1: TMenuItem
        Action = acProjectExport
      end
    end
    object N51: TMenuItem
      Caption = #1057#1074#1086#1076#1085#1099#1081' '#1087#1083#1072#1085
      object N52: TMenuItem
        Caption = #1047#1072#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072
        object N55: TMenuItem
          Caption = #1055#1088#1086#1077#1082#1090#1085#1099#1077
          object DXF3: TMenuItem
            Caption = 'DXF...'
            OnClick = DXF3Click
          end
          object XLS1: TMenuItem
            Caption = 'XLS...'
            OnClick = XLS1Click
          end
        end
        object N56: TMenuItem
          Caption = #1053#1072#1085#1077#1089#1105#1085#1085#1099#1077
          object DXF4: TMenuItem
            Caption = #1092#1072#1081#1083' DXF...'
            OnClick = DXF4Click
          end
          object XLS2: TMenuItem
            Caption = #1092#1072#1081#1083' XLS...'
            OnClick = XLS2Click
          end
        end
      end
      object N53: TMenuItem
        Caption = #1057#1087#1080#1089#1086#1082' '#1089#1077#1090#1077#1081'...'
        OnClick = N53Click
      end
      object N54: TMenuItem
        Action = acMPClassSettings
      end
      object N57: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1094#1074#1077#1090#1072' '#1083#1080#1085#1080#1081'...'
        OnClick = N57Click
      end
      object N59: TMenuItem
        Caption = '-'
      end
      object N62: TMenuItem
        Action = acMPLoadRect
      end
      object N58: TMenuItem
        Action = acMPPickupPoints
      end
      object N60: TMenuItem
        Action = acSavePointList
      end
      object N61: TMenuItem
        Caption = '-'
      end
      object midmif2: TMenuItem
        Action = acMPExportMidMif
      end
    end
    object imMaps: TMenuItem
      Caption = #1055#1083#1072#1085#1096#1077#1090#1099
      object miAdd: TMenuItem
        Action = acAddMap
        Visible = False
      end
      object N25: TMenuItem
        Action = acChangeMap
        Visible = False
      end
      object N1: TMenuItem
        Caption = #1058#1072#1073#1083#1080#1094#1072' '#1087#1083#1072#1085#1096#1077#1090#1086#1074
        Visible = False
        object N22: TMenuItem
          Action = acAllMaps
        end
        object N23: TMenuItem
          Action = acGivenMaps
        end
      end
      object N29: TMenuItem
        Caption = '-'
      end
      object N26: TMenuItem
        Action = acMapManager
      end
      object N7: TMenuItem
        Action = acMapPrintStats
      end
    end
    object N37: TMenuItem
      Caption = #1054#1090#1074#1086#1076#1099
      object N24: TMenuItem
        Action = acLoadLots
      end
      object N38: TMenuItem
        Action = acLotVisible
      end
      object N39: TMenuItem
        Action = acLotProperties
      end
    end
    object N10: TMenuItem
      Caption = #1055#1088#1080#1074#1103#1079#1082#1080
      Visible = False
      object N11: TMenuItem
        Action = acSnapCenter
        AutoCheck = True
      end
      object N12: TMenuItem
        Action = acSnapEnd
        AutoCheck = True
      end
      object N13: TMenuItem
        Action = acSnapIntersect
        AutoCheck = True
      end
      object N14: TMenuItem
        Action = acSnapMiddle
        AutoCheck = True
      end
      object N15: TMenuItem
        Action = acSnapNearestVertex
        AutoCheck = True
      end
      object N16: TMenuItem
        Action = acSnapPerendicular
        AutoCheck = True
      end
      object N17: TMenuItem
        Action = acSnapTangent
        AutoCheck = True
      end
    end
    object N43: TMenuItem
      Caption = #1042#1080#1076
      object N44: TMenuItem
        Caption = #1041#1086#1083#1100#1096#1080#1077' '#1082#1085#1086#1087#1082#1080
        OnClick = N44Click
      end
      object N361: TMenuItem
        Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1089' '#1052#1057#1050'36'
        OnClick = N361Click
      end
    end
    object N8: TMenuItem
      Action = acExit
    end
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 48
    Top = 256
    object acZoomIn: TAction
      Category = 'Zoom'
      Caption = #1059#1074#1077#1083#1080#1095#1080#1090#1100
      Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100
      ImageIndex = 2
      OnExecute = acZoomInExecute
      OnUpdate = acZoomInUpdate
    end
    object acZoomOut: TAction
      Category = 'Zoom'
      Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100
      Hint = #1059#1084#1077#1085#1100#1096#1080#1090#1100
      ImageIndex = 3
      OnExecute = acZoomOutExecute
      OnUpdate = acZoomOutUpdate
    end
    object acZoomRect: TAction
      Category = 'Zoom'
      Caption = #1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1086#1073#1083#1072#1089#1090#1100
      Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1086#1073#1083#1072#1089#1090#1100
      ImageIndex = 4
      OnExecute = acZoomRectExecute
      OnUpdate = acZoomRectUpdate
    end
    object acScroll: TAction
      Caption = #1056#1091#1082#1072
      Hint = #1058#1072#1089#1082#1072#1090#1100
      ImageIndex = 8
      OnExecute = acScrollExecute
    end
    object acSelect: TAction
      Caption = #1055#1088#1086#1089#1090#1086#1081' '#1082#1091#1088#1089#1086#1088
      Hint = #1042#1077#1088#1085#1091#1090#1100' '#1082#1091#1088#1089#1086#1088
      ImageIndex = 7
      OnExecute = acSelectExecute
    end
    object acCalc: TAction
      Caption = #1048#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1048#1079#1084#1077#1088#1077#1085#1080#1103
      ImageIndex = 9
      OnExecute = acCalcExecute
      OnUpdate = acCalcUpdate
    end
    object acFindAddress: TAction
      Category = 'Find'
      Caption = #1040#1076#1088#1077#1089
      Hint = #1053#1072#1081#1090#1080' '#1072#1076#1088#1077#1089' '#1085#1072' '#1072#1076#1088#1077#1089#1085#1086#1084' '#1087#1083#1072#1085#1077
      ImageIndex = 27
      OnExecute = acFindAddressExecute
    end
    object acAerial: TAction
      Caption = #1042#1080#1076#1086#1074#1086#1077' '#1086#1082#1085#1086
      ImageIndex = 10
      Visible = False
      OnExecute = acAerialExecute
    end
    object acFindLotByAddress: TAction
      Category = 'Find'
      Caption = #1087#1086' '#1072#1076#1088#1077#1089#1091
      Hint = #1055#1086#1080#1089#1082' '#1086#1090#1074#1086#1076#1072' '#1087#1086' '#1072#1076#1088#1077#1089#1091
      ImageIndex = 81
      OnExecute = acFindLotByAddressExecute
      OnUpdate = acFindLotByAddressUpdate
    end
    object acShowMapHistory: TAction
      Category = 'Maps'
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1087#1083#1072#1085#1096#1077#1090#1072
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1087#1083#1072#1085#1096#1077#1090#1072
      OnExecute = acShowMapHistoryExecute
      OnUpdate = acShowMapHistoryUpdate
    end
    object acAddMap: TAction
      Category = 'Maps'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1083#1072#1085#1096#1077#1090
    end
    object acDeleteMap: TAction
      Category = 'Maps'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1083#1072#1085#1096#1077#1090
      OnExecute = acDeleteMapExecute
      OnUpdate = acDeleteMapUpdate
    end
    object acZoomAll: TAction
      Category = 'Zoom'
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1075#1086#1088#1086#1076
      ImageIndex = 11
      OnExecute = acZoomAllExecute
      OnUpdate = acZoomAllUpdate
    end
    object acLotInfo: TAction
      Category = 'Lots'
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1074#1086#1076#1091
      Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1074#1086#1076#1091
      ImageIndex = 12
      ShortCut = 113
      OnExecute = acLotInfoExecute
      OnUpdate = acLotInfoUpdate
    end
    object acZoomPrev: TAction
      Category = 'Zoom'
      Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1084#1072#1089#1096#1090#1072#1073
      Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1084#1072#1089#1096#1090#1072#1073
      ImageIndex = 13
      OnExecute = acZoomPrevExecute
      OnUpdate = acZoomPrevUpdate
    end
    object acCoord: TAction
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      ImageIndex = 23
      Visible = False
      OnUpdate = acCoordUpdate
    end
    object acSnapCenter: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1094#1077#1085#1090#1088#1091
      GroupIndex = 10
      Hint = #1082' '#1094#1077#1085#1090#1088#1091
      ImageIndex = 21
      OnExecute = acSnapCenterExecute
    end
    object acSnapEnd: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1082#1086#1085#1094#1091
      GroupIndex = 10
      Hint = #1082' '#1082#1086#1085#1094#1091
      ImageIndex = 15
      OnExecute = acSnapEndExecute
    end
    object acSnapMiddle: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1089#1077#1088#1077#1076#1080#1085#1077
      GroupIndex = 10
      Hint = #1082' '#1089#1077#1088#1077#1076#1080#1085#1077
      ImageIndex = 17
      OnExecute = acSnapMiddleExecute
    end
    object acSnapNearestVertex: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1073#1083#1080#1078#1072#1081#1096#1077#1081' '#1074#1077#1088#1096#1080#1085#1077
      GroupIndex = 10
      Hint = #1082' '#1073#1083#1080#1078#1072#1081#1096#1077#1081' '#1074#1077#1088#1096#1080#1085#1077
      ImageIndex = 18
      OnExecute = acSnapNearestVertexExecute
    end
    object acSnapTangent: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1082#1072#1089#1072#1090#1077#1083#1100#1085#1086#1081
      GroupIndex = 10
      Hint = #1082' '#1082#1072#1089#1072#1090#1077#1083#1100#1085#1086#1081
      ImageIndex = 14
      OnExecute = acSnapTangentExecute
    end
    object acSnapIntersect: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1087#1077#1088#1077#1089#1077#1095#1077#1085#1080#1102
      GroupIndex = 10
      Hint = #1082' '#1087#1077#1088#1077#1089#1077#1095#1077#1085#1080#1102
      ImageIndex = 16
      OnExecute = acSnapIntersectExecute
    end
    object acSnapPerendicular: TAction
      Category = 'Snaps'
      AutoCheck = True
      Caption = #1082' '#1087#1077#1088#1087#1077#1085#1076#1080#1082#1091#1083#1103#1088#1091
      GroupIndex = 10
      Hint = #1082' '#1087#1077#1088#1087#1077#1085#1076#1080#1082#1091#1083#1103#1088#1091
      ImageIndex = 20
      OnExecute = acSnapPerendicularExecute
    end
    object acExit: TAction
      Caption = #1042#1099#1093#1086#1076
      Hint = #1042#1099#1093#1086#1076
      ImageIndex = 22
      OnExecute = acExitExecute
    end
    object acZoomSelect: TAction
      Category = 'Zoom'
      Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091
      ImageIndex = 24
      OnExecute = acZoomSelectExecute
      OnUpdate = acZoomSelectUpdate
    end
    object acGoToPoint: TAction
      Category = 'Find'
      Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1090#1086#1095#1082#1077
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1090#1086#1095#1082#1077' '#1085#1072' '#1082#1072#1088#1090#1077
      ImageIndex = 25
      OnExecute = acGoToPointExecute
    end
    object acSnaps: TAction
      AutoCheck = True
      Caption = #1055#1088#1080#1074#1103#1079#1082#1080
      Checked = True
      ImageIndex = 17
    end
    object acMapByName: TAction
      Category = 'Find'
      Caption = #1055#1083#1072#1085#1096#1077#1090' '#1087#1086' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1077
      Hint = #1053#1072#1081#1090#1080' '#1089#1082#1072#1085' '#1087#1083#1072#1085#1096#1077#1090#1072' '#1087#1086' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1077
      ImageIndex = 26
      OnExecute = acMapByNameExecute
    end
    object acLoadLots: TAction
      Category = 'Lots'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1074#1086#1076#1099' '#1087#1086' '#1086#1073#1083#1072#1089#1090#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1074#1086#1076#1099' '#1087#1086' '#1086#1073#1083#1072#1089#1090#1080
      ImageIndex = 31
      OnExecute = acLoadLotsExecute
      OnUpdate = acLoadLotsUpdate
    end
    object acChangeMap: TAction
      Category = 'Maps'
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1087#1083#1072#1085#1096#1077#1090
    end
    object acCopySelected: TAction
      Category = 'CoordsList'
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1077' '#1074' '#1073#1091#1092#1077#1088
      ImageIndex = 39
      OnExecute = acCopySelectedExecute
      OnUpdate = acCopySelectedUpdate
    end
    object acCopyAll: TAction
      Category = 'CoordsList'
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1095#1082#1080' '#1074' '#1073#1091#1092#1077#1088
      ImageIndex = 38
      OnExecute = acCopyAllExecute
      OnUpdate = acCopyAllUpdate
    end
    object acPastePoints: TAction
      Category = 'CoordsList'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1095#1082#1080' '#1080#1079' '#1073#1091#1092#1077#1088#1072
      ImageIndex = 44
    end
    object acPasteAndReplace: TAction
      Category = 'CoordsList'
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1084#1080' '#1080#1079' '#1073#1091#1092#1077#1088#1072
    end
    object acDeletePoint: TAction
      Category = 'CoordsList'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1090#1086#1095#1082#1091
      ImageIndex = 41
      OnExecute = acDeletePointExecute
      OnUpdate = acDeletePointUpdate
    end
    object acInsertPoint: TAction
      Category = 'CoordsList'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1095#1082#1091
      ImageIndex = 40
      OnExecute = acInsertPointExecute
      OnUpdate = acInsertPointUpdate
    end
    object acEditPoint: TAction
      Category = 'CoordsList'
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1095#1082#1091
      ImageIndex = 43
      OnExecute = acEditPointExecute
      OnUpdate = acEditPointUpdate
    end
    object acLotVisible: TAction
      Category = 'Lots'
      Caption = '-'
      ImageIndex = 5
    end
    object acLotProperties: TAction
      Category = 'Lots'
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1086#1090#1074#1086#1076#1072
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1072' '#1086#1090#1074#1086#1076#1072
      ImageIndex = 45
      OnExecute = acLotPropertiesExecute
    end
    object acAllMaps: TAction
      Category = 'Maps'
      Caption = #1074#1089#1077
      OnExecute = acAllMapsExecute
      OnUpdate = acAllMapsUpdate
    end
    object acGivenMaps: TAction
      Category = 'Maps'
      Caption = #1074#1099#1076#1072#1085#1085#1099#1077
      OnExecute = acGivenMapsExecute
      OnUpdate = acGivenMapsUpdate
    end
    object acMapManager: TAction
      Category = 'Maps'
      Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1087#1083#1072#1085#1096#1077#1090#1086#1074
      OnExecute = acMapManagerExecute
      OnUpdate = acMapManagerUpdate
    end
    object acPrintPrepare: TAction
      Category = 'Print'
      Hint = #1047#1072#1076#1072#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 49
      OnExecute = acPrintPrepareExecute
      OnUpdate = acPrintPrepareUpdate
    end
    object acExportToDXF: TAction
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1089#1083#1086#1081' '#1074' DXF...'
      OnExecute = acExportToDXFExecute
      OnUpdate = acExportToDXFUpdate
    end
    object acPrint: TAction
      Category = 'Print'
      Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1089' '#1101#1082#1088#1072#1085#1072
      Hint = #1055#1077#1095#1072#1090#1072#1090#1100' '#1089' '#1101#1082#1088#1072#1085#1072
      ImageIndex = 59
      OnUpdate = acPrintUpdate
    end
    object acCancelPrint: TAction
      Category = 'Print'
      Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1088#1077#1078#1080#1084#1072' '#1087#1077#1095#1072#1090#1080
      Hint = #1042#1099#1081#1090#1080' '#1080#1079' '#1088#1077#1078#1080#1084#1072' '#1087#1077#1095#1072#1090#1080
      OnExecute = acCancelPrintExecute
      OnUpdate = acCancelPrintUpdate
    end
    object acSetScale: TAction
      Category = 'Zoom'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1084#1072#1089#1096#1090#1072#1073
      OnExecute = acSetScaleExecute
      OnUpdate = acSetScaleUpdate
    end
    object acExport2DXF: TAction
      Category = 'CoordsList'
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' DXF-'#1092#1072#1081#1083
      OnExecute = acExport2DXFExecute
      OnUpdate = acExport2DXFUpdate
    end
    object acShowInvisible: TAction
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100'/'#1089#1087#1088#1103#1090#1072#1090#1100#13#10#1089#1082#1088#1099#1090#1099#1077' '#1086#1090#1074#1086#1076#1099
      ImageIndex = 5
      OnExecute = acShowInvisibleExecute
    end
    object acReloadMaps: TAction
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1087#1083#1072#1085#1096#1077#1090#1099
      ImageIndex = 73
      OnExecute = acReloadMapsExecute
    end
    object acAccuDraw: TAction
      Category = 'Snaps'
      AutoCheck = True
      Checked = True
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' "'#1087#1088#1080#1094#1077#1083'"'
      ImageIndex = 75
      OnExecute = acAccuDrawExecute
    end
    object acTreeClear: TAction
      Category = 'Tree'
      Hint = #1059#1073#1088#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 76
      OnExecute = acTreeClearExecute
    end
    object acTreeLocate: TAction
      Category = 'Tree'
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1086#1073#1098#1077#1082#1090' '#1085#1072' '#1082#1072#1088#1090#1077
      ImageIndex = 77
      OnExecute = acTreeLocateExecute
    end
    object acTreeRemoveCurrent: TAction
      Category = 'Tree'
      Hint = #1059#1073#1088#1072#1090#1100' '#1086#1073#1098#1077#1082#1090
      ImageIndex = 79
      OnExecute = acTreeRemoveCurrentExecute
    end
    object acTreeOnOfContour: TAction
      Category = 'Tree'
      Caption = 'acTreeOnOfContour'
      OnExecute = acTreeOnOfContourExecute
      OnUpdate = acTreeOnOfContourUpdate
    end
    object acMapPrintStats: TAction
      Category = 'Maps'
      Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1077#1095#1072#1090#1080' '#1087#1083#1072#1085#1096#1077#1090#1086#1074
      OnExecute = acMapPrintStatsExecute
      OnUpdate = acMapPrintStatsUpdate
    end
    object acFindNomenNet: TAction
      Category = 'Find'
      Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '#1074' '#1089#1077#1090#1082#1077
      Hint = #1053#1072#1081#1090#1080' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1091' '#1074' '#1088#1072#1079#1075#1088#1072#1092#1082#1077
      ImageIndex = 82
      OnExecute = acFindNomenNetExecute
    end
    object acSavePointList: TAction
      Category = 'CoordsList'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099'...'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      ImageIndex = 84
      OnExecute = acSavePointListExecute
      OnUpdate = acSavePointListUpdate
    end
  end
  object Preferences: TEzModifyPreferences
    PointEntitySize = 0
    UsePreloadedBlocks = False
    UsePreloadedImages = False
    UsePreloadedBandedImages = False
    PatternPlotterOptimized = False
    PlineGen = False
    SplineSegs = 100
    EllipseSegs = 50
    ArcSegs = 20
    BandsBitmapChunkSize = 65535
    DefPenStyle.Style = 1
    DefPenStyle.Color = clBlack
    DefBrushStyle.Pattern = 0
    DefBrushStyle.ForeColor = clBlack
    DefBrushStyle.BackColor = clBlack
    DefSymbolStyle.Index = 0
    DefSymbolStyle.Height = -10.000000000000000000
    DefFontStyle.Name = 'Arial'
    DefFontStyle.Height = 12.000000000000000000
    DefFontStyle.Color = clBlack
    DefFontStyle.Style = []
    DefTTFontStyle.Name = 'Arial'
    DefTTFontStyle.Height = 1.000000000000000000
    DefTTFontStyle.Color = clBlack
    DefTTFontStyle.Style = []
    ShowText = True
    SelectionPen.Style = 1
    SelectionPen.Color = clRed
    SelectionBrush.Pattern = 1
    SelectionBrush.ForeColor = clYellow
    SelectionBrush.BackColor = clNone
    ControlPointsWidth = 10
    ApertureWidth = 8
    MinDrawLimit = 5
    AerialMinDrawLimit = 5
    SelectPickingInside = True
    HintColor = clInfoBk
    HintFont.Charset = DEFAULT_CHARSET
    HintFont.Color = clBlack
    HintFont.Height = -11
    HintFont.Name = 'Arial'
    HintFont.Style = [fsItalic]
    Left = 48
    Top = 312
  end
  object ImageList: TImageList
    Left = 80
    Top = 256
    Bitmap = {
      494C010155007801300210001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006001000001002000000000000060
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004040400000000000000000000000000000000000404040000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004060600000E0E00000E0E00000E0
      E00000E0E0004060600000E0E00000E0E00000E0E00000E0E0004060600000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      00000080000000000000000000000000000000000000241CED00241CED000000
      0000241CED00241CED0000000000241CED00241CED00241CED0000000000241C
      ED00241CED0000000000241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000080800000000000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      00000000000000800000008000000000000000000000241CED00FFFFFF000000
      0000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000808000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      00000000000000000000008000000000000000000000241CED00FFFFFF000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000008080000000
      0000000000000000000000000000000000000000000000800000000000000000
      00000000000000000000008000000000000000000000241CED00FFFFFF000000
      0000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008000000000000000000000241CED00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      0000008080000000000000000000FFFF000000800000FFFF0000000000008080
      80000000000000800000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      00000000000000808000FFFF0000FFFF000000800000FFFF0000FFFF00000000
      00000000000000800000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF000000800000FFFF0000FFFF0000FFFF
      00000000000000800000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF000000800000FFFF0000FFFF0000FFFF
      00000000000000800000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      000000808000FFFF0000FFFF000000800000FFFF0000FFFF0000FFFF0000FFFF
      00000000000000000000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      00000000000000000000FFFF0000008000000080000000800000FFFF00000000
      00000080000000000000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E0E00000E0E00000E0
      E00000E0E0000000000000E0E00000E0E00000E0E00000E0E0000000000000E0
      E00000E0E00000E0E00000E0E000404040000000000000000000000000000000
      0000000000000080800000000000FFFF0000FFFF0000FFFF0000000000008080
      80000080000000000000000000000000000000000000241CED00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000008080000000000000000000000000000000
      00000000000000000000000000000000000000000000241CED00241CED00241C
      ED00241CED00241CED00241CED00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000031DE000031DE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5636B00A563
      6B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A563
      6B00A5636B00A5636B00A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000040E0000040E000000000000031DE000031DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000031DE000031DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5948400FFEF
      C60039525200EFD6AD0039525200EFCE9400EFC68C00EFBD8400EFC67B00EFBD
      840039525200EFC68400A5636B0000000000000000000040E0000040E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000040E0000040E00000000000000000000031DE000031DE000031
      DE00000000000000000000000000000000000000000000000000000000000000
      00000031DE000031DE0000000000000000000000000000000000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B59484003952
      5200395252003952520039525200395252003952520039525200395252003952
      52003952520039525200A5636B0000000000000000000040E0000040E0000040
      E000000000000000000000000000000000000000000000000000000000000000
      00000040E0000040E0000000000000000000000000000031DE000031DE000031
      DE000031DE000000000000000000000000000000000000000000000000000031
      DE000031DE0000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000B5948C00FFEF
      DE0039525200F7DEBD0039525200EFCEA500EFCE9C00EFC69400EFC68C00EFBD
      840039525200EFC68400A5636B0000000000000000000040E0000040E0000040
      E0000040E0000000000000000000000000000000000000800000000000000040
      E0000040E00000000000000000000000000000000000000000000031EF000031
      DE000031DE000031DE00000000000000000000000000000000000031DE000031
      DE00000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000000000BD948C00FFF7
      E70039525200F7DEC600F7DEBD00EFD6AD00EFCEA500EFCE9C00EFC69400EFC6
      8C00EFBD8400EFC68400A5636B000000000000000000000000000040E0000040
      E0000040E0000040E000000000000000000000000000008000000040E0000040
      E000000000000000000000000000000000000000000000000000000000000000
      00000031DE000031DE000031DE00000000000031DE000031DE000031DE000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF000000000000000000000080000000000000000000000000
      0000008000000080000000000000000000000000000000000000C69C9400FFF7
      EF0039525200F7E7CE00F7DEC600F7DEBD00EFD6AD00EFCEA500EFCE9C00EFC6
      9400EFC68C00EFC68400A5636B00000000000000000000000000000000000000
      00000040E0000040E0000040E000000000000040E0000040E0000040E0000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000031DE000031E7000031E7000031E7000031DE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF000000000000000000000080000000000000000000000000
      0000000000000080000000000000000000000000000000000000C6A59C00FFFF
      FF0039525200F7EFDE00F7E7CE00F7DEC600F7DEBD00EFD6AD00EFCEA500EFCE
      9C00EFC69400EFC68C00A5636B00000000000000000000000000000000000000
      0000000000000040E0000040E0000040E0000040E0000040E000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      000000000000000000000031E7000031E7000031EF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000000000000000000000
      0000000000000080000000000000000000000000000000000000CEAD9C00FFFF
      FF0039525200FFEFE700F7EFDE00F7E7CE00F7DEC600F7DEBD00EFD6AD00EFCE
      A500EFCE9C00EFCE9400A5636B00000000000000000000000000000000000000
      000000000000000000000040E0000040E0000040E00000000000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      0000000000000031DE000031EF000031E7000031EF000031F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000000000000000000000
      0000000000000080000000000000000000000000000000000000CEAD9C00FFFF
      FF0039525200FFF7EF00FFEFE700F7EFDE00F7E7CE00F7DEC600F7DEBD00EFD6
      AD00EFCEA500F7D6A500A5636B00000000000000000000000000000000000000
      0000000000000040E0000040E0000040E0000040E0000040E000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      00000031F7000031EF000031E70000000000000000000031F7000031F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000D6B5A500FFFF
      FF0039525200FFFFFF00FFF7EF00FFEFE700F7EFDE00F7E7CE00F7DEC600F7D6
      B500F7D6AD00EFCEA500A5636B00000000000000000000000000000000000000
      00000040E0000040E0000040E00000800000000000000040E0000040E0000000
      0000008000000000000000000000000000000000000000000000000000000031
      FF000031EF000031F700000000000000000000000000000000000031FF000031
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000D6B5A500FFFF
      FF0039525200FFFFFF00FFFFFF00FFF7EF00FFEFE700FFE7D600F7E7CE00F7E7
      CE00DECEB500B5AD9400A5636B00000000000000000000000000000000000040
      E0000040E0000040E000000000000080000000000000000000000040E0000040
      E0000080000000000000000000000000000000000000000000000031F7000031
      F7000031FF000000000000000000000000000000000000000000000000000031
      F7000031F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000DEB5A500FFFF
      FF0039525200FFFFFF00FFFFFF00FFFFFF00FFF7EF00FFEFE700EFDECE00B58C
      7B00A57B6B009C736300A5636B000000000000000000000000000040E0000040
      E0000040E0000000000000000000008000000000000000000000000000000040
      E0000040E000000000000000000000000000000000000031F7000031F7000031
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000031F70000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      0000008000000000000000000000000000000000000000000000E7BDA500FFFF
      FF0039525200FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700DEC6BD00AD73
      5A00E79C5200E78C3100B56B4A0000000000000000000040E0000040E0000040
      E000000000000000000000000000008000000000000000000000000000000000
      0000008000000040E00000000000000000000031F7000031F7000031F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000E7BDA5003952
      52003952520039525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEC6C600BD84
      6300FFB55A00BD7B5A0000000000000000000040E0000040E0000040E0000000
      0000000000000000000000800000000000000000000000000000000000000080
      0000000000000000000000000000000000000031F7000031F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000008000000080000000000000000000000080
      0000000000000000000000000000000000000000000000000000E7BDA500F7F7
      EF0039525200F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00DEC6BD00B57B
      6300C6846B000000000000000000000000000040E0000040E000000000000000
      0000000000000000000000800000008000000080000000000000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000000000EFC6AD00EFCE
      B500EFCEB500E7C6B500E7C6B500E7C6B500E7C6B500E7C6B500E7C6B500A56B
      5A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000000000000000000000000000C0C0C00000000000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000004040400040404000404
      0400040404000404040004040400040404000404040004040400040404000404
      0400040404000404040000000000000000000000000000000000000000000000
      0000000000004040400000000000000000000000000000000000404040000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C000000000000000000000000000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C0000000000086868600CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC0004040400000000000000000040606000C0DCC000C0DCC000C0DC
      C000C0DCC00040606000C0DCC000C0DCC000C0DCC000C0DCC00040606000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000FF000000FF00
      000000000000FF000000FF0000000000000000000000FF00000000000000FF00
      0000FF00000000000000FF00000000000000000000000000000000000000C0C0
      C00000000000000000000000000000000000C0C0C0000000000000000000C0C0
      C000000000000000000000000000C0C0C0000000000086868600FFFFFF00FFFF
      FF0099FFFF00FFFFFF0099FFFF000099330099FFFF00FFFFFF0099FFFF00FFFF
      FF00CCCCCC000404040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C00000000000C0C0C00000000000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C0000000000086868600FFFFFF0099FF
      FF00FFFFFF0099FFFF000099330000993300FFFFFF0099FFFF00FFFFFF0099FF
      FF00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000FFFFFF0000000000C0C0C000FFFFFF0000000000C0C0C0008080
      8000C0C0C0000000000000000000000000000000000086868600FFFFFF00FFFF
      FF0099FFFF00009933000099330000993300009933000099330099FFFF00FFFF
      FF00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000C0C0C0000000000086868600FFFFFF0099FF
      FF00FFFFFF0099FFFF000099330000993300FFFFFF00669900006666000099FF
      FF00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000080808000C0C0
      C000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000C0C0C0000000000086868600FFFFFF00FFFF
      FF0099FFFF00FFFFFF0099FFFF000099330099FFFF00FFFFFF0066660000FFFF
      FF00CCCCCC000404040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000FF0000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000086868600FFFFFF0099FF
      FF006666000099FFFF00FFFFFF0099FFFF00FFFFFF0099FFFF006666000099FF
      FF00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FF000000000000000000
      00000000000000FF000000FF000000FF00000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000086868600FFFFFF00FFFF
      FF0066660000FFFFFF0099FFFF000099330099FFFF00FFFFFF0099FFFF00FFFF
      FF00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      00000000000000000000FF000000000000000000000000000000FFFFFF008080
      80008080800080808000808080000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000086868600FFFFFF0099FF
      FF006666000066990000FFFFFF00009933000099330099FFFF00FFFFFF0099FF
      FF00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000086868600FFFFFF00FFFF
      FF0099FFFF00009933000099330000993300009933000099330099FFFF00FFFF
      FF00CCCCCC000404040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FFFFFF008080
      800080808000808080008080800080808000808080000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000086868600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00009933000099330099FFFF00FFFFFF00CCCC
      CC00CCCCCC0004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF0000FFFF000000000000000000000000000000000086868600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000099330099FFFF00FFFFFF00040404000404
      04000404040004040400000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000FF0000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008080
      8000808080008080800080808000808080008080800080808000FFFFFF000000
      000000FFFF0000FFFF0000000000000000000000000086868600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0099FFFF00FFFFFF0099FFFF0086868600FFFF
      FF000404040000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC00000000000C0DCC000C0DCC000C0DCC000C0DCC00000000000C0DC
      C000C0DCC000C0DCC000C0DCC000404040000000000000000000FF000000FF00
      000000000000FF000000FF000000000000000000FF00FF00000000000000FF00
      0000FF00000000000000FF00000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000FFFF0000FFFF00000000000000000086868600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00868686000404
      0400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000086868600868686008686
      8600868686008686860086868600868686008686860086868600868686000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000000000000000000000000000C0C0C00000000000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C000000000000000000000000000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000008080800000000000808080000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000000000000000000000000000C0C0C0000000000000000000C0C0
      C000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C00000000000C0C0C00000000000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000808080000000FF0000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000C0C0C0000000000000000000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000FF0000000000C0C0C00000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00808080000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF0000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000080800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000FF000000000000000000000000000000000000000000C0C0
      C00000000000000000000000FF0000000000C0C0C0000000000000000000C0C0
      C00000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF0000000000000000000000FF000000FF000000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00808080000000000000000000000000000000000000000000808080000000
      0000808080000000000080808000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF000000000000000000000000000000FF000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000000000000000000000000000FF000000FF0000008080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      FF0080808000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000C0C0C0000000000000000000000000000000000000000000FF00
      000080800000FF00000080000000800000000000000000000000FF0000008080
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      00000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF000000000000000000000000000000FF000000
      0000C0C0C000000000000000000000000000000000000000000000000000FF00
      0000808000000000000080000000800000000000000000000000FF0000008080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0080808000000000000000
      FF0080808000000000000000FF00000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF008080800080808000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000000000000000FF0000000000C0C0C0000000000000000000C0C0
      C00000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000080800000000000000000000000000000FF000000FF0000008080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF0000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000008080000000000000FF000000FF000000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF00000080800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000000000000000000000000000C0C0C00000000000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C000000000000000000000000000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000000000000000000000000000C0C0C0000000000000000000C0C0
      C000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C000000000000000000000000000000000000000FF00000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000C0C0C00000000000C0C0C00000000000C0C0C0000000
      0000C0C0C0000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000C0C0C0000000000000000000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C0000000FF00C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C0000000FF00000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000000080000000
      FF00C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C0000000
      FF000000FF00C0C0C00000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF0000008000C0C0C000C0C0C000000000000000000000000000000000000000
      000000000000FFFF0000FFFF000000000000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C0000000
      80000000FF000000FF00C0C0C000C0C0C0000000FF000000FF000000FF000000
      8000C0C0C00000000000C0C0C000000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000FF000000FF000000FF000000FF000000800000008000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00000080000000FF000000FF0000008000FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C000000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF0000000000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000008000000080000000FF000000FF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF000000000000FFFF0000FFFF0000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000000000C0C0C000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF0000008000FFFFFF00FFFFFF00000080000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000000000C0C0C000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      800000008000FFFFFF0000000000000000000000000000008000000080000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000FF000000FF0000000000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000080000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      80000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000008080800000000000000000000000
      00000000000080808000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000808080000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000000000008080800080808000808080008080
      80000000000000000000808080008080800000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000008080800000000000000000000000
      00000000000080808000808080000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000008080800000000000000000000000
      00000000000080808000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000800000008000000080
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      0000808080008080000080808000808000008080800080800000808080008080
      00008080800080800000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808000008080
      8000000000000000000000000000000000000000000000000000000000008080
      80008080000080808000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008080
      00008080800080800000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808000008080
      800000000000FFFFFF00800000008000000080000000FFFFFF00000000008080
      80008080000080808000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008080
      00008080800080800000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808000008080
      800000000000FFFFFF008000000080000000FFFFFF00FFFFFF00000000008080
      80008080000080808000000000000000000080000000FFFFFF00FFFFFF008000
      0000FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008080
      00008080800080800000000000000000000080000000FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808000008080
      800000000000FFFFFF00800000008000000080000000FFFFFF00000000008080
      8000808000008080800000000000000000008000000080000000800000008000
      000080000000FFFFFF00000000000000000000000000FFFFFF00800000008000
      00008000000080000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008080
      00008080800080800000000000000000000080000000FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808000008080
      8000000000000000000000000000000000000000000000000000000000008080
      80008080000080808000000000000000000080000000FFFFFF00FFFFFF008000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF008000
      0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      0000808080008080000080808000808000008080800080800000808080008080
      00008080800080800000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      00008C8C8C00CCCCCC00DDDDDD00DDDDDD00FBFBFF00DDDDDD008C8C8C007F7F
      7F008C8C8C0000000000000000000000000000000000000000000000FF000000
      FF000000FF00CCCCCC00DDDDDD00DDDDDD00FBFBFF000000FF000000FF007F7F
      7F008C8C8C0000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C0000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C0000000000000000000000000000000000000000000000000008C8C8C005F5F
      5F00CCCCCC00ADADAD008C8C8C007F7F7F008C8C8C00ADADAD00DDDDDD005252
      52005F5F5F008C8C8C008C8C8C000000000000000000000000008C8C8C005F5F
      5F000000FF000000FF008C8C8C007F7F7F008C8C8C000000FF00DDDDDD005252
      52005F5F5F008C8C8C008C8C8C000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C0000000000000000000000000008C8C8C00525252008C8C
      8C007F7F7F005F5F5F005252520042424200000000005F5F5F008C8C8C005252
      5200000000005F5F5F008C8C8C0000000000000000008C8C8C00525252008C8C
      8C007F7F7F000000FF000000FF00424242000000FF000000FF008C8C8C005252
      5200000000005F5F5F008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000008C8C8C00525252005F5F5F007F7F
      7F00424242005252520000000000000000004242420052525200424242000000
      00000D0D0D005F5F5F008C8C8C00000000008C8C8C00525252005F5F5F007F7F
      7F0042424200525252000000FF000000FF000000FF0052525200424242000000
      00000D0D0D005F5F5F008C8C8C000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000008C8C8C005F5F5F00424242005252
      520000000000FBFBFF0000000000000000000000000042424200161615003131
      31005F5F5F007F7F7F0000000000000000008C8C8C005F5F5F00424242005252
      520000000000FBFBFF00000000000000FF000000FF0042424200161615003131
      31005F5F5F007F7F7F0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C0000000000000000000000000008C8C8C005F5F5F004242
      4200424242000000000000000000000000000000000016161500313131005252
      52008C8C8C00525252003131310000000000000000008C8C8C005F5F5F004242
      420042424200000000000000FF000000FF000000FF000000FF00313131005252
      52008C8C8C00525252003131310000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C000000000000000000000000000000000008C8C
      8C005F5F5F005252520042424200161615000D0D0D00424242008C8C8C005252
      5200000000000000000052525200000000000000000000000000000000008C8C
      8C005F5F5F000000FF000000FF00161615000D0D0D000000FF000000FF005252
      5200000000000000000052525200000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C008C8C8C008C8C8C008C8C8C00525252000D0D0D000000
      000000000000525252008C8C8C00000000000000000000000000000000000000
      00000000FF000000FF008C8C8C008C8C8C008C8C8C00525252000000FF000000
      FF0000000000525252008C8C8C00000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000808000000000000000000000808080000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000008C8C8C008C8C8C008C8C8C008C8C
      8C008C8C8C008C8C8C0052525200313131000000000000000000525252005252
      52005F5F5F008C8C8C0000000000000000008C8C8C008C8C8C008C8C8C000000
      FF000000FF008C8C8C0052525200313131000000000000000000525252000000
      FF000000FF008C8C8C0000000000000000000000000000000000FFFF00008080
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000000000008C8C8C008C8C
      8C00525252000D0D0D003131310031313100525252005F5F5F008C8C8C008C8C
      8C000000000000000000000000000000000000000000000000000000FF000000
      FF00525252000D0D0D003131310031313100525252005F5F5F008C8C8C008C8C
      8C00000000000000000000000000000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000808000000000000000000000808080000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080008080
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000008000000000FFFF00000000000000000080000000FFFF
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00FFFF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000800080000000000000000000000080000000F0FB
      FF00FFFFFF000080800000808000008080000080800000808000F0FBFF00F0FB
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000008000800000000000000000000000000080000000F0FBFF00FFFF
      FF000080800000808000008080000080800000808000FFFFFF00F0FBFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000008000
      00008000800000000000000000000000000080000000F0FBFF00FFFFFF000080
      800000808000008080000080800000808000FFFFFF00F0FBFF00800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF008000000000FF
      FF008000000000000000000000000000000080000000F0FBFF00FFFFFF000080
      800000808000008080000080800000808000FFFFFF00F0FBFF00800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080008000800080000000FF000000FF000000FF000000FF00000000008000
      00000000000000000000000000000000000080000000F0FBFF00FFFFFF000080
      800000808000008080000080800000808000FFFFFF00F0FBFF00800000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF00000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000000000000000000000000000000000000000008000000000FF
      FF0080000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000080000000F0FBFF00FFFF
      FF000080800000808000008080000080800000808000FFFFFF00F0FBFF008000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000008000
      000080008000000000000000FF000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000080000000F0FB
      FF00F0FBFF000080800000808000008080000080800000808000F0FBFF00F0FB
      FF008000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000800080000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00FFFFFF0080000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF00000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000800080000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000FFFF0000FFFF0000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      800080008000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080008000800080000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000FFFF00008000
      0000FFFF00008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000800000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFF0000FFFF00008000
      0000FFFF0000FFFF000080000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000FF00000000000000000000000000000000000000008080008080
      8000008080008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000008000
      0000008000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000008000
      0000FF0000000000000000000000000000000000000000000000808080000080
      80008080800000808000808080000080800080000000FFFF0000FFFF00008000
      0000FFFF0000FFFF000080000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF008000000000FF
      FF00800000000000000000000000000000000000000000000000008080008080
      8000008080008080800000808000808080008000000080000000FFFF00008000
      0000FFFF00008000000080000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000008000
      000000800000008000000000FF000000FF000000FF000000FF00000000008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF000000FF0000000000FF000000FF000000FF000000FF00000000008000
      0000000000000000000000000000000000000000000000000000808080000080
      8000808080000080800080808000008080008080800080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000008000000000FF
      FF0080000000000000000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000008000000000FF
      FF0080000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000008080008080
      8000008080008080800000808000808080000080800080808000008080008000
      00000080800080808000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000008000
      000000800000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000808080000080
      8000808080000080800080808000008080008080800000808000808080008000
      0000808080000080800000000000000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000008080008080
      8000008080008080800000808000808080000080800080808000008080008000
      000000808000808080000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000808080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000080800000000000000000000000000000000000000000000000
      000000000000000000008080800000FFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000008080008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000808000808080000000000000000000000000000000FF000000FF000000
      FF00000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000808080000080
      8000808080000000000000FFFF00000000000000000000FFFF00000000000080
      800080808000008080000000000000000000000000000000FF000000FF000000
      FF0000000000000000008080800000FFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      000000800000000000000000FF000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000800000008000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF0000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000800000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000800000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000080000000FFFF000080000000FFFF000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000080000000FFFF000080000000FFFF000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000FFFF0000FFFF000080000000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000FFFF0000FFFF000080000000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF00008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF00008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF00008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF00008000
      000000000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000FFFF0000FFFF000080000000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000FFFF0000FFFF000080000000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000080000000FFFF000080000000FFFF000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000080000000FFFF000080000000FFFF000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FFFF
      0000FF000000FFFF0000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000800000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF0080000000FFFFFF00FF00
      0000FF000000FFFFFF0080000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFF0000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF0000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080008000800080008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF0080000000FFFFFF00FF00
      0000FF000000FFFFFF0080000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFF0000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FFFF00000000000000000000000000008000
      0000FF000000FF000000FF000000FF0000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800080008000800080008000800080000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FF00000000000000000000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008000
      0000FFFFFF00000000000000000080000000FFFFFF0080000000FFFFFF00FF00
      0000FF000000FFFFFF008000000000000000000000000000000000000000FFFF
      000000000000FFFF0000000000000000000000000000FF000000FF000000FFFF
      0000FF000000FFFF0000FF000000FF0000000000000000000000000000008000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000800000008000000080000000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000FFFF000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008000
      0000FFFFFF00000000000000000080000000FFFFFF0080000000FFFFFF008000
      0000FFFFFF0080000000000000000000000000000000FFFF0000FFFF0000FFFF
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008000
      0000FFFFFF000000000000000000800000008000000080000000800000008000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800080008000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000FFFF0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      8000800080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      000000000000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080008000800080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800080008000
      8000800080008000800080008000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF000000000000800000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000080008000000000000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000800000000000000000800000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000080008000000000000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000000000000000000000000000000000008000000000
      0000000000000000000000000000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800080000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000008000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000800080000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000008000008000000000FF
      FF00800000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000080000000000000000000000080
      0000008000000080000000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF0000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000800080000000
      0000000000000000000000000000000000008000800000000000000000008000
      8000800080008000800000000000000000000000000000000000000000008000
      0000008000000080000000800000008000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000080000000800000008000000000
      0000000000000080000000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      000000000000FF00000000000000000000000000000000000000800080000000
      0000000000000000000000000000000000008000800080008000800080000000
      00000000000080008000000000000000000000000000000000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800000000000000000000000000000000000000000008000
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000000000000000000000000000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000000000000000000000000000000000000000
      0000000000000000000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000000000000080
      000000800000008000000000000000000000000000000000000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000008000
      8000000000000000000000000000000000000000000000000000000000008000
      8000800080008000800000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000000000000000000008000000080000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800080000000000000000000800080008000800080008000800080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800080008000800080008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      00000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF00000000000000FF000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000000000000000000000000000FF
      FF0000000000000000000000FF000000FF000000FF000000FF00808080000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000080000000800000008000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00808080000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000000000000000000000FF000000FF00808080000000000000FF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF008080800000FFFF008080800000FFFF008080800000FFFF008080800000FF
      FF0000FFFF000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000080
      0000008000000000000000000000000000000080000000800000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000080
      0000008000000000000000000000000000000000000000800000008000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000FFFF00000000000000FF000000FF00808080000000000000FF
      FF0000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000008000000000000000000000000000000000000000000000008000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0080808000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      00008080800000FF00008080800000FF00008080800000FF00008080800000FF
      000000FF00000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000000000000000000000FF000000FF0080808000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000080000000000000000000000000000000000000000000000080
      00000080000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00808080000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000080000000800000000000000000000000000000000000000080
      00000000000000000000000000000000FF000000000000000000000000000000
      000000FFFF00000000000000FF000000FF000000FF000000FF00808080000000
      000000FFFF0000000000000000000000000000000000000000000000000000FF
      FF008080800000FFFF008080800000FFFF008080800000FFFF008080800000FF
      FF0000FFFF000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000800000008000000000000000000000008000000080
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000800000008000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000FF000000FF000000FF000000FF000000FF000000FF008080
      80000000000000FFFF000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF008080
      80000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000000000000000000000000000FF
      FF00000000000000FF000000FF000000FF000000FF000000FF000000FF008080
      80000000000000FFFF0000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      00000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000080800000000000000000000000
      00000000000000000000000000000000FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800080808000808080008080
      8000000000000000000000000000000000000000000000808000000000000000
      00000000000000000000000000000000FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00000000008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000008080000000
      00000000000000000000000000000000FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00000000008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000080
      800000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000080800000000000000000000000FF0000FFFF00FFFF0000000000008080
      800000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000008000000000000000000000000000000080000000800000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFF00000000FF00FFFF000000FFFF00FFFF00000000
      000000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000FFFFFF0000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF00000000FF0000FFFF00FFFF000000FFFF00FFFF
      00000000000000FFFF0000FFFF000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000FFFFFF000080
      0000008000000080000000800000000000000080000000800000000000000080
      000000800000FFFFFF0000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF00000000FF00FFFF000000FFFF00FFFF000000FF
      FF000000000000FFFF0000FFFF000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000FFFFFF000080
      0000000000000080000000800000000000000080000000800000008000000080
      000000800000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000800000008000000080000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000808000FFFF0000FFFF00000000FF0000FFFF00FFFF000000FFFF00FFFF
      00000000000000FFFF0000FFFF000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000FFFFFF000080
      0000008000000080000000800000008000000000000000800000008000000000
      000000800000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF00000000FF00FFFF000000FFFF00FFFF00000000
      000000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000FFFFFF000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000000000000000FF0000FFFF00FFFF0000000000008080
      800000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      800000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000000000000000000000FF00000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF0000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000FFFF00000000000000
      00000000000000000000000000000000000000000000FF00000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      800000008000000080000000800000008000000080000000800000FFFF000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      800000008000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      800000008000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      800000008000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000FFFFFF00FFFFFF0000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000008000FFFFFF00FFFF
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000FFFFFF00FFFF
      FF00000080000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000008000FFFFFF00FFFF
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000FFFFFF00FFFF
      FF00000080000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000080000000800000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000FFFFFF00FFFF
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000FFFFFF00FFFF
      FF00000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008080000000000000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000000000000000000000000000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000000000000000000000000000FFFF0000FFFF0000FFFF00000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      000000000000000000000000000000000000000000000000000000008000FFFF
      FF00FFFFFF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      000000000000000000000000000000000000000000000000000000008000FFFF
      FF00FFFFFF000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000008000000080000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000FFFFFF00FFFFFF00000080000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000FFFFFF00FFFFFF0000008000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800080808000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000FF00000080000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000008000
      0000FF000000800000008000000080000000FF00000080000000800000008000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000FF000000FF00
      0000FF000000FFFF0000FF000000FFFF0000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000000000000000000080000000FF00
      0000800000000080800000808000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FF000000FF00
      0000FFFF0000FF000000FFFF0000FF000000FF000000FF000000FF000000FF00
      0000FF00000000FF000000800000000000000000000080000000FF0000008000
      0000FF000000008080000080800080000000FF00000080000000FF0000008000
      0000008080000080800000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080808000FFFFFF00FFFFFF00FFFFFF000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000080
      0000008000000080000000FF0000000000000000000080000000FF000000FF00
      0000FF0000000080800000808000008080008000000080000000800000008000
      00000080800000808000000000000000000080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF000000FF000000800000008000000080
      000000800000008000000080000000000000FF000000FF000000FF000000FF00
      0000FF000000008080000080800000808000FF000000FF000000FF0000008000
      0000FF00000080000000800000000000000080808000FFFFFF00FFFFFF008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      00008000000080000000FFFFFF00FFFFFF000000000000000000FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF000000FF000000FF00000080
      00000080000000800000008000000000000080000000FF000000FF0000000080
      800000808000008080000080800000808000FF000000FF000000FF0000008000
      00008000000080000000FF0000000000000080808000FFFFFF00808080000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00808080000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF0000FF
      000000FF0000008000000080000000000000FF00000080000000008080000080
      800000808000008080000080800000808000FF00000000808000FF0000008000
      0000FF000000FF000000FF000000000000000000000080808000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000FFFFFF00FFFFFF00808080000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000FFFFFF00FFFFFF000000000000000000FFFF0000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF000000FF000000FF00000000000080000000FF000000FF0000000080
      800000808000008080000080800000808000008080000080800000808000FF00
      000080000000FF0000008000000000000000000000000000000080808000FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF008080
      8000FFFFFF00FFFFFF00808080000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      00008000000080808000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      0000FFFFFF00FFFFFF00FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF0000000000FF000000FF000000FF0000000080
      800000808000FF000000FF00000080000000008080000080800000808000FF00
      0000FF00000080000000FF00000000000000000000000000000080808000FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF008080
      800080808000FFFFFF00808080000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFF0000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF00000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000808000008080000080800000808000008080000080
      800080000000FF00000000000000000000000000000080808000FFFFFF00FFFF
      FF008080800080808000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF008080
      80000000000080808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00000000000000000080000000FF0000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000FF000000FF00000000000000000000000000000080808000FFFFFF00FFFF
      FF008080800000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF0000000000000000000000000000008080000080
      80000080800000808000FF000000FF00000000808000FF000000008080000080
      8000FF0000000000000000000000000000000000000000000000808080008080
      80000000000080808000FFFFFF00FFFFFF000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      800000808000FF000000FF00000080000000FF00000080000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000080000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000FFFF0000000000000000000000000000FFFF00000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000FFFFFF000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF000000FF00FFFFFF0000000000000000000000000000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000000000FFFFFF0080808000FFFFFF000000000000FFFF0000FF
      FF0000FFFF0000000000000000000000000000000000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C00000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008080000000000000000000FFFF0000FFFF0000FFFF0000000000008080
      800000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000000000FFFFFF0000FFFF008080800000FFFF00FFFFFF000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFF000000000000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000FFFF00FFFFFF0080808000FFFFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000000000FFFFFF0000FFFF00FFFFFF000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000808000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF0000FFFF0000FFFF00000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000FFFF0000FFFF0000FFFF0000000000008080
      800000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000C0C0C000FFFFFF0000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0080808000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008080000000000000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000008080000000000000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000008080000000000000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000FFFF0000FFFF0000FFFF0000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000600100000100010000000000000B00000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000FFFF000000000000FBDEFFFFFFFFFFFF0000FFDFEDE7FFFF
      00003FC78001FFFF00001FB98001FBFF00008FBD8001F9FF0000C7BD8001F8FF
      0000E23D8001F87F0000F00B8001F83F0000F80B8001F81F0000F0038001F83F
      0000F0038001F87F0000F0078001F8FF0000F8078001F9FF0000F8078001FBFF
      0000FE3F8001FFFFFFFFFFFFFFFFFFFFFFFCFFFFC001FFFC9FF9DFFFC0019FF9
      8FF38FFFC0018FF387E705BFC00187A7C3CF818FC001C38FF11FC173C001F113
      F83FE17BC001F83BFC7FC17BC001FC7BF83FFF7BC001F83BF19FFEF7C001F097
      E3CFFEF7C001E2C7C7E7FEF7C001C6E78FFBFEF7C0018EF31FFFFDEFC0031DEF
      3FFFFC6FC0073C6FFFFFFF8FC00FFF8FC4048003FBDEFF7FC98480030000C925
      C84C80030000FF7DC80480030000DFFF800080030000DFFDC00C80030000FFFD
      C00C80030000DE3F800F800300008EB8800F80030000FE3D800F80030000DFFF
      800F80030000DFFD800780030000FFFD800380030000DF7F800180070000C925
      C000800F0000FF7FE009801FFFFFFFFF89278927CCACC404BFF7BFF7DBADC984
      FFFFEABFD8DDC84CBFF79FF7DAADC804BFF7BFB38DA88480FFFFDFF3DCFDCFFC
      BFF7BFA0D87DCFFCBFE79FF3F03FFE3FFFC7FFBBC84FE31FBFE795778007F38F
      BF65BFF70003E0CFFE10FDFF8007E4CF89258827C84FE38FFFEFF07FF03FF11F
      FFC7FDFFF87FF83FFFEFFDFFFCFFFFFFC404CCACFFFFFFFFC984DBADC0077EFF
      C84CD8DD8003AEFFC804DAAD0001CEFF84808DA800018C7FCFFCDFFD0001F01F
      CFFCDFFD0000F01FFFFFFFFF0000E00FE0FFFFFF80000001E0FFFFFFC000E00F
      803F807FE001F01F803F807FC007F01F803F807F0007FC63803F807F1003FEE7
      E0FFFFFF3803FEEBE0FFFFFFFFFFFEFDFE7FC18DFFFF8003FC3FC18DFFFF8003
      F81FC18DF1838003FE1FC18DFBC78003FE7FC18DF9C78003CE73C18DF8078003
      8E71C18DFD8F80030000C18DFC8F80038000C18DFC8F8003CE71C18DFE1F8003
      EE7BC18DFE1F8003FE7FC18DFE1F8003FE7FC18DFF3F8003F81FC18DFF7F8007
      FC1FC18DFFFF800FFE3FC18DFFFF801FFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000
      800380038003FFFF000100010001FFFF000100010001C19C0001000100019C9C
      0001000100019C9C0001000100019C990001000100019C930001000100019C87
      0001000100019C8F0001000100019C870001000100019C930001000100019C99
      800380038003C19CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC007C007FFFFFFFF
      80038003FFFFDFDF00010001F007C00700010001C001C0010001000180018001
      000000000001000100000000000300038000800080018001C000C000E001E001
      E000E001F801F0018000E007000300038007F007C00FC00F8000F003FFFFFFFF
      F000F803FFFFFFFFF800FFFFFFFFFFFFFE7E800FFFFFFFFFFE7CC004FFFFFFFF
      FFFCC004FFDFFBFFFE7B800CFFCFF3FFFE67001CFFC7E3FFFC070004C003C003
      E02F001AC0018003C43F800EC0000003E43F8006C0000003F83FA002C0018003
      FC3FA002C003C003FC3FBFFEFFC7E3FFF83FA666FFCFF3FFE43FBFFEFFDFFBFF
      1E7FC001FFFFFFFF3FFFFFFFFFFFFFFFFFEFFE7FFE7EFE7EFF83FE1FFE7CFE7C
      FF01FC07FFFCFFFCC001FC01FE7BFE7B8000F800FE67FE678001F800FC07FC07
      80010000E02FE02F80010000C43FC43F80010001E43FE43F80010032F83FF83F
      8001003EFC3FFC3F8001003EFC3FFC3F87E1003EF83FF83F8001001DE43FE43F
      C00300231E7F1E7FFC3F003F3FFF3FFFFFE3FFFFFFFFFFFFFFE3FFFFFEFFFEC1
      FD80FD80FEFFFEE1FD80FD80FEFFFEC1FD80FD80FC7FFC61F8E3F8FFF01FF015
      E023E03FF01FF01FE03FE03FE00FE00FC01FC01F0001000100030003E00FE00F
      C01FC01FF01FF01FE03FE03FF01F501FE03FE03FFC7F0C7FF8FFF8FFFEFF06FF
      FDFFFDFFFEFF0EFFFDFFFDFFFEFF06FFFFFEFFFEFFFFFFE3FFFCFFFCFE01FF80
      FFFCFFFCFE01FF80FFFBFFFBFE01F700FFE7FFE7FE01F000FF07FF078001F700
      E0EFE0EF8001E380C7FFC7FF80018080E7FFE7FF800180E3FBFFFBFF80030077
      FCFFFCFF80070007FC7FFC7F800F0077F8FFF8FF800F80FFE7FFE7FF807F80FF
      1FFF1FFF80FFE3FF3FFF3FFF81FFF7FFFFFFFFFFFFFFFFFEC0FFC0FFC0FFFFFC
      BEFFBEFFBEFFFFFCBEFFBEFFBEFFFFFBDEFFDEFFDEFFFFE7DF7FDF7FDF7FFF07
      DF63DF63DF63E0EFDF1BDF1BDF1BC7FFEFFBEFFBEFFBE7FFEFFDEFFDEFFDFBFF
      EFFDEFFDEFFDFCFFEFE3EFE3EFE3FC7FF61FF61FF61FF8FFF1FFF1FFF1FFE7FF
      FFFFFFFFFFFF1FFFFFFFFFFFFFFF3FFFFBDFFFFFFFFF9188FE3FFFFFFFFF7FFE
      EC170007FFFF78FEFC1F8003FFFFF27FF62FC001FFFF673EFFFF0000FFFF679E
      FA2F8000FFFF77DEFE3FC001FFFFF3CFF6370000FFFF7BE6FC1F8000FFFF79EE
      F417C001FFFF7CCEFC1F0000FFFFFE1FE80B8000FFFFFF3FF80FC001FFFF7FFE
      E80BE000FFFF7FFEFC1FF000FFFF1118FE00FFFFFFFFFFFFFE00E0FFEDE7E007
      3E00F1FFEDDBE0071E00FBFFEBDBE0078E00FBFFA65BE007C600FBFFABDBE007
      E200FBFFAD5BE007F000FBFF972F8001F800FBFF8003C003F000F8038001E007
      F000F8078001F00FF000F80F8001F81FF800F8078001FC3FF800F8038001FE7F
      FE00FBFF8001FFFFFE00FFFFFFFFFFFFFFFFFFFFC007FDFCFFFFF81FC007F8F9
      FFFFF7EFC007F8D3FC3FEFF7C007E7408003DFFBC0079F41FC3FBFFDC0071F83
      FE7FBE7DC007BF87FEFFBC3DC007FFCFFEFFBC3DC007FFDFFEFFBE7DC007FFCF
      FEFFBFFDC007FFC7FEFFDFFBC007FFE7FEFFEFF7C007FFFBFEFFF7EFC007FFFC
      FFFFF81FC007FFFCFFFFFFFFC007FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFF
      DFFBDFFFBFFFDFFFEFF7EFFFDFFFEFFFF7EFF7FFEFFFF7FFFBDFFBFFF7FFFBFF
      FC3FFC7FFBFFFDFEFC3FFC3FFDFFDEFDFC3FFC3FFEFFDF7BFC3FFE3FFF7FDF87
      FBDFFFDFFF8FDF87F7EFFFEFFF87DF87EFF7FFF7FF87DFC7DFFBFFFBFFC7DFFF
      BFFFFFFDFFFB0000FFFFFFFFFFFDDFFFF8AFFEEEFFFFFFFFF057FCCCFE1FCFFF
      F02B3888FDEF87FFF8171CCCFBF787FFF02F8EEEF7FBC7FFF03FC7FFEFFDFBFF
      F03FE23FEFFDFDFFF83FF00F6FFDFEFF8C1FF80FAFFDFF7F060FF007C7FBFFBF
      0007F007C3F7FFDF8007F007C1EFFFE38007F80FE01FFFE1C00FF80FFDFFFFE1
      E01FFE3FFEFFFFF1F03FFFFFFF7FFFFFF80FFFFFFFFFFFFFF007FFFF8000F83F
      E00700008000E00FC00300008000C00780030000800080038001000080008003
      0001000080000001000100008000000100000000800000018000000080000001
      C000000080000001C0000000800080038001000080008003800700008000C007
      C00FFFFF8000E00FFC7FFFFFFFFFF83FFE48FFFF8001FFFFFEFEFC7F0000FE7F
      3FFFFC7F0000FE3F1EFED8370000DC3F8EFEE00F0000CC7FC7FFE00F0000C07F
      E23EC0070000C0FFF00EC0070000C01FF80F8003E007C03FF006C007E007C07F
      F006C007E007C0FFF007E00FE007C1FFF80EE00FE00FC3FFF80ED837E01FC7FF
      FE3FFEFFE03FCFFFFE24FFFFE07FDFFFFFFFFFF9FFE7FFFFFC7FFFF9FFE7FFFF
      FC7F3FF93F813F81FC7F1FF91F811F81FC7F8FE18FE78FFFFC7FC7F1C7E7C7FF
      F83FE239E23FE23FF01FF00DF00FF00FF01FF80FF80FF80FF01FF007F007F007
      F83FF007F007F007FC7FF007F007F007FFFFF80FF80FF80FFFFFF80FF80FF80F
      FFFFFE3FFE3FFE3FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu: TPopupMenu
    Images = ImageList
    Left = 112
    Top = 256
  end
  object pmCoords: TPopupMenu
    Images = ImageList
    Left = 152
    Top = 256
    object N27: TMenuItem
      Action = acCopySelected
    end
    object N28: TMenuItem
      Action = acCopyAll
    end
    object N33: TMenuItem
      Caption = '-'
      Visible = False
    end
    object N34: TMenuItem
      Action = acPastePoints
      Visible = False
    end
    object N35: TMenuItem
      Action = acPasteAndReplace
      Visible = False
    end
    object N30: TMenuItem
      Caption = '-'
      Visible = False
    end
    object N31: TMenuItem
      Action = acInsertPoint
    end
    object N36: TMenuItem
      Action = acEditPoint
    end
    object N32: TMenuItem
      Action = acDeletePoint
    end
    object N6: TMenuItem
      Caption = '-'
      Visible = False
    end
    object DXF2: TMenuItem
      Action = acExport2DXF
      Visible = False
    end
  end
  object pmObjects: TPopupMenu
    Images = ImageList
    OnPopup = pmObjectsPopup
    Left = 88
    Top = 120
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'dxf'
    Filter = 'AutoCAD .dxf files|*.dxf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 104
    Top = 312
  end
  object ObjectsImageList: TImageList
    Left = 460
    Top = 224
    Bitmap = {
      494C010112001300200210001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000060
      0000006000000060000000600000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000060
      0000006000000060000000600000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000600000000000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000600000000000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000600000000000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000600000000000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000241CED00241C
      ED00000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000241CED00241C
      ED00000000000000000000000000000000000060000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000000000000000000060
      0000006000000060000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000000000000000000060
      0000006000000060000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000241CED00241C
      ED00000000000000000000000000000000000060000000600000006000000000
      0000000000000060000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000600000006000000000
      0000000000000060000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000241CED00241C
      ED00000000000000000000000000000000000000000000000000000000000000
      0000000000000060000000000000000000000000000000000000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000060000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000241C
      ED00241CED000000000000000000000000000000000000000000000000000000
      000000000000000000000060000000000000000000000000000000000000241C
      ED00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000060
      0000241CED00241CED0000000000000000000000000000000000000000000000
      0000000000000000000000600000000000000000000000000000241CED00241C
      ED00241CED000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000060
      000000000000241CED00241CED00000000000000000000000000000000000060
      00000060000000600000000000000000000000000000241CED00241CED00241C
      ED00241CED00241CED0000000000000000000000000000000000000000000060
      0000006000000060000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000241CED00241CED00000000000000
      000000600000241CED00241CED00006000000060000000600000006000000000
      000000000000000000000000000000000000241CED00241CED00241CED000000
      0000241CED00241CED00241CED00006000000060000000600000006000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000241CED00241CED00000000000000
      000000600000241CED00241CED00000000000000000000000000000000000000
      000000000000000000000000000000000000241CED00241CED00000000000000
      000000600000241CED00241CED00241CED000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000241CED00241CED00241C
      ED00241CED00241CED0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000241CED00241CED00241CED0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000241CED00241C
      ED00241CED000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000241CED00241CED0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008000E0008000
      E0008000E0008000E0008000E0008000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BE92
      7000BE927000BE9270000000000000000000000000008000E0004040C0004040
      C0004040C0004040C0004040C0008000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCFF
      CC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFF
      CC00CCFFCC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BE927000BE92
      7000C3C3C300BE927000BE92700000000000000000008000E0004040C0004040
      C0004040C0004040C0004040C0008000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCFF
      CC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFF
      CC00CCFFCC000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000000000000000000000000000BE927000C3C3
      C300C3C3C300C3C3C300BE9270000000000000000000000000008000E0004040
      C0004040C0004040C0004040C0008000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCFF
      CC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFF
      CC00CCFFCC000000000000000000000000008080800000000000000000000000
      0000000000000000000080808000000000000000000000000000BE927000BE92
      7000C3C3C300BE927000BE9270000000000000000000000000008000E0004040
      C0004040C0004040C0004040C0004040C0008000E00000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000008080800000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCFF
      CC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFF
      CC00CCFFCC000000000000000000000000008080800000000000000000000000
      000000000000000000008080800000000000000000000000000000000000BE92
      7000BE927000BE927000000000000000000000000000000000008000E0004040
      C0004040C0004040C0004040C0004040C0008000E00000000000000000008000
      E0008000E0008000E00000000000000000000000000000000000808080000000
      0000000000000000000000000000000000008080800000000000000000008080
      800080808000808080000000000000000000000000000000000000000000CCFF
      CC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFF
      CC00CCFFCC000000000000000000000000000000000080808000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008000E0004040
      C0004040C0004040C0004040C0004040C0008000E0008000E0008000E0004040
      C0004040C0008000E00000000000000000000000000000000000808080000000
      0000000000000000000000000000000000008080800080808000808080000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E0004040C0004040C0004040C0004040C0004040C0004040C0004040C0004040
      C0004040C0008000E00000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000808080000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF000080808000FFFF0000FFFF000080808000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000008000
      E0004040C0004040C0004040C0004040C0004040C0004040C0004040C0004040
      C0004040C0004040C0008000E000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000000000000000000000000000000000FFFF
      0000FFFF0000FFFF000080808000808080008080800080808000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000808080000000000000000000000000000000000000000000000000008000
      E0004040C0004040C0004040C0004040C0004040C0004040C0004040C0004040
      C0004040C0004040C0008000E000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000008000
      E0004040C0004040C0004040C0004040C0004040C0004040C0004040C0008000
      E0008000E0008000E00000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000008080
      800080808000808080000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      00008000E0004040C0004040C0008000E0008000E0008000E0008000E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      00008000E0008000E0008000E000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CCFFCC00CCFF
      CC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFFCC00CCFF
      CC00CCFFCC00CCFFCC0000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000060
      0000006000000060000000600000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000800000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      800000000000000000000000000000000000000000000060000000C0600000C0
      600000C0600000C0600000C06000006000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000804040008040
      4000804040008040400080404000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000060000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800080808000808080008080
      800000000000000000000000000000000000000000000060000000C0600000C0
      600000C0600000C0600000C06000006000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000804040008040
      4000804040008040400080404000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000008000
      0000006000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00000000008080800080808000808080008080
      80000000000000000000000000000000000000000000000000000060000000C0
      600000C0600000C0600000C06000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008040
      4000804040008040400080404000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00000000008080800080808000808080008080
      80000000000000000000000000000000000000000000000000000060000000C0
      600000C0600000C0600000C0600000C060000060000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008040
      400080404000804040008040400080404000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000000600000006000000000FF000000FF000000FF000000FF00000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000008080800080808000808080008080
      80000000000000000000000000000000000000000000000000000060000000C0
      600000C0600000C0600000C0600000C060000060000000000000000000000060
      0000006000000060000000000000000000000000000000000000FF0000008040
      400080404000804040008040400080404000FF0000000000000000000000FF00
      0000FF000000FF000000000000000000000000000000000000008000000000FF
      FF0080000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      80000000000000000000000000000000000000000000000000000060000000C0
      600000C0600000C0600000C0600000C0600000600000006000000060000000C0
      600000C060000060000000000000000000000000000000000000FF0000008040
      400080404000804040008040400080404000FF000000FF000000FF0000008040
      400080404000FF00000000000000000000000000000000000000000000008000
      000000600000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000800000008000000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000000000000060
      000000C0600000C0600000C0600000C0600000C0600000C0600000C0600000C0
      600000C06000006000000000000000000000000000000000000000000000FF00
      0000804040008040400080404000804040008040400080404000804040008040
      400080404000FF00000000000000000000000000000000000000000000000000
      000000000000006000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000060
      000000C0600000C0600000C0600000C0600000C0600000C0600000C0600000C0
      600000C0600000C060000060000000000000000000000000000000000000FF00
      0000804040008040400080404000804040008040400080404000804040008040
      40008040400080404000FF000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000800000008000000080000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000060
      000000C0600000C0600000C0600000C0600000C0600000C0600000C0600000C0
      600000C0600000C060000060000000000000000000000000000000000000FF00
      0000804040008040400080404000804040008040400080404000804040008040
      40008040400080404000FF000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000060
      000000C0600000C0600000C0600000C0600000C0600000C0600000C060000060
      000000600000006000000000000000000000000000000000000000000000FF00
      000080404000804040008040400080404000804040008040400080404000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000006000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000060000000C0600000C06000006000000060000000600000006000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000008040400080404000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000060
      000000600000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006000000060000000600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000600000006000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000E000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000800000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000008000E00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000060000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000008000
      00008000E0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000008000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000006000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF0000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000600000006000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000008000
      00008000E0008000E0000000FF000000FF000000FF000000FF00000000008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF000000FF000000FF000000FF0000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF000000FF0000000000FF000000FF000000FF000000FF00000000008000
      0000000000000000000000000000000000000000000000000000000000008000
      0000006000000060000000600000006000000000000000000000000000008000
      00000000000000000000000000000000000000000000000000008000000000FF
      FF0080000000000000000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008000000000FF
      FF0080000000000000000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      00008000E000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FF000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000006000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000E0000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000060000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000E0000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000060000000600000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E0008000E000000000000000FF000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000060
      0000006000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000800000008000E0008000E0000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FF000000FF0000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000008000000000600000006000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008000000000000000000000008000E0008000
      E0008000E0008000E0008000E0008000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000060
      0000006000000060000000600000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF00000000008000E000000000000000
      00000000000000000000000000008000E0000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000600000000000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000E00080000000000000008000E000000000000000
      00000000000000000000000000008000E0000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000600000000000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000E000000000000000000000000000000000008000E0000000
      00000000000000000000000000008000E0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000000
      0000000000000000000000000000006000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      00008000E00000000000000000000000000000000000000000008000E0000000
      0000000000000000000000000000000000008000E00000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000E0008000E0008000000000FF
      FF008000000000000000000000000000000000000000000000008000E0000000
      0000000000000000000000000000000000008000E00000000000000000008000
      E0008000E0008000E00000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF0000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000000000000000000060
      0000006000000060000000000000000000000000000000000000000000008000
      00008000E0008000E0008000E0008000E0000000000000000000000000008000
      00000000000000000000000000000000000000000000000000008000E0000000
      0000000000000000000000000000000000008000E0008000E0008000E0000000
      0000000000008000E00000000000000000000000000000000000FF0000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      000000000000FF00000000000000000000000000000000000000006000000000
      0000000000000000000000000000000000000060000000600000006000000000
      00000000000000600000000000000000000000000000000000008000000000FF
      FF00800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000008000E0000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000060000000000000000000000000000000000000000000008000
      00008000E0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000E00000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000000000000000000000000000000000000000
      0000000000008000E00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008000E00000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000000000000000000000000000000000000000
      000000000000000000008000E000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E000000000000000000000000000000000000000000000000000000000008000
      E0008000E0008000E0000000000000000000000000000000000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000060
      0000000000000000000000000000000000000000000000000000000000000060
      0000006000000060000000000000000000000000000000000000000000000000
      000000000000000000008000000000FFFF008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000E00000000000000000008000E0008000E0008000E0008000E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006000000000000000000000006000000060000000600000006000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000E0008000E000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000E0008000E0008000E000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006000000060000000600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      E0008000E0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000800000008000E0008000E0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000C0FFC0FF00000000
      BEFFBEFF00000000BEFFBEFF00000000CEFFDEFF00000000CF7FDF7F00000000
      DF63DF6300000000CF1BDF1B00000000CFFBEFFB00000000E7FDEFFD00000000
      E3FDC7FD00000000E9E383E300000000301F101F0000000031FF30FF00000000
      83FFFC7F00000000C7FFFE7F00000000FFFFFFFFFFFFFFE3C0FFC0FFC003FFC1
      80FFBEFFC003FF8080FFBEFFC0038180C0FFDEFFC0037D80C07FDF7FC0037DC1
      C063DF63C003BDE3C003DF1BC003BEFFE003EFFBC003BEC7E001EFFDC003BE37
      E001EFFDC003DFF7E003EFE3C003DFFBF01FF61F8001DFFBF1FFF1FF8001DFC7
      FFFFFFFF8001EC3FFFFFFFFFFFFFE3FFFE7EFFFFFFFFFFFFFE7CE007C0FFC0FF
      FFFCE00780FF80FFFE7BE00780FF80FFFE67E007C0FFC0FFFC07E007C07FC07F
      E02FE007C063C063C43F8001C003C003E43FC003E003E003F83FE007E001E001
      FC3FF00FE001E001FC3FF81FE003E003F83FFC3FF01FF01FE43FFE7FF1FFF1FF
      1E7FFFFFFFFFFFFF3FFFFFFFFFFFFFFFFE7EFFFEFE7EFFFEFE7CFFFCFE7CFFFC
      FFFCFFFCFFFCFFFCFE7BFFFBFE7BFFFBFE67FFE7FE67FFE7FC07FF07FC07FF07
      E02FE0EFE02FE0EFC43FC7FFC43FC7FFE43FE7FFE43FE7FFF83FFBFFF83FFBFF
      FC3FFCFFFC3FFCFFFC3FFC7FFC3FFC7FF83FF8FFF83FF8FFE43FE7FFE43FE7FF
      1E7F1FFF1E7F1FFF3FFF3FFF3FFF3FFFFFFFFFFFFFFFFFFEC0FFC0FFC0FFFFFC
      BEFFBEFFBEFFFFFCBEFFBEFFBEFFFFFBDEFFDEFFDEFFFFE7DF7FDF7FDF7FFF07
      DF63DF63DF63E0EFDF1BDF1BDF1BC7FFEFFBEFFBEFFBE7FFEFFDEFFDEFFDFBFF
      EFFDEFFDEFFDFCFFEFE3EFE3EFE3FC7FF61FF61FF61FF8FFF1FFF1FFF1FFE7FF
      FFFFFFFFFFFF1FFFFFFFFFFFFFFF3FFF00000000000000000000000000000000
      000000000000}
  end
  object ActionLauncher: TEzActionLauncher
    CmdLine = CmdLine
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursorFrame, mdFullViewCursor]
    Left = 501
    Top = 188
  end
  object alReport: TActionList
    Images = ImageList
    Left = 461
    Top = 188
    object acReportPrint: TAction
      Hint = #1055#1077#1095#1072#1090#1072#1090#1100' '#1086#1090#1095#1077#1090
      ImageIndex = 53
      OnExecute = acReportPrintExecute
      OnUpdate = acReportPrintUpdate
    end
    object acReportCancel: TAction
      Hint = #1047#1072#1082#1086#1085#1095#1080#1090#1100' '#1087#1086#1076#1075#1086#1090#1086#1074#1082#1091' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 66
      OnExecute = acReportCancelExecute
    end
    object acReportPrinterSetUp: TAction
      Hint = #1053#1072#1089#1090#1088#1086#1080#1090#1100' '#1087#1088#1080#1085#1090#1077#1088
      ImageIndex = 52
      OnExecute = acReportPrinterSetUpExecute
    end
    object acReportPageVisibility: TAction
      Hint = #1042#1082#1083#1102#1095#1080#1090#1100'/'#1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1089#1090#1088#1072#1085#1080#1094#1091
      OnExecute = acReportPageVisibilityExecute
      OnUpdate = acReportPageVisibilityUpdate
    end
    object acReportNumbersVisibility: TAction
      Checked = True
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100'/'#1089#1087#1088#1103#1090#1072#1090#1100' '#1085#1086#1084#1077#1088#1072' '#1089#1090#1088#1072#1085#1080#1094
      ImageIndex = 63
      OnExecute = acReportNumbersVisibilityExecute
    end
    object acReportAddText: TAction
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1085#1072' '#1086#1090#1095#1077#1090
      ImageIndex = 64
      OnExecute = acReportAddTextExecute
      OnUpdate = acReportAddTextUpdate
    end
    object acReportDeleteText: TAction
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1089' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 65
      OnExecute = acReportDeleteTextExecute
      OnUpdate = acReportDeleteTextUpdate
    end
    object acReportLotParams: TAction
      Hint = #1058#1086#1083#1097#1080#1085#1072' '#1083#1080#1085#1080#1081
      ImageIndex = 61
      OnExecute = acReportLotParamsExecute
      OnUpdate = acReportLotParamsUpdate
    end
    object acReportNextPage: TAction
      Hint = #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
      ImageIndex = 50
      OnExecute = acReportNextPageExecute
    end
    object acReportPrevPage: TAction
      Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
      ImageIndex = 51
      OnExecute = acReportPrevPageExecute
    end
    object acReportSetScale: TAction
    end
    object acReportPointSize: TAction
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1088#1072#1079#1084#1077#1088' '#1090#1086#1095#1082#1080
      ImageIndex = 67
      OnExecute = acReportPointSizeExecute
      OnUpdate = acReportPointSizeUpdate
    end
    object acReportFont: TAction
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1096#1088#1080#1092#1090
      ImageIndex = 62
      OnExecute = acReportFontExecute
    end
    object acReportMovePrintArea: TAction
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 68
      OnExecute = acReportMovePrintAreaExecute
    end
    object acReportEditPrintArea: TAction
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 69
      OnExecute = acReportEditPrintAreaExecute
    end
    object acReportMoveText: TAction
      Hint = #1057#1076#1074#1080#1085#1091#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
      ImageIndex = 70
      OnExecute = acReportMoveTextExecute
      OnUpdate = acReportMoveTextUpdate
    end
    object acReportRotateText: TAction
      Hint = #1055#1086#1074#1077#1088#1085#1091#1090#1100' '#1090#1077#1082#1089#1090
      ImageIndex = 71
      OnExecute = acReportRotateTextExecute
      OnUpdate = acReportRotateTextUpdate
    end
    object acReportEditText: TAction
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090
      ImageIndex = 72
      OnExecute = acReportEditTextExecute
      OnUpdate = acReportEditTextUpdate
    end
    object acReportTableSettings: TAction
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1074#1080#1076#1072' '#1090#1072#1073#1083#1080#1094#1099
      ImageIndex = 74
      OnExecute = acReportTableSettingsExecute
      OnUpdate = acReportTableSettingsUpdate
    end
    object acReportPageSetup: TAction
      Hint = #1085#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1090#1088#1072#1085#1080#1094#1099
      ImageIndex = 78
      OnExecute = acReportPageSetupExecute
    end
    object acReportEditTable: TAction
      Caption = 'acReportEditTable'
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1091
      ImageIndex = 80
      OnExecute = acReportEditTableExecute
      OnUpdate = acReportEditTableUpdate
    end
    object acReportContoursParams: TAction
      Caption = 'acReportContoursParams'
      OnExecute = acReportContoursParamsExecute
    end
    object acLayers: TAction
      Category = 'Admin'
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1083#1086#1103#1084#1080'...'
      OnExecute = acLayersExecute
      OnUpdate = acLayersUpdate
    end
    object acImportMidMif: TAction
      Category = 'Admin'
      Caption = #1048#1084#1087#1086#1088#1090' MID/MIF '#1074' '#1085#1086#1074#1099#1081' '#1089#1083#1086#1081'...'
      OnExecute = acImportMidMifExecute
    end
    object acLayerBrowser: TAction
      Category = 'Admin'
      Caption = #1054#1090#1088#1099#1090#1100' '#1073#1088#1072#1091#1079#1077#1088' '#1089#1083#1086#1103
      OnExecute = acLayerBrowserExecute
      OnUpdate = acLayerBrowserUpdate
    end
    object acProjectAdd: TAction
      Category = 'Projects'
      Caption = #1053#1086#1074#1099#1081'...'
      Visible = False
    end
    object acProjectBrowse: TAction
      Category = 'Projects'
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1093'...'
      OnExecute = acProjectBrowseExecute
    end
    object acProjectFindByAddress: TAction
      Category = 'Projects'
      Caption = #1053#1072#1081#1090#1080' '#1087#1086' '#1072#1076#1088#1077#1089#1091'...'
      OnExecute = acProjectFindByAddressExecute
    end
    object acProjectAdd2: TAction
      Category = 'Projects'
      Caption = #1048#1084#1087#1086#1088#1090' '#1087#1088#1086#1077#1082#1090#1072' '#1080#1079' '#1092#1072#1081#1083#1072'...'
      OnExecute = acProjectAdd2Execute
    end
    object acProjectExport: TAction
      Category = 'Projects'
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' mid/mif...'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099' '#1074' '#1092#1072#1081#1083' mid/mif'
      OnExecute = acProjectExportExecute
      OnUpdate = acProjectExportUpdate
    end
    object acMPClassSettings: TAction
      Category = 'MP'
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088'...'
      OnExecute = acMPClassSettingsExecute
    end
    object acMPPickupPoints: TAction
      Category = 'MP'
      Caption = #1057#1085#1103#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1089' '#1082#1072#1088#1090#1099
      OnExecute = acMPPickupPointsExecute
      OnUpdate = acMPPickupPointsUpdate
    end
    object acMPExportMidMif: TAction
      Category = 'MP'
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1077#1090#1080' '#1074' mid/mif...'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1089#1077#1090#1080' '#1074' '#1092#1072#1081#1083' mid/mif'
      OnExecute = acMPExportMidMifExecute
      OnUpdate = acMPExportMidMifUpdate
    end
    object acMPLoadRect: TAction
      Category = 'MP'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1077#1090#1080' '#1087#1086' '#1086#1073#1083#1072#1089#1090#1080
      OnExecute = acMPLoadRectExecute
      OnUpdate = acMPLoadRectUpdate
    end
  end
  object MidMifDialog: TOpenDialog
    DefaultExt = '.mif'
    Filter = #1060#1072#1081#1083#1099' MapInfo (MIF/MID)|*.mif'
    Title = #1048#1084#1087#1086#1088#1090' MIF/MID'
    Left = 104
    Top = 440
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = 'mif'
    Filter = 'MapInfo '#1092#1072#1081#1083'|*.mif'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 136
    Top = 312
  end
end
