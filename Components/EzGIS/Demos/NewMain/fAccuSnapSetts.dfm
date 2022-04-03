object frmAccuSnapSetts: TfrmAccuSnapSetts
  Left = 241
  Top = 264
  BorderStyle = bsDialog
  Caption = 'Configure AccuSnap'
  ClientHeight = 150
  ClientWidth = 276
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 33
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = '&Sensitivity :'
  end
  object Label2: TLabel
    Left = 7
    Top = 68
    Width = 69
    Height = 13
    Alignment = taRightJustify
    Caption = '&Default Snap :'
  end
  object Label3: TLabel
    Left = 10
    Top = 91
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Snap &Divisor :'
  end
  object OKBtn: TButton
    Left = 61
    Top = 119
    Width = 76
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 141
    Top = 119
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object TrackBar1: TTrackBar
    Left = 85
    Top = 29
    Width = 182
    Height = 30
    Max = 255
    Frequency = 8
    Position = 100
    TabOrder = 2
  end
  object cboSnap: TComboBox
    Left = 85
    Top = 65
    Width = 182
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'End Point'
      'Mid Point'
      'Center'
      'Intersection'
      'Perpendicular'
      'Tangent'
      'Nearest Point'
      'Origin Point'
      'Parallel'
      'KeyPoint'
      'Bisector')
  end
  object NumEd1: TEzNumEd
    Left = 85
    Top = 88
    Width = 65
    Height = 19
    Cursor = crIBeam
    BorderColor = clDefault
    Digits = 3
    Decimals = 0
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    ParentColor = False
    TabOrder = 4
  end
  object ChkEnabled: TCheckBox
    Left = 29
    Top = 10
    Width = 69
    Height = 14
    Alignment = taLeftJustify
    Caption = '&Enabled :'
    TabOrder = 5
  end
end
