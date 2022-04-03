object mstFormReportTable: TmstFormReportTable
  Left = -2
  Top = 103
  Caption = #1090#1072#1073#1083#1080#1094#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  ClientHeight = 387
  ClientWidth = 795
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    795
    387)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 631
    Top = 354
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    ExplicitLeft = 377
  end
  object btnCancel: TButton
    Left = 712
    Top = 354
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 458
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 795
    Height = 348
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnExit = DBGrid1Exit
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 354
    Width = 240
    Height = 25
    DataSource = DataSource
    Anchors = [akLeft, akBottom]
    TabOrder = 3
  end
  object DataSource: TDataSource
    Left = 304
    Top = 104
  end
end
