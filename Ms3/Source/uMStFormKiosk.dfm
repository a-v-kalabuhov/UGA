object mstKioskForm: TmstKioskForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'mstKioskForm'
  ClientHeight = 412
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    620
    412)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 1
    Top = 0
    Width = 620
    Height = 378
    ActivePage = tsCustomer
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsData: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 3
        Top = 74
        Width = 31
        Height = 13
        Caption = #1040#1076#1088#1077#1089
      end
      object Label6: TLabel
        Left = 215
        Top = 32
        Width = 18
        Height = 13
        Caption = #1058#1080#1087
      end
      object Label7: TLabel
        Left = 3
        Top = 116
        Width = 83
        Height = 13
        Caption = #1055#1083#1086#1097#1072#1076#1100', '#1082#1074'. '#1084'.'
      end
      object Label10: TLabel
        Left = 3
        Top = 157
        Width = 124
        Height = 13
        Caption = #1057#1088#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1103', '#1084#1077#1089#1103#1094#1077#1074
      end
      object Label11: TLabel
        Left = 3
        Top = 32
        Width = 30
        Height = 13
        Caption = #1056#1072#1081#1086#1085
      end
      object Label12: TLabel
        Left = 354
        Top = 32
        Width = 66
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      end
      object Label13: TLabel
        Left = 3
        Top = 239
        Width = 49
        Height = 13
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      end
      object Label14: TLabel
        Left = 208
        Top = 239
        Width = 67
        Height = 13
        Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103
      end
      object Label15: TLabel
        Left = 416
        Top = 239
        Width = 118
        Height = 13
        Caption = #1055#1088#1080#1095#1080#1085#1072' '#1072#1085#1091#1083#1080#1088#1086#1074#1072#1085#1080#1103
      end
      object Label16: TLabel
        Left = 3
        Top = 8
        Width = 50
        Height = 16
        Caption = #1057#1090#1072#1090#1091#1089':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lStatus: TLabel
        Left = 61
        Top = 8
        Width = 46
        Height = 16
        Caption = 'lStatus'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label23: TLabel
        Left = 3
        Top = 197
        Width = 83
        Height = 13
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      end
      object edAddress: TDBEdit
        Left = 3
        Top = 89
        Width = 598
        Height = 21
        Color = clInfoBk
        DataField = 'ADDRESS'
        DataSource = DataSource1
        TabOrder = 3
      end
      object GroupBox1: TGroupBox
        Left = 208
        Top = 116
        Width = 130
        Height = 104
        Caption = #1054#1088#1076#1077#1088
        TabOrder = 6
        object Label8: TLabel
          Left = 7
          Top = 15
          Width = 31
          Height = 13
          Caption = #1053#1086#1084#1077#1088
        end
        object Label9: TLabel
          Left = 7
          Top = 56
          Width = 26
          Height = 13
          Caption = #1044#1072#1090#1072
        end
        object edOrderNum: TDBEdit
          Left = 7
          Top = 30
          Width = 114
          Height = 21
          DataField = 'ORDER_NUMBER'
          DataSource = DataSource1
          TabOrder = 0
        end
        object edOrderDate: TDBEdit
          Left = 7
          Top = 71
          Width = 114
          Height = 21
          Color = clInfoBk
          DataField = 'ORDER_DATE'
          DataSource = DataSource1
          TabOrder = 1
        end
      end
      object GroupBox2: TGroupBox
        Left = 347
        Top = 116
        Width = 127
        Height = 104
        Caption = #1055#1080#1089#1100#1084#1086
        TabOrder = 7
        object Label2: TLabel
          Left = 7
          Top = 15
          Width = 31
          Height = 13
          Caption = #1053#1086#1084#1077#1088
        end
        object Label3: TLabel
          Left = 7
          Top = 56
          Width = 26
          Height = 13
          Caption = #1044#1072#1090#1072
        end
        object edLetterNum: TDBEdit
          Left = 7
          Top = 30
          Width = 114
          Height = 21
          DataField = 'LETTER_NUMBER'
          DataSource = DataSource1
          TabOrder = 0
        end
        object edLetterDate: TDBEdit
          Left = 7
          Top = 71
          Width = 114
          Height = 21
          DataField = 'LETTER_DATE'
          DataSource = DataSource1
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 480
        Top = 116
        Width = 126
        Height = 104
        Caption = #1040#1082#1090' '#1087#1088#1080#1105#1084#1082#1080
        TabOrder = 8
        object Label4: TLabel
          Left = 7
          Top = 15
          Width = 31
          Height = 13
          Caption = #1053#1086#1084#1077#1088
        end
        object Label5: TLabel
          Left = 7
          Top = 56
          Width = 26
          Height = 13
          Caption = #1044#1072#1090#1072
        end
        object edActNum: TDBEdit
          Left = 7
          Top = 30
          Width = 114
          Height = 21
          DataField = 'ACT_NUMBER'
          DataSource = DataSource1
          TabOrder = 0
        end
        object edActDate: TDBEdit
          Left = 7
          Top = 71
          Width = 114
          Height = 21
          DataField = 'ACT_DATE'
          DataSource = DataSource1
          TabOrder = 1
        end
      end
      object cbKind: TComboBox
        Left = 215
        Top = 47
        Width = 114
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = #1050#1080#1086#1089#1082
        Items.Strings = (
          #1050#1080#1086#1089#1082
          #1055#1072#1074#1080#1083#1100#1086#1085)
      end
      object edArea: TDBEdit
        Left = 3
        Top = 131
        Width = 124
        Height = 21
        DataField = 'AREA'
        DataSource = DataSource1
        TabOrder = 4
      end
      object edPeriod: TDBEdit
        Left = 3
        Top = 172
        Width = 122
        Height = 21
        DataField = 'PERIOD'
        DataSource = DataSource1
        TabOrder = 5
      end
      object cbRegion: TComboBox
        Left = 3
        Top = 47
        Width = 183
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = #1046#1077#1083#1077#1079#1085#1086#1076#1086#1088#1086#1078#1085#1099#1081
        Items.Strings = (
          #1046#1077#1083#1077#1079#1085#1086#1076#1086#1088#1086#1078#1085#1099#1081
          #1050#1086#1084#1080#1085#1090#1077#1088#1085#1086#1074#1089#1082#1080#1081
          #1051#1077#1074#1086#1073#1077#1088#1077#1078#1085#1099#1081
          #1051#1077#1085#1080#1085#1089#1082#1080#1081
          #1057#1086#1074#1077#1090#1089#1082#1080#1081
          #1062#1077#1085#1090#1088#1072#1083#1100#1085#1099#1081)
      end
      object edExecutor: TDBEdit
        Left = 354
        Top = 47
        Width = 245
        Height = 21
        Color = clInfoBk
        DataField = 'EXECUTOR'
        DataSource = DataSource1
        TabOrder = 2
      end
      object mInfo: TDBMemo
        Left = 3
        Top = 255
        Width = 183
        Height = 89
        DataField = 'INFO'
        DataSource = DataSource1
        TabOrder = 11
      end
      object mLimit: TDBMemo
        Left = 208
        Top = 255
        Width = 185
        Height = 89
        DataField = 'LIMIT'
        DataSource = DataSource1
        TabOrder = 12
      end
      object mAnnulSource: TDBMemo
        Left = 416
        Top = 255
        Width = 185
        Height = 89
        DataField = 'ANNUL_SOURCE'
        DataSource = DataSource1
        TabOrder = 13
      end
      object edAnnulDate: TDBEdit
        Left = 3
        Top = 212
        Width = 124
        Height = 21
        DataField = 'ANNUL_DATE'
        DataSource = DataSource1
        TabOrder = 9
      end
      object Button6: TButton
        Left = 128
        Top = 210
        Width = 75
        Height = 25
        Caption = #1055#1086#1089#1095#1080#1090#1072#1090#1100
        TabOrder = 10
        OnClick = Button6Click
      end
    end
    object tsCustomer: TTabSheet
      Caption = #1047#1072#1082#1072#1079#1095#1080#1082
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label22: TLabel
        Left = 3
        Top = 16
        Width = 18
        Height = 13
        Caption = #1058#1080#1087
      end
      object gbCommon: TGroupBox
        Left = 0
        Top = 40
        Width = 609
        Height = 161
        Caption = #1054#1073#1097#1080#1077' '#1089#1074#1077#1076#1077#1085#1080#1103
        TabOrder = 1
        object lName: TLabel
          Left = 16
          Top = 24
          Width = 93
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' / '#1060'.'#1048'.'#1054'.'
          FocusControl = edCustName
        end
        object lAddress1: TLabel
          Left = 6
          Top = 51
          Width = 103
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1076#1088#1077#1089' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081
        end
        object lAddress2: TLabel
          Left = 8
          Top = 78
          Width = 101
          Height = 13
          Alignment = taRightJustify
          Caption = #1040#1076#1088#1077#1089' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081
        end
        object lINN: TLabel
          Left = 87
          Top = 104
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Caption = #1048#1053#1053
          FocusControl = edCustINN
        end
        object lPhones: TLabel
          Left = 56
          Top = 129
          Width = 52
          Height = 13
          Alignment = taRightJustify
          Caption = #1058#1077#1083#1077#1092#1086#1085#1099
          FocusControl = edCustPhone
        end
        object edCustName: TDBEdit
          Left = 115
          Top = 21
          Width = 478
          Height = 21
          Color = clInfoBk
          DataField = 'CUSTOMER_NAME'
          DataSource = DataSource1
          MaxLength = 500
          TabOrder = 0
        end
        object edCustAddr1: TDBEdit
          Left = 115
          Top = 48
          Width = 478
          Height = 21
          Color = clInfoBk
          DataField = 'CUSTOMER_ADDRESS_1'
          DataSource = DataSource1
          MaxLength = 120
          TabOrder = 1
        end
        object edCustAddr2: TDBEdit
          Left = 115
          Top = 75
          Width = 478
          Height = 21
          DataField = 'CUSTOMER_ADDRESS_2'
          DataSource = DataSource1
          MaxLength = 120
          TabOrder = 2
        end
        object edCustINN: TDBEdit
          Left = 115
          Top = 102
          Width = 90
          Height = 21
          DataField = 'CUSTOMER_INN'
          DataSource = DataSource1
          TabOrder = 3
        end
        object edCustPhone: TDBEdit
          Left = 114
          Top = 129
          Width = 140
          Height = 21
          DataField = 'CUSTOMER_PHONE'
          DataSource = DataSource1
          MaxLength = 30
          TabOrder = 4
        end
      end
      object gbPersonDoc: TGroupBox
        Left = 0
        Top = 215
        Width = 569
        Height = 100
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090', '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1103#1102#1097#1080#1081' '#1083#1080#1095#1085#1086#1089#1090#1100
        TabOrder = 2
        object Label17: TLabel
          Left = 15
          Top = 15
          Width = 76
          Height = 13
          Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          FocusControl = cbCustDocType
        end
        object Label18: TLabel
          Left = 323
          Top = 15
          Width = 31
          Height = 13
          Caption = #1053#1086#1084#1077#1088
          FocusControl = edCustDocNumber
        end
        object Label19: TLabel
          Left = 198
          Top = 15
          Width = 31
          Height = 13
          Caption = #1057#1077#1088#1080#1103
          FocusControl = edCustDocSerie
        end
        object Label20: TLabel
          Left = 447
          Top = 15
          Width = 67
          Height = 13
          Caption = #1050#1086#1075#1076#1072' '#1074#1099#1076#1072#1085
        end
        object Label21: TLabel
          Left = 15
          Top = 56
          Width = 55
          Height = 13
          Caption = #1050#1077#1084' '#1074#1099#1076#1072#1085
        end
        object cbCustDocType: TComboBox
          Left = 15
          Top = 30
          Width = 177
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            #1087#1072#1089#1087#1086#1088#1090
            #1074#1086#1077#1085#1085#1099#1081' '#1073#1080#1083#1077#1090)
        end
        object edCustDocNumber: TDBEdit
          Left = 323
          Top = 30
          Width = 112
          Height = 21
          DataField = 'CUSTOMER_DOC_NUMBER'
          DataSource = DataSource1
          MaxLength = 10
          TabOrder = 2
        end
        object edCustDocSerie: TDBEdit
          Left = 198
          Top = 30
          Width = 112
          Height = 21
          DataField = 'CUSTOMER_DOC_SERIE'
          DataSource = DataSource1
          MaxLength = 10
          TabOrder = 1
        end
        object edCustDocOwner: TDBEdit
          Left = 15
          Top = 70
          Width = 546
          Height = 21
          DataField = 'CUSTOMER_DOC_OWNER'
          DataSource = DataSource1
          TabOrder = 4
        end
        object edCustDocDate: TDBEdit
          Left = 447
          Top = 30
          Width = 114
          Height = 21
          DataField = 'CUSTOMER_DOC_DATE'
          DataSource = DataSource1
          TabOrder = 3
        end
      end
      object cbCustomerKind: TComboBox
        Left = 40
        Top = 13
        Width = 212
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = #1048#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081' '#1087#1088#1077#1076#1087#1088#1080#1085#1080#1084#1072#1090#1077#1083#1100
        Items.Strings = (
          #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
          #1048#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081' '#1087#1088#1077#1076#1087#1088#1080#1085#1080#1084#1072#1090#1077#1083#1100
          #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086)
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvPoints: TListView
        Left = 3
        Top = 3
        Width = 430
        Height = 334
        Columns = <
          item
            Caption = #8470
            Width = 70
          end
          item
            Caption = 'X'
            Width = 150
          end
          item
            Caption = 'Y'
            Width = 150
          end>
        SmallImages = ImageList1
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Button3: TButton
        Left = 439
        Top = 83
        Width = 170
        Height = 25
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 439
        Top = 2
        Width = 170
        Height = 25
        Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
        TabOrder = 2
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 439
        Top = 33
        Width = 170
        Height = 25
        Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
        TabOrder = 3
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1060#1086#1090#1086
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        612
        350)
      object Button1: TButton
        Left = 485
        Top = 3
        Width = 125
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 485
        Top = 34
        Width = 125
        Height = 25
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 1
        OnClick = Button2Click
      end
      object Panel1: TPanel
        Left = 3
        Top = 3
        Width = 478
        Height = 344
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvRaised
        TabOrder = 2
        object Image1: TImage
          Left = 2
          Top = 2
          Width = 474
          Height = 340
          Align = alClient
          Center = True
          Stretch = True
          ExplicitLeft = -2
          ExplicitTop = 0
          ExplicitWidth = 478
          ExplicitHeight = 344
        end
      end
    end
  end
  object btnOK: TButton
    Left = 456
    Top = 384
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 537
    Top = 384
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object btnAnnul: TButton
    Left = 8
    Top = 384
    Width = 103
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1040#1085#1085#1091#1083#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 3
    OnClick = btnAnnulClick
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 568
  end
  object ImageList1: TImageList
    Left = 536
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FEFF000000000000
      FEFF000000000000FEFF000000000000FC7F000000000000F01F000000000000
      F01F000000000000E00F0000000000000001000000000000E00F000000000000
      F01F000000000000F01F000000000000FC7F000000000000FEFF000000000000
      FEFF000000000000FEFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object DataSource1: TDataSource
    DataSet = mstKioskListForm.qKiosk
    Left = 200
    Top = 376
  end
end
