inherited KisAddressEditor: TKisAddressEditor
  Left = 249
  Top = 164
  Caption = 'KisAddressEditor'
  ClientHeight = 256
  ClientWidth = 557
  OldCreateOrder = True
  Position = poDesktopCenter
  ExplicitWidth = 563
  ExplicitHeight = 288
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 62
    Top = 228
    ExplicitLeft = 62
    ExplicitTop = 228
  end
  object Label1: TLabel [1]
    Left = 15
    Top = 11
    Width = 37
    Height = 13
    Caption = #1048#1085#1076#1077#1082#1089
  end
  object Label2: TLabel [2]
    Left = 299
    Top = 42
    Width = 43
    Height = 13
    Caption = #1054#1073#1083#1072#1089#1090#1100
  end
  object Label3: TLabel [3]
    Left = 15
    Top = 98
    Width = 95
    Height = 13
    Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
  end
  object Label4: TLabel [4]
    Left = 14
    Top = 69
    Width = 74
    Height = 13
    Caption = #1056#1072#1081#1086#1085' '#1086#1073#1083#1072#1089#1090#1080
  end
  object Label5: TLabel [5]
    Left = 15
    Top = 158
    Width = 31
    Height = 13
    Caption = #1059#1083#1080#1094#1072
  end
  object Label6: TLabel [6]
    Left = 15
    Top = 187
    Width = 20
    Height = 13
    Caption = #1044#1086#1084
  end
  object Label7: TLabel [7]
    Left = 167
    Top = 187
    Width = 36
    Height = 13
    Caption = #1050#1086#1088#1087#1091#1089
  end
  object Label8: TLabel [8]
    Left = 278
    Top = 187
    Width = 49
    Height = 13
    Caption = #1050#1074#1072#1088#1090#1080#1088#1072
  end
  object Label9: TLabel [9]
    Left = 14
    Top = 42
    Width = 37
    Height = 13
    Caption = #1057#1090#1088#1072#1085#1072
  end
  object Label10: TLabel [10]
    Left = 15
    Top = 128
    Width = 95
    Height = 13
    Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
  end
  inherited btnOk: TButton
    Left = 393
    Top = 223
    TabOrder = 13
    ExplicitLeft = 393
    ExplicitTop = 223
  end
  inherited btnCancel: TButton
    Left = 474
    Top = 223
    Default = True
    TabOrder = 14
    ExplicitLeft = 474
    ExplicitTop = 223
  end
  object edIndex: TEdit [13]
    Left = 119
    Top = 9
    Width = 47
    Height = 21
    Color = clInfoBk
    MaxLength = 6
    TabOrder = 0
    Text = '999999'
    OnKeyUp = edIndexKeyUp
  end
  object cbCountry: TComboBox [14]
    Left = 119
    Top = 38
    Width = 170
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 0
    TabOrder = 1
  end
  object cbState: TComboBox [15]
    Left = 349
    Top = 39
    Width = 193
    Height = 21
    ItemHeight = 0
    MaxLength = 50
    TabOrder = 2
  end
  object edRegionOfState: TEdit [16]
    Left = 119
    Top = 67
    Width = 424
    Height = 21
    MaxLength = 70
    TabOrder = 3
    Text = 'edRegionOfState'
  end
  object cbTownKind: TComboBox [17]
    Left = 119
    Top = 95
    Width = 45
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    ItemHeight = 0
    MaxLength = 10
    TabOrder = 4
  end
  object edStreetName: TEdit [18]
    Left = 171
    Top = 155
    Width = 305
    Height = 21
    Color = clInfoBk
    MaxLength = 50
    TabOrder = 9
    OnKeyUp = edStreetNameKeyUp
  end
  object cbStreetMark: TComboBox [19]
    Left = 97
    Top = 154
    Width = 67
    Height = 21
    Color = clInfoBk
    ItemHeight = 0
    MaxLength = 10
    TabOrder = 8
  end
  object edBuilding: TEdit [20]
    Left = 97
    Top = 185
    Width = 53
    Height = 21
    MaxLength = 10
    TabOrder = 10
    Text = 'edBuilding'
  end
  object edCorpus: TEdit [21]
    Left = 211
    Top = 185
    Width = 53
    Height = 21
    MaxLength = 10
    TabOrder = 11
    Text = 'edBuilding'
  end
  object edRoom: TEdit [22]
    Left = 330
    Top = 185
    Width = 53
    Height = 21
    MaxLength = 10
    TabOrder = 12
    Text = 'edBuilding'
  end
  object cbVillageKind: TComboBox [23]
    Left = 119
    Top = 124
    Width = 45
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    MaxLength = 10
    TabOrder = 6
  end
  object cbTownName: TComboBox [24]
    Left = 171
    Top = 95
    Width = 372
    Height = 21
    Color = clInfoBk
    ItemHeight = 13
    MaxLength = 50
    TabOrder = 5
    Items.Strings = (
      #1042#1086#1088#1086#1085#1077#1078)
  end
  object cbVillageName: TComboBox [25]
    Left = 171
    Top = 124
    Width = 372
    Height = 21
    ItemHeight = 13
    MaxLength = 50
    TabOrder = 7
    Items.Strings = (
      #1042#1086#1088#1086#1085#1077#1078)
  end
  object btnStreet: TButton [26]
    Left = 483
    Top = 155
    Width = 60
    Height = 20
    Hint = 'Ctrl+Enter'
    Caption = #1042#1099#1073#1088#1072#1090#1100
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
  end
end
