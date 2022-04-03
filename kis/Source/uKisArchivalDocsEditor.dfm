inherited KisArchivalDocsEditor: TKisArchivalDocsEditor
  Left = 317
  Top = 237
  Caption = 'KisArchivalDocsEditor'
  ClientHeight = 596
  ClientWidth = 555
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitTop = -152
  ExplicitWidth = 561
  ExplicitHeight = 628
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 71
    Top = 575
    ExplicitLeft = 71
    ExplicitTop = 575
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 3
    Width = 76
    Height = 13
    Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object Label2: TLabel [2]
    Left = 8
    Top = 42
    Width = 84
    Height = 13
    Caption = #1040#1088#1093#1080#1074#1085#1099#1081' '#1085#1086#1084#1077#1088
  end
  object Label3: TLabel [3]
    Left = 168
    Top = 42
    Width = 101
    Height = 13
    Caption = #1044#1072#1090#1072' '#1089#1076#1072#1095#1080' '#1074' '#1072#1088#1093#1080#1074
  end
  object Label4: TLabel [4]
    Left = 280
    Top = 41
    Width = 119
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
  end
  object Label5: TLabel [5]
    Left = 8
    Top = 81
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
  end
  object Label7: TLabel [6]
    Left = 8
    Top = 121
    Width = 55
    Height = 13
    Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
  end
  object Label10: TLabel [7]
    Left = 9
    Top = 161
    Width = 61
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
  end
  inherited btnOk: TButton
    Left = 391
    Top = 568
    TabOrder = 9
    ExplicitLeft = 391
    ExplicitTop = 568
  end
  inherited btnCancel: TButton
    Left = 472
    Top = 568
    Default = True
    TabOrder = 10
    ExplicitLeft = 472
    ExplicitTop = 568
  end
  object cbDocType: TComboBox [10]
    Left = 8
    Top = 16
    Width = 537
    Height = 21
    Style = csDropDownList
    Color = clInfoBk
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 0
    ParentFont = False
    TabOrder = 0
  end
  object edArchNumber: TEdit [11]
    Left = 8
    Top = 56
    Width = 153
    Height = 21
    Color = clInfoBk
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 1
    Text = 'edArchNumber'
  end
  object edShelveDate: TEdit [12]
    Left = 168
    Top = 56
    Width = 105
    Height = 21
    Color = clInfoBk
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 2
    OnKeyDown = edShelveDateKeyDown
  end
  object edObjectName: TEdit [13]
    Left = 280
    Top = 56
    Width = 265
    Height = 21
    Color = clHighlightText
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 100
    ParentFont = False
    TabOrder = 3
    Text = 'edObjectName'
  end
  object edAddress: TEdit [14]
    Left = 8
    Top = 96
    Width = 537
    Height = 21
    Color = clHighlightText
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 400
    ParentFont = False
    TabOrder = 4
    Text = 'edAddress'
  end
  object edBasis: TEdit [15]
    Left = 8
    Top = 135
    Width = 537
    Height = 21
    Color = clHighlightText
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    TabOrder = 5
    Text = 'edBasis'
  end
  object edComment: TEdit [16]
    Left = 8
    Top = 175
    Width = 537
    Height = 21
    Color = clHighlightText
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    TabOrder = 11
    Text = 'edComment'
  end
  object GroupBox1: TGroupBox [17]
    Left = 8
    Top = 344
    Width = 537
    Height = 218
    Caption = #1057#1087#1080#1089#1086#1082' '#1074#1099#1076#1072#1095#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    TabOrder = 8
    object dbgDocList: TDBGrid
      Left = 2
      Top = 15
      Width = 533
      Height = 170
      Align = alTop
      DataSource = dsDocList
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = RUSSIAN_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnExit = dbgDocListExit
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'ARCHIVAL_DOC_ID'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'DATE_OF_GIVE'
          Title.Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATE_OF_BACK'
          Title.Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PEOPLE_NAME'
          Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
          Width = 162
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OFFICE_NAME'
          Title.Caption = #1054#1090#1076#1077#1083
          Width = 142
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ORDER_ACCOUNT'
          Title.Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
          Width = 77
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ORDER_GIVEN_DOC_LINK'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'ORDER_NUMBER'
          Title.Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
          Width = 76
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TERM'
          Title.Caption = #1057#1088#1086#1082' '
          Width = 61
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OFFICES_ID'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'ORDERS_ID'
          Visible = False
        end>
    end
    object btnAddMove: TButton
      Left = 296
      Top = 190
      Width = 75
      Height = 21
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 1
      OnClick = btnAddMoveClick
    end
    object btnDeleteMove: TButton
      Left = 376
      Top = 190
      Width = 75
      Height = 21
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDeleteMoveClick
    end
    object btnBackDoc: TButton
      Left = 456
      Top = 190
      Width = 75
      Height = 21
      Caption = #1055#1088#1080#1085#1103#1090#1100
      TabOrder = 3
      OnClick = btnBackDocClick
    end
  end
  object GroupBox2: TGroupBox [18]
    Left = 8
    Top = 206
    Width = 537
    Height = 66
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082
    TabOrder = 6
    object edFirm: TEdit
      Left = 6
      Top = 16
      Width = 523
      Height = 21
      Color = clHighlightText
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 300
      ParentFont = False
      TabOrder = 0
      Text = 'edFirm'
    end
    object btnSelectFirm: TButton
      Left = 374
      Top = 40
      Width = 75
      Height = 21
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 1
      TabStop = False
    end
    object btnClearFirm: TButton
      Left = 454
      Top = 40
      Width = 75
      Height = 21
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 2
      TabStop = False
    end
  end
  object GroupBox3: TGroupBox [19]
    Left = 8
    Top = 272
    Width = 537
    Height = 71
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103', '#1074#1099#1087#1086#1083#1085#1103#1074#1096#1072#1103' '#1088#1072#1073#1086#1090#1099
    TabOrder = 7
    object edLicensedOrg: TEdit
      Left = 8
      Top = 20
      Width = 521
      Height = 21
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 0
    end
    object btnSelectOrg: TButton
      Left = 374
      Top = 45
      Width = 75
      Height = 21
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 1
      TabStop = False
    end
    object btnClearOrg: TButton
      Left = 454
      Top = 45
      Width = 75
      Height = 21
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 2
      TabStop = False
    end
  end
  object dsDocList: TDataSource
    Left = 40
    Top = 456
  end
end
