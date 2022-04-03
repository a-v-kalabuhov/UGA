object KisConnectWorkForm: TKisConnectWorkForm
  Left = 369
  Top = 163
  Caption = #1042#1099#1073#1086#1088' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 248
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  DesignSize = (
    371
    248)
  PixelsPerInch = 96
  TextHeight = 13
  object lbWorks: TListBox
    Left = 8
    Top = 8
    Width = 355
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 288
    Top = 215
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    ExplicitTop = 237
  end
  object btnOK: TBitBtn
    Left = 207
    Top = 215
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1073#1088#1072#1090#1100
    ModalResult = 1
    TabOrder = 2
    ExplicitTop = 237
  end
end
