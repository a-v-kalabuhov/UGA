object mstEditMPObjSemanticsDialog: TmstEditMPObjSemanticsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1077#1084#1072#1085#1090#1080#1082#1072' '#1089#1077#1090#1080
  ClientHeight = 360
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    490
    360)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 68
    Top = 51
    Width = 84
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1089#1077#1090#1080':'
    FocusControl = DBLookupComboBox1
    ExplicitTop = 12
  end
  object Label2: TLabel
    Left = 73
    Top = 167
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072':'
    FocusControl = DBEdit1
    ExplicitTop = 128
  end
  object Label3: TLabel
    Left = 104
    Top = 194
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1044#1080#1072#1084#1077#1090#1088':'
    FocusControl = DBEdit2
    ExplicitTop = 155
  end
  object Label4: TLabel
    Left = 8
    Top = 221
    Width = 144
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1088#1091#1073'/'#1087#1088#1086#1074#1086#1076#1086#1074':'
    FocusControl = DBEdit3
    ExplicitTop = 182
  end
  object Label5: TLabel
    Left = 98
    Top = 248
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1052#1072#1090#1077#1088#1080#1072#1083':'
    FocusControl = DBEdit4
    ExplicitTop = 209
  end
  object Label6: TLabel
    Left = 124
    Top = 275
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1042#1077#1088#1093':'
    FocusControl = DBEdit5
    ExplicitTop = 236
  end
  object Label7: TLabel
    Left = 130
    Top = 302
    Width = 22
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1053#1080#1079':'
    FocusControl = DBEdit6
    ExplicitTop = 263
  end
  object Label8: TLabel
    Left = 128
    Top = 329
    Width = 24
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1044#1085#1086':'
    FocusControl = DBEdit7
    ExplicitTop = 290
  end
  object DBText1: TDBText
    Left = 157
    Top = 8
    Width = 245
    Height = 17
    DataField = 'LAYER_NAME'
    DataSource = DataSource1
  end
  object DBText2: TDBText
    Left = 157
    Top = 28
    Width = 245
    Height = 17
    DataField = 'ENT_ID'
    DataSource = DataSource1
  end
  object Label9: TLabel
    Left = 122
    Top = 8
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1057#1083#1086#1081':'
  end
  object Label10: TLabel
    Left = 97
    Top = 28
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #1053#1086#1084#1077#1088' '#1087'/'#1087':'
  end
  object DBLookupComboBox1: TDBLookupComboBox
    Left = 157
    Top = 47
    Width = 145
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'NET_STATE_ID'
    DataSource = DataSource1
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsNetStates
    TabOrder = 0
  end
  object DBCheckBox1: TDBCheckBox
    Left = 68
    Top = 74
    Width = 102
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akLeft, akBottom]
    Caption = #1044#1077#1084#1086#1085#1090#1080#1088#1086#1074#1072#1085#1086':'
    DataField = 'DISMANTLED'
    DataSource = DataSource1
    TabOrder = 1
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox2: TDBCheckBox
    Left = 99
    Top = 97
    Width = 71
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akLeft, akBottom]
    Caption = #1040#1088#1093#1080#1074#1085#1072#1103':'
    DataField = 'ARCHIVED'
    DataSource = DataSource1
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox3: TDBCheckBox
    Left = 83
    Top = 120
    Width = 87
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072':'
    DataField = 'AGREED'
    DataSource = DataSource1
    TabOrder = 3
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBEdit1: TDBEdit
    Left = 157
    Top = 164
    Width = 60
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'ROTANGLE'
    DataSource = DataSource1
    TabOrder = 4
  end
  object DBCheckBox4: TDBCheckBox
    Left = 93
    Top = 144
    Width = 77
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086#1076#1079#1077#1084#1085#1072#1103':'
    DataField = 'UNDERGROUND'
    DataSource = DataSource1
    TabOrder = 5
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBEdit2: TDBEdit
    Left = 157
    Top = 191
    Width = 60
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'DIAM'
    DataSource = DataSource1
    TabOrder = 6
  end
  object DBEdit3: TDBEdit
    Left = 157
    Top = 218
    Width = 60
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'PIPE_COUNT'
    DataSource = DataSource1
    TabOrder = 7
  end
  object DBEdit4: TDBEdit
    Left = 157
    Top = 245
    Width = 145
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'MATERIAL'
    DataSource = DataSource1
    TabOrder = 8
  end
  object DBEdit5: TDBEdit
    Left = 157
    Top = 272
    Width = 145
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'TOP'
    DataSource = DataSource1
    TabOrder = 9
  end
  object DBEdit6: TDBEdit
    Left = 157
    Top = 299
    Width = 145
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'BOTTOM'
    DataSource = DataSource1
    TabOrder = 10
  end
  object DBEdit7: TDBEdit
    Left = 157
    Top = 326
    Width = 145
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'FLOOR'
    DataSource = DataSource1
    TabOrder = 11
  end
  object btnOK: TButton
    Left = 408
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 12
  end
  object btnCancel: TButton
    Left = 408
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 13
  end
  object DataSource1: TDataSource
    Left = 424
    Top = 110
  end
  object dsNetStates: TDataSource
    DataSet = mdNetStates
    Left = 424
    Top = 142
  end
  object mdNetStates: TRxMemoryData
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NAME'
        DataType = ftString
        Size = 25
      end>
    Left = 456
    Top = 142
    object mdNetStatesID: TIntegerField
      FieldName = 'ID'
    end
    object mdNetStatesNAME: TStringField
      FieldName = 'NAME'
      Size = 25
    end
  end
end
