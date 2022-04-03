object frmLineType: TfrmLineType
  Left = 236
  Top = 248
  BorderStyle = bsDialog
  Caption = 'Line type'
  ClientHeight = 231
  ClientWidth = 414
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 5
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = '&Style :'
  end
  object Label2: TLabel
    Left = 11
    Top = 143
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = '&Color :'
  end
  object Label3: TLabel
    Left = 11
    Top = 171
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Scale :'
  end
  object cboColor: TEzColorBox
    Left = 51
    Top = 141
    Width = 166
    Height = 26
    TabOrder = 4
    TabStop = True
    CustomText = '&More Colors...'
    Flat = True
    ParentShowHint = False
    PopupSpacing = 8
    ShowHint = True
    ShowSystemColors = False
    OnChange = cboColorChange
  end
  object OKBtn: TButton
    Left = 50
    Top = 201
    Width = 77
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 132
    Top = 201
    Width = 74
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object EdScale: TEzNumEd
    Left = 51
    Top = 169
    Width = 166
    Height = 20
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    WidthPad = -6
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = EdScaleChange
    ParentColor = False
    TabOrder = 2
  end
  object ltlist1: TEzLinetypeListBox
    Left = 52
    Top = 7
    Width = 163
    Height = 130
    Color = clBtnFace
    ItemHeight = 70
    TabOrder = 3
    OnClick = ltlist1Click
    Repit = 2
    ShowFirstDefaultLineTypes = 62
  end
  object GroupBox1: TGroupBox
    Left = 224
    Top = 7
    Width = 183
    Height = 215
    Caption = 'Sample'
    TabOrder = 5
    object PBox1: TPaintBox
      Left = 7
      Top = 16
      Width = 166
      Height = 167
      OnPaint = PBox1Paint
    end
    object Label4: TLabel
      Left = 8
      Top = 193
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = '&Repeat :'
    end
    object btnCalc: TButton
      Left = 120
      Top = 187
      Width = 56
      Height = 22
      Caption = '&Calculate'
      TabOrder = 0
      OnClick = btnCalcClick
    end
    object Edit1: TEzNumEd
      Left = 54
      Top = 187
      Width = 64
      Height = 21
      Cursor = crIBeam
      BorderStyle = ebsFlat
      BorderColor = clDefault
      Digits = 5
      Decimals = 0
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      NumericValue = 2.000000000000000000
      OnChange = EdScaleChange
      ParentColor = False
      TabOrder = 1
    end
  end
end
