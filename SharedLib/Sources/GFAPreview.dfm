object frmGFAPreview: TfrmGFAPreview
  Left = 1
  Top = 1
  BorderStyle = bsDialog
  Caption = 'frmGFAPreview'
  ClientHeight = 435
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 205
    Top = 0
    Width = 399
    Height = 399
    TabOrder = 0
    object Image: TImage
      Left = 1
      Top = 1
      Width = 397
      Height = 397
      Align = alClient
    end
    object Renderer: TNCSRenderer
      Left = 80
      Top = 128
      Width = 32
      Height = 32
      ControlData = {00030000D8130000D8130000}
    end
  end
  object FileListBox: TFileListBox
    Left = 0
    Top = 176
    Width = 201
    Height = 223
    ItemHeight = 13
    Mask = '*.gfa'
    TabOrder = 1
    OnChange = FileListBoxChange
  end
  object DriveComboBox: TDriveComboBox
    Left = 0
    Top = 0
    Width = 201
    Height = 19
    DirList = DirectoryListBox
    TabOrder = 2
  end
  object DirectoryListBox: TDirectoryListBox
    Left = 0
    Top = 24
    Width = 201
    Height = 145
    FileList = FileListBox
    ItemHeight = 16
    TabOrder = 3
  end
  object Button1: TButton
    Left = 8
    Top = 408
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 4
  end
  object Button2: TButton
    Left = 520
    Top = 408
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 5
  end
  object CheckBox: TCheckBox
    Left = 208
    Top = 408
    Width = 97
    Height = 17
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088
    TabOrder = 6
    OnClick = CheckBoxClick
  end
end
