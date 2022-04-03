object frmEasyThematic: TfrmEasyThematic
  Left = 306
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Easy Thematic Creation'
  ClientHeight = 257
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 10
    Top = 173
    Width = 317
    Height = 49
  end
  object Label1: TLabel
    Left = 46
    Top = 176
    Width = 116
    Height = 13
    Caption = 'Range Thematic options'
  end
  object Label2: TLabel
    Left = 21
    Top = 191
    Width = 22
    Height = 13
    Caption = 'Start'
  end
  object Label10: TLabel
    Left = 268
    Top = 177
    Width = 37
    Height = 13
    Caption = 'Number'
  end
  object Label11: TLabel
    Left = 8
    Top = 10
    Width = 78
    Height = 13
    Caption = 'Layer'#39's Field lists'
  end
  object Label12: TLabel
    Left = 20
    Top = 203
    Width = 24
    Height = 13
    Caption = 'Color'
  end
  object Label3: TLabel
    Left = 155
    Top = 191
    Width = 19
    Height = 13
    Caption = 'End'
  end
  object Label13: TLabel
    Left = 153
    Top = 203
    Width = 24
    Height = 13
    Caption = 'Color'
  end
  object CLStart: TEzColorBox
    Left = 52
    Top = 193
    Width = 89
    Height = 22
    TabOrder = 7
    TabStop = True
    CustomText = '&More Colors...'
    PopupSpacing = 8
    ShowSystemColors = False
  end
  object CLEnd: TEzColorBox
    Left = 180
    Top = 193
    Width = 86
    Height = 22
    TabOrder = 8
    TabStop = True
    CustomText = '&More Colors...'
    PopupSpacing = 8
    ShowSystemColors = False
  end
  object cmdSearchCompXY_0: TButton
    Left = -6240
    Top = 244
    Width = 88
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
  end
  object MERange: TMaskEdit
    Left = 271
    Top = 194
    Width = 20
    Height = 21
    TabOrder = 3
    Text = '10'
  end
  object UpDown5: TUpDown
    Left = 291
    Top = 194
    Width = 16
    Height = 21
    Associate = MERange
    Max = 20
    Position = 10
    TabOrder = 6
  end
  object CBfields: TCheckListBox
    Left = 7
    Top = 28
    Width = 220
    Height = 136
    ItemHeight = 13
    TabOrder = 2
    OnClick = CBfieldsClick
  end
  object CBZero: TCheckBox
    Left = 247
    Top = 152
    Width = 71
    Height = 14
    Caption = 'Exclude 0'
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 237
    Top = 227
    Width = 86
    Height = 22
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object cmdDraw: TButton
    Left = 7
    Top = 228
    Width = 86
    Height = 21
    Caption = 'Create thematic'
    Enabled = False
    ModalResult = 1
    TabOrder = 5
    OnClick = cmdDrawClick
  end
end
