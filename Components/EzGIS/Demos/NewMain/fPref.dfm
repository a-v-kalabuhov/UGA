object frmPreferences: TfrmPreferences
  Left = 302
  Top = 112
  BorderStyle = bsSizeToolWin
  Caption = 'Preferences'
  ClientHeight = 394
  ClientWidth = 295
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
    Width = 295
    Height = 365
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
    Align = alClient
    Color = clBtnFace
    DefaultColWidth = 120
    DefaultRowHeight = 29
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 0
    ColWidths = (
      120
      168)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 295
    Height = 29
    Align = alTop
    TabOrder = 1
    object BtnExpand: TSpeedButton
      Left = 130
      Top = 4
      Width = 56
      Height = 21
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Caption = 'Expanded'
      OnClick = BtnExpandClick
    end
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
