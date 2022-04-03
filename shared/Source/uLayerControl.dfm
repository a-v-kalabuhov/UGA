object LayerControlFrame: TLayerControlFrame
  Left = 0
  Top = 0
  Width = 163
  Height = 25
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  OnResize = FrameResize
  object lName: TLabel
    Left = 8
    Top = 8
    Width = 121
    Height = 13
    AutoSize = False
    Caption = 'lName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lNameClick
  end
  object Button: TSpeedButton
    Left = 136
    Top = 2
    Width = 23
    Height = 22
    Flat = True
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F22222222222
      2222FFA2A2A2A2A2A2A2FAAAAAAAAAAAAAA2FFAAAAAAAAAAAA22FAAAAAAAAAAA
      AAA2FFAAAAAAAAAAAA22FAAAAAAAAAAAAAA2FFAAAAAAAAAAAA22FAAAAAAAAAAA
      AAA2FFAAAAAAAAAAAA22FAAAAAAAAAAAAAA2FFAAAAAAAAAAAA22FAAAAAAAAAAA
      AAA2FFAAAAAAAAAAAA22FAAFAFAFAFAFAFA2FFFFFFFFFFFFFFF2}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClick
  end
end
