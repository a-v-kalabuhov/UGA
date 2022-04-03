object frmPrintProgress: TfrmPrintProgress
  Left = 308
  Top = 223
  Caption = 'Printing status'
  ClientHeight = 135
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 108
    Top = 84
    Width = 61
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object pnlInfo: TPanel
    Left = 11
    Top = 6
    Width = 268
    Height = 50
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object lblPrinter: TLabel
      Left = 0
      Top = 0
      Width = 268
      Height = 13
      Align = alTop
      Caption = 'Searching printers ...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 97
    end
    object lblFileName: TLabel
      Left = 0
      Top = 13
      Width = 268
      Height = 13
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 3
    end
  end
  object Bar1: TProgressBar
    Left = 11
    Top = 63
    Width = 268
    Height = 13
    Step = 1
    TabOrder = 2
  end
end
