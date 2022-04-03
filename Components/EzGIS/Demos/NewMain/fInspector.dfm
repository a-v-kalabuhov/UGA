object frmInspector: TfrmInspector
  Left = 314
  Top = 171
  BorderStyle = bsSizeToolWin
  Caption = 'Entity attributes'
  ClientHeight = 469
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 25
    Align = alTop
    TabOrder = 0
    object BtnApply: TSpeedButton
      Left = 4
      Top = 1
      Width = 53
      Height = 22
      Caption = '&Apply'
      OnClick = BtnApplyClick
    end
    object LblLayer: TLabel
      Left = 64
      Top = 5
      Width = 69
      Height = 13
      Caption = 'Layer / Recno'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 25
    Width = 388
    Height = 444
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Inspector'
      object Splitter1: TSplitter
        Left = 0
        Top = 239
        Width = 380
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 315
      end
      object Panel2: TPanel
        Left = 0
        Top = 242
        Width = 380
        Height = 174
        Align = alClient
        BevelOuter = bvNone
        Color = 11468799
        TabOrder = 0
        Visible = False
        object LblProperty: TLabel
          Left = 0
          Top = 0
          Width = 380
          Height = 15
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 3
        end
        object LblDesc: TLabel
          Left = 0
          Top = 15
          Width = 380
          Height = 159
          Align = alClient
          AutoSize = False
          WordWrap = True
          ExplicitWidth = 315
          ExplicitHeight = 50
        end
      end
      object Inspector1: TEzInspector
        Left = 0
        Top = 0
        Width = 380
        Height = 239
        ButtonWidth = 21
        FontReadOnly.Charset = ANSI_CHARSET
        FontReadOnly.Color = clMaroon
        FontReadOnly.Height = -13
        FontReadOnly.Name = 'Arial'
        FontReadOnly.Style = [fsBold]
        FontModified.Charset = ANSI_CHARSET
        FontModified.Color = clBlack
        FontModified.Height = -13
        FontModified.Name = 'Arial'
        FontModified.Style = [fsBold]
        TitleCaptions.Strings = (
          'Property'
          'Value')
        OnPropertyChange = Inspector1PropertyChange
        OnPropertyHint = Inspector1PropertyHint
        Align = alTop
        Color = clBtnFace
        DefaultRowHeight = 29
        FixedColor = 14803425
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 1
        Visible = False
        ColWidths = (
          133
          240)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Raw Info'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 315
        Height = 326
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object Launcher1: TEzActionLauncher
    Cursor = crHandPoint
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursor, mdCursorFrame]
    OnTrackedEntityClick = Launcher1TrackedEntityClick
    OnFinished = Launcher1Finished
    Left = 80
    Top = 208
  end
end
