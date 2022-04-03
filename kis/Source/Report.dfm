object ReportForm: TReportForm
  Left = 353
  Top = 226
  ActiveControl = edtReportName
  BorderStyle = bsDialog
  Caption = #1054#1090#1095#1077#1090
  ClientHeight = 129
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 8
    Top = 53
    Width = 26
    Height = 13
    Caption = #1060#1072#1081#1083
  end
  object SelectBtn: TSpeedButton
    Left = 290
    Top = 68
    Width = 20
    Height = 19
    Caption = '6'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Marlett'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SelectBtnClick
  end
  object btnOk: TButton
    Left = 8
    Top = 98
    Width = 70
    Height = 24
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 83
    Top = 98
    Width = 71
    Height = 24
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object edtReportName: TEdit
    Left = 8
    Top = 23
    Width = 302
    Height = 21
    TabOrder = 0
  end
  object edtFileName: TEdit
    Left = 8
    Top = 68
    Width = 282
    Height = 21
    TabOrder = 1
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.frf'
    Filter = #1064#1072#1073#1083#1086#1085#1099' '#1086#1090#1095#1077#1090#1086#1074' FastReport (*.frf)|*.frf|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Left = 176
    Top = 64
  end
end
