object SortForm: TSortForm
  Left = 284
  Top = 192
  ActiveControl = lbAllFields
  BorderStyle = bsDialog
  Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
  ClientHeight = 297
  ClientWidth = 425
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
    Top = 8
    Width = 84
    Height = 13
    Caption = '&'#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1087#1086#1083#1103
    FocusControl = lbAllFields
  end
  object btnUp: TSpeedButton
    Left = 200
    Top = 160
    Width = 25
    Height = 25
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00000DDDDDDDDDDD06660DD
      DDDDDDDDD06660DDDDDDDDDDD06660DDDDDDDD00006660000DDDDDD066666660
      DDDDDDDD0666660DDDDDDDDDD06660DDDDDDDDDDDD060DDDDDDDDDDDDDD0DDDD
      DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
    OnClick = btnUpClick
  end
  object btnDown: TSpeedButton
    Left = 200
    Top = 185
    Width = 25
    Height = 25
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD0DDDDDDDDDDDDDD060DDD
      DDDDDDDDD06660DDDDDDDDDD0666660DDDDDDDD066666660DDDDDD0000666000
      0DDDDDDDD06660DDDDDDDDDDD06660DDDDDDDDDDD06660DDDDDDDDDDD00000DD
      DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
    OnClick = btnDownClick
  end
  object Label2: TLabel
    Left = 232
    Top = 8
    Width = 115
    Height = 13
    Caption = '&'#1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1087#1086#1083#1103#1084
    FocusControl = lbOrderFields
  end
  object Label3: TLabel
    Left = 232
    Top = 264
    Width = 144
    Height = 13
    Caption = #1052#1077#1090#1082#1072' - '#1074' '#1086#1073#1088#1072#1090#1085#1086#1084' '#1087#1086#1088#1103#1076#1082#1077
  end
  object btnOk: TButton
    Left = 8
    Top = 264
    Width = 75
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 96
    Top = 264
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object lbOrderFields: TCheckListBox
    Left = 232
    Top = 24
    Width = 185
    Height = 233
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = btnRemoveClick
  end
  object lbAllFields: TListBox
    Left = 8
    Top = 24
    Width = 185
    Height = 233
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = btnAddClick
  end
  object btnAdd: TButton
    Left = 200
    Top = 24
    Width = 25
    Height = 25
    Caption = '>'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 200
    Top = 56
    Width = 25
    Height = 25
    Caption = '<'
    TabOrder = 2
    OnClick = btnRemoveClick
  end
  object btnAddAll: TButton
    Left = 200
    Top = 88
    Width = 25
    Height = 25
    Caption = '>>'
    TabOrder = 3
    OnClick = btnAddAllClick
  end
  object btnRemoveAll: TButton
    Left = 200
    Top = 120
    Width = 25
    Height = 25
    Caption = '<<'
    TabOrder = 4
    OnClick = btnRemoveAllClick
  end
end
