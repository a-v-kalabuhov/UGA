inherited KisLicensedOrgSROPeriodEditor: TKisLicensedOrgSROPeriodEditor
  Caption = 'KisLicensedOrgSROPeriodEditor'
  ClientHeight = 111
  ClientWidth = 446
  Position = poMainFormCenter
  ExplicitWidth = 452
  ExplicitHeight = 139
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 24
    Top = 83
    Margins.Bottom = 0
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 24
    ExplicitTop = 111
  end
  object lSROName: TLabel [1]
    Left = 8
    Top = 11
    Width = 72
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1057#1056#1054
  end
  object lPeriodStartDate: TLabel [2]
    Left = 15
    Top = 41
    Width = 65
    Height = 13
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
  end
  object lPeriodEndDate: TLabel [3]
    Left = 229
    Top = 41
    Width = 83
    Height = 13
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
  end
  inherited btnOk: TButton
    Left = 282
    Top = 78
    Anchors = [akRight, akBottom]
    TabOrder = 3
    ExplicitLeft = 282
    ExplicitTop = 78
  end
  inherited btnCancel: TButton
    Left = 363
    Top = 78
    Anchors = [akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 363
    ExplicitTop = 78
  end
  object edSROName: TEdit [6]
    Left = 86
    Top = 8
    Width = 353
    Height = 21
    Color = clInfoBk
    TabOrder = 0
    Text = 'edSROName'
  end
  object edPeriodStartDate: TEdit [7]
    Left = 86
    Top = 38
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edPeriodStartDate'
  end
  object edPeriodEndDate: TEdit [8]
    Left = 318
    Top = 38
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edPeriodEndDate'
  end
  inherited Alert: TJvDesktopAlert
    Left = 16
  end
end
