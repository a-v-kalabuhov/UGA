object frmAccuDrawSetts: TfrmAccuDrawSetts
  Left = 330
  Top = 241
  BorderStyle = bsDialog
  Caption = 'AccuDraw Settings'
  ClientHeight = 251
  ClientWidth = 260
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 50
    Top = 218
    Width = 75
    Height = 24
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 137
    Top = 218
    Width = 74
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 13
    Top = 10
    Width = 235
    Height = 199
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Display'
      object Label1: TLabel
        Left = 44
        Top = 14
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = '&X axis :'
      end
      object Label2: TLabel
        Left = 44
        Top = 37
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = '&Y axis :'
      end
      object Label3: TLabel
        Left = 7
        Top = 58
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = '&Opposite axis :'
      end
      object Label4: TLabel
        Left = 42
        Top = 81
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = '&Frame :'
      end
      object Label7: TLabel
        Left = 2
        Top = 104
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = '&Snapped Color :'
      end
      object ColorBox1: TEzColorBox
        Left = 81
        Top = 11
        Width = 134
        Height = 17
        TabOrder = 0
        TabStop = True
        PopupSpacing = 8
        ShowSystemColors = True
      end
      object ColorBox2: TEzColorBox
        Left = 81
        Top = 33
        Width = 134
        Height = 18
        TabOrder = 1
        TabStop = True
        PopupSpacing = 8
        ShowSystemColors = True
      end
      object ColorBox3: TEzColorBox
        Left = 81
        Top = 57
        Width = 134
        Height = 18
        TabOrder = 2
        TabStop = True
        PopupSpacing = 8
        ShowSystemColors = True
      end
      object ColorBox4: TEzColorBox
        Left = 81
        Top = 80
        Width = 134
        Height = 18
        TabOrder = 3
        TabStop = True
        PopupSpacing = 8
        ShowSystemColors = True
      end
      object ColorBox5: TEzColorBox
        Left = 81
        Top = 103
        Width = 134
        Height = 18
        TabOrder = 4
        TabStop = True
        PopupSpacing = 8
        ShowSystemColors = True
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Configure'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 23
        Top = 111
        Width = 122
        Height = 13
        Alignment = taRightJustify
        Caption = '&Width of Frame (Pixels ) :'
      end
      object Label6: TLabel
        Left = 23
        Top = 134
        Width = 122
        Height = 13
        Alignment = taRightJustify
        Caption = '&Snap Tolerance (Pixels ) :'
      end
      object CheckBox1: TCheckBox
        Left = 95
        Top = 13
        Width = 69
        Height = 14
        Alignment = taLeftJustify
        Caption = '&Enabled :'
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 72
        Top = 33
        Width = 92
        Height = 13
        Alignment = taLeftJustify
        Caption = '&Snap To Axis :'
        TabOrder = 1
      end
      object CheckBox3: TCheckBox
        Left = 43
        Top = 71
        Width = 121
        Height = 14
        Alignment = taLeftJustify
        Caption = '&Snap To UnRotated :'
        TabOrder = 2
      end
      object NumEd1: TEzNumEd
        Left = 152
        Top = 108
        Width = 66
        Height = 20
        Cursor = crIBeam
        BorderColor = clDefault
        Digits = 4
        Decimals = 0
        HotTrack = False
        DecimalSeparator = ','
        ThousandSeparator = #160
        ParentColor = False
        TabOrder = 4
      end
      object NumEd2: TEzNumEd
        Left = 152
        Top = 131
        Width = 66
        Height = 19
        Cursor = crIBeam
        BorderColor = clDefault
        Digits = 4
        Decimals = 0
        HotTrack = False
        DecimalSeparator = ','
        ThousandSeparator = #160
        ParentColor = False
        TabOrder = 5
      end
      object chkSkip: TCheckBox
        Left = 7
        Top = 157
        Width = 157
        Height = 14
        Alignment = taLeftJustify
        Caption = 'Skip One When Reshaping :'
        TabOrder = 6
      end
      object CheckBox4: TCheckBox
        Left = 46
        Top = 51
        Width = 118
        Height = 14
        Alignment = taLeftJustify
        Caption = 'Rotate to &Segments :'
        TabOrder = 3
      end
      object ChkSameDist: TCheckBox
        Left = 23
        Top = 90
        Width = 141
        Height = 14
        Alignment = taLeftJustify
        Caption = '&Snap To Same Distance :'
        TabOrder = 7
      end
    end
  end
end
