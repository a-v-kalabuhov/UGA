object mstEditProjectDialog: TmstEditProjectDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1077#1082#1090
  ClientHeight = 729
  ClientWidth = 1109
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    1109
    729)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 43
    Top = 11
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1040#1076#1088#1077#1089':'
  end
  object Label2: TLabel
    Left = 403
    Top = 11
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1086#1084#1077#1088':'
  end
  object Label3: TLabel
    Left = 579
    Top = 11
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1072#1090#1072':'
  end
  object Label4: TLabel
    Left = 16
    Top = 123
    Width = 62
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1057#1083#1086#1080' '#1083#1080#1085#1080#1081':'
  end
  object Label5: TLabel
    Left = 528
    Top = 37
    Width = 81
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1088#1082#1080':'
  end
  object Label6: TLabel
    Left = 27
    Top = 60
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082':'
  end
  object Label7: TLabel
    Left = 8
    Top = 86
    Width = 70
    Height = 13
    Alignment = taRightJustify
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 112
    Width = 1093
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object SpeedButton1: TSpeedButton
    Tag = -1
    Left = 398
    Top = 118
    Width = 23
    Height = 23
    Flat = True
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888008
      8888888888880FF08888888888880FF0888888808880FF08888888800880FF08
      88888880F00FF08888888880FFFFF08888888880FFFFF00008888880FFFFFFF0
      88888880FFFFFF0888888880FFFFF08888888880FFFF088888888880FFF08888
      88888880FF08888888888880F088888888888880088888888888}
    ParentShowHint = False
    ShowHint = False
    OnClick = SpeedButton1Click
  end
  object BtnHand: TSpeedButton
    Tag = -1
    Left = 425
    Top = 118
    Width = 22
    Height = 23
    Hint = #1055#1077#1088#1077#1090#1072#1089#1082#1080#1074#1072#1085#1080#1077' '#1088#1091#1082#1086#1081
    Flat = True
    Glyph.Data = {
      EE000000424DEE0000000000000076000000280000000F0000000F0000000100
      0400000000007800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333033333333330333303333000000FF33308000FFFFFFFFF3300FFFFFFFFFFF
      FF3030000FFFFFFFFF003330FFFFFFFFF030330FFFFFFFFF033030FF0FFFFFFF
      03300FF0FFFFFFF033300F0FF0FF0FF0333080FF0FF0FF03333030F0FF0FF033
      333038030030033333303333333333333330}
    ParentShowHint = False
    ShowHint = False
    OnClick = BtnHandClick
  end
  object ZoomWBtn: TSpeedButton
    Tag = -1
    Left = 453
    Top = 118
    Width = 23
    Height = 23
    Hint = #1047#1091#1084
    Flat = True
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      88888888444C8888888888888888800823108888888888888888000888C88888
      888888000080008800318888888800FFFF000888102588888880FFFFFFFF0888
      995580808080FFFFFFFF088810258888880FFFFFFFFFF0889D448088880FFFFF
      FFFFF08822268888880FFFFFFFFFF08800018088880FFFFFFFFFF08819A28888
      8880FFFFFFFF0888200280888880FFFFFFFF0888444C8888888800FFFF008888
      0103808888888800008888882244888888888888888888884126808888888888
      8088888821918888888888888888888802548080808080808088888845F48888
      88888888888888880B0A}
    ParentShowHint = False
    ShowHint = False
    OnClick = ZoomWBtnClick
  end
  object ZoomIn: TSpeedButton
    Tag = -1
    Left = 482
    Top = 118
    Width = 22
    Height = 23
    Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100
    Flat = True
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888800008888888888888888008800008888888888888880008800008888
      8888888888000888000088888888888880008888000088888888888800088888
      0000888887000070008888880000888700FFFF000888888800008880FFFFFFFF
      0888888800008870FFFCCFFF078888880000880FFFFCCFFFF08888880000880F
      FCCCCCCFF08888880000880FFCCCCCCFF08888880000880FFFFCCFFFF0888888
      00008870FFFCCFFF0788888800008880FFFFFFFF088888880000888800FFFF00
      8888888800008888870000788888888800008888888888888888888800008888
      88888888888888880000}
    ParentShowHint = False
    ShowHint = False
    OnClick = ZoomInClick
  end
  object ZoomOut: TSpeedButton
    Tag = -1
    Left = 510
    Top = 118
    Width = 23
    Height = 23
    Hint = #1059#1084#1077#1085#1100#1096#1080#1090#1100
    Flat = True
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888800008888888888888888008800008888888888888880008800008888
      8888888888000888000088888888888880008888000088888888888800088888
      0000888887000070008888880000888800FFFF000888888800008880FFFFFFFF
      0888888800008870FFFFFFFF078888880000880FFFFFFFFFF08888880000880F
      FCCCCCCFF08888880000880FFCCCCCCFF08888880000880FFFFFFFFFF0888888
      00008870FFFFFFFF0788888800008880FFFFFFFF088888880000888800FFFF00
      8888888800008888870000788888888800008888888888888888888800008888
      88888888888888880000}
    ParentShowHint = False
    ShowHint = False
    OnClick = ZoomOutClick
  end
  object ZoomAll: TSpeedButton
    Tag = -1
    Left = 539
    Top = 118
    Width = 23
    Height = 23
    Hint = 'Zoom extents'
    Flat = True
    Glyph.Data = {
      62030000424D6203000000000000420000002800000014000000140000000100
      1000030000002003000000000000000000000000000000000000007C0000E003
      00001F0000001863186318631863186318631863186318631863186318631863
      1863186318631863186318631863186318631863186318631863186318631863
      18631F0018631863186318631863186318631863186318631863186318631863
      18631863186318631F001F001F00186318631863186318631863186318631863
      18631863186318631863186318631F001F001F001F001F001863186310420000
      1863186318631863186318631863186318631863186318631863186318631863
      1863104200001863186318631863186318631863186318631863186318631863
      1863186318631863104200001863186318631863186318631863186318631863
      1863186318631042000000000000186300001863186318631863186318631863
      18631863186318631863186310420000FF7FFF7FFF7F00001863186318631863
      1863186318631863186318631F001863186318630000FF7FFF7FFF7FFF7FFF7F
      0000186318631F00186318631863186318631F001F001863186318630000FF7F
      FF7FFF7FFF7FFF7F0000186318631F001F001863186318631F001F001F001863
      186318630000FF7FFF7FFF7FFF7FFF7F0000186318631F001F001F0018631863
      18631F001F0018631863186310420000FF7FFF7FFF7F00001042186318631F00
      1F00186318631863186318631F00186318631863186310420000000000001042
      1863186318631F00186318631863186318631863186318631863186318631863
      1863186318631863186318631863186318631863186318631863186318631863
      1863186318631863186318631863186318631863186318631863186318631863
      1863186318631863186318631863186318631863186318631863186318631863
      186318631863186318631863186318631863186318631F001F001F001F001F00
      1863186318631863186318631863186318631863186318631863186318631863
      1F001F001F001863186318631863186318631863186318631863186318631863
      186318631863186318631F001863186318631863186318631863186318631863
      1863186318631863186318631863186318631863186318631863186318631863
      186318631863}
    ParentShowHint = False
    ShowHint = False
    OnClick = ZoomAllClick
  end
  object lCoords: TLabel
    Left = 1065
    Top = 129
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'lCoords'
    Visible = False
  end
  object edAddress: TEdit
    Left = 84
    Top = 7
    Width = 300
    Height = 21
    MaxLength = 120
    TabOrder = 0
    Text = 'edAddress'
  end
  object edDocNum: TEdit
    Left = 444
    Top = 8
    Width = 116
    Height = 21
    MaxLength = 120
    TabOrder = 1
    Text = 'edAddress'
  end
  object edDate: TEdit
    Left = 615
    Top = 8
    Width = 116
    Height = 21
    MaxLength = 120
    TabOrder = 2
    Text = 'edAddress'
  end
  object EzDrawBox1: TEzDrawBox
    Left = 390
    Top = 147
    Width = 711
    Height = 559
    UseThread = False
    TabOrder = 16
    OnMouseMove = EzDrawBox1MouseMove
    GIS = EzGIS1
    Anchors = [akLeft, akRight, akBottom]
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
    OnAfterSelect = EzDrawBox1AfterSelect
  end
  object cbLayers: TComboBox
    Left = 84
    Top = 120
    Width = 286
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    TabOrder = 10
    OnChange = cbLayersChange
  end
  object ListBoxLines: TListBox
    Left = 8
    Top = 147
    Width = 55
    Height = 559
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    TabOrder = 11
    OnClick = ListBoxLinesClick
    OnDblClick = ListBoxLinesDblClick
  end
  object grdCoords: TkaDBGrid
    Left = 70
    Top = 147
    Width = 314
    Height = 360
    Anchors = [akLeft, akBottom]
    DataSource = DataSource1
    TabOrder = 12
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnExit = grdCoordsExit
    OnKeyPress = grdCoordsKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'X'
        ReadOnly = True
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Y'
        ReadOnly = True
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Z'
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Delta'
        ReadOnly = True
        Title.Caption = #1059#1082#1083#1086#1085
        Visible = True
      end>
  end
  object EzCmdLine1: TEzCmdLine
    Left = 0
    Top = 705
    Width = 1109
    Height = 24
    DrawBoxList = <
      item
        DrawBox = EzDrawBox1
        Current = False
      end>
    DynamicUpdate = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Color = clWhite
    Align = alBottom
    TabOrder = 15
    TabStop = False
    Visible = False
  end
  object btnOK: TButton
    Left = 945
    Top = 8
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 13
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 1026
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 14
  end
  object chbConfirmed: TCheckBox
    Left = 403
    Top = 35
    Width = 67
    Height = 17
    Alignment = taLeftJustify
    Caption = #1055#1088#1086#1074#1077#1088#1077#1085
    TabOrder = 4
    OnClick = chbConfirmedClick
  end
  object edConfirmDate: TEdit
    Left = 615
    Top = 32
    Width = 116
    Height = 21
    Enabled = False
    MaxLength = 120
    ParentColor = True
    TabOrder = 5
  end
  object edCustomer: TEdit
    Left = 84
    Top = 57
    Width = 647
    Height = 21
    MaxLength = 120
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
    Text = 'edAddress'
    OnKeyPress = edCustomerKeyPress
  end
  object btnCustomer: TButton
    Left = 736
    Top = 55
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 7
    OnClick = btnCustomerClick
  end
  object edExecutor: TEdit
    Left = 84
    Top = 83
    Width = 647
    Height = 21
    MaxLength = 120
    ParentColor = True
    ReadOnly = True
    TabOrder = 8
    Text = 'edAddress'
    OnKeyPress = edExecutorKeyPress
  end
  object btnExecutor: TButton
    Left = 736
    Top = 81
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 9
    OnClick = btnExecutorClick
  end
  object chbCK36: TCheckBox
    Left = 327
    Top = 34
    Width = 57
    Height = 17
    Alignment = taLeftJustify
    Caption = #1052#1057#1050'36'
    TabOrder = 3
  end
  object gbObjectSemantic: TGroupBox
    Left = 69
    Top = 513
    Width = 315
    Height = 194
    Caption = #1057#1077#1084#1072#1085#1090#1080#1082#1072' '#1086#1073#1098#1077#1082#1090#1072
    TabOrder = 17
    object lSemDiam: TLabel
      Left = 7
      Top = 23
      Width = 48
      Height = 13
      Caption = #1044#1080#1072#1084#1077#1090#1088':'
    end
    object lSemVoltage: TLabel
      Left = 158
      Top = 23
      Width = 47
      Height = 13
      Caption = #1053#1072#1087#1088#1103#1078'.:'
    end
    object lHDiff: TLabel
      Left = 268
      Top = 45
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1082#1083#1086#1085
    end
    object lSemInfo: TLabel
      Left = 7
      Top = 46
      Width = 31
      Height = 13
      Caption = #1048#1085#1092#1086':'
    end
    object edDiam: TEdit
      Left = 60
      Top = 20
      Width = 92
      Height = 21
      Enabled = False
      MaxLength = 50
      ParentColor = True
      TabOrder = 0
    end
    object edVoltage: TEdit
      Left = 210
      Top = 20
      Width = 92
      Height = 21
      Enabled = False
      MaxLength = 50
      ParentColor = True
      TabOrder = 1
    end
    object mInfo: TMemo
      Left = 7
      Top = 61
      Width = 295
      Height = 90
      Enabled = False
      Lines.Strings = (
        'mInfo')
      ParentColor = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object btnSemCopy: TButton
      Left = 15
      Top = 157
      Width = 75
      Height = 25
      Action = acSemCopy
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnSemPaste: TButton
      Left = 96
      Top = 157
      Width = 75
      Height = 25
      Action = acSemPaste
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
  end
  object dsCoords: TRxMemoryData
    FieldDefs = <
      item
        Name = 'X'
        DataType = ftFloat
      end
      item
        Name = 'Y'
        DataType = ftFloat
      end
      item
        Name = 'Z'
        DataType = ftFloat
      end>
    BeforeInsert = dsCoordsBeforeInsert
    AfterPost = dsCoordsAfterPost
    AfterScroll = dsCoordsAfterScroll
    Left = 816
    object dsCoordsX: TFloatField
      FieldName = 'X'
      DisplayFormat = '###########0.00'
      Precision = 2
    end
    object dsCoordsY: TFloatField
      FieldName = 'Y'
      DisplayFormat = '###########0.00'
      Precision = 2
    end
    object dsCoordsZ: TFloatField
      FieldName = 'Z'
      DisplayFormat = '###########0.00'
      Precision = 2
    end
    object dsCoordsDelta: TFloatField
      FieldKind = fkCalculated
      FieldName = 'Delta'
      OnGetText = dsCoordsDeltaGetText
      Precision = 2
      Calculated = True
    end
  end
  object DataSource1: TDataSource
    DataSet = dsCoords
    OnUpdateData = DataSource1UpdateData
    Left = 856
  end
  object EzGIS1: TEzGIS
    Active = False
    LayersSubdir = 'C:\Program Files\CodeGear\RAD Studio\5.0\bin\'
    OnBeforePaintEntity = EzGIS1BeforePaintEntity
    Left = 896
  end
  object ActionList1: TActionList
    Left = 936
    Top = 56
    object acSemCopy: TAction
      Caption = #1047#1072#1087#1086#1084#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1077#1084#1085#1072#1090#1080#1082#1091' '#1074' '#1073#1091#1092#1077#1088#1077
      OnExecute = acSemCopyExecute
      OnUpdate = acSemCopyUpdate
    end
    object acSemPaste: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1082' '#1086#1073#1098#1077#1082#1090#1091' '#13#10#1089#1077#1084#1072#1085#1090#1080#1082#1091' '#1080#1079' '#1073#1091#1092#1077#1088#1072
      OnExecute = acSemPasteExecute
      OnHint = acSemPasteHint
      OnUpdate = acSemPasteUpdate
    end
  end
end
