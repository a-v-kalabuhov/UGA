object FmImportTT: TFmImportTT
  Left = 174
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Import symbols from a True Type Font'
  ClientHeight = 387
  ClientWidth = 382
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 67
    Height = 13
    Caption = '&Character list :'
    FocusControl = CheckListBox1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 180
    Top = 36
    Width = 100
    Height = 13
    Caption = 'Conversion &Preview :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 180
    Top = 256
    Width = 185
    Height = 52
    Caption = 
      'Click from the list to the left, the character/symbol to add to ' +
      'the symbols file and then press this button to add all.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object PaintBox1: TPaintBox
    Left = 180
    Top = 52
    Width = 197
    Height = 201
    Color = clBtnFace
    ParentColor = False
    OnPaint = PaintBox1Paint
  end
  object OKBtn: TButton
    Left = 312
    Top = 356
    Width = 66
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
  end
  object BtnSelect: TButton
    Left = 8
    Top = 4
    Width = 101
    Height = 25
    Caption = '&Select font...'
    TabOrder = 1
    OnClick = BtnSelectClick
  end
  object CheckListBox1: TCheckListBox
    Left = 7
    Top = 48
    Width = 166
    Height = 333
    ItemHeight = 13
    TabOrder = 2
    OnClick = CheckListBox1Click
  end
  object ChkFlattened: TCheckBox
    Left = 156
    Top = 12
    Width = 221
    Height = 17
    Caption = '&Flattened pat (converted to line segments)'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 3
    Visible = False
  end
  object Button1: TButton
    Left = 220
    Top = 302
    Width = 118
    Height = 21
    Caption = '&Import All Selection'
    TabOrder = 4
    OnClick = Button1Click
  end
  object FontDialog1: TFontDialog
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Arial'
    Font.Style = []
    Options = [fdTrueTypeOnly, fdEffects]
    Left = 116
    Top = 4
  end
end
