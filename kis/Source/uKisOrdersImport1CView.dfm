object OrderImport1CForm: TOrderImport1CForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1048#1084#1087#1086#1088#1090' '#1079#1072#1082#1072#1079#1086#1074' '#1080#1079' 1'#1057
  ClientHeight = 372
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    537
    372)
  PixelsPerInch = 96
  TextHeight = 13
  object lProgress: TLabel
    Left = 8
    Top = 104
    Width = 36
    Height = 13
    Caption = #1054#1090#1095#1105#1090':'
    Visible = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = #1060#1072#1081#1083':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 54
    Width = 521
    Height = 11
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object Label3: TLabel
    Left = 8
    Top = 157
    Width = 36
    Height = 13
    Caption = #1054#1090#1095#1105#1090':'
  end
  object Memo1: TMemo
    Left = 8
    Top = 176
    Width = 521
    Height = 188
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 400
    Top = 71
    Width = 129
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object edFile: TEdit
    Left = 8
    Top = 27
    Width = 440
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ParentColor = True
    ReadOnly = True
    TabOrder = 2
  end
  object btnOpen: TButton
    Left = 454
    Top = 25
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = btnOpenClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 123
    Width = 521
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object btnImport: TBitBtn
    Left = 8
    Top = 71
    Width = 129
    Height = 25
    Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 5
    OnClick = btnImportClick
  end
  object btnSave: TButton
    Left = 265
    Top = 71
    Width = 129
    Height = 25
    Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1076#1077#1083#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    Enabled = False
    TabOrder = 6
    OnClick = btnSaveClick
  end
  object OpenDialog2: TOpenDialog
    Left = 56
    Top = 8
  end
end
