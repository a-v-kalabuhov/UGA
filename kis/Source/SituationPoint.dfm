object SituationPointForm: TSituationPointForm
  Left = 435
  Top = 393
  ActiveControl = dbeName
  BorderStyle = bsDialog
  Caption = #1058#1086#1095#1082#1072
  ClientHeight = 137
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 60
    Height = 13
    Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077
  end
  object Label4: TLabel
    Left = 88
    Top = 8
    Width = 160
    Height = 13
    Caption = #1059#1075#1086#1083' ('#1083#1077#1074#1099#1077' '#1091#1075#1083#1099'), ('#1075#1088#1072#1076'., '#1084#1080#1085'.)'
  end
  object Label5: TLabel
    Left = 88
    Top = 56
    Width = 38
    Height = 13
    Caption = #1042#1099#1089#1086#1090#1072
  end
  object Label6: TLabel
    Left = 168
    Top = 56
    Width = 70
    Height = 13
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 50
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object btnOk: TButton
    Left = 59
    Top = 104
    Width = 75
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 6
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 179
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object edtDegree: TEdit
    Left = 88
    Top = 24
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object edtMinute: TEdit
    Left = 168
    Top = 24
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object dbeLength: TDBEdit
    Left = 8
    Top = 72
    Width = 73
    Height = 21
    DataField = 'POINT_LENGTH'
    TabOrder = 3
  end
  object dbeHeight: TDBEdit
    Left = 88
    Top = 72
    Width = 73
    Height = 21
    DataField = 'HEIGHT'
    TabOrder = 4
  end
  object dbeComment: TDBEdit
    Left = 168
    Top = 72
    Width = 137
    Height = 21
    DataField = 'COMMENT'
    TabOrder = 5
  end
  object dbeName: TDBEdit
    Left = 8
    Top = 24
    Width = 73
    Height = 21
    DataField = 'NAME'
    TabOrder = 0
  end
end
