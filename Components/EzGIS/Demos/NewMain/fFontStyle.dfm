object frmFontStyle: TfrmFontStyle
  Left = 328
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Font Style'
  ClientHeight = 368
  ClientWidth = 330
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 3
    Width = 59
    Height = 13
    Caption = '&Font Name :'
  end
  object Label4: TLabel
    Left = 10
    Top = 166
    Width = 29
    Height = 13
    Caption = '&View :'
  end
  object PaintBox1: TPaintBox
    Left = 10
    Top = 182
    Width = 315
    Height = 72
    OnPaint = PaintBox1Paint
  end
  object Label2: TLabel
    Left = 45
    Top = 263
    Width = 32
    Height = 13
    Caption = '&Color :'
  end
  object Label3: TLabel
    Left = 50
    Top = 286
    Width = 26
    Height = 13
    Caption = '&Size :'
  end
  object Label5: TLabel
    Left = 9
    Top = 309
    Width = 65
    Height = 13
    Caption = 'Sample &Text :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object cboColor: TEzColorBox
    Left = 80
    Top = 259
    Width = 173
    Height = 22
    TabOrder = 6
    TabStop = True
    CustomText = '&More Colors...'
    Flat = True
    ParentShowHint = False
    PopupSpacing = 8
    ShowHint = True
    ShowSystemColors = True
  end
  object OKBtn: TButton
    Left = 103
    Top = 336
    Width = 76
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 184
    Top = 336
    Width = 74
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Button1: TButton
    Left = 257
    Top = 309
    Width = 53
    Height = 20
    Caption = '&Refresh'
    TabOrder = 2
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 20
    Width = 317
    Height = 141
    ActivePage = TabSheet1
    TabOrder = 3
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Vectorial'
      object LstFonts: TListBox
        Left = 0
        Top = 0
        Width = 309
        Height = 113
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = LstFontsClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'True Type'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 237
        Height = 115
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object LstTTFonts: TListBox
          Left = 0
          Top = 0
          Width = 237
          Height = 115
          Align = alClient
          ItemHeight = 16
          TabOrder = 0
          OnClick = LstFontsClick
        end
      end
      object ChkBold: TCheckBox
        Left = 244
        Top = 8
        Width = 97
        Height = 17
        Caption = '&Bold'
        TabOrder = 1
        OnClick = LstFontsClick
      end
      object ChkItalic: TCheckBox
        Left = 244
        Top = 32
        Width = 97
        Height = 17
        Caption = '&Italic'
        TabOrder = 2
        OnClick = LstFontsClick
      end
      object ChkUnderline: TCheckBox
        Left = 244
        Top = 52
        Width = 97
        Height = 17
        Caption = '&Underline'
        TabOrder = 3
        OnClick = LstFontsClick
      end
    end
  end
  object CboSize: TEzNumEd
    Left = 80
    Top = 284
    Width = 173
    Height = 21
    Cursor = crIBeam
    BorderStyle = ebsFlat
    BorderColor = clDefault
    HotTrack = False
    DecimalSeparator = ','
    ThousandSeparator = #160
    AcceptNegatives = False
    EditFormat.RightInfo = ' Pts.'
    DisplayFormat.RightInfo = ' Pts.'
    DisplayFormat.NegUseParens = True
    OnChange = LstFontsClick
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 80
    Top = 308
    Width = 173
    Height = 21
    TabOrder = 5
    Text = 'AaBbCcDdEeFfGgHhIiJjKkLlMm'
  end
end
