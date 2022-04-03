inherited KisMapScansView: TKisMapScansView
  Caption = ''
  ClientHeight = 344
  ClientWidth = 796
  ExplicitWidth = 812
  ExplicitHeight = 402
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter [0]
    Left = 378
    Top = 109
    Width = 6
    Height = 201
    Align = alRight
    ExplicitLeft = 419
    ExplicitHeight = 161
  end
  inherited ButtonsPanel: TPanel
    Top = 310
    Width = 796
    ExplicitTop = 310
    ExplicitWidth = 796
  end
  inherited Grid: TkaDBGrid
    Width = 378
    Height = 201
  end
  inherited ToolBar: TToolBar
    Width = 796
    ExplicitWidth = 796
  end
  inherited ToolBarNav: TToolBar
    Width = 796
    ExplicitWidth = 796
    inherited LabelSearchField: TLabel
      Caption = '   LabelSearchField'
    end
  end
  inherited ToolBarFilter: TToolBar
    Width = 796
    ExplicitWidth = 796
  end
  object PageControl1: TPageControl [6]
    Left = 384
    Top = 109
    Width = 412
    Height = 201
    ActivePage = TabSheet1
    Align = alRight
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = #1042#1099#1076#1072#1095#1072
      object tbOrders: TToolBar
        Left = 0
        Top = 0
        Width = 404
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 88
        Caption = 'tbOrders'
        ShowCaptions = True
        TabOrder = 0
        object tbConfirmOrder: TToolButton
          Left = 0
          Top = 0
          Caption = 'tbConfirmOrder'
          ImageIndex = 0
        end
        object ToolButton1: TToolButton
          Left = 88
          Top = 0
          Caption = 'ToolButton1'
          ImageIndex = 2
        end
        object tbRefreshOrders: TToolButton
          Left = 176
          Top = 0
          Caption = 'tbRefreshOrders'
          ImageIndex = 1
        end
        object tbSortGiveOuts: TToolButton
          Left = 264
          Top = 0
          Caption = 'tbSortGiveOuts'
          ImageIndex = 2
        end
      end
      object dbgScanOrders: TDBGrid
        Left = 0
        Top = 42
        Width = 404
        Height = 131
        Align = alClient
        PopupMenu = PopupMenu1
        TabOrder = 1
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnColEnter = dbgScanOrdersColEnter
        Columns = <
          item
            Expanded = False
            FieldName = 'ORDER_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ORDER_DATE'
            Title.Caption = #1044#1072#1090#1072
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CUSTOMER'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 120
            Visible = True
          end>
      end
      object ToolBar1: TToolBar
        Left = 0
        Top = 21
        Width = 404
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 8
        Caption = 'tbOrders'
        ShowCaptions = True
        TabOrder = 2
        object Label3: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 49
          Height = 21
          Margins.Top = 0
          Margins.Right = 0
          AutoSize = False
          Caption = '   '#1053#1072#1081#1090#1080
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object edLocateOrder: TEdit
          Left = 49
          Top = 0
          Width = 120
          Height = 21
          TabOrder = 0
          OnChange = edLocateOrderChange
        end
        object lLocateOrder: TLabel
          Left = 169
          Top = 0
          Width = 131
          Height = 21
          Hint = #1055#1086#1083#1077', '#1087#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#13#10#1080#1076#1077#1090' '#1085#1072#1074#1080#1075#1072#1094#1080#1103
          AutoSize = False
          Caption = '   LabelSearchField'
          Color = clMenu
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1088#1080#1105#1084
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object tbTakeBack: TToolBar
        Left = 0
        Top = 0
        Width = 404
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 100
        Caption = 'tbOrders'
        ShowCaptions = True
        TabOrder = 0
        object tbTakeBackOrder: TToolButton
          Left = 0
          Top = 0
          Caption = 'tbTakeBackOrder'
          ImageIndex = 0
        end
        object tbCopyFiles: TToolButton
          Left = 100
          Top = 0
          Caption = 'tbCopyFiles'
          ImageIndex = 2
        end
        object tbRefrefhTakeBake: TToolButton
          Left = 200
          Top = 0
          Caption = 'tbRefrefhTakeBake'
          ImageIndex = 1
        end
        object tbSortTakeBacks: TToolButton
          Left = 300
          Top = 0
          Caption = 'tbSortTakeBacks'
          ImageIndex = 2
        end
      end
      object dbgOrdersTakeBack: TDBGrid
        Left = 0
        Top = 42
        Width = 404
        Height = 131
        Align = alClient
        PopupMenu = PopupMenu2
        TabOrder = 1
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnColEnter = dbgOrdersTakeBackColEnter
        Columns = <
          item
            Expanded = False
            FieldName = 'ORDER_NUMBER'
            Title.Caption = #1053#1086#1084#1077#1088
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ORDER_DATE'
            Title.Caption = #1044#1072#1090#1072
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CUSTOMER'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 120
            Visible = True
          end>
      end
      object ToolBar2: TToolBar
        Left = 0
        Top = 21
        Width = 404
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 8
        Caption = 'tbOrders'
        ShowCaptions = True
        TabOrder = 2
        object Label4: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 49
          Height = 21
          Margins.Top = 0
          Margins.Right = 0
          AutoSize = False
          Caption = '   '#1053#1072#1081#1090#1080
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object edLocateTakeBack: TEdit
          Left = 49
          Top = 0
          Width = 120
          Height = 21
          TabOrder = 0
          OnChange = edLocateTakeBackChange
        end
        object lLocateTakeBack: TLabel
          Left = 169
          Top = 0
          Width = 131
          Height = 21
          Hint = #1055#1086#1083#1077', '#1087#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#13#10#1080#1076#1077#1090' '#1085#1072#1074#1080#1075#1072#1094#1080#1103
          AutoSize = False
          Caption = '   LabelSearchField'
          Color = clMenu
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
        end
      end
    end
  end
  inherited Legend: TkaLegend
    Items = <>
  end
  object PopupMenu1: TPopupMenu
    Left = 512
    Top = 232
  end
  object PopupMenu2: TPopupMenu
    Left = 584
    Top = 232
  end
end
