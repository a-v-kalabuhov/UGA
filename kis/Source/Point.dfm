object PointForm: TPointForm
  Left = 455
  Top = 279
  BorderStyle = bsDialog
  Caption = #1058#1086#1095#1082#1072
  ClientHeight = 88
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 87
    Top = 8
    Width = 6
    Height = 13
    Caption = '&X'
    FocusControl = edtX
  end
  object Label2: TLabel
    Left = 224
    Top = 8
    Width = 6
    Height = 13
    Caption = '&Y'
    FocusControl = edtY
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = '&'#1053#1072#1079#1074#1072#1085#1080#1077
    FocusControl = edtName
  end
  object btnOk: TButton
    Left = 207
    Top = 57
    Width = 72
    Height = 23
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 285
    Top = 57
    Width = 71
    Height = 23
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object edtX: TEdit
    Left = 87
    Top = 27
    Width = 131
    Height = 21
    TabOrder = 1
  end
  object edtY: TEdit
    Left = 224
    Top = 27
    Width = 132
    Height = 21
    TabOrder = 2
  end
  object edtName: TEdit
    Left = 8
    Top = 27
    Width = 73
    Height = 21
    MaxLength = 12
    TabOrder = 0
  end
end
