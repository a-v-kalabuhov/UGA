object kaMemoEditorForm: TkaMemoEditorForm
  Left = 4
  Top = 1
  Width = 466
  Height = 349
  Caption = 'kaMemoEditorForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = kaAppFormCloseQuery
  MinimizeApp = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 458
    Height = 284
    Align = alClient
    PopupMenu = PopupMenu
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 284
    Width = 458
    Height = 19
    Panels = <>
  end
  object MainMenu: TMainMenu
    Left = 48
    Top = 112
    object N1: TMenuItem
      Caption = #1058#1077#1082#1089#1090
      object N2: TMenuItem
        Action = acLoad
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object N13: TMenuItem
        Action = acExit
      end
    end
    object N3: TMenuItem
      Caption = #1055#1088#1072#1074#1082#1072
      object N11: TMenuItem
        Action = Undo
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Action = Cut
      end
      object N5: TMenuItem
        Action = Copy
      end
      object N6: TMenuItem
        Action = Paste
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Action = SelectAll
      end
      object N8: TMenuItem
        Action = Delete
      end
    end
    object miCustom: TMenuItem
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
    end
  end
  object PopupMenu: TPopupMenu
    Left = 112
    Top = 48
    object N16: TMenuItem
      Action = Copy
    end
    object N14: TMenuItem
      Action = Cut
    end
    object N15: TMenuItem
      Action = Delete
    end
    object N17: TMenuItem
      Caption = '-'
    end
    object N18: TMenuItem
      Action = SelectAll
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 56
    object Cut: TEditCut
      Category = 'Edit'
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      Hint = #1042#1099#1088#1077#1079#1072#1090#1100'|'#1042#1099#1088#1077#1079#1072#1090#1100' '#1090#1077#1082#1089#1090' '#1080' '#1087#1086#1084#1077#1089#1090#1080#1090#1100' '#1077#1075#1086' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 0
      ShortCut = 16472
    end
    object Copy: TEditCopy
      Category = 'Edit'
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100'|'#1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 1
      ShortCut = 16451
    end
    object Paste: TEditPaste
      Category = 'Edit'
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100'|'#1042#1089#1090#1072#1074#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 2
      ShortCut = 16470
    end
    object SelectAll: TEditSelectAll
      Category = 'Edit'
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      Hint = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      ShortCut = 16449
    end
    object Undo: TEditUndo
      Category = 'Edit'
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100'|'#1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
      ImageIndex = 3
      ShortCut = 16474
    end
    object Delete: TEditDelete
      Category = 'Edit'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100'|'#1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1095#1090
      ImageIndex = 5
      ShortCut = 46
    end
    object acLoad: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100'|'#1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1080#1079' '#1092#1072#1081#1083#1072
      OnExecute = acLoadExecute
    end
    object acExit: TAction
      Caption = #1042#1099#1093#1086#1076
      Hint = #1042#1099#1093#1086#1076'|'#1047#1072#1082#1088#1099#1090#1100' '#1088#1077#1076#1072#1082#1090#1086#1088
      OnExecute = acExitExecute
    end
  end
end
