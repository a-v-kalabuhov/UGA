object frmTextEditor: TfrmTextEditor
  Left = 100
  Top = 100
  BorderStyle = bsSizeToolWin
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1090#1077#1082#1089#1090#1072
  ClientHeight = 139
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 389
    Height = 25
    Align = alTop
    TabOrder = 0
    object BtnBold: TSpeedButton
      Left = 214
      Top = 4
      Width = 18
      Height = 16
      AllowAllUp = True
      GroupIndex = 1
      Flat = True
      Glyph.Data = {
        C6000000424DC6000000000000007600000028000000090000000A0000000100
        0400000000005000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFF000
        000000000000F0000000F000FF0000000000F000FF0000000000F000FF000000
        0000F0000000F0000000F000FF0000000000F000FF0000000000F000FF000000
        000000000000F0000000}
      OnClick = cboFontNameChange
    end
    object BtnItal: TSpeedButton
      Left = 233
      Top = 4
      Width = 17
      Height = 16
      AllowAllUp = True
      GroupIndex = 2
      Flat = True
      Glyph.Data = {
        C6000000424DC6000000000000007600000028000000090000000A0000000100
        0400000000005000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFF000
        0000000000FFF0000000FF007FFFF0000000FF700FFFF0000000FFF007FFF000
        0000FFF700FFF0000000FFFF007FF0000000FFFF700FF0000000FFFFF007F000
        0000FFFF000000000000}
      OnClick = cboFontNameChange
    end
    object BtnUnder: TSpeedButton
      Left = 250
      Top = 4
      Width = 18
      Height = 16
      AllowAllUp = True
      GroupIndex = 3
      Flat = True
      Glyph.Data = {
        D6000000424DD6000000000000007600000028000000090000000C0000000100
        0400000000006000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFF000
        00000000000000000000FFFFFFFFF0000000FF00000FF0000000F00FFF00F000
        0000F00FFF00F0000000F00FFF00F0000000F00FFF00F0000000F00FFF00F000
        0000F00FFF00F0000000F00FFF00F00000000000F00000000000}
      OnClick = cboFontNameChange
    end
    object cboFontName: TComboBox
      Left = 5
      Top = 3
      Width = 164
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = cboFontNameChange
    end
    object CboSize: TComboBox
      Left = 168
      Top = 3
      Width = 46
      Height = 20
      ItemHeight = 12
      TabOrder = 1
      OnChange = cboFontNameChange
      Items.Strings = (
        '6'
        '7'
        '8'
        '9'
        '10'
        '12'
        '14'
        '18'
        '24'
        '36'
        '48'
        '72')
    end
    object ColorBox1: TEzColorBox
      Left = 273
      Top = 4
      Width = 112
      Height = 16
      TabOrder = 2
      TabStop = True
      PopupSpacing = 8
      ShowSystemColors = False
      OnChange = cboFontNameChange
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 25
    Width = 389
    Height = 114
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      #1053#1086#1074#1099#1081' '#1090#1077#1082#1089#1090)
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = cboFontNameChange
  end
end
