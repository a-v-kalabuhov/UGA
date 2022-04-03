object frmDBInspector: TfrmDBInspector
  Left = 426
  Top = 163
  BorderStyle = bsSizeToolWin
  Caption = 'Configure viewport'
  ClientHeight = 381
  ClientWidth = 241
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Inspector1: TEzInspector
    Left = 0
    Top = 29
    Width = 241
    Height = 352
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
    DefaultColWidth = 120
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
    TabOrder = 0
    ColWidths = (
      120
      114)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 7
      Top = 4
      Width = 58
      Height = 21
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 67
      Top = 4
      Width = 58
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
