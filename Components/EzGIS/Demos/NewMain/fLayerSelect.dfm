object frmSelectLayer: TfrmSelectLayer
  Left = 262
  Top = 125
  BorderStyle = bsDialog
  Caption = 'Select Layer'
  ClientHeight = 266
  ClientWidth = 291
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 39
    Height = 13
    Caption = 'Layers :'
  end
  object OKBtn: TButton
    Left = 70
    Top = 229
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 150
    Top = 229
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object List1: TListBox
    Left = 16
    Top = 32
    Width = 255
    Height = 183
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = OKBtnClick
  end
end
