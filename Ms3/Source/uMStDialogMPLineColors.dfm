object mstMPLineColorsDialog: TmstMPLineColorsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1094#1074#1077#1090#1072' '#1083#1080#1085#1080#1081
  ClientHeight = 289
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object kaDBGrid1: TkaDBGrid
    Left = 8
    Top = 8
    Width = 320
    Height = 273
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellColors = kaDBGrid1CellColors
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = #1057#1083#1086#1081
        Width = 190
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IS_GROUP'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'GROUP_ID'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'LINE_COLOR'
        Title.Caption = #1062#1074#1077#1090
        Visible = True
      end>
  end
  object btnClose: TButton
    Left = 334
    Top = 256
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object btnEdit: TButton
    Left = 334
    Top = 8
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
    TabOrder = 1
    OnClick = btnEditClick
  end
  object ColorDialog1: TColorDialog
    Left = 344
    Top = 64
  end
  object DataSource1: TDataSource
    DataSet = ibqLineColors
    Left = 176
    Top = 30
  end
  object ibtLineColors: TIBTransaction
    AllowAutoStart = False
    DefaultDatabase = MStIBXMapMngr.dbKis
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommit
    Left = 56
    Top = 30
  end
  object ibqLineColors: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = ibtLineColors
    SQL.Strings = (
      'SELECT *'
      'FROM '
      '     MASTER_PLAN_LAYERS'
      'ORDER BY ID')
    UpdateObject = updLineColors
    Left = 96
    Top = 30
    object ibqLineColorsID: TIntegerField
      FieldName = 'ID'
      Origin = '"MASTER_PLAN_LAYERS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ibqLineColorsNAME: TIBStringField
      FieldName = 'NAME'
      Origin = '"MASTER_PLAN_LAYERS"."NAME"'
      Required = True
      Size = 255
    end
    object ibqLineColorsIS_GROUP: TSmallintField
      FieldName = 'IS_GROUP'
      Origin = '"MASTER_PLAN_LAYERS"."IS_GROUP"'
    end
    object ibqLineColorsGROUP_ID: TIntegerField
      FieldName = 'GROUP_ID'
      Origin = '"MASTER_PLAN_LAYERS"."GROUP_ID"'
    end
    object ibqLineColorsLINE_COLOR: TIBStringField
      FieldName = 'LINE_COLOR'
      Origin = '"MASTER_PLAN_LAYERS"."LINE_COLOR"'
      OnGetText = ibqLineColorsLINE_COLORGetText
      Size = 10
    end
  end
  object updLineColors: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM '
      '     MASTER_PLAN_LAYERS'
      'WHERE ID=:ID')
    ModifySQL.Strings = (
      'UPDATE MASTER_PLAN_LAYERS'
      'SET LINE_COLOR = :LINE_COLOR'
      'WHERE ID = :ID')
    Left = 128
    Top = 30
  end
end
