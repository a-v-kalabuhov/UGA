inherited KisDecreeProjectsView: TKisDecreeProjectsView
  Left = 76
  Top = 198
  Caption = 'KisDecreePrjsView'
  ClientHeight = 310
  ClientWidth = 628
  ExplicitWidth = 636
  ExplicitHeight = 364
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 357
    Top = 109
    Width = 6
    Height = 167
    Align = alRight
    ExplicitLeft = 360
  end
  inherited ButtonsPanel: TPanel
    Top = 276
    Width = 628
    ExplicitTop = 276
    ExplicitWidth = 628
    inherited Button1: TButton
      Top = 6
      Width = 75
      Height = 25
      Default = True
      ExplicitTop = 6
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
    inherited Button2: TButton
      Left = 535
      Top = 6
      Width = 75
      Height = 25
      ExplicitLeft = 535
      ExplicitTop = 6
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
  inherited Grid: TkaDBGrid
    Width = 357
    Height = 167
  end
  inherited ToolBar: TToolBar
    Width = 628
    ExplicitWidth = 628
  end
  inherited ToolBarNav: TToolBar
    Width = 628
    ExplicitWidth = 628
    inherited labNavigator: TLabel
      Caption = '   '#1053#1072#1074#1080#1075#1072#1094#1080#1103'   '
    end
  end
  inherited ToolBarFilter: TToolBar
    Width = 628
    ExplicitWidth = 628
  end
  object dbgTemp: TkaDBGrid [6]
    Left = 363
    Top = 109
    Width = 265
    Height = 167
    Align = alRight
    TabOrder = 5
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'INITIAL_NAME'
        Title.Caption = #1054#1090
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SHORT_NAME'
        Title.Caption = #1054#1090#1076#1077#1083
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1055#1077#1088#1077#1076#1072#1085
        Width = 60
        Visible = True
      end>
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
