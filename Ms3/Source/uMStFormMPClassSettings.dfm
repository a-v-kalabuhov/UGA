object mstMPClassSettingsForm: TmstMPClassSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1083#1086#1105#1074
  ClientHeight = 406
  ClientWidth = 894
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object gridClassif: TkaDBGrid
    Left = 0
    Top = 34
    Width = 894
    Height = 372
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = acMPClassEditExecute
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = #1057#1083#1086#1081' '#1074' DXF'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NET_NAME'
        Title.Caption = #1057#1083#1086#1081' '#1074' '#1087#1088#1086#1077#1082#1090#1077
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MP_NET_NAME'
        Title.Caption = #1057#1083#1086#1081' '#1074' '#1089#1074#1086#1076#1085#1086#1084' '#1087#1083#1072#1085#1077
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NET_TYPES_ID'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'MP_NET_TYPES_ID'
        Visible = False
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 894
    Height = 34
    Align = alTop
    Caption = '   '
    TabOrder = 0
    DesignSize = (
      894
      34)
    object Label1: TLabel
      Left = 197
      Top = 9
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1080#1089#1082':'
    end
    object btnEdit: TButton
      Left = 7
      Top = 4
      Width = 75
      Height = 25
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'... (F2)'
      Action = acMPClassEdit
      TabOrder = 0
    end
    object btnDelete: TButton
      Left = 88
      Top = 4
      Width = 75
      Height = 25
      Action = acMPClassDelete
      TabOrder = 1
    end
    object btnClose: TButton
      Left = 812
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object edSearch: TEdit
      Left = 237
      Top = 6
      Width = 137
      Height = 21
      TabOrder = 3
      Text = 'edSearch'
      OnChange = edSearchChange
    end
  end
  object DataSource1: TDataSource
    DataSet = ibqProjectLayerClass
    Left = 16
    Top = 304
  end
  object IBTransaction1: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = MStIBXMapMngr.dbKis
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommit
    Left = 56
    Top = 304
  end
  object ibqProjectLayerClass: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = IBTransaction1
    SQL.Strings = (
      
        'SELECT PL.ID, PL.NAME, PL.REQUIRED, PL.DESTROYED, PL.OBJECT_TYPE' +
        ', PL.NET_TYPES_ID, PL.ACTUAL,'
      
        'PNT.NAME AS NET_NAME, PL.MP_NET_TYPES_ID, MPNT.NAME AS MP_NET_NA' +
        'ME, MPL.LINE_COLOR'
      'FROM PROJECT_LAYERS PL'
      '     LEFT JOIN'
      '     PROJECT_NET_TYPES PNT ON (PL.NET_TYPES_ID = PNT.ID)'
      '     LEFT JOIN'
      '     MASTER_PLAN_LAYERS MPNT ON (PL.MP_NET_TYPES_ID = MPNT.ID)'
      'ORDER BY PL.NAME ')
    UpdateObject = updProjectLayerClass
    Left = 96
    Top = 304
  end
  object updProjectLayerClass: TIBUpdateSQL
    Left = 128
    Top = 304
  end
  object ActionList1: TActionList
    Left = 17
    Top = 256
    object acMPClassAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Enabled = False
    end
    object acMPClassEdit: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'...'
      ShortCut = 113
      OnExecute = acMPClassEditExecute
    end
    object acMPClassDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Enabled = False
    end
  end
  object ibsqlLineColor: TIBSQL
    Database = MStIBXMapMngr.dbKis
    SQL.Strings = (
      'UPDATE MASTER_PLAN_LAYERS'
      'SET LINE_COLOR = :LINE_COLOR '
      'WHERE ID=:ID')
    Transaction = IBTransaction1
    Left = 96
    Top = 336
  end
end
