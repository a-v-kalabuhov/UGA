object AllotmentOwnerForm: TAllotmentOwnerForm
  Left = 57
  Top = 149
  ActiveControl = dbeName
  BorderStyle = bsDialog
  Caption = #1042#1083#1072#1076#1077#1083#1077#1094' '#1086#1090#1074#1086#1076#1072
  ClientHeight = 236
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    513
    236)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 13
    Caption = '&'#1042#1083#1072#1076#1077#1083#1077#1094
    FocusControl = dbeName
  end
  object Label2: TLabel
    Left = 8
    Top = 75
    Width = 43
    Height = 13
    Caption = '&'#1055#1088#1086#1094#1077#1085#1090
    FocusControl = dbePercent
  end
  object Label3: TLabel
    Left = 8
    Top = 115
    Width = 60
    Height = 13
    Caption = '&'#1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
    FocusControl = dbePurpose
  end
  object Label6: TLabel
    Left = 8
    Top = 153
    Width = 110
    Height = 13
    Caption = '&'#1060#1086#1088#1084#1072' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1086#1089#1090#1080
    FocusControl = dbcPropForm
  end
  object Label10: TLabel
    Left = 211
    Top = 153
    Width = 67
    Height = 13
    Caption = #1057#1088'&'#1086#1082' '#1072#1088#1077#1085#1076#1099
    FocusControl = dbeRentPeriod
  end
  object dbeName: TDBEdit
    Left = 8
    Top = 23
    Width = 497
    Height = 21
    DataField = 'NAME'
    DataSource = AllotmentForm.dsOwners
    TabOrder = 0
  end
  object btnSelect: TButton
    Left = 8
    Top = 45
    Width = 70
    Height = 24
    Caption = #1042'&'#1099#1073#1088#1072#1090#1100
    TabOrder = 2
    OnClick = btnSelectClick
  end
  object btnClear: TButton
    Left = 158
    Top = 45
    Width = 71
    Height = 24
    Caption = #1054'&'#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 4
    OnClick = btnClearClick
  end
  object btnOk: TButton
    Left = 359
    Top = 204
    Width = 70
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 8
    OnClick = btnOkClick
    ExplicitLeft = 404
    ExplicitTop = 157
  end
  object btnCancel: TButton
    Left = 434
    Top = 204
    Width = 71
    Height = 24
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 9
    ExplicitLeft = 479
    ExplicitTop = 157
  end
  object dbePercent: TDBEdit
    Left = 8
    Top = 90
    Width = 39
    Height = 21
    DataField = 'PERCENT'
    DataSource = AllotmentForm.dsOwners
    TabOrder = 1
  end
  object dbePurpose: TDBEdit
    Left = 8
    Top = 130
    Width = 497
    Height = 21
    DataField = 'PURPOSE'
    DataSource = AllotmentForm.dsOwners
    TabOrder = 5
  end
  object btnDetail: TButton
    Left = 83
    Top = 45
    Width = 71
    Height = 24
    Caption = #1055#1086'&'#1076#1088#1086#1073#1085#1086
    TabOrder = 3
    OnClick = btnDetailClick
  end
  object dbcPropForm: TDBLookupComboBox
    Left = 8
    Top = 168
    Width = 196
    Height = 21
    DataField = 'PROP_FORMS_NAME'
    DataSource = AllotmentForm.dsOwners
    TabOrder = 6
  end
  object dbeRentPeriod: TDBEdit
    Left = 211
    Top = 168
    Width = 69
    Height = 21
    DataField = 'RENT_PERIOD'
    DataSource = AllotmentForm.dsOwners
    TabOrder = 7
  end
end
