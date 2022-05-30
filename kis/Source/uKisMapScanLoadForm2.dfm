object KisMapScanLoadForm2: TKisMapScanLoadForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1088#1080#1105#1084' '#1087#1083#1072#1085#1096#1077#1090#1086#1074'. '#1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083#1099
  ClientHeight = 376
  ClientWidth = 893
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    893
    376)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object btnOK: TButton
    Left = 729
    Top = 343
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 810
    Top = 343
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 27
    Width = 877
    Height = 310
    ActivePage = TabSheet2
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1092#1072#1081#1083#1086#1074
      DesignSize = (
        869
        282)
      object btnLoad: TBitBtn
        Left = 548
        Top = 3
        Width = 156
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
        TabOrder = 0
        OnClick = btnLoadClick
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000CE0E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          77777777777777777777000000000007777700333333333077770B0333333333
          07770FB03333333330770BFB0333333333070FBFB000000000000BFBFBFBFB07
          77770FBFBFBFBF0777770BFB0000000777777000777777770007777777777777
          7007777777770777070777777777700077777777777777777777}
      end
      object btnCompare: TBitBtn
        Left = 710
        Top = 3
        Width = 156
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        TabOrder = 1
        OnClick = btnCompareClick
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          88888888888800C88888888888800C88888888000070C88888888088880B8888
          8888088FFFF00000000008F7F770FFFFFFF008FFFFF0FFFFFFF008F77F70F7FF
          FFF080FFFF0FFFFFFFF08800007F77FFFFF0880FFFFFFFFFFFF0880F7777F77F
          FFF0880FFFFFFFFFFFF088000000000000008888888888888888}
      end
      object vstMaps: TVirtualStringTree
        Left = 3
        Top = 34
        Width = 863
        Height = 245
        Anchors = [akLeft, akTop, akRight, akBottom]
        CheckImageKind = ckXP
        Colors.UnfocusedSelectionColor = clGradientInactiveCaption
        Colors.UnfocusedSelectionBorderColor = clInactiveCaption
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoVisible]
        TabOrder = 2
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toEditOnClick]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
        OnAddToSelection = vstMapsAddToSelection
        OnColumnDblClick = vstMapsColumnDblClick
        OnCreateEditor = vstMapsCreateEditor
        OnGetText = vstMapsGetText
        Columns = <
          item
            Color = clWindow
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 0
            Width = 100
            WideText = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
          end
          item
            Color = cl3DLight
            Options = [coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
            Position = 1
            Width = 70
            WideText = #1055#1088#1086#1074#1077#1088#1077#1085#1086
          end
          item
            Position = 2
            Width = 100
            WideText = #1048#1079#1084#1077#1085#1077#1085#1080#1103
          end
          item
            Position = 3
            Width = 120
            WideText = #1058#1080#1087' '#1092#1072#1081#1083#1072
          end
          item
            Color = clInfoBk
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 4
            Width = 460
            WideText = #1060#1072#1081#1083
          end>
      end
      object btnAllUnchanged: TButton
        Left = 3
        Top = 3
        Width = 156
        Height = 25
        Caption = #1042#1089#1077' '#1073#1077#1079' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
        TabOrder = 3
        OnClick = btnAllUnchangedClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1090#1099#1082#1086#1074#1082#1072
      ImageIndex = 1
      OnShow = TabSheet2Show
      DesignSize = (
        869
        282)
      object vstJoin: TVirtualStringTree
        Left = 3
        Top = 34
        Width = 863
        Height = 245
        Anchors = [akLeft, akTop, akRight, akBottom]
        CheckImageKind = ckXP
        Colors.UnfocusedSelectionColor = clGradientInactiveCaption
        Colors.UnfocusedSelectionBorderColor = clInactiveCaption
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoVisible]
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toEditOnClick]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
        OnColumnDblClick = vstJoinColumnDblClick
        OnGetText = vstJoinGetText
        Columns = <
          item
            Color = clWindow
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 0
            Width = 100
            WideText = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
          end
          item
            Position = 1
            Width = 100
            WideText = #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
          end
          item
            Color = cl3DLight
            Options = [coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
            Position = 2
            Width = 70
            WideText = #1055#1088#1086#1074#1077#1088#1077#1085#1086
          end>
      end
      object btnShowJoin: TBitBtn
        Left = 710
        Top = 3
        Width = 156
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        TabOrder = 1
        OnClick = btnShowJoinClick
      end
    end
  end
  object OpenPictureDialog1: TOpenDialog
    DefaultExt = '.bmp'
    Filter = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' Windows (*.bmp)|*.bmp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 184
    Top = 8
  end
  object OpenDwgDialog1: TOpenDialog
    DefaultExt = '.dwg'
    Filter = #1060#1072#1081#1083#1099' DWG (*.dwg)|*.dwg'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 240
    Top = 8
  end
end
