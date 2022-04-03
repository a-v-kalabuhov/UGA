object frmSelectDlg: TfrmSelectDlg
  Left = 133
  Top = 153
  BorderStyle = bsDialog
  Caption = 'Select query'
  ClientHeight = 388
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 124
    Width = 591
    Height = 264
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 5
      Width = 62
      Height = 13
      Caption = '&Display field :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 11
      Top = 222
      Width = 113
      Height = 13
      Caption = 'Selected record action :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 63
      Width = 53
      Height = 13
      Caption = 'Result set :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LblRecCount: TLabel
      Left = 73
      Top = 63
      Width = 49
      Height = 13
      Caption = '0 Records'
    end
    object btnall: TSpeedButton
      Left = 340
      Top = 4
      Width = 60
      Height = 22
      Caption = '&All Fields'
      Flat = True
      OnClick = btnallClick
    end
    object btnnone: TSpeedButton
      Left = 404
      Top = 4
      Width = 60
      Height = 22
      Caption = '&No Fields'
      Flat = True
      OnClick = btnallClick
    end
    object BtnClear: TSpeedButton
      Left = 496
      Top = 102
      Width = 88
      Height = 24
      Hint = 'Clear result set'
      Caption = 'SQL &Clear'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnClearClick
    end
    object Button2: TSpeedButton
      Left = 496
      Top = 150
      Width = 88
      Height = 23
      Caption = '&Blink'
      Flat = True
      OnClick = Button2Click
    end
    object Button3: TSpeedButton
      Left = 496
      Top = 126
      Width = 88
      Height = 24
      Caption = '&Zoom'
      Flat = True
      OnClick = Button3Click
    end
    object Button6: TSpeedButton
      Left = 496
      Top = 78
      Width = 88
      Height = 23
      Caption = 'E&xecute !'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = Button6Click
    end
    object Button4: TSpeedButton
      Left = 9
      Top = 237
      Width = 84
      Height = 24
      Caption = '&Select Result'
      Flat = True
      OnClick = Button4Click
    end
    object Button5: TSpeedButton
      Left = 97
      Top = 237
      Width = 100
      Height = 24
      Caption = 'Zoom to &Selection'
      Flat = True
      OnClick = Button5Click
    end
    object DBGrid1: TDBGrid
      Left = 8
      Top = 78
      Width = 481
      Height = 141
      DataSource = DataSource1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object Button10: TButton
      Left = 501
      Top = 237
      Width = 84
      Height = 24
      Cancel = True
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 0
      OnClick = Button10Click
    end
    object CheckList1: TCheckListBox
      Left = 81
      Top = 7
      Width = 255
      Height = 52
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 124
    Align = alTop
    TabOrder = 1
    object Button1: TSpeedButton
      Left = 509
      Top = 2
      Width = 78
      Height = 24
      Caption = '&Wizard'
      Flat = True
      OnClick = Button1Click
    end
    object BtnAddFlds: TSpeedButton
      Left = 509
      Top = 28
      Width = 78
      Height = 22
      Caption = '&Save'
      Flat = True
      Glyph.Data = {
        76060000424D7606000000000000360000002800000014000000140000000100
        2000000000004006000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000000000000828400008284000000000000000000000000000000
        00000000000000000000C6C3C600C6C3C600000000000082840000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000008284000082
        8400000000000000000000000000000000000000000000000000C6C3C600C6C3
        C600000000000082840000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000000000000828400008284000000000000000000000000000000
        00000000000000000000C6C3C600C6C3C600000000000082840000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000008284000082
        8400000000000000000000000000000000000000000000000000000000000000
        0000000000000082840000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000000000000828400008284000082840000828400008284000082
        840000828400008284000082840000828400008284000082840000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000008284000082
        8400000000000000000000000000000000000000000000000000000000000000
        0000008284000082840000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00000000000082840000000000C6C3C600C6C3C600C6C3C600C6C3
        C600C6C3C600C6C3C600C6C3C600C6C3C600000000000082840000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000008284000000
        0000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
        C600000000000082840000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00000000000082840000000000C6C3C600C6C3C600C6C3C600C6C3
        C600C6C3C600C6C3C600C6C3C600C6C3C600000000000082840000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000008284000000
        0000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
        C600000000000082840000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00000000000082840000000000C6C3C600C6C3C600C6C3C600C6C3
        C600C6C3C600C6C3C600C6C3C600C6C3C600000000000000000000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000008284000000
        0000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
        C60000000000C6C3C60000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      OnClick = BtnAddFldsClick
    end
    object SpeedButton1: TSpeedButton
      Left = 509
      Top = 53
      Width = 78
      Height = 23
      Caption = '&Open'
      Flat = True
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001863186318631863186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318630000000000000000000000000000000000000000000018631863
        1863186318630000000000420042004200420042004200420042004200001863
        1863186318630000E07F00000042004200420042004200420042004200420000
        1863186318630000FF7FE07F0000004200420042004200420042004200420042
        0000186318630000E07FFF7FE07F000000420042004200420042004200420042
        0042000018630000FF7FE07FFF7FE07F00000000000000000000000000000000
        0000000000000000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F000018631863
        1863186318630000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F000018631863
        1863186318630000E07FFF7FE07F000000000000000000000000000018631863
        1863186318631863000000000000186318631863186318631863186318630000
        0000000018631863186318631863186318631863186318631863186318631863
        0000000018631863186318631863186318631863186300001863186318630000
        1863000018631863186318631863186318631863186318630000000000001863
        1863186318631863186318631863186318631863186318631863186318631863
        186318631863}
      OnClick = SpeedButton1Click
    end
    object MemoWhere: TMemo
      Left = 1
      Top = 1
      Width = 505
      Height = 122
      Cursor = crIBeam
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = []
      Lines.Strings = (
        'Recno Between 1 And 1000000')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 192
    Top = 326
  end
  object Table1: TEzTable
    ReadOnly = True
    MaxRecords = 0
    UseDeleted = False
    Left = 224
    Top = 328
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'sql'
    Filter = 'Select Query Files (*.sql)|*.sqf'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open select query'
    Left = 472
    Top = 83
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'SQL'
    Filter = 'Select Query Files (*.sqf)|*.sqf'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save Select query'
    Left = 472
    Top = 51
  end
  object PopupMenu1: TPopupMenu
    Left = 640
    Top = 40
    object StandardExpression1: TMenuItem
      Caption = '&Standard Expression...'
      OnClick = StandardExpression1Click
    end
    object VectorialExpression1: TMenuItem
      Caption = '&Vectorial Expression...'
      OnClick = VectorialExpression1Click
    end
    object JOINLayersExpression1: TMenuItem
      Caption = '&JOIN Layers Expression...'
      OnClick = JOINLayersExpression1Click
    end
  end
end
