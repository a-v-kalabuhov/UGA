object AddressForm: TAddressForm
  Left = 29
  Top = 146
  BorderStyle = bsDialog
  Caption = #1040#1076#1088#1077#1089#1085#1099#1081' '#1072#1082#1090
  ClientHeight = 427
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 7
    Top = 398
    Width = 66
    Height = 23
    Caption = '&'#1054#1050
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 427
    Top = 398
    Width = 65
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 497
    Height = 392
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1072#1082#1090#1072
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 7
        Top = 7
        Width = 63
        Height = 13
        Caption = '&'#1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
        FocusControl = dbeOrderDate
      end
      object Label3: TLabel
        Left = 70
        Top = 7
        Width = 50
        Height = 13
        Caption = '&'#8470' '#1079#1072#1082#1072#1079#1072
        FocusControl = dbeOrderNumber
      end
      object Label4: TLabel
        Left = 133
        Top = 7
        Width = 45
        Height = 13
        Caption = #8470' &'#1089#1095#1077#1090#1072
        FocusControl = dbeAccount
      end
      object Label1: TLabel
        Left = 7
        Top = 112
        Width = 106
        Height = 13
        Caption = '&'#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1088#1072#1073#1086#1090
        FocusControl = dbcbWorkName
      end
      object Label5: TLabel
        Left = 7
        Top = 147
        Width = 31
        Height = 13
        Caption = '&'#1040#1076#1088#1077#1089
      end
      object Label6: TLabel
        Left = 140
        Top = 322
        Width = 59
        Height = 13
        Caption = '&'#1056#1077#1072#1083#1080#1079#1072#1094#1080#1103
      end
      object Label7: TLabel
        Left = 203
        Top = 322
        Width = 38
        Height = 13
        Caption = #1054'&'#1087#1083#1072#1090#1072
        FocusControl = dbePayment
      end
      object Label8: TLabel
        Left = 258
        Top = 7
        Width = 53
        Height = 13
        Caption = #1044#1072#1090#1072' '#1072#1082#1090#1072
        FocusControl = dbeActDate
      end
      object Label9: TLabel
        Left = 7
        Top = 322
        Width = 30
        Height = 13
        Caption = #1056#1072#1081#1086#1085
      end
      object Label10: TLabel
        Left = 322
        Top = 7
        Width = 66
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      end
      object Label11: TLabel
        Left = 7
        Top = 182
        Width = 60
        Height = 13
        Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
      end
      object Label12: TLabel
        Left = 7
        Top = 219
        Width = 197
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1087#1088#1080#1089#1074#1086#1077#1085' '#1086#1073#1098#1077#1082#1090#1091' ('#1076#1072#1090'. '#1087#1072#1076#1077#1078')'
      end
      object Label13: TLabel
        Left = 7
        Top = 254
        Width = 55
        Height = 13
        Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
      end
      object Label14: TLabel
        Left = 196
        Top = 7
        Width = 40
        Height = 13
        Caption = #8470' '#1072#1082#1090#1072
        FocusControl = dbeActNumber
      end
      object dbeOrderDate: TDBEdit
        Left = 7
        Top = 21
        Width = 56
        Height = 21
        DataField = 'ORDER_DATE'
        DataSource = AddressesForm.DataSource
        TabOrder = 0
      end
      object dbeOrderNumber: TDBEdit
        Left = 70
        Top = 21
        Width = 57
        Height = 21
        DataField = 'ORDER_NUMBER'
        DataSource = AddressesForm.DataSource
        TabOrder = 1
      end
      object dbeAccount: TDBEdit
        Left = 133
        Top = 21
        Width = 57
        Height = 21
        DataField = 'ACCOUNT_NUMBER'
        DataSource = AddressesForm.DataSource
        TabOrder = 2
      end
      object dbeSale: TDBEdit
        Left = 140
        Top = 336
        Width = 57
        Height = 21
        DataField = 'SALE'
        DataSource = AddressesForm.DataSource
        TabOrder = 3
      end
      object dbePayment: TDBEdit
        Left = 203
        Top = 336
        Width = 280
        Height = 21
        DataField = 'PAYMENT'
        DataSource = AddressesForm.DataSource
        TabOrder = 4
      end
      object gbCustomer: TGroupBox
        Left = 7
        Top = 42
        Width = 476
        Height = 64
        Caption = '&'#1047#1072#1082#1072#1079#1095#1080#1082
        TabOrder = 5
        object dbeCustomerName: TDBEdit
          Left = 7
          Top = 14
          Width = 463
          Height = 21
          DataField = 'CUSTOMER_NAME'
          DataSource = AddressesForm.DataSource
          TabOrder = 0
        end
        object btnSelect: TButton
          Left = 7
          Top = 35
          Width = 66
          Height = 22
          Caption = #1042#1099#1073#1088#1072#1090#1100
          TabOrder = 1
          OnClick = btnSelectClick
        end
        object btnClear: TButton
          Left = 147
          Top = 35
          Width = 66
          Height = 22
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 3
          OnClick = btnClearClick
        end
        object btnDetail: TButton
          Left = 77
          Top = 35
          Width = 65
          Height = 22
          Caption = #1055#1086#1076#1088#1086#1073#1085#1086
          TabOrder = 2
          OnClick = btnDetailClick
        end
      end
      object dbcbWorkName: TDBComboBox
        Left = 7
        Top = 126
        Width = 476
        Height = 21
        DataField = 'WORK_NAME'
        DataSource = AddressesForm.DataSource
        ItemHeight = 13
        TabOrder = 6
      end
      object dbeActDate: TDBEdit
        Left = 258
        Top = 21
        Width = 58
        Height = 21
        DataField = 'ACT_DATE'
        DataSource = AddressesForm.DataSource
        TabOrder = 7
      end
      object dblcbRegion: TDBLookupComboBox
        Left = 7
        Top = 336
        Width = 127
        Height = 21
        DataField = 'REGIONS_NAME'
        DataSource = AddressesForm.DataSource
        TabOrder = 8
      end
      object dblcbExecutor: TDBLookupComboBox
        Left = 322
        Top = 21
        Width = 161
        Height = 21
        DataField = 'INITIAL_NAME'
        DataSource = AddressesForm.DataSource
        TabOrder = 9
      end
      object dbeObject: TDBEdit
        Left = 7
        Top = 233
        Width = 476
        Height = 21
        DataField = 'OBJECT_ADDRESS'
        DataSource = AddressesForm.DataSource
        TabOrder = 10
      end
      object dbmFoundation: TDBMemo
        Left = 7
        Top = 267
        Width = 476
        Height = 51
        DataField = 'FOUNDATION'
        DataSource = AddressesForm.DataSource
        ScrollBars = ssVertical
        TabOrder = 11
      end
      object btnStreet: TButton
        Left = 398
        Top = 159
        Width = 42
        Height = 22
        Caption = #1059#1083#1080#1094#1072
        TabOrder = 12
        OnClick = btnStreetClick
      end
      object btnBuilding: TButton
        Left = 440
        Top = 159
        Width = 43
        Height = 22
        Caption = #1044#1086#1084
        TabOrder = 13
        OnClick = btnBuildingClick
      end
      object dbedPurpose: TDBEdit
        Left = 7
        Top = 196
        Width = 476
        Height = 21
        DataField = 'PURPOSE'
        DataSource = AddressesForm.DataSource
        TabOrder = 14
      end
      object dbedPrintableAddress: TDBEdit
        Left = 7
        Top = 161
        Width = 385
        Height = 21
        DataField = 'PRINTABLE_ADDRESS'
        DataSource = AddressesForm.DataSource
        ReadOnly = True
        TabOrder = 15
      end
      object dbeActNumber: TDBEdit
        Left = 196
        Top = 21
        Width = 56
        Height = 21
        DataField = 'ACT_NUMBER'
        DataSource = AddressesForm.DataSource
        TabOrder = 16
      end
      object dbcbPuprose: TDBComboBox
        Left = 7
        Top = 196
        Width = 476
        Height = 21
        DataField = 'PURPOSE'
        DataSource = AddressesForm.DataSource
        ItemHeight = 13
        TabOrder = 17
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1083#1072#1085' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1087#1086#1095#1090#1086#1074#1086#1075#1086' '#1072#1076#1088#1077#1089#1072
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object btnLoadImage: TButton
        Left = 421
        Top = 7
        Width = 65
        Height = 22
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
        TabOrder = 0
        OnClick = btnLoadImageClick
      end
      object btnClearImage: TButton
        Left = 421
        Top = 42
        Width = 65
        Height = 21
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 1
        OnClick = btnClearImageClick
      end
      object dbiImage: TDBImage
        Left = 2
        Top = 2
        Width = 412
        Height = 363
        DataField = 'IMAGE'
        DataSource = AddressesForm.DataSource
        Enabled = False
        TabOrder = 2
      end
    end
  end
  object ibsAddressWorks: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT WORK_NAME'
      'FROM ADDRESS_WORKS'
      'ORDER BY 1')
    Transaction = AllotmentForm.ibtrReports
    Left = 384
    Top = 88
  end
  object ibsStreetName: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'select NAME, STREET_MARKING_NAME, REGIONS_ID from STREETS '
      'WHERE ID=:ID')
    Transaction = AllotmentForm.ibtrReports
    Left = 88
    Top = 176
  end
  object ibsVillageInfo: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'select A.ID, A.NAME, A.STREET_MARKING_NAME '
      'from VILLAGES A, STREETS B'
      'WHERE A.ID=B.VILLAGES_ID AND B.ID=:ID')
    Transaction = AllotmentForm.ibtrReports
    Left = 144
    Top = 176
  end
end
