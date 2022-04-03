object frmBrushStyle: TfrmBrushStyle
  Left = 215
  Top = 176
  BorderStyle = bsDialog
  Caption = 'Brush Style'
  ClientHeight = 252
  ClientWidth = 390
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 12
    Width = 31
    Height = 13
    Caption = '&Style :'
  end
  object Paintbox1: TPaintBox
    Left = 211
    Top = 11
    Width = 167
    Height = 168
    Visible = False
  end
  object cboBackColor: TEzColorBox
    Left = 44
    Top = 214
    Width = 158
    Height = 26
    TabOrder = 2
    TabStop = True
    Caption = 'BackColor'
    CustomText = '&More Color...'
    NoneColorText = 'Transparent'
    Flat = True
    ParentShowHint = False
    PopupSpacing = 8
    ShowHint = True
    ShowSystemColors = False
    OnChange = cboBackColorChange
  end
  object cboForeColor: TEzColorBox
    Left = 44
    Top = 182
    Width = 158
    Height = 26
    TabOrder = 1
    TabStop = True
    Caption = 'ForeColor'
    CustomText = '&More Color...'
    Flat = True
    ParentShowHint = False
    PopupSpacing = 8
    ShowHint = True
    ShowSystemColors = False
    OnChange = cboForeColorChange
  end
  object OKBtn: TButton
    Left = 223
    Top = 218
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 303
    Top = 218
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object brushlist1: TEzBrushPatternListBox
    Left = 46
    Top = 10
    Width = 153
    Height = 166
    BevelInner = bvLowered
    Color = clBtnFace
    ItemHeight = 40
    TabOrder = 0
    OnClick = brushlist1Click
  end
end
