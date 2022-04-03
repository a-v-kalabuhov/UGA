object frmDGNParams: TfrmDGNParams
  Left = 269
  Top = 203
  BorderStyle = bsDialog
  Caption = 'DGN Parameters'
  ClientHeight = 271
  ClientWidth = 289
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 272
    Height = 220
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 13
    Width = 81
    Height = 13
    Caption = '&Included Levels :'
  end
  object OKBtn: TButton
    Left = 67
    Top = 239
    Width = 76
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 148
    Top = 239
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ChkList1: TCheckListBox
    Left = 13
    Top = 26
    Width = 105
    Height = 176
    ItemHeight = 13
    TabOrder = 2
  end
  object chkTrueType: TCheckBox
    Left = 130
    Top = 26
    Width = 105
    Height = 14
    Caption = '&Use True Type'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object chkDefColor: TCheckBox
    Left = 130
    Top = 46
    Width = 141
    Height = 13
    Caption = 'Use &Default Color Table'
    TabOrder = 4
  end
  object chkMemLoaded: TCheckBox
    Left = 130
    Top = 62
    Width = 141
    Height = 14
    Caption = '&Memory Loaded'
    TabOrder = 5
  end
  object Button1: TButton
    Tag = 1
    Left = 13
    Top = 205
    Width = 50
    Height = 20
    Caption = '&All'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 68
    Top = 205
    Width = 50
    Height = 20
    Caption = '&None'
    TabOrder = 7
    OnClick = Button1Click
  end
end
