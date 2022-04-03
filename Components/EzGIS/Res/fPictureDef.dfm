object frmPict1: TfrmPict1
  Left = 381
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Picture'
  ClientHeight = 191
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object PaintBox1: TPaintBox
    Left = 3
    Top = 3
    Width = 199
    Height = 181
    OnPaint = PaintBox1Paint
  end
  object OKBtn: TButton
    Left = 210
    Top = 133
    Width = 64
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 210
    Top = 160
    Width = 64
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Button1: TButton
    Left = 207
    Top = 4
    Width = 63
    Height = 22
    Caption = '&Define...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 207
    Top = 30
    Width = 63
    Height = 24
    Caption = '&Clear'
    TabOrder = 3
    OnClick = Button2Click
  end
end
