object RenumForm: TRenumForm
  Left = 419
  Top = 193
  ActiveControl = edtDelta
  BorderStyle = bsDialog
  Caption = #1053#1086#1084#1077#1088#1072
  ClientHeight = 98
  ClientWidth = 187
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 20
    Width = 113
    Height = 26
    Alignment = taCenter
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1086#1084#1077#1088#1072#13#10#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1090#1086#1095#1077#1082' '#1085#1072
  end
  object edtDelta: TEdit
    Left = 128
    Top = 25
    Width = 31
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object udDelta: TUpDown
    Left = 159
    Top = 25
    Width = 14
    Height = 21
    Associate = edtDelta
    Min = -1000
    Max = 1000
    Position = 1
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 13
    Top = 68
    Width = 71
    Height = 23
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 103
    Top = 68
    Width = 71
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
