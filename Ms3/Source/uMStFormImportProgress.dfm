object MStImportProgressForm: TMStImportProgressForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1048#1084#1087#1086#1088#1090
  ClientHeight = 106
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    581
    106)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = #1042#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081':'
  end
  object Label2: TLabel
    Left = 17
    Top = 24
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1086':'
  end
  object Label3: TLabel
    Left = 39
    Top = 40
    Width = 44
    Height = 13
    Alignment = taRightJustify
    Caption = #1054#1096#1080#1073#1086#1082':'
  end
  object Label4: TLabel
    Left = 89
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 89
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Label5'
  end
  object Label6: TLabel
    Left = 89
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Label6'
  end
  object Label7: TLabel
    Left = 200
    Top = 8
    Width = 30
    Height = 13
    Caption = #1060#1072#1081#1083':'
  end
  object Label8: TLabel
    Left = 200
    Top = 24
    Width = 373
    Height = 34
    AutoSize = False
    Caption = 'Label8'
    WordWrap = True
  end
  object lElapsed: TLabel
    Left = 8
    Top = 87
    Width = 43
    Height = 13
    Anchors = [akLeft, akRight]
    Caption = #1055#1088#1086#1096#1083#1086':'
    Visible = False
  end
  object lEstimated: TLabel
    Left = 498
    Top = 87
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = #1042#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081':'
    Visible = False
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 64
    Width = 565
    Height = 17
    TabOrder = 0
  end
end
