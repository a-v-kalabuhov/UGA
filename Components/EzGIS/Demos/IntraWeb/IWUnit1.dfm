object formMain: TformMain
  Left = 0
  Top = 0
  Width = 707
  Height = 424
  OnCreate = IWAppFormCreate
  SupportedBrowsers = [brIE, brNetscape6]
  Background.Fixed = False
  HandleTabs = False
  JavaScript.Strings = (
    ''
    'function MouseMove2D( x,  y){'
    ''
    '  var tmp = "" + x;'
    '   tmp = tmp.substring(0, tmp.indexOf('#39'.'#39', 1) + 4);'
    ''
    '  var tmp2 = "" + y;'
    '   tmp2 = tmp2.substring(0, tmp2.indexOf('#39'.'#39', 1) + 4);'
    ''
    '  SubmitForm.IWEDIT1.value = "X = " + tmp + "  Y = " + tmp2;'
    '}'
    '')
  DesignLeft = 46
  DesignTop = 69
  object Map: TEzIWMap
    Left = 8
    Top = 8
    Width = 209
    Height = 49
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    BorderOptions.Color = clNone
    BorderOptions.Width = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
    About = 'EzGIS Version 1.96.10 (Mar, 2003)'
    DrawBox = DrawBox
    IWScaleBar = EzIWScaleBar1
    NumberOfLabelsInCS = 20
    CoordFunction = 'MouseMove2D'
    OnEntityClick = MapEntityClick
  end
  object Grid: TIWGrid
    Left = 408
    Top = 8
    Width = 257
    Height = 41
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    BorderColors.Color = clNone
    BorderColors.Light = clNone
    BorderColors.Dark = clNone
    BGColor = clNone
    BorderSize = 1
    BorderStyle = tfDefault
    CellPadding = 0
    CellSpacing = 0
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FrameBuffer = 40
    Lines = tlAll
    OnRenderCell = GridRenderCell
    UseFrame = False
    UseSize = True
    ColumnCount = 3
    OnCellClick = GridCellClick
    RowCount = 3
  end
  object btnZoomIn: TIWButton
    Left = 408
    Top = 152
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Zoom In'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 0
    OnClick = btnZoomInClick
  end
  object btnZoomOut: TIWButton
    Left = 494
    Top = 152
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Zoom Out'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 1
    OnClick = btnZoomOutClick
  end
  object btnPick: TIWButton
    Left = 574
    Top = 152
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Pick Entity'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 2
    OnClick = btnPickClick
  end
  object btnZoomAll: TIWButton
    Left = 576
    Top = 184
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Zoom All'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 3
    OnClick = btnZoomAllClick
  end
  object Memo: TIWMemo
    Left = 408
    Top = 248
    Width = 257
    Height = 129
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    BGColor = clWebWHITE
    Editable = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    HorizScrollBar = False
    ReadOnly = False
    Required = False
    TabOrder = 4
    WantReturns = False
    FriendlyName = 'Memo'
  end
  object btnZoomWin: TIWButton
    Left = 408
    Top = 184
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'ZoomWin'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 5
  end
  object btnPan: TIWButton
    Left = 494
    Top = 184
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Pan'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 6
  end
  object btnSelect: TIWButton
    Left = 408
    Top = 216
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Select'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 7
  end
  object btnClear: TIWButton
    Left = 576
    Top = 216
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Clear Sel.'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 8
    OnClick = btnClearClick
  end
  object btnRemove: TIWButton
    Left = 560
    Top = 384
    Width = 105
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Remove Script'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 9
    OnClick = btnRemoveClick
  end
  object btnAdd: TIWButton
    Left = 480
    Top = 384
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Add Script'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 10
    OnClick = btnAddClick
  end
  object btnCircleSelect: TIWButton
    Left = 496
    Top = 216
    Width = 75
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Circle Sel.'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 11
  end
  object IWLabel1: TIWLabel
    Left = 8
    Top = 397
    Width = 104
    Height = 16
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    Alignment = taLeftJustify
    Color = clNone
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    NoWrap = False
    Caption = 'Select operator:'
  end
  object cboOperator: TIWComboBox
    Left = 104
    Top = 392
    Width = 121
    Height = 21
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = '-- No Selection --'
    Required = False
    RequireSelection = True
    ScriptEvents = <>
    OnChange = cboOperatorChange
    UseSize = False
    DoSubmitValidation = True
    Editable = True
    TabOrder = 12
    ItemIndex = 0
    Items.Strings = (
      'goWithin'
      'goEntirelyWithin'
      'goContains'
      'goContainsEntire'
      'goIntersects'
      'goEntirelyWithinNoEdgeTouched'
      'goContainsEntireNoEdgeTouched'
      'goExtentOverlaps'
      'goShareCommonPoint'
      'goShareCommonLine'
      'goLineCross'
      'goCommonPointOrLineCross'
      'goEdgeTouch'
      'goEdgeTouchOrIntersect'
      'goPointInPolygon'
      'goCentroidInPolygon'
      'goIdentical')
    Sorted = False
  end
  object IWEdit1: TIWEdit
    Left = 8
    Top = 364
    Width = 273
    Height = 25
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.BackColor = clNone
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEdit1'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 13
    PasswordPrompt = False
    Text = 'IWEdit1'
  end
  object EzIWScaleBar1: TEzIWScaleBar
    Left = 287
    Top = 365
    Width = 113
    Height = 18
    Cursor = crAuto
    IW50Hint = False
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    BorderOptions.Color = clNone
    BorderOptions.Width = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
    About = 'EzGIS Version 1.96.10 (Mar, 2003)'
    IWMap = Map
  end
  object DrawBox: TEzDrawBox
    Left = 20
    Top = 20
    Width = 385
    Height = 345
    UseThread = False
    TabOrder = 0
    About = 'EzGIS Version 1.96.10 (Mar, 2003)'
    ScaleBar = EzScaleBar1
    GIS = Gis1
    NoPickFilter = []
    SnapToGuidelinesDist = 1
    ScreenGrid.Step.X = 1
    ScreenGrid.Step.Y = 1
    ShowMapExtents = False
    ShowLayerExtents = False
    GridInfo.Grid.X = 1
    GridInfo.Grid.Y = 1
    GridInfo.GridColor = clMaroon
    GridInfo.DrawAsCross = True
    GridInfo.GridSnap.X = 0.5
    GridInfo.GridSnap.Y = 0.5
    RubberPen.Color = clRed
    RubberPen.Mode = pmXor
    ScrollBars = ssNone
    FlatScrollBar = False
    object EzScaleBar1: TEzScaleBar
      Left = 176
      Top = 112
      Width = 93
      Height = 22
      Cursor = crHandPoint
      About = 'EzGIS Version 1.96.10 (Mar, 2003)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Color = clWindow
      LinesPen.Color = clRed
      MinorBrush.Color = 15780518
      MajorBrush.Color = clNavy
      IntervalLengthUnits = suCms
      IntervalLength = 1
      BarHeight = 8
      IntervalNumber = 2
      NumDecimals = 0
      Units = cum
    end
  end
  object Gis1: TEzGIS
    Active = False
    LayersSubdir = 'C:\D7\Bin\'
    About = 'EzGIS Version 1.96.10 (Mar, 2003)'
    Left = 264
    Top = 16
  end
end
