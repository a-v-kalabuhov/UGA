object frmMultiPart: TfrmMultiPart
  Left = 462
  Top = 227
  BorderStyle = bsSizeToolWin
  Caption = 'Create Multi-Part Entity'
  ClientHeight = 72
  ClientWidth = 196
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
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 30
    Height = 13
    Caption = '&Type :'
  end
  object cboType: TComboBox
    Left = 42
    Top = 3
    Width = 118
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'Polygon'
      'Polyline')
  end
  object BtnNew: TButton
    Left = 10
    Top = 29
    Width = 85
    Height = 21
    Caption = '&Start New Part'
    TabOrder = 1
    OnClick = BtnNewClick
  end
  object Button2: TButton
    Left = 101
    Top = 29
    Width = 59
    Height = 21
    Caption = '&Finish'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Launcher1: TEzActionLauncher
    CanDoOsnap = True
    CanDoAccuDraw = True
    MouseDrawElements = [mdCursorFrame, mdFullViewCursor]
    OnMouseDown = Launcher1MouseDown
    OnMouseMove = Launcher1MouseMove
    OnPaint = Launcher1Paint
    OnKeyPress = Launcher1KeyPress
    OnSuspendOperation = Launcher1SuspendOperation
    OnContinueOperation = Launcher1ContinueOperation
    OnFinished = Launcher1Finished
    Left = 32
    Top = 28
  end
end
