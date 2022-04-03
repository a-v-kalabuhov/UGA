object KisMngrView: TKisMngrView
  Left = 290
  Top = 207
  Caption = 'KisMngrView'
  ClientHeight = 304
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonsPanel: TPanel
    Left = 0
    Top = 270
    Width = 619
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    OnResize = ButtonsPanelResize
    object Button1: TButton
      Left = 454
      Top = 7
      Width = 66
      Height = 22
      Caption = #1054#1050
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 542
      Top = 7
      Width = 66
      Height = 22
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Grid: TkaDBGrid
    Left = 0
    Top = 109
    Width = 619
    Height = 161
    Align = alClient
    DefaultDrawing = False
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = RUSSIAN_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyDown = GridKeyDown
    OnKeyPress = GridKeyPress
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 619
    Height = 55
    AutoSize = True
    ButtonHeight = 23
    Caption = 'ToolBar'
    TabOrder = 2
  end
  object ToolBarNav: TToolBar
    Left = 0
    Top = 55
    Width = 619
    Height = 27
    ButtonHeight = 21
    Caption = 'ToolBarNav'
    TabOrder = 3
    Visible = False
    object labNavigator: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 79
      Height = 21
      Margins.Top = 0
      Margins.Right = 0
      AutoSize = False
      Caption = '   '#1053#1072#1074#1080#1075#1072#1094#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object edSearch: TEdit
      Left = 79
      Top = 0
      Width = 90
      Height = 21
      TabOrder = 0
      OnChange = edSearchChange
    end
    object LabelSearchField: TLabel
      Left = 169
      Top = 0
      Width = 131
      Height = 21
      Hint = #1055#1086#1083#1077', '#1087#1086' '#1082#1086#1090#1086#1088#1086#1084#1091' '#13#10#1080#1076#1077#1090' '#1085#1072#1074#1080#1075#1072#1094#1080#1103
      AutoSize = False
      Caption = 'LabelSearchField'
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
    object NavButtonsPanel: TPanel
      Left = 300
      Top = 0
      Width = 117
      Height = 21
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object ToolBarFilter: TToolBar
    Left = 0
    Top = 82
    Width = 619
    Height = 27
    ButtonHeight = 21
    Caption = 'ToolBarFilter'
    TabOrder = 4
    Visible = False
    object Label2: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 79
      Height = 21
      AutoSize = False
      Caption = '   '#1060#1080#1083#1100#1090#1088#1072#1094#1080#1103
      Layout = tlCenter
    end
    object edFilter: TEdit
      Left = 79
      Top = 0
      Width = 90
      Height = 21
      TabOrder = 2
      OnChange = edSearchChange
    end
    object Label1: TLabel
      Left = 169
      Top = 0
      Width = 57
      Height = 21
      Alignment = taCenter
      AutoSize = False
      Caption = ' '#1055#1086' '#1087#1086#1083#1102
      Layout = tlCenter
    end
    object cbFilterFields: TComboBox
      Left = 226
      Top = 0
      Width = 150
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object ToolButton5: TToolButton
      Left = 376
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object cbSetFilter: TCheckBox
      Left = 384
      Top = 0
      Width = 72
      Height = 21
      Caption = #1042#1082#1083'/'#1074#1099#1082#1083
      TabOrder = 1
    end
  end
  object MainMenu: TMainMenu
    Left = 248
    Top = 128
    object N1: TMenuItem
      Caption = #1042#1080#1076
      GroupIndex = 4
      object miBigBtns: TMenuItem
        Caption = #1041#1086#1083#1100#1096#1080#1077' '#1082#1085#1086#1087#1082#1080
        ShortCut = 16450
        OnClick = miBigBtnsClick
      end
    end
  end
  object Legend: TkaLegend
    ItemOffset = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = #1051#1077#1075#1077#1085#1076#1072
    Items = <>
    Left = 288
    Top = 128
    Items = <>
  end
end
