object mstDialogPointSize: TmstDialogPointSize
  Left = 359
  Top = 174
  BorderStyle = bsDialog
  Caption = #1056#1072#1079#1084#1077#1088' '#1090#1086#1095#1082#1080
  ClientHeight = 87
  ClientWidth = 147
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 18
    Width = 12
    Height = 13
    Caption = #1084#1084
  end
  object edSize: TEdit
    Left = 48
    Top = 16
    Width = 33
    Height = 21
    MaxLength = 4
    TabOrder = 0
    Text = '1'
    OnChange = edSizeChange
  end
  object btnOK: TButton
    Left = 8
    Top = 56
    Width = 57
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 80
    Top = 56
    Width = 57
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
