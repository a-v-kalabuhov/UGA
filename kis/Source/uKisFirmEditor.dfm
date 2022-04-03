inherited KisFirmEditor: TKisFirmEditor
  Left = 171
  Top = 370
  ActiveControl = edName
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103'/'#1079#1072#1082#1072#1079#1095#1080#1082
  ClientHeight = 267
  ClientWidth = 549
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clNavy
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 555
  ExplicitHeight = 299
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 59
    Top = 242
    Font.Charset = RUSSIAN_CHARSET
    ExplicitLeft = 59
    ExplicitTop = 242
  end
  object HighInstL: TLabel [1]
    Left = 7
    Top = 76
    Width = 139
    Height = 13
    Caption = '&'#1042#1099#1096#1077#1089#1090#1086#1103#1097#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object JAddrL: TLabel [2]
    Left = 7
    Top = 111
    Width = 103
    Height = 13
    Caption = '&'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object BankRecL: TLabel [3]
    Left = 7
    Top = 149
    Width = 117
    Height = 13
    Caption = '&'#1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1088#1077#1082#1074#1080#1079#1080#1090#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object HeadL: TLabel [4]
    Left = 7
    Top = 187
    Width = 73
    Height = 13
    Caption = '&'#1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object TelL: TLabel [5]
    Left = 305
    Top = 186
    Width = 55
    Height = 13
    Caption = #1058'&'#1077#1083#1077#1092#1086#1085#1099' '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object FullNameL: TLabel [6]
    Left = 7
    Top = 0
    Width = 87
    Height = 13
    Caption = '&'#1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ShNameL: TLabel [7]
    Left = 8
    Top = 37
    Width = 93
    Height = 13
    Alignment = taRightJustify
    Caption = '&'#1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  inherited btnOk: TButton
    Left = 385
    Top = 234
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    ParentFont = False
    TabOrder = 7
    ExplicitLeft = 385
    ExplicitTop = 234
  end
  inherited btnCancel: TButton
    Left = 466
    Top = 234
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    ParentFont = False
    TabOrder = 8
    ExplicitLeft = 466
    ExplicitTop = 234
  end
  object edOwnerFirm: TEdit [10]
    Left = 7
    Top = 89
    Width = 536
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 120
    ParentFont = False
    TabOrder = 2
  end
  object edAddress: TEdit [11]
    Left = 7
    Top = 126
    Width = 536
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 120
    ParentFont = False
    TabOrder = 3
  end
  object edBank: TEdit [12]
    Left = 7
    Top = 163
    Width = 536
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 120
    ParentFont = False
    TabOrder = 4
  end
  object edDirector: TEdit [13]
    Left = 7
    Top = 201
    Width = 284
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 50
    ParentFont = False
    TabOrder = 5
  end
  object edPhones: TEdit [14]
    Left = 305
    Top = 201
    Width = 238
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    TabOrder = 6
  end
  object edShortName: TEdit [15]
    Left = 7
    Top = 52
    Width = 536
    Height = 21
    Color = clInfoBk
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 80
    ParentFont = False
    TabOrder = 1
  end
  object edName: TEdit [16]
    Left = 7
    Top = 15
    Width = 536
    Height = 21
    Color = clInfoBk
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 120
    ParentFont = False
    TabOrder = 0
  end
end
