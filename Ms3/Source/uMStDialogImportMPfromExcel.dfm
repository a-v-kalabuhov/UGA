object mstMPExcelDialogForm: TmstMPExcelDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1048#1084#1087#1086#1088#1090' '#1089#1077#1090#1077#1081
  ClientHeight = 619
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    562
    619)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 111
    Height = 13
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' Excel:'
  end
  object edFileName: TEdit
    Left = 8
    Top = 24
    Width = 465
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 0
    ExplicitWidth = 673
  end
  object btnSelectFile: TButton
    Left = 479
    Top = 22
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 1
    OnClick = btnSelectFileClick
    ExplicitLeft = 687
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 53
    Width = 546
    Height = 227
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 2
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 136
      Height = 13
      Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100' '#1089#1090#1088#1086#1082#1080' '#1089#1074#1077#1088#1093#1091
    end
    object Label3: TLabel
      Left = 200
      Top = 16
      Width = 43
      Height = 13
      Caption = #1050#1086#1083#1086#1085#1082#1080
    end
    object spnSkipRows: TJvSpinEdit
      Left = 16
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = spnSkipRowsChange
    end
    object grdColumns: TStringGrid
      Left = 16
      Top = 59
      Width = 177
      Height = 161
      ColCount = 2
      DefaultColWidth = 150
      DefaultRowHeight = 19
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
      TabOrder = 1
      Visible = False
    end
    object ValueListEditor1: TValueListEditor
      Left = 199
      Top = 32
      Width = 338
      Height = 188
      Strings.Strings = (
        #1053#1086#1084#1077#1088' '#1086#1073#1098#1077#1082#1090#1072'=A'
        #1053#1086#1084#1077#1088' '#1087#1086#1076#1086#1073#1098#1077#1082#1090#1072'=B'
        #1053#1086#1084#1077#1088' '#1090#1086#1095#1082#1080'=C'
        #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' X=D'
        #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' Y=E'
        #1057#1083#1086#1081'=F'
        #1040#1076#1088#1077#1089'=G'
        #1053#1086#1084#1077#1088' '#1087#1088#1086#1077#1082#1090#1072'=H'
        #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072'=I'
        #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072'=J'
        #1044#1080#1072#1084#1077#1090#1088'=K'
        #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1088#1086#1074#1086#1076#1086#1074'/'#1090#1088#1091#1073'=L'
        #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077'=M'
        #1052#1072#1090#1077#1088#1080#1072#1083'=N'
        #1042#1077#1088#1093'=O'
        #1053#1080#1079'=P'
        #1044#1085#1086'=R'
        #1041#1072#1083#1072#1085#1089#1086#1076#1077#1088#1078#1072#1090#1077#1083#1100'=S')
      TabOrder = 2
      TitleCaptions.Strings = (
        #1057#1074#1086#1081#1089#1090#1074#1086' '#1086#1073#1098#1077#1082#1090#1072
        #1050#1086#1083#1086#1085#1082#1072' '#1092#1072#1081#1083#1072)
      OnGetPickList = ValueListEditor1GetPickList
      ColWidths = (
        151
        164)
    end
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 286
    Width = 546
    Height = 294
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 11
    DefaultRowHeight = 19
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing]
    TabOrder = 3
    ExplicitWidth = 754
  end
  object btnImport: TButton
    Left = 366
    Top = 586
    Width = 91
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 4
    OnClick = btnImportClick
    ExplicitLeft = 574
  end
  object btnCancel: TButton
    Left = 463
    Top = 586
    Width = 91
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
    ExplicitLeft = 671
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.xls'
    Filter = #1060#1072#1081#1083#1099' Excel (*.xls;*.xlsx)|*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 536
    Top = 8
  end
end
