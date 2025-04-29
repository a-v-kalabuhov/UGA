object mstEditProjectMPDialog: TmstEditProjectMPDialog
  Left = 0
  Top = 0
  Caption = 'mstEditProjectMPDialog'
  ClientHeight = 662
  ClientWidth = 1182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    1182
    662)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 1182
    Height = 11
    Align = alTop
    Shape = bsTopLine
    ExplicitWidth = 1078
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 11
    Width = 1182
    Height = 651
    ActivePage = tsMap
    Align = alClient
    TabOrder = 0
    object tsSemantics: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1072
      object Label1: TLabel
        Left = 103
        Top = 78
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = #1040#1076#1088#1077#1089':'
        FocusControl = edAddress
      end
      object Label2: TLabel
        Left = 58
        Top = 104
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1086#1084#1077#1088' '#1087#1088#1086#1077#1082#1090#1072':'
        FocusControl = edDocNum
      end
      object Label3: TLabel
        Left = 63
        Top = 131
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072' '#1087#1088#1086#1077#1082#1090#1072':'
        FocusControl = edDocDate
      end
      object Label6: TLabel
        Left = 87
        Top = 185
        Width = 51
        Height = 13
        Alignment = taRightJustify
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082':'
        FocusControl = edCustomer
      end
      object Label7: TLabel
        Left = 12
        Top = 212
        Width = 126
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1086#1077#1082#1090#1085#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
        FocusControl = edExecutor
      end
      object Label4: TLabel
        Left = 16
        Top = 50
        Width = 122
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072':'
        FocusControl = edName
      end
      object Label8: TLabel
        Left = 72
        Top = 11
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1090#1072#1090#1091#1089' '#1089#1077#1090#1080':'
        FocusControl = cbStatusList
      end
      object Label9: TLabel
        Left = 23
        Top = 266
        Width = 115
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1077#1084' '#1085#1072#1085#1077#1089#1077#1085' '#1085#1072' '#1082#1072#1088#1090#1091':'
        FocusControl = edDrawer
      end
      object Label10: TLabel
        Left = 52
        Top = 293
        Width = 86
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072' '#1085#1072#1085#1077#1089#1077#1085#1080#1103':'
        FocusControl = edDrawDate
      end
      object Label11: TLabel
        Left = 65
        Top = 158
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080':'
        FocusControl = edRequestNumber
      end
      object Label12: TLabel
        Left = 36
        Top = 239
        Width = 102
        Height = 13
        Alignment = taRightJustify
        Caption = #1041#1072#1083#1072#1085#1089#1086#1076#1077#1088#1078#1072#1090#1077#1083#1100':'
        FocusControl = edOwner
      end
      object edAddress: TEdit
        Left = 144
        Top = 74
        Width = 921
        Height = 21
        MaxLength = 1000
        TabOrder = 3
        Text = 'edAddress'
      end
      object edDocNum: TEdit
        Left = 144
        Top = 101
        Width = 177
        Height = 21
        MaxLength = 12
        TabOrder = 4
        Text = 'edDocNum'
      end
      object edDocDate: TEdit
        Left = 144
        Top = 128
        Width = 116
        Height = 21
        MaxLength = 10
        TabOrder = 5
        Text = 'edDocDate'
      end
      object edCustomer: TEdit
        Left = 144
        Top = 182
        Width = 840
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 7
        Text = 'edCustomer'
        OnKeyPress = edCustomerKeyPress
      end
      object btnCustomer: TButton
        Left = 990
        Top = 180
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 8
        OnClick = btnCustomerClick
      end
      object edExecutor: TEdit
        Left = 144
        Top = 209
        Width = 840
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 9
        Text = 'edExecutor'
        OnKeyPress = edExecutorKeyPress
      end
      object btnExecutor: TButton
        Left = 990
        Top = 207
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 10
        OnClick = btnExecutorClick
      end
      object chbCK36: TCheckBox
        Left = 396
        Top = 10
        Width = 57
        Height = 17
        Alignment = taLeftJustify
        Caption = #1052#1057#1050'36'
        TabOrder = 1
      end
      object edName: TEdit
        Left = 144
        Top = 47
        Width = 921
        Height = 21
        MaxLength = 1000
        TabOrder = 2
        Text = 'edName'
      end
      object cbStatusList: TComboBox
        Left = 144
        Top = 8
        Width = 145
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
      end
      object edDrawer: TEdit
        Left = 144
        Top = 263
        Width = 840
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 13
        Text = 'edDrawer'
        OnKeyPress = edDrawerKeyPress
      end
      object btnDrawer: TButton
        Left = 990
        Top = 261
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 14
        OnClick = btnDrawerClick
      end
      object edDrawDate: TEdit
        Left = 144
        Top = 290
        Width = 116
        Height = 21
        MaxLength = 10
        TabOrder = 15
        Text = 'edDrawDate'
      end
      object edRequestNumber: TEdit
        Left = 144
        Top = 155
        Width = 177
        Height = 21
        MaxLength = 12
        TabOrder = 6
        Text = 'edRequestNumber'
      end
      object edOwner: TEdit
        Left = 144
        Top = 236
        Width = 840
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 11
        Text = 'edOwner'
        OnKeyPress = edOwnerKeyPress
      end
      object btnOwner: TButton
        Left = 990
        Top = 234
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 12
        OnClick = btnOwnerClick
      end
    end
    object tsMap: TTabSheet
      Caption = #1050#1072#1088#1090#1072
      ImageIndex = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 423
        Width = 1174
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 33
        ExplicitWidth = 391
      end
      object MapDrawBox: TEzDrawBox
        Left = 0
        Top = 23
        Width = 1174
        Height = 400
        BorderStyle = bsNone
        UseThread = False
        Align = alClient
        TabOrder = 0
        OnMouseWheel = MapDrawBoxMouseWheel
        GIS = EzGIS1
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
        OnMouseMove2D = MapDrawBoxMouseMove2D
        OnMouseDown2D = MapDrawBoxMouseDown2D
        OnAfterSelect = MapDrawBoxAfterSelect
      end
      object EzCmdLine1: TEzCmdLine
        Left = 0
        Top = 599
        Width = 1174
        Height = 24
        DrawBoxList = <
          item
            DrawBox = MapDrawBox
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
        TabOrder = 1
        TabStop = False
        Visible = False
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 1174
        Height = 23
        Align = alTop
        Caption = ' '
        TabOrder = 2
        object lXY: TLabel
          Left = 1159
          Top = 1
          Width = 14
          Height = 21
          Align = alRight
          Alignment = taRightJustify
          Caption = 'lXY'
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object ToolBar1: TToolBar
          Left = 1
          Top = 1
          Width = 1158
          Height = 21
          Align = alClient
          Caption = 'ToolBar1'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          object ToolButton1: TToolButton
            Left = 0
            Top = 0
            Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100
            Caption = #1059#1074#1077#1083#1080#1095#1080#1090#1100
            ImageIndex = 1
          end
          object ToolButton2: TToolButton
            Left = 23
            Top = 0
            Caption = 'ToolButton2'
            ImageIndex = 1
          end
          object ToolButton3: TToolButton
            Left = 46
            Top = 0
            Caption = 'ToolButton3'
            ImageIndex = 2
          end
          object ToolButton4: TToolButton
            Left = 69
            Top = 0
            Caption = 'ToolButton4'
            ImageIndex = 3
          end
          object ToolButton5: TToolButton
            Left = 92
            Top = 0
            Caption = 'ToolButton5'
            ImageIndex = 4
          end
          object ToolButton6: TToolButton
            Left = 115
            Top = 0
            Width = 8
            Caption = 'ToolButton6'
            ImageIndex = 5
            Style = tbsSeparator
          end
          object ToolButton7: TToolButton
            Left = 123
            Top = 0
            Caption = 'ToolButton7'
            ImageIndex = 5
          end
          object ToolButton8: TToolButton
            Left = 146
            Top = 0
            Caption = 'ToolButton8'
            ImageIndex = 6
          end
          object ToolButton9: TToolButton
            Left = 169
            Top = 0
            Width = 8
            Caption = 'ToolButton9'
            ImageIndex = 7
            Style = tbsSeparator
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 428
        Width = 1174
        Height = 171
        Align = alBottom
        Caption = 'Panel3'
        TabOrder = 3
        object dbgNav: TkaDBGrid
          Left = 1
          Top = 28
          Width = 1172
          Height = 142
          Align = alClient
          BorderStyle = bsNone
          DataSource = dsNav
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDblClick = dbgNavDblClick
          OnCellColors = dbgNavCellColors
          OnGetLogicalValue = dbgNavGetLogicalValue
          OnLogicalColumn = dbgNavLogicalColumn
        end
        object Panel4: TPanel
          Left = 1
          Top = 1
          Width = 1172
          Height = 27
          Align = alTop
          Caption = ' '
          TabOrder = 1
          object Label5: TLabel
            Left = 6
            Top = 5
            Width = 29
            Height = 13
            Caption = #1057#1083#1086#1081':'
          end
          object cbLayers: TComboBox
            Left = 41
            Top = 2
            Width = 285
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = cbLayersChange
          end
          object DBNavigator1: TDBNavigator
            Left = 339
            Top = 2
            Width = 224
            Height = 21
            DataSource = dsNav
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
            TabOrder = 1
            TabStop = True
          end
          object btnLocate: TButton
            Left = 685
            Top = 2
            Width = 110
            Height = 21
            Caption = #1055#1086#1082#1072#1079#1072#1090#1100
            TabOrder = 3
            OnClick = btnLocateClick
          end
          object btnProperties: TButton
            Left = 569
            Top = 2
            Width = 110
            Height = 21
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
            TabOrder = 2
            OnClick = btnPropertiesClick
          end
        end
      end
    end
  end
  object btnCancel: TButton
    Left = 1099
    Top = 4
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 1018
    Top = 4
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = btnOKClick
  end
  object mdNav: TRxMemoryData
    FieldDefs = <
      item
        Name = 'ENT_ID'
        DataType = ftInteger
      end
      item
        Name = 'NET_STATE_ID'
        DataType = ftInteger
      end
      item
        Name = 'DISMANTLED'
        DataType = ftBoolean
      end
      item
        Name = 'ARCHIVED'
        DataType = ftBoolean
      end
      item
        Name = 'AGREED'
        DataType = ftBoolean
      end
      item
        Name = 'UNDERGROUND'
        DataType = ftBoolean
      end
      item
        Name = 'ROTANGLE'
        DataType = ftInteger
      end
      item
        Name = 'DIAM'
        DataType = ftInteger
      end
      item
        Name = 'PIPE_COUNT'
        DataType = ftInteger
      end
      item
        Name = 'MATERIAL'
        DataType = ftString
        Size = 254
      end
      item
        Name = 'TOP'
        DataType = ftString
        Size = 254
      end
      item
        Name = 'BOTTOM'
        DataType = ftString
        Size = 254
      end
      item
        Name = 'FLOOR'
        DataType = ftString
        Size = 254
      end
      item
        Name = 'OBJ_ID'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'LAYER_NAME'
        DataType = ftString
        Size = 100
      end>
    AfterEdit = mdNavAfterEdit
    AfterPost = mdNavAfterPost
    AfterScroll = mdNavAfterScroll
    OnCalcFields = mdNavCalcFields
    Left = 144
    Top = 104
    object mdNavENT_ID: TIntegerField
      DisplayLabel = #8470' '#1087'/'#1087
      DisplayWidth = 5
      FieldName = 'ENT_ID'
    end
    object mdNavNET_STATE_ID: TIntegerField
      DisplayLabel = #1057#1086#1089#1090'.'#1089#1077#1090#1080
      DisplayWidth = 5
      FieldName = 'NET_STATE_ID'
      Visible = False
    end
    object mdNavNET_STATE_NAME: TStringField
      DisplayLabel = #1057#1086#1089#1090'.'#1089#1077#1090#1080
      DisplayWidth = 15
      FieldKind = fkCalculated
      FieldName = 'NET_STATE_NAME'
      Calculated = True
    end
    object mdNavDISMANTLED: TBooleanField
      DisplayLabel = #1044#1077#1084#1086#1085#1090#1080#1088'.'
      FieldName = 'DISMANTLED'
    end
    object mdNavARCHIVED: TBooleanField
      DisplayLabel = #1040#1088#1093#1080#1074#1085#1072#1103
      FieldName = 'ARCHIVED'
    end
    object mdNavAGREED: TBooleanField
      DisplayLabel = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
      FieldName = 'AGREED'
    end
    object mdNavUNDERGROUND: TBooleanField
      DisplayLabel = #1055#1086#1076#1079#1077#1084'.'
      FieldName = 'UNDERGROUND'
    end
    object mdNavROTANGLE: TIntegerField
      DisplayLabel = #1059#1075#1086#1083' '#1087#1086#1074'.'
      DisplayWidth = 5
      FieldName = 'ROTANGLE'
    end
    object mdNavDIAM: TIntegerField
      DisplayLabel = #1044#1080#1072#1084#1077#1090#1088
      DisplayWidth = 5
      FieldName = 'DIAM'
    end
    object mdNavPIPE_COUNT: TIntegerField
      DisplayLabel = #1050#1086#1083'. '#1090#1088#1091#1073'/'#1087#1088#1086#1074#1086#1076#1086#1074
      FieldName = 'PIPE_COUNT'
    end
    object mdNavMATERIAL: TStringField
      DisplayLabel = #1052#1072#1090#1077#1088#1080#1072#1083
      DisplayWidth = 20
      FieldName = 'MATERIAL'
      Size = 254
    end
    object mdNavTOP: TStringField
      DisplayLabel = #1042#1077#1088#1093
      DisplayWidth = 20
      FieldName = 'TOP'
      Size = 254
    end
    object mdNavBOTTOM: TStringField
      DisplayLabel = #1053#1080#1079
      DisplayWidth = 20
      FieldName = 'BOTTOM'
      Size = 254
    end
    object mdNavFLOOR: TStringField
      DisplayLabel = #1044#1085#1086
      DisplayWidth = 20
      FieldName = 'FLOOR'
      Size = 254
    end
    object mdNavOBJ_ID: TStringField
      DisplayWidth = 36
      FieldName = 'OBJ_ID'
      Visible = False
      Size = 36
    end
    object mdNavLAYER_NAME: TStringField
      DisplayLabel = #1057#1083#1086#1081
      FieldName = 'LAYER_NAME'
      Size = 100
    end
  end
  object dsNav: TDataSource
    DataSet = mdNav
    Left = 184
    Top = 104
  end
  object EzGIS1: TEzGIS
    Active = False
    LayersSubdir = 'C:\Program Files\CodeGear\RAD Studio\5.0\bin\'
    OnAfterPaintEntity = EzGIS1AfterPaintEntity
    Left = 64
    Top = 104
  end
  object ActionList1: TActionList
    Left = 104
    Top = 104
    object acSemCopy: TAction
      Caption = #1047#1072#1087#1086#1084#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1077#1084#1085#1072#1090#1080#1082#1091' '#1074' '#1073#1091#1092#1077#1088#1077
    end
    object acSemPaste: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1082' '#1086#1073#1098#1077#1082#1090#1091' '#13#10#1089#1077#1084#1072#1085#1090#1080#1082#1091' '#1080#1079' '#1073#1091#1092#1077#1088#1072
    end
  end
end
