object MStLayerBrowserForm: TMStLayerBrowserForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1041#1088#1072#1091#1079#1077#1088' '#1089#1083#1086#1103
  ClientHeight = 508
  ClientWidth = 843
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 843
    Height = 29
    Align = alTop
    TabOrder = 0
    DesignSize = (
      843
      29)
    object btnDisplay: TSpeedButton
      Left = 588
      Top = 3
      Width = 122
      Height = 23
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072' '#1082#1072#1088#1090#1077
      OnClick = btnDisplayClick
    end
    object btnClose: TSpeedButton
      Left = 716
      Top = 3
      Width = 122
      Height = 23
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = btnCloseClick
    end
    object chbAutoDisplay: TCheckBox
      Left = 497
      Top = 5
      Width = 77
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #1040#1074#1090#1086#1087#1086#1082#1072#1079
      TabOrder = 0
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 3
      Width = 188
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 0
      TabOrder = 1
    end
    object DBNavigator1: TDBNavigator
      Left = 202
      Top = 2
      Width = 148
      Height = 25
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 29
    Width = 843
    Height = 443
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 225
      Top = 0
      Width = 8
      Height = 443
      ExplicitHeight = 475
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 225
      Height = 443
      Align = alLeft
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
          FieldName = 'UID'
          Title.Caption = #1053#1086#1084#1077#1088
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OBJECT_ID'
          Title.Caption = 'ID'
          Width = 115
          Visible = True
        end>
    end
    object vleFields: TValueListEditor
      Left = 233
      Top = 0
      Width = 610
      Height = 443
      Align = alClient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 1
      TitleCaptions.Strings = (
        #1055#1086#1083#1077
        #1047#1085#1072#1095#1077#1085#1080#1077)
      ColWidths = (
        248
        356)
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 472
    Width = 843
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      843
      36)
    object btnCoords: TSpeedButton
      Left = 260
      Top = 6
      Width = 122
      Height = 23
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1072#1085#1090#1099
      Visible = False
    end
    object chbTransparency: TCheckBox
      Left = 8
      Top = 6
      Width = 97
      Height = 17
      Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
      TabOrder = 0
      OnClick = chbTransparencyClick
    end
    object trackAlpha: TTrackBar
      Left = 104
      Top = 2
      Width = 150
      Height = 45
      Max = 255
      Position = 255
      TabOrder = 1
      Visible = False
      OnChange = trackAlphaChange
    end
  end
  object DataSource1: TDataSource
    DataSet = EzTable1
    OnDataChange = DataSource1DataChange
    Left = 200
    Top = 120
  end
  object EzTable1: TEzTable
    ReadOnly = True
    MaxRecords = 0
    UseDeleted = False
    Left = 200
    Top = 160
  end
end
