object frmDoPrint: TfrmDoPrint
  Left = 0
  Top = 103
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1055#1077#1095#1072#1090#1100
  ClientHeight = 112
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 106
    Height = 13
    Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1077' '#1087#1077#1095#1072#1090#1100' '
  end
  object Label2: TLabel
    Left = 200
    Top = 24
    Width = 63
    Height = 13
    Caption = #1082#1086#1087#1080#1081' '#1087#1083#1072#1085#1072
  end
  object Label3: TLabel
    Left = 16
    Top = 56
    Width = 43
    Height = 13
    Caption = #1055#1088#1080#1085#1090#1077#1088
  end
  object Label4: TLabel
    Left = 72
    Top = 56
    Width = 32
    Height = 13
    Caption = 'Label4'
  end
  object Edit1: TEdit
    Left = 130
    Top = 22
    Width = 41
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = '1'
  end
  object UpDown1: TUpDown
    Left = 171
    Top = 22
    Width = 15
    Height = 21
    Associate = Edit1
    Min = 1
    Max = 6
    Position = 1
    TabOrder = 1
    Wrap = False
  end
  object Button1: TButton
    Left = 8
    Top = 80
    Width = 57
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 248
    Top = 80
    Width = 59
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
