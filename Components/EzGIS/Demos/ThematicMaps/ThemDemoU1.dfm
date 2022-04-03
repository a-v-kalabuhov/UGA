object Form1: TForm1
  Left = 192
  Top = 147
  Width = 734
  Height = 532
  Caption = 'EzGis New Thematic Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object drawbox: TEzDrawBox
    Left = 0
    Top = 0
    Width = 594
    Height = 461
    Align = alClient
    TabOrder = 0
    About = 'EzGIS Version 1.85.2 (Nov, 2002)'
    GIS = Gis1
    NoPickFilter = []
    SnapToGuidelinesDist = 1
    ScreenGrid.Step.X = 1
    ScreenGrid.Step.Y = 1
    ShowMapExtents = False
    ShowLayerExtents = False
    GridInfo.Grid.X = 1
    GridInfo.Grid.Y = 1
    GridInfo.GridColor = clMaroon
    GridInfo.DrawAsCross = True
    GridInfo.GridSnap.X = 0.5
    GridInfo.GridSnap.Y = 0.5
    RubberPen.Color = clRed
    RubberPen.Mode = pmXor
    FlatScrollBar = False
  end
  object CmdLine1: TEzCmdLine
    Left = 0
    Top = 461
    Width = 726
    Height = 31
    About = 'EzGIS Version 1.85.2 (Nov, 2002)'
    DrawBoxList = <
      item
        DrawBox = drawbox
        Current = True
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    Color = clWhite
    Align = alBottom
    TabOrder = 1
    TabStop = False
  end
  object Panel1: TPanel
    Left = 594
    Top = 0
    Width = 132
    Height = 461
    Align = alRight
    TabOrder = 2
    object Image1: TImage
      Left = 47
      Top = 37
      Width = 32
      Height = 16
      AutoSize = True
      Picture.Data = {
        07544269746D617076010000424D760100000000000076000000280000002000
        000010000000010004000000000000010000120B0000120B0000100000000000
        0000000000000000800000800000008080008000000080008000808000007F7F
        7F00BFBFBF000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF003333333333333333333333FFFFF3333333333700073333333FFF3777773F
        3FFF00030990BB03000077737337F373777733309990BBB0333333373337F337
        3F3333099990BBBB033333733337F33373F337999990BBBBB73337F33337F333
        37F330999990BBBBB03337F33337FFFFF7F3309999900000003337F333377777
        77F33099990A0CCCC03337F3337373F337F3379990AAA0CCC733373F3733373F
        373333090AAAAA0C033333737333337373333330AAAAAAA033333FF73F333337
        33FF00330AAAAA033000773373FFFF7337773333370007333333333337777733
        3333333333333333333333333333333333333333333333333333333333333333
        3333}
      Transparent = True
    end
    object Image2: TImage
      Left = 49
      Top = 219
      Width = 32
      Height = 16
      AutoSize = True
      Picture.Data = {
        07544269746D617076010000424D760100000000000076000000280000002000
        000010000000010004000000000000010000120B0000120B0000100000000000
        0000000000000000800000800000008080008000000080008000808000007F7F
        7F00BFBFBF000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF003333000300030003333377737773777333333333333333333FFFFFFFFFFF
        FFFF7700000000000000777777777777777733039993BBB3CCC3337F737F737F
        737F37039993BBB3CCC3377F737F737F737F33039993BBB3CCC33F7F737F737F
        737F77079997BBB7CCC77777737773777377330399930003CCC3337F737F7773
        737F370399933333CCC3377F737F3333737F330399933333CCC33F7F737FFFFF
        737F770700077777CCC77777777777777377330333333333CCC3337F33333333
        737F3703333333330003377F33333333777333033333333333333F7FFFFFFFFF
        FFFF770777777777777777777777777777773333333333333333333333333333
        3333}
      Transparent = True
    end
    object Button4: TButton
      Left = 15
      Top = 283
      Width = 107
      Height = 31
      Caption = 'Change Color'
      TabOrder = 0
      OnClick = Button4Click
    end
    object Button1: TButton
      Left = 15
      Top = 246
      Width = 107
      Height = 31
      Caption = 'BarChart Draw'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 15
      Top = 101
      Width = 107
      Height = 31
      Caption = 'Change Color'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 15
      Top = 64
      Width = 107
      Height = 31
      Caption = 'PieChart Draw'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button5: TButton
      Left = 15
      Top = 140
      Width = 107
      Height = 31
      Caption = 'Animate!'
      TabOrder = 4
      OnClick = Button5Click
    end
  end
  object Gis1: TEzGIS
    Active = False
    LayersSubdir = 'C:\D5\Bin\'
    About = 'EzGIS Version 1.85.2 (Nov, 2002)'
    Left = 312
    Top = 78
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 280
    Top = 78
  end
end
