object frmNetwork: TfrmNetwork
  Left = 278
  Top = 180
  Caption = 'Network Analysis'
  ClientHeight = 410
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 430
    Height = 410
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Analysis'
      object Label1: TLabel
        Left = 6
        Top = 7
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = '&Network Layer :'
      end
      object Label2: TLabel
        Left = 16
        Top = 29
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = '&Result Layer :'
      end
      object SpeedButton1: TSpeedButton
        Left = 286
        Top = 26
        Width = 19
        Height = 18
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888880088888888888880B308888888888880B30888888888888800888
          88888888880B308888888888880B308888888888880B308888888888880BB308
          888888880080BB3088888880B3080BB308888880B30880B308888880BB300BB3
          088888880BBBBB30888888888000000888888888888888888888}
        OnClick = SpeedButton1Click
      end
      object Label6: TLabel
        Left = 94
        Top = 55
        Width = 26
        Height = 13
        Caption = '&Size :'
      end
      object LblNPts: TLabel
        Left = 75
        Top = 78
        Width = 85
        Height = 13
        AutoSize = False
        Caption = '0'
      end
      object Label8: TLabel
        Left = 3
        Top = 78
        Width = 69
        Height = 13
        AutoSize = False
        Caption = 'Num. Stops :'
      end
      object CboNetwork: TComboBox
        Left = 85
        Top = 3
        Width = 199
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnClick = CboNetworkClick
      end
      object cboResult: TComboBox
        Left = 85
        Top = 26
        Width = 199
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object Button1: TButton
        Left = 3
        Top = 52
        Width = 86
        Height = 20
        Caption = '&Pick Stops'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 236
        Top = 52
        Width = 106
        Height = 20
        Caption = '&Calculate !'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = Button2Click
      end
      object EzNumEd1: TEzNumEd
        Left = 124
        Top = 52
        Width = 95
        Height = 20
        Cursor = crIBeam
        BorderStyle = ebsFlat
        BorderColor = clDefault
        Digits = 6
        Decimals = 0
        HotTrack = False
        WidthPad = -8
        DecimalSeparator = ','
        ThousandSeparator = #160
        EditFormat.RightInfo = ' Points'
        DisplayFormat.RightInfo = ' Points'
        NumericValue = 6.000000000000000000
        ParentColor = False
        TabOrder = 4
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 170
        Width = 422
        Height = 212
        ActivePage = TabSheet3
        Align = alBottom
        TabOrder = 5
        object TabSheet3: TTabSheet
          Caption = 'Costs'
          object Grid1: TStringGrid
            Left = 0
            Top = 0
            Width = 414
            Height = 184
            Align = alClient
            ColCount = 2
            FixedCols = 0
            RowCount = 2
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking]
            TabOrder = 0
            ColWidths = (
              198
              192)
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Directions'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Memo1: TMemo
            Left = 0
            Top = 27
            Width = 343
            Height = 160
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clMaroon
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 343
            Height = 27
            Align = alTop
            TabOrder = 1
            object Button3: TButton
              Left = 68
              Top = 3
              Width = 61
              Height = 21
              Caption = '&Print...'
              TabOrder = 0
              OnClick = Button3Click
            end
            object Button4: TButton
              Left = 133
              Top = 3
              Width = 61
              Height = 21
              Caption = '&Font...'
              TabOrder = 1
              OnClick = Button4Click
            end
            object Button5: TButton
              Left = 3
              Top = 3
              Width = 61
              Height = 21
              Caption = 'Save &As...'
              TabOrder = 2
              OnClick = Button5Click
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Properties'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 3
        Top = 7
        Width = 181
        Height = 13
        Caption = 'Cost field/expression for line direction :'
        FocusControl = CboStartToEnd
      end
      object Label4: TLabel
        Left = 3
        Top = 46
        Width = 221
        Height = 13
        Caption = 'Cost field/expression to opposite line direction :'
        FocusControl = CboEndToStart
      end
      object Label7: TLabel
        Left = 3
        Top = 85
        Width = 90
        Height = 13
        Caption = '&Street Name Field :'
        FocusControl = CboStreetName
      end
      object Label5: TLabel
        Left = 3
        Top = 153
        Width = 71
        Height = 13
        Caption = '&Working units :'
        FocusControl = CboUnits
      end
      object CboStartToEnd: TComboBox
        Left = 3
        Top = 23
        Width = 274
        Height = 24
        ItemHeight = 0
        TabOrder = 0
        Text = 'Perimeter( Ent )'
      end
      object CboEndToStart: TComboBox
        Left = 3
        Top = 59
        Width = 274
        Height = 24
        ItemHeight = 0
        TabOrder = 1
        Text = 'Perimeter( Ent )'
      end
      object btnAssist: TButton
        Left = 283
        Top = 23
        Width = 61
        Height = 20
        Caption = 'A&ssist...'
        TabOrder = 2
        OnClick = btnAssistClick
      end
      object btnAssistT: TButton
        Left = 281
        Top = 59
        Width = 61
        Height = 20
        Caption = 'A&ssist...'
        TabOrder = 3
        OnClick = btnAssistTClick
      end
      object CboStreetName: TComboBox
        Left = 3
        Top = 101
        Width = 274
        Height = 24
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
      end
      object chkSelected: TCheckBox
        Left = 3
        Top = 130
        Width = 258
        Height = 14
        Caption = 'Considere &Selected Entities as Closed Streets'
        TabOrder = 5
      end
      object CboUnits: TComboBox
        Left = 3
        Top = 169
        Width = 128
        Height = 21
        ItemHeight = 0
        TabOrder = 6
        Items.Strings = (
          'Kilometers'
          'Meters'
          'Centimeters'
          'Millimeters'
          'Miles'
          'Yards'
          'Feet'
          'Inches'
          'Nautical Miles'
          'Decimal Degrees'
          'Hours'
          'Minutes'
          'Seconds')
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Create &Network'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 19
        Top = 7
        Width = 59
        Height = 13
        Alignment = taRightJustify
        Caption = '&Base Layer :'
      end
      object Label10: TLabel
        Left = 23
        Top = 101
        Width = 117
        Height = 13
        Alignment = taRightJustify
        Caption = '&Tolerance in separation :'
      end
      object Label11: TLabel
        Left = 53
        Top = 124
        Width = 87
        Height = 13
        Alignment = taRightJustify
        Caption = '&Symbol for nodes :'
      end
      object Label12: TLabel
        Left = 82
        Top = 146
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = '&Symbol size :'
      end
      object ComboBox1: TComboBox
        Left = 81
        Top = 3
        Width = 199
        Height = 24
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnClick = CboNetworkClick
      end
      object ChkDelete: TCheckBox
        Left = 16
        Top = 33
        Width = 196
        Height = 13
        Caption = '&Deleted duplicated entities'
        TabOrder = 1
      end
      object chkErase: TCheckBox
        Left = 16
        Top = 49
        Width = 196
        Height = 14
        Caption = '&Erase short entities'
        TabOrder = 2
      end
      object chkBreak: TCheckBox
        Left = 16
        Top = 65
        Width = 196
        Height = 14
        Caption = '&Break crossing entities'
        TabOrder = 3
      end
      object chkDisolve: TCheckBox
        Left = 16
        Top = 81
        Width = 196
        Height = 14
        Caption = '&Disolve pseudo nodes'
        TabOrder = 4
      end
      object EdTolerance: TEzNumEd
        Left = 146
        Top = 98
        Width = 163
        Height = 19
        Cursor = crIBeam
        BorderColor = clDefault
        Decimals = 8
        HotTrack = False
        DecimalSeparator = ','
        ThousandSeparator = #160
        ParentColor = False
        TabOrder = 5
      end
      object Symbolsbox: TEzSymbolsGridBox
        Left = 146
        Top = 120
        Width = 163
        Height = 17
        Color = clBtnFace
        TabOrder = 6
        ParentColor = False
      end
      object EdSymbolSize: TEzNumEd
        Left = 146
        Top = 143
        Width = 163
        Height = 20
        Cursor = crIBeam
        BorderColor = clDefault
        Decimals = 0
        HotTrack = False
        DecimalSeparator = ','
        ThousandSeparator = #160
        EditFormat.RightInfo = ' Points'
        DisplayFormat.RightInfo = ' Points'
        ParentColor = False
        TabOrder = 7
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 169
        Width = 196
        Height = 14
        Caption = '&Process only selection'
        TabOrder = 8
      end
      object Button6: TButton
        Left = 114
        Top = 231
        Width = 134
        Height = 20
        Caption = '&Create Network !'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 9
      end
    end
  end
  object Network1: TEzNetwork
    SelectedAreClosed = False
    Units = 'Units'
    Left = 268
    Top = 280
  end
  object Launcher1: TEzActionLauncher
    Cursor = crHandPoint
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursorFrame, mdFullViewCursor]
    OnMouseDown = Launcher1MouseDown
    OnKeyPress = Launcher1KeyPress
    OnFinished = Launcher1Finished
    Left = 232
    Top = 280
  end
  object PrintDialog1: TPrintDialog
    Left = 60
    Top = 280
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 32
    Top = 276
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    FileName = 'Dir1.txt'
    Filter = 'Text files (*.txt)|*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save directions as...'
    Left = 104
    Top = 280
  end
end
