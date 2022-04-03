unit EzImportBase;

{$I EZ_FLAG.PAS}
interface

Uses
  Controls, SysUtils, Classes, Windows, Db, Forms, Dialogs,
  EzLib, EzBase, EzBaseGIS, EzProjections ;

Type

  { TEzImportConverter }

  TEzImportConverter = Class
  Private
    FSourceCoordSystem: TEzCoordSystem;
    FDestinCoordSystem: TEzCoordSystem;
    FSourceProjector: TEzProjector;
    FDestinProjector: TEzProjector;
    Function EditProjector( Const Caption: String;
      Projector: TEzProjector; Var CoordSystem: TEzCoordSystem ): Boolean;
    Procedure Initialize;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Convert( Const SrcPt: TEzPoint ): TEzPoint;
    Function ConvertDistance( Const d: Double; const RefPt: TEzPoint ): Double;
    Function EditProjections( AutoChangeDestin: Boolean ): Boolean;
    Function DestinationUnits: TEzCoordsUnits;

    Property SourceCoordSystem: TEzCoordSystem Read FSourceCoordSystem Write FSourceCoordSystem;
    Property DestinCoordSystem: TEzCoordSystem Read FDestinCoordSystem Write FDestinCoordSystem;
    Property SourceProjector: TEzProjector Read FSourceProjector;
    Property DestinProjector: TEzProjector Read FDestinProjector;
  End;

  TEzFileProgressEvent = Procedure(Sender: TObject;
    Const Filename: String; Progress, NoEntities, BadEntities: Integer;
    Var CanContinue: Boolean) Of Object;

  TEzExternalFile = Class(TComponent)
  Private
    FDrawBox: TEzBaseDrawBox;
    FFileName: String;

    FOnFileProgress: TEzFileProgressEvent;
    Procedure SetDrawBox( Const Value: TEzBaseDrawBox );
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Published
    Property FileName: String Read FFileName Write FFileName;
    Property DrawBox: TEzBaseDrawBox Read FDrawBox Write SetDrawBox;

    Property OnFileProgress: TEzFileProgressEvent Read FOnFileProgress Write FOnFileProgress;
  End;

  TEzBaseImport = Class(TEzExternalFile)
  Private
    FConverter: TEzImportConverter;
    FAutoFreeConverter: Boolean;
    FImportToCurrent: Boolean;
    FConfirmProjectionSystem: Boolean;
    FShowAllMapOnFinish: Boolean;
    FLayerName: String;
    Procedure SetConverter( Value: TEzImportConverter );
  {$IFDEF BCB}
    function GetConfirmProjectionSystem: Boolean;
    function GetConverter: TEzImportConverter;
    function GetOverwrite: Boolean;
    procedure SetConfirmProjectionSystem(const Value: Boolean);
    procedure SetOverwrite(const Value: Boolean);
  {$ENDIF}
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function Execute: Boolean;
    Procedure ImportInitialize; Dynamic;
    Procedure GetSourceFieldList( FieldList: TStrings ); Dynamic;
    Procedure ImportFirst; Dynamic;
    Procedure AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer); Dynamic;
    Function GetSourceExtension: TEzRect; Dynamic;
    Function ImportEof: Boolean; Dynamic;
    Function GetNextEntity(var progress,entno: Integer): TEzEntity; Dynamic;
    Procedure ImportNext; Dynamic;
    Procedure ImportEnd; Dynamic;
    Function ImportFiles( FileList: TStrings ): Boolean;

    property LayerName: String read FLayerName write FLayerName;
    Property Converter: TEzImportConverter {$IFDEF BCB} Read GetConverter {$ELSE} Read FConverter {$ENDIF} Write SetConverter;
  Published
    Property Overwrite: Boolean {$IFDEF BCB} Read GetOverwrite Write SetOverwrite {$ELSE} Read FImportToCurrent Write FImportToCurrent {$ENDIF};
    Property ConfirmProjectionSystem: Boolean {$IFDEF BCB} Read GetConfirmProjectionSystem Write SetConfirmProjectionSystem {$ELSE} Read FConfirmProjectionSystem Write FConfirmProjectionSystem {$ENDIF} Default true;
    Property ShowAllMapOnFinish: Boolean read FShowAllMapOnFinish write FShowAllMapOnFinish;
  End;

  TEzBaseExport = Class(TEzExternalFile)
  Private
    FLayername: String;
  {$IFDEF BCB}
    function GetLayerName: String;
    procedure SetLayerName(const Value: String);
  {$ENDIF}
  Public
    Function Execute: Boolean;
    Procedure ExportInitialize; Dynamic;
    Procedure ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity ); Dynamic;
    Procedure ExportEnd; Dynamic;
  Published
    Property LayerName: String {$IFDEF BCB} Read GetLayerName Write SetLayerName {$ELSE} Read FLayerName Write FLayerName {$ENDIF};
  End;

implementation

Uses
  ezimpl, ezConsts, EzSystem, EzBasicCtrls, EzRtree, fProj ;

Procedure TEzExternalFile.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FDrawBox ) Then
    FDrawBox := Nil;
End;

Procedure TEzExternalFile.SetDrawBox( Const Value: TEzBaseDrawBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
    Value.FreeNotification( Self );
  FDrawBox := Value;
End;

{ TEzImportConverter }
Constructor TEzImportConverter.Create;
Begin
  Inherited Create;
  FSourceProjector := TEzProjector.Create( Nil );
  FDestinProjector := TEzProjector.Create( Nil );
End;

Destructor TEzImportConverter.Destroy;
Begin
  Inherited Destroy;
  FSourceProjector.free;
  FDestinProjector.free;
End;

Procedure TEzImportConverter.Initialize;
Begin
  If FSourceProjector.Params.Count = 0 Then
    FSourceProjector.InitDefault;
  If FDestinProjector.Params.Count = 0 Then
    FDestinProjector.InitDefault;
End;

Function TEzImportConverter.Convert( Const SrcPt: TEzPoint ): TEzPoint;
Var
  Long, Lat: Double;
Begin
  Case FSourceCoordSystem Of
    csCartesian:
      result := SrcPt;
    { if the source is actually a projection, then later can be changed in EzGIS }
    csLatLon:
      Case FDestinCoordSystem Of
        csCartesian, csLatLon:
          result := srcPt;
        csProjection:
          Begin
            If Not FDestinProjector.HasProjection Then
              EzGisError( SLatLonMismatch );
            FDestinProjector.CoordSysFromLatLong( SrcPt.X, SrcPt.Y, result.X, result.Y );
          End;
      End;
    csProjection:
      Case FDestinCoordSystem Of
        csCartesian: result := SrcPt; // no change
        csLatLon:
          FSourceProjector.CoordSysToLatLong( SrcPt.X, SrcPt.Y, Result.X, Result.Y );
        csProjection:
          Begin
            { convert first to lat/lon }
            FSourceProjector.CoordSysToLatLong( SrcPt.X, SrcPt.Y, Long, Lat );
            FDestinProjector.CoordSysFromLatLong( Long, Lat, Result.X, Result.Y );
          End;
      End;
  End;
End;

Function TEzImportConverter.ConvertDistance( Const d: Double; const RefPt: TEzPoint ): Double;
Var
  Long1, Lat1, Long2, Lat2: double;
  p1, p2: TEzPoint;
Begin
  result := d;
  Case FSourceCoordSystem Of
    csLatLon:
      If FDestinCoordSystem = csProjection Then
      Begin
        If Not FDestinProjector.HasProjection Then
          EzGisError( SLatLonMismatch );
        FDestinProjector.CoordSysFromLatLong( Long1, Lat1, p1.X, p1.Y );
        FDestinProjector.CoordSysFromLatLong( Long1, Lat1 + d, p2.X, p2.Y );
        result := abs( p1.y - p2.y );
      End;
    csProjection:
      If FDestinCoordSystem = csLatLon Then
      Begin
        { must convert first from meters to degrees }
        FSourceProjector.CoordSysToLatLong( RefPt.X, RefPt.Y, Long1, Lat1 );
        FSourceProjector.CoordSysToLatLong( RefPt.X, RefPt.Y + d, Long2, Lat2 );
        result := abs( Lat2 - lat1 );
      End;
  End;
End;

Function TEzImportConverter.EditProjector( Const Caption: String;
  Projector: TEzProjector; Var CoordSystem: TEzCoordSystem ): Boolean;
Var
  sl1, sl2: TStringList;
  I: Integer;
Begin
  result := false;
  sl1 := TStringList.create;
  sl2 := TStringList.create;
  Try
    If Projector.Params.Count = 0 Then
      Projector.InitDefault;
    If Projector.Params.Count > 2 Then
      For I := 0 To 2 Do
        sl1.Add( Projector.Params[I] );
    For I := 3 To Projector.Params.count - 1 Do
      sl2.Add( Projector.Params[I] );
    If fProj.SelectCoordSystem(Caption, CoordSystem, sl1, sl2, true) Then
    Begin
      If CoordSystem = csProjection Then
      Begin
        Projector.Params.Clear;
        Projector.Params.AddStrings( sl1 );
        Projector.Params.AddStrings( sl2 );
        Projector.CoordSysInit;
        { were the parameters given correctly ? }
        If Not Projector.HasProjection Then
        Begin
          MessageToUser( SWrongProjParams, SMsgError, MB_ICONERROR );
          Exit;
        End;
      End;
    End
    Else
      Exit;
  Finally
    sl1.free;
    sl2.free;
  End;
  result := true;
End;

Function TEzImportConverter.EditProjections( AutoChangeDestin: Boolean ): Boolean;
Begin
  Initialize;
  result := EditProjector( SProjEditSource, FSourceProjector, FSourceCoordSystem );
  If result = false Then
    exit;
  If AutoChangeDestin Then
  Begin
    FDestinCoordSystem := FSourceCoordSystem;
    FDestinProjector.Params.Assign( FSourceProjector.Params );
    FDestinProjector.CoordSysInit;
  End;
  result := EditProjector( SProjEditDestin, FDestinProjector, FDestinCoordSystem );
End;

Function TEzImportConverter.DestinationUnits: TEzCoordsUnits;
Var
  u: String;
Begin
  If FDestinCoordSystem = csLatLon Then
    Result := cuDeg
  Else
  Begin
    u := FDestinProjector.GC.pj_param.AsString( 'units' );
    If Length( u ) = 0 Then
      result := cuM
    Else
      Result := EzBase.UnitCodeFromID( u );
  End;
End;


{ TEzBaseImport }

constructor TEzBaseImport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfirmProjectionSystem := True;
  FConverter := TEzImportConverter.Create;
  FAutoFreeConverter := True;
end;

destructor TEzBaseImport.Destroy;
begin
  inherited Destroy;
  If FAutoFreeConverter And ( FConverter <> Nil ) Then
    FConverter.Free;
end;

{$IFDEF BCB}
function TEzBaseImport.GetConfirmProjectionSystem: Boolean;
begin
  Result := FConfirmProjectionSystem;
end;

function TEzBaseImport.GetConverter: TEzImportConverter;
begin
  Result := Converter;
end;

function TEzBaseImport.GetOverwrite: Boolean;
begin
  Result := FImportToCurrent;
end;

procedure TEzBaseImport.SetConfirmProjectionSystem(const Value: Boolean);
begin
  FConfirmProjectionSystem := Value;
end;

procedure TEzBaseImport.SetOverwrite(const Value: Boolean);
begin
  FImportToCurrent := Value;
end;
{$ENDIF}

Function TEzBaseImport.Execute: Boolean;
Var
  SourceExt, TmpExt: TEzRect;
  Source_emax: TEzPoint;
  Source_emin: TEzPoint;
  PrevLayerCount: Integer;
  FileWithoutExt, temps: String;
  DestCoordSystem: TEzCoordSystem;
  DestCoordsUnits: TEzCoordsUnits;
  Index: Integer;
  Layer: TEzBaseLayer;
  TmpEntity: TEzEntity;
  wasActive: boolean;
  FieldList: TStringList;
  I, NewRecno: Integer;
  Saved: TCursor;
  BadEntities, progress,entno: Integer;
  CanContinue: Boolean;
begin
  Result := False;

  If FDrawBox = Nil Then EzGisError( SWrongEzGIS );
  If FConverter = Nil Then EzGisError( SWrongProjector );
  If Length(Trim(FileName)) = 0 Then Exit;

  PrevLayerCount := FDrawBox.GIS.Layers.Count;

  FileWithoutExt:= ChangeFileExt(Filename, '') + '_';

  Self.ImportInitialize;    // do some initialization here and return the name of the file to generate

  { this method will try to configure the converter by guessing a coordinate
    system from the source file to import }

  If PrevLayerCount > 0 Then
  Begin
    FConverter.DestinCoordSystem := FDrawBox.GIS.MapInfo.CoordSystem;
    FConverter.DestinProjector.Params.Assign( FDrawBox.GIS.ProjectionParams );
  End;
  { Ask for the projection of the shapefile }
  If FConfirmProjectionSystem And
    Not FConverter.EditProjections( PrevLayerCount = 0 )
  Then
    Exit;

  DestCoordSystem := FConverter.DestinCoordSystem;
  DestCoordsUnits := FConverter.DestinationUnits;
  If PrevLayerCount = 0 Then
  Begin
    With FDrawBox.GIS Do
    Begin
      MapInfo.CoordSystem := FConverter.DestinCoordSystem;
      MapInfo.CoordsUnits := DestCoordsUnits;
      ProjectionParams.Assign( FConverter.DestinProjector.Params );
      Modified := True;
    End;
  End;

  { Exists a layer with that name already ? }
  If Not FImportToCurrent Then
  Begin
    //temps := EzSystem.GetValidLayerName( ExtractFileName( FileWithoutExt ) );
    temps := EzSystem.GetValidLayerName(FLayerName);
    Index := FDrawBox.GIS.Layers.IndexOfName( temps );
    If Index >= 0 Then
    Begin
      If MessageDlg( Format( SLayerAlreadyExists, [temps] ), mtConfirmation, [mbYes, mbNo], 0 ) = mrYes Then
      Begin
        // replace existing layer
        With FDrawBox.GIS Do
        Begin
          Layer := Layers[Index];
          wasActive := AnsiCompareText( MapInfo.CurrentLayer, Layer.Name ) = 0;
          Layers.Delete( Layer.Name, true );
          If wasActive And ( Layers.Count > 0 ) Then
            MapInfo.CurrentLayer := Layers[0].Name;
          If Layers.Count = 0 Then
            With MapInfo Do
            Begin
              Extension := INVALID_EXTENSION;
              CurrentLayer := '';
            End;
        End
      End Else
        Exit;
    End;

    FieldList := TStringList.Create;
    // copiar estructura de source file
    Try
      GetSourceFieldList( FieldList );

      Layer := FDrawBox.GIS.Layers.CreateNewEx(
//        ExtractFilePath(FDrawBox.GIS.FileName) + ExtractFileName(FileWithoutExt),
        ExtractFilePath(FDrawBox.GIS.FileName) + FLayerName,
        DestCoordSystem, DestCoordsUnits, FieldList);

    Finally
      FieldList.Free;
    End;
    If Layer = Nil Then
    Begin
      MessageToUser( SCannotCreateNewLayer, SMsgError, MB_ICONERROR );
      Exit;
    End;
  End
  Else
    Layer := FDrawBox.GIS.CurrentLayer;

  // set as active
  FDrawBox.GIS.MapInfo.CurrentLayer := Layer.Name;

  Layer.ForceOpened;
  Layer.StartBatchInsert;

  Self.ImportFirst;  // an initialization must be done here for importing

  Saved := Screen.Cursor;
  If FDrawBox.GIS.ShowWaitCursor Then
  Begin
    Screen.Cursor := crHourglass;
  End;

  CanContinue:= True;
  BadEntities:= 0;

  Try

    While Not Self.ImportEof Do    // ImportEof must return true when finished importing
    Begin

      Try
        TmpEntity := Self.GetNextEntity( progress,entno );   // GetNextEntity must return the next entity from source files

        { show progress messages }
        If Assigned(FOnFileProgress) Then
          FOnFileProgress(Self, FFilename, progress, entno, BadEntities, CanContinue);

        If Not CanContinue Then
        Begin
          If Assigned(TmpEntity) Then
            FreeAndNil( TmpEntity );
          Break;
        End;

        Try
          If TmpEntity = Nil Then
          Begin
            Inc( BadEntities );
            Continue;
          End;
          { convert from source coordinate system }
          Try
            TmpEntity.BeginUpdate;
            For I := 0 To TmpEntity.Points.Count - 1 Do
              TmpEntity.Points[I] := FConverter.Convert( TmpEntity.Points[I] );
            TmpEntity.EndUpdate;
            NewRecno := Layer.AddEntity( TmpEntity );
            If Layer.DBTable <> Nil Then
            Begin
              // AddSourceFieldData must position on record, ex.: Layer.DBTable.Recno:= NewRecno;
              Self.AddSourceFieldData( Layer, NewRecno );   // this method must add source database field to the current record
            End;
          Finally
            FreeAndNil( TmpEntity );
          End;
        Except
          On E: Exception Do
          Begin
            Inc( BadEntities ); // count number of bad entities and ignore error
          End;
        End;
      Finally
        Self.ImportNext;   // this method must advance to next valid record on source file
      End;
    End;

    { this method must retrieve the extension of the file imported }
    SourceExt:= Self.GetSourceExtension;
    If Not EqualRect2D( SourceExt, INVALID_EXTENSION ) Then
    Begin
      With SourceExt Do
      Begin
        source_emax := FConverter.Convert( Emax );
        source_emin := FConverter.Convert( Emin );
      End;
      With FDrawBox.GIS.MapInfo Do
      Begin
        If PrevLayerCount = 0 Then
        Begin
          TmpExt.Emax := source_emax;
          TmpExt.Emin := source_emin;
          Extension := TmpExt;
        End
        Else
        Begin
          TmpExt := Extension;
          MaxBound( TmpExt.Emax, source_emax );
          MinBound( TmpExt.Emin, source_emin );
          Extension := TmpExt;
        End;
      End;
    End;

  Finally
    Layer.FinishBatchInsert;
    Self.ImportEnd;      // this method must close the source file and/or other finalization
    If FDrawBox.GIS.ShowWaitCursor Then
      Screen.Cursor := Saved;
  End;

  Layer.WriteHeaders(True);
  FDrawBox.GIS.QuickUpdateExtension;
  If (PrevLayerCount = 0) Or FShowAllMapOnFinish Then
    With FDrawBox.GIS Do
      For I := 0 To DrawBoxList.Count - 1 Do
        DrawBoxList[I].ZoomToExtension;

  FDrawBox.GIS.Modified := true;

  Result := true;

end;

function TEzBaseImport.ImportFiles(FileList: TStrings): Boolean;
Var
  I: Integer;
  TmpFilename: String;
  TmpBool: Boolean;
Begin
  result := true;
  TmpBool := FConfirmProjectionSystem;
  TmpFilename := FFileName;
  Try
    For I := 0 To FileList.Count - 1 Do
    Begin
      FFileName := FileList[I];
      Execute;
      FConfirmProjectionSystem := False;
    End;
  Finally
    FFileName := TmpFilename;
    FConfirmProjectionSystem := TmpBool;
  End;
end;

procedure TEzBaseImport.SetConverter(Value: TEzImportConverter);
begin
  If ( FConverter <> Nil ) And FAutoFreeConverter Then
    FreeAndNil( FConverter );
  FConverter := Value;
  FAutoFreeConverter := False;
end;

procedure TEzBaseImport.ImportInitialize;
begin
  // nothing to do here
end;

Procedure TEzBaseImport.GetSourceFieldList( FieldList: TStrings );
Begin
End;

Procedure TEzBaseImport.ImportFirst;
begin
end;

Procedure TEzBaseImport.ImportEnd;
begin
end;

Function TEzBaseImport.ImportEof: Boolean;
Begin
  Result:= True;
End;

Procedure TEzBaseImport.ImportNext;
Begin
End;

Function TEzBaseImport.GetNextEntity(Var progress,entno: Integer): TEzEntity;
Begin
  Result:= Nil;
End;

Procedure TEzBaseImport.AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer);
Begin
End;

Function TEzBaseImport.GetSourceExtension: TEzRect;
Begin
  Result:= INVALID_EXTENSION;
End;

{ TEzBaseExport }

function TEzBaseExport.Execute: Boolean;
Var
  CanContinue: Boolean;
  Layer: TEzBaseLayer;
  I, nEntities: Integer;
  TmpEntity: TEzEntity;
  TmpClass: TEzEntityClass;
Begin
  If FDrawBox = Nil Then EzGisError( SWrongEzGIS );

  Layer := FDrawBox.GIS.Layers.LayerByName( FLayername );

  If Layer = Nil Then EzGisError( Format( SWrongLayername, [FLayername] ) );

  { create the shape file }
  ExportInitialize;
  Try
    Layer.ForceOpened;
    Layer.First;
    Layer.StartBuffering;
    Try
      nEntities := IMax( 1, Layer.RecordCount );
      I := 0;
      CanContinue := True;
      While Not Layer.Eof Do
      Begin
        Try
          With Layer Do
          Begin
            Inc( I );
            FOnFileProgress( Self, FFilename, Round( ( ( I + 1 ) / nEntities ) * 100 ), I, 0, CanContinue );
            If Not CanContinue Then Break;

            If RecIsDeleted Then Continue;

            TmpClass := GetClassFromID( RecEntityID );
            TmpEntity := TmpClass.Create( 4 );
            RecLoadEntity2( TmpEntity );
            Try
              ExportEntity(Layer, TmpEntity);
            Finally
              TmpEntity.Free;
            End;
          End;
        Finally
          Layer.Next;
        End;
      End;
    Finally
      Layer.EndBuffering;
    End;
  Finally
    Self.ExportEnd;
  End;
  result := true;
end;

{$IFDEF BCB}
function TEzBaseExport.GetLayerName: String;
begin
  Result:= FLayerName;
end;

procedure TEzBaseExport.SetLayerName(const Value: String);
begin
  FLayerName:= Value;
end;
{$ENDIF}

Procedure TEzBaseExport.ExportInitialize;
Begin
End;

Procedure TEzBaseExport.ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity );
Begin
End;

Procedure TEzBaseExport.ExportEnd;
Begin
End;

end.
