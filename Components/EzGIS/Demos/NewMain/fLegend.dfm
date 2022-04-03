object frmLegend: TfrmLegend
  Left = 381
  Top = 305
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Legend'
  ClientHeight = 189
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Legend1: TEzLegend
    Left = 0
    Top = 0
    Width = 201
    Height = 189
    PenTool.Style = 0
    PenTool.Color = clBlack
    BrushTool.Pattern = 0
    BrushTool.ForeColor = clBlack
    BrushTool.BackColor = clBlack
    BorderWidth = 1
    LoweredColor = clGray
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    TitleColor = clBlack
    TitleTransparent = False
    TitleAlignment = taCenter
    Transparent = False
    LegendStyle = ctLabel
    LegendRanges = <
      item
        Legend = 'First legend'
        Frequency = 0
        PenStyle.Style = 1
        PenStyle.Color = clBlack
        BrushStyle.Pattern = 1
        BrushStyle.ForeColor = clBlack
        BrushStyle.BackColor = clBlack
        SymbolStyle.Index = 0
        Color = clBlack
        ImageIndex = 0
      end
      item
        Legend = 'Second legend'
        Frequency = 0
        PenStyle.Style = 1
        PenStyle.Color = clBlack
        BrushStyle.Pattern = 1
        BrushStyle.ForeColor = clBlack
        BrushStyle.BackColor = clBlack
        SymbolStyle.Index = 0
        Color = clMaroon
        ImageIndex = 1
      end
      item
        Legend = 'Third legend'
        Frequency = 0
        PenStyle.Style = 1
        PenStyle.Color = clBlack
        BrushStyle.Pattern = 1
        BrushStyle.ForeColor = clBlack
        BrushStyle.BackColor = clBlack
        SymbolStyle.Index = 0
        Color = clGreen
        ImageIndex = 2
      end
      item
        Legend = 'Fourth legend'
        Frequency = 0
        PenStyle.Style = 1
        PenStyle.Color = clBlack
        BrushStyle.Pattern = 1
        BrushStyle.ForeColor = clBlack
        BrushStyle.BackColor = clBlack
        SymbolStyle.Index = 0
        Color = clOlive
        ImageIndex = 3
      end
      item
        Legend = 'Fifth legend'
        Frequency = 0
        PenStyle.Style = 1
        PenStyle.Color = clBlack
        BrushStyle.Pattern = 1
        BrushStyle.ForeColor = clBlack
        BrushStyle.BackColor = clBlack
        SymbolStyle.Index = 0
        Color = clNavy
        ImageIndex = 4
      end
      item
        Legend = 'Sixth legend'
        Frequency = 0
        PenStyle.Style = 1
        PenStyle.Color = clBlack
        BrushStyle.Pattern = 1
        BrushStyle.ForeColor = clBlack
        BrushStyle.BackColor = clBlack
        SymbolStyle.Index = 0
        Color = clPurple
        ImageIndex = 5
      end>
    ShowTitle = True
    Title0 = 'Feature'
    Title1 = 'Legend'
    Stretch = False
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ColWidths = (
      46
      78
      64)
  end
end
