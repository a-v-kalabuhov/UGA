object mstSelectOrgDialog: TmstSelectOrgDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
  ClientHeight = 490
  ClientWidth = 1115
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    1115
    490)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 108
    Height = 13
    Caption = #1048#1089#1082#1072#1090#1100' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102':'
  end
  object dbgrid: TkaDBGrid
    Left = 8
    Top = 32
    Width = 1021
    Height = 450
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dbgridDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 330
        Visible = True
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
        FieldName = 'START_DATE'
        Title.Caption = #1051#1080#1094'.'#1085#1072#1095#1072#1083#1086
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'END_DATE'
        Title.Caption = #1051#1080#1094'.'#1082#1086#1085#1077#1094
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MAPPER_FIO'
        Title.Caption = #1050#1086#1085#1090#1072#1082#1090
        Width = 200
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 1035
    Top = 32
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1099#1073#1088#1072#1090#1100
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 1035
    Top = 63
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object edSearch: TEdit
    Left = 122
    Top = 5
    Width = 231
    Height = 21
    TabOrder = 3
    OnChange = edSearchChange
  end
  object IBQuery1: TIBQuery
    Database = MStIBXMapMngr.dbKis
    Transaction = IBTransaction1
    SQL.Strings = (
      'SELECT * FROM LICENSED_ORGS'
      'ORDER BY NAME')
    Left = 488
    Top = 168
    object IBQuery1ID: TIntegerField
      FieldName = 'ID'
      Origin = '"LICENSED_ORGS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Visible = False
    end
    object IBQuery1NAME: TIBStringField
      FieldName = 'NAME'
      Origin = '"LICENSED_ORGS"."NAME"'
      Size = 300
    end
    object IBQuery1ADDRESS: TIBStringField
      FieldName = 'ADDRESS'
      Origin = '"LICENSED_ORGS"."ADDRESS"'
      Size = 255
    end
    object IBQuery1START_DATE: TDateField
      FieldName = 'START_DATE'
      Origin = '"LICENSED_ORGS"."START_DATE"'
    end
    object IBQuery1END_DATE: TDateField
      FieldName = 'END_DATE'
      Origin = '"LICENSED_ORGS"."END_DATE"'
    end
    object IBQuery1MAPPER_FIO: TIBStringField
      FieldName = 'MAPPER_FIO'
      Origin = '"LICENSED_ORGS"."MAPPER_FIO"'
      Size = 100
    end
  end
  object DataSource1: TDataSource
    DataSet = IBQuery1
    Left = 488
    Top = 208
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = MStIBXMapMngr.dbKis
    Left = 440
    Top = 176
  end
end
