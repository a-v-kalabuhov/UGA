object frmMapOpts: TfrmMapOpts
  Left = 157
  Top = 169
  BorderStyle = bsDialog
  Caption = 'Map Units'
  ClientHeight = 186
  ClientWidth = 369
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
  object Bevel1: TBevel
    Left = 5
    Top = 3
    Width = 358
    Height = 146
    Shape = bsFrame
  end
  object Label2: TLabel
    Left = 20
    Top = 36
    Width = 89
    Height = 13
    Caption = '&Coordinates Units :'
    FocusControl = CboCoords
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 13
    Top = 13
    Width = 94
    Height = 13
    Caption = '&Coordinate System :'
    FocusControl = CboSystem
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 13
    Top = 78
    Width = 66
    Height = 16
    Caption = 'Warning :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 13
    Top = 98
    Width = 339
    Height = 39
    Caption = 
      'You cannot freely change the coordinate system and units of the ' +
      'currently opened map. You must know exactly what you are doing. ' +
      'This dialog is provided specifically for fixing bad information ' +
      'on the map.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 55
    Top = 59
    Width = 56
    Height = 13
    Caption = '&View Units :'
    FocusControl = cboView
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object OKBtn: TButton
    Left = 96
    Top = 157
    Width = 85
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 188
    Top = 157
    Width = 86
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object CboCoords: TComboBox
    Left = 115
    Top = 33
    Width = 157
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object BtnProj1: TButton
    Left = 280
    Top = 9
    Width = 74
    Height = 22
    Caption = '&Projection...'
    TabOrder = 1
    OnClick = BtnProj1Click
  end
  object CboSystem: TComboBox
    Left = 115
    Top = 10
    Width = 157
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnClick = CboSystemClick
    Items.Strings = (
      'Cartesian (Non Earth)'
      'Latitude/Longitude'
      'Projection')
  end
  object cboView: TComboBox
    Left = 115
    Top = 55
    Width = 157
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Visible = False
  end
end
