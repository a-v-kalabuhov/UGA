Unit EzOwnImport;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Controls, SysUtils, Classes, Windows, Dialogs, Db,
  EzLib, EzBase, EzBaseGIS, EzProjections, EzImportBase, EzCADCtrls;

Type

  { TEzOwnImport - Projector is used for the original .ezd file }
  TEzOwnImport = Class( TEzBaseImport )
  Private
    FTempCAD: TEzCAD;
    { for showing progress messages }
    nEntities: Integer;
    MyEntNo: Integer;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ImportInitialize; Override;
    Procedure GetSourceFieldList( FieldList: TStrings ); Override;
    Procedure ImportFirst; Override;
    Procedure AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer); Override;
    Function GetSourceExtension: TEzRect; Override;
    Function ImportEof: Boolean; Override;
    Function GetNextEntity(var progress,entno: Integer): TEzEntity; Override;
    Procedure ImportNext; Override;
    //Procedure ImportEnd; Override;  not needed here
  End;

  { TEzOwnExport - Projector is used for exporting to that projection }
  TEzOwnExport = Class( TEzBaseExport )
  Private
    FTempCAD: TEzCAD;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure ExportInitialize; Override;
    Procedure ExportEntity( SourceLayer: TEzBaseLayer; Entity: TEzEntity ); Override;
  End;

Implementation

Uses
  ezimpl, ezConsts, ezSystem, EzBasicCtrls, EzRtree, ezctrls ;

Constructor TEzOwnImport.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FTempCAD:= TEzCAD.Create(Nil);
End;

Destructor TEzOwnImport.Destroy;
Begin
  Inherited Destroy;
  FTempCAD.Free;
End;

Procedure TEzOwnImport.ImportInitialize;
Var
  SrcLayer: TEzBaseLayer;
Begin
  SrcLayer := TEzLayer.Create( FTempCAD.Layers, ChangeFileExt( Filename, '' ) );
  FTempCAD.ReadOnly:= True;
  SrcLayer.Open;
  With SrcLayer.LayerInfo.Extension Do
  Begin
    If Abs(Emax.x - Emin.x) <= 360 Then
    Begin
      { presumably source file is defined in degrees }
      Converter.SourceCoordSystem := csLatLon;
      If DrawBox.GIS.Layers.Count = 0 Then
        Converter.DestinCoordSystem := Converter.SourceCoordSystem;
    End;
  End;
  { initialize for progress messages }
  nEntities:= SrcLayer.RecordCount;   // this function must return the number of records to import
  MyEntNo := 0;
End;

Procedure TEzOwnImport.GetSourceFieldList( FieldList: TStrings );
Begin
  FTempCAD.Layers[0].GetFieldList(FieldList);
End;

Procedure TEzOwnImport.ImportFirst;
Begin
  FTempCAD.Layers[0].First;
End;

Procedure TEzOwnImport.AddSourceFieldData(DestLayer: TEzBaseLayer; DestRecno: Integer);
Var
  SourceLayer: TEzBaseLayer;
  J: Integer;
Begin
  SourceLayer:= FTempCAD.Layers[0];
  If (DestLayer.DBTable = Nil) Or (SourceLayer.DBTable = Nil) Then Exit;
  DestLayer.DBTable.Recno:= DestRecno;
  DestLayer.DBTable.BeginTrans;
  Try
    DestLayer.DBTable.Edit;
    SourceLayer.DBTable.Recno:= SourceLayer.Recno;
    For J := 1 To SourceLayer.DBTable.FieldCount Do
    Begin
      Try
        With DestLayer.DBTable Do
          AssignFrom( SourceLayer.DBTable, J, FieldNo( SourceLayer.DBTable.Field( J ) ) );
      Except
        // ignore error in fields in DBF file (wrong data)
      End;
    End;
    DestLayer.DBTable.Post;
    DestLayer.DBTable.EndTrans;
  Except
    DestLayer.DBTable.RollbackTrans;
    raise;
  End;
End;

Function TEzOwnImport.GetSourceExtension: TEzRect;
Begin
  FTempCAD.Layers[0].LayerInfo.Extension;
End;

Function TEzOwnImport.ImportEof: Boolean;
Begin
  Result:= FTempCAD.Layers[0].Eof;
End;

Function TEzOwnImport.GetNextEntity(var progress,entno: Integer): TEzEntity;
Begin
  Inc(MyEntNo);
  progress:= Round((MyEntNo / nEntities) * 100);
  entno:=MyEntNo;

  Result:=FTempCAD.Layers[0].RecLoadEntity;
End;

Procedure TEzOwnImport.ImportNext;
Begin
  FTempCAD.Layers[0].Next;
End;


{ TEzOwnExport }

constructor TEzOwnExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTempCAD:= TEzCAD.Create(Nil);
end;

destructor TEzOwnExport.Destroy;
begin
  FTempCAD.Free;
  inherited;
end;

procedure TEzOwnExport.ExportInitialize;
var
  Layer: tEzBaseLayer;
begin
  Layer:= TEzLayer.Create( FTempCAD.Layers, ChangeFileExt( FileName, '' ) );
  Layer.Open;
end;

procedure TEzOwnExport.ExportEntity(SourceLayer: TEzBaseLayer; Entity: TEzEntity);
var
  DestLayer: TEzBaseLayer;
  J, TheRecno: Integer;
  FSource, FDest: Integer;
Begin
  If ( Entity.Points.Parts.Count = 0 ) And ( Entity.Points.Count = 2 ) Then
    Entity.Points.Add( Entity.Points[0] );

  DestLayer:= FTempCAD.Layers[0];

  TheRecno:= DestLayer.AddEntity( Entity );
  If (SourceLayer.DBTable <> Nil) And (DestLayer.DBTable <> Nil) Then
  Begin
    DestLayer.DBTable.Recno:= TheRecno;
    DestLayer.DBTable.Edit;
    // write the new DBF shapefile record
    SourceLayer.DBTable.Recno := SourceLayer.Recno;
    For j := 1 To SourceLayer.DBTable.FieldCount Do
    Begin
      FSource := J;
      FDest := DestLayer.DBTable.FieldNo( SourceLayer.DBTable.Field( J ) );
      If FDest <> 0 Then
      Begin
        Try
          DestLayer.DBTable.AssignFrom( SourceLayer.DBTable, FSource, FDest );
        Except
          // probably caused by corrupted data
        End;
      End;
    End;
    DestLayer.DBTable.Post;
  End;
end;

End.
