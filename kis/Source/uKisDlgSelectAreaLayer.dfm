object KisSelectAleaLayerDialog: TKisSelectAleaLayerDialog
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 112
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    384
    112)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 29
    Height = 13
    Caption = #1057#1083#1086#1080':'
  end
  object OKBtn: TButton
    Left = 220
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 301
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 24
    Width = 368
    Height = 21
    Style = csDropDownList
    DropDownCount = 15
    ItemHeight = 13
    TabOrder = 2
  end
end
