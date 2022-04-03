object frmPropertyWizard: TfrmPropertyWizard
  Left = 328
  Top = 207
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Property Wizard'
  ClientHeight = 318
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 144
    Width = 72
    Height = 14
    Caption = 'Inital value:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 110
    Top = 97
    Width = 77
    Height = 14
    Caption = 'Indent Level'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 15
    Width = 95
    Height = 14
    Caption = 'Property name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 90
    Height = 14
    Caption = 'Property type:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnEdit: TSpeedButton
    Left = 152
    Top = 120
    Width = 89
    Height = 22
    Caption = 'Edit Strings'
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
      000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
      00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
      F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
      0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
      FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
      FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
      0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
      00333377737FFFFF773333303300000003333337337777777333}
    Layout = blGlyphRight
    NumGlyphs = 2
    OnClick = btnEditClick
  end
  object Inspector: TEzInspector
    Left = 16
    Top = 161
    Width = 226
    Height = 118
    ButtonWidth = 21
    FontReadOnly.Charset = DEFAULT_CHARSET
    FontReadOnly.Color = clWindowText
    FontReadOnly.Height = -11
    FontReadOnly.Name = 'Tahoma'
    FontReadOnly.Style = [fsBold, fsItalic]
    FontModified.Charset = DEFAULT_CHARSET
    FontModified.Color = clWindowText
    FontModified.Height = -11
    FontModified.Name = 'Tahoma'
    FontModified.Style = [fsBold]
    TitleCaptions.Strings = (
      'Property'
      'Value')
    OnPropertyChange = InspectorPropertyChange
    Color = clBtnFace
    DefaultRowHeight = 29
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 0
    ColWidths = (
      115
      87)
  end
  object btnOk: TButton
    Left = 86
    Top = 285
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 166
    Top = 285
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object chkReadOnly: TCheckBox
    Left = 16
    Top = 72
    Width = 81
    Height = 17
    Caption = 'Read only'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = chkReadOnlyClick
  end
  object chkModified: TCheckBox
    Left = 110
    Top = 72
    Width = 81
    Height = 17
    Caption = 'Modified'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = chkReadOnlyClick
  end
  object chkEdit: TCheckBox
    Left = 16
    Top = 96
    Width = 73
    Height = 17
    Caption = 'Use edit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = chkReadOnlyClick
  end
  object edName: TEdit
    Left = 110
    Top = 11
    Width = 131
    Height = 21
    TabOrder = 6
    Text = 'Angle'
    OnChange = chkReadOnlyClick
  end
  object cboType: TComboBox
    Left = 110
    Top = 36
    Width = 131
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnClick = cboTypeClick
    Items.Strings = (
      'Angle'
      'Bitmap'
      'Blocks'
      'Boolean'
      'Brushstyle'
      'Color'
      'Date'
      'DefineAnyLocalImage'
      'DefineLocalBitmap'
      'DefineLocalTiff'
      'Dummy'
      'Enumeration'
      'Expression'
      'Float'
      'FontName'
      'Graphic'
      'Integer'
      'Linetype'
      'LongText'
      'Memo'
      'Points'
      'SelectFolder'
      'Set'
      'String'
      'Symbol'
      'Time')
  end
  object chkTrueType: TCheckBox
    Left = 16
    Top = 120
    Width = 89
    Height = 17
    Caption = 'Is true type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = chkReadOnlyClick
  end
  object speIdentLevel: TEdit
    Left = 192
    Top = 92
    Width = 49
    Height = 21
    TabOrder = 9
    Text = '0'
    OnChange = chkReadOnlyClick
  end
  object UpDown1: TUpDown
    Left = 241
    Top = 92
    Width = 16
    Height = 21
    Associate = speIdentLevel
    TabOrder = 10
  end
end
