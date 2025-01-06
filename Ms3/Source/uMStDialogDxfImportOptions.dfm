object MStDxfImportOptionsDialog: TMStDxfImportOptionsDialog
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1090' '#1089#1083#1086#1080
  ClientHeight = 328
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 69
    Top = 8
    Width = 128
    Height = 13
    Alignment = taRightJustify
    Caption = #1042#1089#1077#1075#1086' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1074' '#1092#1072#1081#1083#1077':'
  end
  object Label2: TLabel
    Left = 212
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 8
    Top = 112
    Width = 55
    Height = 13
    Caption = #1053#1077#1090' '#1089#1083#1086#1105#1074':'
  end
  object Label4: TLabel
    Left = 212
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label5: TLabel
    Left = 29
    Top = 24
    Width = 168
    Height = 13
    Alignment = taRightJustify
    Caption = #1041#1091#1076#1077#1090' '#1080#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1085#1086' '#1086#1073#1098#1077#1082#1090#1086#1074':'
  end
  object Label6: TLabel
    Left = 212
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label7: TLabel
    Left = 8
    Top = 40
    Width = 189
    Height = 13
    Alignment = taRightJustify
    Caption = #1041#1091#1076#1077#1090' '#1080#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1085#1086' '#1086#1089#1077#1074#1099#1093' '#1083#1080#1085#1080#1081':'
  end
  object lMissingLayers: TLabel
    Left = 70
    Top = 112
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 128
    Width = 363
    Height = 190
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 296
    Top = 8
    Width = 75
    Height = 25
    Caption = #1048#1084#1087#1086#1088#1090
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 296
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 29
    Top = 72
    Width = 76
    Height = 17
    Caption = #1052#1057#1050' 36'
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 124
    Top = 72
    Width = 161
    Height = 17
    Caption = #1055#1086#1084#1077#1085#1103#1090#1100' '#1084#1077#1089#1090#1072#1084#1080' X '#1080' Y'
    TabOrder = 4
    OnClick = CheckBox2Click
  end
end
