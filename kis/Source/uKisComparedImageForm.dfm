object KisComparedImageForm: TKisComparedImageForm
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1083#1072#1085#1096#1077#1090#1086#1074
  ClientHeight = 426
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  DesignSize = (
    738
    426)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 614
    Top = 393
    Width = 116
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
  end
  object Button2: TButton
    Left = 8
    Top = 393
    Width = 116
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1055#1088#1080#1085#1103#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Box: TATImageBox
    Left = 0
    Top = 32
    Width = 738
    Height = 355
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = False
    Color = 16511726
    ParentColor = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 738
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 2
      Width = 49
      Height = 13
      Caption = #1052#1072#1089#1096#1090#1072#1073':'
    end
    object LabelScale: TLabel
      Left = 8
      Top = 16
      Width = 49
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '100%'
    end
    object lArea: TLabel
      Left = 681
      Top = 2
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1072#1089#1096#1090#1072#1073':'
    end
    object lRank: TLabel
      Left = 701
      Top = 16
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = '100%'
    end
    object TrackBar1: TTrackBar
      Left = 63
      Top = 4
      Width = 217
      Height = 25
      Max = 100
      Min = 1
      PageSize = 10
      Frequency = 50
      Position = 100
      TabOrder = 0
      ThumbLength = 16
      OnChange = TrackBar1Change
    end
    object chkFit: TCheckBox
      Left = 286
      Top = 9
      Width = 225
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1086#1083#1085#1086#1089#1090#1100#1102
      TabOrder = 1
      OnClick = chkFitClick
    end
  end
  object btnSaveImage: TBitBtn
    Left = 485
    Top = 393
    Width = 116
    Height = 25
    Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' '#1092#1072#1081#1083'...'
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
    TabOrder = 4
    Visible = False
    OnClick = btnSaveImageClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00AAAAAAAAAAAA
      AAAAAA0000000000000AA03300000088030AA03300000088030AA03300000088
      030AA03300000000030AA03333333333330AA03300000000330AA03088888888
      030AA03088888888030AA03088888888030AA03088888888030AA03088888888
      000AA03088888888080AA00000000000000AAAAAAAAAAAAAAAAA}
  end
  object btnPrint: TBitBtn
    Left = 363
    Top = 393
    Width = 116
    Height = 25
    Hint = #1055#1077#1095#1072#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
    Anchors = [akRight, akBottom]
    Caption = #1055#1077#1095#1072#1090#1100'...'
    TabOrder = 5
    Visible = False
    OnClick = btnPrintClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000CE0E0000D80E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00222222222222
      22222200000000000222208888888880802200000000000008020888888BBB88
      0002088888877788080200000000000008800888888888808080200000000008
      0800220FFFFFFFF080802220F00000F000022220FFFFFFFF022222220F00000F
      022222220FFFFFFFF02222222000000000222222222222222222}
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 16
    Top = 56
    object acZoomIn: TAction
      Caption = 'acZoomIn'
    end
    object acZoomOut: TAction
      Caption = 'acZoomOut'
    end
    object acZoomAll: TAction
      Caption = 'acZoomAll'
    end
    object acZoom100: TAction
      Caption = 'acZoom100'
    end
  end
  object ImageList1: TImageList
    Left = 48
    Top = 56
  end
  object SaveDialog2: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = #1057#1086#1093#1088#1072#1085#1103#1077#1084
    Left = 16
    Top = 96
  end
end
