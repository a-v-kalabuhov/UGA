object MissingScansForm: TMissingScansForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1090' '#1087#1083#1072#1085#1096#1077#1090#1099
  ClientHeight = 356
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    401
    356)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 51
    Height = 13
    Caption = #1042' '#1085#1072#1083#1080#1095#1080#1080
  end
  object Label2: TLabel
    Left = 135
    Top = 32
    Width = 69
    Height = 13
    Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1090
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 98
    Top = 32
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 225
    Top = 32
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label5'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 51
    Width = 121
    Height = 297
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object ListBox2: TListBox
    Left = 135
    Top = 51
    Width = 121
    Height = 297
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 262
    Top = 51
    Width = 131
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1079#1072#1103#1074#1082#1091
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 262
    Top = 82
    Width = 131
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1079#1072#1103#1074#1082#1091
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 262
    Top = 323
    Width = 131
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = #1053#1080#1095#1077#1075#1086' '#1085#1077' '#1076#1077#1083#1072#1090#1100
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 262
    Top = 113
    Width = 131
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = #1042#1099#1076#1072#1090#1100' '#1073#1077#1079' '#1074#1086#1079#1074#1088#1072#1090#1072
    TabOrder = 4
    OnClick = Button4Click
  end
end
