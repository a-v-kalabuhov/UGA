object frmDefineNew: TfrmDefineNew
  Left = 215
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Define New View'
  ClientHeight = 131
  ClientWidth = 385
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
    Left = 11
    Top = 3
    Width = 53
    Height = 13
    Caption = '&Description'
    FocusControl = Edit1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 115
    Top = 96
    Width = 75
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 195
    Top = 96
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 15
    Top = 20
    Width = 362
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 46
    Width = 181
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
      Width = 177
      Height = 19
      Align = alClient
      Caption = 'LblFirst'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 33
      ExplicitHeight = 13
    end
  end
  object GroupBox2: TGroupBox
    Left = 196
    Top = 46
    Width = 180
    Height = 36
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
      Width = 176
      Height = 19
      Align = alClient
      Caption = 'LblOther'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 40
      ExplicitHeight = 13
    end
  end
end
