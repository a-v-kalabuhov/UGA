object TinyProgressForm: TTinyProgressForm
  Left = 313
  Top = 172
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1046#1076#1080#1090#1077'...'
  ClientHeight = 111
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 265
    Height = 25
    AutoSize = False
    Caption = 'Label1'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 89
    Width = 265
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 550
    OnTimer = Timer1Timer
    Left = 176
    Top = 56
  end
end
