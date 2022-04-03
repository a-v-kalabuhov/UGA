inherited KisMapsMngrView: TKisMapsMngrView
  Left = 279
  Caption = 'KisMapsMngrView'
  ClientHeight = 318
  ClientWidth = 623
  ExplicitWidth = 631
  ExplicitHeight = 372
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 432
    Top = 109
    Width = 6
    Height = 175
    Align = alRight
    ExplicitLeft = 435
  end
  inherited ButtonsPanel: TPanel
    Top = 284
    Width = 623
    ExplicitTop = 284
    ExplicitWidth = 623
    inherited Button1: TButton
      Left = 458
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      ExplicitLeft = 458
      ExplicitTop = 4
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
    inherited Button2: TButton
      Left = 539
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      ExplicitLeft = 539
      ExplicitTop = 4
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
  inherited Grid: TkaDBGrid
    Width = 432
    Height = 175
  end
  inherited ToolBar: TToolBar
    Width = 623
    ExplicitWidth = 623
  end
  inherited ToolBarNav: TToolBar
    Width = 623
    ExplicitWidth = 623
  end
  inherited ToolBarFilter: TToolBar
    Width = 623
    ExplicitWidth = 623
  end
  object gbGiving: TGroupBox [6]
    Left = 438
    Top = 109
    Width = 185
    Height = 175
    Align = alRight
    Caption = #1042#1099#1076#1072#1095#1072'-'#1087#1088#1080#1077#1084
    TabOrder = 5
    object dbgGiving: TkaDBGrid
      Left = 2
      Top = 66
      Width = 181
      Height = 107
      Align = alClient
      TabOrder = 0
      TitleFont.Charset = RUSSIAN_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'NOMENCLATURE'
          Title.Caption = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
          Width = 149
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RECIPIENT'
          Title.Caption = #1043#1076#1077
          Visible = True
        end>
    end
    object tbMassGiving: TToolBar
      Left = 2
      Top = 15
      Width = 181
      Height = 51
      ButtonHeight = 44
      ShowCaptions = True
      TabOrder = 1
    end
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
