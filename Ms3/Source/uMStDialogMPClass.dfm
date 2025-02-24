object mstMPClassDialog: TmstMPClassDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'mstMPClassDialog'
  ClientHeight = 107
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  DesignSize = (
    474
    107)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 67
    Top = 13
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1083#1086#1081' '#1074' DXF'
    ExplicitLeft = 126
  end
  object Label2: TLabel
    Left = 44
    Top = 44
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1083#1086#1081' '#1074' '#1087#1088#1086#1077#1082#1090#1077
    ExplicitLeft = 103
  end
  object Label3: TLabel
    Left = 11
    Top = 78
    Width = 112
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1083#1086#1081' '#1074' '#1089#1074#1086#1076#1085#1086#1084' '#1087#1083#1072#1085#1077
    ExplicitLeft = 70
  end
  object edLayerName: TEdit
    Left = 129
    Top = 10
    Width = 233
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 0
    Text = 'edLayerName'
    OnChange = edLayerNameChange
    ExplicitLeft = 188
  end
  object cbProjectLayer: TComboBox
    Left = 129
    Top = 41
    Width = 233
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 1
    ExplicitLeft = 188
  end
  object cbMPLayer: TComboBox
    Left = 129
    Top = 75
    Width = 233
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 2
    ExplicitLeft = 188
  end
  object btnOK: TButton
    Left = 391
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
    ExplicitLeft = 450
  end
  object btnCancel: TButton
    Left = 391
    Top = 39
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
    ExplicitLeft = 450
  end
end
