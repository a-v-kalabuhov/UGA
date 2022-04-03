object frmAddIndex: TfrmAddIndex
  Left = 252
  Top = 175
  HelpContext = 640
  BorderStyle = bsDialog
  Caption = 'Add index'
  ClientHeight = 267
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 3
    Top = 6
    Width = 52
    Height = 13
    Caption = '&Fields List :'
    FocusControl = List2
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 6
    Top = 183
    Width = 86
    Height = 13
    Caption = '&Expression Index :'
    FocusControl = Edit2
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 6
    Top = 223
    Width = 166
    Height = 13
    Caption = '&Subset condition (filter) expression :'
    FocusControl = Edit3
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 302
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 302
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object List2: TListBox
    Left = 6
    Top = 24
    Width = 160
    Height = 151
    ItemHeight = 13
    TabOrder = 2
    OnClick = List2Click
  end
  object GroupBox1: TGroupBox
    Left = 171
    Top = 99
    Width = 206
    Height = 76
    Caption = '&Options'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Check1: TCheckBox
      Left = 9
      Top = 18
      Width = 154
      Height = 17
      Caption = '&Unique'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Check2: TCheckBox
      Left = 9
      Top = 45
      Width = 151
      Height = 17
      Caption = '&Descending'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object Edit2: TEdit
    Left = 6
    Top = 198
    Width = 375
    Height = 21
    TabOrder = 4
  end
  object Edit3: TEdit
    Left = 6
    Top = 238
    Width = 375
    Height = 21
    TabOrder = 5
  end
end
