inherited KisScanOrderEditor: TKisScanOrderEditor
  Caption = 'KisScanOrderEditor'
  ClientHeight = 329
  ClientWidth = 744
  Position = poMainFormCenter
  OnShow = FormShow
  ExplicitWidth = 750
  ExplicitHeight = 357
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 8
    Top = 308
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 308
  end
  inherited btnOk: TButton
    Left = 580
    Top = 296
    Anchors = [akRight, akBottom]
    TabOrder = 3
    ExplicitLeft = 580
    ExplicitTop = 296
  end
  inherited btnCancel: TButton
    Left = 661
    Top = 296
    Anchors = [akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 661
    ExplicitTop = 296
  end
  object gbSender: TGroupBox [3]
    Left = 8
    Top = 164
    Width = 418
    Height = 118
    Anchors = [akLeft, akBottom]
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082
    TabOrder = 1
    object edOrgname: TEdit
      Left = 113
      Top = 28
      Width = 297
      Height = 21
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 1
      OnKeyPress = edOrgnameKeyPress
    end
    object RadBtnOrgs: TRadioButton
      Left = 11
      Top = 30
      Width = 91
      Height = 17
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
      TabOrder = 0
      TabStop = True
      OnClick = RadBtnOrgsClick
    end
    object RadBtnMP: TRadioButton
      Left = 11
      Top = 87
      Width = 75
      Height = 17
      Caption = #1052#1050#1055' "'#1059#1043#1040'"'
      TabOrder = 3
      TabStop = True
      OnClick = RadBtnMPClick
    end
    object btnSelectOrg: TButton
      Left = 335
      Top = 54
      Width = 75
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 2
      OnClick = btnSelectOrgClick
    end
    object cbOffices: TComboBox
      Left = 113
      Top = 85
      Width = 297
      Height = 21
      Style = csDropDownList
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 4
      Visible = False
      OnChange = cbOfficesChange
    end
  end
  object GroupBox1: TGroupBox [4]
    Left = 8
    Top = 0
    Width = 418
    Height = 161
    Caption = #1044#1077#1090#1072#1083#1080' '#1079#1072#1103#1074#1082#1080
    TabOrder = 0
    object Label1: TLabel
      Left = 11
      Top = 16
      Width = 69
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080
    end
    object Label2: TLabel
      Left = 98
      Top = 16
      Width = 64
      Height = 13
      Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
    end
    object Label3: TLabel
      Left = 11
      Top = 62
      Width = 128
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1088#1072#1073#1086#1090
    end
    object Label4: TLabel
      Left = 11
      Top = 108
      Width = 52
      Height = 13
      Caption = #1042#1080#1076' '#1088#1072#1073#1086#1090
    end
    object edAddress: TEdit
      Left = 11
      Top = 81
      Width = 399
      Height = 21
      Color = clInfoBk
      TabOrder = 2
      Text = 'edAddress'
    end
    object edDate: TEdit
      Left = 98
      Top = 35
      Width = 81
      Height = 21
      Color = clInfoBk
      TabOrder = 1
      Text = 'edDate'
    end
    object edNumber: TEdit
      Left = 11
      Top = 35
      Width = 81
      Height = 21
      Color = clInfoBk
      TabOrder = 0
      Text = 'edNumber'
    end
    object cbWorkType: TComboBox
      Left = 11
      Top = 127
      Width = 399
      Height = 21
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 3
      Text = 'cbWorkType'
    end
    object chbAnnulled: TCheckBox
      Left = 313
      Top = 37
      Width = 97
      Height = 17
      Caption = #1040#1085#1085#1091#1083#1080#1088#1086#1074#1072#1085#1072
      Enabled = False
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox [5]
    Left = 432
    Top = 0
    Width = 304
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
    TabOrder = 2
    DesignSize = (
      304
      282)
    object Label5: TLabel
      Left = 11
      Top = 16
      Width = 31
      Height = 13
      Caption = #1053#1072#1081#1090#1080
    end
    object DBGrid1: TkaDBGrid
      Left = 11
      Top = 55
      Width = 197
      Height = 215
      Anchors = [akLeft, akTop, akRight]
      DataSource = DataSource1
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = RUSSIAN_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnGetLogicalValue = DBGrid1GetLogicalValue
      OnLogicalColumn = DBGrid1LogicalColumn
      Columns = <
        item
          Expanded = False
          FieldName = 'NOMENCLATURE'
          Title.Caption = #1055#1083#1072#1085#1096#1077#1090
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GIVE_STATUS'
          Title.Caption = #1042#1099#1076#1072#1085
          Visible = True
        end>
    end
    object edNomenclature: TEdit
      Left = 11
      Top = 35
      Width = 197
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edNomenclatureChange
      OnKeyPress = edNomenclatureKeyPress
    end
    object btnAdd: TButton
      Left = 223
      Top = 35
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Enabled = False
      TabOrder = 2
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 223
      Top = 66
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Enabled = False
      TabOrder = 3
      OnClick = btnDeleteClick
    end
  end
  object DataSource1: TDataSource [6]
    Left = 456
    Top = 288
  end
end
