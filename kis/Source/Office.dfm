object OfficeForm: TOfficeForm
  Left = 236
  Top = 227
  ActiveControl = dbeName
  BorderStyle = bsDialog
  Caption = #1054#1090#1076#1077#1083
  ClientHeight = 415
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 8
    Top = 384
    Width = 70
    Height = 24
    Caption = '&'#1054#1050
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 83
    Top = 384
    Width = 71
    Height = 24
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 580
    Height = 378
    ActivePage = tshCommon
    Align = alTop
    TabOrder = 0
    object tshCommon: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 8
        Top = 45
        Width = 73
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        FocusControl = dbeName
      end
      object Label2: TLabel
        Left = 505
        Top = 45
        Width = 43
        Height = 13
        Caption = #1050#1088#1072#1090#1082#1086#1077
        FocusControl = dbeShortName
      end
      object Label3: TLabel
        Left = 8
        Top = 90
        Width = 52
        Height = 13
        Caption = #1058#1077#1083#1077#1092#1086#1085#1099
        FocusControl = dbePhones
      end
      object Label4: TLabel
        Left = 188
        Top = 90
        Width = 55
        Height = 13
        Caption = #1053#1072#1095#1072#1083#1100#1085#1080#1082
        FocusControl = dbeDirector
      end
      object Label6: TLabel
        Left = 8
        Top = 135
        Width = 24
        Height = 13
        Caption = #1056#1086#1083#1100
        FocusControl = dbeRoleName
      end
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 66
        Height = 13
        Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
        FocusControl = dbeName
      end
      object dbeName: TDBEdit
        Left = 8
        Top = 60
        Width = 490
        Height = 21
        DataField = 'NAME'
        DataSource = OfficesForm.DataSource
        TabOrder = 0
      end
      object dbeShortName: TDBEdit
        Left = 505
        Top = 60
        Width = 61
        Height = 21
        DataField = 'SHORT_NAME'
        DataSource = OfficesForm.DataSource
        TabOrder = 1
      end
      object dbePhones: TDBEdit
        Left = 8
        Top = 106
        Width = 172
        Height = 21
        DataField = 'PHONES'
        DataSource = OfficesForm.DataSource
        TabOrder = 2
      end
      object dbeDirector: TDBEdit
        Left = 188
        Top = 106
        Width = 310
        Height = 21
        DataField = 'DIRECTOR'
        DataSource = OfficesForm.DataSource
        TabOrder = 3
      end
      object dbeRoleName: TDBEdit
        Left = 8
        Top = 151
        Width = 116
        Height = 21
        DataField = 'ROLE_NAME'
        DataSource = OfficesForm.DataSource
        TabOrder = 4
      end
      object dblcbOrgName: TDBLookupComboBox
        Left = 8
        Top = 23
        Width = 558
        Height = 21
        DataField = 'ORGS_ID'
        DataSource = OfficesForm.DataSource
        KeyField = 'ID'
        ListField = 'NAME'
        ListSource = dsOrgs
        TabOrder = 5
      end
    end
    object tshWorkTypes: TTabSheet
      Caption = #1042#1080#1076#1099' '#1088#1072#1073#1086#1090
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object btnWorkAdd: TSpeedButton
        Left = 8
        Top = 323
        Width = 70
        Height = 24
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = btnWorkAddClick
      end
      object btnWorkDel: TSpeedButton
        Left = 83
        Top = 323
        Width = 71
        Height = 24
        Caption = #1059#1076#1072#1083#1080#1090#1100
        OnClick = btnWorkDelClick
      end
      object Label7: TLabel
        Left = 8
        Top = 226
        Width = 73
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      object Label8: TLabel
        Left = 8
        Top = 278
        Width = 55
        Height = 13
        Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
      end
      object dbgWorkTypes: TDBGrid
        Left = 8
        Top = 8
        Width = 558
        Height = 211
        DataSource = dsWorkTypes
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            ReadOnly = True
            Title.Caption = #1053#1086#1084#1077#1088' '#1087'/'#1087
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CODE'
            Title.Caption = #1050#1086#1076' '#1088#1072#1073#1086#1090#1099
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SHORT_NAME'
            Title.Caption = #1050#1088#1072#1090#1082#1086#1077
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ARGUMENT'
            Title.Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRICE'
            Title.Caption = #1062#1077#1085#1072
            Visible = True
          end>
      end
      object dbmWorkName: TDBMemo
        Left = 8
        Top = 241
        Width = 558
        Height = 31
        DataField = 'NAME'
        DataSource = dsWorkTypes
        TabOrder = 1
      end
      object dbeArgument: TDBEdit
        Left = 8
        Top = 294
        Width = 558
        Height = 25
        DataField = 'ARGUMENT'
        DataSource = dsWorkTypes
        TabOrder = 2
      end
    end
  end
  object ibqWorkTypes: TIBQuery
    Database = KisAppModule.Database
    Transaction = VillagesForm.Transaction
    AfterInsert = ibqWorkTypesAfterInsert
    BeforeDelete = ibqWorkTypesBeforeDelete
    SQL.Strings = (
      'SELECT * FROM WORK_TYPES'
      'WHERE OFFICES_ID=:OFFICES_ID'
      'ORDER BY ID')
    UpdateObject = ibusWorktypes
    Left = 352
    Top = 192
    ParamData = <
      item
        DataType = ftString
        Name = 'OFFICES_ID'
        ParamType = ptUnknown
        Value = '1'
      end>
    object ibqWorkTypesOFFICES_ID: TIntegerField
      FieldName = 'OFFICES_ID'
    end
    object ibqWorkTypesID: TSmallintField
      FieldName = 'ID'
    end
    object ibqWorkTypesCODE: TIBStringField
      FieldName = 'CODE'
      Origin = 'WORK_TYPES.CODE'
      Size = 10
    end
    object ibqWorkTypesNAME: TIBStringField
      FieldName = 'NAME'
      Size = 200
    end
    object ibqWorkTypesSHORT_NAME: TIBStringField
      FieldName = 'SHORT_NAME'
      Size = 100
    end
    object ibqWorkTypesARGUMENT: TIBStringField
      FieldName = 'ARGUMENT'
      Size = 100
    end
    object ibqWorkTypesPRICE: TFloatField
      FieldName = 'PRICE'
      DisplayFormat = '0.00,,'#39#39
    end
  end
  object ibusWorktypes: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT * FROM WORK_TYPES'
      'WHERE OFFICES_ID=:OFFICES_ID AND ID=:ID')
    ModifySQL.Strings = (
      'UPDATE WORK_TYPES'
      'SET'
      'NAME=:NAME,'
      'SHORT_NAME=:SHORT_NAME,'
      'ARGUMENT=:ARGUMENT,'
      'PRICE=:PRICE,'
      'CODE=:CODE'
      'WHERE OFFICES_ID=:OLD_OFFICES_ID AND ID=:OLD_ID')
    InsertSQL.Strings = (
      'INSERT INTO WORK_TYPES (OFFICES_ID, ID, NAME, SHORT_NAME, '
      'ARGUMENT, PRICE, CODE)'
      
        'VALUES (:OFFICES_ID, :ID, :NAME, :SHORT_NAME, :ARGUMENT, :PRICE,' +
        ' :CODE)')
    DeleteSQL.Strings = (
      'DELETE FROM WORK_TYPES'
      'WHERE OFFICES_ID=:OFFICES_ID AND ID=:ID')
    Left = 352
    Top = 224
  end
  object dsWorkTypes: TDataSource
    DataSet = ibqWorkTypes
    Left = 352
    Top = 256
  end
  object ibsGetId: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT MAX(ID) FROM WORK_TYPES'
      'WHERE OFFICES_ID=:OFFICES_ID')
    Transaction = VillagesForm.Transaction
    Left = 384
    Top = 192
  end
  object ibqOrgs: TIBQuery
    Database = KisAppModule.Database
    Transaction = VillagesForm.Transaction
    SQL.Strings = (
      'SELECT ID, NAME FROM ORGS'
      'ORDER BY NAME')
    Left = 276
    Top = 192
  end
  object dsOrgs: TDataSource
    DataSet = ibqOrgs
    Left = 276
    Top = 224
  end
end
