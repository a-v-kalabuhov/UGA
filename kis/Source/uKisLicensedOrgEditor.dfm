inherited KisLicensedOrgEditor: TKisLicensedOrgEditor
  Left = 210
  Top = 190
  Caption = ''
  ClientHeight = 238
  ClientWidth = 385
  Position = poMainFormCenter
  ExplicitWidth = 391
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 32
    Top = 202
    Width = 142
    Height = 26
    Caption = #1046#1077#1083#1090#1099#1077' '#1087#1086#1083#1103' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#13#10#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103'!'
    ExplicitLeft = 32
    ExplicitTop = 202
    ExplicitWidth = 142
    ExplicitHeight = 26
  end
  object Label1: TLabel [1]
    Left = 6
    Top = 6
    Width = 73
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object Label2: TLabel [2]
    Left = 6
    Top = 50
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
  end
  object Label3: TLabel [3]
    Left = 6
    Top = 96
    Width = 166
    Height = 13
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1083#1080#1094#1077#1085#1079#1080#1080
  end
  object Label4: TLabel [4]
    Left = 190
    Top = 96
    Width = 184
    Height = 13
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1083#1080#1094#1077#1085#1079#1080#1080
  end
  object Label5: TLabel [5]
    Left = 6
    Top = 144
    Width = 245
    Height = 13
    Caption = #1060'.'#1048'.'#1054'. '#1095#1077#1083#1086#1074#1077#1082#1072', '#1082#1086#1090#1086#1088#1099#1081' '#1073#1077#1088#1077#1090' '#1082#1072#1088#1090#1084#1072#1090#1077#1088#1080#1072#1083
  end
  inherited btnOk: TButton
    Left = 221
    Top = 205
    TabOrder = 4
    ExplicitLeft = 221
    ExplicitTop = 205
  end
  inherited btnCancel: TButton
    Left = 302
    Top = 205
    Default = True
    TabOrder = 5
    ExplicitLeft = 302
    ExplicitTop = 205
  end
  object edName: TEdit [8]
    Left = 6
    Top = 20
    Width = 374
    Height = 21
    Color = clInfoBk
    MaxLength = 255
    TabOrder = 0
  end
  object edAddress: TEdit [9]
    Left = 6
    Top = 66
    Width = 374
    Height = 21
    MaxLength = 255
    TabOrder = 1
  end
  object edStartDate: TEdit [10]
    Left = 6
    Top = 114
    Width = 61
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 2
  end
  object edEndDate: TEdit [11]
    Left = 190
    Top = 114
    Width = 61
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 3
  end
  object edMapperFio: TEdit [12]
    Left = 6
    Top = 160
    Width = 374
    Height = 21
    MaxLength = 100
    TabOrder = 6
  end
end
