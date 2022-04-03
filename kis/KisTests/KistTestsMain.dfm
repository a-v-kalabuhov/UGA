object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 259
  ClientWidth = 635
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
    Left = 8
    Top = 8
    Width = 233
    Height = 25
    Caption = 'Mid/Mif'
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button1: TButton
    Left = 8
    Top = 64
    Width = 233
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object MidMifDialog: TOpenDialog
    DefaultExt = '.mif'
    Filter = #1060#1072#1081#1083#1099' MapInfo (MIF/MID)|*.mif'
    Title = #1048#1084#1087#1086#1088#1090' MIF/MID'
    Left = 264
    Top = 8
  end
end
