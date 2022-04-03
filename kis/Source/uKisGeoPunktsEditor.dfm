inherited KisGeoPunktsEditor: TKisGeoPunktsEditor
  Left = 177
  Top = 308
  Caption = 'KisGeoPunktsEditor'
  ClientHeight = 466
  ClientWidth = 607
  KeyPreview = True
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  ExplicitTop = -22
  ExplicitWidth = 613
  ExplicitHeight = 498
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Left = 49
    Top = 446
    Visible = False
    ExplicitLeft = 49
    ExplicitTop = 446
  end
  object Label9: TLabel [1]
    Left = 7
    Top = 8
    Width = 57
    Height = 13
    Caption = #1058#1080#1087' '#1087#1091#1085#1082#1090#1072
  end
  object Label6: TLabel [2]
    Left = 7
    Top = 47
    Width = 68
    Height = 13
    Caption = #1050#1083#1072#1089#1089' '#1087#1091#1085#1082#1090#1072
  end
  object Label4: TLabel [3]
    Left = 7
    Top = 199
    Width = 66
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
  end
  object Label5: TLabel [4]
    Left = 7
    Top = 238
    Width = 94
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1100#1085#1080#1082' '#1087#1072#1088#1090#1080#1080
  end
  object Label1: TLabel [5]
    Left = 7
    Top = 83
    Width = 105
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1079#1085#1072#1082#1072
  end
  object Label2: TLabel [6]
    Left = 7
    Top = 278
    Width = 57
    Height = 13
    Caption = #1058#1080#1087' '#1094#1077#1085#1090#1088#1072
  end
  object Label7: TLabel [7]
    Left = 8
    Top = 363
    Width = 79
    Height = 13
    Caption = #1053#1072#1088#1091#1078#1085#1099#1081' '#1079#1085#1072#1082
  end
  object Label8: TLabel [8]
    Left = 155
    Top = 363
    Width = 78
    Height = 13
    Caption = #1063#1077#1088#1090#1077#1078' '#1094#1077#1085#1090#1088#1072
  end
  object Label10: TLabel [9]
    Left = 7
    Top = 122
    Width = 52
    Height = 13
    Caption = #1042#1080#1076' '#1088#1072#1073#1086#1090
  end
  object Label3: TLabel [10]
    Left = 7
    Top = 160
    Width = 120
    Height = 13
    Caption = #1044#1072#1090#1072' '#1082#1086#1086#1088#1076#1080#1085#1080#1088#1086#1074#1072#1085#1080#1103
  end
  object Label11: TLabel [11]
    Left = 303
    Top = 352
    Width = 85
    Height = 26
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#13#10#1084#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1103
  end
  inherited btnOk: TButton
    Left = 443
    Top = 433
    TabOrder = 12
    ExplicitLeft = 443
    ExplicitTop = 433
  end
  inherited btnCancel: TButton
    Left = 524
    Top = 433
    Default = True
    TabOrder = 13
    ExplicitLeft = 524
    ExplicitTop = 433
  end
  object cbStatus: TCheckBox [14]
    Left = 8
    Top = 325
    Width = 91
    Height = 16
    Caption = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1077#1085
    Enabled = False
    TabOrder = 11
  end
  object cbPunktType1: TComboBox [15]
    Left = 7
    Top = 22
    Width = 134
    Height = 21
    Enabled = False
    ItemHeight = 0
    TabOrder = 0
  end
  object edClass: TEdit [16]
    Left = 7
    Top = 61
    Width = 134
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 1
    Text = 'edClass'
  end
  object edPartChief: TEdit [17]
    Left = 7
    Top = 252
    Width = 134
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 6
    Text = 'edPartChief'
  end
  object edCreator: TEdit [18]
    Left = 7
    Top = 213
    Width = 134
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 5
    Text = 'edCreator'
  end
  object edName: TEdit [19]
    Left = 7
    Top = 99
    Width = 134
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 2
    Text = 'edName'
  end
  object edCenterType: TEdit [20]
    Left = 7
    Top = 294
    Width = 79
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 7
    Text = 'edCenterType'
  end
  object edSymbolInfo: TMemo [21]
    Left = 8
    Top = 377
    Width = 134
    Height = 53
    Color = cl3DLight
    Lines.Strings = (
      'edSymbolInfo')
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object edSymbolInfo2: TMemo [22]
    Left = 155
    Top = 377
    Width = 135
    Height = 53
    Color = cl3DLight
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object btnPrintReport: TButton [23]
    Left = 445
    Top = 374
    Width = 148
    Height = 24
    Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1086#1090#1095#1077#1090' (Ctrl + P)'
    TabOrder = 14
  end
  object cbPunktType2: TComboBox [24]
    Left = 7
    Top = 137
    Width = 134
    Height = 21
    Enabled = False
    ItemHeight = 0
    TabOrder = 3
  end
  object edPunktDate: TEdit [25]
    Left = 7
    Top = 174
    Width = 134
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 4
    Text = 'edPunktDate'
  end
  object edPlaceInfo: TMemo [26]
    Left = 303
    Top = 377
    Width = 134
    Height = 53
    Color = cl3DLight
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 10
  end
  object pImage: TPanel [27]
    Left = 144
    Top = 0
    Width = 457
    Height = 353
    TabOrder = 15
    object Panel1: TPanel
      Left = 6
      Top = 8
      Width = 443
      Height = 307
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 0
      object ImgGeoPunkt: TImage
        Left = 2
        Top = 2
        Width = 439
        Height = 303
        Align = alClient
        Center = True
        Stretch = True
      end
    end
    object btnLoadImage: TButton
      Left = 298
      Top = 321
      Width = 71
      Height = 23
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 1
      TabStop = False
      OnClick = btnLoadImageClick
    end
    object btnClearImage: TButton
      Left = 375
      Top = 321
      Width = 71
      Height = 23
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 2
      TabStop = False
      OnClick = btnClearImageClick
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = #1060#1072#1081#1083#1099' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' (*.bmp)|*.bmp'
    Left = 392
    Top = 320
  end
end
