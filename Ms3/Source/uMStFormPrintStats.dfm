object mstPrintStatsForm: TmstPrintStatsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1077#1095#1072#1090#1080' '#1087#1083#1072#1085#1096#1077#1090#1086#1074
  ClientHeight = 541
  ClientWidth = 713
  Color = clBtnFace
  Constraints.MinHeight = 575
  Constraints.MinWidth = 721
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    713
    541)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 33
    Height = 13
    Caption = #1054#1090#1076#1077#1083
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 72
    Height = 13
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  end
  object cbOffice: TComboBox
    Left = 88
    Top = 5
    Width = 361
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbOfficeChange
  end
  object cbUser: TComboBox
    Left = 88
    Top = 37
    Width = 361
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 64
    Width = 441
    Height = 73
    Caption = #1044#1072#1090#1099
    TabOrder = 2
    object Label3: TLabel
      Left = 128
      Top = 48
      Width = 5
      Height = 13
      Caption = #1089
    end
    object Label4: TLabel
      Left = 282
      Top = 48
      Width = 12
      Height = 13
      Caption = #1087#1086
    end
    object RadioButton1: TRadioButton
      Left = 16
      Top = 18
      Width = 89
      Height = 17
      Caption = #1054#1076#1080#1085' '#1076#1077#1085#1100
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 47
      Width = 89
      Height = 17
      Caption = #1044#1080#1072#1087#1072#1079#1086#1085
      TabOrder = 1
      OnClick = RadioButton1Click
    end
    object meSingleDay: TMaskEdit
      Left = 152
      Top = 16
      Width = 120
      Height = 21
      EditMask = '!99/99/00;1;*'
      MaxLength = 8
      TabOrder = 2
      Text = '  .  .  '
    end
    object meStart: TMaskEdit
      Left = 152
      Top = 45
      Width = 120
      Height = 21
      Enabled = False
      EditMask = '!99/99/00;1;*'
      MaxLength = 8
      ParentColor = True
      TabOrder = 3
      Text = '  .  .  '
    end
    object meEnd: TMaskEdit
      Left = 300
      Top = 45
      Width = 120
      Height = 21
      Enabled = False
      EditMask = '!99/99/00;1;*'
      MaxLength = 8
      ParentColor = True
      TabOrder = 4
      Text = '  .  .  '
    end
  end
  object Button1: TButton
    Left = 466
    Top = 5
    Width = 111
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 592
    Top = 5
    Width = 111
    Height = 25
    Anchors = [akLeft, akRight]
    Caption = #1042#1099#1093#1086#1076
    ModalResult = 1
    TabOrder = 4
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 143
    Width = 440
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    Flat = True
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 174
    Width = 695
    Height = 359
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    Enabled = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ACCOUNT_NAME'
        Title.Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOMENCLATURE'
        Title.Caption = #1055#1083#1072#1085#1096#1077#1090
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'USER_NAME'
        Title.Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRINT_DATE'
        Title.Caption = #1044#1072#1090#1072
        Width = 120
        Visible = True
      end>
  end
  object Button3: TButton
    Left = 466
    Top = 40
    Width = 111
    Height = 25
    Caption = #1054#1090#1095#1077#1090
    Enabled = False
    TabOrder = 7
    OnClick = Button3Click
  end
  object DataSource1: TDataSource
    Left = 192
    Top = 296
  end
end
