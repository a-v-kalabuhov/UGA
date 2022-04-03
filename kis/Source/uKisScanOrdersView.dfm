inherited KisScanOrdersView: TKisScanOrdersView
  Caption = 'KisScanOrdersView'
  OnCreate = FormCreate
  ExplicitWidth = 635
  ExplicitHeight = 362
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TkaDBGrid
    Top = 132
    Height = 138
  end
  inherited ToolBarNav: TToolBar
    Top = 78
    ExplicitTop = 78
    object ToolButton1: TToolButton
      Left = 417
      Top = 0
      Width = 16
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
  end
  inherited ToolBarFilter: TToolBar
    Top = 105
    ExplicitTop = 105
    inherited ToolButton5: TToolButton
      Width = 16
      ExplicitWidth = 16
    end
    inherited cbSetFilter: TCheckBox
      Left = 392
      ExplicitLeft = 392
    end
    object ToolButton3: TToolButton
      Left = 464
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 1
      Style = tbsSeparator
    end
  end
  object tbFilters: TToolBar [5]
    Left = 0
    Top = 55
    Width = 619
    Height = 23
    ButtonHeight = 21
    DrawingStyle = dsGradient
    TabOrder = 5
    object ToolButton2: TToolButton
      Left = 0
      Top = 0
      Width = 16
      Caption = 'ToolButton6'
      Style = tbsSeparator
    end
    object Label4: TLabel
      Left = 16
      Top = 0
      Width = 79
      Height = 21
      AutoSize = False
      Caption = '   '#1055#1086#1082#1072#1079#1099#1074#1072#1090#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object cbDateFilter: TComboBox
      Left = 95
      Top = 0
      Width = 450
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  inherited Legend: TkaLegend
    Items = <>
  end
end
