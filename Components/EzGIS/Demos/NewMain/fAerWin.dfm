object frmViewDesc: TfrmViewDesc
  Left = 293
  Top = 150
  BorderStyle = bsDialog
  Caption = 'View Description'
  ClientHeight = 244
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 13
    Width = 60
    Height = 13
    Caption = 'View Name :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LblViewName: TLabel
    Left = 86
    Top = 13
    Width = 65
    Height = 13
    Caption = 'LblViewName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 15
    Top = 166
    Width = 34
    Height = 13
    Caption = 'Width :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 11
    Top = 185
    Width = 37
    Height = 13
    Caption = 'Height :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LblWidth: TLabel
    Left = 50
    Top = 166
    Width = 42
    Height = 13
    Caption = 'LblWidth'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LblHeight: TLabel
    Left = 50
    Top = 185
    Width = 45
    Height = 13
    Caption = 'LblHeight'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 72
    Top = 213
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 15
    Top = 36
    Width = 191
    Height = 36
    Caption = '&First Corner'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object LblFirst: TLabel
      Left = 2
      Top = 15
      Width = 187
      Height = 19
      Align = alClient
      Caption = 'LblFirst'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 33
      ExplicitHeight = 13
    end
  end
  object GroupBox2: TGroupBox
    Left = 15
    Top = 78
    Width = 191
    Height = 37
    Caption = '&Other Corner'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object LblOther: TLabel
      Left = 2
      Top = 15
      Width = 187
      Height = 20
      Align = alClient
      AutoSize = False
      Caption = 'LblOther'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 188
      ExplicitHeight = 21
    end
  end
  object GroupBox3: TGroupBox
    Left = 15
    Top = 120
    Width = 191
    Height = 37
    Caption = 'MidPoint'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object LblMid: TLabel
      Left = 2
      Top = 15
      Width = 187
      Height = 20
      Align = alClient
      AutoSize = False
      Caption = 'LblMid'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 188
    end
  end
end
