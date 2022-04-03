object frmDemoBrowse: TfrmDemoBrowse
  Left = 193
  Top = 88
  ClientHeight = 442
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 375
    Height = 70
    AutoSize = True
    BorderWidth = 1
    ButtonHeight = 29
    ButtonWidth = 47
    ShowCaptions = True
    TabOrder = 0
    object Edit1: TToolButton
      Left = 0
      Top = 0
      Caption = '&Edit'
      Style = tbsDropDown
      OnClick = Edit1Click
    end
    object ToolButton1: TToolButton
      Left = 62
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object Display1: TToolButton
      Left = 70
      Top = 0
      Caption = '&Display'
      ImageIndex = 0
      OnClick = Display1Click
    end
    object Flash1: TToolButton
      Left = 117
      Top = 0
      Caption = '&Blink'
      ImageIndex = 1
      OnClick = Flash1Click
    end
    object ToolButton2: TToolButton
      Left = 164
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object CboLayers: TComboBox
      Left = 172
      Top = 0
      Width = 118
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = CboLayersChange
    end
    object ToolButton3: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 3
      Wrap = True
      Style = tbsSeparator
    end
    object Extents1: TCheckBox
      Left = 0
      Top = 37
      Width = 125
      Height = 29
      Caption = '&Zoom to extents'
      TabOrder = 0
    end
    object AutoView1: TCheckBox
      Left = 125
      Top = 37
      Width = 104
      Height = 29
      Caption = '&Auto display'
      TabOrder = 1
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 423
    Width = 375
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 70
    Width = 375
    Height = 353
    Align = alClient
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -10
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
  end
  object DataSource1: TDataSource
    DataSet = EzTable1
    OnDataChange = DataSource1DataChange
    Left = 212
    Top = 188
  end
  object EditMenu: TPopupMenu
    Left = 168
    Top = 112
    object Undelete1: TMenuItem
      Caption = '&Undelete'
      OnClick = Undelete1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ToggleSelection1: TMenuItem
      Caption = '&Toggle Selection'
      OnClick = ToggleSelection1Click
    end
    object AddtoSelection1: TMenuItem
      Caption = 'Add to &Selection'
      OnClick = AddtoSelection1Click
    end
  end
  object EzTable1: TEzTable
    MaxRecords = 0
    Left = 244
    Top = 188
  end
end
