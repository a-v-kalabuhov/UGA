object frmDXFDlg: TfrmDXFDlg
  Left = 182
  Top = 130
  HelpContext = 60
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Import AutoCAD file (%s)'
  ClientHeight = 349
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 458
    Height = 313
    ActivePage = TabSheet2
    Align = alTop
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '&Parameters'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Bevel1: TBevel
        Left = 34
        Top = 6
        Width = 383
        Height = 252
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 59
        Top = 12
        Width = 84
        Height = 14
        Caption = 'Source &Layers :'
        FocusControl = List1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 60
        Top = 206
        Width = 15
        Height = 14
        Caption = '&X :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 60
        Top = 236
        Width = 16
        Height = 14
        Caption = '&Y :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 236
        Top = 203
        Width = 15
        Height = 14
        Caption = 'X :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 236
        Top = 232
        Width = 16
        Height = 14
        Caption = 'Y :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 56
        Top = 180
        Width = 163
        Height = 14
        Caption = 'AutoCAD File Reference Point'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 279
        Top = 180
        Width = 114
        Height = 14
        Caption = 'Map Reference Point'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object BtnSet: TSpeedButton
        Left = 200
        Top = 259
        Width = 24
        Height = 24
        Hint = 'Set Drawing Extent'
        Glyph.Data = {
          62030000424D6203000000000000420000002800000014000000140000000100
          1000030000002003000000000000000000000000000000000000007C0000E003
          00001F0000001863186318631863186318631863186318631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          18631F0018631863186318631863186318631863186318631863186318631863
          18631863186318631F001F001F00186318631863186318631863186318631863
          18631863186318631863186318631F001F001F001F001F001863186310420000
          1863186318631863186318631863186318631863186318631863186318631863
          1863104200001863186318631863186318631863186318631863186318631863
          1863186318631863104200001863186318631863186318631863186318631863
          1863186318631042000000000000186300001863186318631863186318631863
          18631863186318631863186310420000FF7FFF7FFF7F00001863186318631863
          1863186318631863186318631F001863186318630000FF7FFF7FFF7FFF7FFF7F
          0000186318631F00186318631863186318631F001F001863186318630000FF7F
          FF7FFF7FFF7FFF7F0000186318631F001F001863186318631F001F001F001863
          186318630000FF7FFF7FFF7FFF7FFF7F0000186318631F001F001F0018631863
          18631F001F0018631863186310420000FF7FFF7FFF7F00001042186318631F00
          1F00186318631863186318631F00186318631863186310420000000000001042
          1863186318631F00186318631863186318631863186318631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          186318631863186318631863186318631863186318631F001F001F001F001F00
          1863186318631863186318631863186318631863186318631863186318631863
          1F001F001F001863186318631863186318631863186318631863186318631863
          186318631863186318631F001863186318631863186318631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          186318631863}
        ParentShowHint = False
        ShowHint = True
        OnClick = BtnSetClick
      end
      object Label9: TLabel
        Left = 230
        Top = 264
        Width = 142
        Height = 13
        Caption = 'Set cad extent to map extent'
      end
      object List1: TListBox
        Left = 59
        Top = 32
        Width = 342
        Height = 146
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
      end
      object NumEdit1: TEzNumEd
        Left = 79
        Top = 200
        Width = 150
        Height = 21
        Cursor = crIBeam
        BorderColor = clDefault
        HotTrack = False
        WidthPad = -10
        DecimalSeparator = ','
        ThousandSeparator = #160
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
      end
      object NumEdit2: TEzNumEd
        Left = 79
        Top = 229
        Width = 150
        Height = 21
        Cursor = crIBeam
        BorderColor = clDefault
        HotTrack = False
        WidthPad = -10
        DecimalSeparator = ','
        ThousandSeparator = #160
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
      end
      object NumEdit4: TEzNumEd
        Left = 252
        Top = 229
        Width = 148
        Height = 21
        Cursor = crIBeam
        BorderColor = clDefault
        HotTrack = False
        WidthPad = -10
        DecimalSeparator = ','
        ThousandSeparator = #160
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 3
      end
      object NumEdit3: TEzNumEd
        Left = 252
        Top = 200
        Width = 148
        Height = 21
        Cursor = crIBeam
        BorderColor = clDefault
        HotTrack = False
        WidthPad = -10
        DecimalSeparator = ','
        ThousandSeparator = #160
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Block parameters'
      object Bevel2: TBevel
        Left = 2
        Top = 3
        Width = 443
        Height = 274
        Shape = bsFrame
      end
      object Label8: TLabel
        Left = 12
        Top = 12
        Width = 78
        Height = 14
        Caption = '&Existing Blocks'
        FocusControl = ListBlocks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object ListBlocks: TListBox
        Left = 12
        Top = 32
        Width = 221
        Height = 237
        Enabled = False
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
      object ChkAddBlocks: TCheckBox
        Left = 240
        Top = 28
        Width = 197
        Height = 17
        Caption = 'Add &selected blocks to symbol table'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = ChkAddBlocksClick
      end
      object Radio1: TRadioGroup
        Left = 244
        Top = 52
        Width = 181
        Height = 89
        Caption = 'If symbol name already exists :'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          '&Replace'
          '&Skip'
          '&Duplicate')
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object OKBtn: TButton
    Left = 138
    Top = 318
    Width = 86
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 233
    Top = 318
    Width = 86
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
