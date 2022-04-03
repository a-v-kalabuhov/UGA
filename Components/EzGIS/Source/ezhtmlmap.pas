Unit EzHTMLmap;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Windows, Controls, EzBaseGis, EzBase ;

Type

  TEzHTMLMap = Class( TComponent )
  Private
    FDrawBox: TEzBaseDrawBox;
    FHTMLTemplate: String;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FTarget: String; // where the info clicked will go
    Procedure SetDrawBox( Value: TEzBaseDrawBox );
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Procedure SaveToFile( Const LayerName, FileName: String );
  Published
    Property HTMLTemplate: String Read FHTMLTemplate Write FHTMLTemplate;
    Property ImageWidth: Integer Read FImageWidth Write FImageWidth Default 640;
    Property ImageHeight: Integer Read FImageHeight Write FImageHeight Default 480;
    Property DrawBox: TEzBaseDrawBox Read FDrawBox Write SetDrawBox;
    Property Target: String Read FTarget Write FTarget;
  End;

Implementation

Uses
  EzSystem, EzConsts, EzEntities, EzLib ;

Resourcestring
  SHTMLTemplateError = 'HTML template not found or DrawBox undefined';
  SHTMLLayerError = 'The defined layer does not exists';
{$IFNDEF GIF_SUPPORT}
  SHTMLNoGIFSupport = 'Compilation Switch for GIF images is not turned ON';
{$ENDIF}
  SHTMLHintError = 'The draw box does not have assigned the OnShowHint event';
  SHTMLTemplateWrong = 'HTML template does not contain link code';
  { HTML generation template must contain this text for replacement purposes }
  SHTMLTagLink = '<#EzGis>';

Constructor TEzHTMLMap.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FImageWidth := 640;
  FImageHeight := 480;
  FTarget := 'hint_window';
End;

Procedure TEzHTMLMap.SaveToFile( Const LayerName, FileName: String );
Var
  TmpEntity: TEzEntity;
  Entities: Array[TEzEntityID] Of TEzEntity;
  Cont, EntityID: TEzEntityID;
  Lines: TStringList;
  HTMLCode: TStringList;
  HREFCode: TStringList;
  TmpClipIndex, ARecno: Integer;
  GraphicLink: TEzGraphicLink;
  AImageFileName, AHint, source, dest, BaseName, OutputDir: String;
  Layer: TEzBaseLayer;
  HasClippedThis, Accept: Boolean;
  WCRect: TEzRect;
  ScaleW, ScaleH, halfheight: Double;
  Pt2: TEzPoint;
  PrevDrawLimit: Integer;
  PrevCursor: TCursor;

  Procedure CalculateDevicePoints;
  Var
    ptlist, tmps, tag: String;
    VisPoints, VisPoints1,
      Idx1, Idx2, cnt, n: Integer;
    TmpPt1, TmpPt2: TEzPoint;
    TmpPts, FirstClipPts: PEzPointArray;
    TmpSize, DevSize: Integer;
    DevPts: PPointArray;
    ClipRes: TEzClipCodes;
    Clip, Extent: TEzRect;
    M: TEzMatrix;
    V: TEzVector;
    TmpPt: TPoint;
  Begin
    Clip := WCRect;
    Extent := TmpEntity.FBox;
    M := IDENTITY_MATRIX2D;
    V := TmpEntity.DrawPoints;

    If V.Count < 3 Then  Exit;
    n := 0;
    If V.Parts.Count < 2 Then
    Begin
      Idx1 := 0;
      Idx2 := V.Count - 1;
    End
    Else
    Begin
      Idx1 := V.Parts[n];
      Idx2 := V.Parts[n + 1] - 1;
    End;

    TmpSize := ( V.Count + 4 ) * sizeof( TEzPoint );
    DevSize := ( V.Count + 4 ) * sizeof( TPoint );
    GetMem( TmpPts, TmpSize );
    GetMem( FirstClipPts, TmpSize );
    GetMem( DevPts, DevSize );
    Try
      Repeat
        VisPoints1 := 0;
        If IsBoxFullInBox2D( Extent, Clip ) Then
        Begin
          For cnt := Idx1 To Idx2 Do
            TmpPts^[cnt - Idx1] := TransformPoint2D( V[cnt], M );
          VisPoints := ( Idx2 - Idx1 ) + 1;
        End
        Else
        Begin
          For cnt := Idx1 To Idx2 Do
          Begin
            TmpPt1 := TransformPoint2D( V[cnt], M );
            If cnt < Idx2 Then
              TmpPt2 := TransformPoint2D( V[cnt + 1], M )
            Else
              TmpPt2 := TransformPoint2D( V[Idx1], M );
            ClipRes := ClipLineLeftRight2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              FirstClipPts^[VisPoints1] := TmpPt1;
              Inc( VisPoints1 );
            End;
            If ccSecond In ClipRes Then
            Begin
              FirstClipPts^[VisPoints1] := TmpPt2;
              Inc( VisPoints1 );
            End;
          End;
          FirstClipPts^[VisPoints1] := FirstClipPts^[0];
          Inc( VisPoints1 );
          VisPoints := 0;
          For cnt := 0 To VisPoints1 - 2 Do
          Begin
            TmpPt1 := FirstClipPts^[cnt];
            TmpPt2 := FirstClipPts^[cnt + 1];
            ClipRes := ClipLineUpBottom2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              TmpPts^[VisPoints] := TmpPt1;
              Inc( VisPoints );
            End;
            If ccSecond In ClipRes Then
            Begin
              TmpPts^[VisPoints] := TmpPt2;
              Inc( VisPoints );
            End;
          End;
        End;
        If VisPoints > 1 Then
        Begin
          { the points are now in DevPts. Build the point list }
          ptlist := '';
          For cnt := 0 To VisPoints - 1 Do
            DevPts[cnt] := FDrawBox.Grapher.RealToPoint( TmpPts^[cnt] );

          For cnt := 0 To VisPoints - 1 Do
          Begin
            TmpPt := DevPts[cnt];
            TmpPt.X := Round( TmpPt.X * ScaleW );
            TmpPt.Y := Round( TmpPt.Y * ScaleH );
            With TmpPt Do
              tmps := Format( '%d,%d', [X, Y] );
            If Length( ptlist ) = 0 Then
              ptlist := tmps
            Else
              ptlist := ptList + ',' + tmps;
          End;
          { build the HTML TAG }
          tag := Format( '<AREA SHAPE="POLY" COORDS="%s" alt="%s">', [ptlist, AHint] );
          { add to the map definition }
          HTMLCode.Add( tag );
        End;
        If V.Count < 2 Then
          Break;
        Inc( n );
        If n >= V.Parts.Count Then
          Break;
        Idx1 := V.Parts[n];
        If n < V.Parts.Count - 1 Then
          Idx2 := V.Parts[n + 1] - 1
        Else
          Idx2 := V.Count - 1;
      Until False;
    Finally
      FreeMem( TmpPts, TmpSize );
      FreeMem( FirstClipPts, TmpSize );
      FreeMem( DevPts, DevSize );
    End;
  End;

Begin
  If ( FDrawBox = Nil ) Or ( Length( FHTMLTemplate ) = 0 ) Or Not FileExists( FHTMLTemplate ) Then
    EzGisError( SHTMLTemplateError );
  Layer := FDrawBox.Gis.Layers.LayerByName( LayerName );
  If Layer = Nil Then
    EzGisError( SHTMLLayerError );

{$IFNDEF GIF_SUPPORT}
  MessageToUser( SHTMLNoGIFSupport, smsgerror, MB_ICONERROR );
  Exit;
{$ENDIF}

  { now create the .Gif file from the Viewport }
  GraphicLink := TEzGraphicLink.Create;

  Layer.ForceOpened;
  If Not ( Layer.LayerInfo.Visible And Assigned( FDrawBox.OnShowHint ) ) Then
  Begin
    EzGisError( SHTMLHintError );
  End;
  TmpClipIndex := FDrawBox.Gis.ClippedEntities.IndexOf( Layer );
  HasClippedThis := TmpClipIndex >= 0;

  ScaleW := FImageWidth / FDrawBox.ScreenBitmap.Width;
  ScaleH := FImageHeight / FDrawBox.ScreenBitmap.Height;

  WCRect := FDrawBox.Grapher.CurrentParams.VisualWindow;

  OutputDir := AddSlash( ExtractFilePath( FileName ) );
  BaseName := ExtractFileName( ChangeFileExt( FileName, '' ) );

  Lines := TStringList.Create;
  HREFCode := TStringList.Create;
  HTMLCode := TStringList.Create;

{$IFDEF GIF_SUPPORT}
  AImageFileName := BaseName + '.gif';
  GraphicLink.putGIF( FDrawBox.ScreenBitmap, OutputDir + AImageFileName );
{$ENDIF}

  HTMLCode.Add( Format( '<BASE TARGET="%s">', [FTarget] ) );
  HTMLCode.Add( Format( '<IMG SRC="%s" WIDTH="%d" HEIGHT="%d" USEMAP="#%s">',
    [AImageFileName, FImageWidth, FImageHeight, BaseName] ) );
  HTMLCode.Add( Format( '<MAP NAME="%s">', [BaseName] ) );

  For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
    Entities[Cont] := GetClassFromID( Cont ).Create( 4 );
  PrevDrawLimit := Ez_Preferences.MinDrawLimit;
  Ez_Preferences.MinDrawLimit := 0;
  PrevCursor := FDrawBox.Cursor;
  FDrawBox.Cursor := crHourglass;
  Try
    Lines.LoadFromFile( FHTMLTemplate );
    If AnsiPos( SHTMLTagLink, Lines.Text ) = 0 Then
      EzGisError( SHTMLTemplateWrong );

    Layer.First;
    Layer.StartBuffering;
    Try
      { Now create the HTML code for the hotspot map }
      While Not Layer.Eof Do
      Begin
        Try
          EntityID := Layer.RecEntityID;
          If Layer.RecIsDeleted Or
            Not IsRectVisible( Layer.RecExtension, WCRect ) Then
            Continue;
          ARecno := Layer.Recno;
          If HasClippedThis And
            ( Not FDrawBox.Gis.ClippedEntities[TmpClipIndex].IsSelected( ARecno ) ) Then
            Continue;

          TmpEntity := Entities[EntityID];
          Layer.RecLoadEntity2( TmpEntity );
          If Not ( TmpEntity.EntityID = idPlace ) And Not TmpEntity.IsClosed Then
            Continue;
          If TmpEntity.EntityID = idPlace Then
          Begin
            Pt2 := TmpEntity.Points[0];
            halfheight := TEzPlace( TmpEntity ).SymbolTool.Height / 2;
            With TmpEntity Do
            Begin
              Points.Clear;
              Points.Add( Point2D( Pt2.X - halfheight, pt2.y - halfheight ) );
              Points.Add( Point2D( Pt2.X + halfheight, pt2.y - halfheight ) );
              Points.Add( Point2D( Pt2.X + halfheight, pt2.y + halfheight ) );
              Points.Add( Point2D( Pt2.X - halfheight, pt2.y + halfheight ) );
            End;
          End;

          { now calculate the string to show in a new browser window }
          AHint := '';
          If Layer.DBTable <> Nil Then
            Layer.DBTable.Recno := ARecno;
          If Assigned( FDrawBox.OnShowHint ) Then
          Begin
            AHint := '';
            Accept := False;
            FDrawBox.OnShowHint( FDrawBox, Layer, ARecno, AHint, Accept );
            If Not ( Accept And ( Length( AHint ) > 0 ) ) Then Continue;

          End;

          AHint := StringReplace( AHint, #13#10, '<BR>', [rfReplaceAll] );
          Try
            CalculateDevicePoints;
          Except
            MessageToUser( inttostr( Layer.Recno ), smsgerror, MB_ICONERROR );
          End;
        Finally
          Layer.Next;
        End;
      End;
      HTMLCode.Add( '</MAP>' );
      { now replace the string }
      source := Lines.Text;
      dest := HTMLCode.Text;
      Lines.Text := StringReplace( Source, SHTMLTagLink, dest, [rfReplaceAll] );
      Lines.SaveToFile( FileName );
    Finally
      Layer.EndBuffering;
    End;
  Finally
    Ez_Preferences.MinDrawLimit := PrevDrawLimit;
    Lines.Free;
    HTMLCode.Free;
    HREFcode.Free;
    GraphicLink.Free;
    For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
      Entities[Cont].Free;
    FDrawBox.Cursor := PrevCursor;
  End;
End;

Procedure TEzHTMLMap.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FDrawBox ) Then
    FDrawBox := Nil;
End;

Procedure TEzHTMLMap.SetDrawBox( Value: TEzBaseDrawBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Assigned( Value ) And ( Value <> FDrawBox ) Then
    Value.FreeNotification( Self );
  FDrawBox := Value;
End;

End.
