object SoglassDocAddForm: TSoglassDocAddForm
  Left = 412
  Top = 265
  ActiveControl = BitBtn1
  BorderStyle = bsDialog
  Caption = #1055#1086#1082#1072#1079#1072#1090#1077#1083#1080
  ClientHeight = 141
  ClientWidth = 211
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 52
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label2: TLabel
    Left = 8
    Top = 41
    Width = 106
    Height = 13
    Caption = #1055#1083#1086#1097#1072#1076#1100' '#1079#1072#1089#1090#1088#1086#1081#1082#1080':'
  end
  object Label3: TLabel
    Left = 121
    Top = 41
    Width = 90
    Height = 13
    Caption = #1046#1080#1083#1072#1103'  '#1087#1083#1086#1097#1072#1076#1100':'
  end
  object Label4: TLabel
    Left = 8
    Top = 75
    Width = 91
    Height = 13
    Caption = #1054#1073#1097#1072#1103'  '#1087#1083#1086#1097#1072#1076#1100':'
  end
  object Label5: TLabel
    Left = 121
    Top = 75
    Width = 78
    Height = 13
    Caption = #1057#1090#1088#1086#1080#1090'. '#1086#1073#1100#1077#1084':'
  end
  object BitBtn1: TBitBtn
    Left = 128
    Top = 113
    Width = 76
    Height = 23
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object dbeNAME: TDBEdit
    Left = 8
    Top = 15
    Width = 196
    Height = 25
    DataField = 'NAME'
    DataSource = SoglassDocForm.dsValues
    TabOrder = 1
  end
  object dbePLOSH: TDBEdit
    Left = 8
    Top = 53
    Width = 98
    Height = 25
    DataField = 'PLOSH'
    DataSource = SoglassDocForm.dsValues
    TabOrder = 2
  end
  object dbeZHPLOSH: TDBEdit
    Left = 121
    Top = 52
    Width = 83
    Height = 25
    DataField = 'ZHPLOSH'
    DataSource = SoglassDocForm.dsValues
    TabOrder = 3
  end
  object dbeOBPLOSH: TDBEdit
    Left = 8
    Top = 87
    Width = 98
    Height = 25
    DataField = 'OBPLOSH'
    DataSource = SoglassDocForm.dsValues
    TabOrder = 4
  end
  object dbeOBEM: TDBEdit
    Left = 121
    Top = 87
    Width = 83
    Height = 25
    DataField = 'OBEM'
    DataSource = SoglassDocForm.dsValues
    TabOrder = 5
  end
end
