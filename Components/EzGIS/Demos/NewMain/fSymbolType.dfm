object frmSymbolStyle: TfrmSymbolStyle
  Left = 339
  Top = 223
  BorderStyle = bsDialog
  Caption = 'Symbol Style'
  ClientHeight = 217
  ClientWidth = 244
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 9
    Width = 31
    Height = 13
    Caption = '&Style :'
  end
  object Label2: TLabel
    Left = 13
    Top = 156
    Width = 26
    Height = 13
    Caption = '&Size :'
  end
  object symList1: TEzSymbolsListBox
    Left = 42
    Top = 7
    Width = 186
    Height = 143
    Columns = 3
    Color = clBtnFace
    ItemHeight = 50
    TabOrder = 3
  end
  object OKBtn: TButton
    Left = 34
    Top = 180
    Width = 76
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 115
    Top = 180
    Width = 74
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEzNumEd
    Left = 42
    Top = 154
    Width = 159
    Height = 20
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
    ParentColor = False
    TabOrder = 2
  end
end
