object frmVectorialExpr: TfrmVectorialExpr
  Left = 184
  Top = 199
  BorderStyle = bsDialog
  Caption = 'Vectorial Expression'
  ClientHeight = 280
  ClientWidth = 572
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
  object Panel4: TPanel
    Left = 0
    Top = 85
    Width = 570
    Height = 195
    Align = alLeft
    TabOrder = 0
    object LblW: TLabel
      Left = 351
      Top = 176
      Width = 65
      Height = 13
      Caption = '&Buffer Width :'
      Enabled = False
    end
    object Splitter2: TSplitter
      Left = 185
      Top = 27
      Width = 4
      Height = 167
    end
    object Button1: TSpeedButton
      Left = 348
      Top = 30
      Width = 134
      Height = 20
      Caption = '&Pick Points From Map...'
      OnClick = Button1Click
    end
    object SpeedButton1: TSpeedButton
      Left = 484
      Top = 30
      Width = 82
      Height = 20
      Caption = '&Blink'
      OnClick = SpeedButton1Click
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 568
      Height = 26
      Align = alTop
      TabOrder = 0
      object Panel6: TPanel
        Left = 189
        Top = 1
        Width = 153
        Height = 24
        Align = alLeft
        BevelOuter = bvLowered
        Caption = 'Vector Function'
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 342
        Top = 1
        Width = 225
        Height = 24
        Align = alClient
        BevelOuter = bvLowered
        Caption = 'Point List'
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 188
        Height = 24
        Align = alLeft
        BevelOuter = bvLowered
        Caption = 'Graphic Operator'
        TabOrder = 2
      end
    end
    object NumEd1: TEzNumEd
      Left = 419
      Top = 172
      Width = 144
      Height = 20
      Cursor = crIBeam
      BorderColor = clDefault
      Decimals = 4
      HotTrack = False
      DecimalSeparator = ','
      ThousandSeparator = #160
      Enabled = False
      ParentColor = False
      TabOrder = 1
    end
    object Panel8: TPanel
      Left = 1
      Top = 27
      Width = 184
      Height = 167
      Align = alLeft
      TabOrder = 2
      DesignSize = (
        184
        167)
      object cboOp1: TComboBox
        Left = 3
        Top = 3
        Width = 177
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 0
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
      object Memo1: TMemo
        Left = 1
        Top = 54
        Width = 182
        Height = 112
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
        TabOrder = 1
      end
    end
    object Panel9: TPanel
      Left = 189
      Top = 27
      Width = 151
      Height = 167
      Align = alLeft
      TabOrder = 3
      object LBVector: TListBox
        Left = 1
        Top = 1
        Width = 149
        Height = 165
        Align = alClient
        ItemHeight = 13
        Items.Strings = (
          'POLYGON'
          'POLYLINE'
          'BUFFER'
          'BUFFER AS POLYGON')
        TabOrder = 0
        OnClick = LBVectorClick
      end
    end
    object Memo2: TMemo
      Left = 348
      Top = 55
      Width = 218
      Height = 115
      ScrollBars = ssBoth
      TabOrder = 4
      OnChange = Memo2Change
    end
  end
  object Panel10: TPanel
    Left = 0
    Top = 0
    Width = 572
    Height = 85
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 7
      Top = 3
      Width = 36
      Height = 13
      Caption = 'Result :'
    end
    object MemoResult: TMemo
      Left = 46
      Top = 1
      Width = 452
      Height = 84
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Button2: TButton
      Left = 504
      Top = 21
      Width = 61
      Height = 20
      Caption = 'OK'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 504
      Top = 44
      Width = 61
      Height = 20
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Launcher1: TEzActionLauncher
    CanDoOsnap = False
    CanDoAccuDraw = False
    MouseDrawElements = [mdCursorFrame, mdFullViewCursor]
    OnTrackedEntity = Launcher1TrackedEntity
    OnFinished = Launcher1Finished
    Left = 616
    Top = 80
  end
end
