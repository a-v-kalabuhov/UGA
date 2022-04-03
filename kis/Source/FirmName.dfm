object FirmNameForm: TFirmNameForm
  Left = 291
  Top = 342
  ActiveControl = dbeType
  BorderStyle = bsDialog
  Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103'/'#1095#1072#1089#1090#1085#1086#1077' '#1083#1080#1094#1086
  ClientHeight = 151
  ClientWidth = 513
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 18
    Height = 13
    Caption = #1058#1080#1087
  end
  object Label2: TLabel
    Left = 8
    Top = 53
    Width = 73
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object dbeName: TDBEdit
    Left = 8
    Top = 68
    Width = 497
    Height = 25
    DataField = 'NAME'
    TabOrder = 1
  end
  object btnSelect: TButton
    Left = 8
    Top = 90
    Width = 70
    Height = 24
    Caption = #1042'&'#1099#1073#1088#1072#1090#1100
    TabOrder = 2
    OnClick = btnSelectClick
  end
  object btnClear: TButton
    Left = 158
    Top = 90
    Width = 71
    Height = 24
    Caption = #1054'&'#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 3
    OnClick = btnClearClick
  end
  object btnDetail: TButton
    Left = 83
    Top = 90
    Width = 71
    Height = 24
    Caption = #1055#1086'&'#1076#1088#1086#1073#1085#1086
    TabOrder = 4
    OnClick = btnDetailClick
  end
  object btnOk: TButton
    Left = 359
    Top = 121
    Width = 71
    Height = 23
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 5
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 434
    Top = 121
    Width = 71
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object dbeType: TDBLookupComboBox
    Left = 8
    Top = 23
    Width = 498
    Height = 21
    DataField = 'FIRM_TYPE_NAME'
    TabOrder = 0
  end
end
