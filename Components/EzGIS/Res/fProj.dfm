object frmGeoProj: TfrmGeoProj
  Left = 205
  Top = 157
  BorderStyle = bsDialog
  Caption = 'Select Coordinate System'
  ClientHeight = 280
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 38
    Top = 9
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = '&Group :'
    FocusControl = GroupCombo
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 19
    Top = 50
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = '&Projection :'
    FocusControl = ProjectionCombo
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 30
    Top = 70
    Width = 44
    Height = 13
    Alignment = taRightJustify
    Caption = '&Ellipsoid :'
    FocusControl = DatumCombo
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 6
    Top = 90
    Width = 68
    Height = 13
    Alignment = taRightJustify
    Caption = 'Coords &Units :'
    FocusControl = LinearUnitsCombo
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 12
    Top = 30
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = '&World Zone :'
    FocusControl = cboZone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 411
    Top = 6
    Width = 56
    Height = 19
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 411
    Top = 28
    Width = 56
    Height = 18
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object GroupCombo: TComboBox
    Left = 78
    Top = 6
    Width = 238
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 0
    OnChange = GroupComboChange
    Items.Strings = (
      'Cartesian (non Earth)'
      'Geodetic Latiude/Longitude'
      'Projection')
  end
  object ProjectionCombo: TComboBox
    Left = 78
    Top = 47
    Width = 238
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 2
    OnChange = ProjectionComboChange
  end
  object DatumCombo: TComboBox
    Left = 78
    Top = 67
    Width = 238
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 3
    OnChange = ProjectionComboChange
  end
  object LinearUnitsCombo: TComboBox
    Left = 78
    Top = 88
    Width = 238
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    TabOrder = 4
    OnChange = ProjectionComboChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 114
    Width = 474
    Height = 166
    Align = alBottom
    TabOrder = 7
    object Label7: TLabel
      Left = 252
      Top = 6
      Width = 116
      Height = 12
      Caption = 'Z&one Code (Future use) :'
    end
    object Label8: TLabel
      Left = 252
      Top = 42
      Width = 83
      Height = 12
      Caption = 'Zone D&escription :'
    end
    object Edit1: TEdit
      Left = 255
      Top = 21
      Width = 109
      Height = 20
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 255
      Top = 57
      Width = 214
      Height = 20
      TabOrder = 1
    end
    object Button3: TButton
      Left = 255
      Top = 87
      Width = 214
      Height = 19
      Caption = '&Add to Database'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 245
      Height = 164
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 5
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 245
        Height = 16
        Align = alTop
        Caption = 'Basic Parameters'
        TabOrder = 0
      end
      object Memo1: TMemo
        Left = 0
        Top = 16
        Width = 245
        Height = 48
        Align = alTop
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Panel4: TPanel
        Left = 0
        Top = 64
        Width = 245
        Height = 15
        Align = alTop
        Caption = 'Projection Specific Parameters'
        TabOrder = 2
      end
      object Memo2: TMemo
        Left = 0
        Top = 79
        Width = 245
        Height = 85
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
    end
    object Button4: TButton
      Left = 255
      Top = 108
      Width = 214
      Height = 18
      Caption = '&Update this Projection'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 255
      Top = 129
      Width = 214
      Height = 19
      Caption = '&Delete this Projection'
      TabOrder = 4
      OnClick = Button5Click
    end
  end
  object cboZone: TComboBox
    Left = 78
    Top = 27
    Width = 238
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    Sorted = True
    TabOrder = 1
    OnChange = cboZoneChange
  end
end
