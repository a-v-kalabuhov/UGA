object frmEzProviderWizard: TfrmEzProviderWizard
  Left = 291
  Top = 170
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Inspector Provider Wizard'
  ClientHeight = 383
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TSpeedButton
    Left = 249
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Append'
    OnClick = Button1Click
  end
  object Button2: TSpeedButton
    Left = 249
    Top = 41
    Width = 75
    Height = 25
    Caption = 'Update'
    OnClick = Button2Click
  end
  object btnUp: TSpeedButton
    Left = 249
    Top = 204
    Width = 75
    Height = 25
    Caption = 'Move &Up'
    Enabled = False
    OnClick = btnUpClick
  end
  object btnDown: TSpeedButton
    Left = 249
    Top = 237
    Width = 75
    Height = 25
    Caption = 'Move &Down'
    Enabled = False
    OnClick = btnDownClick
  end
  object btnErase: TSpeedButton
    Left = 249
    Top = 106
    Width = 75
    Height = 25
    Caption = '&Erase'
    OnClick = Delete1Click
  end
  object btnClear: TSpeedButton
    Left = 249
    Top = 139
    Width = 75
    Height = 25
    Caption = 'Clea&r'
    OnClick = DeleteAll1Click
  end
  object btnInsert: TSpeedButton
    Left = 249
    Top = 172
    Width = 75
    Height = 25
    Caption = '&Insert'
    OnClick = Insert1Click
  end
  object btnEdit: TSpeedButton
    Left = 249
    Top = 73
    Width = 75
    Height = 25
    Caption = 'Edi&t'
    Enabled = False
    OnClick = Edit1Click
  end
  object EzInspector: TEzInspector
    Left = 0
    Top = 0
    Width = 241
    Height = 383
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
    Align = alLeft
    Color = clBtnFace
    DefaultRowHeight = 29
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 0
    OnClick = EzInspectorClick
    OnMouseUp = EzInspectorMouseUp
    ColWidths = (
      68
      166)
  end
  object BitBtn1: TBitBtn
    Left = 248
    Top = 272
    Width = 75
    Height = 25
    Caption = '&Close'
    Default = True
    TabOrder = 1
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
    Spacing = 5
  end
  object PopupMenu1: TPopupMenu
    Left = 48
    Top = 216
    object Insert1: TMenuItem
      Caption = 'Insert'
      OnClick = Insert1Click
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Caption = 'Erase'
      OnClick = Delete1Click
    end
    object Append1: TMenuItem
      Caption = 'Append'
      OnClick = Button1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DeleteAll1: TMenuItem
      Caption = 'Clear'
      OnClick = DeleteAll1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MoveUp1: TMenuItem
      Caption = 'Move Up'
      OnClick = btnUpClick
    end
    object MoveDown1: TMenuItem
      Caption = 'Move Down'
      OnClick = btnDownClick
    end
  end
end
