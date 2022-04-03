object MstDialogImportLayerForm: TMstDialogImportLayerForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1084#1087#1086#1088#1090' '#1089#1083#1086#1103
  ClientHeight = 565
  ClientWidth = 879
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    879
    565)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 82
    Top = 8
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = #1060#1072#1081#1083':'
    FocusControl = txtFileName
  end
  object Label2: TLabel
    Left = 34
    Top = 57
    Width = 78
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1083#1086#1103':'
    FocusControl = edLayerName
  end
  object Label3: TLabel
    Left = 8
    Top = 84
    Width = 104
    Height = 13
    Alignment = taRightJustify
    Caption = #1057#1080#1089#1090#1077#1084#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090':'
    FocusControl = cbCoordSys
  end
  object Label4: TLabel
    Left = 57
    Top = 31
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = #1054#1073#1098#1077#1082#1090#1086#1074':'
    FocusControl = txtRecordCount
  end
  object Label5: TLabel
    Left = 8
    Top = 128
    Width = 73
    Height = 13
    Caption = #1055#1086#1083#1103' '#1074' '#1092#1072#1081#1083#1077':'
    FocusControl = lvFieldsSource
  end
  object Label6: TLabel
    Left = 345
    Top = 128
    Width = 96
    Height = 13
    Caption = #1055#1086#1083#1103' '#1076#1083#1103' '#1080#1084#1087#1086#1088#1090#1072':'
    FocusControl = lvFieldsTarget
  end
  object edLayerName: TEdit
    Left = 118
    Top = 54
    Width = 579
    Height = 21
    TabOrder = 0
    Text = #1048#1084#1103' '#1089#1083#1086#1103
  end
  object cbCoordSys: TComboBox
    Left = 118
    Top = 81
    Width = 180
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = #1057#1050'36'
    Items.Strings = (
      #1057#1050'36'
      #1084#1077#1089#1090#1085#1072#1103)
  end
  object lvFieldsSource: TListView
    Left = 8
    Top = 144
    Width = 250
    Height = 413
    Anchors = [akLeft, akTop, akBottom]
    Columns = <
      item
        Caption = #1055#1086#1083#1077
        Width = 150
      end
      item
        Caption = #1058#1080#1087
        Width = 90
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = lvFieldsSourceChange
  end
  object lvFieldsTarget: TListView
    Left = 345
    Top = 144
    Width = 526
    Height = 413
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
        Width = 250
      end
      item
        Caption = #1058#1080#1087
        Width = 100
      end
      item
        Caption = #1055#1086#1083#1077
        Width = 150
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    TabOrder = 3
    ViewStyle = vsReport
    OnChange = lvFieldsTargetChange
    OnKeyUp = lvFieldsTargetKeyUp
  end
  object btnAddField: TButton
    Left = 264
    Top = 144
    Width = 75
    Height = 25
    Caption = '>>>'
    Enabled = False
    TabOrder = 4
    OnClick = btnAddFieldClick
  end
  object btnDelField: TButton
    Left = 264
    Top = 175
    Width = 75
    Height = 25
    Caption = '<<<'
    Enabled = False
    TabOrder = 5
    OnClick = btnDelFieldClick
  end
  object btnAddAll: TButton
    Left = 264
    Top = 232
    Width = 75
    Height = 25
    Caption = #1042#1089#1077' >>>'
    TabOrder = 6
    OnClick = btnAddAllClick
  end
  object btnDelAll: TButton
    Left = 264
    Top = 263
    Width = 75
    Height = 25
    Caption = #1042#1089#1077' <<<'
    TabOrder = 7
    OnClick = btnDelAllClick
  end
  object txtRecordCount: TStaticText
    Left = 118
    Top = 31
    Width = 81
    Height = 17
    Caption = 'txtRecordCount'
    TabOrder = 8
  end
  object txtFileName: TStaticText
    Left = 118
    Top = 8
    Width = 59
    Height = 17
    Caption = 'StaticText1'
    TabOrder = 9
  end
  object Button1: TButton
    Left = 796
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1050
    TabOrder = 10
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 796
    Top = 39
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 11
  end
  object chbExchangeXY: TCheckBox
    Left = 312
    Top = 83
    Width = 137
    Height = 17
    Caption = #1055#1086#1084#1077#1085#1103#1090#1100' X '#1080' Y '#1084#1077#1089#1090#1072#1084#1080
    TabOrder = 12
  end
end
