object frmMemoEditor: TfrmMemoEditor
  Left = 188
  Top = 100
  BorderStyle = bsDialog
  Caption = 'String List Editor'
  ClientHeight = 311
  ClientWidth = 427
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 405
    Height = 269
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object OKBtn: TButton
    Left = 136
    Top = 280
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 216
    Top = 280
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 16
    Top = 28
    Width = 385
    Height = 241
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
    OnChange = Memo1Change
  end
end
