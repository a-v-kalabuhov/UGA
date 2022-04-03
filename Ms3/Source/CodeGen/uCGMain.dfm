object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Code Gen'
  ClientHeight = 530
  ClientWidth = 718
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    718
    530)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 575
    Top = 8
    Width = 135
    Height = 13
    Alignment = taCenter
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Gen from Field list'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 575
    Top = 122
    Width = 135
    Height = 13
    Alignment = taCenter
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Gen from SQL text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 561
    Height = 514
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button1: TButton
    Left = 575
    Top = 32
    Width = 138
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Insert Code'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 575
    Top = 141
    Width = 138
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'String const'
    TabOrder = 2
    OnClick = Button2Click
  end
end
