unit fRangesEditor;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, EzInspect, StdCtrls, Buttons, ExtCtrls, EzThematics, ezbasegis;

type
  TfrmRangesEditor = class(TForm)
    Panel1: TPanel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    ListBox1: TListBox;
    Panel2: TPanel;
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
  private
    { Private declarations }
    FBuilder: TEzThematicBuilder;
    FLast: Integer;
    FDrawBox: TEzBaseDrawBox;
    procedure UpdateProperties;
  public
    { Public declarations }
    function Enter( Builder: TEzThematicBuilder; DrawBox: TEzBaseDrawBox  ):Word;
  end;

implementation

{$R *.DFM}

uses
  EzLib, EzSystem;

{ TfrmColumnsEditor }

function TfrmRangesEditor.Enter( Builder: TEzThematicBuilder; DrawBox: TEzBaseDrawBox ):Word;
var
  I: Integer;
  ColsStrings: TStrings;
begin
  FDrawBox := DrawBox;

  FBuilder:= Builder;
  for I:= 0 to FBuilder.ThematicRanges.Count-1 do
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

procedure TfrmRangesEditor.btnDeleteClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:= ListBox1.ItemIndex;
  if Index < 0 then Exit;
  FBuilder.ThematicRanges.Delete( Index );
  ListBox1.Items.Delete( Index );
  if Index <= ListBox1.Items.Count - 1 then
    ListBox1.ItemIndex:= Index
  else if ListBox1.Items.Count > 0 then
    ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.OnClick(Nil);
end;

procedure TfrmRangesEditor.btnAddClick(Sender: TObject);
begin
  FBuilder.ThematicRanges.Add;
  ListBox1.Items.Add( '' );
  ListBox1.ItemIndex:= ListBox1.Items.Count-1;
  ListBox1.OnClick(Nil);
end;

procedure TfrmRangesEditor.BtnUPClick(Sender: TObject);
begin
  if ListBox1.ItemIndex < 0 then Exit;
  if FBuilder.ThematicRanges.Up( ListBox1.ItemIndex ) then
  begin
    ListBox1.ItemIndex:= ListBox1.ItemIndex - 1;
    ListBox1.OnClick(Nil);
  end;
  ListBox1.Invalidate;
end;

procedure TfrmRangesEditor.BtnDOWNClick(Sender: TObject);
begin
  if ListBox1.ItemIndex < 0 then Exit;
  if FBuilder.ThematicRanges.Down( ListBox1.ItemIndex ) then
  begin
    ListBox1.ItemIndex:= ListBox1.ItemIndex + 1;
    ListBox1.OnClick(Nil);
  end;
  ListBox1.Invalidate;
end;

procedure TfrmRangesEditor.ListBox1DrawItem(Control: TWinControl;
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
    AText:= Format('Range %d',[Index]);
    TextOut( Rect.Left, Rect.Top, AText);
  end;
end;

procedure TfrmRangesEditor.ListBox1Click(Sender: TObject);
var
  Range: TEzThematicItem;
  bp: TEzBaseProperty;
  tv: TEzTreeViewProperty;
begin
  if ListBox1.ItemIndex < 0 then Exit;
  UpdateProperties;

  Inspector1.ClearPropertyList;
  Inspector1.Visible:= true;

  FLast:= ListBox1.ItemIndex;
  { fill the property list }
  Range:= Self.FBuilder.ThematicRanges[Flast];

  tv:= TEzTreeViewProperty.Create('General');
  tv.readonly:=true;
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzStringProperty.Create('Legend');
  bp.ValString:= Range.Legend;
  bp.Hint:= 'Define the legend for this range';
  tv.AddProperty( bp );

  bp:= TEzExpressionProperty.Create('Expression');
  TEzExpressionProperty(bp).Gis:= FDrawBox.Gis;
  TEzExpressionProperty(bp).LayerName:= Self.FBuilder.LayerName;
  bp.ValString:= Range.Expression;
  bp.Hint:= 'Define the expression for this range';
  tv.AddProperty( bp );

  { pen style }
  tv:= TEzTreeViewProperty.Create('Pen');
  tv.readonly:=true;
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzLinetypeProperty.Create('PenStyle');
  bp.ValInteger:= Range.PenStyle.Style;
  bp.Hint:= 'Select the pen style';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('PenColor');
  bp.ValInteger:= Range.PenStyle.Color;
  bp.Hint:= 'Select the pen color';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('PenWidth(Scale)');
  bp.ValFloat:= Range.PenStyle.Scale;
  bp.Hint:= 'Select the pen width or scale';
  tv.AddProperty( bp );

  { brush style }
  tv:= TEzTreeViewProperty.Create('Brush');
  tv.readonly:=true;
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzBrushstyleProperty.Create('BrushPattern');
  bp.ValInteger:= Range.BrushStyle.Pattern;
  bp.Hint:= 'Select the brush pattern';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('BrushForeColor');
  bp.ValInteger:= Range.BrushStyle.ForeColor;
  bp.Hint:= 'Select the brush foreground color';
  tv.AddProperty( bp );

  bp:= TEzColorProperty.Create('BrushBackColor');
  TEzColorProperty(bp).NoneColorText:= '&Transparent';
  TEzColorProperty(bp).ShowSystemColors:= true;
  bp.ValInteger:= Range.BrushStyle.BackColor;
  bp.Hint:= 'Select the brush background color';
  tv.AddProperty( bp );

  { symbol style }
  tv:= TEzTreeViewProperty.Create('Symbol');
  tv.readonly:=true;
  Inspector1.AddProperty( tv );
  tv.Modified:=true;    { causes to show on bold}

  bp:= TEzSymbolProperty.Create('SymbolIndex');
  bp.ValInteger:= Range.SymbolStyle.Index;
  bp.Hint:= 'Select the symbol to use';
  tv.AddProperty( bp );

  bp:= TEzAngleProperty.Create('SymbolRotangle');
  bp.ValFloat:= Range.SymbolStyle.Rotangle;
  bp.Hint:= 'Define rotation angle';
  tv.AddProperty( bp );

  bp:= TEzFloatProperty.Create('SymbolHeight');
  bp.ValFloat:= Range.SymbolStyle.Height;
  bp.Hint:= 'Define height of symbol';
  tv.AddProperty( bp );

  Inspector1.FullExpand;

end;

procedure TfrmRangesEditor.UpdateProperties;
var
  Range: TEzThematicItem;
  bp: TEzBaseProperty;
begin
  if (FLast < 0 ) or (FLast > ListBox1.Items.Count - 1 ) then Exit;

  { update the properties here }

  Range:= FBuilder.ThematicRanges[FLast];

  bp:= Inspector1.GetPropertyByName('Legend');
  if bp.modified then
    Range.Legend:= bp.ValString;

  bp:= Inspector1.GetPropertyByName('Expression');
  if bp.modified then
    Range.Expression:= bp.ValString;

  bp:= Inspector1.GetPropertyByName('PenStyle');
  if bp.modified then
    Range.Penstyle.Style:= bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('PenColor');
  if bp.modified then
    Range.Penstyle.Color:= bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('PenWidth(Scale)');
  if bp.modified then
    Range.Penstyle.Width:= bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('BrushPattern');
  if bp.modified then
    Range.BrushStyle.Pattern:= bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('BrushForeColor');
  if bp.modified then
    Range.BrushStyle.ForeColor:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('BrushBackColor');
  if bp.modified then
    Range.BrushStyle.BackColor:=bp.ValInteger;

  { symbol style }

  bp:= Inspector1.GetPropertyByName('SymbolIndex');
  if bp.modified then
    Range.SymbolStyle.Index:=bp.ValInteger;

  bp:= Inspector1.GetPropertyByName('SymbolRotangle');
  if bp.modified then
    Range.SymbolStyle.Rotangle:=bp.ValFloat;

  bp:= Inspector1.GetPropertyByName('SymbolHeight');
  if bp.modified then
    Range.SymbolStyle.Height:=bp.ValFloat;

end;

procedure TfrmRangesEditor.FormClose(Sender: TObject; var Action: TCloseAction);
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

end.
