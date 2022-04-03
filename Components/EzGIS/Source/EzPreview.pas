unit EzPreview;

{$I EZ_FLAG.PAS}
interface

Uses
  SysUtils, Classes, Windows, StdCtrls, Controls, Graphics, Printers, ExtCtrls,
  EzBaseExpr, EzLib, EzSystem, EzBase, EzRtree, EzBaseGIS, EzEntities, ezimpl,
  Forms;

Type

  { TEzGISItem }
  TEzGISItem = Class( TCollectionItem )
  Private
    FGIS: TEzBaseGIS;
  Protected
    Function GetDisplayName: String; Override;
    Function GetCaption: String;
  Public
    Procedure Assign( Source: TPersistent ); Override;
  Published
    Property GIS: TEzBaseGIS Read FGIS Write FGIS;
  End;

  { TEzGISList }
  TEzGISList = Class( TOwnedCollection )
  Private
    Function GetItem( Index: Integer ): TEzGISItem;
    Procedure SetItem( Index: Integer; Value: TEzGISItem );
  Public
    Constructor Create( AOwner: TPersistent );
    Function Add: TEzGISItem;
    Property Items[Index: Integer]: TEzGISItem Read GetItem Write SetItem; Default;
  End;

  TEzPaperSize = ( psPrinter,
                   psLetter,
                   psLegal,
                   psLedger,
                   psStatement,
                   psExecutive,
                   psA3,
                   psA4,
                   psA5,
                   psB3,
                   psB4,
                   psB5,
                   psFolio,
                   psQuarto,
                   ps10x14,
                   ps11x17,
                   psCsize,
                   psUSStdFanfold,
                   psGermanStdFanfold,
                   psGermanLegalFanfold,
                   ps6x8,
                   psFoolscap,
                   psLetterPlus,
                   psA4Plus,
                   psCustom );


  {----------------------------------------------------------------------------}
  {                  The preview viewport                                      }
  {----------------------------------------------------------------------------}

  TEzPreviewBox = Class( TEzBaseDrawBox )
  Private
    FGISList: TEzGISList;
    FPaperSize: TEzPaperSize;
    FPaperPen: TPen;
    FPaperBrush: TBrush;
    FShadowPen: TPen;
    FShadowBrush: TBrush;
    FShowShadow: Boolean;
    FOrientation: TPrinterOrientation;
    FPrinterPaperWidth: Double;
    FPrinterPaperHeight: Double;
    FCustomPaperWidth: Double;
    FCustomPaperHeight: Double;
    FShowPrinterMargins: Boolean;
    FPrinterMarginLeft: Double;
    FPrinterMarginRight: Double;
    FPrinterMarginTop: Double;
    FPrinterMarginBottom: Double;
    FPaperUnits: TEzScaleUnits;
    FPaperShp: TEzRectangle;
    FShadowShp: TEzRectangle;
    FMarginLeftShp: TEzPolyLine;
    FMarginRightShp: TEzPolyLine;
    FMarginTopShp: TEzPolyLine;
    FMarginBottomShp: TEzPolyLine;
    FPrintMode: TEzPrintMode;
    Procedure DestroyShapes;
    Function GetPrintablePageWidth: Double;
    Function GetPrintablePageHeight: Double;
    Function GetMarginLeft: Double;
    Function GetMarginTop: Double;
    Function GetMarginBottom: Double;
    Function GetMarginRight: Double;
    Function GetPaperWidth: Double;
    Function GetPaperHeight: Double;
    Procedure SetPaperHeight( Const Value: Double );
    Procedure SetPaperSize( Const Value: TEzPaperSize );
    Procedure SetPaperWidth( Const Value: Double );
    Procedure SetShowShadow( Value: Boolean );
    Procedure CreatePaperShapes;
    Procedure SetPaperPen( Value: TPen );
    Procedure SetPaperBrush( Value: TBrush );
    Procedure SetShadowPen( Value: TPen );
    Procedure SetShadowBrush( Value: TBrush );
    Procedure SetPaperShapeAttributes;
    Procedure SetOrientation( Value: TPrinterOrientation );
    Procedure SetGISList( Value: TEzGISList );
{$IFDEF BCB}
    Function GetGISList: TEzGISList;
    Function GetPaperSize: TEzPaperSize;
    Function GetOrientation: TPrinterOrientation;
    Function GetShowPrinterMargins: Boolean;
    Procedure SetShowPrinterMargins(Value: Boolean);
    Function GetPaperUnits: TEzScaleUnits;
    Procedure SetPaperUnits(Value: TEzScaleUnits);
    Function GetPrintMode: TEzPrintMode;
    Procedure SetPrintMode(Value: TEzPrintMode);
    Function GetPaperPen: TPen;
    Function GetPaperBrush: TBrush;
    Function GetShadowPen: TPen;
    Function GetShadowBrush: TBrush;
    Function GetShowShadow: Boolean;
    function GetMarginBottomShp: TEzPolyLine;
    function GetMarginLeftShp: TEzPolyLine;
    function GetMarginRightShp: TEzPolyLine;
    function GetMarginTopShp: TEzPolyLine;
    function GetPaperShp: TEzRectangle;
    function GetShadowShp: TEzRectangle;
{$ENDIF}
  Protected
    Procedure Loaded; Override;
    Procedure UpdateViewport( WCRect: TEzRect ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ZoomToPaper;
    procedure ZoomToFit;
    Procedure Print(const ReportName: String = '');
    Procedure ConfigurePaperShapes;
    Procedure CreateNewEditor;
    Procedure PopulateFrom( Symbol: TEzSymbol );
    Procedure PopulateTo( Symbol: TEzSymbol );
    function AddMap( Index: Integer;
                      Const OutX, OutY, WidthOut, HeightOut,
                      PlottedUnits, DrawingUnits, CoordX, CoordY: Double;
                      IsAtCenter: Boolean;
                      PrintFrame: Boolean = False ): Integer;
    function CurrentScale: Double;

    Property PrintablePageWidth: Double Read GetPrintablePageWidth;
    Property PrintablePageHeight: Double Read GetPrintablePageHeight;
    Property PaperShp: TEzRectangle {$IFDEF BCB} Read GetPaperShp {$ELSE} Read FPaperShp {$ENDIF};
    Property ShadowShp: TEzRectangle {$IFDEF BCB} Read GetShadowShp {$ELSE} Read FShadowShp {$ENDIF};
    Property MarginLeftShp: TEzPolyLine {$IFDEF BCB} Read GetMarginLeftShp {$ELSE}Read FMarginLeftShp {$ENDIF};
    Property MarginRightShp: TEzPolyLine {$IFDEF BCB} Read GetMarginRightShp {$ELSE} Read FMarginRightShp {$ENDIF};
    Property MarginTopShp: TEzPolyLine {$IFDEF BCB} Read GetMarginTopShp {$ELSE} Read FMarginTopShp {$ENDIF};
    Property MarginBottomShp: TEzPolyLine {$IFDEF BCB} Read GetMarginBottomShp {$ELSE} Read FMarginBottomShp {$ENDIF};
    Property MarginLeft: Double Read GetMarginLeft;
    Property MarginTop: Double Read GetMarginTop;
    Property MarginRight: Double Read GetMarginRight;
    Property MarginBottom: Double Read GetMarginBottom;
    Property NoPickFilter;
  Published
    Property GISList: TEzGISList Read {$IFDEF BCB}GetGISList{$ELSE}FGISList{$ENDIF} Write SetGISList;
    Property PaperSize: TEzPaperSize Read {$IFDEF BCB}GetPaperSize{$ELSE}FPaperSize{$ENDIF} Write SetPaperSize;
    Property PaperWidth: Double Read GetPaperWidth Write SetPaperWidth;
    Property PaperHeight: Double Read GetPaperHeight Write SetPaperHeight;
    Property Orientation: TPrinterOrientation Read {$IFDEF BCB}GetOrientation{$ELSE}FOrientation{$ENDIF} Write SetOrientation;
    Property ShowPrinterMargins: Boolean Read {$IFDEF BCB}GetShowPrinterMargins{$ELSE}FShowPrinterMargins{$ENDIF} Write {$IFDEF BCB}SetShowPrinterMargins{$ELSE}FShowPrinterMargins{$ENDIF};
    Property PaperUnits: TEzScaleUnits Read {$IFDEF BCB}GetPaperUnits{$ELSE}FPaperUnits{$ENDIF} Write {$IFDEF BCB}SetPaperUnits{$ELSE}FPaperUnits{$ENDIF};
    Property PrintMode: TEzPrintMode Read {$IFDEF BCB}GetPrintMode{$ELSE}FPrintMode{$ENDIF} Write {$IFDEF BCB}SetPrintMode{$ELSE}FPrintMode{$ENDIF};
    Property PaperPen: TPen Read {$IFDEF BCB}GetPaperPen{$ELSE}FPaperPen{$ENDIF} Write SetPaperPen;
    Property PaperBrush: TBrush Read {$IFDEF BCB}GetPaperBrush{$ELSE}FPaperBrush{$ENDIF} Write SetPaperBrush;
    Property ShadowPen: TPen Read {$IFDEF BCB}GetShadowPen{$ELSE}FShadowPen{$ENDIF} Write SetShadowPen;
    Property ShadowBrush: TBrush Read {$IFDEF BCB}GetShadowBrush{$ELSE}FShadowBrush{$ENDIF} Write SetShadowBrush;
    Property ShowShadow: Boolean Read {$IFDEF BCB}GetShowShadow{$ELSE}FShowShadow{$ENDIF} Write SetShowShadow Default True;

    { inherited properties }
    Property NumDecimals;
    Property DelayShowHint;
    Property PartialSelect;
    Property StackedSelect;
    Property SnapToGuidelines;
    Property SnapToGuidelinesDist;
    Property ScreenGrid;
    Property GridInfo;
    Property RubberPen;
    Property ScrollBars;
    Property FlatScrollBar;

    { events to be published in descendants }
    Property OnGridError;
    Property OnHScroll;
    Property OnVScroll;
    Property OnHChange;
    Property OnVChange;

    Property OnBeginRepaint;
    Property OnEndRepaint;
    Property OnMouseMove2D;
    Property OnMouseDown2D;
    Property OnMouseUp2D;

    Property OnPaint;

    { drawbox specific events }
    Property OnEntityDblClick;
    Property OnBeforeInsert;
    Property OnAfterInsert;
    Property OnBeforeSelect;
    Property OnAfterSelect;
    Property OnAfterUnSelect;
    Property OnZoomChange;
    Property OnEntityChanged;
    Property OnShowHint;
    Property OnSelectionChanged;
  End;

  {-------------------------------------------------------------------------------}
  //                  Mosaic view BOX
  {-------------------------------------------------------------------------------}

  TEzPageAdvance = ( padvNone, padvLeft, padvRight, padvUp, padvDown );

  TEzMosaicView = Class( TEzBaseDrawBox )
  Private
    FParentView: TEzPreviewBox;
    FInnerColor: TColor;
    FOuterColor: TColor;
    FShowInverted: Boolean;
    FPrintedInnerColor: TColor;
    FPrintedOuterColor: TColor;
    FX1List: TEzDoubleList;
    FY1List: TEzDoubleList;
    FX2List: TEzDoubleList;
    FY2List: TEzDoubleList;
    FSavedDrawLimit: Integer;
    Procedure SetParentView( Const Value: TEzPreviewBox );
    Function FindGis: TEzBaseGis;
{$IFDEF BCB}
    Function GetX1List: TEzDoubleList;
    Function GetY1List: TEzDoubleList;
    Function GetX2List: TEzDoubleList;
    Function GetY2List: TEzDoubleList;
    Function GetShowInverted: boolean;
    procedure SetShowInverted(Value: boolean);
    Function GetPrintedInnerColor: TColor;
    procedure SetPrintedInnerColor(Value: TColor);
    Function GetPrintedOuterColor: TColor;
    procedure SetPrintedOuterColor(Value: TColor);
    Function GetInnerColor: TColor;
    procedure SetInnerColor(Value: TColor);
    Function GetOuterColor: TColor;
    procedure SetOuterColor(Value: TColor);
    Function GetParentView: TEzPreviewBox;
{$ENDIF}
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    Procedure UpdateViewport( WCRect: TEzRect ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;

    Procedure BeginRepaint; Override;
    Procedure EndRepaint; Override;
    Function GetPreviewEntity(var Layer: TEzBaseLayer; var Recno: Integer) : TEzEntity;
    Function CurrentPrintArea(Ent: TEzEntity; Advance: TEzPageAdvance): TEzRect;
    Procedure GoAdvance( Advance: TEzPageAdvance );
    procedure AddCurrentToPrintList;
    procedure ClearPrintList;

    Property X1List: TEzDoubleList read {$IFDEF BCB}GetX1List{$ELSE}FX1List{$ENDIF};
    Property Y1List: TEzDoubleList read {$IFDEF BCB}GetY1List{$ELSE}FY1List{$ENDIF};
    Property X2List: TEzDoubleList read {$IFDEF BCB}GetX2List{$ELSE}FX2List{$ENDIF};
    Property Y2List: TEzDoubleList read {$IFDEF BCB}GetY2List{$ELSE}FY2List{$ENDIF};
  Published
    Property ShowInverted: Boolean {$IFDEF BCB}Read GetShowInverted Write SetShowInverted{$ELSE}Read FShowInverted Write FShowInverted{$ENDIF};
    Property PrintedInnerColor: TColor Read {$IFDEF BCB}GetPrintedInnerColor Write SetPrintedInnerColor{$ELSE}FPrintedInnerColor Write FPrintedInnerColor{$ENDIF} default clRed;
    Property PrintedOuterColor: TColor Read {$IFDEF BCB}GetPrintedOuterColor Write SetPrintedOuterColor{$ELSE}FPrintedOuterColor Write FPrintedOuterColor{$ENDIF} default clBlack;
    Property InnerColor: TColor Read {$IFDEF BCB}GetInnerColor Write SetInnerColor{$ELSE}FInnerColor Write FInnerColor{$ENDIF} default clGreen;
    Property OuterColor: TColor Read {$IFDEF BCB}GetOuterColor Write SetOuterColor{$ELSE}FOuterColor Write FOuterColor{$ENDIF} default clBlack;
    Property ParentView: TEzPreviewBox Read {$IFDEF BCB}GetParentView{$ELSE}FParentView{$ENDIF} Write SetParentView;

    { inherited }
    //Property ScreenScaleBar;
    Property ShowMapExtents;
    Property ShowLayerExtents;

    { inherited }

    Property OnBeginRepaint;
    Property OnEndRepaint;
    Property OnMouseMove2D;
    Property OnMouseDown2D;
    Property OnMouseUp2D;

    Property OnPaint;

    { drawbox specific events }
    Property OnZoomChange;

  End;


  { TEzHRuler }
  TEzHRuler = Class( TPaintBox )
  Private
    FPreviewBox: TEzPreviewBox;
    FLastMousePosInRuler: TPoint;
    FRubberPenColor: TColor;
    FMarksColor: TColor;
    FBoxOnPaint: TNotifyEvent;
    FBoxOnMouseMove: TMouseMoveEvent;
    Procedure SetPreviewBox( Value: TEzPreviewBox );
    Procedure DrawRulerPosition( p: TPoint; AMode: TPenMode );
    Procedure SetRubberPenColor( Const Value: TColor );
    Procedure SetMarksColor( Const Value: TColor );
    Procedure MyOnPaint( Sender: TObject );
    Procedure MyOnMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer );
  {$IFDEF BCB} (*_*)
    function GetMarksColor: TColor;
    function GetPreviewBox: TEzPreviewBox;
    function GetRubberPenColor: TColor;
  {$ENDIF}
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    Procedure Paint; Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
  Published
    Property PreviewBox: TEzPreviewBox
      read {$IFDEF BCB} GetPreviewBox {$ELSE} FPreviewBox {$ENDIF}
      write SetPreviewBox; (*_*)
    Property RubberPenColor: TColor
      read {$IFDEF BCB} GetRubberPenColor {$ELSE} FRubberPenColor {$ENDIF}
      write SetRubberPenColor; (*_*)
    Property MarksColor: TColor
      read {$IFDEF BCB} GetMarksColor {$ELSE} FMarksColor {$ENDIF}
      write SetMarksColor; (*_*)
  End;

  { TEzVRuler }
  TEzVRuler = Class( TPaintBox )
  Private
    FPreviewBox: TEzPreviewBox;
    FLastMousePosInRuler: TPoint;
    FRubberPenColor: TColor;
    FMarksColor: TColor;
    FBoxOnPaint: TNotifyEvent;
    FBoxOnMouseMove: TMouseMoveEvent;
    Procedure SetPreviewBox( Value: TEzPreviewBox );
    Procedure DrawRulerPosition( p: TPoint; AMode: TPenMode );
    Procedure SetRubberPenColor( Const Value: TColor );
    Procedure SetMarksColor( Const Value: TColor );
    Procedure MyOnPaint( Sender: TObject );
    Procedure MyOnMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer );
  {$IFDEF BCB} (*_*)
    function GetMarksColor: TColor;
    function GetPreviewBox: TEzPreviewBox;
    function GetRubberPenColor: TColor;
  {$ENDIF}
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
    Procedure Paint; Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
  Published
    Property PreviewBox: TEzPreviewBox
      read {$IFDEF BCB} GetPreviewBox {$ELSE} FPreviewBox {$ENDIF}
      write SetPreviewBox; (*_*)
    Property RubberPenColor: TColor
      read {$IFDEF BCB} GetRubberPenColor {$ELSE} FRubberPenColor {$ENDIF}
      write SetRubberPenColor Default clAqua; (*_*)
    Property MarksColor: TColor
      read {$IFDEF BCB} GetMarksColor {$ELSE} FMarksColor {$ENDIF}
      write SetMarksColor; (*_*)
  End;


implementation

Uses
  EzConsts, EzCADCtrls, EzMiscelEntities, EzShpImport;


{ TEzGISItem }

Procedure TEzGISItem.Assign( Source: TPersistent );
Begin
  If Source Is TEzGISItem Then
  Begin
    FGIS := TEzGISItem( Source ).FGIS;
  End
  Else
    Inherited Assign( Source );
End;

Function TEzGISItem.GetCaption: String;
Begin
  If FGIS = Nil Then
    result := SGISUnassigned
  Else
    result := ExtractFileName( FGIS.FileName );
End;

Function TEzGISItem.GetDisplayName: String;
Begin
  result := GetCaption;
  If Result = '' Then
    Result := Inherited GetDisplayName;
End;

{ TEzGISList }

Constructor TEzGISList.Create( AOwner: TPersistent );
Begin
  Inherited Create( AOwner, TEzGISItem );
End;

Function TEzGISList.Add: TEzGISItem;
Begin
  Result := TEzGISItem( Inherited Add );
End;

Function TEzGISList.GetItem( Index: Integer ): TEzGISItem;
Begin
  Result := TEzGISItem( Inherited GetItem( Index ) );
End;

Procedure TEzGISList.SetItem( Index: Integer; Value: TEzGISItem );
Begin
  Inherited SetItem( Index, Value );
End;


{ ********* TEzPreviewBox ************ }

Constructor TEzPreviewBox.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FPaperUnits := summs;
  FGISList := TEzGISList.Create( Self );
  FPaperPen := TPen.Create;
  FPaperPen.Style := psSolid;
  FPaperPen.Color := clBlack;
  FPaperBrush := TBrush.Create;
  FPaperBrush.Style := bsSolid;
  FPaperBrush.Color := clWhite;
  FShadowPen := TPen.Create;
  FShadowPen.Style := psSolid;
  FShadowPen.Color := clBlack;
  FShadowBrush := TBrush.Create;
  FShadowBrush.Style := bsSolid;
  FShadowBrush.Color := clBlack;
  FShowShadow := True;
  CreatePaperShapes;
  FShowPrinterMargins := True;
  if EzLib.PrintersInstalled then
    FOrientation := Printer.Orientation
  else
    FOrientation := poPortrait;
  PaperSize := psPrinter; { force calculation of printer dimensions and margins }

  GIS := TEzCAD.Create( Nil );
  CreateNewEditor;
End;

Destructor TEzPreviewBox.Destroy;
Begin
  FPaperPen.Free;
  FPaperBrush.Free;
  FShadowPen.Free;
  FShadowBrush.Free;
  DestroyShapes;
  FGISList.Free;
  Gis.Free;
  Inherited Destroy;
End;

Procedure TEzPreviewBox.Loaded;
begin
  inherited Loaded;
  SetPaperShapeAttributes;
end;

{$IFDEF BCB}
Function TEzPreviewBox.GetGISList: TEzGISList;
Begin
  Result:=FGISList;
End;

Function TEzPreviewBox.GetPaperSize: TEzPaperSize;
Begin
  Result:=FPaperSize;
End;

Function TEzPreviewBox.GetOrientation: TPrinterOrientation;
Begin
  Result:=FOrientation;
End;

Function TEzPreviewBox.GetShowPrinterMargins: Boolean;
Begin
  Result:= FShowPrinterMargins;
End;

Procedure TEzPreviewBox.SetShowPrinterMargins(Value: Boolean);
Begin
  FShowPrinterMargins:=Value;
End;

Function TEzPreviewBox.GetPaperUnits: TEzScaleUnits;
Begin
  Result:=FPaperUnits;
End;

Procedure TEzPreviewBox.SetPaperUnits(Value: TEzScaleUnits);
Begin
  FPaperUnits:=Value;
End;

Function TEzPreviewBox.GetPrintMode: TEzPrintMode;
Begin
  Result:=FPrintMode;
End;

Procedure TEzPreviewBox.SetPrintMode(Value: TEzPrintMode);
Begin
  FPrintMode:=Value;
End;

Function TEzPreviewBox.GetPaperPen: TPen;
Begin
  Result:=FPaperPen;
End;

Function TEzPreviewBox.GetPaperBrush: TBrush;
Begin
  Result:=FPaperBrush;
End;

Function TEzPreviewBox.GetShadowPen: TPen;
Begin
  Result:=FShadowPen;
End;

Function TEzPreviewBox.GetShadowBrush: TBrush;
Begin
  Result:=FShadowBrush;
End;

Function TEzPreviewBox.GetShowShadow: Boolean;
Begin
  Result:=FShowShadow;
End;
function TEzPreviewBox.GetMarginBottomShp: TEzPolyLine;
begin
  Result := FMarginBottomShp;
end;

function TEzPreviewBox.GetMarginLeftShp: TEzPolyLine;
begin
  Result := FMarginLeftShp;
end;

function TEzPreviewBox.GetMarginRightShp: TEzPolyLine;
begin
  Result := FMarginRightShp;
end;

function TEzPreviewBox.GetMarginTopShp: TEzPolyLine;
begin
  Result := FMarginTopShp;
end;

function TEzPreviewBox.GetPaperShp: TEzRectangle;
begin
  Result := FPaperShp;
end;

function TEzPreviewBox.GetShadowShp: TEzRectangle;
begin
  Result := FShadowShp;
end;
{$ENDIF}

Procedure TEzPreviewBox.CreateNewEditor;
Var
  I: Integer;
Begin
  ConfigurePaperShapes;
  GIS.Close;
  GIS.Layers.CreateNewCosmethic( 'A0' );
  GIS.Open;
  GIS.CurrentLayerName := 'A0';
  For I := 0 To Gis.DrawBoxList.Count - 1 Do
    Gis.DrawBoxList[I].Grapher.Clear;
  Selection.Clear;
  Grapher.Clear;
End;

Procedure TEzPreviewBox.PopulateFrom( Symbol: TEzSymbol );
Var
  Layer: TEzBaseLayer;
  I: Integer;
Begin
  { delete all records }
  Layer := GIS.Layers[0];
  Layer.First;
  While Not Layer.Eof Do
  Begin
    Layer.DeleteEntity( Layer.Recno );
    Layer.Next;
  End;
  //Layer.Pack;
  For I := 0 To Symbol.Count - 1 Do
    Layer.AddEntity( Symbol.Entities[I] );
End;

Procedure TEzPreviewBox.PopulateTo( Symbol: TEzSymbol );
Var
  Layer: TEzBaseLayer;
  Entity: TEzEntity;
Begin
  { delete all records }
  Symbol.Clear;
  Layer := GIS.Layers[0];
  Layer.First;
  While Not Layer.Eof Do
  Begin
    If Not Layer.RecIsDeleted Then
    Begin
      Entity := Layer.RecLoadEntity;
      Symbol.Add( Entity );
    End;
    Layer.Next;
  End;
End;

Procedure TEzPreviewBox.DestroyShapes;
Begin
  If Assigned( FPaperShp ) Then
    FPaperShp.Free;
  If Assigned( FShadowShp ) Then
    FShadowShp.Free;
  If Assigned( FMarginLeftShp ) Then
    FMarginLeftShp.Free;
  If Assigned( FMarginRightShp ) Then
    FMarginRightShp.Free;
  If Assigned( FMarginTopShp ) Then
    FMarginTopShp.Free;
  If Assigned( FMarginBottomShp ) Then
    FMarginBottomShp.Free;
End;

Procedure TEzPreviewBox.CreatePaperShapes;
Var
  p: TEzPoint;
Begin
  DestroyShapes;
  p := Point2d( 0, 0 );
  FPaperShp := TEzRectangle.CreateEntity( p, p );
  FShadowShp := TEzRectangle.CreateEntity( p, p );
  FMarginLeftShp := TEzPolyLine.CreateEntity( [p, p] );
  FMarginRightShp := TEzPolyLine.CreateEntity( [p, p] );
  FMarginTopShp := TEzPolyLine.CreateEntity( [p, p] );
  FMarginBottomShp := TEzPolyLine.CreateEntity( [p, p] );
  SetPaperShapeAttributes;
End;

Procedure TEzPreviewBox.SetPaperShapeAttributes;
Begin
  With FPaperShp.Pentool Do
  Begin
    Style := 1;
    Color := FPaperPen.Color;
    Width := 0;
  End;
  With FPaperShp.Brushtool Do
  Begin
    Pattern := 1;
    Color := FPaperBrush.Color;
    BackColor:= clBlack;
  End;
  With FShadowShp.Pentool Do
  Begin
    Style := 1;
    Color := FShadowPen.Color;
    Width := 0;
  End;
  With FShadowShp.Brushtool Do
  Begin
    Pattern := 1;
    Color := FShadowBrush.Color;
    BackColor:= clBlack;
  End;
  With FMarginLeftShp.Pentool Do
  Begin
    Style := 1;
    Color := clSilver;
    Width := 0;
  End;
  FMarginRightShp.Pentool.Assign( FMarginLeftShp.Pentool );
  FMarginTopShp.Pentool.Assign( FMarginLeftShp.Pentool );
  FMarginBottomShp.Pentool.Assign( FMarginLeftShp.Pentool );
End;

Function TEzPreviewBox.CurrentScale: Double;
Var
  ScaleDist: Double;
  Units: TEzScaleUnits;
Begin
  Units:= PaperUnits;
  Case Units Of
    suInches: ScaleDist := Grapher.ScreenDpiX; // inches
    suMms: ScaleDist := ( Grapher.ScreenDpiX / 25.4 ); // mms
    suCms: ScaleDist := ( Grapher.ScreenDpiX / 2.54 ); // cms
  Else
    ScaleDist := Grapher.ScreenDpiX;
  End;
  With Grapher do
  With CurrentParams.VisualWindow Do
    Result := Round(( ( Emax.X - Emin.X ) / Abs( ViewPortRect.X2 - ViewPortRect.X1 ) ) * ScaleDist);
End;

Procedure TEzPreviewBox.UpdateViewport( WCRect: TEzRect );
Var
  TheCanvas: TCanvas;
  VisualWindow: TEzRect;
Begin

  //If Not Showing then Exit;

  VisualWindow := Grapher.CurrentParams.VisualWindow;
  WCRect := VisualWindow;

  Inherited UpdateViewport( WCRect );

  If FShowShadow And IsRectVisible( FShadowShp.FBox, VisualWindow ) Then
  Begin
    FShadowShp.Draw( Grapher, ScreenBitmap.Canvas, VisualWindow, dmNormal );
  End;
  If IsRectVisible( FPaperShp.FBox, VisualWindow ) Then
    FPaperShp.Draw( Grapher, ScreenBitmap.Canvas, VisualWindow, dmNormal );
  If FShowPrinterMargins Then
  Begin
    If IsRectVisible( FMarginLeftShp.FBox, VisualWindow ) Then
      FMarginLeftShp.Draw( Grapher, ScreenBitmap.Canvas, VisualWindow,
        dmNormal );
    If IsRectVisible( FMarginRightShp.FBox, VisualWindow ) Then
      FMarginRightShp.Draw( Grapher, ScreenBitmap.Canvas, VisualWindow,
        dmNormal );
    If IsRectVisible( FMarginTopShp.FBox, VisualWindow ) Then
      FMarginTopShp.Draw( Grapher, ScreenBitmap.Canvas, VisualWindow,
        dmNormal );
    If IsRectVisible( FMarginBottomShp.FBox, VisualWindow ) Then
      FMarginBottomShp.Draw( Grapher, ScreenBitmap.Canvas, VisualWindow,
        dmNormal );
  End;

  { now draw the entities as usual }
  TheCanvas := Canvas;
  If odCanvas In OutputDevices Then
    TheCanvas := Canvas
  Else If odBitmap In OutputDevices Then
    TheCanvas := ScreenBitmap.Canvas;

  With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( WCRect, GIS, TheCanvas, Grapher, Selection, IsAerial,
                    False, pmAll, Self.ScreenBitmap );

    Finally
      Free;
    End;
End;

Procedure TEzPreviewBox.SetShowShadow( Value: Boolean );
Begin
  FShowShadow := Value;
  Repaint;
End;

Procedure TEzPreviewBox.Print(const ReportName: String = '');
Var
  PrnGrapher: TEzGrapher;
  //PaperUnits: TEzScaleUnits;
  //PageW, PageH: Double;
Begin
  try
    Printer.Printers.Count;
  except
    Exit;
  end;
  If Printer.Printing Then
    Raise Exception.Create( SPrinterIsBusy );
  { this will raise an exception immediately if printer is not ready }
  Printer.BeginDoc;
  Printer.Title := ReportName;
  PrnGrapher := TEzGrapher.Create( 1, adPrinter );
  { first, we need to calculate how many pixels are in the current printer
    for the predefined pagewidth and pageheight }
  //PageW := Dpi2Units(PaperUnits, PrnGrapher.PrinterDpiX, Printer.PageWidth );
  //PageH := Dpi2Units(PaperUnits, PrnGrapher.PrinterDpiY, Printer.PageHeight );
  PrnGrapher.SetViewport( 0, 0, Printer.PageWidth-1, Printer.PageHeight-1 );
  PrnGrapher.SetWindow( MarginLeft,  ( PaperWidth - MarginRight   ),
                        -MarginTop, -( PaperHeight - MarginBottom ) );
  With TEzPainterObject.Create(Nil) Do
  Try
    DrawEntities( Rect2D( 0, -PaperHeight, PaperWidth, 0 ),
                  GIS,
                  Printer.Canvas,
                  PrnGrapher,
                  Selection,
                  False,
                  False,
                  pmAll,
                  Self.ScreenBitmap );
  Finally
    Free;
    PrnGrapher.Free;
    Printer.EndDoc;
    Printer.Title := '';
  End;
End;

Procedure TEzPreviewBox.ZoomToPaper;
Var
  TmpMarginX, TmpMarginY: Double;
  MaxExtents: TEzRect;
Begin
  MaxExtents := Rect2D( 0, -PaperHeight, PaperWidth, 0 );
  If Not EqualRect2D( MaxExtents, Grapher.OriginalParams.VisualWindow ) Then
  Begin
    With MaxExtents Do
    Begin
      TmpMarginX := ( Emax.X - Emin.X ) / 40;
      TmpMarginY := ( Emax.Y - Emin.Y ) / 40;
      Grapher.SetWindow( Emin.X - TmpMarginX,
                         Emax.X + TmpMarginX ,
                         Emin.Y - TmpMarginY,
                         Emax.Y + TmpMarginY  );
    End;
  End;
  Grapher.Zoom( 1 );
  Repaint;
End;

Function TEzPreviewBox.GetPrintablePageWidth: Double;
Begin
  result := PaperWidth - MarginLeft - MarginRight;
End;

Function TEzPreviewBox.GetPrintablePageHeight: Double;
Begin
  result := PaperHeight - MarginTop - MarginBottom;
End;

Procedure TEzPreviewBox.ConfigurePaperShapes;
Var
  Delta: Double;
  p: TEzPoint;
Begin
  { paper }
  FPaperShp.Points[0] := Point2D( 0, 0 );
  FPaperShp.Points[1] := Point2D( PaperWidth, -PaperHeight );
  { shadow }
  FShadowShp.Points.Assign( FPaperShp.Points );
  Delta := PaperWidth * 0.015;
  p := FShadowShp.Points[0];
  FShadowShp.Points[0] := Point2D( p.X + Delta, p.Y - Delta );
  p := FShadowShp.Points[1];
  FShadowShp.Points[1] := Point2D( p.X + Delta, p.Y - Delta );
  { left margin }
  FMarginLeftShp.Points[0] := Point2D( MarginLeft, -MarginTop );
  FMarginLeftShp.Points[1] := Point2D( MarginLeft, -( PaperHeight - MarginBottom ) );
  { right margin }
  FMarginRightShp.Points[0] := Point2D( PaperWidth - MarginRight, -MarginTop );
  FMarginRightShp.Points[1] := Point2D( PaperWidth - MarginRight, -( PaperHeight - MarginBottom ) );
  { margin top }
  FMarginTopShp.Points[0] := Point2D( MarginLeft, -MarginTop );
  FMarginTopShp.Points[1] := Point2D( PaperWidth - MarginRight, -MarginTop );
  { margin bottom }
  FMarginBottomShp.Points[0] := Point2D( MarginLeft, -( PaperHeight - MarginBottom ) );
  FMarginBottomShp.Points[1] := Point2D( PaperWidth - MarginRight, -( PaperHeight - MarginBottom ) );
End;

Function TEzPreviewBox.GetMarginLeft: Double;
Begin
  result := Inches2Units( FPaperUnits, FPrinterMarginLeft );
End;

Function TEzPreviewBox.GetMarginTop: Double;
Begin
  result := Inches2Units( FPaperUnits, FPrinterMarginTop );
End;

Function TEzPreviewBox.GetMarginBottom: Double;
Begin
  result := Inches2Units( FPaperUnits, FPrinterMarginBottom );
End;

Function TEzPreviewBox.GetMarginRight: Double;
Begin
  result := Inches2Units( FPaperUnits, FPrinterMarginRight );
End;

Function TEzPreviewBox.GetPaperWidth: Double;
Begin
  If FPaperSize = psPrinter Then
    result := FPrinterPaperWidth
  Else
    result := FCustomPaperWidth;
  result := Inches2Units( FPaperUnits, result );
End;

Function TEzPreviewBox.GetPaperHeight: Double;
Begin
  If FPaperSize = psPrinter Then
    result := FPrinterPaperHeight
  Else
    result := FCustomPaperHeight;
  result := Inches2Units( FPaperUnits, result );
End;

Procedure TEzPreviewBox.SetPaperWidth( Const Value: Double );
Begin
  FCustomPaperWidth := Units2Inches( FPaperUnits, abs( Value ) );
End;

Procedure TEzPreviewBox.SetPaperHeight( Const Value: Double );
Begin
  FCustomPaperHeight := Units2Inches( FPaperUnits, abs( Value ) );
End;

Procedure TEzPreviewBox.SetOrientation( Value: TPrinterOrientation );
Var
  temp: Double;
Begin
  If ( FPaperSize = psPrinter ) Or ( Value = FOrientation ) Then Exit;
  FOrientation := Value;
  temp := FCustomPaperWidth;
  FCustomPaperWidth := FCustomPaperHeight;
  FCustomPaperHeight := temp;
End;

Procedure TEzPreviewBox.SetPaperSize( Const Value: TEzPaperSize );
Var
  ps, pt: TPoint;
  GutterLeft: Integer;
  GutterTop: Integer;
  GutterRight: Integer;
  GutterBottom: Integer;
  PrinterDpiX: Integer;
  PrinterDpiY: Integer;
Begin
  FPaperSize := Value;
  { determine paper dimensions }
  if EzLib.PrintersInstalled then
  begin
    Escape( Printer.Handle, GETPHYSPAGESIZE, 0, Nil, @ps );
    Escape( Printer.Handle, GETPRINTINGOFFSET, 0, Nil, @pt );
  end
  else
  begin
    ps := Point(Trunc(210 / 25.4 * Screen.PixelsPerInch), Trunc(297 / 25.4 * Screen.PixelsPerInch));
    pt := Point(10, 10);
  end;
  GutterLeft := pt.X;
  GutterTop := pt.Y;
  if EzLib.PrintersInstalled then
  begin
    GutterRight := ps.X - GutterLeft - Printer.PageWidth;
    GutterBottom := ps.Y - GutterTop - Printer.PageHeight;
  end
  else
  begin
    GutterRight := 10;
    GutterBottom := 10;
  end;
  If EzLib.PrintersInstalled Then
  begin
    PrinterDpiX := GetDeviceCaps( Printer.Handle, LOGPIXELSX );
    PrinterDpiY := GetDeviceCaps( Printer.Handle, LOGPIXELSY );
  end
  else
  begin
    PrinterDpiX := Screen.PixelsPerInch;
    PrinterDpiY := Screen.PixelsPerInch;
  end;

  FPrinterMarginLeft := GutterLeft / PrinterDpiX;
  FPrinterMarginTop := GutterTop / PrinterDpiY;
  FPrinterMarginRight := GutterRight / PrinterDpiX;
  FPrinterMarginBottom := GutterBottom / PrinterDpiY;
  FPrinterPaperWidth := ps.X / PrinterDpiX;
  FPrinterPaperHeight := ps.Y / PrinterDpiY;

  FPrinterMarginLeft := GutterLeft / PrinterDpiX;
  FPrinterMarginTop := GutterTop / PrinterDpiY;
  FPrinterMarginRight := GutterRight / PrinterDpiX;
  FPrinterMarginBottom := GutterBottom / PrinterDpiY;
  FPrinterPaperWidth := ps.X / PrinterDpiX;
  FPrinterPaperHeight := ps.Y / PrinterDpiY;

  Case Value Of
    psPrinter:
      Begin
        FCustomPaperWidth := FPrinterPaperWidth;
        FCustomPaperHeight := FPrinterPaperHeight;
      End;
    psLetter:
      Begin
        FCustomPaperWidth := 8.5;
        FCustomPaperHeight := 11;
      End;
    psLegal:
      Begin
        FCustomPaperWidth := 8.5;
        FCustomPaperHeight := 14;
      End;
    psLedger:
      Begin
        FCustomPaperWidth := 11;
        FCustomPaperHeight := 17;
      End;
    psStatement:
      Begin
        FCustomPaperWidth := 5.5;
        FCustomPaperHeight := 8.5;
      End;
    psExecutive:
      Begin
        FCustomPaperWidth := 7.25;
        FCustomPaperHeight := 10.5;
      End;
    psA3:
      Begin
        FCustomPaperWidth := 11.69;
        FCustomPaperHeight := 16.54;
      End;
    psA4:
      Begin
        FCustomPaperWidth := 8.27;
        FCustomPaperHeight := 11.69;
      End;
    psA5:
      Begin
        FCustomPaperWidth := 5.83;
        FCustomPaperHeight := 8.27;
      End;
    psB3:
      Begin
        FCustomPaperWidth := 14.33;
        FCustomPaperHeight := 20.28;
      End;
    psB4:
      Begin
        FCustomPaperWidth := 10.12;
        FCustomPaperHeight := 14.33;
      End;
    psB5:
      Begin
        FCustomPaperWidth := 7.17;
        FCustomPaperHeight := 10.12;
      End;
    psFolio:
      Begin
        FCustomPaperWidth := 8.5;
        FCustomPaperHeight := 13;
      End;
    psQuarto:
      Begin
        FCustomPaperWidth := 8.47;
        FCustomPaperHeight := 10.83;
      End;
    ps10x14:
      Begin
        FCustomPaperWidth := 10;
        FCustomPaperHeight := 14;
      End;
    ps11x17:
      Begin
        FCustomPaperWidth := 11;
        FCustomPaperHeight := 17;
      End;
    psCsize:
      Begin
        FCustomPaperWidth := 17;
        FCustomPaperHeight := 22;
      End;
    psUSStdFanfold:
      Begin
        FCustomPaperWidth := 11;
        FCustomPaperHeight := 14.88;
      End;
    psGermanStdFanfold:
      Begin
        FCustomPaperWidth := 8.5;
        FCustomPaperHeight := 12;
      End;
    psGermanLegalFanfold:
      Begin
        FCustomPaperWidth := 8.5;
        FCustomPaperHeight := 13;
      End;
    ps6x8:
      Begin
        FCustomPaperWidth := 6;
        FCustomPaperHeight := 8;
      End;
    psFoolscap:
      Begin
        FCustomPaperWidth := 13.5;
        FCustomPaperHeight := 17;
      End;
    psLetterPlus:
      Begin
        FCustomPaperWidth := 9;
        FCustomPaperHeight := 13.3;
      End;
    psA4Plus:
      Begin
        FCustomPaperWidth := 8.77;
        FCustomPaperHeight := 14;
      End;
  End;
End;

Procedure TEzPreviewBox.SetPaperPen( Value: TPen );
Begin
  FPaperPen.Assign( Value );
  SetPaperShapeAttributes;
End;

Procedure TEzPreviewBox.SetPaperBrush( Value: TBrush );
Begin
  FPaperBrush.Assign( Value );
  SetPaperShapeAttributes;
End;

Procedure TEzPreviewBox.SetShadowPen( Value: TPen );
Begin
  FShadowPen.Assign( Value );
  SetPaperShapeAttributes;
End;

Procedure TEzPreviewBox.SetShadowBrush( Value: TBrush );
Begin
  FShadowBrush.Assign( Value );
  SetPaperShapeAttributes;
End;

function TEzPreviewBox.AddMap( Index: Integer; Const OutX, OutY, WidthOut, HeightOut,
  PlottedUnits, DrawingUnits, CoordX, CoordY: Double; IsAtCenter: Boolean; PrintFrame: Boolean = False ): Integer;
Var
  Preview: TEzPreviewEntity;
  PrintView: TEzRect;
  DrawingScale, WidthArea, HeightArea: Double;
Begin
  If ( Index < 0 ) Or ( Index > FGISList.Count - 1 ) Then
    Raise Exception.Create( SGISListError );
  { calcula la escala de dibujo }
  DrawingScale := DrawingUnits / PlottedUnits;

  { ancho y alto del area en el mapa }
  WidthArea := WidthOut * DrawingScale;
  HeightArea := HeightOut * DrawingScale;

  If IsAtCenter Then
  Begin
    With PrintView Do
    Begin
      Emin.X := CoordX - WidthArea / 2;
      Emin.Y := CoordY - HeightArea / 2;
      Emax.X := CoordX + WidthArea / 2;
      Emax.Y := CoordY + HeightArea / 2;
    End;
  End
  Else
  Begin
    With PrintView Do
    Begin
      Emin.X := CoordX;
      Emin.Y := CoordY - HeightArea;
      Emax.X := CoordX + WidthArea;
      Emax.Y := CoordY;
    End;
  End;
  Preview := TEzPreviewEntity.CreateEntity( Point2D( OutX, OutY ),
    Point2D( OutX + WidthOut, ( OutY - HeightOut ) ), pmAll, Index );
  Try
    Preview.PrintFrame := PrintFrame;
    //Preview.PenStyle.Style:= 0;         // don't draw the frame
    Preview.PaperUnits := Self.FPaperUnits;
    Preview.PlottedUnits := PlottedUnits;
    Preview.DrawingUnits := DrawingUnits;
    Preview.ProposedPrintArea := PrintView;
    Result := Self.AddEntity( GIS.CurrentLayerName, Preview );
  Finally
    Preview.Free;
  End;
End;

Procedure TEzPreviewBox.SetGISList( Value: TEzGISList );
Begin
  FGISList.Assign( Value );
End;

procedure TEzPreviewBox.ZoomToFit;
var
  w,x1,y1,x2,margin:Double;
begin
  x1:=PaperShp.Points[0].X;
  x2:=PaperShp.Points[1].X;
  y1:=PaperShp.Points[0].Y;
  w:=abs(x2-x1);
  margin:= w/40;
  SetViewTo(x1-margin,y1+margin,(x1+w)+margin,y1-1);
end;


{ TEzHRuler }

Procedure MaxMinSeparation( PreviewBox: TEzPreviewBox; Var maxs, mins: Double );
Var
  azoom: integer;
  OriginalDX, CurrentDX: Double;
Begin
  With PreviewBox.Grapher Do
  Begin
    With OriginalParams.VisualWindow Do
      OriginalDX := Emax.X - Emin.X;
    With CurrentParams.VisualWindow Do
      CurrentDX := Emax.X - Emin.X;
    azoom := round( ( OriginalDX / CurrentDX ) * 100 )
  End;
  If PreviewBox.FPaperUnits = suMms Then
  Begin
    Case azoom Of
      0..24:
        Begin
          mins := 10;
          maxs := 100;
        End;
      25..49:
        Begin
          mins := 10;
          maxs := 50;
        End;
      50..100:
        Begin
          mins := 2;
          maxs := 20;
        End;
      101..MaxInt:
        Begin
          mins := 1;
          maxs := 10;
        End;
    End;
  End Else If PreviewBox.FPaperUnits = suCms Then
  Begin
    Case azoom Of
      0..24:
        Begin
          mins := 1;
          maxs := 10;
        End;
      25..49:
        Begin
          mins := 1;
          maxs := 5;
        End;
      50..100:
        Begin
          mins := 0.2;
          maxs := 2;
        End;
      101..MaxInt:
        Begin
          mins := 0.1;
          maxs := 1;
        End;
    End;
  End
  Else If PreviewBox.FPaperUnits = suInches Then
  Begin
    Case azoom Of
      0..24:
        Begin
          mins := 1 / 2;
          maxs := 4;
        End;
      25..32:
        Begin
          mins := 1 / 2;
          maxs := 2;
        End;
      33..100:
        Begin
          mins := 1 / 8;
          maxs := 1;
        End;
      101..MaxInt:
        Begin
          mins := 1 / 16;
          maxs := 1;
        End;
    End;
  End;
End;

Constructor TEzHRuler.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  Align := alTop;
  FRubberPenColor := clAqua;
  FMarksColor := clOlive;
End;

Procedure TEzHRuler.SetPreviewBox( Value: TEzPreviewBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FPreviewBox ) then FPreviewBox.RemoveFreeNotification( Self );
{$ENDIF}
  If ( Value <> Nil ) And ( Value <> FPreviewBox ) Then
  Begin
    Value.FreeNotification( Self );
    If FPreviewBox <> Nil Then
      With FPreviewBox Do
      Begin
        OnMouseMove := FBoxOnMouseMove;
        OnPaint := FBoxOnPaint;
      End;
    If Value <> Nil Then
      With value Do
      Begin
        FBoxOnMouseMove := OnMouseMove;
        FBoxOnPaint := OnPaint;

        OnMouseMove := MyOnMouseMove;
        OnPaint := MyOnPaint;
      End;
  End;
  FPreviewBox := value;
  Invalidate;
End;

Procedure TEzHRuler.MyOnMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
Begin
  If Assigned( FBoxOnMouseMove ) Then
    FBoxOnMouseMove( Sender, Shift, X, Y );
  If FPreviewBox = Nil Then
    Exit;
  DrawRulerPosition( FLastMousePosInRuler, pmXor );
  FLastMousePosInRuler := ScreenToClient( FPreviewBox.ClientToScreen( Point( X, Y ) ) );
  DrawRulerPosition( FLastMousePosInRuler, pmXor );
End;

Procedure TEzHRuler.MyOnPaint( Sender: TObject );
Begin
  If Assigned( FBoxOnPaint ) Then
    FBoxOnPaint( Sender );
  Self.Paint;
End;

Procedure TEzHRuler.DrawRulerPosition( p: TPoint; AMode: TPenMode );
Begin
  If FPreviewBox = Nil Then Exit;
  With Canvas Do
  Begin
    Pen.Mode := AMode;
    Pen.Color := ColorToRGB( FRubberPenColor ) Xor ColorToRGB( Self.Color );
    MoveTo( p.X, 0 );
    LineTo( p.X, Height );
    Pen.Mode := pmCopy;
  End;
End;

Procedure TEzHRuler.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FPreviewBox ) Then
    FPreviewBox := Nil;
End;

Procedure TEzHRuler.Paint;
Var
  ULColor, LRColor: TColor;
  R: TRect;
  i, W: integer;
  Text: String;
  N: Integer;
  pt: TPoint;
  TmpPt: TEzPoint;
  XM, XLeft, MinSep, MaxSep: Double;
  EffectiveH, m, Y, DY: Cardinal;

  Procedure DrawSides( Const Rect: TRect );
  Begin
    With Canvas, Rect Do
    Begin
      Pen.Color := LRColor;
      MoveTo( Left, Top );
      LineTo( Left, Bottom );

      MoveTo( Left, Top );
      LineTo( Right, Top );

      Pen.Color := ULColor;
      MoveTo( Right - 1, Top );
      LineTo( Right - 1, Bottom );

      MoveTo( Left, Bottom - 1 );
      LineTo( Right, Bottom - 1 );
    End;
  End;

Begin
  Inherited Paint;

  If ( csDesigning In ComponentState ) Or ( FPreviewBox = Nil ) Then Exit;

  DrawRulerPosition( FLastMousePosInRuler, pmNotXor );

  ULColor := clBtnShadow;
  LRColor := clBtnHighlight;
  With Canvas Do
  Begin
    // first, paint the borders
    Font.Assign( Self.Font );
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
    FillRect( ClientRect );
    Brush.Style := bsClear;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    R := ClientRect;
    W := 2;
    For I := 1 To W Do
    Begin
      DrawSides( R );
      InflateRect( R, -1, -1 );
    End;
    Pen.Color := FMarksColor;

    { calc min and max separators }
    MaxMinSeparation( FPreviewBox, MaxSep, MinSep );

    If FPreviewBox.Grapher.RealToDistX(maxsep) < 10 then exit;

    //PixelsSep:= FPreviewBox.Grapher.RealToDistX(MinSep);
    //if (PixelsSep < 3) or (PixelsSep >= FPreviewBox.Width) then Exit;

    { Calc the zero point }
    TmpPt := Point2d( 0, 0 );
    pt := Self.ScreenToClient(
      FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );

    {calc the begining of ruler...}
    If pt.X > 0 Then
    Begin
      While pt.X >= 0 Do
      Begin
        TmpPt.X := TmpPt.X - MaxSep;
        pt := Self.ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      End;
    End
    Else If pt.X < 0 Then
    Begin
      While pt.X <= 0 Do
      Begin
        TmpPt.X := TmpPt.X + MaxSep;
        pt := Self.ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      End;
      If pt.X >= Self.Width Then
      Begin
        TmpPt.X := TmpPt.X - MaxSep;
        pt := Self.ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      End;
    End;
    TmpPt.X := TmpPt.X - MaxSep;

    {...and draw it}
    XLeft := TmpPt.X;
    m := 0;
    While pt.X < Self.Width Do
    Begin
      TmpPt.X := XLeft + m * MaxSep;
      pt := Self.ScreenToClient(
        FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );

      { If FPreviewBox.PaperUnits = suMms Then
        Text := FloatToStr( round( abs( TmpPt.X + FPreviewBox.MarginLeft ) ) / 1  )
      Else If FPreviewBox.PaperUnits = suMms Then
        Text := FloatToStr( round( abs( TmpPt.X + FPreviewBox.MarginLeft ) ) / 1  )
      Else
        Text := FloatToStr( round( abs( TmpPt.X + FPreviewBox.MarginLeft ) ) );  }

      Text := FloatToStr( round( abs( TmpPt.X + FPreviewBox.MarginLeft ) ) );

      { Draw the mayor scale }
      MoveTo( pt.X, 2 );
      LineTo( pt.X, Self.Height - 2 );

      {Draw the text}
      TextOut( pt.X + 1, 2, Text );

      {draw the minor scale}
      XM := MinSep;
      n := 0;
      While XM < MaxSep Do
      Begin
        pt := Self.ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( Point2d( TmpPt.X + XM, 0 ) ) ) );
        Inc( n );
        EffectiveH := ( Self.Height - 4 );
        DY := 0;
        If FPreviewBox.FPaperUnits = suMms Then
        Begin
          If XM = MaxSep / 2 Then
            DY := EffectiveH Div 2
          Else
            DY := EffectiveH Div 4;
        End Else If FPreviewBox.FPaperUnits = suCms Then
        Begin
          If XM = MaxSep / 2 Then
            DY := EffectiveH Div 2
          Else
            DY := EffectiveH Div 4;
        End
        Else
        Begin
          If MinSep = 1 / 2 Then
          Begin
            If n * MinSep = int( n * MinSep ) Then
              DY := EffectiveH Div 2
            Else
              DY := EffectiveH Div 4;
          End
          Else If MinSep = 1 / 8 Then
          Begin
            If n = 4 Then
              DY := EffectiveH Div 2
            Else
              DY := EffectiveH Div 4
          End
          Else If MinSep = 1 / 16 Then
          Begin
            If n = 8 Then
              DY := EffectiveH Div 2
            Else If n Mod 2 = 0 Then
              DY := EffectiveH Div 3
            Else
              DY := EffectiveH Div 5;
          End;
        End;
        Y := Self.Height - 2;
        MoveTo( pt.X, Y );
        LineTo( pt.X, Y - DY );

        XM := XM + MinSep;
      End;

      Inc( m );
    End;
  End;
  DrawRulerPosition( FLastMousePosInRuler, pmNotXor );
End;

Procedure TEzHRuler.SetRubberPenColor( Const Value: TColor );
Begin
  FRubberPenColor := Value;
  Invalidate;
End;

Procedure TEzHRuler.SetMarksColor( Const Value: TColor );
Begin
  FMarksColor := Value;
  Invalidate;
End;

{$IFDEF BCB}
function TEzHRuler.GetMarksColor: TColor;
begin
  Result := FMarksColor;
end;

function TEzHRuler.GetPreviewBox: TEzPreviewBox;
begin
  Result := FPreviewBox;
end;

function TEzHRuler.GetRubberPenColor: TColor;
begin
  Result := FRubberPenColor;
end;
{$ENDIF}

{ TEzVRuler }

Constructor TEzVRuler.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  Align := alLeft;
  FRubberPenColor := clAqua;
  FMarksColor := clOlive;
End;

Procedure TEzVRuler.SetPreviewBox( Value: TEzPreviewBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FPreviewBox ) then FPreviewBox.RemoveFreeNotification( Self );
{$ENDIF}
  If ( Value <> Nil ) And ( Value <> FPreviewBox ) Then
  Begin
    Value.FreeNotification( Self );
    If FPreviewBox <> Nil Then
      With FPreviewBox Do
      Begin
        OnMouseMove := FBoxOnMouseMove;
        OnPaint := FBoxOnPaint;
      End;
    If Value <> Nil Then
      With value Do
      Begin
        FBoxOnMouseMove := OnMouseMove;
        FBoxOnPaint := OnPaint;

        OnMouseMove := MyOnMouseMove;
        OnPaint := MyOnPaint;
      End;
  End;
  FPreviewBox := value;
  Invalidate;
End;

Procedure TEzVRuler.MyOnMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer );
Begin
  If Assigned( FBoxOnMouseMove ) Then
    FBoxOnMouseMove( Sender, Shift, X, Y );
  If FPreviewBox = Nil Then
    Exit;
  DrawRulerPosition( FLastMousePosInRuler, pmXor );
  FLastMousePosInRuler := ScreenToClient( FPreviewBox.ClientToScreen( Point( X, Y ) ) );
  DrawRulerPosition( FLastMousePosInRuler, pmXor );
End;

Procedure TEzVRuler.MyOnPaint( Sender: TObject );
Begin
  If Assigned( FBoxOnPaint ) Then
    FBoxOnPaint( Sender );
  Self.Paint;
End;

Procedure TEzVRuler.DrawRulerPosition( p: TPoint; AMode: TPenMode );
Begin
  If FPreviewBox = Nil Then
    Exit;
  With Canvas Do
  Begin
    Pen.Mode := AMode;
    Pen.Color := ColorToRGB( FRubberPenColor ) Xor ColorToRGB( Self.Color );
    MoveTo( 0, p.Y );
    LineTo( Width, p.Y );
    Pen.Mode := pmCopy;
  End;
End;

Procedure TEzVRuler.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FPreviewBox ) Then
    FPreviewBox := Nil;
End;

Procedure TEzVRuler.Paint;
Var
  ULColor, LRColor: TColor;
  R: TRect;
  i, W: integer;
  Text: String;
  N: Integer;
  pt: TPoint;
  TmpPt: TEzPoint;
  YM, YTop, MinSep, MaxSep: Double;
  EffectiveW, m, X, DX: Cardinal;

  Procedure DrawSides( Rect: TRect );
  Begin
    With Canvas, Rect Do
    Begin
      Pen.Color := LRColor;
      MoveTo( Left, Top );
      LineTo( Left, Bottom );

      MoveTo( Left, Top );
      LineTo( Right, Top );

      Pen.Color := ULColor;
      MoveTo( Right - 1, Top );
      LineTo( Right - 1, Bottom );

      MoveTo( Left, Bottom - 1 );
      LineTo( Right, Bottom - 1 );
    End;
  End;

Begin
  Inherited Paint;
  If ( csDesigning In ComponentState ) Or ( FPreviewBox = Nil ) Then
    Exit;
  DrawRulerPosition( FLastMousePosInRuler, pmNotXor );

  ULColor := clBtnShadow;
  LRColor := clBtnHighlight;
  With Canvas Do
  Begin
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
    FillRect( ClientRect );
    Brush.Style := bsClear;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    R := ClientRect;
    W := 2;
    For I := 1 To W Do
    Begin
      DrawSides( R );
      InflateRect( R, -1, -1 );
    End;
    Pen.Color := FMarksColor;

    {calc min and max separators}
    MaxMinSeparation( FPreviewBox, MaxSep, MinSep );

    If FPreviewBox.Grapher.RealToDistY(maxsep) < 10 then exit;

    {Calc the zero point}
    TmpPt := Point2d( 0, 0 );
    pt := ScreenToClient(
      FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
    Inc( pt.Y );

    { calc the begining of ruler... }
    If pt.Y < 0 Then
    Begin
      While pt.Y <= 0 Do
      Begin
        TmpPt.Y := TmpPt.Y - MaxSep;
        pt := ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      End;
      If pt.Y >= Height Then
      Begin
        TmpPt.Y := TmpPt.Y + MaxSep;
        pt := ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      End;
    End
    Else If pt.Y > 0 Then
    Begin
      While pt.Y >= 0 Do
      Begin
        TmpPt.Y := TmpPt.Y + MaxSep;
        pt := ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      End;
    End;
    TmpPt.Y := TmpPt.Y + MaxSep;

    { ...and draw it }
    YTop := TmpPt.Y;
    m := 0;
    While pt.Y < Height Do
    Begin
      TmpPt.Y := YTop - m * MaxSep;
      pt := ScreenToClient(
        FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( TmpPt ) ) );
      {If FPreviewBox.FPaperUnits = suMms Then
        Text := FloatToStr( round( abs( TmpPt.Y - FPreviewBox.MarginTop ) ) / 1 )
      Else
        Text := FloatToStr( round( abs( TmpPt.Y - FPreviewBox.MarginTop ) ) );  }

      Text := FloatToStr( round( abs( TmpPt.Y - FPreviewBox.MarginTop ) ) );

      {draw the mayor scale}
      MoveTo( 2, pt.Y );
      LineTo( Width - 2, pt.Y );

      {Draw the text}
      TextOut( 2, pt.Y + 1, Text );

      {draw the minor scale}
      YM := MinSep;
      n := 0;
      While YM < MaxSep Do
      Begin
        pt := ScreenToClient(
          FPreviewBox.ClientToScreen( FPreviewBox.Grapher.RealToPoint( Point2d( 0, TmpPt.Y - YM ) ) ) );
        Inc( n );
        EffectiveW := ( Width - 4 );
        DX := 0;
        If FPreviewBox.PaperUnits = suMms Then
        Begin
          If YM = MaxSep / 2 Then
            DX := EffectiveW Div 2
          Else
            DX := EffectiveW Div 4;
        End Else If FPreviewBox.PaperUnits = suCms Then
        Begin
          If YM = MaxSep / 2 Then
            DX := EffectiveW Div 2
          Else
            DX := EffectiveW Div 4;
        End
        Else
        Begin
          If MinSep = 1 / 2 Then
          Begin
            If n * MinSep = int( n * MinSep ) Then
              DX := EffectiveW Div 2
            Else
              DX := EffectiveW Div 4;
          End
          Else If MinSep = 1 / 8 Then
          Begin
            If n = 4 Then
              DX := EffectiveW Div 2
            Else
              DX := EffectiveW Div 4
          End
          Else If MinSep = 1 / 16 Then
          Begin
            If n = 8 Then
              DX := EffectiveW Div 2
            Else If n Mod 2 = 0 Then
              DX := EffectiveW Div 3
            Else
              DX := EffectiveW Div 5;
          End;
        End;
        X := Width - 2;
        MoveTo( X, pt.Y );
        LineTo( X - DX, pt.Y );

        YM := YM + MinSep;
      End;

      Inc( m );
    End;
  End;
  DrawRulerPosition( FLastMousePosInRuler, pmNotXor );
End;

Procedure TEzVRuler.SetRubberPenColor( Const Value: TColor );
Begin
  FRubberPenColor := Value;
  Invalidate;
End;

Procedure TEzVRuler.SetMarksColor( Const Value: TColor );
Begin
  FMarksColor := Value;
  Invalidate;
End;

{$IFDEF BCB}
function TEzVRuler.GetMarksColor: TColor;
begin
  Result := FMarksColor;
end;

function TEzVRuler.GetPreviewBox: TEzPreviewBox;
begin
  Result := FPreviewBox;
end;

function TEzVRuler.GetRubberPenColor: TColor;
begin
  Result := FRubberPenColor;
end;
{$ENDIF}


{ TEzMosaicView }

Constructor TEzMosaicView.Create( AOwner: TComponent );
Begin
  Inherited Create( Aowner );
  ZoomWithMargins:= False;
  FInnerColor := clGreen;
  FOuterColor := clBlack;
  FPrintedInnerColor := clRed;
  FPrintedOuterColor := clBlack;
  FShowInverted := False;
  IsAerial := True;
  ScrollBars := ssNone;
  FX1List:= TEzDoubleList.create;
  FY1List:= TEzDoubleList.create;
  FX2List:= TEzDoubleList.create;
  FY2List:= TEzDoubleList.create;
End;

Destructor TEzMosaicView.Destroy;
Begin
  Inherited Destroy;
  FX1List.free;
  FY1List.free;
  FX2List.free;
  FY2List.free;
End;

{$IFDEF BCB}
Function TEzMosaicView.GetX1List: TEzDoubleList;
Begin
  Result:=FX1List;
End;

Function TEzMosaicView.GetY1List: TEzDoubleList;
Begin
  Result:=FY1List;
End;

Function TEzMosaicView.GetX2List: TEzDoubleList;
Begin
Result:=FX2List;
End;

Function TEzMosaicView.GetY2List: TEzDoubleList;
Begin
  Result:=FY2List;
End;

Function TEzMosaicView.GetShowInverted: boolean;
Begin
  Result:=FShowInverted;
End;

procedure TEzMosaicView.SetShowInverted(Value: boolean);
Begin
  FShowInverted:=value;
End;

Function TEzMosaicView.GetPrintedInnerColor: TColor;
Begin
  Result:=FPrintedInnerColor
End;

procedure TEzMosaicView.SetPrintedInnerColor(Value: TColor);
Begin
  FPrintedInnerColor:=value;
End;

Function TEzMosaicView.GetPrintedOuterColor: TColor;
Begin
  Result:=FPrintedOuterColor
End;

procedure TEzMosaicView.SetPrintedOuterColor(Value: TColor);
Begin
  PrintedOuterColor:=value;
End;

Function TEzMosaicView.GetInnerColor: TColor;
Begin
  Result:=FInnerColor;
End;

procedure TEzMosaicView.SetInnerColor(Value: TColor);
Begin
  FInnerColor:=Value;
End;

Function TEzMosaicView.GetOuterColor: TColor;
Begin
  Result:=FOuterColor;
End;

procedure TEzMosaicView.SetOuterColor(Value: TColor);
Begin
  FOuterColor:=Value;
End;

Function TEzMosaicView.GetParentView: TEzPreviewBox;
Begin
  Result:=FParentView;
End;
{$ENDIF}

Function TEzMosaicView.CurrentPrintArea(Ent: TEzEntity;
  Advance: TEzPageAdvance): TEzRect;
var
  MapWidthArea, MapHeightArea, DrawingScale, X, Y: Double;
  PaperAreaWidth, PaperAreaHeight: Double;
  PreviewArea, MapDrawingArea: TEzRect;
begin
  PreviewArea.Emin := Ent.Points[0];
  PreviewArea.Emax := Ent.Points[1];
  PreviewArea := ReorderRect2D( PreviewArea );
  PaperAreaWidth := Abs( PreviewArea.X2 - PreviewArea.X1 );
  PaperAreaHeight := Abs( PreviewArea.Y2 - PreviewArea.Y1 );
  MapDrawingArea := ReorderRect2D( TEzPreviewEntity( Ent ).ProposedPrintArea );
  With TEzPreviewEntity( Ent ) Do
    DrawingScale := DrawingUnits / PlottedUnits;
  With MapDrawingArea Do
  Begin
    Emax.X := Emin.X + PaperAreaWidth * DrawingScale;
    Emin.Y := Emax.Y - PaperAreaHeight * DrawingScale;
  End;
  { just in case you want to resave this entity }
  TEzPreviewEntity( Ent ).ProposedPrintArea:= MapDrawingArea;

  MapWidthArea := Abs( MapDrawingArea.X2 - MapDrawingArea.X1 );
  MapHeightArea := Abs( MapDrawingArea.Y2 - MapDrawingArea.Y1 );
  Y := MapDrawingArea.Y2;
  X := MapDrawingArea.X1;
  Result.X1 := X;
  Result.X2 := X + MapWidthArea;
  Result.Y1 := Y - MapHeightArea;
  Result.Y2 := Y;
  if Advance = padvNone then Exit;
  case Advance of
    padvLeft:
      begin
        Result.X1 := Result.X1 - MapWidthArea;
        Result.X2 := Result.X2 - MapWidthArea;
      end;
    padvRight:
      begin
        Result.X1 := Result.X1 + MapWidthArea;
        Result.X2 := Result.X2 + MapWidthArea;
      end;
    padvDown:
      begin
        Result.Y1 := Result.Y1 - MapHeightArea;
        Result.Y2 := Result.Y2 - MapHeightArea;
      end;
    padvUp:
      begin
        Result.Y1 := Result.Y1 + MapHeightArea;
        Result.Y2 := Result.Y2 + MapHeightArea;
      end;
  end;
end;

Procedure TEzMosaicView.GoAdvance( Advance: TEzPageAdvance );
var
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  Index, Recno: Integer;
begin
  Ent:= GetPreviewEntity(Layer,Recno);
  if Ent = Nil then Exit;
  try
    Index:= TEzPreviewEntity( Ent ).FileNo;
    if (Index < 0 ) or (Index > FParentView.GisList.Count - 1) then Exit;
    TEzPreviewEntity( Ent ).ProposedPrintArea := CurrentPrintArea( Ent, Advance );
    Layer.UpdateEntity( Recno, Ent );
    FParentView.Repaint;
  finally
    Ent.free;
  end;
end;

procedure TEzMosaicView.AddCurrentToPrintList;
var
  Curr: TEzRect;
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
  Recno: Integer;
begin
  Ent:= GetPreviewEntity(Layer,Recno);
  if Ent = Nil then Exit;
  try
    Curr:= CurrentPrintArea( Ent, padvNone );
    FX1List.Add( Curr.X1 );
    FY1List.Add( Curr.Y1 );
    FX2List.Add( Curr.X2 );
    FY2List.Add( Curr.Y2 );
    Refresh;
  finally
    Ent.free;
  end;
end;

procedure TEzMosaicView.ClearPrintList;
begin
  FX1List.Clear;
  FY1List.Clear;
  FX2List.Clear;
  FY2List.Clear;
  Refresh;
end;

Function TEzMosaicView.GetPreviewEntity(var Layer: TEzBaseLayer; var Recno: Integer) : TEzEntity;
var
  Ent: TEzEntity;
begin
  Ent:= Nil;
  { Search for first entity that is a preview entity }
  Layer:= FParentView.Gis.Layers[0];  // just one layer on the preview box
  Layer.First;
  while not Layer.Eof do
  begin
    try
      if Layer.RecIsDeleted then Continue;
      Ent:= Layer.RecLoadEntity;
      if Ent= Nil then Continue;
      if Ent is TEzPreviewEntity then
      begin
        Recno:= Layer.Recno;
        Break;
      end else Ent.Free;
    finally
      Layer.Next;
    end;
  end;
  Result:= Ent;
end;

Function TEzMosaicView.FindGis: TEzBaseGis;
var
  Ent: TEzEntity;
  Index: Integer;
  Layer: TEzBaseLayer;
  Recno: Integer;
begin
  Result:= Nil;
  if (FParentView = Nil) or (FParentView.Gis = Nil) Then Exit;
  Ent:= GetPreviewEntity(Layer,Recno);
  if Ent = Nil then Exit;
  try
    Index:= TEzPreviewEntity( Ent ).FileNo;
    if (Index < 0 ) or (Index > FParentView.GisList.Count - 1) then Exit;
    Result:= FParentView.GisList[Index].Gis;
  finally
    Ent.free;
  end;
end;

Procedure TEzMosaicView.UpdateViewport( WCRect: TEzRect );
Var
  TheCanvas: TCanvas;
  VisualWindow: TEzRect;
Begin
  //If Not Showing then Exit;

  { check if WCRect is bigger than current view area }
  VisualWindow := Grapher.CurrentParams.VisualWindow;
  if (WCRect.X1 < VisualWindow.X1) or (WCRect.Y1 < VisualWindow.Y1) or
     (WCRect.X2 > VisualWindow.X2) or (WCRect.Y2 > VisualWindow.Y2) then
  begin
    WCRect:= IntersectRect2D(WCRect, VisualWindow);
    if EqualRect2D(WCRect, NULL_EXTENSION) then Exit;
  end;

  Inherited UpdateViewport( WCRect );

  TheCanvas := Canvas;
  If odBitmap In OutputDevices Then
    TheCanvas := ScreenBitmap.Canvas;

  Gis:= FindGis;

  With TEzPainterObject.Create(Nil) Do
    Try
      DrawEntities( WCRect,
                    GIS,
                    TheCanvas,
                    Grapher,
                    Selection,
                    True,
                    False,
                    pmAll,
                    Self.ScreenBitmap );
    Finally
      Free;
    End;

End;

Procedure TEzMosaicView.SetParentView( Const Value: TEzPreviewBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FParentView ) then FParentView.RemoveFreeNotification( Self );
{$ENDIF}
  if Value <> Nil then
  begin
    Value.FreeNotification( Self );
    //Color := value.Color;
    RubberPen.Color := clRed;
    ScrollBars := ssNone;
    Cursor := crDefault;
    IsAerial := True;
  end;
  FParentView:= Value;
  if not (csDesigning in ComponentState) then
  begin
    Gis:= FindGis;
    If Gis <> Nil Then
      ZoomToExtension;
  end;
End;

procedure TEzMosaicView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FParentView ) Then
    FParentView := Nil;
end;

procedure TEzMosaicView.BeginRepaint;
begin
  FSavedDrawLimit:= Ez_Preferences.MinDrawLimit;
  Ez_Preferences.MinDrawLimit:= Ez_Preferences.AerialMinDrawLimit;
  inherited;
end;

procedure TEzMosaicView.EndRepaint;
begin
  Ez_Preferences.MinDrawLimit:= FSavedDrawLimit;
  inherited;
end;

end.

