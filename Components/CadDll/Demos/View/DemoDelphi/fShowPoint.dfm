object frmShowPoint: TfrmShowPoint
  Left = 384
  Top = 242
  BorderStyle = bsSingle
  Caption = 'Show Point'
  ClientHeight = 204
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 8
    Top = 89
    Width = 40
    Height = 13
    Caption = 'X-coord:'
  end
  object Label9: TLabel
    Left = 8
    Top = 117
    Width = 40
    Height = 13
    Caption = 'Y-coord:'
  end
  object Label11: TLabel
    Left = 8
    Top = 145
    Width = 30
    Height = 13
    Caption = 'Scale:'
  end
  object edtX: TEdit
    Left = 56
    Top = 81
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtY: TEdit
    Left = 56
    Top = 110
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 192
    Top = 172
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 276
    Top = 172
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object edtScale: TEdit
    Left = 56
    Top = 139
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object chkShowMarker: TCheckBox
    Left = 8
    Top = 173
    Width = 97
    Height = 17
    Caption = 'Show Marker'
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 344
    Height = 65
    Caption = 'Image Extents'
    TabOrder = 6
    object Label10: TLabel
      Left = 8
      Top = 32
      Width = 22
      Height = 13
      Caption = 'Top:'
    end
    object Label12: TLabel
      Left = 8
      Top = 16
      Width = 21
      Height = 13
      Caption = 'Left:'
    end
    object lblLeft: TLabel
      Left = 36
      Top = 16
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblTop: TLabel
      Left = 36
      Top = 32
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 16
      Height = 13
      Caption = 'Z1:'
    end
    object lblZ1: TLabel
      Left = 36
      Top = 48
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label4: TLabel
      Left = 180
      Top = 32
      Width = 36
      Height = 13
      Caption = 'Bottom:'
    end
    object lblBottom: TLabel
      Left = 220
      Top = 32
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label3: TLabel
      Left = 180
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Right:'
    end
    object lblRight: TLabel
      Left = 220
      Top = 16
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label5: TLabel
      Left = 180
      Top = 48
      Width = 16
      Height = 13
      Caption = 'Z2:'
    end
    object lblZ2: TLabel
      Left = 220
      Top = 48
      Width = 6
      Height = 13
      Caption = '0'
    end
  end
end
