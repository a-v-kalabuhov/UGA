object frmRepeat: TfrmRepeat
  Left = 275
  Top = 179
  BorderStyle = bsDialog
  Caption = 'Repeat selection'
  ClientHeight = 188
  ClientWidth = 224
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 205
    Height = 133
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 18
    Top = 80
    Width = 47
    Height = 13
    Caption = '&Offset X :'
  end
  object Label2: TLabel
    Left = 18
    Top = 108
    Width = 47
    Height = 13
    Caption = '&Offset Y :'
  end
  object Label3: TLabel
    Left = 29
    Top = 48
    Width = 33
    Height = 13
    Caption = '&Rows :'
  end
  object Label4: TLabel
    Left = 16
    Top = 20
    Width = 47
    Height = 13
    Caption = '&Columns :'
  end
  object OKBtn: TButton
    Left = 34
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelBtn: TButton
    Left = 114
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object EzNumEd1: TEzNumEd
    Left = 68
    Top = 45
    Width = 137
    Height = 24
    Cursor = crIBeam
    BorderStyle = ebsThick
    Digits = 6
    Decimals = 0
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    NumericValue = 1.000000000000000000
    ParentColor = False
    TabOrder = 1
  end
  object EzNumEd2: TEzNumEd
    Left = 68
    Top = 16
    Width = 137
    Height = 24
    Cursor = crIBeam
    BorderStyle = ebsThick
    Digits = 6
    Decimals = 0
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    NumericValue = 2.000000000000000000
    ParentColor = False
    TabOrder = 0
  end
  object EzNumEd3: TEzNumEd
    Left = 68
    Top = 75
    Width = 137
    Height = 24
    Cursor = crIBeam
    BorderStyle = ebsThick
    Decimals = 4
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    ParentColor = False
    TabOrder = 2
  end
  object EzNumEd4: TEzNumEd
    Left = 68
    Top = 104
    Width = 137
    Height = 24
    Cursor = crIBeam
    BorderStyle = ebsThick
    Decimals = 4
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    ParentColor = False
    TabOrder = 3
  end
end
