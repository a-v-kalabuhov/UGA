object MStMissingLayersDialog: TMStMissingLayersDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1090' '#1089#1083#1086#1080
  ClientHeight = 365
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 121
    Height = 33
    AutoSize = False
    Caption = #1042#1089#1077#1075#1086' '#1085#1072#1081#1076#1077#1085#1086' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1076#1083#1103' '#1080#1084#1087#1086#1088#1090#1072':'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 135
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 8
    Top = 54
    Width = 55
    Height = 13
    Caption = #1053#1077#1090' '#1089#1083#1086#1105#1074':'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 70
    Width = 363
    Height = 288
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 296
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 296
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    Visible = False
  end
end
