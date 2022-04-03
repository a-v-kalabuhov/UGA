object OtvodPrintForm: TOtvodPrintForm
  Left = 306
  Top = 192
  ActiveControl = ExitBtn
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1077#1095#1072#1090#1100
  ClientHeight = 431
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox: TScrollBox
    Left = 0
    Top = 30
    Width = 441
    Height = 401
    HorzScrollBar.Size = 16
    HorzScrollBar.Tracking = True
    VertScrollBar.Size = 16
    VertScrollBar.Tracking = True
    Align = alClient
    Color = clAppWorkSpace
    ParentColor = False
    TabOrder = 0
    OnResize = ScrollBoxResize
    object ShpShadow: TShape
      Left = 60
      Top = 20
      Width = 249
      Height = 361
      Brush.Color = clBlack
    end
    object pnlPage: TPanel
      Left = 56
      Top = 16
      Width = 249
      Height = 361
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      object ibPage: TImage
        Left = 0
        Top = 0
        Width = 249
        Height = 361
        Align = alClient
        PopupMenu = ConfigMenu
        Stretch = True
        Transparent = True
        ExplicitLeft = 67
        ExplicitTop = 24
      end
    end
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 441
    Height = 30
    ButtonHeight = 23
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object btnScaleAll: TSpeedButton
      Left = 0
      Top = 0
      Width = 23
      Height = 23
      Hint = #1042#1089#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAA0000000000000AA067676767676760A076700000007
        670A06760FFFFF06760A07670F444F07670A06760FFFFF06760A07670F44FF07
        670A06760FFFFF06760A07670F444F07670A06760FFFFF06760A076700000007
        670A067676767676760AA0000000000000AAAAAAAAAAAAAAAAAA}
      OnClick = btnScaleAllClick
    end
    object btnScaleWidth: TSpeedButton
      Left = 23
      Top = 0
      Width = 23
      Height = 23
      Hint = #1055#1086' '#1096#1080#1088#1080#1085#1077' '#1089#1090#1088#1072#1085#1080#1094#1099
      GroupIndex = 1
      Down = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAA0000000000000AA4FFFFFFFFFFFFF0A4FFFF000000F
        FF0A4FFFFFFFFFFFFF0A4FFFF00000FFFF0A4FFFFFFFFFFFFF0A4FF4F0000FF4
        FF0A4F44FFFFFFF44F0A44444F000F44440A4F44FFFFFFF44F0A4FF4F00000F4
        FF0A4FFFFFFFFFFFFF0AA0000000000000AAAAAAAAAAAAAAAAAA}
      OnClick = btnScaleWidthClick
    end
    object btnScale100: TSpeedButton
      Left = 46
      Top = 0
      Width = 23
      Height = 23
      Hint = '100 %'
      GroupIndex = 1
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAA0000000000000AA0FFFFFFFFFFFFF0A0F0000000000
        0F0A0FFFFFFFFFFFFF0A0F00000000000F0A0FFFFFFFFFFFFF0A0F0000000000
        0F0A0FFFFFFFFFFFFF0A0F00000000000F0A0FFFFFFFFFFFFF0A0F0000000000
        0F0A0FFFFFFFFFFFFF0AA0000000000000AAAAAAAAAAAAAAAAAA}
      OnClick = btnScale100Click
    end
    object ToolButton4: TToolButton
      Left = 69
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object PrintBtn: TSpeedButton
      Left = 77
      Top = 0
      Width = 23
      Height = 23
      Hint = #1055#1077#1095#1072#1090#1100
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222222222
        22222200000000000222208888888880802200000000000008020888888BBB88
        0002088888877788080200000000000008800888888888808080200000000008
        0800220FFFFFFFF080802220F00000F000022220FFFFFFFF022222220F00000F
        022222220FFFFFFFF02222222000000000222222222222222222}
      OnClick = PrintBtnClick
    end
    object PrinterSetupBtn: TSpeedButton
      Left = 100
      Top = 0
      Width = 23
      Height = 23
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1080#1085#1090#1077#1088#1072
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
        AAAAAA00000000000AAAA0888888888080AA000000000000080A0888888BBB88
        000A088888877788080A00000000000008800888888888808080A00000000008
        0800AA0FFFFFFFF08080AAA0FFFFFFF6EEE0A7000000000E6007A0E6EEEEEEEE
        0AAAA7000000000E6007AAAA0FFFFF76EEE0AAAAA00000070007}
      OnClick = PrinterSetupBtnClick
    end
    object SaveBtn: TSpeedButton
      Left = 123
      Top = 0
      Width = 23
      Height = 23
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDD0000000000000DD0EE000000880E0DD0EE000000880E0DD0EE00000088
        0E0DD0EE000000000E0DD0EEEEEEEEEEEE0DD0EE00000000EE0DD0E088888888
        0E0DD0E0888888880E0DD0E0888888880E0DD0E0888888880E0DD0E088888888
        000DD0E0888888880F0DD00000000000000DDDDDDDDDDDDDDDDD}
      OnClick = SaveBtnClick
    end
    object ToolButton3: TToolButton
      Left = 146
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 9
      Style = tbsSeparator
    end
    object sbWord: TSpeedButton
      Left = 154
      Top = 0
      Width = 23
      Height = 23
      Hint = #1042#1099#1074#1077#1089#1090#1080' '#1074' Word'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0040C0C0C0C0C0
        C0C00C0C0C0C0C0C0C0CC0FFFFFFFFFFFFC00CFC0CFC0C0FFF0CC0F0C0F0C0C8
        FFC00CFC0CFC0C07FF0CC0F0C0C0C0C0FFC00CFC0C0C0C0C8F0CC0F0CFC0CFC0
        7FC00C0C0F0C0F0C0F0CC0C0CFC00FC0C0C00C0C0C0C0C0C0C0CC0FFFFFFFFFF
        FFC00CFFFFFFFFFFFF0CC0C0C0C0C0C0C0C00C0C0C0C0C0C0C0C}
      Visible = False
      OnClick = tbToWordClick
    end
    object sbVisio: TSpeedButton
      Left = 177
      Top = 0
      Width = 23
      Height = 23
      Hint = #1042#1099#1074#1077#1089#1090#1080' '#1074' Visio'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF004CCCCCCCCCCC
        CCCCCCCCACCCCCCCCCCCCCCAAACC2AAAAA2CCCAAAAACCAAAAACCCAAAAAAAC2AA
        A2CCCCAAAAACCCAAACCCCCCAAACCCC2A2CCCCCCCACCCCCCACCCCCCCCCCCCCCCC
        CCCCCC2AA2CCC222222CC2AAAA2CCAAAAA2CCAAAAAACCAAAAA2CCAAAAAACCAAA
        AA2CC2AAAA2CCAAAAA2CCC2AA2CCCAAAAA2CCCCCCCCCCCCCCCCC}
      Layout = blGlyphTop
      OnClick = sbVisioClick
    end
    object ToolButton7: TToolButton
      Left = 200
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object Label3: TLabel
      Left = 208
      Top = 0
      Width = 97
      Height = 23
      AutoSize = False
      Caption = '     '#1052#1072#1089#1096#1090#1072#1073' 1:  '
      DragMode = dmAutomatic
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object ScaleCombo: TComboBox
      Left = 305
      Top = 0
      Width = 57
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = '10000'
      OnClick = ScaleComboClick
      OnExit = ScaleComboExit
      OnKeyDown = ScaleComboKeyDown
      Items.Strings = (
        '500'
        '1000'
        '2000'
        '5000'
        '10000')
    end
    object ToolButton2: TToolButton
      Left = 362
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object ExitBtn: TBitBtn
      Left = 370
      Top = 0
      Width = 79
      Height = 23
      Cancel = True
      Caption = '&'#1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = ExitBtnClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        0333330111111111033333011111111103333301111111110333330111111111
        0333330111111111033333011111111103333301111111B10333330111111111
        0333330111111111033333011EEEEE11033333011EEEEE11033333011EEEEE11
        0333330111111111033333011111111103333300000000000333}
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 112
    Top = 112
  end
  object ConfigMenu: TPopupMenu
    OnPopup = ConfigMenuPopup
    Left = 208
    Top = 112
    object OtvodItm: TMenuItem
      Caption = '&'#1054#1090#1074#1086#1076
      OnClick = OtvodItmClick
    end
    object CoordItm: TMenuItem
      Caption = '&'#1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
      OnClick = CoordItmClick
    end
    object CompassItm: TMenuItem
      Caption = '&'#1057#1090#1088#1077#1083#1082#1072
      OnClick = CompassItmClick
    end
    object ScaleItm: TMenuItem
      Caption = '&'#1052#1072#1089#1096#1090#1072#1073
      OnClick = ScaleItmClick
    end
    object NetItm: TMenuItem
      Caption = #1057'&'#1077#1090#1082#1072
      Checked = True
      OnClick = NetItmClick
    end
    object LabelsItm: TMenuItem
      Caption = #1052#1077#1090#1082#1080' '#1090#1086#1095#1077#1082
      Checked = True
      OnClick = LabelsItmClick
    end
    object LineLabelsItm: TMenuItem
      Caption = #1052#1077#1088#1099' '#1083#1080#1085#1080#1081
      OnClick = LineLabelsItmClick
    end
  end
  object SaveDialog: TSavePictureDialog
    Filter = 
      'All (*.gif;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.gif;*.jpg;*.j' +
      'peg;*.bmp;*.ico;*.emf;*.wmf|GIF Image (*.gif)|*.gif|JPEG Image F' +
      'ile (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp' +
      ')|*.bmp|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf|Met' +
      'afiles (*.wmf)|*.wmf'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 176
    Top = 112
  end
  object CoordMenu: TPopupMenu
    Left = 208
    Top = 80
    object CoordConfigItm: TMenuItem
      Caption = '&'#1053#1072#1089#1090#1088#1086#1081#1082#1072
      OnClick = CoordConfigItmClick
    end
    object miCS: TMenuItem
      AutoCheck = True
      Caption = #1052#1057#1050' 36'
      OnClick = miCSClick
    end
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'FontDialog.Font'
      'NetItm.Checked')
    StoredValues = <>
    Left = 144
    Top = 112
  end
  object FontDialog: TFontDialog
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Left = 176
    Top = 80
  end
end
