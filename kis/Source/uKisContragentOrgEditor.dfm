inherited KisContragentOrgEditor: TKisContragentOrgEditor
  Left = 27
  Top = 103
  Caption = ''
  ClientHeight = 638
  ClientWidth = 712
  ExplicitWidth = 718
  ExplicitHeight = 666
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Top = 600
    Width = 712
    Height = 38
    AutoSize = False
    ExplicitTop = 600
    ExplicitWidth = 712
    ExplicitHeight = 38
  end
  inherited IDLabel: TLabel
    Left = 7
    Top = 619
    Alignment = taRightJustify
    Font.Color = cl3DDkShadow
    ParentColor = False
    ParentFont = False
    ExplicitLeft = 7
    ExplicitTop = 619
  end
  inherited lComment: TLabel
    Left = 520
    Top = 469
    ExplicitLeft = 520
    ExplicitTop = 469
  end
  inherited btnOk: TButton
    Left = 548
    Top = 607
    TabOrder = 5
    ExplicitLeft = 548
    ExplicitTop = 607
  end
  inherited btnCancel: TButton
    Left = 629
    Top = 607
    TabOrder = 6
    ExplicitLeft = 629
    ExplicitTop = 607
  end
  inherited gbCommon: TGroupBox
    Width = 712
    Height = 193
    ExplicitWidth = 712
    ExplicitHeight = 193
    inherited lName: TLabel
      Left = 22
      Alignment = taRightJustify
      ExplicitLeft = 22
    end
    inherited lShortName: TLabel
      Left = 11
      Alignment = taRightJustify
      ExplicitLeft = 11
    end
    inherited lAddress1: TLabel
      Left = 44
      Width = 53
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089' '#1102#1088'.'
      ExplicitLeft = 44
      ExplicitWidth = 53
    end
    inherited lAddress2: TLabel
      Left = 33
      Width = 64
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089' '#1092#1072#1082#1090'.'
      ExplicitLeft = 33
      ExplicitWidth = 64
    end
    inherited lINN: TLabel
      Left = 74
      Top = 137
      ExplicitLeft = 74
      ExplicitTop = 137
    end
    inherited lPhones: TLabel
      Left = 43
      Top = 166
      Alignment = taRightJustify
      ExplicitLeft = 43
      ExplicitTop = 166
    end
    object Label22: TLabel [6]
      Left = 212
      Top = 137
      Width = 21
      Height = 13
      Caption = #1050#1055#1055
    end
    object Label19: TLabel [7]
      Left = 340
      Top = 136
      Width = 61
      Height = 13
      Caption = #1050#1086#1076' '#1054#1050#1054#1055#1060
    end
    object Label20: TLabel [8]
      Left = 440
      Top = 136
      Width = 53
      Height = 13
      Caption = #1050#1086#1076' '#1054#1050#1055#1054
    end
    object Label21: TLabel [9]
      Left = 563
      Top = 136
      Width = 59
      Height = 13
      Caption = #1050#1086#1076' '#1054#1050#1054#1053#1061
    end
    inherited edName: TEdit
      Left = 103
      Width = 592
      OnChange = edNameChange
      OnExit = edNameExit
      ExplicitLeft = 103
      ExplicitWidth = 592
    end
    inherited edNameShort: TEdit
      Left = 103
      Width = 592
      OnChange = edNameShortChange
      OnExit = edNameShortExit
      ExplicitLeft = 103
      ExplicitWidth = 592
    end
    inherited edAddr1: TEdit
      Left = 103
      Width = 507
      Color = clWindow
      ExplicitLeft = 103
      ExplicitWidth = 507
    end
    inherited edAddr2: TEdit
      Left = 103
      Width = 507
      ExplicitLeft = 103
      ExplicitWidth = 507
    end
    inherited btnAddress1: TButton
      TabOrder = 10
    end
    inherited btnAddress2: TButton
      TabOrder = 11
    end
    inherited edINN: TEdit
      Left = 103
      Top = 134
      Width = 100
      TabOrder = 4
      ExplicitLeft = 103
      ExplicitTop = 134
      ExplicitWidth = 100
    end
    inherited edPhones: TEdit
      Left = 103
      Top = 163
      Width = 328
      TabOrder = 9
      ExplicitLeft = 103
      ExplicitTop = 163
      ExplicitWidth = 328
    end
    object edKPP: TEdit
      Left = 238
      Top = 134
      Width = 91
      Height = 21
      MaxLength = 9
      TabOrder = 5
      OnKeyPress = EditNumberField
    end
    object edOKPF: TEdit
      Left = 406
      Top = 133
      Width = 25
      Height = 21
      MaxLength = 2
      TabOrder = 6
    end
    object edOKPO: TEdit
      Left = 498
      Top = 133
      Width = 58
      Height = 21
      MaxLength = 8
      TabOrder = 7
      Text = '999999999'
    end
    object edOKONH: TEdit
      Left = 628
      Top = 133
      Width = 69
      Height = 21
      MaxLength = 10
      TabOrder = 8
      Text = '99999999999'
    end
  end
  inherited mComment: TMemo
    Left = 520
    Top = 485
    Width = 185
    Height = 116
    TabOrder = 4
    ExplicitLeft = 520
    ExplicitTop = 485
    ExplicitWidth = 185
    ExplicitHeight = 116
  end
  inherited gbBank: TGroupBox
    Top = 193
    Width = 712
    Height = 80
    TabOrder = 1
    ExplicitTop = 193
    ExplicitWidth = 712
    ExplicitHeight = 80
    inherited lAccountType: TLabel
      Left = 68
      Top = 51
      Width = 50
      Height = 13
      Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
      ExplicitLeft = 68
      ExplicitTop = 51
      ExplicitWidth = 50
      ExplicitHeight = 13
    end
    inherited lAccount: TLabel
      Left = 286
      Top = 50
      ExplicitLeft = 286
      ExplicitTop = 50
    end
    inherited cbKindAccount: TComboBox
      Left = 128
      Top = 47
      Width = 119
      TabOrder = 1
      ExplicitLeft = 128
      ExplicitTop = 47
      ExplicitWidth = 119
    end
    inherited edBank: TEdit
      Left = 128
      Top = 18
      Width = 473
      TabOrder = 0
      ExplicitLeft = 128
      ExplicitTop = 18
      ExplicitWidth = 473
    end
    inherited edBankAccount: TEdit
      Left = 356
      Top = 47
      ExplicitLeft = 356
      ExplicitTop = 47
    end
    inherited btnBank: TButton
      Left = 608
      Top = 17
      Width = 89
      ExplicitLeft = 608
      ExplicitTop = 17
      ExplicitWidth = 89
    end
  end
  object gbHeadOrg: TGroupBox [8]
    Left = 0
    Top = 465
    Width = 513
    Height = 137
    Caption = #1043#1086#1083#1086#1074#1085#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    TabOrder = 3
    object Label23: TLabel
      Left = 7
      Top = 15
      Width = 79
      Height = 26
      Caption = #1058#1080#1087' '#1076#1086#1095#1077#1088#1085#1077#1075#1086' '#13#10#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
    end
    object Label24: TLabel
      Left = 9
      Top = 53
      Width = 190
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1075#1086#1083#1086#1074#1085#1086#1081' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
    end
    object Label25: TLabel
      Left = 10
      Top = 93
      Width = 148
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1075#1086#1083#1086#1074#1085#1086#1081' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
    end
    object cbSubdivisionType: TComboBox
      Left = 91
      Top = 19
      Width = 115
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object edHeadOrgName: TEdit
      Left = 9
      Top = 69
      Width = 494
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edHeadOrgAddress: TEdit
      Left = 9
      Top = 108
      Width = 494
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object btnSelectHeadOrg: TButton
      Left = 429
      Top = 15
      Width = 69
      Height = 23
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 3
      TabStop = False
    end
    object btnClearHeadOrg: TButton
      Left = 429
      Top = 39
      Width = 69
      Height = 23
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 4
      TabStop = False
    end
  end
  object pOfficials: TPanel [9]
    Left = 0
    Top = 273
    Width = 712
    Height = 192
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object gbChief: TGroupBox
      Left = 0
      Top = 0
      Width = 417
      Height = 192
      Align = alLeft
      Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1080
      TabOrder = 0
      object lChiefPost: TLabel
        Left = 8
        Top = 59
        Width = 57
        Height = 13
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        FocusControl = edChiefPost
      end
      object Label121: TLabel
        Left = 31
        Top = 30
        Width = 35
        Height = 13
        Caption = #1060'.'#1048'.'#1054'.'
      end
      object Label18: TLabel
        Left = 15
        Top = 162
        Width = 50
        Height = 13
        Caption = #1043#1083#1072#1074'.'#1073#1091#1093'.'
      end
      object edChiefFIO: TEdit
        Left = 72
        Top = 28
        Width = 297
        Height = 21
        MaxLength = 150
        TabOrder = 0
      end
      object edChiefPost: TEdit
        Left = 71
        Top = 55
        Width = 297
        Height = 21
        MaxLength = 250
        TabOrder = 1
      end
      object edAccountantFIO: TEdit
        Left = 72
        Top = 160
        Width = 297
        Height = 21
        MaxLength = 150
        TabOrder = 3
      end
      object gbChiefDocs: TGroupBox
        Left = 6
        Top = 80
        Width = 405
        Height = 69
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
        TabOrder = 2
        object Label261: TLabel
          Left = 173
          Top = 17
          Width = 13
          Height = 13
          Caption = #8470
        end
        object Label14: TLabel
          Left = 264
          Top = 17
          Width = 12
          Height = 13
          Caption = #1086#1090
        end
        object btnAddChiefDoc: TSpeedButton
          Left = 371
          Top = 14
          Width = 23
          Height = 22
          Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1089#1087#1080#1089#1086#1082' '#13#10#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
          Flat = True
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
          ParentShowHint = False
          ShowHint = True
          OnClick = btnAddChiefDocClick
        end
        object Label1: TLabel
          Left = 26
          Top = 36
          Width = 34
          Height = 26
          Alignment = taRightJustify
          Caption = #1042#1077#1089#1100' '#13#10#1089#1087#1080#1089#1086#1082
          FocusControl = edContacterFIO
        end
        object cbChiefDocType: TComboBox
          Left = 67
          Top = 14
          Width = 97
          Height = 21
          Style = csDropDownList
          Color = clInfoBk
          ItemHeight = 13
          TabOrder = 0
        end
        object edChiefDocNumber: TEdit
          Left = 188
          Top = 14
          Width = 72
          Height = 21
          MaxLength = 10
          TabOrder = 1
        end
        object edChiefDocs: TEdit
          Left = 67
          Top = 39
          Width = 297
          Height = 21
          MaxLength = 255
          TabOrder = 3
        end
        object dtpChiefDocDate: TDateTimePicker
          Left = 284
          Top = 14
          Width = 80
          Height = 22
          Date = 38052.724696041660000000
          Time = 38052.724696041660000000
          Color = clInfoBk
          TabOrder = 2
        end
      end
    end
    object gbContacter: TGroupBox
      Left = 424
      Top = 0
      Width = 288
      Height = 192
      Align = alRight
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
      TabOrder = 1
      object lContacterPost: TLabel
        Left = 5
        Top = 59
        Width = 57
        Height = 13
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        FocusControl = edContacterPost
      end
      object lContacterName: TLabel
        Left = 28
        Top = 30
        Width = 35
        Height = 13
        Caption = #1060'.'#1048'.'#1054'.'
        FocusControl = edContacterFIO
      end
      object lContacterPhone: TLabel
        Left = 18
        Top = 91
        Width = 44
        Height = 13
        Caption = #1058#1077#1083#1077#1092#1086#1085
        FocusControl = edContacterPhone
      end
      object edContacterPost: TEdit
        Left = 67
        Top = 57
        Width = 205
        Height = 21
        MaxLength = 50
        TabOrder = 1
      end
      object edContacterFIO: TEdit
        Left = 67
        Top = 28
        Width = 205
        Height = 21
        MaxLength = 150
        TabOrder = 0
      end
      object edContacterPhone: TEdit
        Left = 67
        Top = 86
        Width = 205
        Height = 21
        MaxLength = 30
        TabOrder = 2
      end
    end
  end
end
