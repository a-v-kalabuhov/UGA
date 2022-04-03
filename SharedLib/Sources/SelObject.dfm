object frmObjectList: TfrmObjectList
  Left = -2
  Top = 103
  Width = 219
  Height = 182
  BorderStyle = bsSizeToolWin
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1073#1098#1077#1082#1090
  Color = clBtnFace
  Constraints.MinHeight = 182
  Constraints.MinWidth = 219
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 144
    Top = 128
    Width = 67
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 0
    Top = 128
    Width = 65
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object lbObjects: TListBox
    Left = 0
    Top = 0
    Width = 211
    Height = 121
    Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1073#1098#1077#1082#1090' '#1076#1074#1086#1081#1085#1099#1084' '#1097#1077#1083#1095#1082#1086#1084#13#10#1080#1083#1080' '#1085#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091' '#1054#1050
    Align = alTop
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnDblClick = lbObjectsDblClick
    OnMouseMove = lbObjectsMouseMove
  end
end
