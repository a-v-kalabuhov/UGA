object mstMPBrowserFilterDialog: TmstMPBrowserFilterDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1060#1080#1083#1100#1090#1088' '#1089#1077#1090#1077#1081
  ClientHeight = 303
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    328
    303)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 13
    Caption = #1040#1076#1088#1077#1089':'
  end
  object Label9: TLabel
    Left = 8
    Top = 51
    Width = 80
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1087#1088#1086#1077#1082#1090#1072':'
  end
  object chbArchived: TLabel
    Left = 8
    Top = 187
    Width = 51
    Height = 13
    Caption = #1040#1088#1093#1080#1074#1085#1099#1081
  end
  object chbConfirmed: TLabel
    Left = 8
    Top = 218
    Width = 59
    Height = 13
    Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085
  end
  object chbDismantled: TLabel
    Left = 8
    Top = 249
    Width = 74
    Height = 13
    Caption = #1044#1077#1084#1086#1085#1090#1080#1088#1086#1074#1072#1085
  end
  object chbUndergroud: TLabel
    Left = 8
    Top = 278
    Width = 57
    Height = 13
    Caption = #1055#1086#1076#1079#1077#1084#1085#1099#1081
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
    TabOrder = 7
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
    TabOrder = 8
  end
  object gbDateProject: TGroupBox
    Left = 8
    Top = 94
    Width = 217
    Height = 79
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1077#1082#1090#1072
    TabOrder = 2
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
  object edDocNumber: TEdit
    Left = 8
    Top = 67
    Width = 217
    Height = 21
    TabOrder = 1
    Text = 'edDocNumber'
  end
  object ComboBox1: TComboBox
    Left = 88
    Top = 184
    Width = 134
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 3
    Items.Strings = (
      #1085#1077' '#1074#1072#1078#1085#1086
      #1076#1072
      #1085#1077#1090)
  end
  object ComboBox2: TComboBox
    Left = 88
    Top = 215
    Width = 134
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 4
    Items.Strings = (
      #1085#1077' '#1074#1072#1078#1085#1086
      #1076#1072
      #1085#1077#1090)
  end
  object ComboBox3: TComboBox
    Left = 88
    Top = 246
    Width = 134
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 5
    Items.Strings = (
      #1085#1077' '#1074#1072#1078#1085#1086
      #1076#1072
      #1085#1077#1090)
  end
  object ComboBox4: TComboBox
    Left = 88
    Top = 275
    Width = 134
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 6
    Items.Strings = (
      #1085#1077' '#1074#1072#1078#1085#1086
      #1076#1072
      #1085#1077#1090)
  end
end
