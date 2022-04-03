inherited KisLettersView: TKisLettersView
  Left = 253
  Top = 205
  Caption = ''
  OnCreate = FormCreate
  ExplicitWidth = 627
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter [0]
    Left = 419
    Top = 123
    Width = 9
    Height = 82
    Align = alRight
    ExplicitTop = 109
    ExplicitHeight = 169
  end
  object Splitter1: TSplitter [1]
    Left = 0
    Top = 205
    Width = 619
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 109
    ExplicitWidth = 99
  end
  inherited ButtonsPanel: TPanel
    inherited Button1: TButton
      Left = 453
      Top = 6
      Width = 75
      Height = 25
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
      ExplicitLeft = 534
      ExplicitTop = 6
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
  inherited Grid: TkaDBGrid
    Top = 123
    Width = 419
    Height = 82
  end
  inherited ToolBar: TToolBar
    Height = 23
    ExplicitHeight = 23
  end
  object dbgCandidates: TDBGrid [5]
    Left = 428
    Top = 123
    Width = 191
    Height = 82
    Align = alRight
    TabOrder = 5
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  inherited ToolBarNav: TToolBar
    Top = 69
    DrawingStyle = dsGradient
    List = True
    ExplicitTop = 69
    inherited labNavigator: TLabel
      Caption = '   '#1053#1072#1074#1080#1075#1072#1094#1080#1103'   '
    end
    inherited LabelSearchField: TLabel
      AlignWithMargins = True
    end
    inherited NavButtonsPanel: TPanel
      Width = 31
      ExplicitWidth = 31
    end
  end
  inherited ToolBarFilter: TToolBar
    Top = 96
    DrawingStyle = dsGradient
    ExplicitTop = 96
    inherited Label2: TLabel
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Caption = '  '#1060#1080#1083#1100#1090#1088#1072#1094#1080#1103
    end
    inherited Label1: TLabel
      Caption = '  '#1055#1086' '#1087#1086#1083#1102
    end
    inherited ToolButton5: TToolButton
      Indeterminate = True
      Style = tbsDivider
    end
    inherited cbSetFilter: TCheckBox
      AlignWithMargins = True
      Margins.Left = 5
      Align = alLeft
    end
    object Label3: TLabel
      Left = 456
      Top = 0
      Width = 5
      Height = 21
      AutoSize = False
    end
  end
  object dbgOrders: TkaDBGrid [8]
    Left = 0
    Top = 208
    Width = 619
    Height = 62
    Align = alBottom
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 6
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object tbOffices: TToolBar [9]
    Left = 0
    Top = 23
    Width = 619
    Height = 23
    ButtonHeight = 21
    DrawingStyle = dsGradient
    TabOrder = 7
    object ToolButton6: TToolButton
      Left = 0
      Top = 0
      Width = 16
      Caption = 'ToolButton6'
      Style = tbsSeparator
    end
    object Label5: TLabel
      Left = 16
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
      Left = 95
      Top = 0
      Width = 450
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object tbFilters: TToolBar [10]
    Left = 0
    Top = 46
    Width = 619
    Height = 23
    ButtonHeight = 21
    DrawingStyle = dsGradient
    TabOrder = 8
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
