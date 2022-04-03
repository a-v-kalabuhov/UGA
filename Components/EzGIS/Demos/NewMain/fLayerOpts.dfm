object frmLayerOptions: TfrmLayerOptions
  Left = 232
  Top = 189
  BorderStyle = bsDialog
  Caption = 'Layer Options'
  ClientHeight = 327
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 33
    Align = alTop
    TabOrder = 0
    object Label30: TLabel
      Left = 144
      Top = 12
      Width = 63
      Height = 13
      Caption = '&Layer Name :'
    end
    object Button1: TButton
      Left = 4
      Top = 4
      Width = 61
      Height = 25
      Caption = '&Accept'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 72
      Top = 4
      Width = 61
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object GridBox1: TComboBox
      Left = 212
      Top = 8
      Width = 249
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = GridBox1Change
    end
  end
  object dxPageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 480
    Height = 294
    ActivePage = dxTabSheet11
    Align = alClient
    HotTrack = True
    MultiLine = True
    TabOrder = 1
    object dxTabSheet11: TTabSheet
      Caption = '&General'
      object Label25: TLabel
        Left = 48
        Top = 36
        Width = 78
        Height = 13
        Caption = '&Text Fixed Size :'
      end
      object Label26: TLabel
        Left = 12
        Top = 56
        Width = 113
        Height = 13
        Caption = '&Overlapped text action :'
      end
      object Label27: TLabel
        Left = 16
        Top = 84
        Width = 107
        Height = 13
        Caption = 'Overlapped &text color :'
      end
      object Label31: TLabel
        Left = 4
        Top = 112
        Width = 123
        Height = 13
        Caption = 'Structure of Attached file :'
      end
      object Label1: TLabel
        Left = 312
        Top = 3
        Width = 129
        Height = 13
        Caption = '&Select only entities of type :'
      end
      object SpeedButton5: TSpeedButton
        Left = 315
        Top = 16
        Width = 66
        Height = 17
        Caption = '&All'
      end
      object SpeedButton6: TSpeedButton
        Left = 384
        Top = 16
        Width = 65
        Height = 17
        Caption = '&None'
      end
      object EzColorBox8: TEzColorBox
        Left = 128
        Top = 80
        Width = 169
        Height = 21
        TabOrder = 5
        TabStop = True
        CustomText = 'More Colors...'
        Flat = True
        PopupSpacing = 8
        ShowSystemColors = False
      end
      object dxCheckEdit19: TCheckBox
        Left = 128
        Top = 8
        Width = 117
        Height = 17
        Caption = '&Text Has Shadow'
        TabOrder = 0
      end
      object DBGrid2: TDBGrid
        Left = 0
        Top = 127
        Width = 472
        Height = 121
        Align = alBottom
        DataSource = DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'FIELDNAME'
            Title.Caption = 'Field Name'
            Width = 129
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TYPE'
            PickList.Strings = (
              'C - CHARACTER'
              'L - LOGICAL'
              'D - DATE'
              'N - NUMERIC'
              'M - MEMO'
              'B - BINARY'
              'G - GRAPHIC')
            Title.Caption = 'Type'
            Width = 61
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SIZE'
            Title.Caption = 'Size'
            Width = 69
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DEC'
            Title.Caption = 'Dec'
            Width = 53
            Visible = True
          end>
      end
      object dxSpinEdit8: TEdit
        Left = 128
        Top = 32
        Width = 69
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object UpDown1: TUpDown
        Left = 197
        Top = 32
        Width = 16
        Height = 21
        Associate = dxSpinEdit8
        TabOrder = 4
      end
      object dxPickEdit1: TComboBox
        Left = 128
        Top = 56
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          'None'
          'Hide Overlapped'
          'Show Overlapped On Color')
      end
      object CheckListBox1: TCheckListBox
        Left = 312
        Top = 36
        Width = 160
        Height = 92
        ItemHeight = 13
        TabOrder = 6
      end
    end
    object dxTabSheet1: TTabSheet
      Caption = '&Overrides'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dxPageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 472
        Height = 248
        ActivePage = dxTabSheet7
        Align = alClient
        HotTrack = True
        TabOrder = 0
        ExplicitWidth = 474
        ExplicitHeight = 271
        object dxTabSheet7: TTabSheet
          Caption = '&Pen Style'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object ezPenColorBox1: TEzColorBox
            Left = 68
            Top = 88
            Width = 121
            Height = 21
            TabOrder = 8
            TabStop = True
            CustomText = '&More Colors...'
            Flat = True
            PopupSpacing = 8
            ShowSystemColors = False
          end
          object dxchkOverridePen: TCheckBox
            Left = 8
            Top = 16
            Width = 89
            Height = 17
            Caption = '&Override pen'
            TabOrder = 0
          end
          object ezPenStyleBox1: TEzLineTypeGridBox
            Left = 68
            Top = 40
            Width = 189
            Height = 21
            DropDownCols = 4
            Color = clBtnFace
            TabOrder = 1
            ParentColor = False
            Repit = 0
          end
          object dxKeepSamePen1: TCheckBox
            Left = 44
            Top = 112
            Width = 197
            Height = 17
            Caption = '&Keep same line width to every zoom'
            TabOrder = 2
          end
          object dxCheckEdit18: TCheckBox
            Left = 8
            Top = 40
            Width = 57
            Height = 17
            Caption = '&Style :'
            TabOrder = 3
          end
          object dxCheckEdit27: TCheckBox
            Left = 8
            Top = 64
            Width = 57
            Height = 17
            Caption = '&Width :'
            TabOrder = 4
          end
          object dxCheckEdit28: TCheckBox
            Left = 8
            Top = 88
            Width = 57
            Height = 17
            Caption = '&Color :'
            TabOrder = 5
          end
          object dxSpinPenWidth1: TEdit
            Left = 68
            Top = 64
            Width = 97
            Height = 24
            TabOrder = 7
            Text = '0'
          end
          object UpDown4: TUpDown
            Left = 165
            Top = 64
            Width = 16
            Height = 20
            Associate = dxSpinPenWidth1
            TabOrder = 6
          end
        end
        object dxTabSheet8: TTabSheet
          Caption = '&Brush Style'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object EzForeColor1: TEzColorBox
            Left = 92
            Top = 64
            Width = 121
            Height = 21
            TabOrder = 5
            TabStop = True
            CustomText = '&More colors...'
            Flat = True
            PopupSpacing = 8
            ShowSystemColors = False
          end
          object EzBackColor1: TEzColorBox
            Left = 92
            Top = 88
            Width = 121
            Height = 21
            TabOrder = 6
            TabStop = True
            CustomText = '&More colors...'
            NoneColorText = '&Transparent'
            Flat = True
            PopupSpacing = 8
            ShowSystemColors = False
          end
          object dxCheckEdit2: TCheckBox
            Left = 8
            Top = 16
            Width = 109
            Height = 17
            Caption = '&Override brush'
            TabOrder = 0
          end
          object BrushBox1: TEzBrushPatternGridBox
            Left = 92
            Top = 40
            Width = 121
            Height = 21
            DropDownCols = 4
            Color = clBtnFace
            TabOrder = 1
            ParentColor = False
          end
          object dxCheckEdit29: TCheckBox
            Left = 8
            Top = 40
            Width = 81
            Height = 17
            Caption = '&Style :'
            TabOrder = 4
          end
          object dxCheckEdit30: TCheckBox
            Left = 8
            Top = 64
            Width = 81
            Height = 17
            Caption = '&ForeColor :'
            TabOrder = 2
          end
          object dxCheckEdit31: TCheckBox
            Left = 8
            Top = 88
            Width = 81
            Height = 17
            Caption = '&BackColor :'
            TabOrder = 3
          end
        end
        object dxTabSheet9: TTabSheet
          Caption = '&Symbol Style'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object dxchkSymbolOverr: TCheckBox
            Left = 32
            Top = 16
            Width = 109
            Height = 17
            Caption = '&Override symbol'
            TabOrder = 0
          end
          object EzSymbolsGridBox1: TEzSymbolsGridBox
            Left = 92
            Top = 40
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 1
            ParentColor = False
          end
          object dxCheckEdit5: TCheckBox
            Left = 68
            Top = 88
            Width = 205
            Height = 17
            Caption = '&Keep same symbol size to every zoom'
            TabOrder = 2
          end
          object dxCheckEdit32: TCheckBox
            Left = 32
            Top = 40
            Width = 57
            Height = 17
            Caption = '&Style :'
            TabOrder = 3
          end
          object dxCheckEdit33: TCheckBox
            Left = 32
            Top = 64
            Width = 57
            Height = 17
            Caption = '&Size :'
            TabOrder = 4
          end
          object dxSpinEdit2: TEdit
            Left = 92
            Top = 64
            Width = 97
            Height = 24
            TabOrder = 5
            Text = '0'
          end
          object UpDown2: TUpDown
            Left = 189
            Top = 64
            Width = 16
            Height = 20
            Associate = dxSpinEdit2
            TabOrder = 6
          end
        end
        object dxTabSheet10: TTabSheet
          Caption = '&Font Style'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object EzColorGridBox5: TEzColorBox
            Left = 92
            Top = 168
            Width = 97
            Height = 21
            TabOrder = 13
            TabStop = True
            CustomText = 'More colors...'
            Flat = True
            PopupSpacing = 8
            ShowSystemColors = False
          end
          object dxCheckEdit6: TCheckBox
            Left = 92
            Top = 16
            Width = 109
            Height = 17
            Caption = '&Override font'
            TabOrder = 0
          end
          object ListBox1: TListBox
            Left = 92
            Top = 44
            Width = 225
            Height = 97
            ItemHeight = 16
            TabOrder = 1
          end
          object dxCheckEdit7: TCheckBox
            Left = 68
            Top = 192
            Width = 205
            Height = 17
            Caption = '&Keep same font size to every zoom'
            TabOrder = 2
          end
          object chkBold: TCheckBox
            Left = 324
            Top = 44
            Width = 121
            Height = 17
            Caption = '&Bold'
            TabOrder = 3
          end
          object chkItalic: TCheckBox
            Left = 324
            Top = 68
            Width = 121
            Height = 17
            Caption = '&Italic'
            TabOrder = 4
          end
          object chkUnderline: TCheckBox
            Left = 324
            Top = 92
            Width = 121
            Height = 17
            Caption = '&Underline'
            TabOrder = 5
          end
          object chkStrikeout: TCheckBox
            Left = 324
            Top = 116
            Width = 121
            Height = 17
            Caption = '&Strikeout'
            TabOrder = 6
          end
          object dxCheckEdit34: TCheckBox
            Left = 28
            Top = 44
            Width = 61
            Height = 17
            Caption = '&Name :'
            TabOrder = 7
          end
          object dxCheckEdit35: TCheckBox
            Left = 324
            Top = 20
            Width = 121
            Height = 17
            Caption = '&Style :'
            TabOrder = 8
          end
          object dxCheckEdit36: TCheckBox
            Left = 32
            Top = 144
            Width = 57
            Height = 17
            Caption = '&Size :'
            TabOrder = 9
          end
          object dxCheckEdit37: TCheckBox
            Left = 32
            Top = 168
            Width = 57
            Height = 17
            Caption = '&Color :'
            TabOrder = 10
          end
          object dxSpinEdit3: TEdit
            Left = 92
            Top = 144
            Width = 97
            Height = 24
            TabOrder = 12
            Text = '0'
          end
          object UpDown3: TUpDown
            Left = 189
            Top = 144
            Width = 16
            Height = 19
            Associate = dxSpinEdit3
            TabOrder = 11
          end
        end
      end
    end
    object dxTabSheet2: TTabSheet
      Caption = '&Zoom Ranges'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dxPageControl3: TPageControl
        Left = 0
        Top = 0
        Width = 472
        Height = 248
        ActivePage = dxTabSheet12
        Align = alClient
        HotTrack = True
        TabOrder = 0
        ExplicitWidth = 474
        ExplicitHeight = 271
        object dxTabSheet12: TTabSheet
          Caption = 'Zoom &Range'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Label12: TLabel
            Left = 9
            Top = 44
            Width = 89
            Height = 13
            Alignment = taRightJustify
            Caption = '&Min Zoom Scale 1:'
          end
          object Label14: TLabel
            Left = 6
            Top = 72
            Width = 92
            Height = 13
            Alignment = taRightJustify
            Caption = '&Max Zoom Scale 1:'
          end
          object dxCheckEdit8: TCheckBox
            Left = 100
            Top = 12
            Width = 125
            Height = 17
            Caption = '&Active range'
            TabOrder = 0
          end
          object dxSpinEdit4: TEzNumEd
            Left = 103
            Top = 40
            Width = 125
            Height = 24
            Cursor = crIBeam
            BorderStyle = ebsFlat
            BorderColor = clBlack
            Decimals = 4
            HotTrack = False
            DecimalSeparator = ','
            ThousandSeparator = #160
            ParentColor = False
            TabOrder = 1
          end
          object dxSpinEdit5: TEzNumEd
            Left = 103
            Top = 68
            Width = 125
            Height = 24
            Cursor = crIBeam
            BorderStyle = ebsFlat
            BorderColor = clBlack
            Decimals = 4
            HotTrack = False
            DecimalSeparator = ','
            ThousandSeparator = #160
            ParentColor = False
            TabOrder = 2
          end
        end
        object dxTabSheet13: TTabSheet
          Caption = '&Text Zoom Range'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Label15: TLabel
            Left = 9
            Top = 44
            Width = 89
            Height = 13
            Alignment = taRightJustify
            Caption = '&Min Zoom Scale 1:'
          end
          object Label16: TLabel
            Left = 6
            Top = 72
            Width = 92
            Height = 13
            Alignment = taRightJustify
            Caption = '&Max Zoom Scale 1:'
          end
          object dxCheckEdit9: TCheckBox
            Left = 100
            Top = 12
            Width = 125
            Height = 17
            Caption = '&Active range'
            TabOrder = 0
          end
          object dxSpinEdit6: TEzNumEd
            Left = 103
            Top = 40
            Width = 125
            Height = 24
            Cursor = crIBeam
            BorderStyle = ebsFlat
            BorderColor = clBlack
            Decimals = 4
            HotTrack = False
            DecimalSeparator = ','
            ThousandSeparator = #160
            ParentColor = False
            TabOrder = 1
          end
          object dxSpinEdit7: TEzNumEd
            Left = 103
            Top = 68
            Width = 125
            Height = 24
            Cursor = crIBeam
            BorderStyle = ebsFlat
            BorderColor = clBlack
            Decimals = 4
            HotTrack = False
            DecimalSeparator = ','
            ThousandSeparator = #160
            ParentColor = False
            TabOrder = 2
          end
        end
      end
    end
    object dxTabSheet3: TTabSheet
      Caption = '&Line Direction'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label17: TLabel
        Left = 12
        Top = 64
        Width = 53
        Height = 13
        Caption = '&Line Color :'
      end
      object Label18: TLabel
        Left = 20
        Top = 88
        Width = 45
        Height = 13
        Caption = '&Fill Color :'
      end
      object EzColorGridBox6: TEzColorBox
        Left = 72
        Top = 60
        Width = 121
        Height = 21
        TabOrder = 3
        TabStop = True
        CustomText = 'More colors...'
        Flat = True
        PopupSpacing = 8
        ShowSystemColors = False
      end
      object EzColorGridBox7: TEzColorBox
        Left = 72
        Top = 84
        Width = 121
        Height = 21
        TabOrder = 4
        TabStop = True
        CustomText = 'More colors...'
        NoneColorText = '&Transparent'
        Flat = True
        PopupSpacing = 8
        ShowSystemColors = False
      end
      object dxCheckEdit10: TCheckBox
        Left = 72
        Top = 12
        Width = 125
        Height = 17
        Caption = '&Show Line Direction'
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 72
        Top = 108
        Width = 121
        Height = 93
        Caption = 'Line Position'
        TabOrder = 1
        object dxCheckEdit11: TCheckBox
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Caption = '&Start'
          TabOrder = 0
        end
        object dxCheckEdit12: TCheckBox
          Left = 8
          Top = 40
          Width = 105
          Height = 17
          Caption = '&Middle'
          TabOrder = 1
        end
        object dxCheckEdit13: TCheckBox
          Left = 8
          Top = 64
          Width = 105
          Height = 17
          Caption = '&End'
          TabOrder = 2
        end
      end
      object dxCheckEdit17: TCheckBox
        Left = 72
        Top = 36
        Width = 125
        Height = 17
        Caption = '&Revert Direction'
        TabOrder = 2
      end
    end
    object dxTabSheet4: TTabSheet
      Caption = '&Select Filter'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label19: TLabel
        Left = 16
        Top = 12
        Width = 89
        Height = 13
        Caption = '&Select expression :'
      end
      object SpeedButton1: TSpeedButton
        Left = 392
        Top = 4
        Width = 73
        Height = 22
        Caption = '&Assist...'
        Flat = True
        OnClick = SpeedButton1Click
      end
      object Label20: TLabel
        Left = 20
        Top = 152
        Width = 344
        Height = 26
        Caption = 
          'Entities will be selected with any selection tool, only when the' +
          ' expression above evaluates to true for the given entity.'
        WordWrap = True
      end
      object dxMemo1: TMemo
        Left = 20
        Top = 28
        Width = 453
        Height = 89
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object dxCheckEdit14: TCheckBox
        Left = 20
        Top = 120
        Width = 77
        Height = 17
        Caption = '&Active'
        TabOrder = 1
      end
    end
    object dxTabSheet5: TTabSheet
      Caption = '&Hints'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label21: TLabel
        Left = 16
        Top = 12
        Width = 78
        Height = 13
        Caption = '&Hint expression :'
      end
      object Label22: TLabel
        Left = 20
        Top = 152
        Width = 391
        Height = 26
        Caption = 
          'When the hint action is active and you move the mouse over an en' +
          'tity, the hint will be displayed based on the value returned fro' +
          'm the expression above.'
        WordWrap = True
      end
      object SpeedButton2: TSpeedButton
        Left = 400
        Top = 4
        Width = 73
        Height = 22
        Caption = '&Assist...'
        Flat = True
        OnClick = SpeedButton2Click
      end
      object dxMemo2: TMemo
        Left = 20
        Top = 28
        Width = 453
        Height = 89
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object dxCheckEdit15: TCheckBox
        Left = 20
        Top = 120
        Width = 77
        Height = 17
        Caption = '&Active'
        TabOrder = 1
      end
    end
    object dxTabSheet6: TTabSheet
      Caption = '&Visibility Filter'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label23: TLabel
        Left = 16
        Top = 12
        Width = 83
        Height = 13
        Caption = '&Expression used :'
      end
      object SpeedButton3: TSpeedButton
        Left = 400
        Top = 4
        Width = 73
        Height = 22
        Caption = '&Assist...'
        Flat = True
        OnClick = SpeedButton3Click
      end
      object Label24: TLabel
        Left = 20
        Top = 152
        Width = 335
        Height = 26
        Caption = 
          'Entities will be made invisible when the expression above return' +
          ' a false value when evaluated against any entity.'
        WordWrap = True
      end
      object dxMemo3: TMemo
        Left = 20
        Top = 28
        Width = 453
        Height = 89
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object dxCheckEdit16: TCheckBox
        Left = 20
        Top = 120
        Width = 77
        Height = 17
        Caption = '&Active'
        TabOrder = 1
      end
    end
    object dxTabSheet14: TTabSheet
      Caption = '&Labeling'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 144
        Top = 12
        Width = 83
        Height = 13
        Caption = '&Expression used :'
      end
      object SpeedButton4: TSpeedButton
        Left = 396
        Top = 4
        Width = 73
        Height = 22
        Caption = '&Assist...'
        Flat = True
        OnClick = SpeedButton4Click
      end
      object Label28: TLabel
        Left = 146
        Top = 203
        Width = 26
        Height = 13
        Caption = '&Size :'
      end
      object Label29: TLabel
        Left = 145
        Top = 227
        Width = 30
        Height = 13
        Caption = '&Color :'
      end
      object cboColor: TEzColorBox
        Left = 176
        Top = 222
        Width = 121
        Height = 22
        TabOrder = 10
        TabStop = True
        CustomText = 'More Colors...'
        Flat = True
        PopupSpacing = 8
        ShowSystemColors = False
      end
      object dxCheckEdit1: TCheckBox
        Left = 8
        Top = 4
        Width = 133
        Height = 17
        Caption = 'Labeling &Active'
        TabOrder = 0
      end
      object dxMemo4: TMemo
        Left = 144
        Top = 28
        Width = 329
        Height = 41
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object dxCheckEdit3: TCheckBox
        Left = 8
        Top = 28
        Width = 133
        Height = 17
        Caption = '&Align to line segments'
        TabOrder = 2
      end
      object dxCheckEdit4: TCheckBox
        Left = 8
        Top = 52
        Width = 133
        Height = 17
        Caption = '&Repeat in all segments'
        TabOrder = 3
      end
      object dxCheckEdit20: TCheckBox
        Left = 8
        Top = 76
        Width = 133
        Height = 17
        Caption = '&Smart showing'
        TabOrder = 4
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 124
        Width = 133
        Height = 121
        Caption = 'Label Position'
        TabOrder = 5
        object Shape1: TShape
          Left = 44
          Top = 44
          Width = 45
          Height = 45
          Brush.Color = clMaroon
          Shape = stCircle
        end
        object sbCenter: TSpeedButton
          Left = 52
          Top = 56
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbCenterUp: TSpeedButton
          Tag = 1
          Left = 52
          Top = 20
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbUpperRight: TSpeedButton
          Tag = 3
          Left = 92
          Top = 20
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbCenterRight: TSpeedButton
          Tag = 5
          Left = 92
          Top = 56
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbLowerRight: TSpeedButton
          Tag = 8
          Left = 92
          Top = 92
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbCenterDown: TSpeedButton
          Tag = 7
          Left = 52
          Top = 92
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbLowerLeft: TSpeedButton
          Tag = 6
          Left = 12
          Top = 92
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbCenterLeft: TSpeedButton
          Tag = 4
          Left = 12
          Top = 56
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
        object sbUpperLeft: TSpeedButton
          Tag = 2
          Left = 12
          Top = 20
          Width = 29
          Height = 22
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Text'
          Flat = True
          OnClick = sbCenterClick
        end
      end
      object dxCheckEdit21: TCheckBox
        Left = 8
        Top = 100
        Width = 133
        Height = 17
        Caption = 'Use &True Type fonts'
        TabOrder = 6
      end
      object PageControl1: TPageControl
        Left = 147
        Top = 72
        Width = 322
        Height = 125
        ActivePage = TabSheet2
        TabOrder = 7
        object TabSheet1: TTabSheet
          Caption = 'Vectorial'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object LstFonts: TListBox
            Left = 0
            Top = 0
            Width = 315
            Height = 99
            Align = alClient
            ItemHeight = 16
            TabOrder = 0
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'True Type'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 237
            Height = 99
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object LstTTFonts: TListBox
              Left = 0
              Top = 0
              Width = 237
              Height = 99
              Align = alClient
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object dxCheckEdit22: TCheckBox
            Left = 240
            Top = 4
            Width = 73
            Height = 17
            Caption = '&Bold'
            TabOrder = 1
          end
          object dxCheckEdit23: TCheckBox
            Left = 240
            Top = 28
            Width = 73
            Height = 17
            Caption = '&Italic'
            TabOrder = 2
          end
          object dxCheckEdit24: TCheckBox
            Left = 240
            Top = 52
            Width = 73
            Height = 17
            Caption = '&Underline'
            TabOrder = 3
          end
          object dxCheckEdit25: TCheckBox
            Left = 240
            Top = 76
            Width = 73
            Height = 17
            Caption = '&Strikeout'
            TabOrder = 4
          end
        end
      end
      object EdSize: TEzNumEd
        Left = 176
        Top = 199
        Width = 121
        Height = 21
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
        Ctl3D = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 8
      end
      object dxCheckEdit26: TCheckBox
        Left = 300
        Top = 200
        Width = 141
        Height = 17
        Caption = '&Keep same font size'
        TabOrder = 9
      end
    end
  end
  object DataSource1: TDataSource
    Left = 268
    Top = 228
  end
end
