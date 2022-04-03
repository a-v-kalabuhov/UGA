object frmAddPlace: TfrmAddPlace
  Left = 748
  Top = 114
  BorderStyle = bsSizeToolWin
  Caption = 'Add Place'
  ClientHeight = 522
  ClientWidth = 153
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SymbList1: TEzSymbolsListBox
    Left = 0
    Top = 46
    Width = 153
    Height = 476
    Align = alClient
    Color = clBtnFace
    ItemHeight = 50
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = SymbList1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 153
    Height = 46
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 14
      Top = 10
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = '&Size:'
    end
    object Label2: TLabel
      Left = 3
      Top = 26
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = '&Height:'
    end
    object CboSize: TComboBox
      Left = 39
      Top = 3
      Width = 85
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = CboSizeChange
      Items.Strings = (
        '6'
        '7'
        '8'
        '9'
        '10'
        '12'
        '14'
        '16'
        '18'
        '20'
        '22'
        '24'
        '36'
        '40')
    end
    object NumEd1: TEzNumEd
      Left = 39
      Top = 23
      Width = 85
      Height = 19
      Cursor = crIBeam
      BorderStyle = ebsFlat
      BorderColor = clDefault
      Digits = 6
      Decimals = 4
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      OnChange = NumEd1Change
      ParentColor = False
      TabOrder = 1
    end
  end
  object Launcher1: TEzActionLauncher
    Cursor = crHandPoint
    CanDoOsnap = True
    CanDoAccuDraw = True
    MouseDrawElements = [mdCursor]
    OnMouseDown = Launcher1MouseDown
    OnMouseMove = Launcher1MouseMove
    OnPaint = Launcher1Paint
    OnKeyPress = Launcher1KeyPress
    OnSuspendOperation = Launcher1SuspendOperation
    OnContinueOperation = Launcher1ContinueOperation
    OnFinished = Launcher1Finished
    Left = 56
    Top = 68
  end
end
