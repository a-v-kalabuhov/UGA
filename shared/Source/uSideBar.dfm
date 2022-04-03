object SideBar: TSideBar
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  OnResize = FrameResize
  object BarControlButton: TSpeedButton
    Left = 64
    Top = 32
    Width = 23
    Height = 22
    Flat = True
    OnClick = BarControlButtonClick
  end
  object BarPanel: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
end
