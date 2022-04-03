object frmDataSetEditor: TfrmDataSetEditor
  Left = 180
  Top = 159
  Width = 530
  Height = 534
  Caption = 'frmDataSetEditor'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 404
    Top = 0
    Width = 118
    Height = 507
    Align = alRight
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 16
      Width = 103
      Height = 25
      Action = acClose
      TabOrder = 0
    end
    object Button2: TButton
      Left = 8
      Top = 472
      Width = 103
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
    object Button3: TButton
      Left = 8
      Top = 88
      Width = 103
      Height = 25
      Caption = #1053#1086#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 8
      Top = 128
      Width = 103
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 8
      Top = 168
      Width = 103
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      TabOrder = 4
      OnClick = Button5Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 404
    Height = 507
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 465
      Width = 402
      Height = 41
      Align = alBottom
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = '   '#1041#1099#1089#1090#1088#1099#1081' '#1087#1086#1080#1089#1082
      TabOrder = 0
      object Edit1: TEdit
        Left = 96
        Top = 11
        Width = 193
        Height = 21
        TabOrder = 0
        OnChange = Edit1Change
      end
      object Button6: TButton
        Left = 298
        Top = 11
        Width = 73
        Height = 21
        Caption = #1044#1072#1083#1077#1077
        TabOrder = 1
      end
    end
    object DBGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 402
      Height = 464
      Align = alClient
      DataSource = DataSource
      TabOrder = 1
      TitleFont.Charset = RUSSIAN_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object DataSource: TDataSource
    Left = 248
    Top = 392
  end
  object ActionList: TActionList
    Left = 232
    Top = 224
    object acInsert: TDataSetInsert
      Category = 'Dataset'
      Caption = #1053#1086#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
      Hint = 'Insert'
      ImageIndex = 4
      DataSource = DataSource
    end
    object acDelete: TDataSetDelete
      Category = 'Dataset'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      Hint = 'Delete'
      ImageIndex = 5
      DataSource = DataSource
    end
    object acEdit: TDataSetEdit
      Category = 'Dataset'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      Hint = 'Edit'
      ImageIndex = 6
      DataSource = DataSource
    end
    object acClose: TAction
      Category = 'Window'
      Caption = 'OK'
      OnExecute = acCloseExecute
      OnUpdate = acCloseUpdate
    end
  end
end
