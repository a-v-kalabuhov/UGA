object KisStreetSelectorForm: TKisStreetSelectorForm
  Left = -2
  Top = 103
  BorderStyle = bsNone
  Caption = 'KisStreetSelectorForm'
  ClientHeight = 245
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 488
    Height = 245
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    DesignSize = (
      488
      245)
    object DBGrid1: TDBGrid
      Left = 2
      Top = 2
      Width = 484
      Height = 120
      Cursor = crDrag
      Align = alTop
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'NAME'
          Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'STREET_MARKING_NAME'
          Title.Caption = #1057#1086#1082#1088'.'
          Visible = True
        end>
    end
    object btnSelect: TBitBtn
      Left = 319
      Top = 208
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Default = True
      TabOrder = 1
      Visible = False
    end
    object btnClose: TBitBtn
      Left = 400
      Top = 208
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 2
      Visible = False
    end
  end
  object DataSource1: TDataSource
    Left = 272
    Top = 136
  end
end
