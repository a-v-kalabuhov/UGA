object frmAddress: TfrmAddress
  Left = 15
  Top = 47
  ActiveControl = Edit1
  BorderStyle = bsToolWindow
  Caption = #1040#1076#1088#1077#1089
  ClientHeight = 95
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 32
    Height = 13
    Caption = #1059#1083#1080#1094#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 23
    Height = 13
    Caption = #1044#1086#1084
  end
  object Edit1: TEdit
    Left = 48
    Top = 13
    Width = 225
    Height = 21
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 48
    Top = 53
    Width = 89
    Height = 21
    TabOrder = 1
    OnKeyPress = Edit2KeyPress
  end
  object Button1: TButton
    Left = 288
    Top = 11
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 288
    Top = 64
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
