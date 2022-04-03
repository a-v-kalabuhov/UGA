object frmRounded: TfrmRounded
  Left = 579
  Top = 175
  Caption = 'Rounded Corner Entity Design'
  ClientHeight = 107
  ClientWidth = 267
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
    Top = 29
    Width = 96
    Height = 13
    Caption = 'Roundness Radius :'
  end
  object Label2: TLabel
    Left = 76
    Top = 7
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = '&Style :'
  end
  object NumEd1: TEzNumEd
    Left = 107
    Top = 26
    Width = 108
    Height = 20
    Cursor = crIBeam
    BorderColor = clDefault
    Decimals = 4
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    OnChange = NumEd1Change
    ParentColor = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 156
    Top = 59
    Width = 61
    Height = 20
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
  object chkClosed: TCheckBox
    Left = 26
    Top = 65
    Width = 92
    Height = 14
    Alignment = taLeftJustify
    Caption = 'Force C&losed :'
    TabOrder = 2
  end
  object cboStyle: TComboBox
    Left = 107
    Top = 3
    Width = 108
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = cboStyleChange
    Items.Strings = (
      'Sharp'
      'Rounded')
  end
  object chkColinear: TCheckBox
    Left = 7
    Top = 49
    Width = 111
    Height = 14
    Alignment = taLeftJustify
    Caption = 'Force On &Colinear :'
    Checked = True
    State = cbChecked
    TabOrder = 4
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
    Top = 4
  end
end
