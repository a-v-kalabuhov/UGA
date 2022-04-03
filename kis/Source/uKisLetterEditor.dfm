inherited KisLetterEditor: TKisLetterEditor
  Left = 206
  Top = 122
  Caption = #1042#1093#1086#1076#1103#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
  ClientHeight = 466
  ClientWidth = 660
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 666
  ExplicitHeight = 498
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 23
    Top = 438
    ExplicitLeft = 23
    ExplicitTop = 438
  end
  object PageControl: TPageControl [1]
    Left = 0
    Top = 0
    Width = 660
    Height = 425
    ActivePage = tsData
    Align = alTop
    MultiLine = True
    TabOrder = 0
    object tsData: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 6
        Top = 245
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = '&'#1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
      end
      object Label5: TLabel
        Left = 164
        Top = 108
        Width = 63
        Height = 13
        Caption = #1050#1086#1085#1090#1088'. &'#1076#1072#1090#1072
      end
      object Label16: TLabel
        Left = 8
        Top = 353
        Width = 121
        Height = 13
        Caption = #1054#1090'&'#1084#1077#1090#1082#1072' '#1086#1073' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1080
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 356
        Top = 0
        Width = 76
        Height = 13
        Caption = #1058'&'#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      end
      object Label4: TLabel
        Left = 8
        Top = 0
        Width = 92
        Height = 13
        Caption = #1054#1090#1076#1077#1083' - '#1074#1083#1072#1076#1077#1083#1077#1094
      end
      object Label7: TLabel
        Left = 8
        Top = 378
        Width = 64
        Height = 13
        Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072
      end
      object Label14: TLabel
        Left = 164
        Top = 134
        Width = 63
        Height = 26
        Caption = #1050#1086#1085#1090#1088'. '#1076#1072#1090#1072#13#10#1079#1072#1082#1072#1079#1072
      end
      object CustomerGroup2: TGroupBox
        Left = 4
        Top = 169
        Width = 645
        Height = 72
        Caption = #1047#1072'&'#1082#1072#1079#1095#1080#1082
        TabOrder = 8
        object edFirmName: TEdit
          Left = 8
          Top = 15
          Width = 625
          Height = 21
          MaxLength = 120
          TabOrder = 0
        end
        object btnFirmClear: TButton
          Left = 156
          Top = 41
          Width = 70
          Height = 23
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100
          TabOrder = 3
        end
        object btnFirmDetail: TButton
          Left = 82
          Top = 41
          Width = 69
          Height = 23
          Caption = #1055#1086#1076#1088#1086#1073#1085#1086
          TabOrder = 2
        end
        object btnFirmSelect: TButton
          Left = 8
          Top = 41
          Width = 69
          Height = 23
          Caption = #1042#1099#1073#1088#1072#1090#1100
          TabOrder = 1
        end
      end
      object mContent: TMemo
        Left = 4
        Top = 261
        Width = 645
        Height = 75
        ScrollBars = ssVertical
        TabOrder = 9
      end
      object chExecuted: TCheckBox
        Left = 313
        Top = 108
        Width = 71
        Height = 16
        Caption = '&'#1048#1089#1087#1086#1083#1085#1077#1085#1086
        TabOrder = 7
      end
      object edControlDate: TEdit
        Left = 234
        Top = 106
        Width = 68
        Height = 21
        TabOrder = 6
      end
      object InGroup: TGroupBox
        Left = 4
        Top = 37
        Width = 165
        Height = 61
        Caption = '&'#1042#1093#1086#1076#1103#1097#1080#1077' '#1050#1043#1040
        TabOrder = 2
        object Label1: TLabel
          Left = 93
          Top = 15
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072
          FocusControl = edDocDate
        end
        object Label2: TLabel
          Left = 6
          Top = 15
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088
          FocusControl = edDocNumber
        end
        object edDocDate: TEdit
          Left = 93
          Top = 30
          Width = 68
          Height = 21
          TabOrder = 1
        end
        object edDocNumber: TEdit
          Left = 5
          Top = 30
          Width = 84
          Height = 21
          MaxLength = 14
          TabOrder = 0
        end
      end
      object CustomerGroup: TGroupBox
        Left = 173
        Top = 37
        Width = 151
        Height = 61
        Caption = '&'#1047#1072#1082#1072#1079#1095#1080#1082
        TabOrder = 3
        object Label8: TLabel
          Left = 6
          Top = 15
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088
        end
        object Label9: TLabel
          Left = 77
          Top = 15
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072
        end
        object edOrgNumber: TEdit
          Left = 5
          Top = 30
          Width = 68
          Height = 21
          MaxLength = 20
          TabOrder = 0
        end
        object edOrgDate: TEdit
          Left = 77
          Top = 30
          Width = 68
          Height = 21
          TabOrder = 1
        end
      end
      object AdmGroup: TGroupBox
        Left = 326
        Top = 37
        Width = 151
        Height = 61
        Caption = '&'#1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1094#1080#1103
        TabOrder = 4
        object Label11: TLabel
          Left = 6
          Top = 15
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088
        end
        object Label12: TLabel
          Left = 77
          Top = 15
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072
        end
        object edAdmNumber: TEdit
          Left = 5
          Top = 30
          Width = 68
          Height = 21
          MaxLength = 12
          TabOrder = 0
        end
        object edAdmDate: TEdit
          Left = 77
          Top = 30
          Width = 68
          Height = 21
          TabOrder = 1
        end
      end
      object edExecutedInfo: TEdit
        Left = 136
        Top = 350
        Width = 513
        Height = 21
        MaxLength = 120
        TabOrder = 10
      end
      object cbDocTypesName: TComboBox
        Left = 356
        Top = 15
        Width = 293
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
      end
      object cbOfficeName: TComboBox
        Left = 8
        Top = 15
        Width = 342
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 479
        Top = 37
        Width = 170
        Height = 61
        Caption = #1042#1093#1086#1076#1103#1097#1080#1077' '#1052#1055' "'#1059#1043#1040'"'
        TabOrder = 5
        object Label10: TLabel
          Left = 6
          Top = 15
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088
        end
        object Label13: TLabel
          Left = 93
          Top = 15
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072
        end
        object edMPNumber: TEdit
          Left = 5
          Top = 30
          Width = 84
          Height = 21
          MaxLength = 14
          TabOrder = 0
        end
        object edMPDate: TEdit
          Left = 93
          Top = 30
          Width = 68
          Height = 21
          TabOrder = 1
        end
      end
      object btnGenerateMPNumber: TButton
        Left = 494
        Top = 104
        Width = 151
        Height = 24
        Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1086#1084#1077#1088
        TabOrder = 12
        TabStop = False
      end
      object btnGenerateKGANumber: TButton
        Left = 4
        Top = 104
        Width = 151
        Height = 24
        Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1086#1084#1077#1088
        TabOrder = 13
        TabStop = False
      end
      object cbObjectType: TComboBox
        Left = 136
        Top = 375
        Width = 135
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 11
        Items.Strings = (
          #1053#1077#1080#1079#1074#1077#1089#1090#1085#1086
          #1056#1077#1082#1083#1072#1084#1086#1085#1086#1089#1080#1090#1077#1083#1100
          #1042#1088#1077#1084#1077#1085#1085#1099#1077' '#1089#1086#1086#1088#1091#1078#1077#1085#1080#1103)
      end
      object Edit1: TEdit
        Left = 234
        Top = 138
        Width = 68
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 14
      end
      object CheckBox1: TCheckBox
        Left = 313
        Top = 140
        Width = 71
        Height = 16
        Caption = '&'#1048#1089#1087#1086#1083#1085#1077#1085#1086
        Enabled = False
        TabOrder = 15
      end
    end
    object tsVisa: TTabSheet
      Caption = #1042#1080#1079#1099', '#1076#1074#1080#1078#1077#1085#1080#1077
      OnShow = tsVisaShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object VisaGroup: TGroupBox
        Left = 0
        Top = 0
        Width = 652
        Height = 130
        Align = alTop
        Caption = #1042#1080'&'#1079#1099
        TabOrder = 0
        object dbgVisas: TkaDBGrid
          Left = 2
          Top = 15
          Width = 648
          Height = 113
          Align = alClient
          DataSource = dsVisas
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines]
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'DOC_DATE'
              Title.Caption = #1044#1072#1090#1072
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CONTROL_DATE'
              Title.Caption = #1050#1086#1085#1090#1088'. '#1076#1072#1090#1072
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SIGNATURE'
              Title.Caption = #1055#1086#1076#1087#1080#1089#1100
              Width = 103
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CONTENT'
              Title.Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
              Width = 310
              Visible = True
            end>
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 130
        Width = 652
        Height = 267
        Align = alClient
        Caption = #1044#1074#1080#1078#1077#1085#1080#1077
        TabOrder = 1
        object pcPassing: TPageControl
          Left = 2
          Top = 15
          Width = 648
          Height = 250
          ActivePage = tsPassingMain
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 0
          object tsPassingMain: TTabSheet
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object btnNew: TSpeedButton
              Left = 15
              Top = 159
              Width = 62
              Height = 22
              Caption = #1044#1086#1073#1072#1074#1080#1090#1100
              OnClick = btnNewClick
            end
            object btnDel: TSpeedButton
              Left = 89
              Top = 159
              Width = 62
              Height = 22
              Caption = #1059#1076#1072#1083#1080#1090#1100
              OnClick = btnDelClick
            end
            object btnShow: TSpeedButton
              Left = 164
              Top = 159
              Width = 62
              Height = 22
              Caption = #1048#1079#1084#1077#1085#1080#1090#1100
              OnClick = btnShowClick
            end
            object dbgPassings: TkaDBGrid
              Left = 0
              Top = 0
              Width = 640
              Height = 148
              Align = alTop
              DataSource = dsPassings
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = RUSSIAN_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'DOC_DATE'
                  Title.Caption = #1044#1072#1090#1072
                  Width = 65
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'EXECUTED'
                  Title.Caption = #1048#1089#1087'.'
                  Width = 50
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'OFFICES_NAME'
                  Title.Caption = #1054#1090#1076#1077#1083
                  Width = 135
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'PEOPLE_FULL_NAME'
                  Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
                  Width = 145
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CONTENT'
                  Title.Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
                  Width = 196
                  Visible = True
                end>
            end
          end
          object tsPassingAdditional: TTabSheet
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object dbgParentPassings: TkaDBGrid
              Left = 0
              Top = 0
              Width = 640
              Height = 219
              Align = alClient
              DataSource = dsParentPassings
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = RUSSIAN_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
              Columns = <
                item
                  Expanded = False
                  FieldName = 'DOC_DATE'
                  Title.Caption = #1044#1072#1090#1072
                  Width = 65
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'EXECUTED'
                  Title.Caption = #1048#1089#1087'.'
                  Width = 50
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'OFFICES_NAME'
                  Title.Caption = #1054#1090#1076#1077#1083
                  Width = 135
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'PEOPLE_FULL_NAME'
                  Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
                  Width = 145
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CONTENT'
                  Title.Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
                  Width = 196
                  Visible = True
                end>
            end
          end
        end
      end
    end
    object tsAddition: TTabSheet
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1086#1090#1076#1077#1083#1086#1074
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgOfficeDocs: TkaDBGrid
        Left = 8
        Top = 15
        Width = 561
        Height = 335
        DataSource = dsOfficeDocs
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'DOC_YEAR'
            Title.Caption = #1043#1086#1076
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Width = 131
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR_DATE'
            Title.Caption = #1050#1086#1075#1076#1072' '#1087#1077#1088#1077#1076#1072#1085#1086
            Visible = True
          end>
      end
      object btnOfficeDocCreate: TButton
        Left = 580
        Top = 22
        Width = 68
        Height = 24
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnOfficeDocCreateClick
      end
      object btnOfficeDocDelete: TButton
        Left = 580
        Top = 52
        Width = 68
        Height = 24
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
        OnClick = btnOfficeDocDeleteClick
      end
      object btnOfficeDocEdit: TButton
        Left = 580
        Top = 82
        Width = 68
        Height = 23
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 3
        OnClick = btnOfficeDocEditClick
      end
    end
    object tsAddresses: TTabSheet
      Caption = #1040#1076#1088#1077#1089#1072' '#1086#1073#1098#1077#1082#1090#1086#1074
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgAddresses: TkaDBGrid
        Left = 8
        Top = 15
        Width = 561
        Height = 335
        DataSource = dsAddresses
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            ButtonStyle = cbsEllipsis
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'LETTERS_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ADDRESS'
            Title.Caption = #1040#1076#1088#1077#1089' '#1086#1073#1098#1077#1082#1090#1072
            Width = 376
            Visible = True
          end>
      end
      object btnAddAddress: TButton
        Left = 578
        Top = 14
        Width = 68
        Height = 24
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnAddAddressClick
      end
      object btnDeleteAddress: TButton
        Left = 578
        Top = 44
        Width = 68
        Height = 24
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
        OnClick = btnDeleteAddressClick
      end
      object btnEditAddress: TButton
        Left = 578
        Top = 74
        Width = 68
        Height = 23
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 3
        OnClick = btnEditAddressClick
      end
    end
    object tsOutcomLetters: TTabSheet
      Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1077' '#1087#1080#1089#1100#1084#1072
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgOutcomLetters: TkaDBGrid
        Left = 0
        Top = 0
        Width = 569
        Height = 397
        Align = alLeft
        DataSource = dsOutcomLetters
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            ButtonStyle = cbsEllipsis
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'INCOMLETTER_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'OUTCOMLETTER_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'SEQ_NUMBER'
            Title.Caption = #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' '#1085#1086#1084#1077#1088
            Width = 119
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088' '#1052#1055
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_REG'
            Title.Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Width = 139
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FIRM_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'FIRM'
            Title.Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100' '#1087#1080#1089#1100#1084#1072
            Width = 159
            Visible = True
          end>
      end
      object btnEditOutcomLetter: TButton
        Left = 580
        Top = 67
        Width = 68
        Height = 23
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 1
      end
      object btnSelectOutcomLetter: TButton
        Left = 580
        Top = 8
        Width = 68
        Height = 23
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 2
      end
      object btnDeleteOutcomLetter: TButton
        Left = 580
        Top = 37
        Width = 68
        Height = 23
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 3
        OnClick = btnDeleteOutcomLetterClick
      end
    end
  end
  inherited btnOk: TButton
    Left = 496
    Top = 433
    Anchors = [akRight, akBottom]
    Default = True
    TabOrder = 1
    ExplicitLeft = 496
    ExplicitTop = 433
  end
  inherited btnCancel: TButton
    Left = 577
    Top = 433
    Anchors = [akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 577
    ExplicitTop = 433
  end
  object dsAddresses: TDataSource
    Left = 320
    Top = 305
  end
  object dsOfficeDocs: TDataSource
    Left = 280
    Top = 305
  end
  object dsPassings: TDataSource
    Left = 240
    Top = 305
  end
  object dsVisas: TDataSource
    Left = 200
    Top = 305
  end
  object dsParentPassings: TDataSource
    Left = 362
    Top = 305
  end
  object dsOutcomLetters: TDataSource
    Left = 404
    Top = 305
  end
end
