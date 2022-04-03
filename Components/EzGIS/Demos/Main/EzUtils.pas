unit EzUtils;

{$I EZ_FLAG.PAS}
{.$DEFINE USE_ADO}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ComCtrls,
  EzBaseGis, EzBase, EzSystem, EzExpressions
{$IFDEF USE_ADO}
  , ADOdb
{$ENDIF}
  ;

type

  TEzLayersOptions = Class;

  TEzExternalConnectionType = ( ectDBase, ectADO );

  TEzLayerOptions = class(TObject)
  Private
    FLayersOptions: TEzLayersOptions;

    FLayerName: string;
    { selection }
    FSelectionFilter: TEzEntityIDs;
    { hints }
    FHintExpr: TEzMainExpr;
    FHintActive: Boolean;
    FHintText: string;
    { pen override}
    FPenOverride: TEzPenTool;
    FOverridePen: Boolean;
    FOverridePen_Style: Boolean;
    FOverridePen_Color: Boolean;
    FOverridePen_Width: Boolean;
    FKeepSameLineWidth: Boolean;
    { brush override }
    FBrushOverride: TEzBrushTool;
    FOverrideBrush: boolean;
    FOverrideBrush_Pattern: boolean;
    FOverrideBrush_ForeColor: boolean;
    FOverrideBrush_BackColor: boolean;
    { symbol override }
    FSymbolOverride: TEzSymbolTool;
    FOverrideSymbol: Boolean;
    FOverrideSymbol_Index: Boolean;
    FOverrideSymbol_Rotangle: Boolean;
    FOverrideSymbol_Height: Boolean;
    FKeepSameSymbolSize: Boolean;
    { font override }
    FFontOverride: TEzFontTool;
    FOverrideFont: Boolean;
    FOverrideFont_Name: Boolean;
    FOverrideFont_Angle: Boolean;
    FOverrideFont_Height: Boolean;
    FOverrideFont_Color: Boolean;
    FOverrideFont_Style: Boolean;
    FKeepSameFontSize: Boolean;
    { line direction }
    FShowLineDirection: Boolean;
    FDirectionPos: TEzDirectionPos;
    FDirectionPen: TEzPenTool;
    FDirectionBrush: TEzBrushTool;
    FRevertDirection: Boolean;
    { zoom range for layer }
    FZoomRangeActive: Boolean;
    FMinZoomScale: Double;
    FMaxZoomScale: Double;
    { zoom range for text }
    FTextZoomRangeActive: Boolean;
    FMinZoomScaleForText: Double;
    FMaxZoomScaleForText: Double;
    { add filter }
    FAddFilter: TEzEntityIDs;
    { select filter }
    FSelectFilterActive: Boolean;
    FSelectFilterText: string;
    FSelectFilterExpr: TEzMainExpr;
    { entities visibility based on an expression }
    FVisibleFilterActive: Boolean;
    FVisibleFilterText: string;
    FVisibleFilterExpr: TEzMainExpr;
    { labeling }
    FLabelingActive: Boolean;
    FLabelingText: string;
    FLabelingExpr: TEzMainExpr;
    FAlignLabels: Boolean;
    FRepeatInSegments: Boolean;
    FSmartShowing: Boolean;
    FLabelsFont: TEzFontTool;   { also uses FKeepSameFontSize}
    FTrueType: Boolean;
    FLabelPos: TEzLabelPos;
    FLabelsKeepSameFontSize: Boolean;
    FTag: Integer;

    { connection to an ADO/Dbf database }
    FConnectionType: TEzExternalConnectionType;
    FConnected: Boolean;

{$IFDEF FALSE}
    { the halcyon dataset object used to open external .DBF files }
    FLayer_hds: THalcyonDataset;
    { the halcyon datasetr object used to open external .DBF files }
    FExternal_hds: THalcyonDataset;
{$ENDIF}
    { the ADO dataset object used }
{$IFDEF USE_ADO}
    FADODataset: TADODataset;
{$ENDIF}
    { the internal field used to connect to an external ADO / DBF table  }
    FInternalConnectionField: string;
    { the external field used to connect to an internal field of the layer }
    FExternalConnectionField: string;
    { command text used to open the ADO / DBF table. Usually it will be
      SELECT * FROM customer for ADO or the name of the Dbf file }
    FCommandText: string;
    { index to use when connected to an TADODataset }
    FADOIndexName: string;

  Public
    Constructor Create( LayersOptions: TEzLayersOptions );
    Destructor Destroy; Override;
    procedure LoadFromStream( Stream: TStream );
    procedure SaveToStream( Stream: TStream );
    procedure Prepare(Gis: TEzBaseGis);
    procedure Connect(Gis: TEzBaseGis);
    procedure DisConnect;
    Procedure ConnectClone( Gis: TEzBaseGis );
    Procedure DisConnectClone;

    Property SelectionFilter: TEzEntityIDs read FSelectionFilter write FSelectionFilter;
    Property AddFilter: TEzEntityIDs read FAddFilter write FAddFilter;
    Property LayersOptions: TEzLayersOptions read FLayersOptions;
    Property LayerName: string read FLayerName write FLayerName;
    Property HintText: string read FHintText write FHintText;
    Property HintExpr: TEzMainExpr read FHintExpr write FHintExpr;
    Property HintActive: Boolean read FHintActive write FHintActive;
    Property PenOverride: TEzPenTool read FPenOverride;
    Property OverridePen: Boolean read FOverridePen write FOverridePen;
    Property OverridePen_Style: Boolean read FOverridePen_Style write FOverridePen_Style;
    Property OverridePen_Color: Boolean read FOverridePen_Color write FOverridePen_Color;
    Property OverridePen_Width: Boolean read FOverridePen_Width write FOverridePen_Width;
    Property BrushOverride: TEzBrushTool read FBrushOverride;
    Property OverrideBrush: boolean read FOverrideBrush write FOverrideBrush;
    Property OverrideBrush_Pattern: boolean read FOverrideBrush_Pattern write FOverrideBrush_Pattern;
    Property OverrideBrush_ForeColor: boolean read FOverrideBrush_ForeColor write FOverrideBrush_ForeColor;
    Property OverrideBrush_BackColor: boolean read FOverrideBrush_BackColor write FOverrideBrush_BackColor;
    Property SymbolOverride: TEzSymbolTool read FSymbolOverride;
    Property OverrideSymbol: Boolean read FOverrideSymbol write FOverrideSymbol;
    Property OverrideSymbol_Index: Boolean read FOverrideSymbol_Index write FOverrideSymbol_Index;
    Property OverrideSymbol_Rotangle: Boolean read FOverrideSymbol_Rotangle write FOverrideSymbol_Rotangle;
    Property OverrideSymbol_Height: Boolean read FOverrideSymbol_Height write FOverrideSymbol_Height;
    Property FontOverride: TEzFontTool read FFontOverride;
    Property OverrideFont: Boolean read FOverrideFont write FOverrideFont;
    Property OverrideFont_Name: Boolean read FOverrideFont_Name write FOverrideFont_Name;
    Property OverrideFont_Angle: Boolean read FOverrideFont_Angle write FOverrideFont_Angle;
    Property OverrideFont_Height: Boolean read FOverrideFont_Height write FOverrideFont_Height;
    Property OverrideFont_Color: Boolean read FOverrideFont_Color write FOverrideFont_Color;
    Property OverrideFont_Style: Boolean read FOverrideFont_Style write FOverrideFont_Style;
    Property ShowLineDirection: Boolean read FShowLineDirection write FShowLineDirection;
    Property DirectionPos: TEzDirectionPos read FDirectionPos write FDirectionPos;
    Property DirectionPen: TEzPenTool read FDirectionPen;
    Property DirectionBrush: TEzBrushTool read FDirectionBrush;
    Property RevertDirection: Boolean read FRevertDirection write FRevertDirection;
    Property ZoomRangeActive: Boolean read FZoomRangeActive write FZoomRangeActive;
    Property MinZoomScale: Double read FMinZoomScale write FMinZoomScale;
    Property MaxZoomScale: Double read FMaxZoomScale write FMaxZoomScale;
    Property MinZoomScaleForText: Double read FMinZoomScaleForText write FMinZoomScaleForText;
    Property MaxZoomScaleForText: Double read FMaxZoomScaleForText write FMaxZoomScaleForText;
    Property TextZoomRangeActive: Boolean read FTextZoomRangeActive write FTextZoomRangeActive;
    Property SelectFilterActive: Boolean read FSelectFilterActive write FSelectFilterActive;
    Property SelectFilterText: string read FSelectFilterText write FSelectFilterText;
    Property SelectFilterExpr: TEzMainExpr read FSelectFilterExpr write FSelectFilterExpr;
    Property VisibleFilterActive: Boolean read FVisibleFilterActive write FVisibleFilterActive;
    Property VisibleFilterText: string read FVisibleFilterText write FVisibleFilterText;
    Property VisibleFilterExpr: TEzMainExpr read FVisibleFilterExpr write FVisibleFilterExpr;
    Property KeepSameLineWidth: Boolean read FKeepSameLineWidth write FKeepSameLineWidth;
    Property KeepSameSymbolSize: Boolean read FKeepSameSymbolSize write FKeepSameSymbolSize;
    Property KeepSameFontSize: Boolean read FKeepSameFontSize write FKeepSameFontSize;
    Property LabelingActive: Boolean read FLabelingActive write FLabelingActive;
    Property AlignLabels: Boolean read FAlignLabels write FAlignLabels;
    Property RepeatInSegments: Boolean read FRepeatInSegments write FRepeatInSegments;
    Property SmartShowing: Boolean read FSmartShowing write FSmartShowing;
    Property LabelsFont: TEzFontTool read FLabelsFont;
    Property TrueType: Boolean read FTrueType write FTrueType;
    Property LabelingText: string read FLabelingText write FLabelingText;
    Property LabelingExpr: TEzMainExpr read FLabelingExpr write FLabelingExpr;
    Property LabelPos: TEzLabelPos read FLabelPos write FLabelPos;
    Property LabelsKeepSameFontSize: Boolean read FLabelsKeepSameFontSize write FLabelsKeepSameFontSize;
    { CONNEXION TO EXTERNAL DATABASE }
     Property Connected: Boolean read FConnected;
    { ADO connection }
{$IFDEF USE_ADO}
    Property ADODataset: TADODataset read FADODataset;
{$ENDIF}
    Property ADOIndexName: string read FADOIndexName write FADOIndexName;
{$IFDEF FALSE}
    Property Layer_hds: THalcyonDataset read FLayer_hds;
    Property External_hds: THalcyonDataset read FExternal_hds;
{$ENDIF}
    Property ConnectionType: TEzExternalConnectionType read FConnectionType write FConnectionType;
    Property InternalConnectionField: string read FInternalConnectionField write FInternalConnectionField;
    Property ExternalConnectionField: string read FExternalConnectionField write FExternalConnectionField;
    Property CommandText: string read FCommandText write FCommandText;
    Property Tag: Integer read FTag write FTag;

  End;

  TEzLayersOptions = Class(TObject)
  Private
    FList: TList;
    { ---- for connection to an ADO database }
{$IFDEF USE_ADO}
    FADOConnection: TADOConnection;
{$ENDIF}
    { the connection string to client/server database }
    FConnectionString: string;
    { other configuration parameters that must be saved }
    FConnectionTimeOut: Integer;
{$IFDEF USE_ADO}
    FCursorLocation: TCursorLocation;
    FIsolationLevel: TIsolationLevel;  // not yet used
    FMode: TConnectMode;
{$ENDIF}
    FKeepConnection: Boolean;
    FLoginPrompt: Boolean;
    FUserName: string;
    FPassword: string;
    { this defines in 0 element, the layer
      in second element, the pivot field (AGEB field)
      from third element and on, it defines the fields that can be calculated
    }
    FAnalisisInfo: TStrings;

    function Get(Index: Integer): TEzLayerOptions;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    procedure Clear;
    function Add: TEzLayerOptions;
    function Count: integer;
    function LayerByName(const LayerName: string): TEzLayerOptions;
    procedure LoadFromStream( Stream: TStream );
    procedure SaveToStream( Stream: TStream );
    Procedure LoadFromFile( const Filename: string );
    procedure SaveToFile( const Filename: string );
    procedure Prepare(Gis: TEzBaseGis);
    procedure ConnectAll( Gis: TEzBaseGis );
    procedure DisConnectAll;
    procedure CheckConnection;

    property Items[Index:Integer]: TEzLayerOptions read Get; default;

{$IFDEF USE_ADO}
    property ADOConnection: TADOConnection read FADOConnection;
    property CursorLocation: TCursorLocation read FCursorLocation write FCursorLocation;
    property IsolationLevel: TIsolationLevel read FIsolationLevel write FIsolationLevel;
    property Mode: TConnectMode read FMode write FMode;
{$ENDIF}
    property ConnectionString: string read FConnectionString write FConnectionString;
    property ConnectionTimeOut: Integer read FConnectionTimeOut write FConnectionTimeOut;
    property KeepConnection: Boolean read FKeepConnection write FKeepConnection;
    property LoginPrompt: Boolean read FLoginPrompt write FLoginPrompt;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;

    property AnalisisInfo: TStrings read FAnalisisInfo;
  End;

  { named views }

  TEzNamedViews = Class;

  TEzNamedView= class
  private
    FOwner: TEzNamedViews;
    FX1: Double;
    FY1: Double;
    FX2: Double;
    FY2: Double;
    FName: string;
  public
    Constructor Create(AOwner: TEzNamedViews);
    Procedure SetInView(DrawBox: TEzBaseDrawBox);
    procedure LoadFromStream( Stream: TStream );
    procedure SaveToStream( Stream: TStream );
    Property X1: Double read FX1 write FX1;
    Property Y1: Double read FY1 write FY1;
    Property X2: Double read FX2 write FX2;
    Property Y2: Double read FY2 write FY2;
    Property Name: string read FName write FName;
  end;

  TEzNamedViews = Class(TObject)
  Private
    FList: TList;
    FDrawBox: TEzBaseDrawBox;
    FAutoRestore: Boolean;
    function Get(Index: Integer): TEzNamedView;
  Public
    constructor Create(DrawBox: TEzBaseDrawBox);
    Destructor Destroy; Override;
    procedure Clear;
    function Add: TEzNamedView;
    function Count: integer;
    Procedure Delete(Index: integer);
    function ViewByName(const Name: string): TEzNamedView;
    procedure LoadFromStream( Stream: TStream );
    procedure SaveToStream( Stream: TStream );
    Procedure LoadFromFile( const Filename: string );
    procedure SaveToFile( const Filename: string );
    procedure Exchange(Index1,Index2:Integer);

    property Items[Index:Integer]: TEzNamedView read Get; default;
    property AutoRestore: Boolean read FAutoRestore write FAutoRestore;
  End;

  { TEzGradient }

  TEzGradientDirection = ( gdTopBottom, gdBottomTop, gdLeftRight, gdRightLeft,
  gdFromCenter, gdFromTopLeft, gdFromBottomLeft );

  TEzGradient = Class( TPersistent )
  Private
    FDirection: TEzGradientDirection;
    FEndColor: TColor;
    FMidColor: TColor;
    FStartColor: TColor;
    FVisible: Boolean;

    FOnChange: TNotifyEvent;
    Procedure SetColorProperty( Var AColor: TColor; Value: TColor );
    Procedure SetDirection( Value: TEzGradientDirection );
    Procedure SetEndColor( Value: TColor );
    Procedure SetMidColor( Value: TColor );
    Procedure SetStartColor( Value: TColor );
    Procedure SetVisible( Value: Boolean );
    Procedure GradientFill( Canvas: TCanvas; Const Rect: TRect;
      StartColor: TColor; EndColor: TColor; Direction: TEzGradientDirection );
  Public
    Constructor Create( ChangeEvent: TNotifyEvent );
    Procedure Assign( Source: TPersistent ); Override;
    Procedure Draw( Canvas: TCanvas; Const Rect: TRect );
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
    Property Direction: TEzGradientDirection Read FDirection Write SetDirection Default gdTopBottom;
    Property EndColor: TColor Read FEndColor Write SetEndColor Default clYellow;
    Property MidColor: TColor Read FMidColor Write SetMidColor Default clNone;
    Property StartColor: TColor Read FStartColor Write SetStartColor Default clWhite;
    Property Visible: Boolean Read FVisible Write SetVisible Default False;
  End;

  Procedure SetScrollBoxRange( ScrollBox: TScrollBox; Header: THeaderControl );
  Procedure SaveHeaderControl( Header: THeaderControl );
  Procedure RestoreHeaderControl( Header: THeaderControl );

implementation

uses
  Inifiles;

Procedure SetScrollBoxRange( ScrollBox: TScrollBox; Header: THeaderControl );
Var
  cnt, Extent: integer;
Begin
  Extent := 0;
  For cnt := 0 To Header.Sections.Count - 1 Do
    Inc( Extent, Header.Sections[cnt].Width );
  ScrollBox.HorzScrollBar.Range := Extent + GetSystemMetrics( SM_CXHTHUMB );
End;

Procedure SaveHeaderControl( Header: THeaderControl );
Var
  IniFile: TIniFile;
  cnt: integer;
Begin
  IniFile := TIniFile.Create( ExtractFilePath( Application.ExeName ) + 'Active.ini' );
  Try
    For cnt := 0 To Header.Sections.Count - 1 Do
      IniFile.WriteInteger( GetParentForm( Header ).Name, 'Col' + IntToStr( cnt ),
        Header.Sections[cnt].Width );
  Finally
    IniFile.Free;
  End;
End;

Procedure RestoreHeaderControl( Header: THeaderControl );
Var
  Inifile: TIniFile;
  cnt: integer;
Begin
  IniFile := TIniFile.Create( ExtractFilePath( Application.ExeName ) + 'Active.ini' );
  Try
    For cnt := 0 To Header.Sections.Count - 1 Do
      Header.Sections[cnt].Width :=
        IniFile.ReadInteger( GetParentForm( Header ).Name, 'Col' + IntToStr( cnt ), 50 );
  Finally
    IniFile.Free;
  End;
End;

{ TEzLayerOptions }

constructor TEzLayerOptions.Create( LayersOptions: TEzLayersOptions );
var
  id: TEzEntityID;
  TempFilter: TEzEntityIDs;
begin
  inherited Create;
  FLayersOptions:= LayersOptions;
  { pen override}
  FPenOverride:= TEzPenTool.create;
  FPenOverride.Assign( Ez_Preferences.DefPenStyle );
  { brush override }
  FBrushOverride:= TEzBrushTool.create;
  FBrushOverride.Assign( Ez_Preferences.DefBrushstyle );
  { symbol override }
  FSymbolOverride:= TEzSymbolTool.create;
  FSymbolOverride.Assign( Ez_Preferences.DefSymbolstyle );
  { font override }
  FFontOverride:= TEzFontTool.create;
  FFontOverride.Assign( Ez_Preferences.Deffontstyle );
  { line direction }
  FDirectionPen:= TEzPenTool.create;
  FDirectionBrush:= TEzBrushTool.create;
  { labeling }
  FLabelsFont:= TEzFontTool.create;
  FTrueType:= true;

  TempFilter:= [];
  for id:= Low( TEzEntityID ) to high( TEzEntityID ) do
    Include( TempFilter, id );
  AddFilter := TempFilter;

end;

destructor TEzLayerOptions.Destroy;
begin
  FPenOverride.free;
  FBrushOverride.free;
  FSymbolOverride.free;
  FFontOverride.free;
  FDirectionPen.free;
  FDirectionBrush.free;
  FLabelsFont.free;
  if FSelectFilterExpr <> nil then FSelectFilterExpr.free;
  if FVisibleFilterExpr <> nil then FVisibleFilterExpr.free;
  if FHintExpr <> Nil then FreeAndNil(FHintExpr);
  if FLabelingExpr <> Nil then FreeAndNil(FLabelingExpr);

{$IFDEF USE_ADO}
  if Assigned( FADODataset ) then FADODataset.Free;
{$ENDIF}
{$IFDEF FALSE}
  if Assigned( FExternal_hds ) then FExternal_hds.Free;
  if Assigned( FLayer_hds ) then FLayer_hds.Free;
{$ENDIF}

  inherited Destroy;
end;

procedure TEzLayerOptions.LoadFromStream(Stream: TStream);
var
  Dummy: Boolean;
begin
  with stream do
  begin
    FLayerName:= EzReadStrFromStream(stream);
    read(FHintActive,sizeof(FHintActive));
    FHintText:=EzReadStrFromStream(stream);
    FPenOverride.loadfromstream(stream);
    read(FOverridePen,sizeof(FOverridePen));
    read(FOverridePen_Style,sizeof(FOverridePen_Style));
    read(FOverridePen_Color,sizeof(FOverridePen_Color));
    read(FOverridePen_Width,sizeof(FOverridePen_Width));
    FBrushOverride.loadfromstream(stream);
    read(FOverrideBrush,sizeof(FOverrideBrush));
    read(FOverrideBrush_Pattern,sizeof(FOverrideBrush_Pattern));
    read(FOverrideBrush_ForeColor,sizeof(FOverrideBrush_ForeColor));
    read(FOverrideBrush_BackColor,sizeof(FOverrideBrush_BackColor));
    FSymbolOverride.loadfromstream(stream);
    read(FOverrideSymbol,sizeof(FOverrideSymbol));
    read(FOverrideSymbol_Index,sizeof(FOverrideSymbol_Index));
    read(FOverrideSymbol_Rotangle,sizeof(FOverrideSymbol_Rotangle));
    read(FOverrideSymbol_Height,sizeof(FOverrideSymbol_Height));
    FFontOverride.loadfromstream(stream);
    read(FOverrideFont,sizeof(FOverrideFont));
    read(FOverrideFont_Name,sizeof(FOverrideFont));
    read(FOverrideFont_Angle,sizeof(FOverrideFont));
    read(FOverrideFont_Height,sizeof(FOverrideFont));
    read(FOverrideFont_Color,sizeof(FOverrideFont));
    read(FOverrideFont_Style,sizeof(FOverrideFont));
    read(FShowLineDirection,sizeof(FShowLineDirection));
    read(FDirectionPos,sizeof(FDirectionPos));
    FDirectionPen.loadfromstream(stream);
    FDirectionBrush.loadfromstream(stream);
    read(FRevertDirection,sizeof(FRevertDirection));
    read(FZoomRangeActive,sizeof(FZoomRangeActive));
    read(FMinZoomScale,sizeof(FMinZoomScale));
    read(FMaxZoomScale,sizeof(FMaxZoomScale));
    read(FTextZoomRangeActive,sizeof(FTextZoomRangeActive));
    read(FMinZoomScaleForText,sizeof(FMinZoomScaleForText));
    read(FMaxZoomScaleForText,sizeof(FMaxZoomScaleForText));
    read(FSelectFilterActive,sizeof(FSelectFilterActive));
    FSelectFilterText:= EzReadStrFromStream(stream);
    //FSelectFilterExpr: TEzMainExpr;
    read(FVisibleFilterActive,sizeof(FVisibleFilterActive));
    FVisibleFilterText:= EzReadStrFromStream(stream);
    //FVisibleFilterExpr: TEzMainExpr;
    read(FKeepSameLineWidth,sizeof(FKeepSameLineWidth));
    read(FKeepSameSymbolSize,sizeof(FKeepSameSymbolSize));
    read(FKeepSameFontSize,sizeof(FKeepSameFontSize));
    read(FHintActive,sizeof(FHintActive));
    read(FLabelingActive,sizeof(FLabelingActive));
    read(FAlignLabels,sizeof(FAlignLabels));
    read(FRepeatInSegments,sizeof(FRepeatInSegments));
    read(FSmartShowing,sizeof(FSmartShowing));
    FLabelsFont.LoadFromStream(stream);
    read(FTrueType,sizeof(FTrueType));
    read(FLabelPos,sizeof(FLabelPos));
    read(FLabelsKeepSameFontSize,sizeof(FLabelsKeepSameFontSize));
    FLabelingText:= EzReadStrFromStream(stream);

    { ADO connection }
    read(FConnectionType,sizeof(ConnectionType));
    read(Dummy,sizeof(Dummy));
    FConnected:= False;
    FInternalConnectionField:= EzReadStrFromStream(stream);
    FExternalConnectionField:= EzReadStrFromStream(stream);
    FCommandText:= EzReadStrFromStream(stream);
    FADOIndexName:= EzReadStrFromStream(stream);
    Read(FAddFilter,sizeof(FAddFilter));
  end;
  if FHintExpr <> nil then FreeAndNil(FHintExpr);
  if FLabelingExpr <> nil then FreeAndNil(FLabelingExpr);
  if FSelectFilterExpr <> nil then FreeAndNil(FSelectFilterExpr);
  if FVisibleFilterExpr <> nil then FreeAndNil(FVisibleFilterExpr);
end;

procedure TEzLayerOptions.Prepare(Gis: TEzBaseGis);
var
  Layer: TEzBaseLayer;
begin
  { create all layer expressions }
  Layer:= Gis.Layers.LayerByName( FLayerName ) ;
  if Layer = Nil then Exit;
  if FHintExpr <> nil then FreeAndNil(FHintExpr);
  if FSelectFilterExpr <> nil then FreeAndNil(FSelectFilterExpr);
  if FVisibleFilterExpr <> nil then FreeAndNil(FVisibleFilterExpr);
  if FLabelingExpr <> nil then FreeAndNil(FLabelingExpr);

  if FHintActive and (length(Trim(FHintText))>0) then
  begin
    FHintExpr:= TEzMainExpr.Create(Gis,Layer);
    try
      FHintExpr.ParseExpression( FHintText );
    except
      FHintActive:= false;
      FreeAndNil( FHintExpr );
    end;
  end else
    FHintActive:=false;

  if FSelectFilterActive and (length(Trim(FSelectFilterText))>0) then
  begin
    FSelectFilterExpr:= TEzMainExpr.Create(Gis,Layer);
    try
      FSelectFilterExpr.ParseExpression( FSelectFilterText );
    except
      FSelectFilterActive:= false;
      FreeAndNil( FSelectFilterExpr );
    end;
  end else
    FSelectFilterActive:=false;

  if FVisibleFilterActive and (length(Trim(FVisibleFilterText))>0) then
  begin
    FVisibleFilterExpr:= TEzMainExpr.Create(Gis,Layer);
    try
      FVisibleFilterExpr.ParseExpression( FVisibleFilterText );
    except
      FVisibleFilterActive:= false;
      FreeAndNil( FVisibleFilterExpr );
    end;
  end else
    FVisibleFilterActive:=false;

  if FLabelingActive and (length(Trim(FLabelingText))>0) then
  begin
    FLabelingExpr:= TEzMainExpr.create(gis,Layer);
    try
      FLabelingExpr.ParseExpression(FLabelingText);
    except
      FLabelingActive:= false;
      FreeAndNil( FLabelingExpr );
    end;
  end else
    FLabelingActive:=false;

end;

procedure TEzLayerOptions.SaveToStream(Stream: TStream);
var
  Dummy: Boolean;
begin
  with stream do
  begin
    EzWriteStrToStream(FLayerName,stream);
    write(FHintActive,sizeof(FHintActive));
    EzWriteStrToStream(FHintText,stream);
    FPenOverride.savetostream(stream);
    write(FOverridePen,sizeof(FOverridePen));
    write(FOverridePen_Style,sizeof(FOverridePen_Style));
    write(FOverridePen_Color,sizeof(FOverridePen_Color));
    write(FOverridePen_Width,sizeof(FOverridePen_Width));
    FBrushOverride.savetostream(stream);
    write(FOverrideBrush,sizeof(FOverrideBrush));
    write(FOverrideBrush_Pattern,sizeof(FOverrideBrush_Pattern));
    write(FOverrideBrush_ForeColor,sizeof(FOverrideBrush_ForeColor));
    write(FOverrideBrush_BackColor,sizeof(FOverrideBrush_BackColor));
    FSymbolOverride.savetostream(stream);
    write(FOverrideSymbol,sizeof(FOverrideSymbol));
    write(FOverrideSymbol_Index,sizeof(FOverrideSymbol_Index));
    write(FOverrideSymbol_Rotangle,sizeof(FOverrideSymbol_Rotangle));
    write(FOverrideSymbol_Height,sizeof(FOverrideSymbol_Height));
    FFontOverride.savetostream(stream);
    write(FOverrideFont,sizeof(FOverrideFont));
    write(FOverrideFont_Name,sizeof(FOverrideFont));
    write(FOverrideFont_Angle,sizeof(FOverrideFont));
    write(FOverrideFont_Height,sizeof(FOverrideFont));
    write(FOverrideFont_Color,sizeof(FOverrideFont));
    write(FOverrideFont_Style,sizeof(FOverrideFont));
    write(FShowLineDirection,sizeof(FShowLineDirection));
    write(FDirectionPos,sizeof(FDirectionPos));
    FDirectionPen.savetostream(stream);
    FDirectionBrush.savetostream(stream);
    write(FRevertDirection,sizeof(FRevertDirection));
    write(FZoomRangeActive,sizeof(FZoomRangeActive));
    write(FMinZoomScale,sizeof(FMinZoomScale));
    write(FMaxZoomScale,sizeof(FMaxZoomScale));
    write(FTextZoomRangeActive,sizeof(FTextZoomRangeActive));
    write(FMinZoomScaleForText,sizeof(FMinZoomScaleForText));
    write(FMaxZoomScaleForText,sizeof(FMaxZoomScaleForText));
    write(FSelectFilterActive,sizeof(FSelectFilterActive));
    EzWriteStrToStream(FSelectFilterText,stream);
    //FSelectFilterExpr: TEzMainExpr;
    write(FVisibleFilterActive,sizeof(FVisibleFilterActive));
    EzWriteStrToStream(FVisibleFilterText,stream);
    //FVisibleFilterExpr: TEzMainExpr;
    write(FKeepSameLineWidth,sizeof(FKeepSameLineWidth));
    write(FKeepSameSymbolSize,sizeof(FKeepSameSymbolSize));
    write(FKeepSameFontSize,sizeof(FKeepSameFontSize));
    write(FHintActive,sizeof(FHintActive));
    write(FLabelingActive,sizeof(FLabelingActive));
    write(FAlignLabels,sizeof(FAlignLabels));
    write(FRepeatInSegments,sizeof(FRepeatInSegments));
    write(FSmartShowing,sizeof(FSmartShowing));
    FLabelsFont.SaveToStream(stream);
    write(FTrueType,sizeof(FTrueType));
    write(FLabelPos,sizeof(FLabelPos));
    write(FLabelsKeepSameFontSize,sizeof(FLabelsKeepSameFontSize));
    EzWriteStrToStream(FLabelingText,stream);

    { ADO connection }
    write(FConnectionType,sizeof(ConnectionType));
    Dummy:=false;
    write(Dummy,sizeof(Dummy));
    EzWriteStrToStream(FInternalConnectionField,stream);
    EzWriteStrToStream(FExternalConnectionField, stream);
    EzWriteStrToStream(FCommandText,stream);
    EzWriteStrToStream(FADOIndexName,stream);
    Write(FAddFilter,sizeof(FAddFilter));
  end;
end;

Procedure TEzLayerOptions.ConnectClone( Gis: TEzBaseGis );
{$IFDEF FALSE}
var
  Layer: TEzBaseLayer;
  FileName: string;
{$ENDIF}
begin
{$IFDEF FALSE}
  if not FConnected then Exit;
  Layer:= Gis.Layers.LayerByName( FLayerName );
  if Layer = Nil then Exit;

  { open the layer table }
  if Not Assigned( FLayer_hds ) then
    FLayer_hds:= THalcyonDataset.Create(Nil)
  else
    FLayer_hds.Close;
  FLayer_hds.DatabaseName:= ExtractFilePath( Layer.FileName );
  FLayer_hds.TableName:= ChangeFileExt( ExtractFileName( Layer.FileName ), '.Dbf');
  FLayer_hds.Open;
  if FLayer_hds.FindField(FInternalConnectionField) = Nil then
  begin
     FLayer_hds.Close;
     Exit;
  end;
  FileName:= ChangeFileExt( Layer.FileName, '.Cdx' );
  if Not FileExists( FileName ) then
  begin
     FLayer_hds.Close;
     Exit;
  end;
  FLayer_hds.Index( FileName, FInternalConnectionField );
{$ENDIF}
end;

Procedure TEzLayerOptions.DisConnectClone;
Begin
{$IFDEF FALSE}
  if Assigned( FLayer_hds ) then
    FreeAndNil( FLayer_hds );
{$ENDIF}
End;

procedure TEzLayerOptions.Connect( Gis: TEzBaseGis );
var
  Layer: TEzBaseLayer;
{$IFDEF FALSE}
  FileName: string;
{$ENDIF}
begin
  DisConnect;
  Layer:= Gis.Layers.LayerByName( FLayerName );
  if Layer = Nil then Exit;
  { connect...}
  if (Length(Trim(FInternalConnectionField)) = 0) Or
     (Length(Trim(FExternalConnectionField)) = 0) Then Exit;
  case FConnectionType of
    ectDBase:
      begin
        if not FileExists( FCommandtext ) then Exit;

        { in method OpenClonnedConnection the .dbf is opened }

        { open the external Dbf table and index }
{$IFDEF FALSE}
        if Not Assigned( FExternal_hds ) then
          FExternal_hds:= THalcyonDataset.Create(Nil)
        else
          FExternal_hds.Close;
        FExternal_hds.DatabaseName:= ExtractFilePath( FCommandtext );
        FExternal_hds.TableName:= ChangeFileExt( ExtractFileName( FCommandtext ), '.Dbf');
        FExternal_hds.Open;
        if FExternal_hds.FindField( FExternalConnectionField ) = Nil then
        begin
           FLayer_hds.Close;
           FExternal_hds.Close;
           Exit;
        end;
        FileName:= AddSlash( FExternal_hds.DatabaseName ) +
          FLayerName + '_' + ChangeFileExt( FExternal_hds.TableName, '.Cdx' );
        if Not FileExists( FileName ) then
        begin
           FLayer_hds.Close;
           FExternal_hds.Close;
           Exit;
        end;
        FExternal_hds.Index( FLayerName + '_' +
          ChangeFileExt( ExtractFileName( FCommandtext ), '.Cdx' ), FExternalConnectionField );
{$ENDIF}
      end;
    ectADO:
      begin
        if Length( FCommandText ) = 0 then Exit;
        FLayersOptions.CheckConnection;
{$IFDEF USE_ADO}
        if Not Assigned( FADODataset ) then
        begin
          FADODataset:= TADODataset.Create(Nil);
          FADODataset.Connection := FLayersOptions.FADOConnection;
        End else
          FADODataset.Close;
        FADODataset.CommandType := cmdText;
        FADODataset.CommandText := FCommandText;
        FADODataset.Open;
{$ENDIF}
      end;
  end;
  FConnected := True;
end;

procedure TEzLayerOptions.DisConnect;
begin
{$IFDEF FALSE}
  if Assigned( FLayer_hds ) then
    FreeAndNil( FLayer_hds );
  if Assigned( FExternal_hds ) then
    FreeAndNil( FExternal_hds );
{$ENDIF}
{$IFDEF USE_ADO}
  if Assigned( FADODataset ) then
    FreeAndNil( FADODataset );
  if Assigned(FLayersOptions.FADOConnection) And (FLayersOptions.FADOConnection.DatasetCount=0) then
  begin
    if Assigned( FLayersOptions.FADOConnection ) then
      FreeAndNil( FLayersOptions.FADOConnection );
  end;
{$ENDIF}
  FConnected := False;
end;

{ TEzLayersOptions }

constructor TEzLayersOptions.Create;
begin
  Inherited Create;
  FList:= TList.create;
  FConnectionTimeOut:= 15;
{$IFDEF USE_ADO}
  FCursorLocation:= clUseClient;
  FIsolationLevel:= ilCursorStability;
  FMode:= cmUnknown;
{$ENDIF}
  FKeepConnection:= True;
  FLoginPrompt:= False;
  FAnalisisInfo:= TStringList.create;
end;

destructor TEzLayersOptions.Destroy;
begin
  Clear;
  FList.free;

{$IFDEF USE_ADO}
  if Assigned( FADOConnection ) then
    FADOConnection.Free;
{$ENDIF}
  FAnalisisInfo.Free;

  inherited;
end;

function TEzLayersOptions.Add: TEzLayerOptions;
begin
  Result:= TEzLayerOptions.Create(Self);
  FList.Add(Result);
end;

procedure TEzLayersOptions.Clear;
var
  I:Integer;
begin
  for I:=0 to FList.count-1 do
    TEzLayerOptions(FList[I]).free;
  FList.clear;
end;

function TEzLayersOptions.Count: integer;
begin
  result:=flist.count;
end;

function TEzLayersOptions.Get(Index: Integer): TEzLayerOptions;
begin
  result:= FList[Index];
end;

function TEzLayersOptions.LayerByName( const LayerName: string ): TEzLayerOptions;
var
  I:Integer;
begin
  Result:= Nil;
  for I:=0 to FList.count-1 do
    if AnsiCompareText(TEzLayerOptions(FList[I]).LayerName,LayerName)=0 then
    begin
      Result:=FList[I];
      Exit;
    end;
end;

procedure TEzLayersOptions.LoadFromFile(const Filename: string);
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

procedure TEzLayersOptions.LoadFromStream(Stream: TStream);
var
  i,n: integer;
  lo: TEzLayerOptions;
begin
  Clear;

  with stream do
  begin
    FConnectionString:=EzReadStrFromStream( stream );
    Read(FConnectionTimeOut,sizeof(FConnectionTimeOut));
{$IFDEF USE_ADO}
    Read(FCursorLocation,sizeof(FCursorLocation));
    Read(FIsolationLevel,sizeof(FIsolationLevel));
    Read(FKeepConnection,sizeof(FKeepConnection));
    Read(FLoginPrompt,sizeof(FLoginPrompt));
    Read(FMode,sizeof(FMode));
{$ENDIF}
    FUserName:=EzReadStrFromStream( stream );
    FPassword:=EzReadStrFromStream( stream );
  end;
  { read number of layers }
  stream.Read(n,sizeof(n));
  for i:=0 to n-1 do
  begin
    lo:= Self.Add;
    lo.LoadFromStream(stream);
  end;
  { now read the territorial analisis info }
  Stream.Read(n,sizeof(n));
  FAnalisisInfo.Clear;
  for i:=0 to n-1 do
  begin
    FAnalisisInfo.Add( EzReadStrFromStream( stream ) );
  end;
end;

procedure TEzLayersOptions.Prepare(Gis: TEzBaseGis);
var
  I: Integer;
begin
  for I:=0 to FList.count-1 do
    TEzLayerOptions(FList[I]).Prepare(Gis);
end;

procedure TEzLayersOptions.CheckConnection;
var
  I: Integer;
  FoundADO: Boolean;
  NeedReconnect: Boolean;
begin
  FoundADO:= False;
  for I:=0 to FList.count-1 do
  begin
    if TEzLayerOptions(FList[I]).ConnectionType = ectADO then
    begin
      FoundADO:= true;
      break;
    end;
  end;
{$IFDEF USE_ADO}
  if FoundADO then
  begin
    NeedReconnect:=false;
    if Not Assigned( FADOConnection ) then
    begin
      FADOConnection:= TADOConnection.Create(Nil);
      NeedReconnect:=true;
    End;
    if not NeedReconnect then
    begin
      NeedReconnect:=
         //(AnsiCompareText( FADOConnection.ConnectionString, FConnectionString)<>0) or
         (FADOConnection.ConnectionTimeOut<> FConnectionTimeOut) or
         (FADOConnection.CursorLocation <> FCursorLocation) or
         (FADOConnection.IsolationLevel <> FIsolationLevel) or
         (FADOConnection.KeepConnection<> FKeepConnection) or
         (FADOConnection.LoginPrompt<> FLoginPrompt) or
         (FADOConnection.Mode<> FMode) Or
         Not FADOConnection.Connected;
    end;

    if NeedReconnect then
    begin
      FADOConnection.Connected:= False;
      FADOConnection.ConnectionString:=FConnectionString;
      FADOConnection.ConnectionTimeOut:= FConnectionTimeOut;
      FADOConnection.CursorLocation := FCursorLocation;
      FADOConnection.IsolationLevel := FIsolationLevel;
      FADOConnection.KeepConnection := FKeepConnection;
      FADOConnection.LoginPrompt:= FLoginPrompt;
      FADOConnection.Mode:= FMode;

      FADOConnection.Connected := true;
      FMode:= FADOConnection.Mode;
    end;
  end;
{$ENDIF}
end;

procedure TEzLayersOptions.ConnectAll( Gis: TEzBaseGis );
var
  I: Integer;
begin
  CheckConnection;
  for I:=0 to FList.count-1 do
  begin
    TEzLayerOptions(FList[I]).Connect(Gis);
  end;
end;

procedure TEzLayersOptions.DisConnectAll;
var
  I: Integer;
begin
  for I:=0 to FList.count-1 do
    TEzLayerOptions(FList[I]).Disconnect;
{$IFDEF USE_ADO}
  if Assigned( FADOConnection ) then
    FreeAndNil( FADOConnection );
{$ENDIF}
end;

procedure TEzLayersOptions.SaveToFile(const Filename: string);
var
  stream: TStream;
begin
  stream:= TFileStream.create(FileName, fmCreate);
  try
    SaveToStream(stream);
  finally
    stream.free;
  end;
end;

procedure TEzLayersOptions.SaveToStream(Stream: TStream);
var
  i,n: integer;
begin
  with stream do
  begin
    EzWriteStrToStream( FConnectionString, stream );
    write(FConnectionTimeOut,sizeof(FConnectionTimeOut));
{$IFDEF USE_ADO}
    write(FCursorLocation,sizeof(FCursorLocation));
    write(FIsolationLevel,sizeof(FIsolationLevel));
    write(FKeepConnection,sizeof(FKeepConnection));
    write(FLoginPrompt,sizeof(FLoginPrompt));
    write(FMode,sizeof(FMode));
{$ENDIF}
    EzWriteStrToStream( FUserName, stream );
    EzWriteStrToStream( FPassword, stream );
  end;

  n:=FList.Count;
  Stream.write(n,sizeof(n));
  for i:=0 to n-1 do
  begin
    TEzLayerOptions(FList[i]).SaveToStream(stream);
  end;
  { now read the territorial analisis info }
  n:= FAnalisisInfo.Count;
  Stream.Write(n,sizeof(n));
  for i:=0 to n-1 do
  begin
    EzWriteStrToStream( FAnalisisInfo[i], stream );
  end;
end;

{ TEzNamedViews }

function TEzNamedViews.Add: TEzNamedView;
begin
  Result:= TEzNamedView.Create(Self);
  FList.Add(Result);
end;

procedure TEzNamedViews.Clear;
var
  I:Integer;
begin
  for I:=0 to FList.count-1 do
    TEzNamedView(FList[I]).free;
  FList.clear;
end;

function TEzNamedViews.Count: integer;
begin
  result:=flist.count;
end;

constructor TEzNamedViews.Create(DrawBox: TEzBaseDrawBox);
begin
  Inherited Create;
  FDrawBox:= DrawBox;
  FList:= TList.create;
end;

procedure TEzNamedViews.Delete(Index: integer);
begin
  if (index<0) or (index>FList.count-1) then exit;
  TEzNamedview(FList[index]).Free;
  FList.delete(index);
end;

destructor TEzNamedViews.Destroy;
begin
  Clear;
  FList.free;
  inherited;
end;

procedure TEzNamedViews.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1,Index2);
end;

function TEzNamedViews.Get(Index: Integer): TEzNamedView;
begin
  result:= FList[Index];
end;

procedure TEzNamedViews.LoadFromFile(const Filename: string);
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

procedure TEzNamedViews.LoadFromStream(Stream: TStream);
var
  i,n: integer;
  view: TEzNamedView;
begin
  Clear;
  stream.Read(n,sizeof(n));
  stream.read(FAutorestore,sizeof(boolean));
  for i:=0 to n-1 do
  begin
    view:= Self.Add;
    view.LoadFromStream(stream);
  end;
end;

procedure TEzNamedViews.SaveToFile(const Filename: string);
var
  stream: TStream;
begin
  stream:= TFileStream.create(FileName, fmCreate);
  try
    SaveToStream(stream);
  finally
    stream.free;
  end;
end;

procedure TEzNamedViews.SaveToStream(Stream: TStream);
var
  i,n: integer;
begin
  n:=FList.Count;
  Stream.write(n,sizeof(n));
  stream.write(FAutorestore,sizeof(boolean));
  for i:=0 to n-1 do
  begin
    TEzNamedView(FList[i]).SaveToStream(stream);
  end;
end;

function TEzNamedViews.ViewByName(const Name: string): TEzNamedView;
var
  I:Integer;
begin
  Result:= Nil;
  for I:=0 to FList.count-1 do
    if AnsiCompareText(TEzNamedView(FList[I]).Name,Name)=0 then
    begin
      Result:=FList[I];
      Exit;
    end;
end;

{ TEzNamedView }

Constructor TEzNamedView.Create(AOwner: TEzNamedViews);
begin
  inherited create;
  FOwner:= AOwner;
end;


procedure TEzNamedView.LoadFromStream(Stream: TStream);
begin
  with Stream do
  begin
    FName:= EzReadStrFromStream(stream);
    read(Fx1,sizeof(double));
    read(Fy1,sizeof(double));
    read(Fx2,sizeof(double));
    read(Fy2,sizeof(double));
  end;
end;

procedure TEzNamedView.SaveToStream(Stream: TStream);
begin
  with Stream do
  begin
    EzWriteStrToStream(FName,stream);
    write(Fx1,sizeof(double));
    write(Fy1,sizeof(double));
    write(Fx2,sizeof(double));
    write(Fy2,sizeof(double));
  end;
end;

procedure TEzNamedView.SetInView(DrawBox: TEzBaseDrawBox);
begin
  TEzNamedViews(FOwner).FDrawBox.SetViewTo(FX1,FY1,FX2,FY2);
end;


{ TEzGradient }

Constructor TEzGradient.Create( ChangeEvent: TNotifyEvent );
Begin
  Inherited Create;
  FOnChange := ChangeEvent;
  FDirection := gdTopBottom;
  FStartColor := clWhite;
  FEndColor := clYellow;
  FMidColor := clNone;
End;

Procedure TEzGradient.SetVisible( Value: Boolean );
Begin
  If FVisible <> Value Then
  Begin
    FVisible := Value;
    if Assigned(FOnChange) then
      FOnChange( Self );
  End;
End;

Procedure TEzGradient.SetDirection( Value: TEzGradientDirection );
Begin
  If FDirection <> Value Then
  Begin
    FDirection := Value;
    if Assigned(FOnChange) then
      FOnChange( Self );
  End;
End;

Procedure TEzGradient.SetColorProperty( Var AColor: TColor; Value: TColor );
Begin
  If AColor <> Value Then
  Begin
    AColor := Value;
    if Assigned(FOnChange) then
      FOnChange( Self );
  End;
End;

Procedure TEzGradient.SetStartColor( Value: TColor );
Begin
  SetColorProperty( FStartColor, Value );
End;

Procedure TEzGradient.SetEndColor( Value: TColor );
Begin
  SetColorProperty( FEndColor, Value );
End;

Procedure TEzGradient.SetMidColor( Value: TColor );
Begin
  SetColorProperty( FMidColor, Value );
End;

Procedure TEzGradient.Assign( Source: TPersistent );
Begin
  If Source Is TEzGradient Then
    With TEzGradient( Source ) Do
    Begin
      Self.FDirection := FDirection;
      Self.FEndColor := FEndColor;
      Self.FMidColor := FMidColor;
      Self.FStartColor := FStartColor;
      Self.FVisible := FVisible;
    End
  Else
    Inherited;
End;

Procedure TEzGradient.Draw( Canvas: TCanvas; Const Rect: TRect );
Var
  R: TRect;

  Procedure DoVert( C0, C1, C2, C3: TColor );
  Begin
    R.Bottom := ( Rect.Bottom + Rect.Top ) Div 2;
    GradientFill( Canvas, R, C0, C1, Direction );
    R.Top := R.Bottom;
    R.Bottom := Rect.Bottom;
    GradientFill( Canvas, R, C2, C3, Direction );
  End;

  Procedure DoHoriz( C0, C1, C2, C3: TColor );
  Begin
    R.Right := ( Rect.Left + Rect.Right ) Div 2;
    GradientFill( Canvas, R, C0, C1, Direction );
    R.Left := R.Right;
    R.Right := Rect.Right;
    GradientFill( Canvas, R, C2, C3, Direction );
  End;

Begin
  If MidColor = clNone Then
    GradientFill( Canvas, Rect, StartColor, EndColor, Direction )
  Else
  Begin
    R := Rect;
    Case Direction Of
      gdTopBottom: DoVert( MidColor, EndColor, StartColor, MidColor );
      gdBottomTop: DoVert( StartColor, MidColor, MidColor, EndColor );
      gdLeftRight: DoHoriz( MidColor, EndColor, StartColor, MidColor );
      gdRightLeft: DoHoriz( StartColor, MidColor, MidColor, EndColor );
    Else
      GradientFill( Canvas, Rect, StartColor, EndColor, Direction )
    End;
  End;
End;

Procedure RectSize( Const R: TRect; Var RectWidth, RectHeight: Integer );
Begin
  With R Do
  Begin
    RectWidth := Right - Left;
    RectHeight := Bottom - Top;
  End;
End;

Procedure SwapInteger( Var a, b: Integer );
Var
  tmp: Integer;
Begin
  tmp := a;
  a := b;
  b := tmp;
End;

Procedure TEzGradient.GradientFill( Canvas: TCanvas; Const Rect: TRect;
  StartColor: TColor; EndColor: TColor; Direction: TEzGradientDirection );

Var
  T0, T1, T2: Integer;
  D0, D1, D2: Integer;
  tmpBrush: HBRUSH;
  FDC: THandle;
  OldColor: TColor;

  Procedure CalcBrushColor( Index, Range: Integer );
  Var
    tmp: TColor;
  Begin
    tmp := RGB( T0 + MulDiv( Index, D0, Range ),
      T1 + MulDiv( Index, D1, Range ),
      T2 + MulDiv( Index, D2, Range ) );
    If tmp <> OldColor Then
    Begin
      If tmpBrush <> 0 Then
        DeleteObject( SelectObject( FDC, tmpBrush ) );
      tmpBrush := SelectObject( FDC, CreateSolidBrush( tmp ) );
      OldColor := tmp;
    End;
  End;

Var
  tmpRect: TRect;

  Procedure RectGradient( Horizontal: Boolean );
  Var
    t, P1, P2, P3: Integer;
    Size: Integer;
    Steps: Integer;
  Begin
    FDC := Canvas.Handle;
    With tmpRect Do
    Begin
      If Horizontal Then
      Begin
        P3 := Bottom - Top;
        Size := Right - Left;
      End
      Else
      Begin
        P3 := Right - Left;
        Size := Bottom - Top;
      End;
      Steps := Size;
      If Steps > 256 Then
        Steps := 256;
      P1 := 0;
      OldColor := -1;
      For t := 0 To Steps - 1 Do
      Begin
        CalcBrushColor( t, Pred( Steps ) );
        P2 := MulDiv( t + 1, Size, Steps );
        If Horizontal Then
          PatBlt( FDC, Right - P1, Top, P1 - P2, P3, PATCOPY )
        Else
          PatBlt( FDC, Left, Bottom - P1, P3, P1 - P2, PATCOPY );
        P1 := P2;
      End;
    End;
  End;

  Procedure FromCorner;
  Var
    FromTop: Boolean;
    SizeX, SizeY, tmpDiagonal, tmp1, tmp2, P0, P1: Integer;
  Begin
    FromTop := Direction = gdFromTopLeft;
    With tmpRect Do
      If FromTop Then
        P1 := Top
      Else
        P1 := Bottom;
    P0 := P1;
    RectSize( tmpRect, SizeX, SizeY );
    tmpDiagonal := SizeX + SizeY;
    FDC := Canvas.Handle;
    tmp1 := 0;
    tmp2 := 0;
    Repeat
      CalcBrushColor( tmp1 + tmp2, tmpDiagonal );
      PatBlt( FDC, tmpRect.Left + tmp2, P0, 1, P1 - P0, PATCOPY );
      If tmp1 < SizeY Then
      Begin
        Inc( tmp1 );
        If FromTop Then
        Begin
          PatBlt( FDC, tmpRect.Left, P0, tmp2 + 1, 1, PATCOPY );
          If P0 < tmpRect.Bottom Then
            Inc( P0 )
        End
        Else
        Begin
          PatBlt( FDC, tmpRect.Left, P0 - 1, tmp2 + 1, 1, PATCOPY );
          If P0 > tmpRect.Top Then
            Dec( P0 );
        End;
      End;
      If tmp2 < SizeX Then
        Inc( tmp2 );
    Until ( tmp1 >= SizeY ) And ( tmp2 >= SizeX );
  End;

  Procedure FromCenter;
  Const
    GradientPrecision: Integer = 1;
  Var
    tmpXCenter, tmpYCenter, SizeX, SizeY, P0, P1, tmpLeft, tmpTop: Integer;
    tmp1, tmp2, tmp3: Integer;
  Begin
    RectSize( tmpRect, SizeX, SizeY );
    tmpXCenter := SizeX Shr 1;
    tmpYCenter := SizeY Shr 1;
    tmp1 := 0;
    tmp2 := 0;
    tmp3 := tmpXCenter + tmpYCenter;
    FDC := Canvas.Handle;
    Repeat
      CalcBrushColor( tmp1 + tmp2, tmp3 );
      P0 := SizeY - ( 2 * tmp1 );
      P1 := SizeX - ( 2 * tmp2 );
      tmpLeft := tmpRect.Left + tmp2;
      tmpTop := tmpRect.Top + tmp1;
      PatBlt( FDC, tmpLeft, tmpTop, GradientPrecision, P0, PATCOPY );
      PatBlt( FDC, tmpRect.Right - tmp2 - 1, tmpTop, GradientPrecision, P0, PATCOPY );
      PatBlt( FDC, tmpLeft, tmpTop, P1, GradientPrecision, PATCOPY );
      PatBlt( FDC, tmpLeft, tmpRect.Bottom - tmp1 - GradientPrecision,
        P1, GradientPrecision, PATCOPY );
      If tmp1 < tmpYCenter Then
        Inc( tmp1, GradientPrecision );
      If tmp2 < tmpXCenter Then
        Inc( tmp2, GradientPrecision );
    Until ( tmp1 >= tmpYCenter ) And ( tmp2 >= tmpXCenter );
  End;

Begin
  If ( Direction = gdTopBottom ) Or ( Direction = gdLeftRight ) Then
  Else
    SwapInteger( Integer( StartColor ), Integer( EndColor ) );

  StartColor := ColorToRGB( StartColor );
  EndColor := ColorToRGB( EndColor );

  T0 := GetRValue( StartColor );
  T1 := GetGValue( StartColor );
  T2 := GetBValue( StartColor );
  D0 := GetRValue( EndColor ) - T0;
  D1 := GetGValue( EndColor ) - T1;
  D2 := GetBValue( EndColor ) - T2;

  tmpRect := Rect;
  With tmpRect Do
  Begin
    If Right < Left Then
      SwapInteger( Left, Right );
    If Bottom < Top Then
      SwapInteger( Top, Bottom );
  End;

  tmpBrush := 0;
  OldColor := -1;

  Case Direction Of
    gdLeftRight,
      gdRightLeft: RectGradient( True );
    gdTopBottom,
      gdBottomTop: RectGradient( False );
    gdFromTopLeft,
      gdFromBottomLeft: FromCorner;
    gdFromCenter: FromCenter;
  End;
  If tmpBrush <> 0 Then
    DeleteObject( SelectObject( FDC, tmpBrush ) );
End;


end.
