inherited KisOrderEditor: TKisOrderEditor
  Left = 244
  Top = 162
  Caption = #1047#1072#1082#1072#1079
  ClientHeight = 552
  ClientWidth = 622
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 628
  ExplicitHeight = 580
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 0
    Top = 489
    Width = 622
    Height = 63
    Align = alClient
    Caption = ''
    ExplicitLeft = 0
    ExplicitTop = 489
    ExplicitWidth = 3
  end
  object Label36: TLabel [1]
    Left = 247
    Top = 528
    Width = 227
    Height = 13
    Caption = #1046#1077#1083#1090#1099#1077' '#1087#1086#1083#1103' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103'!'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object labelNumDoc: TLabel [2]
    Left = 8
    Top = 495
    Width = 134
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080' '#1086#1090#1076#1077#1083#1072': '#1085#1077#1090
  end
  inherited btnOk: TButton
    Left = 8
    Top = 523
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 523
  end
  inherited btnCancel: TButton
    Left = 89
    Top = 523
    Cancel = True
    ExplicitLeft = 89
    ExplicitTop = 523
  end
  object PageControl: TPageControl [5]
    Left = 0
    Top = 0
    Width = 622
    Height = 489
    ActivePage = tshCommon
    Align = alTop
    TabOrder = 0
    object tshCommon: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 152
        Top = 42
        Width = 63
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
        FocusControl = edDocNumber
      end
      object Label2: TLabel
        Left = 224
        Top = 42
        Width = 58
        Height = 13
        Caption = #1044#1072#1090#1072' '#1089#1095#1077#1090#1072
        FocusControl = edDocDate
      end
      object Label3: TLabel
        Left = 8
        Top = 42
        Width = 50
        Height = 13
        Caption = #8470' '#1079#1072#1082#1072#1079#1072
        FocusControl = edOrderNumber
      end
      object Label4: TLabel
        Left = 80
        Top = 42
        Width = 63
        Height = 13
        Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
        FocusControl = edOrderDate
      end
      object Label10: TLabel
        Left = 8
        Top = 2
        Width = 33
        Height = 13
        Caption = #1054#1090#1076#1077#1083
        FocusControl = cbOffices
      end
      object Label5: TLabel
        Left = 8
        Top = 415
        Width = 40
        Height = 13
        Caption = #1053#1044#1057', %'
      end
      object Label17: TLabel
        Left = 364
        Top = 2
        Width = 66
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      end
      object Label16: TLabel
        Left = 385
        Top = 415
        Width = 55
        Height = 13
        Caption = #1055#1083#1072#1090'. '#1076#1086#1082'.'
        FocusControl = edTicket
      end
      object Label18: TLabel
        Left = 217
        Top = 415
        Width = 67
        Height = 13
        Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
      end
      object Label19: TLabel
        Left = 368
        Top = 42
        Width = 53
        Height = 13
        Caption = #1044#1072#1090#1072' '#1072#1082#1090#1072
        FocusControl = edActDate
      end
      object Label20: TLabel
        Left = 296
        Top = 42
        Width = 56
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075'.'
        FocusControl = edContractNumber
      end
      object Label21: TLabel
        Left = 8
        Top = 82
        Width = 77
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1086#1073#1098#1077#1082#1090#1072
      end
      object Label27: TLabel
        Left = 440
        Top = 42
        Width = 151
        Height = 13
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
      end
      object edDocNumber: TEdit
        Left = 152
        Top = 58
        Width = 65
        Height = 21
        TabOrder = 4
      end
      object edDocDate: TEdit
        Left = 224
        Top = 58
        Width = 65
        Height = 21
        TabOrder = 5
        OnKeyPress = edDocDateKeyPress
      end
      object edOrderNumber: TEdit
        Left = 8
        Top = 58
        Width = 65
        Height = 21
        Color = clInfoBk
        TabOrder = 2
      end
      object edOrderDate: TEdit
        Left = 80
        Top = 58
        Width = 65
        Height = 21
        Color = clInfoBk
        TabOrder = 3
        OnKeyPress = edOrderDateKeyPress
      end
      object cbOffices: TComboBox
        Left = 8
        Top = 18
        Width = 345
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        TabOrder = 0
      end
      object gbContragent: TGroupBox
        Left = 8
        Top = 122
        Width = 601
        Height = 285
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        TabOrder = 10
        object Label6: TLabel
          Left = 8
          Top = 104
          Width = 31
          Height = 13
          Caption = #1040#1076#1088#1077#1089
          FocusControl = edContragentAddress
        end
        object Label9: TLabel
          Left = 8
          Top = 142
          Width = 55
          Height = 13
          Caption = #1056#1077#1082#1074#1080#1079#1080#1090#1099
        end
        object Label7: TLabel
          Left = 164
          Top = 243
          Width = 52
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085#1099
          FocusControl = edPhones
        end
        object Label8: TLabel
          Left = 330
          Top = 243
          Width = 21
          Height = 13
          Caption = #1048#1053#1053
          FocusControl = edINN
        end
        object Label22: TLabel
          Left = 8
          Top = 64
          Width = 265
          Height = 13
          Caption = #1055#1088#1077#1076#1089#1090#1072#1074#1080#1090#1077#1083#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1074' '#1088#1086#1076#1080#1090'. '#1087#1072#1076#1077#1078#1077' ('#1082#1086#1075#1086' ?)'
          FocusControl = edCustomer
        end
        object Label24: TLabel
          Left = 430
          Top = 243
          Width = 76
          Height = 13
          Caption = #1057#1088#1086#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
          FocusControl = edValPeriod
        end
        object Label15: TLabel
          Left = 8
          Top = 192
          Width = 24
          Height = 13
          Caption = #1041#1072#1085#1082
        end
        object LabelAccount: TLabel
          Left = 8
          Top = 243
          Width = 33
          Height = 13
          Caption = #1056'/'#1089#1095#1077#1090
        end
        object Label32: TLabel
          Left = 356
          Top = 64
          Width = 126
          Height = 13
          Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080
          FocusControl = edCustomerBase
        end
        object btnContragentClear: TButton
          Left = 170
          Top = 38
          Width = 75
          Height = 22
          Caption = #1054'&'#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 12
          TabStop = False
        end
        object btnContragentDetail: TButton
          Left = 89
          Top = 38
          Width = 76
          Height = 22
          Caption = #1055#1086'&'#1076#1088#1086#1073#1085#1086
          TabOrder = 11
          TabStop = False
        end
        object btnContragentSelect: TButton
          Left = 10
          Top = 38
          Width = 74
          Height = 22
          Caption = #1042'&'#1099#1073#1088#1072#1090#1100
          TabOrder = 1
          TabStop = False
        end
        object edContragentName: TEdit
          Left = 8
          Top = 16
          Width = 585
          Height = 21
          TabStop = False
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 0
        end
        object edContragentAddress: TEdit
          Left = 8
          Top = 120
          Width = 585
          Height = 21
          TabStop = False
          Color = clScrollBar
          ReadOnly = True
          TabOrder = 4
        end
        object mContragentProperties: TMemo
          Left = 8
          Top = 157
          Width = 585
          Height = 33
          TabStop = False
          Color = clActiveBorder
          ReadOnly = True
          TabOrder = 5
        end
        object edPhones: TEdit
          Left = 164
          Top = 258
          Width = 153
          Height = 21
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 8
        end
        object edINN: TEdit
          Left = 330
          Top = 258
          Width = 89
          Height = 21
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 9
        end
        object edCustomer: TEdit
          Left = 8
          Top = 80
          Width = 337
          Height = 21
          TabOrder = 2
        end
        object edValPeriod: TEdit
          Left = 430
          Top = 258
          Width = 82
          Height = 21
          TabOrder = 10
          OnKeyPress = edValPeriodKeyPress
        end
        object mContragentBank: TMemo
          Left = 8
          Top = 208
          Width = 585
          Height = 33
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 6
        end
        object edBankAccount: TEdit
          Left = 8
          Top = 258
          Width = 140
          Height = 21
          TabStop = False
          Color = cl3DLight
          MaxLength = 20
          ReadOnly = True
          TabOrder = 7
          Text = '9999999999999999999999'
        end
        object edCustomerBase: TEdit
          Left = 355
          Top = 80
          Width = 238
          Height = 21
          MaxLength = 255
          TabOrder = 3
        end
      end
      object edNDS: TEdit
        Left = 56
        Top = 412
        Width = 40
        Height = 21
        TabStop = False
        ReadOnly = True
        TabOrder = 11
        OnExit = edNDSExit
        OnKeyUp = edNDSKeyUp
      end
      object cbChecked: TCheckBox
        Left = 131
        Top = 415
        Width = 65
        Height = 16
        Caption = #1054#1087#1083#1072#1095#1077#1085
        TabOrder = 12
      end
      object edTicket: TComboBox
        Left = 440
        Top = 412
        Width = 81
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 14
        Text = #1082'/'#1095
        Items.Strings = (
          #1082'/'#1095
          #1087'/'#1087)
      end
      object edActDate: TEdit
        Left = 368
        Top = 58
        Width = 65
        Height = 21
        TabOrder = 7
        OnKeyPress = edActDateKeyPress
      end
      object edContractNumber: TEdit
        Left = 296
        Top = 58
        Width = 65
        Height = 21
        TabOrder = 6
      end
      object edObjectAddress: TEdit
        Left = 8
        Top = 98
        Width = 601
        Height = 21
        MaxLength = 120
        TabOrder = 9
      end
      object edInformation: TEdit
        Left = 440
        Top = 58
        Width = 169
        Height = 21
        MaxLength = 20
        TabOrder = 8
      end
      object cbMark: TCheckBox
        Left = 536
        Top = 0
        Width = 73
        Height = 17
        Alignment = taLeftJustify
        Caption = #1042#1099#1076#1077#1083#1080#1090#1100
        TabOrder = 15
      end
      object cbExecutor: TComboBox
        Left = 360
        Top = 18
        Width = 249
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        TabOrder = 1
      end
      object edPayDate: TEdit
        Left = 290
        Top = 412
        Width = 82
        Height = 21
        TabOrder = 13
        Text = 'edPayDate'
        OnKeyPress = edPayDateKeyPress
      end
      object cbClosed: TCheckBox
        Left = 131
        Top = 437
        Width = 86
        Height = 16
        Caption = #1040#1082#1090' '#1079#1072#1082#1088#1099#1090
        TabOrder = 16
      end
    end
    object tshWorks: TTabSheet
      Caption = #1056#1072#1073#1086#1090#1099
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object btnAddPosition: TSpeedButton
        Left = 8
        Top = 312
        Width = 75
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = btnAddPositionClick
      end
      object btnDeletePosition: TSpeedButton
        Left = 88
        Top = 312
        Width = 76
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        OnClick = btnDeletePositionClick
      end
      object btnEditPosition: TSpeedButton
        Left = 168
        Top = 312
        Width = 75
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      end
      object Label25: TLabel
        Left = 8
        Top = 208
        Width = 73
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      object Label26: TLabel
        Left = 8
        Top = 264
        Width = 55
        Height = 13
        Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
      end
      object dbeArgument: TDBEdit
        Left = 11
        Top = 281
        Width = 599
        Height = 21
        DataField = 'ARGUMENT'
        DataSource = dsPositions
        TabOrder = 2
      end
      object dbmWorkTypesName: TDBMemo
        Left = 8
        Top = 224
        Width = 601
        Height = 33
        DataField = 'WORK_TYPES_NAME'
        DataSource = dsPositions
        TabOrder = 0
      end
      object pnlSum: TPanel
        Left = 8
        Top = 343
        Width = 601
        Height = 65
        BevelOuter = bvLowered
        TabOrder = 1
        object Label11: TLabel
          Left = 15
          Top = 8
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1090#1086#1075#1086':'
        end
        object Label12: TLabel
          Left = 168
          Top = 8
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1053#1044#1057':'
        end
        object Label14: TLabel
          Left = 126
          Top = 40
          Width = 74
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = #1042#1089#1077#1075#1086' '#1089' '#1053#1044#1057':'
        end
        object dbtSumNds: TLabel
          Left = 254
          Top = 8
          Width = 3
          Height = 13
          Alignment = taRightJustify
        end
        object dbtSumma: TLabel
          Left = 102
          Top = 8
          Width = 3
          Height = 13
          Alignment = taRightJustify
        end
        object dbtSumAllNds: TLabel
          Left = 254
          Top = 40
          Width = 3
          Height = 13
          Alignment = taRightJustify
        end
        object Label28: TLabel
          Left = 464
          Top = 11
          Width = 57
          Height = 13
          Caption = #1041#1072#1079'. '#1089#1091#1084#1084#1072':'
        end
        object dbtSumNsp: TLabel
          Left = 254
          Top = 24
          Width = 3
          Height = 13
          Alignment = taRightJustify
        end
        object dbeSumBase: TLabel
          Left = 528
          Top = 8
          Width = 3
          Height = 13
        end
        object lNDS: TLabel
          Left = 205
          Top = 8
          Width = 71
          Height = 13
          AutoSize = False
          Caption = #1053#1044#1057':'
        end
        object lAllNDS: TLabel
          Left = 205
          Top = 40
          Width = 73
          Height = 13
          AutoSize = False
          Caption = #1042#1089#1077#1075#1086' '#1089' '#1053#1044#1057' '#1080' '#1053#1057#1055':'
        end
        object lAll: TLabel
          Left = 55
          Top = 8
          Width = 34
          Height = 13
          Caption = #1048#1090#1086#1075#1086':'
        end
        object edSumBase: TEdit
          Left = 525
          Top = 9
          Width = 68
          Height = 21
          TabOrder = 0
          Text = 'edSumBase'
        end
      end
      object dbgPositions: TkaDBGrid
        Left = 8
        Top = 0
        Width = 602
        Height = 202
        DataSource = dsPositions
        TabOrder = 3
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnColEnter = dbgPositionsColEnter
        OnExit = dbgPositionsExit
        Columns = <
          item
            Expanded = False
            FieldName = 'WORK_TYPE_CODE'
            Title.Caption = #1050#1086#1076
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'WORK_TYPES_NAME'
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 91
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UNIT'
            Title.Caption = #1045#1076#1080#1085#1080#1094#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRICE'
            Title.Caption = #1062#1077#1085#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QUANTITY'
            Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            Width = 74
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUMMA'
            Title.Caption = #1057#1091#1084#1084#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ARGUMENT'
            Title.Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
            Width = 125
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OBJECTS_AMOUNT'
            Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1086#1073#1098#1077#1082#1090#1086#1074
            Width = 126
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRINTED'
            ReadOnly = True
            Title.Caption = #1055#1077#1095#1072#1090#1100
            Visible = True
          end>
      end
      object cbPrintWorksValue: TCheckBox
        Left = 456
        Top = 414
        Width = 153
        Height = 17
        Caption = #1087#1077#1095#1072#1090#1072#1090#1100' '#1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1088#1072#1073#1086#1090
        TabOrder = 4
      end
      object btnSum: TButton
        Left = 504
        Top = 312
        Width = 105
        Height = 25
        Hint = #1057#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1077#1087#1077#1095#1072#1090#1072#1077#1084#1091#1102#13#10#1088#1072#1073#1086#1090#1091' '#1089' '#1087#1077#1095#1072#1090#1072#1077#1084#1086#1081
        Caption = #1057#1091#1084#1084#1080#1088#1086#1074#1072#1090#1100
        TabOrder = 5
        TabStop = False
      end
    end
    object tshPayer: TTabSheet
      Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbPayer: TGroupBox
        Left = 0
        Top = 0
        Width = 614
        Height = 257
        Align = alTop
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 121
          Width = 31
          Height = 13
          Caption = #1040#1076#1088#1077#1089
          FocusControl = edPayerAddress
        end
        object Label23: TLabel
          Left = 8
          Top = 161
          Width = 55
          Height = 13
          Caption = #1056#1077#1082#1074#1080#1079#1080#1090#1099
        end
        object Label29: TLabel
          Left = 8
          Top = 213
          Width = 52
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085#1099
          FocusControl = edPayerPhones
        end
        object Label30: TLabel
          Left = 178
          Top = 213
          Width = 21
          Height = 13
          Caption = #1048#1053#1053
          FocusControl = edPayerINN
        end
        object Label31: TLabel
          Left = 8
          Top = 80
          Width = 265
          Height = 13
          Caption = #1055#1088#1077#1076#1089#1090#1072#1074#1080#1090#1077#1083#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1074' '#1088#1086#1076#1080#1090'. '#1087#1072#1076#1077#1078#1077' ('#1082#1086#1075#1086' ?)'
          FocusControl = edPayerCustomer
        end
        object btnPayerClear: TButton
          Left = 168
          Top = 48
          Width = 75
          Height = 25
          Caption = #1054'&'#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 3
          TabStop = False
        end
        object btnPayerDetail: TButton
          Left = 88
          Top = 48
          Width = 76
          Height = 25
          Caption = #1055#1086'&'#1076#1088#1086#1073#1085#1086
          TabOrder = 2
          TabStop = False
        end
        object btnPayerSelect: TButton
          Left = 8
          Top = 48
          Width = 75
          Height = 25
          Caption = #1042'&'#1099#1073#1088#1072#1090#1100
          TabOrder = 1
        end
        object edPayerName: TEdit
          Left = 8
          Top = 16
          Width = 602
          Height = 21
          TabStop = False
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 0
        end
        object edPayerAddress: TEdit
          Left = 8
          Top = 137
          Width = 599
          Height = 21
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 5
        end
        object mPayerProperties: TMemo
          Left = 8
          Top = 176
          Width = 599
          Height = 33
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 6
        end
        object edPayerPhones: TEdit
          Left = 8
          Top = 228
          Width = 153
          Height = 21
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 7
        end
        object edPayerINN: TEdit
          Left = 178
          Top = 228
          Width = 89
          Height = 21
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 8
        end
        object edPayerCustomer: TEdit
          Left = 8
          Top = 96
          Width = 599
          Height = 21
          MaxLength = 500
          TabOrder = 4
        end
        object btnExChange: TBitBtn
          Left = 432
          Top = 48
          Width = 169
          Height = 25
          Caption = #1055#1086#1084#1077#1085#1103#1090#1100' '#1089' '#1079#1072#1082#1072#1079#1095#1080#1082#1086#1084
          TabOrder = 9
          TabStop = False
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDA4A4A4A4A4
            A400A4FDFDFDFDFDFDFD000000000000000000A4FDFDFDA4FDA4006F6F6F6F6F
            6F6F6F00A4FDFD00FD00005F5F5F5F5F5F5F5F6F00A4FD00FD00005F5F5F5F5F
            5F5F5F5F5F00FD00FD00005F5F5F5F5F5F5F5F5F00FDFD00A400000000000000
            00005F00FDFDFD000000FDFDFDFDFDFDFDA400FDFDFDFDFDFDFDA4A4A4FDFDFD
            A400A4A4A4A4A4A4A4A4000000FDFDA400350000000000000000FDA400FDA400
            35353535353535353500FD00A4FD003535353535353535353500A4A400FDFD00
            3D353535353535353500000000FDFDFD003D3D3D3D3D3D3D3D00FDFDFDFDFDFD
            FD000000000000000000FDFDFDFDFDFDFDFD00FDFDFDFDFDFDFD}
        end
      end
      object bgBankAccount: TGroupBox
        Left = 0
        Top = 257
        Width = 614
        Height = 201
        Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1081' '#1089#1095#1077#1090
        TabOrder = 1
        object Label34: TLabel
          Left = 8
          Top = 69
          Width = 63
          Height = 13
          Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
        end
        object Label33: TLabel
          Left = 8
          Top = 17
          Width = 24
          Height = 13
          Caption = #1041#1072#1085#1082
        end
        object Label35: TLabel
          Left = 160
          Top = 69
          Width = 50
          Height = 13
          Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
        end
        object mPayerBank: TMemo
          Left = 8
          Top = 32
          Width = 599
          Height = 33
          TabStop = False
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 0
        end
        object edPayerBankAccount: TEdit
          Left = 8
          Top = 84
          Width = 140
          Height = 21
          TabStop = False
          Color = cl3DLight
          MaxLength = 20
          ReadOnly = True
          TabOrder = 1
          Text = '9999999999999999999999'
        end
        object edAccountType: TEdit
          Left = 160
          Top = 84
          Width = 121
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object btnSelectAccount: TBitBtn
          Left = 432
          Top = 80
          Width = 169
          Height = 25
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1095#1077#1090
          TabOrder = 3
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F7F7F7F7F7F7
            F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F700F7F7F7F7F7F7F7F7F7F7F7F7F7F7
            00FE00F7F7F7F7F7F7F7F7F7F7F7F700FEFEFE00F7F7F7F7F7F7F7F7F7F700FE
            FEFEFEFE00F7F7F7F7F7F7F7F700FEFEFEFEFEFEFE00F7F7F7F7F7F700FEFEFE
            FEFEFEFEFEFE00F7F7F7F70000000000FEFEFE0000000000F7F7F7F7F7F7F700
            FEFEFE00F7F7F7F7F7F7F7F7F7F7F700FEFEFE00F7F7F7F7F7F7F7F7F7F7F700
            FEFEFE00F7F7F7F7F7F7F7F7F7F7F700FEFEFE00F7F7F7F7F7F7F7F7F7F7F700
            FEFEFE00F7F7F7F7F7F7F7F7F7F7F700FEFEFE00F7F7F7F7F7F7F7F7F7F7F700
            00000000F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7}
        end
      end
    end
    object tshLetter: TTabSheet
      Caption = #1042#1093#1086#1076#1103#1097#1077#1077' '#1087#1080#1089#1100#1084#1086
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label51: TLabel
        Left = 351
        Top = 160
        Width = 76
        Height = 13
        Caption = #1058'&'#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Enabled = False
      end
      object Label52: TLabel
        Left = 3
        Top = 160
        Width = 92
        Height = 13
        Caption = #1054#1090#1076#1077#1083' - '#1074#1083#1072#1076#1077#1083#1077#1094
        Enabled = False
      end
      object Label54: TLabel
        Left = 3
        Top = 269
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = '&'#1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
        Enabled = False
      end
      object Label43: TLabel
        Left = 3
        Top = 211
        Width = 47
        Height = 13
        Alignment = taRightJustify
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082
        Enabled = False
      end
      object Label50: TLabel
        Left = 3
        Top = 377
        Width = 121
        Height = 13
        Caption = #1054#1090'&'#1084#1077#1090#1082#1072' '#1086#1073' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1080
        Enabled = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label49: TLabel
        Left = 3
        Top = 404
        Width = 64
        Height = 13
        Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072
        Enabled = False
      end
      object btnLetterSelect: TSpeedButton
        Left = 454
        Top = 25
        Width = 157
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
        OnClick = btnLetterSelectClick
      end
      object btnLetterClear: TSpeedButton
        Left = 454
        Top = 56
        Width = 157
        Height = 25
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        OnClick = btnLetterClearClick
      end
      object cbLetterDocType: TComboBox
        Left = 351
        Top = 179
        Width = 260
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 0
      end
      object cbLetterOffice: TComboBox
        Left = 3
        Top = 179
        Width = 342
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 1
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 77
        Width = 342
        Height = 61
        Caption = #1042#1093#1086#1076#1103#1097#1080#1077' '#1052#1055' "'#1059#1043#1040'"'
        TabOrder = 2
        object Label45: TLabel
          Left = 6
          Top = 15
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088
        end
        object Label46: TLabel
          Left = 95
          Top = 15
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072
        end
        object edLetterMPNumber: TEdit
          Left = 5
          Top = 30
          Width = 84
          Height = 21
          TabOrder = 0
        end
        object btnFindLetterMP: TBitBtn
          Left = 200
          Top = 28
          Width = 121
          Height = 25
          Caption = #1053#1072#1081#1090#1080
          TabOrder = 2
          OnClick = btnFindLetterMPClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            88888888888800C88888888888800C88888888000070C88888888088880B8888
            8888088FFFF00000000008F7F770FFFFFFF008FFFFF0FFFFFFF008F77F70F7FF
            FFF080FFFF0FFFFFFFF08800007F77FFFFF0880FFFFFFFFFFFF0880F7777F77F
            FFF0880FFFFFFFFFFFF088000000000000008888888888888888}
        end
        object dtpLetterMPDate: TDateTimePicker
          Left = 95
          Top = 30
          Width = 99
          Height = 21
          Date = 41735.479471631940000000
          Time = 41735.479471631940000000
          TabOrder = 1
        end
      end
      object InGroup: TGroupBox
        Left = 3
        Top = 10
        Width = 342
        Height = 61
        Caption = '&'#1042#1093#1086#1076#1103#1097#1080#1077' '#1050#1043#1040
        TabOrder = 3
        object Label47: TLabel
          Left = 95
          Top = 15
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072
        end
        object Label48: TLabel
          Left = 6
          Top = 15
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088
          FocusControl = edLetterKGANumber
        end
        object edLetterKGANumber: TEdit
          Left = 5
          Top = 30
          Width = 84
          Height = 21
          TabOrder = 0
        end
        object btnFindLetterKGA: TBitBtn
          Left = 200
          Top = 28
          Width = 121
          Height = 25
          Caption = #1053#1072#1081#1090#1080
          TabOrder = 2
          OnClick = btnFindLetterKGAClick
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            88888888888800C88888888888800C88888888000070C88888888088880B8888
            8888088FFFF00000000008F7F770FFFFFFF008FFFFF0FFFFFFF008F77F70F7FF
            FFF080FFFF0FFFFFFFF08800007F77FFFFF0880FFFFFFFFFFFF0880F7777F77F
            FFF0880FFFFFFFFFFFF088000000000000008888888888888888}
        end
        object dtpLetterKGADate: TDateTimePicker
          Left = 95
          Top = 30
          Width = 99
          Height = 21
          Date = 41735.479471631940000000
          Time = 41735.479471631940000000
          TabOrder = 1
        end
      end
      object mLetterContent: TMemo
        Left = 3
        Top = 288
        Width = 608
        Height = 75
        Enabled = False
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object edLetterFirmName: TEdit
        Left = 3
        Top = 230
        Width = 608
        Height = 21
        Enabled = False
        TabOrder = 5
      end
      object edLetterExecutedInfo: TEdit
        Left = 130
        Top = 374
        Width = 481
        Height = 21
        Enabled = False
        TabOrder = 6
      end
      object cbLetterObjectType: TComboBox
        Left = 130
        Top = 401
        Width = 135
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 7
        Items.Strings = (
          #1053#1077#1080#1079#1074#1077#1089#1090#1085#1086
          #1056#1077#1082#1083#1072#1084#1086#1085#1086#1089#1080#1090#1077#1083#1100
          #1042#1088#1077#1084#1077#1085#1085#1099#1077' '#1089#1086#1086#1088#1091#1078#1077#1085#1080#1103)
      end
    end
    object tshMaps: TTabSheet
      Caption = #1055#1083#1072#1085#1096#1077#1090#1099
      ImageIndex = 4
      DesignSize = (
        614
        461)
      object GroupBox1: TGroupBox
        Left = 3
        Top = 3
        Width = 304
        Height = 455
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
        TabOrder = 0
        DesignSize = (
          304
          455)
        object Label37: TLabel
          Left = 11
          Top = 16
          Width = 31
          Height = 13
          Caption = #1053#1072#1081#1090#1080
        end
        object dbgMaps: TkaDBGrid
          Left = 11
          Top = 55
          Width = 197
          Height = 386
          Anchors = [akLeft, akTop, akRight]
          DataSource = dsMaps
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'NOMENCLATURE'
              Title.Caption = #1055#1083#1072#1085#1096#1077#1090
              Width = 160
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
        object btnAddMap: TButton
          Left = 214
          Top = 35
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnAddMapClick
        end
        object btnDeleteMap: TButton
          Left = 214
          Top = 66
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnDeleteMapClick
        end
      end
    end
  end
  object cbCancelled: TCheckBox [6]
    Left = 528
    Top = 502
    Width = 88
    Height = 17
    TabStop = False
    Caption = #1040#1085#1085#1091#1083#1080#1088#1086#1074#1072#1085
    TabOrder = 3
  end
  object dsPositions: TDataSource
    Left = 420
    Top = 41
  end
  object dsMaps: TDataSource
    Left = 328
    Top = 40
  end
end
