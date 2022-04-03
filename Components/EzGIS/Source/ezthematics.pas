unit EzThematics;

{$I EZ_FLAG.PAS}
interface

Uses
  Windows, SysUtils, Classes, Messages, Graphics, Controls, StdCtrls, ExtCtrls,
  EzBaseGis, ezbase, ezlib, grids, EzMiscelEntities ;

type
  {-------------------------------------------------------------------------------}
  {                  Define TEzThematicBuilder                                        }
  {-------------------------------------------------------------------------------}

  TEzThematicBuilder = Class;

  // TEzThematicItem class
  TEzThematicItem = Class( TCollectionItem )
  Private
    FExpression: String;
    FLegend: String;
    FFrequency: Integer;
    FPenStyle: TEzPenTool;
    FBrushStyle: TEzBrushTool;
    FSymbolStyle: TEzSymbolTool;
    FFontStyle: TEzFontTool;
    procedure SetBrushstyle(Value:TEzBrushtool);
    procedure SetPenstyle(Value:TEzPentool);
    procedure SetSymbolStyle(Value:TEzSymboltool);
    procedure SetFontStyle(Value:TEzFonttool);
  Protected
    Function GetDisplayName: String; Override;
  Public
    Constructor Create( Collection: TCollection ); Override;
    destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Legend: String Read FLegend Write FLegend;
    Property Expression: String Read FExpression Write FExpression;
    Property PenStyle: TEzPenTool read FPenStyle write SetPenStyle;
    Property BrushStyle: TEzBrushTool read FBrushStyle write SetBrushStyle;
    Property SymbolStyle: TEzSymbolTool read FSymbolStyle write SetSymbolStyle;
    Property FontStyle: TEzFontTool read FFontStyle Write SetFontStyle;
    Property Frequency: Integer read FFrequency write FFrequency;
  End;

  TEzThematicRanges = Class( TOwnedCollection )
  Private
    FThematicBuilder: TEzThematicBuilder;
    Function GetItem( Index: Integer ): TEzThematicItem;
    Procedure SetItem( Index: Integer; Value: TEzThematicItem );
  Public
    Constructor Create( AOwner: TPersistent );
    Destructor Destroy; Override;
    Function Add: TEzThematicItem;
    function Up( Index: Integer ): Boolean;
    function Down( Index: Integer ): Boolean;
{$IFDEF DELPHI4}
    Procedure Delete(Index: Integer );
{$ENDIF}

    Property Items[Index: Integer]: TEzThematicItem Read GetItem Write SetItem; Default;
  End;

  TEzThematicBuilder = Class( TComponent )
  Private
    FLayerName: string;
    FThematicRanges: TEzThematicRanges;
    FTitle: String;
    FShowThematic: Boolean;
    //FSaveBeforePaintEntity: TEzBeforePaintEntityEvent;
    FExprList: TList;
    FPenStyle: TEzPenTool;
    FBrushStyle: TEzBrushTool;
    FSymbolStyle: TEzSymbolTool;
    FFontStyle: TEzFontTool;
    FApplyPen: Boolean;
    FApplyBrush: Boolean;
    FApplySymbol: Boolean;
    FApplyFont: Boolean;
    FApplyColor: Boolean;
    FThematicOpened: Boolean;
    //FIsBeforePaintEntity: Boolean;
    Procedure SetThematicRanges( Value: TEzThematicRanges );
    procedure BeforePaintEntity( Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas;
      Const Clip: TEzRect; DrawMode: TEzDrawMode;
      Var CanShow: Boolean; Var EntList: TEzEntityList; Var AutoFree: Boolean );
    Function StartThematic( Layer: TEzBaseLayer ): Boolean;
    Function CalcThematicInfo( Layer: TEzBaseLayer; Recno: Integer ): Boolean;
    Procedure EndThematic;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    procedure Assign( Source: TPersistent ); Override;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile( const FileName: string );
    procedure SaveToFile( const FileName: string );
    procedure Prepare(Layer: TEzBaseLayer );
    procedure UnPrepare( Layer: TEzBaseLayer );
    Procedure CreateAutomaticThematicRange( Gis: TEzBaseGis;
      NumRanges: Integer; const ThematicLayer, FieldName: String;
      BrushStartColor, BrushStopColor: TColor;
      BrushPattern: Integer; LineStartColor, LineStopColor: TColor;
      LineStyle: Integer; AutoLineWidth, CalcbyRange, IgnoreZero, ManualRange: boolean;
      ManualRangevalue: Double; DecimalPos: Integer );
    Procedure CreateAutomaticThematicRangeStrField( Gis: TEzBaseGis;
      const ThematicLayer, FieldName: String;
      BrushStartColor, BrushStopColor: TColor; BrushPattern: Integer;
      LineStartColor, LineStopColor: TColor; LineStyle: Integer; AutoLineWidth: Boolean );
    Procedure Recalculate( Gis: TEzBaseGis );
  Published
    Property LayerName: string read FLayerName write FLayerName;
    Property ThematicRanges: TEzThematicRanges Read FThematicRanges Write SetThematicRanges;
    Property Title: String Read FTitle Write FTitle;
    Property ShowThematic: Boolean read FShowThematic write FShowThematic default True;
    Property ApplyPen: Boolean read FApplyPen write FApplyPen default true;
    Property ApplyBrush: Boolean read FApplyBrush write FApplyBrush default true;
    Property ApplyColor: Boolean read FApplyColor write FApplyColor default true;
    Property ApplySymbol: Boolean read FApplySymbol write FApplySymbol default true;
    Property ApplyFont: Boolean read FApplyFont write FApplyFont default true;
  End;

  { TEzLegend component }

  TEzLegendItem = Class( TCollectionItem )
  Private
    FLegend: String;
    FSubLegend: string;
    FFrequency: Integer;
    FPenStyle: TEzPenTool;
    FBrushStyle: TEzBrushTool;
    FSymbolStyle: TEzSymbolTool;
    FFontStyle: TEzFonttool;
    FColor: TColor;
    FImageIndex: Integer;
    procedure SetBrushstyle(Value:TEzBrushtool);
    procedure SetPenstyle(Value:TEzPentool);
    procedure SetSymbolStyle(Value:TEzSymboltool);
    procedure SetColor(const Value: TColor);
    Procedure InvalidateLegend;
    procedure SetImageIndex(const Value: Integer);
    procedure SetFontStyle(const Value: TEzFonttool);
  Protected
    Function GetDisplayName: String; Override;
  Public
    Constructor Create( Collection: TCollection ); Override;
    destructor Destroy; Override;
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property Legend: String Read FLegend Write FLegend;
    Property SubLegend: String Read FSubLegend Write FSubLegend;
    Property Frequency: Integer read FFrequency write FFrequency;
    Property PenStyle: TEzPenTool read FPenStyle write SetPenStyle;
    Property BrushStyle: TEzBrushTool read FBrushStyle write SetBrushStyle;
    Property SymbolStyle: TEzSymbolTool read FSymbolStyle write SetSymbolStyle;
    Property FontStyle: TEzFonttool read FFontStyle write SetFontStyle;
    Property Color: TColor read FColor write SetColor;
    Property ImageIndex: Integer read FImageIndex write SetImageIndex;
  End;

  TEzLegendRanges = Class( TOwnedCollection )
  Private
    Function GetItem( Index: Integer ): TEzLegendItem;
    Procedure SetItem( Index: Integer; Value: TEzLegendItem );
  Public
    Constructor Create( AOwner: TPersistent );
    Function Add: TEzLegendItem;
    function Up( Index: Integer ): Boolean;
    function Down( Index: Integer ): Boolean;
    function Owner: TPersistent;

    Property Items[Index: Integer]: TEzLegendItem Read GetItem Write SetItem; Default;
  End;

  TEzLegend = class(TCustomGrid)
  Private
    FLegendStyle: TEzColumnType;
    FLegendRanges: TEzLegendRanges;
    FShowTitle: Boolean;
    FTitle0: string;
    FTitle1: string;
    FTitle2: string;
    FImageList: TImageList;
    FStretch: Boolean;
    FPenTool: TEzPenTool;
    FBrushTool: TEzBrushTool;
    FBorderWidth: Integer;
    FLoweredColor: TColor;
    FTransparent: Boolean;
    FInColChange: Boolean;
    FTitleFont: TFont;
    FTitleColor: TColor;
    FTitleTransparent: Boolean;
    FTitleAlignment: TAlignment;
    procedure SetLegendStyle(const Value: TEzColumnType);
    procedure SetLegendRanges(const Value: TEzLegendRanges);
    procedure SetShowTitle(const Value: Boolean);
    procedure SetTitle0(const Value: string);
    procedure SetTitle1(const Value: string);
    procedure SetTitle2(const Value: string);
    procedure SetImageList(const Value: TImageList);
    procedure InitializeRows;
    procedure SetStretch(const Value: Boolean);
    procedure SetBrushTool(const Value: TEzBrushTool);
    procedure SetPenTool(const Value: TEzPenTool);
    procedure SetTitleFont(const Value: TFont);
  Protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    procedure ColWidthsChanged; override;
  Public
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; override;
    Procedure PopulateFrom( Source: TEzThematicBuilder );
    procedure AdjustColWidths;

    { inherited properties }
    property ColWidths;
    property Row;
    property RowCount;
    property Col;
    property ColCount;
    property RowHeights;
  Published
    Property PenTool: TEzPenTool read FPenTool write SetPenTool;
    Property BrushTool: TEzBrushTool read FBrushTool write SetBrushTool;
    Property BorderWidth: Integer read FBorderWidth write FBorderWidth;
    Property LoweredColor: TColor read FLoweredColor write FLoweredColor;
    Property TitleFont: TFont read FTitleFont write SetTitleFont;
    Property TitleColor: TColor read FTitleColor write FTitleColor;
    Property TitleTransparent: Boolean read FTitleTransparent write FTitleTransparent;
    Property TitleAlignment: TAlignment read FTitleAlignment write FTitleAlignment;
    Property Transparent: Boolean read FTransparent write FTransparent;
    Property LegendStyle: TEzColumnType read FLegendStyle write SetLegendStyle;
    Property LegendRanges: TEzLegendRanges Read FLegendRanges Write SetLegendRanges;
    Property ShowTitle: Boolean read FShowTitle write SetShowTitle;
    Property Title0: string read FTitle0 write SetTitle0;
    Property Title1: string read FTitle1 write SetTitle1;
    Property Title2: string read FTitle2 write SetTitle2;
    Property ImageList: TImageList read FImageList write SetImageList;
    Property Stretch: Boolean read FStretch write SetStretch;
    { inherited properties and events }
    property Options;
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DefaultColWidth;
    property DefaultRowHeight;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property GridLineWidth;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
    property OnClick;
{$IFDEF LEVEL5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
  End;

implementation

uses
  Forms, EzMiscelCtrls, ezgraphics, ezlinedraw, ezsystem, ezbaseexpr, ezconsts,
  ezentities, EzExpressions;

{-------------------------------------------------------------------------------}
{                  Implements TEzThematicItem                                     }
{-------------------------------------------------------------------------------}

Constructor TEzThematicItem.Create( Collection: TCollection );
Begin
  Inherited Create( Collection );
  FPenStyle:= TEzPentool.Create;
  FPenStyle.Style:= 1;
  FBrushStyle:= TEzBrushtool.Create;
  FBrushStyle.Pattern:= 1;
  FFontStyle:= TEzFonttool.Create;
  FSymbolStyle:= TEzSymboltool.Create;
End;

destructor TEzThematicItem.Destroy;
begin
  FPenStyle.free;
  FBrushStyle.Free;
  FFontStyle.Free;
  FSymbolStyle.Free;
  inherited Destroy;
end;

Procedure TEzThematicItem.Assign( Source: TPersistent );
Begin
  If Source Is TEzThematicItem Then
  Begin
    FExpression := TEzThematicItem( Source ).Expression;
    FLegend := TEzThematicItem( Source ).Legend;
    FFrequency:= TEzThematicItem( Source ).FFrequency;
    FPenStyle.Assign( TEzThematicItem( Source ).PenStyle );
    FBrushStyle.Assign( TEzThematicItem( Source ).BrushStyle );
    FFontStyle.Assign( TEzThematicItem( Source ).FontStyle );
    FSymbolStyle.Assign( TEzThematicItem( Source ).SymbolStyle );
  End
  Else
    Inherited Assign( Source );
End;

Function TEzThematicItem.GetDisplayName: String;
Begin
  If FLegend = '' Then
    Result := Inherited GetDisplayName
  else
    result := FLegend;
End;

procedure TEzThematicItem.SetBrushstyle(Value:TEzBrushtool);
begin
  FBrushstyle.Assign(Value);
end;

procedure TEzThematicItem.SetPenstyle(Value:TEzPentool);
begin
  FPenstyle.Assign(Value);
end;

procedure TEzThematicItem.SetSymbolStyle(Value:TEzSymboltool);
begin
  FSymbolstyle.Assign(Value);
end;

procedure TEzThematicItem.SetFontStyle(Value:TEzFonttool);
begin
  FFontStyle.Assign(Value);
end;

{-------------------------------------------------------------------------------}
{                  Implements TEzThematicRanges                                   }
{-------------------------------------------------------------------------------}

Constructor TEzThematicRanges.Create( AOwner: TPersistent );
Begin
  Inherited Create( AOwner, TEzThematicItem );
  FThematicBuilder := AOwner As TEzThematicBuilder;
End;

Destructor TEzThematicRanges.destroy;
Begin
  FThematicBuilder := Nil;
  Inherited Destroy;
End;

Function TEzThematicRanges.GetItem( Index: Integer ): TEzThematicItem;
Begin
  Result := TEzThematicItem( Inherited GetItem( Index ) );
End;

Procedure TEzThematicRanges.SetItem( Index: Integer; Value: TEzThematicItem );
Begin
  Inherited SetItem( Index, Value );
End;

Function TEzThematicRanges.Add: TEzThematicItem;
Begin
  Result := TEzThematicItem( Inherited Add );
End;

function TEzThematicRanges.Down( Index: Integer ): Boolean;
begin
  Result:= False;
  if ( Index < 0 ) or ( Index >= Count - 1 ) then Exit;
  GetItem( Index ).Index := Index + 1;
  Result:= True;
End;

function TEzThematicRanges.Up( Index: Integer ): Boolean;
begin
  Result:= False;
  if ( Index <= 0 ) or ( Index > Count - 1 ) then Exit;
  GetItem( Index ).Index := Index - 1;
  Result:= True;
end;

{$IFDEF DELPHI4}
Procedure TEzThematicRanges.Delete(Index: Integer );
Begin
  if ( Index < 0 ) or ( Index > Count - 1 ) then Exit;
  GetItem( Index ).Free;
End;
{$ENDIF}

{-------------------------------------------------------------------------------}
{                  Implements TEzThematicBuilder                                    }
{-------------------------------------------------------------------------------}

Constructor TEzThematicBuilder.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FThematicRanges := TEzThematicRanges.Create( Self );
  FPenStyle:= TEzPentool.Create;
  FBrushStyle:= TEzBrushtool.Create;
  FFontStyle:= TEzFonttool.Create;
  FSymbolStyle:= TEzSymboltool.Create;
  FApplyPen:=false;
  FApplyBrush:=false;
  FApplyColor:=true;
  FApplySymbol:=false;
  FApplyFont:=false;
  FShowThematic:= True;
End;

Destructor TEzThematicBuilder.Destroy;
Begin
  FThematicRanges.Free;
  FPenStyle.free;
  FBrushStyle.Free;
  FFontStyle.Free;
  FSymbolStyle.Free;
  if FExprList <> Nil then
    EndThematic;
  Inherited Destroy;
End;

procedure TEzThematicBuilder.Assign(Source: TPersistent);
begin
  if Source is TEzThematicBuilder then
  begin
    LayerName := TEzThematicBuilder( Source ).LayerName;
    ThematicRanges.Assign( TEzThematicBuilder( Source ).ThematicRanges );
    Title := TEzThematicBuilder( Source ).Title;
    ShowThematic := TEzThematicBuilder( Source ).ShowThematic;
    ApplyPen := TEzThematicBuilder( Source ).ApplyPen;
    ApplyBrush:= TEzThematicBuilder( Source ).ApplyBrush;
    ApplySymbol:= TEzThematicBuilder( Source ).ApplySymbol;
    ApplyFont := TEzThematicBuilder( Source ).ApplyFont;
  end else
    inherited Assign( Source );
end;

const
  ThematicFileID = 890504;

procedure TEzThematicBuilder.SaveToStream(Stream: TStream);
var
  I, n, IDFile: Integer;
begin
  IDFile:= ThematicFileID;
  with Stream do
  begin
    Write(IDFile,sizeof(IDFile));
    EzWriteStrToStream( FTitle, stream );
    EzWriteStrToStream( FLayerName, stream );
    Write(FShowThematic,sizeof(FShowThematic));
    Write(FApplyPen,sizeof(FApplyPen));
    Write(FApplyBrush,sizeof(FApplyBrush));
    Write(FApplySymbol,sizeof(FApplySymbol));
    Write(FApplyFont,sizeof(FApplyFont));

    n:= ThematicRanges.Count;
    Write(n,sizeof(n));
    for I:= 0 to n-1 do
    begin
      with ThematicRanges[I] do
      begin
        EzWriteStrToStream( FLegend, stream );
        EzWriteStrToStream( FExpression, stream );
        Write(FFrequency,sizeof(FFrequency));
        FPenStyle.SaveToStream(Stream);
        FBrushStyle.SaveToStream(Stream);
        FSymbolStyle.SaveToStream(Stream);
        FFontStyle.SaveToStream(Stream);
      end;
    end;
  end;
end;

procedure TEzThematicBuilder.LoadFromStream(Stream: TStream);
var
  I, n, IDFile: Integer;
begin
  ThematicRanges.Clear;
  with Stream do
  begin
    Read(IDFile,sizeof(IDFile));
    if IDFile <> ThematicFileID then Exit;
    FTitle:= EzReadStrFromStream( stream );
    FLayerName:= EzReadStrFromStream( stream );
    Read(FShowThematic,sizeof(FShowThematic));
    Read(FApplyPen,sizeof(FApplyPen));
    Read(FApplyBrush,sizeof(FApplyBrush));
    Read(FApplySymbol,sizeof(FApplySymbol));
    Read(FApplyFont,sizeof(FApplyFont));

    Read(n,sizeof(n));
    for I:= 0 to n-1 do
    begin
      with ThematicRanges.Add do
      begin
        FLegend:= EzReadStrFromStream( stream );
        FExpression:= EzReadStrFromStream( stream );
        Read(FFrequency,sizeof(FFrequency));
        FPenStyle.LoadFromStream(Stream);
        FBrushStyle.LoadFromStream(Stream);
        FSymbolStyle.LoadFromStream(Stream);
        FFontStyle.LoadFromStream(Stream);
      end;
    end;
  end;
end;

procedure TEzThematicBuilder.LoadFromFile( const FileName: string );
var
  stream: TStream;
begin
  if not FileExists(FileName) then exit;
  stream:= TFileStream.create(FileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(stream);
  finally
    stream.free;
  end;
end;

procedure TEzThematicBuilder.SaveToFile( const FileName: string );
var
  stream: TStream;
begin
  stream:= TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(stream);
  finally
    stream.free;
  end;
end;

Procedure TEzThematicBuilder.SetThematicRanges( Value: TEzThematicRanges );
Begin
  FThematicRanges.Assign( Value );
End;

Function TEzThematicBuilder.StartThematic( Layer: TEzBaseLayer ): Boolean;
Var
  MainExpr: TEzMainExpr;
  I: Integer;
Begin
  Result:= False;
  if (FThematicRanges.Count = 0) Or (Layer = Nil) Or Not (Layer.LayerInfo.Visible) then Exit;
  EndThematic;
  FExprList := TList.Create;
  Try
    For I := 0 To FThematicRanges.Count - 1 Do
    Begin
      if Length(FThematicRanges[I].Expression) = 0 then
        Raise EExpression.Create( SExprFail )
      else
      begin
        // evaluate expression
        MainExpr := TEzMainExpr.Create( Layer.Layers.Gis, Layer );
        MainExpr.ParseExpression( FThematicRanges[I].Expression );
        If ( MainExpr.Expression <> Nil ) And
           ( MainExpr.Expression.ExprType <> ttBoolean ) Then
        Begin
          MainExpr.Free;
          Raise EExpression.Create( SExprFail );
        End;
        If MainExpr.Expression <> Nil Then
          FExprList.Add( MainExpr )
        Else
        begin
          MainExpr.Free;
          Raise EExpression.Create( SExprFail );
        end;
      end;
    End;
  Except
    Self.FShowThematic := False;
    EndThematic;
    Raise;
  End;
  Result := True;
End;

Function TEzThematicBuilder.CalcThematicInfo( Layer: TEzBaseLayer; Recno: Integer ): Boolean;
Var
  I: Integer;
Begin
  Result:= False;
  If Layer.Recno <> Recno Then
    Layer.Recno := Recno;
  Layer.Synchronize;
  For I := 0 To FExprList.Count - 1 Do
    If TEzMainExpr(FExprList[I]).Expression.AsBoolean = true Then
      Begin
        Self.FPenStyle.Assign( FThematicRanges[I].PenStyle );
        Self.FBrushstyle.Assign( FThematicRanges[I].BrushStyle );
        Self.FSymbolstyle.Assign( FThematicRanges[I].SymbolStyle );
        Self.FFontStyle.Assign( FThematicRanges[I].FontStyle );
        Result:= True;
        Exit;
      End;
End;

Procedure TEzThematicBuilder.EndThematic;
var
  I: Integer;
Begin
  if FExprList = Nil then Exit;
  for I:= 0 to FExprList.Count - 1 do
    TEzMainExpr( FExprList[I] ).Free;
  FreeAndNil( FExprList );
End;

procedure TEzThematicBuilder.Recalculate( Gis: TEzBaseGis );
var
  Layer: TEzBaseLayer;
  I: Integer;
begin
  Layer:= Gis.Layers.LayerByName( FLayerName );
  if Layer = Nil then Exit;
  if Not StartThematic( Layer ) then Exit;
  for I:= 0 to FThematicRanges.Count-1 do
    FThematicRanges[I].FFrequency:= 0;
  Screen.Cursor:= crHourglass;
  try
    Layer.First;
    Layer.StartBuffering;
    Try
      While Not Layer.Eof Do
      Begin
        Try
          If Layer.RecIsDeleted Then Continue;
          Layer.Synchronize;
          For I := 0 To FExprList.Count - 1 Do
            If TEzMainExpr(FExprList[I]).Expression.AsBoolean = true Then
              Begin
                Inc( FThematicRanges[I].FFrequency );
                Break;
              End;
        Finally
          Layer.Next;
        End;
      End;
    Finally
      Layer.EndBuffering;
    End;
  finally
    EndThematic;
    Screen.Cursor:= crDefault;
  end;
end;

Procedure TEzThematicBuilder.Prepare( Layer: TEzBaseLayer );
Begin
  If FShowThematic And ( AnsiCompareText( Layer.Name, Self.FLayerName ) = 0 ) then
  begin
    FThematicOpened := Self.StartThematic( Layer );

    If FThematicOpened then
    begin
      //FSaveBeforePaintEntity := Layer.OnBeforePaintEntity;
      //FIsBeforePaintEntity := Assigned( FSaveBeforePaintEntity );

      Layer.OnBeforePaintEntity := Self.BeforePaintEntity;
    end;
  end;
End;

Procedure TEzThematicBuilder.UnPrepare( Layer: TEzBaseLayer );
Begin
  If FThematicOpened And ( AnsiCompareText( Layer.Name, Self.FLayerName ) = 0 ) then
  begin
    EndThematic;
    //Layer.OnBeforePaintEntity := FSaveBeforePaintEntity;
    Layer.OnBeforePaintEntity := Nil;
  end;
  FThematicOpened := False;
End;

Procedure TEzThematicBuilder.BeforePaintEntity( Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
  DrawMode: TEzDrawMode; Var CanShow: Boolean; Var EntList: TEzEntityList;
  Var AutoFree: Boolean );
Begin
  { call the old event handler }
  {If FIsBeforePaintEntity And (FSaveBeforePaintEntity <> BeforePaintEntity) Then
    FSaveBeforePaintEntity( Sender, Layer, Recno, Entity, Grapher, Canvas,
      Clip, DrawMode, CanShow ); }
  if not CanShow then Exit;

  With Layer Do
  Begin
    If FThematicOpened And ( Entity.EntityID In [idPoint, idPlace,
      idPolyline, idPolygon, idRectangle, idArc, idEllipse, idSpline] ) Then
    Begin
      if not Self.CalcThematicInfo( Layer, Recno ) then Exit;

      if (Entity is TEzOpenedEntity) and FApplyPen then
      begin
        TEzOpenedEntity(Entity).Pentool.Assign(Self.FPenstyle);
      end;
      if Entity is TEzClosedEntity and FApplyBrush then
      begin
        TEzClosedEntity(Entity).Brushtool.Assign(Self.FBrushstyle);
      end;
      if (Entity.EntityID = idPoint) and FApplyPen then
      begin
        TEzPointEntity(Entity).Color:= Self.FPenstyle.Color;
      end;
      if (Entity.EntityID = idPlace) and FApplySymbol then
      begin
        TEzPlace(Entity).Symboltool.Assign( Self.FSymbolStyle );
      end;
      if (Entity.EntityID = idTrueTypeText) and FApplyFont then
      begin
        TEzTrueTypeText(Entity).Fonttool.Assign( Self.FFontStyle );
      end;
      if (Entity.EntityID = idJustifVectText) and FApplyFont then
      begin
        with TEzJustifVectorText(Entity) do
        begin
          FontName:= self.FFontStyle.Name;
          Height:= self.FFontStyle.Height;
          Fontcolor:= self.FFontStyle.Color;
        end;
      end;
      if (Entity.EntityID = idFittedVectText) and FApplyFont then
      begin
        with TEzFittedVectorText(Entity) do
        begin
          FontName:= self.FFontStyle.Name;
          Height:= self.FFontStyle.Height;
          Fontcolor:= self.FFontStyle.Color;
        end;
      end;
    End;
  End;
End;

{ for string fields only }
Procedure TEzThematicBuilder.CreateAutomaticThematicRangeStrField( Gis: TEzBaseGis;
  const ThematicLayer, FieldName: String;
  BrushStartColor, BrushStopColor: TColor; BrushPattern: Integer;
  LineStartColor, LineStopColor: TColor; LineStyle: Integer; AutoLineWidth: Boolean );
var
  Layer: TEzBaseLayer;
  DiscreteValues: TStrings;
  EdExpr, TmpStr, Pivot, Value: string;
  Cnt, NumRanges, Index: Integer;
  BeginColor, EndColor, StepColor: TColor;
  LineBeginColor, LineEndColor, LineStepColor: TColor;
  R, G, B: Byte;
  BeginRGBValue, LineBeginRGBValue: Array[0..2] Of Byte;
  RGBDiff, LineRGBDiff: Array[0..2] Of Integer;
  MainExpr: TEzMainExpr;
  FThematicLayer: TEzBaseLayer;
Begin
  If FieldName = '' Then
  Begin
    MessageToUser( SExpresionNull, smsgerror, MB_ICONERROR );
    Exit;
  End;
  EdExpr := ThematicLayer + '.' + Fieldname;
  FThematicLayer := Gis.Layers.LayerByName( Thematiclayer );
  If FThematicLayer = Nil Then Exit;
  MainExpr := TEzMainExpr.Create( Gis, FThematicLayer );
  Try
    MainExpr.ParseExpression( EdExpr );
  Except
    On E: Exception Do
    Begin
      MessageToUser( E.Message, smsgerror, MB_ICONERROR );
      MainExpr.Free;
      Exit;
    End;
  End;
  DiscreteValues:= TStringList.create;
  Gis.StartProgress( SCalculatingRanges, 1, FThematicLayer.RecordCount );
  try
    cnt:= 0;
    FThematicLayer.First;
    while not FThematicLayer.Eof do
    begin
      Inc( cnt );
      Gis.UpdateProgress( cnt );

      if FThematicLayer.RecIsDeleted then
      begin
        FThematicLayer.Next;
        Continue;
      end;
      FThematicLayer.Synchronize;
      Value:= MainExpr.Expression.AsString;
      if Length(Trim(Value)) > 0 then
        DiscreteValues.Add( Value );
      FThematicLayer.Next;
    end;
    if DiscreteValues.Count = 0 then Exit;
    TStringList( DiscreteValues ).Sort;
    { now delete repeated records }
    Index:= 0;
    Pivot:= DiscreteValues[0];
    DiscreteValues.Objects[Index]:= Pointer( -1 );
    Inc(Index);
    while Index < DiscreteValues.Count do
    begin
      If DiscreteValues[Index] <> Pivot then
      begin
        DiscreteValues.Objects[Index]:= Pointer( -1 );
        Pivot := DiscreteValues[Index];
      end;
      Inc( Index );
    end;
    { now delete all non-marked records and that will be the ranges }
    for Index := DiscreteValues.Count-1 downto 0 do
      if DiscreteValues.Objects[Index] = Nil then
        DiscreteValues.Delete( Index );

    { create the ranges now. One color for every range }
    // for fill color
    BeginColor := ColorToRGB( BrushStartColor );
    EndColor := ColorToRGB( BrushStopColor );
    BeginRGBValue[0] := GetRValue( BeginColor );
    BeginRGBValue[1] := GetGValue( BeginColor );
    BeginRGBValue[2] := GetBValue( BeginColor );
    RGBDiff[0] := GetRValue( EndColor ) - BeginRGBValue[0];
    RGBDiff[1] := GetGValue( EndColor ) - BeginRGBValue[1];
    RGBDiff[2] := GetBValue( EndColor ) - BeginRGBValue[2];
    // for line color
    LineBeginColor := ColorToRGB( LineStartColor );
    LineEndColor := ColorToRGB( LineStopColor );
    LineBeginRGBValue[0] := GetRValue( LineBeginColor );
    LineBeginRGBValue[1] := GetGValue( LineBeginColor );
    LineBeginRGBValue[2] := GetBValue( LineBeginColor );
    LineRGBDiff[0] := GetRValue( LineEndColor ) - LineBeginRGBValue[0];
    LineRGBDiff[1] := GetGValue( LineEndColor ) - LineBeginRGBValue[1];
    LineRGBDiff[2] := GetBValue( LineEndColor ) - LineBeginRGBValue[2];

    ThematicRanges.Clear;

    NumRanges := DiscreteValues.Count;

    For cnt := 0 To NumRanges - 1 Do
    Begin
      R := BeginRGBValue[0] + MulDiv( cnt, RGBDiff[0], Pred( NumRanges ) );
      G := BeginRGBValue[1] + MulDiv( cnt, RGBDiff[1], Pred( NumRanges ) );
      B := BeginRGBValue[2] + MulDiv( cnt, RGBDiff[2], Pred( NumRanges ) );
      StepColor := RGB( R, G, B );
      // line color
      R := LineBeginRGBValue[0] + MulDiv( cnt, LineRGBDiff[0], Pred( NumRanges ) );
      G := LineBeginRGBValue[1] + MulDiv( cnt, LineRGBDiff[1], Pred( NumRanges ) );
      B := LineBeginRGBValue[2] + MulDiv( cnt, LineRGBDiff[2], Pred( NumRanges ) );
      LineStepColor := RGB( R, G, B );

      DiscreteValues[cnt]:= StringReplace( DiscreteValues[cnt],#34,#34#34, [rfReplaceAll]);
      TmpStr := Format( '%s = "%s"', [EdExpr, DiscreteValues[cnt]] );

      With ThematicRanges.Add Do
      Begin
        Expression := TmpStr;
        Legend := DiscreteValues[cnt];
        PenStyle.style := 1;
        PenStyle.color := LineStepColor;
        If AutoLineWidth Then
          PenStyle.Width := Gis.DrawBoxList[0].Grapher.PointsToDistY( cnt )
        Else
          PenStyle.Width := 0;
        Brushstyle.Pattern := Brushstyle.Pattern;
        Brushstyle.ForeColor := StepColor;
        Brushstyle.BackColor := clWhite;
        SymbolStyle.Index := IMin( Ez_Symbols.Count-1, cnt );
        Symbolstyle.Height := Gis.DrawBoxList[0].Grapher.PointsToDistY( 20 );
      End;
    End;

  finally
    DiscreteValues.free;
    MainExpr.Free;
    Gis.EndProgress;
  end;
End;

{ for numeric fields only }
Procedure TEzThematicBuilder.CreateAutomaticThematicRange( Gis: TEzBaseGis;
  NumRanges: Integer; const ThematicLayer, FieldName: String;
  BrushStartColor, BrushStopColor: TColor;
  BrushPattern: Integer; LineStartColor, LineStopColor: TColor;
  LineStyle: Integer; AutoLineWidth, CalcbyRange, IgnoreZero, ManualRange: boolean;
  ManualRangevalue: Double; DecimalPos: Integer );

Var
  cnt, icnt, TotalAffected, Decimals, n: Integer;
  Value, MinValue, MaxValue, Delta, LowRange, HiRange: Double;
  BeginColor, EndColor, StepColor: TColor;
  LineBeginColor, LineEndColor, LineStepColor: TColor;
  tmpStr: String;
  R, G, B: Byte;
  BeginRGBValue, LineBeginRGBValue: Array[0..2] Of Byte;
  RGBDiff, LineRGBDiff: Array[0..2] Of Integer;
  MainExpr: TEzMainExpr;
  //Accept: Boolean;
  Values: TEzDoubleList;
  EdExpr, temp1, temp2: String;
  FMax, FMin: double;
  FThematicLayer: TEzBaseLayer;
  code: integer;
Begin
  If FieldName = '' Then
  Begin
    MessageToUser( SExpresionNull, smsgerror, MB_ICONERROR );
    Exit;
  End;

  EdExpr := ThematicLayer + '.' + Fieldname;
  FThematicLayer := Gis.Layers.LayerByName( Thematiclayer );
  If FThematicLayer = Nil Then Exit;

  MainExpr := TEzMainExpr.Create( Gis, FThematicLayer );
  Try
    MainExpr.ParseExpression( EdExpr );
  Except
    On E: Exception Do
    Begin
      MessageToUser( E.Message, smsgerror, MB_ICONERROR );
      MainExpr.Free;
      Exit;
    End;
  End;

  ThematicRanges.Clear;

  Values := TEzDoubleList.Create;
  FMax := -1E20;
  FMin := 1E20;
  Try
    {Calculate min and max values}
    Gis.StartProgress( SCalculatingRanges, 1, FThematicLayer.RecordCount );
    TotalAffected := 0;
    Try
      FThematicLayer.First;
      cnt := 0;
      While Not FThematicLayer.Eof Do
      Begin
        Inc( cnt );
        Gis.UpdateProgress( cnt );
        If FThematicLayer.RecIsDeleted Then
        Begin
          FThematicLayer.Next;
          Continue;
        End;
        FThematicLayer.Synchronize;
        Value := MainExpr.Expression.AsFloat;
        Values.Add( Value );
        If CalcbyRange Then
        Begin
          If IgnoreZero And ( value = 0 ) Then
          Begin
            FThematicLayer.Next;
            Continue;
          End;
          FMin := dMin( Value, FMin );
          FMax := dMax( Value, FMax );
        End;
        Inc( TotalAffected );

        FThematicLayer.Next;
      End;
    Finally
      Gis.EndProgress;
    End;
    Values.Sort;
    If Not CalcbyRange Then
    Begin // equal number
      FMin := 1;
      FMax := TotalAffected;
      Decimals := 0;
    End
    Else
      Decimals := DecimalPos;

    If FMax - FMin = 0 Then Exit; // can't calculate
    If CalcbyRange Then
      Delta := ( FMax - FMin ) / NumRanges
    Else
      Delta := ( ( FMax - FMin + 1 ) / NumRanges + 1 );

    If ( ManualRange ) And ( CalcbyRange ) Then
      Delta := ManualRangeValue;

    MinValue := FMin;
    If Decimals = 0 Then
    Begin
      MinValue := Int( MinValue );
      Delta := Int( Delta );
    End;
    // for fill color
    BeginColor := ColorToRGB( BrushStartColor );
    EndColor := ColorToRGB( BrushStopColor );
    BeginRGBValue[0] := GetRValue( BeginColor );
    BeginRGBValue[1] := GetGValue( BeginColor );
    BeginRGBValue[2] := GetBValue( BeginColor );
    RGBDiff[0] := GetRValue( EndColor ) - BeginRGBValue[0];
    RGBDiff[1] := GetGValue( EndColor ) - BeginRGBValue[1];
    RGBDiff[2] := GetBValue( EndColor ) - BeginRGBValue[2];
    // for line color
    LineBeginColor := ColorToRGB( LineStartColor );
    LineEndColor := ColorToRGB( LineStopColor );
    LineBeginRGBValue[0] := GetRValue( LineBeginColor );
    LineBeginRGBValue[1] := GetGValue( LineBeginColor );
    LineBeginRGBValue[2] := GetBValue( LineBeginColor );
    LineRGBDiff[0] := GetRValue( LineEndColor ) - LineBeginRGBValue[0];
    LineRGBDiff[1] := GetGValue( LineEndColor ) - LineBeginRGBValue[1];
    LineRGBDiff[2] := GetBValue( LineEndColor ) - LineBeginRGBValue[2];

    For cnt := 0 To NumRanges - 1 Do
    Begin
      R := BeginRGBValue[0] + MulDiv( cnt, RGBDiff[0], Pred( NumRanges ) );
      G := BeginRGBValue[1] + MulDiv( cnt, RGBDiff[1], Pred( NumRanges ) );
      B := BeginRGBValue[2] + MulDiv( cnt, RGBDiff[2], Pred( NumRanges ) );
      StepColor := RGB( R, G, B );
      // line color
      R := LineBeginRGBValue[0] + MulDiv( cnt, LineRGBDiff[0], Pred( NumRanges ) );
      G := LineBeginRGBValue[1] + MulDiv( cnt, LineRGBDiff[1], Pred( NumRanges ) );
      B := LineBeginRGBValue[2] + MulDiv( cnt, LineRGBDiff[2], Pred( NumRanges ) );
      LineStepColor := RGB( R, G, B );

      If CalcbyRange Then
      Begin
        MaxValue := MinValue + Delta;
        If Decimals = 0 Then
          MaxValue := MaxValue - 1;
      End
      Else
      Begin
        If cnt = NumRanges - 1 Then
          MaxValue := Values.Count
        Else
        Begin
          MaxValue := MinValue + Delta;
          If Decimals = 0 Then
            MaxValue := MaxValue - 1;
        End;
      End;

      If cnt < Pred( NumRanges ) Then
        TmpStr := '(%s >= %s) And (%s < %s)'
      Else
        TmpStr := '(%s >= %s) And (%s <= %s)';
      If CalcbyRange Then
      Begin
        LowRange := MinValue;
        HiRange := MaxValue
      End
      Else
      Begin
        LowRange := Values[Trunc( MinValue ) - 1];
        HiRange := Values[Trunc( MaxValue ) - 1];
      End;

      With ThematicRanges.Add Do
      Begin
        System.Str( LowRange:30:Decimals, temp1 );
        System.Str( HiRange:30:Decimals, temp2 );
        Expression := Format( TmpStr, [EdExpr, trim(temp1), EdExpr, trim(temp2)] );
        Legend := Format( '%.*n - %.*n', [Decimals, LowRange, Decimals, HiRange] );
        PenStyle.style := 1;
        PenStyle.color := LineStepColor;
        If AutoLineWidth Then
          PenStyle.Width := Gis.DrawBoxList[0].Grapher.PointsToDistY( cnt )
        Else
          PenStyle.Width := 0;
        //PenStyle.Width := Gis.DrawBoxList[0].Grapher.PointsToDistY( cnt );
        Brushstyle.Pattern := Brushstyle.Pattern;
        Brushstyle.ForeColor := StepColor;
        Brushstyle.BackColor := clWhite;
        SymbolStyle.Index := IMin( Ez_Symbols.Count-1, cnt );
        Symbolstyle.Height := Gis.DrawBoxList[0].Grapher.PointsToDistY( 20 );
      End;
      MinValue := MaxValue;
    End;
  Finally
    MainExpr.Free;
    Values.Free;
  End;
End;


{ TEzLegendItem }

constructor TEzLegendItem.Create(Collection: TCollection);
begin
  Inherited Create( Collection );
  FPenStyle:= TEzPentool.Create;
  FPenStyle.Style:= 1;
  FBrushStyle:= TEzBrushtool.Create;
  FBrushStyle.Pattern:= 1;
  FSymbolStyle:= TEzSymboltool.Create;
end;

destructor TEzLegendItem.Destroy;
begin
  FPenStyle.free;
  FBrushStyle.Free;
  FSymbolStyle.Free;
  inherited;
end;

procedure TEzLegendItem.Assign(Source: TPersistent);
begin
  If Source Is TEzLegendItem Then
  Begin
    FLegend := TEzLegendItem( Source ).Legend;
    FPenStyle.Assign( TEzLegendItem( Source ).PenStyle );
    FBrushStyle.Assign( TEzLegendItem( Source ).BrushStyle );
    FSymbolStyle.Assign( TEzLegendItem( Source ).SymbolStyle );
    InvalidateLegend;
  End
  Else
    Inherited Assign( Source );
end;

function TEzLegendItem.GetDisplayName: String;
begin
  If FLegend = '' Then
    Result := Inherited GetDisplayName
  else
    result := FLegend;
end;

procedure TEzLegendItem.SetBrushstyle(Value: TEzBrushtool);
begin
  FBrushstyle.Assign(Value);
  InvalidateLegend;
end;

procedure TEzLegendItem.SetPenstyle(Value: TEzPentool);
begin
  FPenstyle.Assign(Value);
  InvalidateLegend;
end;

procedure TEzLegendItem.SetSymbolStyle(Value: TEzSymboltool);
begin
  FSymbolstyle.Assign(Value);
  InvalidateLegend;
end;

procedure TEzLegendItem.SetFontStyle(const Value: TEzFonttool);
begin
  FFontStyle.Assign( Value );
  InvalidateLegend;
end;

procedure TEzLegendItem.SetColor(const Value: TColor);
begin
  FColor:= Value;
  InvalidateLegend;
end;

Procedure TEzLegendItem.InvalidateLegend;
begin
  If TEzLegendRanges( Collection ).Owner Is TEzLegend Then
    TEzLegend(TEzLegendRanges( Collection ).Owner).Invalidate;
end;

procedure TEzLegendItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  InvalidateLegend;
end;

{ TEzLegendRanges }

constructor TEzLegendRanges.Create(AOwner: TPersistent);
begin
  Inherited Create( AOwner, TEzLegendItem );
end;

function TEzLegendRanges.Add: TEzLegendItem;
begin
  Result := TEzLegendItem( Inherited Add );
end;

function TEzLegendRanges.Up(Index: Integer): Boolean;
begin
  Result:= False;
  if ( Index <= 0 ) or ( Index > Count - 1 ) then Exit;
  GetItem( Index ).Index := Index - 1;
  Result:= True;
end;

function TEzLegendRanges.Down(Index: Integer): Boolean;
begin
  Result:= False;
  if ( Index < 0 ) or ( Index >= Count - 1 ) then Exit;
  GetItem( Index ).Index := Index + 1;
  Result:= True;
end;

function TEzLegendRanges.GetItem(Index: Integer): TEzLegendItem;
begin
  Result := TEzLegendItem( Inherited GetItem( Index ) );
end;

procedure TEzLegendRanges.SetItem(Index: Integer; Value: TEzLegendItem);
begin
  Inherited SetItem( Index, Value );
end;

function TEzLegendRanges.Owner: TPersistent;
begin
  Result:= Inherited GetOwner;
end;


{ TEzLegend class implementation }

{ TEzLegend }

constructor TEzLegend.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLegendRanges:= TEzLegendRanges.Create(Self);
  FixedCols:= 0;
  FixedRows:= 1;
  ColCount:= 3;
  Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine];
  ShowTitle:= true;
  FTitleFont:= TFont.Create;
  FTitleColor:= clBlack;
  FTitleTransparent:= false;
  FTitleAlignment:= taCenter;
  FPenTool:= TEzPenTool.Create;
  FBrushTool:= TEzBrushTool.Create;
  FBorderWidth:= 1;
  FLoweredColor:= clGray;
end;

destructor TEzLegend.Destroy;
begin
  FLegendRanges.Free;
  FPentool.Free;
  FBrushtool.Free;
  FTitleFont.Free;
  inherited Destroy;
end;

procedure TEzLegend.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  uFormat: Word;
  AText: string;
  AIndex: Integer;
  AItem: TEzLegendItem;
  R: TRect;
  Image : TBitmap;
  Ax,Ay: Integer;

  Procedure DrawLineStyle;
  var
    FGrapher: TEzGrapher;
  begin
    FGrapher:= TEzGrapher.Create(10,adScreen);
    try
      if AItem.FPenStyle.Style < 0 then Exit;
      Canvas.Font.Assign( Self.Font );
      EzMiscelCtrls.DrawLineType( FGrapher, Canvas, AItem.FPenStyle.Style,
        ARect, [], AItem.FPenStyle.Color, Self.Color, False, 0, 2, False,
        True, False );
    finally
      FGrapher.free;
    end;
  end;

  Procedure DrawBrushStyle;
  var
    FGrapher: TEzGrapher;
  begin
    FGrapher:= TEzGrapher.Create(10,adScreen);
    try
      Canvas.Font.Assign( Self.Font );
      EzMiscelCtrls.DrawPattern( Canvas, AItem.FBrushStyle.Pattern,
        AItem.FBrushStyle.ForeColor, AItem.FBrushStyle.BackColor, Self.Color, ARect,
        False, [], False, True, False );
    finally
      FGrapher.free;
    end;
  end;

  Procedure DrawSymbolStyle;
  var
    FGrapher: TEzGrapher;
    ValInteger: Integer;
  begin
    ValInteger:= AItem.FSymbolStyle.Index;
    FGrapher:= TEzGrapher.Create(10,adScreen);
    try
      if ValInteger < 0 then Exit;
      EzMiscelCtrls.DrawSymbol( FGrapher, Canvas, ValInteger, ARect, [],
        Self.Color, False, False, true, False );
    finally
      FGrapher.free;
    end;
  end;

begin
  InitializeRows;
  if csDesigning in ComponentState then Exit;
  with Canvas do
  begin
    Font.Assign( Self.Font );
    if FShowTitle and (ARow = 0) then
    begin
      case ACol of
        0: AText:= FTitle0;
        1: AText:= FTitle1;
        2: AText:= FTitle2;
      end;
      Font.Style:= Font.Style + [fsBold];
      uFormat:= DT_CENTER or DT_VCENTER or DT_SINGLELINE;
      DrawText( Handle, PChar(AText), -1, ARect, uFormat );
    end;
    if (FShowTitle and (ARow > 0) ) Or (Not FShowTitle and (ARow >=0)) then
    begin
      InflateRect(ARect, -1, -1);
      if FShowTitle then AIndex:= ARow - 1 else AIndex := ARow;
      if AIndex > FLegendRanges.Count-1 then Exit;
      AItem:= FLegendRanges[AIndex];
      if ACol = 0 then
      begin
        Case FLegendStyle of
          ctLineStyle:
            begin
              DrawLineStyle;
            end;
          ctBrushStyle:
            begin
              DrawBrushStyle;
            end;
          ctColor:
            begin
              Pen.Width:= 1;
              Pen.Color:= clBlack;
              Brush.Style:= bsSolid;
              Brush.Color:= AItem.FColor;
              R:= ARect;
              Windows.InflateRect(R,-2,-2);
              with R do
                Rectangle(left, top, right, bottom );
            end;
          ctSymbolStyle:
            begin
              DrawSymbolStyle;
            end;
          ctBitmap:
            begin
              if FImageList = Nil then Exit;
              if AItem.FImageIndex > ImageList.Count-1 then exit;
              Image := TBitmap.Create;
              try
                ImageList.GetBitmap(AIndex, Image);
                Image.Transparent:= true;
                Image.TransparentMode := tmAuto;
                if FStretch then
                begin
                  R:= ARect;
                  Windows.InflateRect(R,-2,-2);
                  StretchDraw( R, Image );
                end else
                begin
                  Ax:= ARect.Left + IMax((( ARect.Right - ARect.Left ) - Image.Width ) div 2, 0);
                  Ay:= ARect.Top + IMax((( ARect.Bottom - ARect.Top ) - Image.Height ) div 2, 0);
                  Draw( Ax,Ay, Image );
                end;
              finally
                Image.free;
              end;
            end;
        end;
      end else if ACol=1 then
      begin
        AText:= AItem.FLegend;
        uFormat:= DT_LEFT or DT_VCENTER or DT_SINGLELINE;
        DrawText( Handle, PChar(AText), -1, ARect, uFormat );
      end else if ACol=2 then
      begin
        AText:= IntToStr( AItem.FFrequency );
        uFormat:= DT_RIGHT or DT_VCENTER or DT_SINGLELINE;
        DrawText( Handle, PChar(AText), -1, ARect, uFormat );
      end;
    end;
  end;
end;

procedure TEzLegend.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FImageList ) Then
    FImageList := Nil;
end;

procedure TEzLegend.SetImageList(const Value: TImageList);
begin
  if FImageList = Value then Exit;
{$IFDEF LEVEL5}
  if Assigned( FImageList ) then FImageList.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
    Value.FreeNotification( Self );
  FImageList:= Value;
end;

procedure TEzLegend.SetLegendRanges(const Value: TEzLegendRanges);
begin
  FLegendRanges.Assign( Value );
end;

procedure TEzLegend.SetLegendStyle(const Value: TEzColumnType);
begin
  if FLegendStyle = Value then Exit;
  FLegendStyle := Value;
end;

procedure TEzLegend.SetShowTitle(const Value: Boolean);
begin
  if FShowTitle = Value then exit;
  FShowTitle := Value;
  InitializeRows;
end;

Procedure TEzLegend.InitializeRows;
begin
  if FShowTitle then
  begin
    if FLegendRanges.Count = 0 then
    begin
      if RowCount <> 2 then RowCount := 2;
    end else
    begin
      if RowCount <> FLegendRanges.Count + 1 then
        RowCount := FLegendRanges.Count + 1;
    end;
    if FixedRows <> 1 then FixedRows := 1;
  end else
  begin
    if FLegendRanges.Count = 0 then
    begin
      if RowCount <> 0 then RowCount := 0;
    end else
    begin
      if RowCount <> FLegendRanges.Count then
        RowCount := FLegendRanges.Count;
    end;
    if FixedRows <> 0 then FixedRows := 0;
  end;
end;

procedure TEzLegend.SetTitle0(const Value: string);
begin
  FTitle0 := Value;
  Invalidate;
end;

procedure TEzLegend.SetTitle1(const Value: string);
begin
  FTitle1 := Value;
  Invalidate;
end;

procedure TEzLegend.SetTitle2(const Value: string);
begin
  FTitle2 := Value;
  Invalidate;
end;

procedure TEzLegend.PopulateFrom(Source: TEzThematicBuilder);
var
  I: Integer;
  SourceItem: TEzThematicItem;
begin
  FLegendRanges.Clear;
  for I:= 0 to Source.FThematicRanges.Count -1 do
  begin
    SourceItem:= Source.FThematicRanges[I];
    with FLegendRanges.Add do
    begin
      FPenStyle.assign( SourceItem.FPenStyle );
      FBrushStyle.Assign( SourceItem.FBrushStyle );
      FSymbolStyle.Assign( SourceItem.FSymbolStyle );
      FLegend:= SourceItem.FLegend;
      FFrequency:= SourceItem.Frequency;
    end;
  end;
  FTitle1:= Source.Title;
  If Source.ApplyPen then
    FLegendStyle:= ctLineStyle
  else If Source.ApplyBrush then
    FLegendStyle:= ctBrushStyle
  else If Source.ApplyColor then
    FLegendStyle:= ctColor
  else If Source.ApplySymbol then
    FLegendStyle:= ctSymbolStyle;

  InitializeRows;
  Invalidate;
end;

procedure TEzLegend.SetStretch(const Value: Boolean);
begin
  if FStretch = Value then exit;
  FStretch := Value;
  Invalidate;
end;

procedure TEzLegend.AdjustColWidths;
begin
  if FInColChange then Exit;
  FInColChange:= true;
  try
    if ColWidths[0] >= MulDiv(ClientWidth,1,3) then
    begin
      ColWidths[0] := MulDiv(ClientWidth,1,3);
    end;
    ColWidths[2] := ClientWidth - ColWidths[0] - ColWidths[1] -
      GetSystemMetrics(SM_CXBORDER) * 1 - GridLineWidth * ColCount ;
  finally
    FInColChange:= false;
  end;
end;

procedure TEzLegend.ColWidthsChanged;
begin
  AdjustColWidths;
  inherited ColWidthsChanged;
end;

procedure TEzLegend.SetBrushTool(const Value: TEzBrushTool);
begin
  FBrushTool.Assign( Value );
end;

procedure TEzLegend.SetPenTool(const Value: TEzPenTool);
begin
  FPenTool.Assign( Value );
end;

procedure TEzLegend.SetTitleFont(const Value: TFont);
begin
  FTitleFont.Assign( Value );
end;

end.
