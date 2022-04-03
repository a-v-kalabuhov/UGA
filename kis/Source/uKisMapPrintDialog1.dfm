object KisMapPrintDialogForm: TKisMapPrintDialogForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'KisMapPrintDialogForm'
  ClientHeight = 443
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    514
    443)
  PixelsPerInch = 96
  TextHeight = 13
  object imgPreview: TImage
    Left = 8
    Top = 35
    Width = 369
    Height = 400
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object btnSetup: TButton
    Left = 383
    Top = 51
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1053#1072#1089#1090#1088#1086#1080#1090#1100'...'
    TabOrder = 0
    OnClick = btnSetupClick
  end
  object cbPrinters: TComboBox
    Left = 8
    Top = 8
    Width = 369
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 1
    OnChange = cbPrintersChange
  end
  object btnPrint: TButton
    Left = 383
    Top = 8
    Width = 122
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1055#1077#1095#1072#1090#1072#1090#1100
    TabOrder = 2
    OnClick = btnPrintClick
  end
  object btnClose: TButton
    Left = 383
    Top = 410
    Width = 122
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 3
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 424
    Top = 184
  end
end
