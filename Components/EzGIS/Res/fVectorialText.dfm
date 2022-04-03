object frmVectorialText: TfrmVectorialText
  Left = 195
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Vectorial Text parameters'
  ClientHeight = 177
  ClientWidth = 509
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 216
    Top = 130
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = 'Inter&Line Spacing :'
  end
  object Label4: TLabel
    Left = 212
    Top = 153
    Width = 94
    Height = 13
    Alignment = taRightJustify
    Caption = 'Inter&Char Spacing :'
  end
  object Label1: TLabel
    Left = 400
    Top = 130
    Width = 40
    Height = 13
    Caption = 'X Height'
  end
  object Label2: TLabel
    Left = 400
    Top = 153
    Width = 40
    Height = 13
    Caption = 'X Height'
  end
  object Label5: TLabel
    Left = 246
    Top = 107
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Line Height :'
  end
  object OKBtn: TButton
    Left = 427
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object CancelBtn: TButton
    Left = 427
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object Memo1: TMemo
    Left = 7
    Top = 7
    Width = 413
    Height = 85
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object rgb1: TRadioGroup
    Left = 7
    Top = 98
    Width = 98
    Height = 69
    Caption = '&Horizontal Align'
    ItemIndex = 0
    Items.Strings = (
      '&Left'
      '&Center'
      '&Right')
    TabOrder = 1
  end
  object rgb2: TRadioGroup
    Left = 111
    Top = 98
    Width = 98
    Height = 69
    Caption = '&Vertical Align'
    ItemIndex = 0
    Items.Strings = (
      '&Top'
      '&Center'
      '&Bottom')
    TabOrder = 2
  end
  object NumEd2: TEdit
    Left = 309
    Top = 150
    Width = 88
    Height = 21
    TabOrder = 4
  end
  object NumEd1: TEdit
    Left = 309
    Top = 127
    Width = 88
    Height = 21
    TabOrder = 5
  end
  object NumEd3: TEdit
    Left = 309
    Top = 104
    Width = 88
    Height = 21
    TabOrder = 3
  end
end
