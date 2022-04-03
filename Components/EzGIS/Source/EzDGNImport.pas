Unit EzDGNImport;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, Forms,
  Dialogs, EzLib, EzBaseGIS, ezbase, EzSHPImport, EzCADCtrls,
  EzDgnLayer, EzImportBase;

Type

  TEzDGNImport = Class( TComponent )
  Private
    FDrawBox: TEzBaseDrawBox;
    FConverter: TEzImportConverter;
    FMustDeleteConverter: Boolean;
    FConfirmProjectionSystem: Boolean;
    FUseTrueType: Boolean;
    FUseDefaultColorTable: Boolean;

    FDgnFile : TEzDGNFile;

    FTargetNames: TStrings;
    FGenerateMultiLayers: Boolean;

    FFileName: String;

    //Canceled: Boolean; //Check for Canceling.

    FCad: TEzCad;  // the CAD used to read the file
    FCol0: TIntegerList;  // follows the columns that goes to the database file
    FCol1: TStrings;
    FCol2: TIntegerList;
    FCol3: TEzDoubleList;

    FOnFileProgress: TEzFileProgressEvent;
    FLayerName: String;

    Procedure SetDrawBox( value: TEzBaseDrawBox );
    Procedure SetConverter( Value: TEzImportConverter );
    Procedure ConvertPoint(Sender: TObject; Var P: TEzPoint );
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Function ReadDGN: Boolean;
    Function Execute: Boolean;
    Function ImportFiles( FileList: TStrings ): Boolean;

    Property Converter: TEzImportConverter Read FConverter Write SetConverter;
    Property Cad: TEzCad Read FCad;
    Property Col0: TIntegerList read FCol0;
    Property Col1: TStrings read FCol1;
    Property Col2: TIntegerList read FCol2;
    Property Col3: TEzDoubleList read FCol3;
    Property TargetNames: TStrings read FTargetNames;
    Property GenerateMultiLayers: Boolean read FGenerateMultiLayers write FGenerateMultiLayers;
  Published
    Property FileName: String Read FFileName Write FFileName;
    property LayerName: String read FLayerName write FLayerName;
    Property DrawBox: TEzBaseDrawBox Read FDrawBox Write SetDrawBox;
    Property ConfirmProjectionSystem: Boolean Read FConfirmProjectionSystem Write FConfirmProjectionSystem Default true;
    Property UseTrueType: Boolean read FUseTrueType write FUseTrueType default true;
    Property UseDefaultColorTable: Boolean read FUseDefaultColorTable write FUseDefaultColorTable Default False;

    Property OnFileProgress: TEzFileProgressEvent Read FOnFileProgress Write FOnFileProgress;
  End;

Implementation

Uses
  ezimpl, ezConsts, ezSystem, EzEntities, ezbasicctrls, Math ;

  { TEzDGNImport }

Constructor TEzDGNImport.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FCad:= TEzCad.Create( Nil );
  FCad.CreateNew('dummy');

  FCol0 := TIntegerList.Create;
  FCol1 := TStringList.Create;
  FCol2 := TIntegerList.Create;
  FCol3 := TEzDoubleList.Create;

  //Canceled := FALSE;
  FFileName := Filename;
  FConverter := TEzImportConverter.Create;
  FUseTrueType:= True;

  FTargetNames:= TStringList.Create;

  FDgnFile:= TEzDGNFile.Create;

  //FUseDefaultColorTable:= True;
End;

Destructor TEzDGNImport.Destroy;
Begin
  Inherited Destroy;
  FConverter.Free;
  FCad.free;
  FCol0.free;
  FCol1.free;
  FCol2.free;
  FCol3.free;
  FTargetNames.Free;
  FDgnFile.Free;
End;

Procedure TEzDGNImport.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FDrawBox ) Then
    FDrawBox := Nil;
End;

Procedure TEzDGNImport.SetDrawBox( Value: TEzBaseDrawBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
  begin
    Value.FreeNotification( Self );
  end;
  FDrawBox := Value;
End;

Type

  EDGNError = Class( Exception );


Function TEzDGNImport.Execute: Boolean;
var
  temps: string;
  FileWithoutExt: string;
  I, J, Index: Integer;
  LIndex: Integer;
  Layer: TEzBaseLayer;
  wasActive: Boolean;
  FieldList : TStringList;
  SrcLayer: TEzBaseLayer;
  TheRecno: Integer;
  PrevLayerCount: integer;
  TmpEntity: TEzEntity;
  DataIndex: Integer;
  ImportCnt: integer;
  CurrCnt: integer;
  CanContinue: boolean;
  DestCoordSystem: TEzCoordSystem;
  DestCoordsUnits: TEzCoordsUnits;
Begin
  Result := False;
  Assert( FDrawBox <> Nil );
  Assert( FDrawBox.Gis <> Nil );
  Assert( FConverter <> Nil );

  PrevLayerCount := FDrawBox.GIS.Layers.Count;

  FileWithoutExt := ChangeFileExt( FFileName, '' );

  DestCoordSystem:= FConverter.DestinCoordSystem;
  DestCoordsUnits:= FConverter.DestinationUnits;
  If PrevLayerCount = 0 Then
    With FDrawBox.GIS Do
    Begin
      MapInfo.CoordSystem := DestCoordSystem;
      MapInfo.CoordsUnits := DestCoordsUnits;
      ProjectionParams.Assign( FConverter.DestinProjector.Params );
      Modified := True;
    End;

  Application.ProcessMessages;

  Screen.Cursor:= crHourglass;
  try

    { count the elements to import }
    ImportCnt:= 0;
    For LIndex:= 0 to FCad.Layers.Count-1 do
    begin
      SrcLayer:= FCad.Layers[LIndex];
      If Not SrcLayer.LayerInfo.Visible then Continue;
      Inc( ImportCnt, SrcLayer.RecordCount );
    end;
    CurrCnt:= 0;
    CanContinue:= True;

    If FGenerateMultiLayers then
    begin

      DataIndex:= -1;

      For LIndex:= 0 to FCad.Layers.Count-1 do
      begin
        SrcLayer:= FCad.Layers[LIndex];
        If Not SrcLayer.LayerInfo.Visible then Continue;

        temps := ezsystem.GetValidLayerName( FTargetNames[LIndex] ) ;
        Index := DrawBox.GIS.Layers.IndexOfName( temps );
        If Index >= 0 Then
        Begin
          // replace existing layer
          With DrawBox.GIS Do
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
            //Layer.LayerInfo.CoordsUnits := MapInfo.CoordsUnits;
          End
        End;

        FieldList := TStringList.Create;
        Try

          FieldList.Add( 'UID;N;12;0' );
          FieldList.Add( 'ELE_TYPE;N;2;0' );
          FieldList.Add( 'ELE_STR;C;20;0' );
          FieldList.Add( 'DIMENSION;N;1;0' );
          FieldList.Add( 'Z;N;20;4' );

          Layer := DrawBox.GIS.Layers.CreateNewEx(
            ExtractFilePath( DrawBox.GIS.FileName ) + temps, DestCoordSystem,
            DestCoordsUnits, FieldList );

        Finally
          FieldList.Free;
        End;

        If Layer = Nil Then
        Begin
          MessageToUser( SCannotCreateNewLayer, SMsgError, MB_ICONERROR );
          Exit;
        End;

        Layer.ForceOpened;
        Layer.StartBatchInsert;
        try
          SrcLayer.First;
          While Not SrcLayer.Eof do
          begin
            Inc(CurrCnt);
            FOnFileProgress( Self, FFilename, Round( ( ( CurrCnt + 1 ) / ImportCnt ) * 100 ), CurrCnt, 0, CanContinue );
            If Not CanContinue Then Break;

            TmpEntity:= SrcLayer.RecLoadEntity;
            try
              { convert from source coordinate system }
              TmpEntity.BeginUpdate;
              For J := 0 To TmpEntity.Points.Count - 1 Do
                TmpEntity.Points[J] := FConverter.Convert( TmpEntity.Points[J] );
              TmpEntity.EndUpdate;

              TheRecno:= Layer.AddEntity( TmpEntity );

              If Layer.DBTable <> Nil Then
              Begin
                Inc( DataIndex );
                with Layer.DBTable do
                begin
                  Recno:= TheRecno;
                  Edit;
                  IntegerPut( 'ELE_TYPE', FCol0[DataIndex] );
                  StringPut( 'ELE_STR', Copy(FCol1[DataIndex],1,20) );
                  IntegerPut( 'DIMENSION', FCol2[DataIndex] );
                  FloatPut( 'Z', FCol3[DataIndex] );
                  Post;
                end;
              End;

            finally
              TmpEntity.Free;
            end;

            SrcLayer.Next;
          end;
        finally
          Layer.FinishBatchInsert;
        end;
        Layer.Modified := true;
      end;
    end else
    begin
      { Exists a layer with that name already ? }

//      temps := ezsystem.GetValidLayerName( ExtractFileName( FileWithoutExt ) );
      temps := ezsystem.GetValidLayerName(FLayerName);
      Index := DrawBox.GIS.Layers.IndexOfName( temps );
      If Index >= 0 Then
      Begin
        If MessageDlg( Format( SLayerAlreadyExists, [temps] ), mtConfirmation, [mbYes, mbNo], 0 ) = mrYes Then
          // replace existing layer
          With DrawBox.GIS Do
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
            //Layer.LayerInfo.CoordsUnits := MapInfo.CoordsUnits;
          End
        Else
          Exit;
      End;

      FieldList := TStringList.Create;
      Try

        FieldList.Add( 'UID;N;12;0' );
        FieldList.Add( 'ELE_TYPE;N;2;0' );
        FieldList.Add( 'ELE_STR;C;20;0' );
        FieldList.Add( 'DIMENSION;N;1;0' );
        FieldList.Add( 'Z;N;20;4' );

        Layer := DrawBox.GIS.Layers.CreateNewEx( ExtractFilePath( DrawBox.GIS.FileName ) +
                   temps, DestCoordSystem, DestCoordsUnits, FieldList );

      Finally
        FieldList.Free;
      End;

      If Layer = Nil Then
      Begin
        MessageToUser( SCannotCreateNewLayer, SMsgError, MB_ICONERROR );
        Exit;
      End;

      DataIndex:= -1;

      Layer.ForceOpened;
      Layer.StartBatchInsert;
      try
        For LIndex:= 0 to FCad.Layers.Count-1 do
        begin
          SrcLayer:= FCad.Layers[LIndex];
          If Not SrcLayer.LayerInfo.Visible then Continue;
          SrcLayer.First;
          While Not SrcLayer.Eof do
          begin
            Inc(CurrCnt);
            FOnFileProgress( Self, FFilename,
              Round( ( ( CurrCnt + 1 ) / ImportCnt ) * 100 ), CurrCnt, 0,
              CanContinue );
            If Not CanContinue Then Break;

            TmpEntity:= SrcLayer.RecLoadEntity;
            try
              { convert from source coordinate system }
              {TmpEntity.BeginUpdate;
              For J := 0 To TmpEntity.Points.Count - 1 Do
                TmpEntity.Points[J] := FConverter.Convert( TmpEntity.Points[J] );
              TmpEntity.EndUpdate; }

              TheRecno:= Layer.AddEntity( TmpEntity );

              If Layer.DBTable <> Nil Then
              Begin
                Inc( DataIndex );
                with Layer.DBTable do
                begin
                  Recno:= TheRecno;
                  BeginTrans;
                  Edit;
                  IntegerPut( 'ELE_TYPE', FCol0[DataIndex] );
                  StringPut( 'ELE_STR', Copy(FCol1[DataIndex],1,20) );
                  IntegerPut( 'DIMENSION', FCol2[DataIndex] );
                  FloatPut( 'Z', FCol2[DataIndex] );
                  Post;
                  EndTrans;
                end;
              End;

            finally
              TmpEntity.Free;
            end;

            SrcLayer.Next;
          end;
        end;
      finally
        Layer.FinishBatchInsert;
      end;
      Layer.Modified := true;

    End;

    { sort by name }
    If FGenerateMultiLayers then
      DrawBox.GIS.Layers.Sort;

    {With DrawBox.GIS.MapInfo Do
    Begin
      emax := FConverter.Convert( emax );
      emin := FConverter.Convert( emin );
      If PrevLayerCount = 0 Then
      Begin
        rtemp.Emax := emax;
        rtemp.Emin := emin;
        Extension := rtemp;
      End
      Else
      Begin
        rtemp := Extension;
        MaxBound( rtemp.Emax, emax );
        MinBound( rtemp.Emin, emin );
        Extension := rtemp;
      End;
    End; }
  finally
    Screen.Cursor:= crDefault;
  end;

  DrawBox.GIS.QuickUpdateExtension;
  If PrevLayerCount = 0 Then
    With DrawBox.GIS Do
      For I := 0 To DrawBoxList.Count - 1 Do
        DrawBoxList[I].ZoomToExtension;

End;

Procedure TEzDGNImport.ConvertPoint(Sender: TObject; Var P: TEzPoint );
Begin
  P:= FConverter.Convert( P ) ;
End;

Function TEzDGNImport.ReadDGN: Boolean;
Var
  element_Type: Integer;
  element_level: Integer;
  _3Dz: Double;
  PlanOfEle: integer;
  element_str: String;
  TmpEntity: TEzEntity;
  Layer: TEzBaseLayer;
  i: integer;
  OldCursor: TCursor;
  PrevLayerCount: Integer;
Begin

  Assert( (FDrawBox <> Nil) And (FDrawBox.GIS <> Nil) And ( FConverter <> Nil ) );

  Result := False;

  If Not FileExists( FFileName ) Then
  Begin
    MessageToUser( Format( SShpFileNotFound, [FFileName] ), smsgerror, MB_ICONERROR );
    Exit;
  End;

  { configure the projection for this source file }
  PrevLayerCount := FDrawBox.GIS.Layers.Count ;
  If PrevLayerCount > 0 Then
  begin
    With FDrawBox.GIS, FConverter Do
    Begin
      FConverter.DestinCoordSystem := MapInfo.CoordSystem;
      FConverter.DestinProjector.Params.Assign( ProjectionParams );
    End;
  end;

  If FConfirmProjectionSystem And
     Not FConverter.EditProjections( PrevLayerCount = 0 ) Then Exit;

  Application.ProcessMessages;

  FDGNFile.Close;
  FDGNFile.FileName := FFileName;
  FDGNFile.UseDefaultColorTable:= FUseDefaultColorTable;
  FDGNFile.UseTrueType:= Self.FUseTrueType;
  { assign the converter event for converting points from one coord system to another}
  FDGNFile.OnConvertPoint := Self.ConvertPoint;

  //Canceled := False;

  FCAD.UpdateExtension;

  FTargetNames.Clear;

  OldCursor:= Screen.Cursor;
  Screen.Cursor:= crHourglass;
  Try

    { open file and read offsets for every element }
    FDGNFile.Open;

    For I:= 0 to FDGNFile.RecordCount-1 do
    begin
      TmpEntity:= FDGNFile.GetElement(I, element_type, element_level, PlanOfEle,
        element_str, _3Dz ) ;
      If TmpEntity = Nil then Continue;
      Try

        Layer:= FCad.Layers.LayerByName( Format('A%.2d', [element_level] )  );
        if Layer = Nil then
        begin
          Layer := FCad.Layers.CreateNew( Format('A%.2d', [element_level] )  );
          FTargetNames.Add( Layer.Name );
        end;

        Layer.AddEntity( TmpEntity );

        FCol0.Add( element_type );
        FCol1.Add( element_str );
        FCol2.Add( PlanOfEle );
        FCol3.Add( _3Dz );

      Finally
        TmpEntity.Free;
      End;
    end;
  Finally
    Screen.Cursor:= OldCursor;
  End;

  If FCad.Layers.Count > 0 then
    FCad.MapInfo.CurrentLayer := FCad.Layers[0].Name;

  Result := True;
End;

Function TEzDGNImport.ImportFiles( FileList: TStrings ): Boolean;
Var
  I: Integer;
  TmpFilename: String;
  TmpBool: Boolean;
Begin
  result := false;
  TmpBool := FConfirmProjectionSystem;
  TmpFilename := FFileName;
  Try
    For I := 0 To FileList.Count - 1 Do
    Begin
      FFileName := FileList[I];
      Execute;
      FConfirmProjectionSystem := false;
    End;
  Finally
    FFileName := TmpFilename;
    FConfirmProjectionSystem := TmpBool;
  End;
End;

Procedure TEzDGNImport.SetConverter( Value: TEzImportConverter );
Begin
  If ( FConverter <> Nil ) And FMustDeleteConverter Then
    FreeAndNil( FConverter );
  FConverter := Value;
  FMustDeleteConverter := False;
End;

End.
