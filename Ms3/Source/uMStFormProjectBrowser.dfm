object MStProjectBrowserForm: TMStProjectBrowserForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1086#1077#1082#1090#1086#1074
  ClientHeight = 508
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      783
      29)
    object btnClose: TSpeedButton
      Left = 668
      Top = 3
      Width = 110
      Height = 23
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = btnCloseClick
      ExplicitLeft = 932
    end
    object btnLoadToLayer: TSpeedButton
      Left = 158
      Top = 3
      Width = 110
      Height = 23
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1088#1086#1077#1082#1090' '#1085#1072' '#1082#1072#1088#1090#1091
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1072' '#1082#1072#1088#1090#1091
      ParentShowHint = False
      ShowHint = True
      OnClick = btnLoadToLayerClick
    end
    object btnLoadAll: TSpeedButton
      Left = 274
      Top = 3
      Width = 110
      Height = 23
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1072' '#1082#1072#1088#1090#1091' '#1074#1089#1077' '#1087#1088#1086#1077#1082#1090#1099' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1089' '#1091#1095#1105#1090#1086#1084' '#1092#1080#1083#1100#1090#1088#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1089#1077
      ParentShowHint = False
      ShowHint = True
      OnClick = btnLoadAllClick
    end
    object SpeedButton1: TSpeedButton
      Left = 390
      Top = 3
      Width = 110
      Height = 23
      Hint = #1059#1073#1088#1072#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1088#1086#1077#1082#1090' '#1089' '#1082#1072#1088#1090#1099
      Caption = #1059#1073#1088#1072#1090#1100' '#1089' '#1082#1072#1088#1090#1099
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 506
      Top = 3
      Width = 110
      Height = 23
      Hint = #1059#1073#1088#1072#1090#1100' '#1074#1089#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099' '#1089' '#1082#1072#1088#1090#1099
      Caption = #1059#1073#1088#1072#1090#1100' '#1074#1089#1077
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object DBNavigator1: TDBNavigator
      Left = 4
      Top = 1
      Width = 148
      Height = 25
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 472
    Width = 783
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      783
      36)
    object btnCoords: TSpeedButton
      Left = 656
      Top = 6
      Width = 122
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      OnClick = btnCoordsClick
      ExplicitLeft = 920
    end
    object btnZone: TSpeedButton
      Left = 424
      Top = 6
      Width = 110
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1079#1086#1085#1091
      OnClick = btnZoneClick
      ExplicitLeft = 688
    end
    object SpeedButton3: TSpeedButton
      Left = 540
      Top = 6
      Width = 110
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1086#1085#1091
      OnClick = SpeedButton3Click
      ExplicitLeft = 804
    end
    object btnDisplay: TSpeedButton
      Left = 308
      Top = 6
      Width = 110
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072' '#1082#1072#1088#1090#1077
      OnClick = btnDisplayClick
      ExplicitLeft = 572
    end
    object chbTransparency: TCheckBox
      Left = 8
      Top = 6
      Width = 97
      Height = 17
      Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
      TabOrder = 0
      OnClick = chbTransparencyClick
    end
    object trackAlpha: TTrackBar
      Left = 104
      Top = 2
      Width = 150
      Height = 45
      Max = 255
      Position = 255
      TabOrder = 1
      Visible = False
      OnChange = trackAlphaChange
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 29
    Width = 783
    Height = 443
    ActivePage = tabData
    Align = alClient
    TabOrder = 2
    object tabData: TTabSheet
      Caption = #1055#1088#1086#1077#1082#1090#1099
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 775
        Height = 33
        Align = alTop
        TabOrder = 0
        object btnFilterStart: TSpeedButton
          Left = 4
          Top = 1
          Width = 77
          Height = 26
          Caption = #1060#1080#1083#1100#1090#1088
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000CE0E0000C40E00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888800000888880000080F000888880F00080F000888880F
            0008000000080000000800F000000F00000800F000800F00000800F000800F00
            00088000000000000088880F00080F0008888800000800000888888000888000
            88888880F08880F0888888800088800088888888888888888888}
          OnClick = btnFilterStartClick
        end
        object btnFilterClear: TSpeedButton
          Left = 87
          Top = 1
          Width = 77
          Height = 26
          Caption = #1057#1073#1088#1086#1089#1080#1090#1100
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000CE0E0000C40E00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888888888888888888800000888880009080F090888880F00080F999888880F
            9008009990080009000800F999000F99000800F099900990000800F009999900
            00088000009990000088880F0999990008888800999809000888889999888099
            88888999908880F9988889900088800099888888888888888888}
          OnClick = btnFilterClearClick
        end
      end
      object kaDBGrid1: TkaDBGrid
        Left = 0
        Top = 33
        Width = 775
        Height = 382
        Align = alClient
        DataSource = DataSource1
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellColors = kaDBGrid1CellColors
        OnGetLogicalValue = kaDBGrid1GetLogicalValue
        OnLogicalColumn = kaDBGrid1LogicalColumn
        Columns = <
          item
            Expanded = False
            FieldName = 'PROJECT_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ADDRESS'
            Title.Caption = #1040#1076#1088#1077#1089
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1087#1088#1086#1077#1082#1090#1072
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LINE_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'INFO'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'DIAMETER'
            Title.Caption = #1044#1080#1072#1084#1077#1090#1088
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VOLTAGE'
            Title.Caption = #1053#1072#1087#1088#1103#1078'.'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAYER_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'LAYER_NAME'
            Title.Caption = #1057#1083#1086#1081
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CUSTOMER'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CONFIRMED'
            Title.Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            Width = 55
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CONFIRM_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1088#1082#1080
            Width = 80
            Visible = True
          end>
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = IBQuery1
    Left = 504
    Top = 144
  end
  object IBQuery1: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = IBTransaction1
    AfterClose = IBQuery1AfterClose
    AfterScroll = IBQuery1AfterScroll
    SQL.Strings = (
      'SELECT '
      
        '       PRJS.ID AS PROJECT_ID, PRJS.ADDRESS, PRJS.DOC_NUMBER, PRJ' +
        'S.DOC_DATE, PRJS.CONFIRMED, PRJS.CONFIRM_DATE,'
      
        '       LINES.ID AS LINE_ID, LINES.INFO, LINES.DIAMETER, LINES.VO' +
        'LTAGE,'
      '       LAYERS.ID AS LAYER_ID, LAYERS.NAME AS LAYER_NAME,'
      '       ORGS2.NAME AS CUSTOMER, ORGS1.NAME AS EXECUTOR'
      'FROM'
      '    PROJECT_LINES LINES'
      '    LEFT JOIN'
      
        '    PROJECT_LAYERS LAYERS ON (LINES.PROJECT_LAYERS_ID = LAYERS.I' +
        'D)'
      '    LEFT JOIN'
      '    PROJECTS PRJS ON (LINES.PROJECTS_ID = PROJECTS.ID)'
      '    LEFT JOIN'
      '    LICENSED_ORGS ORGS1 ON (PRJS.EXECUTOR_ORGS_ID = ORGS1.ID)'
      '    LEFT JOIN'
      '    LICENSED_ORGS ORGS2 ON (PRJS.CUSTOMER_ORGS_ID = ORGS2.ID)')
    Left = 584
    Top = 144
  end
  object IBTransaction1: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = MStIBXMapMngr.dbKis
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    AutoStopAction = saCommit
    Left = 544
    Top = 144
  end
  object ActionList1: TActionList
    Left = 144
    Top = 208
  end
end
