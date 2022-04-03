object FindForm: TFindForm
  Left = 352
  Top = 300
  ActiveControl = edtExample
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #1055#1086#1080#1089#1082
  ClientHeight = 151
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 158
    Top = 45
    Width = 26
    Height = 13
    Caption = #1055#1086'&'#1083#1077
    FocusControl = cbColumns
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 89
    Height = 13
    Caption = '&'#1058#1077#1082#1089#1090' '#1076#1083#1103' &'#1087#1086#1080#1089#1082#1072
    FocusControl = edtExample
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 45
    Width = 42
    Height = 13
    Caption = #1058'&'#1072#1073#1083#1080#1094#1072
    FocusControl = cbTable
  end
  object cbColumns: TComboBox
    Left = 158
    Top = 60
    Width = 144
    Height = 21
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 0
    ParentFont = False
    TabOrder = 2
    OnClick = cbColumnsClick
  end
  object edtExample: TEdit
    Left = 8
    Top = 23
    Width = 294
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object OkBtn: TButton
    Left = 8
    Top = 121
    Width = 70
    Height = 23
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 5
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 83
    Top = 121
    Width = 71
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object cbIdentical: TCheckBox
    Left = 8
    Top = 90
    Width = 114
    Height = 16
    Caption = #1055#1086#1083#1085#1086#1077' &'#1089#1086#1074#1087#1072#1076#1077#1085#1080#1077
    TabOrder = 3
  end
  object cbCaseSensitive: TCheckBox
    Left = 158
    Top = 90
    Width = 107
    Height = 16
    Caption = #1057' &'#1091#1095#1077#1090#1086#1084' '#1088#1077#1075#1080#1089#1090#1088#1072
    TabOrder = 4
  end
  object cbTable: TComboBox
    Left = 8
    Top = 60
    Width = 143
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnClick = cbTableClick
    Items.Strings = (
      #1054#1089#1085#1086#1074#1085#1072#1103)
  end
  object FStorage: TJvFormStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'edtExample.Text')
    StoredValues = <>
    Left = 256
    Top = 104
  end
  object Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
    Left = 96
    Top = 16
  end
  object ibqFields: TIBQuery
    Database = KisAppModule.Database
    Transaction = Transaction
    SQL.Strings = (
      'SELECT FIELD_NAME, FIELD_DESCRIPTION, FIELD_TYPE'
      'FROM DICT_FIELDS'
      'WHERE TABLE_NAME=:TABLE_NAME')
    Left = 160
    Top = 16
    ParamData = <
      item
        DataType = ftString
        Name = 'TABLE_NAME'
        ParamType = ptUnknown
      end>
  end
  object ibqTables: TIBQuery
    Database = KisAppModule.Database
    Transaction = Transaction
    SQL.Strings = (
      'SELECT CHILD, DESCRIPTION'
      'FROM GET_CHILD_TABLES(:PARENT)'
      'WHERE DESCRIPTION IS NOT NULL')
    Left = 128
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PARENT'
        ParamType = ptUnknown
      end>
  end
  object ibsSelect: TIBSQL
    Database = KisAppModule.Database
    Transaction = Transaction
    Left = 192
    Top = 16
  end
end
