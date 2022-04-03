Unit EzCADCtrls;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Windows, StdCtrls, Controls, Graphics, Forms, Printers,
  EzBaseExpr, EzLib, EzSystem, EzBase, EzRtree, EzBaseGIS, EzEntities,
  EzBasicCtrls;

Type

  {-------------------------------------------------------------------------------}
  //                      TEzCAD
  {-------------------------------------------------------------------------------}

  TEzCAD = Class( TEzBaseGIS )
  Protected
    Procedure WriteMapHeader( Const Filename: String ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Function CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer; Override;
    Procedure Open; Override;
    Procedure Close; Override;
    Procedure SaveAs( Const Filename: String ); Override;
    Procedure SaveToStream( Stream: TStream );
    Procedure LoadFromStream( Stream: TStream );
  Published
  End;

  {-------------------------------------------------------------------------------}
  //                  TEzCADMemoryLayer
  {-------------------------------------------------------------------------------}

  TEzCADMemoryLayer = Class( TEzMemoryLayer )
  Public
    Procedure InitializeOnCreate( Const FileName: String; AttachedDB, IsAnimation: Boolean;
      CoordSystem: TEzCoordSystem; CoordsUnits: TEzCoordsUnits;
      FieldList: TStrings ); Override;
  End;


Implementation

Uses
  Inifiles, Ezconsts;

Procedure TEzCADMemoryLayer.InitializeOnCreate( Const FileName: String;
  AttachedDB, IsAnimation: Boolean; CoordSystem: TEzCoordSystem;
  CoordsUnits: TEzCoordsUnits; FieldList: TStrings );
Begin
  { initialize this layer
   Warning : this method is for internal use only and you must never call this method }
  FHeader.CoordsUnits := CoordsUnits;
  FHeader.IsIndexed := TRUE;
  FHeader.IsAnimationLayer := True;//FALSE;
  FHeader.UseAttachedDB := FALSE;
  If Frt <> Nil Then
    Frt.free;
  Frt := TMemRTree.Create( Self, RTYPE, fmCreate );
  Frt.CreateIndex( '', CoordMultiplier );
  If FDelStatus <> Nil Then
    FDelStatus.Free;
  FDelStatus := TBits.Create;
  Modified := true;
End;

{-------------------------------------------------------------------------------}
{                  TEzCAD - class implementation                             }
{-------------------------------------------------------------------------------}

Constructor TEzCAD.Create( Aowner: TComponent );
Begin
  Layers := TEzLayers.Create( Self );
  Inherited Create( AOwner );
  FMapInfo := TEzMapInfo.Create( self );
End;

Function TEzCAD.CreateLayer( Const LayerName: String; LayerType: TEzLayerType ): TEzBaseLayer;
Begin
  // ignored the parameter LayerType
  Result := TEzCADMemoryLayer.Create( Layers, ExtractFileName( LayerName ) );
End;

Procedure TEzCAD.WriteMapHeader( Const Filename: String );
Begin
  // nothing to do here
End;

Procedure TEzCAD.Open;
Var
  DwgStream: TStream;
Begin

  If IsDesigning Then Exit;
  Close;
  Inherited Open;

  If ( Length( FileName ) = 0 ) Or Not FileExists( FileName ) Then
  Begin
    Modified := false;
    Exit;
  End;

  { Is reading from a readonly file ?}
  If HasAttr( FileName, SysUtils.faReadOnly ) Then
    Self.ReadOnly := True;

  DwgStream := TFileStream.Create( FileName, OpenMode );
  Try
    LoadFromStream( DwgStream );
  Finally
    DwgStream.Free;
  End;

End;

procedure TEzCAD.Close;
var
  I: Integer;
begin
  inherited Close;
  for I:= 0 to Layers.Count-1 do
    Layers[I].Close;
end;

procedure TEzCAD.LoadFromStream(Stream: TStream);
Var
  LayerName: String;
  I, n, Index, hcount, vcount: Integer;
  TmpModified: Boolean;
  Coord: Double;
  AMapHeader: TEzMapHeader;
  Layer: TEzBaseLayer;
  RdPt: TEzPoint;
  Buff: TEzBufferedRead;
begin
  TmpModified := False;

  Buff := TEzBufferedRead.Create( Stream, SIZE_LONGBUFFER );
  Try
    Buff.Read( AMapHeader, sizeof( AMapHeader ) );
    If Not ( ( AMapHeader.HeaderID = MAP_ID ) And
      ( AMapHeader.VersionNumber = MAP_VERSION_NUMBER ) ) Then
    Begin
      MessageToUser( SWrongCADFile, smsgerror, MB_ICONERROR );
    End;

    Layers.Clear;
    For I := 0 To AMapHeader.NumLayers - 1 Do
    Begin
      Buff.Read( n, sizeof( n ) );
      LayerName := '';
      If n > 0 Then
      Begin
        SetLength( LayerName, n );
        Buff.Read( LayerName[1], n );
      End;
      // first, look in the same directory as the map opened
      Index := Layers.Add( LayerName, ltMemory );
      If Index >= 0 Then
      Begin
        Layer := Layers[Index];
        Layer.Open;
        If Layer Is TEzMemoryLayer Then
          TEzMemoryLayer( Layer ).LoadFromStream( Buff );
      End;
    End;
    // not used in CAD, the projection parameters
    ProjectionParams.Clear;

    { now read the guidelines}
    HGuidelines.Clear;
    VGuidelines.Clear;
    Buff.Read( hcount, sizeof( hcount ) );
    Buff.Read( vcount, sizeof( vcount ) );
    For I := 0 To hcount - 1 Do
    Begin
      Buff.Read( Coord, sizeof( Coord ) );
      HGuidelines.Add( Coord );
    End;
    If hcount > 0 Then
      HGuideLines.Sort;
    For I := 0 To vcount - 1 Do
    Begin
      Buff.Read( Coord, sizeof( Coord ) );
      VGuidelines.Add( Coord );
    End;
    If vcount > 0 Then
      VGuideLines.Sort;

    { now read the polygonal clipping area }
    ClipPolygonalArea.Clear;
    Buff.Read( n, sizeof( Integer ) );
    For I := 0 To n - 1 Do
    Begin
      Buff.Read( RdPt, sizeof( TEzPoint ) );
      ClipPolygonalArea.Add( RdPt );
    End;

    If ( Length( AMapHeader.AerialViewLayer ) > 0 ) And
      ( Layers.IndexOfName( AMapHeader.AerialViewLayer ) = -1 ) Then
    Begin
      AMapHeader.AerialViewLayer := '';
      Modified := true;
    End;
    If ( Length( AMapHeader.CurrentLayer ) > 0 ) And
      ( Layers.IndexOfName( AMapHeader.CurrentLayer ) < 0 ) And ( Layers.Count > 0 ) Then
      CurrentLayerName := Layers[0].Name
    Else If Assigned( OnCurrentLayerChange ) Then
      OnCurrentLayerChange( Self, AMapHeader.CurrentLayer );

    TEzMapInfo( FMapInfo ).MapHeader := AMapHeader;
  Finally
    Buff.Free;
  End;

  If Assigned( OnFileNameChange ) Then
    OnFileNameChange( Self );
  { Clear temp entities }
  For I := 0 To DrawBoxList.Count - 1 Do
    DrawBoxList[I].TempEntities.Clear;

  { redisplay the viewports }
  For I := 0 To DrawBoxList.Count - 1 Do
    With DrawBoxList[I] Do
    Begin
      Grapher.Clear;
      If Self.AutoSetLastView Then
        Grapher.SetViewTo( FMapInfo.LastView );
    End;

  Modified := TmpModified;
end;

procedure TEzCAD.SaveToStream(Stream: TStream);
Var
  I, n, hcount, vcount: Integer;
  LayerName: String;
  Coord: double;
  TheMapHeader: TEzMapHeader;
  WrPt: TEzPoint;
  Layer: TEzBaseLayer;
begin
  If DrawBoxList.Count > 0 Then
    FMapInfo.LastView := DrawBoxList[0].Grapher.CurrentParams.VisualWindow;
  // save the coord system
  TheMapHeader := TEzMapInfo( FMapInfo ).MapHeader;
  With TheMapHeader Do
  Begin
    HeaderID := MAP_ID;
    VersionNumber := MAP_VERSION_NUMBER;
    NumLayers := Layers.Count;
  End;
  TEzMapInfo( FMapInfo ).MapHeader := TheMapHeader;
  With Stream Do
  Begin
    Write( TheMapHeader, sizeof( TEzMapHeader ) );
    // now save the name of layers
    For I := 0 To TheMapHeader.NumLayers - 1 Do
    Begin
      Layer := Layers[I];
      LayerName := Layer.FileName;
      n := Length( LayerName );
      Write( n, sizeof( n ) );
      If n > 0 Then
        Write( LayerName[1], n );
      If Layer Is TEzMemoryLayer Then
        TEzMemoryLayer( Layer ).SaveToStream( Stream );
    End;

    // not used in CAD the projection parameters
    ProjectionParams.Clear;

    { save the guidelines }
    hcount := HGuideLines.Count;
    vcount := VGuideLines.Count;
    Write( hcount, sizeof( hcount ) );
    Write( vcount, sizeof( vcount ) );
    For I := 0 To hcount - 1 Do
    Begin
      Coord := HGuidelines[I];
      Write( Coord, sizeof( Coord ) );
    End;
    For I := 0 To vcount - 1 Do
    Begin
      Coord := VGuidelines[I];
      Write( Coord, sizeof( Coord ) );
    End;

    { Save the polygonal clipping area }
    n := ClipPolygonalArea.Count;
    Write( n, sizeof( n ) );
    For i := 0 To n - 1 Do
    Begin
      WrPt := ClipPolygonalArea[I];
      Write( WrPt, sizeof( TEzPoint ) );
    End;
  End;
end;

Procedure TEzCAD.SaveAs( Const FileName: String );
Var
  DwgStream: TFileStream;
  TmpFileName: String;
Begin
  If ( Length( FileName ) = 0 ) Or ReadOnly Then Exit;

  TmpFilename := self.FileName;
  Self.FileName := FileName;
  If TmpFilename <> self.FileName Then
  Begin
    If Assigned( OnFileNameChange ) Then
      OnFileNameChange( Self );
  End;

  DwgStream := TFileStream.Create( FileName, fmCreate );
  Try
    SaveToStream( DwgStream );
  Finally
    DwgStream.Free;
  End;

  Modified := False;

End;

End.
