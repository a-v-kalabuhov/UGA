object PastePointsOptionsDialog: TPastePointsOptionsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1089#1090#1072#1074#1083#1103#1077#1084' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
  ClientHeight = 227
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 60
    Top = 39
    Width = 330
    Height = 51
    AutoSize = False
    Caption = 
      #1042#1089#1077' '#1090#1086#1095#1082#1080' '#1074' '#1082#1086#1085#1090#1091#1088#1077' '#1073#1091#1076#1091#1090' '#1091#1076#1072#1083#1077#1085#1099', '#1072' '#1074#1084#1077#1089#1090#1086' '#1085#1080#1093' '#1074#1089#1090#1072#1074#1083#1077#1085#1099' '#1076#1072#1085#1085#1099#1077 +
      ' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072'.'#13#10#1045#1089#1083#1080' '#1086#1087#1094#1080#1103' '#1085#1077' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1072', '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1073#1091#1092#1077#1088#1072' ' +
      #1086#1084#1077#1085#1072' '#1073#1091#1076#1091#1090' '#1076#1086#1073#1072#1074#1083#1077#1085#1099' '#1082' '#1080#1084#1077#1102#1097#1080#1084#1089#1103' '#1090#1086#1095#1082#1072#1084'.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 60
    Top = 127
    Width = 330
    Height = 51
    AutoSize = False
    Caption = 
      #1045#1089#1083#1080' '#1101#1090#1072' '#1086#1087#1094#1080#1103' '#1085#1077' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1072', '#1090#1086' '#1085#1086#1084#1077#1088#1072' '#1090#1086#1095#1077#1082' '#1073#1091#1076#1091#1090' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072 +
      #1085#1099' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080'.'
    WordWrap = True
  end
  object chbReplacePoints: TCheckBox
    Left = 16
    Top = 16
    Width = 374
    Height = 17
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1080#1084#1077#1102#1097#1080#1077#1089#1103' '#1090#1086#1095#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object chbChangeNumbers: TCheckBox
    Left = 16
    Top = 104
    Width = 374
    Height = 17
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1085#1086#1084#1077#1088#1072' '#1090#1086#1095#1077#1082' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 234
    Top = 194
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 315
    Top = 194
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
