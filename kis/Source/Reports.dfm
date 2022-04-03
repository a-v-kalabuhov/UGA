object ReportsForm: TReportsForm
  Left = 378
  Top = 276
  ActiveControl = lbReports
  BorderStyle = bsDialog
  Caption = #1054#1090#1095#1077#1090#1099
  ClientHeight = 212
  ClientWidth = 385
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
  object lbReports: TListBox
    Left = 8
    Top = 8
    Width = 294
    Height = 134
    IntegralHeight = True
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = btnEditClick
  end
  object btnAdd: TButton
    Left = 309
    Top = 8
    Width = 70
    Height = 23
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 309
    Top = 37
    Width = 70
    Height = 24
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object btnEdit: TButton
    Left = 309
    Top = 68
    Width = 70
    Height = 23
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 3
    OnClick = btnEditClick
  end
  object btnOk: TButton
    Left = 8
    Top = 180
    Width = 70
    Height = 24
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 83
    Top = 180
    Width = 71
    Height = 24
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
end
