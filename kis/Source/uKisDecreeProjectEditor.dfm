inherited KisDecreeProjectEditor: TKisDecreeProjectEditor
  Left = 311
  Top = 105
  Caption = 'KisDecreeProjectEditor'
  ClientHeight = 464
  ClientWidth = 506
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitTop = -11
  ExplicitWidth = 512
  ExplicitHeight = 496
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 37
    Top = 443
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 37
    ExplicitTop = 443
  end
  inherited btnOk: TButton
    Left = 342
    Top = 431
    Anchors = [akRight, akBottom]
    ExplicitLeft = 342
    ExplicitTop = 431
  end
  inherited btnCancel: TButton
    Left = 423
    Top = 431
    Anchors = [akRight, akBottom]
    Default = True
    ExplicitLeft = 423
    ExplicitTop = 431
  end
  object PageControl1: TPageControl [3]
    Left = 0
    Top = 0
    Width = 506
    Height = 424
    ActivePage = tshDecreePrj
    Align = alTop
    TabOrder = 2
    object tshDecreePrj: TTabSheet
      Caption = #1055#1088#1086#1077#1082#1090' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 7
        Top = 75
        Width = 133
        Height = 13
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
      end
      object Label2: TLabel
        Left = 104
        Top = 1
        Width = 33
        Height = 13
        Caption = #1054#1090#1076#1077#1083
      end
      object Label3: TLabel
        Left = 104
        Top = 38
        Width = 66
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      end
      object Label4: TLabel
        Left = 7
        Top = 0
        Width = 31
        Height = 13
        Caption = #1053#1086#1084#1077#1088
      end
      object cbOffice: TComboBox
        Left = 104
        Top = 15
        Width = 387
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 0
        TabOrder = 1
      end
      object cbExecutor: TComboBox
        Left = 104
        Top = 52
        Width = 387
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 0
        TabOrder = 2
      end
      object GroupBox3: TGroupBox
        Left = 7
        Top = 208
        Width = 484
        Height = 187
        Caption = #1042#1080#1079#1099
        TabOrder = 3
        object dbgVisas: TkaDBGrid
          Left = 2
          Top = 15
          Width = 480
          Height = 135
          Align = alTop
          DataSource = dsVisas
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = dbgVisasExit
          Columns = <
            item
              DropDownRows = 10
              Expanded = False
              FieldName = 'PRJ_STATE_ID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'PRJ_STATE'
              PickList.Strings = (
                '')
              Title.Caption = #1043#1076#1077' '#1085#1072#1093#1086#1076#1080#1090#1089#1103
              Width = 351
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IN_DATE'
              Title.Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080
              Width = 94
              Visible = True
            end>
        end
        object btnVisaCreate: TButton
          Left = 7
          Top = 156
          Width = 68
          Height = 23
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnVisaCreateClick
        end
        object btnVisaDelete: TButton
          Left = 89
          Top = 156
          Width = 68
          Height = 23
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnVisaDeleteClick
        end
      end
      object GroupBox4: TGroupBox
        Left = 7
        Top = 141
        Width = 484
        Height = 68
        Caption = #1047#1072#1103#1074#1082#1072
        TabOrder = 4
        object Label6: TLabel
          Left = 7
          Top = 18
          Width = 141
          Height = 13
          Caption = #8470' '#1079#1072#1103#1074#1082#1080' '#1074' '#1082#1072#1085#1094#1077#1083#1103#1088#1080#1080' '#1052#1055
        end
        object Label7: TLabel
          Left = 282
          Top = 12
          Width = 78
          Height = 26
          Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080' '#1074' '#13#10#1082#1072#1085#1094#1077#1083#1103#1088#1080#1080' '#1052#1055
        end
        object edNumberMP: TEdit
          Left = 157
          Top = 15
          Width = 113
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 0
          Text = 'edNumberMP'
        end
        object edDateMP: TEdit
          Left = 364
          Top = 15
          Width = 112
          Height = 21
          Color = clInfoBk
          ReadOnly = True
          TabOrder = 1
          Text = 'edDateMP'
        end
        object btnSelectLetter: TButton
          Left = 7
          Top = 37
          Width = 98
          Height = 23
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1080#1089#1100#1084#1086
          TabOrder = 2
        end
      end
      object edSeqNumber: TEdit
        Left = 7
        Top = 15
        Width = 91
        Height = 21
        Color = clInfoBk
        TabOrder = 0
        Text = 'edSeqNumber'
      end
      object edHeader: TMemo
        Left = 7
        Top = 89
        Width = 484
        Height = 53
        Color = clInfoBk
        Lines.Strings = (
          'edHeader')
        TabOrder = 5
      end
    end
    object tshAddresses: TTabSheet
      Caption = #1040#1076#1088#1077#1089#1072
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 498
        Height = 193
        Align = alTop
        Caption = #1040#1076#1088#1077#1089#1072' '#1087#1088#1086#1077#1082#1090#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
        TabOrder = 0
        object btnNewAddress: TSpeedButton
          Left = 7
          Top = 166
          Width = 63
          Height = 21
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          OnClick = btnNewAddressClick
        end
        object btnDelAddress: TSpeedButton
          Left = 82
          Top = 166
          Width = 62
          Height = 21
          Caption = #1059#1076#1072#1083#1080#1090#1100
          OnClick = btnDelAddressClick
        end
        object btnEditAddress: TSpeedButton
          Left = 156
          Top = 166
          Width = 62
          Height = 21
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          OnClick = btnEditAddressClick
        end
        object dbgDecreeAddresses: TkaDBGrid
          Left = 2
          Top = 15
          Width = 494
          Height = 146
          Align = alTop
          DataSource = dsDecreeAddresses
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'ADDRESS'
              Title.Caption = #1040#1076#1088#1077#1089
              Width = 506
              Visible = True
            end>
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 193
        Width = 498
        Height = 203
        Align = alClient
        Caption = #1040#1076#1088#1077#1089#1072' '#1074#1093#1086#1076#1103#1097#1077#1075#1086' '#1087#1080#1089#1100#1084#1072
        TabOrder = 1
        object dbgLetterAddresses: TkaDBGrid
          Left = 2
          Top = 15
          Width = 494
          Height = 186
          Align = alClient
          DataSource = dsLetterAddresses
          Enabled = False
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'ADDRESS'
              Title.Caption = #1040#1076#1088#1077#1089
              Width = 510
              Visible = True
            end>
        end
      end
    end
    object tsDecree: TTabSheet
      Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 75
        Top = 8
        Width = 26
        Height = 13
        Caption = '&'#1044#1072#1090#1072
        FocusControl = edDate
      end
      object Label8: TLabel
        Left = 8
        Top = 8
        Width = 31
        Height = 13
        Caption = '&'#1053#1086#1084#1077#1088
        FocusControl = edNumber
      end
      object Label9: TLabel
        Left = 8
        Top = 151
        Width = 64
        Height = 13
        Caption = '&'#1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
      end
      object Label10: TLabel
        Left = 211
        Top = 8
        Width = 44
        Height = 13
        Caption = #1042'&'#1093'. '#1076#1072#1090#1072
        FocusControl = edInt_Date
      end
      object Label11: TLabel
        Left = 143
        Top = 8
        Width = 49
        Height = 13
        Caption = '&'#1042#1093'. '#1085#1086#1084#1077#1088
        FocusControl = edInt_Number
      end
      object Label12: TLabel
        Left = 8
        Top = 83
        Width = 53
        Height = 13
        Caption = '&'#1047#1072#1075#1086#1083#1086#1074#1086#1082
      end
      object Label13: TLabel
        Left = 8
        Top = 45
        Width = 45
        Height = 13
        Caption = #1058'&'#1080#1087' '#1072#1082#1090#1072
      end
      object edDecreeTypes: TEdit
        Left = 8
        Top = 60
        Width = 481
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object edDate: TEdit
        Left = 75
        Top = 23
        Width = 61
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object edNumber: TEdit
        Left = 8
        Top = 23
        Width = 61
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
      object edInt_Date: TEdit
        Left = 211
        Top = 23
        Width = 61
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object edInt_Number: TEdit
        Left = 143
        Top = 23
        Width = 61
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object mHeader: TMemo
        Left = 8
        Top = 98
        Width = 481
        Height = 46
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 5
      end
      object mContent: TMemo
        Left = 8
        Top = 166
        Width = 481
        Height = 219
        Color = clBtnFace
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 6
      end
      object btnSelectDecree: TButton
        Left = 414
        Top = 16
        Width = 75
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 7
      end
    end
    object tsDesc: TTabSheet
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label14: TLabel
        Left = 8
        Top = 16
        Width = 61
        Height = 13
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
      object memoDesc: TMemo
        Left = 8
        Top = 32
        Width = 481
        Height = 257
        Enabled = False
        TabOrder = 0
      end
    end
  end
  object dsDecreeAddresses: TDataSource
    Left = 324
    Top = 409
  end
  object dsLetterAddresses: TDataSource
    Left = 356
    Top = 410
  end
  object dsVisas: TDataSource
    Left = 388
    Top = 409
  end
  object PrintDialog: TPrintDialog
    Left = 120
    Top = 216
  end
  object PrintDialog1: TPrintDialog
    Left = 120
    Top = 216
  end
end
