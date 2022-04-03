object frmDGNExport: TfrmDGNExport
  Left = 294
  Top = 133
  BorderStyle = bsDialog
  Caption = 'DGN Export parameters'
  ClientHeight = 375
  ClientWidth = 301
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 95
    Height = 13
    Caption = '&Layer(s) to Export :'
  end
  object Label6: TLabel
    Left = 7
    Top = 239
    Width = 286
    Height = 56
    AutoSize = False
    Caption = 
      'For exporting to DGN, we need a seed file. This is just a simple' +
      ' Microstation DGN file without entities but initialized to lot o' +
      'f parameters needed in the Microstation environment. Note: Micro' +
      'station V8 seed files not supported.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label7: TLabel
    Left = 7
    Top = 304
    Width = 48
    Height = 13
    Caption = 'Seed file :'
  end
  object SpeedButton1: TSpeedButton
    Left = 267
    Top = 321
    Width = 18
    Height = 18
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object OKBtn: TButton
    Left = 76
    Top = 348
    Width = 76
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 157
    Top = 348
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 101
    Top = 7
    Width = 186
    Height = 104
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 135
    Width = 199
    Height = 101
    Caption = '&Unit Parameters'
    TabOrder = 3
    object Label2: TLabel
      Left = 7
      Top = 16
      Width = 103
      Height = 13
      Caption = 'Subunits Per &Master :'
    end
    object Label3: TLabel
      Left = 120
      Top = 16
      Width = 32
      Height = 13
      Caption = '&Label :'
    end
    object Label4: TLabel
      Left = 7
      Top = 59
      Width = 88
      Height = 13
      Caption = '&UOR Per SubUnit :'
    end
    object Label5: TLabel
      Left = 120
      Top = 59
      Width = 32
      Height = 13
      Caption = '&Label :'
    end
    object Edit1: TEdit
      Left = 120
      Top = 33
      Width = 69
      Height = 21
      MaxLength = 3
      TabOrder = 0
      Text = 'm'
    end
    object Edit2: TEdit
      Left = 120
      Top = 75
      Width = 69
      Height = 21
      MaxLength = 3
      TabOrder = 1
      Text = 'mm'
    end
    object NumEd1: TEzNumEd
      Left = 10
      Top = 33
      Width = 98
      Height = 19
      Cursor = crIBeam
      BorderColor = clDefault
      Decimals = 0
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      NumericValue = 1000.000000000000000000
      ParentColor = False
      TabOrder = 2
    end
    object NumEd2: TEzNumEd
      Left = 10
      Top = 75
      Width = 98
      Height = 19
      Cursor = crIBeam
      BorderColor = clDefault
      Decimals = 0
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      NumericValue = 1.000000000000000000
      ParentColor = False
      TabOrder = 3
    end
  end
  object Edit3: TEdit
    Left = 7
    Top = 320
    Width = 257
    Height = 21
    TabOrder = 4
  end
  object chkExplode: TCheckBox
    Left = 10
    Top = 117
    Width = 101
    Height = 14
    Caption = '&Explode Blocks'
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'DGN'
    Filter = 'Microstation DGN files (*.DGN)|*.dgn'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Define the seed file'
    Left = 328
    Top = 418
  end
end
