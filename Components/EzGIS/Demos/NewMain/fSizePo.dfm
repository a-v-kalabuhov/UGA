object frmSizePos: TfrmSizePos
  Left = 134
  Top = 148
  BorderStyle = bsDialog
  Caption = 'Size and position for graphic entity'
  ClientHeight = 130
  ClientWidth = 610
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 4
    Top = 8
    Width = 397
    Height = 73
    Brush.Color = clTeal
  end
  object Shape2: TShape
    Left = 148
    Top = 32
    Width = 109
    Height = 25
    Brush.Color = clYellow
  end
  object Label1: TLabel
    Left = 180
    Top = 38
    Width = 45
    Height = 13
    Caption = 'Graphic'
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 73
    Top = 112
    Width = 43
    Height = 13
    Caption = 'From left'
  end
  object Label3: TLabel
    Left = 221
    Top = 112
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object Label4: TLabel
    Left = 343
    Top = 112
    Width = 49
    Height = 13
    Caption = 'From right'
  end
  object Label5: TLabel
    Left = 541
    Top = 12
    Width = 43
    Height = 13
    Caption = 'From top'
  end
  object Label6: TLabel
    Left = 541
    Top = 37
    Width = 31
    Height = 13
    Caption = 'Height'
  end
  object Label7: TLabel
    Left = 541
    Top = 62
    Width = 61
    Height = 13
    Caption = 'From bottom'
  end
  object Label8: TLabel
    Left = 116
    Top = 94
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object Label9: TLabel
    Left = 252
    Top = 94
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object Label10: TLabel
    Left = 392
    Top = 94
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object Label11: TLabel
    Left = 520
    Top = 12
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object Label12: TLabel
    Left = 520
    Top = 37
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object Label13: TLabel
    Left = 520
    Top = 62
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object OKBtn: TButton
    Left = 451
    Top = 106
    Width = 76
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 531
    Top = 106
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnApply: TButton
    Left = 531
    Top = 81
    Width = 75
    Height = 21
    Caption = '&Apply'
    TabOrder = 2
    OnClick = btnApplyClick
  end
  object edLeft: TEzNumEd
    Left = 4
    Top = 88
    Width = 109
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = edLeftChange
    ParentColor = False
    TabOrder = 3
  end
  object edWidth: TEzNumEd
    Left = 140
    Top = 88
    Width = 109
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = edLeftChange
    ParentColor = False
    TabOrder = 4
  end
  object edRight: TEzNumEd
    Left = 280
    Top = 88
    Width = 109
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = edRightChange
    ParentColor = False
    TabOrder = 5
  end
  object edBottom: TEzNumEd
    Left = 408
    Top = 58
    Width = 109
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = edBottomChange
    ParentColor = False
    TabOrder = 6
  end
  object edHeight: TEzNumEd
    Left = 408
    Top = 33
    Width = 109
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = edTopChange
    ParentColor = False
    TabOrder = 7
  end
  object edTop: TEzNumEd
    Left = 408
    Top = 8
    Width = 109
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = edTopChange
    ParentColor = False
    TabOrder = 8
  end
end
