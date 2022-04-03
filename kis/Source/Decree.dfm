object DecreeForm: TDecreeForm
  Left = 360
  Top = 221
  ActiveControl = dbeNumber
  BorderStyle = bsDialog
  Caption = #1053#1086#1088#1084#1072#1090#1080#1074#1085#1099#1081' '#1072#1082#1090
  ClientHeight = 423
  ClientWidth = 574
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
  object Label1: TLabel
    Left = 75
    Top = 8
    Width = 26
    Height = 13
    Caption = '&'#1044#1072#1090#1072
    FocusControl = dbeDate
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = '&'#1053#1086#1084#1077#1088
    FocusControl = dbeNumber
  end
  object Label3: TLabel
    Left = 8
    Top = 151
    Width = 64
    Height = 13
    Caption = '&'#1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
  end
  object Label4: TLabel
    Left = 211
    Top = 8
    Width = 44
    Height = 13
    Caption = #1042'&'#1093'. '#1076#1072#1090#1072
    FocusControl = dbeInt_Date
  end
  object Label5: TLabel
    Left = 143
    Top = 8
    Width = 49
    Height = 13
    Caption = '&'#1042#1093'. '#1085#1086#1084#1077#1088
    FocusControl = dbeInt_Number
  end
  object Label6: TLabel
    Left = 8
    Top = 83
    Width = 53
    Height = 13
    Caption = '&'#1047#1072#1075#1086#1083#1086#1074#1086#1082
  end
  object Label7: TLabel
    Left = 8
    Top = 45
    Width = 45
    Height = 13
    Caption = #1058'&'#1080#1087' '#1072#1082#1090#1072
    FocusControl = dblcDecreeTypes
  end
  object dbeDecreeTypes: TDBEdit
    Left = 8
    Top = 60
    Width = 558
    Height = 21
    DataField = 'DECREE_TYPES_NAME'
    DataSource = dsDecrees
    TabOrder = 11
  end
  object dblcDecreeTypes: TDBLookupComboBox
    Left = 8
    Top = 60
    Width = 558
    Height = 21
    DataField = 'DECREE_TYPES_NAME'
    DataSource = dsDecrees
    DropDownRows = 10
    TabOrder = 4
  end
  object btnOk: TButton
    Left = 8
    Top = 392
    Width = 70
    Height = 23
    Caption = '&'#1054#1050
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 90
    Top = 392
    Width = 71
    Height = 23
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 8
  end
  object dbeDate: TDBEdit
    Left = 75
    Top = 23
    Width = 61
    Height = 21
    DataField = 'DOC_DATE'
    DataSource = dsDecrees
    TabOrder = 1
  end
  object dbeNumber: TDBEdit
    Left = 8
    Top = 23
    Width = 61
    Height = 21
    DataField = 'DOC_NUMBER'
    DataSource = dsDecrees
    TabOrder = 0
  end
  object dbeInt_Date: TDBEdit
    Left = 211
    Top = 23
    Width = 61
    Height = 21
    DataField = 'INT_DATE'
    DataSource = dsDecrees
    TabOrder = 3
  end
  object dbeInt_Number: TDBEdit
    Left = 143
    Top = 23
    Width = 61
    Height = 21
    DataField = 'INT_NUMBER'
    DataSource = dsDecrees
    TabOrder = 2
  end
  object dbmHeader: TDBMemo
    Left = 8
    Top = 98
    Width = 558
    Height = 46
    DataField = 'HEADER'
    DataSource = dsDecrees
    TabOrder = 5
  end
  object dbcbChecked: TDBCheckBox
    Left = 489
    Top = 392
    Width = 77
    Height = 16
    Caption = #1055'&'#1088#1086#1074#1077#1088#1077#1085#1086
    DataField = 'CHECKED'
    DataSource = dsDecrees
    TabOrder = 10
    ValueChecked = '1'
    ValueUnchecked = '0'
  end
  object btnPrint: TButton
    Left = 407
    Top = 392
    Width = 70
    Height = 23
    Caption = '&'#1055#1077#1095#1072#1090#1100
    TabOrder = 9
    OnClick = btnPrintClick
  end
  object dbmContent: TDBMemo
    Left = 8
    Top = 166
    Width = 558
    Height = 219
    DataField = 'CONTENT'
    DataSource = dsDecrees
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object dsDecrees: TDataSource
    Left = 224
    Top = 256
  end
  object PrintDialog: TPrintDialog
    Left = 120
    Top = 216
  end
end
