object mstPointForm: TmstPointForm
  Left = 455
  Top = 279
  ActiveControl = edtX
  BorderStyle = bsToolWindow
  Caption = #1058#1086#1095#1082#1072
  ClientHeight = 111
  ClientWidth = 185
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 6
    Height = 13
    Caption = '&X'
    FocusControl = edtX
  end
  object Label2: TLabel
    Left = 104
    Top = 8
    Width = 6
    Height = 13
    Caption = '&Y'
    FocusControl = edtY
  end
  object btnOk: TButton
    Left = 8
    Top = 78
    Width = 66
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 111
    Top = 78
    Width = 66
    Height = 25
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object edtX: TEdit
    Left = 8
    Top = 24
    Width = 73
    Height = 21
    TabOrder = 0
  end
  object edtY: TEdit
    Left = 104
    Top = 24
    Width = 73
    Height = 21
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 51
    Width = 129
    Height = 17
    Caption = #1052#1077#1083#1082#1080#1081' '#1084#1072#1089#1096#1090#1072#1073
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
end
