object mstMPBrowserForm: TmstMPBrowserForm
  Left = 0
  Top = 0
  Caption = #1057#1074#1086#1076#1085#1099#1081' '#1087#1083#1072#1085
  ClientHeight = 370
  ClientWidth = 1161
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
    Width = 1161
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      1161
      29)
    object btnClose: TSpeedButton
      Left = 1046
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
      Action = acLoadToGis
      ParentShowHint = False
      ShowHint = True
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
    object btnRemoveFromMap: TSpeedButton
      Left = 390
      Top = 3
      Width = 110
      Height = 23
      Hint = #1059#1073#1088#1072#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1088#1086#1077#1082#1090' '#1089' '#1082#1072#1088#1090#1099
      Caption = #1059#1073#1088#1072#1090#1100' '#1089' '#1082#1072#1088#1090#1099
      ParentShowHint = False
      ShowHint = True
      OnClick = btnRemoveFromMapClick
    end
    object btnRemoveAllFromMap: TSpeedButton
      Left = 506
      Top = 3
      Width = 110
      Height = 23
      Hint = #1059#1073#1088#1072#1090#1100' '#1074#1089#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1086#1073#1098#1077#1082#1090#1099' '#1089' '#1082#1072#1088#1090#1099
      Caption = #1059#1073#1088#1072#1090#1100' '#1074#1089#1077
      ParentShowHint = False
      ShowHint = True
      OnClick = btnRemoveAllFromMapClick
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
    Top = 334
    Width = 1161
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      1161
      36)
    object btnCoords: TSpeedButton
      Left = 1034
      Top = 6
      Width = 122
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
      OnClick = btnCoordsClick
      ExplicitLeft = 920
    end
    object btnZone: TSpeedButton
      Left = 458
      Top = 6
      Width = 110
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1079#1086#1085#1091
      Enabled = False
      Visible = False
    end
    object btnRemoveZone: TSpeedButton
      Left = 570
      Top = 6
      Width = 110
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1086#1085#1091
      Enabled = False
      Visible = False
    end
    object btnDisplay: TSpeedButton
      Left = 918
      Top = 6
      Width = 110
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072' '#1082#1072#1088#1090#1077
      OnClick = btnDisplayClick
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
    Width = 1161
    Height = 305
    ActivePage = tabData
    Align = alClient
    Constraints.MinWidth = 745
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
        Width = 1153
        Height = 33
        Align = alTop
        TabOrder = 0
        DesignSize = (
          1153
          33)
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
        object btnProperties: TSpeedButton
          Left = 170
          Top = 1
          Width = 77
          Height = 26
          Caption = #1057#1074#1086#1081#1089#1090#1074#1072
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
            0000FFFFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF000000FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFF
            FFFFFFFFC0C0C0000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFF
            FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000
            000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000
            00FFFFFFFFFFFF00000000000000000000000000000000000000000000000000
            0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FF0000
            FF0000FF0000FF0000FF0000000000000000000000000000000000000000FFFF
            FFFFFFFF000000FF00FF000000000000FF0000FF0000FF000000000000000000
            0000000000000000FF00FFFF00FF000000000000FF00FF000000000000000000
            000000FF0000000000000000000000000000000000000000FF00FFFF00FFFF00
            FFFF00FFFF00FF00000000000000000000000000000000000000000080808000
            FFFF808080000000FF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000FF
            0000FF0000FF00000000000000FFFF00FFFF00FFFF000000FF00FFFF00FFFF00
            FFFF00FFFF00FF0000000000000000FF0000FF0000FF00000000000080808000
            FFFF808080000000000000FF00FFFF00FFFF00FF000000FF00FF0000000000FF
            0000FF0000FF000000000000000000000000000000000000FF00FF0000000000
            00000000FF00FFFF00FF00000000000000000000000000000000000000000000
            0000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          OnClick = btnPropertiesClick
        end
        object sbtnDeleteProject: TSpeedButton
          Left = 1051
          Top = 1
          Width = 94
          Height = 26
          Anchors = [akTop, akRight]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            08000000000000010000CE0E0000D80E00000001000000000000000000008080
            8000000080000080800000800000808000008000000080008000408080004040
            0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
            FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
            80008000FF004080FF007F7F7F00BFBFBF0000000000000000002DB30E00C300
            0B000000AC0002002C0000001100000003000000000000000000000000000000
            00000000A000B57F00000000B0005B006C005B00B800B37FFF00FFFF50005B00
            2600B27F60005D002C0000000A000000010000000000000038005B00A6000000
            6300F7BF2C0000000A0000000100000000000000070080845700000064005B00
            2300F7BF00000000070002009900F9BF7900F7BFA000000088005B002E00F7BF
            0700808400000000800007400000000046000000DE0002002E0000001F000000
            3F003F01000007403F003F01E400FA3B3F000400000000000000F91AB2000000
            0000010000000A000000FA3B1000000000000000D000347AFF000740E400413C
            3F00FFFF07000000000007405700AC83200000000300F91AB200098307000000
            0000000001000A002C0057010000080000001F175900B27FA8005B0028005B00
            0700B37FFF00FFFF34005B00E200B27FA8005B0040005B00C200B37FFF00FFFF
            4C005B00B000B27FA8005B0058005B003500B37FFF00FFFF64005B0061004100
            A8005B0070005B006E004100FF00FFFF7C005B00C1004100A8005B0088005B00
            DC004100FF00FFFF94005B0018004100A8005B0088005B0025004100FF00FFFF
            94005B009C0041001100000001000000000000009800B57F0100000000000000
            0000000000000000010000020100000000000000000000003A00198000000000
            0000000005000000000000000000000000000000000000004C0000002C000000
            00000000800060000000000005000000030000001C0060000400000048005B00
            40000000000000004C0060002600080016001C009000600000000000F200B37F
            0000000000000000C800B67F000000000000000043006F737300626D7000C75E
            2B00315B64002E16EF009D51AC0002007A003103070000001200000230002000
            AC0002003600A886D3003F17000012000000300500002C052C00200030000000
            12000002000000000200E4C2000048360000F8360000B886B200B83200004836
            0000C486B2002F012C001A050000000002009804000000003200000000004836
            000006870000EE86000000000000010000000000D8000000FA00B27F2F00B57F
            B800FF36470034876E002F016400470100000000D80000003400000024000000
            F8000000FF00000001000000B800000000004701B8006000F80000003E00B27F
            2F00B57FF80029797200328B320087058000AC1137007E13FA000E0E0E0E0E0E
            0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E020E0E
            0E0E0E0E0E0E0E0E0E0E0E0E1010020E0E0E0E0E0E0E100E0E0E0E0E0210020E
            0E0E0E0E0E020E0E0E0E0E0E0E0210100E0E0E0E10020E0E0E0E0E0E0E0E0210
            020E0E02100E0E0E0E0E0E0E0E0E0E02100210100E0E0E0E0E0E0E0E0E0E0E0E
            1002100E0E0E0E0E0E0E0E0E0E0E0E10021002020E0E0E0E0E0E0E0E0E0E0210
            020E0E100E0E0E0E0E0E0E0E100210020E0E0E0E02100E0E0E0E0E021002100E
            0E0E0E0E0E02100E0E0E0E10020E0E0E0E0E0E0E0E0E02100E0E0E0E0E0E0E0E
            0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E}
          OnClick = sbtnDeleteProjectClick
          ExplicitLeft = 834
        end
        object btnSpravka: TSpeedButton
          Left = 253
          Top = 1
          Width = 116
          Height = 26
          Action = acGiveOutCertif
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000000000000000000000000000000000004CB1224CB122
            4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
            224CB1224CB1224CB12200000000000000000000000000000000000000000000
            00000000000000004CB1224CB1224CB1224CB1224CB1224CB122000000FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000004CB1224CB1224CB1
            224CB1224CB1224CB122000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF0000004CB1224CB1224CB1224CB1224CB1224CB122000000FFFFFF
            000000000000FFFFFF000000000000000000FFFFFF0000004CB1224CB1224CB1
            224CB1224CB1224CB122000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF0000000000004CB1224CB1224CB1224CB1224CB122000000FFFFFF
            000000BDBDBD000000000000FFFFFF000000FFFFFF0000000000FF0000004CB1
            224CB1224CB1224CB122000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF0000000000FF0000FF0000004CB1224CB1224CB122000000FFFFFF
            000000000000FFFFFF0000000000000000000000FF0000FF0000FF0000FF0000
            FF0000004CB1224CB122000000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF00
            00000000FF0000FF0000FF0000FF0000FF0000FF0000004CB122000000FFFFFF
            000000BDBDBDFFFFFF000000FFFFFF0000000000FF0000FF0000FF0000FF0000
            FF0000FF0000FF000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000
            00000000FF0000FF0000FF0000FF0000FF0000FF0000004CB122000000000000
            0000000000000000000000004CB1220000000000FF0000FF0000FF0000FF0000
            FF0000004CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224C
            B1224CB1224CB1220000FF0000FF0000004CB1224CB1224CB1224CB1224CB122
            4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1220000FF0000004CB1
            224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224C
            B1224CB1224CB1220000004CB1224CB1224CB1224CB1224CB122}
        end
      end
      object kaDBGrid1: TkaDBGrid
        Left = 0
        Top = 33
        Width = 1153
        Height = 244
        Align = alClient
        DataSource = DataSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnMouseUp = kaDBGrid1MouseUp
        OnCellColors = kaDBGrid1CellColors
        OnGetLogicalValue = kaDBGrid1GetLogicalValue
        OnLogicalColumn = kaDBGrid1LogicalColumn
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MASTER_PLAN_CLASS_ID'
            Title.Caption = 'ID '#1082#1083#1072#1089#1089#1072
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAYER_NAME'
            Title.Caption = #1050#1083#1072#1089#1089
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STATUS'
            Title.Caption = 'ID c'#1090#1072#1090#1091#1089#1072
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STATUS_NAME'
            Title.Caption = #1057#1090#1072#1090#1091#1089
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ARCHIVED'
            Title.Caption = #1040#1088#1093#1080#1074#1085#1099#1081
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CONFIRMED'
            Title.Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DISMANTLED'
            Title.Caption = #1044#1077#1084#1086#1085#1090#1080#1088#1086#1074#1072#1085
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS'
            Title.Caption = #1040#1076#1088#1077#1089
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_NUMBER'
            Title.Caption = #8470' '#1087#1088#1086#1077#1082#1090#1072
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1087#1088#1086#1077#1082#1090#1072
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = #1055#1088#1086#1077#1082#1090
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'REQUEST_NUMBER'
            Title.Caption = #8470' '#1079#1072#1103#1074#1082#1080
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'REQUEST_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UNDERGROUND'
            Title.Caption = #1055#1086#1076#1079#1077#1084'.'
            Width = 60
            Visible = True
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
            FieldName = 'PIPE_COUNT'
            Title.Caption = #1050#1086#1083'-'#1074#1086' '#1090#1088#1091#1073'/'#1082#1072#1073#1077#1083#1077#1081
            Width = 115
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VOLTAGE'
            Title.Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MATERIAL'
            Title.Caption = #1052#1072#1090#1077#1088#1080#1072#1083
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TOP'
            Title.Caption = #1042#1077#1088#1093
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BOTTOM'
            Title.Caption = #1053#1080#1079
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FLOOR'
            Title.Caption = #1044#1085#1086
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OWNER'
            Title.Caption = #1041#1072#1083#1072#1085#1089#1086#1076#1077#1088#1078#1072#1090#1077#1083#1100
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IS_LINE'
            Title.Caption = #1051#1080#1085#1080#1103
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ROTATION'
            Title.Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DRAW_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1085#1072#1085#1077#1089#1077#1085#1080#1103
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CUSTOMER_ORGS_ID'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082' ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CUSTOMER_NAME'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR_ORGS_ID'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR_NAME'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DRAW_ORGS_ID'
            Title.Caption = #1050#1077#1084' '#1085#1072#1085#1077#1089#1077#1085#1086' ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DRAWER_NAME'
            Title.Caption = #1050#1077#1084' '#1085#1072#1085#1077#1089#1077#1085#1086
            Width = 150
            Visible = True
          end>
      end
    end
  end
  object DataSource1: TDataSource
    Left = 88
    Top = 136
  end
  object ActionList1: TActionList
    Left = 32
    Top = 136
    object acGiveOutCertif: TAction
      Caption = #1042#1099#1076#1072#1090#1100' '#1089#1087#1088#1072#1074#1082#1091
      OnExecute = acGiveOutCertifExecute
      OnUpdate = acGiveOutCertifUpdate
    end
    object acLoadToGis: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1072' '#1082#1072#1088#1090#1091
      OnExecute = acLoadToGisExecute
      OnUpdate = acLoadToGisUpdate
    end
    object acCopyObjId: TAction
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' ID '#1086#1073#1098#1077#1082#1090#1072
      OnExecute = acCopyObjIdExecute
    end
    object acProjectedToDrawn: TAction
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1085#1072#1085#1077#1089#1105#1085#1085#1099#1077
      OnExecute = acProjectedToDrawnExecute
      OnUpdate = acProjectedToDrawnUpdate
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 448
    Top = 144
    object ID1: TMenuItem
      Action = acCopyObjId
    end
    object N1: TMenuItem
      Action = acProjectedToDrawn
    end
  end
end
