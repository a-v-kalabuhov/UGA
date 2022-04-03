inherited KisLetterVisaEditor: TKisLetterVisaEditor
  ActiveControl = edDocDate
  Caption = ''
  ClientHeight = 149
  ClientWidth = 312
  Position = poMainFormCenter
  ExplicitWidth = 318
  ExplicitHeight = 181
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 3
    Top = 113
    Width = 142
    Height = 26
    WordWrap = True
    ExplicitLeft = 3
    ExplicitTop = 113
    ExplicitWidth = 142
    ExplicitHeight = 26
  end
  object Label1: TLabel [1]
    Left = 7
    Top = 15
    Width = 26
    Height = 13
    Caption = '&'#1044#1072#1090#1072
  end
  object Label2: TLabel [2]
    Left = 74
    Top = 7
    Width = 63
    Height = 27
    AutoSize = False
    Caption = '&'#1050#1086#1085#1090#1088'. '#13#10#1076#1072#1090#1072
    WordWrap = True
  end
  object Label3: TLabel [3]
    Left = 141
    Top = 15
    Width = 43
    Height = 13
    Caption = '&'#1055#1086#1076#1087#1080#1089#1100
  end
  object Label4: TLabel [4]
    Left = 7
    Top = 74
    Width = 64
    Height = 13
    Caption = '&'#1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
  end
  inherited btnOk: TButton
    Left = 148
    Top = 116
    TabOrder = 4
    ExplicitLeft = 148
    ExplicitTop = 116
  end
  inherited btnCancel: TButton
    Left = 229
    Top = 116
    Default = True
    TabOrder = 5
    ExplicitLeft = 229
    ExplicitTop = 116
  end
  object edDocDate: TEdit [7]
    Left = 7
    Top = 37
    Width = 61
    Height = 21
    Color = clInfoBk
    MaxLength = 10
    TabOrder = 0
    OnKeyPress = edDocDateKeyPress
  end
  object edContent: TEdit [8]
    Left = 7
    Top = 89
    Width = 299
    Height = 21
    MaxLength = 150
    TabOrder = 3
  end
  object edControlDate: TEdit [9]
    Left = 74
    Top = 37
    Width = 61
    Height = 21
    MaxLength = 10
    TabOrder = 1
    OnKeyPress = edControlDateKeyPress
  end
  object cbSignature: TComboBox [10]
    Left = 141
    Top = 37
    Width = 165
    Height = 21
    Color = clInfoBk
    ItemHeight = 13
    TabOrder = 2
  end
end
