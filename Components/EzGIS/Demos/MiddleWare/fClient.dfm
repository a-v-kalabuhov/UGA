object frmClient: TfrmClient
  Left = 196
  Top = 91
  Width = 526
  Height = 366
  Caption = 'TCP Client Connect'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 120
    Height = 24
    Caption = 'EZGIS Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 9
    Top = 45
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label3: TLabel
    Left = 165
    Top = 45
    Width = 19
    Height = 13
    Caption = 'Port'
  end
  object Bevel1: TBevel
    Left = 6
    Top = 37
    Width = 233
    Height = 61
  end
  object edtHost: TEdit
    Left = 38
    Top = 41
    Width = 121
    Height = 24
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object edtPort: TEdit
    Left = 194
    Top = 41
    Width = 41
    Height = 24
    TabOrder = 1
    Text = '8543'
  end
  object btnConnect: TButton
    Left = 82
    Top = 69
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 2
    OnClick = btnConnectClick
  end
  object btnDisconnect: TButton
    Left = 160
    Top = 69
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 3
    OnClick = btnDisconnectClick
  end
  object btnExit: TButton
    Left = 338
    Top = 237
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 4
    OnClick = btnExitClick
  end
  object lbCommunication: TListBox
    Tag = 99
    Left = 7
    Top = 103
    Width = 404
    Height = 129
    ItemHeight = 13
    TabOrder = 5
  end
end
