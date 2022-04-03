unit fColsEditor;

{$I EZ_FLAG.PAS}
interface                      

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, EzInspect, StdCtrls, Buttons, ExtCtrls, EzMiscelEntities;

type
  TfrmColumnsEditor = class(TForm)
    Panel1: TPanel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    ListBox1: TListBox;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Inspector1: TEzInspector;
    BtnUP: TSpeedButton;
    BtnDOWN: TSpeedButton;
    Splitter1: TSplitter;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure BtnUPClick(Sender: TObject);
    procedure BtnDOWNClick(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Inspector1PropertyChange(Sender: TObject;
      const PropertyName: String);
  private
    { Private declarations }
    FEditColumns: TEzColumnList;
    FRowCount: Integer;
    FLast: Integer;
    procedure UpdateProperties;
  public
    { Public declarations }
    function Enter(RowCount: Integer; Columns: TEzColumnList):Word;

    property EditColumns: TEzColumnList read FEditColumns;
  end;

implementation

{$R *.DFM}

uses
  EzLib, EzSystem;

{ TfrmColumnsEditor }

function TfrmColumnsEditor.Enter(RowCount: Integer; Columns: TEzColumnList): Word;
var
  I: Integer;
  ColsStrings: TStrings;
begin
  FEditColumns:= TEzColumnList.Create(Nil);
  FEditColumns.Assign(Columns);
  FRowCount:= RowCount;

  for I:= 0 to FEditColumns.Count-1 do
    ListBox1.Items.Add('');
  FLast:= -1;
  if ListBox1.Items.Count > 0 then
  begin
    ListBox1.ItemIndex:= 0;
    ListBox1.OnClick(Nil);
  end;

  ColsStrings:= TStringList.Create;
  try
    RestoreFormPlacement(ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, true, ColsStrings);
    if ColsStrings.Count = 2 then
    begin
      Inspector1.ColWidths[0]:= StrToInt(ColsStrings.Values['Col0']);
      Inspector1.ColWidths[1]:= StrToInt(ColsStrings.Values['Col1']);
    end;
  finally
    ColsStrings.free;
  end;

  Result:=ShowModal;
end;

procedure TfrmColumnsEditor.btnDeleteClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:= ListBox1.ItemIndex;
  if Index < 0 then Exit;
  FEditColumns.Delete( Index );
  ListBox1.Items.Delete( Index );
  if Index <= ListBox1.Items.Count - 1 then
    ListBox1.ItemIndex:= Index
  else if ListBox1.Items.Count > 0 then
    ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.OnClick(Nil);
end;

procedure TfrmColumnsEditor.btnAddClick(Sender: TObject);
begin
  FEditColumns.Add;
  ListBox1.Items.Add( '' );
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.OnClick(Nil);
end;

procedure TfrmColumnsEditor.BtnUPClick(Sender: TObject);
begin
  if ListBox1.ItemIndex < 0 then Exit;
  if FEditColumns.Up( ListBox1.ItemIndex ) then
  begin
    ListBox1.ItemIndex:= ListBox1.ItemIndex - 1;
    ListBox1.OnClick(Nil);
  end;
  ListBox1.Invalidate;
end;

procedure TfrmColumnsEditor.BtnDOWNClick(Sender: TObject);
begin
  if ListBox1.ItemIndex < 0 then Exit;
  if FEditColumns.Down( ListBox1.ItemIndex ) then
  begin
    ListBox1.ItemIndex:= ListBox1.ItemIndex + 1;
    ListBox1.OnClick(Nil);
  end;
  ListBox1.Invalidate;
end;

procedure TfrmColumnsEditor.ListBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  AText: string;
begin
  with ListBox1.Canvas do
  begin
    FillRect( Rect );
    Font.Assign( Self.Font );
    if odSelected in State then
      Font.Color:= clHighlightText;
    AText:= FEditColumns[Index].Title.Caption;
    if Length(AText) = 0 then
      AText:= Format('Column %d',[Index]);
    TextOut( Rect.Left, Rect.Top, AText);
  end;
end;

procedure TfrmColumnsEditor.ListBox1Click(Sender: TObject);
var
  Column: TEzColumnItem;
  bp: TEzBaseProperty;
  J: Integer;
  pn: string;
  tv: TEzTreeViewProperty;
begin
  if ListBox1.ItemIndex < 0 then Exit;
  UpdateProperties;

  Inspector1.ClearPropertyList;
  Inspector1.Visible:= true;

  FLast:= ListBox1.ItemIndex;
  { fill the property list }
  Column:= FEditColumns[Flast];

  tv:= TEzTreeViewProperty.Create('General');
  tv.ReadOnly:= true;
  Inspector1.AddProperty( tv );
  tv.Modified:= true;

  bp:= TEzEnumerationProperty.Create('ColumnType');
  with TEzEnumerationProperty(bp).Strings do
  begin
    Add('ctText');
    Add('ctColor');
    Add('ctLineStyle');
    Add('ctBrushStyle');
    Add('ctSymbolStyle');
    Add('ctBitmap');
  end;
  bp.ValInteger:= Ord(Column.ColumnType);
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('Width');
  bp.ValFloat:= Column.Width;
  tv.AddProperty( bp );

  bp:= TEzEnumerationProperty.Create('Alignment');
  with TEzEnumerationProperty(bp).Strings do
  begin
    Add('taLeftJustify');
    Add('taRightJustify');
    Add('taCenter');
  end;
  bp.ValInteger:= Ord(Column.Alignment);
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('Color');
  bp.ValInteger:= Column.Color;
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('Transparent');
  bp.ValBoolean:= Column.Transparent;
  tv.AddProperty( bp );

  tv:= TEzTreeViewProperty.Create('Font');
  tv.ReadOnly:= true;
  Inspector1.AddProperty( tv );
  tv.Modified:= true;

  bp:= TEzFontNameProperty.Create('FontName');
  TEzFontNameProperty(bp).TrueType:= true;
  bp.ValString:= Column.Font.Name;
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('FontHeight');
  bp.ValFloat:= Column.Font.Height;
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('FontColor');
  bp.ValInteger:= Column.Font.Color;
  tv.AddProperty( bp );

  bp:= TEzSetProperty.Create('FontStyle');
  with TEzSetProperty(bp) do
  begin
    Strings.BeginUpdate;
    Strings.add('Bold');
    Strings.add('Italic');
    Strings.add('Underline');
    Strings.add('StrikeOut');
    Strings.EndUpdate;

    with Column.Font do
    begin
      Defined[0] := fsBold in Style;
      Defined[1] := fsItalic in Style;
      Defined[2] := fsUnderline in Style;
      Defined[3] := fsStrikeout in Style;
    end;
  end;
  tv.AddProperty( bp );

  tv:= TEzTreeViewProperty.Create('Title');
  tv.ReadOnly:= true;
  Inspector1.AddProperty( tv );
  tv.Modified:= true;

  bp:= TEzStringProperty.Create('Title.Caption');
  bp.ValString:= Column.Title.Caption;
  tv.AddProperty( bp );

  bp:= TEzEnumerationProperty.Create('Title.Alignment');
  with TEzEnumerationProperty(bp).Strings do
  begin
    Add('taLeftJustify');
    Add('taRightJustify');
    Add('taCenter');
  end;
  bp.ValInteger:= Ord(Column.Title.Alignment);
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('Title.Color');
  bp.ValInteger:= Column.Title.Color;
  tv.AddProperty( bp );

  bp:= TEzBooleanProperty.Create('Title.Transparent');
  bp.ValBoolean:= Column.Title.Transparent;
  tv.AddProperty( bp );

  bp:= TEzFontNameProperty.Create('Title.FontName');
  TEzFontNameProperty(bp).TrueType:= true;
  bp.ValString:= Column.Title.Font.Name;
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('Title.FontColor');
  bp.ValInteger:= Column.Title.Font.Color;
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('Title.FontHeight');
  bp.ValFloat:= Column.Title.Font.Height;
  tv.AddProperty( bp );

  bp:= TEzSetProperty.Create('Title.FontStyle');
  with TEzSetProperty(bp) do
  begin
    Strings.BeginUpdate;
    Strings.add('Bold');
    Strings.add('Italic');
    Strings.add('Underline');
    Strings.add('StrikeOut');
    Strings.EndUpdate;

    with Column.Title.Font do
    begin
      Defined[0] := fsBold in Style;
      Defined[1] := fsItalic in Style;
      Defined[2] := fsUnderline in Style;
      Defined[3] := fsStrikeout in Style;
    end;
  end;
  tv.AddProperty( bp );

  tv:= TEzTreeViewProperty.Create('Rows');
  tv.ReadOnly:= true;
  Inspector1.AddProperty( tv );
  tv.Modified:= true;

  for J:= 0 to Self.FRowCount - 1 do
  begin
    pn:= Format('Row(%d)', [J+1]);
    case Column.ColumnType of
      ctLabel:
        begin
          bp:= TEzStringProperty.Create(pn);
          bp.ValString:= Column.Strings[J];
          tv.AddProperty( bp );
        end;
      ctColor:
        begin
          bp:= TEzColorProperty.Create(pn);
          bp.ValInteger:= StrToIntDef(Column.Strings[J], 0);
          tv.AddProperty( bp );
        end;
      ctLineStyle:
        begin
          bp:= TEzLinetypeProperty.Create(pn);
          bp.ValInteger:= StrToIntDef(Column.Strings[J], 0);
          tv.AddProperty( bp );
        end;
      ctBrushStyle:
        begin
          bp:= TEzBrushstyleProperty.Create(pn);
          bp.ValInteger:= StrToIntDef(Column.Strings[J], 0);
          tv.AddProperty( bp );
        end;
      ctSymbolStyle:
        begin
          bp:= TEzSymbolProperty.Create(pn);
          bp.ValInteger:= StrToIntDef(Column.Strings[J], 0);
          tv.AddProperty( bp );
        end;
      ctBitmap:
        begin
          bp:= TEzDefineAnyLocalImageProperty.Create(pn);
          bp.ValString:= Column.Strings[J];
          tv.AddProperty( bp );
        end;
    end;
  end;
end;

procedure TfrmColumnsEditor.UpdateProperties;
var
  Column: TEzColumnItem;
  bp: TEzBaseProperty;
  FontStyle: TEzFontStyle;
  temp:boolean;
  J: Integer;
  pn: string;
begin
  if (FLast < 0 ) or (FLast > ListBox1.Items.Count - 1 ) then Exit;

  { update the properties here }

  Column:= FEditColumns[FLast];

  bp:= Inspector1.GetPropertyByName('ColumnType');
  if bp.modified then
    Column.ColumnType:= TEzColumnType(ezlib.imax(0,bp.ValInteger));

  bp:= Inspector1.GetPropertyByName('Alignment');
  if bp.modified then
    Column.Alignment:= TAlignment(ezlib.imax(0,bp.ValInteger));

  bp:= Inspector1.GetPropertyByName('Color');
  if bp.modified then
    Column.Color:= bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('Transparent');
  if bp.modified then
    Column.Transparent:= bp.ValBoolean;

  FontStyle:= Column.Font;
  temp:=false;

  bp:= Inspector1.GetPropertyByName('FontName');
  if bp.modified then
  begin
    FontStyle.Name:= bp.ValString;
    temp:=true;
  end;

  bp:= Inspector1.GetPropertyByName('FontColor');
  if bp.modified then
  begin
    FontStyle.Color:= bp.ValInteger;
    temp:=true;
  end;

  bp:= Inspector1.GetPropertyByName('FontHeight');
  if bp.modified then
  begin
    FontStyle.Height:= bp.ValFloat;
    temp:=true;
  end;

  bp:= Inspector1.GetPropertyByname('FontStyle');
  if bp.modified then
  begin
    FontStyle.Style:= [];
    with TEzSetProperty(bp) do
    begin
      if Defined[0] then Include(FontStyle.Style,fsbold);
      if Defined[1] then Include(FontStyle.Style,fsitalic);
      if Defined[2] then Include(FontStyle.Style,fsunderline);
      if Defined[3] then Include(FontStyle.Style,fsstrikeout);
    end;
    temp:= true;
  end;

  if temp then
    Column.Font:= FontStyle;

  bp:= Inspector1.GetPropertyByName('Width');
  if bp.modified then
    Column.Width:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('Title.Caption');
  if bp.modified then
    Column.Title.Caption:=bp.ValString;

  bp:= Inspector1.GetPropertyByName('Title.Alignment');
  if bp.modified then
    Column.Title.Alignment:=TAlignment(ezlib.imax(0,bp.ValInteger));

  bp:= Inspector1.GetPropertyByName('Title.Color');
  if bp.modified then
    Column.Title.Color:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('Title.Transparent');
  if bp.modified then
    Column.Title.Transparent:=bp.ValBoolean;

  FontStyle:= Column.Title.Font;
  temp:=false;

  bp:= Inspector1.GetPropertyByName('Title.FontName');
  if bp.modified then
  begin
    FontStyle.Name:= bp.ValString;
    temp:=true;
  end;

  bp:= Inspector1.GetPropertyByName('Title.FontColor');
  if bp.modified then
  begin
    FontStyle.Color:= bp.ValInteger;
    temp:=true;
  end;

  bp:= Inspector1.GetPropertyByName('Title.FontHeight');
  if bp.modified then
  begin
    FontStyle.Height:= bp.ValFloat;
    temp:=true;
  end;

  bp:= Inspector1.GetPropertyByname('Title.FontStyle');
  if bp.modified then
  begin
    FontStyle.Style:= [];
    with TEzSetProperty(bp) do
    begin
      if Defined[0] then Include(FontStyle.Style,fsbold);
      if Defined[1] then Include(FontStyle.Style,fsitalic);
      if Defined[2] then Include(FontStyle.Style,fsunderline);
      if Defined[3] then Include(FontStyle.Style,fsstrikeout);
    end;
    temp:= true;
  end;

  if temp then
    Column.Title.Font:= FontStyle;

  for J:= 0 to Self.FRowCount - 1 do
  begin
    pn:= Format('Row(%d)', [J+1]);
    case Column.ColumnType of
      ctLabel:
        begin
          bp:= Inspector1.GetPropertyByName(pn);
          Column.Strings[J]:= bp.ValString;
        end;
      ctColor:
        begin
          bp:= Inspector1.GetPropertyByName(pn);
          Column.Strings[J]:= IntToStr(bp.ValInteger);
        end;
      ctLineStyle:
        begin
          bp:= Inspector1.GetPropertyByName(pn);
          Column.Strings[J]:= Inttostr(bp.ValInteger);
        end;
      ctBrushStyle:
        begin
          bp:= Inspector1.GetPropertyByName(pn);
          Column.Strings[J]:= Inttostr(bp.ValInteger);
        end;
      ctSymbolStyle:
        begin
          bp:= Inspector1.GetPropertyByName(pn);
          Column.Strings[J]:= Inttostr(bp.ValInteger);
        end;
      ctBitmap:
        begin
          bp:= Inspector1.GetPropertyByName(pn);
          Column.Strings[J]:= bp.ValString;
        end;
    end;
  end;
end;

procedure TfrmColumnsEditor.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ColsString: TStrings;
  I: Integer;
begin
  ColsString:= TStringList.Create;
  try
    for I:= 0 to Inspector1.ColCount-1 do
      ColsString.Add(Format('Col%d=%d', [I,Inspector1.ColWidths[I]] ));
    SaveFormPlacement( ExtractFilePath(Application.ExeName) + 'formspos.ini',
      Self, ColsString );
  finally
    ColsString.Free;
  end;
  UpdateProperties;
end;

procedure TfrmColumnsEditor.Inspector1PropertyChange(Sender: TObject;
  const PropertyName: String);
var
  pn: string;
  J: Integer;
  Column: TEzColumnItem;
  bp, bp1: TEzBaseProperty;
begin
  if AnsiCompareText(PropertyName, 'Title.Caption') = 0 then
    ListBox1.Invalidate
  else if AnsiCompareText(PropertyName, 'ColumnType') = 0 then
  begin
    Column:= FEditColumns[FLast];
    bp1:= Inspector1.GetPropertyByName( PropertyName );
    for J:= 0 to Self.FRowCount - 1 do
    begin
      pn:= Format('Row(%d)', [J+1]);
      case TEzColumnType(bp1.ValInteger) of
        ctLabel:
          begin
            bp:= TEzStringProperty.Create(pn);
            bp.ValString:= Column.Strings[J];
            Inspector1.ReplaceProperty( pn, bp );
          end;
        ctColor:
          begin
            bp:= TEzColorProperty.Create(pn);
            bp.ValInteger:=
              EzLib.IMin(Low(TColor), EzLib.IMax(StrToIntDef(Column.Strings[J], 0),High(TColor)));
            Inspector1.ReplaceProperty( pn, bp );
          end;
        ctLineStyle:
          begin
            bp:= TEzLinetypeProperty.Create(pn);
            bp.ValInteger:= EzLib.IMin( Ez_LineTypes.Count-1,
              EzLib.IMax(StrToIntDef(Column.Strings[J], 0), 0) );
            Inspector1.ReplaceProperty( pn, bp );
          end;
        ctBrushStyle:
          begin
            bp:= TEzBrushstyleProperty.Create(pn);
            bp.ValInteger:= EzLib.IMin( 89,
              EzLib.IMax(StrToIntDef(Column.Strings[J], 0), 0) );
            Inspector1.ReplaceProperty( pn, bp );
          end;
        ctSymbolStyle:
          begin
            bp:= TEzSymbolProperty.Create(pn);
            bp.ValInteger:= EzLib.IMin( Ez_Symbols.Count-1,
              EzLib.IMax(StrToIntDef(Column.Strings[J], 0), 0) );
            Inspector1.ReplaceProperty( pn, bp );
          end;
        ctBitmap:
          begin
            bp:= TEzDefineAnyLocalImageProperty.Create(pn);
            bp.ValString:= Column.Strings[J];
            Inspector1.ReplaceProperty( pn, bp );
          end;
      end;
    end;
  end;
end;

end.
