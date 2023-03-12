inherited KisMapScanEditor: TKisMapScanEditor
  Left = 209
  Top = 184
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'KisMapScanEditor'
  ClientHeight = 518
  ClientWidth = 1092
  Constraints.MinHeight = 550
  Constraints.MinWidth = 800
  Position = poDesktopCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 1108
  ExplicitHeight = 556
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 8
    Top = 497
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 464
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
  end
  object Label2: TLabel [2]
    Left = 246
    Top = 8
    Width = 101
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1072#1103' '#1089#1091#1084#1084#1072' MD5'
  end
  object Label3: TLabel [3]
    Left = 112
    Top = 8
    Width = 116
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1086' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103
  end
  inherited btnOk: TButton
    Left = 928
    Top = 486
    Anchors = [akRight, akBottom]
    ExplicitLeft = 897
    ExplicitTop = 486
  end
  inherited btnCancel: TButton
    Left = 1009
    Top = 486
    Anchors = [akRight, akBottom]
    Default = True
    ExplicitLeft = 978
    ExplicitTop = 486
  end
  object edNomenclature: TEdit [6]
    Left = 8
    Top = 27
    Width = 36
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    Enabled = False
    MaxLength = 6
    TabOrder = 2
    OnKeyDown = edNomenclatureKeyDown
    OnKeyPress = edNomenclatureKeyPress
  end
  object edNom2: TEdit [7]
    Left = 43
    Top = 27
    Width = 36
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    Enabled = False
    MaxLength = 6
    TabOrder = 3
    OnKeyDown = edNom2KeyDown
    OnKeyPress = edNom2KeyPress
  end
  object edNom3: TEdit [8]
    Left = 78
    Top = 27
    Width = 28
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    Enabled = False
    MaxLength = 2
    TabOrder = 4
    OnKeyPress = edNom3KeyPress
  end
  object edMD5: TEdit [9]
    Left = 244
    Top = 27
    Width = 285
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    MaxLength = 2
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 6
    OnEnter = edMD5Enter
  end
  object edStartDate: TEdit [10]
    Left = 112
    Top = 27
    Width = 126
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    Enabled = False
    MaxLength = 2
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 5
  end
  object PageControl1: TPageControl [11]
    Left = 8
    Top = 54
    Width = 1076
    Height = 426
    ActivePage = tabHistor
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 7
    ExplicitWidth = 1045
    object tabHistor: TTabSheet
      Caption = #1048#1089#1090#1086#1088#1080#1103
      ExplicitWidth = 1037
      DesignSize = (
        1068
        398)
      object dbgGivenMapList: TkaDBGrid
        Left = 0
        Top = 0
        Width = 1068
        Height = 364
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        DataSource = dsGiveOuts
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = dbgGivenMapListDblClick
        OnExit = dbgGivenMapListExit
        OnCellColors = dbgGivenMapListCellColors
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'MAP_SCANS_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'DATE_OF_BACK'
            Title.Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088'.'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_OF_GIVE'
            Title.Caption = #1044#1072#1090#1072' '#1074#1099#1076'.'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DEFINITION_NUMBER'
            Title.Caption = #8470' '#1088#1072#1079#1088#1077#1096'-'#1103
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GIVEN_OBJECT'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'HOLDER'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'HOLDER_NAME'
            Title.Caption = #1050#1086#1084#1091' '#1074#1099#1076#1072#1085
            Width = 96
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PEOPLE_NAME'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ORDERS_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'LICENSED_ORGS_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'PEOPLE_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'PERSON_WHO_GIVE'
            Title.Caption = #1042#1099#1076#1072#1083
            Width = 108
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PERSON_WHO_GIVE_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'TERM_OF_GIVE'
            Title.Caption = #1057#1088#1086#1082
            Width = 34
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS'
            Title.Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1088#1072#1073#1086#1090
            Width = 134
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OFFICES_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ORDER_NUMBER'
            Title.Caption = #8470' '#1079#1072#1082#1072#1079#1072
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MD5_OLD'
            Title.Caption = 'MD5 '#1076#1086
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MD5_NEW'
            Title.Caption = 'MD5 '#1089#1090#1072#1083#1086
            Visible = True
          end>
      end
      object btnShowChanges: TButton
        Left = 3
        Top = 370
        Width = 158
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        TabOrder = 1
        OnClick = btnShowChangesClick
      end
      object btnAddGiveOutToHistory: TButton
        Left = 167
        Top = 370
        Width = 158
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1092#1086#1088#1084#1091#1083#1103#1088
        TabOrder = 2
        OnClick = btnAddGiveOutToHistoryClick
      end
    end
    object tabHistory: TTabSheet
      Caption = #1060#1086#1088#1084#1091#1083#1103#1088
      ImageIndex = -1
      OnShow = tabHistoryShow
      ExplicitWidth = 1037
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1068
        Height = 398
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 1037
        DesignSize = (
          1068
          398)
        object btnViewHistoryImage: TBitBtn
          Left = 916
          Top = 368
          Width = 149
          Height = 25
          Hint = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1080#1079' '#1092#1086#1088#1084#1091#1083#1103#1088#1072' '#1074' '#1074#1099#1089#1086#1082#1086#1084' '#1082#1072#1095#1077#1089#1090#1074#1077'...'
          Anchors = [akRight, akBottom]
          Caption = #1057#1084#1086#1090#1088#1077#1090#1100'...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = btnViewHistoryImageClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000C40E0000C40E00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
            DDDD000000000000DD000FFFFFFFFFF0D0000FFFFFFF0000000D0FFFFFF07887
            00DD0FFFFF0788E7F0DD0FFFFF08888780DD0FFFFF08E88780DD0FFFFF07EE87
            F0DD0FFFFFF078870DDD0FFFFFFF0000DDDD0FFFFFFFFFF0DDDD0FFFFFFF0000
            DDDD0FFFFFFF080DDDDD0FFFFFFF00DDDDDD000000000DDDDDDD}
          ExplicitLeft = 885
        end
        object dbgHistoryList: TDBGrid
          Left = 2
          Top = 2
          Width = 698
          Height = 360
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = dsMapHistory
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDblClick = dbgHistoryListDblClick
          OnExit = dbgHistoryListExit
          Columns = <
            item
              Expanded = False
              FieldName = 'ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MAP_500_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'CHIEF'
              Title.Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
              Width = 103
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CURRENT_CHANGES_MAPPING'
              Title.Caption = #1054#1073#1089#1083#1077#1076#1086#1074#1072#1085#1080#1077' '#1080' '#1089#1098#1077#1084#1082#1072' '#1090#1077#1082#1091#1097#1080#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'DATE_OF_ACCEPT'
              Title.Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1082#1080' '#1088#1072#1073#1086#1090' '#1075#1077#1086#1089#1083#1091#1078#1073#1086#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'DATE_OF_WORKS'
              Title.Caption = #1044#1072#1090#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1088#1072#1073#1086#1090
              Width = 137
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DRAFT_WORKS_EXECUTOR'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1095#1077#1088#1090#1077#1078#1085#1099#1093' '#1088#1072#1073#1086#1090
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'ENGIN_NET_MAPPING'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072' '#1080#1085#1078#1077#1085#1077#1088#1085#1099#1093' '#1089#1077#1090#1077#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'HIGH_RISE_MAPPING'
              Title.Caption = #1042#1099#1089#1086#1090#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'HORIZONTAL_MAPPING'
              Title.Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MENS_MAPPING'
              Title.Caption = #1052#1077#1085#1079#1091#1072#1083#1100#1085#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'NEWLY_BUILDING_MAPPING'
              Title.Caption = #1057#1098#1077#1084#1082#1072' '#1074#1085#1086#1074#1100' '#1074#1099#1089#1090#1088#1086#1077#1085#1085#1099#1093' '#1079#1076#1072#1085#1080#1081
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'ORDER_NUMBER'
              Title.Caption = #8470' '#1088#1072#1079#1088#1077#1096'.'
              Width = 72
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TACHEOMETRIC_MAPPING'
              Title.Caption = #1058#1072#1093#1077#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1089#1098#1077#1084#1082#1072
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'TOTAL_SUM'
              Title.Caption = #1042#1089#1077#1075#1086
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'WORKS_EXECUTOR'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1087#1086#1083#1077#1074#1099#1093' '#1088#1072#1073#1086#1090
              Width = 153
              Visible = True
            end>
        end
        object btnAddHistory: TButton
          Left = 2
          Top = 368
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnAddHistoryClick
        end
        object btnDeleteHistory: TButton
          Left = 164
          Top = 368
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnDeleteHistoryClick
        end
        object btnEditHistory: TButton
          Left = 83
          Top = 368
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 3
        end
        object Panel4: TPanel
          Left = 706
          Top = 3
          Width = 358
          Height = 358
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 5
          ExplicitLeft = 675
          object pbPreview: TPaintBox
            Left = 0
            Top = 0
            Width = 356
            Height = 356
            Align = alClient
            ExplicitLeft = 1
            ExplicitWidth = 135
            ExplicitHeight = 135
          end
        end
        object btnPrintHistory: TBitBtn
          Left = 551
          Top = 368
          Width = 149
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1092#1086#1088#1084#1091#1083#1103#1088
          TabOrder = 4
          OnClick = btnPrintHistoryClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000CE0E0000D80E00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222222222
            22222200000000000222208888888880802200000000000008020888888BBB88
            0002088888877788080200000000000008800888888888808080200000000008
            0800220FFFFFFFF080802220F00000F000022220FFFFFFFF022222220F00000F
            022222220FFFFFFFF02222222000000000222222222222222222}
          ExplicitLeft = 520
        end
        object btnSaveHistoryImage: TBitBtn
          Left = 706
          Top = 368
          Width = 149
          Height = 25
          Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1080#1079' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' '#1074' '#1092#1072#1081#1083'...'
          Anchors = [akRight, akBottom]
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
          TabOrder = 6
          OnClick = btnSaveHistoryImageClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000C40E0000C40E00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
            AAAAAA0000000000000AA03300000088030AA03300000088030AA03300000088
            030AA03300000000030AA03333333333330AA03300000000330AA03088888888
            030AA03088888888030AA03088888888030AA03088888888030AA03088888888
            000AA03088888888080AA00000000000000AAAAAAAAAAAAAAAAA}
          ExplicitLeft = 675
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1060#1086#1088#1084#1091#1083#1103#1088' - '#1089#1090#1072#1088#1099#1081
      ImageIndex = 1
      ExplicitWidth = 1037
      DesignSize = (
        1068
        398)
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1065
        Height = 364
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1091' '#1087#1083#1072#1085#1096#1077#1090#1072' '#1074' '#1089#1087#1080#1089#1082#1077' '#1089#1083#1077#1074#1072'.'
        TabOrder = 0
        ExplicitWidth = 1034
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 1065
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 1034
          object Label4: TLabel
            Left = 8
            Top = 2
            Width = 49
            Height = 13
            Caption = #1052#1072#1089#1096#1090#1072#1073':'
          end
          object LabelScale: TLabel
            Left = 8
            Top = 16
            Width = 49
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '100%'
          end
          object TrackBar1: TTrackBar
            Left = 63
            Top = 4
            Width = 217
            Height = 25
            Max = 100
            Min = 1
            PageSize = 10
            Frequency = 50
            Position = 100
            TabOrder = 0
            ThumbLength = 16
            OnChange = TrackBar1Change
          end
          object chkFit: TCheckBox
            Left = 286
            Top = 9
            Width = 225
            Height = 17
            Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1086#1083#1085#1086#1089#1090#1100#1102
            TabOrder = 1
            OnClick = chkFitClick
          end
        end
        object Box: TATImageBox
          Left = 0
          Top = 33
          Width = 1065
          Height = 331
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          AutoScroll = False
          Color = 16511726
          ParentColor = False
          TabOrder = 1
          ExplicitWidth = 1034
        end
      end
      object btnLoadHistoryImage: TButton
        Left = 3
        Top = 370
        Width = 158
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083
        TabOrder = 1
        OnClick = btnLoadHistoryImageClick
      end
      object btnSaveHistoryFile: TButton
        Left = 167
        Top = 370
        Width = 158
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1072#1081#1083
        TabOrder = 2
        OnClick = btnSaveHistoryFileClick
      end
    end
  end
  object btnPrintMap: TButton [12]
    Left = 922
    Top = 23
    Width = 158
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1087#1083#1072#1085#1096#1077#1090
    TabOrder = 8
    OnClick = btnPrintMapClick
    ExplicitLeft = 891
  end
  inherited Alert: TJvDesktopAlert
    Left = 56
    Top = 120
  end
  object dsGiveOuts: TDataSource
    Left = 236
    Top = 336
  end
  object PopupMenu1: TPopupMenu
    Left = 568
    Top = 8
    object miCopyMD5: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' MD5'
      OnClick = miCopyMD5Click
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 24
    Top = 120
  end
  object dsMapHistory: TDataSource
    OnStateChange = dsMapHistoryStateChange
    Left = 276
    Top = 336
  end
  object SaveDialog1: TSaveDialog
    Left = 24
    Top = 160
  end
  object pmFormularView: TPopupMenu
    Left = 384
    Top = 336
    object N1: TMenuItem
      Action = acViewDiffZone
    end
    object N2: TMenuItem
      Action = acViewMapNew
    end
    object N3: TMenuItem
      Action = acViewMapOld
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Action = acViewMapHistory
    end
  end
  object pmSaveImage: TPopupMenu
    TrackButton = tbLeftButton
    Left = 416
    Top = 336
    object MenuItem1: TMenuItem
      Action = acSaveDiffZone
    end
    object MenuItem2: TMenuItem
      Action = acSaveMapNew
    end
    object MenuItem3: TMenuItem
      Action = acSaveMapOld
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Word1: TMenuItem
      Action = acFormularToWord
    end
  end
  object ActionList1: TActionList
    Left = 504
    Top = 336
    object acViewDiffZone: TAction
      Category = 'View Image'
      Caption = #1054#1073#1083#1072#1089#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      OnExecute = acViewDiffZoneExecute
      OnUpdate = acViewDiffZoneUpdate
    end
    object acViewMapNew: TAction
      Category = 'View Image'
      Caption = #1055#1083#1072#1085#1096#1077#1090' '#1087#1086#1089#1083#1077' '#1087#1088#1080#1105#1084#1072
      OnExecute = acViewMapNewExecute
    end
    object acSaveDiffZone: TAction
      Category = 'Save Image'
      Caption = #1054#1073#1083#1072#1089#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      OnExecute = acSaveDiffZoneExecute
      OnUpdate = acSaveDiffZoneUpdate
    end
    object acSaveMapNew: TAction
      Category = 'Save Image'
      Caption = #1055#1083#1072#1085#1096#1077#1090' '#1087#1086#1089#1083#1077' '#1087#1088#1080#1105#1084#1072
      OnExecute = acSaveMapNewExecute
    end
    object acSaveMapOld: TAction
      Category = 'Save Image'
      Caption = #1055#1083#1072#1085#1096#1077#1090' '#1076#1086' '#1087#1088#1080#1105#1084#1072
      OnExecute = acSaveMapOldExecute
    end
    object acViewMapOld: TAction
      Category = 'View Image'
      Caption = #1055#1083#1072#1085#1096#1077#1090' '#1076#1086' '#1087#1088#1080#1105#1084#1072
      OnExecute = acViewMapOldExecute
    end
    object acFormularToWord: TAction
      Caption = #1060#1086#1088#1084#1091#1083#1103#1088' '#1074' '#1092#1072#1081#1083' Word'
      OnExecute = acFormularToWordExecute
      OnUpdate = acFormularToWordUpdate
    end
    object acViewMapHistory: TAction
      Category = 'View Image'
      Caption = #1055#1083#1072#1085#1096#1077#1090' + '#1086#1073#1083#1072#1089#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      OnExecute = acViewMapHistoryExecute
    end
  end
  object SaveDialog2: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 128
    Top = 120
  end
end
