object KisNomenclatureCalc: TKisNomenclatureCalc
  Left = 350
  Top = 407
  BorderStyle = bsDialog
  Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
  ClientHeight = 248
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 261
    Top = 13
    Width = 73
    Height = 13
    Caption = '&'#1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
  end
  object edtNomen: TEdit
    Left = 261
    Top = 28
    Width = 76
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 242
    Height = 87
    Caption = #1058#1086#1095#1082#1072
    TabOrder = 1
    object Label1: TLabel
      Left = 23
      Top = 12
      Width = 6
      Height = 13
      Caption = '&X'
      FocusControl = edtX
    end
    object Label2: TLabel
      Left = 90
      Top = 12
      Width = 6
      Height = 13
      Caption = '&Y'
      FocusControl = edtY
    end
    object edtX: TEdit
      Left = 23
      Top = 28
      Width = 61
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object edtY: TEdit
      Left = 90
      Top = 28
      Width = 61
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object btnShowPoint: TButton
      Left = 157
      Top = 27
      Width = 76
      Height = 24
      Hint = #1055#1086#1089#1095#1080#1090#1072#1090#1100' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1091
      Caption = '&'#1055#1086#1082#1072#1079#1072#1090#1100' >'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnShowPointClick
    end
    object CheckBox1: TCheckBox
      Left = 54
      Top = 57
      Width = 97
      Height = 17
      Caption = #1050#1088#1072#1089#1085#1086#1083#1077#1089#1085#1099#1081
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 96
    Width = 354
    Height = 144
    Caption = #1055#1083#1072#1085#1096#1077#1090
    TabOrder = 2
    object Label5: TLabel
      Left = 90
      Top = 12
      Width = 6
      Height = 13
      Caption = '&Y'
      FocusControl = Edit2
    end
    object Label4: TLabel
      Left = 23
      Top = 12
      Width = 6
      Height = 13
      Caption = '&X'
      FocusControl = Edit1
    end
    object Label6: TLabel
      Left = 8
      Top = 28
      Width = 7
      Height = 13
      Caption = #1040
      FocusControl = Edit1
    end
    object Label7: TLabel
      Left = 8
      Top = 57
      Width = 6
      Height = 13
      Caption = #1041
      FocusControl = Edit1
    end
    object Label8: TLabel
      Left = 8
      Top = 87
      Width = 6
      Height = 13
      Caption = #1042
      FocusControl = Edit1
    end
    object Label9: TLabel
      Left = 8
      Top = 118
      Width = 6
      Height = 13
      Caption = #1043
      FocusControl = Edit1
    end
    object Shape1: TShape
      Left = 263
      Top = 43
      Width = 74
      Height = 74
    end
    object Label10: TLabel
      Left = 239
      Top = 24
      Width = 40
      Height = 13
      Caption = #1090#1086#1095#1082#1072' '#1040
    end
    object Label11: TLabel
      Left = 312
      Top = 24
      Width = 39
      Height = 13
      Caption = #1090#1086#1095#1082#1072' '#1041
    end
    object Label12: TLabel
      Left = 312
      Top = 122
      Width = 39
      Height = 13
      Caption = #1090#1086#1095#1082#1072' '#1042
    end
    object Label13: TLabel
      Left = 239
      Top = 122
      Width = 39
      Height = 13
      Caption = #1090#1086#1095#1082#1072' '#1043
    end
    object Shape2: TShape
      Left = 260
      Top = 41
      Width = 7
      Height = 6
      Shape = stCircle
    end
    object Shape3: TShape
      Left = 333
      Top = 41
      Width = 7
      Height = 6
      Shape = stCircle
    end
    object Shape4: TShape
      Left = 260
      Top = 114
      Width = 7
      Height = 7
      Shape = stCircle
    end
    object Shape5: TShape
      Left = 333
      Top = 114
      Width = 7
      Height = 7
      Shape = stCircle
    end
    object Edit1: TEdit
      Left = 23
      Top = 28
      Width = 61
      Height = 21
      TabOrder = 0
      Text = '---'
    end
    object Edit2: TEdit
      Left = 90
      Top = 28
      Width = 61
      Height = 21
      TabOrder = 1
      Text = '---'
    end
    object Edit3: TEdit
      Left = 23
      Top = 57
      Width = 61
      Height = 21
      TabOrder = 2
      Text = '---'
    end
    object Edit4: TEdit
      Left = 90
      Top = 57
      Width = 61
      Height = 21
      TabOrder = 3
      Text = '---'
    end
    object btnShowCase: TButton
      Left = 158
      Top = 70
      Width = 76
      Height = 24
      Hint = #1055#1086#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1087#1083#1072#1085#1096#1077#1090#1072
      Caption = '&'#1055#1086#1082#1072#1079#1072#1090#1100' <'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnShowCaseClick
    end
    object Edit5: TEdit
      Left = 23
      Top = 87
      Width = 61
      Height = 21
      TabOrder = 5
      Text = '---'
    end
    object Edit6: TEdit
      Left = 90
      Top = 87
      Width = 61
      Height = 21
      TabOrder = 6
      Text = '---'
    end
    object Edit7: TEdit
      Left = 23
      Top = 118
      Width = 61
      Height = 21
      TabOrder = 7
      Text = '---'
    end
    object Edit8: TEdit
      Left = 90
      Top = 118
      Width = 61
      Height = 21
      TabOrder = 8
      Text = '---'
    end
  end
end
