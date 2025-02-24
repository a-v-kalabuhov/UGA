object Form1: TForm1
  Left = 70
  Top = 170
  Caption = 'EzGIS Main'
  ClientHeight = 705
  ClientWidth = 819
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 32
    Top = 118
    Width = 723
    Height = 546
    Align = alClient
    BevelOuter = bvNone
    Color = clAppWorkSpace
    TabOrder = 8
  end
  object CmdLine1: TEzCmdLine
    Left = 0
    Top = 664
    Width = 819
    Height = 22
    DrawBoxList = <>
    DynamicUpdate = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Color = clWhite
    Align = alBottom
    TabOrder = 0
    TabStop = False
    OnAccuDrawActivate = CmdLine1AccuDrawActivate
    OnAccuDrawChange = CmdLine1AccuDrawChange
    OnAccuSnapChange = CmdLine1AccuSnapChange
    OnStatusMessage = CmdLine1StatusMessage
    OnAfterCommand = CmdLine1AfterCommand
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 686
    Width = 819
    Height = 19
    AutoHint = True
    Panels = <
      item
        Width = 600
      end>
    SizeGrip = False
    object bar1: TProgressBar
      Left = 212
      Top = 2
      Width = 188
      Height = 17
      TabOrder = 0
      Visible = False
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 819
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Spacing = 0
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 25
    Width = 819
    Height = 31
    ActionManager = ActionManager1
    Caption = 'ActionToolBar1'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    EdgeBorders = [ebTop]
    Spacing = 0
  end
  object ActionToolBar2: TActionToolBar
    Left = 0
    Top = 56
    Width = 819
    Height = 32
    ActionManager = ActionManager1
    Caption = 'ActionToolBar2'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    EdgeBorders = [ebTop, ebBottom]
    Spacing = 0
  end
  object ActionToolBar3: TActionToolBar
    Left = 787
    Top = 118
    Width = 32
    Height = 546
    ActionManager = ActionManager1
    Align = alRight
    Caption = 'ActionToolBar3'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    EdgeBorders = [ebLeft]
    Spacing = 0
  end
  object ActionToolBar4: TActionToolBar
    Left = 0
    Top = 118
    Width = 32
    Height = 546
    ActionManager = ActionManager1
    Align = alLeft
    Caption = 'ActionToolBar4'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    EdgeBorders = [ebRight]
    Spacing = 0
  end
  object ActionToolBar6: TActionToolBar
    Left = 755
    Top = 118
    Width = 32
    Height = 546
    ActionManager = ActionManager1
    Align = alRight
    Caption = 'ActionToolBar6'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    EdgeBorders = [ebLeft]
    Spacing = 0
  end
  object ActionToolBar5: TActionToolBar
    Left = 0
    Top = 88
    Width = 819
    Height = 30
    ActionManager = ActionManager1
    Caption = 'ActionToolBar5'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    Spacing = 0
  end
  object GIS1: TEzGIS
    Active = False
    LayersSubdir = 'C:\D6\Bin\'
    PolygonClipOperation.Operation = pcInt
    FontShadowColor = clGray
    FontShadowOffset = 2
    OnBeforePaintLayer = GIS1BeforePaintLayer
    OnAfterPaintLayer = GIS1AfterPaintLayer
    OnFileNameChange = GIS1FileNameChange
    OnBeforePaintEntity = GIS1BeforePaintEntity
    OnProgress = GIS1Progress
    OnShowDirection = GIS1ShowDirection
    OnAfterInsertLayer = GIS1AfterInsertLayer
    OnPrintBegin = GIS1PrintBegin
    OnPrintProgress = GIS1PrintProgress
    OnPrintEnd = GIS1PrintEnd
    OnAfterDragDrop = GIS1AfterDragDrop
    OnGisTimer = GIS1GisTimer
    Left = 136
    Top = 152
  end
  object EzGeorefImage1: TEzGeorefImage
    GeorefPoints = <>
    Left = 168
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'DXF'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Import File'
    Left = 204
    Top = 152
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'DXF'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Export File'
    Left = 239
    Top = 155
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'Bmp'
    Filter = 'Windows Bitmaps (*.bmp)|*.bmp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Define bitmap file'
    Left = 288
    Top = 152
  end
  object Preferences1: TEzModifyPreferences
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
    Left = 136
    Top = 180
  end
  object OpenDialog3: TOpenDialog
    DefaultExt = 'DWG'
    Filter = 'AutoCAD DWG files (*.DWG)|*.DWG'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Define AutoCAD DWG file'
    Left = 203
    Top = 179
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = 'htm'
    Filter = 'HTML files (*.htm)|*.htm'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Export as HTML map'
    Left = 242
    Top = 185
  end
  object SaveDialog3: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Windows Bitmap files (*.bmp)|*.bmp'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Create Thumnail Bitmap'
    Left = 242
    Top = 217
  end
  object OpenDialog7: TOpenDialog
    DefaultExt = 'EZD'
    Filter = 'Map Layers (*.EZD)|*.EZD'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Add Layer'
    Left = 289
    Top = 183
  end
  object OpenDialog4: TOpenDialog
    DefaultExt = 'fnt'
    Filter = 'Fuentes vectoriales (*.fnt)|*.fnt'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Agrega fuente vectorial'
    Left = 288
    Top = 212
  end
  object OpenDialog5: TOpenDialog
    DefaultExt = 'ezs'
    Filter = 'Archivo de simbolos (*.ezs)|*.ezs'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Cargar archivo de simbolos'
    Left = 288
    Top = 240
  end
  object OpenDialog6: TOpenDialog
    DefaultExt = 'ezl'
    Filter = 'Archivos de tipos de linea (*.ezl)|*.ezl'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Cargar archivo de tipos de linea'
    Left = 288
    Top = 268
  end
  object Timer1: TTimer
    Enabled = False
    Left = 72
    Top = 160
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
      end
      item
      end
      item
        Items = <
          item
            Items = <
              item
                Action = Action4
              end
              item
                Action = FileOpen1
                ImageIndex = 1
                ShortCut = 16463
              end
              item
                Action = FilePrintSetup1
              end
              item
                Action = Action6
              end
              item
                Action = Action7
              end
              item
                Action = Action8
              end
              item
                Action = Action9
              end
              item
                Action = actPrintPreview
              end
              item
                Action = Action12
                ImageIndex = 3
              end>
            Caption = '&File'
          end>
      end
      item
        Items = <
          item
            Items = <
              item
                Action = Action4
                ImageIndex = 1
              end
              item
                Action = FileOpen1
                ImageIndex = 2
                ShortCut = 16463
              end
              item
                Action = Action6
                ImageIndex = 4
              end
              item
                Caption = '-'
              end
              item
                Action = Action8
              end
              item
                Caption = '-'
              end
              item
                Action = Action9
              end
              item
                Action = Action7
              end
              item
                Caption = '-'
              end
              item
                Action = FilePrintSetup1
                ImageIndex = 98
              end
              item
                Action = actPrintPreview
                ImageIndex = 6
              end
              item
                Caption = '-'
              end
              item
                Action = Action12
                ImageIndex = 94
              end>
            Caption = '&File'
          end
          item
            Items = <
              item
                Action = EditUndo1
                ImageIndex = 9
                ShortCut = 16474
              end
              item
                Caption = '-'
              end
              item
                Action = EditCut1
                ImageIndex = 12
                ShortCut = 16472
              end
              item
                Action = EditCopy1
                ImageIndex = 13
                ShortCut = 16451
              end
              item
                Action = EditPaste1
                ImageIndex = 14
                ShortCut = 16470
              end
              item
                Action = Action17
                ImageIndex = 14
              end
              item
                Action = EditDelete1
                ImageIndex = 99
                ShortCut = 46
              end
              item
                Action = Action19
                Caption = 'C&lear Clipboard Data'
              end
              item
                Caption = '-'
              end
              item
                Action = Action20
                Caption = 'D&rop'
              end
              item
                Caption = '-'
              end
              item
                Action = Action21
                ImageIndex = 13
              end
              item
                Action = Action22
                Caption = 'P&aste And Define Position As Text'
                ImageIndex = 14
              end
              item
                Caption = '-'
              end
              item
                Action = Action23
                ImageIndex = 13
              end
              item
                Action = Action24
                ImageIndex = 13
              end
              item
                Caption = '-'
              end
              item
                Action = Action25
              end
              item
                Action = Action26
                Caption = 'U&ngroup'
              end
              item
                Caption = '-'
              end
              item
                Action = Action27
                ImageIndex = 35
              end
              item
                Action = Action28
                Caption = '&Send to Back'
                ImageIndex = 37
              end
              item
                Caption = '-'
              end
              item
                Action = Action29
              end
              item
                Action = Action31
                Caption = 'ARRA&Y from selection...'
              end
              item
                Action = Action32
                Caption = 'Delete Repet&itions...'
              end>
            Caption = '&Edit'
          end
          item
            Items = <
              item
                Items = <
                  item
                    Action = actSketch
                    ImageIndex = 114
                  end
                  item
                    Action = Action33
                    Caption = 'P&oint'
                    ImageIndex = 71
                  end
                  item
                    Action = Action34
                    ImageIndex = 68
                  end
                  item
                    Action = actSymbolMult
                    Caption = 'S&ymbols (Multiple)'
                    ImageIndex = 102
                  end
                  item
                    Action = actTextPlace
                    Caption = '&Text Place'
                    ImageIndex = 69
                  end
                  item
                    Action = Action35
                    ImageIndex = 62
                  end
                  item
                    Action = Action36
                    ImageIndex = 70
                  end
                  item
                    Action = actRounded
                    Caption = '&Rounded Polyline'
                    ImageIndex = 100
                  end
                  item
                    Action = Action37
                    ImageIndex = 72
                  end
                  item
                    Action = Action38
                    Caption = 'R&ectangle'
                    ImageIndex = 75
                  end
                  item
                    Action = Action43
                    Caption = 'B&uffer'
                    ImageIndex = 103
                  end
                  item
                    Action = Action42
                    Caption = 'Insert Bloc&k'
                    ImageIndex = 8
                  end
                  item
                    Action = Action41
                    Caption = 'Spl&ine'
                    ImageIndex = 82
                  end
                  item
                    Action = Action40
                    Caption = 'E&llipse'
                    ImageIndex = 56
                  end
                  item
                    Action = actCircleCR
                    Caption = 'Circle (Center,Ra&dius)'
                    ImageIndex = 107
                  end
                  item
                    Action = actCircle3P
                    Caption = 'Circle (&3 points)'
                    ImageIndex = 106
                  end
                  item
                    Action = Action39
                    ImageIndex = 39
                  end
                  item
                    Action = actArcSCE
                    Caption = 'Arc (Start A&ngle, Center, Sweep Angle)'
                    ImageIndex = 105
                  end
                  item
                    Action = actArcCRSE
                    Caption = '&Arc (Center,Radius,Start,End)'
                    ImageIndex = 104
                  end
                  item
                    Action = actDimParallel
                    Caption = 'Di&m Parallel'
                    ImageIndex = 53
                  end
                  item
                    Action = actDimVertical
                    ImageIndex = 54
                  end
                  item
                    Action = actDimHoriz
                    ImageIndex = 52
                  end>
                Caption = '&Most Common'
              end
              item
                Items = <
                  item
                    Action = Action49
                    ImageIndex = 44
                  end
                  item
                    Action = Action48
                    ImageIndex = 45
                  end
                  item
                    Action = Action47
                    Caption = 'B&anner Text'
                    ImageIndex = 42
                  end
                  item
                    Action = Action46
                    ImageIndex = 85
                  end
                  item
                    Action = Action45
                    ImageIndex = 61
                  end
                  item
                    Action = Action44
                    ImageIndex = 57
                  end>
                Caption = '&Text Entities'
              end
              item
                Items = <
                  item
                    Action = Action52
                    ImageIndex = 41
                  end
                  item
                    Action = Action51
                    ImageIndex = 66
                  end
                  item
                    Action = Action50
                    ImageIndex = 92
                  end>
                Caption = 'Ima&ges'
              end>
            Caption = 'E&ntity'
          end
          item
            Items = <
              item
                Action = Action54
              end
              item
                Action = Action55
              end
              item
                Caption = '-'
              end
              item
                Action = Action56
                ImageIndex = 36
                ShortCut = 16460
              end
              item
                Action = actBrowse
                ImageIndex = 34
              end
              item
                Action = Action58
              end
              item
                Action = Action59
              end
              item
                Caption = '-'
              end
              item
                Action = Action60
              end
              item
                Caption = '-'
              end
              item
                Action = Action61
                Caption = '&Quick Update Extension'
              end
              item
                Action = Action62
                Caption = 'U&pdate Extension'
              end
              item
                Caption = '-'
              end
              item
                Action = Action63
                Caption = 'Re&structure Layer...'
              end
              item
                Action = Action15
              end
              item
                Action = Action64
                Caption = 'Pa&ck Layer...'
              end>
            Caption = '&Layer'
          end
          item
            Items = <
              item
                Action = actRepaint
                ImageIndex = 33
                ShortCut = 116
              end
              item
                Caption = '-'
              end
              item
                Action = Action66
                Caption = '&Pan'
                ImageIndex = 80
                ShortCut = 16464
              end
              item
                Items = <
                  item
                    Action = actZoomAll
                    Caption = '&Zoom All'
                    ImageIndex = 87
                  end
                  item
                    Action = Action67
                    ImageIndex = 88
                  end
                  item
                    Action = Action68
                    ImageIndex = 89
                  end
                  item
                    Action = Action69
                    ImageIndex = 74
                  end
                  item
                    Action = actZoomWin
                    ImageIndex = 0
                  end
                  item
                    Action = Action72
                  end
                  item
                    Action = Action73
                  end
                  item
                    Action = Action74
                    Caption = 'Z&oom Extension'
                  end>
                Caption = '&Zoom'
              end
              item
                Caption = '-'
              end
              item
                Action = actViewGrid
              end
              item
                Caption = '-'
              end
              item
                Action = Action76
              end
              item
                Action = Action77
                Caption = 'Show &Coords'
              end
              item
                Action = actShowCmdLine
                Caption = 'Show Co&mmand Line'
              end
              item
                Caption = '-'
              end
              item
                Action = Action79
                Caption = '&Aerial View'
              end
              item
                Action = actNamedViews
              end>
            Caption = '&View'
          end
          item
            Items = <
              item
                Action = Action81
              end
              item
                Action = Action82
              end
              item
                Caption = '-'
              end
              item
                Action = Action83
              end
              item
                Caption = '-'
              end
              item
                Action = Action84
              end
              item
                Action = Action85
              end
              item
                Caption = '-'
              end
              item
                Action = Action86
              end
              item
                Action = Action87
                Caption = 'Fi&t text to path'
              end
              item
                Caption = '-'
              end
              item
                Action = actOrto
              end
              item
                Items = <
                  item
                    Action = Action89
                  end
                  item
                    Action = Action90
                  end
                  item
                    Action = Action91
                  end>
                Caption = 'Clippi&ng'
              end
              item
                Action = Action92
                Caption = 'C&lear Clip Boundary'
              end
              item
                Caption = '-'
              end
              item
                Action = Action11
              end
              item
                Action = Action93
                Caption = 'G&eoreferenced Image...'
              end>
            Caption = '&Define'
          end
          item
            Items = <
              item
                Items = <
                  item
                    Action = Action94
                    Caption = '&Select Rectangle'
                    ImageIndex = 76
                  end
                  item
                    Action = Action95
                    Caption = 'S&elect Circle'
                    ImageIndex = 91
                  end
                  item
                    Action = Action97
                    Caption = 'Se&lect Polygon'
                    ImageIndex = 73
                  end
                  item
                    Action = Action98
                    ImageIndex = 43
                  end>
                Caption = '&MultiSelection'
              end
              item
                Action = Action99
                Caption = 'Selec&t One'
                ImageIndex = 81
                ShortCut = 16452
              end
              item
                Action = Action100
                ShortCut = 16449
              end
              item
                Action = Action101
                Caption = '&UnSelect All'
                ShortCut = 16467
              end
              item
                Caption = '-'
              end
              item
                Action = Action102
                Caption = 'Select e&ntire layer...'
              end
              item
                Action = Action103
                Caption = 'C&opy Selection to...'
              end
              item
                Caption = '-'
              end
              item
                Action = Action104
                Caption = 'Bl&ink Selection'
              end
              item
                Action = Action105
                Caption = 'Sus&pend Blinking'
              end>
            Caption = '&Select'
          end
          item
            Items = <
              item
                Action = CustomizeActionBars2
              end
              item
                Caption = '-'
              end
              item
                Action = Action106
              end
              item
                Action = Action107
              end
              item
                Action = Action108
              end
              item
                Action = Action109
              end
              item
                Caption = '-'
              end
              item
                Items = <
                  item
                    Action = actShowAccuSnap
                    Caption = 'S&how AccuSnap'
                  end
                  item
                    Action = Action111
                    Caption = '&Configure AccuSnap...'
                  end>
                Caption = 'Acc&uSnap'
              end
              item
                Items = <
                  item
                    Action = actAccuDraw
                  end
                  item
                    Action = Action113
                  end
                  item
                    Action = Action114
                  end
                  item
                    Action = Action115
                    ShortCut = 16466
                  end
                  item
                    Action = Action116
                    ShortCut = 16469
                  end
                  item
                    Action = Action117
                    Caption = 'Cha&nge AccuDraw Origin'
                    ShortCut = 16463
                  end>
                Caption = 'AccuDra&w'
              end
              item
                Caption = '-'
              end
              item
                Items = <
                  item
                    Action = Action118
                    Caption = 'S&ymbols Editor...'
                  end
                  item
                    Action = Action119
                    Caption = 'Lin&etype Editor...'
                  end
                  item
                    Action = Action120
                    Caption = 'Raster I&mage Editor...'
                  end
                  item
                    Action = Action121
                  end>
                Caption = '&Editors'
              end
              item
                Caption = '-'
              end
              item
                Action = Action122
                Caption = 'Ma&p Units...'
              end
              item
                Action = Action123
                Caption = 'Repro&ject...'
              end
              item
                Caption = '-'
              end
              item
                Action = actSnapToGrid
                Caption = 'Snap to &Grid'
              end
              item
                Action = actSnapToGLines
                Caption = 'Snap to Gui&delines'
              end
              item
                Caption = '-'
              end
              item
                Action = Action126
                Caption = 'P&references...'
              end
              item
                Action = Action127
                Caption = '&Viewport Config...'
              end
              item
                Action = Action128
              end
              item
                Action = Action129
                Caption = 'La&yers Config...'
              end
              item
                Caption = '-'
              end
              item
                Action = Action130
                Caption = 'Lo&ad Vectorial Font...'
              end
              item
                Action = Action131
                Caption = 'Load Sym&bols File...'
              end
              item
                Action = Action132
                Caption = 'Load L&inetypes File...'
              end>
            Caption = '&Options'
          end
          item
            Items = <
              item
                Items = <
                  item
                    Action = actMove
                    ImageIndex = 64
                  end
                  item
                    Action = actScale
                    ImageIndex = 79
                  end
                  item
                    Action = actRotate
                    ImageIndex = 78
                  end
                  item
                    Action = Action136
                    Caption = 'R&eshape'
                    ImageIndex = 77
                  end
                  item
                    Action = Action137
                    ImageIndex = 60
                  end
                  item
                    Action = Action138
                    ImageIndex = 51
                  end
                  item
                    Action = Action139
                    Caption = 'Mirr&or'
                  end
                  item
                    Action = Action140
                    Caption = 'O&ffset'
                    ImageIndex = 48
                  end
                  item
                    Action = Action141
                    Caption = 'E&xplode'
                  end>
                Caption = 'Transf&orm'
              end
              item
                Items = <
                  item
                    Action = Action142
                  end
                  item
                    Action = Action143
                  end
                  item
                    Action = Action144
                  end
                  item
                    Action = Action145
                  end
                  item
                    Action = Action146
                  end>
                Caption = 'CA&D Actions'
              end
              item
                Items = <
                  item
                    Action = actPreserveOriginals
                    Caption = '&Preserve Originals'
                  end
                  item
                    Action = Action148
                  end
                  item
                    Action = Action149
                  end
                  item
                    Action = Action150
                  end
                  item
                    Action = Action151
                  end
                  item
                    Action = Action152
                  end>
                Caption = 'Po&lygon Clipping'
              end
              item
                Items = <
                  item
                    Action = actDimHoriz
                    ImageIndex = 52
                  end
                  item
                    Action = actDimVertical
                    ImageIndex = 54
                  end
                  item
                    Action = actDimParallel
                    ImageIndex = 53
                  end>
                Caption = 'D&im'
              end
              item
                Items = <
                  item
                    Action = Action156
                  end
                  item
                    Action = Action157
                  end
                  item
                    Action = Action158
                  end
                  item
                    Action = Action159
                    Caption = 'Convert AutoCAD D&WG -> DXF...'
                  end>
                Caption = '&Conversions'
              end
              item
                Action = Action160
                Caption = 'Chang&e Reshape Rotate Origin'
                ShortCut = 16468
              end>
            Caption = '&CAD Edit'
          end
          item
            Items = <
              item
                Action = Action161
              end
              item
                Caption = '-'
              end
              item
                Action = Action162
              end
              item
                Action = Action163
              end>
            Caption = 'S&patial Analisis'
          end
          item
            Items = <
              item
                Action = Action164
              end
              item
                Action = Action165
              end
              item
                Caption = '-'
              end
              item
                Action = Action166
              end>
            Caption = 'Ne&twork'
          end
          item
            Items = <
              item
                Action = Action167
              end
              item
                Caption = '-'
              end
              item
                Action = HelpContents1
              end
              item
                Action = HelpOnHelp1
              end
              item
                Caption = '-'
              end
              item
                Action = Action168
                Caption = '&EzSoft Engineering Home Page...'
              end
              item
                Action = Action169
              end>
            Caption = '&Help'
          end>
        ActionBar = ActionMainMenuBar1
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = Action4
          end
          item
            Action = FileOpen1
            ImageIndex = 1
            ShortCut = 16463
          end
          item
            Action = Action6
          end
          item
            Action = actPrintPreview
          end
          item
            Action = actRepaint
            ShortCut = 116
          end
          item
            Action = Action167
          end
          item
            Action = Action12
            ImageIndex = 3
          end>
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
        Items = <
          item
            Action = FileOpen1
            ImageIndex = 1
            ShortCut = 16463
          end>
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = Action4
            ImageIndex = 1
          end
          item
            Action = FileOpen1
            ImageIndex = 2
            ShortCut = 16463
          end
          item
            Action = Action6
            ImageIndex = 4
          end
          item
            Action = actPrintPreview
            ImageIndex = 6
          end
          item
            Action = actRepaint
            ImageIndex = 33
            ShortCut = 116
          end
          item
            Action = Action167
            ImageIndex = 29
          end
          item
            Action = Action12
            ImageIndex = 94
          end
          item
            Action = Action118
            Caption = 'S&ymbols Editor...'
            ImageIndex = 38
          end
          item
            Action = Action121
            ImageIndex = 19
          end
          item
            Action = actBrowse
            ImageIndex = 34
          end
          item
            Action = Action56
            Caption = '&Layer Control...'
            ImageIndex = 36
            ShortCut = 16460
          end
          item
            Action = actView1
            Caption = 'Vie&w 1'
            ImageIndex = 110
          end
          item
            Action = actView2
            Caption = 'View &2'
            ImageIndex = 111
          end
          item
            Action = actView3
            Caption = 'V&iew 3'
            ImageIndex = 112
          end
          item
            Action = actView4
            Caption = 'View &4'
            ImageIndex = 113
          end
          item
            Action = actView5
            Caption = 'View &5'
            ImageIndex = 109
          end>
        ActionBar = ActionToolBar1
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = actSketch
            ImageIndex = 114
          end
          item
            Action = Action33
            Caption = '&Point'
            ImageIndex = 71
          end
          item
            Action = Action34
            ImageIndex = 68
          end
          item
            Action = actSymbolMult
            Caption = 'S&ymbols (Multiple)'
            ImageIndex = 102
          end
          item
            Action = actTextPlace
            Caption = '&Text Place'
            ImageIndex = 69
          end
          item
            Action = Action35
            ImageIndex = 62
          end
          item
            Action = Action36
            Caption = 'P&olyline'
            ImageIndex = 70
          end
          item
            Action = actRounded
            Caption = '&Rounded Polyline'
            ImageIndex = 100
          end
          item
            Action = actMultiPart
            Caption = 'act&MultiPart'
            ImageIndex = 101
          end
          item
            Action = Action37
            ImageIndex = 72
          end
          item
            Action = Action38
            Caption = 'R&ectangle'
            ImageIndex = 75
          end
          item
            Action = Action39
            ImageIndex = 39
          end
          item
            Action = actArcCRSE
            ImageIndex = 104
          end
          item
            Action = actArcSCE
            Caption = 'Arc (Start Angle, Center, S&weep Angle)'
            ImageIndex = 105
          end
          item
            Action = Action13
            Caption = 'Circle &2P'
            ImageIndex = 115
          end
          item
            Action = actCircle3P
            Caption = 'Circle (&3 points)'
            ImageIndex = 106
          end
          item
            Action = actCircleCR
            Caption = 'Circle (Center,R&adius)'
            ImageIndex = 107
          end
          item
            Action = Action40
            Caption = 'Ell&ipse'
            ImageIndex = 56
          end
          item
            Action = Action41
            Caption = 'Spli&ne'
            ImageIndex = 82
          end
          item
            Action = Action42
            Caption = 'Insert Bloc&k'
            ImageIndex = 8
          end
          item
            Action = Action43
            Caption = 'B&uffer'
            ImageIndex = 103
          end
          item
            Action = actDimHoriz
            ImageIndex = 52
          end
          item
            Action = actDimVertical
            ImageIndex = 54
          end
          item
            Action = actDimParallel
            Caption = '&Dim Parallel'
            ImageIndex = 53
          end>
        ActionBar = ActionToolBar2
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = actZoomWin
            ImageIndex = 0
          end
          item
            Action = actZoomAll
            Caption = '&Zoom All'
            ImageIndex = 87
          end
          item
            Action = Action68
            ImageIndex = 89
          end
          item
            Action = actZoomPrevious
            ImageIndex = 90
          end
          item
            Action = Action95
            Caption = '&Select Circle'
            ImageIndex = 91
          end
          item
            Action = actMeasures
            Caption = '&Measures'
            ImageIndex = 63
          end
          item
            Action = Action98
            ImageIndex = 43
          end>
        ActionBar = ActionToolBar3
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = actMove
            ImageIndex = 64
          end
          item
            Action = actScale
            ImageIndex = 79
          end
          item
            Action = actRotate
            ImageIndex = 78
          end
          item
            Action = Action136
            Caption = 'R&eshape'
            ImageIndex = 77
          end
          item
            Action = Action137
            ImageIndex = 60
          end
          item
            Action = Action138
            ImageIndex = 51
          end
          item
            Action = Action140
            ImageIndex = 48
          end
          item
            Action = actHGLines
            ImageIndex = 59
          end
          item
            Action = actVGLines
            ImageIndex = 86
          end
          item
            Action = actNextMarker
            ImageIndex = 97
          end
          item
            Action = actPriorMarker
            ImageIndex = 96
          end
          item
            Action = actAutoLabel
            ImageIndex = 108
          end>
        ActionBar = ActionToolBar4
      end
      item
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = Action66
            Caption = '&Pan'
            ImageIndex = 80
            ShortCut = 16464
          end
          item
            Action = Action69
            ImageIndex = 74
          end
          item
            Action = Action67
            ImageIndex = 88
          end
          item
            Action = Action94
            Caption = '&Select Rectangle'
            ImageIndex = 76
          end
          item
            Action = Action97
            Caption = 'Se&lect Polygon'
            ImageIndex = 73
          end
          item
            Action = Action99
            Caption = 'Sele&ct One'
            ImageIndex = 81
            ShortCut = 16452
          end
          item
            Action = Action82
            ImageIndex = 58
          end
          item
            Action = Action81
            Caption = 'E&dit Database Info'
            ImageIndex = 50
          end>
        ActionBar = ActionToolBar6
      end
      item
        Items.CaptionOptions = coNone
        Items = <
          item
            Action = Action50
            ImageIndex = 92
          end
          item
            Action = Action51
            ImageIndex = 66
          end
          item
            Action = Action52
            ImageIndex = 41
          end
          item
            Action = Action14
            Caption = '&ERMapper image'
            ImageIndex = 116
          end
          item
            Action = Action46
            Caption = '&Windows True Type Text'
            ImageIndex = 85
          end
          item
            Action = Action44
            ImageIndex = 57
          end
          item
            Action = Action45
            ImageIndex = 61
          end
          item
            Action = Action47
            Caption = 'B&anner Text'
            ImageIndex = 42
          end
          item
            Action = Action48
            ImageIndex = 45
          end
          item
            Action = Action49
            Caption = 'B&ullet Leader Text'
            ImageIndex = 44
          end>
        ActionBar = ActionToolBar5
      end>
    Images = Images
    Left = 128
    Top = 232
    StyleName = 'XP Style'
    object Action4: TAction
      Category = 'File'
      Caption = '&New...'
      Hint = 'New|Create New Map'
      ImageIndex = 1
      OnExecute = actNewExecute
    end
    object FileOpen1: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Dialog.DefaultExt = 'EZM'
      Dialog.Filter = 'EzGIS Map Files(*.EZM)|*.EZM'
      Dialog.Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
      Dialog.Title = 'Open Existing Map'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 2
      ShortCut = 16463
      BeforeExecute = FileOpen1BeforeExecute
      OnAccept = FileOpen1Accept
    end
    object Action6: TAction
      Category = 'File'
      Caption = '&Save'
      Hint = 'Save|Save current map'
      ImageIndex = 4
      OnExecute = actSaveExecute
      OnUpdate = Action6Update
    end
    object Action8: TAction
      Category = 'File'
      Caption = 'Save &Clipped Area to...'
      Hint = 'Save clipped area|Save clipped area to a file'
      OnExecute = actSaveclippedExecute
      OnUpdate = Action6Update
    end
    object Action9: TAction
      Category = 'File'
      Caption = 'Create &Thumbnaill bitmap...'
      Hint = 'Create thumbnail|Create thumbnail from current map'
      OnExecute = actCreateThumnaillbitmapExecute
      OnUpdate = Action6Update
    end
    object Action7: TAction
      Category = 'File'
      Caption = 'Create HTML &Hot Spot map...'
      Hint = 'Create hotspot|Create html hotspot map from current view'
      OnExecute = actHotSpotExecute
      OnUpdate = Action6Update
    end
    object FilePrintSetup1: TFilePrintSetup
      Category = 'File'
      Caption = 'Print Set&up...'
      Hint = 'Print Setup|Configure printer parameters'
      ImageIndex = 98
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 9
      ShortCut = 16474
      OnExecute = EditUndo1Execute
      OnUpdate = EditUndo1Update
    end
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 12
      ShortCut = 16472
      OnExecute = EditCut1Execute
      OnUpdate = actMoveUpdate
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 13
      ShortCut = 16451
      OnExecute = EditCopy1Execute
      OnUpdate = actMoveUpdate
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 14
      ShortCut = 16470
      OnExecute = EditPaste1Execute
      OnUpdate = EditPaste1Update
    end
    object Action17: TAction
      Category = 'Edit'
      Caption = 'Paste And Define P&osition'
      Hint = 'Paste and define position'
      ImageIndex = 14
      OnExecute = actPasteAndDefinePositionExecute
      OnUpdate = EditPaste1Update
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 99
      ShortCut = 46
      OnExecute = EditDelete1Execute
      OnUpdate = actMoveUpdate
    end
    object Action19: TAction
      Category = 'Edit'
      Caption = '&Clear Clipboard Data'
      Hint = 'Clear|Clear clipboard contents'
      OnExecute = actClearClipboardExecute
    end
    object Action20: TAction
      Category = 'Edit'
      Caption = '&Drop'
      Hint = 'Drop|Drop an element onto current map'
      OnExecute = actDropExecute
      OnUpdate = Action6Update
    end
    object HelpContents1: THelpContents
      Category = 'Help'
      Caption = '&Contents'
      Hint = 'Help Contents'
      ImageIndex = 31
      OnUpdate = HelpContents1Update
    end
    object HelpOnHelp1: THelpOnHelp
      Category = 'Help'
      Caption = '&Help on Help'
      Hint = 'Help on help'
      ImageIndex = 31
      OnUpdate = HelpContents1Update
    end
    object actPrintPreview: TAction
      Category = 'File'
      Caption = '&Print Preview...'
      Hint = 'Print Preview'
      ImageIndex = 6
      OnExecute = actPrintPreviewExecute
      OnUpdate = Action6Update
    end
    object Action12: TAction
      Category = 'File'
      Caption = '&Exit'
      Hint = 'Exit|Terminates application'
      ImageIndex = 94
      OnExecute = Action12Execute
    end
    object Action21: TAction
      Category = 'Edit'
      Caption = 'Copy To Clipboard As Te&xt'
      ImageIndex = 13
      OnExecute = actCopyToClipboardExecute
      OnUpdate = actMoveUpdate
    end
    object Action22: TAction
      Category = 'Edit'
      Caption = 'Paste And Define &Position As Text'
      ImageIndex = 14
      OnExecute = Action22Execute
      OnUpdate = EditPaste1Update
    end
    object Action23: TAction
      Category = 'Edit'
      Caption = 'Copy to Clip&board as Bmp'
      ImageIndex = 13
      OnExecute = Action23Execute
    end
    object Action24: TAction
      Category = 'Edit'
      Caption = 'Copy to Clipboard as &Emf'
      ImageIndex = 13
      OnExecute = actCopyToClipboardAsEmfExecute
    end
    object Action25: TAction
      Category = 'Edit'
      Caption = '&Group'
      OnExecute = actGroupExecute
      OnUpdate = Action6Update
    end
    object Action26: TAction
      Category = 'Edit'
      Caption = '&Ungroup'
      OnExecute = actUngroupExecute
      OnUpdate = Action6Update
    end
    object Action27: TAction
      Category = 'Edit'
      Caption = 'Bring to &Front'
      ImageIndex = 35
      OnExecute = actToFrontExecute
      OnUpdate = actMoveUpdate
    end
    object Action28: TAction
      Category = 'Edit'
      Caption = 'Send to &Back'
      ImageIndex = 37
      OnExecute = actToBackExecute
      OnUpdate = actMoveUpdate
    end
    object Action29: TAction
      Category = 'Edit'
      Caption = '&Move Guidelines'
      OnExecute = actMoveGuidelinesExecute
      OnUpdate = Action6Update
    end
    object Action30: TAction
      Category = 'Edit'
      Caption = 'Ma&ke Block From Selection...'
      OnExecute = actMakeBlockFromSelectionExecute
      OnUpdate = actMoveUpdate
    end
    object Action31: TAction
      Category = 'Edit'
      Caption = '&ARRAY from selection...'
      OnExecute = actREPEATExecute
      OnUpdate = actMoveUpdate
    end
    object Action32: TAction
      Category = 'Edit'
      Caption = 'Delete &Repetitions...'
      OnExecute = actDeleteRepetitionsExecute
      OnUpdate = Action6Update
    end
    object Action33: TAction
      Category = 'Entity'
      Caption = 'Point'
      ImageIndex = 71
      OnExecute = actPointExecute
      OnUpdate = Action6Update
    end
    object Action34: TAction
      Category = 'Entity'
      Caption = 'Sym&bol'
      ImageIndex = 68
      OnExecute = actSymbolExecute
      OnUpdate = Action6Update
    end
    object actSymbolMult: TAction
      Category = 'Entity'
      Caption = 'Symbols (Multiple)'
      ImageIndex = 102
      OnExecute = actSymbolMultExecute
      OnUpdate = Action6Update
    end
    object actTextPlace: TAction
      Category = 'Entity'
      Caption = 'Text Place'
      ImageIndex = 69
      OnExecute = actTextPlaceExecute
      OnUpdate = Action6Update
    end
    object Action35: TAction
      Category = 'Entity'
      Caption = '&Line'
      ImageIndex = 62
      OnExecute = actLineExecute
      OnUpdate = Action6Update
    end
    object Action36: TAction
      Category = 'Entity'
      Caption = '&Polyline'
      ImageIndex = 70
      OnExecute = actPolylineExecute
      OnUpdate = Action6Update
    end
    object actRounded: TAction
      Category = 'Entity'
      Caption = 'Rounded Polyline'
      ImageIndex = 100
      OnExecute = actRoundedExecute
      OnUpdate = Action6Update
    end
    object actMultiPart: TAction
      Category = 'Entity'
      Caption = 'actMultiPart'
      ImageIndex = 101
      OnExecute = actMultiPartExecute
      OnUpdate = Action6Update
    end
    object Action37: TAction
      Category = 'Entity'
      Caption = 'Poly&gon'
      ImageIndex = 72
      OnExecute = actPolygonExecute
      OnUpdate = Action6Update
    end
    object Action38: TAction
      Category = 'Entity'
      Caption = 'Rectan&gle'
      ImageIndex = 75
      OnExecute = actRectangleExecute
      OnUpdate = Action6Update
    end
    object Action39: TAction
      Category = 'Entity'
      Caption = 'Ar&c'
      ImageIndex = 39
      OnExecute = Action39Execute
      OnUpdate = Action6Update
    end
    object actArcCRSE: TAction
      Category = 'Entity'
      Caption = 'Arc (Center,Radius,Start,End)'
      ImageIndex = 104
      OnExecute = actArcCRSEExecute
      OnUpdate = Action6Update
    end
    object actArcSCE: TAction
      Category = 'Entity'
      Caption = 'Arc (Start Angle, Center, Sweep Angle)'
      Hint = 'Arc (Start Angle, Center, Sweep Angle)'
      ImageIndex = 105
      OnExecute = actArcSCEExecute
      OnUpdate = Action6Update
    end
    object Action13: TAction
      Category = 'Entity'
      Caption = 'Circle 2P'
      Hint = 'Circle 2P'
      ImageIndex = 115
      OnExecute = Action13Execute
    end
    object actCircle3P: TAction
      Category = 'Entity'
      Caption = 'Circle (3 points)'
      ImageIndex = 106
      OnExecute = actCircle3PExecute
      OnUpdate = Action6Update
    end
    object actCircleCR: TAction
      Category = 'Entity'
      Caption = 'Circle (Center,Radius)'
      ImageIndex = 107
      OnExecute = actCircleCRExecute
      OnUpdate = Action6Update
    end
    object Action40: TAction
      Category = 'Entity'
      Caption = '&Ellipse'
      ImageIndex = 56
      OnExecute = actEllipseExecute
      OnUpdate = Action6Update
    end
    object Action41: TAction
      Category = 'Entity'
      Caption = '&Spline'
      ImageIndex = 82
      OnExecute = actSplineExecute
      OnUpdate = Action6Update
    end
    object Action42: TAction
      Category = 'Entity'
      Caption = 'Insert &Block'
      ImageIndex = 8
      OnExecute = actInsertBlockExecute
      OnUpdate = Action6Update
    end
    object Action43: TAction
      Category = 'Entity'
      Caption = '&Buffer'
      ImageIndex = 103
      OnExecute = actBufferExecute
      OnUpdate = Action6Update
    end
    object Action44: TAction
      Category = 'Entity'
      Caption = '&Fitted Vectorial Text'
      ImageIndex = 57
      OnExecute = actFittedTextExecute
      OnUpdate = Action6Update
    end
    object Action45: TAction
      Category = 'Entity'
      Caption = '&Justified Vectorial Text'
      ImageIndex = 61
      OnExecute = actJustifiedTextExecute
      OnUpdate = Action6Update
    end
    object Action46: TAction
      Category = 'Entity'
      Caption = 'Windows &True Type Text'
      ImageIndex = 85
      OnExecute = actTrueTypeTextExecute
      OnUpdate = Action6Update
    end
    object Action47: TAction
      Category = 'Entity'
      Caption = '&Banner Text'
      ImageIndex = 42
      OnExecute = actBannerTextExecute
      OnUpdate = Action6Update
    end
    object Action48: TAction
      Category = 'Entity'
      Caption = '&Callout Text'
      ImageIndex = 45
      OnExecute = actCalloutTextExecute
      OnUpdate = Action6Update
    end
    object Action49: TAction
      Category = 'Entity'
      Caption = '&Bullet Leader Text'
      ImageIndex = 44
      OnExecute = actBulletLeaderTextExecute
      OnUpdate = Action6Update
    end
    object Action50: TAction
      Category = 'Entity'
      Caption = '&Referenced Picture'
      ImageIndex = 92
      OnExecute = actPictureRefExecute
      OnUpdate = Action6Update
    end
    object Action51: TAction
      Category = 'Entity'
      Caption = '&Persistent Bitmap'
      ImageIndex = 66
      OnExecute = actPersistentBitmapExecute
      OnUpdate = Action6Update
    end
    object Action52: TAction
      Category = 'Entity'
      Caption = '&Banded Bitmap'
      ImageIndex = 41
      OnExecute = actBandsBitmapExecute
      OnUpdate = Action6Update
    end
    object Action54: TAction
      Category = 'Layer'
      Caption = '&Import...'
      OnExecute = actImportExecute
      OnUpdate = Action6Update
    end
    object Action55: TAction
      Category = 'Layer'
      Caption = '&Export...'
      OnExecute = actExportExecute
      OnUpdate = Action6Update
    end
    object Action56: TAction
      Category = 'Layer'
      Caption = 'Layer C&ontrol...'
      ImageIndex = 36
      ShortCut = 16460
      OnExecute = actLayerControlExecute
      OnUpdate = Action6Update
    end
    object actBrowse: TAction
      Category = 'Layer'
      Caption = '&Browse Layer...'
      ImageIndex = 34
      OnExecute = actBrowseExecute
      OnUpdate = Action6Update
    end
    object Action58: TAction
      Category = 'Layer'
      Caption = '&Add Layer...'
      OnExecute = actAddLayerExecute
      OnUpdate = Action6Update
    end
    object Action59: TAction
      Category = 'Layer'
      Caption = '&Unload Layer...'
      OnExecute = actUnloadLayerExecute
      OnUpdate = Action6Update
    end
    object Action60: TAction
      Category = 'Layer'
      Caption = 'Spatially &reindex'
      OnExecute = actReindexExecute
      OnUpdate = Action6Update
    end
    object Action61: TAction
      Category = 'Layer'
      Caption = 'Quick Update Extension'
      OnExecute = actQuickUpdateExtensionExecute
      OnUpdate = Action6Update
    end
    object Action62: TAction
      Category = 'Layer'
      Caption = '&Update Extension'
      OnExecute = actUpdateExtensionExecute
      OnUpdate = Action6Update
    end
    object Action63: TAction
      Category = 'Layer'
      Caption = '&Restructure Layer...'
      OnExecute = actRestructureExecute
      OnUpdate = Action6Update
    end
    object Action64: TAction
      Category = 'Layer'
      Caption = '&Pack Layer...'
      OnExecute = actPackLayerExecute
      OnUpdate = Action6Update
    end
    object actRepaint: TAction
      Category = 'View'
      Caption = 'Repaint &View'
      ImageIndex = 33
      ShortCut = 116
      OnExecute = actRepaintExecute
      OnUpdate = Action6Update
    end
    object Action66: TAction
      Category = 'View'
      Caption = 'Pan'
      ImageIndex = 80
      ShortCut = 16464
      OnExecute = actPanExecute
      OnUpdate = Action6Update
    end
    object actZoomAll: TAction
      Category = 'View'
      Caption = 'Zoom All'
      ImageIndex = 87
      OnExecute = actZoomAllExecute
      OnUpdate = Action6Update
    end
    object Action67: TAction
      Category = 'View'
      Caption = 'Zoom &In'
      ImageIndex = 88
      OnExecute = actZoomInExecute
      OnUpdate = Action6Update
    end
    object Action68: TAction
      Category = 'View'
      Caption = 'Zoom O&ut'
      ImageIndex = 89
      OnExecute = actZoomOutExecute
      OnUpdate = Action6Update
    end
    object Action69: TAction
      Category = 'View'
      Caption = 'Zoom R&ealtime'
      ImageIndex = 74
      OnExecute = actZoomRealtimeExecute
      OnUpdate = Action6Update
    end
    object actZoomWin: TAction
      Category = 'View'
      Caption = 'Zoom &Window'
      ImageIndex = 0
      OnExecute = actZoomWinExecute
      OnUpdate = Action6Update
    end
    object Action72: TAction
      Category = 'View'
      Caption = 'Zoom &Selection'
      OnExecute = actZoomSelectionExecute
      OnUpdate = Action6Update
    end
    object Action73: TAction
      Category = 'View'
      Caption = 'Zoom to &Layer'
      OnExecute = actZoomLayerExecute
      OnUpdate = Action6Update
    end
    object Action74: TAction
      Category = 'View'
      Caption = 'Zoom &Extension'
      OnExecute = actZoomAllExecute
      OnUpdate = Action6Update
    end
    object actViewGrid: TAction
      Category = 'View'
      Caption = '&Grid'
      OnExecute = actViewGridExecute
      OnUpdate = Action6Update
    end
    object Action76: TAction
      Category = 'View'
      Caption = 'Show &Hints'
      OnExecute = actShowHintsExecute
      OnUpdate = Action6Update
    end
    object Action77: TAction
      Category = 'View'
      Caption = '&Show Coords'
      OnExecute = actShowCoordsExecute
      OnUpdate = Action6Update
    end
    object actShowCmdLine: TAction
      Category = 'View'
      Caption = 'Show &Command Line'
      OnExecute = actShowCmdLineExecute
      OnUpdate = Action6Update
    end
    object Action79: TAction
      Category = 'View'
      Caption = 'Aerial &View'
      ImageIndex = 93
      OnExecute = actAerialViewExecute
      OnUpdate = Action6Update
    end
    object actNamedViews: TAction
      Category = 'View'
      Caption = '&Named views...'
      OnExecute = actNamedviewsExecute
      OnUpdate = Action6Update
    end
    object Action81: TAction
      Category = 'Define'
      Caption = 'Edit Database &Info'
      ImageIndex = 50
      OnExecute = actEditDatabaseInfoExecute
      OnUpdate = Action6Update
    end
    object Action82: TAction
      Category = 'Define'
      Caption = 'Edit &Graphic Info'
      ImageIndex = 58
      OnExecute = actEditGraphicInfoExecute
      OnUpdate = Action6Update
    end
    object Action83: TAction
      Category = 'Define'
      Caption = 'Revert &direction'
      OnExecute = actRevertdirectionExecute
      OnUpdate = actMoveUpdate
    end
    object Action84: TAction
      Category = 'Define'
      Caption = 'Add mar&ker...'
      OnExecute = actAddMarkerExecute
      OnUpdate = Action6Update
    end
    object Action85: TAction
      Category = 'Define'
      Caption = '&Clear Markers'
      OnExecute = actClearMarkersExecute
      OnUpdate = Action6Update
    end
    object Action86: TAction
      Category = 'Define'
      Caption = '&Fit to Path'
      OnExecute = actFitToPathExecute
      OnUpdate = actMoveUpdate
    end
    object Action87: TAction
      Category = 'Define'
      Caption = '&Fit text to path'
      OnExecute = actFitTextToPathExecute
      OnUpdate = actMoveUpdate
    end
    object actOrto: TAction
      Category = 'Define'
      Caption = '&Ortho'
      OnExecute = actOrtoExecute
    end
    object Action89: TAction
      Category = 'Define'
      Caption = '&Rectangular'
      OnExecute = actClipRectangularExecute
      OnUpdate = Action6Update
    end
    object Action90: TAction
      Category = 'Define'
      Caption = '&Polygonal'
      OnExecute = actClipPolygonalExecute
      OnUpdate = Action6Update
    end
    object Action91: TAction
      Category = 'Define'
      Caption = 'From Current &Selection'
      OnExecute = actSetClipBoundaryfromSelectionExecute
      OnUpdate = actMoveUpdate
    end
    object Action92: TAction
      Category = 'Define'
      Caption = 'Clear Cli&p Boundary'
      OnExecute = actCancelclippedExecute
      OnUpdate = Action6Update
    end
    object Action93: TAction
      Category = 'Define'
      Caption = '&Georeferenced Image...'
      OnExecute = actGeoreferencedImageExecute
      OnUpdate = Action6Update
    end
    object Action94: TAction
      Category = 'Select'
      Caption = 'Select Rectangle'
      ImageIndex = 76
      OnExecute = actSelectRectangleExecute
      OnUpdate = Action6Update
    end
    object Action95: TAction
      Category = 'Select'
      Caption = 'Select Circle'
      ImageIndex = 91
      OnExecute = actSelectCircleExecute
      OnUpdate = Action6Update
    end
    object Action97: TAction
      Category = 'Select'
      Caption = 'Select Polygon'
      ImageIndex = 73
      OnExecute = actSelectPolylineExecute
      OnUpdate = Action6Update
    end
    object Action98: TAction
      Category = 'Select'
      Caption = 'Select in &Buffer'
      ImageIndex = 43
      OnExecute = actSelectBufferExecute
      OnUpdate = Action6Update
    end
    object Action99: TAction
      Category = 'Select'
      Caption = 'Select One'
      ImageIndex = 81
      ShortCut = 16452
      OnExecute = actDefaultActionExecute
      OnUpdate = Action6Update
    end
    object Action100: TAction
      Category = 'Select'
      Caption = 'Select &All'
      ShortCut = 16449
      OnExecute = actSelectAllExecute
      OnUpdate = Action6Update
    end
    object Action101: TAction
      Category = 'Select'
      Caption = 'Un&Select All'
      ShortCut = 16467
      OnExecute = actUnSelectAllExecute
      OnUpdate = actMoveUpdate
    end
    object Action102: TAction
      Category = 'Select'
      Caption = 'Select &entire layer...'
      OnExecute = actSelectEntireLayerExecute
      OnUpdate = Action6Update
    end
    object Action103: TAction
      Category = 'Select'
      Caption = 'Copy &Selection to...'
      OnExecute = actCopySelectionToExecute
      OnUpdate = actMoveUpdate
    end
    object Action104: TAction
      Category = 'Select'
      Caption = '&Blink Selection'
      OnExecute = actBlinkSelectionExecute
      OnUpdate = actMoveUpdate
    end
    object Action105: TAction
      Category = 'Select'
      Caption = '&Suspend Blinking'
      OnExecute = actSuspendBlinkingExecute
      OnUpdate = Action6Update
    end
    object CustomizeActionBars2: TCustomizeActionBars
      Category = 'Options'
      Caption = '&Customize Toolbars'
      OnExecute = CustomizeActionBars2Execute
      OnUpdate = Action6Update
      CustomizeDlg.StayOnTop = False
    end
    object Action106: TAction
      Category = 'Options'
      Caption = '&Line Style...'
      OnExecute = actLineStyleExecute
      OnUpdate = Action6Update
    end
    object Action107: TAction
      Category = 'Options'
      Caption = '&Fill Style...'
      OnExecute = actFillStyleExecute
      OnUpdate = Action6Update
    end
    object Action108: TAction
      Category = 'Options'
      Caption = '&Symbol Style...'
      OnExecute = actSymbolStyleExecute
      OnUpdate = Action6Update
    end
    object Action109: TAction
      Category = 'Options'
      Caption = '&Text Style...'
      OnExecute = actTextStyleExecute
      OnUpdate = Action6Update
    end
    object actShowAccuSnap: TAction
      Category = 'Options'
      Caption = 'Show Accu&Snap'
      OnExecute = actShowAccuSnapExecute
      OnUpdate = Action6Update
    end
    object Action111: TAction
      Category = 'Options'
      Caption = 'Configure Accu&Snap...'
      OnExecute = actConfigureAccuSnapExecute
      OnUpdate = Action6Update
    end
    object actAccuDraw: TAction
      Category = 'Options'
      Caption = 'Show &AccuDraw'
      OnExecute = CmdLine1AccuDrawActivate
      OnUpdate = Action6Update
    end
    object Action113: TAction
      Category = 'Options'
      Caption = 'C&onfigure AccuDraw...'
      OnExecute = actConfigureAccuDrawExecute
      OnUpdate = Action6Update
    end
    object Action114: TAction
      Category = 'Options'
      Caption = '&Rotate AccuDraw...'
      OnExecute = actRotateAccuDrawExecute
      OnUpdate = Action6Update
    end
    object Action115: TAction
      Category = 'Options'
      Caption = 'Rotate &Interactively'
      ShortCut = 16466
      OnExecute = actRotateInteractivelyExecute
      OnUpdate = Action6Update
    end
    object Action116: TAction
      Category = 'Options'
      Caption = '&UnRotate AccuDraw'
      ShortCut = 16469
      OnExecute = actUnrotateAccuDrawExecute
      OnUpdate = Action6Update
    end
    object Action117: TAction
      Category = 'Options'
      Caption = 'C&hange AccuDraw Origin'
      ShortCut = 16463
      OnExecute = actChangeAccuDrawOriginExecute
      OnUpdate = Action6Update
    end
    object Action118: TAction
      Category = 'Options'
      Caption = '&Symbols Editor...'
      ImageIndex = 38
      OnExecute = actSymbolsEditorExecute
      OnUpdate = Action6Update
    end
    object Action119: TAction
      Category = 'Options'
      Caption = '&Linetype Editor...'
      OnExecute = actLinetypeEditorExecute
      OnUpdate = Action6Update
    end
    object Action120: TAction
      Category = 'Options'
      Caption = 'Raster Image Editor...'
      OnExecute = actRasterImageEditorExecute
      OnUpdate = Action6Update
    end
    object Action121: TAction
      Category = 'Options'
      Caption = 'Bloc&ks Editor...'
      ImageIndex = 19
      OnExecute = Action121Execute
      OnUpdate = Action6Update
    end
    object Action122: TAction
      Category = 'Options'
      Caption = '&Map Units...'
      OnExecute = actMapUnitsExecute
      OnUpdate = Action6Update
    end
    object Action123: TAction
      Category = 'Options'
      Caption = '&Reproject...'
      OnExecute = actReprojectExecute
      OnUpdate = Action6Update
    end
    object actSnapToGrid: TAction
      Category = 'Options'
      Caption = '&Snap to Grid'
      OnExecute = actSnapToGridExecute
      OnUpdate = Action6Update
    end
    object actSnapToGLines: TAction
      Category = 'Options'
      Caption = 'Snap to &Guidelines'
      OnExecute = actSnapToGLinesExecute
      OnUpdate = Action6Update
    end
    object Action126: TAction
      Category = 'Options'
      Caption = '&Preferences...'
      OnExecute = actPreferencesExecute
      OnUpdate = Action6Update
    end
    object Action127: TAction
      Category = 'Options'
      Caption = 'Viewport Config...'
      OnExecute = actViewportConfigExecute
      OnUpdate = Action6Update
    end
    object Action128: TAction
      Category = 'Options'
      Caption = 'Gis C&onfig...'
      OnExecute = actGisConfigExecute
      OnUpdate = Action6Update
    end
    object Action129: TAction
      Category = 'Options'
      Caption = '&Layers Config...'
      OnExecute = actLayersConfigExecute
      OnUpdate = Action6Update
    end
    object Action130: TAction
      Category = 'Options'
      Caption = '&Load Vectorial Font...'
      OnExecute = actLoadVectorialFontExecute
      OnUpdate = Action6Update
    end
    object Action131: TAction
      Category = 'Options'
      Caption = 'Load &Symbols File...'
      OnExecute = actLoadSymbolsFileExecute
      OnUpdate = Action6Update
    end
    object Action132: TAction
      Category = 'Options'
      Caption = 'Load &Linetypes File...'
      OnExecute = actLoadLinetypesFileExecute
      OnUpdate = Action6Update
    end
    object actMove: TAction
      Category = 'CAD Edit'
      Caption = '&Move'
      ImageIndex = 64
      OnExecute = actMoveExecute
      OnUpdate = actMoveUpdate
    end
    object actScale: TAction
      Category = 'CAD Edit'
      Caption = '&Scale'
      ImageIndex = 79
      OnExecute = actScaleExecute
      OnUpdate = actMoveUpdate
    end
    object actRotate: TAction
      Category = 'CAD Edit'
      Caption = '&Rotate'
      ImageIndex = 78
      OnExecute = actRotateExecute
      OnUpdate = actMoveUpdate
    end
    object Action136: TAction
      Category = 'CAD Edit'
      Caption = '&Reshape'
      ImageIndex = 77
      OnExecute = actReshapeExecute
      OnUpdate = Action6Update
    end
    object Action137: TAction
      Category = 'CAD Edit'
      Caption = '&Insert Node'
      ImageIndex = 60
      OnExecute = actInsertNodeExecute
      OnUpdate = Action6Update
    end
    object Action138: TAction
      Category = 'CAD Edit'
      Caption = '&Delete Node'
      ImageIndex = 51
      OnExecute = actDeleteNodeExecute
      OnUpdate = Action6Update
    end
    object Action139: TAction
      Category = 'CAD Edit'
      Caption = '&Mirror'
      OnExecute = actMirrorExecute
      OnUpdate = Action6Update
    end
    object Action140: TAction
      Category = 'CAD Edit'
      Caption = '&Offset'
      ImageIndex = 48
      OnExecute = actOffsetExecute
      OnUpdate = Action6Update
    end
    object Action141: TAction
      Category = 'CAD Edit'
      Caption = '&Explode'
      OnExecute = actExplodeExecute
      OnUpdate = Action6Update
    end
    object Action142: TAction
      Category = 'CAD Edit'
      Caption = '&Trim'
      OnExecute = actTrimExecute
      OnUpdate = Action6Update
    end
    object Action143: TAction
      Category = 'CAD Edit'
      Caption = '&Extend'
      OnExecute = actExtendExecute
      OnUpdate = Action6Update
    end
    object Action144: TAction
      Category = 'CAD Edit'
      Caption = '&Break'
      OnExecute = actBreakExecute
      OnUpdate = Action6Update
    end
    object Action145: TAction
      Category = 'CAD Edit'
      Caption = '&Fillet'
      OnExecute = actFilletExecute
      OnUpdate = Action6Update
    end
    object Action146: TAction
      Category = 'CAD Edit'
      Caption = '&Join'
      OnExecute = actJoinExecute
      OnUpdate = Action6Update
    end
    object actPreserveOriginals: TAction
      Category = 'CAD Edit'
      Caption = 'Preserve Originals'
      Checked = True
      OnExecute = actPreserveOriginalsExecute
    end
    object Action148: TAction
      Category = 'CAD Edit'
      Caption = '&Union'
      OnExecute = actUnionExecute
      OnUpdate = actMoveUpdate
    end
    object Action149: TAction
      Category = 'CAD Edit'
      Caption = '&Intersection'
      OnExecute = actIntersectionExecute
      OnUpdate = actMoveUpdate
    end
    object Action150: TAction
      Category = 'CAD Edit'
      Caption = '&Difference'
      OnExecute = actDifferenceExecute
      OnUpdate = actMoveUpdate
    end
    object Action151: TAction
      Category = 'CAD Edit'
      Caption = '&Split'
      OnExecute = actSplitExecute
      OnUpdate = actMoveUpdate
    end
    object Action152: TAction
      Category = 'CAD Edit'
      Caption = '&Xor'
      OnExecute = actXorExecute
      OnUpdate = actMoveUpdate
    end
    object Action156: TAction
      Category = 'CAD Edit'
      Caption = 'Convert Poly&line'
      OnExecute = actToPolylineExecute
      OnUpdate = Action6Update
    end
    object Action157: TAction
      Category = 'CAD Edit'
      Caption = 'Convert Poly&gon'
      OnExecute = actToPolygonExecute
      OnUpdate = Action6Update
    end
    object Action158: TAction
      Category = 'CAD Edit'
      Caption = 'Convert &Multi-Polygon/Polyline'
      OnExecute = actCombineExecute
      OnUpdate = Action6Update
    end
    object Action159: TAction
      Category = 'CAD Edit'
      Caption = 'Convert AutoCAD DWG -> DXF...'
      OnExecute = actConvertAutoCADDWGDXFExecute
    end
    object Action160: TAction
      Category = 'CAD Edit'
      Caption = 'Change Reshape Ro&tate Origin'
      ShortCut = 16468
      OnExecute = actChangeReshapeRotateOriginExecute
      OnUpdate = Action6Update
    end
    object Action161: TAction
      Category = 'Spatial Analisis'
      Caption = 'General Purpose &Query...'
      OnExecute = actQueryExecute
      OnUpdate = Action6Update
    end
    object Action162: TAction
      Category = 'Spatial Analisis'
      Caption = 'Thematics &Editor...'
      OnExecute = actThematicsEditorExecute
      OnUpdate = Action6Update
    end
    object Action163: TAction
      Category = 'Spatial Analisis'
      Caption = 'Turn &off thematics'
      OnExecute = actTurnoffthematicsExecute
      OnUpdate = Action6Update
    end
    object Action164: TAction
      Category = 'Network'
      Caption = 'Add &Nodes'
      OnExecute = actAddNodesExecute
      OnUpdate = Action6Update
    end
    object Action165: TAction
      Category = 'Network'
      Caption = 'Add Node &Links'
      OnExecute = actAddNodeLinksExecute
      OnUpdate = Action6Update
    end
    object Action166: TAction
      Category = 'Network'
      Caption = '&Analysis...'
      OnExecute = actAnalysisExecute
      OnUpdate = Action6Update
    end
    object Action167: TAction
      Category = 'Help'
      Caption = '&About'
      ImageIndex = 29
      OnExecute = Action167Execute
      OnUpdate = HelpContents1Update
    end
    object Action168: TAction
      Category = 'Help'
      Caption = 'EzSoft Engineering Home Page...'
      OnExecute = actEzSoftEngineeringHOMEPAGEExecute
      OnUpdate = HelpContents1Update
    end
    object Action169: TAction
      Category = 'Help'
      Caption = 'Write to &Us...'
      OnExecute = actWritetoUsExecute
      OnUpdate = HelpContents1Update
    end
    object actView1: TAction
      Caption = 'View 1'
      Hint = 'Open View'
      ImageIndex = 110
      OnExecute = actView1Execute
    end
    object actView2: TAction
      Tag = 1
      Caption = 'View 2'
      Hint = 'Open View'
      ImageIndex = 111
      OnExecute = actView1Execute
    end
    object actView3: TAction
      Tag = 2
      Caption = 'View 3'
      Hint = 'Open View'
      ImageIndex = 112
      OnExecute = actView1Execute
    end
    object actView4: TAction
      Tag = 3
      Caption = 'View 4'
      Hint = 'Open View'
      ImageIndex = 113
      OnExecute = actView1Execute
    end
    object actView5: TAction
      Tag = 4
      Caption = 'View 5'
      Hint = 'Open View'
      ImageIndex = 109
      OnExecute = actView1Execute
    end
    object actNextMarker: TAction
      Caption = '&Next Marker'
      Hint = 'Show Next Marker'
      ImageIndex = 97
      OnExecute = actNextMarkerExecute
    end
    object actPriorMarker: TAction
      Caption = '&Previous Marker'
      Hint = 'Show Previous Marker'
      ImageIndex = 96
      OnExecute = actPriorMarkerExecute
    end
    object Action14: TAction
      Category = 'Entity'
      Caption = 'ERMapper image'
      ImageIndex = 116
      OnExecute = Action14Execute
    end
    object actDimHoriz: TAction
      Category = 'Entity'
      Caption = 'Dim &Horizontal'
      ImageIndex = 52
      OnUpdate = Action6Update
    end
    object actDimVertical: TAction
      Category = 'Entity'
      Caption = 'Dim &Vertical'
      ImageIndex = 54
      OnExecute = actDimVerticalExecute
      OnUpdate = Action6Update
    end
    object actDimParallel: TAction
      Category = 'Entity'
      Caption = 'Dim &Parallel'
      ImageIndex = 53
      OnExecute = actDimParallelExecute
      OnUpdate = Action6Update
    end
    object actHGLines: TAction
      Category = 'CAD Edit'
      Caption = '&Horizontal Guidelines'
      ImageIndex = 59
      OnExecute = actHGLinesExecute
      OnUpdate = Action6Update
    end
    object actVGLines: TAction
      Category = 'CAD Edit'
      Caption = '&Vertical Guidelines'
      ImageIndex = 86
      OnExecute = actVGLinesExecute
      OnUpdate = Action6Update
    end
    object actMeasures: TAction
      Caption = 'Measures'
      Hint = 'Distance'
      ImageIndex = 63
      OnExecute = actMeasuresExecute
    end
    object actAutoLabel: TAction
      Caption = 'Auto &Labeling'
      Hint = 'Auto Label'
      ImageIndex = 108
      OnExecute = actAutoLabelExecute
    end
    object actZoomPrevious: TAction
      Category = 'View'
      Caption = 'Zoom &Previous'
      ImageIndex = 90
      OnExecute = actZoomPreviousExecute
      OnUpdate = Action6Update
    end
    object Action11: TAction
      Category = 'Define'
      Caption = '&Preloaded images...'
      Hint = 'Preloaded images|Define preloaded images'
      OnExecute = Action11Execute
      OnUpdate = Action6Update
    end
    object actSketch: TAction
      Category = 'Entity'
      Caption = '&Sketch'
      ImageIndex = 114
      OnExecute = actSketchExecute
      OnUpdate = Action6Update
    end
    object Action15: TAction
      Category = 'Layer'
      Caption = #1048#1079' CK36 '#1084#1077#1089#1090#1085#1091#1102
      OnExecute = Action15Execute
      OnUpdate = Action15Update
    end
  end
  object Images: TImageList
    Height = 20
    Width = 20
    Left = 100
    Top = 232
    Bitmap = {
      494C0101750077003C0014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      00000000000036000000280000005000000058020000010020000000000000EE
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      00008000000000000000000000008000000080000000800000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000080000000800000008000000080000000000000000000
      80000000FF000000FF0000000000000000000000800080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000080000000800000008000000080000000000000000000
      8000000080000000800000000000000000000000800080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000080000000800000008000000080000000000000000000
      0000000000008000000000008000000000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000000000
      000000000000000000000000800000008000000080000000FF00000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000008000
      000000000000000000000000FF000000800080000000000080000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000008000
      00000000000000000000000080000000000000008000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000080000000000000000000000000000000000000008000
      0000000000000000000080000000000080000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000080000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000000000000008000
      0000000000000000000000000000800000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000080000000800000008000000080000000000000008000
      0000000000000000000000000000800000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000080000000800000008000000080000000000000008000
      0000000000000000000000000000800000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000080000000800000008000000080000000000000008000
      0000000000000000000000000000800000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000800000008000000080000000000000008000
      0000000000000000000000000000800000000000000000000000800000000000
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
      0000808080000000800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00808080000000800080808000FFFFFF000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      00000000000000FFFF000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000FF00FF0000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000FF00FF00FF00FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008080800000000000FFFF
      FF00808080000000800080808000FFFFFF000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000800080808000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      0000000000000000000000FFFF0000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF0000FFFF00C0C0C00000FFFF00C0C0C00000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000000000000000000000
      00000000000000FFFF0000000000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000008080008080
      80000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000008080000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080008080
      80000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000FFFF000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000FFFF0000000000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000080800000000000008080000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
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
      0000000000000000000000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000FFFFFF00808080000000800080808000FFFF
      FF00000000008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000800000008000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000080000000800000008000000000000000
      000000000000000000000000000000000000000000000000800000008000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000000080008080800000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      80000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000080000000800000008000000000000000
      000000000000000000000000000000000000000000000000800000008000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000008000000080000000800000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000080000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      80000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000080000000800000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000000080008080800000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      80000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000008000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000008000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000FFFFFF00808080000000800080808000FFFF
      FF00000000008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000008000808080000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000008080
      8000000080008080800000000000000000000000000000000000000000000000
      0000808080000000800080808000000000000000000000000000000000000000
      0000000000000000000000000000808080000000800080808000000000000000
      0000000000000000000000000000000000008080800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      8000000000000000800000000000000000000000000000000000000000000000
      0000000080000000000000008000000000000000000000000000000000000000
      0000000000000000000000000000000080000000000000008000000000000000
      0000000000000000000000000000000000000000800000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000008080
      8000000080008080800000000000000000000000000000000000000000000000
      0000808080000000800080808000000000000000000000000000000000000000
      0000000000000000000000000000808080000000800080808000000000000000
      0000000000000000000000000000000000008080800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000000000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000202020000000000000000000000000000000
      0000000000000000000000000000404040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C00000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000020202000808080000000000000000000000000000000
      0000000000000000000000000000808080006060600000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002020200080808000808080000000000000000000000000000000
      0000000000000000000000000000808080008080800060606000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000090909000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0009090900080808000808080000000000000000000000000000000
      00000000000000000000000000008080800080808000B0B0B000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000909090000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000090909000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00090909000808080000000000000000000000000000000
      000000000000000000000000000080808000B0B0B0000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0009090900000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C00000000000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000090909000C0C0
      C000C0C0C000C0C0C00090909000606060006060600060606000606060006060
      6000000000000000000060606000404040000000000000000000000000000000
      0000000000000000000000000000505050006060600000000000000000006060
      60006060600060606000606060006060600090909000C0C0C000C0C0C000C0C0
      C000909090000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009090
      9000C0C0C000C0C0C00060606000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000060606000C0C0C000C0C0C0009090
      9000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000090909000C0C0C00060606000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000060606000C0C0C000909090000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080800000FFFF0000FFFF0000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009090900060606000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006060600090909000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000808000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000030303000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003030300000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF000080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000808000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C00080800000FFFF0000FFFF0000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000000000000000000000000000C0C0C000000000000000
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
      0000000000000000000000000000000000000000000000000000000000002020
      2000202020002020200020202000202020002020200020202000202020002020
      2000202020002020200020202000202020002020200020000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005F3F3F004040
      4000404040009F9F5F009F9F5F00BFDF5F005F7F40007F5F5F009F9F5F009F9F
      5F009F9F5F009F9F5F0040404000404040009F9F5F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF
      7F00FFFF7F00FFFF7F00DFBF7F00FFFF7F00FFFF7F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF
      7F003F7FFF007F7FFF00BFBFBF00FFFF7F00FFFF7F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000000000000000000000000000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF
      7F003F7FFF003F7FFF00BFBFBF00FFFF7F00FFFF7F007F7F3F00000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000000000000000000000000000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF
      7F00DFDF9F00DFDF9F00FFFF7F00FFFF7F00FFFF7F007F7F3F00000000000000
      0000000000000000000000000000000000000000000080808000FFFF00000000
      0000FF0000000000000000000000000000000000000000000000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFFBF00FFFFBF00FFFF7F00FFFF
      7F00AFAFAF006FEFEF00FFFF7F00FFFFBF00FFFFFF007F7F7F00000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      000000000000FF00000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFFBF00FFFFBF00FFFFFF00FFFFBF00FFFF7F00FFFF7F00FFFF7F00BFBF
      7F0000BFFF0000FF3F00BF7F0000FFFF7F00FFFFBF007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF000000000000FF00000000000000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFFBF00FFFFFF00FFFFFF00FFFF7F00BFBF7F0000BF
      FF0000FF3F00BF3F00009F0020005F3F9F00FFFF7F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000FF00000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000C6C6C60000000000FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFFBF00FFFF7F00FFFF7F00FFFF7F0000BFFF0000FF
      3F00BF3F00009F0020002000DF0000BFFF007FDF7F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000FFFF0000FFFF008080
      8000000000000000000000000000808080008080800080808000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF0000000000C6C6C60000000000C6C6C6000000000000000000000000000000
      00008400000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F0000FF3F00BF3F
      00009F0020002000DF0000BFFF00009F3F00BF9F3F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0000000
      0000000000000000000080808000FFFF000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000C6C6C6000000
      0000C6C6C60000000000C6C6C60000000000C6C6C600C6C6C600C6C6C6000000
      00008400000000000000000000000000000000000000000000007F7F3F00FFFF
      BF00FFFFFF00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00BF3F00009F00
      20002000DF0000BFFF00009F3F00BF200000DF7F3F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFF000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080000000000000FFFF0000FFFF008080
      8000000000000000000000000000808080008080800080808000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C6008400000000000000000000000000000000000000000000007F7F3F00FFFF
      FF00FFFFBF00FFFFFF00FFFFBF00FFFF7F00FFFF7F00FFFF7F00BF3F5F002000
      DF0000BFFF00009F3F00BF2000009F002000DFBF9F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C00000000000000000000000000000000000FFFF000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000808080000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C60000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C6008400000000000000000000000000000000000000000000007F7F3F00FFFF
      BF00FFFFBF00FFFFFF00FFFFFF00FFFFBF00FFFF7F00FFFF7F00FFFF7F007FBF
      BF00009F3F00BF200000BF3F3F00DFBF5F00FFFF7F007F7F3F00000000000000
      00000000000000000000000000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008000
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000808080000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      00008400000000000000000000000000000000000000000000007F7F3F00FFFF
      7F00FFFFFF00FFFFFF00FFFFBF00FFFFFF00FFFF7F00FFFF7F00FFFF7F00FFFF
      7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F00FFFF7F007F7F3F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000000000000000000000000000000000000000000003F3F00007F7F
      3F007F7F3F007F7F3F007F7F3F007F7F3F007F7F3F007F7F3F007F7F3F007F7F
      3F007F7F3F007F7F3F007F7F3F007F7F3F007F7F3F003F3F3F00000000000000
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
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      84000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000000000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      0000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      000000000000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FF000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FF000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      840000000000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      0000FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      000000000000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      0000000000000000000084828400000000000000000000000000000000000000
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
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400840000008400000084000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000000000008486
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400848284000000
      0000000000000000000084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848284008400000084000000848284000000
      0000000000008482840084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000840000000000000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848684000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084828400848284008482
      8400840000008400000084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      840000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000848284008482840084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000840000008482
      8400848284008482840084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00008482840084828400FF00000084000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000840000008482840084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000008486
      840000000000FFFFFF00FFFFFF00FFFFFF000000000084868400000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000848684000000000000000000000000008486840000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000007B797B0000007B007B797B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000007B000000000000007B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B797B0000007B007B797B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848284000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B79
      7B0000007B007B797B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      7B000000000000007B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B79
      7B0000007B007B797B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000000000000000000000000000000000007B797B0000007B007B79
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000007B00000000000000
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B797B0000007B007B79
      7B00000000000000000000000000000000000000000000000000000000000000
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
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FF000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000084868400840000008400000084000000840000008400
      0000848684000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000084000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000FF0000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008486
      8400840000008400000000000000000000000000000000000000000000000000
      0000000000008400000084000000848684000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000860000008600000000
      0000000000008486840084000000840000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000086000000860000008600000086
      0000000000000000000084000000840000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000086000000860000008600000086
      0000000000000000000084000000840000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000860000008600000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008486840000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      8400840000008400000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000008400000084000000000000000000
      0000000000008400000084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000008400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084868400840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000000000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000007B7900000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848284000000000000000000000000000000000000000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B790000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B79000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B79
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000084008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000000000000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007B797B000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848284000000840084828400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008482
      8400000084008482840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400000084008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000008482
      8400000084008482840000000000000000000000000000000000000000000000
      0000848284000000840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000000000000840000000000000000000000000000000000000000000000
      0000000084000000000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400000084008482840000000000000000000000000000000000000000000000
      0000848284000000840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      8400848284000000000000000000000000000000000000000000000000000000
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
      00004200000042C3C60042E3E70042C3C60084C3840084E3420084C342008482
      000084824200848284008482840084E3840084C38400C6C38400000000000000
      0000000000000000000000000000000000004200000042C3C60042E3E70042C3
      C60084C3840084E3420084C342008482000084824200848284008482840084E3
      840084C38400C6C3840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840084828400848284008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000846163000000
      000084000000FF000000FF000000FF000000FF000000FF000000C6616300C641
      4200FF000000C6820000FF000000C6820000FF000000C6828400000000000000
      00000000000000000000846163000000000084000000FF000000FF000000FF00
      0000FF000000FF000000C6616300C6414200FF000000C6820000FF000000C682
      0000FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000008400000084000000840000008400
      0000848284000000000000000000000000000000000000000000840000000000
      0000C6C3C60084828400848284008482840084828400C6C3C600848284008482
      8400C6C3C60084828400848284008482840084828400C6C3C600000000000000
      00000000000000000000840000000000000084000000FF000000FF000000C641
      4200C6A24200C6414200C6616300C6616300C6A26300C6414200C6616300C641
      4200FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000844142000000
      0000848284000000000000000000000000000000000000000000846163004220
      2100000000000000000000000000000000000000000084828400000000000000
      00000000000000000000844142000000000084000000C6414200C6A2A500C661
      6300C6614200C6616300C6414200C6A2A500C6A26300C6616300C6414200FF00
      0000FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848284008482840084828400848284008482
      840084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000840000000000
      0000848284000000000000000000000000000000000000000000848284000000
      0000000000000000000000000000000000000000000084828400000000000000
      00000000000000000000840000000000000084000000C6410000C6C3A500FF00
      0000C6820000FF000000FF000000FF000000FF000000FF000000FF000000C641
      4200C6616300F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000844100000000
      0000848284000000000000000000000000000000000000000000846163004220
      2100000000000000000000000000000000000000000084828400000000000000
      0000000000000000000084410000000000004200000084000000C6820000C6A2
      4200C6414200C6A26300C6616300C6414200420000000000000084000000C600
      000084000000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000848200000082
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      0000000000000000000084820000008200000000000000000000FFFF00008482
      000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000848200000041
      0000848284000000000000000000000000000000000084616300C6C3C600A5A2
      A500422021000000000000000000000000000000000084828400000000000000
      0000000000000000000084820000004100000000000000820000FFFF00000000
      000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000000000000020
      42008482840000000000000000000000000000000000C6DFC600FFFFFF00FFFF
      FF00A5A2A5000000000000000000000000000000000084828400000000000000
      0000000000000000000000000000002042000000000000000000004100000000
      000000410000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000000000004241
      00008482840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00C6C3C6000000000000000000000000000000000084828400000000000000
      0000000000000000000000000000424100000000000000000000000000000000
      000042410000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      000084000000FF000000FF000000FF000000FF000000FF000000FF0000008400
      0000848284000000000000000000000000000000000000000000848200004241
      00008482840000000000000000000000000042202100A5A2A500FFFFFF00C6DF
      C600846163000000000000000000000000000000000084828400000000000000
      0000000000000000000084820000424100000082000000000000008200004282
      0000C6C30000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      0000840000008400000084000000840000008400000084000000840000008400
      00000000000000000000000000000000000000000000000000000041000000C3
      0000848284000000000000000000000000000000000042202100000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      000000000000000000000041000000C300000041000084820000000000008482
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008400000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424100008482
      0000848284000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C3C600000000000000
      000000000000000000004241000084820000C6C30000FFFF0000C6C300008482
      000084820000FFFF0000FFFF0000FFFF0000FFFF000042E3420042E34200FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008400000084828400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084820000FFFF
      0000848284004282840084E3E70084E3E70084E3E70084E3E70084E3E70084E3
      E7004282840000000000000000000000000000000000C6C3C600000000000000
      0000000000000000000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF000042E34200008284000082840042E3
      4200FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084820000FFFF
      0000848284004282840084E3E70084E3E70084E3E70084E3E70084E3E70084E3
      E700428284000000000000000000000000000000000084828400000000000000
      0000000000000000000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF000000E3840000C3C60000C3C60000E3
      8400FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424100008482
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      0000000000000000000042410000848200008482000084820000848200008482
      0000848200008482000084820000848200004282420000828400008284004282
      420084820000C6C3840000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000008482840084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400840000008400000084000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400848284000000
      0000000000000000000084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000008482
      8400000084008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      8400000000000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000840000008400
      0000840000008400000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084828400848284008482
      8400840000008400000084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000008482
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000840000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000848284008482840084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008482
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084828400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000840000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000840000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00008482840084828400FF00000084000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000008400000084000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000840000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000840000008482840084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000840000008400
      0000840000008400000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000008400
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000008400000084828400FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400848284000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000000000000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840000008400848284000000000000000000000000000000
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
      00000000000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C600C6C3C600C6C3C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C3C600FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C3C600FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C3C600FF0000000000000000000000C6C3C600C6C3
      C6000000000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C6000000
      0000C6C3C60000000000C6C3C600C6C3C6000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C3C600FF000000000000000000000000000000C6C3
      C6000000000000000000C6C3C6000000000000000000C6C3C60000000000C6C3
      C60000000000C6C3C600C6C3C600000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000C6C3C600FF000000000000000000000000000000C6C3
      C600000000000000000000000000C6C3C6000000000000000000C6C3C6000000
      000000000000C6C3C60000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FFFF0000FFFF
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000000000000000000000000000C6C3
      C600000000000000000000000000C6C3C60000000000C6C3C600C6C3C6000000
      000000000000C6C3C60000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000000000000000000000000000C6C3
      C6000000000000000000000000000000000000000000C6C3C60000000000C6C3
      C60000000000C6C3C6000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000FF000000FF000000000000000000000000000000C6C3
      C600C6C3C6000000000000000000000000000000000000000000000000000000
      000000000000C6C3C6000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000008400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000840084828400000000000000
      000000000000FF000000C6C3C600FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000084000000840000008400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000084000000840000008400000000000000
      00000000000000000000C6C3C600FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000008400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000840084828400000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00000000000000840000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FFFF0000FFFF0000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF00000000000000FF000000FF0000000000
      0000FF000000FF00000000000000FF000000FF00000000000000FF000000FF00
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840000008400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
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
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
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
      0000000000000000000000000000000000004200000042C3C60042E3E70042C3
      C60084C3840084E3420084C342008482000084824200848284008482840084E3
      840084C38400C6C3840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400848284008482
      8400848284008482840084828400848284008482840000000000000000000000
      00000000000000000000846163000000000084000000FF000000FF000000FF00
      0000FF000000FF000000C6616300C6414200FF000000C6820000FF000000C682
      0000FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008482840000000000000000000000
      00000000000000000000840000000000000084000000FF000000FF000000C641
      4200C6A24200C6414200C6616300C6616300C6A26300C6414200C6616300C641
      4200FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      00000000000000000000844142000000000084000000C6414200C6A2A500C661
      6300C6614200C6616300C6414200C6A2A500C6A26300C6616300C6414200FF00
      0000FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      84008482840084828400848284008482840084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      00000000000000000000840000000000000084000000C6410000C6C3A500FF00
      0000C6820000FF000000FF000000FF000000FF000000FF000000FF000000C641
      4200C6616300F7CBA50000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      00008400000084000000840000008400000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      0000000000000000000084410000000000004200000084000000C6820000C6A2
      4200C6414200C6A26300C6616300C6414200420000000000000084000000C600
      000084000000F7CBA50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF00000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      0000000000000000000084820000008200000000000000000000FFFF00008482
      000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF00000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      0000000000000000000084820000004100000000000000820000FFFF00000000
      000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF00000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      0000000000000000000000000000002042000000000000000000004100000000
      000000410000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF00000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      0000000000000000000000000000424100000000000000000000000000000000
      000042410000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF00000084000000FF000000FF000000FF00
      0000FF000000FF000000FF000000840000008482840000000000000000000000
      0000000000000000000084820000424100000082000000000000008200004282
      0000C6C30000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF0000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      000000000000000000000041000000C300000041000084820000000000008482
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004241000084820000C6C30000FFFF0000C6C300008482
      000084820000FFFF0000FFFF0000FFFF0000FFFF000042E3420042E34200FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FF00
      0000FF000000FF000000FF000000FF000000FF00000084000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF000042E34200008284000082840042E3
      4200FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF000000E3840000C3C60000C3C60000E3
      8400FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042410000848200008482000084820000848200008482
      0000848200008482000084820000848200004282420000828400008284004282
      420084820000C6C3840000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840000008400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00848284000000840084828400FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084828400000084008482840000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000008400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000008400000084000000840000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000084000000840000008400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084828400000084008482840000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000840000008400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000008400FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000008400FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00848284000000840084828400FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840000008400848284000000
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
      0000000000000000000000000000000000000000000000000000008284000082
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000828400000000000000
      0000008284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004200000042C3C60042E3E70042C3
      C60084C3840084E3420084C342008482000084824200848284008482840084E3
      840084C38400C6C3840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000000000000000000000
      000000000000000000000000000000FFFF00C6C3C60000FFFF00C6C3C60000FF
      FF00C6C3C60000FFFF00C6C3C60000FFFF00C6C3C60000FFFF00C6C3C60000FF
      FF000000000000000000F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000000000000000000000
      0000000000000000000000FFFF00000000008482840084828400848284008482
      8400848284008482840084828400848284008482840084828400848284008482
      84000000000000000000840000000000000084000000FF000000FF000000C641
      4200C6A24200C6414200C6616300C6616300C6A26300C6414200C6616300C641
      4200FF000000C682840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848284000000000000000000000000000000000000000000848284000000
      0000000000000000000000000000000000000082840000000000008284000000
      00008482840000FFFF000000000000FFFF008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      84000000000000000000844142000000000084000000C6414200C6A2A500C661
      6300C6614200C6616300C6414200C6A2A500C6A26300C6616300C6414200FF00
      0000FF000000C682840000000000000000000000000000000000848284008482
      8400848284008482840084828400848284008482840084828400848284008482
      8400848284008482840084828400848284008482840084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000000000000000000000000000828400000000000082
      8400848284000000000000FFFF00000000008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      84000000000000000000F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000828400008284000000000000FFFF008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400000000000000000084410000000000004200000084000000C6820000C6A2
      4200C6414200C6A26300C6616300C6414200420000000000000084000000C600
      000084000000F7CBA50000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000000000000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000082
      8400848284000000000000FFFF00000000008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400000000000000000084820000008200000000000000000000FFFF00008482
      000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008284000000
      00008482840000FFFF000000000000FFFF008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      84000000000000000000F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008284000000
      0000000000008482840000FFFF00000000008482840084828400848284008482
      8400848284008482840084828400848284008482840084828400848284008482
      8400000000000000000000000000002042000000000000000000004100000000
      000000410000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008284000000
      000000000000000000008482840000FFFF000000000000FFFF000000000000FF
      FF000000000000FFFF000000000000FFFF000000000000FFFF000000000000FF
      FF00000000000000000000000000424100000000000000000000000000000000
      000042410000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000000000000000000082
      8400000000000000000000000000848284008482840084828400848284008482
      8400848284008482840084828400848284008482840084828400848284008482
      84000000000000000000F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000828400000000000000
      0000008284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000041000000C300000041000084820000000000008482
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000828400000000000000
      0000008284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004241000084820000C6C30000FFFF0000C6C300008482
      000084820000FFFF0000FFFF0000FFFF0000FFFF000042E3420042E34200FFFF
      0000FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008284000082
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FB
      FF00F7FBFF00F7FBFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084820000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF000000E3840000C3C60000C3C60000E3
      8400FFFF0000F7CBA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042410000848200008482000084820000848200008482
      0000848200008482000084820000848200004282420000828400008284004282
      420084820000C6C3840000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      84008482840000000000FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      84008482840000000000FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00000000000000000000000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      8400000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000084828400000000000000000000000000000000000000
      0000848284000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      00000000000000000000000084000000FF000000FF000000FF000000FF000000
      FF00000084000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000820000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000082000000820000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400848284000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000082
      000000820000008200000082000000820000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000008482
      8400848284000000000000000000000000000000000000000000848284000000
      84000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000084008482840000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000082000000820000FFFFFF00FFFFFF0000820000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF0000000000FFFFFF0084000000FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF008400000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000008482
      8400848284000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000820000FFFFFF00FFFFFF0000820000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000820000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000820000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF0000000000FFFFFF0084000000FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF008400000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000820000FFFF
      FF00FFFFFF0000820000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400000000000000000000000000
      00000000000000000000000000000000000084828400848284000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000820000FFFF
      FF00FFFFFF000082000000820000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF0000000000FFFFFF0084000000FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF008400000000000000000000000000
      000000000000000000000000000000000000848284008482840000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000082
      000000820000008200000082000000820000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400000000000000000000000000
      00000000000000000000000000000000000084828400848284000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000848284000000
      84000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF00000084008482840000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000082000000820000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008400000000000000000000000000
      0000000000000000000000000000000000008482840084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000820000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000084000000FF000000FF000000FF000000FF000000
      FF00000084000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000848284000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000084828400848284008482
      84008482840084828400848284000000000000FFFF0000000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400840084008400848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      840084008400FFFFFF00FFFFFF00C6C3C6008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C3C600C6C3C600848284008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008400840084008400FFFF
      FF00FFFFFF000000000000000000C6C3C600C6C3C60084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C3C600C6C3C600C6C3C600C6C3C6008482840084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000FFFFFF00FFFFFF0000FFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848284008400840084008400FFFFFF00FFFFFF000000
      000000000000840084008400840000000000C6C3C600C6C3C600848284000000
      000000000000000000000000000000000000000000000000000084828400C6C3
      C600C6C3C60084828400C6C3C600FFFFFF00C6C3C60084828400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084828400000000000000000000000000000000000000
      000000000000000000008482840084008400FFFFFF0000000000000000008400
      84008400840084008400840084008400840000000000C6C3C600C6C3C6008482
      840000000000000000000000000000000000000000000000000000000000C6C3
      C60084828400C6C3C600FFFFFF00C6C3C600FFFFFF00C6C3C600848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084828400FFFFFF00FFFFFF0000FFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084828400000000000000000000000000000000000000
      0000000000000000000084828400000000000000000084008400840084008400
      84000082840000FFFF0084008400840084008400840000000000C6C3C600C6C3
      C600848284000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C6C3C600FFFFFF00C6C3C600FFFFFF00C6C3C6008482
      8400848284000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF008482840084000000C6C3C600FFFFFF00FFFFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000000000000000000000000000000000000000
      0000000000000000000084828400840084008400840084008400840084008400
      840084008400008284008400840084008400840084008400840000000000C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C6C3C600FFFFFF00C6C3C600FFFFFF00C6C3
      C600848284008482840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF00FFFF
      FF00FFFFFF0000FFFF0084828400840000008482840000FFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008482840000000000000000000000
      000000000000000000000000000084008400FFFFFF0084008400840084008400
      8400840084008400840000FFFF0000FFFF008400840084008400840084000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00C6C3C600FFFFFF00C6C3C600FFFF
      FF00C6C3C6008482840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008400
      000084828400FFFFFF00FFFFFF008400000084000000FFFFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400840000008400
      0000000000000000000084828400840000008400000084828400000000000000
      00000000000000000000000000000000000084008400FFFFFF00840084008400
      84008400840084008400840084000082840000FFFF0000FFFF00840084008400
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C6C3C600FFFFFF00C6C3
      C600FFFFFF00C6C3C60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF008400
      00008400000000FFFF00C6C3C600840000008400000000FFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008482
      8400000000000000000000000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000084008400FFFFFF008400
      84008400840084008400008284008400840000FFFF0000FFFF00840084008400
      8400840084000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00C6C3C600FFFF
      FF00C6C3C600FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00C6C3
      C60084000000840000008400000084000000C6C3C600FFFFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008482
      8400000000000000000000000000840000008400000084000000000000000000
      000000000000000000000000000000000000000000000000000084008400FFFF
      FF00840084008400840000FFFF0000FFFF0000FFFF0084008400840084008400
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00C6C3
      C600C6C3C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF000000
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000084828400840000008400000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      8400FFFFFF008400840084008400840084008400840084008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084008400FFFFFF0084008400840084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400840084008400000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084000000000000000000
      0000000000000000000000000000848284008400000084000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0084828400FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000000000
      0000000000000000000000000000848284008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0084828400FFFFFF00C6C3C6008482840000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400840000000000
      0000000000000000000000000000840000008400000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00C6C3C60000000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0084828400FFFFFF00C6C3C6008482840000FFFF00FFFF
      FF0000FFFF008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848284000000000000FFFF0084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0084828400FFFFFF00C6C3C6008482840000FFFF00FFFFFF0000FF
      FF0084828400C6C3C600C6C3C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008400
      0000000000000000000084000000840000008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00C6C3C600000000008482
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C3C6008482840000FFFF00FFFFFF0000FFFF008482
      8400C6C3C600C6C3C600C6C3C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848284000000000000FFFF00848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000FFFF0084828400C6C3
      C600C6C3C600C6C3C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400840000008400000084000000848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00C6C3C6000000
      0000848284000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0084828400C6C3C600C6C3
      C600C6C3C6008482840084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848284000000000000FFFF008482
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C3C600C6C3C600C6C3
      C600000000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848284008400000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000000000000000000000000
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
      0000000000000000000000000000000000008482840084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      840084828400848284008482840000000000848284008482840000000000C6C3
      C600C6C3C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400840000008400000084000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000848284008482840084828400848284008482840084828400848284008482
      8400848284008482840084828400848284008482840084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848284008482840000000000848284008482840000000000C6C3C600C6C3
      C600000000000000000000000000000000000000000000000000000000008482
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084828400848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000084828400848284008482840000000000C6C3C600C6C3C6000000
      000000FFFF00000000000000000000000000000000000000000000000000C6C3
      C600000000000000000000000000FFFFFF000000000000000000000000008482
      8400000000000000000000000000000000008482840000000000000000000000
      0000000000000000000000000000000000000000000084828400848284000000
      0000000000000000000084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF000000000000000000FFFFFF0000FFFF000000000084828400000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF00000000008482840000000000FFFFFF00000000000000000000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000008482
      840000000000FF000000FF000000000000000000000000FFFF0000FFFF000000
      0000000000000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000000000000848284008400000084000000848284000000
      0000000000008482840084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000848284000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000C6C3C60000000000FFFFFF000000000084828400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000008482
      840000000000FF000000FF000000840000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000084000000840000008400000084828400848284008482
      8400840000008400000084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000084000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF000000000000FFFF00C6C3C600000000000000000084828400000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000008482
      840000000000FF000000FF000000840000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000848284008482840084000000840000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000084000000
      840000FFFF00FFFFFF0000FFFF00FFFFFF00848284000000840000FFFF00FFFF
      FF00000000000000000000000000000000000000000084828400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0084828400000000008482
      840000FFFF000000000000000000000000000000000000000000000000008482
      840000000000FF000000FF000000840000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000840000008482
      8400848284008482840084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000848284000000
      84008482840000FFFF00FFFFFF00848284000000840084828400FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000084828400000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000C6C3C6000000
      0000FFFFFF000000000000000000000000000000000000000000000000008482
      840000000000FF000000FF000000840000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      00008482840084828400FF00000084000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      8400000084008482840000FFFF000000840000008400FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000084828400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0084828400000000008482
      840000FFFF00000000000000000000000000000000000000000000000000C6C3
      C60000000000FF000000FF000000840000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000840000008482840084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000008482
      840000008400000084000000840000008400FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000084828400000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000008482
      8400C6C3C6000000000000000000000000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000008482
      8400000084000000840000008400FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C3
      C600848284000000000000000000000000000000000000FFFF0000FFFF000082
      8400000000000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000084000000FF0000008400000084828400848284008482
      8400000000000000000000000000000000000000000000000000848284000000
      8400000084000000840000008400848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400C6C3C6000000000000000000000000000000000000FFFF0000FFFF000082
      840000000000000000000000FF00000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000084000000
      8400848284000000000000008400000084008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00848284000000000000000000000000000000000000FFFF0000FFFF000082
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000840084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000FFFF0000FFFF00C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00000084828400848284008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084828400848284008482
      8400848284008482840084828400848284008482840084828400848284008482
      8400848284008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482000084828400848200008482
      8400848200008482840084820000848284008482000084828400848200008482
      8400848200000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848284000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084820000848284000000
      0000000000000000000000000000000000000000000000000000848284008482
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848284000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000FFFFFF0000FF
      FF0000000000848284000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482000084828400848200000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848200008482
      8400848200000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848284000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000C6C3C60000000000FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084820000848284000000
      0000FFFFFF00840000008400000084000000FFFFFF0000000000848284008482
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF0000000000848284000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000FFFF00C6C3C6000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482000084828400848200000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848200008482
      8400848200000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848284000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000C6C3C6000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084820000848284000000
      0000FFFFFF008400000084000000FFFFFF00FFFFFF0000000000848284008482
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF0000000000848284000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF008482840000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000008482840000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000C6C3C6000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482000084828400848200000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848200008482
      8400848200000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848284000000000000000000000000000000
      000000000000000000008482840000FFFF0000FFFF0084828400FFFFFF0000FF
      FF008482840000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084820000848284000000
      0000FFFFFF00840000008400000084000000FFFFFF0000000000848284008482
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF0000000000848284000000000000000000000000000000
      000000000000000000000000000084828400FFFFFF008482840000FFFF008482
      840000FFFF00FFFFFF0000FFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000008482840000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482000084828400848200000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848200008482
      8400848200000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848284000000000000000000000000000000
      00000000000000000000848284008482840084828400FFFFFF0084828400FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482840084820000848284000000
      0000000000000000000000000000000000000000000000000000848284008482
      0000848284000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848284000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF008482840000FFFF00FFFFFF008482
      8400848284008482840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008482000084828400848200008482
      8400848200008482840084820000848284008482000084828400848200008482
      8400848200000000000000000000000000000000000000000000000000000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000848284000000000000000000000000000000
      00000000000000000000000000008482840000FFFF008482840000FFFF008482
      840000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008482840000FFFF000000000084828400FFFFFF000000
      00008482840000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000000000008482840000FFFF000000
      0000000000008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400FFFFFF000000
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
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000008400000000000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000000000000000
      0000000000000000000000000000848284000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000008400000000000000840000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000008482
      84000082840084828400008284008482840084000000FFFFFF00840000008400
      000084000000840000008400000084000000FFFFFF0084000000000000000000
      000000000000000000000000000000000000C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000008400000000000000840000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF008400000000000000000000000000000000000000000000000082
      84008482840000828400848284000082840084000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000000000000000
      000000000000000000000000000000000000C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000840000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000008482
      84000082840084828400008284008482840084000000FFFFFF00840000008400
      000084000000FFFFFF0084000000840000008400000084000000000000000000
      00000000000000000000000000008482840000000000C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000848284008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF008400000000000000000000000000000000000000000000000082
      84008482840000828400848284000082840084000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF008400000000000000000000000000
      00000000000000000000000000000000000000000000C6C3C600FFFFFF00C6C3
      C600FFFFFF00C6C3C600FFFFFF00000000008482840084828400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      00000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000008482
      84000082840084828400008284008482840084000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C3C600FFFF
      FF00C6C3C600FFFFFF00C6C3C600FFFFFF000000000084828400848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000FFFFFF000000000000000000FFFFFF00840000008400
      0000840000008400000000000000000000000000000000000000000000000082
      8400848284000082840084828400008284008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C3
      C600FFFFFF00C6C3C600FFFFFF00C6C3C600FFFFFF0000000000848284008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      00000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFF
      FF00840000000000000000000000000000000000000000000000000000008482
      8400008284008482840000828400848284000082840084828400008284008482
      8400008284008482840000828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C3C600FFFFFF00C6C3C600FFFFFF00C6C3C600FFFFFF00000000008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000008400
      0000000000000000000000000000000000000000000000000000000000000082
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000008482840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C3C600FFFFFF00C6C3C600FFFFFF00C6C3C600FFFFFF008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF000000000000000000FFFF
      FF00000000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000008482
      84008482840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600000000008482840000828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C3C600FFFFFF00C6C3C600FFFFFF00C6C3C600C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000082
      840084828400008284000000000000FFFF00000000000000000000FFFF000000
      0000848284000082840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400000000000000000000000000000000008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
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
      00000000000084828400C6C3C60000FFFF00C6C3C600C6C3C600000000008482
      8400848284008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084828400FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF000000
      000000FFFF00C6C3C60084828400848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008482840000FFFF00FFFFFF00FFFFFF00FFFFFF0000FF
      FF0000000000FFFFFF0000FFFF00C6C3C6008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000008482840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084828400840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000000000
      0000000000000000000000000000000000000000000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084828400FFFFFF00FFFFFF00FFFFFF0000FF
      FF008482840000000000FFFFFF0000FFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000840000008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000848284008400000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848200008482000000000000FFFFFF0000FF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000008482
      0000848200000000000000000000000000008482000000000000FFFFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000008400000084000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000840000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      000000000000000000000000000000000000000000000000000000000000FFFF
      00008482000000000000FFFF0000000000008482000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000FFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000840000008400000000000000000000000000000000000000840000008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000848284008400000000000000000000000000000000000000840000008400
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000000000
      0000000000000000000000000000840000000000000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF00000000000000000000FFFF0000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000848284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008482840084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000000000
      0000000000000000000000000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF0000FF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084828400FFFFFF0000FFFF00FFFFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF00C6C3C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848284008482840084828400848284008482
      8400848284008482840084828400848284008482840000000000000000000000
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
      0000000000000082840000000000000000000000000000000000C6C3C6000000
      0000008284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008284000082840000000000000000000000000000000000000000000000
      0000C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00000000000082840000000000000000000000000000000000C6C3C6000000
      000000828400000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C60000000000C6C3C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008284000082840000000000000000000000000000000000000000000000
      0000C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000082840000000000000000000000000000000000000000000000
      000000828400000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      0000008284000082840000000000000000000000000000000000000000000000
      0000C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00000000000082840000828400008284000082840000828400008284000082
      840000828400000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400C6C3
      C600C6C3C6008482840000000000848284000000000000000000000000000000
      0000000000000000000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C60000FFFF0000FFFF0000FFFF00C6C3C600C6C3C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008284000082840000000000000000000000000000000000000000000000
      0000000000000000000000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF0000FFFF00FFFFFF00848284000000
      0000000000000082840000828400000000000000000000000000000000000082
      840000828400000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400C6C3C600C6C3
      C600FFFF00008482840084828400000000000000000000000000000000000000
      0000000000000000000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600848284008482840084828400C6C3C600C6C3C60000000000C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      0000008284000082840000828400008284000082840000828400008284000082
      8400008284000082840000828400008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF008482840084000000FF00
      0000000000000082840000000000C6C3C600C6C3C600C6C3C600C6C3C6000000
      000000828400000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C600C6C3C600C6C3
      C600C6C3C60084828400C6C3C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C3
      C600C6C3C6000000000000000000000000000000000000000000000000000000
      0000008284000082840000000000000000000000000000000000000000000000
      0000000000000000000000828400008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF0000FFFF0084820000FF0000008482
      0000000000000082840000000000C6C3C600C6C3C600C6C3C600C6C3C6000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C600FFFF0000C6C3
      C600C6C3C60084828400C6C3C600000000000000000000000000000000000000
      0000000000000000000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C60000000000C6C3C6000000
      0000C6C3C6000000000000000000000000000000000000000000000000000000
      00000082840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF0084820000C6C3C600C6C3
      C600000000000082840000000000C6C3C600C6C3C600C6C3C600C6C3C6000000
      0000C6C3C600000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400FFFF0000FFFF
      0000C6C3C6008482840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C3C60000000000C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      00000082840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF0000FFFF0084820000C6C3C6008482
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084828400C6C3
      C600C6C3C6008482840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C6000000
      0000C6C3C6000000000000000000000000000000000000000000000000000000
      00000082840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF00C6C3C600848200008482
      8400FF0000000082000084820000C6C3C600FFFFFF00C6C3C600000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000082840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000008284000000000000000000000000000000
      0000000000000000000084828400FFFFFF0000FFFF00FFFFFF00C6C3C6008482
      00008482000084820000C6C3C600FFFFFF0000FFFF00C6C3C600000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000082840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000000000000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000082840000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
      C600C6C3C600C6C3C60000000000C6C3C6000000000000000000000000000000
      0000000000000000000084828400FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF00C6C3C600FFFFFF0084828400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3
      C600000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00C6C3C6008482840000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084828400848284008482840084828400848284008482
      8400848284008482840084828400848284000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000082840000828400008284000082840000828400008284000082
      8400008284000082840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000828400008284000082840000828400008284000082
      8400008284000082840000828400000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000000000008284000082840000828400008284000082
      8400008284000082840000828400008284000000000000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00FFFFFF0000FFFF00000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000082840000828400008284000082
      8400008284000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848284000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000580200000100010000000000201C00000000000000000000
      000000000000000000000000FFFFFF00FFFFF0000000000000000000C600B000
      0000000000000000C42330000000000000000000C42330000000000000000000
      C431B0000000000000000000DDF330000000000000000000DDEC100000000000
      00000000DDEC10000000000000000000DDED50000000000000000000C5EC1000
      0000000000000000C5ED50000000000000000000DDED50000000000000000000
      DDED50000000000000000000DDED50000000000000000000DDEED00000000000
      00000000C42ED0000000000000000000C42ED0000000000000000000C42ED000
      0000000000000000C62ED0000000000000000000FFFFF0000000000000000000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFF1FF0000FFFFFFFFFFFF07FFE0FF0000FE0FFFFE
      7FFE63FF803F0000FCE7FFFE7FF9EDFF001F0000FCE7FFFE7FFBEDFF001F0000
      FFE7FFE01FFBE8FE000F0000FF8FFFEE7FFBF4FE000F0000FFE7FFF67FF9F27E
      000F0000FCE7FFFA7FFCF97E000F0000FCE7FFFC7FFEF83E000F0000FE0FFFFE
      7FFCFC3F001F0000FFFFFFFFFFE1FC3F001F0000FFFFFFFFFFDFFFFF803F0000
      FFFFFFFFFFFFFFFFE0FF0000FFFFFFFFFFFFFFFFF1FF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      DFFFFFFFFFFFFFFFFFFF0000AC003FFFFFFFFFFFE03F000078003FF07FFFFFFF
      F3FF000072003FE73FFF03FFF9FF00008BFF3FE73FFFCFFFFCFF0000E1FF3FFF
      3FFFCFFFFE7F0000CBFF3FFF3FFFCFFFFF3F0000E5FF3FF07FFFCFFFE73F0000
      F2003FF3FFFFCFFFE73F00005C003FF3FFFFCFFFF07F0000AFFFFFF03FFF0FFF
      FFFF0000AFFFFFFFFFFFFFFFFFFF0000DFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFCFFFF1FFFFFFF0000FF8FFFFCFFFE0FFFE0FF0000FF8FFFFC
      FFF803FFC07F0000FF8FFFF87FF001FF803F0000FF07FFF03FF001FF001F0000
      FE03FF8007E000FE000F0000FC003F8007E0007E000F0000E0003F800FE0007E
      000F0000E0003FE01FE0007E000F0000E000FFF87FE000FE000F0000FC01FC63
      1FF001FF001F0000FF07FFBDEFF001FF803F0000FFFFFF7FDFF803FFC07F0000
      FFFFFCFF3FFE0FFFE0FF0000FFFFFFBDEFFF1FFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFE00070000FFFFFFFFFFFFFEFE00070000
      FFFFFFFFFFFFFDFE00070000FFFFFFFFFFFF9BFE00070000E3F1FE3F1FFF67FE
      00070000E000FE000FFF57FE00070000E3F17E3F17FF4BFFFF070000FFFFBFFF
      FBFE83FFFF070000FFFFBFFFFBFD07FFFF070000CE7FBDEFFBF22F7FFF070000
      CE7FBD2FFBE4697FE0070000CE477D2C77E2E97FE0070000C0C0FCCC0FF0E67F
      E0070000CE47FCCC7FF9E67FE0070000CE7FFDEFFFFFEF7FE0070000CE7FFFFF
      FFFFFFFFE0070000C0FFFFFFFFFFFFFFE0070000FFFFFFFFFFFFFFFFFFFF0000
      FDFFFFFF7FFFFFFFFFFF0000F9FFFFFF3FFFFFFFFFFF0000F1FFFFFF1FFFFFFF
      FFFF0000E1FFFFFF0FC001FFFFFF0000C000FE0007A000FF7FEF00008000FE00
      03BFFE7E3FFF00000000FE0001A7FE3E1FDF00000000FE0001BFFE3F1FBF0000
      8000FE0003DFF93F8F3F0000C000FE0007E800BFC67F0000E1F3FF9F0FF0007F
      E0FF0000F1F3FE071FFFF83FF1FF0000F9E1FE973FE0003FE0FF0000FDD2F000
      7FE001FFC67F0000FE001000FFE0003F0F3F0000FFD2FE97FFFFF03E1F9F0000
      FFE1FE07FFFFF83E3FEF0000FFF3FF9FFFFFFFFFFFFF0000FFF3FF9FFFFFFFFF
      FFFF0000FFF3FF9FFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000E0003FF7EFFFFFFFFFFF0000C0003FEBD7FF7FFE003F0000
      C0003FE3C7FE7FFE003F0000C0003FC307FC7FFE003F0000C0003F822FF87FFE
      003F0000C0003E034FC001FE003F0000C0003DC14FF00FFE003F0000C0003E04
      1FF00DFE003F0000C0003FF21FF009FE003F0000C0003FD91FF0003E00170000
      C0003F849FF0003E00070000C0003F9E4FF0003E00070000C0003E7027F009FF
      E0070000C0003D8783F00DFFF0070000C0003E3FCBF00FFFF8170000C0003FFF
      E7F00FFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFDDFFFFFFFF0000FFFF3FFFF399FF3FFFFF0000FFFE3FFFE311FE3F
      FFFF0000FFFC7FFFC799FC7FFFBF0000FFF8FFFF8FDDF8FFC93F0000FFF1FFFF
      1FFC11FFDF3F0000F803FF803FF803FF7A6F0000E007FF007FF003FF786F0000
      E007FE007FE001FFF83F0000C003FC003FE001FEF8770000C003FC003FE001FE
      F8F70000C003FC003FE001FEF9F70000C003FC003FE001FFFBFF0000C003FC00
      3FE001FF7FEF0000C003FC003FF003FF7FEF0000E007FE007FF807FFDFBF0000
      F00FFF00FFFC0FFFC93F0000F81FFF81FFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFDFF0000FCFFFFFF3FF7EFFFF8FF0000F9FFFFFC0FF7CFFFF0670000
      FBF9FFF803FFCFFFFFCF0000FBC47F9C07F69FFFFF9F0000FB9F7E1807F61FFF
      F0BF0000F93FBC0007FE0FFFE07F0000FC7F3F0007F61FFEE0370000FFFF7F80
      07F63FFCE0330000F9F37FC007FE7FF8E0310000F9F3FFE007F6FFFCE0330000
      F9F3FFF007F7FFFEF0770000F9F3FFF807FFFFFFFFFF0000F9F3FFFC07F7FFFF
      FFFF0000E040FFFE07F7FFFFFFFF0000E040FFFF07FFFFFFF07F0000FFFFFFFF
      C7F7FFFFF8FF0000FFFFFFFFFFF7FFFFFDFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      CFFF0000FFFFFFFFFFFF1FFF9FFF0000FFF7FFFCFFF01FFFBF9F0000FC03FFFC
      FFFF1FFFBC470000C001FFD9FFFFFFFFB9F70000C000FFC1FFFFFFFF93FB0000
      E0007FC1FFFFE3FFC7F30000F800FFC07FF001FFFFF70000F001FFC0FFFFE2FF
      9FE70000E001FFC1FFFFFF7F9F9F0000C003FFC3FFFFFF7F9FFF0000C003FFC7
      FFFFFF7F9FFF0000C007FFCFFFFFFF7F9FFF0000E00FFFDFFFEF8EFE07FF0000
      E49FFFFFFFEF81FE07FF0000FFFFFFFFFFFF8FFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFF3FFFFFFFFFF0000FFFFFFEF
      E1FFFFFFFFFF0000FFFFFFC761FFFFFFFFFF0000FFFFFFC703FC07FFFFFF0000
      E4647FBB03F803FFFFFF0000FFE7FFBB01F1F1FF540F0000EF4F7F7D03E3F8FF
      820F0000EF0F7CFD07E798FF000F0000FF07F8FE0FE70CFF820F0000EF0F7DFE
      1FE70CFF000F0000EF1F7FFF3FE79FFF820F0000FF3FFFFF7FE3FCFF540F0000
      EF7F7FFF3FE37FFF000F0000EFFF7FFF1FF139FF000F0000FFFFFFFF9FF81FFF
      000F0000EFFF7FFFEFFC1FFF000F0000E4927FFFF3FF3FFF000F0000FFFFFFFF
      F1FF7FFF000F0000FFFFFFFFFBFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFE7F
      FFFF0000FFFFFFFFFFFFFC7FFFFF0000FFFFFE4647FFF8FFFFFF0000FFFFFFFE
      7FFFF1FFFFFF0000FC03FEF4F7F063FC7FFF0000FC03FEF0F7C007FC00070000
      F801FFF07F800FFC00070000F801FEF0F7800C1E00070000F000FEF1EF0007FE
      00070000F000FFF3FF00077E00070000F801FEF7BF00077E00070000FC03FEFF
      7F00041E00070000FE07FFBFFF00077E00030000FF0FFFDDFF800F7E00030000
      FF9FFFF3FF800FFFFFE30000FFFFFFFFFFC01FFFFFFF0000FFFFFFFFFFF07FFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFEFFFFEFFFFFFFFFFF0000
      FFFDFFFFDFFFFFFFFFFF0000FF9BFFF9BFFFFFFFFFFF0000FF67FFF67FE3F1FF
      FFFF0000FF57FFF57FE000FFFFFF0000FF4BFFF4BFE3F17FFFFF0000FE83FFE8
      3FFFFFBFFBFF0000FD07FFD07FFFFFBFF1FF0000F23FFF23FFFFFFBFFBFF0000
      E47FFE4777FFFFBFFFFF0000E2FFFE2F77FFC77FFFFF0000F0FFFF0F8FFFC0FF
      FFFF0000F9FFFF9FAFFFC7FFFFFF0000FFFFFFFFDFFFFFFFFFFF0000FFFFFFFF
      DFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFE0003E
      00030000FFFFFFF807C0003C00030000FFDFFFF007D0003D00030000FF8FFFF0
      07D0003D00030000FF07FE0007C0103C00030000FFDFFC0007C0003C00030000
      FFDFFC0007C0003C00030000FBDEFC0007C0003C00030000F3DE7C0007C0803C
      00030000E0003C0007C0803C00030000F3DE7C0007C0003C00030000FBDEFC00
      0FC0303C00030000FFDFFC01FFC000BC00030000FFDFFC01FFC000BC00030000
      FF07FC03FFC0003C00030000FF8FFFFFFFC0003C00030000FFDFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFF3FFFFFFFFFFF0000FFDFFFFC0FFFFFFFFFFF0000
      FFBFFE0003FFFFFFFFFF0000FF7FFF9C07E3FFF800030000FEFFFE0007E3FFF8
      00030000C0FDFC0007E3FFF800030000DAFDFF0007FDFFF800030000D6F07E00
      07FEFFF800030000D6FDFFC007FF7FF800030000DAFDFFE007FFBFF800030000
      C0FFFE0007FFDFF800030000FEFFFFF807FFEFF800030000FF7FFFFC07FFF7F8
      00030000FFBFFE0007FFF8F800030000FFDFFFFF07FFF8F800030000FFEFFFFF
      C7FFF8FFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFC0000FFFFFFFFFF0000FFFFFC0000FFFFFF
      FEFF0000FFFFFCFFFFFF0FFFFCFF0000FFFFFCCC14FC03FFFCFF0000FFFFFCCC
      00F801FFE9FF0000FFFFF8CCC9F000FFE1FF0000FC07FCCC09F000FFE0FF0000
      F001F0CE80E0007FE1FF0000E000FCC7F9E0007FE3FF0000C0013807FFE0007F
      E7FF0000C0003CFFFFE0007FEFFF0000C0013E0000F000FFFFFF0000E000FFFF
      FFF000FFFFFF0000F0A1FFFFFFF801FFFFFF0000FC07FFFFFFFC03FC92490000
      FF1FFFFFFFFF0FFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFE000000FFFFFFFF
      FFFFFFFFFE000000FFFFFFEFFFFFFFFFFE000000FFFFFFDFFFFFFFFFFE000000
      FFFFFFBFFFF800FFFE000000EFFF7F07FFFFF7F3F8000000EFFF7E8FFFFFE3F3
      F0000000EFFF7D8FFFFFC1F1E0000000EFFF7FB7FFFFF7F1C2000000EDFB7FFB
      FFFFF7F086000000E9F97FFDBFFFF7F00E000000E0007FFE37FFF7F01FFF0000
      E9F97FFE2FFFF7F00FFF0000EDFB7FFC1FFFF7F000FF0000EFFF7FFFBFFFC1F0
      007F0000FFFFFFFF7FFFE3F001FF0000FFFFFFFEFFFFF7F007FF0000FFFFFFFF
      FFF800F01FFF0000FFFFFFFFFFFFFFF07FFF0000FFFFFFFFFFFFFFF1FFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFE0003FFFFFF
      FFFF0000FF807C0003FF0FFFFDFF0000FF007D0003FC03FFFBFF0000FF007D00
      03F801FFF7FF0000E0007C0003F000FFEFFF0000C0007C0003F000FC0FFF0000
      C0007C0003E0007DAFFF0000C0007C0003E0007D6F070000C0007C0003E0007D
      6FFF0000C0007C0003E0007DAFFF0000C0007C0003F000FC0FFF0000C000FC00
      03F000FFEFFF0000C01FFC0003F801FFF7FF0000C01FFC0003FC03FFFBFF0000
      C03FFC0003FF0FFFFDFF0000FFFFFC0003FFFFFFFEFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFBFFFFF1FFFFFFF0000
      FFFFFF9FFFFE0FFFE0FF0000E7FFFF8FFFF803FFC07F0000E7FFFFC7FFF001FF
      803F0000FBFFFFC3FFF001FF001F0000FDFFFC0003E000FE000F0000FEFFFC00
      03E0007E000F0000FF7FFC0003E0007E000F0000FFBFFC0003E0007E000F0000
      FFFBFC0003E000FE000F0000FFFBFC0003F001FF001F0000FFFBFC0003F001FF
      803F0000FFFBFC0003F803FFC07F0000FFE0FC0003FE0FFFE0FF0000FFFFFFFF
      FFFF1FFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000CFFFFFFFFFFFFFFFFFFF0000B6000E0003FFFFFF
      FFFF00007C000C0003FFFFFFFFFF000079000D0003FFFFFE46470000527FED00
      03C0003FFE7F0000A57FEC000380003EF4F70000F07FEC000380003EF0F70000
      E57FEC000380003FF07F0000D27FEC000380003EF0F70000D9000C000380003E
      F1FF0000DCAAAC000380003FF3FF00006E000C000380003EF7FF0000B7FFFC00
      0380003EFFFF0000B7FFFC000380007FBFFF0000CFFFFC0003FFFFFFDCFF0000
      FFFFFC0003FFFFFFF37F0000FFFFFC0003FFFFFFFFBF0000FFFFFFFFFFFFFFFF
      FFDF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFE03FFFFFFFFFF0000FFFFFFFE03FFFEFFFFFF0000
      FE003FFE03FFFDFE7FFF0000FC007FC003FF9BFC3FFF0000F9FEFFC003FF67FC
      3FFF0000F2003FC003FF57FE7FFF0000E4007FC003FF4BFEFFFF0000C1FEFE00
      1FFE83FEFFFF0000F2003E001FFD03FF7FFF0000E4007E001FF233FF7FFF0000
      C000FE001FE473FFBFFF0000F001FE001FE2807FC7FF0000E003FE03FFF0807F
      C7FF0000C007FE03FFF9F3FFC7FF0000FFFFFFFFFFFFF3FFF9CF0000FFFFFFFF
      FFFFF3FFFE070000FFFFFFFFFFFFFFFFFFCF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFE000FFFFFFF
      FE030000FC07FE000FFFFFFFFE030000F803FE000FE0007FFE030000F001FE00
      0FE0007FC0030000E000FE000FE0007FC0030000C0007E000FE0007FC0030000
      C0007E000FE0007FC0030000C0007E000FE0007E001F0000C0007E000FE0007E
      001F0000C0007E000FE0007E001F0000C0007E000FE0007E001F0000C0007E00
      0FE0007E001F0000E000FE000FE0007E03FF0000F001FE001FE0007E03FF0000
      F803FE003FFFFFFFFFFF0000FC07FE007FFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFBFFFFFFFFFFF0000FFFFFFFF3FFE7FFFF8FF0000
      FFFFFF801FFE7FFFE07F0000F800FF000FFCF1FF803F0000F03FFE0007DCF1FE
      001F0000E01FFE0007C9FFFC000F0000C00FFE0007C1F1FC00070000C007FE00
      07C031FC00030000E003FE0007C079FC00070000F001FE0007C0FC7E00070000
      F801FE0007C18C3F00070000FC01FE0007C38E3F80030000FE01FE0007C78E3F
      C0030000FF03FE0007CFCC3FE00F0000FF87FE000FDFE07FF03F0000FFFFFF00
      1FFFFFFFF8FF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000C1FFFFFFFFFFFFFFFFFF0000FE7FFCFFFFCFFFFC01FF0000FF1FFF1C
      0FFFDFFFFCFF0000FE0FFF3E1FFFCFFFFC7F0000FC07FF9E3FFFC7FFFC3F0000
      F803FF9E3FFFC3FFFC1F0000F001FFC07FFFC1FFFC1F0000E000FFCC7FFFC3FF
      FE0F0000C000FFE4FFFFC7FFFE0F0000F801FFE0FFFFCFFFFF070000FE00FFF1
      FFFFDFFFFF070000FF007FF1FFFFFFFFFF830000FF883FFBFFFFFFFFFF830000
      FFFC3FFFFFFFFFFFFFC70000FFFE7FFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFC003FFFFFFFF3F0000FFFFFFC003C000FFFC0F0000
      F0003FC003C0007FF8030000E0003FC003C0003F9C070000E0003FC003C0003E
      18070000C0003FC003C0007C00070000C0003FC003C0007F00070000C0003FC0
      03C0007F80070000C0003FC003C0007FC0070000E0003DC003C0007FE0070000
      E0003CC003C0007FF0070000E0003C4003C3007FF8070000C0007C3FFFC3007F
      FC070000C47FFC7FFFC3047FFE070000FE3FFCFFFFE307FFFF070000FF1FFDFF
      FFF387FFFFC70000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFF0007F0007F00030000C1F07F0003F0007E00030000C1F07F00
      03F0007E00030000C1F07F0003F0007E00030000C0407F0003F0007E00030000
      C0007F0003F0007E00030000C0007F0003F0007C00030000C0007F0003F0007C
      00030000E000FF0003F0007E00030000F041FF0003F0007C00030000F041FF00
      03F0007C00070000F8E3FF0003F0007E07FF0000F8E3FF0007F0007C93FF0000
      F8E3FFFFFFFFFFFD9BFF0000FFFFFFFFFFFFFFFF9FFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FCFFFFFFFFFF003FFFFF0000
      FB67FFF803E0003E01FF0000FB5BFFF803C0003E00FF0000FB5BFFF803C0003E
      007F0000FC5BFE0003C0003E003F0000FF47FE0003C0007F001F0000FF1FFE00
      03C000FF800F0000FFBFFE0003C000FFC0070000FF1FFE0007C000FFE0070000
      FF5FFE000FC000FFF0070000FE4FFE001FC000FFF8070000FEEFFE01FFC000FF
      FC070000FEEFFE03FFE001FFFFFF0000FEEFFE07FFFE1FFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FC03FFFFFFFFFFFFFFFF0000F800FFFFFFFFFFFFF0FF0000F8007FFF
      FFFFFFFFC03F0000FC003FFFFFFFFFFF8F1F0000FC003FFF9FF9FFFF9F9F0000
      FE003F07CFF3E0FF3FCF0000FE003F0FEFF7F0FF3FCF0000E4003F1FEFF7F8FF
      3FCF0000C0003F2FEFF7F4FF3FCF0000C0003F73CFF3CEFF9E9F0000C0003FFC
      1FF83FFF9E1F0000E6003FFFFFFFFFFFFE3F0000FE003FFFFFFFFFFFFE1F0000
      FE003FFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFFFFF003FFFFFFFFFF0000F0007C0003C0033F001F0000
      E0007C0003C0023E000F0000E0007C0003C0007C00070000E0007C0003C000FC
      00070000E0007C0003C000FC00070000E0007C0003C000FC00030000E0007C00
      03C000FC00030000E0007C0003C000FE00030000E0007C0003C001FF00030000
      E0007C001FC003FF80070000E0007C001FC003FF801F0000E0007C001FC003FF
      C01F0000E0007C003FC007FFC00F0000E0007C007FC00FFFE00F0000FFFFFC00
      FFC01FFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFF0000FFFF9FFFFFFFFFFFFFFF0000FFFF1FFFFFFFFFFF
      FFFF0000FFC23FFFFFFFFFFE000F0000FF007F001FE003FE000F0000FE007F00
      1FE001FE000F0000AA007F001FE000FE000F0000FC003F001FE0007E000F0000
      BC003F001FE0003E000F0000FC003F001FE0003E000F0000BC003F001FE003FE
      000F0000FE007F001FE003FE000F0000BE007F001FE003FF07FB0000FF00FF00
      1FF1FE3F8FFB0000BFC3FF003FFFFF3FFFD70000FFFFFF007FFFEEBFFFCF0000
      BFFBFF00FFFFF1FFFFC70000FFFFFFFFFFFFFFFFFFFF0000AAABFFFFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object ReopenActionList1: TActionList
    Left = 156
    Top = 232
    object Action1: TAction
      Caption = 'Action4'
    end
    object Action5: TAction
      Caption = 'Action5'
    end
    object Action2: TAction
      Caption = 'Action6'
    end
    object Action3: TAction
      Caption = 'Action7'
    end
    object Action10: TAction
      Caption = 'Action8'
    end
  end
  object CustomizeDlg1: TCustomizeDlg
    ActionManager = ActionManager1
    StayOnTop = False
    Left = 128
    Top = 260
  end
  object ERMapperLauncher: TEzActionLauncher
    CmdLine = CmdLine1
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursorFrame, mdFullViewCursor]
    OnTrackedEntity = ERMapperLauncherTrackedEntity
    Left = 397
    Top = 186
  end
end
