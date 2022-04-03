object frmNewLayer: TfrmNewLayer
  Left = 196
  Top = 111
  Caption = 'New Layer'
  ClientHeight = 381
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 233
    Height = 13
    Caption = '&Name (without path and must begin with a letter) :'
    FocusControl = Edit1
  end
  object BtnAddFlds: TSpeedButton
    Left = 10
    Top = 98
    Width = 212
    Height = 23
    Caption = '&Populate Fields From a DBF...'
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
    OnClick = BtnAddFldsClick
  end
  object Edit1: TEdit
    Left = 10
    Top = 26
    Width = 283
    Height = 21
    TabOrder = 0
  end
  object chkAnimated: TCheckBox
    Left = 10
    Top = 55
    Width = 131
    Height = 14
    Caption = '&Animated Layer'
    TabOrder = 1
  end
  object chkCosmethic: TCheckBox
    Left = 10
    Top = 78
    Width = 131
    Height = 14
    Caption = '&Cosmethic Layer'
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 127
    Width = 343
    Height = 147
    Caption = '&Fields'
    TabOrder = 3
    object DBNavigator1: TDBNavigator
      Left = 2
      Top = 15
      Width = 339
      Height = 25
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
      Align = alTop
      Flat = True
      TabOrder = 0
    end
    object DBGrid2: TDBGrid
      Left = 2
      Top = 40
      Width = 339
      Height = 105
      Align = alClient
      DataSource = DataSource1
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'FIELDNAME'
          Title.Caption = 'Field Name'
          Width = 116
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TYPE'
          PickList.Strings = (
            'C - CHARACTER'
            'L - LOGICAL'
            'D - DATE'
            'N - NUMERIC'
            'M - MEMO'
            'B - BINARY'
            'G - GRAPHIC')
          Title.Caption = 'Type'
          Width = 88
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SIZE'
          Title.Caption = 'Size'
          Width = 56
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DEC'
          Title.Caption = 'Dec'
          Width = 40
          Visible = True
        end>
    end
  end
  object Button1: TButton
    Left = 116
    Top = 283
    Width = 60
    Height = 20
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 283
    Width = 61
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object DataSource1: TDataSource
    Left = 252
    Top = 264
  end
end
