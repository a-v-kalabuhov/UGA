object frmViews: TfrmViews
  Left = 254
  Top = 235
  BorderStyle = bsDialog
  Caption = 'Views Control'
  ClientHeight = 282
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object BtnUp: TSpeedButton
    Left = 299
    Top = 103
    Width = 31
    Height = 30
    Hint = 'Sube un nivel'
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333337777733333333334444473333333333CCCC473
      333333333CCCC473333333333CCCC473333333333CCCC473333333333CCCC477
      7333333CCCCCCCCC33333333CCCCCCC3333333333CCCCC333333333333CCC333
      33333333333C3333333333333333333333333333333333333333}
    OnClick = BtnUpClick
  end
  object BtnDown: TSpeedButton
    Left = 298
    Top = 135
    Width = 32
    Height = 30
    Hint = 'Baja un nivel'
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333733333333333333477333333333333CC4773333333333CCCC477
      33333333CCCCCC477333333CCCCCC444333333333CCCC473333333333CCCC473
      333333333CCCC473333333333CCCC473333333333CCCC473333333333CCCC433
      3333333333333333333333333333333333333333333333333333}
    OnClick = BtnDownClick
  end
  object Label1: TLabel
    Left = 14
    Top = 14
    Width = 36
    Height = 16
    Caption = '&Views'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 15
    Top = 212
    Width = 70
    Height = 27
    Caption = '&Restore'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 89
    Top = 212
    Width = 70
    Height = 27
    Caption = '&New'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 162
    Top = 212
    Width = 71
    Height = 27
    Caption = '&Delete'
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 236
    Top = 212
    Width = 90
    Height = 27
    Caption = 'Descrip&tion'
    OnClick = SpeedButton4Click
  end
  object SpeedButton5: TSpeedButton
    Left = 162
    Top = 241
    Width = 164
    Height = 27
    Caption = '&Set As Clip Boundary'
    OnClick = SpeedButton5Click
  end
  object List1: TListBox
    Left = 15
    Top = 34
    Width = 277
    Height = 169
    ItemHeight = 16
    TabOrder = 0
    OnClick = List1Click
  end
  object Check1: TCheckBox
    Left = 15
    Top = 246
    Width = 119
    Height = 21
    Caption = '&Auto Restore'
    TabOrder = 1
    OnClick = Check1Click
  end
  object PopupMenu1: TPopupMenu
    Left = 92
    Top = 144
    object Current2: TMenuItem
      Caption = 'From Current &Display'
      ShortCut = 113
      OnClick = Current2Click
    end
    object Define1: TMenuItem
      Caption = 'Define &Window'
      ShortCut = 114
      OnClick = Define1Click
    end
  end
end
