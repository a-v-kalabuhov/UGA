inherited KisOfficeDocsView: TKisOfficeDocsView
  Caption = 'KisOfficeDocsView'
  ExplicitWidth = 627
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited ButtonsPanel: TPanel
    inherited Button1: TButton
      Left = 453
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      ExplicitLeft = 453
      ExplicitTop = 6
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
    inherited Button2: TButton
      Left = 534
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      ExplicitLeft = 534
      ExplicitTop = 6
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
  inherited Grid: TkaDBGrid
    Top = 136
    Height = 134
  end
  inherited ToolBarNav: TToolBar
    Top = 82
    DrawingStyle = dsGradient
    ExplicitTop = 82
  end
  inherited ToolBarFilter: TToolBar
    Top = 109
    DrawingStyle = dsGradient
    ExplicitTop = 109
  end
  object tbOffices: TToolBar [5]
    Left = 0
    Top = 55
    Width = 619
    Height = 27
    ButtonHeight = 21
    DrawingStyle = dsGradient
    TabOrder = 5
    object Label5: TLabel
      Left = 0
      Top = 0
      Width = 79
      Height = 21
      AutoSize = False
      Caption = '   '#1054#1090#1076#1077#1083
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object cbOffice: TComboBox
      Left = 79
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
