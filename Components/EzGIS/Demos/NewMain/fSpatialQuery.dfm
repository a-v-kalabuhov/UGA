object frmSpatialQuery: TfrmSpatialQuery
  Left = 59
  Top = 166
  Caption = 'Spatial Query'
  ClientHeight = 334
  ClientWidth = 914
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 297
    Top = 50
    Width = 4
    Height = 284
    ExplicitHeight = 220
  end
  object Splitter2: TSplitter
    Left = 443
    Top = 50
    Width = 4
    Height = 284
    ExplicitHeight = 220
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 914
    Height = 50
    Align = alTop
    TabOrder = 0
    object Label8: TLabel
      Left = 7
      Top = 3
      Width = 36
      Height = 13
      Caption = '&Result :'
    end
    object Button2: TButton
      Left = 679
      Top = 3
      Width = 61
      Height = 21
      Caption = 'OK'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 679
      Top = 26
      Width = 61
      Height = 20
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Memo3: TMemo
      Left = 49
      Top = 3
      Width = 618
      Height = 43
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 50
    Width = 297
    Height = 284
    Align = alLeft
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 295
      Height = 19
      Align = alTop
      Caption = 'Additional Filters For Layer '
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 1
      Top = 20
      Width = 295
      Height = 111
      Align = alTop
      TabOrder = 1
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 293
        Height = 13
        Align = alTop
        Caption = '&Filter Expression :'
        ExplicitWidth = 82
      end
      object SpeedButton1: TSpeedButton
        Left = 3
        Top = 88
        Width = 56
        Height = 18
        Caption = '&Assist...'
        OnClick = SpeedButton1Click
      end
      object Memo1: TMemo
        Left = 1
        Top = 14
        Width = 293
        Height = 71
        Align = alTop
        ScrollBars = ssBoth
        TabOrder = 0
        OnChange = Memo1Change
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 131
      Width = 295
      Height = 152
      Align = alClient
      TabOrder = 2
      object Label2: TLabel
        Left = 1
        Top = 1
        Width = 293
        Height = 13
        Align = alTop
        Caption = 'Ordering :'
        ExplicitWidth = 46
      end
      object SpeedButton2: TSpeedButton
        Left = 245
        Top = 20
        Width = 46
        Height = 17
        Caption = '&Assist...'
        OnClick = SpeedButton2Click
      end
      object Label3: TLabel
        Left = 3
        Top = 23
        Width = 12
        Height = 13
        Alignment = taRightJustify
        Caption = '(1)'
      end
      object Label4: TLabel
        Left = 3
        Top = 46
        Width = 12
        Height = 13
        Alignment = taRightJustify
        Caption = '(2)'
      end
      object SpeedButton3: TSpeedButton
        Left = 245
        Top = 42
        Width = 46
        Height = 18
        Caption = '&Assist...'
        OnClick = SpeedButton3Click
      end
      object Label5: TLabel
        Left = 3
        Top = 68
        Width = 12
        Height = 13
        Alignment = taRightJustify
        Caption = '(3)'
      end
      object SpeedButton4: TSpeedButton
        Left = 245
        Top = 65
        Width = 46
        Height = 18
        Caption = '&Assist...'
        OnClick = SpeedButton4Click
      end
      object cboOrder1: TComboBox
        Left = 20
        Top = 19
        Width = 169
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        OnChange = Memo1Change
      end
      object cboOrder2: TComboBox
        Left = 20
        Top = 42
        Width = 169
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        OnChange = Memo1Change
      end
      object cboOrder3: TComboBox
        Left = 20
        Top = 65
        Width = 169
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        OnChange = Memo1Change
      end
      object chkDesc1: TCheckBox
        Left = 191
        Top = 22
        Width = 50
        Height = 14
        Caption = 'DESC'
        TabOrder = 3
        OnClick = Memo1Change
      end
      object chkDesc2: TCheckBox
        Left = 191
        Top = 46
        Width = 50
        Height = 13
        Caption = 'DESC'
        TabOrder = 4
        OnClick = Memo1Change
      end
      object chkDesc3: TCheckBox
        Left = 191
        Top = 68
        Width = 50
        Height = 14
        Caption = 'DESC'
        TabOrder = 5
        OnClick = Memo1Change
      end
    end
  end
  object Panel5: TPanel
    Left = 301
    Top = 50
    Width = 142
    Height = 284
    Align = alLeft
    TabOrder = 2
    DesignSize = (
      142
      284)
    object Panel7: TPanel
      Left = 1
      Top = 1
      Width = 140
      Height = 19
      Align = alTop
      Caption = 'Graphic JOIN Operator'
      TabOrder = 0
    end
    object cboOp1: TComboBox
      Left = 3
      Top = 23
      Width = 136
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      OnChange = cboOp1Change
      Items.Strings = (
        'WITHIN'
        'ENTIRELY WITHIN'
        'CONTAINS'
        'CONTAINS ENTIRE'
        'INTERSECTS'
        'ENTIRELY WITHIN NO EDGE TOUCHED'
        'CONTAINS ENTIRE NO EDGE TOUCHED'
        'EXTENT OVERLAPS'
        'SHARE COMMON POINT'
        'SHARE COMMON LINE'
        'LINE CROSS'
        'COMMON POINT OR LINE CROSS'
        'EDGE TOUCH'
        'EDGE TOUCH OR INTERSECT'
        'POINT IN POLYGON'
        'CENTROID IN POLYGON'
        'IDENTICAL')
    end
    object Memo2: TMemo
      Left = 1
      Top = 204
      Width = 140
      Height = 79
      Align = alBottom
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object Panel8: TPanel
    Left = 447
    Top = 50
    Width = 123
    Height = 284
    Align = alLeft
    TabOrder = 3
    object Panel9: TPanel
      Left = 1
      Top = 1
      Width = 121
      Height = 19
      Align = alTop
      Caption = 'JOIN Layer'
      TabOrder = 0
    end
    object LBJoin: TListBox
      Left = 1
      Top = 20
      Width = 121
      Height = 263
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnClick = Memo1Change
    end
  end
  object Panel11: TPanel
    Left = 570
    Top = 50
    Width = 344
    Height = 284
    Align = alClient
    TabOrder = 4
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 342
      Height = 282
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Standard Filter'
        ImageIndex = 1
        object SpeedButton5: TSpeedButton
          Left = 0
          Top = 3
          Width = 170
          Height = 24
          Caption = 'Define &Filter...'
          OnClick = SpeedButton5Click
        end
        object MemoStd: TMemo
          Left = 0
          Top = 94
          Width = 334
          Height = 160
          Align = alBottom
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          OnChange = Memo1Change
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Vectorial Filter'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Button1: TSpeedButton
          Left = 0
          Top = 3
          Width = 170
          Height = 24
          Caption = 'Define &Filter...'
          OnClick = Button1Click
        end
        object MemoVect: TMemo
          Left = 0
          Top = 33
          Width = 171
          Height = 160
          Align = alBottom
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          OnChange = Memo1Change
        end
      end
    end
  end
end
