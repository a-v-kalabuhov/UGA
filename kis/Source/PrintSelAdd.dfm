object PrintSelAddForm: TPrintSelAddForm
  Left = 403
  Top = 288
  Width = 405
  Height = 191
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 176
    Height = 17
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077'  '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
  end
  object Label2: TLabel
    Left = 10
    Top = 59
    Width = 112
    Height = 17
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077'  '#1092#1072#1081#1083#1072':'
  end
  object edNameDoc: TEdit
    Left = 10
    Top = 30
    Width = 375
    Height = 25
    TabOrder = 0
  end
  object edNameFile: TEdit
    Left = 10
    Top = 78
    Width = 277
    Height = 25
    TabOrder = 1
  end
  object Button1: TButton
    Left = 187
    Top = 118
    Width = 92
    Height = 31
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 292
    Top = 118
    Width = 92
    Height = 31
    Caption = 'Ok'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 293
    Top = 71
    Width = 91
    Height = 34
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 2
    OnClick = Button3Click
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'frf'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofEnableSizing]
    Left = 8
    Top = 96
  end
end
