object mstMPCertifDialog: TmstMPCertifDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1087#1088#1072#1074#1082#1072
  ClientHeight = 74
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 13
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1086#1084#1077#1088':'
  end
  object Label2: TLabel
    Left = 25
    Top = 44
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1072#1090#1072':'
  end
  object edNumber: TEdit
    Left = 61
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edNumber'
  end
  object edDate: TEdit
    Left = 61
    Top = 41
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edDate'
  end
  object btnOK: TButton
    Left = 204
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 204
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
