object mstEditMPObjSemanticsDialog: TmstEditMPObjSemanticsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1077#1084#1072#1085#1090#1080#1082#1072' '#1086#1073#1098#1077#1082#1090#1072
  ClientHeight = 367
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lObjState: TLabel
    Left = 67
    Top = 50
    Width = 84
    Height = 13
    Alignment = taRightJustify
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1089#1077#1090#1080':'
    FocusControl = DBLookupComboBox1
  end
  object Label2: TLabel
    Left = 72
    Top = 125
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072':'
    FocusControl = DBEdit1
  end
  object Label3: TLabel
    Left = 103
    Top = 179
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1080#1072#1084#1077#1090#1088':'
    FocusControl = DBEdit2
  end
  object Label4: TLabel
    Left = 7
    Top = 234
    Width = 144
    Height = 13
    Alignment = taRightJustify
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1088#1091#1073'/'#1087#1088#1086#1074#1086#1076#1086#1074':'
    FocusControl = DBEdit3
  end
  object Label5: TLabel
    Left = 97
    Top = 261
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = #1052#1072#1090#1077#1088#1080#1072#1083':'
    FocusControl = DBEdit4
  end
  object Label6: TLabel
    Left = 123
    Top = 288
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = #1042#1077#1088#1093':'
    FocusControl = DBEdit5
  end
  object Label7: TLabel
    Left = 129
    Top = 315
    Width = 22
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1080#1079':'
    FocusControl = DBEdit6
  end
  object Label8: TLabel
    Left = 127
    Top = 342
    Width = 24
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1085#1086':'
    FocusControl = DBEdit7
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
  object lLayer: TLabel
    Left = 122
    Top = 8
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = #1057#1083#1086#1081':'
  end
  object lNumber: TLabel
    Left = 97
    Top = 28
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1086#1084#1077#1088' '#1087'/'#1087':'
  end
  object Label1: TLabel
    Left = 98
    Top = 206
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1072#1074#1083#1077#1085#1080#1077':'
    FocusControl = DBLookupComboBox2
  end
  object Label9: TLabel
    Left = 84
    Top = 152
    Width = 67
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077':'
    FocusControl = DBLookupComboBox3
  end
  object DBLookupComboBox1: TDBLookupComboBox
    Left = 157
    Top = 47
    Width = 220
    Height = 21
    DataField = 'NET_STATE_ID'
    DataSource = DataSource1
    Enabled = False
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsNetStates
    TabOrder = 0
  end
  object DBCheckBox1: TDBCheckBox
    Left = 55
    Top = 74
    Width = 115
    Height = 18
    Alignment = taLeftJustify
    Caption = #1044#1077#1084#1086#1085#1090#1080#1088#1086#1074#1072#1085#1085#1099#1081':'
    DataField = 'DISMANTLED'
    DataSource = DataSource1
    TabOrder = 1
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBCheckBox2: TDBCheckBox
    Left = 99
    Top = 98
    Width = 71
    Height = 18
    Alignment = taLeftJustify
    Caption = #1040#1088#1093#1080#1074#1085#1099#1081':'
    DataField = 'ARCHIVED'
    DataSource = DataSource1
    TabOrder = 3
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBEdit1: TDBEdit
    Left = 157
    Top = 122
    Width = 60
    Height = 21
    DataField = 'ROTANGLE'
    DataSource = DataSource1
    TabOrder = 5
  end
  object DBCheckBox4: TDBCheckBox
    Left = 268
    Top = 74
    Width = 77
    Height = 18
    Alignment = taLeftJustify
    Caption = #1055#1086#1076#1079#1077#1084#1085#1099#1081':'
    DataField = 'UNDERGROUND'
    DataSource = DataSource1
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBEdit2: TDBEdit
    Left = 157
    Top = 176
    Width = 60
    Height = 21
    DataField = 'DIAM'
    DataSource = DataSource1
    TabOrder = 7
  end
  object DBEdit3: TDBEdit
    Left = 157
    Top = 231
    Width = 60
    Height = 21
    DataField = 'PIPE_COUNT'
    DataSource = DataSource1
    TabOrder = 9
  end
  object DBEdit4: TDBEdit
    Left = 157
    Top = 258
    Width = 220
    Height = 21
    DataField = 'MATERIAL'
    DataSource = DataSource1
    TabOrder = 10
  end
  object DBEdit5: TDBEdit
    Left = 157
    Top = 285
    Width = 220
    Height = 21
    DataField = 'TOP'
    DataSource = DataSource1
    TabOrder = 11
  end
  object DBEdit6: TDBEdit
    Left = 157
    Top = 312
    Width = 220
    Height = 21
    DataField = 'BOTTOM'
    DataSource = DataSource1
    TabOrder = 12
  end
  object DBEdit7: TDBEdit
    Left = 157
    Top = 339
    Width = 220
    Height = 21
    DataField = 'FLOOR'
    DataSource = DataSource1
    TabOrder = 13
  end
  object btnOK: TButton
    Left = 408
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 14
  end
  object btnCancel: TButton
    Left = 408
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 15
  end
  object DBCheckBox5: TDBCheckBox
    Left = 208
    Top = 98
    Width = 137
    Height = 18
    Alignment = taLeftJustify
    Caption = #1050#1072#1085#1072#1083#1080#1079#1072#1094#1080#1103' '#1085#1072#1087#1086#1088#1085#1072#1103':'
    DataField = 'SEWER'
    DataSource = DataSource1
    TabOrder = 4
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object DBLookupComboBox2: TDBLookupComboBox
    Left = 158
    Top = 203
    Width = 220
    Height = 21
    DataField = 'PRESSURE_IDX'
    DataSource = DataSource1
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsPressure
    TabOrder = 8
  end
  object DBLookupComboBox3: TDBLookupComboBox
    Left = 157
    Top = 149
    Width = 220
    Height = 21
    DataField = 'VOLTAGE_IDX'
    DataSource = DataSource1
    KeyField = 'ID'
    ListField = 'NAME'
    ListSource = dsVoltage
    TabOrder = 6
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
  object dsVoltage: TDataSource
    DataSet = mdVoltage
    Left = 424
    Top = 174
  end
  object mdVoltage: TRxMemoryData
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
    Top = 174
    object IntegerField1: TIntegerField
      FieldName = 'ID'
    end
    object StringField1: TStringField
      FieldName = 'NAME'
      Size = 25
    end
  end
  object mdPressure: TRxMemoryData
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
    Top = 206
    object IntegerField2: TIntegerField
      FieldName = 'ID'
    end
    object StringField2: TStringField
      FieldName = 'NAME'
      Size = 25
    end
  end
  object dsPressure: TDataSource
    DataSet = mdPressure
    Left = 424
    Top = 206
  end
end
