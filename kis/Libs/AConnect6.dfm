object ConnectForm: TConnectForm
  Left = 378
  Top = 223
  ActiveControl = edtServer
  BorderStyle = bsDialog
  Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
  ClientHeight = 160
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 37
    Height = 13
    Caption = '&'#1057#1077#1088#1074#1077#1088
    FocusControl = edtServer
  end
  object Label2: TLabel
    Left = 112
    Top = 32
    Width = 49
    Height = 13
    Caption = '&'#1055#1088#1086#1090#1086#1082#1086#1083
    FocusControl = cbProtocol
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 65
    Height = 13
    Caption = '&'#1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
    FocusControl = edtDatabase
  end
  object btnOk: TButton
    Left = 18
    Top = 128
    Width = 75
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 106
    Top = 128
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object btnTest: TButton
    Left = 194
    Top = 128
    Width = 75
    Height = 25
    Caption = #1058'&'#1077#1089#1090
    TabOrder = 8
    OnClick = btnTestClick
  end
  object rbLocal: TRadioButton
    Left = 8
    Top = 8
    Width = 81
    Height = 17
    Caption = '&'#1051#1086#1082#1072#1083#1100#1085#1086#1077
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = SetControls
  end
  object rbRemote: TRadioButton
    Left = 112
    Top = 8
    Width = 81
    Height = 17
    Caption = '&'#1059#1076#1072#1083#1077#1085#1085#1086#1077
    TabOrder = 1
    OnClick = SetControls
  end
  object edtServer: TEdit
    Left = 8
    Top = 48
    Width = 89
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 2
  end
  object cbProtocol: TComboBox
    Left = 112
    Top = 48
    Width = 89
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'TCP/IP'
      'NetBEUI'
      'SPX')
  end
  object btnBrowse: TButton
    Left = 208
    Top = 48
    Width = 75
    Height = 25
    Caption = #1055#1086'&'#1082#1072#1079#1072#1090#1100
    TabOrder = 4
    OnClick = btnBrowseClick
  end
  object edtDatabase: TEdit
    Left = 8
    Top = 96
    Width = 273
    Height = 21
    TabOrder = 5
  end
  object OpenDialog: TOpenDialog
    Filter = #1041#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' InterBase (*.gdb)|*.gdb|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoNetworkButton, ofEnableSizing]
    Left = 248
    Top = 80
  end
  object IBDatabase: TIBDatabase
    Params.Strings = (
      'user_name=sysdba')
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 232
    Top = 8
  end
end
