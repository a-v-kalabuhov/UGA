inherited KisArchDocMoveEditor: TKisArchDocMoveEditor
  Left = 342
  Top = 353
  Caption = ''
  ClientHeight = 234
  ClientWidth = 390
  Position = poDesktopCenter
  ExplicitWidth = 396
  ExplicitHeight = 266
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 8
    Top = 200
    Width = 155
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = #1046#1077#1083#1090#1099#1077' '#1087#1086#1083#1103' '#13#10#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103'!'
    ExplicitLeft = 8
    ExplicitTop = 200
    ExplicitWidth = 155
    ExplicitHeight = 26
  end
  object Label1: TLabel [1]
    Left = 6
    Top = 6
    Width = 97
    Height = 26
    Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080' '#13#10#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1085#1072' '#1088#1091#1082#1080
  end
  object Label2: TLabel [2]
    Left = 262
    Top = 6
    Width = 94
    Height = 26
    Caption = #1057#1088#1086#1082', '#1085#1072' '#1082#1086#1090#1086#1088#1099#1081' '#13#10#1074#1099#1076#1072#1085' '#1076#1086#1082#1091#1084#1077#1085#1090
  end
  object Label3: TLabel [3]
    Left = 134
    Top = 22
    Width = 76
    Height = 13
    Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
  end
  object Label4: TLabel [4]
    Left = 6
    Top = 62
    Width = 33
    Height = 13
    Caption = #1054#1090#1076#1077#1083
  end
  object Label5: TLabel [5]
    Left = 6
    Top = 102
    Width = 66
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
  end
  object Label6: TLabel [6]
    Left = 6
    Top = 142
    Width = 50
    Height = 13
    Caption = #8470' '#1079#1072#1082#1072#1079#1072
  end
  object Label7: TLabel [7]
    Left = 70
    Top = 142
    Width = 45
    Height = 13
    Caption = #8470' '#1089#1095#1077#1090#1072
  end
  inherited btnOk: TButton
    Left = 226
    Top = 201
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 226
    ExplicitTop = 177
  end
  inherited btnCancel: TButton
    Left = 307
    Top = 201
    Anchors = [akRight, akBottom]
    Default = True
    TabOrder = 8
    ExplicitLeft = 307
    ExplicitTop = 177
  end
  object edDateOfGive: TEdit [10]
    Left = 6
    Top = 38
    Width = 121
    Height = 21
    Color = clInfoBk
    TabOrder = 0
    Text = 'edDateOfGive'
    OnKeyUp = edDateKeyUp
  end
  object edTerm: TEdit [11]
    Left = 262
    Top = 38
    Width = 115
    Height = 21
    Color = clInfoBk
    TabOrder = 2
    Text = 'edTerm'
    OnKeyUp = edIntegerKeyUp
  end
  object edDateOfBack: TEdit [12]
    Left = 134
    Top = 38
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edDateOfBack'
    OnKeyUp = edDateKeyUp
  end
  object cbOffice: TComboBox [13]
    Left = 6
    Top = 78
    Width = 377
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 0
    TabOrder = 3
  end
  object cbPeople: TComboBox [14]
    Left = 6
    Top = 118
    Width = 377
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 0
    TabOrder = 4
  end
  object edOrderNumber: TEdit [15]
    Left = 6
    Top = 158
    Width = 51
    Height = 21
    Color = clInfoBk
    TabOrder = 5
    Text = 'edOrderNumber'
    OnKeyUp = edIntegerKeyUp
  end
  object edOrderAccount: TEdit [16]
    Left = 70
    Top = 158
    Width = 59
    Height = 21
    Color = clInfoBk
    TabOrder = 6
    Text = 'edOrderAccount'
    OnKeyUp = edIntegerKeyUp
  end
end
