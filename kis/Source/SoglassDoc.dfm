object SoglassDocForm: TSoglassDocForm
  Tag = 2
  Left = 108
  Top = 112
  BorderStyle = bsSingle
  Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077'  '#1087#1088#1086#1077#1082#1090#1086#1074
  ClientHeight = 444
  ClientWidth = 571
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 203
    Top = 15
    Width = 37
    Height = 13
    Caption = 'Label10'
  end
  object btnOK: TButton
    Left = 330
    Top = 415
    Width = 70
    Height = 24
    Caption = '&'#1054#1050
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 412
    Top = 415
    Width = 71
    Height = 24
    Caption = #1054'&'#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnPrint: TButton
    Left = 495
    Top = 415
    Width = 71
    Height = 24
    Caption = '&'#1055#1077#1095#1072#1090#1100
    TabOrder = 2
    OnClick = btnPrintClick
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 571
    Height = 408
    ActivePage = TabSheet1
    Align = alTop
    HotTrack = True
    MultiLine = True
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 8
        Top = 1
        Width = 79
        Height = 13
        Caption = #1047#1072#1082#1083#1102#1095#1077#1085#1080#1077' '#8470
      end
      object Label2: TLabel
        Left = 99
        Top = 1
        Width = 62
        Height = 13
        Caption = #1055#1086' '#1087#1088#1086#1077#1082#1090#1091':'
      end
      object Label3: TLabel
        Left = 8
        Top = 37
        Width = 107
        Height = 13
        Caption = #1057#1090#1072#1076#1080#1103'  '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1080':'
      end
      object Label4: TLabel
        Left = 309
        Top = 2
        Width = 75
        Height = 13
        Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1080':'
      end
      object Label5: TLabel
        Left = 445
        Top = 2
        Width = 70
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
      end
      object Label6: TLabel
        Left = 310
        Top = 38
        Width = 114
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1089#1090#1088#1086#1080#1090#1077#1083#1100#1089#1090#1074#1072':'
      end
      object Label7: TLabel
        Left = 8
        Top = 240
        Width = 52
        Height = 13
        Caption = #1051#1080#1094#1077#1085#1079#1080#1103':'
      end
      object Label8: TLabel
        Left = 309
        Top = 241
        Width = 92
        Height = 13
        Caption = #1048#1053#1053' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080':'
      end
      object Label9: TLabel
        Left = 310
        Top = 289
        Width = 106
        Height = 13
        Caption = #1040#1076#1088#1077#1089'  '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1103':'
      end
      object Label11: TLabel
        Left = 159
        Top = 38
        Width = 30
        Height = 13
        Caption = #1056#1072#1081#1086#1085
      end
      object dbeZAKL: TDBEdit
        Left = 8
        Top = 14
        Width = 76
        Height = 21
        DataField = 'PROJECTID'
        DataSource = MainDS
        MaxLength = 5
        TabOrder = 0
      end
      object dbePROJECT: TDBEdit
        Left = 98
        Top = 14
        Width = 204
        Height = 21
        DataField = 'PROJECT'
        DataSource = MainDS
        TabOrder = 1
      end
      object dbeDATA: TDBEdit
        Left = 309
        Top = 14
        Width = 115
        Height = 21
        DataField = 'DATE_PODPIS'
        DataSource = MainDS
        TabOrder = 2
      end
      object dbeNAMEISP: TDBEdit
        Left = 444
        Top = 14
        Width = 112
        Height = 21
        DataField = 'NAMEISP'
        DataSource = MainDS
        TabOrder = 3
      end
      object dbeSTADIA: TDBEdit
        Left = 8
        Top = 50
        Width = 143
        Height = 21
        DataField = 'STADIA'
        DataSource = MainDS
        TabOrder = 4
      end
      object dbeADDRESS: TDBEdit
        Left = 309
        Top = 50
        Width = 247
        Height = 21
        DataField = 'ADDRESS'
        DataSource = MainDS
        TabOrder = 6
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 75
        Width = 550
        Height = 76
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        TabOrder = 7
        object dbeMEN: TDBEdit
          Left = 8
          Top = 14
          Width = 535
          Height = 21
          DataField = 'MEN'
          DataSource = MainDS
          TabOrder = 0
        end
        object btnSel1: TButton
          Left = 317
          Top = 45
          Width = 70
          Height = 24
          Caption = #1042#1099#1073#1088#1072#1090#1100
          TabOrder = 1
          OnClick = btnSel1Click
        end
        object btnFirmsShow1: TButton
          Left = 392
          Top = 45
          Width = 70
          Height = 24
          Caption = #1055#1086#1076#1088#1086#1073#1085#1086
          TabOrder = 2
          OnClick = btnFirmsShow1Click
        end
        object btnClear1: TButton
          Left = 466
          Top = 45
          Width = 72
          Height = 24
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 3
          OnClick = BtnClear1Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 158
        Width = 550
        Height = 76
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100'  '#1087#1088#1086#1077#1082#1090#1072':'
        TabOrder = 8
        object dbeCOMPANY: TDBEdit
          Left = 8
          Top = 14
          Width = 535
          Height = 21
          DataField = 'COMPANY'
          DataSource = MainDS
          TabOrder = 0
        end
        object btnClear2: TButton
          Left = 466
          Top = 44
          Width = 72
          Height = 24
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 1
          OnClick = btnClear2Click
        end
        object btnFirmsShow2: TButton
          Left = 392
          Top = 44
          Width = 70
          Height = 24
          Caption = #1055#1086#1076#1088#1086#1073#1085#1086
          TabOrder = 2
          OnClick = btnFirmsShow2Click
        end
        object btnSel2: TButton
          Left = 317
          Top = 44
          Width = 70
          Height = 24
          Caption = #1042#1099#1073#1088#1072#1090#1100
          TabOrder = 3
          OnClick = BtnSel2Click
        end
      end
      object dbmCOMPLIC: TDBMemo
        Left = 8
        Top = 253
        Width = 294
        Height = 70
        DataField = 'COMPLIC'
        DataSource = MainDS
        TabOrder = 9
      end
      object dbeCOMPINN: TDBEdit
        Left = 309
        Top = 254
        Width = 250
        Height = 21
        DataField = 'COMPINN'
        DataSource = MainDS
        TabOrder = 10
      end
      object dbeCOMPADDR: TDBEdit
        Left = 309
        Top = 302
        Width = 250
        Height = 21
        DataField = 'COMPADDR'
        DataSource = MainDS
        TabOrder = 11
      end
      object dblsREGION: TDBLookupComboBox
        Left = 158
        Top = 50
        Width = 136
        Height = 21
        DataField = 'REGION'
        DataSource = MainDS
        DropDownRows = 10
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        TabStop = False
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label12: TLabel
        Left = 144
        Top = 3
        Width = 90
        Height = 13
        Caption = #1046#1080#1083#1072#1103'  '#1087#1083#1086#1097#1072#1076#1100':'
      end
      object Label13: TLabel
        Left = 8
        Top = 2
        Width = 106
        Height = 13
        Caption = #1055#1083#1086#1097#1072#1076#1100' '#1079#1072#1089#1090#1088#1086#1081#1082#1080':'
      end
      object Label14: TLabel
        Left = 287
        Top = 3
        Width = 91
        Height = 13
        Caption = #1054#1073#1097#1072#1103'  '#1087#1083#1086#1097#1072#1076#1100':'
      end
      object Label15: TLabel
        Left = 437
        Top = 3
        Width = 115
        Height = 13
        Caption = #1057#1090#1088#1086#1080#1090#1077#1083#1100#1085#1099#1081'  '#1086#1073#1100#1077#1084':'
      end
      object Label16: TLabel
        Left = 9
        Top = 220
        Width = 185
        Height = 13
        Caption = #1055#1088#1072#1074#1086#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1102#1097#1080#1081'  '#1076#1086#1082#1091#1084#1077#1085#1090':'
      end
      object Label17: TLabel
        Left = 303
        Top = 220
        Width = 206
        Height = 13
        Caption = #1040#1088#1093#1080#1090#1077#1082#1090#1091#1088#1085#1086'-'#1087#1083#1072#1085#1080#1088#1086#1074#1086#1095#1085#1086#1077' '#1088#1077#1096#1077#1085#1080#1077':'
      end
      object dbeZHPLOSH: TDBEdit
        Left = 143
        Top = 15
        Width = 106
        Height = 21
        DataField = 'ZHPLOSH'
        DataSource = MainDS
        TabOrder = 1
      end
      object dbePLOSH: TDBEdit
        Left = 8
        Top = 15
        Width = 98
        Height = 21
        DataField = 'PLOSH'
        DataSource = MainDS
        TabOrder = 0
      end
      object dbeOBPLOSH: TDBEdit
        Left = 286
        Top = 15
        Width = 119
        Height = 21
        DataField = 'OBPLOSH'
        DataSource = MainDS
        TabOrder = 2
      end
      object dbeOBEM: TDBEdit
        Left = 437
        Top = 15
        Width = 120
        Height = 21
        DataField = 'OBEM'
        DataSource = MainDS
        TabOrder = 3
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 45
        Width = 550
        Height = 159
        Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072'  '#1086#1073#1097#1080#1093'  '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1077#1081' '
        TabOrder = 4
        object dbgValues: TDBGrid
          Left = 8
          Top = 15
          Width = 535
          Height = 99
          DataSource = dsValues
          TabOrder = 3
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDblClick = btnDialogClick
          Columns = <
            item
              Expanded = False
              FieldName = 'NAME'
              ReadOnly = True
              Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
              Width = 148
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PLOSH'
              Title.Caption = #1055#1083#1086#1097#1072#1076#1100' '
              Width = 101
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ZHPLOSH'
              Title.Caption = #1046#1080#1083#1072#1103'  '#1087#1083#1086#1097#1072#1076#1100
              Width = 112
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OBPLOSH'
              Title.Caption = #1054#1073#1097#1072#1103'  '#1087#1083#1086#1097#1072#1076#1100
              Width = 101
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OBEM'
              Title.Caption = #1054#1073#1100#1077#1084
              Width = 86
              Visible = True
            end>
        end
        object btnAdd: TButton
          Left = 384
          Top = 128
          Width = 70
          Height = 23
          Caption = '&'#1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnAddClick
        end
        object btnDel: TButton
          Left = 460
          Top = 128
          Width = 70
          Height = 23
          Caption = '&'#1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnDelClick
        end
        object btnDialog: TButton
          Left = 309
          Top = 128
          Width = 70
          Height = 23
          Caption = '&'#1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 0
          OnClick = btnDialogClick
        end
      end
      object dbmDOCUMENT: TDBMemo
        Left = 8
        Top = 233
        Width = 279
        Height = 129
        DataField = 'DOKUMENT'
        DataSource = MainDS
        TabOrder = 5
      end
      object dbmRESHENIE: TDBMemo
        Left = 301
        Top = 233
        Width = 257
        Height = 129
        DataField = 'RESHENIE'
        DataSource = MainDS
        TabOrder = 6
      end
    end
  end
  object ibsValuesMaxId: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT MAX(ID) AS MAX_ID'
      'FROM SOGLASOVANIE_VALUES'
      'WHERE IDOFSOGLASS=:IDOFSOGLASS')
    Transaction = FindForm.Transaction
    Left = 188
    Top = 208
  end
  object ibsCountValues: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT COUNT(Name) FROM SOGLASOVANIE_VALUES'
      'WHERE IDOFSOGLASS=:IDOFSOGLASS')
    Transaction = FindForm.Transaction
    Left = 220
    Top = 208
  end
  object ibqVal: TIBQuery
    Database = KisAppModule.Database
    Transaction = FindForm.Transaction
    AfterInsert = ibqValAfterInsert
    BeforeDelete = ibqValBeforeDelete
    SQL.Strings = (
      'SELECT * FROM SOGLASOVANIE_VALUES '
      'WHERE IDOFSOGLASS=:IDOFSOGLASS')
    UpdateObject = ibuValues
    Left = 68
    Top = 240
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IDOFSOGLASS'
        ParamType = ptUnknown
      end>
  end
  object dsValues: TDataSource
    DataSet = ibqVal
    Left = 36
    Top = 240
  end
  object ibuValues: TIBUpdateSQL
    ModifySQL.Strings = (
      'UPDATE SOGLASOVANIE_VALUES'
      'SET'
      'NAME=:NAME,'
      'OBEM=:OBEM,'
      'OBPLOSH=:OBPLOSH,'
      'PLOSH=:PLOSH,'
      'ZHPLOSH=:ZHPLOSH'
      'WHERE (ID=:ID) AND (IDOFSOGLASS=:IDOFSOGLASS)')
    InsertSQL.Strings = (
      'INSERT INTO SOGLASOVANIE_VALUES'
      '(ID, IDOFSOGLASS, PLOSH, ZHPLOSH, OBPLOSH, OBEM, NAME)'
      'VALUES'
      '(:ID, :IDOFSOGLASS, :PLOSH, :ZHPLOSH, :OBPLOSH, :OBEM, :NAME)')
    DeleteSQL.Strings = (
      'DELETE FROM SOGLASOVANIE_VALUES'
      'WHERE (ID=:ID) AND (IDOFSOGLASS=:IDOFSOGLASS)')
    Left = 100
    Top = 240
  end
  object ibsValues: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT * FROM SOGLASOVANIE_VALUES'
      'WHERE'
      'IDOFSOGLASS=:IDOFSOGLASS')
    Transaction = FindForm.Transaction
    Left = 132
    Top = 336
  end
  object MainDS: TDataSource
    DataSet = SoglassForm.Query
    Left = 128
    Top = 448
  end
end
