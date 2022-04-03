object KisProgressForm: TKisProgressForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 63
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 329
    Height = 47
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
    Layout = tlCenter
  end
  object Image1: TImage
    Left = 351
    Top = 8
    Width = 47
    Height = 47
  end
  object Timer1: TTimer
    Left = 456
    Top = 8
  end
  object ImageList1: TImageList
    Left = 296
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer2Timer
    Left = 256
    Top = 16
  end
end
