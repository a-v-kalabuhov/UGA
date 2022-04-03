object mstAddressForm: TmstAddressForm
  Left = 71
  Top = 102
  ActiveControl = edStreet
  BorderStyle = bsDialog
  Caption = #1040#1076#1088#1077#1089
  ClientHeight = 105
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 9
    Top = 18
    Width = 30
    Height = 14
    Caption = #1059#1083#1080#1094#1072
  end
  object Label2: TLabel
    Left = 9
    Top = 46
    Width = 22
    Height = 14
    Caption = #1044#1086#1084
  end
  object edStreet: TEdit
    Left = 52
    Top = 14
    Width = 242
    Height = 22
    Hint = 
      #1042#1074#1086#1076#1080#1090#1089#1103' '#1090#1086#1083#1100#1082#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091#1083#1080#1094#1099'.'#13#10#1053#1072#1087#1088#1080#1084#1077#1088', '#1076#1083#1103' '#1087#1088#1086#1089#1087#1077#1082#1090#1072' '#1056#1077#1074 +
      #1086#1083#1102#1094#1080#1080#13#10#1085#1072#1076#1086' '#1074#1074#1077#1089#1090#1080' "'#1056#1077#1074#1086#1083#1102#1094#1080#1080'".'
    Color = clInfoBk
    MaxLength = 30
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnKeyPress = edStreetKeyPress
  end
  object edBuilding: TEdit
    Left = 52
    Top = 43
    Width = 37
    Height = 22
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 1
    OnKeyPress = edBuildingKeyPress
  end
  object Button1: TButton
    Left = 145
    Top = 74
    Width = 72
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 225
    Top = 74
    Width = 69
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
