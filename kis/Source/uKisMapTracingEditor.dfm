inherited KisMapTracingEditor: TKisMapTracingEditor
  Left = 289
  Top = 210
  ActiveControl = edNomenclature
  Caption = ''
  ClientHeight = 394
  ClientWidth = 536
  Position = poMainFormCenter
  ExplicitWidth = 542
  ExplicitHeight = 426
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 39
    Top = 365
    ExplicitLeft = 39
    ExplicitTop = 365
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
  end
  inherited btnOk: TButton
    Left = 372
    Top = 361
    TabOrder = 5
    ExplicitLeft = 372
    ExplicitTop = 361
  end
  inherited btnCancel: TButton
    Left = 453
    Top = 361
    Default = True
    TabOrder = 6
    ExplicitLeft = 453
    ExplicitTop = 361
  end
  object edNomenclature: TEdit [4]
    Left = 8
    Top = 24
    Width = 36
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    MaxLength = 6
    TabOrder = 0
    OnKeyDown = edNomenclatureKeyDown
    OnKeyPress = edNomenclatureKeyPress
  end
  object cbIsSecret: TCheckBox [5]
    Left = 168
    Top = 24
    Width = 129
    Height = 17
    Caption = #1057#1077#1082#1088#1077#1090#1085#1072#1103' '#1095#1072#1089#1090#1100
    TabOrder = 3
  end
  object gGivings: TkaDBGrid [6]
    Left = 8
    Top = 56
    Width = 409
    Height = 297
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 4
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'GIVE_DATE'
        Title.Caption = #1042#1099#1076#1072#1085
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BACK_DATE'
        Title.Caption = #1042#1086#1079#1074#1088'.'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PERIOD'
        Title.Caption = #1057#1088#1086#1082
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RECIPIENT'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PERSON_NAME'
        Title.Caption = #1060'.'#1048'.'#1054'.'
        Visible = True
      end>
  end
  object edNom2: TEdit [7]
    Left = 43
    Top = 24
    Width = 41
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    MaxLength = 5
    TabOrder = 1
    OnKeyDown = edNom2KeyDown
    OnKeyPress = edNom2KeyPress
  end
  object edNom3: TEdit [8]
    Left = 83
    Top = 24
    Width = 33
    Height = 21
    CharCase = ecUpperCase
    Color = clInfoBk
    MaxLength = 2
    TabOrder = 2
    OnKeyPress = edNom3KeyPress
  end
  object btnEditLast: TButton [9]
    Left = 424
    Top = 136
    Width = 105
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 7
    Visible = False
  end
  object btnDeleteLast: TButton [10]
    Left = 424
    Top = 56
    Width = 105
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 8
  end
  object DataSource: TDataSource
    Left = 248
    Top = 120
  end
end
