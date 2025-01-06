object mstMPClassDialog: TmstMPClassDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'mstMPClassDialog'
  ClientHeight = 112
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    476
    112)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 69
    Top = 11
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1083#1086#1081' '#1074' DXF'
    ExplicitLeft = 10
  end
  object Label2: TLabel
    Left = 46
    Top = 46
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1083#1086#1081' '#1074' '#1087#1088#1086#1077#1082#1090#1077
    ExplicitLeft = -13
  end
  object Label3: TLabel
    Left = 13
    Top = 83
    Width = 112
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1083#1086#1081' '#1074' '#1089#1074#1086#1076#1085#1086#1084' '#1087#1083#1072#1085#1077
    ExplicitLeft = -46
  end
  object edLayerName: TEdit
    Left = 131
    Top = 8
    Width = 233
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 0
    Text = 'edLayerName'
    OnChange = edLayerNameChange
  end
  object cbProjectLayer: TComboBox
    Left = 131
    Top = 43
    Width = 233
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    DropDownCount = 20
    ItemHeight = 0
    TabOrder = 1
  end
  object cbMPLayer: TComboBox
    Left = 131
    Top = 80
    Width = 233
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    DropDownCount = 20
    ItemHeight = 0
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 395
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 395
    Top = 76
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
end
