object AllotmentForm: TAllotmentForm
  Left = 207
  Top = 176
  BorderStyle = bsDialog
  Caption = #1054#1090#1074#1086#1076
  ClientHeight = 582
  ClientWidth = 982
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    982
    582)
  PixelsPerInch = 96
  TextHeight = 13
  object Label28: TLabel
    Left = 258
    Top = 550
    Width = 139
    Height = 26
    Alignment = taCenter
    Anchors = [akLeft, akBottom]
    Caption = #1046#1077#1083#1090#1099#1077' '#1087#1086#1083#1103' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#13#10#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103'!'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 982
    Height = 544
    ActivePage = tshData
    Align = alTop
    TabOrder = 0
    object tshData: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      object Label1: TLabel
        Left = 8
        Top = 41
        Width = 31
        Height = 13
        Caption = '&'#1040#1076#1088#1077#1089
        FocusControl = dbeAddress
      end
      object Label2: TLabel
        Left = 640
        Top = 1
        Width = 30
        Height = 13
        Caption = '&'#1056#1072#1081#1086#1085
        FocusControl = dbcbRegion
      end
      object Label3: TLabel
        Left = 8
        Top = 82
        Width = 47
        Height = 13
        Caption = '&'#1055#1083#1086#1097#1072#1076#1100
        FocusControl = dbeArea
      end
      object Label12: TLabel
        Left = 8
        Top = 0
        Width = 66
        Height = 13
        Caption = #1044#1072#1090#1072' '#1086#1090#1074#1086#1076#1072
        FocusControl = dbeDocDate
      end
      object Label33: TLabel
        Left = 8
        Top = 120
        Width = 53
        Height = 13
        Caption = #1043#1077#1086#1076#1077#1079#1080#1089#1090
      end
      object Label6: TLabel
        Left = 8
        Top = 459
        Width = 58
        Height = 13
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      end
      object Label11: TLabel
        Left = 91
        Top = 0
        Width = 31
        Height = 13
        Caption = #1053#1086#1084#1077#1088
        FocusControl = dbeDocNumber
      end
      object Label10: TLabel
        Left = 174
        Top = 0
        Width = 133
        Height = 13
        Caption = #8470' '#1088#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1075#1086' '#1086#1090#1074#1086#1076#1072
        FocusControl = dbeParentNumber
      end
      object Label15: TLabel
        Left = 315
        Top = 0
        Width = 110
        Height = 13
        Caption = #8470' '#1076#1086#1095#1077#1088#1085#1077#1075#1086' '#1086#1090#1074#1086#1076#1072
        FocusControl = dbeChildNumber
      end
      object Label19: TLabel
        Left = 256
        Top = 120
        Width = 141
        Height = 13
        Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1086#1076#1075#1086#1090#1086#1074#1080#1083
      end
      object Label20: TLabel
        Left = 244
        Top = 491
        Width = 107
        Height = 13
        Caption = #1044#1072#1090#1072' '#1072#1085#1085#1091#1083#1080#1088#1086#1074#1072#1085#1080#1103
      end
      object Label21: TLabel
        Left = 429
        Top = 491
        Width = 66
        Height = 13
        Caption = #1053#1086#1074#1099#1081' '#1085#1086#1084#1077#1088
      end
      object Label26: TLabel
        Left = 98
        Top = 82
        Width = 137
        Height = 13
        Caption = #1055#1083#1086#1097#1072#1076#1100' '#1073#1083#1072#1075#1086#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
        FocusControl = dbedAccomplishmentArea
      end
      object Label27: TLabel
        Left = 257
        Top = 82
        Width = 173
        Height = 13
        Caption = #1055#1083#1086#1097#1072#1076#1100' '#1074#1088#1077#1084#1077#1085#1085#1086#1075#1086' '#1089#1086#1086#1088#1091#1078#1077#1085#1080#1103
        FocusControl = dbedTempBuildingArea
      end
      object Label8: TLabel
        Left = 608
        Top = 120
        Width = 138
        Height = 13
        Caption = #1055#1088#1086#1077#1082#1090' '#1075#1088#1072#1085#1080#1094' '#1087#1086#1076#1075#1086#1090#1086#1074#1080#1083
      end
      object Label29: TLabel
        Left = 608
        Top = 82
        Width = 71
        Height = 13
        Caption = #1057#1086#1079#1076#1072#1083' '#1086#1090#1074#1086#1076
      end
      object Label31: TLabel
        Left = 437
        Top = 0
        Width = 54
        Height = 13
        Caption = '&'#1050#1072#1090#1077#1075#1086#1088#1080#1103
        FocusControl = dbcbRegion
      end
      object Label32: TLabel
        Left = 10
        Top = 167
        Width = 317
        Height = 13
        Caption = #1057#1089#1099#1083#1082#1072' '#1085#1072' '#1087#1088#1072#1074#1086#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1102#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1074' '#1050#1086#1085#1089#1091#1083#1100#1090#1072#1085#1090#1077
      end
      object dbeAddress: TDBEdit
        Left = 8
        Top = 55
        Width = 828
        Height = 21
        Color = clInfoBk
        DataField = 'ADDRESS'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = dbeAddressChange
      end
      object dbcbRegion: TDBLookupComboBox
        Left = 639
        Top = 15
        Width = 197
        Height = 21
        Color = clInfoBk
        DataField = 'REGIONS_NAME'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object dbeArea: TDBEdit
        Left = 13
        Top = 94
        Width = 68
        Height = 21
        DataField = 'AREA'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object dbeCancelledInfo: TDBEdit
        Left = 115
        Top = 488
        Width = 121
        Height = 21
        DataField = 'CANCELLED_INFO'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
      end
      object dbeDocDate: TDBEdit
        Left = 8
        Top = 15
        Width = 73
        Height = 21
        DataField = 'DOC_DATE'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object gbOwners: TGroupBox
        Left = 484
        Top = 272
        Width = 475
        Height = 178
        Caption = #1042#1083#1072#1076#1077#1083#1100#1094#1099
        TabOrder = 5
        DesignSize = (
          475
          178)
        object dbgOwners: TDBGrid
          Left = 10
          Top = 18
          Width = 379
          Height = 157
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = dsOwners
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = btnOwnerEditClick
          Columns = <
            item
              Expanded = False
              FieldName = 'NAME'
              Title.Caption = #1042#1083#1072#1076#1077#1083#1077#1094
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Width = 108
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PERCENT'
              Title.Caption = #1055#1088#1086#1094#1077#1085#1090
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Width = 48
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PURPOSE'
              Title.Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PROP_FORMS_NAME'
              Title.Caption = #1060#1086#1088#1084#1072' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1086#1089#1090#1080
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Width = 122
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'RENT_PERIOD'
              Title.Caption = #1057#1088#1086#1082' '#1072#1088#1077#1085#1076#1099
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Visible = True
            end>
        end
        object bntOwnerNew: TButton
          Left = 395
          Top = 15
          Width = 71
          Height = 23
          Anchors = [akTop, akRight]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = bntOwnerNewClick
        end
        object btnOwnerDel: TButton
          Left = 395
          Top = 38
          Width = 71
          Height = 24
          Anchors = [akTop, akRight]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnOwnerDelClick
        end
        object btnOwnerEdit: TButton
          Left = 395
          Top = 62
          Width = 71
          Height = 24
          Anchors = [akTop, akRight]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 3
          OnClick = btnOwnerEditClick
        end
      end
      object gbDecrees: TGroupBox
        Left = 3
        Top = 272
        Width = 475
        Height = 178
        Caption = #1053#1086#1088#1084#1072#1090#1080#1074#1085#1099#1077' '#1072#1082#1090#1099
        TabOrder = 6
        DesignSize = (
          475
          178)
        object dbgDocs: TDBGrid
          Left = 8
          Top = 15
          Width = 379
          Height = 156
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = dsDocs
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = btnDecreeEditClick
          Columns = <
            item
              Expanded = False
              FieldName = 'DOC_NUMBER'
              Title.Caption = #1053#1086#1084#1077#1088
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DOC_DATE'
              Title.Caption = #1044#1072#1090#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'HEADER'
              Title.Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Width = 341
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DECREE_TYPES_NAME'
              Title.Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'Tahoma'
              Title.Font.Style = []
              Visible = True
            end>
        end
        object btnDecreeNew: TButton
          Left = 395
          Top = 15
          Width = 71
          Height = 22
          Anchors = [akTop, akRight]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnDecreeNewClick
        end
        object btnDecreeDel: TButton
          Left = 395
          Top = 37
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnDecreeDelClick
        end
        object btnDecreeEdit: TButton
          Left = 395
          Top = 58
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 3
          OnClick = btnDecreeEditClick
        end
        object btnDecreeDetail: TButton
          Left = 395
          Top = 79
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          Caption = #1055#1086#1076#1088#1086#1073#1085#1086
          TabOrder = 4
          OnClick = btnDecreeDetailClick
        end
      end
      object dbchCancelled: TDBCheckBox
        Left = 4
        Top = 491
        Width = 105
        Height = 16
        Caption = #1053#1077#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1077#1085
        DataField = 'CANCELLED'
        DataSource = AllotmentsForm.DataSource
        TabOrder = 8
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object dbeExecutor: TDBEdit
        Left = 8
        Top = 133
        Width = 241
        Height = 21
        Color = clInfoBk
        DataField = 'EXECUTOR'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        TabOrder = 4
      end
      object dbeDocuments: TDBEdit
        Left = 75
        Top = 456
        Width = 886
        Height = 21
        DataField = 'DOCUMENTS'
        DataSource = AllotmentsForm.DataSource
        TabOrder = 7
      end
      object dbeDocNumber: TDBEdit
        Left = 91
        Top = 15
        Width = 70
        Height = 21
        DataField = 'DOC_NUMBER'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
      end
      object dbeParentNumber: TDBEdit
        Left = 174
        Top = 15
        Width = 61
        Height = 21
        DataField = 'PARENT_NUMBER'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
      end
      object dbeChildNumber: TDBEdit
        Left = 315
        Top = 15
        Width = 61
        Height = 21
        DataField = 'CHILD_NUMBER'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
      end
      object dbeDecreePrepared: TDBEdit
        Left = 255
        Top = 133
        Width = 232
        Height = 21
        DataField = 'DECREE_PREPARED'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        TabOrder = 13
      end
      object dbeAnnulDate: TDBEdit
        Left = 354
        Top = 488
        Width = 62
        Height = 21
        DataField = 'ANNUL_DATE'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
      end
      object dbeNewNumber: TDBEdit
        Left = 497
        Top = 488
        Width = 61
        Height = 21
        DataField = 'NEW_NUMBER'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 15
      end
      object dbedAccomplishmentArea: TDBEdit
        Left = 103
        Top = 94
        Width = 69
        Height = 21
        DataField = 'ACCOMPLISHMENT_AREA'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 16
      end
      object dbedTempBuildingArea: TDBEdit
        Left = 256
        Top = 94
        Width = 73
        Height = 21
        DataField = 'TEMP_BUILDING_AREA'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 17
      end
      object dbeBoundaryProjectPrepared: TDBEdit
        Left = 606
        Top = 133
        Width = 232
        Height = 21
        DataField = 'BOUNDARY_PROJECT_PREPARED'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 18
      end
      object dbeCreator: TDBEdit
        Left = 606
        Top = 94
        Width = 232
        Height = 21
        Color = clInactiveCaption
        DataField = 'CREATOR'
        DataSource = AllotmentsForm.DataSource
        ReadOnly = True
        TabOrder = 19
      end
      object dbcbLotKinds: TDBLookupComboBox
        Left = 436
        Top = 15
        Width = 197
        Height = 21
        Color = clInfoBk
        DataField = 'LOT_KINDS_NAME'
        DataSource = AllotmentsForm.DataSource
        DropDownRows = 10
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 20
      end
      object dbchMSK36: TDBCheckBox
        Left = 592
        Top = 491
        Width = 105
        Height = 16
        Caption = #1052#1057#1050' 36'
        DataField = 'MSK36'
        DataSource = AllotmentsForm.DataSource
        TabOrder = 21
        ValueChecked = '1'
        ValueUnchecked = '0'
        OnClick = dbchMSK36Click
      end
      object dbeConsultant: TDBEdit
        Left = 8
        Top = 183
        Width = 828
        Height = 21
        Color = clInfoBk
        DataField = 'LINK_CONSULTANT'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 1000
        ParentFont = False
        TabOrder = 22
      end
      object btnOpenLinkConsultant: TButton
        Left = 842
        Top = 181
        Width = 108
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100
        TabOrder = 23
        OnClick = btnOpenLinkConsultantClick
      end
    end
    object tshCoordinats: TTabSheet
      Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
      object Label7: TLabel
        Left = 0
        Top = 21
        Width = 45
        Height = 13
        Caption = #1050#1086#1085#1090#1091#1088#1099
      end
      object Label14: TLabel
        Left = 452
        Top = 40
        Width = 51
        Height = 13
        Caption = #1055#1083#1086#1097#1072#1076#1100':'
      end
      object Label17: TLabel
        Left = 0
        Top = 198
        Width = 30
        Height = 13
        Caption = #1058#1086#1095#1082#1080
      end
      object Label18: TLabel
        Left = 545
        Top = 0
        Width = 65
        Height = 13
        Caption = #1055#1083#1072#1085' '#1086#1090#1074#1086#1076#1072
      end
      object btnPointCopy: TSpeedButton
        Left = 440
        Top = 487
        Width = 102
        Height = 26
        Action = acPointDelete
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF000000
          0000000000000000000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF000000
          00000000FF000000FF000000FF000000FF000000FF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF000000
          0000000000000000000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00800000008000000080000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF008000000080000000FFFF000080000000FFFF0000800000008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0080000000FFFF0000FFFF000080000000FFFF0000FFFF00008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0080000000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00800000008000
          0000800000008000000080000000800000008000000080000000800000008000
          000080000000800000008000000080000000FF00FF00FF00FF00FF00FF00FF00
          FF0080000000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0080000000FFFF0000FFFF000080000000FFFF0000FFFF00008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF008000000080000000FFFF000080000000FFFF0000800000008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00800000008000000080000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object btnWriteArea: TSpeedButton
        Left = 509
        Top = 55
        Width = 33
        Height = 21
        Hint = #1047#1072#1085#1077#1089#1090#1080' '#1074#1099#1095#1077#1089#1083#1077#1085#1085#1091#1102' '#1087#1083#1086#1097#1072#1076#1100' '#1074' '#1087#1086#1083#1077' "'#1055#1083#1086#1097#1072#1076#1100'" '#1085#1072' '#1074#1082#1083#1072#1076#1082#1077' "'#1044#1072#1085#1085#1099#1077'"'
        Caption = '>>'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Dialog'
        Font.Style = []
        ParentFont = False
        OnClick = btnWriteAreaClick
      end
      object SpeedButton1: TSpeedButton
        Left = 440
        Top = 214
        Width = 102
        Height = 26
        Action = acPointAdd
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00000000000000FF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF000000
          000000000000000000000000FF00000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF000000
          00000000FF000000FF000000FF000000FF000000FF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF000000
          000000000000000000000000FF00000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00800000008000000080000000FF00FF00FF00
          FF00FF00FF00000000000000FF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF008000000080000000FFFF000080000000FFFF0000800000008000
          0000FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0080000000FFFF0000FFFF000080000000FFFF0000FFFF00008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0080000000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00800000008000
          0000800000008000000080000000800000008000000080000000800000008000
          000080000000800000008000000080000000FF00FF00FF00FF00FF00FF00FF00
          FF0080000000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0080000000FFFF0000FFFF000080000000FFFF0000FFFF00008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF008000000080000000FFFF000080000000FFFF0000800000008000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00800000008000000080000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object SpeedButton2: TSpeedButton
        Left = 440
        Top = 246
        Width = 102
        Height = 26
        Action = acPointEdit
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00
          FF000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00
          FF00FF00FF00000000000000FF000000FF0000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00
          FF00000000000000FF000000FF000000FF0000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00800000008000000080000000FF00
          FF00FF00FF00000000000000FF000000000000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF008000000080000000FFFF000080000000FFFF00008000
          000080000000FF00FF0000000000FF00FF0000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF0080000000FFFF0000FFFF000080000000FFFF0000FFFF
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0080000000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF
          0000FFFF000080000000FF00FF00FF00FF00FF00FF00FF00FF00800000008000
          0000800000008000000080000000800000008000000080000000800000008000
          00008000000080000000800000008000000080000000FF00FF00FF00FF00FF00
          FF00FF00FF0080000000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF
          0000FFFF000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF0080000000FFFF0000FFFF000080000000FFFF0000FFFF
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
          FF0000000000FF00FF008000000080000000FFFF000080000000FFFF00008000
          000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          00000000FF0000000000FF00FF00FF00FF00800000008000000080000000FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          FF000000FF000000FF0000000000FF00FF00FF00FF0080000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          FF000000FF0000000000FF00FF00FF00FF00FF00FF0080000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          0000000000000000000000000000FF00FF00FF00FF0080000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object SpeedButton3: TSpeedButton
        Left = 440
        Top = 278
        Width = 102
        Height = 26
        Action = acPointCopy
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          0000FF000000FFFF0000FF000000FFFF0000FF000000FF000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          0000FFFF0000FFFF0000FF000000FFFF0000FFFF0000FF000000FF00FF00FF00
          FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF000000FFFF
          0000FFFF0000FFFF0000FF000000FFFF0000FFFF0000FFFF0000FF00FF00FF00
          FF00FF00FF00FF00FF0000000000FF000000FF000000FF000000FF000000FF00
          0000FF000000FF000000FF000000FF000000FF000000FF000000FF00FF00FF00
          FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF000000FFFF
          0000FFFF0000FFFF0000FF000000FFFF0000FFFF0000FFFF0000FF00FF00FF00
          FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          0000FFFF0000FFFF0000FF000000FFFF0000FFFF0000FF000000FF00FF000000
          000000000000FFFF000000000000FFFF00000000000000000000FF00FF00FF00
          0000FF000000FFFF0000FF000000FFFF0000FF000000FF000000FF00FF000000
          0000FFFF0000FFFF000000000000FFFF0000FFFF000000000000FF00FF00FF00
          FF00FF00FF00FF000000FF000000FF000000FF00FF00FF00FF0000000000FFFF
          0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FF00
          FF00FF00FF00FF00FF00FF000000FF00FF00FF00FF00FF00FF00000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF000000FF00FF00FF00FF00FF00FF0000000000FFFF
          0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FF00
          FF00FF00FF00FF00FF00FF000000FF00FF00FF00FF00FF00FF00FF00FF000000
          0000FFFF0000FFFF000000000000FFFF0000FFFF000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
          000000000000FFFF000000000000FFFF00000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object SpeedButton4: TSpeedButton
        Left = 440
        Top = 310
        Width = 102
        Height = 26
        Action = acPointNamePlus
      end
      object SpeedButton5: TSpeedButton
        Left = 440
        Top = 82
        Width = 102
        Height = 26
        Action = acCntAdd
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          0000008484000084840000848400008484000084840000848400008484000084
          8400008484000084840000000000FF00FF00FF00FF00FF00FF000000000000FF
          FF00000000000084840000848400008484000084840000848400008484000084
          840000848400008484000084840000000000FF00FF00FF00FF0000000000FFFF
          FF00000000000000000000848400008484000084840000848400008484000084
          84000084840000848400008484000084840000000000FF00FF000000000000FF
          FF00000000000000000000848400008484000084840000848400008484000084
          840000848400008484000084840000848400008484000000000000000000FFFF
          FF0000000000FFFFFF0000000000000000000000000000000000008484000084
          84000084840000848400008484000084840000848400000000000000000000FF
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
          000000000000000000000000000000000000000000000000000000000000FFFF
          FF0000000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
          C600FFFFFF00C6C6C60000000000FF00FF00FF00FF00FF00FF000000000000FF
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00000000000000000000000000FF00FF00FF00FF00FF00FF000000
          000000000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFF
          FF000000000000FF000000FF000000000000FF00FF00FF00FF00FF00FF00FF00
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
          00000000000000FF000000FF00000000000000000000FF00FF00FF00FF00FF00
          FF0000000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C6000000000000FF
          000000FF000000FF000000FF000000FF000000FF000000000000FF00FF00FF00
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
          000000FF000000FF000000FF000000FF000000FF000000000000FF00FF00FF00
          FF00000000000000000000000000000000000000000000000000000000000000
          00000000000000FF000000FF00000000000000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF000000000000FF000000FF000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF00}
      end
      object SpeedButton6: TSpeedButton
        Left = 440
        Top = 114
        Width = 102
        Height = 26
        Action = acCntEdit
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
          0000FF00FF000000000000000000000000000000000000000000FFFFFF00FFFF
          FF0000000000FFFFFF000000000000000000FFFFFF0000000000FFFF00000000
          00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF00000000
          000000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000FFFF
          FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF00000000
          0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
          0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF00000000
          000000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
          00000000000000FFFF0000000000FFFFFF00FFFFFF0000000000FFFF00000000
          0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
          FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFF00000000
          000000FFFF00FFFFFF0000000000000000000000000000000000000000000000
          000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
          00000000000000FFFF00FFFFFF0000FFFF00000000000000000000FFFF000000
          0000FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF000000000000000000000000000000000000FFFF0000000000FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF000000000000FFFF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF0000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF000000000000FFFF0000000000FFFFFF00FFFFFF000000
          000000000000FFFFFF0000000000FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF000000000000FFFF000000000000000000FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FF00FF00FF00FF00FF00
          FF00000000000000FF0000000000FF00FF0000000000FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF000000000000000000000000000000
          0000000000000000000000000000FF00FF00FF00FF00FF00FF00}
      end
      object SpeedButton7: TSpeedButton
        Left = 440
        Top = 146
        Width = 102
        Height = 26
        Action = acCntDel
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          0000008484000084840000848400008484000084840000848400008484000084
          8400008484000084840000000000FF00FF00FF00FF00FF00FF000000000000FF
          FF00000000000084840000848400008484000084840000848400008484000084
          840000848400008484000084840000000000FF00FF00FF00FF0000000000FFFF
          FF00000000000000000000848400008484000084840000848400008484000084
          84000084840000848400008484000084840000000000FF00FF000000000000FF
          FF00000000000000000000848400008484000084840000848400008484000084
          840000848400008484000084840000848400008484000000000000000000FFFF
          FF0000000000FFFFFF0000000000000000000000000000000000008484000084
          84000084840000848400008484000084840000848400000000000000000000FF
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
          000000000000000000000000000000000000000000000000000000000000FFFF
          FF0000000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
          C600FFFFFF00C6C6C60000000000FF00FF00FF00FF00FF00FF000000000000FF
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00C6C6C60000000000FF00FF00FF00FF00FF00FF00FF00FF000000
          000000000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFF
          FF00FFFFFF00C6C6C60000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
          0000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0000000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600000000000000
          00000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
          8400000084000000840000008400000084000000840000000000FF00FF00FF00
          FF00000000000000000000000000000000000000000000000000000000000000
          FF000000FF000000FF000000FF000000FF000000FF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
          00000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object tbRecord: TToolBar
        Left = 440
        Top = 0
        Width = 92
        Height = 24
        Align = alNone
        ButtonWidth = 25
        Caption = 'tbRecord'
        Images = ImageList
        TabOrder = 5
        object btnEdit: TToolButton
          Left = 0
          Top = 0
          Action = actEdit
        end
        object btnNew: TToolButton
          Left = 25
          Top = 0
          Action = actNew
        end
        object btnDel: TToolButton
          Left = 50
          Top = 0
          Action = actDel
        end
      end
      object PictPanel: TPanel
        Left = 545
        Top = 16
        Width = 427
        Height = 498
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clWhite
        ParentBackground = False
        TabOrder = 4
        object PaintBox: TPaintBox
          Left = 0
          Top = 0
          Width = 423
          Height = 494
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnMouseDown = PaintBoxMouseDown
          OnPaint = PaintBoxPaint
          ExplicitLeft = -4
          ExplicitTop = 4
          ExplicitWidth = 282
          ExplicitHeight = 414
        end
      end
      object dbchErrorCoord: TDBCheckBox
        Left = 244
        Top = 3
        Width = 61
        Height = 16
        Caption = #1054#1096#1080#1073#1082#1072
        DataField = 'ERROR_COORD'
        DataSource = AllotmentsForm.DataSource
        TabOrder = 2
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object lvPoints: TListView
        Left = 0
        Top = 213
        Width = 434
        Height = 300
        Columns = <
          item
            Caption = #1058#1086#1095#1082#1072
            Width = 42
          end
          item
            Alignment = taRightJustify
            Caption = 'X'
            Width = 80
          end
          item
            Alignment = taRightJustify
            Caption = 'Y'
            Width = 80
          end
          item
            Alignment = taRightJustify
            Caption = #1044#1083#1080#1085#1072
            Width = 70
          end
          item
            Caption = #1040#1079#1080#1084#1091#1090
            Width = 70
          end>
        ColumnClick = False
        DragMode = dmAutomatic
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        ParentFont = False
        PopupMenu = PopupMenu
        SmallImages = ImageList
        TabOrder = 1
        ViewStyle = vsReport
        OnDblClick = actEditExecute
        OnEditing = lvPointsEditing
        OnDragDrop = lvPointsDragDrop
        OnDragOver = lvPointsDragOver
        OnKeyDown = lvPointsKeyDown
      end
      object lvContours: TListView
        Left = 0
        Top = 34
        Width = 434
        Height = 158
        Columns = <
          item
            Caption = #1050#1086#1085#1090#1091#1088
          end
          item
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            Width = 150
          end
          item
            Caption = #1042#1080#1076#1077#1085
            Width = 45
          end
          item
            Alignment = taCenter
            Caption = '+/-'
            Width = 40
          end
          item
            Caption = #1047#1072#1084#1082#1085'.'
          end
          item
            Alignment = taRightJustify
            Caption = #1055#1083#1086#1097#1072#1076#1100
            Width = 70
          end>
        ColumnClick = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HideSelection = False
        RowSelect = True
        ParentFont = False
        PopupMenu = PopupMenu
        SmallImages = ilContours
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = actEditExecute
        OnEditing = lvContoursEditing
        OnDragDrop = lvContoursDragDrop
        OnDragOver = lvContoursDragOver
        OnSelectItem = lvContoursSelectItem
      end
      object edtArea: TEdit
        Left = 440
        Top = 55
        Width = 69
        Height = 21
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
        Text = '000000,00'
      end
      object chbShowMSK36: TCheckBox
        Left = 0
        Top = 3
        Width = 157
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074' '#1052#1057#1050'36'
        TabOrder = 6
        OnClick = chbShowMSK36Click
      end
    end
    object tshInfo: TTabSheet
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      object Label16: TLabel
        Left = 3
        Top = 3
        Width = 54
        Height = 13
        Caption = #1051#1072#1085#1076#1096#1072#1092#1090
        FocusControl = dbmLandscape
      end
      object Label4: TLabel
        Left = 3
        Top = 108
        Width = 75
        Height = 13
        Caption = #1053#1077#1076#1074#1080#1078#1080#1084#1086#1089#1090#1100
        FocusControl = dbmRealty
      end
      object Label5: TLabel
        Left = 3
        Top = 213
        Width = 55
        Height = 13
        Caption = #1055#1072#1084#1103#1090#1085#1080#1082#1080
        FocusControl = dbmMonument
      end
      object Label9: TLabel
        Left = 3
        Top = 318
        Width = 82
        Height = 13
        Caption = #1056#1072#1089#1090#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100
        FocusControl = dbmFlora
      end
      object Label13: TLabel
        Left = 3
        Top = 424
        Width = 37
        Height = 13
        Caption = #1055#1088#1086#1095#1072#1103
        FocusControl = dbmInformation
      end
      object dbmLandscape: TDBMemo
        Left = 90
        Top = 0
        Width = 543
        Height = 100
        DataField = 'INFO_LANDSCAPE'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object dbmRealty: TDBMemo
        Left = 90
        Top = 105
        Width = 543
        Height = 100
        DataField = 'INFO_REALTY'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object dbmMonument: TDBMemo
        Left = 90
        Top = 210
        Width = 543
        Height = 100
        DataField = 'INFO_MONUMENT'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object dbmFlora: TDBMemo
        Left = 90
        Top = 315
        Width = 543
        Height = 100
        DataField = 'INFO_FLORA'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object dbmInformation: TDBMemo
        Left = 90
        Top = 421
        Width = 543
        Height = 90
        DataField = 'INFORMATION'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
    object tshOther: TTabSheet
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      ImageIndex = 3
      object Label23: TLabel
        Left = 3
        Top = 40
        Width = 56
        Height = 13
        Caption = #1057#1084#1077#1078#1077#1089#1090#1074#1072
        FocusControl = dbmNeighbours
      end
      object Label22: TLabel
        Left = 1
        Top = 7
        Width = 73
        Height = 13
        Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
      end
      object Label24: TLabel
        Left = 0
        Top = 146
        Width = 74
        Height = 13
        Caption = #1041#1083#1080#1078#1072#1081#1096#1080#1077' '#1055#1047
        FocusControl = dbmPZ
      end
      object Label25: TLabel
        Left = 3
        Top = 252
        Width = 52
        Height = 26
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#13#10#1086#1090#1074#1086#1076#1072
        FocusControl = dbmDescr
      end
      object Label30: TLabel
        Left = 3
        Top = 355
        Width = 347
        Height = 13
        Caption = #1050#1072#1076#1072#1089#1090#1088#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' '#1079#1077#1084#1077#1083#1100#1085#1086#1075#1086' '#1091#1095#1072#1089#1090#1082#1072' ('#1087#1088#1080#1084#1077#1088': 36:34:05 01 0123)'
      end
      object dbmNeighbours: TDBMemo
        Left = 90
        Top = 37
        Width = 543
        Height = 100
        DataField = 'NEIGHBOURS'
        DataSource = AllotmentsForm.DataSource
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object dbeNomenclatura: TDBEdit
        Left = 90
        Top = 5
        Width = 827
        Height = 21
        Color = clInfoBk
        DataField = 'NOMENCLATURA'
        DataSource = AllotmentsForm.DataSource
        TabOrder = 1
      end
      object btnCalcNomenclatur: TButton
        Left = 923
        Top = 3
        Width = 48
        Height = 23
        Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1091
        Caption = '<<<'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnCalcNomenclaturClick
      end
      object dbmPZ: TDBMemo
        Left = 90
        Top = 143
        Width = 543
        Height = 100
        DataField = 'PZ'
        DataSource = AllotmentsForm.DataSource
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object dbmDescr: TDBMemo
        Left = 90
        Top = 249
        Width = 543
        Height = 100
        DataField = 'DESCRIPTION'
        DataSource = AllotmentsForm.DataSource
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object dbeCadastr: TDBEdit
        Left = 362
        Top = 352
        Width = 197
        Height = 21
        DataField = 'CADASTRE'
        DataSource = AllotmentsForm.DataSource
        TabOrder = 5
      end
      object btnClearCadastre: TButton
        Left = 565
        Top = 352
        Width = 65
        Height = 21
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 6
        OnClick = btnClearCadastreClick
      end
    end
  end
  object btnOk: TButton
    Left = 8
    Top = 550
    Width = 70
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = '&'#1054#1050
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 90
    Top = 550
    Width = 71
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object dbchChecked: TDBCheckBox
    Left = 505
    Top = 553
    Width = 69
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = #1055#1088#1086#1074#1077#1088#1077#1085
    DataField = 'CHECKED'
    DataSource = AllotmentsForm.DataSource
    TabOrder = 5
    ValueChecked = '1'
    ValueUnchecked = '0'
    OnClick = dbchCheckedClick
  end
  object btnChecked: TButton
    Left = 421
    Top = 550
    Width = 71
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = #1055#1088#1086#1074#1077#1088#1077#1085
    TabOrder = 4
    Visible = False
    OnClick = btnCheckedClick
  end
  object btnPrint: TButton
    Left = 173
    Top = 550
    Width = 71
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = #1055#1077#1095#1072#1090#1100
    TabOrder = 3
    OnClick = btnPrintClick
  end
  object ibqOwners: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      
        'SELECT A.ALLOTMENTS_ID, A.ID, A.FIRMS_ID, A.NAME, A.PERCENT, A.P' +
        'URPOSE, A.PROP_FORMS_ID, A.RENT_PERIOD, B.NAME AS PROP_FORMS_NAM' +
        'E, B.NAME_ACC AS PROP_FORMS_NAME_ACC'
      
        'FROM ALLOTMENT_OWNERS A LEFT JOIN PROP_FORMS B ON A.PROP_FORMS_I' +
        'D=B.ID'
      'WHERE A.ALLOTMENTS_ID=:ALLOTMENTS_ID')
    UpdateObject = ibusOwners
    Left = 40
    Top = 216
    ParamData = <
      item
        DataType = ftString
        Name = 'ALLOTMENTS_ID'
        ParamType = ptUnknown
        Value = '3'
      end>
    object ibqOwnersALLOTMENTS_ID: TIntegerField
      FieldName = 'ALLOTMENTS_ID'
      Required = True
    end
    object ibqOwnersID: TSmallintField
      FieldName = 'ID'
      Required = True
    end
    object ibqOwnersFIRMS_ID: TIntegerField
      FieldName = 'FIRMS_ID'
    end
    object ibqOwnersNAME: TIBStringField
      FieldName = 'NAME'
      Required = True
      Size = 120
    end
    object ibqOwnersPERCENT: TFloatField
      FieldName = 'PERCENT'
      Required = True
      DisplayFormat = '##0.##'
    end
    object ibqOwnersPURPOSE: TIBStringField
      FieldName = 'PURPOSE'
      Required = True
      Size = 150
    end
    object ibqOwnersPROP_FORMS_ID: TIntegerField
      FieldName = 'PROP_FORMS_ID'
    end
    object ibqOwnersRENT_PERIOD: TSmallintField
      FieldName = 'RENT_PERIOD'
    end
    object ibqOwnersPROP_FORMS_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'PROP_FORMS_NAME'
      LookupDataSet = ibqPropForms
      LookupKeyFields = 'ID'
      LookupResultField = 'NAME'
      KeyFields = 'PROP_FORMS_ID'
      Size = 30
      Lookup = True
    end
    object ibqOwnersPROP_FORMS_NAME_ACC: TIBStringField
      FieldName = 'PROP_FORMS_NAME_ACC'
      Size = 30
    end
  end
  object dsOwners: TDataSource
    DataSet = ibqOwners
    Left = 40
    Top = 280
  end
  object ibusOwners: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT A.ALLOTMENTS_ID, A.ID, A.FIRMS_ID, A.NAME, A.PERCENT, '
      'A.PURPOSE, A.PROP_FORMS_ID, A.RENT_PERIOD, B.NAME AS '
      'PROP_FORMS_NAME, B.NAME_ACC AS PROP_FORMS_NAME_ACC'
      'FROM ALLOTMENT_OWNERS A LEFT JOIN PROP_FORMS B ON '
      'A.PROP_FORMS_ID=B.ID'
      'WHERE (A.ALLOTMENTS_ID=:ALLOTMENTS_ID) AND (A.ID=:ID)')
    ModifySQL.Strings = (
      'UPDATE ALLOTMENT_OWNERS SET'
      'ALLOTMENTS_ID=:ALLOTMENTS_ID,'
      'ID=:ID,'
      'FIRMS_ID=:FIRMS_ID,'
      'NAME=:NAME,'
      'PERCENT=:PERCENT,'
      'PURPOSE=:PURPOSE,'
      'PROP_FORMS_ID=:PROP_FORMS_ID,'
      'RENT_PERIOD=:RENT_PERIOD'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:OLD_ID)')
    InsertSQL.Strings = (
      'INSERT INTO ALLOTMENT_OWNERS'
      
        '(ALLOTMENTS_ID, ID, FIRMS_ID, NAME, PERCENT, PURPOSE, PROP_FORMS' +
        '_ID, RENT_PERIOD)'
      
        'VALUES (:ALLOTMENTS_ID, :ID, :FIRMS_ID, :NAME, :PERCENT, :PURPOS' +
        'E, :PROP_FORMS_ID, :RENT_PERIOD)')
    DeleteSQL.Strings = (
      'DELETE FROM ALLOTMENT_OWNERS'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:OLD_ID)')
    Left = 40
    Top = 248
  end
  object ibqDocs: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      'SELECT *'
      'FROM ALLOTMENT_DOCS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID'
      'ORDER BY DOC_DATE')
    UpdateObject = ibusDocs
    Left = 352
    Top = 208
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ALLOTMENTS_ID'
        ParamType = ptUnknown
        Value = '607581'
      end>
    object ibqDocsALLOTMENTS_ID: TIntegerField
      FieldName = 'ALLOTMENTS_ID'
      Origin = '"ALLOTMENT_DOCS"."ALLOTMENTS_ID"'
      Required = True
    end
    object ibqDocsID: TSmallintField
      FieldName = 'ID'
      Origin = '"ALLOTMENT_DOCS"."ID"'
      Required = True
    end
    object ibqDocsDECREES_ID: TIntegerField
      FieldName = 'DECREES_ID'
      Origin = '"ALLOTMENT_DOCS"."DECREES_ID"'
      Required = True
    end
    object ibqDocsDOC_NUMBER: TIBStringField
      FieldKind = fkInternalCalc
      FieldName = 'DOC_NUMBER'
      Origin = '"ALLOTMENT_DOCS"."DOC_NUMBER"'
      ReadOnly = True
      Size = 10
    end
    object ibqDocsDOC_DATE: TDateTimeField
      FieldKind = fkInternalCalc
      FieldName = 'DOC_DATE'
      Origin = '"ALLOTMENT_DOCS"."DOC_DATE"'
      ReadOnly = True
    end
    object ibqDocsHEADER: TIBStringField
      FieldKind = fkInternalCalc
      FieldName = 'HEADER'
      Origin = '"ALLOTMENT_DOCS"."HEADER"'
      ReadOnly = True
      Size = 1000
    end
    object ibqDocsDECREE_TYPES_NAME: TIBStringField
      FieldKind = fkInternalCalc
      FieldName = 'DECREE_TYPES_NAME'
      Origin = '"ALLOTMENT_DOCS"."DECREE_TYPES_NAME"'
      ReadOnly = True
      Size = 100
    end
    object ibqDocsDECREE_TYPES_ID: TIntegerField
      FieldKind = fkInternalCalc
      FieldName = 'DECREE_TYPES_ID'
      Origin = '"ALLOTMENT_DOCS"."DECREE_TYPES_ID"'
      ReadOnly = True
    end
  end
  object ibusDocs: TIBUpdateSQL
    RefreshSQL.Strings = (
      'SELECT *'
      'FROM ALLOTMENT_DOCS'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:ID)')
    ModifySQL.Strings = (
      'UPDATE ALLOTMENT_DOCS SET'
      'ALLOTMENTS_ID=:ALLOTMENTS_ID,'
      'ID=:ID,'
      'DECREES_ID=:DECREES_ID'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:OLD_ID)')
    InsertSQL.Strings = (
      'INSERT INTO ALLOTMENT_DOCS'
      '(ALLOTMENTS_ID, ID, DECREES_ID)'
      'VALUES (:ALLOTMENTS_ID, :ID, :DECREES_ID)')
    DeleteSQL.Strings = (
      'DELETE FROM ALLOTMENT_DOCS'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:OLD_ID)')
    Left = 384
    Top = 208
  end
  object dsDocs: TDataSource
    DataSet = ibqDocs
    Left = 416
    Top = 208
  end
  object ibsOwnersNextId: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT MAX(ID) AS MAX_ID'
      'FROM ALLOTMENT_OWNERS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID')
    Transaction = ibtrReports
    Left = 112
    Top = 224
  end
  object ibsOwnersSumPercent: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT SUM(PERCENT) AS SUM_PERCENT'
      'FROM ALLOTMENT_OWNERS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID')
    Transaction = ibtrReports
    Left = 144
    Top = 224
  end
  object ibqDecrees: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      
        'SELECT A.ID, A.DOC_NUMBER, A.DOC_DATE, A.INT_NUMBER, A.INT_DATE,' +
        ' A.HEADER, A.CHECKED, A.CONTENT, A.YEAR_NUMBER, A.DECREE_TYPES_I' +
        'D, B.NAME AS DECREE_TYPES_NAME'
      
        'FROM DECREES A LEFT JOIN DECREE_TYPES B ON A.DECREE_TYPES_ID=B.I' +
        'D'
      'WHERE A.ID=:ID')
    Left = 448
    Top = 208
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ID'
        ParamType = ptUnknown
      end>
  end
  object ibsDocsNextId: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT MAX(ID) AS MAX_ID'
      'FROM ALLOTMENT_DOCS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID')
    Transaction = ibtrReports
    Left = 448
    Top = 264
  end
  object ImageList: TImageList
    Left = 284
    Top = 240
    Bitmap = {
      494C01011900A800780010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000007000000001002000000000000070
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000080000000FFFF000080000000FFFF000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000FFFF0000FFFF000080000000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF00008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF00008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000FFFF0000FFFF000080000000FFFF0000FFFF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000080000000FFFF000080000000FFFF000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FFFF
      0000FF000000FFFF0000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FF0000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFF0000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF0084000000FFFFFF00FF00
      0000FF000000FFFFFF0084000000000000000000000000000000000000000000
      00000000000000000000800000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000800000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFF0000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF0084000000FFFFFF00FF00
      0000FF000000FFFFFF0084000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FFFF0000FFFF
      0000FF000000FFFF0000FFFF0000FF0000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      000000000000FFFF0000000000000000000000000000FF000000FF000000FFFF
      0000FF000000FFFF0000FF000000FF0000000000000000000000FFFFFF008400
      0000FFFFFF00000000000000000084000000FFFFFF0084000000FFFFFF00FF00
      0000FF000000FFFFFF0084000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000FFFF000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF008400
      000084000000840000008400000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000FFFFFF008400
      0000FFFFFF00000000000000000084000000FFFFFF0084000000FFFFFF008400
      0000FFFFFF008400000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF008400
      000084000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      0000FFFF0000FFFF000080000000FFFF0000FFFF0000FFFF0000800000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000FFFFFF008400
      0000FFFFFF000000000000000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFF0000FFFF000080000000FFFF0000FFFF000080000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000FFFF000080000000FFFF00008000000080000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008400
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000FFFF00008400
      0000FFFF000084000000840000000000000000000000FFFFFF00000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      84000084840000848400000000000000000000000000FFFFFF00000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      840000848400008484000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000084000000FFFF0000FFFF00008400
      0000FFFF0000FFFF000084000000000000000000000000FFFF00000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400000000000000000000FFFF00000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      840000848400008484000084840000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000008484008484
      8400008484008400000084000000840000008400000084000000840000008400
      00008400000084000000840000008400000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000084840000848400008484000084
      84000084840000848400008484000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000084840000848400008484000084
      840000848400008484000084840000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000848484000084
      84008484840000848400848484000084840084000000FFFF0000FFFF00008400
      0000FFFF0000FFFF000084000000000000000000000000FFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000008484008484
      8400008484008484840000848400848484008400000084000000FFFF00008400
      0000FFFF000084000000840000000000000000000000FFFFFF0000000000FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00C6C6
      C6000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00C6C6
      C60000000000000000000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000848484000084
      8400848484000084840084848400008484008484840084000000840000008400
      0000840000008400000000000000000000000000000000FFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000FFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C60000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000008484008484
      8400008484008484840000848400848484000084840084848400008484008400
      000000848400848484000000000000000000000000000000000000000000FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF000000000000FF
      000000FF0000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00C6C6
      C6000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000000000000000000848484000084
      8400848484000084840084848400008484008484840000848400848484008400
      000084848400008484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000FF
      000000FF0000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000008484008484
      8400008484008484840000848400848484000084840084848400008484008400
      000000848400848484000000000000000000000000000000000000000000FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C6000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000000000000000000000000000000000FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000848484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000084848400008484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000008400000084000000
      8400000084000000840000008400000000000000000000000000000000000000
      00000000000000FFFF0000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000008484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000008484008484840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000848484000084
      8400848484000000000000FFFF00000000000000000000FFFF00000000000084
      8400848484000084840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C6000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF0000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084840000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000848400008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400840084008400840084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484000084840000848400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000848400008484000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840084008400840084008400840084008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848400008484000084840000848400008484000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000084840000848400008484000084840000848400000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      8400840084008400840084008400840084008400840084008400000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      0000848400008484000084840000848400008484000084840000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000840084008400
      8400840084008400840084008400840084008400840084008400840084000000
      0000000000000000000000000000000000000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000084008400840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400000000000000000000000000000000000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000084840000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000008400840084008400840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084000000000000000000000000008484000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400000000000000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000084008400840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084008400840000000000000000000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084008400840084008400000000000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000000000000000000000000000000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400008484000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084008400840084008400840084000000000000000000000000008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000848400000000000000000000000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400000000000000000000000000000000000000
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000840084008400840084008400840084008400840084008400840084008400
      8400840084008400840084008400000000000000000000000000000000000000
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000000000000000000000000000000000000000
      0000000000000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000008400840084008400840084008400840084008400840084008400
      8400840084008400840000000000000000000000000000000000000000000000
      0000000000008484000084840000848400008484000084840000848400008484
      0000848400008484000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400840084008400840084008400840084008400
      8400840084000000000000000000000000000000000000000000000000000000
      0000000000000000000084840000848400008484000084840000848400008484
      0000848400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840084008400840084008400840084008400
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840084008400840084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000008400000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084000000840000008400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000840000008400000084000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008400000084000000840000008400000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000840000008400000084000000840000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      0000008400000084000000840000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000008400000084
      0000008400000084000000840000008400000084000000840000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084000000FFFF000084000000FFFF000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000000000000000000000000000000000000000000840000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FFFF0000FFFF000084000000FFFF0000FFFF0000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000000000000000000000000084000000840000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000000000000000000000000000000000000000000000000008400
      0000FFFF0000FFFF0000FFFF000084000000FFFF0000FFFF0000FFFF00008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000000000000000000000000000840000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000000000000000000000000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000840000000000000000000000000000000000008400
      0000FFFF0000FFFF0000FFFF000084000000FFFF0000FFFF0000FFFF00008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000000000000000000000000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000840000008400000000000000000000000000000000
      000084000000FFFF0000FFFF000084000000FFFF0000FFFF0000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000000000000000000000000000000000000
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000840000000000000000000000000000000000000000
      00008400000084000000FFFF000084000000FFFF000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000008400000084000000840000008400000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000084000000840000008400000084000000840000008400000084
      0000008400000084000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000008400000084000000840000008400000084
      0000008400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000008400000084000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008400000084000000840000008400000084
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000840000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000840000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000700000000100010000000000800300000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FEC1000000000000
      FEE1000000000000FEC1000000000000FC61000000000000F015000000000000
      F01F000000000000E00F0000000000000001000000000000E00F000000000000
      F01F000000000000501F0000000000000C7F00000000000006FF000000000000
      0EFF00000000000006FF000000000000FFE3FFFFFFE3FFFFFF80FE01FFE3FFFF
      FF80FE01FD80FD80F700FE01FD80FD80F000FE01FD80FD80F7008001F8E3F8FF
      E3808001E023E03F80808001E03FE03F80E38001C01FC01F0077800300030003
      00078007C01FC01F0077800FE03FE03F80FF800FE03FE03F80FF807FF8FFF8FF
      E3FF80FFFDFFFDFFF7FF81FFFDFFFDFF800F800FFC00FFEF00070007FC00FF83
      000300032000FF01000100010000C00100000000000080000000000000008001
      0000000000008001000700070000800100030007000080018003800700008001
      C001C007E0008001C000C001F8008001C000C000F00087E1C001C000E0018001
      FFC3FF81C403C003FFE7FFFFEC07FC3FFDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBFFDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBFFDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBFFFFFFDFFFDFFFDFFFEFFF8FFF8FFF8FF
      FEFFF07FF07FF07FFEFFE03FE03FE03FFC7FC01FC01FC01FF01F800F800F800F
      F01F000700070007E00F8003800380030001C001C001C001E00FE000E000E000
      F01FF001F001F001F01FF803F803F803FC7FFC07FC07FC07FEFFFE0FFE0FFE0F
      FEFFFF1FFF1FFF1FFEFFFFBFFFBFFFBF00000000000000000000000000000000
      000000000000}
  end
  object ibsContoursNew: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      
        'INSERT INTO ALLOTMENT_CONTOURS (ALLOTMENTS_ID, ID, NAME, ENABLED' +
        ', POSITIVE, CLOSED, COLOR)'
      
        'VALUES (:ALLOTMENTS_ID, :ID, :NAME, :ENABLED, :POSITIVE, :CLOSED' +
        ', :COLOR)')
    Transaction = ibtrReports
    Left = 384
    Top = 320
  end
  object ibsContoursUpdate: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'UPDATE ALLOTMENT_CONTOURS SET'
      'ID=:ID,'
      'NAME=:NAME,'
      'ENABLED=:ENABLED,'
      'POSITIVE=:POSITIVE,'
      'CLOSED=:CLOSED,'
      'COLOR=:COLOR'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:OLD_ID)')
    Transaction = ibtrReports
    Left = 416
    Top = 320
  end
  object ibsContoursDel: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'DELETE FROM ALLOTMENT_CONTOURS'
      'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(ID=:ID)')
    Transaction = ibtrReports
    Left = 448
    Top = 320
  end
  object PopupMenu: TPopupMenu
    Images = ImageList
    Left = 148
    Top = 280
    object N1: TMenuItem
      Action = actNew
    end
    object N2: TMenuItem
      Action = actDel
    end
    object N3: TMenuItem
      Action = actEdit
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object acPasteContour1: TMenuItem
      Action = acPasteContour
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Action = acCopyPoints
    end
    object N6: TMenuItem
      Action = acCopyAllPoints
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object N11: TMenuItem
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1074' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083
      OnClick = N11Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object DXF1: TMenuItem
      Action = acExportToDXF
    end
    object N8: TMenuItem
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083
      Visible = False
      OnClick = N8Click
    end
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 224
    Top = 280
    object actNew: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 16
      ShortCut = 45
      OnExecute = actNewExecute
    end
    object actDel: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 17
      ShortCut = 16430
      OnExecute = actDelExecute
    end
    object actEdit: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 18
      ShortCut = 16397
      OnExecute = actEditExecute
    end
    object acPasteContour: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1090#1086#1095#1082#1080' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 19
      OnExecute = acPasteContourExecute
      OnUpdate = acPasteContourUpdate
    end
    object acCopyPoints: TAction
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1090#1086#1095#1082#1080' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 20
      OnExecute = acCopyPointsExecute
      OnUpdate = acCopyPointsUpdate
    end
    object acCopyAllPoints: TAction
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1077#1089#1100' '#1082#1086#1085#1090#1091#1088' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 21
      OnExecute = acCopyAllPointsExecute
      OnUpdate = acCopyAllPointsUpdate
    end
    object acExportToDXF: TAction
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' DXF-'#1092#1072#1081#1083
      OnExecute = acExportToDXFExecute
    end
  end
  object ibsPointsNew: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      
        'INSERT INTO ALLOTMENT_POINTS (ALLOTMENTS_ID, CONTOURS_ID, ID, NA' +
        'ME, X, Y)'
      'VALUES (:ALLOTMENTS_ID, :CONTOURS_ID, :ID, :NAME, :X, :Y)')
    Transaction = ibtrReports
    Left = 384
    Top = 352
  end
  object ibsPointsUpdate: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'UPDATE ALLOTMENT_POINTS SET'
      'NAME=:NAME,'
      'X=:X,'
      'Y=:Y'
      
        'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(CONTOURS_ID=:CONTOURS_ID' +
        ')AND(ID=:ID)')
    Transaction = ibtrReports
    Left = 416
    Top = 352
  end
  object ibsPointsDel: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'DELETE FROM ALLOTMENT_POINTS'
      
        'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(CONTOURS_ID=:CONTOURS_ID' +
        ')AND(ID=:ID)')
    Transaction = ibtrReports
    Left = 448
    Top = 352
  end
  object ibsPointsMaxId: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT MAX(ID) AS MAX_ID'
      'FROM ALLOTMENT_POINTS'
      
        'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(CONTOURS_ID=:CONTOURS_ID' +
        ')')
    Transaction = ibtrReports
    Left = 840
    Top = 544
  end
  object ibqPoints: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      'SELECT * FROM ALLOTMENT_POINTS'
      
        'WHERE (ALLOTMENTS_ID=:ALLOTMENTS_ID)AND(CONTOURS_ID=:CONTOURS_ID' +
        ')'
      'ORDER BY ID')
    Left = 352
    Top = 352
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ALLOTMENTS_ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'CONTOURS_ID'
        ParamType = ptUnknown
      end>
  end
  object ibqAllPoints: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      'SELECT * FROM ALLOTMENT_POINTS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID'
      'ORDER BY CONTOURS_ID, ID')
    Left = 872
    Top = 544
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ALLOTMENTS_ID'
        ParamType = ptUnknown
      end>
  end
  object ibqContours: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      'SELECT *'
      'FROM ALLOTMENT_CONTOURS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID'
      'ORDER BY ID')
    Left = 352
    Top = 320
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ALLOTMENTS_ID'
        ParamType = ptUnknown
      end>
  end
  object ibtrReports: TIBTransaction
    DefaultDatabase = KisAppModule.Database
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 744
    Top = 544
  end
  object ibtReports: TIBTable
    Database = KisAppModule.Database
    Transaction = ibtrReports
    FieldDefs = <
      item
        Name = 'USER_NAME'
        Attributes = [faRequired]
        DataType = ftString
        Size = 22
      end
      item
        Name = 'STRING01'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING02'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING03'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING04'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING05'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING06'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING07'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING08'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING09'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'STRING10'
        DataType = ftString
        Size = 202
      end
      item
        Name = 'MEMO1'
        DataType = ftMemo
      end
      item
        Name = 'MEMO2'
        DataType = ftMemo
      end
      item
        Name = 'MEMO3'
        DataType = ftMemo
      end>
    IndexDefs = <
      item
        Name = 'REPORTS_USER_NAME'
        Fields = 'USER_NAME'
      end>
    IndexFieldNames = 'USER_NAME'
    StoreDefs = True
    TableName = 'REPORTS'
    Left = 776
    Top = 544
    object ibtReportsUSER_NAME: TIBStringField
      FieldName = 'USER_NAME'
      Size = 22
    end
    object ibtReportsSTRING01: TIBStringField
      FieldName = 'STRING01'
      Size = 202
    end
    object ibtReportsSTRING02: TIBStringField
      FieldName = 'STRING02'
      Size = 202
    end
    object ibtReportsSTRING03: TIBStringField
      FieldName = 'STRING03'
      Size = 202
    end
    object ibtReportsSTRING04: TIBStringField
      FieldName = 'STRING04'
      Size = 202
    end
    object ibtReportsSTRING05: TIBStringField
      FieldName = 'STRING05'
      Size = 202
    end
    object ibtReportsSTRING06: TIBStringField
      FieldName = 'STRING06'
      Size = 202
    end
    object ibtReportsSTRING07: TIBStringField
      FieldName = 'STRING07'
      Size = 202
    end
    object ibtReportsSTRING08: TIBStringField
      FieldName = 'STRING08'
      Size = 202
    end
    object ibtReportsSTRING09: TIBStringField
      FieldName = 'STRING09'
      Size = 202
    end
    object ibtReportsSTRING10: TIBStringField
      FieldName = 'STRING10'
      Size = 202
    end
    object ibtReportsMEMO1: TMemoField
      FieldName = 'MEMO1'
      BlobType = ftMemo
      Size = 8
    end
    object ibtReportsMEMO2: TMemoField
      FieldName = 'MEMO2'
      BlobType = ftMemo
      Size = 8
    end
    object ibtReportsMEMO3: TMemoField
      FieldName = 'MEMO3'
      BlobType = ftMemo
      Size = 8
    end
  end
  object dsReports: TDataSource
    AutoEdit = False
    DataSet = ibtReports
    Left = 808
    Top = 544
  end
  object ibsFirms: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT *'
      'FROM FIRMS'
      'WHERE ID=:ID')
    Transaction = ibtrReports
    Left = 176
    Top = 224
  end
  object ibqPropForms: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtrReports
    SQL.Strings = (
      'SELECT * FROM PROP_FORMS'
      'ORDER BY ID')
    Left = 212
    Top = 224
  end
  object ibsDocs: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'SELECT DECREE_TYPES_ID, DECREE_TYPES_NAME, DOC_NUMBER, DOC_DATE'
      'FROM ALLOTMENT_DOCS'
      'WHERE ALLOTMENTS_ID=:ALLOTMENTS_ID'
      'ORDER BY DECREE_TYPES_ID')
    Transaction = ibtrReports
    Left = 480
    Top = 320
  end
  object ibqGetPrintInf: TIBQuery
    Database = KisAppModule.Database
    Transaction = ibtList
    SQL.Strings = (
      'SELECT * FROM ALLOTMENTS_REPORTS_LIST'
      'WHERE ID=:ID')
    Left = 908
    Top = 544
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
  end
  object ibtList: TIBTransaction
    DefaultDatabase = KisAppModule.Database
    Left = 940
    Top = 544
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.dxf'
    Filter = 'AutoCAD dxf-'#1092#1072#1081#1083'|*.dxf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 504
    Top = 208
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.txt'
    Filter = #1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083'|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 504
    Top = 176
  end
  object alPoints: TActionList
    Images = ImageList
    Left = 40
    Top = 344
    object acPointAdd: TAction
      Category = 'Points'
      Caption = #1053#1086#1074#1072#1103' '#1090#1086#1095#1082#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1090#1086#1095#1082#1091
      ImageIndex = 22
      OnExecute = acPointAddExecute
      OnUpdate = acPointAddUpdate
    end
    object acPointDelete: TAction
      Category = 'Points'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1095#1082#1080
      ImageIndex = 23
      OnExecute = acPointDeleteExecute
      OnUpdate = acPointDeleteUpdate
    end
    object acPointEdit: TAction
      Category = 'Points'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1080' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1090#1086#1095#1082#1080
      ImageIndex = 24
      OnExecute = acPointEditExecute
      OnUpdate = acPointEditUpdate
    end
    object acPointCopy: TAction
      Category = 'Points'
      Caption = #1050#1086#1087#1080#1103
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1082#1086#1087#1080#1102' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1090#1086#1095#1082#1080
      ImageIndex = 20
      OnExecute = acPointCopyExecute
      OnUpdate = acPointCopyUpdate
    end
    object acPointNamePlus: TAction
      Category = 'Points'
      Caption = #1053#1086#1084#1077#1088' +'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1086#1084#1077#1088#1072' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1090#1086#1095#1077#1082
      OnExecute = acPointNamePlusExecute
      OnUpdate = acPointNamePlusUpdate
    end
    object acCntAdd: TAction
      Category = 'Contours'
      Caption = #1053#1086#1074#1099#1081' '#1082#1086#1085#1090#1091#1088
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1082#1086#1085#1090#1091#1088
      ImageIndex = 16
      OnExecute = acCntAddExecute
      OnUpdate = acCntAddUpdate
    end
    object acCntEdit: TAction
      Category = 'Contours'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1082#1086#1085#1090#1091#1088#1072
      ImageIndex = 18
      OnExecute = acCntEditExecute
      OnUpdate = acCntEditUpdate
    end
    object acCntDel: TAction
      Category = 'Contours'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1082#1086#1085#1090#1091#1088
      ImageIndex = 17
      OnExecute = acCntDelExecute
      OnUpdate = acCntDelUpdate
    end
  end
  object ilContours: TImageList
    Left = 108
    Top = 392
    Bitmap = {
      494C01010100A8008C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FDFF000000000000F8FF000000000000
      F07F000000000000E03F000000000000C01F000000000000800F000000000000
      00070000000000008003000000000000C001000000000000E000000000000000
      F001000000000000F803000000000000FC07000000000000FE0F000000000000
      FF1F000000000000FFBF00000000000000000000000000000000000000000000
      000000000000}
  end
  object ilContoursDefault: TImageList
    Left = 148
    Top = 392
    Bitmap = {
      494C01011000A800880010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C6000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF0000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084840000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000848400008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400840084008400840084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484000084840000848400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000848400008484000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840084008400840084008400840084008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848400008484000084840000848400008484000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000084840000848400008484000084840000848400000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      8400840084008400840084008400840084008400840084008400000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      0000848400008484000084840000848400008484000084840000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000840084008400
      8400840084008400840084008400840084008400840084008400840084000000
      0000000000000000000000000000000000000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000084008400840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400000000000000000000000000000000000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000084840000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000008400000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000008400840084008400840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084000000000000000000000000008484000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400000000000000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000084008400840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084008400840000000000000000000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000840084008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084008400840084008400000000000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000000000000000000000000000000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400008484000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000008400
      8400840084008400840084008400840084008400840084008400840084008400
      8400840084008400840084008400840084000000000000000000000000008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000848400000000000000000000000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000848400000000000000000000000000000000000000
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000840084008400840084008400840084008400840084008400840084008400
      8400840084008400840084008400000000000000000000000000000000000000
      0000848400008484000084840000848400008484000084840000848400008484
      0000848400008484000084840000000000000000000000000000000000000000
      0000000000000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000008400840084008400840084008400840084008400840084008400
      8400840084008400840000000000000000000000000000000000000000000000
      0000000000008484000084840000848400008484000084840000848400008484
      0000848400008484000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400840084008400840084008400840084008400
      8400840084000000000000000000000000000000000000000000000000000000
      0000000000000000000084840000848400008484000084840000848400008484
      0000848400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840084008400840084008400840084008400
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840084008400840084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000008400000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084000000840000008400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000840000008400000084000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008400000084000000840000008400000084000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000840000008400000084000000840000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      0000008400000084000000840000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000008400000084
      0000008400000084000000840000008400000084000000840000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000000000000000000000000000000000000000000840000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000000000000000000000000084000000840000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000000000000000000000000000840000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000000000000000000000000008400000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000840000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000000000000000000000000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000840000008400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000000000000000000000000000000000000
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000084000000840000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000008400000084000000840000008400000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000084000000840000008400000084000000840000008400000084
      0000008400000084000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000008400000084000000840000008400000084
      0000008400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000008400000084000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008400000084000000840000008400000084
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084000000840000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000840000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBFFDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBFFDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBFFDFFFDFFFDFFFDFFF8FFF8FFF8FFF8FF
      F07FF07FF07FF07FE03FE03FE03FE03FC01FC01FC01FC01F800F800F800F800F
      00070007000700078003800380038003C001C001C001C001E000E000E000E000
      F001F001F001F001F803F803F803F803FC07FC07FC07FC07FE0FFE0FFE0FFE0F
      FF1FFF1FFF1FFF1FFFBFFFBFFFBFFFBF00000000000000000000000000000000
      000000000000}
  end
end
