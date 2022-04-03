Unit EzSystem;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, StdCtrls, Forms,
  EzBaseGIS, EzBase, EzBaseExpr, EzLib, EzEntities, IniFiles;

Const
  { mouse cursors used in the system }
  crZoomIn = 1;
  crZoomOut = 2;
  crScrollingUp = 3;
  crScrollingDn = 4;
  crRealTimeZoom = 5;
  crHidden = 6;
  crDrawCross = 7;
  { buffered read }                 
  SIZE_LONGBUFFER = 100 * 1024;

Type

  {-------------------------------------------------------------------------------}
  {                  TEzBufferedRead                                              }
  {-------------------------------------------------------------------------------}

  PCharArray = ^TCharArray;
  TCharArray = Array[0..0] Of Char;

  TEzBufferedRead = Class( TStream )
  Private
    FStream: TStream;
    FBytesInBuffer: Integer;
    FSectorInBuffer: Integer;
    FOffsetInBuffer: Integer;
    PBuffer: PCharArray;
    FSizeOfBuffer: Integer;
    FPosition: Integer; // internal position
  Public
    Constructor Create( F: TStream; BuffSize: Integer );
    Destructor Destroy; Override;
    Function Read( Var Buffer; Count: Longint ): Longint; Override;
    Function Seek( Offset: Longint; Origin: Word ): Longint; Override;
    Function Write( Const Buffer; Count: Longint ): Longint; Override;
    //procedure ResetPos;
  End;


  {------------------------------------------------------------------------------}
  {                  Miscelaneous                                                }
  {------------------------------------------------------------------------------}

Procedure EzGISError( Const ErrStr: String );
Procedure SortList( ol: TList );
Function GetTemporaryLayerName( Const Path, Prefix: String ): String;
Function GetTemporaryFileName( Const Prefix: String ): String;
Function WindowsDirectory: String;
Function SystemDirectory: String;
{$IFDEF FALSE}
Function DeleteFileWithUndo( Const sFileName: String ): boolean;
{$ENDIF}
Function AddSlash( Const Path: String ): String;
Function RemoveSlash( Const Path: String ): String;
Function CreateBitmapFromIcon( Icon: TIcon; BackColor: TColor ): TBitmap;
Function MessageToUser( Const Msg, Caption: String; AType: Word ): Word;
Function DelphiRunning: boolean;
Procedure AddMarker( DrawBox: TEzBaseDrawBox; Const X, Y: Double; SetInView: Boolean );
Function DeleteFileChecking( Const FileName: String ): Boolean;
function CombineSelection( DrawBox: TEzBaseDrawBox; DeleteOriginals: Boolean ): Integer;
Procedure ExplodeSelection( DrawBox: TEzBaseDrawBox; PreserveOriginals: Boolean );
Procedure ReadFile( Const Path: String; FileList: TStrings );
Procedure freelist( Var alist: TList );
Function GetListOfVectors( Entity: TEzEntity ): TList;
Function CreateIfNotExists( Const FileName: String ): TFileStream;
Function CreateDllList( FieldList: TStringList ): String;
Function HasAttr( Const FileName: String; Attr: Word ): Boolean;
Function DegMinSec2Extended( Const DegMinSec: TDegMinSec ): Double;
Function Extended2DegMinSec( Const RealDeg: Double ): TDegMinSec;
Procedure DeleteDuplicatedVertexes( Ent: TEzEntity );
Function LoadSingleSelEntity( DrawBox: TEzBaseDrawBox;
  Var Layer: TEzBaseLayer;
  Var Recno: Integer ): TEzEntity;
Procedure ShowGuideLines( DrawBox: TEzBaseDrawBox;
  HGuideLines, VGuideLines: TEzDoubleList );
Procedure SendToBack( DrawBox: TEzBaseDrawBox );
Procedure BringToFront( DrawBox: TEzBaseDrawBox );
Procedure PaintDrawBoxFSGrid( DrawBox: TEzBaseDrawBox; const WCRect: TEzRect );
function Dark(Col: TColor; Percent: Byte): TColor;
Function Perimeter( Vect: TEzVector; MustClose: Boolean ): Double;
Procedure BlinkEntity( DrawBox: TEzBaseDrawBox; Layer: TEzBaseLayer; RecNo: Integer );
Procedure BlinkEntityIndirect( DrawBox: TEzBaseDrawBox; Entity: TEzEntity );
Procedure BlinkEntities( DrawBox: TEzBaseDrawBox );
Procedure HiliteEntity( Entity: TEzEntity; DrawBox: TEzBaseDrawBox );
Procedure UnHiliteEntity( Entity: TEzEntity; DrawBox: TEzBaseDrawBox );
Function CreateBufferFromEntity( Entity: TEzEntity; CurvePoints: Integer; Distance: Double; EndArcs: Boolean): TEzEntity;
Function Field2Exprtype( Layer: TEzBaseLayer; FieldNo: Integer ): TExprtype;
procedure SaveFont(FStream: TIniFile; Section: string; smFont: TFont);
procedure LoadFont(FStream: TIniFile; Section: string; smFont: TFont);
Function Dpi2Units( iUnits: TEzScaleUnits; Dpis, Value: integer ): Double;
Function Units2Dpi( iUnits: TEzScaleUnits; Dpis: Integer; Value: Double ): integer;
Function Units2Inches( iUnits: TEzScaleUnits; Value: Double ): Double;
Function Inches2Units( iUnits: TEzScaleUnits; Value: Double ): Double;
Procedure EzWriteStrToStream( Const TextToWrite: String; stream: TStream );
Function EzReadStrFromStream( stream: TStream ): String;
Function StringIndex( Const SearchString: String; const StrList: Array Of String ): Integer;
Function GetCurrentColorDepth: Integer;
Procedure SaveFormPlacement( const IniFilename: string; Frm: TForm; Additional: TStrings);
Procedure RestoreFormPlacement( const IniFilename: string; Frm: TForm;
  ShwNormal: Boolean; Additional: TStrings );
Function RemoveStrDelim( Const S: String ): String;
function DeleteFilesSameName( const Filename: string ): Boolean;
Function AddBrackets( const Value: string): string;
Function ReadFloatFromIni( IniFile: TIniFile; Const Section, Ident: string; Const Default: Double): Double;
Function ReadIntFromIni( IniFile: TIniFile; Const Section, Ident: string; Default: Integer): Integer;
Procedure WriteFloatToIni( IniFile: TIniFile; Const Section, Ident: string; Value: Double);
Function GetValidLayerName( const OrigLayerName: string): string;
Function TrimCrLf(const s: string): string;
Function ComplColor(Clr: TColor):TColor;
Procedure GetMessageboxFont( afont: TFont );
Function DefaultFontName: string;
function DefaultFont: TFont;
Function DefaultFontHandle: HFont;
Function GetParentFormHWND( Control: TWinControl ): HWND;
Procedure HideFormTitleBar(Form: TForm);
Procedure ShowFormTitleBar(Form: TForm);

{$IFDEF LEVEL4}
{$IFNDEF LEVEL5}
Procedure FreeAndNil( Var Obj );
{$ENDIF}
{$ENDIF}

{ global variables }

Var
  Ez_Preferences: TEzPreferences; // ezbase
  Ez_Symbols: TEzSymbols; // ezbasegis
  Ez_VectorFonts: TEzVectorFonts; // ezentities
  Ez_LineTypes: TEzSymbols; // ezbasegis
  Ez_Hatches: TEzHatchList; // ezentities
  { this temporary entity is used in several situations }
  GlobalTempEntity: TEzEntity;

Implementation

Uses
  EzExprLex, EzExprYacc, EzLexLib, EzYaccLib, EzConsts, Ezpolyclip,
  EzGraphics, ezrtree;

{$IFDEF LEVEL4}
{$IFNDEF LEVEL5}

Procedure FreeAndNil( Var Obj );
Var
  P: TObject;
Begin
  P := TObject( Obj );
  TObject( Obj ) := Nil; // clear the reference before destroying the object
  P.Free;
End;
{$ENDIF}
{$ENDIF}

{This function will return the number of bits per pixel
 (8, 16, 24...) for the current desktop resolution }

Function GetCurrentColorDepth: Integer;
Var
  topDC: HDC;
Begin
  topDC := GetDC( 0 );
  Try
    Result := GetDeviceCaps( topDC, BITSPIXEL ) * GetDeviceCaps( topDC, PLANES );
  Finally
    ReleaseDC( 0, topDC );
  End;
End;

Function StringIndex( Const SearchString: String; const StrList: Array Of String ): Integer;
Var
  I: Integer;
Begin
  Result := -1;
  For I := 0 To High( StrList ) Do
    If CompareText( SearchString, StrList[I] ) = 0 Then
    Begin
      Result := I;
      Break;
    End;
End;

{-------------------------------------------------------------------------------}
{ End of section of expression evaluator                                        }
{-------------------------------------------------------------------------------}

Function Dpi2Units( iUnits: TEzScaleUnits; Dpis, Value: integer ): Double;
Begin
  result := Value / Dpis;
  If iUnits = suMms Then
    result := result * 25.4
  Else If iUnits = suCms Then
    result := result * 2.54;
End;

Function Units2Dpi( iUnits: TEzScaleUnits; Dpis: Integer; Value: Double ): integer;
Var
  u: Double;
Begin
  u := Value;
  If iUnits = suMms Then
    u := Value / 25.4
  Else If iUnits = suCms Then
    u := Value / 2.54;
  result := trunc( u * Dpis );
End;

Function Units2Inches( iUnits: TEzScaleUnits; Value: Double ): Double;
Begin
  result := Value;
  If iUnits = suMms Then
    result := result / 25.4
  Else If iUnits = suCms Then
    result := result / 2.54;
End;

Function Inches2Units( iUnits: TEzScaleUnits; Value: Double ): Double;
Begin
  result := Value;
  If iUnits = suMms Then
    result := result * 25.4
  Else If iUnits = suCms Then
    result := result * 2.54;
End;

{ Field2Exprtype }

Function Field2Exprtype( Layer: TEzBaseLayer; FieldNo: Integer ): TExprtype;
Begin
  Result := ttString;
  If Layer.DBTable = Nil Then Exit;

  Case Layer.DBTable.FieldType( FieldNo ) Of
    'C': Result := ttString;
    'N', 'F', 'T': Result := ttFloat;
    'D', 'I': Result := ttInteger;
    'L': Result := ttBoolean;
  End;
End;

{ CreateBufferFromEntity }

Function CreateBufferFromEntity( Entity: TEzEntity;
  CurvePoints: Integer;
  Distance: Double;
  EndArcs: Boolean ): TEzEntity;
Var
  TmpEnt, TmpPolygon, TmpArc1, TmpArc2: TEzEntity;
  subject, clipping, clipresult: TEzEntityList;
  RefLength, Scale: Double;
  p1, p2, pc, p1s, p2s, p1arc1, p2arc1, p1arc2, p2arc2: TEzPoint;
  I, J, part: Integer;
  Matrix: TEzMatrix;
Begin
  Result := Nil;
  If Entity.EntityID = idPlace Then
  Begin
    p1 := Entity.Points[0];
    Result := TEzEllipse.CreateEntity( Point2D( P1.X - Distance / 2,
      P1.Y - Distance / 2 ),
      Point2D( P1.X + Distance / 2, P1.Y + Distance / 2 ) );
  End
  Else
  If Entity.EntityID In
   [idPolyline,
    idPolygon,
    idSpline,
    idRectangle,
    idArc,
    idEllipse]
  Then
  Begin
    { now, for every entity, generate a polygon around it }
    subject := TEzEntityList.Create;
    clipping := TEzEntityList.Create;
    clipresult := TEzEntityList.Create;
    Try
      Try
        { transform every line segment into a polygon }
        For i := 0 To Entity.DrawPoints.Count - 2 Do
        Begin
          p1 := Entity.DrawPoints[i];
          p2 := Entity.DrawPoints[i + 1];
          { calculate the center of line segment }
          pc := Point2D( ( p1.x + p2.x ) / 2, ( p1.y + p2.y ) / 2 );
          { calculate a reference length for scaling }
          RefLength := Dist2D( pc, p1 );
          If RefLength = 0 Then
            RefLength := Distance;
          { now scale the line segment }
          Scale := 1 + ( Distance / 2 ) / RefLength;
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

          { now, create two arcs with these points calculated }
          TmpArc1 := TEzArc.CreateEntity( p1arc1, p1s, p2arc1 );
          TEzArc( TmpArc1 ).PointsInCurve := CurvePoints;
          TmpArc2 := TEzArc.CreateEntity( p1arc2, p2s, p2arc2 );
          TEzArc( TmpArc2 ).PointsInCurve := CurvePoints;
          Try
            { now, build the polygon points with this }
            TmpPolygon := TEzPolygon.CreateEntity( [Point2D( 0, 0 )] );
            With TmpPolygon.Points Do
            Begin
              Clear;
              if EndArcs then
              begin
                For J := 0 To TmpArc1.DrawPoints.Count - 1 Do
                  Add( TmpArc1.DrawPoints[J] );
              end
              else
              begin
                Add( TmpArc1.DrawPoints[0] );
                Add( TmpArc1.DrawPoints[TmpArc1.DrawPoints.Count - 1] );
              end;
              Add( p1arc2 );
              if EndArcs then
              begin
                For J := 0 To TmpArc2.DrawPoints.Count - 1 Do
                  Add( TmpArc2.DrawPoints[J] );
              end
              else
              begin
                Add( TmpArc2.DrawPoints[0] );
                Add( TmpArc2.DrawPoints[TmpArc2.DrawPoints.Count - 1] );
              end;
              Add( p1arc1 );
            End;
          Finally
            TmpArc1.Free;
            TmpArc2.Free;
          End;
          { it is the last line segment ?}
          If i = 0 Then
          Begin
            If Entity.DrawPoints.Count = 2 Then
            Begin
              clipresult.Add( TmpPolygon );
            End
            Else
              subject.Add( TmpPolygon );
          End
          Else
          Begin
            FreeAndNil( Clipping );
            clipping := TEzEntityList.Create;
            clipping.Add( TmpPolygon );
            Ezpolyclip.polygonClip( pcUNION, subject, clipping, clipresult, Nil );
            If i < Entity.DrawPoints.Count - 2 Then
            Begin
              FreeAndNil( subject );
              subject := TEzEntityList.Create;
              For j := 0 To clipresult.Count - 1 Do
                subject.Add( clipresult[j] );
              clipresult.ExtractAll;
            End;
          End;
        End;
        Result := TEzPolygon.CreateEntity( [Point2D( 0, 0 )] );
        Result.Points.Clear;
        part := 0;
        For I := 0 To clipresult.count - 1 Do
        Begin
          If I > 0 Then
          Begin
            If I = 1 Then
              Result.Points.Parts.Add( 0 );
            Result.Points.Parts.Add( part );
          End;
          TmpEnt := clipresult[I];
          For J := 0 To TmpEnt.Points.Count - 1 Do
          Begin
            Result.Points.Add( TmpEnt.Points[J] );
            Inc( part );
          End;
        End;
        With TEzPolygon( Result ) Do
        Begin
          If Entity Is TEzOpenedEntity Then
            Pentool.Assign( TEzOpenedEntity( Entity ).PenTool );
          If Entity Is TEzClosedEntity Then
            Brushtool.Assign( TEzClosedEntity( Entity ).BrushTool );
        End;
      Except
        MessageTouser( SWrongBuffer, smsgerror, MB_ICONERROR );
        Abort;
      End;
    Finally
      subject.free;
      clipping.free;
      clipresult.free;
    End;
  End
  Else
    EzGISError( SCannotCreateBuffer );
End;

{ LoadSingleSelEntity }

Function LoadSingleSelEntity( DrawBox: TEzBaseDrawBox; Var Layer: TEzBaseLayer;
  Var Recno: Integer ): TEzEntity;
Var
  SelLayer: TEzSelectionLayer;
Begin
  Result := Nil;
  If DrawBox.Selection.NumSelected <> 1 Then
    Exit;
  { Caller is responsible for freeing the TEzEntity result }
  With DrawBox Do
  Begin
    SelLayer := Selection.Items[0];
    Layer := SelLayer.Layer;
    Recno := SelLayer.SelList[0];
    Layer.Recno := Recno;
    Result := Layer.RecLoadEntity;
  End;
  //Result.DrawBox:= DrawBox;
End;

{ SendToBack }

Procedure SendToBack( DrawBox: TEzBaseDrawBox );
Var
  SelLayer: TEzSelectionLayer;
  Layer: TEzBaseLayer;
  FirstRecno: Integer;
Begin
  With DrawBox Do
  Begin
    If Selection.NumSelected <> 1 Then
      Exit;
    selLayer := Selection.Items[0];
    Layer := selLayer.Layer;
    if Layer.LayerInfo.Locked then Exit;
    FirstRecno := Layer.SendEntityToBack( SelLayer.SelList[0] );
    {select it}
    Selection.Clear;
    Selection.Add( Layer, FirstRecno );
    Repaint;
  End;
End;

{ BringToFront }

Procedure BringToFront( DrawBox: TEzBaseDrawBox );
Var
  SelLayer: TEzSelectionLayer;
  Layer: TEzBaseLayer;
  LastRecNo: Integer;
Begin
  With DrawBox Do
  Begin
    If Selection.NumSelected <> 1 Then Exit;
    selLayer := Selection.Items[0];
    Layer := selLayer.Layer;
    if Layer.LayerInfo.Locked then Exit;
    LastRecno := Layer.BringEntityToFront( SelLayer.SelList[0] );
    {select it}
    Selection.Clear;
    Selection.Add( Layer, LastRecno );
    Repaint;
  End;
End;

{ ShowGuideLines }

Procedure ShowGuideLines( DrawBox: TEzBaseDrawBox; HGuideLines, VGuideLines: TEzDoubleList );
Var
  I, orientation: Integer;
  X, Y, coord: Double;
  TmpPt1, TmpPt2: TPoint;

  Procedure DrawGuideLine( Canvas: TCanvas );
  Begin
    With DrawBox.Grapher Do
    Begin
      Case Orientation Of
        0:
          Begin
            Y := coord;
            With CurrentParams.VisualWindow Do
              If ( Y >= Emin.Y ) And ( Y <= Emax.Y ) Then
              Begin
                { dibuja la linea guia }
                TmpPt1 := RealToPoint( Point2D( Emin.X, Y ) );
                TmpPt2 := RealToPoint( Point2D( Emax.X, Y ) );
                With Canvas Do
                Begin
                  MoveTo( TmpPt1.X, TmpPt1.Y );
                  LineTo( TmpPt2.X, TmpPt2.Y );
                End;
              End;
          End;
        1:
          Begin
            X := coord;
            With CurrentParams.VisualWindow Do
              If ( X >= Emin.X ) And ( X <= Emax.X ) Then
              Begin
                RealToPoint( Point2D( Emin.X, Y ) );
                TmpPt1 := RealToPoint( Point2D( X, Emin.Y ) );
                TmpPt2 := RealToPoint( Point2D( X, Emax.Y ) );
                With Canvas Do
                Begin
                  MoveTo( TmpPt2.X, TmpPt2.Y );
                  LineTo( TmpPt1.X, TmpPt1.Y );
                End;
              End;
          End;
      End;
    End;
  End;

Begin
  If DrawBox.IsAerial Or
    (( HGuideLines.Count = 0 ) And ( VGuideLines.Count = 0 )) Then
    Exit;
  If ( odCanvas In DrawBox.OutputDevices ) Then
    With DrawBox {.ScreenBitmap} Do
    Begin
      DrawBox.grapher.SaveCanvas( Canvas );
      With Canvas Do
      Begin
        Brush.Style := bsClear;
        Pen.Mode := pmCopy;
        Pen.Color := clBlue;
        Pen.Width := 1;
        Pen.Style := psDot;
      End;
      orientation := 0;
      For I := 0 To HGuideLines.Count - 1 Do
      Begin
        coord := HGuideLines[I];
        DrawGuideLine( Canvas );
      End;
      orientation := 1;
      For I := 0 To VGuideLines.Count - 1 Do
      Begin
        coord := VGuideLines[I];
        DrawGuideLine( Canvas );
      End;
      DrawBox.grapher.RestoreCanvas( Canvas );
    End;
End;

{ PaintDrawBoxFSGrid }

Procedure PaintDrawBoxFSGrid( DrawBox: TEzBaseDrawBox; const WCRect: TEzRect );
Var
  X, Y, AX1, AY1, AX2, AY2: Double;
  DeltaX, DeltaY: Integer;
  p: TPoint;

Begin
  With DrawBox, DrawBox.ScreenBitmap.Canvas, WCRect Do
  Begin
    If ( ScreenGrid.Step.X <= 0 ) Or ( ScreenGrid.Step.Y <= 0 ) Then
      Exit;
    Pen.Color := ScreenGrid.Color;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    DeltaX := Abs( Grapher.RealToDistX( ScreenGrid.Step.X ) );
    DeltaY := Abs( Grapher.RealToDistY( ScreenGrid.Step.Y ) );
    If ( DeltaX < 8 ) Or ( DeltaY < 8 ) Then
      Exit;
    AX1 := Trunc( Emin.X / ScreenGrid.Step.X ) * ScreenGrid.Step.X;
    AY1 := Trunc( Emin.Y / ScreenGrid.Step.Y ) * ScreenGrid.Step.Y;
    AX2 := Emax.X;
    AY2 := Emax.Y;
    X := AX1;
    While X < AX2 Do
    Begin
      Y := AY1;
      While Y < AY2 Do
      Begin
        p := Grapher.RealToPoint( Point2D( X, Y ) );
        // the horz line
        MoveTo( 0, p.Y );
        LineTo( Width, p.Y );
        // the vert line
        MoveTo( p.X, 0 );
        LineTo( p.x, Height );
        Y := Y + ScreenGrid.Step.Y;
      End;
      X := X + ScreenGrid.Step.X;
    End;
  End;
End;

{ Perimeter }

Function Perimeter( Vect: TEzVector; MustClose: Boolean ): Double;
Var
  TmpPt1, TmpPt2: TEzPoint;
  Idx1, Idx2, n, np, cnt: integer;
Begin
  Result := 0;
  If ( Vect = Nil ) Or ( Vect.Count < 2 ) Then Exit;
  np := Vect.Parts.Count;
  n := 0;
  If np < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := Vect.Count - 1;
  End
  Else
  Begin
    Idx1 := Vect.Parts[n];
    Idx2 := Vect.Parts[n + 1] - 1;
  End;
  Repeat
    TmpPt1 := Vect[Idx1];
    For cnt := Idx1 + 1 To Idx2 Do
    Begin
      TmpPt2 := Vect[cnt];
      Result := Result + Dist2D( TmpPt1, TmpPt2 );
      TmpPt1 := TmpPt2;
    End;
    If MustClose Then
      Result := Result + Dist2D( Vect[Idx1], Vect[Idx2] );
    If np < 2 Then
      Break;
    Inc( n );
    If n >= np Then
      Break;
    Idx1 := Vect.Parts[n];
    If n < np - 1 Then
      Idx2 := Vect.Parts[n + 1] - 1
    Else
      Idx2 := Vect.Count - 1;
  Until false;
End;

{ BlinkEntityIndirect }

Procedure BlinkEntityIndirect( DrawBox: TEzBaseDrawBox; Entity: TEzEntity );
Var
  I: Integer;
Begin
  If ( Entity.EntityID = idNone ) Or
    Not Entity.IsVisible( DrawBox.Grapher.CurrentParams.VisualWindow ) Then Exit;

  For I := 1 To DrawBox.BlinkCount Do
  Begin
    HiliteEntity( Entity, DrawBox );
    Sleep( DrawBox.BlinkRate );
    UnHiliteEntity( Entity, DrawBox );
    Sleep( DrawBox.BlinkRate );
  End;
End;

{ BlinkEntity }

Procedure BlinkEntity( DrawBox: TEzBaseDrawBox; Layer: TEzBaseLayer; RecNo: Integer );
Var
  Entity: TEzEntity;
Begin
  Entity := Layer.LoadEntityWithRecNo( RecNo );
  If Entity = Nil Then Exit;
  Try
    BlinkEntityIndirect( DrawBox, Entity );
  Finally
    Entity.Free;
  End;
End;


Procedure HiliteEntity( Entity: TEzEntity; DrawBox: TEzBaseDrawBox );
Var
  TmpOD: TEzOutputDevices;
  TempEntity: TEzEntity;
  MustFree: Boolean;
Begin
  TempEntity := Nil;
  MustFree:= False;
  Try
    If ( Entity.EntityID In [idPlace, idNode, idPictureRef, idPersistBitmap,
      idBandsBitmap, idCustomPicture, idFittedVectText, idTable,
      idBlockInsert, idDimHorizontal, idDimVertical, idDimParallel] ) Then
    Begin
      With Entity.FBox Do
        TempEntity := TEzPolygon.CreateEntity( [Emin, Point2D( Emax.X, Emin.Y ),
                                                Emax, Point2D( Emin.X, Emax.Y ), Emin] );
      MustFree := true;
    End Else
      TempEntity:= Entity;

    With DrawBox Do
    Begin
      TmpOD:= OutputDevices;
      OutputDevices:= [odCanvas];
      DrawEntity( TempEntity, dmSelection );
      OutputDevices:= TmpOD;
    End;

  Finally
    If MustFree Then
      TempEntity.Free;
  End;
End;

Procedure UnHiliteEntity( Entity: TEzEntity; DrawBox: TEzBaseDrawBox );
Var
  TmpR: TRect;
Begin
  With DrawBox Do
  Begin
    TmpR:= Grapher.RealToRect( Entity.FBox );
    If Not Windows.IsRectEmpty(TmpR) Then
    Begin
      InflateRect(TmpR,2,2);
      Canvas.CopyRect(TmpR, ScreenBitmap.Canvas, TmpR );
    End;
  End;
End;

{ BlinkEntities }

Procedure BlinkEntities( DrawBox: TEzBaseDrawBox );
Var
  Entity: TEzEntity;
  I,J,L,S: Integer;
  Found: Boolean;
  Layer: TEzBaseLayer;
Begin

  Found:= False;
  { for every blink }
  For I := 1 To DrawBox.BlinkCount Do
  Begin
    { for every type of painting }
    for S:= 1 to 2 Do Begin

      { for every layer }
      For L:= 0 to DrawBox.GIS.Layers.Count-1 Do
      Begin
        Layer:= DrawBox.GIS.Layers[L];
        If Not Layer.LayerInfo.Visible Or Not Layer.HasBlinkers Then Continue;

        { for every entity on the layer marked for blinking }
        For J:= 0 to Layer.Blinkers.Count-1 Do
        Begin
          Entity:= Layer.LoadEntityWithRecNo(Layer.Blinkers[J]);
          If Entity= Nil Then Continue;

          If ( Entity.EntityID = idNone ) Or
            Not Entity.IsVisible( DrawBox.Grapher.CurrentParams.VisualWindow ) Then
          Begin
            Entity.Free;
            Continue;
          End;

          If S = 1 Then
          Begin
            HiliteEntity( Entity, DrawBox );
          End Else If S = 2 Then
          Begin
            UnHiliteEntity( Entity, DrawBox );
          End;
          Found:= True;
        End;
      End;

      If Not Found then Break;

      Sleep( DrawBox.BlinkRate );

    End;
    If Not Found then Break;
  End;
End;

procedure SaveFont(FStream: TIniFile; Section: string; smFont: TFont);
begin
  FStream.WriteString(Section, 'Font', smFont.Name + ',' +
                                       IntToStr(smFont.CharSet) + ',' +
                                       IntToStr(smFont.Color) + ',' +
                                       IntToStr(smFont.Size) + ',' +
                                       IntToStr(Byte(smFont.Style)));
end;

procedure LoadFont(FStream: TIniFile; Section: string; smFont: TFont);
var s, Data: string;
    i: Integer;
begin
  s := FStream.ReadString(Section, 'Font', ',,,,');
  try
    i := Pos(',', s);
    if i > 0 then
    begin
      {Name}
      Data := Trim(Copy(s, 1, i-1));
      if Data <> '' then
        smFont.Name := Data;
      Delete(s, 1, i);
      i := Pos(',', s);
      if i > 0 then
      begin
        {CharSet}
        Data := Trim(Copy(s, 1, i-1));
        if Data <> '' then
          smFont.Charset := TFontCharSet(StrToIntDef(Data, smFont.Charset));
        Delete(s, 1, i);
        i := Pos(',', s);
        if i > 0 then
        begin
          { Color }
          Data := Trim(Copy(s, 1, i-1));
          if Data <> '' then
            smFont.Color := TColor(StrToIntDef(Data, smFont.Color));
          Delete(s, 1, i);
          i := Pos(',', s);
          if i > 0 then
          begin
           {Size}
           Data := Trim(Copy(s, 1, i-1));
           if Data <> '' then
             smFont.Size := StrToIntDef(Data, smFont.Size);
           Delete(s, 1, i);
           {Style}
           Data := Trim(s);
           if Data <> '' then
             smFont.Style := TFontStyles(Byte(StrToIntDef(Data, Byte(smFont.Style))));
          end
        end
      end
    end;
  except
  end;
end;


{ DeleteDuplicatedVertexes }

Procedure DeleteDuplicatedVertexes( Ent: TEzEntity );
Var
  I: Integer;
  Found: Boolean;
Begin
  Repeat
    Found := False;
    For I := 0 To Ent.Points.Count - 2 Do
    Begin
      If EqualPoint2D( Ent.Points[I], Ent.Points[I + 1] ) Then
      Begin
        Ent.Points.Delete( I );
        Found := True;
        Break;
      End;
    End;
  Until Not Found;
End;

Function DegMinSec2Extended( Const DegMinSec: TDegMinSec ): Double;
Begin
  With DegMinSec Do
  Begin
    Result := ( Minutes * 60 + Seconds ) / 3600.0 + Abs( Degrees );
    If Degrees < 0 Then
      Result := -Result;
  End;
End;

Function Extended2DegMinSec( Const RealDeg: Double ): TDegMinSec;
Var
  Seconds, Working: Double;
Begin
  Working := Abs( RealDeg );
  Result.Degrees := Trunc( Working );
  Seconds := Frac( Working ) * 3600;
  Result.Minutes := Trunc( Seconds / 60 );
  Result.Seconds := Seconds - Result.Minutes * 60;
  If RealDeg < 0 Then
    Result.Degrees := -Result.Degrees;
End;

{-------------------------------------------------------------------------------}
{                  TEzBufferedRead - class implementation                         }
{-------------------------------------------------------------------------------}
{$WARNINGS OFF}

Constructor TEzBufferedRead.Create( F: TStream; BuffSize: integer );
Begin
  Inherited Create;

  FStream := F;
  If FStream.Size < BuffSize Then
    BuffSize := FStream.Size;
  FSizeOfBuffer := BuffSize;
  GetMem( PBuffer, FSizeOfBuffer );

  FSectorInBuffer := -1;

  Seek( F.Position, 0 );

End;

Destructor TEzBufferedRead.Destroy;
Begin
  FreeMem( PBuffer, FSizeOfBuffer );

  Inherited Destroy;
End;

{procedure TEzBufferedRead.ResetPos;
begin
  FSectorInBuffer := -1;
  FStream.Seek(FPosition,0);
end; }

Function TEzBufferedRead.Seek( Offset: Longint; Origin: Word ): Longint;
Var
  TmpSector: LongInt;
Begin
  //Origin:= soFromBeginning; allways
  TmpSector := Offset Div FSizeOfBuffer;
  If FSectorInBuffer = TmpSector Then
  Begin
    FOffsetInBuffer := Offset Mod FSizeOfBuffer;
    //Result := TmpSector * FSizeOfBuffer + FOffsetInBuffer;
    Exit;
  End;
  FStream.Seek( TmpSector * FSizeOfBuffer, 0 );
  FOffsetInBuffer := Offset Mod FSizeOfBuffer; // offset in current buffer
  FBytesInBuffer := FStream.Read( PBuffer^, FSizeOfBuffer );
  FPosition := FStream.Position;
  FSectorInBuffer := TmpSector;
  //Result := TmpSector * FSizeOfBuffer + FOffsetInBuffer;
End;

{$R-}
Function TEzBufferedRead.Read( Var Buffer; Count: Longint ): Longint;
Var
  LocalBuffer: PChar;
  BufSize, N: Integer;

  Function ReadNextBuffer: Boolean;
  Begin
    // read next buffer and return false if cannot
    FStream.Position := FPosition;
    FBytesInBuffer := FStream.Read( PBuffer^, FSizeOfBuffer );
    FPosition := FStream.Position;
    Inc( FSectorInBuffer );
    FOffsetInBuffer := 0;
    Result := ( FBytesInBuffer > 0 );
  End;

  Function DoRead( Var Buff; Cnt: Longint ): Longint;
  Var
    N, Diff: Longint;
    Temp: PChar;
  Begin
    If FOffsetInBuffer + Cnt <= FBytesInBuffer Then
    Begin
      // in the buffer is full data
      Move( PBuffer^[FOffsetInBuffer], Buff, Cnt );
      Inc( FOffsetInBuffer, Cnt );
      Result := Cnt;
    End
    Else
    Begin
      // in the buffer is partial data
      N := FBytesInBuffer - FOffsetInBuffer;
      Move( PBuffer^[FOffsetInBuffer], Buff, N );
      Result := N;
      If Not ReadNextBuffer Then Exit;
      Diff := Cnt - N;
      Temp := @Buff;
      Inc( Temp, N );
      Move( PBuffer^[FOffsetInBuffer], Temp^, Diff );
      Inc( FOffsetInBuffer, Diff );
      Inc( Result, Diff );
    End;
  End;

Begin
  Result := 0;
  If Count < 1 Then Exit;
  If Count > FSizeOfBuffer Then
  Begin
    LocalBuffer := @Buffer;
    BufSize := FSizeOfBuffer;
    While Count > 0 Do
    Begin
      If Count > BufSize Then
        N := BufSize
      Else
        N := Count;
      Inc( Result, DoRead( LocalBuffer^, N ) );
      Inc( LocalBuffer, N );
      Dec( Count, N );
    End;
  End
  Else
    Result := DoRead( Buffer, Count );
End;

Function TEzBufferedRead.Write( Const Buffer; Count: Longint ): Longint;
Begin
  { -- not implemented -- }
  Result := 0;
End;
{$WARNINGS ON}

Procedure SortList( ol: TList );

  Procedure QuickSort( L, R: Integer );
  Var
    I, J: Integer;
    P, T: TObject;
  Begin
    Repeat
      I := L;
      J := R;
      P := ol[( L + R ) Shr 1];
      Repeat
        While Longint( ol[I] ) < Longint( P ) Do
          Inc( I );
        While Longint( ol[J] ) > Longint( P ) Do
          Dec( J );
        If I <= J Then
        Begin
          T := ol[I];
          ol[I] := ol[J];
          ol[J] := T;
          Inc( I );
          Dec( J );
        End;
      Until I > J;
      If L < J Then
        QuickSort( L, J );
      L := I;
    Until I >= R;
  End;

Begin
  If ol.Count > 0 Then
    QuickSort( 0, ol.Count - 1 );
End;

Function DeleteFileChecking( Const FileName: String ): Boolean;
Begin
  Result := false;
  If FileExists( FileName ) Then
  Begin
    Try
      TFileStream.Create( FileName, fmOpenReadWrite Or fmShareExclusive ).Free;
    Except
      Exit;
    End;
    Result := SysUtils.DeleteFile( FileName );
  End;
End;

{Delete a file and send it to the trash can
 is not working correctly !!!}
{$IFDEF FALSE}

Function DeleteFileWithUndo( Const sFileName: String ): boolean;
Var
  fos: TSHFileOpStruct;
Begin
  FillChar( fos, SizeOf( fos ), 0 );
  With fos Do
  Begin
    wFunc := FO_DELETE;
    pFrom := PChar( sFileName );
    fFlags := FOF_ALLOWUNDO Or FOF_NOCONFIRMATION Or FOF_SILENT;
  End;
  Result := ( 0 = ShFileOperation( fos ) );
End;
{$ENDIF}

{ -- Create TBitmap object from TIcon -- }

Function CreateBitmapFromIcon( Icon: TIcon; BackColor: TColor ): TBitmap;
Var
  IWidth, IHeight: Integer;
Begin
  IWidth := Icon.Width;
  IHeight := Icon.Height;
  Result := TBitmap.Create;
  Try
    Result.Width := IWidth;
    Result.Height := IHeight;
    With Result.Canvas Do
    Begin
      Brush.Color := BackColor;
      FillRect( Rect( 0, 0, IWidth, IHeight ) );
      Draw( 0, 0, Icon );
    End;
  Except
    Result.Free;
    Raise;
  End;
End;

Function AddSlash( Const Path: String ): String;
Begin
  result := Path;
  If ( Length( result ) > 0 ) And ( result[length( result )] <> '\' ) Then
    result := result + '\'
End;

Function RemoveSlash( Const Path: String ): String;
Var
  rlen: integer;
Begin
  result := Path;
  rlen := length( result );
  If ( rlen > 0 ) And ( result[rlen] = '\' ) Then
    Delete( result, rlen, 1 );
End;

Function GetTemporaryLayerName( Const Path, Prefix: String ): String;
Var
  FileName: Array[0..1023] Of char;
Begin
  GetTempFileName( PChar( Path ), PChar( Prefix ), 0, FileName );
  result := FileName;
End;

Function GetTemporaryFileName( Const Prefix: String ): String;
Var
  TempPath: Array[0..1023] Of char;
  FileName: Array[0..1023] Of char;
Begin
  GetTempPath( 1023, TempPath );
  GetTempFileName( TempPath, PChar( Prefix ), 0, FileName );
  result := FileName;
End;

Function SystemDirectory: String;
Var
  buffer: Array[0..MAX_PATH] Of char;
Begin
  GetSystemDirectory( buffer, sizeof( buffer ) );
  result := AddSlash( StrPas( buffer ) );
End;

Const
  A2 = 'TAlignPalette';
  //A3 = 'TPropertyInspector';
  A4 = 'TAppBuilder';

Function DelphiRunning: boolean;
Var
  H2, {H3,} H4: Hwnd;
Begin
  H2 := FindWindow( A2, Nil );
  //H3 := FindWindow(A3, nil);
  H4 := FindWindow( A4, Nil );
  Result := ( H2 <> 0 ) {and (H3 <> 0)} And ( H4 <> 0 );
End;

{-------------------------------------------------------------------------}

Function WindowsDirectory: String;
Var
  buffer: Array[0..MAX_PATH] Of char;
Begin
  GetWindowsDirectory( buffer, SizeOf( buffer ) );
  result := AddSlash( StrPas( buffer ) );
End;

Function MessageToUser( Const Msg, Caption: String; AType: Word ): Word;
Begin
  Result := Application.Messagebox( pchar( Msg ), pchar( Caption ), MB_OK Or AType );
End;

Procedure SetupCursors;
Begin
  With Screen Do          
  Begin
    Cursors[crZoomIn] := Windows.LoadCursor( HInstance, 'ZOOMIN' );
    Cursors[crZoomOut] := LoadCursor( HInstance, 'ZOOMOUT' );
    Cursors[crScrollingUp] := LoadCursor( HInstance, 'SCROLLING_UP' );
    Cursors[crScrollingDn] := LoadCursor( HInstance, 'SCROLLING_DN' );
    Cursors[crRealTimeZoom] := LoadCursor( HInstance, 'REALTIMEZ' );
    Cursors[crHidden] := LoadCursor( HInstance, 'CR_HIDDEN' );
    Cursors[crDrawCross] := LoadCursor( HInstance, 'DRAW_CROSS' );
  End;
End;

Procedure DisposeCursors;
Begin
  With Screen Do
  Begin
    Cursors[crZoomIn] := 0;
    Cursors[crZoomOut] := 0;
    Cursors[crScrollingUp] := 0;
    Cursors[crScrollingDn] := 0;
    Cursors[crRealTimeZoom] := 0;
    Cursors[crHidden] := 0;
    Cursors[crDrawCross] := 0;
  End
End;

Procedure AddMarker( DrawBox: TEzBaseDrawBox; Const X, Y: Double; SetInView: Boolean );
Var
  TmpPlace: TEzPlace;
  Extents: TEzRect;
  CX, CY, TmpWidth, TmpHeight, TmpMarginX, TmpMarginY: Double;
Begin
  With DrawBox, Ez_Preferences Do
  Begin
    If Ez_Symbols.Count = 0 Then Exit;

    TmpPlace := TEzPlace.CreateEntity( Point2D( X, Y ) );
    With TmpPlace.Symboltool.FSymbolStyle Do
    Begin
      If SymbolMarker > Ez_Symbols.Count - 1 Then
        SymbolMarker := 0;
      Index := SymbolMarker;
      Height := Grapher.getrealsize( DefSymbolStyle.height );
      TmpPlace.UpdateExtension;
      TempEntities.Add( TmpPlace );
    End;
    If Not SetInView Then Exit;
    TmpPlace.UpdateExtension;
    Extents := TmpPlace.FBox;
    With Extents Do
    Begin
      CX := ( Emin.X + EMax.X ) / 2;
      CY := ( Emin.Y + EMax.Y ) / 2;
    End;
    With Grapher.CurrentParams.VisualWindow Do
    Begin
      TmpWidth := ( Emax.X - Emin.X ) / 2;
      TmpHeight := ( Emax.Y - Emin.Y ) / 2;
    End;
    TmpMarginX := 0;
    TmpMarginY := 0;
    With Extents Do
    Begin
      Emin.X := CX - TmpWidth - TmpMarginX;
      Emax.X := CX + TmpWidth + TmpMarginX;
      Emin.Y := CY - TmpHeight - TmpMarginY;
      Emax.Y := CY + TmpHeight + TmpMarginY;
    End;
    Grapher.SetViewTo( Extents );
    Repaint;
  End;
End;

{ freelist }

Procedure freelist( Var alist: TList );
Var
  i: Integer;
Begin
  If alist = Nil Then Exit;
  For i := 0 To alist.count - 1 Do
  if alist[i] <> nil then
    TObject( alist[i] ).free;
  FreeAndNil( alist );
End;

{ GetListOfVectors }

Function GetListOfVectors( Entity: TEzEntity ): TList;
Var
  I, n, Idx1, Idx2: Integer;
  V, SrcV: TEzVector;
Begin
  If Entity.EntityID In [idPolyline, idPolygon] Then
    SrcV := Entity.Points
  Else
    SrcV := Entity.DrawPoints;
  Result := TList.Create;
  n := 0;
  If SrcV.Parts.Count < 2 Then
  Begin
    Idx1 := 0;
    Idx2 := SrcV.Count - 1;
  End
  Else
  Begin
    Idx1 := SrcV.Parts[n];
    Idx2 := SrcV.Parts[n + 1] - 1;
  End;
  Repeat
    V := TEzVector.Create( Succ( Idx2 - Idx1 ) );
    For I := Idx1 To Idx2 Do
      V.Add( SrcV[I] );
    Result.Add( V );
    If SrcV.Parts.Count < 2 Then
      Break;
    Inc( n );
    If n >= SrcV.Parts.Count Then
      Break;
    Idx1 := SrcV.Parts[n];
    If n < SrcV.Parts.Count - 1 Then
      Idx2 := SrcV.Parts[n + 1] - 1
    Else
      Idx2 := SrcV.Count - 1;
  Until false;
  //
  if Assigned(Result) then
    for I := Result.Count - 1 downto 0 do
    begin
      V := Result[I];
      if V.Count = 0 then
      begin
        Result.Delete(I);
        FreeAndNil(V);
      end;
    end;
End;

{ ExplodeSelection }

Procedure ExplodeSelection( DrawBox: TEzBaseDrawBox; PreserveOriginals: Boolean );
Var
  Idx, J, K, NewRecno: Integer;
  TmpEnt, TmpEnt2: TEzEntity;
  TempL: TList;
  Cnt: TEzEntityID;
  Entities: Array[TEzEntityID] Of TEzEntity;
  AvoidList: TIntegerList;
Begin
  With DrawBox Do
  Begin
    For Cnt := Low( TEzEntityID ) To High( TEzEntityID ) Do
      Entities[Cnt] := GetClassFromID( Cnt ).Create( 4 );
    AvoidList := TIntegerList.Create;
    Try
      For Idx := 0 To Selection.Count - 1 Do
      Begin
        With Selection.Items[Idx] Do
        Begin { TEzSelectionLayer }
          AvoidList.Clear;
          For K := 0 To SelList.Count - 1 Do
          Begin
            TmpEnt := Layer.LoadEntityWithRecno( SelList[K] );
            If TmpEnt.Points.Parts.Count > 1 Then
            Begin
              TempL := GetListOfVectors( TmpEnt );
              For J := 0 To TempL.Count - 1 Do
              Begin
                TmpEnt2 := Entities[TmpEnt.EntityID];
                TmpEnt2.Assign( TmpEnt );
                TmpEnt2.Points.Clear;
                TmpEnt2.Points.Assign( TEzVector( TempL[J] ) );
                { Add this entity to the layer }
                NewRecno := Layer.AddEntity( TmpEnt2 );
                { now copy the DBF record }
                If Layer.DBTable <> Nil Then
                  Layer.CopyRecord( K, NewRecno );
              End;
              freelist( TempL );
            End
            Else
              AvoidList.Add( SelList[K] );
            TmpEnt.Free;
          End;
          For K := 0 To AvoidList.Count - 1 Do
            Delete( AvoidList[K] );
        End;
      End;
      If Not PreserveOriginals Then
        DeleteSelection;
    Finally
      For Cnt := Low( TEzEntityID ) To High( TEzEntityID ) Do
        Entities[Cnt].Free;
      AvoidList.Free;
    End;
  End;
End;

{ CombineSelection }

function CombineSelection( DrawBox: TEzBaseDrawBox; DeleteOriginals: Boolean ): Integer;
Var
  Combined, TmpEnt: TEzEntity;
  I, K, n, Idx, cnt, NewRecno,
    SourceRecnoClosed, SourceRecnoOpened: Integer;
  TempL, LayerListClosed, LayerListOpened,
    ListClosed, ListOpened: TList;
  SourceLayerOpened,
    SourceLayerClosed: TEzBaseLayer;
  IsSame: Boolean;
  V: TEzVector;
  { subject, clipping, result: TList; }
  AvoidList: TIntegerList;

Begin
  Result := -1;
  { Combine all open entities
     (TLine2D, TEzPolyline, TEzArc, TSpline2D) into one single entity }
  { Count all open entities }
  With DrawBox Do
  Begin
    If Selection.Count = 0 Then Exit;
    ListClosed := TList.Create;
    ListOpened := TList.Create;
    LayerListClosed := TList.Create;
    LayerListOpened := TList.Create;
    SourceLayerClosed := Nil;
    SourceLayerOpened := Nil;
    SourceRecNoClosed := 0;
    SourceRecNoOpened := 0;
    AvoidList := TIntegerList.Create;
    Try
      For cnt := 0 To Selection.Count - 1 Do
      Begin
        With Selection.Items[cnt] Do
        Begin { TEzSelectionLayer }
          AvoidList.Clear;
          For K := 0 To SelList.Count - 1 Do
          Begin
            TmpEnt := Layer.LoadEntityWithRecno( SelList[K] );
            If TmpEnt <> Nil Then
            Begin
              If TmpEnt.IsClosed Then
              Begin
                TempL := GetListOfVectors( TmpEnt );
                For I := 0 To TempL.Count - 1 Do
                  ListClosed.Add( TEzVector( TempL[I] ) );
                TempL.Free;
                LayerListClosed.Add( Layer );
                If SourceLayerClosed = Nil Then
                Begin
                  SourceLayerClosed := Layer;
                  SourceRecnoClosed := K;
                End;
              End
              Else
              Begin
                TempL := GetListOfVectors( TmpEnt );
                For I := 0 To TempL.Count - 1 Do
                  ListOpened.Add( TEzVector( TempL[I] ) );
                TempL.Free;
                LayerListOpened.Add( Layer );
                If ( SourceLayerOpened = Nil ) Then
                Begin
                  SourceLayerOpened := Layer;
                  SourceRecnoOpened := K;
                End;
              End;
              TmpEnt.Free;
            End
            Else
              AvoidList.add( SelList[K] );
          End;
          For K := 0 To AvoidList.Count - 1 Do
            Delete( AvoidList[K] );
        End;
      End;
      If ListOpened.Count > 1 Then
      Begin
        (* combine them *)
        Combined := TEzPolyLine.CreateEntity( [Point2D( 0, 0 )] );
        Try
          Idx := 0;
          Combined.Points.Clear;
          For cnt := 0 To ListOpened.Count - 1 Do
          Begin
            V := TEzVector( ListOpened[cnt] );
            {if cnt=0 then
              firstccw:= EzLib.IsCounterClockWise(V)
            else
            begin
              if not (EzLib.IsCounterClockWise(V)=firstccw) then
              begin
                // revert direction to same
                V.RevertDirection;
              end;
            end; }
            n := V.Count;
            Combined.Points.Parts.Add( Idx );
            For K := 0 To n - 1 Do
              Combined.Points.Add( V[K] );
            Inc( Idx, n );
          End;
          If Combined.Points.Parts.Count = 1 Then
            Combined.Points.Parts.Clear;
          (* Now save this entity to the original layer or to the current layer
             if not possible *)
          IsSame := True;
          For K := 1 To LayerListOpened.Count - 1 Do
            // all selected are of same layer ?
            If TEzBaseLayer( LayerListOpened[K] ) <> TEzBaseLayer( LayerListOpened[0] ) Then
            Begin
              IsSame := False;
              Break;
            End;
          If IsSame Then
          Begin
            NewRecno := TEzBaseLayer( LayerListOpened[0] ).AddEntity( Combined );
            SourceLayerOpened.CopyRecord( SourceRecNoOpened, NewRecno );
            Result := NewRecNo;
          End
          Else
            Result := DrawBox.AddEntity( GIS.CurrentLayerName, Combined );
        Finally
          Combined.Free;
        End;
      End;

      If ListClosed.Count > 1 Then
      Begin
        // combine them
        Combined := TEzPolygon.CreateEntity( [Point2D( 0, 0 )] );
        Try
          Idx := 0;
          Combined.Points.Clear;
          For cnt := 0 To ListClosed.Count - 1 Do
          Begin
            V := TEzVector( ListClosed[cnt] );
            n := V.Count;
            Combined.Points.Parts.Add( Idx );
            For K := 0 To n - 1 Do
              Combined.Points.Add( V[K] );
            Inc( Idx, n );
          End;
          If Combined.Points.Parts.Count = 1 Then
            Combined.Points.Parts.Clear;
          (* Now save this entity to the original layer or to the current layer
             if not possible *)
          IsSame := True;
          For k := 1 To LayerListClosed.Count - 1 Do
            // all selected are of same layer ?
            If TEzBaseLayer( LayerListClosed[k] ) <> TEzBaseLayer( LayerListClosed[0] ) Then
            Begin
              IsSame := False;
              Break;
            End;
          If IsSame Then
          Begin
            NewRecno := TEzBaseLayer( LayerListClosed[0] ).AddEntity( Combined );
            SourceLayerClosed.CopyRecord( SourceRecNoClosed, NewRecno );
            Result := NewRecno;
          End
          Else
            Result := DrawBox.AddEntity( GIS.CurrentLayerName, Combined );
        Finally
          Combined.Free;
        End;
      End;
      If ( ListOpened.Count > 1 ) Or ( ListClosed.Count > 1 ) And DeleteOriginals Then
        DeleteSelection;
    Finally
      If ( ListClosed <> Nil ) Then
        freelist( ListClosed );
      If ( ListOpened <> Nil ) Then
        freelist( ListOpened );
      LayerListClosed.Free;
      LayerListOpened.Free;
      AvoidList.free;
    End;
  End;

End;

Function CreateDllList( FieldList: TStringList ): String;
Var
  i: integer;
Begin
  Result := '';
  For i := 0 To pred( FieldList.Count ) Do
    Result := Result + FieldList[i] + '\';
End;

{---------------------------------------------------------------------}

Procedure ReadFile( Const Path: String; FileList: TStrings );
Var
  SearchRec: TSearchRec;
  FindResult: integer;
Begin
  FileList.Clear;
  Try
    FindResult := FindFirst( Path, faAnyFile, SearchRec );
    While FindResult = 0 Do
    Begin
      FileList.Add( SearchRec.Name );
      FindResult := FindNext( SearchRec );
    End;
  Finally
    SysUtils.FindClose( SearchRec );
  End;
End;

Function CreateIfNotExists( Const FileName: String ): TFileStream;
Begin
  If FileExists( FileName ) Then
    Result := TFileStream.Create( FileName, fmOpenReadWrite Or fmShareDenyNone )
  Else
    Result := TFileStream.Create( FileName, fmCreate );
End;

Procedure EzGISError( Const ErrStr: String );
Begin
//  Raise Exception.Create( ErrStr );
End;

Function HasAttr( Const FileName: String; Attr: Word ): Boolean;
Var
  FileAttr: Integer;
Begin
  FileAttr := FileGetAttr( FileName );
  If FileAttr = -1 Then
    FileAttr := 0;
  Result := ( FileAttr And Attr ) = Attr;
End;

Procedure EzWriteStrToStream( Const TextToWrite: String; stream: TStream );
Var
  n: Integer;
Begin
  n := Length( TextToWrite );
  stream.write( n, sizeof( Integer ) );
  If n > 0 Then
    stream.write( TextToWrite[1], n );
End;

Function EzReadStrFromStream( stream: TStream ): String;
Var
  n: Integer;
Begin
  stream.Read( n, sizeof( Integer ) );
  If n > 0 Then
  Begin
    SetLength( Result, n );
    stream.Read( Result[1], n );
  End
  Else
    Result := '';
End;


Function WritePrivateProfileInt( Const Section, Entry: String;
  iToWrite: word; Const FileName: String ): BOOL;
Var
  Work: String;
Begin
  Work := format( '%.6d', [iToWrite] );
  WritePrivateProfileInt :=
    WritePrivateProfileString( PChar( Section ), PChar( Entry ), PChar( Work ),
    PChar( FileName ) );
End;

Procedure RestoreFormPlacement( const IniFileName: string;
  Frm: TForm; ShwNormal: Boolean; Additional: TStrings );
Var
  I,n: Integer;
  wpPos: TWINDOWPLACEMENT;
  ptPos: TPOINT;
  rcPos: TRECT;
  //hWindow: HWND;
  SectionName: String;
  SetMin: boolean;
  Inifile: TInifile;
Begin
  //hWindow := Frm.Handle;
  SectionName := Frm.Name;
  SetMin := false;

  wpPos.length := sizeof( wpPos );

  (* Flag to restore minimized position *)
  If SetMin Then
    wpPos.flags := WPF_SETMINPOSITION
  Else
    wpPos.flags := 0;
  Inifile:= TIniFile.Create( IniFileName );
  With Inifile Do
  Try
    ptPos.x := ReadIntFromIni( Inifile, SectionName, 'MinX', -65535 );
    If ptPos.x = -65535 Then
      Exit; // the record not yet exists

    (* Get window state (max, min or restored) *)
    wpPos.showCmd := ReadIntFromIni( Inifile, SectionName, 'ShowCmd', SW_SHOWNORMAL );

    (* Minimized position *)
    ptPos.x := ReadIntFromIni( Inifile, SectionName, 'MinX', -1 );
    ptPos.y := ReadIntFromIni( Inifile, SectionName, 'MinY', -1 );
    If ( ( ptPos.x = -1 ) Or ( ptPos.y = -1 ) ) Then
      wpPos.flags := 0;
    wpPos.ptMinPosition := ptPos;

    (* Maximized position *)
    ptPos.x := ReadIntFromIni( Inifile, SectionName, 'MaxX', 0 );
    ptPos.y := ReadIntFromIni( Inifile, SectionName, 'MaxY', 0 );
    wpPos.ptMaxPosition := ptPos;

    (* Window position and size *)
    rcPos.top := ReadIntFromIni( Inifile, SectionName, 'Top', GetSystemMetrics( SM_CYSCREEN ) Div 8 );
    rcPos.left := ReadIntFromIni( Inifile, SectionName, 'Left', GetSystemMetrics( SM_CXSCREEN ) Div 8 );
    If true{wpPos.flags <> 0} Then
    Begin
      rcPos.bottom := ReadIntFromIni( Inifile, SectionName, 'Bottom', rcPos.top * 7 );
      rcPos.right := ReadIntFromIni( Inifile, SectionName, 'Right', rcPos.left * 7 );
    End
    Else
    Begin
      rcPos.Bottom := rcpos.Top + frm.Height;
      rcPos.Right := rcpos.Left + frm.Width;
    End;
    if Additional <> Nil then
    begin
      Additional.Clear;
      n:= ReadIntFromIni( Inifile, SectionName + 'AddInfo', 'Lines',0);
      for I:= 0 to n-1 do
        Additional.Add( ReadString( SectionName + 'AddInfo', 'Line' + IntToStr(I), '' ) );
    end;
  Finally
    Free;
  End;

  wpPos.rcNormalPosition := rcPos;

  (* Restore everything *)
  {If ShwNormal And ( Frm.BorderStyle In [bsSizeable, bsSizeToolWin] ) Then
    SetWindowPlacement( hWindow, @wpPos )
  Else }
    With rcPos Do
    Begin
      Frm.Top := Top;
      Frm.Left := Left;
      If Frm.BorderStyle In [bsSizeable, bsSizeToolWin] Then
      Begin
        Frm.Width := ( Right - Left );
        Frm.Height := ( Bottom - Top );
      End;
      If wpPos.showCmd = SW_SHOWMAXIMIZED Then
        Frm.WindowState := wsMaximized
      Else If wpPos.showCmd = SW_SHOWMINIMIZED Then
        Frm.WindowState := wsMinimized
      Else
        Frm.WindowState := wsNormal;
    End;
End;

Procedure SaveFormPlacement( const IniFilename: string; Frm: TForm;
  Additional: TStrings );
Var
  I,n: Integer;
  wpPos: TWINDOWPLACEMENT;
  ptPos: TPOINT;
  rcPos: TRECT;
  hWindow: HWND;
  SectionName: String;
Begin
  hWindow := Frm.Handle;
  SectionName := Frm.Name;

  wpPos.length := sizeof( wpPos );

  (* Save everything *)
  GetWindowPlacement( hWindow, @wpPos );

  With TInifile.Create( IniFileName ) Do
  Try
    (* Save current window state (maximized, minimized or restored) *)
    WriteInteger( SectionName, 'ShowCmd', wpPos.showCmd );

    (* Save Minimized position *)
    ptPos := wpPos.ptMinPosition;
    WriteInteger( SectionName, 'MinX', ptPos.x );
    WriteInteger( SectionName, 'MinY', ptPos.y );

    (* Save Maximized position *)
    ptPos := wpPos.ptMaxPosition;
    WriteInteger( SectionName, 'MaxX', ptPos.x );
    WriteInteger( SectionName, 'MaxY', ptPos.y );

    rcPos := wpPos.rcNormalPosition;
    WriteInteger( SectionName, 'Top', rcPos.top );
    WriteInteger( SectionName, 'Left', rcPos.left );
    WriteInteger( SectionName, 'Bottom', rcPos.bottom );
    WriteInteger( SectionName, 'Right', rcPos.right );
    if Additional <> Nil then
    begin
      n:= Additional.Count;
      WriteInteger( SectionName + 'AddInfo', 'Lines',n );
      for I:= 0 to n-1 do
        WriteString( SectionName + 'AddInfo', 'Line' + IntToStr(I), Additional[I] );
    end;
  Finally
    free;
  End;

End;

const
  SQUOTE = ['''', '"'];

Function RemoveStrDelim( Const S: String ): String;
Begin
  If ( Length( S ) >= 2 ) And
     ( S[1] In SQUOTE ) And ( S[Length( S )] In SQUOTE ) Then
    Result := Copy( S, 2, Length( S ) - 2 )
  Else
    Result := S;
End;

Function AddBrackets( const Value: string ): string;
Begin
  if AnsiPos(#32, Value) > 0 then
    Result:= '[' + Value + ']'
  else
    Result:= Value;
End;

function DeleteFilesSameName( const Filename: string ): Boolean;
Var
  layname: String;
  SR: TSearchRec;
  Found: Integer;
  source: String;
Begin
  Result := True;
  layname := ChangeFileExt( FileName, '' );
  source := ExtractFilepath( FileName );
  // Remove the files in the directory
  Found := FindFirst( layname + '.*', faAnyFile, SR );
  Try
    While Result And ( Found = 0 ) Do
    Begin
      If ( SR.Name <> '.' ) And ( SR.Name <> '..' ) Then
      Begin
        // Remove attributes that could prevent us from deleting the file
        FileSetAttr( source + SR.Name, FileGetAttr( source + SR.Name ) And
          Not ( $00000001 Or $00000002 ) );
        // Delete file
        If Not SysUtils.DeleteFile( source + SR.Name ) Then
          Result := False;
      End;
      Found := FindNext( SR );
    End;
  Finally
    Sysutils.FindClose( SR );
  End;
  Result := true;
end;

Function ReadFloatFromIni( IniFile: TIniFile; Const Section, Ident: string; Const Default: Double): Double;
var
  temp: string;
  Code: Integer;
begin
  System.Str(Default:32:16,temp);
  temp:= Inifile.ReadString( Section, Ident, trim(temp) );
  System.Val( temp, Result, Code );
  If Code <> 0 then Result:= 0;
  If Abs(Result) < 1E-10 then Result:= 0;
end;

Procedure WriteFloatToIni( IniFile: TIniFile; Const Section, Ident: string; Value: Double);
var
  temp: string;
begin
  if Abs(Value) < 1E-10 then Value:= 0;
  System.Str(Value:32:16,temp);
  Inifile.WriteString( Section, Ident, trim(temp) );
end;

Function ReadIntFromIni( IniFile: TIniFile; Const Section, Ident: string; Default: Integer): Integer;
var
  temp: string;
  Code: Integer;
begin
  temp:= Inifile.ReadString( Section, Ident, IntToStr( Default ) );
  Val( temp, Result, Code );
  If Code <> 0 then Result:= 0;
end;

Function GetValidLayerName( const OrigLayerName: string): string;
Var
  I: Integer;
  Found: Boolean;
begin
  Result:= OrigLayerName;
  If (Length(Result) > 0) And Not( Result[1] In ['A'..'Z', 'a'..'z', #127..#255, '_'] ) Then
    Result[1]:= '_';
  repeat
    Found:= false;
    For I:= 1 to Length(Result) do
    begin
      If Not( Result[I] In ['A'..'Z', 'a'..'z', '0'..'9', '_', #127..#255] ) Then
      begin
        Found:= true;
        Break;
      end;
    end;
    if Found then
    begin
      Result := StringReplace( Result, Result[I], '_', [rfReplaceAll, rfIgnoreCase] );
    end;
  until not found;
end;

function TrimCrLf(const s: string): string;
begin
  Result:= s;
  While (Length(Result) > 0) and (Result[Length(Result)] in [#13,#10]) do
    System.Delete(Result, Length(Result), 1);
end;

Function ComplColor(Clr: TColor):TColor;
var
  r,g,b: Byte;
Begin
  r:= GetRValue(clr);
  g:= GetGValue(clr);
  b:= GetBValue(clr);
  Result:= RGB(255-r,255-g,255-b);
End;

function Dark(Col: TColor; Percent: Byte): TColor;
var
  R, G, B: Byte;
begin
  R := GetRValue(Col);
  G := GetGValue(Col);
  B := GetBValue(Col);
  R := Round(R*Percent/100);
  G := Round(G*Percent/100);
  B := Round(B*Percent/100);
  Result := RGB(R, G, B);
end;

function Light(Col: TColor; Percent: Byte): TColor;
var R, G, B: Byte;
begin
  R := GetRValue(Col);
  G := GetGValue(Col);
  B := GetBValue(Col);
  R := Round(R*Percent/100) + Round(255 - Percent/100*255);
  G := Round(G*Percent/100) + Round(255 - Percent/100*255);
  B := Round(B*Percent/100) + Round(255 - Percent/100*255);
  Result := RGB(R, G, B);
end;

Function DefaultFontHandle: HFont;
var
  ncMetrics: TNonClientMetrics;
begin
  ncMetrics.cbSize := sizeof(TNonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS,
                       sizeof(TNonClientMetrics),
                       @ncMetrics, 0);
  Result:= CreateFontIndirect(ncMetrics.lfMessageFont);
End;

Procedure GetMessageboxFont( afont: TFont );
begin
  assert(assigned(afont));
  afont.Handle  := DefaultFontHandle;
end;

function DefaultFont: TFont;
Begin
  Result := TFont.Create;
  GetMessageboxFont(Result);
End;

Function DefaultFontName: string;
var
  aFont: TFont;
Begin
  aFont:= DefaultFont;
  try
    Result:= aFont.Name;
  finally
    aFont.free;
  end;
end;

Function GetParentFormHWND( Control: TWinControl ): HWND;
begin
{$IFDEF GEN_ACTIVEX}
  Result := Windows.GetParent( Control.Handle );
{$ELSE}
  Result := GetParentForm( Control ).Handle;
{$ENDIF}
end;

Procedure ShowFormTitlebar(Form: TForm);
Var
  Save : LongInt;
begin
  with Form do
  begin
    If BorderStyle=bsNone then Exit;
    Save:=GetWindowLong(Handle,gwl_Style);
    If (Save and ws_Caption)<>ws_Caption then Begin
      Case BorderStyle of
        bsSingle,
        bsSizeable : SetWindowLong(Handle,gwl_Style,Save or
          ws_Caption or ws_border);
        bsDialog : SetWindowLong(Handle,gwl_Style,Save or
          ws_Caption or ds_modalframe or ws_dlgframe);
      End;
      Height:=Height+getSystemMetrics(sm_cyCaption);
      Refresh;
    End;
  end;
end;

Procedure HideFormTitlebar(Form: TForm);
Var
  Save : LongInt;
Begin
  with Form do
  begin
    If BorderStyle=bsNone then Exit;
    Save:=GetWindowLong(Handle,gwl_Style);
    If (Save and ws_Caption)=ws_Caption then Begin
      Case BorderStyle of
        bsSingle,
        bsSizeable : SetWindowLong(Handle,gwl_Style,Save and
          (Not(ws_Caption)) or ws_border);
        bsDialog : SetWindowLong(Handle,gwl_Style,Save and
          (Not(ws_Caption)) or ds_modalframe or ws_dlgframe);
      End;
      Height:=Height-getSystemMetrics(sm_cyCaption);
      Refresh;
    End;
  end;
end;


{PaintTo draw the visible client area of a RichEdit control to the
TCanvas. Use following method to render the complete contents to your
TCanvas.

DestDCHandle is TCanvas.Handle, R is the Rect with relation to your
canvas, RichEdit is a TRichEdit-Instance (can be invisible),
PixelsPerInch is the Resolution (for Screen e.g. 96).}
{$IFDEF FALSE}
procedure DrawRTF(DestDCHandle: HDC; const R: TRect;
  RichEdit: TRichEdit; PixelsPerInch: Integer);
var
  TwipsPerPixel: Integer;
  Range: TFormatRange;
begin
  TwipsPerPixel := 1440 div PixelsPerInch;
  with Range do
  begin
    hDC       := DestDCHandle;     // DC handle
    hdcTarget := DestDCHandle;     // ditto
    // convert the coordinates to twips (1/1440")
    rc.Left   := R.Left   * TwipsPerPixel;
    rc.Top    := R.Top    * TwipsPerPixel;
    rc.Right  := R.Right  * TwipsPerPixel;
    rc.Bottom := R.Bottom * TwipsPerPixel;
    rcPage := rc;
    chrg.cpMin := 0;
    chrg.cpMax := -1; // RichEdit.GetTextLen;
    // Free cached information
    RichEdit.Perform(EM_FORMATRANGE, 0, 0);
    // first measure the text, to find out how high the format rectangle
    // will be. The call sets fmtrange.rc.bottom to the actual height
    // required, if all characters in the selected range will fit into
    // a smaller rectangle,
    RichEdit.Perform(EM_FORMATRANGE, 0, DWord(@Range));
    // Now render the text
    RichEdit.Perform(EM_FORMATRANGE, 1, DWord(@Range));
    // Free cached information
    RichEdit.Perform(EM_FORMATRANGE, 0, 0);
  end;
end;
{$ENDIF}

{Sample 1:

procedure TForm1.Button1Click(Sender: TObject);
var
  RichEdit: TRichEdit;
  bmp: TBitmap;
  DestDCHandle: HDC;
begin
  RichEdit := TRichEdit.Create(Self);
  try
    RichEdit.Visible := False;
    RichEdit.Parent := Self;
    // Win2k, WinXP
    RichEdit.Lines.LoadFromFile('filename.rtf');
    bmp := TBitmap.Create;
    try
      bmp.width := 500;
      bmp.height := 500;
      DestDCHandle := bmp.Canvas.Handle;
      DrawRTF(DestDCHandle, Rect(0, 0, bmp.Width, bmp.Height),
        RichEdit, 96);
      Image1.Picture.Assign(bmp);
    finally
      bmp.Free;
    end;
  finally
    RichEdit.Free;
  end;
end;

Sample 2 (draw transparent):

procedure TForm1.Button1Click(Sender: TObject);
var
  RichEdit: TRichEdit;
  ExStyle: DWord;
  bmp: TBitmap;
  DestDCHandle: HDC;
begin
  RichEdit := TRichEdit.Create(Self);
  try
    RichEdit.Visible := False;
    RichEdit.Parent := Self;
    // Win2k, WinXP
    ExStyle := GetWindowLong(RichEdit.Handle, GWL_EXSTYLE);
    ExStyle := ExStyle or WS_EX_TRANSPARENT;
    SetWindowLong(RichEdit.Handle, GWL_EXSTYLE, ExStyle);
    RichEdit.Lines.LoadFromFile('filename.rtf');
    bmp := TBitmap.Create;
    try
      bmp.LoadFromFile('filename.bmp');
      DestDCHandle := bmp.Canvas.Handle;
      // Win9x
      SetBkMode(DestDCHandle, TRANSPARENT);
      DrawRTF(DestDCHandle, Rect(0, 0, bmp.Width, bmp.Height),
        RichEdit, 96);
      Image1.Picture.Assign(bmp);
    finally
      bmp.Free;
    end;
  finally
    RichEdit.Free;
  end;
end; }

function ArrayOfByteToHexString(const A: array of Byte): AnsiString;
var
   i: Integer;
   Temp: AnsiString;
begin
   Result := '';
   for i := Low(A) to High(A) do
   begin
     Temp := ' ' + IntToHex(A[i], 2);
     // following is optional
     if i mod 16 = 0 then
       Temp := Temp + #13#10
     else if (i mod 8)<>0 then
       Temp := Temp + '-';
   end;
   Result := Trim(Temp);
end;

{ tracking window movement

type
   TForm1 = class(TForm)
     ListBox1: TListBox;
   private
   public
     procedure WMWindowPosChanged(var Msg: TMessage); message WM_WINDOWPOSCHANGED;
     procedure WMWindowPosChanging(var Msg: TMessage); message WM_WINDOWPOSCHANGING;
   end;

procedure TForm1.WMWindowPosChanged(var Msg: TMessage);
begin
   ListBox1.Items.Add('Changed');
   ListBox1.TopIndex := ListBox1.Items.Count - 1;

   inherited;
end;

procedure TForm1.WMWindowPosChanging(var Msg: TMessage);
begin
   ListBox1.Items.Add('Changing');
   ListBox1.TopIndex := ListBox1.Items.Count - 1;

   inherited;
end;

You can easily obtain the desktop workarea (ie the free area excluding the
taskbar using a Windows API :

SystemParametersInfo(SPI_GETWORKAREA,0,@ARect,0);

}

Initialization
  Ez_Preferences := TEzPreferences.Create;
  Ez_Symbols := TEzSymbols.Create;
  Ez_VectorFonts := TEzVectorFonts.Create;
  Ez_LineTypes := TEzSymbols.Create;
  Ez_LineTypes.IsLineType := true;
  Ez_Hatches := TEzHatchList.Create;

  SetupCursors;

Finalization
  Ez_Preferences.Free;
  Ez_Symbols.Free;
  Ez_VectorFonts.Free;
  Ez_LineTypes.Free;
  Ez_Hatches.Free;

  DisposeCursors;

End.
