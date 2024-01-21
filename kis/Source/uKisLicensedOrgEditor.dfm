inherited KisLicensedOrgEditor: TKisLicensedOrgEditor
  Left = 210
  Top = 190
  Caption = ''
  ClientHeight = 258
  ClientWidth = 397
  Position = poMainFormCenter
  OnShow = FormShow
  ExplicitWidth = 403
  ExplicitHeight = 286
  PixelsPerInch = 96
  TextHeight = 13
  inherited HintWarnLabel: TLabel
    Top = 224
    Width = 142
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = #1046#1077#1083#1090#1099#1077' '#1087#1086#1083#1103' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099' '#13#10#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103'!'
    ExplicitTop = 249
    ExplicitWidth = 142
    ExplicitHeight = 26
  end
  inherited btnOk: TButton
    Left = 233
    Top = 225
    Anchors = [akRight, akBottom]
    ExplicitLeft = 233
    ExplicitTop = 225
  end
  inherited btnCancel: TButton
    Left = 314
    Top = 225
    Anchors = [akRight, akBottom]
    Default = True
    ExplicitLeft = 314
    ExplicitTop = 225
  end
  object PageControl1: TPageControl [3]
    Left = 0
    Top = 0
    Width = 397
    Height = 217
    ActivePage = tsMain
    Align = alTop
    TabOrder = 2
    object tsMain: TTabSheet
      Caption = #1044#1072#1085#1085#1099#1077
      object Label1: TLabel
        Left = 6
        Top = 6
        Width = 73
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      object Label2: TLabel
        Left = 6
        Top = 50
        Width = 31
        Height = 13
        Caption = #1040#1076#1088#1077#1089
      end
      object Label3: TLabel
        Left = 6
        Top = 96
        Width = 166
        Height = 13
        Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1083#1080#1094#1077#1085#1079#1080#1080
      end
      object Label4: TLabel
        Left = 190
        Top = 96
        Width = 184
        Height = 13
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1083#1080#1094#1077#1085#1079#1080#1080
      end
      object Label5: TLabel
        Left = 6
        Top = 144
        Width = 245
        Height = 13
        Caption = #1060'.'#1048'.'#1054'. '#1095#1077#1083#1086#1074#1077#1082#1072', '#1082#1086#1090#1086#1088#1099#1081' '#1073#1077#1088#1077#1090' '#1082#1072#1088#1090#1084#1072#1090#1077#1088#1080#1072#1083
      end
      object edName: TEdit
        Left = 6
        Top = 20
        Width = 374
        Height = 21
        Color = clInfoBk
        MaxLength = 255
        TabOrder = 0
      end
      object edAddress: TEdit
        Left = 6
        Top = 66
        Width = 374
        Height = 21
        MaxLength = 255
        TabOrder = 1
      end
      object edStartDate: TEdit
        Left = 6
        Top = 114
        Width = 61
        Height = 21
        Color = clInfoBk
        MaxLength = 10
        TabOrder = 2
      end
      object edEndDate: TEdit
        Left = 190
        Top = 114
        Width = 61
        Height = 21
        Color = clInfoBk
        MaxLength = 10
        TabOrder = 3
      end
      object edMapperFio: TEdit
        Left = 6
        Top = 160
        Width = 374
        Height = 21
        MaxLength = 100
        TabOrder = 4
      end
    end
    object tsSRO: TTabSheet
      Caption = #1057#1056#1054
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgSRO: TDBGrid
        Left = 3
        Top = 3
        Width = 302
        Height = 183
        DataSource = dsSROPeriods
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = RUSSIAN_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'SRO_NAME'
            Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'START_DATE'
            Title.Caption = #1053#1072#1095#1072#1083#1086
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'END_DATE'
            Title.Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077
            Visible = True
          end>
      end
      object btnSROAdd: TButton
        Left = 311
        Top = 3
        Width = 75
        Height = 25
        Action = acSROAdd
        TabOrder = 1
      end
      object btnSRODel: TButton
        Left = 311
        Top = 89
        Width = 75
        Height = 25
        Action = acSRODel
        TabOrder = 2
      end
      object btnSROEdoit: TButton
        Left = 311
        Top = 34
        Width = 75
        Height = 25
        Action = acSROEdit
        TabOrder = 3
      end
    end
  end
  object dsSROPeriods: TDataSource
    Left = 8
    Top = 224
  end
  object ActionList1: TActionList
    Left = 40
    Top = 224
    object acSROAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = acSROAddExecute
      OnUpdate = acSROAddUpdate
    end
    object acSRODel: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = acSRODelExecute
      OnUpdate = acSRODelUpdate
    end
    object acSROEdit: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = acSROEditExecute
      OnUpdate = acSROEditUpdate
    end
  end
end
