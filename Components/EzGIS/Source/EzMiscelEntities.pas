Unit EzMiscelEntities;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Controls, SysUtils, Classes, Windows, Graphics, Printers, Forms,
  EzLib, EzBase, EzBaseGIS, EzEntities
{$IFDEF USE_RICHEDIT}
  , ComCtrls, RichEdit
{$ENDIF}
  ;

Type

  {------------------------------------------------------------------------------}
  {         TEzPreviewEntity -  Preview / Printing of the drawing                    }
  {------------------------------------------------------------------------------}

  TEzPreviewEntity = Class( TEzRectangle )
  Private
    FFileNo: Integer; { The Index on the list TEzPreviewBox.GisList }
    FPlottedUnits: Double; { FPlottedUnits = FDrawingUnits }
    FDrawingUnits: Double; { Example: 10 MMs = 1 meter }
    FPaperUnits: TEzScaleUnits; { MMs CMs or INCHes }
    FPrintMode: TEzPrintMode;
    FPresentation: TEzPreviewPresentation;
    FSelection: TEzSelection;
    FPrintFrame: Boolean;
    { the proposed area to print }
    FProposedPrintArea: TEzRect;
    { Calculated extension to print }
    FCalculatedPrintArea: TEzRect;
    FDemo: Boolean;
    Function GetGIS: TEzBaseGIS;
    Procedure Preview( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect );
    Procedure Print( Grapher: TEzGrapher; Const Clip: TEzRect;
      Demo: Boolean = False );
  {$IFDEF BCB}
    function GetCalculatedPrintArea: TEzRect;
    function GetDrawingUnits: Double;
    function GetFileNo: Integer;
    function GetPaperUnits: TEzScaleUnits;
    function GetPlottedUnits: Double;
    function GetPresentation: TEzPreviewPresentation;
    function GetPrintFrame: Boolean;
    function GetPrintMode: TEzPrintMode;
    function GetProposedPrintArea: TEzRect;
    function GetSelection: TEzSelection;
    procedure SetCalculatedPrintArea(const Value: TEzRect);
    procedure SetDrawingUnits(const Value: Double);
    procedure SetFileNo(const Value: Integer);
    procedure SetPaperUnits(const Value: TEzScaleUnits);
    procedure SetPlottedUnits(const Value: Double);
    procedure SetPresentation(const Value: TEzPreviewPresentation);
    procedure SetPrintFrame(const Value: Boolean);
    procedure SetPrintMode(const Value: TEzPrintMode);
    procedure SetProposedPrintArea(const Value: TEzRect);
    procedure SetSelection(const Value: TEzSelection);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    { methods }
    Constructor CreateEntity( Const p1, p2: TEzPoint;
      PrintMode: TEzPrintMode; FileNo: Integer );
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure CalculateScales( Const WindowToFit: TEzRect );
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = false): Boolean; Override;

    Property GIS: TEzBaseGIS Read GetGIS;
    { The index in the list TEzPreviewBox.DrawBoxList }
    Property FileNo: Integer {$IFDEF BCB} Read GetFileNo Write SetFileNo {$ELSE}Read FFileNo Write FFileNo {$ENDIF};
    { the selection used to print }
    Property Selection: TEzSelection {$IFDEF BCB} Read GetSelection Write SetSelection {$ELSE} Read FSelection Write FSelection {$ENDIF};
    { units to plot... }
    Property PlottedUnits: Double {$IFDEF BCB} Read GetPlottedUnits Write SetPlottedUnits {$ELSE} Read FPlottedUnits Write FPlottedUnits {$ENDIF};
    { ...correspond to drawing units }
    Property DrawingUnits: Double {$IFDEF BCB} Read GetDrawingUnits Write SetDrawingUnits {$ELSE} Read FDrawingUnits Write FDrawingUnits {$ENDIF};
    { the paper units which this map was placed on a DrawBox }
    Property PaperUnits: TEzScaleUnits {$IFDEF BCB} Read GetPaperUnits Write SetPaperUnits {$ELSE} Read FPaperUnits Write FPaperUnits {$ENDIF};
    { printing mode : all, selection, all but selection }
    Property PrintMode: TEzPrintMode {$IFDEF BCB} Read GetPrintMode Write SetPrintMode {$ELSE} Read FPrintMode Write FPrintMode {$ENDIF};
    { print a frame around the map ? }
    Property PrintFrame: Boolean {$IFDEF BCB} Read GetPrintFrame Write SetPrintFrame {$ELSE} Read FPrintFrame Write FPrintFrame {$ENDIF};
    { how the map is presented in the preview : a rectangle border or full map }
    Property Presentation: TEzPreviewPresentation {$IFDEF BCB} Read GetPresentation Write SetPresentation {$ELSE} Read fPresentation Write fPresentation {$ENDIF};
    { the blue dotted rectangle on the DrawBox what u want to print }
    Property ProposedPrintArea: TEzRect {$IFDEF BCB} Read GetProposedPrintArea Write SetProposedPrintArea {$ELSE} Read FProposedPrintArea Write FProposedPrintArea {$ENDIF};
    { based on ProposedPrintArea, the real extension based on scale is calculated }
    Property CalculatedPrintArea: TEzRect {$IFDEF BCB} Read GetCalculatedPrintArea Write SetCalculatedPrintArea {$ELSE} Read FCalculatedPrintArea Write FCalculatedPrintArea {$ENDIF};

    property Demo: Boolean read FDemo write FDemo;
  End;


  {-------------------------------------------------------------------------------}
  {                  TEzTableEntity                                                     }
  {-------------------------------------------------------------------------------}

  TEzColumnItem = Class;
  TEzColumnList = Class;
  TEzTableEntity = Class;

  TEzTableBorderStyle = Packed Record
    Visible: Boolean;
    Style: Byte;
    Color: TColor;
    Width: Double;
  End;

  TEzTitleItem = Class
  Private
    FColumnItem: TEzColumnItem;
    FCaption: String;
    FAlignment: TAlignment;
    FColor: TColor;
    FTransparent: Boolean;
    FFont: TEzFontStyle;
  Public
    Constructor Create( ColumnItem: TEzColumnItem );
    Property Caption: String Read FCaption Write FCaption;
    Property Alignment: TAlignment Read FAlignment Write FAlignment;
    Property Color: TColor Read FColor Write FColor;
    Property Transparent: Boolean Read FTransparent Write FTransparent;
    Property Font: TEzFontStyle Read FFont Write FFont;
  End;

  TEzColumnType = (ctLabel, ctColor, ctLineStyle, ctBrushStyle, ctSymbolStyle, ctBitmap );

  TEzColumnItem = Class
  Private
    FColumnList: TEzColumnList;
    FColumnType: TEzColumnType;
    FStrings: TStrings;
    FAlignment: TAlignment;
    FColor: TColor;
    FTransparent: Boolean;
    FFont: TEzFontStyle;
    FTitle: TEzTitleItem;
    FWidth: Double;
  Public
    Constructor Create( ColumnList: TEzColumnList );
    Destructor Destroy; Override;

    Property ColumnType: TEzColumnType read FColumnType write FColumnType;
    Property Strings: TStrings read FStrings;
    Property Alignment: TAlignment Read FAlignment Write FAlignment;
    Property Color: TColor Read FColor Write FColor;
    Property Transparent: Boolean Read FTransparent Write FTransparent;
    Property Font: TEzFontStyle Read FFont Write FFont;
    Property Title: TEzTitleItem Read FTitle Write FTitle;
    Property Width: Double Read FWidth Write FWidth;
  End;

  TEzColumnList = Class
  Private
    FItems: TList;
    FTable: TEzTableEntity;
    Function GetCount: Integer;
    Function GetItem( Index: Integer ): TEzColumnItem;
  Public
    Constructor Create( Table: TEzTableEntity );
    Destructor Destroy; Override;
    Procedure Assign( Source: TEzColumnList );
    Function Add: TEzColumnItem;
    Procedure Clear;
    Procedure Delete( Index: Integer );
    Procedure Exchange( Index1, Index2: Integer );
    function Up( Index: Integer ): Boolean;
    function Down( Index: Integer ): Boolean;

    Property Count: Integer Read GetCount;
    Property Items[Index: Integer]: TEzColumnItem Read GetItem; Default;
  End;

  TEzGridOptions = Set Of ( ezgoHorzLine, ezgoVertLine );

  TEzTableDrawCellEvent = Procedure( Sender: TObject; ACol, ARow: Longint;
    Canvas: TCanvas; Grapher: TEzGrapher; Rect: TRect ) Of Object;

  TEzTableEntity = Class( TEzRectangle )
  Private
    FColumns: TEzColumnList;
    FOptions: TEzGridOptions;
    FRowHeight: Double;
    FRowCount: Integer;
    FTitleHeight: Double;
    FGridStyle: TEzTableBorderStyle;
    FOwnerDraw: Boolean;
    FBorderWidth: Double;
    FDefaultDrawing: Boolean;
    FLoweredColor: TColor;

    FOnDrawCell: TEzTableDrawCellEvent;
    Function GetColumns: TEzColumnList;
    Procedure SetRowCount( Value: Integer );
  {$IFDEF BCB}
    function GetBorderWidth: Double;
    function GetDefaultDrawing: Boolean;
    function GetGridStyle: TEzTableBorderStyle;
    function GetLoweredColor: TColor;
    function GetOnDrawCell: TEzTableDrawCellEvent;
    function GetOptions: TEzGridOptions;
    function GetOwnerDraw: Boolean;
    function GetRowCount: Integer;
    function GetRowHeight: Double;
    function GetTitleHeight: Double;
    procedure SetBorderWidth(const Value: Double);
    procedure SetDefaultDrawing(const Value: Boolean);
    procedure SetGridStyle(const Value: TEzTableBorderStyle);
    procedure SetLoweredColor(const Value: TColor);
    procedure SetOnDrawCell(const Value: TEzTableDrawCellEvent);
    procedure SetOptions(const Value: TEzGridOptions);
    procedure SetOwnerDraw(const Value: Boolean);
    procedure SetTitleHeight(const Value: Double);
  {$ENDIF}
    procedure SetRowHeight(const Value: Double);
    procedure DrawAbnormal(Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; DrawMode: TEzDrawMode;
      Data: Pointer = nil);
    procedure DrawEmpty(Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; aRect: TRect);
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string;Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Procedure UpdateExtension; Override;

    Property Columns: TEzColumnList Read GetColumns;
    Property Options: TEzGridOptions {$IFDEF BCB} Read GetOptions Write SetOptions {$ELSE} Read FOptions Write FOptions {$ENDIF};
    Property RowHeight: Double {$IFDEF BCB} Read GetRowHeight Write SetRowHeight {$ELSE} Read FRowHeight Write SetRowHeight {$ENDIF};
    Property TitleHeight: Double {$IFDEF BCB} Read GetTitleHeight Write SetTitleHeight {$ELSE} Read FTitleHeight Write FTitleHeight {$ENDIF};
    Property RowCount: Integer {$IFDEF BCB} Read GetRowCount Write SetRowCount {$ELSE} Read FRowCount Write SetRowCount {$ENDIF};
    Property GridStyle: TEzTableBorderStyle {$IFDEF BCB} Read GetGridStyle Write SetGridStyle {$ELSE} Read FGridStyle Write FGridStyle {$ENDIF};
    Property OwnerDraw: Boolean {$IFDEF BCB} Read GetOwnerDraw Write SetOwnerDraw {$ELSE} Read FOwnerDraw Write FOwnerDraw {$ENDIF};
    Property BorderWidth: Double {$IFDEF BCB} Read GetBorderWidth Write SetBorderWidth {$ELSE} Read FBorderWidth Write FBorderWidth {$ENDIF};
    Property DefaultDrawing: Boolean {$IFDEF BCB} Read GetDefaultDrawing Write SetDefaultDrawing {$ELSE} Read FDefaultDrawing Write FDefaultDrawing {$ENDIF};
    Property LoweredColor: TColor {$IFDEF BCB} Read GetLoweredColor Write SetLoweredColor {$ELSE} Read FLoweredColor Write FLoweredColor {$ENDIF};

    Property OnDrawCell: TEzTableDrawCellEvent {$IFDEF BCB} Read GetOnDrawCell Write SetOnDrawCell {$ELSE} Read FOnDrawCell Write FOnDrawCell {$ENDIF};

  End;

  {-------------------------------------------------------------------------------}
  //                  TEzRtfText
  // Warning !: This entity is intended only for the preview box TEzPreviewBox
  //            It will not work correctly when placed on a map.
  {-------------------------------------------------------------------------------}

  TEzRtfText = Class( TEzClosedEntity )
  Private
    FLines: TStrings;
    FVector: TEzVector;
    Function GetLines: TStrings;
    procedure PrintTo(RichEdit: TRichEdit; Canvas: TCanvas; TargetRect: TRect);
    function RenderText(Grapher: TEzGrapher; Metafile: TMetafile;
      aBox: TWinControl; RichEdit: TRichEdit): TRect;
  Protected
    Function GetDrawPoints: TEzVector; Override;
    Function GetEntityID: TEzEntityID; Override;
    function GetParentControl(Painter: TEzPainterObject;
      var Preview: Boolean; var aBox: TWinControl): TWinControl;
    procedure LoadLines(RichEdit: TRichEdit; aParent: TWinControl);
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint; RTFLines: TStrings );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; aCanvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;

    Property Lines: TStrings Read GetLines;
  End;

  TEzRTFText2 = class(TEzRtfText)
  Private
    FMMWidth: Double;
    FMMHeight: Double;
  Protected
    Function GetEntityID: TEzEntityID; Override;
  Public
    Constructor CreateEntity( Const P1, P2: TEzPoint; RTFLines: TStrings; TheMMWidth, TheMMHeight: Double );
    //
    procedure CheckSize( Grapher: TEzGrapher; aParent: TWinControl );
    Procedure Draw( Grapher: TEzGrapher; aCanvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function  StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    //
    property MMHeight: Double read FMMHeight write FMMHeight;
    property MMWidth: Double read FMMWidth write FMMWidth;
  end;


  {-------------------------------------------------------------------------------}
  {                  BlockInsert                                                  }
  {-------------------------------------------------------------------------------}

  TEzBlockInsert = Class( TEzEntity )
  Private
    { basic data }
    FBlockName: string;
    FRotangle: Double;
    FScaleX: Double;
    FScaleY: Double;
    FText: string;
    FBlock: TEzSymbol;
    FPreloadedSet: Boolean;
    Procedure MoveAndRotateControlPts( Var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher );
    function CalcBoundingBox: TEzRect;
    procedure SetRotangle(const Value:Double);
    procedure SetScaleX(const Value:Double);
    procedure SetScaleY(const Value:Double);
    Function MakePolyPoints: TEzVector;
    procedure SetBlockName(const Value:string);
  {$IFDEF BCB}
    function GetBlockName: string;
    function GetRotangle: Double;
    function GetScaleX: Double;
    function GetScaleY: Double;
    function GetText: string;
    procedure SetText(const Value: string);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    constructor CreateEntity(const BlockName: string;
      const Pt: TEzPoint; const Rotangle, ScaleX, ScaleY: Double);
    Destructor Destroy; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    Procedure ApplyTransform; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil ); Override;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function GetControlPointType( Index: Integer ): TEzControlPointType; Override;
    Function PointCode( Const Pt: TEzPoint;
                        Const Aperture: Double;
                        Var Distance: Double;
                        SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = false ): Boolean; Override;
    function Block: TEzSymbol;

    Property BlockName: string {$IFDEF BCB} read GetBlockName {$ELSE} read FBlockName {$ENDIF} write SetBlockName;
    Property Rotangle: Double {$IFDEF BCB} read GetRotangle {$ELSE} read FRotangle {$ENDIF} write SetRotangle;
    Property ScaleX: Double {$IFDEF BCB} read GetScaleX {$ELSE} read FScaleX {$ENDIF} write SetScaleX;
    Property ScaleY: Double {$IFDEF BCB} read GetScaleY {$ELSE} read FScaleY {$ENDIF} write SetScaleY;
    Property Text: string {$IFDEF BCB} read GetText write SetText {$ELSE} read FText write FText {$ENDIF};
  End;

  {-------------------------------------------------------------------------------}
  //                  TEzSplineText
  {-------------------------------------------------------------------------------}

  TEzSplineText = Class( TEzSpline )
  Private
    FText: AnsiString;
    FFontTool: TEzFontTool;
    FCharSpacing: Double;
    FUseTrueType: Boolean;
    FFitted: Boolean;
    { if true, the polyline is used as the path for the text}
    FUsePointsAsPath: Boolean;
    FShowSpline: Boolean;
    function GetFontTool: TEzFontTool;
    procedure SetUseTrueType(const Value: Boolean);
    procedure DrawTrueType(Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; DrawMode: TEzDrawMode);
    procedure DrawVectorial(Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; DrawMode: TEzDrawMode);
  {$IFDEF BCB}
    function GetCharSpacing: Double;
    function GetFitted: Boolean;
    function GetShowSpline: Boolean;
    function GetText: String;
    function GetUsePointsAsPath: Boolean;
    function GetUseTrueType: Boolean;
    procedure SetCharSpacing(const Value: Double);
    procedure SetFitted(const Value: Boolean);
    procedure SetShowSpline(const Value: Boolean);
    procedure SetText(const Value: String);
    procedure SetUsePointsAsPath(const Value: Boolean);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
  Public
    Constructor CreateEntity(TrueType: Boolean; const SplineText: string );
    destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Function StorageSize: Integer; Override;
    Procedure UpdateExtension; Override;
    Function PointCode( Const Pt: TEzPoint;
                        Const Aperture: Double;
                        Var Distance: Double;
                        SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = false ): Boolean; Override;

    Property FontTool: TEzFontTool Read GetFontTool;
    Property Text: String {$IFDEF BCB} Read GetText Write SetText {$ELSE} Read FText Write FText {$ENDIF};
    Property CharSpacing: Double {$IFDEF BCB} Read GetCharSpacing Write SetCharSpacing {$ELSE} Read FCharSpacing Write FCharSpacing {$ENDIF};
    Property UseTrueType: Boolean {$IFDEF BCB} read GetUseTrueType {$ELSE} read FUseTrueType {$ENDIF} write SetUseTrueType;
    Property Fitted: Boolean {$IFDEF BCB} read GetFitted write SetFitted {$ELSE} read FFitted write FFitted {$ENDIF};
    Property UsePointsAsPath: Boolean {$IFDEF BCB} read GetUsePointsAsPath write SetUsePointsAsPath {$ELSE} read FUsePointsAsPath write FUsePointsAsPath {$ENDIF};
    Property ShowSpline: Boolean {$IFDEF BCB} read GetShowSpline write SetShowSpline {$ELSE} read FShowSpline write FShowSpline {$ENDIF};
  End;


Implementation

Uses
  Math, EzGraphics, EzSystem, EzConsts, EzBasicCtrls, EzLineDraw, EzStrArru,
  EzPreview, EzMiscelCtrls, EzBaseExpr;


{------------------------------------------------------------------------------}
{                  TEzPreviewEntity - preview / printing entity                   }
{------------------------------------------------------------------------------}

Constructor TEzPreviewEntity.CreateEntity( Const p1, p2: TEzPoint;
  PrintMode: TEzPrintMode; FileNo: Integer );
Begin
  Inherited CreateEntity( p1, p2 );
  FFileNo := FileNo;
  FPrintMode := PrintMode;
  FPrintFrame := True;
End;

Function TEzPreviewEntity.GetEntityID: TEzEntityID;
Begin
  result := idPreview;
End;

Function TEzPreviewEntity.BasicInfoAsString: string;
Begin
  With FProposedPrintArea do
    Result:= Format(sPreviewInfo, [FPoints.AsString,FFileNo,FPlottedUnits,
      FDrawingUnits,EzBaseExpr.NBoolean[FPrintFrame], X1,Y1,X2,Y2]);
End;

Function TEzPreviewEntity.GetGIS: TEzBaseGIS;
var
  pb: TEzPreviewBox;
  I: Integer;
Begin
  Result := Nil;
  If (PainterObject = Nil) Or (PainterObject.SourceGis=Nil) Then Exit;
  { debido a esto, solo se pueden colocar entidades TEzPreviewEntity en un
    control TEzPreviewBox }
  pb:= Nil;
  for I:= 0 to PainterObject.SourceGis.DrawBoxList.Count-1 do
    if PainterObject.SourceGis.DrawBoxList[I] is TEzPreviewBox then
    begin
      pb:= PainterObject.SourceGis.DrawBoxList[I] as TEzPreviewBox;
      Break;
    end;
  if pb = Nil then Exit;

  With pb Do
  Begin
    If ( FFileNo < 0 ) Or ( FFileNo > GISList.Count - 1 ) Then Exit;
    Result := GISList[FFileNo].GIS;
    If EqualRect2D( FProposedPrintArea, NULL_EXTENSION ) Then
      FProposedPrintArea := Result.MapInfo.LastView;
  End;
End;

{$IFDEF BCB}
function TEzPreviewEntity.GetCalculatedPrintArea: TEzRect;
begin
  Result := FCalculatedPrintArea;
end;

function TEzPreviewEntity.GetDrawingUnits: Double;
begin
  Result := FDrawingUnits;
end;

function TEzPreviewEntity.GetFileNo: Integer;
begin
  Result := FFileNo;
end;

function TEzPreviewEntity.GetPaperUnits: TEzScaleUnits;
begin
  Result := FPaperUnits;
end;

function TEzPreviewEntity.GetPlottedUnits: Double;
begin
  Result := FplottedUnits;
end;

function TEzPreviewEntity.GetPresentation: TEzPreviewPresentation;
begin
  Result := FPresentation;
end;

function TEzPreviewEntity.GetPrintFrame: Boolean;
begin
  Result := FPrintFrame;
end;

function TEzPreviewEntity.GetPrintMode: TEzPrintMode;
begin
  Result := FPrintMode;
end;

function TEzPreviewEntity.GetProposedPrintArea: TEzRect;
begin
  Result := FProposedPrintArea;
end;

function TEzPreviewEntity.GetSelection: TEzSelection;
begin
  Result := FSelection;
end;

procedure TEzPreviewEntity.SetCalculatedPrintArea(const Value: TEzRect);
begin
  FCalculatedPrintArea := Value;
end;

procedure TEzPreviewEntity.SetDrawingUnits(const Value: Double);
begin
  FDrawingUnits := Value;
end;

procedure TEzPreviewEntity.SetFileNo(const Value: Integer);
begin
  FFileNo := Value;
end;

procedure TEzPreviewEntity.SetPaperUnits(const Value: TEzScaleUnits);
begin
  FPaperUnits := Value;
end;

procedure TEzPreviewEntity.SetPlottedUnits(const Value: Double);
begin
  FPlottedUnits := Value;
end;

procedure TEzPreviewEntity.SetPresentation(
  const Value: TEzPreviewPresentation);
begin
  FPresentation := Value;
end;

procedure TEzPreviewEntity.SetPrintFrame(const Value: Boolean);
begin
  FPrintFrame := Value;
end;

procedure TEzPreviewEntity.SetPrintMode(const Value: TEzPrintMode);
begin
  FPrintMode := Value;
end;

procedure TEzPreviewEntity.SetProposedPrintArea(const Value: TEzRect);
begin
  FProposedPrintArea := Value;
end;

procedure TEzPreviewEntity.SetSelection(const Value: TEzSelection);
begin
  FSelection := Value;
end;
{$ENDIF}

Procedure TEzPreviewEntity.CalculateScales( Const WindowToFit: TEzRect );
Var
  PaperAreaWidth, PaperAreaHeight: Double;
  inchesX, inchesY: Double;
  mmsX, mmsY: Double;
  cmsX, cmsY: Double;
  DX, DY: Double;
Begin
  FProposedPrintArea := WindowToFit;
  With FProposedPrintArea Do
    If ( Emin.X >= Emax.X ) Or ( Emin.Y >= Emax.Y ) Then
    Begin
      MessageToUser( SBadExtension, smsgerror, MB_ICONERROR );
      Exit;
    End;

  inchesX := Abs( FPoints[1].X - FPoints[0].X );
  inchesY := Abs( FPoints[1].Y - FPoints[0].Y );
  If FPaperUnits = suMms Then
  Begin
    inchesX := inchesX / 25.4;
    inchesY := inchesY / 25.4;
  End Else If FPaperUnits = suCms Then
  Begin
    inchesX := inchesX / 2.54;
    inchesY := inchesY / 2.54;
  End;
  mmsX := inchesX * 25.4;
  mmsY := inchesY * 25.4;
  cmsX := inchesX * 2.54;
  cmsY := inchesY * 2.54;
  PaperAreaWidth := inchesX;
  PaperAreaHeight := inchesY;
  If FPaperUnits = suMms Then
  Begin
    PaperAreaWidth := mmsX;
    PaperAreaHeight := mmsY;
  End Else If FPaperUnits = suCms Then
  Begin
    PaperAreaWidth := cmsX;
    PaperAreaHeight := cmsY;
  End;
  With FProposedPrintArea Do
  Begin
    DX := Emax.X - Emin.X;
    DY := Emax.Y - Emin.Y;
  End;
  FDrawingUnits := dMax( DX, DY );
  FPlottedUnits := dMin( PaperAreaWidth, PaperAreaHeight );
End;

Procedure TEzPreviewEntity.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Begin
  if (Grapher.Device = adScreen) then
    if FPrintFrame or (DrawMode In [dmRubberPen, dmSelection]) then
      inherited Draw(Grapher, Canvas, Clip, DrawMode);
  If (DrawMode In [dmRubberPen, dmSelection]) Or ( GIS = Nil ) Then Exit;
  If Grapher.Device = adScreen Then
    Preview( Grapher, Canvas, Clip )
  Else
    Print( Grapher, Clip, FDemo );
End;

Procedure TEzPreviewEntity.Preview( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect );
Var
  DrawingScale, PaperAreaHeight, PaperAreaWidth: Double;
  TmpX1, TmpY1, TmpX2, TmpY2: Double;
  TmpBox, VisualWindow, VPArea: TEzRect;
  TmpGrapher: TEzGrapher;
  TmpRect: Windows.TRect;
  Clipped: Boolean;
Begin
  If ( FDrawingUnits = 0 ) Or ( fPlottedUnits = 0 ) Then Exit;

  With TmpBox Do
  Begin
    Emin.X := dMin( FPoints[0].X, FPoints[1].X );
    Emin.Y := dMin( FPoints[0].Y, FPoints[1].Y );
    Emax.X := dMax( FPoints[0].X, FPoints[1].X );
    Emax.Y := dMax( FPoints[0].Y, FPoints[1].Y );
  End;

  TmpRect := ReorderRect( Grapher.RealToRect( FPoints.Extension ) );
  InflateRect( TmpRect, -1, -1 );

  If FPresentation = ppDraft Then
  Begin
    Canvas.Font.Handle := EzSystem.DefaultFontHandle;
    DrawText( Canvas.Handle, PChar( Format( '<%s>', [GIS.FileName] ) ), -1, TmpRect,
      DT_SINGLELINE Or DT_CENTER Or DT_VCENTER );
    Exit;
  End;

  DrawingScale := FDrawingUnits / FPlottedUnits;

  PaperAreaWidth := Abs( TmpBox.Emax.X - TmpBox.Emin.X );
  PaperAreaHeight := Abs( TmpBox.Emax.Y - TmpBox.Emin.Y );

  //TmpMinDrawLimit := Globalinfo.GlobalParams.MinDrawLimit;
  //Globalinfo.GlobalParams.MinDrawLimit := 0;

  TmpGrapher := TEzGrapher.Create( 10, adScreen );
  Try
    With TmpRect Do
      TmpGrapher.SetViewport( Left, Top, Right, Bottom );
    FProposedPrintArea := ReorderRect2D( FProposedPrintArea );
    FCalculatedPrintArea := FProposedPrintArea;
    With FCalculatedPrintArea Do
    Begin
      TmpX1 := Emin.X;
      TmpY2 := Emax.Y;
      TmpX2 := TmpX1 + PaperAreaWidth * DrawingScale;
      TmpY1 := TmpY2 - PaperAreaHeight * DrawingScale;
    End;
    With FCalculatedPrintArea Do
    Begin // mark the calculated visual window
      Emin.X := TmpX1;
      Emin.Y := TmpY1;
      Emax.X := TmpX2;
      Emax.Y := TmpY2;
    End;
    TmpGrapher.SetWindow( TmpX1, TmpX2, TmpY1, TmpY2 );
    TmpGrapher.SetViewTo( FCalculatedPrintArea ); //move screen to center!
    VisualWindow := TmpGrapher.CurrentParams.VisualWindow;
    // Now calculate the DrawBox rect in TEzPreviewEntity coordinates
    VPArea := TmpGrapher.RectToReal( Grapher.RealToRect( Clip ) );
    Clipped := FALSE;
    With VisualWindow Do
    Begin
      If Emin.X < VPArea.Emin.X Then
      Begin
        Emin.X := VPArea.Emin.X;
        Clipped := TRUE;
      End;
      If Emin.Y < VPArea.Emin.Y Then
      Begin
        Emin.Y := VPArea.Emin.Y;
        Clipped := TRUE;
      End;
      If Emax.X > VPArea.Emax.X Then
      Begin
        Emax.X := VPArea.Emax.X;
        Clipped := TRUE;
      End;
      If Emax.Y > VPArea.Emax.Y Then
      Begin
        Emax.Y := VPArea.Emax.Y;
        Clipped := TRUE;
      End;
    End;
    If Not Clipped Then
    Begin
      TmpRect := TmpGrapher.RealToRect( VisualWindow );
      With TmpRect Do
        TmpGrapher.CanvasRegionStacker.Push( Canvas, CreateRectRgn( Left, Top, Right, Bottom ) );
    End;

    With TEzPainterObject.Create( Nil ) Do
      Try
        DrawEntities( VisualWindow,
          GIS,
          Canvas,
          TmpGrapher,
          FSelection,
          FALSE,
          FALSE,
          FPrintMode,
          Self.PainterObject.SourceGis.DrawBoxList[0].ScreenBitmap );
      Finally
        free;
      End;
  Finally
    TmpGrapher.CanvasRegionStacker.PopAll( Canvas );
    TmpGrapher.Free;
  End;
End;

{print the drawing}

procedure PrintDemoText;
var
  LogRec: TLOGFONT;
  OldFont, NewFont: HFONT;
  OldAlign: Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  Printer.Canvas.Font.Size := 40;
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.Font.Color := clGray;
  GetObject( Printer.Canvas.Font.Handle, SizeOf( LogRec ), @LogRec );
  LogRec.lfEscapement := 450;
  LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  StrPCopy( LogRec.lfFaceName, Printer.Canvas.Font.Name );
  newFont := CreateFontIndirect( LogRec );
  oldFont := SelectObject( Printer.Canvas.Handle, newFont );
  OldAlign := GetTextAlign( Printer.Canvas.Handle );
  SetTextAlign( Printer.Canvas.Handle, TA_CENTER );
  Printer.Canvas.TextOut( Printer.PageWidth Div 2, Printer.PageHeight Div 2,
    'Д   е   м   о   н   с   т   р   а   ц   и   о   н   н   а   я         в   е   р   с   и   я' );
  newFont := SelectObject( Printer.Canvas.Handle, oldFont );
  DeleteObject( newFont );
  SetTextAlign( Printer.Canvas.Handle, OldAlign );
end;

Procedure TEzPreviewEntity.Print( Grapher: TEzGrapher; Const Clip: TEzRect;
  Demo: Boolean = False);
Var
  VPArea: TEzRect;
  DrawingScale: Double;
  PaperAreaHeight, PaperAreaWidth: Double;
  TmpX1, TmpY1, TmpX2, TmpY2: Double;
  TmpBox, VisualWindow: TEzRect;
  PrinterGrapher: TEzGrapher;
  TmpShowText, Clipped: Boolean;
  TmpMinDrawLimit: Integer;
  PrinterAreaRect, R: TRect;
Begin
  If ( FDrawingUnits = 0 ) Or ( fPlottedUnits = 0 ) Then
    Exit;

  //Printer.BeginDoc;
  TmpBox.Emin.X := dMin( FPoints[0].X, FPoints[1].X );
  TmpBox.Emin.Y := dMin( FPoints[0].Y, FPoints[1].Y );
  TmpBox.Emax.X := dMax( FPoints[0].X, FPoints[1].X );
  TmpBox.Emax.Y := dMax( FPoints[0].Y, FPoints[1].Y );

  DrawingScale := FDrawingUnits / fPlottedUnits;

  (* ancho y alto del area a imprimir en unidades reales (mms o inches) *)
  PaperAreaWidth := Abs( TmpBox.Emax.X - TmpBox.Emin.X );
  PaperAreaHeight := Abs( TmpBox.Emax.Y - TmpBox.Emin.Y );

  { This is used to calculate a viewport rectangle in logical units }
  PrinterGrapher := TEzGrapher.Create( 10, adPrinter );
  Try
    PrinterAreaRect := Grapher.RealToRect( TmpBox );
    With PrinterAreaRect Do
      PrinterGrapher.Setviewport( Left, Top, Right, Bottom );

    FProposedPrintArea := ReorderRect2D( FProposedPrintArea );
    FCalculatedPrintArea := FProposedPrintArea;
    With FCalculatedPrintArea Do
    Begin
      TmpX1 := Emin.X;
      TmpY2 := Emax.Y;
      TmpX2 := TmpX1 + PaperAreaWidth * DrawingScale;
      TmpY1 := TmpY2 - PaperAreaHeight * DrawingScale;
    End;
    With FCalculatedPrintArea Do
    Begin // mark the calculated visual window
      Emin.X := TmpX1;
      Emin.Y := TmpY1;
      Emax.X := TmpX2;
      Emax.Y := TmpY2;
    End;
    PrinterGrapher.SetWindow( TmpX1, TmpX2, TmpY1, TmpY2 );

    VisualWindow := PrinterGrapher.CurrentParams.VisualWindow;
    // Now calculate the DrawBox rect in TEzPreviewEntity coordinates
    VPArea := PrinterGrapher.RectToReal( Grapher.RealToRect( Clip ) );
    Clipped := FALSE;
    With VisualWindow Do
    Begin
      If Emin.X < VPArea.Emin.X Then
      Begin
        Emin.X := VPArea.Emin.X;
        Clipped := TRUE;
      End;
      If Emin.Y < VPArea.Emin.Y Then
      Begin
        Emin.Y := VPArea.Emin.Y;
        Clipped := TRUE;
      End;
      If Emax.X > VPArea.Emax.X Then
      Begin
        Emax.X := VPArea.Emax.X;
        Clipped := TRUE;
      End;
      If Emax.Y > VPArea.Emax.Y Then
      Begin
        Emax.Y := VPArea.Emax.Y;
        Clipped := TRUE;
      End;
    End;
    If Not Clipped Then
    Begin
      R := PrinterGrapher.RealToRect( VisualWindow );
      With R Do
        PrinterGrapher.CanvasRegionStacker.Push( Printer.Canvas,
          CreateRectRgn( Left, Top, Right, Bottom ) );
    End;
    TmpMinDrawLimit := Ez_Preferences.MinDrawLimit;
    Ez_Preferences.MinDrawLimit := 0;
    With Ez_Preferences Do
    Begin
      TmpShowText := ShowText;
      ShowText := True;
    End;

    With TEzPainterObject.Create(Nil) Do
      Try
        DrawEntities( VisualWindow,
          GIS,
          Printer.Canvas,
          PrinterGrapher,
          FSelection,
          FALSE,
          FALSE,
          FPrintMode,
          Nil );   { warning!!: cannot show transparent bitmaps on printer }
      Finally
        free;
      End;

    With Ez_Preferences Do
    Begin
      MinDrawLimit := TmpMinDrawLimit;
      ShowText := TmpShowText;
    End;

  Finally
    PrinterGrapher.CanvasRegionStacker.PopAll( Printer.Canvas );
    PrinterGrapher.Free;
  End;
{$IFDEF DEMO}
  PrintDemoText;
{$ELSE}
  if Demo then
    PrintDemoText;
{$ENDIF}
End;

Procedure TEzPreviewEntity.LoadFromStream( Stream: TStream );
Begin
  Inherited LoadFromStream( Stream );
  With Stream Do
  Begin
    Read( FFileNo, SizeOf( Integer ) );
    Read( FPlottedUnits, SizeOf( Double ) );
    Read( FDrawingUnits, SizeOf( Double ) );
    Read( FPaperUnits, SizeOf( FPaperUnits ) );
    Read( FPrintFrame, SizeOf( Boolean ) );
    Read( FPresentation, sizeof( fPresentation ) );
    Read( FProposedPrintArea, SizeOf( TEzRect ) );
    Read( FCalculatedPrintArea, SizeOf( TEzRect ) );
    Read( FPrintMode, sizeof( FPrintMode ) );
  End;

  // CalculateScales;
End;

Procedure TEzPreviewEntity.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  { Save aditional properties }
  With Stream Do
  Begin
    Write( FFileNo, SizeOf( Integer ) );
    Write( FPlottedUnits, SizeOf( Double ) );
    Write( FDrawingUnits, SizeOf( Double ) );
    Write( FPaperUnits, SizeOf( FPaperUnits ) );
    Write( FPrintFrame, SizeOf( Boolean ) );
    Write( FPresentation, sizeof( FPresentation ) );
    Write( FProposedPrintArea, SizeOf( TEzRect ) );
    Write( FCalculatedPrintArea, SizeOf( TEzRect ) );
    Write( FPrintMode, sizeof( FPrintMode ) );
  End;
End;


function TEzPreviewEntity.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      // the move control point
      MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      AddPoint( MovePt.X, MovePt.Y );
    end;
  End;
end;

function TEzPreviewEntity.GetControlPointType(Index: Integer): TEzControlPointType;
begin
  If Index = 8 Then
    Result := cptMove
  Else
    Result := cptNode;
end;

procedure TEzPreviewEntity.UpdateControlPoint(Index: Integer; const Value: TEzPoint; Grapher: TEzGrapher=Nil);
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
  M: TEzMatrix;
Begin
  FPoints.DisableEvents := True;
  Try
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    Case Index Of
      0: // LOWER LEFT
        Begin
          TmpR.Emin := Value;
        End;
      1: // MIDDLE BOTTOM
        Begin
          TmpR.Emin.Y := Value.Y;
        End;
      2: // LOWER RIGHT
        Begin
          TmpR.Emax.X := Value.X;
          TmpR.Emin.Y := Value.Y;
        End;
      3: // MIDDLE RIGHT
        Begin
          TmpR.Emax.X := Value.X;
        End;
      4: // UPPER RIGHT
        Begin
          TmpR.Emax := Value;
        End;
      5: // MIDDLE TOP
        Begin
          TmpR.Emax.Y := Value.Y;
        End;
      6: // UPPER LEFT
        Begin
          TmpR.Emin.X := Value.X;
          TmpR.Emax.Y := Value.Y;
        End;
      7: // MIDDLE LEFT
        Begin
          TmpR.Emin.X := Value.X;
        End;
      8: // MOVE POINT
        Begin
          // calculate current move point
          MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
          MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
          M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
          TmpR.Emin := TransformPoint2d( TmpR.Emin, M );
          TmpR.Emax := TransformPoint2d( TmpR.Emax, M );
        End;
    End;
    FPoints[0] := TmpR.Emin;
    FPoints[1] := TmpR.Emax;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
end;


function TEzPreviewEntity.IsEqualTo(Entity: TEzEntity;
  IncludeAttribs: Boolean = false ): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idPreview ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( ( FFileNo <> TEzPreviewEntity(Entity).FFileNo ) Or
                           ( FPlottedUnits <> TEzPreviewEntity(Entity).FPlottedUnits ) Or
                           ( FDrawingUnits <> TEzPreviewEntity(Entity).FDrawingUnits ) Or
                           ( FPaperUnits <> TEzPreviewEntity(Entity).FPaperUnits ) Or
                           ( FPrintMode <> TEzPreviewEntity(Entity).FPrintMode ) Or
                           ( FPresentation <> TEzPreviewEntity(Entity).FPresentation ) Or
                           ( FPrintFrame <> TEzPreviewEntity(Entity).FPrintFrame ) Or
                           Not EqualRect2d( FProposedPrintArea, TEzPreviewEntity(Entity).FProposedPrintArea ) Or
                           ( FPrintFrame <> TEzPreviewEntity(Entity).FPrintFrame ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{-------------------------------------------------------------------------------}
{                  Implements TEzTableEntity                                          }
{-------------------------------------------------------------------------------}

{ ----- TEzTitleItem ----- }

Constructor TEzTitleItem.Create( ColumnItem: TEzColumnItem );
Begin
  Inherited Create;
  FColumnItem := ColumnItem;
  FColor := clWhite;
  FFont.Name := EzSystem.DefaultFontName;
  FFont.Height := 1;
  FFont.Angle := 0;
End;

{ ----- TEzColumnItem ----- }

Constructor TEzColumnItem.Create( ColumnList: TEzColumnList );
Begin
  Inherited Create;
  FColumnList := ColumnList;
  FStrings:= TStringSparseList.Create( SPASmall );
  FTitle := TEzTitleItem.Create( self );
  FTitle.Alignment := taCenter;
  FColor := clWhite;
  FFont.Name := EzSystem.DefaultFontName;
  FFont.Height := 1;
  Width:= 1;
End;

Destructor TEzColumnItem.Destroy;
Begin
  FTitle.Free;
  FStrings.Free;
  Inherited Destroy;
End;

{ ----- TEzColumnList ----- }

Constructor TEzColumnList.Create( Table: TEzTableEntity );
Begin
  Inherited Create;
  FTable := Table;
  FItems := TList.Create;
End;

Destructor TEzColumnList.Destroy;
Begin
  Clear;
  FItems.free;
  Inherited Destroy;
End;

Function TEzColumnList.Add: TEzColumnItem;
Begin
  Result := TEzColumnItem.Create( Self );
  FItems.Add( Result );
End;

Procedure TEzColumnList.Clear;
Var
  I: Integer;
Begin
  For I := 0 To FItems.Count - 1 Do
    TEzColumnItem( FItems[I] ).Free;
  FItems.Clear;
End;

Procedure TEzColumnList.Delete( Index: Integer );
Begin
  TEzColumnItem( FItems[Index] ).Free;
  FItems.Delete( Index );
End;

Function TEzColumnList.GetCount: Integer;
Begin
  Result := FItems.Count;
End;

Function TEzColumnList.GetItem( Index: Integer ): TEzColumnItem;
Begin
  Result := FItems[Index];
End;

Procedure TEzColumnList.Assign( Source: TEzColumnList );
Var
  I: Integer;
Begin
  Clear;
  For I := 0 To Source.Count - 1 Do
    With Add Do
    Begin
      ColumnType:= Source[I].ColumnType;
      Strings.Assign( Source[I].Strings );
      Alignment := Source[I].Alignment;
      Color := Source[I].Color;
      Transparent := Source[I].Transparent;
      FFont := Source[I].Font;
      Width := Source[I].Width;
      With Title Do
      Begin
        Caption := Source[I].Title.Caption;
        Alignment := Source[I].Title.Alignment;
        Color := Source[I].Title.Color;
        Transparent := Source[I].Title.Transparent;
        FFont := Source[I].Title.Font;
      End;
    End;
End;

Procedure TEzColumnList.Exchange( Index1, Index2: Integer );
Begin
  FItems.Exchange( Index1, Index2 );
End;

function TEzColumnList.Down( Index: Integer ): Boolean;
var
  temp: Pointer;
begin
  Result:= False;
  if ( Index < 0 ) or ( Index >= FItems.Count - 1 ) then Exit;
  temp:= FItems[Index + 1];
  FItems[Index + 1]:= FItems[Index];
  FItems[Index]:= temp;
  Result:= True;
end;

function TEzColumnList.Up( Index: Integer ): Boolean;
var
  temp: Pointer;
begin
  Result:= False;
  if ( Index <= 0 ) or ( Index > FItems.Count - 1 ) then Exit;
  temp:= FItems[Index - 1];
  FItems[Index - 1]:= FItems[Index];
  FItems[Index]:= temp;
  Result:= True;
end;

{ ----- TEzTableEntity ----- }

Constructor TEzTableEntity.CreateEntity( Const P1, P2: TEzPoint );
Begin
  Inherited CreateEntity( P1, P2 );
  FRowHeight := Abs( P1.Y - P2.Y ) / FRowCount;
  FTitleHeight := FRowHeight;
End;

Destructor TEzTableEntity.Destroy;
Begin
  FColumns.free;
  Inherited Destroy;
End;

procedure TEzTableEntity.Initialize;
begin
  inherited;
  FColumns := TEzColumnList.Create( Self );
  FOptions := [ezgoVertLine, ezgoHorzLine];
  FRowCount := 5;
  With FGridStyle Do
  Begin
    Visible := true;
    Style := 1;
    Color := clBlack;
    Width := 0.0;
  End;
  FDefaultDrawing := True;
  FLoweredColor := clGray;
end;

Function TEzTableEntity.BasicInfoAsString: string;
Var
  I,J: Integer;
  temp: string;
Begin
  result := Format(sTableInfo, [FPoints.AsString, RowCount,Columns.Count,
    EzBaseExpr.NBoolean[ezgoHorzLine in Options],
    EzBaseExpr.NBoolean[ezgoVertLine in Options],
    EzBaseExpr.NBoolean[Gridstyle.Visible], Gridstyle.Style,Gridstyle.Color,Gridstyle.Width,
    BorderWidth,LoweredColor]) + CrLf + '{' + CrLf;
  For I:= 0 to Columns.Count-1 do
  begin
    With Columns[I] Do
    Begin
      // the row data
      temp := '';
      For J:= 0 to Self.RowCount - 1 do
        If J < Self.RowCount - 1 Then
          temp := temp + StringOfChar(#32,6) + Format(sRowDataInfo,[Strings[J]]) + ',' + CrLf
        Else
          temp := temp + StringOfChar(#32,6) + Format(sRowDataInfo,[Strings[J]]);

      Result:= Result + StringOfChar(#32,2) + sColumnInfo + CrLf +
        StringOfChar(#32,4) + Format(sTTFontInfo,[Font.Name,
        EzBaseExpr.NBoolean[fsbold in Font.Style],
        EzBaseExpr.NBoolean[fsitalic in Font.Style],
        EzBaseExpr.NBoolean[fsUnderline in Font.Style],
        EzBaseExpr.NBoolean[fsStrikeout in Font.Style],
        Font.Color,Windows.ANSI_CHARSET]) + CrLf +

        StringOfChar(#32,4) + Format(sTableColumnInfo, [Width,EzBaseExpr.NBoolean[Transparent],
          Color,Ord(Alignment),Ord(ColumnType),Font.Height]) + CrLf +

        StringOfChar(#32,4) + sTitleCaption + CrLf +
        StringOfChar(#32,6) + Format(sTTFontInfo,[Title.Font.Name,
        EzBaseExpr.NBoolean[fsbold in Title.Font.Style],
        EzBaseExpr.NBoolean[fsitalic in Title.Font.Style],
        EzBaseExpr.NBoolean[fsUnderline in Title.Font.Style],
        EzBaseExpr.NBoolean[fsStrikeout in Title.Font.Style],
        Title.Font.Color,Windows.ANSI_CHARSET]) + CrLf+
        StringOfChar(#32,6) + Format(sColumnTitleInfo, [Title.Caption,Ord(Title.Alignment),
          Title.Color,EzBaseExpr.NBoolean[Title.Transparent],
          Title.Font.Height] ) + CrLf +

        StringOfChar(#32,4) + sDataInfo + CrLf + temp + CrLf + '  }' + CrLf + CrLf;
    End;
  end;
  result:= result + '}' + CrLf;
  
End;

Function TEzTableEntity.GetEntityID: TEzEntityID;
Begin
  result := idTable;
End;

Function TEzTableEntity.GetColumns: TEzColumnList;
Begin
  If ( FColumns = Nil ) Then
    FColumns := TEzColumnList.Create( self );
  result := FColumns
End;

{$IFDEF BCB}
function TEzTableEntity.GetBorderWidth: Double;
begin
  Result := FBorderWidth;
end;

function TEzTableEntity.GetDefaultDrawing: Boolean;
begin
  Result := FDefaultDrawing;
end;

function TEzTableEntity.GetGridStyle: TEzTableBorderStyle;
begin
  Result := FGridStyle;
end;

function TEzTableEntity.GetLoweredColor: TColor;
begin
  Result := FLoweredColor;
end;

function TEzTableEntity.GetOnDrawCell: TEzTableDrawCellEvent;
begin
  Result := FOnDrawCell;
end;

function TEzTableEntity.GetOptions: TEzGridOptions;
begin
  Result := FOptions;
end;

function TEzTableEntity.GetOwnerDraw: Boolean;
begin
  Result := FOwnerDraw;
end;

function TEzTableEntity.GetRowCount: Integer;
begin
  Result := FRowCount;
end;

function TEzTableEntity.GetRowHeight: Double;
begin
  Result := FRowHeight;
end;

function TEzTableEntity.GetTitleHeight: Double;
begin
  Result := FTitleHeight;
end;

procedure TEzTableEntity.SetBorderWidth(const Value: Double);
begin
  FBorderWidth := Value;
end;

procedure TEzTableEntity.SetDefaultDrawing(const Value: Boolean);
begin
  FDefaultDrawing := Value;
end;

procedure TEzTableEntity.SetGridStyle(const Value: TEzTableBorderStyle);
begin
  FGridStyle := Value;
end;

procedure TEzTableEntity.SetLoweredColor(const Value: TColor);
begin
  FLoweredColor := Value;
end;

procedure TEzTableEntity.SetOnDrawCell(const Value: TEzTableDrawCellEvent);
begin
  FOnDrawCell := Value;
end;

procedure TEzTableEntity.SetOptions(const Value: TEzGridOptions);
begin
  FOptions := Value;
end;

procedure TEzTableEntity.SetOwnerDraw(const Value: Boolean);
begin
  FOwnerDraw := Value;
end;

procedure TEzTableEntity.SetTitleHeight(const Value: Double);
begin
  FTitleHeight := Value;
end;
{$ENDIF}

procedure TEzTableEntity.SetRowHeight(const Value: Double);
begin
  FRowHeight := Value;
end;

Function TEzTableEntity.StorageSize: Integer;
Var
  i, j: Integer;
Begin
  Result := Inherited StorageSize + SizeOf( FOptions ) + SizeOf( FRowHeight )
    + sizeof( FRowCount ) + sizeof( FTitleHeight )
    + sizeof( FGridStyle ) + sizeof( FOwnerDraw )
    + sizeof( FBorderWidth ) + sizeof( FDefaultDrawing )
    + sizeof( FLoweredColor );
  For i := 0 To Columns.Count - 1 Do
    With Columns[i] Do
    Begin
      result := result + sizeof( FAlignment ) + sizeof( FColor )
        + sizeof( FTransparent ) + sizeof( FFont ) + sizeof( FWidth );
      With FTitle Do
        result := result + Length( FCaption ) + sizeof( FAlignment ) + sizeof( FColor )
          + sizeof( FTransparent ) + sizeof( FFont );
      for J:= 0 to FRowCount - 1 do
        result := result + Length( Strings[ J ] );
    End;
End;

Procedure TEzTableEntity.LoadFromStream( Stream: TStream );
Var
  i, j, n: integer;
  Item: TEzColumnItem;
Begin
  Inherited LoadFromStream( Stream );
  With Stream Do
  Begin
    Read( FOptions, sizeof( FOptions ) );
    Read( FRowHeight, sizeof( FRowHeight ) );
    Read( FRowCount, sizeof( FRowCount ) );
    Read( FTitleHeight, sizeof( FTitleHeight ) );
    Read( FGridStyle, sizeof( FGridStyle ) );
    Read( FOwnerDraw, sizeof( FOwnerDraw ) );
    Read( FBorderWidth, sizeof( FBorderWidth ) );
    Read( FDefaultDrawing, sizeof( FDefaultDrawing ) );
    Read( FLoweredColor, sizeof( FLoweredColor ) );
    Read( n, sizeof( n ) ); // number of columns
    Columns.Clear;
    For i := 0 To n - 1 Do
    Begin
      Item := Columns.Add;
      With Item Do
      Begin
        Read( FColumnType, sizeof( FColumnType ) );
        Read( FAlignment, sizeof( FAlignment ) );
        Read( FColor, sizeof( FColor ) );
        Read( FTransparent, sizeof( FTransparent ) );
        Read( FFont, sizeof( FFont ) );
        Read( FWidth, sizeof( FWidth ) );
        With FTitle Do
        Begin
          FCaption := EzReadStrFromStream( stream );
          Read( FAlignment, sizeof( FAlignment ) );
          Read( FColor, sizeof( FColor ) );
          Read( FTransparent, sizeof( FTransparent ) );
          Read( FFont, sizeof( FFont ) );
        End;
        for j:= 0 to FRowCount - 1 do
          Strings[J]:= EzReadStrFromStream( stream );
      End;
    End;
    SetRowCount( FRowCount ); { force to fix Strings data }
  End;
  FOriginalSize := StorageSize;
End;

Procedure TEzTableEntity.SaveToStream( Stream: TStream );
Var
  i, j, n: integer;
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    Write( FOptions, sizeof( FOptions ) );
    Write( FRowHeight, sizeof( FRowHeight ) );
    Write( FRowCount, sizeof( FRowCount ) );
    Write( FTitleHeight, sizeof( FTitleHeight ) );
    Write( FGridStyle, sizeof( FGridStyle ) );
    Write( FOwnerDraw, sizeof( FOwnerDraw ) );
    Write( FBorderWidth, sizeof( FBorderWidth ) );
    Write( FDefaultDrawing, sizeof( FDefaultDrawing ) );
    Write( FLoweredColor, sizeof( FLoweredColor ) );
    n := Columns.Count;
    Write( n, sizeof( n ) ); // number of columns
    For i := 0 To n - 1 Do
      With Columns[i] Do
      Begin
        Write( FColumnType, sizeof( FColumnType ) );
        Write( FAlignment, sizeof( FAlignment ) );
        Write( FColor, sizeof( FColor ) );
        Write( FTransparent, sizeof( FTransparent ) );
        Write( FFont, sizeof( FFont ) );
        Write( FWidth, sizeof( FWidth ) );
        With FTitle Do
        Begin
          EzWriteStrToStream( FCaption, stream );
          Write( FAlignment, sizeof( FAlignment ) );
          Write( FColor, sizeof( FColor ) );
          Write( FTransparent, sizeof( FTransparent ) );
          Write( FFont, sizeof( FFont ) );
        End;
        for j:= 0 to FRowCount - 1 do
          EzWriteStrToStream( FStrings[j], stream );
      End;
  End;
  FOriginalSize := StorageSize;
End;

Procedure TEzTableEntity.SetRowCount( Value: Integer );
var
  I,J: Integer;
Begin
  FRowCount := Value;
  if Columns.Count > 0 then
  begin
    for I:= 0 to Columns.Count - 1 do
    begin
      for j:= Columns[I].Strings.Count to Value do
        Columns[I].FStrings.Add( '' );
    end;
  end;
End;

(*
Procedure TEzTableEntity.Draw( Grapher: TEzGrapher; Canvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  TmpR: TEzRect;
  GridRect, R, Rect, R1: TRect;
  GridLineWidth, OuterLineWidth, OuterLineHeight: Integer;
  BorderWidthPix, BorderHeightPix: Integer;
  GridRowHeight, TitleRowHeight: Integer;
  GridWidth, I, J, K, N, X, Y, TmpHeight, H, Y1: Integer;
  GridColWidths: Array[0..1000] Of Integer; // max of 1000 columns
  uFormat: Word;
  txt: String;
  ValInteger: Integer;
  Poly: array[0..4] of TPoint;
  Parts: array[0..0] of Integer;
  BmpRes: HBitmap;
  Bmp: TBitmap;
  ForeColor,BackColor:TColor;
  Resname: string;
  TmpGrapher: TEzGrapher;
  linetype: integer;
  Penwidth: integer;
  ALineColor: TColor;
  Symbol: TEzSymbol;
  dist: double;
  V: TEzVector;
  TmpMarginX: double;
  TmpMarginY: double;
  Rgn: HRgn;
  PenStyle: TEzPenStyle;
  PtArr: Array[0..5] of TPoint;
  Repit: Integer;
  e:TEzRect;
  GraphicLink: TEzGraphicLink;
  filnam: string;
  TheRowHeight:Double;

  procedure BitmapToPrinter(DestRect: TRect;
    ABitmap: TBitmap; L, T, W, H: Integer);
  var
    Info: PBitmapInfo;
    Image: Pointer;
    Tc: Integer;
    InfoSize, ImageSize: DWORD;
  begin
    GetDIBSizes(ABitmap.Handle, InfoSize, ImageSize);
    Info := AllocMem(InfoSize);
    Image := GlobalAllocPtr(HeapAllocFlags, ImageSize);
    try
      with ABitmap do
        GetDIB(Handle, Palette, Info^, Image^);
      Tc := T;
      if Info^.bmiHeader.biHeight > 0 then
        Tc := Info^.bmiHeader.biHeight - H - T;
      with DestRect do
        StretchDIBits(Canvas.Handle, Left, Top, (Right - Left), (Bottom - Top),
          L, Tc, W, H, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
    finally
      if InfoSize < 65535 then
        FreeMem(Info,InfoSize)
      else
        GlobalFreePtr(Info);
      GlobalFreePtr(Image);
    end;
  end;

  procedure MyPrintBitmap(abmp: TBitmap);
  var
    hPaintPal, hOldPal: HPalette;                  {Used for realizing the palette}
  begin
    InflateRect(R,-2,-2);
    hPaintPal:= abmp.Palette;
    hOldPal:= SelectPalette(Canvas.Handle, hPaintPal, False);
    try
      RealizePalette(Canvas.Handle);
      SetStretchBltMode(Canvas.Handle, STRETCH_DELETESCANS);
      if Grapher.Device = adScreen then    // this goes to the screen
      begin
        StretchBlt(Canvas.Handle, R.Left, R.Top,
          (R.Right - R.Left), (R.Bottom - R.Top),
          abmp.Canvas.Handle, 0, 0, abmp.Width, abmp.Height, SRCCOPY);
      end else    // this goes to the printer
      begin
          BitmapToPrinter(R,abmp,0,0,abmp.Width,abmp.Height);
      end;
    finally
      if hOldPal <> 0 then
        SelectPalette(Canvas.Handle, hOldPal, False);
    end;
  end;

  procedure DrawTitleOwnerDraw;
  begin
  end;

var
  SplitRows: TIntegerList;
  TmpInt: Integer;
begin
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D(TmpR);
  GridRect := Grapher.RealToRect(TmpR);
  if (DrawMode in [dmRubberPen, dmSelection]) then
  begin
    DrawAbnormal(Grapher, Canvas, Clip, DrawMode, Data);
    Exit;
  end;
  if (FRowCount < 0) or (Columns.Count < 1) then
  begin
    DrawEmpty(Grapher, Canvas, Clip, GridRect);
    Exit;
  end;

  // Calculate row height (FRowHeight is ignored because it is causing drawing problems )
  if FRowHeight < 1 then
    TheRowHeight := Abs(TmpR.Emax.Y - TmpR.Emin.Y) / Succ(FRowCount)
  else
    TheRowHeight := FRowHeight;

  { calculate parameters }
  OuterLineWidth := Grapher.RealToDistX(PenTool.FPenStyle.Scale);
  OuterLineHeight := Grapher.RealToDistY(PenTool.FPenStyle.Scale);
  GridLineWidth := Grapher.RealToDistX(FGridStyle.Width);
  GridRowHeight := Grapher.RealToDistY(TheRowHeight);
  TitleRowHeight := Grapher.RealToDistY(FTitleHeight);
  GridWidth := Abs(GridRect.Right - GridRect.Left - OuterLineWidth);
  N := 0;
  for I := 0 to Columns.Count - 2 do
  begin
    GridColWidths[I] := Grapher.RealToDistX(Columns[I].Width);
    Inc(N, GridColWidths[I]);
  end;
  GridColWidths[Pred(Columns.Count)] := EzLib.IMax(0, GridWidth - N);
  { calculate grid cells border width in pixels }
  If FBorderWidth > 0 Then
  Begin
    BorderWidthPix := Grapher.RealToDistX( FBorderWidth );
    BorderHeightPix := Grapher.RealToDistY( FBorderWidth );
  End
  Else
  Begin
    BorderWidthPix := 0;
    BorderHeightPix := 0;
  End;

  SplitRows := TIntegerList.Create;
  try
    For I := 2 To Succ(FRowCount) Do
    begin
      TmpInt := 0;
      For J := 0 To Pred(Columns.Count) Do
      begin
        txt := Trim(Columns[J].Strings[I - 2]);
        if txt <> '' then
          Inc(TmpInt);
      end;
      if TmpInt < 2 then
        SplitRows.Add(I);
    end;
    { now draw the text }
    X := GridRect.Left + (OuterLineWidth Div 2);
    N := Columns.Count;
    For J := 0 To Pred(N) Do
    Begin
      Rect.Left := X;
      Rect.Right := X + GridColWidths[J] - 1;
      Y := GridRect.Top + (OuterLineHeight Div 2);
      For I := 1 To Succ(FRowCount) Do
      Begin
        Rect.Top := Y;
        Rect.Bottom := Y + GridRowHeight - 1;
        R := Rect;
        If I = 1 Then
        Begin
          // the title
          R.Bottom := Y + TitleRowHeight - 1;
          If Not FOwnerDraw Or FDefaultDrawing Then
          Begin
            If J = 0 Then
              R.Left := R.Left + BorderWidthPix
            Else
              R.Left := R.Left + ( BorderWidthPix Div 2 );
            R.Top := R.Top + BorderHeightPix;
            R.Right := R.Right - ( BorderWidthPix Div 2 );
            R.Bottom := R.Bottom - ( BorderHeightPix Div 2 );
            { pinta el relleno de la celda }
            With Canvas Do
            Begin
              If Not Columns[J].Title.FTransparent Then
              Begin
                Brush.Style := bsSolid;
                Brush.Color := Columns[J].Title.FColor;
                FillRect( R );
              End;
              { dibuja el rectangulo exterior de la celda }
              Pen.Style:=psSolid;
              Pen.Width := IMax( 1, GridLineWidth );
              Pen.Color := FGridStyle.Color;
              With R Do
              Begin
                if ezgoHorzLine in FOptions then
                begin
                  MoveTo( Left, Top );
                  LineTo( Right, Top );
                end;
                if ezgoVertLine in FOptions then
                begin
                  MoveTo( Left, Top );
                  LineTo( Left, Bottom );
                end;
              End;
              Pen.Color := FLoweredColor;
              With R Do
              Begin
                if ezgoHorzLine in FOptions then
                begin
                  Moveto( Left, Bottom );
                  Lineto( Right, Bottom );
                end;
                if ezgoVertLine in FOptions then
                begin
                  Moveto( Right, Bottom );
                  Lineto( Right, Top );
                end;
              End;
              InflateRect( R, -Pen.Width, -Pen.Width );
            End;
          End;
          If Not FOwnerDraw Then
          Begin
            With Columns[J].Title Do
            Begin
              TmpHeight := IMax( 1, Abs( Grapher.RealToDistY( FFont.Height ) ) );
              TmpHeight := IMin( TmpHeight, ( R.Bottom - R.Top ) - 2 );
              With Canvas.Font Do
              Begin
                Name := FFont.Name;
                Style := FFont.Style;
                Height := TmpHeight;
                Color := FFont.Color;
              End;
              Case FAlignment Of
                taLeftJustify: uFormat := DT_LEFT;
                taRightJustify: uFormat := DT_RIGHT;
                taCenter: uFormat := DT_CENTER;
              Else
                uFormat := DT_LEFT;
              End;
            End;
            SetBkMode( Canvas.Handle, TRANSPARENT );
            DrawText( Canvas.Handle, PChar( Columns[J].Title.FCaption ), -1, R,
              uFormat  Or {DT_VCENTER Or} DT_WORDBREAK{DT_SINGLELINE} );
          End
          Else If Assigned( FOnDrawCell ) Then
            FOnDrawCell( Self, J, I - 1, Canvas, Grapher, R );
        End
        Else
        Begin
          // the row
          //Canvas.brush.style:=bsclear;
          //with R do Canvas.rectangle(left,top,right,bottom);
          If J = 0 Then
            R.Left := R.Left + BorderWidthPix
          Else
            R.Left := R.Left + ( BorderWidthPix Div 2 );
          R.Top := R.Top + ( BorderHeightPix Div 2 );
          R.Right := R.Right - ( BorderWidthPix Div 2 );
          R.Bottom := R.Bottom - ( BorderHeightPix Div 2 );
          ///
          if (SplitRows.IndexOfValue(I) < 0) then
          begin
            R1 := R;
            H := DrawText(Canvas.Handle, PChar( txt ), -1, R1, uFormat Or DT_VCENTER Or DT_WORDBREAK Or DT_CALCRECT );
            if H > (R.Bottom - R.Top) then
            begin
              R.Bottom := R.Top + H + 2;
              Y1 := Y1 + H + 2 - (R.Bottom - R.Top);
              if Y1 > Y then
                Y := Y1;
            end;
          end;
          ///
          { pinta el relleno de la celda }
          If FDefaultDrawing Then
          Begin
            With Canvas Do
            Begin
              If Not Columns[J].FTransparent Then
              Begin
                Brush.Style := bsSolid;
                Brush.Color := Columns[J].FColor;
                FillRect( R );
              End;
              { dibuja el rectangulo exterior de la celda }
              Pen.Style:=psSolid;
              Pen.Width := IMax( 1, GridLineWidth );
              Pen.Color := FGridStyle.Color;
              With R Do
              Begin
                if ezgoHorzLine in FOptions then
                begin
                  MoveTo( Left, Top );
                  LineTo( Right, Top );
                end;
                if (SplitRows.IndexOfValue(I) < 0) or (J = 0) then
                if ezgoVertLine in FOptions then
                begin
                  MoveTo( Left, Top );
                  LineTo( Left, Bottom );
                end;
              End;
              Pen.Color := FLoweredColor;
              With R Do
              Begin
                if ezgoHorzLine in FOptions then
                begin
                  Moveto( Left, Bottom );
                  Lineto( Right, Bottom );
                end;
                if (SplitRows.IndexOfValue(I) < 0) or (J = Pred(N)) then
                if ezgoVertLine in FOptions then
                begin
                  Moveto( Right, Bottom );
                  Lineto( Right, Top );
                end;
              End;
              InflateRect( R, -Pen.Width, -Pen.Width );
            End;
          End;
          If Not FOwnerDraw Then
          Begin
            uFormat := DT_LEFT;
            If I = 2 Then
            begin
              With Columns[J] Do
              Begin
                TmpHeight := IMax( 1, Abs( Grapher.RealToDistY( FFont.Height ) ) );
                TmpHeight := IMin( TmpHeight, ( R.Bottom - R.Top ) - 2 );
                With Canvas.Font Do
                Begin
                  Name := FFont.Name;
                  Style := FFont.Style;
                  Height := TmpHeight;
                  Color := FFont.Color;
                End;
              End;
            End;
            Case Columns[J].FAlignment Of
              taLeftJustify: uFormat := DT_LEFT;
              taRightJustify: uFormat := DT_RIGHT;
              taCenter: uFormat := DT_CENTER;
            End;
            txt := Columns[J].Strings[I - 2];
            if SplitRows.IndexOfValue(I) >= 0 then
            begin
              uFormat := DT_LEFT;
              R.Right := R.Left + GridWidth;
              txt := '  ' + txt;
            end;
            case Columns[J].ColumnType of
              ctLabel:
                begin
                  if trim(txt) <> '' then
                  begin
                    SetBkMode( Canvas.Handle, TRANSPARENT );
                    DrawText( Canvas.Handle, PChar( txt ), -1, R, uFormat Or DT_VCENTER Or DT_WORDBREAK );
                  end;
                end;
              ctColor:
                begin
                  ValInteger:= StrToIntDef(txt,0);
                  InflateRect( R, -2, -2 );
                  Canvas.Brush.Style:= bsSolid;
                  Canvas.Brush.Color:= ValInteger;
                  with R do Canvas.Rectangle(left, top, right, bottom);
                  Canvas.Brush.Style:= bsClear;
                end;
              ctLineStyle:
                begin
                  ValInteger:= StrToIntDef(txt,0);
                  { DRAW THE LINE TYPE }
                  TmpGrapher:= TEzGrapher.Create(10,Grapher.Device);
                  try
                    EzMiscelCtrls.DrawLinetype(TmpGrapher, Canvas, ValInteger,
                      R, [], clBlack, Columns[J].Color,False, 0, 2, false, true, false );
                  finally
                    TmpGrapher.free;
                  end;
                end;
              ctBrushStyle:
                begin
                  ValInteger:= StrToIntDef(txt,0);

                  InflateRect( R, -2, -2 );

                  EzMiscelCtrls.DrawPattern( Canvas,ValInteger,clBlack,clWhite,
                    Columns[J].Color,R,false, [], false, true, false);

                end;
              ctSymbolStyle:
                begin
                  ValInteger:= StrToIntDef(txt,0);
                  TmpGrapher:= TEzGrapher.Create(10,Grapher.Device);
                  try
                    EzMiscelCtrls.DrawSymbol( TmpGrapher, Canvas, ValInteger,
                      R, [], Columns[J].Color, false, true, false);
                  finally
                    TmpGrapher.free;
                  end;
                end;
              ctBitmap:
                begin
                  GraphicLink:= TEzGraphicLink.Create;
                  try
                    filnam := AddSlash( Ez_Preferences.CommonSubDir ) + txt;
                    If FileExists( filnam ) Then
                      GraphicLink.ReadGeneric( filnam );
                    MyPrintBitmap(GraphicLink.Bitmap);
                  finally
                    GraphicLink.Free;
                  end;
                end;
            end;
          End
          Else If Assigned( FOnDrawCell ) Then
            FOnDrawCell( Self, J, I - 1, Canvas, Grapher, R );
        End;
        if I = 1 then
          Inc( Y, TitleRowHeight - 1 )
        else
          Inc( Y, GridRowHeight - 1 );
      End;

      Inc( X, GridColWidths[J] - 1 );
    End;
  finally
    FreeAndNil(SplitRows);
  end;
End;     *)

procedure TEzTableEntity.Draw(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
Var
  TmpR: TEzRect;
  GridRect, R, Rect, R1: TRect;
  GridLineWidth, OuterLineWidth, OuterLineHeight: Integer;
  BorderWidthPix, BorderHeightPix: Integer;
  GridRowHeight, TitleRowHeight: Integer;
  GridWidth, I, J, K, N, X, Y, TmpHeight, H, H1: Integer;
  GridColWidths: Array[0..1000] Of Integer; // max of 1000 columns
  uFormat: Word;
  txt: String;
  ValInteger: Integer;
  Poly: array[0..4] of TPoint;
  Parts: array[0..0] of Integer;
  BmpRes: HBitmap;
  Bmp: TBitmap;
  ForeColor,BackColor:TColor;
  Resname: string;
  TmpGrapher: TEzGrapher;
  linetype: integer;
  Penwidth: integer;
  ALineColor: TColor;
  Symbol: TEzSymbol;
  dist: double;
  V: TEzVector;
  TmpMarginX: double;
  TmpMarginY: double;
  Rgn: HRgn;
  PenStyle: TEzPenStyle;
  PtArr: Array[0..5] of TPoint;
  Repit: Integer;
  e:TEzRect;
  GraphicLink: TEzGraphicLink;
  filnam: string;
  TheRowHeight:Double;

  procedure BitmapToPrinter(DestRect: TRect;
    ABitmap: TBitmap; L, T, W, H: Integer);
  var
    Info: PBitmapInfo;
    Image: Pointer;
    Tc: Integer;
    InfoSize, ImageSize: DWORD;
  begin
    GetDIBSizes(ABitmap.Handle, InfoSize, ImageSize);
    Info := AllocMem(InfoSize);
    Image := GlobalAllocPtr(HeapAllocFlags, ImageSize);
    try
      with ABitmap do
        GetDIB(Handle, Palette, Info^, Image^);
      Tc := T;
      if Info^.bmiHeader.biHeight > 0 then
        Tc := Info^.bmiHeader.biHeight - H - T;
      with DestRect do
        StretchDIBits(Canvas.Handle, Left, Top, (Right - Left), (Bottom - Top),
          L, Tc, W, H, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
    finally
      if InfoSize < 65535 then
        FreeMem(Info,InfoSize)
      else
        GlobalFreePtr(Info);
      GlobalFreePtr(Image);
    end;
  end;

  procedure MyPrintBitmap(abmp: TBitmap);
  var
    hPaintPal, hOldPal: HPalette;                  {Used for realizing the palette}
  begin
    InflateRect(R,-2,-2);
    hPaintPal:= abmp.Palette;
    hOldPal:= SelectPalette(Canvas.Handle, hPaintPal, False);
    try
      RealizePalette(Canvas.Handle);
      SetStretchBltMode(Canvas.Handle, STRETCH_DELETESCANS);
      if Grapher.Device = adScreen then    // this goes to the screen
      begin
        StretchBlt(Canvas.Handle, R.Left, R.Top,
          (R.Right - R.Left), (R.Bottom - R.Top),
          abmp.Canvas.Handle, 0, 0, abmp.Width, abmp.Height, SRCCOPY);
      end else    // this goes to the printer
      begin
          BitmapToPrinter(R,abmp,0,0,abmp.Width,abmp.Height);
      end;
    finally
      if hOldPal <> 0 then
        SelectPalette(Canvas.Handle, hOldPal, False);
    end;
  end;

var
  SplitRows: TIntegerList;
  TmpInt: Integer;
begin
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D(TmpR);
  GridRect := Grapher.RealToRect(TmpR);
  if (DrawMode in [dmRubberPen, dmSelection]) then
  begin
    DrawAbnormal(Grapher, Canvas, Clip, DrawMode, Data);
    Exit;
  end;
  if (FRowCount < 0) or (Columns.Count < 1) then
  begin
    DrawEmpty(Grapher, Canvas, Clip, GridRect);
    Exit;
  end;

  // Calculate row height (FRowHeight is ignored because it is causing drawing problems )
  if FRowHeight < 1 then
    TheRowHeight := Abs(TmpR.Emax.Y - TmpR.Emin.Y) / Succ(FRowCount)
  else
    TheRowHeight := FRowHeight;

  { calculate parameters }
  OuterLineWidth := Grapher.RealToDistX(PenTool.FPenStyle.Width);
  OuterLineHeight := Grapher.RealToDistY(PenTool.FPenStyle.Width);
  GridLineWidth := Grapher.RealToDistX(FGridStyle.Width);
  GridRowHeight := Grapher.RealToDistY(TheRowHeight);
  TitleRowHeight := Grapher.RealToDistY(FTitleHeight);
  GridWidth := Abs(GridRect.Right - GridRect.Left - OuterLineWidth);
  N := 0;
  for I := 0 to Columns.Count - 2 do
  begin
    GridColWidths[I] := Grapher.RealToDistX(Columns[I].Width);
    Inc(N, GridColWidths[I]);
  end;
  GridColWidths[Pred(Columns.Count)] := EzLib.IMax(0, GridWidth - N);
  { calculate grid cells border width in pixels }
  If FBorderWidth > 0 Then
  Begin
    BorderWidthPix := Grapher.RealToDistX( FBorderWidth );
    BorderHeightPix := Grapher.RealToDistY( FBorderWidth );
  End
  Else
  Begin
    BorderWidthPix := 0;
    BorderHeightPix := 0;
  End;

  SplitRows := TIntegerList.Create;
  try
    For I := 2 To Succ(FRowCount) Do
    begin
      TmpInt := 0;
      H := -1;
      For J := 0 To Pred(Columns.Count) Do
      begin
        txt := Trim(Columns[J].Strings[I - 2]);
        if txt <> '' then
        begin
          Inc(TmpInt);
          if H < 0 then
            H := J;
        end;
      end;
      if (TmpInt < 2) and (H = 0) then
        SplitRows.Add(I);
    end;
    /// draw header
    X := GridRect.Left + (OuterLineWidth Div 2);
    Y := GridRect.Top + (OuterLineHeight Div 2);
    N := Columns.Count;
    For J := 0 To Pred(N) Do
    Begin
      Rect.Left := X;
      Rect.Right := X + GridColWidths[J] - 1;
      Rect.Top := Y;
      Rect.Bottom := Y + GridRowHeight - 1;
      R := Rect;
      R.Bottom := Y + TitleRowHeight - 1;
      If Not FOwnerDraw Or FDefaultDrawing Then
      Begin
        If J = 0 Then
          R.Left := R.Left + BorderWidthPix
        Else
          R.Left := R.Left + ( BorderWidthPix Div 2 );
        R.Top := R.Top + BorderHeightPix;
        R.Right := R.Right - ( BorderWidthPix Div 2 );
        R.Bottom := R.Bottom - ( BorderHeightPix Div 2 );
        With Canvas Do
        Begin
          If Not Columns[J].Title.FTransparent Then
          Begin
            Brush.Style := bsSolid;
            Brush.Color := Columns[J].Title.FColor;
            FillRect( R );
          End;
          Pen.Style:=psSolid;
          Pen.Width := IMax( 1, GridLineWidth );
          Pen.Color := FGridStyle.Color;
          With R Do
          Begin
            if ezgoHorzLine in FOptions then
            begin
              MoveTo( Left, Top );
              LineTo( Right, Top );
            end;
            if ezgoVertLine in FOptions then
            begin
              MoveTo( Left, Top );
              LineTo( Left, Bottom );
            end;
          End;
          Pen.Color := FLoweredColor;
          With R Do
          Begin
            if ezgoHorzLine in FOptions then
            begin
              Moveto( Left, Bottom );
              Lineto( Right, Bottom );
            end;
            if ezgoVertLine in FOptions then
            begin
              Moveto( Right, Bottom );
              Lineto( Right, Top );
            end;
          End;
          InflateRect( R, -Pen.Width, -Pen.Width );
        End;
      End;
      If Not FOwnerDraw Then
      Begin
        With Columns[J].Title Do
        Begin
          TmpHeight := IMax( 1, Abs( Grapher.RealToDistY( FFont.Height ) ) );
          //TmpHeight := IMin( TmpHeight, ( R.Bottom - R.Top ) - 2 );
          With Canvas.Font Do
          Begin
            Name := FFont.Name;
            Style := FFont.Style;
            Height := TmpHeight;
            Color := FFont.Color;
          End;
          Case FAlignment Of
            taLeftJustify: uFormat := DT_LEFT;
            taRightJustify: uFormat := DT_RIGHT;
            taCenter: uFormat := DT_CENTER;
          Else
            uFormat := DT_LEFT;
          End;
        End;
        SetBkMode( Canvas.Handle, TRANSPARENT );
        DrawText( Canvas.Handle, PChar( Columns[J].Title.FCaption ), -1, R,
          uFormat  Or DT_VCENTER Or DT_WORDBREAK{DT_SINGLELINE} );
      End
      Else
        If Assigned( FOnDrawCell ) Then
          FOnDrawCell( Self, J, 0, Canvas, Grapher, R );
      Inc( X, GridColWidths[J] - 1 );
      if J = Pred(N) then
        GridWidth := X - GridRect.Left + (OuterLineWidth Div 2) + 1;
    End;
    { now draw rows }
    Y := GridRect.Top + (OuterLineHeight Div 2) + TitleRowHeight - 1;
    for I := 2 to Succ(RowCount) do
    begin
      X := GridRect.Left + (OuterLineWidth Div 2);
      if SplitRows.IndexOfValue(I) >= 0 then
      begin
        H := GridRowHeight;
        Rect.Left := X;
        Rect.Right := X + GridWidth - 1;
        Rect.Top := Y;
        Rect.Bottom := Y + H - 1;
        R := Rect;
        R.Left := R.Left + BorderWidthPix;
        R.Top := R.Top + ( BorderHeightPix Div 2 );
        R.Right := R.Right - ( BorderWidthPix Div 2 );
        R.Bottom := R.Bottom - ( BorderHeightPix Div 2 );
        uFormat := DT_LEFT;
        With Columns[0] Do
        Begin
          TmpHeight := IMax( 1, Abs( Grapher.RealToDistY( FFont.Height ) ) );
          //TmpHeight := IMin( TmpHeight, ( R.Bottom - R.Top ) - 2 );
          With Canvas.Font Do
          Begin
            Name := FFont.Name;
            Style := FFont.Style;
            Height := TmpHeight;
            Color := FFont.Color;
          End;
        End;
        txt := Columns[0].Strings[I - 2];
        if trim(txt) <> '' then
        begin
          R.Left := R.Left + 10;
          H1 := DrawText( Canvas.Handle, PChar( txt ), -1, R, uFormat Or DT_WORDBREAK or DT_CALCRECT);
          if H1 > H then
          begin
            while H1 > H do
              H := H + GridRowHeight;
          end;
        end;
      end
      else
        H := GridRowHeight;
      ///
      if SplitRows.IndexOfValue(I) >= 0 then
      begin
        Rect.Left := X;
        Rect.Right := X + GridWidth - 1;
        Rect.Top := Y;
        Rect.Bottom := Y + H - 1;
        R := Rect;
        R.Left := R.Left + BorderWidthPix;
        R.Top := R.Top + ( BorderHeightPix Div 2 );
        R.Right := R.Right - ( BorderWidthPix Div 2 );
        R.Bottom := R.Bottom - ( BorderHeightPix Div 2 );
        With Canvas Do
        Begin
          If Not Columns[0].FTransparent Then
          begin
            Brush.Style := bsSolid;
            Brush.Color := Columns[0].FColor;
            FillRect( R );
          end;
          Pen.Style:=psSolid;
          Pen.Width := IMax( 1, GridLineWidth );
          Pen.Color := FGridStyle.Color;
          With R Do
          Begin
            if ezgoHorzLine in FOptions then
            begin
              MoveTo( Left, Top );
              LineTo( Right, Top );
            end;
            if ezgoVertLine in FOptions then
            begin
              MoveTo( Left, Top );
              LineTo( Left, Bottom );
            end;
          End;
          Pen.Color := FLoweredColor;
          With R Do
          Begin
            if ezgoHorzLine in FOptions then
            begin
              Moveto( Left, Bottom );
              Lineto( Right, Bottom );
            end;
            if ezgoVertLine in FOptions then
            begin
              Moveto( Right, Bottom );
              Lineto( Right, Top );
            end;
          End;
          InflateRect( R, -Pen.Width, -Pen.Width );
          /// рисуем текст
          uFormat := DT_LEFT;
          With Columns[0] Do
          Begin
            TmpHeight := IMax( 1, Abs( Grapher.RealToDistY( FFont.Height ) ) );
            //TmpHeight := IMin( TmpHeight, ( R.Bottom - R.Top ) - 2 );
            With Canvas.Font Do
            Begin
              Name := FFont.Name;
              Style := FFont.Style;
              Height := TmpHeight;
              Color := FFont.Color;
            End;
          End;
          txt := Columns[0].Strings[I - 2];
          if trim(txt) <> '' then
          begin
            SetBkMode( Canvas.Handle, TRANSPARENT );
            R.Left := R.Left + 10;
            DrawText( Canvas.Handle, PChar( txt ), -1, R, uFormat Or DT_VCENTER Or DT_WORDBREAK );
            R.Left := R.Left - 10;
          end;
        End;
      end
      else
      begin
        N := Columns.Count;
        for J := 0 to Pred(N) do
        begin
          Rect.Left := X;
          Rect.Right := X + GridColWidths[J] - 1;
          Rect.Top := Y;
          Rect.Bottom := Y + H - 1;
          R := Rect;
          If J = 0 Then
            R.Left := R.Left + BorderWidthPix
          Else
            R.Left := R.Left + ( BorderWidthPix Div 2 );
          R.Top := R.Top + ( BorderHeightPix Div 2 );
          R.Right := R.Right - ( BorderWidthPix Div 2 );
          R.Bottom := R.Bottom - ( BorderHeightPix Div 2 );
          If FDefaultDrawing Then
          Begin
            With Canvas Do
            Begin
              If Not Columns[J].FTransparent Then
              Begin
                Brush.Style := bsSolid;
                Brush.Color := Columns[J].FColor;
                FillRect( R );
              End;
              { dibuja el rectangulo exterior de la celda }
              Pen.Style:=psSolid;
              Pen.Width := IMax( 1, GridLineWidth );
              Pen.Color := FGridStyle.Color;
              With R Do
              Begin
                if ezgoHorzLine in FOptions then
                begin
                  MoveTo( Left, Top );
                  LineTo( Right, Top );
                end;
                if (SplitRows.IndexOfValue(I) < 0) or (J = 0) then
                if ezgoVertLine in FOptions then
                begin
                  MoveTo( Left, Top );
                  LineTo( Left, Bottom );
                end;
              End;
              Pen.Color := FLoweredColor;
              With R Do
              Begin
                if ezgoHorzLine in FOptions then
                begin
                  Moveto( Left, Bottom );
                  Lineto( Right, Bottom );
                end;
                if (SplitRows.IndexOfValue(I) < 0) or (J = Pred(N)) then
                if ezgoVertLine in FOptions then
                begin
                  Moveto( Right, Bottom );
                  Lineto( Right, Top );
                end;
              End;
              InflateRect( R, -Pen.Width, -Pen.Width );
            End;
          End;
          If Not FOwnerDraw Then
          Begin
            uFormat := DT_LEFT;
            If I = 2 Then
            begin
              With Columns[J] Do
              Begin
                TmpHeight := IMax( 1, Abs( Grapher.RealToDistY( FFont.Height ) ) );
                //TmpHeight := IMin( TmpHeight, ( R.Bottom - R.Top ) - 2 );
                With Canvas.Font Do
                Begin
                  Name := FFont.Name;
                  Style := FFont.Style;
                  Height := TmpHeight;
                  Color := FFont.Color;
                End;
              End;
            End;
            Case Columns[J].FAlignment Of
              taLeftJustify: uFormat := DT_LEFT;
              taRightJustify: uFormat := DT_RIGHT;
              taCenter: uFormat := DT_CENTER;
            End;
            txt := Columns[J].Strings[I - 2];
            case Columns[J].ColumnType of
              ctLabel:
                begin
                  if trim(txt) <> '' then
                  begin
                    SetBkMode( Canvas.Handle, TRANSPARENT );
                    DrawText( Canvas.Handle, PChar( txt ), -1, R, uFormat Or DT_VCENTER Or DT_WORDBREAK );
                  end;
                end;
              ctColor:
                begin
                  ValInteger:= StrToIntDef(txt,0);
                  InflateRect( R, -2, -2 );
                  Canvas.Brush.Style:= bsSolid;
                  Canvas.Brush.Color:= ValInteger;
                  with R do
                    Canvas.Rectangle(left, top, right, bottom);
                  Canvas.Brush.Style:= bsClear;
                end;
              ctLineStyle:
                begin
                  ValInteger:= StrToIntDef(txt,0);
                  { DRAW THE LINE TYPE }
                  TmpGrapher:= TEzGrapher.Create(10,Grapher.Device);
                  try
                    EzMiscelCtrls.DrawLinetype(TmpGrapher, Canvas, ValInteger,
                      R, [], clBlack, Columns[J].Color,False, 0, 2, false, true, false );
                  finally
                    TmpGrapher.free;
                  end;
                end;
              ctBrushStyle:
                begin
                  ValInteger:= StrToIntDef(txt,0);

                  InflateRect( R, -2, -2 );

                  EzMiscelCtrls.DrawPattern( Canvas,ValInteger,clBlack,clWhite,
                    Columns[J].Color,R,false, [], false, true, false);

                end;
              ctSymbolStyle:
                begin
                  ValInteger:= StrToIntDef(txt,0);
                  TmpGrapher:= TEzGrapher.Create(10,Grapher.Device);
                  try
                    EzMiscelCtrls.DrawSymbol( TmpGrapher, Canvas, ValInteger,
                      R, [], Columns[J].Color, false, true, false);
                  finally
                    TmpGrapher.free;
                  end;
                end;
              ctBitmap:
                begin
                  GraphicLink:= TEzGraphicLink.Create;
                  try
                    filnam := AddSlash( Ez_Preferences.CommonSubDir ) + txt;
                    If FileExists( filnam ) Then
                      GraphicLink.ReadGeneric( filnam );
                    MyPrintBitmap(GraphicLink.Bitmap);
                  finally
                    GraphicLink.Free;
                  end;
                end;
            end;
          End
          Else If Assigned( FOnDrawCell ) Then
            FOnDrawCell( Self, J, I - 1, Canvas, Grapher, R );
          Inc( X, GridColWidths[J] - 1 );
        end;
      end;
      ///
      Y := Y + H - 1;
    end;
  finally
    FreeAndNil(SplitRows);
  end;
end;

function TEzTableEntity.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
  i: Integer;
  Accum: TEzPoint;
  //TheRowHeight: Double;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      // the move control point
      MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      AddPoint( MovePt.X, MovePt.Y );
    end;
    { add the columns width guides }
    Accum.X:= TmpR.X1;
    Accum.Y:= TmpR.Y2;
    For i := 0 To Columns.Count - 2 Do
    begin
      Accum.X := Accum.X + Columns[i].Width;
      Result.Add(Accum);
    end;
    { add the row height guide (only one) }
    //TheRowHeight:= Abs(TmpR.Emax.Y-TmpR.Emin.Y) / Succ(FRowCount);
    Result.AddPoint( TmpR.X1, TmpR.Y2 - FRowHeight );
  End;
end;

function TEzTableEntity.GetControlPointType(Index: Integer): TEzControlPointType;
begin
  If Index = 8 Then
    Result := cptMove
  Else
    Result := cptNode;
end;

procedure TEzTableEntity.UpdateControlPoint(Index: Integer; const Value: TEzPoint; Grapher: TEzGrapher=Nil);
Var
  TmpR: TEzRect;
  Movept, Temp, Accum: TEzPoint;
  M: TEzMatrix;
  I: Integer;
Begin
  FPoints.DisableEvents := True;
  Try
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    if Index = (9 + Columns.Count-1) then
    begin
      { the row height guide }
      FRowHeight:= TmpR.Y2 - Value.Y;
      if FRowHeight < 0 then FRowHeight:= 0;
    end else if Index > 8 then
    begin
      { the column widht guides }
      Accum.X:= TmpR.X1;
      Accum.Y:= TmpR.Y2;
      For i := 0 To Index - 9 - 1 Do
      begin
        Accum.X := Accum.X + Columns[i].Width;
      end;
      Temp:= Value;
      if Temp.X < Accum.X then Temp.X:= Accum.X;
      Columns[Index - 9].Width:= Temp.X - Accum.X;
    end else
      Case Index Of
        0: // LOWER LEFT
          Begin
            TmpR.Emin := Value;
          End;
        1: // MIDDLE BOTTOM
          Begin
            TmpR.Emin.Y := Value.Y;
          End;
        2: // LOWER RIGHT
          Begin
            TmpR.Emax.X := Value.X;
            TmpR.Emin.Y := Value.Y;
          End;
        3: // MIDDLE RIGHT
          Begin
            TmpR.Emax.X := Value.X;
          End;
        4: // UPPER RIGHT
          Begin
            TmpR.Emax := Value;
          End;
        5: // MIDDLE TOP
          Begin
            TmpR.Emax.Y := Value.Y;
          End;
        6: // UPPER LEFT
          Begin
            TmpR.Emin.X := Value.X;
            TmpR.Emax.Y := Value.Y;
          End;
        7: // MIDDLE LEFT
          Begin
            TmpR.Emin.X := Value.X;
          End;
        8: // MOVE POINT
          Begin
            // calculate current move point
            MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
            MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
            M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
            TmpR.Emin := TransformPoint2d( TmpR.Emin, M );
            TmpR.Emax := TransformPoint2d( TmpR.Emax, M );
          End;
      End;
    FPoints[0] := TmpR.Emin;
    FPoints[1] := TmpR.Emax;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
end;


procedure TEzTableEntity.UpdateExtension;
begin
  inherited UpdateExtension;

end;

{ RichText section }

Type
  TPageInfo = Record
    width, height: Integer; { physical width and height, in dots }
    //offsetX, offsetY: Integer; { nonprintable margin, in dots }
    resX, resY: Integer; { logical resolution, dots per inch }
  End;

Procedure GetPageinfo( Var info: TPageInfo; index: Integer = -1 );
Begin
  If index > -1 Then
    Printer.PrinterIndex := index;
  if PrintersInstalled then
    With Printer Do
    Begin
      info.resX := GetDeviceCaps( handle, LOGPIXELSX );
      info.resY := GetDeviceCaps( handle, LOGPIXELSY );
      info.width := GetDeviceCaps( handle, PHYSICALWIDTH );
      info.height := GetDeviceCaps( handle, PHYSICALHEIGHT );
    End
  else
  begin
    info.resX := Screen.PixelsPerInch;
    info.resY := Screen.PixelsPerInch;
    info.width := Trunc(210 / 25.4 * info.resX);
    info.height := Trunc(297 / 25.4 * info.resX);
  end;
End;

Procedure DotsToTwips( Var value: Integer; dpi: Integer );
Begin
  value := MulDiv( value, 1440, dpi );
End;

Procedure RectToTwips( Var rect: TRect; Const info: TPageInfo );
Begin
  DotsToTwips( rect.left, info.resX );
  DotsToTwips( rect.right, info.resX );
  DotsToTwips( rect.top, info.resY );
  DotsToTwips( rect.bottom, info.resY );
End;

{------------------------------------------------------------------------------}
{                  TEzRtfText                                             }
{------------------------------------------------------------------------------}

Constructor TEzRtfText.CreateEntity( Const P1, P2: TEzPoint; RTFLines: TStrings );
Begin
  Inherited CreateEntity( [P1, P2], False );
  Lines.Assign( RTFLines );
End;

Destructor TEzRtfText.Destroy;
Begin
  FVector.Free;
  If FLines <> Nil Then
    FLines.Free;
  Inherited Destroy;
End;

procedure TEzRtfText.Initialize;
begin
  inherited;
  FVector := TEzVector.Create( 5 );
end;

Function TEzRtfText.GetLines: TStrings;
Begin
  If FLines = Nil Then
    FLines := TStringList.Create;
  Result := FLines;
End;

function TEzRtfText.GetParentControl(Painter: TEzPainterObject;
  var Preview: Boolean; var aBox: TWinControl): TWinControl;
var
  I: Integer;
begin
  Result := nil;
  If Painter = Nil then
    Exit;
  //
  Preview := False;
  aBox := Nil;
  for I := 0 to PainterObject.SourceGis.DrawBoxList.Count-1 do
    if PainterObject.SourceGis.DrawBoxList[I] is TEzPreviewBox then
    begin
      aBox := PainterObject.SourceGis.DrawBoxList[I];
      Preview := True;
      Break;
    end;
  //
  If aBox <> nil Then
    Result := aBox.Parent;
  if not Assigned(Result) then
  begin
    aBox := nil;
    for I := 0 to PainterObject.SourceGis.DrawBoxList.Count-1 do
      if PainterObject.SourceGis.DrawBoxList[I] is TEzBaseDrawBox then
      begin
        aBox := PainterObject.SourceGis.DrawBoxList[I];
        Break;
      end;
    If aBox <> Nil Then
      Result := aBox.Parent;
  end;
end;

Function TEzRtfText.GetEntityID: TEzEntityID;
Begin
  result := idRtfText;
End;

Function TEzRtfText.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
Begin
  Result := TEzVector.Create( 8 );
  TmpR.Emin := FPoints[0];
  TmpR.Emax := FPoints[1];
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    Add( TmpR.Emin ); // LOWER LEFT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emin.Y ); // MIDDLE BOTTOM
    AddPoint( TmpR.Emax.X, TmpR.Emin.Y ); // LOWER RIGHT
    AddPoint( TmpR.Emax.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE RIGHT
    Add( TmpR.Emax ); // UPPER RIGHT
    AddPoint( ( TmpR.Emin.X + TmpR.Emax.X ) / 2, TmpR.Emax.Y ); // MIDDLE TOP
    AddPoint( TmpR.Emin.X, TmpR.Emax.Y ); // UPPER LEFT
    AddPoint( TmpR.Emin.X, ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2 ); // MIDDLE LEFT
    if TransfPts then
    begin
      // the move control point
      MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
      MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
      AddPoint( MovePt.X, MovePt.Y );
    end;
  End;
End;

Function TEzRtfText.GetControlPointType( Index: Integer ): TEzControlPointType;
Begin
  If Index = 8 Then
    Result := cptMove
  Else
    Result := cptNode;
End;

Procedure TEzRtfText.UpdateControlPoint( Index: Integer;
  Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  TmpR: TEzRect;
  Movept: TEzPoint;
  M: TEzMatrix;
Begin
  FPoints.DisableEvents := True;
  Try
    TmpR.Emin := FPoints[0];
    TmpR.Emax := FPoints[1];
    TmpR := ReorderRect2D( TmpR );
    Case Index Of
      0: // LOWER LEFT
        Begin
          TmpR.Emin := Value;
        End;
      1: // MIDDLE BOTTOM
        Begin
          TmpR.Emin.Y := Value.Y;
        End;
      2: // LOWER RIGHT
        Begin
          TmpR.Emax.X := Value.X;
          TmpR.Emin.Y := Value.Y;
        End;
      3: // MIDDLE RIGHT
        Begin
          TmpR.Emax.X := Value.X;
        End;
      4: // UPPER RIGHT
        Begin
          TmpR.Emax := Value;
        End;
      5: // MIDDLE TOP
        Begin
          TmpR.Emax.Y := Value.Y;
        End;
      6: // UPPER LEFT
        Begin
          TmpR.Emin.X := Value.X;
          TmpR.Emax.Y := Value.Y;
        End;
      7: // MIDDLE LEFT
        Begin
          TmpR.Emin.X := Value.X;
        End;
      8: // MOVE POINT
        Begin
          // calculate current move point
          MovePt.X := ( TmpR.Emin.X + TmpR.Emax.X ) / 2;
          MovePt.Y := ( TmpR.Emin.Y + TmpR.Emax.Y ) / 2;
          M := Translate2d( Value.X - MovePt.X, Value.Y - MovePt.Y );
          TmpR.Emin := TransformPoint2d( TmpR.Emin, M );
          TmpR.Emax := TransformPoint2d( TmpR.Emax, M );
        End;
    End;
    FPoints[0] := TmpR.Emin;
    FPoints[1] := TmpR.Emax;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Function TEzRtfText.GetDrawPoints: TEzVector;
Begin
  Result := FVector;
End;

Procedure TEzRtfText.LoadFromStream( Stream: TStream );
Var
  I, n, len: Integer;
  TmpStr: String;
Begin
  Inherited LoadFromStream( stream );
  With stream Do
  Begin
    Lines.Clear;
    read( n, sizeof( n ) );
    For I := 0 To n - 1 Do
    Begin
      read( len, sizeof( len ) );
      TmpStr := '';
      If len > 0 Then
      Begin
        SetLength( TmpStr, len );
        read( TmpStr[1], len );
      End;
      Lines.Add( TmpStr );
    End;
  End;
  FPoints.CanGrow := false;
  UpdateExtension;
  FOriginalSize := StorageSize;
End;

procedure TEzRtfText.LoadLines(RichEdit: TRichEdit; aParent: TWinControl);
var
  MemStream: TMemoryStream;
begin
  if not Assigned(RichEdit) then
    Exit;
  RichEdit.Visible := False;
  RichEdit.Parent := aParent;
  MemStream := TMemoryStream.Create;
  Try
    Lines.SaveToStream(MemStream);
    MemStream.Position := 0;
    RichEdit.Lines.LoadFromStream(MemStream);
  Finally
    FreeAndNil(MemStream);
  End;
end;

Procedure TEzRtfText.SaveToStream( Stream: TStream );
Var
  I, n, len: Integer;
  TmpStr: String;
Begin
  Inherited SaveToStream( Stream );
  With stream Do
  Begin
    n := Lines.Count;
    write( n, sizeof( n ) );
    For I := 0 To n - 1 Do
    Begin
      TmpStr := Lines[I];
      len := Length( TmpStr );
      write( len, sizeof( len ) );
      If len > 0 Then
        write( TmpStr[1], len );
    End;
  End;
  FOriginalSize := StorageSize;
End;

Function TEzRtfText.StorageSize: Integer;
Var
  I, n: Integer;
Begin
  { calculate the length of every line plus the line}
  n := 0;
  For I := 0 To Lines.Count - 1 Do
    Inc( n, sizeof( Integer ) + Length( Lines[I] ) ); // length of line + line
  Inc( n, SizeOf( Integer ) ); // number of lines
  Result := Inherited StorageSize + n;
End;

procedure TEzRtfText.PrintTo(RichEdit: TRichEdit; Canvas: TCanvas; TargetRect: TRect);
var
  Range: TFormatRange;
  info: TPageInfo;
  Pagerect: TRect;
  PrintRect: TRect;
Begin
  GetPageinfo(info);
  //
  Printrect := TargetRect;//Rect(0, 0, RectWidth, RectHeight);
  RectToTwips( Printrect, info );

  Canvas.Brush.Style := bsClear;

  Range.hdc := Printer.Handle;
  Range.hdcTarget := Printer.Handle;

  Pagerect := Rect( 0, 0, info.width, info.height );
  RectToTwips( Pagerect, info );
  Range.rc := PrintRect;
  Range.rcPage := PageRect;
  Range.chrg.cpMin := 0;
  Range.chrg.cpMax := -1;
  Richedit.Perform( EM_FORMATRANGE, 1, LPARAM( @Range ) );
end;

Function TEzRtfText.RenderText(Grapher: TEzGrapher; Metafile: TMetafile;
  aBox: TWinControl; RichEdit: TRichEdit): TRect;
Var
  Range: TFormatRange;
  info: TPageInfo;
  Pagerect: TRect;
  PrintRect: TRect;
  RectWidth, RectHeight: Integer;
  LogX, LogY: Integer;
  DpiX, DpiY: Integer;
  aCanvas: TMetafileCanvas;
  PBox: TEzPreviewBox;
  DBox: TEzBaseDrawBox;
  R: TRect;
  Stop: Boolean;
Begin
  if not Assigned(aBox) then
    Exit;
  if not Assigned(RichEdit) then
    Exit;
  //
  PBox := nil;
  DBox := nil;
  if aBox is TEzPreviewBox then
    PBox := TEzPreviewBox(aBox)
  else
  if aBox is TEzBaseDrawBox then
    DBox := TEzBaseDrawBox(aBox);
  //
  Metafile.Clear;
  if PrintersInstalled then
    aCanvas := TMetafilecanvas.Create(Metafile, Printer.Handle)
  else
    aCanvas := TMetafilecanvas.Create(Metafile, 0);
  try
    GetPageinfo(info);
    if PrintersInstalled then
    begin
      DpiX := GetDeviceCaps(aCanvas.Handle, LOGPIXELSX);
      DpiY := GetDeviceCaps(aCanvas.Handle, LOGPIXELSY)
    end
    else
    begin
      DpiX := Screen.PixelsPerInch;
      DpiY := Screen.PixelsPerInch;
    end;
    //
    Stop := False;
    RectWidth := -1;
    RectHeight := -1;
    if Assigned(PBox) then
    begin
      RectWidth := Round(EzSystem.Units2Inches(PBox.PaperUnits, PBox.PrintablePageWidth) * DpiX);
      RectHeight := Round(EzSystem.Units2Inches(PBox.PaperUnits, PBox.PrintablePageHeight) * DpiY);
    end
    else
    if Assigned(DBox) then
    begin
      if PrintersInstalled then
      begin
        RectWidth := Printer.PageWidth;
        RectHeight := Printer.PageHeight;
      end
      else
        with Grapher.RealToRect(FBox) do
        begin
          RectWidth := (Right - Left) * DpiX;
          RectHeight:= (Bottom - Top) * DpiY;
        end;
    end
    else
      Stop := True;

    if not Stop then
    begin
      Printrect := Grapher.RealToRect(FBox);
      RectToTwips( Printrect, info );

      Metafile.Width := RectWidth;
      Metafile.Height := RectHeight;
      aCanvas.Brush.Style := bsClear;

      if PrintersInstalled then
      begin
        Range.hdc := aCanvas.Handle;
        if PrintersInstalled then
          Range.hdcTarget := Printer.Handle
        else
          Range.hdcTarget := RichEdit.Parent.Handle;

        Pagerect := Rect( 0, 0, info.width, info.height );
        RectToTwips( Pagerect, info );

        Range.rc := PrintRect;
        Range.rc := PageRect;
        Range.rcPage := PageRect;
        Range.chrg.cpMin := 0;
        Range.chrg.cpMax := -1;
        Richedit.Perform( EM_FORMATRANGE, 1, LPARAM( @Range ) );
      end
      else
      begin
        r := Grapher.RealToRect(FBox);
        Metafile.Width := (r.Right - r.Left);
        Metafile.Height := (r.Bottom - r.Top);
        FillChar(Range, SizeOf(TFormatRange), 0);
        Range.hdc := aCanvas.Handle;
        Range.hdcTarget := aCanvas.Handle;
        LogX := GetDeviceCaps(aCanvas.Handle, LOGPIXELSX);
        LogY := GetDeviceCaps(aCanvas.Handle, LOGPIXELSY);
        Range.rc.right := Metafile.Width * 1440 div LogX;
        Range.rc.bottom := Metafile.Height * 1440 div LogY;
        Range.rcPage := Range.rc;
        Range.chrg.cpMax := -1;
        // ensure printer DC is in text map mode
        SendMessage(RichEdit.Handle, EM_FORMATRANGE, 0, 0);    // flush buffer
        SendMessage(RichEdit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
        SendMessage(RichEdit.Handle, EM_FORMATRANGE, 0, 0);  // flush buffer
      end;
    end;
  finally
    FreeAndNil(aCanvas);
  end;
  Result := Rect(0, 0, Metafile.Width, Metafile.Height);
End;


Procedure TEzRtfText.Draw( Grapher: TEzGrapher; aCanvas: TCanvas;
  Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
{$IFDEF USE_RICHEDIT}
Var
  RichEdit: TRichEdit;
  r, r1: TRect;
  Metafile: TMetafile;
  ParentCtrl: TWinControl;
  mfc: TMetafilecanvas;
  K: Double;
{$ENDIF}
var
  IsPreview: Boolean;
  TheBox: TWinControl;
Begin

  If ( Not Ez_Preferences.ShowText ) Or ( Not IsBoxInBox2D( FBox, Clip ) ) Or
    (Lines.Count = 0) Then Exit;

{$IFDEF USE_RICHEDIT}
  If DrawMode In [dmRubberPen, dmSelection] Then
  Begin
{$ENDIF}
    DrawPoints.DrawClosed( aCanvas,
                           Clip,
                           FBox,
                           Grapher,
                           PenTool.FPenStyle,
                           PenTool.Scale,
                           BrushTool.FBrushStyle,
                           self.GetTransformMatrix,
                           DrawMode,
                           Nil );
    Exit;
{$IFDEF USE_RICHEDIT}
  End;
{$ENDIF}

{$IFDEF USE_RICHEDIT}
  If PainterObject = Nil then
    Exit;
  ParentCtrl := GetParentControl(PainterObject, IsPreview, TheBox);
  if not Assigned(ParentCtrl) then
    Exit;
  RichEdit := TRichEdit.Create( Nil );
  Metafile := TMetafile.Create;
  Mfc := nil;
  Try
    LoadLines(RichEdit, ParentCtrl);
    //
    r := Grapher.RealToRect( FBox );
    Richedit.Perform( EM_FORMATRANGE, 0, 0 ); // flush buffer
    if (not IsPreview) and (Grapher.Device = adPrinter) and PrintersInstalled then
      PrintTo(RichEdit, aCanvas, r)
    else
    begin
      r1 := RenderText(Grapher, Metafile, TheBox, RichEdit);
      if IsPreview then
        aCanvas.StretchDraw( r, Metafile )
      else
      begin
        if Grapher.Device = adPrinter then
          aCanvas.Draw(r.Top, r.Left, Metafile)
        else
        begin
          K := Metafile.Height / Metafile.Width;
          r.Bottom := r.Top + Round((r.Right - r.Left) * K);
          aCanvas.StretchDraw(r, Metafile);
        end;
      end;
    end; 
    Richedit.Perform( EM_FORMATRANGE, 0, 0 );
  Finally
    FreeAndNil(mfc);
    FreeAndNil(Metafile);
    FreeAndNil(RichEdit);
  End;

{$ENDIF}
End;

Procedure TEzRtfText.UpdateExtension;
Begin
  Inherited UpdateExtension;
  If FPoints.Count <> 2 Then Exit;
  If FVector = Nil Then
    FVector := TEzVector.Create( 5 )
  Else
    FVector.Clear;
  With FVector Do
  Begin
    Add( FPoints[0] );
    Add( Point2D( FPoints[0].X, FPoints[1].Y ) );
    Add( FPoints[1] );
    Add( Point2D( FPoints[1].X, FPoints[0].Y ) );
    Add( FPoints[0] );
  End;
End;


{ TEzBlockInsert }

constructor TEzBlockInsert.CreateEntity(const BlockName: string;
  const Pt: TEzPoint; const Rotangle, ScaleX, ScaleY: Double);
begin
  Inherited Create( 1, False );
  FBlockName:= BlockName;
  FRotangle:= Rotangle;
  FScaleX:= ScaleX;
  FScaleY:= ScaleY;
  FPoints.Add(Pt);
end;

destructor TEzBlockInsert.Destroy;
begin
  if Not FPreloadedSet and (FBlock <> nil) then FBlock.free;
  inherited Destroy;
end;

Function TEzBlockInsert.BasicInfoAsString: string;
Begin
  Result:= Format(sBlockInfo, [FPoints.AsString,FBlockName,RadToDeg(FRotangle),FScaleX,FScaleY,FText]);
End;

procedure TEzBlockInsert.SetBlockName(const Value: string);
begin
  if Not FPreloadedSet then
  begin
    if FBlock <> nil then FreeAndNil(FBlock);
  end else
    FBlock:= Nil;
  FBlockName:= Value;
  UpdateExtension;
end;

procedure TEzBlockInsert.ApplyTransform;
begin
  BeginUpdate;
  FPoints[0] := TransformPoint2d( FPoints[0], Self.GetTransformMatrix);
  Self.SetTransformMatrix( IDENTITY_MATRIX2D );
  EndUpdate;
end;

function TEzBlockInsert.CalcBoundingBox: TEzRect;
var
  TmpPt: TEzPoint;
  Matrix: TEzMatrix;
begin
  TmpPt:= FPoints[0];
  Matrix:= BuildTransformationMatrix(
    FScaleX, FScaleY, 0,
    -Block.Centroid.X + TmpPt.X, -Block.Centroid.Y + TmpPt.Y, Block.Centroid );
  Result:= TransformBoundingBox2D( Block.Extension, Matrix );

  {Result:= TransformBoundingBox2D( Block.Extension, Scale2d( FScaleX, FScaleY, Block.Centroid ) );
  Result:= TransformBoundingBox2D( Result, Translate2d( -Block.Centroid.X + TmpPt.X, -Block.Centroid.Y + TmpPt.Y ) );}
end;

procedure TEzBlockInsert.Draw(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil);
var
  Matrix: TEzMatrix;
  TmpBox: TEzRect;
  Found: Boolean;
  FoundType: TEzEntityID;
  Ent: TEzEntity;
  I: Integer;
  tmp: string;
begin
  if Block.Count = 0 then Exit;

  Matrix := BuildTransformationMatrix( FScaleX, FScaleY, FRotangle,
    -Block.Centroid.X + FPoints[0].X, -Block.Centroid.Y + FPoints[0].Y, Block.Centroid );
  matrix3x3PreMultiply( self.GetTransformMatrix, Matrix );
  TmpBox := TransformBoundingBox2D( Block.Extension, Matrix );

  If Not IsRectVisible( TmpBox, Clip ) Then Exit;

  { is there some text to replace ? }
  Found := false;
  Ent := Nil;
  FoundType := idNone;
  If Length( FText ) > 0 Then
  Begin
    For I := 0 To Block.Count - 1 Do
    Begin
      Ent := Block.Entities[i];
      If Ent.EntityID = idJustifVectText Then
      Begin
        tmp := TEzJustifVectorText( Ent ).Text;
        TEzJustifVectorText( Ent ).Text := FText;
        Found := true;
        Foundtype := Ent.EntityID;
        Break;
      End Else If Ent.EntityID = idFittedVectText Then
      Begin
        tmp := TEzFittedVectorText( Ent ).Text;
        TEzFittedVectorText( Ent ).Text := fText;
        Found := true;
        Foundtype := Ent.EntityID;
        Break;
      End Else If Ent.EntityID = idTrueTypeText Then
      Begin
        tmp := TEzTrueTypeText( Ent ).Text;
        TEzTrueTypeText( Ent ).Text := fText;
        Found := true;
        Foundtype := Ent.EntityID;
        Break;
      End;
    End;
  End;

  Block.Draw( Grapher, Canvas, Clip, Matrix, DrawMode );

  If Found Then
  Begin
    If FoundType = idJustifVectText Then
      TEzJustifVectorText( Ent ).Text := tmp
    Else If FoundType = idFittedVectText Then
      TEzFittedVectorText( Ent ).Text := tmp
    Else If FoundType = idTrueTypeText Then
      TEzTrueTypeText( Ent ).Text := tmp
  End;

end;

function TEzBlockInsert.GetEntityID: TEzEntityID;
begin
  result:= idBlockInsert;
end;

procedure TEzBlockInsert.LoadFromStream(Stream: TStream);
var
  n: Integer;
begin
  FPoints.DisableEvents := true;
  Inherited LoadFromStream( Stream ); // read ID and points
  FBlockName:= EzReadStrFromStream( Stream );
  with Stream do
  begin
    Read(FRotangle, sizeof(FRotangle));
    Read(FScaleX, sizeof(FScaleX));
    Read(FScaleY, sizeof(FScaleY));
    Read(n,sizeof(n));
    FText:= '';
    if n > 0 then
    begin
      SetLength(FText, n);
      Read(FText[1],n);
    end;
  end;
  if FBlock <> nil then FBlock.Clear;
  FPoints.DisableEvents := false;
  FPoints.CanGrow := false;
  FPoints.OnChange := UpdateExtension;
  FOriginalSize := StorageSize;
  UpdateExtension;
end;

procedure TEzBlockInsert.SaveToStream(Stream: TStream);
var
  n: Integer;
begin
  Inherited SaveToStream( stream ); // save ID and points
  EzWriteStrToStream( FBlockName, Stream );
  with Stream do
  begin
    Write(FRotangle, sizeof(FRotangle));
    Write(FScaleX, sizeof(FScaleX));
    Write(FScaleY, sizeof(FScaleY));
    n:= Length(FText);
    Write(n,sizeof(n));
    if n>0 then Write(FText[1], n);
  end;
  FOriginalSize := StorageSize;
end;

procedure TEzBlockInsert.MoveAndRotateControlPts(var MovePt, RotatePt: TEzPoint; Grapher: TEzGrapher);
Var
  M: TEzMatrix;
  TmpBox: TEzRect;
Begin
  If Not EqualPoint2d(Ez_Preferences.GRotatePoint, INVALID_POINT) Then
  Begin
    MovePt:= Ez_Preferences.GRotatePoint;
  End Else
  Begin
    TmpBox:= ReorderRect2d( CalcBoundingBox() );
    MovePt.X := ( TmpBox.X1 + TmpBox.X2 ) / 2;
    MovePt.Y := ( TmpBox.Y1 + TmpBox.Y2 ) / 2;
  End;
  RotatePt.Y := MovePt.Y;
  If Grapher <> Nil Then
    RotatePt.X:= MovePt.X + Grapher.DistToRealX(Grapher.ScreenDpiX div 2)
  Else
    RotatePt.X := MovePt.X + ( dMax( TmpBox.X1, TmpBox.X2 ) - MovePt.X ) * ( 2 / 3 );
  If FRotangle <> 0 Then
  Begin
    M := Rotate2d( FRotangle, MovePt );
    RotatePt := TransformPoint2d( RotatePt, M );
  End;
end;

function TEzBlockInsert.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  MovePt, RotatePt: TEzPoint;
  V: TEzVector;
Begin
  Result := TEzVector.Create( 10 );
  { 6 (3)           5              4  (2)
    +---------------+---------------+
    |                               |
  7 +                               + 3
    | (4)                           |
    +---------------+---------------+
    0 (0)           1               2 (1)
  }
  V := MakePolyPoints;
  Try
    With Result Do
    Begin
      Add( V[0] ); // LOWER LEFT
      Add( Point2d( ( V[0].X + V[1].X ) / 2, ( V[0].Y + V[1].Y ) / 2 ) ); // MIDDLE BOTTOM
      Add( V[1] ); // LOWER RIGHT
      Add( Point2d( ( V[1].X + V[2].X ) / 2, ( V[1].Y + V[2].Y ) / 2 ) ); // MIDDLE RIGHT
      Add( V[2] ); // UPPER RIGHT
      Add( Point2d( ( V[2].X + V[3].X ) / 2, ( V[2].Y + V[3].Y ) / 2 ) ); // MIDDLE TOP
      Add( V[3] ); // UPPER LEFT
      Add( Point2d( ( V[0].X + V[3].X ) / 2, ( V[0].Y + V[3].Y ) / 2 ) ); // MIDDLE LEFT
      if TransfPts then
      begin
        MoveAndRotateControlPts( MovePt, RotatePt, Grapher );
        Add( MovePt );
        Add( RotatePt );
      end;
    End;
  Finally
    V.Free;
  End;
end;

function TEzBlockInsert.GetControlPointType(Index: Integer): TEzControlPointType;
begin
  Result := cptNode;
  If Index = 8 Then
    Result := cptMove
  Else If Index = 9 Then
    Result := cptRotate;
end;

procedure TEzBlockInsert.UpdateControlPoint(Index: Integer;
  const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  M: TEzMatrix;
  theMovePt, theRotatePt: TEzPoint;
  I: Integer;
  phiStart, phiEnd, CX, CY: Double;
  V: TEzVector;
  Bx, BoxBlock: TEzRect;
Begin
  FPoints.DisableEvents := True;
  V := MakePolyPoints;
  Try
    { 6                5                  4
      +---------------+-------------------+
      |                                   |
    7 +                                   + 3
      |                                   |
      +---------------+-------------------+
      0               1                   2
    }
    Case Index Of
      0: // calculate the point
        Begin
          V[0] := Value;
          V[4] := Value;
          V[3] := Perpend( Value, V[2], V[3] );
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      1:
        Begin
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
          V[1] := Perpend( Value, V[1], V[2] );
        End;
      2:
        Begin
          V[1] := Value;
          V[2] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[3] );
          V[4] := V[0];
        End;
      3:
        Begin
          V[1] := Perpend( Value, V[0], V[1] );
          V[2] := Perpend( Value, V[2], V[3] );
        End;
      4:
        Begin
          V[2] := Value;
          V[1] := Perpend( Value, V[0], V[1] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      5:
        Begin
          V[2] := Perpend( Value, V[1], V[2] );
          V[3] := Perpend( Value, V[0], V[3] );
        End;
      6:
        Begin
          V[3] := Value;
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
          V[2] := Perpend( Value, V[1], V[2] );
        End;
      7:
        Begin
          V[3] := Perpend( Value, V[2], V[3] );
          V[0] := Perpend( Value, V[0], V[1] );
          V[4] := V[0];
        End;
      8: // the move point
        Begin
          // calculate current move point
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          M := Translate2d( Value.X - theMovePt.X, Value.Y - theMovePt.Y );
          For I := 0 To V.Count - 1 Do
            V[I] := TransformPoint2d( V[I], M );
        End;
      9: // the rotate point
        Begin
          MoveAndRotateControlPts( theMovePt, theRotatePt, Grapher );
          phiStart := Angle2D( theRotatePt, theMovePt );
          phiEnd := Angle2d( value, theMovePt );
          M := Rotate2d( phiEnd - phiStart, theMovePt );
          For I := 0 To V.Count - 1 Do
            V[I] := TransformPoint2d( V[I], M );
        End;
    End;
    FRotangle := Angle2d( V[0], V[1] );
    Bx := V.Extension;
    CX := ( Bx.Emin.X + Bx.Emax.X ) / 2;
    CY := ( Bx.Emin.Y + Bx.Emax.Y ) / 2;
    FPoints[0] := Point2d(CX,CY);
    BoxBlock:= Block.Extension;
    FScaleX := Dist2d( V[0], V[1] ) / Abs(BoxBlock.X2 - BoxBlock.X1);
    FScaleY := Dist2d( V[0], V[3] ) / Abs(BoxBlock.Y2 - BoxBlock.Y1);
  Finally
    FPoints.DisableEvents := false;
    V.free;
  End;
end;

Function TEzBlockInsert.MakePolyPoints: TEzVector;
Var
  Cx, Cy: Double;
  M: TEzMatrix;
  I: Integer;
  TmpBox, TmpR: TEzRect;
Begin
  Result := TEzVector.Create( 5 );
  Result.Clear;
  TmpBox:= CalcBoundingBox();
  TmpR.Emin := TmpBox.Emin;
  TmpR.Emax := TmpBox.Emax;
  TmpR := ReorderRect2D( TmpR );
  With Result Do
  Begin
    { 3                2
      +---------------+
      |               |
      |               |
      |               |
    4 +---------------+
      0               1
    }
    Add( TmpR.Emin );
    Add( Point2D( TmpR.Emax.X, TmpR.Emin.Y ) );
    Add( TmpR.Emax );
    Add( Point2D( TmpR.Emin.X, TmpR.Emax.Y ) );
    Add( TmpR.Emin );
  End;
  If FRotangle <> 0 Then
  Begin
    { rotate with respect to the centroid }
    CX := ( TmpBox.X1 + TmpBox.X2 ) / 2;
    CY := ( TmpBox.Y1 + TmpBox.Y2 ) / 2;
    M := Rotate2d( FRotangle, Point2d( CX, CY ) );
    For I := 0 To Result.Count - 1 Do
      Result[I] := TransformPoint2d( Result[I], M );
  End;
End;

function TEzBlockInsert.StorageSize: Integer;
begin
  Result:= inherited StorageSize + Length(FBlockName);
end;

procedure TEzBlockInsert.UpdateExtension;
var
  FileName: string;
  Stream: TStream;
  CX,CY:Double;
  TmpBox: TEzRect;
  M: TEzMatrix;
begin
  If FPoints.Count = 0 Then Exit;
  if Block.Count = 0 then
  begin
    FileName:= ChangeFileExt(AddSlash(Ez_Preferences.CommonSubDir) + FBlockName, '.edb');
    if (Length(FBlockName) = 0) or not FileExists(Filename) then
    begin
      FBox.Emin:= FPoints[0];
      FBox.Emax:= FPoints[0];
      Exit;
    end;
    Stream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      Block.LoadFromStream(Stream)
    finally
      Stream.Free;
    end;
  end;
  TmpBox:= CalcBoundingBox();
  M:= Self.GetTransformMatrix;
  if FRotangle <> 0 then
  begin
    CX:= (TmpBox.X1 + TmpBox.X2) / 2;
    CY:= (TmpBox.Y1 + TmpBox.Y2) / 2;
    matrix3x3PreMultiply( Rotate2d(FRotangle, Point2d(CX, CY)), M );
  end;
  FBox := ReorderRect2D( TransformBoundingBox2D( TmpBox, M ) );
end;

function TEzBlockInsert.Block: TEzSymbol;
var
  Index: Integer;
begin
  if FBlock = nil then
  begin
    FPreloadedSet:= False;
    if Ez_Preferences.UsePreloadedBlocks then
    begin
      Index:= Ez_Preferences.PreloadedBlocks.IndexOf(FBlockName);
      if Index >= 0 then
      begin
        FBlock:= TEzSymbol( Ez_Preferences.PreloadedBlocks.Objects[Index] );
        FPreloadedSet:= true;
      end;
    end;
    if not FPreloadedSet then
      FBlock:= TEzSymbol.Create(Nil);
  end;
  Result:= FBlock;
end;

function TEzBlockInsert.PointCode(const Pt: TEzPoint;
  const Aperture: Double; var Distance: Double;
  SelectPickingInside: Boolean; UseDrawPoints: Boolean=True): Integer;
begin
  Result := PICKED_NONE;
  If IsPointInBox2D( Pt, FBox ) Then
  Begin
    Distance := 0;
    Result := PICKED_INTERIOR;
  End;
end;

procedure TEzBlockInsert.SetRotangle(const Value: Double);
begin
  FRotangle:= Value;
  UpdateExtension;
end;

procedure TEzBlockInsert.SetScaleX(const Value: Double);
begin
  FScaleX:=value;
  UpdateExtension;
end;

procedure TEzBlockInsert.SetScaleY(const Value: Double);
begin
  FScaleY:=value;
  UpdateExtension;
end;

function TEzBlockInsert.IsEqualTo(Entity: TEzEntity;
  IncludeAttribs: Boolean = false): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idBlockInsert ) Or Not FPoints.IsEqualTo( Entity.Points )
  {$IFDEF FALSE}Or
     ( IncludeAttribs And
       ( ( AnsiCompareText(FBlockName, TEzBlockInsert( Entity ).FBlockName) <> 0 ) Or
         ( FRotangle <> TEzBlockInsert( Entity ).FRotangle ) Or
         ( FScaleX <> TEzBlockInsert( Entity ).FScaleX ) Or
         ( FScaleY <> TEzBlockInsert( Entity ).FScaleY ) Or
         ( FText <> TEzBlockInsert( Entity ).FText ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzBlockInsert.GetBlockName: string;
begin
  Result := FBlockName;
end;

function TEzBlockInsert.GetRotangle: Double;
begin
  Result := FRotangle;
end;

function TEzBlockInsert.GetScaleX: Double;
begin
  Result := FScaleX;
end;

function TEzBlockInsert.GetScaleY: Double;
begin
  Result := FScaleY;
end;

function TEzBlockInsert.GetText: string;
begin
  Result := FText;
end;

procedure TEzBlockInsert.SetText(const Value: string);
begin
  FText := Value;
end;
{$ENDIF}

{ TEzSplineText }

constructor TEzSplineText.CreateEntity(TrueType: Boolean; const SplineText: string );
begin
  Inherited Create( 5 );
  if TrueType then
    FontTool.Assign(Ez_Preferences.DefTTFontStyle)
  else
    FontTool.Assign(Ez_Preferences.DefFontStyle);
  FUseTrueType:= TrueType;  { never change to UseTrueType:=truetype because will fires event }
  FText:= SplineText;
  UpdateExtension;
end;

destructor TEzSplineText.Destroy;
begin
  if FFontTool <> Nil then FFonttool.free;
  inherited;
end;

procedure TEzSplineText.Initialize;
begin
  inherited;
  FFitted:= True;
  FCharSpacing := 0.10;
  FShowSpline:= True;
  FFontTool:= TEzFontTool.Create;
end;

Function TEzSplineText.BasicInfoAsString: string;
Begin
  Result:= Format(sSplineTextInfo, [EzBaseExpr.NBoolean[FUseTrueType],FText,FPoints.AsString]);
End;

procedure TEzSplineText.DrawTrueType(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode);
var
  LogRec: TLOGFONT;
  OldFont, NewFont: HFONT;
  Origin: TPoint;
  UseAngle: Double;
  I1,I2, I, nIndex, TmpHeight: Integer;
  EquidistVector: TEzVector;
  EquidistList: TIntegerList;
  WidthList: TEzDoubleList;
  Pt: TEzPoint;
  V: TEzVector;
begin
  if Fonttool.Height < 0 then
     Fonttool.Height := Grapher.PointsToDistY(Trunc(-Fonttool.Height));
  TmpHeight := Abs(Grapher.RealToDistY(Fonttool.Height));
  if TmpHeight <= 2 then Exit;

  if FUsePointsAsPath then V:= FPoints
  else
  begin
    if FCurvePoints=Nil then GetCurvePoints;
    V:= FCurvePoints;
  end;

  if FShowSpline or (DrawMode in [dmRubberPen, dmSelection]) then
  begin
     if DrawMode = dmSelection then Pentool.Style:= 1;
     inherited Draw(Grapher,Canvas,Clip,DrawMode);
     if DrawMode in [dmRubberPen, dmSelection] then Exit;
     //if DrawMode=dmRubberPen then exit;
  end;

  If Not Ez_Preferences.ShowText Then Exit;

  { draw the text }
  Canvas.Font.Name := Fonttool.Name;
  Canvas.Font.Style := Fonttool.Style;
  Canvas.Font.Height := TmpHeight;
  Canvas.Font.Color:= Fonttool.Color;

  GetObject( Canvas.Font.Handle, SizeOf( LogRec ), @LogRec );
  //LogRec.lfEscapement := Round(UseAngle * 10);
  LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  StrPCopy( LogRec.lfFaceName, Fonttool.Name );

  EquidistList:= TIntegerList.Create;
  EquidistVector:= TEzVector.Create( V.Count + Length(FText) );
  WidthList:= Nil;
  if Not FFitted then
    WidthList:= TEzDoubleList.Create;

  try
    if Not FFitted then
    begin
      for I:= 1 to Length(FText) do
      begin
        WidthList.Add( Grapher.DistToRealX(Canvas.TextWidth(FText[I])) * (1.0+FCharSpacing) );
      end;
    end;
    EquidistVector.SplitEquidistant( V, Length(FText), EquidistList, WidthList );
    while EquidistList.Count < Length(FText) do
      EquidistList.Add( EquidistVector.Count - 1 );

    SetBkMode( Canvas.Handle, TRANSPARENT );

    SetTextAlign( Canvas.Handle, TA_LEFT or TA_BASELINE );

    for I:= 1 to Length( FText ) do
    begin
      nIndex:= EquidistList[I-1];
      Pt:= EquidistVector[nIndex];
      if nIndex = EquidistVector.Count-1 then
      begin
        I1:= nIndex-1;
        I2:= nIndex;
      end else
      begin
        I1:= nIndex;
        I2:= nIndex+1;
      end;
      UseAngle := RadToDeg( Angle2D( EquidistVector[I1], EquidistVector[I2] ) );
      LogRec.lfEscapement := Round( UseAngle * 10 );
      newFont := CreateFontIndirect( LogRec );
      oldFont := SelectObject( Canvas.Handle, newFont );
      Origin := Grapher.RealToPoint( TransformPoint2D( EquidistVector[I1], GetTransformMatrix) );
      Canvas.TextOut(Origin.X, Origin.Y, FText[I]);
      newFont := SelectObject( Canvas.Handle, oldFont );
      DeleteObject( newFont );
    end;
  finally
    EquidistVector.free;
    EquidistList.free;
    if Not FFitted then
      WidthList.Free;
  end;
end;

procedure TEzSplineText.DrawVectorial(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode);
Var
  TmpText: TEzFittedVectorText;
  V: TEzVector;
Begin
  if FUsePointsAsPath then V:= FPoints
  else
  begin
    If FCurvePoints = Nil Then GetCurvePoints;
    V:= FCurvePoints;
  end;
  If FShowSpline or (DrawMode In [dmRubberPen, dmSelection]) Then
  Begin
    if DrawMode = dmSelection then Pentool.Style:= 1;
    Inherited Draw( Grapher, Canvas, Clip, DrawMode );
    if DrawMode in [dmRubberPen, dmSelection] then Exit;
    //If DrawMode = dmRubberPen Then exit;
  End;

  If Not Ez_Preferences.ShowText Then Exit;

  TmpText := TEzFittedVectorText.CreateEntity(
                                 V[0],
                                 FText,
                                 Grapher.GetRealsize( Fonttool.Height ),
                                 -1, 0 );
  TmpText.FontName:= Fonttool.Name;
  TmpText.FontColor := Fonttool.Color;
  TmpText.InterCharSpacing := FCharSpacing;
  Try
    TmpText.DrawToPath( V, FFitted, Grapher, Canvas, Clip, DrawMode );
  Finally
    TmpText.Free;
  End;
end;

procedure TEzSplineText.Draw(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil);
begin
  if FUseTrueType then
    DrawTrueType(Grapher, Canvas, Clip, DrawMode)
  else
    DrawVectorial(Grapher, Canvas, Clip, DrawMode);
end;

function TEzSplineText.GetEntityID: TEzEntityID;
begin
  result:= idSplineText;
end;

function TEzSplineText.GetFontTool: TEzFontTool;
begin
  if FFontTool= Nil then
    FFontTool:= TEzFontTool.Create;
  Result:= FFontTool;
end;

{$IFDEF BCB}
function TEzSplineText.GetCharSpacing: Double;
begin
  Result := FCharSpacing;
end;

function TEzSplineText.GetFitted: Boolean;
begin
  Result := FFitted;
end;

function TEzSplineText.GetShowSpline: Boolean;
begin
  Result := FShowSpline;
end;

function TEzSplineText.GetText: String;
begin
  Result := FText;
end;

function TEzSplineText.GetUsePointsAsPath: Boolean;
begin
  Result := FUsePointsAsPath;
end;

function TEzSplineText.GetUseTrueType: Boolean;
begin
  Result := FUseTrueType;
end;

procedure TEzSplineText.SetCharSpacing(const Value: Double);
begin
  FCharSpacing := Value;
end;

procedure TEzSplineText.SetFitted(const Value: Boolean);
begin
  FFitted := Value;
end;

procedure TEzSplineText.SetShowSpline(const Value: Boolean);
begin
  FShowSpline := Value;
end;

procedure TEzSplineText.SetText(const Value: String);
begin
  FText := Value;
end;

procedure TEzSplineText.SetUsePointsAsPath(const Value: Boolean);
begin
  FUsePointsAsPath := Value;
end;
{$ENDIF}

function TEzSplineText.IsEqualTo(Entity: TEzEntity;
  IncludeAttribs: Boolean = false): Boolean;
begin
  Result:= False;
  if Not ( Entity.EntityID = idSplineText ) Or
    ( Inherited IsEqualTo( Entity, IncludeAttribs ) = False )
    {$IFDEF FALSE}Or
    ( IncludeAttribs And ( ( FText <> TEzSplineText(Entity).FText ) Or
                           ( FText <> TEzSplineText(Entity).FText ) Or
                           ( FCharSpacing <> TEzSplineText(Entity).FCharSpacing ) Or
                           ( FUseTrueType <> TEzSplineText(Entity).FUseTrueType ) Or
                            Not CompareMem( @FFontTool.FFontStyle,
                                            @TEzSplineText(Entity).FFontTool.FFontStyle,
                                            SizeOf( TEzFontStyle ) ) ) ){$ENDIF} Then Exit;
  Result:= True;
end;

procedure TEzSplineText.LoadFromStream(Stream: TStream);
Begin
  Inherited LoadFromStream( Stream );
  With Stream Do
  Begin
    FText:= EzReadStrFromStream( stream );
    FontTool.LoadFromStream(Stream);
    Read( FCharSpacing, sizeof( FCharSpacing ) );
    Read( FUseTrueType, sizeof( FUseTrueType ) );
    Read( FFitted, sizeof( FFitted ) );
    Read( FUsePointsAsPath, sizeof( FUsePointsAsPath ) );
    Read( FShowSpline, sizeof( FShowSpline ) );
  End;
  FOriginalSize := StorageSize;
end;

procedure TEzSplineText.SaveToStream(Stream: TStream);
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    EzWriteStrToStream( FText, stream );
    FontTool.SaveToStream(stream);
    Write( FCharSpacing, sizeof( FCharSpacing ) );
    Write( FUseTrueType, sizeof( FUseTrueType ) );
    Write( FFitted, sizeof( FFitted ) );
    Write( FUsePointsAsPath, sizeof( FUsePointsAsPath ) );
    Write( FShowSpline, sizeof( FShowSpline ) );
  End;
  FOriginalSize := StorageSize;
end;

procedure TEzSplineText.SetUseTrueType(const Value: Boolean);
begin
  if Value <> FUseTrueType then
  begin
    if Value then
      FontTool.Name:= EzSystem.DefaultFontName
    else
      FontTool.Name:= Ez_VectorFonts[0].Name;
  end;
  FUseTrueType := Value;
end;

function TEzSplineText.StorageSize: Integer;
begin
  Result := Inherited StorageSize + Length( FText ) + Length( FontTool.Name );
end;

procedure TEzSplineText.UpdateExtension;
begin
  If FPoints = Nil Then Exit;
  fBox := TransformBoundingBox2D( FPoints.Extension, GetTransformMatrix );
end;

function TEzSplineText.PointCode(const Pt: TEzPoint;
  const Aperture: Double; var Distance: Double;
  SelectPickingInside: Boolean; UseDrawPoints: Boolean=True): Integer;
var
  p1s,p2s,p2arc1,p1arc1,p2arc2,p1arc2,p1,p2,pc: TEzPoint;
  RefLength, TmpDistance, Scale: Double;
  Matrix: TEzMatrix;
  polygon: TEzEntity;
  I,TempCode: Integer;
begin
  Result := inherited PointCode(Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints);
  If Result >= PICKED_INTERIOR Then Exit;
  { transform every line segment into a polygon }
  for I:= 0 to FPoints.Count-2 do
  begin
    p1 := FPoints[i];
    p2 := FPoints[i+1];
    { calculate the center of line segment }
    pc := Point2D( ( p1.x + p2.x ) / 2, ( p1.y + p2.y ) / 2 );
    { calculate a reference length for scaling }
    RefLength := Dist2D( pc, p1 );
    TmpDistance:= Fonttool.Height;
    If RefLength = 0 Then RefLength := TmpDistance;
    { now scale the line segment }
    Scale := 1 + TmpDistance / RefLength;
    Matrix := Scale2D( Scale, Scale, pc );
    p1s := TransformPoint2D( p1, Matrix );
    p2s := TransformPoint2D( p2, Matrix );
    { rotate p1s to the right  }
    Matrix := Rotate2D( System.Pi / 2, p1 );
    p2arc1 := TransformPoint2D( p1s, Matrix );
    { rotate p1s to the left  }
    Matrix := Rotate2D( -System.Pi / 2, p1 );
    p1arc1 := TransformPoint2D( p1s, Matrix );

    { now the opposite point }
    { rotate p2s to the right  }
    Matrix := Rotate2D( System.Pi / 2, p2 );
    p2arc2 := TransformPoint2D( p2s, Matrix );
    { rotate p1s to the left  }
    Matrix := Rotate2D( -System.Pi / 2, p2 );
    p1arc2 := TransformPoint2D( p2s, Matrix );

    { create a polygon with these points }
    polygon:= TEzPolygon.CreateEntity([p1arc1,p2arc1,p1arc2,p2arc2,p1arc1]);
    try
      { is inside the polygon ?}
      TempCode:= polygon.PointCode(Pt,Aperture,Distance,true,UseDrawPoints);
      if TempCode >= PICKED_INTERIOR then
      begin
        Result:= TempCode;
        Exit;
      end;
    finally
      polygon.free;
    end;
  end;
end;

procedure TEzTableEntity.DrawAbnormal(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
begin
  inherited Draw(Grapher, Canvas, Clip, DrawMode);
end;

procedure TEzTableEntity.DrawEmpty(Grapher: TEzGrapher; Canvas: TCanvas;
  const Clip: TEzRect; aRect: TRect);
begin
  Canvas.Font.Size := 9;
  Canvas.Font.Color := clBlack;
  Canvas.Font.Style := [];
  DrawText(Canvas.Handle, PChar(SEmptyTable), -1, aRect,
    DT_SINGLELINE or DT_VCENTER or DT_CENTER );
end;

{ TEzRTFText2 }

// необходимо вызывать всегда при изменении текста
// и сразу после создания
procedure TEzRTFText2.CheckSize;
Var
  RichEdit: TRichEdit;
  R, Rprint, Rpage, RpageTwips, RprintTwips: TRect;
  Metafile: TMetafile;
  MfCanvas: TMetafileCanvas;
  HasPrinter: Boolean;
  DpiX, DpiY, OffsetX, OffsetY: Integer;
  Range: TFormatRange;
  DY: Double;
  W, H: Integer;
  I, aBottom: Integer;
  P1, P2: TEzPoint;
  Bmp: TBitmap;
  Row: pRGBTripleArray;
  J: Integer;
  OldMMHeight: Double;
Begin
  If (Not Ez_Preferences.ShowText) Or (Lines.Count = 0) then
    Exit;
{$IFDEF USE_RICHEDIT}
  if not Assigned(aParent) then
    Exit;
  //
  aBottom := -1;
  HasPrinter := PrintersInstalled;
  RichEdit := TRichEdit.Create(Nil);
  Metafile := TMetafile.Create;
  try
    if HasPrinter then
      MfCanvas := TMetafileCanvas.Create(Metafile, Printer.Handle)
    else
      MfCanvas := TMetafileCanvas.Create(Metafile, 0);
    try
      LoadLines(RichEdit, aParent);
      R := Grapher.RealToRect(FBox);
      //
      Richedit.Perform( EM_FORMATRANGE, 0, 0 ); // flush buffer
      if HasPrinter then
      begin
        DpiX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
        DpiY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
        W := Round(FMMWidth * DpiX / 25.4);
        H := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
        OffsetX := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
        OffsetY := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);
      end
      else
      begin
        DpiX := Max(300, Screen.PixelsPerInch);
        DpiY := Max(300, Screen.PixelsPerInch);
        W := Round(FMMWidth * DpiX / 25.4);
        H := Round(Screen.Height * DpiY / Screen.PixelsPerInch);
        OffsetX := Round(5 * DpiX / 25.4);
        OffsetY := Round(5 * DpiY / 25.4);
      end;
      //
      Rpage := Rect(0, 0, W, H);
      Rprint := Rect(OffsetX, OffsetY, W - OffsetX, H - OffsetY);
      //
      RpageTwips := Rpage;
      DotsToTwips(RpageTwips.Left, DpiX);
      DotsToTwips(RpageTwips.Right, DpiX);
      DotsToTwips(RpageTwips.Top, DpiY);
      DotsToTwips(RpageTwips.Bottom, DpiY);
      //
      RprintTwips := Rprint;
      DotsToTwips(RprintTwips.Left, DpiX);
      DotsToTwips(RprintTwips.Right, DpiX);
      DotsToTwips(RprintTwips.Top, DpiY);
      DotsToTwips(RprintTwips.Bottom, DpiY);

      MfCanvas.Brush.Style := bsClear;

      Range.hdc := MfCanvas.Handle;
      Range.hdcTarget := MfCanvas.Handle;

      Range.rc := RprintTwips;
      Range.rcPage := RpageTwips;
      Range.chrg.cpMin := 0;
      Range.chrg.cpMax := -1;
      Richedit.Perform( EM_FORMATRANGE, 1, LPARAM( @Range ) );
    finally
      FreeAndNil(MfCanvas);
    end;
    Richedit.Perform( EM_FORMATRANGE, 0, 0 );
    //
    Bmp := TBitmap.Create;
    try
      Bmp.PixelFormat := pf24bit;
      Bmp.Width := Round(Metafile.Width / 10);
      Bmp.Height := Round(Metafile.Height / 10);
      Bmp.Canvas.Brush.Color := clBlack;
      Bmp.Canvas.Brush.Style := bsSolid;
      Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
      Bmp.Canvas.Brush.Style := bsClear;
      Bmp.Canvas.StretchDraw(Rect(0, 0, Bmp.Width, Bmp.Height), Metafile);
      for I := Bmp.Height - 1 downto 1 do
      begin
        Row := Bmp.ScanLine[I];
        for J := Bmp.Width - 1 downto 0 do
        begin
          with Row[J] do
            if (rgbtBlue = 255) and (rgbtGreen = 255) and (rgbtRed = 255) then
            begin
              aBottom := I;
              Break;
            end;
        end;
        //
        if aBottom > 0 then
          Break;
      end;
      //
{      for I := 0 to Bmp.Height - 1 do
      begin
        Row := Bmp.ScanLine[I];
        for J := Bmp.Width - 1 downto 0 do
        begin
          with Row[J] do
            if (rgbtBlue = 255) and (rgbtGreen = 255) and (rgbtRed = 255) then
            begin
              aTop := I;
              Break;
            end;
        end;
        //
        if aTop > 0 then
          Break;
      end;
      //
      for I := 0 to Bmp.Height - 1 do
      begin
        Row := Bmp.ScanLine[I];
        for J := Bmp.Width - 1 downto 0 do
        begin
          with Row[J] do
            if (rgbtBlue = 255) and (rgbtGreen = 255) and (rgbtRed = 255) then
            begin
              aRight := I;
              Break;
            end;
        end;
        //
        if aRight > 0 then
          Break;
      end;
      //
      for I := 0 to Bmp.Height - 1 do
      begin
        Row := Bmp.ScanLine[I];
        for J := 0 to Bmp.Width - 1 do
        begin
          with Row[J] do
            if (rgbtBlue = 255) and (rgbtGreen = 255) and (rgbtRed = 255) then
            begin
              aLeft := I;
              Break;
            end;
        end;
        //
        if aLeft > 0 then
          Break;
      end;        }
      // считаем размер
      UpdateExtension;
      P1 := Points[0];
      P2 := Points[1];
      if aBottom > 0 then
      begin
        Dy := (aBottom + Round(2 * OffsetY / 10)) / (Bmp.Height - 1);
        OldMMHeight := FMMHeight;
        FMMHeight := Metafile.MMHeight / 100 * Dy;
        P2.y := P1.y - (P1.y - P2.y) * FMMHeight / OldMMHeight;
      end;
      if not EqualPoint2D(P2, Points[1]) then
      begin
        Points[1] := P2;
        UpdateExtension;
      end;
    finally
      FreeAndNil(Bmp);
    end;
  Finally
    FreeAndNil(Metafile);
    FreeAndNil(RichEdit);
  End;
{$ENDIF}
end;

constructor TEzRTFText2.CreateEntity(const P1, P2: TEzPoint; RTFLines: TStrings;
  TheMMWidth, TheMMHeight: Double);
begin
  inherited CreateEntity(P1, P2, RTFLines);
  FMMWIdth := TheMMWidth;
  FMMHeight := TheMMHeight;
end;

procedure TEzRTFText2.Draw(Grapher: TEzGrapher; aCanvas: TCanvas;
  const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer);
Var
  RichEdit: TRichEdit;
  R, Rnew, Rprint, Rpage, RpageTwips, RprintTwips: TRect;
  Metafile: TMetafile;
  ParentCtrl: TWinControl;
  IsPreview: Boolean;
  TheBox: TWinControl;
  MfCanvas: TMetafileCanvas;
  HasPrinter: Boolean;
  DpiX, DpiY, OffsetX, OffsetY: Integer;
  Range: TFormatRange;
  DX, DY: Double;
  W, H: Integer;
Begin
  If ( Not Ez_Preferences.ShowText ) Or ( Not IsBoxInBox2D( FBox, Clip ) ) Or
    (Lines.Count = 0)
  Then
    Exit;
{$IFDEF USE_RICHEDIT}
  If DrawMode In [dmRubberPen, dmSelection] Then
  Begin
{$ENDIF}
    inherited;
    Exit;
{$IFDEF USE_RICHEDIT}
  End;
{$ENDIF}

{$IFDEF USE_RICHEDIT}
  if PainterObject = nil then
    Exit;
  ParentCtrl := GetParentControl(PainterObject, IsPreview, TheBox);
  if not Assigned(ParentCtrl) then
    Exit;
  //
  HasPrinter := PrintersInstalled;
  RichEdit := TRichEdit.Create(Nil);
  Metafile := TMetafile.Create;
  try
    if HasPrinter then
      MfCanvas := TMetafileCanvas.Create(Metafile, Printer.Handle)
    else
      MfCanvas := TMetafileCanvas.Create(Metafile, 0);
    try
      LoadLines(RichEdit, ParentCtrl);
      R := Grapher.RealToRect(FBox);
      //
      Richedit.Perform( EM_FORMATRANGE, 0, 0 ); // flush buffer
      W := Round(FMMWidth * 100);
      H := Round(FMMHeight * 100);
      if HasPrinter then
      begin
        DpiX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
        DpiY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
        OffsetX := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
        OffsetY := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);
      end
      else
      begin
        DpiX := 300;
        DpiY := 300;
        OffsetX := Round(5 * DpiX / 25.4);
        OffsetY := Round(5 * DpiY / 25.4);
      end;
      //
      W := Round(FMMWidth * DpiX / 25.4);
      H := Round(FMMHeight * DpiY / 25.4);
      Rpage := Rect(0, 0, W, H);
      Rprint := Rect(OffsetX, OffsetY, W - OffsetX, H - OffsetY);
      //
      RpageTwips := Rpage;
      DotsToTwips(RpageTwips.Left, DpiX);
      DotsToTwips(RpageTwips.Right, DpiX);
      DotsToTwips(RpageTwips.Top, DpiY);
      DotsToTwips(RpageTwips.Bottom, DpiY);
      //
      RprintTwips := Rprint;
      DotsToTwips(RprintTwips.Left, DpiX);
      DotsToTwips(RprintTwips.Right, DpiX);
      DotsToTwips(RprintTwips.Top, DpiY);
      DotsToTwips(RprintTwips.Bottom, DpiY);

      MfCanvas.Brush.Style := bsClear;

      Range.hdc := MfCanvas.Handle;
      Range.hdcTarget := MfCanvas.Handle;

      Range.rc := RprintTwips;
      Range.rcPage := RpageTwips;
      Range.chrg.cpMin := 0;
      Range.chrg.cpMax := -1;
      Richedit.Perform( EM_FORMATRANGE, 1, LPARAM( @Range ) );
    finally
      FreeAndNil(MfCanvas);
    end;
    Richedit.Perform( EM_FORMATRANGE, 0, 0 );
    //
    // считаем размер R и метафайла
    // получаем новый R
    Dx := Metafile.Width / W;
    Dy := Metafile.Height / H;
    Rnew := R;
    Rnew.Right := R.Left + Round((R.Right - R.Left) * Dx);
    Rnew.Bottom := R.Top + Round((R.Bottom - R.Top) * Dy);
    //
    aCanvas.StretchDraw(Rnew, Metafile);
  Finally
    FreeAndNil(Metafile);
    FreeAndNil(RichEdit);
  End;

{$ENDIF}
end;

function TEzRTFText2.GetEntityID: TEzEntityID;
begin
  Result := idRtfText2;
end;

procedure TEzRTFText2.LoadFromStream(Stream: TStream);
begin
  inherited;
  Stream.Read(FMMWidth, SizeOf(FMMWidth));
  Stream.Read(FMMHeight, SizeOf(FMMHeight));
end;

procedure TEzRTFText2.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FMMWidth, SizeOf(FMMWidth));
  Stream.Write(FMMHeight, SizeOf(FMMHeight));
end;

function TEzRTFText2.StorageSize: Integer;
Begin
  Result := Inherited StorageSize;
  Result := Result + SizeOf(FMMWidth);
  Result := Result + SizeOf(FMMHeight);
end;

procedure TEzRTFText2.UpdateExtension;
begin
  Inherited UpdateExtension;
end;

End.
