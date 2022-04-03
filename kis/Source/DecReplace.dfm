object DecReplaceForm: TDecReplaceForm
  Left = 238
  Top = 241
  ActiveControl = btnReplace
  BorderStyle = bsDialog
  Caption = #1047#1072#1084#1077#1085#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
  ClientHeight = 523
  ClientWidth = 730
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 91
    Height = 17
    Caption = '&'#1057#1090#1072#1088#1099#1081' '#1090#1077#1082#1089#1090
  end
  object Label2: TLabel
    Left = 10
    Top = 246
    Width = 83
    Height = 17
    Caption = '&'#1053#1086#1074#1099#1081' '#1090#1077#1082#1089#1090
  end
  object memOld: TMemo
    Left = 10
    Top = 30
    Width = 710
    Height = 208
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object memNew: TMemo
    Left = 10
    Top = 266
    Width = 710
    Height = 208
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object btnReplace: TButton
    Left = 10
    Top = 482
    Width = 92
    Height = 31
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnSkip: TButton
    Left = 118
    Top = 482
    Width = 92
    Height = 31
    Cancel = True
    Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100
    ModalResult = 2
    TabOrder = 3
  end
end
