object KisCheckForm: TKisCheckForm
  Left = 270
  Top = 231
  Width = 451
  Height = 367
  Caption = 'KisCheckForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object ProgressBar: TProgressBar
    Left = 0
    Top = 325
    Width = 443
    Height = 15
    Align = alBottom
    TabOrder = 0
  end
  object mResult: TMemo
    Left = 0
    Top = 0
    Width = 443
    Height = 325
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'mResult')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
