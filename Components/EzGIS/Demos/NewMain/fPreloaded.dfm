object frmPreloaded: TfrmPreloaded
  Left = 225
  Top = 67
  BorderStyle = bsDialog
  Caption = 'Preloaded Images and Blocks'
  ClientHeight = 488
  ClientWidth = 412
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 383
    Height = 39
    Caption = 
      'Most of images are loaded from disk when needed to display. In o' +
      'rder to speed up the display time, some images can be loaded to ' +
      'memory. Check here the images you want loaded.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 13
    Top = 59
    Width = 315
    Height = 13
    Caption = 'In EzGIS, the images must be located on a common subdirectory :'
  end
  object LblCommonSubDir: TLabel
    Left = 13
    Top = 75
    Width = 85
    Height = 13
    Caption = 'LblCommonSubDir'
  end
  object Label3: TLabel
    Left = 13
    Top = 94
    Width = 209
    Height = 13
    Caption = 'Preloaded images for TEzPictureRef Entity :'
  end
  object Label4: TLabel
    Left = 13
    Top = 218
    Width = 220
    Height = 13
    Caption = 'Preloaded images for TEzBandsBitmap Entity :'
  end
  object Label5: TLabel
    Left = 14
    Top = 337
    Width = 87
    Height = 13
    Caption = 'Preloaded Blocks :'
  end
  object OKBtn: TButton
    Left = 124
    Top = 458
    Width = 76
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 205
    Top = 458
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Check1: TCheckBox
    Left = 241
    Top = 94
    Width = 59
    Height = 14
    Caption = '&Enabled'
    TabOrder = 2
  end
  object Check2: TCheckBox
    Left = 244
    Top = 218
    Width = 59
    Height = 14
    Caption = '&Enabled'
    TabOrder = 3
  end
  object Check3: TCheckBox
    Left = 114
    Top = 338
    Width = 59
    Height = 14
    Caption = '&Enabled'
    TabOrder = 4
  end
  object CheckList1: TCheckListBox
    Left = 13
    Top = 111
    Width = 381
    Height = 98
    ItemHeight = 20
    Style = lbOwnerDrawFixed
    TabOrder = 5
    OnClick = CheckList1Click
    OnDrawItem = CheckList1DrawItem
  end
  object CheckList2: TCheckListBox
    Left = 13
    Top = 234
    Width = 381
    Height = 98
    ItemHeight = 20
    Style = lbOwnerDrawFixed
    TabOrder = 6
    OnClick = CheckList2Click
    OnDrawItem = CheckList1DrawItem
  end
  object CheckList3: TCheckListBox
    Left = 14
    Top = 353
    Width = 381
    Height = 99
    ItemHeight = 20
    Style = lbOwnerDrawFixed
    TabOrder = 7
    OnClick = CheckList3Click
    OnDrawItem = CheckList1DrawItem
  end
end
