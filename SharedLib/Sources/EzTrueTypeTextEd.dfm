object frmTrueTypeTextEditor: TfrmTrueTypeTextEditor
  Left = 259
  Top = 115
  AutoSize = True
  BorderStyle = bsToolWindow
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1085#1072#1076#1087#1080#1089#1080
  ClientHeight = 401
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 321
    Height = 156
    Align = alTop
    Caption = #1058#1077#1082#1089#1090
    TabOrder = 0
    object mText: TMemo
      Left = 2
      Top = 15
      Width = 317
      Height = 139
      Align = alClient
      Lines.Strings = (
        'mText')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 156
    Width = 321
    Height = 97
    Align = alTop
    Caption = #1064#1088#1080#1092#1090
    TabOrder = 1
    object lFontExample: TLabel
      Left = 8
      Top = 51
      Width = 46
      Height = 13
      Caption = #1055#1056#1048#1052#1045#1056
    end
    object btnSelectFont: TButton
      Left = 256
      Top = 14
      Width = 59
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 0
      OnClick = btnSelectFontClick
    end
    object FontCombobox: TOvcFontComboBox
      Left = 8
      Top = 16
      Width = 153
      Height = 22
      ItemHeight = 12
      TabOrder = 1
      FontCategories = fcTrueType
      PreviewFont = True
      OnChange = FontComboboxChange
    end
    object edFontSize: TEdit
      Left = 168
      Top = 16
      Width = 57
      Height = 21
      TabOrder = 2
      Text = '0'
      OnKeyPress = edFontSizeKeyPress
    end
    object udFontSize: TUpDown
      Left = 225
      Top = 16
      Width = 15
      Height = 21
      Associate = edFontSize
      TabOrder = 3
      OnChangingEx = udFontSizeChangingEx
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 253
    Width = 321
    Height = 119
    Align = alTop
    Caption = #1059#1075#1086#1083' '#1087#1086#1074#1086#1088#1086#1090#1072
    TabOrder = 2
    object rlAngle: TOvcRotatedLabel
      Left = 2
      Top = 15
      Width = 239
      Height = 98
      Alignment = taCenter
      AutoSize = False
      Caption = #1058#1077#1082#1089#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      OriginX = 115
      OriginY = 50
      ShadowedText = True
    end
    object edAngle: TEdit
      Left = 248
      Top = 48
      Width = 49
      Height = 21
      TabOrder = 0
      Text = '0'
      OnKeyPress = edAngleKeyPress
    end
    object udAngle: TUpDown
      Left = 297
      Top = 48
      Width = 15
      Height = 21
      Associate = edAngle
      Min = -360
      Max = 360
      TabOrder = 1
      OnChangingEx = udAngleChangingEx
    end
  end
  object Button1: TButton
    Left = 8
    Top = 376
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 240
    Top = 376
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object FontDlg: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdTrueTypeOnly, fdEffects]
    Left = 160
    Top = 112
  end
end
