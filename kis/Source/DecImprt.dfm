object DecreeImportForm: TDecreeImportForm
  Left = 4
  Top = 5
  ActiveControl = DriveBox
  Caption = #1048#1084#1087#1086#1088#1090
  ClientHeight = 513
  ClientWidth = 748
  Color = clBtnFace
  Constraints.MinHeight = 310
  Constraints.MinWidth = 550
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 426
    Width = 748
    Height = 87
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object AutoBox: TGroupBox
      Left = 176
      Top = 8
      Width = 345
      Height = 73
      Caption = '&'#1040#1074#1090#1086#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 42
        Width = 18
        Height = 13
        Caption = #1058#1080#1087
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object NoBox: TCheckBox
        Left = 8
        Top = 16
        Width = 113
        Height = 17
        Caption = '&'#1042#1093'. '#1085#1086#1084#1077#1088', '#1075#1088#1091#1087#1087#1072':'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
      object DateBox: TCheckBox
        Left = 168
        Top = 16
        Width = 65
        Height = 17
        Caption = #1042#1093'. &'#1076#1072#1090#1072
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 3
      end
      object edtNumberOrder: TEdit
        Left = 128
        Top = 16
        Width = 15
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '1'
      end
      object udNumberOrder: TUpDown
        Left = 143
        Top = 16
        Width = 15
        Height = 21
        Associate = edtNumberOrder
        Min = 1
        Max = 9
        Position = 1
        TabOrder = 2
      end
      object cbDecreeType: TComboBox
        Left = 32
        Top = 40
        Width = 305
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
      end
    end
    object ImportBtn: TButton
      Left = 528
      Top = 16
      Width = 90
      Height = 25
      Caption = '&'#1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = ImportBtnClick
    end
    object DelBtn: TButton
      Left = 528
      Top = 48
      Width = 90
      Height = 25
      Caption = '&'#1059#1076#1072#1083#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = DelBtnClick
    end
    object cbConvert: TCheckBox
      Left = 8
      Top = 24
      Width = 153
      Height = 17
      Caption = '&'#1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1080#1079' ASCII'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnClick = cbConvertClick
    end
    object cbDelete: TCheckBox
      Left = 8
      Top = 48
      Width = 145
      Height = 17
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1089#1083#1077' '#1080#1084#1087#1086#1088#1090#1072
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 426
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 433
    DesignSize = (
      177
      426)
    object DriveBox: TDriveComboBox
      Left = 8
      Top = 8
      Width = 161
      Height = 19
      DirList = DirBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TextCase = tcUpperCase
    end
    object DirBox: TDirectoryListBox
      Left = 8
      Top = 32
      Width = 161
      Height = 116
      FileList = FileBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      IntegralHeight = True
      ItemHeight = 16
      ParentFont = False
      TabOrder = 1
    end
    object FileBox: TFileListBox
      Left = 8
      Top = 152
      Width = 161
      Height = 257
      Ctl3D = True
      ItemHeight = 16
      MultiSelect = True
      ParentCtl3D = False
      ParentShowHint = False
      ShowGlyphs = True
      ShowHint = False
      TabOrder = 2
      OnClick = FileBoxClick
      OnDblClick = ImportBtnClick
    end
    object FilterBox: TFilterComboBox
      Left = 8
      Top = 412
      Width = 161
      Height = 21
      Anchors = [akBottom]
      FileList = FileBox
      Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
      TabOrder = 3
    end
  end
  object memText: TMemo
    Left = 177
    Top = 0
    Width = 571
    Height = 426
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
    OnExit = memTextExit
    ExplicitHeight = 433
  end
  object FormStorage: TJvFormStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'cbConvert.Checked'
      'cbDelete.Checked'
      'NoBox.Checked'
      'udNumberOrder.Position'
      'DateBox.Checked')
    StoredValues = <>
    Left = 328
    Top = 112
  end
  object Query: TIBSQL
    Database = KisAppModule.Database
    Transaction = Transaction
    Left = 360
    Top = 80
  end
  object Transaction: TIBTransaction
    DefaultDatabase = KisAppModule.Database
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 360
    Top = 112
  end
  object ibsInsert: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'INSERT INTO DECREES'
      
        '(ID, DOC_NUMBER, DOC_DATE, INT_NUMBER, INT_DATE, DECREE_TYPES_ID' +
        ', CONTENT, HEADER)'
      
        'VALUES (:ID, :DOC_NUMBER, :DOC_DATE, :INT_NUMBER, :INT_DATE, :DE' +
        'CREE_TYPES_ID, :CONTENT, :HEADER)')
    Transaction = Transaction
    Left = 392
    Top = 80
  end
  object ibsUpdate: TIBSQL
    Database = KisAppModule.Database
    SQL.Strings = (
      'UPDATE DECREES SET'
      'DECREE_TYPES_ID=:DECREE_TYPES_ID,'
      'HEADER=:HEADER,'
      'CONTENT=:CONTENT'
      'WHERE DOC_DATE=:DOC_DATE AND DOC_NUMBER=:DOC_NUMBER')
    Transaction = Transaction
    Left = 424
    Top = 80
  end
  object ibqDecreeTypes: TIBQuery
    Database = KisAppModule.Database
    Transaction = Transaction
    SQL.Strings = (
      'SELECT * FROM DECREE_TYPES'
      'ORDER BY ID')
    Left = 456
    Top = 80
  end
end
