object frmAccuDraw: TfrmAccuDraw
  Left = 261
  Top = 272
  BorderStyle = bsSingle
  Caption = 'AccuDraw'
  ClientHeight = 76
  ClientWidth = 187
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object BtnRect: TSpeedButton
    Left = 59
    Top = 52
    Width = 33
    Height = 20
    Hint = 'Change to Rectangular'
    GroupIndex = 1
    Down = True
    Glyph.Data = {
      96010000424D9601000000000000760000002800000018000000180000000100
      0400000000002001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333300033333333333333333333300033333333333333
      3333333000333333333333333CCCC3300033CCCC333333333CCCC3300033CCCC
      333333333CC33330003333CC3333333333333330003333333333333333333333
      33333333333333333CC33333333333CC333330000000033FFF33999999933000
      0000033FFF339999999330000000033FFF339999999333333CC33333333333CC
      333333333333333333333333333333333333333AAA333333333333333CC3333A
      AA3333CC333333333CCCC33AAA33CCCC333333333CCCC33AAA33CCCC33333333
      3333333AAA333333333333333333333AAA333333333333333333333AAA333333
      3333333333333333333333333333333333333333333333333333}
    ParentShowHint = False
    ShowHint = True
    OnClick = BtnRectClick
  end
  object BtnPolar: TSpeedButton
    Left = 94
    Top = 52
    Width = 34
    Height = 20
    Hint = 'Change to Polar'
    GroupIndex = 1
    Glyph.Data = {
      96010000424D9601000000000000760000002800000018000000180000000100
      0400000000002001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333000333333333333333333333000333333333333333
      333CCC000CCC333333333333333CCC000CCC3333333333333333330003333333
      33333333C3333300033333C333333333CC33330003333CC33333333CC3333333
      333333CC3333333CC3333333333333CC33333000000333FFF333999999933000
      000333FFF333999999933000000333FFF33399999993333CC3333333333333CC
      3333333CC3333333333333CC33333333C3333333333333C333333333333333AA
      A333333333333333333C33AAA33C333333333333333CCCAAACCCC33333333333
      333CCCAAACCC333333333333333333AAA333333333333333333333AAA3333333
      33333333333333AAA33333333333333333333333333333333333}
    ParentShowHint = False
    ShowHint = True
    OnClick = BtnPolarClick
  end
  object Label1: TLabel
    Left = 15
    Top = 10
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Delta X:'
  end
  object Label2: TLabel
    Left = 15
    Top = 29
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Delta Y:'
  end
  object Label3: TLabel
    Left = 4
    Top = 52
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'Compass :'
  end
  object NumEd1: TEzNumEd
    Left = 59
    Top = 6
    Width = 108
    Height = 19
    Cursor = crIBeam
    BorderColor = clBlack
    Digits = 12
    Decimals = 4
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = NumEd1Change
    ParentColor = False
    TabOrder = 0
  end
  object NumEd2: TEzNumEd
    Left = 59
    Top = 28
    Width = 108
    Height = 20
    Cursor = crIBeam
    BorderColor = clBlack
    Digits = 12
    Decimals = 4
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = NumEd2Change
    ParentColor = False
    TabOrder = 1
  end
  object chkX: TCheckBox
    Left = 169
    Top = 7
    Width = 17
    Height = 13
    TabOrder = 2
    OnClick = chkXClick
  end
  object chkY: TCheckBox
    Left = 169
    Top = 29
    Width = 17
    Height = 14
    TabOrder = 3
    OnClick = chkYClick
  end
end
