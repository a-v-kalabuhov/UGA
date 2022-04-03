object frmAddEntity: TfrmAddEntity
  Left = 186
  Top = 72
  BorderStyle = bsDialog
  Caption = 'Add Entity From Text Dialog'
  ClientHeight = 398
  ClientWidth = 449
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 35
    Height = 16
    Caption = 'Help :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 272
    Width = 98
    Height = 13
    Caption = '&Type the text here :'
  end
  object OKBtn: TButton
    Left = 147
    Top = 364
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 227
    Top = 364
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 429
    Height = 241
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'You can add an entity to the current layer, by typing here '
      'its text.'
      'The following example adds a polygon entity to the current '
      'layer:'
      ''
      'POLYGON (0,0),(100,100),(200,200),(300),(300)'
      ''
      'For adding a multi-part polygon, you separate every part '
      'with a semicolon, like in the following (spaces and line '
      'feeds are ignored):'
      ''
      'POLYGON (0,0),(100,100),(200,200),(300),(300);'
      '  (5,5),(20,20), (35,35), 50,50)'
      ''
      'You can optionally add database information with the '
      'following format:'
      ''
      '{ entity_definition'
      '  DATA INFO'
      '  field1 : value_field1'
      '  field2 : value_field2'
      '...'
      '}'
      ''
      'Example:'
      ''
      '{ POLYGON (0,0), (100,100), (200,200), (300), (300);  '
      '(5,5),(20,20), (35,35), 50,50)'
      '  DATA INFO'
      '  NAME : "John, Smith"'
      '  ADDRESS : "Rio Rico, Dr."'
      '  CITY : "Tucson, Az."'
      '  AGE : 58'
      '}'
      ''
      'For other entities, the syntax is as follows:'
      ''
      'PLACE (123456.78, 123456.78)'
      ''
      'TEXTPLACE (123456.78, 123456.78), "TEXT"'
      ''
      '// the opposite corners'
      'RECTANGLE (123456.78, 123456.78),(123456.78, 123456.78)'
      ''
      '// center point, radius, start angle, numradians, '
      'iscounterclockwise'
      'ARC (123456.78, 123456.78), 123456.78, 123456.78, '
      '123456.78, '
      'TRUE'
      ''
      '// an arc with three points'
      'ARC2 (0,0),(100,100),(200,200)'
      ''
      ''
      'ELLIPSE (123456.78, 123456.78), (123456.78, 123456.78)'
      ''
      ''
      'FITTEDTEXT (123456.78, 123456.78), "xxxx", height, width, '
      'angle, color'
      ''
      '// text box, text, height, color'
      'JUSTIFTEXT (123456.78, 123456.78), (123456.78, 123456.78), '
      '"XXXXX", height, color'
      ''
      'PICTUREREF (123456.78, 123456.78), (123456.78, 123456.78), '
      '"BITMAP1.BMP"'
      ''
      'BANDSBITMAP (123456.78, 123456.78), (123456.78, '
      '123456.78), '
      '"BITMAP1.BMP"'
      ''
      'SPLINE (123456.78, 123456.78)[, (123456.78, 123456.78), '
      '(123456.78, 123456.78), ...]'
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 8
    Top = 292
    Width = 433
    Height = 61
    TabOrder = 3
  end
end
