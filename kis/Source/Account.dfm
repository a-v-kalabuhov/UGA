object AccountForm: TAccountForm
  Left = 303
  Top = 218
  BorderStyle = bsDialog
  Caption = #1047#1072#1082#1072#1079
  ClientHeight = 434
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 391
    Top = 405
    Width = 66
    Height = 22
    Caption = '&'#1054#1050
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 469
    Top = 405
    Width = 65
    Height = 22
    Caption = #1054'&'#1090#1084#1077#1085#1072
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 545
    Height = 399
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
        Left = 133
        Top = 42
        Width = 63
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
        FocusControl = dbeDocNumber
      end
      object Label2: TLabel
        Left = 196
        Top = 42
        Width = 58
        Height = 13
        Caption = #1044#1072#1090#1072' '#1089#1095#1077#1090#1072
        FocusControl = dbeDocDate
      end
      object Label3: TLabel
        Left = 7
        Top = 42
        Width = 50
        Height = 13
        Caption = #8470' '#1079#1072#1082#1072#1079#1072
        FocusControl = dbeOrderNumber
      end
      object Label4: TLabel
        Left = 70
        Top = 42
        Width = 63
        Height = 13
        Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
        FocusControl = dbeOrderDate
      end
      object Label10: TLabel
        Left = 7
        Top = 7
        Width = 33
        Height = 13
        Caption = #1054#1090#1076#1077#1083
        FocusControl = dblcbOfficesName
      end
      object Label5: TLabel
        Left = 7
        Top = 314
        Width = 40
        Height = 13
        Caption = #1053#1044#1057', %'
      end
      object Label17: TLabel
        Left = 374
        Top = 3
        Width = 66
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
        FocusControl = dbeExecutor
      end
      object Label16: TLabel
        Left = 419
        Top = 314
        Width = 55
        Height = 13
        Caption = #1055#1083#1072#1090'. '#1076#1086#1082'.'
        FocusControl = dbeTicket
      end
      object Label18: TLabel
        Left = 277
        Top = 314
        Width = 67
        Height = 13
        Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
        FocusControl = dbePayDate
      end
      object Label19: TLabel
        Left = 322
        Top = 42
        Width = 53
        Height = 13
        Caption = #1044#1072#1090#1072' '#1072#1082#1090#1072
        FocusControl = dbeActDate
      end
      object Label20: TLabel
        Left = 258
        Top = 42
        Width = 56
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075'.'
        FocusControl = dbeContractNumber
      end
      object Label21: TLabel
        Left = 7
        Top = 77
        Width = 77
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1086#1073#1098#1077#1082#1090#1072
      end
      object Label27: TLabel
        Left = 385
        Top = 42
        Width = 151
        Height = 13
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
      end
      object Label15: TLabel
        Left = 105
        Top = 314
        Width = 39
        Height = 13
        Caption = #1053#1057#1055', %'
      end
      object dbeDocNumber: TDBEdit
        Left = 133
        Top = 56
        Width = 57
        Height = 21
        DataField = 'DOC_NUMBER'
        DataSource = AccountsForm.DataSource
        TabOrder = 5
      end
      object dbeDocDate: TDBEdit
        Left = 196
        Top = 56
        Width = 56
        Height = 21
        DataField = 'DOC_DATE'
        DataSource = AccountsForm.DataSource
        TabOrder = 6
      end
      object dbeOrderNumber: TDBEdit
        Left = 7
        Top = 56
        Width = 56
        Height = 21
        DataField = 'ORDER_NUMBER'
        DataSource = AccountsForm.DataSource
        TabOrder = 3
      end
      object dbeOrderDate: TDBEdit
        Left = 70
        Top = 56
        Width = 57
        Height = 21
        DataField = 'ORDER_DATE'
        DataSource = AccountsForm.DataSource
        TabOrder = 4
      end
      object dblcbOfficesName: TDBLookupComboBox
        Left = 7
        Top = 21
        Width = 301
        Height = 21
        DataField = 'OFFICES_NAME'
        DataSource = AccountsForm.DataSource
        TabOrder = 0
      end
      object gbFirmName: TGroupBox
        Left = 7
        Top = 112
        Width = 525
        Height = 196
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        TabOrder = 11
        object Label6: TLabel
          Left = 7
          Top = 70
          Width = 31
          Height = 13
          Caption = #1040#1076#1088#1077#1089
          FocusControl = dbeAddress
        end
        object Label9: TLabel
          Left = 7
          Top = 105
          Width = 55
          Height = 13
          Caption = #1056#1077#1082#1074#1080#1079#1080#1090#1099
        end
        object Label7: TLabel
          Left = 7
          Top = 154
          Width = 52
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085#1099
          FocusControl = dbePhones
        end
        object Label8: TLabel
          Left = 216
          Top = 154
          Width = 21
          Height = 13
          Caption = #1048#1053#1053
          FocusControl = dbeINN
        end
        object Label22: TLabel
          Left = 224
          Top = 35
          Width = 265
          Height = 13
          Caption = #1055#1088#1077#1076#1089#1090#1072#1074#1080#1090#1077#1083#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1074' '#1088#1086#1076#1080#1090'. '#1087#1072#1076#1077#1078#1077' ('#1082#1086#1075#1086' ?)'
          FocusControl = dbeCustomer
        end
        object Label24: TLabel
          Left = 301
          Top = 154
          Width = 76
          Height = 13
          Caption = #1057#1088#1086#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
          FocusControl = dbeValPeriod
        end
        object Label29: TLabel
          Left = 147
          Top = 154
          Width = 21
          Height = 13
          Caption = #1050#1055#1055
          FocusControl = dbeKPP
        end
        object btnFirmClear: TButton
          Left = 147
          Top = 42
          Width = 66
          Height = 21
          Caption = #1054'&'#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 3
          OnClick = btnFirmClearClick
        end
        object btnFirmDetail: TButton
          Left = 77
          Top = 42
          Width = 65
          Height = 21
          Caption = #1055#1086'&'#1076#1088#1086#1073#1085#1086
          TabOrder = 2
          OnClick = btnFirmDetailClick
        end
        object btnFirmSelect: TButton
          Left = 7
          Top = 42
          Width = 66
          Height = 21
          Caption = #1042'&'#1099#1073#1088#1072#1090#1100
          TabOrder = 1
          OnClick = btnFirmSelectClick
        end
        object dbeFirmName: TDBEdit
          Left = 7
          Top = 14
          Width = 511
          Height = 21
          DataField = 'FIRM_NAME'
          DataSource = AccountsForm.DataSource
          TabOrder = 0
        end
        object dbeAddress: TDBEdit
          Left = 7
          Top = 84
          Width = 511
          Height = 21
          DataField = 'ADDRESS'
          DataSource = AccountsForm.DataSource
          TabOrder = 5
        end
        object dbmProperties: TDBMemo
          Left = 7
          Top = 119
          Width = 511
          Height = 29
          DataField = 'PROPERTIES'
          DataSource = AccountsForm.DataSource
          TabOrder = 6
        end
        object dbePhones: TDBEdit
          Left = 7
          Top = 167
          Width = 134
          Height = 21
          DataField = 'PHONES'
          DataSource = AccountsForm.DataSource
          TabOrder = 7
        end
        object dbeINN: TDBEdit
          Left = 216
          Top = 167
          Width = 78
          Height = 21
          DataField = 'INN'
          DataSource = AccountsForm.DataSource
          TabOrder = 8
        end
        object dbeCustomer: TDBEdit
          Left = 224
          Top = 49
          Width = 294
          Height = 21
          DataField = 'CUSTOMER'
          DataSource = AccountsForm.DataSource
          TabOrder = 4
        end
        object dbeValPeriod: TDBEdit
          Left = 301
          Top = 167
          Width = 71
          Height = 21
          DataField = 'VAL_PERIOD'
          DataSource = AccountsForm.DataSource
          TabOrder = 9
        end
        object dbeKPP: TDBEdit
          Left = 147
          Top = 167
          Width = 63
          Height = 21
          DataField = 'KPP'
          DataSource = AccountsForm.DataSource
          TabOrder = 10
        end
      end
      object dbeNDS: TDBEdit
        Left = 49
        Top = 314
        Width = 36
        Height = 21
        DataField = 'NDS'
        DataSource = AccountsForm.DataSource
        TabOrder = 12
        OnExit = dbeNDSExit
      end
      object dbcbChecked: TDBCheckBox
        Left = 190
        Top = 314
        Width = 56
        Height = 16
        Caption = #1054#1087#1083#1072#1095#1077#1085
        DataField = 'CHECKED'
        DataSource = AccountsForm.DataSource
        TabOrder = 13
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object dbeExecutor: TDBEdit
        Left = 314
        Top = 21
        Width = 217
        Height = 21
        DataField = 'EXECUTOR'
        DataSource = AccountsForm.DataSource
        TabOrder = 1
        Visible = False
      end
      object dbeTicket: TDBEdit
        Left = 476
        Top = 314
        Width = 56
        Height = 21
        DataField = 'TICKET'
        DataSource = AccountsForm.DataSource
        TabOrder = 15
      end
      object dbePayDate: TDBEdit
        Left = 347
        Top = 314
        Width = 58
        Height = 21
        DataField = 'PAY_DATE'
        DataSource = AccountsForm.DataSource
        TabOrder = 14
      end
      object dbeActDate: TDBEdit
        Left = 322
        Top = 56
        Width = 57
        Height = 21
        DataField = 'ACT_DATE'
        DataSource = AccountsForm.DataSource
        TabOrder = 8
      end
      object dbeContractNumber: TDBEdit
        Left = 258
        Top = 56
        Width = 58
        Height = 21
        DataField = 'CONTRACT_NUMBER'
        DataSource = AccountsForm.DataSource
        TabOrder = 7
      end
      object dbeObjectAddress: TDBEdit
        Left = 7
        Top = 91
        Width = 525
        Height = 21
        DataField = 'OBJECT_ADDRESS'
        DataSource = AccountsForm.DataSource
        TabOrder = 10
      end
      object dbeInformation: TDBEdit
        Left = 385
        Top = 56
        Width = 147
        Height = 21
        DataField = 'INFORMATION'
        DataSource = AccountsForm.DataSource
        TabOrder = 9
      end
      object dbcbMarkExecutor: TDBCheckBox
        Left = 456
        Top = 0
        Width = 68
        Height = 15
        Alignment = taLeftJustify
        Caption = #1042#1099#1076#1077#1083#1080#1090#1100
        DataField = 'MARK_EXECUTOR'
        DataSource = AccountsForm.DataSource
        TabOrder = 2
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object dblcbExecutor: TDBLookupComboBox
        Left = 314
        Top = 21
        Width = 218
        Height = 21
        DataField = 'PEOPLE_ID'
        DataSource = AccountsForm.DataSource
        DropDownRows = 15
        KeyField = 'ID'
        ListField = 'INITIAL_NAME'
        ListSource = dsPeople
        TabOrder = 16
      end
    end
    object tshWorks: TTabSheet
      Caption = #1056#1072#1073#1086#1090#1099
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object btnWorkAdd: TSpeedButton
        Left = 7
        Top = 273
        Width = 66
        Height = 21
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = btnWorkAddClick
      end
      object btnWorkDel: TSpeedButton
        Left = 77
        Top = 273
        Width = 65
        Height = 21
        Caption = #1059#1076#1072#1083#1080#1090#1100
        OnClick = btnWorkDelClick
      end
      object btnWorkEdit: TSpeedButton
        Left = 147
        Top = 273
        Width = 66
        Height = 21
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        OnClick = btnWorkEditClick
      end
      object Label25: TLabel
        Left = 7
        Top = 182
        Width = 73
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      object Label26: TLabel
        Left = 7
        Top = 231
        Width = 55
        Height = 13
        Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
      end
      object dbgWorks: TDBGrid
        Left = 7
        Top = 7
        Width = 525
        Height = 169
        DataSource = AccountsForm.dsAccountsDet
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines]
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'WORK_TYPE_CODE'
            ReadOnly = True
            Title.Caption = #1050#1086#1076'  '
            Visible = True
          end
          item
            ButtonStyle = cbsEllipsis
            Expanded = False
            FieldName = 'WORK_TYPES_NAME'
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 233
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UNIT'
            PickList.Strings = (
              #1096#1090'.'
              #1084'.'
              #1082#1074'.'#1084'.'
              #1082#1074'.'#1076#1084'.')
            Title.Caption = #1045#1076#1080#1085#1080#1094#1072
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRICE'
            Title.Caption = #1062#1077#1085#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QUANTITY'
            Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUMMA'
            ReadOnly = True
            Title.Caption = #1057#1091#1084#1084#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ARGUMENT'
            Title.Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OBJECTS_AMOUNT'
            Title.Caption = #1050#1086#1083'-'#1074#1086' '#1086#1073#1098#1077#1082#1090#1086#1074
            Visible = True
          end>
      end
      object dbmWorkTypesName: TDBMemo
        Left = 7
        Top = 196
        Width = 525
        Height = 29
        DataField = 'WORK_TYPES_NAME'
        DataSource = AccountsForm.dsAccountsDet
        TabOrder = 1
      end
      object pnlSum: TPanel
        Left = 7
        Top = 301
        Width = 525
        Height = 56
        BevelOuter = bvLowered
        TabOrder = 3
        object Label11: TLabel
          Left = 9
          Top = 7
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1090#1086#1075#1086':'
        end
        object Label12: TLabel
          Left = 147
          Top = 7
          Width = 29
          Height = 11
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1053#1044#1057':'
        end
        object Label14: TLabel
          Left = 35
          Top = 35
          Width = 141
          Height = 12
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1042#1089#1077#1075#1086' '#1089' '#1053#1044#1057' '#1080' '#1053#1057#1055':'
        end
        object dbtSumNds: TDBText
          Left = 182
          Top = 7
          Width = 43
          Height = 11
          Alignment = taRightJustify
          DataField = 'SUM_NDS'
          DataSource = AccountsForm.DataSource
        end
        object dbtSumma: TDBText
          Left = 49
          Top = 7
          Width = 43
          Height = 11
          Alignment = taRightJustify
          DataField = 'SUMMA'
          DataSource = AccountsForm.DataSource
        end
        object dbtSumAllNds: TDBText
          Left = 182
          Top = 35
          Width = 43
          Height = 12
          Alignment = taRightJustify
          DataField = 'SUM_ALL_NDS'
          DataSource = AccountsForm.DataSource
        end
        object Label28: TLabel
          Left = 405
          Top = 10
          Width = 57
          Height = 13
          Caption = #1041#1072#1079'. '#1089#1091#1084#1084#1072':'
        end
        object Label13: TLabel
          Left = 112
          Top = 21
          Width = 64
          Height = 11
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1053#1057#1055':'
        end
        object dbtSumNsp: TDBText
          Left = 182
          Top = 21
          Width = 43
          Height = 11
          Alignment = taRightJustify
          DataField = 'SUM_NSP'
          DataSource = AccountsForm.DataSource
        end
        object dbeSumBase: TDBEdit
          Left = 461
          Top = 7
          Width = 57
          Height = 21
          DataField = 'SUM_BASE'
          DataSource = AccountsForm.DataSource
          TabOrder = 0
        end
      end
      object dbeArgument: TDBEdit
        Left = 7
        Top = 245
        Width = 525
        Height = 21
        DataField = 'ARGUMENT'
        DataSource = AccountsForm.dsAccountsDet
        TabOrder = 2
      end
    end
  end
  object btnPrint: TButton
    Left = 313
    Top = 405
    Width = 66
    Height = 22
    Caption = #1055#1077#1095#1072#1090#1100
    TabOrder = 3
    Visible = False
    OnClick = btnPrintClick
  end
  object DBCheckBox1: TDBCheckBox
    Left = 5
    Top = 404
    Width = 78
    Height = 15
    Caption = #1040#1085#1085#1091#1083#1080#1088#1086#1074#1072#1085
    DataField = 'CANCELLED'
    DataSource = AccountsForm.DataSource
    TabOrder = 4
    ValueChecked = '1'
    ValueUnchecked = '0'
  end
  object ibsGetNSP: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT NSP FROM PARAMETERS')
    Transaction = AllotmentForm.ibtrReports
    Left = 292
    Top = 104
  end
  object FormStorage1: TJvFormStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredValues = <>
    Left = 400
    Top = 464
  end
  object ibqPeople: TIBQuery
    Database = KisAppModule.Database
    Transaction = AllotmentForm.ibtrReports
    AfterOpen = ibqPeopleAfterOpen
    DataSource = AccountsForm.DataSource
    SQL.Strings = (
      'select ID, INITIAL_NAME'
      'from PEOPLE'
      'where OFFICES_ID=:OFFICES_ID OR ID=:PEOPLE_ID'
      'order by 2')
    Left = 48
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OFFICES_ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'PEOPLE_ID'
        ParamType = ptUnknown
      end>
  end
  object dsPeople: TDataSource
    DataSet = ibqPeople
    Left = 96
    Top = 88
  end
end
