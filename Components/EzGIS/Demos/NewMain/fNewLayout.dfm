object frmNewLayout: TfrmNewLayout
  Left = 205
  Top = 194
  BorderStyle = bsDialog
  Caption = 'New Design'
  ClientHeight = 137
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 53
    Top = 20
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = '&Paper Units :'
  end
  object Label2: TLabel
    Left = 58
    Top = 40
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = 'P&aper Size :'
  end
  object OKBtn: TButton
    Left = 79
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 159
    Top = 104
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cboUnits: TComboBox
    Left = 120
    Top = 16
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'Inches'
      'Millimeters')
  end
  object check1: TCheckBox
    Left = 20
    Top = 68
    Width = 114
    Height = 17
    Alignment = taLeftJustify
    Caption = '&Auto Place Map :'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cboSize: TComboBox
    Left = 120
    Top = 40
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'Same as Printer'
      'Letter - 8.5 x 11'
      'Legal - 8.5 x 14'
      'Ledger - 11 x 17'
      'Statement - 5.5 x 8.5'
      'Executive - 7.25 x 10.5'
      'A3 - 11.69 x 16.54'
      'A4 - 8.27 x 11.69'
      'A5 - 5.83 x 8.27'
      'B3 - 14.33 x 20.28'
      'B4 - 10.12 x 14.33'
      'B5 - 7.17 x 10.12'
      'Folio - 8.5 x 13'
      'Quarto - 8.47 x 10.83'
      '10 x 14'
      '11 x 17'
      'Csize - 17 x 22'
      'USStdFanfold - 11 x 14.88'
      'GermanStdFanfold - 8.5 x 12'
      'GermanLegalFanfold - 8.5 x 13'
      '6 x 8'
      'Foolscap - 13.5 x 17'
      'LetterPlus - 9 x 13.3'
      'A4Plus - 8.77 x 14')
  end
end
