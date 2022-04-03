Unit EzDims;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, ExtCtrls, Dialogs,
  Forms, EzBase, EzBaseGIS, EzLib, EzCmdLine, EzEntities, EzSystem;

Type

  { TEzDimHorizontal }

  TEzDimHorizontal = Class( TEzEntity )
  Private
    FPenTool: TEzPenTool;
    { Points has a fixed number of elements with the following meaning :
      Points[0] = BaseLineFrom
      Points[1] = BaseLineTo
      Points[2] = TextBasePoint
      Points[3] = TextLineY only Y abscisa is used
    }
    FFontName: String;
    FTextHeight: Double;
    FNumDecimals: Integer;
    { the list of entities (all are calculated from basic info), where:
      0 = the text line
      1 = line from the center of the text line to the text entity
      2 = the left arrow
      3 = the right arrow
      4 = the left line
      5 = the right line
      6 = the text entity
    }
    FEntities: TList;
    Function IsTextOnLine: Boolean;
    Procedure ClearEntities;
    Procedure SetNumDecimals( Value: Integer );
    Procedure SetTextHeight( Const Value: Double );
    Procedure SetTextLineY( Const Value: Double );
    Function GetBaseLineFrom: TEzPoint;
    Function GetBaseLineTo: TEzPoint;
    Function GetTextBasePoint: TEzPoint;
    Function GetTextLineY: Double;
    Procedure SetBaseLineFrom( Const Value: TEzPoint );
    Procedure SetBaseLineTo( Const Value: TEzPoint );
    Procedure SetFontName( Const Value: String );
    Procedure SetTextBasePoint( Const Value: TEzPoint );
  {$IFDEF BCB}
    function GetFontName: String;
    function GetNumDecimals: Integer;
    function GetPenTool: TEzPenTool;
    function GetTextHeight: Double;
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const BaseLineFrom, BaseLineTo: TEzPoint;
      Const TextLineY: Double );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure UpdateExtension; Override;
    Function StorageSize: Integer; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil); Override;
    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer; Override;
    Procedure Calculate;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = False ): Boolean; Override;

    Property TextLineY: Double Read GetTextLineY Write SetTextLineY;
    Property TextHeight: Double  {$IFDEF BCB} Read GetTextHeight  {$ELSE} Read FTextHeight {$ENDIF} Write SetTextHeight;
    Property NumDecimals: Integer  {$IFDEF BCB} Read GetNumDecimals   {$ELSE} Read FNumDecimals {$ENDIF} Write SetNumDecimals;
    Property FontName: String  {$IFDEF BCB} Read GetFontName   {$ELSE} Read FFontName {$ENDIF} Write SetFontName;
    Property BaseLineFrom: TEzPoint Read GetBaseLineFrom Write SetBaseLineFrom;
    Property BaseLineTo: TEzPoint Read GetBaseLineTo Write SetBaseLineTo;
    Property TextBasePoint: TEzPoint Read GetTextBasePoint Write SetTextBasePoint;
    Property PenTool: TEzPenTool  {$IFDEF BCB} Read GetPenTool  {$ELSE} Read FPenTool {$ENDIF};
  End;

  { TEzDimVertical }

  TEzDimVertical = Class( TEzEntity )
  Private
    FPenTool: TEzPenTool;
    { Points has a fixed number of elements with the following meaning :
      Points[0] = BaseLineFrom
      Points[1] = BaseLineTo
      Points[2] = TextBasePoint
      Points[3] = TextLineX only X abscisa is used
    }
    FFontName: String;
    FTextHeight: Double;
    FNumDecimals: Integer;
    { the list of entities (all are calculated from basic info), where:
      0 = the text line
      1 = line from the center of the text line to the text entity
      2 = the left arrow
      3 = the right arrow
      4 = the left line
      5 = the right line
      6 = the text entity
    }
    FEntities: TList;
    Function IsTextOnLine( Const TextWidth: Double ): Boolean;
    Procedure ClearEntities;
    Procedure SetNumDecimals( Value: Integer );
    Procedure SetTextHeight( Const Value: Double );
    Procedure SetTextLineX( Const Value: Double );
    Function GetBaseLineFrom: TEzPoint;
    Function GetBaseLineTo: TEzPoint;
    Function GetTextBasePoint: TEzPoint;
    Function GetTextLineX: Double;
    Procedure SetBaseLineFrom( Const Value: TEzPoint );
    Procedure SetBaseLineTo( Const Value: TEzPoint );
    Procedure SetFontName( Const Value: String );
    Procedure SetTextBasePoint( Const Value: TEzPoint );
  {$IFDEF BCB}
    function GetFontName: String;
    function GetNumDecimals: Integer;
    function GetPenTool: TEzPenTool;
    function GetTextHeight: Double;
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const BaseLineFrom, BaseLineTo: TEzPoint;
      Const TextLineX: Double );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure UpdateExtension; Override;
    Function StorageSize: Integer; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas; Const Clip: TEzRect;
      DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil); Override;
    Function PointCode( Const Pt: TEzPoint; Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer; Override;
    Procedure Calculate;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean  = False ): Boolean; Override;

    Property TextLineX: Double Read GetTextLineX Write SetTextLineX;
    Property TextHeight: Double {$IFDEF BCB} Read GetTextHeight {$ELSE} Read FTextHeight {$ENDIF} Write SetTextHeight;
    Property NumDecimals: Integer {$IFDEF BCB} Read GetNumDecimals {$ELSE} Read FNumDecimals {$ENDIF} Write SetNumDecimals;
    Property FontName: String {$IFDEF BCB} Read GetFontName {$ELSE} Read FFontName {$ENDIF} Write SetFontName;
    Property BaseLineFrom: TEzPoint Read GetBaseLineFrom Write SetBaseLineFrom;
    Property BaseLineTo: TEzPoint Read GetBaseLineTo Write SetBaseLineTo;
    Property TextBasePoint: TEzPoint Read GetTextBasePoint Write SetTextBasePoint;
    Property PenTool: TEzPenTool {$IFDEF BCB} Read GetPenTool {$ELSE} Read FPenTool {$ENDIF};

  End;

  { TEzDimParallel }
  TEzDimParallel = Class( TEzEntity )
  Private
    FPenTool: TEzPenTool;
    { Points has a fixed number of elements with the following meaning :
      Points[0] = BaseLineFrom
      Points[1] = BaseLineTo
      Points[2] = TextBasePoint
    }
    FTextLineDistanceApart: Double;
    FFontName: String;
    FTextHeight: Double;
    FNumDecimals: Integer;
    { the list of entities (all are calculated from basic info), where:
      0 = the text line
      1 = line from the center of the text line to the text entity
      2 = the left arrow
      3 = the right arrow
      4 = the left line
      5 = the right line
      6 = the text entity
    }
    FEntities: TList;
    Function IsTextOnLine: Boolean;
    Procedure ClearEntities;
    Procedure SetNumDecimals( Value: Integer );
    Procedure SetTextHeight( Const Value: Double );
    Procedure SetTextLineDistanceApart( Const Value: Double );
    Function GetBaseLineFrom: TEzPoint;
    Function GetBaseLineTo: TEzPoint;
    Function GetTextBasePoint: TEzPoint;
    Procedure SetBaseLineFrom( Const Value: TEzPoint );
    Procedure SetBaseLineTo( Const Value: TEzPoint );
    Procedure SetFontName( Const Value: String );
    Procedure SetTextBasePoint( Const Value: TEzPoint );
{$IFDEF BCB}
    function GetFontName: String;
    function GetNumDecimals: Integer;
    function GetPenTool: TEzPenTool;
    function GetTextHeight: Double;
    function GetTextLineDistanceApart: Double;
{$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
    Function BasicInfoAsString: string; Override;
    Function AttribsAsString: string; Override;
  Public
    Constructor CreateEntity( Const BaseLineFrom, BaseLineTo: TEzPoint;
      Const TextLineDistanceApart: Double );
    Destructor Destroy; Override;
    procedure Initialize; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Procedure UpdateExtension; Override;
    Function StorageSize: Integer; Override;
    Procedure Draw( Grapher: TEzGrapher; Canvas: TCanvas;
      Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil ); Override;
    Procedure UpdateControlPoint( Index: Integer; Const Value: TEzPoint; Grapher: TEzGrapher=Nil); Override;
    Function PointCode( Const Pt: TEzPoint;  Const Aperture: Double;
      Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer; Override;
    Procedure Calculate;
    Function GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector; Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = False  ): Boolean; Override;

    Property TextLineDistanceApart: Double  {$IFDEF BCB} Read GetTextLineDistanceApart {$ELSE} Read FTextLineDistanceApart {$ENDIF} Write SetTextLineDistanceApart;
    Property TextHeight: Double  {$IFDEF BCB} Read GetTextHeight  {$ELSE} Read FTextHeight {$ENDIF} Write SetTextHeight;
    Property NumDecimals: Integer  {$IFDEF BCB} Read GetNumDecimals {$ELSE} Read FNumDecimals {$ENDIF} Write SetNumDecimals;
    Property FontName: String  {$IFDEF BCB} Read GetFontName {$ELSE} Read FFontName {$ENDIF} Write SetFontName;
    Property BaseLineFrom: TEzPoint Read GetBaseLineFrom Write SetBaseLineFrom;
    Property BaseLineTo: TEzPoint Read GetBaseLineTo Write SetBaseLineTo;
    Property TextBasePoint: TEzPoint Read GetTextBasePoint Write SetTextBasePoint;
    Property PenTool: TEzPenTool  {$IFDEF BCB} Read GetPenTool {$ELSE} Read FPenTool{$ENDIF};

  End;

Implementation

Uses
  EzPolyClip, EzBaseExpr, ezConsts, EzRtree;

{ TEzDimHorizontal }

Constructor TEzDimHorizontal.CreateEntity( Const BaseLineFrom, BaseLineTo: TEzPoint;
  Const TextLineY: Double );
Begin
  Inherited Create( 4 );
  FPoints.DisableEvents := true;
  FPoints.Add( BaseLineFrom );
  FPoints.Add( BaseLineTo );
  { when text base point is (MAXCOORD,MAXCOORD) then it must be recalculated }
  FPoints.Add( Point2d( MAXCOORD, MAXCOORD ) );
  FPoints.Add( Point2d( 0, TextLineY ) );
  FPoints.DisableEvents := false;
  FPoints.CanGrow:= False;

  UpdateExtension;
End;

Destructor TEzDimHorizontal.Destroy;
Begin
  FPenTool.Free;
  If FEntities <> Nil Then
  Begin
    ClearEntities;
    FEntities.Free;
  End;
  Inherited Destroy;
End;

procedure TEzDimHorizontal.Initialize;
begin
  FEntities := TList.Create;
  FPenTool := TEzPenTool.Create;
  With Ez_Preferences Do
  Begin
    FFontName := DefFontStyle.Name;
    FTextHeight := DefFontStyle.Height;
    FNumDecimals := NumDecimals;
    FPenTool.Assign( DefPenStyle );
  End;
  FPenTool.Style := 1;
end;

Function TEzDimHorizontal.BasicInfoAsString: string;
Begin
  Result:= Format(sDimHorizInfo, [BaseLineFrom.X,BaseLineFrom.Y,
    BaseLineTo.X,BaseLineTo.Y,TextLineY]);
End;

Function TEzDimHorizontal.AttribsAsString: string;
Begin
  Result:= Format( sPenInfo, [Pentool.Style, Pentool.Color, Pentool.Width]) + CrLf +
    Format(sVectorFontInfo, [FontName]);
End;

Procedure TEzDimHorizontal.ClearEntities;
Var
  I: Integer;
Begin
  If FEntities = Nil Then
    exit;
  For I := 0 To FEntities.Count - 1 Do
    TEzEntity( FEntities[I] ).Free;
  FEntities.Clear;
End;

Function TEzDimHorizontal.IsTextOnLine: Boolean;
Var
  temp: Double;
Begin
  If EqualPoint2d( TextBasePoint, Point2d( MAXCOORD, MAXCOORD ) ) Then
  Begin
    Result := true;
    exit;
  End;
  temp := Points[2].Y - FTextHeight / 2;
  Result := ( temp >= Points[3].Y ) And ( temp <= ( Points[3].Y + 1.25 * FTextHeight ) );
End;

Procedure TEzDimHorizontal.Calculate;
Var
  FromPt, ToPt: TEzPoint;
  TextCoordY: Double;
  TextBasePoint: TEzPoint;
  ArrowHeight, ArrowLength, Delta: Double;
  ArrowPt, MidPoint, p: TEzPoint;
  TmpHeight: Double;
  OuterArrows: Boolean;
  BaseLine: Array[0..1] Of TEzPoint;
  TmpEnt: TEzEntity;
  TextEnt: TEzEntity;
  TextLine: TEzEntity;
  LeftLine: TEzEntity;
  LeftArrow: TEzEntity;
  RightLine: TEzEntity;
  RightArrow: TEzEntity;
  TextLine2Text: TEzEntity;
  IntersVect, Vect1, Vect2: TEzVector;
Begin
  If FEntities = Nil Then
    FEntities := TList.Create;
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  p := Point2d( 0, 0 );
  If Points.Count = 0 Then
  Begin
    Points.Add( p );
    Points.Add( p );
    Points.Add( p );
    Points.Add( p );
  End;
  If FEntities.Count = 0 Then
  Begin
    // text line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( FPenTool );
    FEntities.Add( TmpEnt );
    // line from center of text line to text entity
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( FPenTool );
    FEntities.Add( TmpEnt );
    // left arrow
    TmpEnt := TEzPolygon.CreateEntity( [p, p, p, p] );
    With TEzPolygon( TmpEnt ) Do
    Begin
      PenTool.Assign( Self.FPenTool );
      BrushTool.Pattern := 1;
      BrushTool.Color := FPenTool.Color;
    End;
    FEntities.Add( TmpEnt );
    // right arrow
    TmpEnt := TEzPolygon.CreateEntity( [p, p, p, p] );
    With TEzPolygon( TmpEnt ) Do
    Begin
      PenTool.Assign( Self.FPenTool );
      BrushTool.Pattern := 1;
      BrushTool.Color := FPenTool.Color;
    End;
    FEntities.Add( TmpEnt );
    // left line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( Self.FPenTool );
    FEntities.Add( TmpEnt );
    // right line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( Self.FPenTool );
    FEntities.Add( TmpEnt );
    // text entity
    TmpEnt := TEzFittedVectorText.CreateEntity( Point2d( 0, 0 ), '', 1, -1, 0 );
    TEzFittedVectorText( TmpEnt ).FontName := self.FFontName;
    TEzFittedVectorText( TmpEnt ).FontColor := FPenTool.Color;
    FEntities.Add( TmpEnt );
  End;

  FromPt := Points[0];
  ToPt := Points[1];
  TextBasePoint := Points[2];
  TextCoordY := Points[3].Y;

  If EqualPoint2d( FromPt, ToPt ) Then
    Exit;

  If FromPt.X < ToPt.X Then
  Begin
    BaseLine[0] := FromPt;
    BaseLine[1] := ToPt;
  End
  Else
  Begin
    BaseLine[0] := ToPt;
    BaseLine[1] := FromPt;
  End;

  TextLine := FEntities[0];
  TextLine2Text := FEntities[1];
  LeftArrow := FEntities[2];
  RightArrow := FEntities[3];
  LeftLine := FEntities[4];
  RightLine := FEntities[5];
  TextEnt := FEntities[6];

  // the text line
  TextLine.Points[0] := Point2d( BaseLine[0].X, TextCoordY );
  TextLine.Points[1] := Point2d( BaseLine[1].X, TextCoordY );

  // the text
  With TEzFittedVectorText( TextEnt ) Do
  Begin
    BeginUpdate;
    Text := Format( '%.*n', [FNumDecimals, Abs( Baseline[1].X - BaseLine[0].X )] );
    Height := FTextHeight;
    Width := -1; // force to calculate the text width
    MidPoint := Point2d( ( Baseline[0].X + BaseLine[1].X ) / 2, TextCoordY );
    If EqualPoint2d( TextBasePoint, Point2d( MAXCOORD, MAXCOORD ) ) Then
    Begin
      BasePoint := Point2d( MidPoint.X - Width / 2, MidPoint.Y + Height * ( 1.25 ) );
      Self.Points.DisableEvents := true;
      Self.Points[2] := BasePoint;
      Self.Points.DisableEvents := false;
    End
    Else
      BasePoint := TextBasePoint;
    EndUpdate;
    TextLine2Text.Points[0] := MidPoint;
    If Self.IsTextOnLine Then
    Begin
      BasePoint := Point2d( BasePoint.X, TextCoordY + 1.25 * FTextHeight );
      TextLine2Text.Points[1] := Point2d( ( Points[0].X + Points[3].X ) / 2, TextCoordY );
    End
    Else
    Begin
      IntersVect := TEzVector.Create( 2 );
      Vect1 := TEzVector.Create( Points.Count );
      Vect2 := TEzVector.Create( 2 );
      Try
        Vect1.Assign( Points );
        Delta := FTextHeight * 0.20;
        Vect1[0] := Point2d( Vect1[0].X - Delta, Vect1[0].Y + Delta );
        Vect1[1] := Point2d( Vect1[1].X - Delta, Vect1[1].Y - Delta );
        Vect1[2] := Point2d( Vect1[2].X + Delta, Vect1[2].Y - Delta );
        Vect1[3] := Point2d( Vect1[3].X + Delta, Vect1[3].Y + Delta );
        Vect1[4] := Vect1[0];
        Vect2.Add( MidPoint );
        Vect2.Add( Point2d( ( Points[0].X + Points[3].X ) / 2, ( Points[0].Y + Points[1].Y ) / 2 ) );
        If EzLib.VectIntersect( Vect1, Vect2, IntersVect, true ) Then
        Begin
          TextLine2Text.Points[1] := IntersVect[0];
        End;
      Finally
        IntersVect.Free;
        Vect1.Free;
        Vect2.Free;
      End;
    End;
  End;

  { fix the text line if not enough distance }
  ArrowHeight := FTextHeight / 2;
  ArrowLength := FTextHeight;
  OuterArrows := false;
  If Abs( Baseline[1].X - BaseLine[0].X ) <= ( TEzFittedVectorText( TextEnt ).Width + ArrowLength * 2 ) Then
  Begin
    OuterArrows := true;
    TextLine.Points[0] := Point2d( TextLine.Points[0].X - ArrowLength * 2, TextLine.Points[0].Y );
    TextLine.Points[1] := Point2d( TextLine.Points[1].X + ArrowLength * 2, TextLine.Points[1].Y );
  End;

  // left line
  If Abs( BaseLine[0].Y - TextCoordY ) < FTextHeight Then
  Begin
    LeftLine.Points[0] := Point2d( BaseLine[0].X, TextCoordY + FTextHeight / 2 );
    LeftLine.Points[1] := Point2d( BaseLine[0].X, TextCoordY - FTextHeight / 2 );
  End
  Else
  Begin
    If TextCoordY > BaseLine[0].Y Then
      TmpHeight := FTextHeight / 2
    Else
      TmpHeight := -FTextHeight / 2;
    LeftLine.Points[0] := BaseLine[0];
    LeftLine.Points[1] := Point2d( BaseLine[0].X, TextCoordY + TmpHeight );
    If Abs( BaseLine[0].Y - TextCoordY ) < FTextHeight Then
    Begin
      LeftLine.Points[0] := Point2d( BaseLine[0].X, BaseLine[0].Y - TmpHeight );
      LeftLine.Points[1] := Point2d( BaseLine[0].X, BaseLine[0].Y + TmpHeight );
    End;
  End;

  // right line
  If Abs( BaseLine[1].Y - TextCoordY ) < FTextHeight Then
  Begin
    RightLine.Points[0] := Point2d( BaseLine[1].X, TextCoordY + FTextHeight / 2 );
    RightLine.Points[1] := Point2d( BaseLine[1].X, TextCoordY - FTextHeight / 2 );
  End
  Else
  Begin
    If TextCoordY > BaseLine[1].Y Then
      TmpHeight := FTextHeight / 2
    Else
      TmpHeight := -FTextHeight / 2;
    RightLine.Points[0] := BaseLine[1];
    RightLine.Points[1] := Point2d( BaseLine[1].X, TextCoordY + TmpHeight );
    If Abs( BaseLine[1].Y - TextCoordY ) < FTextHeight Then
    Begin
      RightLine.Points[0] := Point2d( BaseLine[1].X, BaseLine[1].Y - TmpHeight );
      RightLine.Points[1] := Point2d( BaseLine[1].X, BaseLine[1].Y + TmpHeight );
    End;
  End;

  If OuterArrows Then
    Delta := -ArrowLength
  Else
    Delta := ArrowLength;

  // left arrow
  ArrowPt := Point2d( BaseLine[0].X, TextCoordY );
  With LeftArrow Do
  Begin
    Points[0] := ArrowPt;
    Points[1] := Point2d( ArrowPt.X + Delta, ArrowPt.Y + ArrowHeight / 2 );
    Points[2] := Point2d( ArrowPt.X + Delta, ArrowPt.Y - ArrowHeight / 2 );
    Points[3] := ArrowPt;
  End;

  // right arrow
  ArrowPt := Point2d( BaseLine[1].X, TextCoordY );
  With RightArrow Do
  Begin
    Points[0] := ArrowPt;
    Points[1] := Point2d( ArrowPt.X - Delta, ArrowPt.Y + ArrowHeight / 2 );
    Points[2] := Point2d( ArrowPt.X - Delta, ArrowPt.Y - ArrowHeight / 2 );
    Points[3] := ArrowPt;
  End;

End;

Procedure TEzDimHorizontal.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  i: Integer;
Begin
  For i := 0 To FEntities.Count - 1 Do
  Begin
    With TEzEntity( FEntities[i] ) Do
    Begin
      SetTransformMatrix( Self.GetTransformMatrix );
      Draw( Grapher, Canvas, Clip, DrawMode );
    End;
  End;
End;

Function TEzDimHorizontal.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Begin
  Result := TEzVector.Create( 5 );
  { 1 +   4 +----+
      | \   |text|
      |  \  +----+
    0 +---\--+ 2
           \ |
            \|
             + 3
  }
  Result.Add( Point2d( Points[0].X, Points[3].Y ) );
  Result.Add( Points[0] );
  Result.Add( Point2d( Points[1].X, Points[3].Y ) );
  Result.Add( Points[1] );
  Result.Add( Points[2] );
End;

Procedure TEzDimHorizontal.UpdateControlPoint( Index: Integer;
  Const Value: TEzPoint; Grapher: TEzGrapher=Nil);
Begin
  FPoints.DisableEvents := true;
  Try
    Case Index Of
      0: Points[3] := Point2d( 0, Value.Y );
      1: Points[0] := Value;
      2: Points[3] := Point2d( 0, Value.Y );
      3: Points[1] := Value;
      4: Points[2] := Value;
    End;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Procedure TEzDimHorizontal.LoadFromStream( Stream: TStream );
Begin
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  If FEntities = Nil Then
    FEntities := TList.Create;
  ClearEntities;
  FPoints.DisableEvents := true;
  Try
    Inherited LoadFromStream( Stream );
    With Stream Do
    Begin
      FFontName := EzReadStrFromStream( stream );
      FPenTool.LoadFromStream( Stream );
      Read( FTextHeight, sizeof( FTextHeight ) );
      Read( FNumDecimals, sizeof( FNumDecimals ) );
    End;
    FPoints.CanGrow := False;
    FPoints.OnChange := UpdateExtension;
    FOriginalSize := StorageSize;
  Finally
    FPoints.DisableEvents := false;
  End;
  UpdateExtension;
End;

Procedure TEzDimHorizontal.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    EzWriteStrToStream( FFontName, stream );
    FPenTool.SaveToStream( Stream );
    Write( FTextHeight, sizeof( FTextHeight ) );
    Write( FNumDecimals, sizeof( FNumDecimals ) );
  End;
  FOriginalSize := StorageSize;
End;

Procedure TEzDimHorizontal.SetNumDecimals( Value: Integer );
Begin
  FNumDecimals := Value;
  UpdateExtension;
End;

Procedure TEzDimHorizontal.SetTextHeight( Const Value: Double );
Begin
  FTextHeight := Value;
  UpdateExtension;
End;

Procedure TEzDimHorizontal.SetTextLineY( Const Value: Double );
Begin
  Points[3] := Point2d( 0, Value );
  UpdateExtension;
End;

Procedure TEzDimHorizontal.UpdateExtension;
Var
  i: integer;
  TmpR: TEzRect;
Begin
  Calculate;
  FBox := INVALID_EXTENSION;
  For i := 0 To FEntities.Count - 1 Do
  Begin
    TmpR := TEzEntity( FEntities[i] ).FBox;
    FBox.Emin.X := dMin( FBox.Emin.X, TmpR.Emin.X );
    FBox.Emin.Y := dMin( FBox.Emin.Y, TmpR.Emin.Y );
    FBox.Emax.X := dMax( FBox.Emax.X, TmpR.Emax.X );
    FBox.Emax.Y := dMax( FBox.Emax.Y, TmpR.Emax.Y );
  End;
End;

Function TEzDimHorizontal.GetBaseLineFrom: TEzPoint;
Begin
  Result := Points[0];
End;

Function TEzDimHorizontal.GetBaseLineTo: TEzPoint;
Begin
  Result := Points[1];
End;

Function TEzDimHorizontal.GetTextBasePoint: TEzPoint;
Begin
  Result := Points[2]
End;

Function TEzDimHorizontal.GetTextLineY: Double;
Begin
  Result := Points[3].Y;
End;

Procedure TEzDimHorizontal.SetBaseLineFrom( Const Value: TEzPoint );
Begin
  Points[0] := Value;
  UpdateExtension;
End;

Procedure TEzDimHorizontal.SetBaseLineTo( Const Value: TEzPoint );
Begin
  Points[1] := Value;
  UpdateExtension;
End;

Procedure TEzDimHorizontal.SetFontName( Const Value: String );
Begin
  FFontName := Value;
  UpdateExtension;
End;

Procedure TEzDimHorizontal.SetTextBasePoint( Const Value: TEzPoint );
Begin
  Points[2] := Value;
  UpdateExtension;
End;

Function TEzDimHorizontal.StorageSize: Integer;
Begin
  result := Length( FFontName );
End;

Function TEzDimHorizontal.GetEntityID: TEzEntityID;
Begin
  result := idDimHorizontal;
End;

Function TEzDimHorizontal.PointCode( Const Pt: TEzPoint; Const Aperture: Double;
  Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer;
Var
  I: Integer;
Begin
  Result := PICKED_NONE;
  If ( FEntities = Nil ) Or ( FEntities.Count = 0 ) Then Exit;
  For I := 0 To FEntities.Count - 1 Do
  Begin
    Result := TEzEntity( FEntities[I] ).PointCode( Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints );
    If Result >= PICKED_INTERIOR Then Exit;
  End;
End;

function TEzDimHorizontal.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean = False ): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idDimHorizontal ) Or Not FPoints.IsEqualTo( Entity.Points ) Or
     ( IncludeAttribs And (
         Not CompareMem( @FPenTool.FPenStyle,
                         @TEzDimHorizontal(Entity).FPenTool.FPenStyle,
                         SizeOf( TEzPenStyle ) ) Or
         (AnsiCompareText(FFontName, TEzDimHorizontal(Entity).FFontName) <> 0) Or
         (FTextHeight <> TEzDimHorizontal(Entity).FTextHeight) ) ) Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzDimHorizontal.GetFontName: String;
begin
  Result := FFontName;
end;

function TEzDimHorizontal.GetNumDecimals: Integer;
begin
  Result := FNumDecimals;
end;

function TEzDimHorizontal.GetPenTool: TEzPenTool;
begin
  Result := FPenTool;
end;

function TEzDimHorizontal.GetTextHeight: Double;
begin
  Result := FTextHeight;
end;
{$ENDIF}

{ TEzDimVertical }

Constructor TEzDimVertical.CreateEntity( Const BaseLineFrom, BaseLineTo: TEzPoint;
  Const TextLineX: Double );
Begin
  Inherited Create( 4 );
  FPoints.DisableEvents := true;
  FPoints.Add( BaseLineFrom );
  FPoints.Add( BaseLineTo );
  { when text base point is (MAXCOORD,MAXCOORD) then it must be recalculated }
  FPoints.Add( Point2d( MAXCOORD, MAXCOORD ) );
  FPoints.Add( Point2d( 0, TextLineX ) );
  FPoints.DisableEvents := false;
  FPoints.CanGrow := false;

  UpdateExtension;
End;

Destructor TEzDimVertical.Destroy;
Begin
  FPenTool.Free;
  If FEntities <> Nil Then
  Begin
    ClearEntities;
    FEntities.Free;
  End;
  Inherited Destroy;
End;

procedure TEzDimVertical.Initialize;
begin
  FEntities := TList.Create;
  FPenTool := TEzPenTool.Create;
  With Ez_Preferences Do
  Begin
    FFontName := DefFontStyle.Name;
    FTextHeight := DefFontStyle.Height;
    FNumDecimals := NumDecimals;
    FPenTool.Assign( DefPenStyle );
  End;
  FPenTool.Style := 1;
end;

Function TEzDimVertical.BasicInfoAsString: string;
Begin
  Result:= Format(sDimVertInfo, [BaseLineFrom.X,BaseLineFrom.Y,
    BaseLineTo.X,BaseLineTo.Y,TextLineX]);
End;

Function TEzDimVertical.AttribsAsString: string;
Begin
  Result:= Format( sPenInfo, [Pentool.Style, Pentool.Color, Pentool.Width]) + CrLf +
    Format(sVectorFontInfo, [FontName]);
End;

Procedure TEzDimVertical.ClearEntities;
Var
  I: Integer;
Begin
  If FEntities = Nil Then
    exit;
  For I := 0 To FEntities.Count - 1 Do
    TEzEntity( FEntities[I] ).Free;
  FEntities.Clear;
End;

Function TEzDimVertical.IsTextOnLine( Const TextWidth: Double ): Boolean;
Var
  TextCoordX: Double;
  TextBasePoint: TEzPoint;
Begin
  If EqualPoint2d( TextBasePoint, Point2d( MAXCOORD, MAXCOORD ) ) Then
  Begin
    Result := true;
    exit;
  End;
  TextBasePoint := Points[2];
  TextCoordX := Points[3].X;
  Result := ( ( TextBasePoint.X >= TextCoordX - TextWidth / 2 ) And ( TextBasePoint.X <= TextCoordX + TextWidth / 2 ) ) Or
    ( ( TextBasePoint.X + TextWidth ) >= TextCoordX - TextWidth / 2 ) And ( ( TextBasePoint.X + TextWidth ) <= TextCoordX +
      TextWidth / 2 );
End;

Procedure TEzDimVertical.Calculate;
Var
  FromPt, ToPt: TEzPoint;
  TextCoordX: Double;
  TextBasePoint: TEzPoint;
  ArrowHeight, ArrowLength, Delta: Double;
  ArrowPt, MidPoint, p: TEzPoint;
  TmpHeight: Double;
  OuterArrows: Boolean;
  BaseLine: Array[0..1] Of TEzPoint;
  TmpEnt: TEzEntity;
  TextEnt: TEzEntity;
  TextLine: TEzEntity;
  BottomLine: TEzEntity;
  BottomArrow: TEzEntity;
  TopLine: TEzEntity;
  TopArrow: TEzEntity;
  TextLine2Text: TEzEntity;
  IntersVect, Vect1, Vect2: TEzVector;
Begin
  If FEntities = Nil Then
    FEntities := TList.Create;
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  p := Point2d( 0, 0 );
  If Points.Count = 0 Then
  Begin
    Points.Add( p );
    Points.Add( p );
    Points.Add( p );
    Points.Add( p );
  End;
  If FEntities.Count = 0 Then
  Begin
    // text line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( FPenTool );
    FEntities.Add( TmpEnt );
    // line from center of text line to text entity
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( FPenTool );
    FEntities.Add( TmpEnt );
    // left arrow
    TmpEnt := TEzPolygon.CreateEntity( [p, p, p, p] );
    With TEzPolygon( TmpEnt ) Do
    Begin
      PenTool.Assign( Self.FPenTool );
      BrushTool.Pattern := 1;
      BrushTool.Color := FPenTool.Color;
    End;
    FEntities.Add( TmpEnt );
    // right arrow
    TmpEnt := TEzPolygon.CreateEntity( [p, p, p, p] );
    With TEzPolygon( TmpEnt ) Do
    Begin
      PenTool.Assign( Self.FPenTool );
      BrushTool.Pattern := 1;
      BrushTool.Color := FPenTool.Color;
    End;
    FEntities.Add( TmpEnt );
    // left line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( Self.FPenTool );
    FEntities.Add( TmpEnt );
    // right line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( Self.FPenTool );
    FEntities.Add( TmpEnt );
    // text entity
    TmpEnt := TEzFittedVectorText.CreateEntity( Point2d( 0, 0 ), '', 1, -1, 0 );
    TEzFittedVectorText( TmpEnt ).FontName := self.FFontName;
    TEzFittedVectorText( TmpEnt ).FontColor := FPenTool.Color;
    FEntities.Add( TmpEnt );
  End;

  FromPt := Points[0];
  ToPt := Points[1];
  TextBasePoint := Points[2];
  TextCoordX := Points[3].X;

  If EqualPoint2d( FromPt, ToPt ) Then
    Exit;

  If FromPt.Y < ToPt.Y Then
  Begin
    BaseLine[0] := FromPt;
    BaseLine[1] := ToPt;
  End
  Else
  Begin
    BaseLine[0] := ToPt;
    BaseLine[1] := FromPt;
  End;

  TextLine := FEntities[0];
  TextLine2Text := FEntities[1];
  BottomArrow := FEntities[2];
  TopArrow := FEntities[3];
  BottomLine := FEntities[4];
  TopLine := FEntities[5];
  TextEnt := FEntities[6];

  // the text line
  TextLine.Points[0] := Point2d( TextCoordX, BaseLine[0].Y );
  TextLine.Points[1] := Point2d( TextCoordX, BaseLine[1].Y );

  // the text
  With TEzFittedVectorText( TextEnt ) Do
  Begin
    BeginUpdate;
    Text := Format( '%.*n', [FNumDecimals, Abs( Baseline[1].Y - BaseLine[0].Y )] );
    Height := FTextHeight;
    Width := -1; // force to calculate the text width
    MidPoint := Point2d( TextCoordX, ( Baseline[0].Y + BaseLine[1].Y ) / 2 );
    If EqualPoint2d( TextBasePoint, Point2d( MAXCOORD, MAXCOORD ) ) Then
    Begin
      BasePoint := Point2d( MidPoint.X - Width / 2, MidPoint.Y + Height / 2 );
      Self.Points.DisableEvents := true;
      Self.Points[2] := BasePoint;
      Self.Points.DisableEvents := false;
    End
    Else
      BasePoint := TextBasePoint;
    EndUpdate;

    { fix the text line if not enough distance }
    ArrowHeight := FTextHeight / 2;
    ArrowLength := FTextHeight;
    OuterArrows := false;
    If Abs( Baseline[1].Y - BaseLine[0].Y ) <= ( TEzFittedVectorText( TextEnt ).Width + ArrowLength * 2 ) Then
    Begin
      OuterArrows := true;
      TextLine.Points[0] := Point2d( TextLine.Points[0].X, TextLine.Points[0].Y - ArrowLength * 2 );
      TextLine.Points[1] := Point2d( TextLine.Points[1].X, TextLine.Points[1].Y + ArrowLength * 2 );
    End;

    TextLine2Text.Points[0] := MidPoint;
    If Self.IsTextOnLine( Width ) Then
    Begin
      BasePoint := Point2d( TextCoordX - Width / 2, BasePoint.Y );
      Self.Points.DisableEvents := true;
      Self.Points[2] := BasePoint;
      Self.Points.DisableEvents := false;
      { check if the text line and the vector text intersects }
      If ( Points[0].Y >= BaseLine[0].Y ) And ( Points[0].Y <= BaseLine[1].Y ) And
        ( Points[1].Y >= BaseLine[0].Y ) And ( Points[1].Y <= BaseLine[1].Y ) Then
      Begin
        TextLine2Text.Points[1] := TextLine2Text.Points[0];
        Delta := FTextHeight * 0.20;
        With TextLine.Points Do
        Begin
          Clear;
          Add( Point2d( TextCoordX, BaseLine[0].Y ) );
          Add( Point2d( TextCoordX, TextEnt.Points[1].Y - Delta ) );
          Add( Point2d( TextCoordX, TextEnt.Points[0].Y + Delta ) );
          Add( Point2d( TextCoordX, BaseLine[1].Y ) );
          Parts.Add( 0 );
          Parts.Add( 2 );
        End;
      End
      Else
        TextLine2Text.Points[1] := Point2d( TextCoordX, ( Points[0].Y + Points[1].Y ) / 2 );
    End
    Else
    Begin
      IntersVect := TEzVector.Create( 2 );
      Vect1 := TEzVector.Create( Points.Count );
      Vect2 := TEzVector.Create( 2 );
      Try
        Vect1.Assign( Points );
        Delta := FTextHeight * 0.20;
        Vect1[0] := Point2d( Vect1[0].X - Delta, Vect1[0].Y + Delta );
        Vect1[1] := Point2d( Vect1[1].X - Delta, Vect1[1].Y - Delta );
        Vect1[2] := Point2d( Vect1[2].X + Delta, Vect1[2].Y - Delta );
        Vect1[3] := Point2d( Vect1[3].X + Delta, Vect1[3].Y + Delta );
        Vect1[4] := Vect1[0];
        Vect2.Add( MidPoint );
        Vect2.Add( Point2d( ( Points[0].X + Points[3].X ) / 2, ( Points[0].Y + Points[1].Y ) / 2 ) );
        If EzLib.VectIntersect( Vect1, Vect2, IntersVect, true ) Then
        Begin
          TextLine2Text.Points[1] := IntersVect[0];
        End;
      Finally
        IntersVect.Free;
        Vect1.Free;
        Vect2.Free;
      End;
    End;
  End;

  // bottom line
  If Abs( BaseLine[0].X - TextCoordX ) < FTextHeight Then
  Begin
    BottomLine.Points[0] := Point2d( TextCoordX + FTextHeight / 2, BaseLine[0].Y );
    BottomLine.Points[1] := Point2d( TextCoordX - FTextHeight / 2, BaseLine[0].Y );
  End
  Else
  Begin
    If TextCoordX > BaseLine[0].X Then
      TmpHeight := FTextHeight / 2
    Else
      TmpHeight := -FTextHeight / 2;
    BottomLine.Points[0] := BaseLine[0];
    BottomLine.Points[1] := Point2d( TextCoordX + TmpHeight, BaseLine[0].Y );
    If Abs( BaseLine[0].X - TextCoordX ) < FTextHeight Then
    Begin
      BottomLine.Points[0] := Point2d( BaseLine[0].X - TmpHeight, BaseLine[0].Y );
      BottomLine.Points[1] := Point2d( BaseLine[0].X + TmpHeight, BaseLine[0].Y );
    End;
  End;

  // top line
  If Abs( BaseLine[1].X - TextCoordX ) < FTextHeight Then
  Begin
    TopLine.Points[0] := Point2d( TextCoordX + FTextHeight / 2, BaseLine[1].Y );
    TopLine.Points[1] := Point2d( TextCoordX - FTextHeight / 2, BaseLine[1].Y );
  End
  Else
  Begin
    If TextCoordX > BaseLine[1].X Then
      TmpHeight := FTextHeight / 2
    Else
      TmpHeight := -FTextHeight / 2;
    TopLine.Points[0] := BaseLine[1];
    TopLine.Points[1] := Point2d( TextCoordX + TmpHeight, BaseLine[1].Y );
    If Abs( BaseLine[1].X - TextCoordX ) < FTextHeight Then
    Begin
      TopLine.Points[0] := Point2d( BaseLine[1].X - TmpHeight, BaseLine[1].Y );
      TopLine.Points[1] := Point2d( BaseLine[1].X + TmpHeight, BaseLine[1].Y );
    End;
  End;

  If OuterArrows Then
    Delta := -ArrowLength
  Else
    Delta := ArrowLength;

  // left arrow
  ArrowPt := Point2d( TextCoordX, BaseLine[0].Y );
  With BottomArrow Do
  Begin
    Points[0] := ArrowPt;
    Points[1] := Point2d( ArrowPt.X + ArrowHeight / 2, ArrowPt.Y + Delta );
    Points[2] := Point2d( ArrowPt.X - ArrowHeight / 2, ArrowPt.Y + Delta );
    Points[3] := ArrowPt;
  End;

  // right arrow
  ArrowPt := Point2d( TextCoordX, BaseLine[1].Y );
  With TopArrow Do
  Begin
    Points[0] := ArrowPt;
    Points[1] := Point2d( ArrowPt.X + ArrowHeight / 2, ArrowPt.Y - Delta );
    Points[2] := Point2d( ArrowPt.X - ArrowHeight / 2, ArrowPt.Y - Delta );
    Points[3] := ArrowPt;
  End;

End;

Procedure TEzDimVertical.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  i: Integer;
Begin
  For i := 0 To 6 Do //FEntities.Count - 1 do
  Begin
    With TEzEntity( FEntities[i] ) Do
    Begin
      SetTransformMatrix( Self.GetTransformMatrix );
      Draw( Grapher, Canvas, Clip, DrawMode );
    End;
  End;
End;

Function TEzDimVertical.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Begin
  Result := TEzVector.Create( 5 );
  Result.Add( Point2d( Points[3].X, Points[0].Y ) );
  Result.Add( Points[0] );
  Result.Add( Point2d( Points[3].X, Points[1].Y ) );
  Result.Add( Points[1] );
  Result.Add( Points[2] );
End;

Procedure TEzDimVertical.UpdateControlPoint( Index: Integer;
  Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Begin
  FPoints.DisableEvents := true;
  Try
    Case Index Of
      0: Points[3] := Point2d( Value.X, 0 );
      1: Points[0] := Value;
      2: Points[3] := Point2d( Value.X, 0 );
      3: Points[1] := Value;
      4: Points[2] := Value;
    End;
    UpdateExtension;
  Finally
    FPoints.DisableEvents := false;
  End;
End;

Procedure TEzDimVertical.LoadFromStream( Stream: TStream );
Begin
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  If FEntities = Nil Then
    FEntities := TList.Create;
  ClearEntities;
  FPoints.DisableEvents := true;
  Try
    Inherited LoadFromStream( Stream );
    With Stream Do
    Begin
      FFontName := EzReadStrFromStream( stream );
      FPenTool.LoadFromStream( Stream );
      Read( FTextHeight, sizeof( FTextHeight ) );
      Read( FNumDecimals, sizeof( FNumDecimals ) );
    End;
    FPoints.CanGrow := False;
    FPoints.OnChange := UpdateExtension;
    FOriginalSize := StorageSize;
  Finally
    FPoints.DisableEvents := false;
  End;
  UpdateExtension;
End;

Procedure TEzDimVertical.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    EzWriteStrToStream( FFontName, stream );
    FPenTool.SaveToStream( Stream );
    Write( FTextHeight, sizeof( FTextHeight ) );
    Write( FNumDecimals, sizeof( FNumDecimals ) );
  End;
  FOriginalSize := StorageSize;
End;

Procedure TEzDimVertical.SetNumDecimals( Value: Integer );
Begin
  FNumDecimals := Value;
  UpdateExtension;
End;

Procedure TEzDimVertical.SetTextHeight( Const Value: Double );
Begin
  FTextHeight := Value;
  UpdateExtension;
End;

Procedure TEzDimVertical.SetTextLineX( Const Value: Double );
Begin
  Points[3] := Point2d( Value, 0 );
  UpdateExtension;
End;

Procedure TEzDimVertical.UpdateExtension;
Var
  i: integer;
  TmpR: TEzRect;
Begin
  Calculate;
  FBox := INVALID_EXTENSION;
  For i := 0 To FEntities.Count - 1 Do
  Begin
    TmpR := TEzEntity( FEntities[i] ).FBox;
    FBox.Emin.X := dMin( FBox.Emin.X, TmpR.Emin.X );
    FBox.Emin.Y := dMin( FBox.Emin.Y, TmpR.Emin.Y );
    FBox.Emax.X := dMax( FBox.Emax.X, TmpR.Emax.X );
    FBox.Emax.Y := dMax( FBox.Emax.Y, TmpR.Emax.Y );
  End;
End;

Function TEzDimVertical.GetBaseLineFrom: TEzPoint;
Begin
  Result := Points[0];
End;

Function TEzDimVertical.GetBaseLineTo: TEzPoint;
Begin
  Result := Points[1];
End;

Function TEzDimVertical.GetTextBasePoint: TEzPoint;
Begin
  Result := Points[2]
End;

Function TEzDimVertical.GetTextLineX: Double;
Begin
  Result := Points[3].X;
End;

Procedure TEzDimVertical.SetBaseLineFrom( Const Value: TEzPoint );
Begin
  Points[0] := Value;
  UpdateExtension;
End;

Procedure TEzDimVertical.SetBaseLineTo( Const Value: TEzPoint );
Begin
  Points[1] := Value;
  UpdateExtension;
End;

Procedure TEzDimVertical.SetFontName( Const Value: String );
Begin
  FFontName := Value;
  UpdateExtension;
End;

Procedure TEzDimVertical.SetTextBasePoint( Const Value: TEzPoint );
Begin
  Points[2] := Value;
  UpdateExtension;
End;

Function TEzDimVertical.StorageSize: Integer;
Begin
  result := Length( FFontName );
End;

Function TEzDimVertical.GetEntityID: TEzEntityID;
Begin
  result := idDimVertical;
End;

Function TEzDimVertical.PointCode( Const Pt: TEzPoint; Const Aperture: Double;
  Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer;
Var
  I: Integer;
Begin
  Result := PICKED_NONE;
  If ( FEntities = Nil ) Or ( FEntities.Count = 0 ) Then
    Exit;
  For I := 0 To FEntities.Count - 1 Do
  Begin
    Result := TEzEntity( FEntities[I] ).PointCode( Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints );
    If Result >= PICKED_INTERIOR Then Exit;
  End;
End;

function TEzDimVertical.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean = False ): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idDimVertical ) Or Not FPoints.IsEqualTo( Entity.Points ) Or
     ( IncludeAttribs And (
         Not CompareMem( @FPenTool.FPenStyle,
                         @TEzDimVertical(Entity).FPenTool.FPenStyle,
                         SizeOf( TEzPenStyle ) ) Or
         (AnsiCompareText(FFontName, TEzDimVertical(Entity).FFontName) <> 0) Or
         (FTextHeight <> TEzDimVertical(Entity).FTextHeight) ) ) Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzDimVertical.GetFontName: String;
begin
  Result := FFontName;
end;

function TEzDimVertical.GetNumDecimals: Integer;
begin
  Result := FNumDecimals;
end;

function TEzDimVertical.GetPenTool: TEzPenTool;
begin
  Result := FPenTool;
end;

function TEzDimVertical.GetTextHeight: Double;
begin
  Result := FTextHeight;
end;
{$ENDIF}

{ TEzDimParallel }

Constructor TEzDimParallel.CreateEntity( Const BaseLineFrom, BaseLineTo: TEzPoint;
  Const TextLineDistanceApart: Double );
Begin
  Inherited Create( 4 );

  FPoints.DisableEvents := true;
  FPoints.Add( BaseLineFrom );
  FPoints.Add( BaseLineTo );
  { when text base point is (MAXCOORD,MAXCOORD) then it must be recalculated }
  FPoints.Add( Point2d( MAXCOORD, MAXCOORD ) );
  FPoints.Add( Point2d( 0, TextLineDistanceApart ) );
  FPoints.DisableEvents := false;
  FPoints.CanGrow := false;

  UpdateExtension;
End;

Destructor TEzDimParallel.Destroy;
Begin
  FPenTool.Free;
  If FEntities <> Nil Then
  Begin
    ClearEntities;
    FEntities.Free;
  End;
  Inherited Destroy;
End;

procedure TEzDimParallel.Initialize;
begin
  FEntities := TList.Create;
  FPenTool := TEzPenTool.Create;
  With Ez_Preferences Do
  Begin
    FFontName := DefFontStyle.Name;
    FTextHeight := DefFontStyle.Height;
    FNumDecimals := NumDecimals;
    FPenTool.Assign( DefPenStyle );
  End;
  FPenTool.Style := 1;
end;

Function TEzDimParallel.BasicInfoAsString: string;
Begin
  Result:= Format(sDimParallelInfo, [BaseLineFrom.X,BaseLineFrom.Y,
    BaseLineTo.X,BaseLineTo.Y,TextLineDistanceApart]);
End;

Function TEzDimParallel.AttribsAsString: string;
Begin
  Result:= Format( sPenInfo, [Pentool.Style, Pentool.Color, Pentool.Width]) + CrLf +
    Format(sVectorFontInfo, [FontName]);
End;

Procedure TEzDimParallel.ClearEntities;
Var
  I: Integer;
Begin
  If FEntities = Nil Then
    exit;
  For I := 0 To FEntities.Count - 1 Do
    TEzEntity( FEntities[I] ).Free;
  FEntities.Clear;
End;

Function TEzDimParallel.IsTextOnLine: Boolean;
Var
  V: TEzVector;
Begin
  If EqualPoint2d( TextBasePoint, Point2d( MAXCOORD, MAXCOORD ) ) Then
  Begin
    Result := true;
    exit;
  End;
  V := TEzVector.Create( 2 );
  Try
    Result := VectIntersect( TEzEntity( FEntities[6] ).Points, TEzEntity( FEntities[0] ).Points, V, true );
  Finally
    V.Free;
  End;
End;

Procedure TEzDimParallel.Calculate;
Var
  temp, textCent, p0, p1, p2, p3: TEzPoint;
  textCoordY, TextDistApart, lineDist, lineAngle: Double;
  TextBasePoint: TEzPoint;
  ArrowHeight, ArrowLength, Delta: Double;
  ArrowPt, MidPoint, p: TEzPoint;
  TmpHeight: Double;
  OuterArrows: Boolean;
  BaseLine, baseLineNoRot, textLineNoRot: Array[0..1] Of TEzPoint;
  TmpEnt: TEzEntity;
  TextEnt: TEzEntity;
  TextLine: TEzEntity;
  LeftLine: TEzEntity;
  LeftArrow: TEzEntity;
  RightLine: TEzEntity;
  RightArrow: TEzEntity;
  TextLine2Text: TEzEntity;
  IntersVect, Vect1, Vect2: TEzVector;
  M: TEzMatrix;
  I: Integer;
Begin
  If FEntities = Nil Then
    FEntities := TList.Create;
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  p := Point2d( 0, 0 );
  If Points.Count = 0 Then
  Begin
    Points.Add( p );
    Points.Add( p );
    Points.Add( p );
  End;
  If FEntities.Count = 0 Then
  Begin
    // text line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( FPenTool );
    FEntities.Add( TmpEnt );
    // line from center of text line to text entity
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( FPenTool );
    FEntities.Add( TmpEnt );
    // left arrow
    TmpEnt := TEzPolygon.CreateEntity( [p, p, p, p] );
    With TEzPolygon( TmpEnt ) Do
    Begin
      PenTool.Assign( Self.FPenTool );
      BrushTool.Pattern := 1;
      BrushTool.Color := FPenTool.Color;
    End;
    FEntities.Add( TmpEnt );
    // right arrow
    TmpEnt := TEzPolygon.CreateEntity( [p, p, p, p] );
    With TEzPolygon( TmpEnt ) Do
    Begin
      PenTool.Assign( Self.FPenTool );
      BrushTool.Pattern := 1;
      BrushTool.Color := FPenTool.Color;
    End;
    FEntities.Add( TmpEnt );
    // left line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( Self.FPenTool );
    FEntities.Add( TmpEnt );
    // right line
    TmpEnt := TEzPolyLine.CreateEntity( [p, p] );
    TEzPolyLine( TmpEnt ).PenTool.Assign( Self.FPenTool );
    FEntities.Add( TmpEnt );
    // text entity
    TmpEnt := TEzFittedVectorText.CreateEntity( Point2d( 0, 0 ), '', 1, -1, 0 );
    TEzFittedVectorText( TmpEnt ).FontName := self.FFontName;
    TEzFittedVectorText( TmpEnt ).FontColor := FPenTool.Color;
    FEntities.Add( TmpEnt );
  End;

  If EqualPoint2d( Points[0], Points[1] ) Then
    Exit;
  TextBasePoint := Points[2];
  TextDistApart := FTextLineDistanceApart;

  If Points[0].X > Points[1].X Then
  Begin
    Points.DisableEvents := true;
    temp := Points[0];
    Points[0] := Points[1];
    Points[1] := temp;
    Points.DisableEvents := false;
  End;
  BaseLine[0] := Points[0];
  BaseLine[1] := Points[1];

  TextLine := FEntities[0];
  TextLine2Text := FEntities[1];
  LeftArrow := FEntities[2];
  RightArrow := FEntities[3];
  LeftLine := FEntities[4];
  RightLine := FEntities[5];
  TextEnt := FEntities[6];

  // the text line
  ArrowHeight := FTextHeight / 2;
  ArrowLength := FTextHeight;
  lineDist := Dist2d( BaseLine[0], BaseLine[1] );
  lineAngle := Angle2d( BaseLine[0], BaseLine[1] );

  M := Rotate2d( lineAngle, BaseLine[0] );
  TextLine.Points[0] := TransformPoint2d( Point2d( BaseLine[0].X, BaseLine[0].Y + TextDistApart ), M );
  TextLine.Points[1] := TransformPoint2d( Point2d( BaseLine[0].X + lineDist, BaseLine[0].Y + TextDistApart ), M );

  baseLineNoRot[0] := baseLine[0];
  baseLineNoRot[1] := Point2d( baseLine[0].X + lineDist, baseLine[0].Y );

  textLineNoRot[0] := Point2d( baseLineNoRot[0].X, baseLineNoRot[0].Y + TextDistApart );
  textLineNoRot[1] := Point2d( baseLineNoRot[1].X, baseLineNoRot[1].Y + TextDistApart );

  textCoordY := baseLineNoRot[0].Y + TextDistApart;

  // the text
  With TEzFittedVectorText( TextEnt ) Do
  Begin
    BeginUpdate;
    Text := Format( '%.*n', [FNumDecimals, lineDist] );
    Height := FTextHeight;
    Width := -1; // force to calculate the text width
    MidPoint := Point2d( ( textLine.Points[0].X + textLine.Points[1].X ) / 2,
      ( textLine.Points[0].Y + textLine.Points[1].Y ) / 2 );
    If EqualPoint2d( TextBasePoint, Point2d( MAXCOORD, MAXCOORD ) ) Then
    Begin
      BasePoint := Point2d( MidPoint.X - Width / 2, MidPoint.Y + Height * ( 1.25 ) );
      Self.Points.DisableEvents := true;
      Self.Points[2] := BasePoint;
      Self.Points.DisableEvents := false;
    End
    Else
      BasePoint := TextBasePoint;
    EndUpdate;
    TextLine2Text.Points[0] := MidPoint;
    If Self.IsTextOnLine Then
    Begin
      Centroid( TextCent.X, TextCent.Y );
      temp := Perpend( textCent, textLine.Points[0], textLine.Points[1] );
      BasePoint := Point2d( temp.X - Width / 2, temp.Y + Height );
      TextLine2Text.Points[1] := temp;
      If ( temp.X > textLine.Points[0].X ) And ( temp.X < textLine.Points[1].X ) And
        ( temp.Y > ezlib.dMin( textLine.Points[0].Y, textLine.Points[1].Y ) ) And
        ( temp.Y < ezlib.dMax( textLine.Points[0].Y, textLine.Points[1].Y ) ) Then
      Begin
        // split into parts
        Vect1 := TEzVector.Create( 2 );
        Vect2 := TEzVector.Create( TextEnt.Points.Count );
        Try
          Vect2.Assign( TextEnt.Points );
          Delta := FTextHeight * 0.20;
          Vect2[0] := Point2d( Vect2[0].X - Delta, Vect2[0].Y + Delta );
          Vect2[1] := Point2d( Vect2[1].X - Delta, Vect2[1].Y - Delta );
          Vect2[2] := Point2d( Vect2[2].X + Delta, Vect2[2].Y - Delta );
          Vect2[3] := Point2d( Vect2[3].X + Delta, Vect2[3].Y + Delta );
          Vect2[4] := Vect2[0];
          If VectIntersect( textLine.Points, Vect2, Vect1, true ) And ( Vect1.Count = 2 ) Then
          Begin
            If Dist2d( textLine.Points[0], Vect1[0] ) < Dist2d( textLine.Points[0], Vect1[1] ) Then
            Begin
              p1 := Vect1[0];
              p2 := Vect1[1];
            End
            Else
            Begin
              p2 := Vect1[1];
              p1 := Vect1[0];
            End;
            p0 := textLine.Points[0];
            p3 := textLine.Points[1];
            With textLine.Points Do
            Begin
              Clear;
              Add( p0 );
              Add( p1 );
              Add( p2 );
              Add( p3 );
              Parts.Add( 0 );
              Parts.Add( 2 );
            End;
            TextLine2Text.Points[1] := TextLine2Text.Points[0];
          End;
        Finally
          Vect1.Free;
          Vect2.Free;
        End;
      End;
    End
    Else
    Begin
      IntersVect := TEzVector.Create( 2 );
      Vect1 := TEzVector.Create( Points.Count );
      Vect2 := TEzVector.Create( 2 );
      Try
        Vect1.Assign( Points );
        Delta := FTextHeight * 0.20;
        Vect1[0] := Point2d( Vect1[0].X - Delta, Vect1[0].Y + Delta );
        Vect1[1] := Point2d( Vect1[1].X - Delta, Vect1[1].Y - Delta );
        Vect1[2] := Point2d( Vect1[2].X + Delta, Vect1[2].Y - Delta );
        Vect1[3] := Point2d( Vect1[3].X + Delta, Vect1[3].Y + Delta );
        Vect1[4] := Vect1[0];
        Vect2.Add( MidPoint );
        Vect2.Add( Point2d( ( Points[0].X + Points[3].X ) / 2, ( Points[0].Y + Points[1].Y ) / 2 ) );
        If EzLib.VectIntersect( Vect1, Vect2, IntersVect, true ) Then
        Begin
          TextLine2Text.Points[1] := IntersVect[0];
        End;
      Finally
        IntersVect.Free;
        Vect1.Free;
        Vect2.Free;
      End;
    End;
  End;

  // left line
  If Abs( BaseLineNoRot[0].Y - TextCoordY ) < FTextHeight Then
  Begin
    LeftLine.Points[0] := Point2d( textLineNoRot[0].X, textLineNoRot[0].Y + FTextHeight / 2 );
    LeftLine.Points[1] := Point2d( textLineNoRot[0].X, textLineNoRot[0].Y - FTextHeight / 2 );
  End
  Else
  Begin
    If textCoordY > BaseLineNoRot[0].Y Then
      TmpHeight := FTextHeight / 2
    Else
      TmpHeight := -FTextHeight / 2;
    LeftLine.Points[0] := BaseLineNoRot[0];
    LeftLine.Points[1] := Point2d( BaseLineNoRot[0].X, textCoordY + TmpHeight );
    If Abs( BaseLineNoRot[0].Y - TextCoordY ) < FTextHeight Then
    Begin
      LeftLine.Points[0] := Point2d( BaseLineNoRot[0].X, BaseLineNoRot[0].Y - TmpHeight );
      LeftLine.Points[1] := Point2d( BaseLineNoRot[0].X, BaseLineNoRot[0].Y + TmpHeight );
    End;
  End;
  // rotate the line
  LeftLine.Points[0] := TransformPoint2d( LeftLine.Points[0], M );
  LeftLine.Points[1] := TransformPoint2d( LeftLine.Points[1], M );

  // right line
  If Abs( BaseLineNoRot[1].Y - TextCoordY ) < FTextHeight Then
  Begin
    RightLine.Points[0] := Point2d( BaseLineNoRot[1].X, textCoordY + FTextHeight / 2 );
    RightLine.Points[1] := Point2d( BaseLineNoRot[1].X, textCoordY - FTextHeight / 2 );
  End
  Else
  Begin
    If TextCoordY > BaseLineNoRot[1].Y Then
      TmpHeight := FTextHeight / 2
    Else
      TmpHeight := -FTextHeight / 2;
    RightLine.Points[0] := BaseLineNoRot[1];
    RightLine.Points[1] := Point2d( BaseLineNoRot[1].X, TextCoordY + TmpHeight );
    If Abs( BaseLineNoRot[1].Y - TextCoordY ) < FTextHeight Then
    Begin
      RightLine.Points[0] := Point2d( BaseLineNoRot[1].X, BaseLineNoRot[1].Y - TmpHeight );
      RightLine.Points[1] := Point2d( BaseLineNoRot[1].X, BaseLineNoRot[1].Y + TmpHeight );
    End;
  End;
  // rotate the line
  RightLine.Points[0] := TransformPoint2d( RightLine.Points[0], M );
  RightLine.Points[1] := TransformPoint2d( RightLine.Points[1], M );

  OuterArrows := false;
  If lineDist <= ( TEzFittedVectorText( TextEnt ).Width + ArrowLength * 2 ) Then
  Begin
    OuterArrows := true;
    Delta := ArrowLength * 2;
    textLineNoRot[0] := Point2d( textLineNoRot[0].X - Delta, textLineNoRot[0].Y );
    textLineNoRot[1] := Point2d( textLineNoRot[1].X + Delta, textLineNoRot[1].Y );
    TextLine.Points[0] := TransformPoint2d( textLineNoRot[0], M );
    TextLine.Points[TextLine.Points.Count - 1] := TransformPoint2d( textLineNoRot[1], M );
  End;

  If OuterArrows Then
    Delta := -ArrowLength
  Else
    Delta := ArrowLength;

  // left arrow
  ArrowPt := Point2d( BaseLineNoRot[0].X, TextCoordY );
  With LeftArrow Do
  Begin
    Points[0] := ArrowPt;
    Points[1] := Point2d( ArrowPt.X + Delta, ArrowPt.Y + ArrowHeight / 2 );
    Points[2] := Point2d( ArrowPt.X + Delta, ArrowPt.Y - ArrowHeight / 2 );
    Points[3] := ArrowPt;
  End;
  // rotate the arrow
  For I := 0 To LeftArrow.Points.Count - 1 Do
    LeftArrow.Points[I] := TransformPoint2d( LeftArrow.Points[I], M );

  // right arrow
  ArrowPt := Point2d( BaseLineNoRot[1].X, TextCoordY );
  With RightArrow Do
  Begin
    Points[0] := ArrowPt;
    Points[1] := Point2d( ArrowPt.X - Delta, ArrowPt.Y + ArrowHeight / 2 );
    Points[2] := Point2d( ArrowPt.X - Delta, ArrowPt.Y - ArrowHeight / 2 );
    Points[3] := ArrowPt;
  End;
  // rotate the arrow
  For I := 0 To RightArrow.Points.Count - 1 Do
    RightArrow.Points[I] := TransformPoint2d( RightArrow.Points[I], M );

End;

Procedure TEzDimParallel.Draw( Grapher: TEzGrapher;
  Canvas: TCanvas; Const Clip: TEzRect; DrawMode: TEzDrawMode; Data: Pointer = Nil );
Var
  i: Integer;
Begin
  For i := 0 To FEntities.Count - 1 Do
  Begin
    With TEzEntity( FEntities[i] ) Do
    Begin
      SetTransformMatrix( Self.GetTransformMatrix );
      Draw( Grapher, Canvas, Clip, DrawMode );
    End;
  End;
End;

Function TEzDimParallel.GetControlPoints(TransfPts: Boolean; Grapher: TEzGrapher=Nil): TEzVector;
Var
  textLine: Array[0..1] Of TEzPoint;
  M: TEzMatrix;
Begin
  Result := TEzVector.Create( 5 );
  textLine[0] := Point2d( Points[0].X, Points[0].Y + FTextLineDistanceApart );
  textLine[1] := Point2d( textLine[0].X + Dist2d( Points[0], Points[1] ), textLine[0].Y );
  M := Rotate2d( Angle2d( Points[0], Points[1] ), Points[0] );
  textLine[0] := TransformPoint2d( textLine[0], M );
  textLine[1] := TransformPoint2d( textLine[1], M );
  Result.Add( Points[0] );
  Result.Add( textLine[0] );
  Result.Add( Points[1] );
  Result.Add( textLine[1] );
  Result.Add( Points[2] );
End;

Procedure TEzDimParallel.UpdateControlPoint( Index: Integer;
  Const Value: TEzPoint; Grapher: TEzGrapher=Nil );
Var
  temp: TEzPoint;
Begin
  FPoints.DisableEvents := true;
  Try
    Case Index Of
      0: Points[0] := Value;
      1, 3:
        Begin
          temp := TransformPoint2d( Value, Rotate2d( -Angle2d( Points[0], Points[1] ), Points[0] ) );
          SetTextLineDistanceApart( temp.Y - Points[0].Y );
        End;
      2: Points[1] := Value;
      4: Points[2] := Value;
    End;
  Finally
    FPoints.DisableEvents := false;
  End;
  UpdateExtension;
End;

Procedure TEzDimParallel.LoadFromStream( Stream: TStream );
Begin
  If FPenTool = Nil Then
    FPenTool := TEzPenTool.Create;
  If FEntities = Nil Then
    FEntities := TList.Create;
  ClearEntities;
  FPoints.DisableEvents := true;
  Try
    Inherited LoadFromStream( Stream );
    With Stream Do
    Begin
      Read( FTextLineDistanceApart, sizeof( Double ) );
      FFontName := EzReadStrFromStream( stream );
      FPenTool.LoadFromStream( Stream );
      Read( FTextHeight, sizeof( FTextHeight ) );
      Read( FNumDecimals, sizeof( FNumDecimals ) );
    End;
    FPoints.CanGrow := False;
    FPoints.OnChange := UpdateExtension;
    FOriginalSize := StorageSize;
  Finally
    FPoints.DisableEvents := false;
  End;
  UpdateExtension;
End;

Procedure TEzDimParallel.SaveToStream( Stream: TStream );
Begin
  Inherited SaveToStream( Stream );
  With Stream Do
  Begin
    Write( FTextLineDistanceApart, sizeof( Double ) );
    EzWriteStrToStream( FFontName, stream );
    FPenTool.SaveToStream( Stream );
    Write( FTextHeight, sizeof( FTextHeight ) );
    Write( FNumDecimals, sizeof( FNumDecimals ) );
  End;
  FOriginalSize := StorageSize;
End;

Procedure TEzDimParallel.SetNumDecimals( Value: Integer );
Begin
  FNumDecimals := Value;
  UpdateExtension;
End;

Procedure TEzDimParallel.SetTextHeight( Const Value: Double );
Begin
  FTextHeight := Value;
  UpdateExtension;
End;

Procedure TEzDimParallel.SetTextLineDistanceApart( Const Value: Double );
Begin
  FTextLineDistanceApart := Value;
  UpdateExtension;
End;

Procedure TEzDimParallel.UpdateExtension;
Var
  i: integer;
  TmpR: TEzRect;
Begin
  Calculate;
  FBox := INVALID_EXTENSION;
  For i := 0 To FEntities.Count - 1 Do
  Begin
    TmpR := TEzEntity( FEntities[i] ).FBox;
    FBox.Emin.X := dMin( FBox.Emin.X, TmpR.Emin.X );
    FBox.Emin.Y := dMin( FBox.Emin.Y, TmpR.Emin.Y );
    FBox.Emax.X := dMax( FBox.Emax.X, TmpR.Emax.X );
    FBox.Emax.Y := dMax( FBox.Emax.Y, TmpR.Emax.Y );
  End;
End;

Function TEzDimParallel.GetBaseLineFrom: TEzPoint;
Begin
  Result := Points[0];
End;

Function TEzDimParallel.GetBaseLineTo: TEzPoint;
Begin
  Result := Points[1];
End;

Function TEzDimParallel.GetTextBasePoint: TEzPoint;
Begin
  Result := Points[2]
End;

Procedure TEzDimParallel.SetBaseLineFrom( Const Value: TEzPoint );
Begin
  Points[0] := Value;
  UpdateExtension;
End;

Procedure TEzDimParallel.SetBaseLineTo( Const Value: TEzPoint );
Begin
  Points[1] := Value;
  UpdateExtension;
End;

Procedure TEzDimParallel.SetFontName( Const Value: String );
Begin
  FFontName := Value;
  UpdateExtension;
End;

Procedure TEzDimParallel.SetTextBasePoint( Const Value: TEzPoint );
Begin
  Points[2] := Value;
  UpdateExtension;
End;

Function TEzDimParallel.StorageSize: Integer;
Begin
  result := Length( FFontName );
End;

Function TEzDimParallel.GetEntityID: TEzEntityID;
Begin
  result := idDimParallel;
End;

Function TEzDimParallel.PointCode( Const Pt: TEzPoint; Const Aperture: Double;
  Var Distance: Double; SelectPickingInside: Boolean; UseDrawPoints: Boolean=True ): Integer;
Var
  I: Integer;
Begin
  Result := PICKED_NONE;
  If ( FEntities = Nil ) Or ( FEntities.Count = 0 ) Then Exit;
  For I := 0 To FEntities.Count - 1 Do
  Begin
    Result := TEzEntity( FEntities[I] ).PointCode( Pt, Aperture, Distance, SelectPickingInside, UseDrawPoints );
    If Result >= PICKED_INTERIOR Then Exit;
  End;
End;

function TEzDimParallel.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean = False ): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idDimParallel ) Or Not FPoints.IsEqualTo( Entity.Points ) Or
     ( IncludeAttribs And (
         Not CompareMem( @FPenTool.FPenStyle,
                         @TEzDimParallel(Entity).FPenTool.FPenStyle,
                         SizeOf( TEzPenStyle ) ) Or
         (AnsiCompareText(FFontName, TEzDimParallel(Entity).FFontName) <> 0) Or
         (FTextHeight <> TEzDimParallel(Entity).FTextHeight) Or
         (FTextLineDistanceApart <> TEzDimParallel(Entity).FTextLineDistanceApart) ) ) Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzDimParallel.GetFontName: String;
begin
  Result := FFontName;
end;

function TEzDimParallel.GetNumDecimals: Integer;
begin
  Result := FNumDecimals;
end;

function TEzDimParallel.GetPenTool: TEzPenTool;
begin
  Result := FPenTool;
end;

function TEzDimParallel.GetTextHeight: Double;
begin
  Result := FTextHeight;
end;

function TEzDimParallel.GetTextLineDistanceApart: Double;
begin
  Result := FTextLineDistanceApart;
end;
{$ENDIF}

End.

