object KisSearchDialog: TKisSearchDialog
  Left = 227
  Top = 301
  BorderStyle = bsDialog
  Caption = #1055#1086#1080#1089#1082
  ClientHeight = 155
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    469
    155)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 190
    Top = 0
    Width = 190
    Height = 155
    Align = alLeft
    Caption = #1059#1089#1083#1086#1074#1080#1103
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 14
      Width = 44
      Height = 13
      Caption = #1058#1072#1073#1083#1080#1094#1099
    end
    object Label2: TLabel
      Left = 7
      Top = 56
      Width = 25
      Height = 13
      Caption = #1055#1086#1083#1103
    end
    object cbTables: TComboBox
      Left = 7
      Top = 28
      Width = 178
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object cbFields: TComboBox
      Left = 7
      Top = 70
      Width = 178
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object RadioButton1: TRadioButton
      Left = 14
      Top = 105
      Width = 166
      Height = 15
      TabOrder = 2
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 14
      Top = 126
      Width = 163
      Height = 15
      TabOrder = 3
      OnClick = RadioButton2Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 190
    Height = 155
    Align = alLeft
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
    TabOrder = 1
    object Label3: TLabel
      Left = 7
      Top = 14
      Width = 14
      Height = 13
      Caption = #1054#1090
    end
    object Label4: TLabel
      Left = 7
      Top = 56
      Width = 14
      Height = 13
      Caption = #1044#1086
    end
    object CheckBox1: TCheckBox
      Left = 14
      Top = 105
      Width = 155
      Height = 15
      TabOrder = 0
    end
    object chbEmptyField: TCheckBox
      Left = 14
      Top = 126
      Width = 170
      Height = 15
      Caption = #1048#1089#1082#1072#1090#1100' '#1087#1091#1089#1090#1086#1077' '#1087#1086#1083#1077
      TabOrder = 1
    end
  end
  object btnOK: TButton
    Left = 386
    Top = 7
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 386
    Top = 38
    Width = 75
    Height = 25
    Hint = #1054#1090#1084#1077#1085#1072' (Ecs)'
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
end
