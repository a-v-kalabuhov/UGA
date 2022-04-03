object frmExprBuilder: TfrmExprBuilder
  Left = 186
  Top = 151
  Caption = 'Expression builder'
  ClientHeight = 388
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 189
    Top = 52
    Width = 4
    Height = 336
    ExplicitHeight = 262
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 52
    Align = alTop
    TabOrder = 0
    DesignSize = (
      720
      52)
    object Label1: TLabel
      Left = 7
      Top = 7
      Width = 36
      Height = 13
      Caption = '&Result :'
    end
    object Button1: TButton
      Left = 525
      Top = 3
      Width = 62
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 525
      Top = 26
      Width = 62
      Height = 20
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object Button3: TButton
      Left = 460
      Top = 26
      Width = 62
      Height = 20
      Anchors = [akTop, akRight]
      Caption = '&Reset'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 460
      Top = 3
      Width = 62
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Edit...'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Edit1: TMemo
      Left = 46
      Top = 3
      Width = 410
      Height = 47
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 52
    Width = 189
    Height = 336
    Align = alLeft
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 187
      Height = 26
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Field Name'
      TabOrder = 0
    end
    object LBFields: TListBox
      Left = 1
      Top = 27
      Width = 187
      Height = 308
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnClick = LBFieldsClick
    end
  end
  object Panel4: TPanel
    Left = 193
    Top = 52
    Width = 527
    Height = 336
    Align = alClient
    TabOrder = 2
    DesignSize = (
      527
      336)
    object Label2: TLabel
      Left = 7
      Top = 81
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = 'OR'
    end
    object Label3: TLabel
      Left = 7
      Top = 127
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = 'OR'
    end
    object Label4: TLabel
      Left = 7
      Top = 176
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = 'OR'
    end
    object Label5: TLabel
      Left = 7
      Top = 218
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = 'OR'
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 525
      Height = 26
      Align = alTop
      TabOrder = 0
      object Panel6: TPanel
        Left = 1
        Top = 1
        Width = 188
        Height = 24
        Align = alLeft
        BevelOuter = bvLowered
        Caption = 'Operator'
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 189
        Top = 1
        Width = 335
        Height = 24
        Align = alClient
        BevelOuter = bvLowered
        Caption = 'Value(s)'
        TabOrder = 1
      end
    end
    object cboOp1: TComboBox
      Left = 3
      Top = 33
      Width = 180
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      OnChange = LBFieldsClick
      Items.Strings = (
        'None'
        'is equal to (exactly)'
        'is not equal to'
        'is greater than'
        'is greater than or equal to'
        'is less than'
        'is less than or equal to'
        'is between'
        'is not between'
        'is in list'
        'is not in list'
        'begins with the text'
        'ends with the text'
        'contains the text'
        'does not contains the text')
    end
    object cboOp2: TComboBox
      Left = 26
      Top = 78
      Width = 154
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
      OnChange = LBFieldsClick
      Items.Strings = (
        'None'
        'is equal to (exactly)'
        'is not equal to'
        'is greater than'
        'is greater than or equal to'
        'is less than'
        'is less than or equal to'
        'is between'
        'is not between'
        'is in list'
        'is not in list'
        'begins with the text'
        'ends with the text'
        'contains the text'
        'does not contains the text')
    end
    object Grid1: TStringGrid
      Left = 190
      Top = 33
      Width = 202
      Height = 43
      Anchors = [akTop, akRight]
      ColCount = 1
      DefaultColWidth = 120
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goVertLine, goEditing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 3
      OnSetEditText = Grid1SetEditText
    end
    object Grid2: TStringGrid
      Left = 190
      Top = 78
      Width = 202
      Height = 43
      Anchors = [akTop, akRight]
      ColCount = 1
      DefaultColWidth = 120
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goVertLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 4
      OnSetEditText = Grid1SetEditText
    end
    object cboOp3: TComboBox
      Left = 26
      Top = 124
      Width = 154
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 5
      OnChange = LBFieldsClick
      Items.Strings = (
        'None'
        'is equal to (exactly)'
        'is not equal to'
        'is greater than'
        'is greater than or equal to'
        'is less than'
        'is less than or equal to'
        'is between'
        'is not between'
        'is in list'
        'is not in list'
        'begins with the text'
        'ends with the text'
        'contains the text'
        'does not contains the text')
    end
    object Grid3: TStringGrid
      Left = 190
      Top = 124
      Width = 202
      Height = 43
      Anchors = [akTop, akRight]
      ColCount = 1
      DefaultColWidth = 120
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goVertLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 6
      OnSetEditText = Grid1SetEditText
    end
    object cboOp4: TComboBox
      Left = 26
      Top = 172
      Width = 154
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 7
      OnChange = LBFieldsClick
      Items.Strings = (
        'None'
        'is equal to (exactly)'
        'is not equal to'
        'is greater than'
        'is greater than or equal to'
        'is less than'
        'is less than or equal to'
        'is between'
        'is not between'
        'is in list'
        'is not in list'
        'begins with the text'
        'ends with the text'
        'contains the text'
        'does not contains the text')
    end
    object Grid4: TStringGrid
      Left = 190
      Top = 169
      Width = 202
      Height = 43
      Anchors = [akTop, akRight]
      ColCount = 1
      DefaultColWidth = 120
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goVertLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 8
      OnSetEditText = Grid1SetEditText
    end
    object cboOp5: TComboBox
      Left = 26
      Top = 215
      Width = 154
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 9
      OnChange = LBFieldsClick
      Items.Strings = (
        'None'
        'is equal to (exactly)'
        'is not equal to'
        'is greater than'
        'is greater than or equal to'
        'is less than'
        'is less than or equal to'
        'is between'
        'is not between'
        'is in list'
        'is not in list'
        'begins with the text'
        'ends with the text'
        'contains the text'
        'does not contains the text')
    end
    object Grid5: TStringGrid
      Left = 190
      Top = 215
      Width = 202
      Height = 43
      Anchors = [akTop, akRight]
      ColCount = 1
      DefaultColWidth = 120
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goVertLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 10
      OnSetEditText = Grid1SetEditText
    end
  end
end
