object frmProgressDlg: TfrmProgressDlg
  Left = 256
  Top = 219
  BorderStyle = bsToolWindow
  Caption = 'Operation Status'
  ClientHeight = 105
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DispMsg: TLabel
    Left = 16
    Top = 8
    Width = 323
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 32
    Width = 85
    Height = 13
    Caption = '0 Objects Created'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 16
    Top = 62
    Width = 9
    Height = 29
    Shape = bsLeftLine
  end
  object Bevel2: TBevel
    Left = 96
    Top = 62
    Width = 9
    Height = 29
    Shape = bsLeftLine
  end
  object Bevel3: TBevel
    Left = 176
    Top = 62
    Width = 9
    Height = 29
    Shape = bsLeftLine
  end
  object Bevel4: TBevel
    Left = 255
    Top = 62
    Width = 9
    Height = 29
    Shape = bsLeftLine
  end
  object Bevel5: TBevel
    Left = 335
    Top = 62
    Width = 9
    Height = 29
    Shape = bsLeftLine
  end
  object Label4: TLabel
    Left = 14
    Top = 52
    Width = 14
    Height = 13
    Caption = '0%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 90
    Top = 52
    Width = 20
    Height = 13
    Caption = '25%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 170
    Top = 52
    Width = 20
    Height = 13
    Caption = '50%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 250
    Top = 52
    Width = 20
    Height = 13
    Caption = '75%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 314
    Top = 52
    Width = 26
    Height = 13
    Caption = '100%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 76
    Width = 321
    Height = 16
    Smooth = True
    TabOrder = 0
  end
end
