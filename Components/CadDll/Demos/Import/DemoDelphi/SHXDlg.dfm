object FontSettingsDlg: TFontSettingsDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Font Settings'
  ClientHeight = 224
  ClientWidth = 494
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 414
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
    Left = 414
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object cbUseSHXFonts: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Use SHX fonts'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = cbUseSHXFontsClick
  end
  object gbSHXFonts: TGroupBox
    Left = 8
    Top = 31
    Width = 400
    Height = 162
    Caption = 'SHX fonts'
    TabOrder = 3
    object Label1: TLabel
      Left = 16
      Top = 32
      Width = 62
      Height = 13
      Caption = 'Search path:'
    end
    object Label2: TLabel
      Left = 16
      Top = 72
      Width = 64
      Height = 13
      Caption = 'Default path:'
    end
    object Label3: TLabel
      Left = 16
      Top = 112
      Width = 62
      Height = 13
      Caption = 'Default font:'
    end
    object Edit1: TEdit
      Left = 84
      Top = 30
      Width = 305
      Height = 21
      TabOrder = 0
      Text = 'c:\Program Files\DWG TrueView 2009\Fonts\'
    end
    object Edit2: TEdit
      Left = 84
      Top = 70
      Width = 305
      Height = 21
      TabOrder = 1
      Text = 'c:\Program Files\DWG TrueView 2009\Fonts\'
    end
    object Edit3: TEdit
      Left = 84
      Top = 110
      Width = 305
      Height = 21
      TabOrder = 2
      Text = 'simplex.shx'
    end
  end
end
