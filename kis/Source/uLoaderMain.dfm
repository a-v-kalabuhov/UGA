object Form1: TForm1
  Left = 1
  Top = 106
  Width = 799
  Height = 640
  Caption = #1058#1080#1087#1099' '#1086#1073#1098#1077#1082#1090#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    791
    613)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 640
    Top = 8
    Width = 49
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'ID '#1086#1090#1076#1077#1083#1072
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 633
    Height = 609
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Edit1: TEdit
    Left = 640
    Top = 24
    Width = 57
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 1
  end
  object Button1: TButton
    Left = 640
    Top = 88
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 640
    Top = 128
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1047#1072#1083#1080#1090#1100' '#1074' '#1041#1044
    TabOrder = 3
    OnClick = Button2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 640
    Top = 184
    Width = 145
    Height = 105
    Anchors = [akTop, akRight]
    Caption = #1063#1090#1086
    ItemIndex = 0
    Items.Strings = (
      #1090#1080#1087#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      #1090#1080#1087#1072' '#1086#1073#1098#1077#1082#1090#1086#1074
      #1101#1090#1072#1087#1099' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103)
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 640
    Top = 304
    Width = 121
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1072#1088#1099#1077
    TabOrder = 5
  end
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 'srv-bd1:ugatest'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=mupDB01'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    Left = 384
    Top = 56
  end
  object IBTransaction1: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 384
    Top = 16
  end
  object IBSQL1: TIBSQL
    Database = IBDatabase1
    SQL.Strings = (
      'INSERT INTO EXECUTION_PHASES(OFFICES_ID, NAME)'
      'VALUES (:OFFICES_ID, :NAME)')
    Transaction = IBTransaction1
    Left = 384
    Top = 96
  end
  object OpenDialog1: TOpenDialog
    Filter = #1058#1077#1082#1089#1090'|*.txt'
    Left = 704
    Top = 232
  end
end
