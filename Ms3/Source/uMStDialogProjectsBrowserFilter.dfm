object mstProjectBrowserFilterDialog: TmstProjectBrowserFilterDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1060#1080#1083#1100#1090#1088' '#1087#1088#1086#1077#1082#1090#1086#1074
  ClientHeight = 499
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    328
    499)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 13
    Caption = #1040#1076#1088#1077#1089':'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 51
    Height = 13
    Caption = #1047#1072#1082#1072#1079#1095#1080#1082':'
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 70
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
  end
  object Label7: TLabel
    Left = 8
    Top = 360
    Width = 48
    Height = 13
    Caption = #1044#1080#1072#1084#1077#1090#1088':'
  end
  object Label8: TLabel
    Left = 8
    Top = 408
    Width = 67
    Height = 13
    Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077':'
  end
  object Label9: TLabel
    Left = 8
    Top = 232
    Width = 40
    Height = 13
    Caption = #1057#1090#1072#1090#1091#1089':'
  end
  object Label6: TLabel
    Left = 8
    Top = 456
    Width = 67
    Height = 13
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103':'
  end
  object edAddress: TEdit
    Left = 8
    Top = 24
    Width = 217
    Height = 21
    TabOrder = 0
    Text = 'edAddress'
  end
  object btnOK: TButton
    Left = 245
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 9
  end
  object btnCancel: TButton
    Left = 245
    Top = 39
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 10
  end
  object edCustomer: TEdit
    Left = 8
    Top = 72
    Width = 217
    Height = 21
    TabOrder = 1
    Text = 'edCustomer'
  end
  object edExecutor: TEdit
    Left = 8
    Top = 120
    Width = 217
    Height = 21
    TabOrder = 2
    Text = 'edExecutor'
  end
  object edDiameter: TEdit
    Left = 8
    Top = 376
    Width = 217
    Height = 21
    TabOrder = 6
    Text = 'edDiameter'
  end
  object edVoltage: TEdit
    Left = 8
    Top = 424
    Width = 217
    Height = 21
    TabOrder = 7
    Text = 'edVoltage'
  end
  object cbStatus: TComboBox
    Left = 8
    Top = 248
    Width = 217
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = #1087#1088#1086#1074#1077#1088#1077#1085
    OnChange = cbStatusChange
    Items.Strings = (
      #1087#1088#1086#1074#1077#1088#1077#1085
      #1085#1077#1087#1088#1086#1074#1077#1088#1077#1085
      #1085#1077#1074#1072#1078#1085#1086)
  end
  object gbDateConfirm: TGroupBox
    Left = 8
    Top = 275
    Width = 217
    Height = 79
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1088#1082#1080
    TabOrder = 5
    object Label10: TLabel
      Left = 19
      Top = 21
      Width = 12
      Height = 13
      Alignment = taRightJustify
      Caption = #1086#1090
    end
    object Label11: TLabel
      Left = 18
      Top = 48
      Width = 13
      Height = 13
      Alignment = taRightJustify
      Caption = #1076#1086
    end
    object dtpDateConfirm1: TDateTimePicker
      Left = 37
      Top = 18
      Width = 177
      Height = 21
      Date = 44402.724272071760000000
      Time = 44402.724272071760000000
      TabOrder = 0
    end
    object dtpDateConfirm2: TDateTimePicker
      Left = 37
      Top = 45
      Width = 177
      Height = 21
      Date = 44402.724272071760000000
      Time = 44402.724272071760000000
      TabOrder = 1
    end
  end
  object gbDateProject: TGroupBox
    Left = 8
    Top = 147
    Width = 217
    Height = 79
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1077#1082#1090#1072
    TabOrder = 3
    object Label4: TLabel
      Left = 19
      Top = 21
      Width = 12
      Height = 13
      Alignment = taRightJustify
      Caption = #1086#1090
    end
    object Label5: TLabel
      Left = 18
      Top = 48
      Width = 13
      Height = 13
      Alignment = taRightJustify
      Caption = #1076#1086
    end
    object dtpDateProject1: TDateTimePicker
      Left = 37
      Top = 18
      Width = 177
      Height = 21
      Date = 44402.724272071760000000
      Time = 44402.724272071760000000
      TabOrder = 0
    end
    object dtpDateProject2: TDateTimePicker
      Left = 37
      Top = 45
      Width = 177
      Height = 21
      Date = 44402.724272071760000000
      Time = 44402.724272071760000000
      TabOrder = 1
    end
  end
  object edInfo: TEdit
    Left = 8
    Top = 472
    Width = 217
    Height = 21
    TabOrder = 8
    Text = 'edInfo'
  end
end
