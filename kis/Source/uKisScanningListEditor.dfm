inherited KisScanningListEditor: TKisScanningListEditor
  Left = 443
  Top = 218
  Caption = 'KisScanningListEditor'
  ClientHeight = 264
  ClientWidth = 289
  Position = poDesktopCenter
  OnShow = FormShow
  ExplicitWidth = 295
  ExplicitHeight = 296
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 31
    Top = 213
    ExplicitLeft = 31
    ExplicitTop = 213
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 11
    Width = 71
    Height = 26
    Caption = #1044#1072#1090#1072' '#13#10#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
    FocusControl = edDateOfScan
  end
  object Label2: TLabel [2]
    Left = 88
    Top = 24
    Width = 68
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
    FocusControl = edOrderNumber
  end
  object Label3: TLabel [3]
    Left = 8
    Top = 72
    Width = 33
    Height = 13
    Caption = #1054#1090#1076#1077#1083
    FocusControl = cbOffice
  end
  object Label4: TLabel [4]
    Left = 8
    Top = 120
    Width = 66
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
    FocusControl = cbExecutor
  end
  object Label5: TLabel [5]
    Left = 8
    Top = 168
    Width = 60
    Height = 13
    Caption = #1042#1080#1076' '#1088#1072#1073#1086#1090#1099
    FocusControl = edWorkType
  end
  inherited btnOk: TButton
    Left = 125
    Top = 232
    TabOrder = 5
    ExplicitLeft = 125
    ExplicitTop = 232
  end
  inherited btnCancel: TButton
    Left = 206
    Top = 232
    TabOrder = 6
    ExplicitLeft = 206
    ExplicitTop = 232
  end
  object edDateOfScan: TEdit [8]
    Left = 8
    Top = 40
    Width = 65
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 0
  end
  object edOrderNumber: TEdit [9]
    Left = 88
    Top = 40
    Width = 65
    Height = 21
    Color = clInfoBk
    TabOrder = 1
    Text = 'edOrderNumber'
  end
  object cbOffice: TComboBox [10]
    Left = 8
    Top = 88
    Width = 273
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 0
    TabOrder = 2
  end
  object cbExecutor: TComboBox [11]
    Left = 8
    Top = 136
    Width = 273
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 0
    TabOrder = 3
  end
  object edWorkType: TEdit [12]
    Left = 8
    Top = 184
    Width = 273
    Height = 21
    Color = clInfoBk
    TabOrder = 4
    Text = 'edWorkType'
  end
end
