object mstMPLineColorsDialog: TmstMPLineColorsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1094#1074#1077#1090#1072' '#1083#1080#1085#1080#1081
  ClientHeight = 430
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    444
    430)
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 242
    Top = 397
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080' '#1074#1099#1081#1090#1080
    ModalResult = 1
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 428
    Height = 383
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1062#1074#1077#1090#1072
      DesignSize = (
        420
        355)
      object Label1: TLabel
        Left = 145
        Top = 330
        Width = 141
        Height = 13
        Caption = #1058#1086#1083#1097#1080#1085#1072' '#1083#1080#1085#1080#1080' '#1074' '#1087#1080#1082#1089#1077#1083#1103#1093':'
      end
      object dbgLines: TkaDBGrid
        Left = 3
        Top = 3
        Width = 336
        Height = 318
        Anchors = [akLeft, akTop, akRight, akBottom]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellColors = dbgLinesCellColors
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = #1057#1083#1086#1081
            Width = 190
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IS_GROUP'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'GROUP_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'LINE_COLOR'
            Title.Caption = #1062#1074#1077#1090
            Visible = True
          end>
      end
      object btnEdit: TButton
        Left = 342
        Top = 3
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
        TabOrder = 1
        OnClick = btnEditClick
      end
      object edLineWidth: TSpinEdit
        Left = 292
        Top = 327
        Width = 47
        Height = 22
        MaxValue = 20
        MinValue = 1
        TabOrder = 2
        Value = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1054#1082#1072#1085#1090#1086#1074#1082#1072
      ImageIndex = 1
      DesignSize = (
        420
        355)
      object Label2: TLabel
        Left = 121
        Top = 330
        Width = 165
        Height = 13
        Caption = #1058#1086#1083#1097#1080#1085#1072' '#1086#1082#1072#1085#1090#1086#1074#1082#1080' '#1074' '#1087#1080#1082#1089#1077#1083#1103#1093':'
      end
      object dbgEdging: TkaDBGrid
        Left = 3
        Top = 3
        Width = 336
        Height = 318
        Anchors = [akLeft, akTop, akRight, akBottom]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = dbgEdgingCellClick
        OnKeyPress = dbgEdgingKeyPress
        OnCellColors = dbgEdgingCellColors
        OnGetLogicalValue = dbgEdgingGetLogicalValue
        OnLogicalColumn = dbgEdgingLogicalColumn
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            Width = 170
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'HAS_BACKCOLOR'
            Title.Caption = #1054#1082#1072#1085#1090#1086#1074#1082#1072
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BACKCOLOR'
            Title.Caption = #1062#1074#1077#1090
            Visible = True
          end>
      end
      object Button2: TButton
        Left = 342
        Top = 3
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
        TabOrder = 1
        OnClick = Button2Click
      end
      object edEdgingWidth: TSpinEdit
        Left = 292
        Top = 327
        Width = 47
        Height = 22
        MaxValue = 20
        MinValue = 1
        TabOrder = 2
        Value = 0
      end
    end
  end
  object Button1: TButton
    Left = 361
    Top = 397
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
