object frmNewPt: TfrmNewPt
  Left = 329
  Top = 214
  BorderStyle = bsDialog
  Caption = 'Edit/Insert a Reference Point'
  ClientHeight = 181
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 54
    Top = 149
    Width = 76
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 135
    Top = 149
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 80
    Width = 249
    Height = 65
    Caption = 'Will become :'
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 15
      Width = 92
      Height = 13
      Caption = 'Real Coordinate &X :'
    end
    object Label2: TLabel
      Left = 10
      Top = 41
      Width = 92
      Height = 13
      Caption = 'Real Coordinate &Y :'
    end
    object Label3: TLabel
      Left = 208
      Top = 18
      Width = 3
      Height = 13
    end
    object Label4: TLabel
      Left = 208
      Top = 37
      Width = 3
      Height = 13
    end
    object Edit1: TEzNumEd
      Left = 107
      Top = 12
      Width = 134
      Height = 21
      Cursor = crIBeam
      BorderStyle = ebsThick
      Decimals = 4
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      ParentColor = False
      TabOrder = 0
    end
    object Edit2: TEzNumEd
      Left = 107
      Top = 38
      Width = 134
      Height = 21
      Cursor = crIBeam
      BorderStyle = ebsThick
      Decimals = 4
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      ParentColor = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 7
    Width = 250
    Height = 70
    Caption = 'The point at pixel coordinates :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label6: TLabel
      Left = 89
      Top = 20
      Width = 13
      Height = 13
      Caption = '&X :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 88
      Top = 45
      Width = 13
      Height = 13
      Caption = '&Y :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EdX: TEzNumEd
      Left = 107
      Top = 16
      Width = 99
      Height = 21
      Cursor = crIBeam
      BorderStyle = ebsThick
      Decimals = 0
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      ParentColor = False
      TabOrder = 0
    end
    object EdY: TEzNumEd
      Left = 107
      Top = 41
      Width = 99
      Height = 21
      Cursor = crIBeam
      BorderStyle = ebsThick
      Decimals = 0
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      ParentColor = False
      TabOrder = 1
    end
  end
end
