object frmReproject: TfrmReproject
  Left = 196
  Top = 154
  Caption = 'Reproject'
  ClientHeight = 470
  ClientWidth = 762
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 439
    Width = 762
    Height = 31
    Align = alBottom
    TabOrder = 0
    object BtnNext: TButton
      Left = 191
      Top = 7
      Width = 82
      Height = 20
      Caption = '&Next >>'
      TabOrder = 0
      OnClick = BtnNextClick
    end
    object BtnPrevious: TButton
      Left = 103
      Top = 7
      Width = 82
      Height = 20
      Caption = '<< &Previous'
      Enabled = False
      TabOrder = 1
      OnClick = BtnPreviousClick
    end
    object BtnConvert: TButton
      Left = 279
      Top = 7
      Width = 82
      Height = 20
      Caption = '&Convert'
      Enabled = False
      TabOrder = 2
      OnClick = BtnConvertClick
    end
    object Button6: TButton
      Left = 375
      Top = 7
      Width = 82
      Height = 20
      Caption = '&Exit'
      TabOrder = 3
      OnClick = BtnExitClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 762
    Height = 439
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Source'
      object Label3: TLabel
        Left = 260
        Top = 104
        Width = 109
        Height = 13
        Caption = 'Projection Parameters :'
      end
      object Label4: TLabel
        Left = 263
        Top = 357
        Width = 84
        Height = 13
        Caption = 'Projection Name :'
      end
      object LblProjName: TLabel
        Left = 361
        Top = 357
        Width = 60
        Height = 13
        Caption = 'LblProjName'
      end
      object Label5: TLabel
        Left = 263
        Top = 374
        Width = 44
        Height = 13
        Caption = 'Ellipsoid :'
      end
      object LblProjEllipsoid: TLabel
        Left = 361
        Top = 374
        Width = 70
        Height = 13
        Caption = 'LblProjEllipsoid'
      end
      object Label6: TLabel
        Left = 263
        Top = 390
        Width = 30
        Height = 13
        Caption = 'Units :'
      end
      object LblProjUnits: TLabel
        Left = 361
        Top = 390
        Width = 56
        Height = 13
        Caption = 'LblProjUnits'
      end
      object Label10: TLabel
        Left = 260
        Top = 49
        Width = 94
        Height = 13
        Caption = '&Coordinate System :'
      end
      object Label12: TLabel
        Left = 260
        Top = 75
        Width = 89
        Height = 13
        Caption = 'Coordinates &Units :'
      end
      object Label1: TLabel
        Left = 10
        Top = 39
        Width = 88
        Height = 13
        Caption = '&Layers to convert :'
      end
      object Memo1: TMemo
        Left = 260
        Top = 127
        Width = 251
        Height = 225
        Color = clSilver
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Button1: TButton
        Left = 377
        Top = 98
        Width = 232
        Height = 23
        Caption = '&Define Source Layer Projection Parameters...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object CboCoordSystem: TComboBox
        Left = 364
        Top = 46
        Width = 167
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnClick = CboCoordSystemClick
        Items.Strings = (
          'Cartesian (Non Earth)'
          'Latitude/Longitude'
          'Projection')
      end
      object CboCoordsUnits: TComboBox
        Left = 364
        Top = 72
        Width = 167
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
      end
      object CheckListBox1: TCheckListBox
        Left = 7
        Top = 55
        Width = 244
        Height = 297
        ItemHeight = 13
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Destination'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 7
        Top = 7
        Width = 84
        Height = 13
        Caption = 'Destination &Path :'
      end
      object SpeedButton1: TSpeedButton
        Left = 426
        Top = 16
        Width = 23
        Height = 24
        Glyph.Data = {
          42020000424D4202000000000000420000002800000010000000100000000100
          1000030000000002000000000000000000000000000000000000007C0000E003
          00001F0000001863186318631863186318631863186318631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          1863186318630000000000000000000000000000000000000000000018631863
          1863186318630000000000420042004200420042004200420042004200001863
          1863186318630000E07F00000042004200420042004200420042004200420000
          1863186318630000FF7FE07F0000004200420042004200420042004200420042
          0000186318630000E07FFF7FE07F000000420042004200420042004200420042
          0042000018630000FF7FE07FFF7FE07F00000000000000000000000000000000
          0000000000000000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F000018631863
          1863186318630000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F000018631863
          1863186318630000E07FFF7FE07F000000000000000000000000000018631863
          1863186318631863000000000000186318631863186318631863186318630000
          0000000018631863186318631863186318631863186318631863186318631863
          0000000018631863186318631863186318631863186300001863186318630000
          1863000018631863186318631863186318631863186318630000000000001863
          1863186318631863186318631863186318631863186318631863186318631863
          186318631863}
        OnClick = SpeedButton1Click
      end
      object Label8: TLabel
        Left = 7
        Top = 104
        Width = 109
        Height = 13
        Caption = 'Projection Parameters :'
      end
      object Label9: TLabel
        Left = 10
        Top = 357
        Width = 84
        Height = 13
        Caption = 'Projection Name :'
      end
      object DestLblProjName: TLabel
        Left = 107
        Top = 357
        Width = 60
        Height = 13
        Caption = 'LblProjName'
      end
      object Label11: TLabel
        Left = 10
        Top = 374
        Width = 44
        Height = 13
        Caption = 'Ellipsoid :'
      end
      object DestLblProjEllipsoid: TLabel
        Left = 107
        Top = 374
        Width = 70
        Height = 13
        Caption = 'LblProjEllipsoid'
      end
      object Label13: TLabel
        Left = 10
        Top = 393
        Width = 30
        Height = 13
        Caption = 'Units :'
      end
      object DestLblProjUnits: TLabel
        Left = 107
        Top = 393
        Width = 56
        Height = 13
        Caption = 'LblProjUnits'
      end
      object Label14: TLabel
        Left = 7
        Top = 49
        Width = 94
        Height = 13
        Caption = '&Coordinate System :'
      end
      object Label16: TLabel
        Left = 7
        Top = 75
        Width = 89
        Height = 13
        Caption = 'Coordinates &Units :'
      end
      object Edit2: TEdit
        Left = 7
        Top = 20
        Width = 413
        Height = 24
        TabOrder = 0
      end
      object Memo2: TMemo
        Left = 7
        Top = 127
        Width = 251
        Height = 225
        Color = clSilver
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Button2: TButton
        Left = 176
        Top = 98
        Width = 273
        Height = 23
        Caption = '&Define Destination Layer Projection Parameters...'
        TabOrder = 2
        OnClick = Button2Click
      end
      object CboDestCoordSystem: TComboBox
        Left = 111
        Top = 46
        Width = 166
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 3
        OnClick = CboDestCoordSystemClick
        Items.Strings = (
          'Cartesian (Non Earth)'
          'Latitude/Longitude'
          'Projection')
      end
      object CboDestCoordsUnits: TComboBox
        Left = 111
        Top = 72
        Width = 166
        Height = 24
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Conversion'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 0
        Top = 0
        Width = 508
        Height = 52
        Align = alTop
        Caption = 
          'You are now ready to convert the layer from one coordinate syste' +
          'm to another.'#13#10'In order to start the transformation, press the "' +
          'Convert" button, or if you changed your mind, press the "Exit" b' +
          'utton.'#13#10'We strongly recommend first you back up your information' +
          ' before proceeding.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object ProgressBar1: TProgressBar
        Left = 4
        Top = 52
        Width = 357
        Height = 17
        TabOrder = 0
      end
    end
  end
  object DestinGis: TEzGIS
    Active = False
    LayersSubdir = 'C:\D5\Bin\'
    Left = 576
    Top = 228
  end
  object Projector1: TEzProjector
    Params.Strings = (
      'proj=utm'
      'ellps=WGS84'
      'units=m'
      'zone=12')
    Left = 124
    Top = 207
  end
  object Projector2: TEzProjector
    Params.Strings = (
      'proj=utm'
      'ellps=WGS84'
      'units=m'
      'zone=12')
    Left = 580
    Top = 199
  end
end
