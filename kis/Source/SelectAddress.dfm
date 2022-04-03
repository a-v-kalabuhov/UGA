object frmSelectAddress: TfrmSelectAddress
  Left = 301
  Top = 389
  BorderStyle = bsDialog
  Caption = #1040#1076#1088#1077#1089
  ClientHeight = 121
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button3: TButton
    Left = 5
    Top = 90
    Width = 71
    Height = 24
    Caption = #1054#1050
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 331
    Top = 90
    Width = 71
    Height = 24
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 407
    Height = 84
    Align = alTop
    TabOrder = 2
    object Button1: TButton
      Left = 8
      Top = 45
      Width = 91
      Height = 24
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1091#1083#1080#1094#1091
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 15
      Width = 392
      Height = 25
      MaxLength = 300
      TabOrder = 1
    end
  end
end
