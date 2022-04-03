inherited KisGivenScanEditor2: TKisGivenScanEditor2
  Left = 350
  Top = 174
  BorderStyle = bsSizeable
  Caption = 'KisGivenScanEditor2'
  ClientHeight = 638
  ClientWidth = 1145
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 1161
  ExplicitHeight = 676
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 16
    Top = 610
    Anchors = [akLeft, akBottom]
    Visible = False
    ExplicitLeft = 16
    ExplicitTop = 345
  end
  inherited btnOk: TButton
    Left = 981
    Top = 605
    Anchors = [akRight, akBottom]
    Default = True
    TabOrder = 2
    ExplicitLeft = 981
    ExplicitTop = 605
  end
  inherited btnCancel: TButton
    Left = 1062
    Top = 605
    Anchors = [akRight, akBottom]
    Cancel = True
    TabOrder = 3
    ExplicitLeft = 1062
    ExplicitTop = 605
  end
  object Panel1: TPanel [3]
    Left = 0
    Top = 0
    Width = 243
    Height = 599
    Anchors = [akLeft, akTop, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      243
      599)
    object vstMaps: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 243
      Height = 321
      Anchors = [akLeft, akTop, akBottom]
      CheckImageKind = ckXP
      Colors.UnfocusedSelectionColor = clGradientInactiveCaption
      Colors.UnfocusedSelectionBorderColor = clInactiveCaption
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoVisible]
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
      OnAddToSelection = vstMapsAddToSelection
      OnCreateEditor = vstMapsCreateEditor
      OnGetText = vstMapsGetText
      Columns = <
        item
          Color = clWindow
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
          Position = 0
          Width = 100
          WideText = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
        end
        item
          Position = 1
          Width = 100
          WideText = #1050#1072#1082' '#1074#1099#1076#1072#1090#1100
        end>
    end
    object pnlSquares: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 327
      Width = 243
      Height = 146
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
      object Map25: TCheckBox
        AlignWithMargins = True
        Left = 192
        Top = 108
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '25'
        TabOrder = 24
      end
      object Map24: TCheckBox
        AlignWithMargins = True
        Left = 149
        Top = 108
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '24'
        TabOrder = 23
      end
      object Map23: TCheckBox
        AlignWithMargins = True
        Left = 98
        Top = 108
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '23'
        TabOrder = 22
      end
      object Map22: TCheckBox
        AlignWithMargins = True
        Left = 47
        Top = 108
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '22'
        TabOrder = 21
      end
      object Map21: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 108
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '21'
        TabOrder = 20
      end
      object Map20: TCheckBox
        AlignWithMargins = True
        Left = 192
        Top = 82
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '20'
        TabOrder = 19
      end
      object Map19: TCheckBox
        AlignWithMargins = True
        Left = 149
        Top = 82
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '19'
        TabOrder = 18
      end
      object Map18: TCheckBox
        AlignWithMargins = True
        Left = 98
        Top = 82
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '18'
        TabOrder = 17
      end
      object Map17: TCheckBox
        AlignWithMargins = True
        Left = 47
        Top = 82
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '17'
        TabOrder = 16
      end
      object Map16: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 82
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '16'
        TabOrder = 15
      end
      object Map15: TCheckBox
        AlignWithMargins = True
        Left = 192
        Top = 56
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '15'
        TabOrder = 14
      end
      object Map14: TCheckBox
        AlignWithMargins = True
        Left = 149
        Top = 56
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '14'
        TabOrder = 13
      end
      object Map13: TCheckBox
        AlignWithMargins = True
        Left = 98
        Top = 56
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '13'
        TabOrder = 12
      end
      object Map12: TCheckBox
        AlignWithMargins = True
        Left = 47
        Top = 56
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '12'
        TabOrder = 11
      end
      object Map11: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 56
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '11'
        TabOrder = 10
      end
      object Map10: TCheckBox
        AlignWithMargins = True
        Left = 192
        Top = 30
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '10'
        TabOrder = 9
      end
      object Map9: TCheckBox
        AlignWithMargins = True
        Left = 149
        Top = 30
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '9'
        TabOrder = 8
      end
      object Map8: TCheckBox
        AlignWithMargins = True
        Left = 98
        Top = 30
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '8'
        TabOrder = 7
      end
      object Map7: TCheckBox
        AlignWithMargins = True
        Left = 47
        Top = 30
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '7'
        TabOrder = 6
      end
      object Map6: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 30
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '6'
        TabOrder = 5
      end
      object Map5: TCheckBox
        AlignWithMargins = True
        Left = 192
        Top = 4
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '5'
        TabOrder = 4
      end
      object Map4: TCheckBox
        AlignWithMargins = True
        Left = 149
        Top = 4
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '4'
        TabOrder = 3
      end
      object Map3: TCheckBox
        AlignWithMargins = True
        Left = 98
        Top = 4
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '3'
        TabOrder = 2
      end
      object Map2: TCheckBox
        AlignWithMargins = True
        Left = 47
        Top = 4
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '2'
        TabOrder = 1
      end
      object Map1: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 32
        Height = 20
        Margins.Right = 0
        Caption = '1'
        TabOrder = 0
        OnClick = Map1Click
      end
    end
  end
  object EzDrawBox1: TEzDrawBox [4]
    Left = 249
    Top = 32
    Width = 888
    Height = 567
    UseThread = False
    Color = 8323199
    TabOrder = 1
    TabStop = False
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    FlatScrollBar = True
    OnMouseDown2D = EzDrawBox1MouseDown2D
    OnBeforeSelect = EzDrawBox1BeforeSelect
    object EzCmdLine1: TEzCmdLine
      Left = 0
      Top = 524
      Width = 869
      Height = 24
      DrawBoxList = <
        item
          DrawBox = EzDrawBox1
          Current = True
        end>
      DynamicUpdate = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Color = clWhite
      Align = alBottom
      TabOrder = 0
      TabStop = False
      Visible = False
      ExplicitTop = 490
    end
  end
  object Panel2: TPanel [5]
    AlignWithMargins = True
    Left = 249
    Top = 0
    Width = 888
    Height = 31
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    DesignSize = (
      888
      31)
    object SpeedButton1: TSpeedButton
      Left = 7
      Top = 2
      Width = 27
      Height = 26
      Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FF000000000000
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000
        00000000000000FF00FF008080000000000000FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF000000000000000000000000000000000000FF00FFFF00FF008080
        000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000
        00FF00FFFF00FFFF00FFFF00FFFF00FF008080000000000000FF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF008080000000000000FF00FF000000000000000000FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008080000000000000FF
        FF00FFFF00FFFF00000000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF008080FFFF00FFFF00FFFF00FFFF00FFFF00000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF000000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF000000
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008080FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF000000FFFF00FFFF00FFFF00FFFF00FFFF00000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008080000000FF
        FF00FFFF00FFFF00000000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF008080000000000000FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 36
      Top = 2
      Width = 27
      Height = 26
      Hint = #1059#1084#1077#1085#1100#1096#1080#1090#1100
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000
        00000000000000FF00FF008080000000000000FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF000000000000000000000000000000000000FF00FFFF00FF008080
        000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF008080000000000000FF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF008080000000000000FF00FF000000000000000000FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008080000000000000FF
        FF00FFFF00FFFF00000000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF008080FFFF00FFFF00FFFF00FFFF00FFFF00000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF000000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF000000
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008080FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF000000FFFF00FFFF00FFFF00FFFF00FFFF00000000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF008080000000FF
        FF00FFFF00FFFF00000000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF008080000000000000FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 65
      Top = 2
      Width = 27
      Height = 26
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1105
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF800000800000FF
        0000800000FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF800000FF0000800000800000800000FF0000800000800000800000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF800000FF000080000000808000808080
        0000800000800000800000800000800000FF00FFFF00FFFF00FFFF00FF800000
        FF0000800000FF0000008080008080800000FF0000800000FF00008000000080
        80008080FF00FFFF00FFFF00FF800000FF0000FF0000FF000000808000808000
        8080800000800000800000800000008080008080FF00FFFF00FFFF0000FF0000
        FF0000FF0000FF0000008080008080008080FF0000FF0000FF0000800000FF00
        00800000800000FF00FF800000FF0000FF000000808000808000808000808000
        8080FF0000FF0000FF0000800000800000800000FF0000FF00FFFF0000800000
        008080008080008080008080008080008080FF0000008080FF0000800000FF00
        00FF0000FF0000FF00FF800000FF0000FF000000808000808000808000808000
        8080008080008080008080FF0000800000FF0000800000FF00FFFF0000FF0000
        FF0000008080008080FF0000FF0000800000008080008080008080FF0000FF00
        00800000FF0000FF00FFFF00FFFF0000FF0000FF0000FF0000FF000000808000
        8080008080008080008080008080800000FF0000FF00FFFF00FFFF00FF800000
        FF0000008080008080008080008080008080008080008080008080008080FF00
        00FF0000FF00FFFF00FFFF00FFFF00FF008080008080008080008080FF0000FF
        0000008080FF0000008080008080FF0000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF008080008080FF0000FF0000800000FF0000800000FF0000FF0000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF0000800000FF
        0000FF0000FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 118
      Top = 2
      Width = 130
      Height = 26
      Caption = #1042#1099#1076#1072#1090#1100' '#1094#1077#1083#1080#1082#1086#1084
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 254
      Top = 2
      Width = 130
      Height = 26
      Caption = #1042#1099#1076#1072#1090#1100' '#1087#1086' '#1082#1074#1072#1076#1088#1072#1090#1072#1084
      OnClick = SpeedButton5Click
    end
    object btnAllUnchanged: TButton
      Left = 390
      Top = 3
      Width = 130
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1042#1089#1077' '#1087#1083#1072#1085#1096#1077#1090#1099' '#1094#1077#1083#1080#1082#1086#1084
      TabOrder = 0
      OnClick = btnAllUnchangedClick
    end
  end
  object ActionList1: TActionList
    Left = 88
    Top = 64
  end
end
