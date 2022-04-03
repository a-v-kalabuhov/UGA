inherited KisOutcomingLetterEditor: TKisOutcomingLetterEditor
  Left = 206
  Top = 349
  Caption = 'KisOutcomingLetterEditor'
  ClientHeight = 441
  ClientWidth = 489
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 495
  ExplicitHeight = 473
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 39
    Top = 408
    ExplicitLeft = 39
    ExplicitTop = 408
  end
  inherited btnOk: TButton
    Left = 325
    Top = 408
    ExplicitLeft = 325
    ExplicitTop = 408
  end
  inherited btnCancel: TButton
    Left = 406
    Top = 408
    Default = True
    ExplicitLeft = 406
    ExplicitTop = 408
  end
  object PageControl1: TPageControl [3]
    Left = 0
    Top = 0
    Width = 489
    Height = 402
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1048#1089#1093#1086#1076#1103#1097#1077#1077' '#1087#1080#1089#1100#1084#1086
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 4
        Top = 8
        Width = 56
        Height = 13
        Caption = #1058#1080#1087' '#1087#1080#1089#1100#1084#1072
      end
      object Label2: TLabel
        Left = 283
        Top = 40
        Width = 49
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1052#1055
      end
      object Label3: TLabel
        Left = 4
        Top = 40
        Width = 93
        Height = 13
        Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      end
      object Label4: TLabel
        Left = 4
        Top = 208
        Width = 64
        Height = 13
        Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
      end
      object Label5: TLabel
        Left = 8
        Top = 349
        Width = 153
        Height = 13
        Caption = #1044#1072#1090#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
      end
      object Label6: TLabel
        Left = 4
        Top = 129
        Width = 99
        Height = 13
        Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100' '#1087#1080#1089#1100#1084#1072
      end
      object Label7: TLabel
        Left = 4
        Top = 70
        Width = 103
        Height = 13
        Caption = #1054#1090#1076#1077#1083'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
      end
      object Label8: TLabel
        Left = 4
        Top = 99
        Width = 66
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
      end
      object Label9: TLabel
        Left = 283
        Top = 8
        Width = 50
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1087'/'#1087
      end
      object Label10: TLabel
        Left = 4
        Top = 189
        Width = 93
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      end
      object cbKind: TComboBox
        Left = 109
        Top = 8
        Width = 136
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          #1086#1090#1074#1077#1090' '#1085#1072' '#1078#1072#1083#1086#1073#1091
          #1086#1090#1074#1077#1090' '#1087#1086' '#1079#1072#1103#1074#1082#1077
          #1079#1072#1087#1088#1086#1089
          #1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
          #1087#1080#1089#1100#1084#1086' ('#1087#1088#1086#1089#1090#1086#1081' '#1090#1080#1087')')
      end
      object edNumber: TEdit
        Left = 343
        Top = 37
        Width = 134
        Height = 21
        Color = clInfoBk
        MaxLength = 20
        TabOrder = 3
      end
      object edDateReg: TEdit
        Left = 109
        Top = 37
        Width = 136
        Height = 21
        Color = clInfoBk
        TabOrder = 2
        OnKeyPress = edDateRegKeyPress
      end
      object mContent: TMemo
        Left = 2
        Top = 223
        Width = 477
        Height = 97
        Lines.Strings = (
          'mContent')
        ScrollBars = ssVertical
        TabOrder = 8
      end
      object cbNotification: TCheckBox
        Left = 8
        Top = 327
        Width = 149
        Height = 16
        Caption = #1055#1080#1089#1100#1084#1086' '#1089' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077#1084
        TabOrder = 9
      end
      object cbDelivered: TCheckBox
        Left = 327
        Top = 327
        Width = 149
        Height = 16
        Caption = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1087#1086#1083#1091#1095#1077#1085#1086
        TabOrder = 10
      end
      object edDeliveredDate: TEdit
        Left = 169
        Top = 347
        Width = 135
        Height = 21
        TabOrder = 11
        OnKeyPress = edDeliveredDateKeyPress
      end
      object cbOffice: TComboBox
        Left = 109
        Top = 67
        Width = 370
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        TabOrder = 4
      end
      object cbPeople: TComboBox
        Left = 109
        Top = 96
        Width = 370
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        TabOrder = 5
      end
      object edFirm: TEdit
        Left = 109
        Top = 126
        Width = 370
        Height = 21
        Color = clInfoBk
        MaxLength = 300
        TabOrder = 6
        Text = 'edFirm'
        OnKeyUp = edFirmKeyUp
      end
      object btnSelectFirm: TButton
        Left = 109
        Top = 154
        Width = 71
        Height = 23
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 12
        TabStop = False
      end
      object btnFirmClear: TButton
        Left = 186
        Top = 154
        Width = 69
        Height = 23
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 13
        TabStop = False
      end
      object edSeqNumber: TEdit
        Left = 343
        Top = 8
        Width = 134
        Height = 21
        Color = clInfoBk
        MaxLength = 20
        TabOrder = 1
      end
      object edAddress: TEdit
        Left = 109
        Top = 186
        Width = 370
        Height = 21
        Color = clHighlightText
        TabOrder = 7
        Text = 'edAddress'
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099'-'#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgLetterSupplement: TDBGrid
        Left = 0
        Top = 0
        Width = 395
        Height = 374
        Align = alLeft
        DataSource = dsLetterSupplement
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = dbgLetterSupplementExit
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'OUTCOMING_LETTER_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'KIND'
            Title.Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_PRODUCER_NAME'
            Title.Caption = #1057#1086#1079#1076#1072#1090#1077#1083#1100' '#1087#1080#1089#1100#1084#1072
            Width = 105
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088
            Width = 78
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 96
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CONTENT'
            Title.Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
            Width = 121
            Visible = True
          end>
      end
      object btnSupplemCreate: TButton
        Left = 404
        Top = 8
        Width = 68
        Height = 23
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnSupplemCreateClick
      end
      object btnSupplemDelete: TButton
        Left = 404
        Top = 37
        Width = 68
        Height = 23
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
        OnClick = btnSupplemDeleteClick
      end
      object btnSupplemEdit: TButton
        Left = 404
        Top = 67
        Width = 68
        Height = 23
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 3
        OnClick = btnSupplemEditClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1042#1093#1086#1076#1103#1097#1080#1077' '#1087#1080#1089#1100#1084#1072
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgLettersLink: TDBGrid
        Left = 0
        Top = 0
        Width = 395
        Height = 374
        Align = alLeft
        DataSource = dsLettersLink
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = dbgLettersLinkExit
        Columns = <
          item
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
            FieldName = 'DOC_DATE'
            Title.Caption = #1044#1072#1090#1072
            Width = 83
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MP_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088' '#1052#1055
            Width = 102
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 135
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MP_DATE'
            Title.Caption = #1044#1072#1090#1072
            Width = 82
            Visible = True
          end>
      end
      object btnLinkSelect: TButton
        Left = 404
        Top = 8
        Width = 68
        Height = 23
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnLinkSelectClick
      end
      object btnLinkDelete: TButton
        Left = 404
        Top = 37
        Width = 68
        Height = 23
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
        OnClick = btnLinkDeleteClick
      end
      object btnLinkDetail: TButton
        Left = 404
        Top = 67
        Width = 68
        Height = 23
        Caption = #1055#1086#1076#1088#1086#1073#1085#1086
        TabOrder = 3
      end
    end
  end
  object dsLetterSupplement: TDataSource
    Left = 148
    Top = 57
  end
  object dsLettersLink: TDataSource
    Left = 180
    Top = 57
  end
end
