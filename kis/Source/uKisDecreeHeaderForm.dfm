object KisDecreeHeaderForm: TKisDecreeHeaderForm
  Left = 247
  Top = 207
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1079#1072#1075#1086#1083#1086#1074#1082#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
  ClientHeight = 130
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    456
    130)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 373
    Top = 97
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
    ExplicitTop = 86
  end
  object btnOK: TButton
    Left = 292
    Top = 98
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 1
    ExplicitTop = 87
  end
  object mText: TMemo
    Left = 8
    Top = 8
    Width = 440
    Height = 84
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitHeight = 73
  end
end
