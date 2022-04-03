object ContourForm: TContourForm
  Left = 300
  Top = 353
  ActiveControl = edtNumber
  BorderStyle = bsDialog
  Caption = #1050#1086#1085#1090#1091#1088
  ClientHeight = 219
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    253
    219)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 7
    Width = 31
    Height = 13
    Caption = '&'#1053#1086#1084#1077#1088
    FocusControl = edtNumber
  end
  object Label2: TLabel
    Left = 66
    Top = 7
    Width = 31
    Height = 13
    Caption = '&'#1053#1086#1084#1077#1088
    FocusControl = edtNumber
  end
  object Label3: TLabel
    Left = 66
    Top = 48
    Width = 26
    Height = 13
    Caption = #1062#1074#1077#1090
    FocusControl = edtNumber
  end
  object btnOk: TButton
    Left = 97
    Top = 188
    Width = 71
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 7
    ExplicitTop = 144
  end
  object btnCancel: TButton
    Left = 174
    Top = 188
    Width = 71
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 8
    ExplicitTop = 144
  end
  object edtNumber: TEdit
    Left = 8
    Top = 23
    Width = 31
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object udNumber: TUpDown
    Left = 39
    Top = 23
    Width = 16
    Height = 21
    Associate = edtNumber
    Min = 1
    Max = 99
    Position = 1
    TabOrder = 1
  end
  object rgPositive: TRadioGroup
    Left = 8
    Top = 130
    Width = 237
    Height = 52
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1047#1085#1072#1082
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      #1054#1090#1088#1080#1094#1072#1090#1077#1083#1100#1085#1099#1081
      #1055#1086#1083#1086#1078#1080#1090#1077#1083#1100#1085#1099#1081)
    TabOrder = 6
    ExplicitTop = 86
  end
  object cbEnabled: TCheckBox
    Left = 8
    Top = 96
    Width = 53
    Height = 15
    Caption = '&'#1042#1080#1076#1077#1085
    TabOrder = 4
  end
  object chbClosed: TCheckBox
    Left = 87
    Top = 99
    Width = 138
    Height = 15
    Caption = #1047#1072#1084#1082#1085#1091#1090#1099#1081
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 66
    Top = 23
    Width = 179
    Height = 21
    MaxLength = 256
    TabOrder = 2
    Text = #1050#1086#1085#1090#1091#1088
  end
  object ColorList1: TJvColorComboBox
    Left = 66
    Top = 66
    Width = 179
    Height = 20
    ColorDialogText = 'Custom...'
    DroppedDownWidth = 179
    NewColorText = 'Custom'
    Options = [coText, coStdColors, coCustomColors]
    TabOrder = 3
  end
end
