object frmAutoLabel: TfrmAutoLabel
  Left = 301
  Top = 302
  Caption = 'Auto-Labeling'
  ClientHeight = 195
  ClientWidth = 439
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 439
    Height = 195
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '&General'
      object Label1: TLabel
        Left = 46
        Top = 10
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = '&Layer to Label :'
      end
      object Label2: TLabel
        Left = 8
        Top = 33
        Width = 111
        Height = 13
        Alignment = taRightJustify
        Caption = '&Store Labels On Layer :'
      end
      object Label3: TLabel
        Left = 0
        Top = 55
        Width = 157
        Height = 13
        Caption = 'Expression Used to Build Labels :'
      end
      object BtnAssist: TSpeedButton
        Left = 166
        Top = 52
        Width = 66
        Height = 20
        Caption = '&Assist...'
        OnClick = BtnAssistClick
      end
      object cboLayer: TComboBox
        Left = 124
        Top = 7
        Width = 147
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object cboStore: TComboBox
        Left = 124
        Top = 29
        Width = 147
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object Memo1: TMemo
        Left = 0
        Top = 110
        Width = 431
        Height = 57
        Align = alBottom
        Lines.Strings = (
          'UID')
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&Label Config'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label28: TLabel
        Left = 124
        Top = 111
        Width = 26
        Height = 13
        Caption = '&Size :'
      end
      object Label29: TLabel
        Left = 278
        Top = 111
        Width = 30
        Height = 13
        Caption = '&Color :'
      end
      object chkAlign: TCheckBox
        Left = 2
        Top = 44
        Width = 129
        Height = 17
        Caption = '&Align to line segments'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object chkTrueType: TCheckBox
        Left = 2
        Top = 60
        Width = 126
        Height = 17
        Caption = 'Use &True Type fonts'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object PageControl2: TPageControl
        Left = 136
        Top = 3
        Width = 219
        Height = 100
        ActivePage = TabSheet4
        TabOrder = 2
        object TabSheet3: TTabSheet
          Caption = 'Vectorial'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object LstFonts: TListBox
            Left = 0
            Top = 0
            Width = 213
            Height = 75
            Align = alClient
            ItemHeight = 16
            TabOrder = 0
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'True Type'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 144
            Height = 75
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LstTTFonts: TListBox
              Left = 0
              Top = 0
              Width = 144
              Height = 75
              Align = alClient
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object chkBold: TCheckBox
            Left = 147
            Top = 4
            Width = 73
            Height = 17
            Caption = '&Bold'
            TabOrder = 1
          end
          object chkItal: TCheckBox
            Left = 147
            Top = 21
            Width = 73
            Height = 17
            Caption = '&Italic'
            TabOrder = 2
          end
          object chkUnder: TCheckBox
            Left = 147
            Top = 39
            Width = 73
            Height = 17
            Caption = '&Underline'
            TabOrder = 3
          end
          object chkStrike: TCheckBox
            Left = 147
            Top = 57
            Width = 73
            Height = 16
            Caption = '&Strikeout'
            TabOrder = 4
          end
        end
      end
      object EdSize: TEzNumEd
        Left = 154
        Top = 106
        Width = 121
        Height = 22
        Cursor = crIBeam
        BorderStyle = ebsFlat
        BorderColor = clDefault
        Decimals = 0
        HotTrack = False
        DecimalSeparator = ','
        ThousandSeparator = #160
        AcceptNegatives = False
        EditFormat.RightInfo = ' Pts.'
        DisplayFormat.RightInfo = ' Pts.'
        DisplayFormat.NegUseParens = True
        NumericValue = 12.000000000000000000
        Ctl3D = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 3
      end
      object cboColor: TEzColorBox
        Left = 315
        Top = 106
        Width = 40
        Height = 22
        TabOrder = 4
        TabStop = True
        CustomText = 'More Colors...'
        Flat = True
        PopupSpacing = 8
        ShowSystemColors = False
      end
    end
  end
  object Launcher1: TEzActionLauncher
    Cursor = crHandPoint
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursor, mdCursorFrame]
    OnMouseDown = Launcher1MouseDown
    OnMouseMove = Launcher1MouseMove
    OnMouseUp = Launcher1MouseUp
    OnPaint = Launcher1Paint
    OnKeyPress = Launcher1KeyPress
    OnSuspendOperation = Launcher1SuspendOperation
    OnContinueOperation = Launcher1ContinueOperation
    OnFinished = Launcher1Finished
    Left = 152
    Top = 124
  end
end
