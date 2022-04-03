inherited KisLetterPassingEditor: TKisLetterPassingEditor
  Left = 300
  Top = 409
  ActiveControl = edDocDate
  Caption = ''
  ClientHeight = 241
  ClientWidth = 313
  Position = poMainFormCenter
  ExplicitWidth = 319
  ExplicitHeight = 273
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 128
    Top = 161
    Width = 178
    Height = 35
    AutoSize = False
    WordWrap = True
    ExplicitLeft = 128
    ExplicitTop = 161
    ExplicitWidth = 178
    ExplicitHeight = 35
  end
  object Label1: TLabel [1]
    Left = 7
    Top = 7
    Width = 26
    Height = 13
    Caption = '&'#1044#1072#1090#1072
    FocusControl = edDocDate
  end
  object Label4: TLabel [2]
    Left = 7
    Top = 119
    Width = 64
    Height = 13
    Caption = '&'#1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
    FocusControl = edContent
  end
  object Label2: TLabel [3]
    Left = 7
    Top = 45
    Width = 33
    Height = 13
    Caption = #1054#1090'&'#1076#1077#1083
    FocusControl = cbOffices
  end
  object Label3: TLabel [4]
    Left = 7
    Top = 82
    Width = 66
    Height = 13
    Caption = '&'#1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
    FocusControl = cbPeople
  end
  inherited btnOk: TButton
    Left = 149
    Top = 208
    Default = True
    TabOrder = 5
    ExplicitLeft = 149
    ExplicitTop = 208
  end
  inherited btnCancel: TButton
    Left = 230
    Top = 208
    Cancel = True
    TabOrder = 6
    ExplicitLeft = 230
    ExplicitTop = 208
  end
  object edDocDate: TEdit [7]
    Left = 7
    Top = 22
    Width = 66
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 0
    OnKeyPress = edDocDateKeyPress
  end
  object edContent: TEdit [8]
    Left = 7
    Top = 134
    Width = 299
    Height = 21
    MaxLength = 150
    TabOrder = 3
  end
  object cbOffices: TComboBox [9]
    Left = 7
    Top = 59
    Width = 299
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 13
    TabOrder = 1
  end
  object cbPeople: TComboBox [10]
    Left = 7
    Top = 97
    Width = 299
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 13
    TabOrder = 2
  end
  object chbExecuted: TCheckBox [11]
    Left = 7
    Top = 163
    Width = 91
    Height = 16
    Caption = #1048#1089#1087#1086#1083#1085#1077#1085#1086
    TabOrder = 4
  end
end
