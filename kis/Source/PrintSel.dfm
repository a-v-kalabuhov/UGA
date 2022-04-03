object PrintSelForm: TPrintSelForm
  Left = 470
  Top = 191
  ActiveControl = lbReports
  BorderStyle = bsDialog
  Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1074#1086#1076#1072
  ClientHeight = 248
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 2
    Width = 40
    Height = 13
    Caption = #1054#1090'&'#1095#1077#1090#1099
    FocusControl = lbReports
  end
  object btnOk: TButton
    Left = 8
    Top = 219
    Width = 70
    Height = 23
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 83
    Top = 219
    Width = 71
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object lbReports: TListBox
    Left = 9
    Top = 21
    Width = 249
    Height = 121
    IntegralHeight = True
    ItemHeight = 13
    Items.Strings = (
      #1040#1082#1090' '#1086#1090#1074#1086#1076#1072' (1 '#1089#1090#1088'.)'
      #1040#1082#1090' '#1086#1090#1074#1086#1076#1072' (2 '#1089#1090#1088'.)'
      #1055#1083#1072#1085' '#1086#1090#1074#1086#1076#1072' ('#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1080' '#1091#1095#1072#1089#1090#1086#1082')'
      #1055#1083#1072#1085' '#1086#1090#1074#1086#1076#1072' ('#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099')'
      #1040#1082#1090' '#1079#1077#1084#1077#1083#1100#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072
      #1055#1083#1072#1085' '#1079#1077#1084#1077#1083#1100#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072' 1'
      #1055#1083#1072#1085' '#1079#1077#1084#1077#1083#1100#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072' 1 (2)'
      #1055#1083#1072#1085' '#1079#1077#1084#1077#1083#1100#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072' 2'
      #1055#1083#1072#1085' '#1079#1077#1084#1077#1083#1100#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072' 3'
      #1055#1083#1072#1085' '#1087#1072#1074#1080#1083#1100#1086#1085#1072
      #1055#1083#1072#1085' '#1048#1046#1057' '#1089#1098#1077#1084#1082#1080
      #1058#1086#1083#1100#1082#1086' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1080' '#1087#1083#1072#1085)
    TabOrder = 0
    OnDblClick = lbReportsDblClick
  end
  object cbAllOwners: TCheckBox
    Left = 188
    Top = 166
    Width = 92
    Height = 16
    Caption = #1042#1089#1077' '#1074#1083#1072#1076#1077#1083#1100#1094#1099
    TabOrder = 3
  end
  object btnAddItem: TButton
    Left = 264
    Top = 23
    Width = 91
    Height = 23
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Enabled = False
    TabOrder = 4
    OnClick = btnAddItemClick
  end
  object btnDelItem: TButton
    Left = 264
    Top = 53
    Width = 91
    Height = 23
    Caption = #1059#1076#1072#1083#1080#1090#1100
    Enabled = False
    TabOrder = 5
    OnClick = btnDelItemClick
  end
  object btnRedactItem: TButton
    Left = 264
    Top = 83
    Width = 91
    Height = 23
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 6
    OnClick = btnRedactItemClick
  end
  object rgReportType: TRadioGroup
    Left = 8
    Top = 158
    Width = 174
    Height = 54
    Caption = #1042#1099#1073#1086#1088
    ItemIndex = 1
    Items.Strings = (
      #1047#1077#1084#1083#1077#1091#1089#1090#1088#1086#1080#1090#1077#1083#1100#1085#1086#1077' '#1076#1077#1083#1086
      #1055#1088#1086#1095#1080#1077' '#1086#1090#1095#1077#1090#1099)
    TabOrder = 7
    OnClick = rgReportTypeClick
  end
  object ibReportsList: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtListReports
    SQL.Strings = (
      'SELECT * FROM  ALLOTMENTS_REPORTS_LIST'
      'WHERE REPORT_TYPE=:RT'
      'ORDER BY SORT_ORDER')
    Left = 280
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'RT'
        ParamType = ptUnknown
      end>
  end
  object ibGetId: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtListReports
    SQL.Strings = (
      'SELECT * FROM ALLOTMENTS_REPORTS_LIST'
      'WHERE NAME=:NAME')
    Left = 312
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'NAME'
        ParamType = ptUnknown
      end>
  end
  object ibqMaxId: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtListReports
    SQL.Strings = (
      'SELECT MAX(ID) AS MAX_ID FROM ALLOTMENTS_REPORTS_LIST')
    Left = 344
    Top = 120
  end
  object ibsAdd: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'INSERT INTO ALLOTMENTS_REPORTS_LIST  '
      '(ID, NAME, KIND, FILEPATH, REPORT_TYPE)'
      'VALUES'
      '(:ID, :NAME, :KIND, :FILEPATH, :REPORT_TYPE)')
    Transaction = ibtListReports
    Left = 280
    Top = 152
  end
  object ibsDel: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'DELETE FROM ALLOTMENTS_REPORTS_LIST'
      'WHERE NAME=:NAME')
    Transaction = ibtListReports
    Left = 312
    Top = 152
  end
  object ibsUpd: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'UPDATE ALLOTMENTS_REPORTS_LIST SET'
      'NAME=:NAME,'
      'FILEPATH=:FILEPATH,'
      'KIND=:KIND'
      'WHERE ID=:ID')
    Transaction = ibtListReports
    Left = 344
    Top = 152
  end
  object ibtListReports: TIBTransaction
    DefaultDatabase = KisAppModule.Database
    Left = 248
    Top = 160
  end
end
