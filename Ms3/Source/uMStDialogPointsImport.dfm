object MstDialogImportPointsForm: TMstDialogImportPointsForm
  Left = 154
  Top = 82
  BorderStyle = bsDialog
  Caption = #1048#1084#1087#1086#1088#1090' '#1090#1086#1095#1077#1082
  ClientHeight = 453
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 200
    Top = 32
    Width = 56
    Height = 13
    Caption = #1057#1090#1083#1086#1073#1077#1094' X:'
  end
  object Label2: TLabel
    Left = 344
    Top = 32
    Width = 56
    Height = 13
    Caption = #1057#1090#1083#1086#1073#1077#1094' Y:'
  end
  object lvText: TListView
    Left = 8
    Top = 136
    Width = 489
    Height = 281
    Columns = <
      item
        Caption = #8470' '#1057#1090#1088#1086#1082#1080
        Width = 70
      end>
    OwnerDraw = True
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvTextChange
    OnChanging = lvTextChanging
    OnColumnClick = lvTextColumnClick
    OnDrawItem = lvTextDrawItem
    OnKeyDown = lvTextKeyDown
    OnKeyUp = lvTextKeyUp
    OnMouseUp = lvTextMouseUp
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 177
    Height = 121
    Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1089#1090#1086#1083#1073#1094#1086#1074
    Items.Strings = (
      #1090#1086#1095#1082#1072' '#1089' '#1079#1072#1087#1103#1090#1086#1081
      #1079#1072#1087#1103#1090#1072#1103
      #1089#1080#1084#1074#1086#1083' '#1090#1072#1073#1091#1083#1103#1094#1080#1080
      #1087#1088#1086#1073#1077#1083
      #1087#1088#1086#1080#1079#1074#1086#1083#1100#1085#1099#1081)
    TabOrder = 1
    OnClick = RadioGroup1Click
  end
  object Edit1: TEdit
    Left = 144
    Top = 104
    Width = 25
    Height = 21
    MaxLength = 1
    TabOrder = 2
    Visible = False
    OnChange = Edit1Change
  end
  object Button1: TButton
    Left = 200
    Top = 104
    Width = 137
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1090#1086#1083#1073#1077#1094' X'
    TabOrder = 3
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 344
    Top = 104
    Width = 137
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1090#1086#1083#1073#1077#1094' Y'
    TabOrder = 4
    Visible = False
    OnClick = Button2Click
  end
  object BitBtn1: TBitBtn
    Left = 336
    Top = 424
    Width = 75
    Height = 25
    Action = Action1
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object BitBtn2: TBitBtn
    Left = 424
    Top = 424
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 427
    Width = 169
    Height = 17
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1080#1084#1077#1102#1097#1080#1077#1089#1103' '#1090#1086#1095#1082#1080
    TabOrder = 7
    OnClick = CheckBox1Click
  end
  object cbX: TComboBox
    Left = 200
    Top = 48
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    OnChange = cbXChange
  end
  object cbY: TComboBox
    Left = 344
    Top = 48
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    OnChange = cbYChange
  end
  object ActionList1: TActionList
    Left = 384
    Top = 24
    object Action1: TAction
      Caption = 'OK'
      ImageIndex = 7
      OnExecute = Action1Execute
      OnUpdate = Action1Update
    end
  end
end
