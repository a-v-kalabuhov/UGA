object frmEditDB: TfrmEditDB
  Left = 402
  Top = 137
  HelpContext = 310
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeToolWin
  Caption = 'Database Information Tool'
  ClientHeight = 265
  ClientWidth = 233
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    object STLayer: TLabel
      Left = 74
      Top = 1
      Width = 158
      Height = 23
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 5
      ExplicitHeight = 13
    end
    object StRec: TLabel
      Left = 53
      Top = 1
      Width = 21
      Height = 23
      Align = alLeft
      Caption = '0/0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 13
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 52
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object BtnApply: TSpeedButton
        Left = 4
        Top = 2
        Width = 41
        Height = 19
        Caption = '&Apply'
        OnClick = BtnApplyClick
      end
    end
  end
  object Inspector1: TEzInspector
    Left = 0
    Top = 25
    Width = 233
    Height = 240
    ButtonWidth = 21
    FontReadOnly.Charset = DEFAULT_CHARSET
    FontReadOnly.Color = clMaroon
    FontReadOnly.Height = -11
    FontReadOnly.Name = 'MS Sans Serif'
    FontReadOnly.Style = [fsBold]
    FontModified.Charset = DEFAULT_CHARSET
    FontModified.Color = clBlack
    FontModified.Height = -11
    FontModified.Name = 'MS Sans Serif'
    FontModified.Style = [fsBold]
    TitleCaptions.Strings = (
      'Property'
      'Value')
    Align = alClient
    Color = clBtnFace
    DefaultColWidth = 159
    DefaultRowHeight = 29
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
    ColWidths = (
      115
      111)
  end
  object Launcher1: TEzActionLauncher
    Cursor = crHandPoint
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursor, mdCursorFrame]
    OnTrackedEntityClick = Launcher1TrackedEntityClick
    OnFinished = Launcher1Finished
    Left = 88
    Top = 164
  end
end
