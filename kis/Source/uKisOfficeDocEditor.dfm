inherited KisOfficeDocEditor: TKisOfficeDocEditor
  Left = 139
  Top = 105
  Caption = ''
  ClientHeight = 557
  ClientWidth = 597
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 603
  ExplicitHeight = 585
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 76
    Top = 533
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 76
    ExplicitTop = 533
  end
  inherited btnOk: TButton
    Left = 431
    Top = 527
    Anchors = [akRight, akBottom]
    ExplicitLeft = 431
    ExplicitTop = 527
  end
  inherited btnCancel: TButton
    Left = 512
    Top = 527
    Anchors = [akRight, akBottom]
    Default = True
    ExplicitLeft = 512
    ExplicitTop = 527
  end
  object PageControl: TPageControl [3]
    Left = 0
    Top = 0
    Width = 597
    Height = 521
    ActivePage = tsMain
    Align = alTop
    TabOrder = 2
    object tsMain: TTabSheet
      Caption = #1043#1083#1072#1074#1085#1072#1103
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 152
        Top = 7
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080'&'#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        FocusControl = cbDocTypes
      end
      object Label1: TLabel
        Left = 8
        Top = 266
        Width = 63
        Height = 13
        Caption = #1048#1085'&'#1092#1086#1088#1084#1072#1094#1080#1103
        FocusControl = mInformation
      end
      object Label2: TLabel
        Left = 78
        Top = 7
        Width = 26
        Height = 13
        Caption = '&'#1044#1072#1090#1072
        FocusControl = edDocDate
      end
      object Label11: TLabel
        Left = 8
        Top = 7
        Width = 31
        Height = 13
        Caption = '&'#1053#1086#1084#1077#1088
        FocusControl = edDocNumber
      end
      object Label7: TLabel
        Left = 8
        Top = 48
        Width = 77
        Height = 13
        Caption = #1040#1076#1088#1077#1089' '#1086#1073#1098#1077#1082#1090#1072
      end
      object Label3: TLabel
        Left = 400
        Top = 128
        Width = 54
        Height = 13
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
      end
      object lEndDate: TLabel
        Left = 400
        Top = 184
        Width = 90
        Height = 13
        Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103
      end
      object cbDocTypes: TComboBox
        Left = 152
        Top = 22
        Width = 433
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 0
        TabOrder = 0
      end
      object edDocDate: TEdit
        Left = 78
        Top = 22
        Width = 69
        Height = 21
        Color = clInfoBk
        TabOrder = 1
      end
      object edDocNumber: TEdit
        Left = 8
        Top = 22
        Width = 65
        Height = 21
        Color = clInfoBk
        MaxLength = 5
        TabOrder = 2
        OnKeyPress = edDocNumberKeyPress
      end
      object mInformation: TMemo
        Left = 8
        Top = 280
        Width = 577
        Height = 68
        TabOrder = 3
      end
      object gbExecutors: TGroupBox
        Left = 8
        Top = 125
        Width = 377
        Height = 140
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1080
        TabOrder = 4
        object btnAddExecutor: TSpeedButton
          Left = 299
          Top = 13
          Width = 68
          Height = 23
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          OnClick = btnAddExecutorClick
        end
        object btnDeleteExecutor: TSpeedButton
          Left = 301
          Top = 42
          Width = 68
          Height = 23
          Caption = #1059#1076#1072#1083#1080#1090#1100
          OnClick = btnDeleteExecutorClick
        end
        object dbgExecutors: TkaDBGrid
          Left = 2
          Top = 15
          Width = 291
          Height = 123
          Align = alLeft
          Color = clInfoBk
          DataSource = dsExecutors
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnExit = dbgExecutorsExit
          Columns = <
            item
              Expanded = False
              FieldName = 'PEOPLE_NAME'
              Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
              Width = 180
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'RECEIVE_DATE'
              Title.Caption = #1055#1077#1088#1077#1076#1072#1085#1086
              Visible = True
            end>
        end
      end
      object gbIncoming: TGroupBox
        Left = 8
        Top = 352
        Width = 577
        Height = 137
        Caption = #1042#1093#1086#1076#1103#1097#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
        TabOrder = 5
        object btnLetterShow: TSpeedButton
          Left = 501
          Top = 66
          Width = 68
          Height = 23
          Caption = #1055#1086#1076#1088#1086#1073#1085#1086
        end
        object btnLetterDel: TSpeedButton
          Left = 501
          Top = 42
          Width = 68
          Height = 23
          Caption = #1059#1076#1072#1083#1080#1090#1100
          OnClick = btnLetterDelClick
        end
        object btnLetterNew: TSpeedButton
          Left = 501
          Top = 18
          Width = 68
          Height = 23
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          OnClick = btnLetterNewClick
        end
        object dbgLetters: TDBGrid
          Left = 2
          Top = 15
          Width = 490
          Height = 120
          Align = alLeft
          DataSource = dsLetters
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
              FieldName = 'DOC_NUMBER'
              Title.Caption = #1053#1086#1084#1077#1088
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DOC_DATE'
              Title.Caption = #1044#1072#1090#1072
              Width = 65
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FIRM_NAME'
              Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
              Width = 281
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MP_DATE'
              Title.Caption = #1044#1072#1090#1072' '#1052#1055
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MP_NUMBER'
              Title.Caption = #1053#1086#1084#1077#1088' '#1052#1055
              Visible = True
            end>
        end
      end
      object edObjectAddress: TEdit
        Left = 8
        Top = 64
        Width = 577
        Height = 21
        Color = clInfoBk
        MaxLength = 120
        TabOrder = 6
        Text = 'edObjectAddress'
      end
      object cbStatus: TComboBox
        Left = 398
        Top = 146
        Width = 187
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 7
        Text = #1042' '#1088#1072#1073#1086#1090#1077
        OnChange = cbStatusChange
        Items.Strings = (
          #1042' '#1088#1072#1073#1086#1090#1077
          #1042#1099#1087#1086#1083#1085#1077#1085#1072
          #1040#1085#1085#1091#1083#1080#1088#1086#1074#1072#1085#1072)
      end
      object cbObjectType: TComboBox
        Left = 8
        Top = 96
        Width = 577
        Height = 21
        Style = csDropDownList
        Color = clInfoBk
        ItemHeight = 0
        TabOrder = 8
      end
      object edEndDate: TEdit
        Left = 400
        Top = 200
        Width = 73
        Height = 21
        Color = clInfoBk
        TabOrder = 9
        Text = 'edEndDate'
      end
    end
    object tsProgress: TTabSheet
      Caption = #1061#1086#1076' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgPhases: TkaDBGrid
        Left = 0
        Top = 0
        Width = 489
        Height = 489
        DataSource = dsPhases
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnExit = dbgPhasesExit
        OnCellColors = dbgPhasesCellColors
        Columns = <
          item
            Expanded = False
            FieldName = 'PHASE_NAME'
            Title.Caption = #1069#1090#1072#1087
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BEGIN_DATE'
            Title.Caption = #1053#1072#1095#1072#1090
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'END_DATE'
            Title.Caption = #1047#1072#1082#1086#1085#1095#1077#1085
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Width = 80
            Visible = True
          end>
      end
      object btnPhaseAdd: TButton
        Left = 496
        Top = 8
        Width = 89
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
        OnClick = btnPhaseAddClick
      end
      object btnPhaseDelete: TButton
        Left = 496
        Top = 72
        Width = 89
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
      end
      object btnPhaseEdit: TButton
        Left = 496
        Top = 40
        Width = 89
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 3
      end
    end
    object tsOrders: TTabSheet
      Caption = #1047#1072#1082#1072#1079#1099
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgOrders: TkaDBGrid
        Left = 0
        Top = 0
        Width = 489
        Height = 441
        DataSource = dsOrders
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
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
            FieldName = 'ORDER_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ORDER_DATE'
            Title.Caption = #1044#1072#1090#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072
            Width = 73
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOC_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1089#1095#1077#1090#1072
            Width = 73
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ACT_DATE'
            Title.Caption = #1044#1072#1090#1072' '#1072#1082#1090#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EXECUTOR'
            Title.Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Visible = True
          end>
      end
      object btnOrderCreate: TButton
        Left = 496
        Top = 8
        Width = 89
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 1
      end
      object btnOrderEdit: TButton
        Left = 496
        Top = 40
        Width = 89
        Height = 25
        Caption = #1055#1086#1076#1088#1086#1073#1085#1086
        TabOrder = 2
      end
      object btnOrderDelete: TButton
        Left = 496
        Top = 72
        Width = 89
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 3
      end
      object btnOrderPrint: TButton
        Left = 496
        Top = 104
        Width = 89
        Height = 25
        Caption = #1055#1077#1095#1072#1090#1100
        TabOrder = 4
      end
    end
    object tsDecreeProject: TTabSheet
      Caption = #1055#1088#1086#1077#1082#1090' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        589
        493)
      object Label8: TLabel
        Left = 7
        Top = 0
        Width = 31
        Height = 13
        Caption = #1053#1086#1084#1077#1088
      end
      object Label10: TLabel
        Left = 7
        Top = 43
        Width = 133
        Height = 13
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
      end
      object btnDecreeProjectCreate: TBitBtn
        Left = 475
        Top = 8
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
        TabOrder = 0
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
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
          FDFDFDFDFDFDFDFDFDFD000000000000000000FDFDFDFDFDFDFD00F6F6F6F6F6
          F6F600FDFD5252FDFDFD00F600000000525252525252F952FDFD00F6F6F6F6F6
          52F9F9F9F9F9F9F952FD00F60000000052F9F9F9F9F9F9F9F95200F6F6F6F6F6
          52F9F9F9F9F9F9F9F95200F60000000052F9F9F9F9F9F9F9F95200F6F6F6F6F6
          52F9F9F9F9F9F9F9F95200F60000000052F9F9F9F9F9F9F952FD00F6F6F6F6F6
          525252525252F952FDFD00F600000000F6F600FDFD5252FDFDFD00F6F6F6F6F6
          F600F7FDFDFDFDFDFDFD00000000000000F7F7FDFDFDFDFDFDFDFDFDFDFDFDFD
          FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD}
      end
      object btnDecreeProjectSelect: TBitBtn
        Left = 475
        Top = 40
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 1
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
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
          FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD000000000000000000FDFDFD5B5BFD
          FD00FFFFFFFFFFFFFF00FDFD5BB05B5B5B5B5B5B00000000FF00FD5BB0B0B0B0
          B0B0B05BFFFFFFFFFF005BB0B0B0B0B0B0B0B05B00000000FF005BB0B0B0B0B0
          B0B0B05BFFFFFFFFFF005BB0B0B0B0B0B0B0B05B00000000FF005BB0B0B0B0B0
          B0B0B05BFFFFFFFFFF00FD5BB0B0B0B0B0B0B05B00000000FF00FDFD5BB05B5B
          5B5B5B5BFFFFFFFFFF00FDFDFD5B5BFDFD00FF00000000FFFF00FDFDFDFDFDFD
          FD00FFFFFFFFFFFF00F7FDFDFDFDFDFDFD00000000000000F7F7FDFDFDFDFDFD
          FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD}
      end
      object btnDecreeProjectClear: TBitBtn
        Left = 475
        Top = 72
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 2
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
          F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F70001FFF7F7F70001FFF7
          F7F7F7F7F7F7F7F7F7F7F700000001FFF7F7F7F7F70001FFF7F7F700000001FF
          F7F7F7F70001FFF7F7F7F7F700000001FFF7F7000001FFF7F7F7F7F7F7000000
          01FF000001FFF7F7F7F7F7F7F7F7000000000001FFF7F7F7F7F7F7F7F7F7F700
          000001FFF7F7F7F7F7F7F7F7F7F7000000000001FFF7F7F7F7F7F7F7F7000000
          01FF0001FFF7F7F7F7F7F70000000001FFF7F7000001FFF7F7F70000000001FF
          F7F7F7F7000001FFF7F7000001FFF7F7F7F7F7F7F7000001FFF7F7F7F7F7F7F7
          F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7}
      end
      object edSeqNumber: TEdit
        Left = 7
        Top = 15
        Width = 91
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = 'edSeqNumber'
      end
      object mHeader: TMemo
        Left = 7
        Top = 57
        Width = 458
        Height = 53
        Color = clBtnFace
        Lines.Strings = (
          'edHeader')
        ReadOnly = True
        TabOrder = 4
      end
      object GroupBox3: TGroupBox
        Left = 7
        Top = 120
        Width = 458
        Height = 361
        Caption = #1042#1080#1079#1099
        TabOrder = 5
        object dbgVisas: TkaDBGrid
          Left = 2
          Top = 15
          Width = 454
          Height = 344
          Align = alClient
          Color = clBtnFace
          DataSource = dsVisas
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
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
              Width = 325
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
      end
    end
  end
  object dsLetters: TDataSource
    Left = 56
    Top = 400
  end
  object dsExecutors: TDataSource
    Left = 256
    Top = 181
  end
  object dsVisas: TDataSource
    Left = 219
    Top = 288
  end
  object dsPhases: TDataSource
    Left = 212
    Top = 176
  end
  object dsOrders: TDataSource
    Left = 332
    Top = 304
  end
end
