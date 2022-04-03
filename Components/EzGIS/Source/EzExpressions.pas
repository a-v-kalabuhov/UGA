unit EzExpressions;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, StdCtrls, Forms,
  EzBaseGIS, EzBase, EzBaseExpr, EzLib, EzEntities, IniFiles;

Type

  {----------------------------------------------------------------------------}
  {                  Expression evaluator section                              }
  {----------------------------------------------------------------------------}

  { TEzMainExpr }
  TEzMainExpr = Class
  Private
    FDefaultLayer: TEzBaseLayer;
    FGIS: TEzBaseGIS;
    FHasUDFs: Boolean;
    FCheckStr: String;
    FOrderByList: TList;
    FDescending: TBits;
    FClosestMax: Integer;
    Procedure IDFunc( Sender: TObject; Const Group, Identifier: String;
      ParameterList: TParameterList; Var ReturnExpr: TExpression );
    Procedure ClearOrderBy;
    function GetOrderBy(Index: Integer): TExpression;
    function GetDescending(Index: Integer): Boolean;
  Public
    Expression: TExpression;
    Constructor Create( GIS: TEzBaseGIS; Layer: TEzBaseLayer );
    Destructor Destroy; Override;
    Procedure ParseExpression( Const s: String );
    Function CheckExpression( Const s, CheckforThis: String ): Boolean;
    Function OrderByCount: Integer;

    Property HasUDFs: Boolean Read FHasUDFs;
    Property Gis: TEzBaseGis Read FGis;
    Property DefaultLayer: TEzBaseLayer Read FDefaultLayer;
    Property OrderByList[Index: Integer]: TExpression read GetOrderBy;
    Property OrderDescending[Index: Integer]: Boolean read GetDescending;
    Property ClosestMax: Integer read FClosestMax write FClosestMax;
  End;

  TEzExprList = Class
  Private
    FItems: TList;
    Function GetItem( Index: Integer ): TEzMainExpr;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add( Value: TEzMainExpr );
    Function Count: Integer;

    { properties }
    Property Items[Index: Integer]: TEzMainExpr Read GetItem; Default;
  End;

  TEntExpr = Class( TFunction )
  Private
    FGIS: TEzBaseGIS;
    FLayer: TEzBaseLayer;
  Protected
    Function GetAsString: String; Override;
    Function GetExprType: TExprType; Override;
    Function GetMaxString: String; Override;
  Public
    Constructor Create( ParameterList: TParameterList;
      GIS: TEzBaseGIS; Layer: TEzBaseLayer );
  End;

  { This is for the following syntax;
    VECTOR( [ (10,10),(20,20),(30,30),(40,40),(50,50),(10,10) ] )
    and is used mainly to be passed as parameters to other special syntax
    this function will be of type ttBoolean and will return
    true if the vector consist of 1 or more points and false otherwise }

  TEzVectorType = (vtUndefined, vtPolyline, vtPolygon, vtBuffer);

  TEzVectorExpr = Class( TFunction )
  Private
    FVector: TEzVector;
    FVectorType: TEzVectorType;
    FBufferWidth: Double;
  {$IFDEF BCB}
    function GetVector: TEzVector;
  {$ENDIF}
  Protected
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList; Vector: TEzVector;
      VectorType: TEzVectorType; const BufferWidth: Double );
    Destructor Destroy; Override;
    property Vector: TEzVector {$IFDEF BCB} read GetVector {$ELSE} read FVector {$ENDIF};
  End;

  { this is used as a parameter for other expressions and return the following
    an integer that can be typecasted the following way

    case TEzGraphicOperator(xx.AsInteger) }

  TEzGraphicOperatorExpr = Class( Tfunction )
  Private
    FGraphicOperator: TEzGraphicOperator;
  Protected
    Function GetAsInteger: Integer; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList;
      GraphicOperator: TEzGraphicOperator );
  End;

  { This is required for supporting the following syntax :
    CITIES_.ENT graphic_operator VECTOR([(10,10),(20,20),(30,30),(40,40),(50,50),(10,10)])
  }
  TEzQueryVectorExpr = Class( TFunction )
  Private
    FMainExpr: TEzMainExpr;
    FRecordList: TBits;
    FMinRecno: Integer;
    FMaxRecno: Integer;
    FPrimaryLayer: TEzBaseLayer;
  {$IFDEF BCB}
    function GetPrimaryLayer: TEzBaseLayer;
  {$ENDIF}
  Protected
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList;
      MainExpr: TEzMainExpr );
    Destructor Destroy; Override;
    Property PrimaryLayer: TEzBaseLayer {$IFDEF BCB} read GetPrimaryLayer {$ELSE} read FPrimaryLayer {$ENDIF};
  End;

  { This is for the following syntax :
    CITIES_.ENT graphic_operator STATES_.ENT SCOPE ("STATES_.NAME LIKE 'A%'") }

  TEzQueryScopeExpr = Class( TFunction )
  Private
    FMainExpr: TEzMainExpr;
    FRecordList: TBits;
    FMinRecno: Integer;
    FMaxRecno: Integer;
    FPrimaryLayer: TEzBaseLayer;
  {$IFDEF BCB}
    function GetPrimaryLayer: TEzBaseLayer;
  {$ENDIF}
  Protected
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList;
      MainExpr: TEzMainExpr );
    Destructor Destroy; Override;
    Property PrimaryLayer: TEzBaseLayer {$IFDEF BCB} read GetPrimaryLayer {$ELSE} read FPrimaryLayer {$ENDIF};
  End;

  { This is required for supporting the following syntax :
    CITIES_.ENT ENTIRELY WITHIN STATES_.ENT SCOPE (STATES_.STATE_NAME IN ("Oklahoma", "Washington") ) AND CITIES_.CITY_NAME > 'C'"
    STATES_.ENT ENTIRELY WITHIN VECTOR ( [
      (-122.55, 49.56), (-125.27, 49.22), (-125.32, 46.86), (-125.09, 45.23), (-124.20, 44.12), (-122.49, 44.48),
      (-122.11, 45.30), (-120.41, 45.70), (-118.88, 45.99), (-120.70, 47.46), (-119.34, 48.00), (-120.35, 49.07),
      (-121.89, 49.15) , (-122.55, 49.56) ] )

    and the list of integers are the list of records against to compare
    if no record number listed, then all the records in the layer are used
  }

  TEzQueryLayerExpr = Class( TFunction )
  Private
    FMainExpr: TEzMainExpr;
    FRecordList: TBits;
    FMinRecno: Integer;
    FMaxRecno: Integer;
    FPrimaryLayer: TEzBaseLayer;
  {$IFDEF BCB}
    function GetPrimaryLayer: TEzBaseLayer;
  {$ENDIF}
  Protected
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList; MainExpr: TEzMainExpr );
    Destructor Destroy; Override;
    Property PrimaryLayer: TEzBaseLayer {$IFDEF BCB} read GetPrimaryLayer {$ELSE} read FPrimaryLayer {$ENDIF};
  End;

implementation

Uses
  EzExprLex, EzExprYacc, EzLexLib, EzYaccLib, EzConsts, Ezpolyclip,
  EzGraphics, ezrtree, EzSystem;


{ TEzExprList }

Constructor TEzExprList.Create;
Begin
  Inherited Create;
  FItems := TList.Create;
End;

Destructor TEzExprList.Destroy;
Var
  I: Integer;
Begin
  For I := 0 To FItems.Count - 1 Do
    TEzMainExpr( FItems[I] ).Free;
  FItems.Free;
  Inherited Destroy;
End;

Procedure TEzExprList.Add( Value: TEzMainExpr );
Begin
  FItems.Add( Value );
End;

Function TEzExprList.Count: Integer;
Begin
  result := FItems.Count;
End;

Function TEzExprList.GetItem( Index: Integer ): TEzMainExpr;
Begin
  result := FItems[Index];
End;

{-------------------------------------------------------------------------------}
{ Start of section of expression evaluator                                      }
{-------------------------------------------------------------------------------}

  (* These are the classes derived from EzBaseExpr.TFunction that will be used
     in EzGis... *)

  (* --- This is used to solve an external reference ---
    In this, you can evaluate all kind of expression because in event
    TEzBaseGIS.FunctionSolve will be passed the Layer and the
    requested parameters. The main purpose is to extract information
    you need to show (labels) or reflect (thematic maps) in the maps.
    The source of this info can be a Client/Server SQL or whatever.
    Also can be used to add functions not included like ATAN(VALUE),
    or some other entity functions (example: a summary of some field) *)
Type

  TUDFExpr = Class( TFunction )
  Private
    FLayer: TEzBaseLayer;
    FGIS: TEzBaseGIS;
    FIdentifier: String;
    FDataType: TExprType;
    FMaxLen: Integer;
  Protected
    Function GetAsString: String; Override;
    Function GetAsFloat: Double; Override;
    Function GetAsInteger: Integer; Override;
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
    Function GetMaxString: String; Override;
  Public
    Constructor Create( ParameterList: TParameterList;
      GIS: TEzBaseGIS; Layer: TEzBaseLayer; Const Identifier: String;
      DataType: TExprType; MaxLen: Integer );
  End;

  { Extract the value from a field in the native table
  Note: the "native" table is the DB file that is attached to
  a layer. Example: in layer "MYLAYER" exists files: MYLAYER.ENT,
  MYLAYER.ENX, and MYLAYER.DBF, then "native" table refers to file MYLAYER.DBF}
  TNativeExpr = Class( TFunction )
  Private
    fLayer: TEzBaseLayer;
    fField: Integer; {the field that the expression refers to}
  Protected
    Function GetAsString: String; Override;
    Function GetAsFloat: Double; Override;
    Function GetAsInteger: Integer; Override;
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
    Function GetMaxString: String; Override;
  Public
    Constructor Create( ParameterList: TParameterList;
      Layer: TEzBaseLayer; F: Integer );
  End;

  (* This class extract information about entities like: area, perimeter
     max extents, centroid, color, fillcolor, etc.
     First and only parameter must be an expresion of type TEntExpr *)
  TEntityOperator =
    ( opArea, opPerimeter, opMaxExtentX, opMaxExtentY,
    opMinExtentX, opMinExtentY, opCentroidX, opCentroidY, opType, opColor,
    opFillColor, opText, opLayerName, opPointsList );

  TEntityOpExpr = Class( TFunction )
  Private
    FGIS: TEzBaseGIS; // copied verbatim from parameter TEntExpr
    FLayer: TEzBaseLayer;
    FOperator: TEntityOperator;
  Protected
    Function GetAsString: String; Override;
    Function GetAsFloat: Double; Override;
    Function GetAsInteger: Integer; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList; Operator: TEntityOperator );
  End;

  // given red,green and blue return the TColor
  TRGBExpr = Class( TFunction )
  Protected
    Function GetAsInteger: Integer; Override;
    Function GetExprType: TExprType; Override;
  End;

  TDistanceExpr = Class( TFunction )
  Protected
    Function GetAsFloat: Double; Override;
    Function GetExprType: TExprType; Override;
  End;

  TNowExpr = Class( TFunction )
  Protected
    Function GetAsFloat: Double; Override;
    Function GetExprType: TExprType; Override;
  End;

  TToDateExpr = Class( TFunction )
  Protected
    Function GetAsFloat: Double; Override;
    Function GetExprType: TExprType; Override;
  End;

  TToNumExpr = Class( TFunction )
  Protected
    Function GetAsFloat: Double; Override;
    Function GetExprType: TExprType; Override;
  End;

  { returns if an expression is selected
    will only be valid for first viewport}
  TIsSelectedExpr = Class( TFunction )
  Private
    FLayer: TEzBaseLayer;
    FGIS: TEzBaseGIS;
  Protected
    Function GetAsBoolean: Boolean; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList );
  End;

  TRecNoExpr = Class( TFunction )
  Private
    FLayer: TEzBaseLayer;
  Protected
    Function GetAsInteger: Integer; Override;
    Function GetExprType: TExprType; Override;
  Public
    Constructor Create( ParameterList: TParameterList; Layer: TEzBaseLayer );
  End;

{ TEzGraphicOperatorExpr }

Constructor TEzGraphicOperatorExpr.Create( ParameterList: TParameterList;
  GraphicOperator: TEzGraphicOperator );
Begin
  Inherited Create( ParameterList );
  FGraphicOperator := GraphicOperator;
End;

Function TEzGraphicOperatorExpr.GetAsInteger: Integer;
Begin
  result := Ord( FGraphicOperator );
End;

Function TEzGraphicOperatorExpr.GetExprType: TExprType;
Begin
  result := ttInteger;
End;

{ TEzVectorExpr }

Constructor TEzVectorExpr.Create( ParameterList: TParameterList; Vector: TEzVector;
  VectorType: TEzVectorType; const BufferWidth: Double );
Begin
  Inherited Create( ParameterList );
  FVector := TEzVector.Create( Vector.Count );
  FVector.Assign( Vector );
  FVectorType:= VectorType;
  FBufferWidth:= BufferWidth;
End;

Destructor TEzVectorExpr.Destroy;
Begin
  FVector.free;
  Inherited destroy;
End;

Function TEzVectorExpr.GetAsBoolean: Boolean;
Begin
  result := FVector.Count > 0;
End;

Function TEzVectorExpr.GetExprType: TExprType;
Begin
  result := ttBoolean;
End;

{ TEzQueryLayerExprCreate }

type

  TEzQueryLayerKind = ( qlkFixedRecords, qlkAllRecords, qlkQueryVector,
    qlkQueryScope, qlkQueryLayer, qlkComplexExpression );


Constructor TEzQueryLayerExpr.Create( ParameterList: TParameterList;
  MainExpr: TEzMainExpr );
Var
  QueryLayerKind: TEzQueryLayerKind;
  I, MaxRec, MinRec: Integer;
  TestEntity: TEzEntity;
  Operator: TEzGraphicOperator;
  TestLayer: TEzBaseLayer;
  TheRecordList: TBits;
  TheRecno: Integer;
  ErrorFound: Boolean;

  Procedure DoQuery;
  Var
    EntityToQuery: TEzEntity;
    Passed: Boolean;
  Begin
    { set filter for the source layer and for this entity
      in order to optimize speed }
    FPrimaryLayer.SetGraphicFilter( stOverlap, TestEntity.FBox );
    FPrimaryLayer.First;
    Try
      While Not FPrimaryLayer.eof Do
      Begin
        Try
          If FPrimaryLayer.RecIsDeleted Then
          Begin
            Continue;
          End;
          EntityToQuery := FPrimaryLayer.RecLoadEntity;
          If EntityToQuery = Nil Then
            Continue;
          Try
            Passed := EntityToQuery.CompareAgainst( TestEntity, Operator );
            If Passed Then
            Begin
              TheRecno := FPrimaryLayer.Recno;
              FRecordList[TheRecno] := true;
              FMinRecno := IMin( FMinRecno, TheRecno );
              FMaxRecno := IMax( FMaxRecno, TheRecno );
            End;
          Finally
            EntityToQuery.free;
          End;
        Finally
          FPrimaryLayer.Next;
        End;
      End;
    Finally
      FPrimaryLayer.CancelFilter;
    End;
  End;

Begin
  Inherited Create( ParameterList );
  ErrorFound:=false;
  If ParameterList <> Nil Then
  Begin
    If ( ParameterList.Count = 3 ) And
      ( ParameterList.Param[0] Is TEntExpr ) And
      ( ParameterList.Param[1] Is TEzGraphicOperatorExpr ) And
      ( ( ParameterList.ExprType[2] = ttString ) Or
        ( ParameterList.Param[2] Is TEntExpr ) Or
        ( ParameterList.Param[2] Is TEzQueryVectorExpr ) Or
        ( ParameterList.Param[2] Is TEzQueryLayerExpr ) Or
        ( ParameterList.Param[2] Is TEzQueryScopeExpr ) ) Then
    Begin
      // all is right
    End
    Else If ParameterList.Count > 3 Then  // a list of records
    Begin
      For I := 3 To ParameterList.Count - 1 Do
      Begin
        If Not ( ParameterList.ExprType[I] = ttInteger ) Then
        Begin
          ErrorFound := true;
          Break;
        End;
      End;
    End
    Else
      ErrorFound := true;
  End
  Else
    ErrorFound := true;

  if ErrorFound then
    Raise EExpression.Create( Format(SWrongParameters, ['QUERY_LAYER']) );

  FMainExpr := MainExpr;
  FRecordList := TBits.Create;
  { determines the type of query }
  QueryLayerKind := Low( TEzQueryLayerKind );
  TestLayer := Nil;
  TheRecordList := Nil;
  If ParameterList.Count > 3 Then
  Begin
    If ( ParameterList.Count = 4 ) And ( ParameterList.ExprType[2] = ttBoolean ) And
      ( ParameterList.ExprType[3] = ttString ) Then
      QueryLayerKind := qlkComplexExpression
    Else
      QueryLayerKind := qlkFixedRecords;
  End
  Else If ParameterList.Count = 3 Then
  Begin
    If Param[2] Is TEntExpr Then
      QueryLayerKind := qlkAllRecords
    Else If Param[2] Is TEzQueryVectorExpr Then
      QueryLayerKind := qlkQueryVector
    Else If Param[2] Is TEzQueryScopeExpr Then
      QueryLayerKind := qlkQueryScope
    Else If Param[2] Is TEzQueryLayerExpr Then
      QueryLayerKind := qlkQueryLayer
    Else
      Raise EExpression.Create( 'Third parameter is wrong' );
  End;
  FMinRecno := System.MaxInt;
  FMaxRecno := -System.MaxInt;
  { get the test layer}
  FPrimaryLayer:= ( Param[0] As TEntExpr ).FLayer;
  { get the graphic operator }
  Operator := TEzGraphicOperator( Param[1].AsInteger );
  Case QueryLayerKind Of
    qlkFixedRecords:
      Begin
        { get the layer whose records will be used to query to FPrimaryLayer. }
        TestLayer := ( Param[2] As TEntExpr ).FLayer;
        { query to specific records }
        For I := 3 To ParameterCount - 1 Do
        Begin
          TestEntity := TestLayer.LoadEntityWithRecno( Param[I].AsInteger );
          If TestEntity = Nil Then
            Continue;
          Try
            DoQuery;
          Finally
            TestEntity.free;
          End;
        End;
      End;
    qlkAllRecords:
      Begin
        { get the layer whose records will be used to query to FPrimaryLayer. }
        TestLayer := ( Param[2] As TEntExpr ).FLayer;
        { use all the records in SourceLayer}
        TestLayer.First;
        TestLayer.StartBuffering;
        Try
          While Not TestLayer.eof Do
          Begin
            Try
              If TestLayer.RecIsDeleted Then
                continue;
              TestEntity := TestLayer.RecLoadEntity;
              If TestEntity = Nil Then
                Continue;
              Try
                DoQuery;
              Finally
                TestEntity.free;
              End;
            Finally
              TestLayer.Next;
            End;
          End;
        Finally
          TestLayer.EndBuffering;
        End;
      End;
    qlkQueryVector, qlkQueryScope, qlkQueryLayer, qlkComplexExpression:
      Begin
        If QueryLayerKind = qlkQueryVector Then
        Begin
          TestLayer := TEzQueryVectorExpr( Param[2] ).FPrimaryLayer;
          TheRecordList := TEzQueryVectorExpr( Param[2] ).FRecordList;
          MinRec := TEzQueryVectorExpr( Param[2] ).FMinRecno;
          MaxRec := TEzQueryVectorExpr( Param[2] ).FMaxRecno;
        End
        Else If QueryLayerKind = qlkQueryScope Then
        Begin
          TestLayer := TEzQueryScopeExpr( Param[2] ).FPrimaryLayer;
          TheRecordList := TEzQueryScopeExpr( Param[2] ).FRecordList;
          MinRec := TEzQueryScopeExpr( Param[2] ).FMinRecno;
          MaxRec := TEzQueryScopeExpr( Param[2] ).FMaxRecno;
        End
        Else If QueryLayerKind in [qlkQueryLayer, qlkComplexExpression] Then
        Begin
          TestLayer := TEzQueryLayerExpr( Param[2] ).FPrimaryLayer;
          TheRecordList := TEzQueryLayerExpr( Param[2] ).FRecordList;
          MinRec := TEzQueryLayerExpr( Param[2] ).FMinRecno;
          MaxRec := TEzQueryLayerExpr( Param[2] ).FMaxRecno;
        End
        Else
        Begin
          MinRec := 0;
          MaxRec := -1;
        End;
        For I := MinRec To MaxRec Do
        Begin
          If TheRecordList[I] Then
          Begin
            TestEntity := TestLayer.LoadEntityWithRecno( I );
            If TestEntity = Nil Then
              Continue;
            Try
              DoQuery;
            Finally
              TestEntity.free;
            End;
          End;
        End;
      End;
  End;

End;

Destructor TEzQueryLayerExpr.Destroy;
Begin
  FRecordList.free;
  Inherited Destroy;
End;

{$IFDEF BCB}
function TEzQueryLayerExpr.GetPrimaryLayer: TEzBaseLayer;
begin
  Result := FPrimaryLayer;
end;
{$ENDIF}

Function TEzQueryLayerExpr.GetAsBoolean: Boolean;
Var
  TheRecno: Integer;
Begin
  TheRecno := FPrimaryLayer.Recno;
  If TheRecno <= FMaxRecno Then
    Result := FRecordList[TheRecno]
  Else
    Result := false;
End;

Function TEzQueryLayerExpr.GetExprType: TExprType;
Begin
  result := ttBoolean;
End;

{$IFDEF BCB}
function TEzVectorExpr.GetVector: TEzVector;
begin
  Result := FVector;
end;
{$ENDIF}

{ TEzQueryVectorExpr }

Constructor TEzQueryVectorExpr.Create( ParameterList: TParameterList;
  MainExpr: TEzMainExpr );
Var
  TestEntity: TEzEntity;
  Operator: TEzGraphicOperator;
  Vector: TEzVector;
  EntityToQuery: TEzEntity;
  Passed: Boolean;
  TheRecno: Integer;
  VectorType: TEzVectorType;
  BufferWidth: Double;
  TempEntity: TEzEntity;
Begin
  Inherited Create( ParameterList );
  If ( ParameterList <> Nil ) And ( ParameterList.Count = 3 ) And
     ( ParameterList.Param[0] Is TEntExpr ) And
     ( ParameterList.Param[1] Is TEzGraphicOperatorExpr ) And
     ( ParameterList.Param[2] Is TEzVectorExpr ) Then
  Begin
    // all is right here
  End Else
  Begin
    Raise EExpression.Create( Format(SWrongParameters, ['QUERY_VECTOR']) );
  End;

  FMainExpr := MainExpr;
  FRecordList := TBits.Create;
  FMinRecno := System.MaxInt;
  FMaxRecno := -System.MaxInt;

  { get the test layer}
  FPrimaryLayer := ( Param[0] As TEntExpr ).FLayer;
  { get the graphic operator }
  Operator := TEzGraphicOperator( Param[1].AsInteger );
  { get the vector }
  Vector := ( Param[2] As TEzVectorExpr ).FVector;
  VectorType:= ( Param[2] As TEzVectorExpr ).FVectorType;
  BufferWidth:= ( Param[2] As TEzVectorExpr ).FBufferWidth;
  if VectorType = vtPolygon then
  begin
    if not EqualPoint2d( Vector[0], Vector[Vector.Count - 1] ) Then
      Vector.Add( Vector[0] );
    TestEntity := TEzPolygon.Create( Vector.Count );
    TestEntity.Points.Assign( Vector );
  end else if VectorType = vtBuffer then
  begin
    TempEntity := TEzPolyline.Create( Vector.Count );
    try
      TempEntity.Points.Assign( Vector );
      TestEntity:= CreateBufferFromEntity( TempEntity, 50, BufferWidth, True );
    finally
      TempEntity.Free;
    end;
  end else  { assumed a simple polyline if VectorType in [ vtPolyline, vtBuffer ] }
  begin
    TestEntity := TEzPolyline.Create( Vector.Count );
    TestEntity.Points.Assign( Vector );
  end;
  { now query against this entity TestEntity }
  { Set filter for the source layer and for this entity in order to optimize speed }
  FPrimaryLayer.SetGraphicFilter( stOverlap, TestEntity.FBox );
  FPrimaryLayer.First;
  Try
    While Not FPrimaryLayer.eof Do
    Begin
      Try
        If FPrimaryLayer.RecIsDeleted Then
          Continue;
        EntityToQuery := FPrimaryLayer.RecLoadEntity;
        If EntityToQuery = Nil Then
          Continue;
        Try
          Passed := EntityToQuery.CompareAgainst( TestEntity, Operator );
          If Passed Then
          Begin
            TheRecno := FPrimaryLayer.Recno;
            FRecordList[TheRecno] := true;
            FMinRecno := IMin( FMinRecno, TheRecno );
            FMaxRecno := IMax( FMaxRecno, TheRecno );
          End;
        Finally
          EntityToQuery.free;
        End;
      Finally
        FPrimaryLayer.Next;
      End;
    End;
  Finally
    FPrimaryLayer.CancelFilter;
    TestEntity.Free;
  End;
End;

Destructor TEzQueryVectorExpr.Destroy;
Begin
  FRecordList.free;
  Inherited Destroy;
End;

Function TEzQueryVectorExpr.GetAsBoolean: Boolean;
Var
  TheRecno: Integer;
Begin
  TheRecno := FPrimaryLayer.Recno;
  If TheRecno <= FMaxRecno Then
    Result := FRecordList[TheRecno]
  Else
    Result := false;
End;

Function TEzQueryVectorExpr.GetExprType: TExprType;
Begin
  result := ttBoolean;
End;

{$IFDEF BCB}
function TEzQueryVectorExpr.GetPrimaryLayer: TEzBaseLayer;
begin
  Result := FPrimaryLayer;
end;
{$ENDIF}

{ TEzQueryScopeExpr }

Constructor TEzQueryScopeExpr.Create( ParameterList: TParameterList;
  MainExpr: TEzMainExpr );
Var
  //Resolver: TEzMainExpr;
  TheRecno: Integer;
Begin
  Inherited Create( ParameterList );

  If ( ParameterList <> Nil ) And ( ParameterList.Count = 2 ) And
     ( ParameterList.Param[0] Is TEntExpr ) And
     ( ParameterList.ExprType[1] = ttBoolean ) Then
  Begin
    // all is right
  End
  Else
    Raise EExpression.Create( Format(SWrongParameters, ['QUERY_SCOPE']) );

  FMainExpr := MainExpr;
  FRecordList := TBits.create;
  FMinRecno := System.MaxInt;
  FMaxRecno := -System.MaxInt;

  { get the test layer}
  FPrimaryLayer := ( Param[0] As TEntExpr ).FLayer;
  { create the expression }
  {Resolver := Nil;
  if no resolver is defined, then all records are included }
  {If Length( Param[1].AsString ) > 0 Then
  Begin
    Resolver := TEzMainExpr.Create( FMainExpr.Gis, FPrimaryLayer );
    Resolver.ParseExpression( Param[1].AsString );
    If Resolver.Expression.ExprType <> ttBoolean Then
      FreeAndNil( Resolver ); // all records will be included on wrong expression type !!!
  End; }
  FPrimaryLayer.First;
  FPrimaryLayer.StartBuffering;
  Try
    While Not FPrimaryLayer.Eof Do
    Begin
      Try
        If FPrimaryLayer.RecIsDeleted Then
          Continue;
        //If Resolver <> Nil Then
        //Begin
          If FPrimaryLayer.DBTable <> Nil Then
            FPrimaryLayer.Synchronize;
          If Param[1].AsBoolean Then
          Begin
            TheRecno := FPrimaryLayer.Recno;
            FRecordList[TheRecno] := true;
            FMinRecno := IMin( FMinRecno, TheRecno );
            FMaxRecno := IMax( FMaxRecno, TheRecno );
          End;
        //End
        //Else
        //Begin
          //TheRecno := FPrimaryLayer.Recno;
          //FRecordList[TheRecno] := true;
          //FMinRecno := IMin( FMinRecno, TheRecno );
          //FMaxRecno := IMax( FMaxRecno, TheRecno );
        //End;
      Finally
        FPrimaryLayer.Next;
      End;
    End;
  Finally
    FPrimaryLayer.EndBuffering;
  End;

End;

Destructor TEzQueryScopeExpr.destroy;
Begin
  FRecordList.free;
  Inherited destroy;
End;

Function TEzQueryScopeExpr.GetAsBoolean: Boolean;
Var
  TheRecno: Integer;
Begin
  TheRecno := FPrimaryLayer.Recno;
  If TheRecno <= FMaxRecno Then
    Result := FRecordList[TheRecno]
  Else
    Result := false;
End;

Function TEzQueryScopeExpr.GetExprType: TExprType;
Begin
  result := ttBoolean;
End;

{ TUDFExpr - class implementation}

Constructor TUDFExpr.Create( ParameterList: TParameterList;
  GIS: TEzBaseGIS; Layer: TEzBaseLayer; Const Identifier: String;
  DataType: TExprType; MaxLen: Integer );
Begin
  Inherited Create( ParameterList );
  FLayer := Layer;
  FGIS := GIS;
  FIdentifier := Identifier;
  FDataType := DataType;
  FMaxLen:= MaxLen;
End;

Function TUDFExpr.GetExprType: TExprType;
Begin
  Result := FDataType;
End;

Function TUDFExpr.GetMaxString: String;
Var
  Mx: Integer;
Begin
  Result:= '';
  if Not (FDatatype = ttString) then Exit;
  Mx:= FMaxLen;
  if Mx = 0 then Mx := 1;
  Result:= StringOfChar( 'x', Mx );
End;

Function TUDFExpr.GetAsString: String;
Var
  Value: String;
  RecNo: Integer;
Begin
  { this expression was not created if this event doesn't exist, so don't check }
  If FLayer <> Nil Then RecNo := FLayer.RecNo Else RecNo := 0;
  FGIS.OnUDFSolve( FGIS, FIdentifier, Self.ParameterList, FLayer, RecNo, Value );
  Result := Value;
End;

Function TUDFExpr.GetAsFloat: Double;
Var
  Value: String;
  Code: Integer;
  RecNo: Integer;
Begin
  Value := FloatToStr( 0 );
  If FLayer <> Nil Then RecNo := FLayer.RecNo Else RecNo := 0;
  FGIS.OnUDFSolve( FGIS, FIdentifier, Self.ParameterList, FLayer, RecNo, Value );
  Val( Value, Result, Code );
  If Not ( Code = 0 ) Then
    Result := 0;
End;

Function TUDFExpr.GetAsInteger: Integer;
Var
  Value: String;
  Code: Integer;
  RecNo: Integer;
Begin
  Value := IntToStr( 0 );
  If FLayer <> Nil Then RecNo := FLayer.RecNo Else RecNo := 0;
  FGIS.OnUDFSolve( FGIS, FIdentifier, self.ParameterList, FLayer, RecNo, Value );
  Val( Value, Result, Code );
  If Not ( Code = 0 ) Then
    Result := 0;
End;

Function TUDFExpr.GetAsBoolean: Boolean;
Var
  Value: String;
  RecNo: Integer;
Begin
  Value := NBoolean[False];
  If FLayer <> Nil Then RecNo := FLayer.RecNo Else RecNo := 0;
  FGIS.OnUDFSolve( FGIS, FIdentifier, self.ParameterList, FLayer, RecNo, Value );
  If AnsiCompareText( Value, NBoolean[True] ) = 0 Then
    Result := True
  Else
    Result := False;
End;

{ TNativeExpr - class implementation}

Constructor TNativeExpr.Create( ParameterList: TParameterList;
  Layer: TEzBaseLayer; F: Integer);
Begin
  Inherited Create( ParameterList );
  FLayer := Layer;
  FField := F;
End;

Function TNativeExpr.GetExprType: TExprType;
Begin
  Case FLayer.DBTable.FieldType( FField ) Of
    'C': Result := ttString;
    'N', 'F', 'T': Result := ttFloat;
    'D', 'I': Result := ttInteger;
    'L': Result := ttBoolean;
  Else
    result := ttString;
  End;
End;

Function TNativeExpr.GetMaxString: String;
Var
  ASize: Integer;
Begin
  Result := '';
  If FLayer.DBTable.FieldType( FField ) = 'C' Then
  Begin
    ASize := FLayer.DBTable.FieldLen( FField );
    SetLength( Result, ASize );
    FillChar( Result[1], ASize, 'x' );
  End;
End;

Function TNativeExpr.GetAsString: String;
Begin
  Result := '';
  If Not ( FLayer.DBTable.FieldType( FField ) In ['M', 'B', 'G'] ) Then
  Begin
     Result := FLayer.DBTable.StringGetN( FField );
  End;
End;

Function TNativeExpr.GetAsFloat: Double;
Begin
  Result := FLayer.DBTable.FloatGetN( FField );
End;

Function TNativeExpr.GetAsInteger: Integer;
Begin
  Result := FLayer.DBTable.IntegerGetN( FField );
End;

Function TNativeExpr.GetAsBoolean: Boolean;
Begin
  Result := FLayer.DBTable.LogicGetN( FField );
End;

{$IFDEF BCB}
function TEzQueryScopeExpr.GetPrimaryLayer: TEzBaseLayer;
begin
  Result := FPrimaryLayer;
end;
{$ENDIF}

{ TNowExpr }

function TNowExpr.GetAsFloat: Double;
begin
  result:= Now;
end;

function TNowExpr.GetExprType: TExprType;
begin
  result:= ttFloat;
end;

// TToDateExpr class implementation

Function TToDateExpr.GetAsFloat: Double;
Begin
  Result := StrToDate( Param[0].AsString );
End;

Function TToDateExpr.GetExprType: TExprType;
Begin
  Result := ttFloat;
End;

// TToNumExpr class implementation

Function TToNumExpr.GetAsFloat: Double;
Begin
  Result := StrToFloat( Param[0].AsString );
End;

Function TToNumExpr.GetExprType: TExprType;
Begin
  Result := ttFloat;
End;

// TDistanceExpr

Function TDistanceExpr.GetAsFloat: Double;
Begin
  Result := Dist2D( Point2D( Param[0].AsFloat, Param[1].AsFloat ),
    Point2D( Param[2].AsFloat, Param[3].AsFloat ) );
End;

Function TDistanceExpr.GetExprType: TExprType;
Begin
  Result := ttFloat;
End;

{TRGBExpr - class implementation}

Function TRGBExpr.GetAsInteger: Integer;
Begin
  Result := RGB( Param[0].AsInteger, Param[1].AsInteger, Param[2].AsInteger );
End;

Function TRGBExpr.GetExprType: TExprType;
Begin
  Result := ttInteger;
End;

{ TEntExpr - class implementation}

Constructor TEntExpr.Create( ParameterList: TParameterList;
  GIS: TEzBaseGIS; Layer: TEzBaseLayer );
Begin
  Inherited Create( ParameterList );
  FGIS := GIS;
  FLayer := Layer;
  if FLayer = Nil then
    Raise EExpression.Create( Format(SWrongLayername, ['']) );
End;

Function TEntExpr.GetMaxString: String;
Var
  ASize: Integer;
Begin
  Result:= '';
  ASize:= 18;
  SetLength( Result, ASize );
  FillChar( Result[1], ASize, 'x' );
End;

Function TEntExpr.GetAsString: String;
Var
  Entity: TEzEntity;
  TmpStr: String;
Begin
  Result := '';
  If FLayer.RecNo = 0 Then Exit;
  Entity := FLayer.LoadEntityWithRecNo( FLayer.Recno );
  If Entity <> Nil Then
  Begin
    Try
      TmpStr := Entity.ClassName;
      Result := '(' + Copy( TmpStr, 4, Length( TmpStr ) ) + ')';
    Finally
      Entity.Free;
    End;
  End;
End;

Function TEntExpr.GetExprType: TExprType;
Begin
  result := ttString;
End;

{TRecNoExpr - class implementation}

Constructor TRecNoExpr.Create( ParameterList: TParameterList; Layer: TEzBaseLayer );
Begin
  Inherited Create( ParameterList );
  FLayer := Layer;
End;

Function TRecNoExpr.GetAsInteger: Integer;
Begin
  Result := FLayer.RecNo;
End;

Function TRecNoExpr.GetExprType: TExprType;
Begin
  Result := ttInteger;
End;

{TIsSelectedExpr - class implementation}

Constructor TIsSelectedExpr.Create( ParameterList: TParameterList );
Var
  Param: TExpression;
Begin
  Inherited Create( ParameterList );
  Param := ParameterList.Param[0];
  FGIS := TEntExpr( Param ).FGIS;
  FLayer := TEntExpr( Param ).FLayer;
End;

Function TIsSelectedExpr.GetAsBoolean: Boolean;
Begin
  //if FGIS.DrawBoxList.Count=0 then Exit;
  With FGIS.DrawBoxList[0] Do
    Result := Selection.IsSelected( FLayer, FLayer.RecNo );
End;

Function TIsSelectedExpr.GetExprType: TExprType;
Begin
  Result := ttBoolean;
End;

{ TEntityOpExpr - class implementation}

Constructor TEntityOpExpr.Create( ParameterList: TParameterList; Operator: TEntityOperator );
Var
  Param: TExpression;
Begin
  Inherited Create( ParameterList );
  FOperator := Operator;
  Param := ParameterList.Param[0];
  FGIS := TEntExpr( Param ).FGIS;
  FLayer := ( Param As TEntExpr ).FLayer;
End;

Function TEntityOpExpr.GetAsString: String;
Var
  Entity: TEzEntity;
  tmpStr: String;
Begin
  Case FOperator Of
    opType, opText, opLayerName, opPointsList:
      Begin
        If FLayer.RecNo = 0 Then Exit;
        Entity := FLayer.LoadEntityWithRecNo( FLayer.Recno );
        If ( Entity <> Nil ) Then
        Begin
          Try
            Case FOperator Of
              opType:
                Begin
                  tmpStr := Entity.ClassName;
                  Result := '(' + Copy( tmpStr, 4, Length( tmpStr ) ) + ')';
                End;
              opText:
                If Entity.EntityID = idJustifVectText Then
                  result := TEzJustifVectorText( entity ).Text
                Else If Entity.EntityID = idFittedVectText Then
                  result := TEzFittedVectorText( entity ).Text
                Else
                  Result := '';
              opLayerName:
                Result := FLayer.Name;
              opPointsList:
                Result:= Entity.Points.AsString;
            End;
          Finally
            Entity.Free;
          End;
        End;
      End;
    //opRecno: Result := IntToStr(GetAsInteger);
  Else
    Result := FloatToStr( GetAsFloat );
  End;
End;

Function TEntityOpExpr.GetAsInteger: Integer;
Begin
  Result := 0;
End;

Function TEntityOpExpr.GetAsFloat: Double;
Var
  Entity: TEzEntity;
  Emax, Emin, C: TEzPoint;

  Procedure calc_maxmin;
  Begin
    Entity.UpdateExtension;
    Emin := Entity.FBox.Emin;
    Emax := Entity.FBox.Emax;
  End;

Begin
  { Given a Recno, then read the entity}
  Result := 0;
  If FLayer.RecNo = 0 Then Exit;
  Entity := FLayer.LoadEntityWithRecNo( FLayer.Recno );
  If Entity = Nil Then Exit;
  Try
    With FGIS.DrawBoxList[0] Do
      Case FOperator Of
        opArea:
          Result := Entity.Area;
        opPerimeter:
          Result := Entity.Perimeter;
        opMaxExtentX:
          Begin
            calc_maxmin;
            Result := Emax.X;
          End;
        opMaxExtentY:
          Begin
            calc_maxmin;
            Result := Emax.Y;
          End;
        opMinExtentX:
          Begin
            calc_maxmin;
            Result := Emin.X;
          End;
        opMinExtentY:
          Begin
            calc_maxmin;
            Result := Emin.Y;
          End;
        opCentroidX:
          Begin
            Entity.Centroid( C.X, C.Y );
            Result := C.X;
          End;
        opCentroidY:
          Begin
            Entity.Centroid( C.X, C.Y );
            Result := C.Y;
          End;
        opColor:
          Begin
            Result := clBlack;
            If Entity.EntityID = idTrueTypeText Then
              Result := TEzTrueTypeText( Entity ).FontTool.Color
            Else If Entity.EntityID = idJustifVectText Then
              Result := TEzJustifVectorText( Entity ).FontColor
            Else If Entity.EntityID = idFittedVectText Then
              Result := TEzFittedVectorText( Entity ).FontColor
            Else If Entity.EntityID = idPoint Then
              Result := TEzPointEntity( Entity ).Color
            Else If Entity Is TEzOpenedEntity Then
              TEzOpenedEntity( entity ).PenTool.Color;
          End;
        opFillColor:
          If Entity Is TEzClosedEntity Then
            Result := TEzClosedEntity( Entity ).BrushTool.Color
          Else
            Result := clBlack
      End;
  Finally
    Entity.Free;
  End;
End;

Function TEntityOpExpr.GetExprType: TExprType;
Begin
  Case FOperator Of
    //opRecno: result := ttInteger;
    opType, opText, opLayerName, opPointsList: result := ttString;
  Else
    result := ttFloat;
  End;
End;

{TEzMainExpr - clas implementation}

Constructor TEzMainExpr.Create( GIS: TEzBaseGIS; Layer: TEzBaseLayer );
Begin
  Inherited Create;
  FOrderByList:= TList.Create;
  FDescending:= TBits.Create;
  FDefaultLayer := Layer;
  FGIS := GIS;
End;

Destructor TEzMainExpr.Destroy;
Begin
  Expression.Free;
  ClearOrderBy;
  FOrderByList.Free;
  FDescending.Free;
  Inherited Destroy;
End;

Procedure TEzMainExpr.ClearOrderBy;
var
  I: Integer;
begin
  for I:= 0 to FOrderByList.Count-1 do
    TExpression(FOrderByList[I]).Free;
  FOrderByList.Clear;
end;

function TEzMainExpr.GetOrderBy(Index: Integer): TExpression;
begin
  Result:= Nil;
  if (Index < 0) or (Index > FOrderByList.Count-1) then Exit;
  Result:= TExpression( FOrderByList[Index] );
end;

Function TEzMainExpr.OrderByCount: Integer;
Begin
  Result:= FOrderByList.Count;
End;

function TEzMainExpr.GetDescending(Index: Integer): Boolean;
begin
  Result:= FDescending[Index];
end;

Procedure TEzMainExpr.IDFunc( Sender: TObject; Const Group, Identifier: String;
  ParameterList: TParameterList; Var ReturnExpr: TExpression );
Const
  Colors: Array[0..15] Of TIdentMapEntry = (
    ( Value: clBlack; Name: 'BLACK' ),
    ( Value: clMaroon; Name: 'MAROON' ),
    ( Value: clGreen; Name: 'GREEN' ),
    ( Value: clOlive; Name: 'OLIVE' ),
    ( Value: clNavy; Name: 'NAVY' ),
    ( Value: clPurple; Name: 'PURPLE' ),
    ( Value: clTeal; Name: 'TEAL' ),
    ( Value: clGray; Name: 'GRAY' ),
    ( Value: clSilver; Name: 'SILVER' ),
    ( Value: clRed; Name: 'RED' ),
    ( Value: clLime; Name: 'LIME' ),
    ( Value: clYellow; Name: 'YELLOW' ),
    ( Value: clBlue; Name: 'BLUE' ),
    ( Value: clFuchsia; Name: 'FUCHSIA' ),
    ( Value: clAqua; Name: 'AQUA' ),
    ( Value: clWhite; Name: 'WHITE' ) );

Var
  Work, LayerName: String;
  I, MaxLen, NumError: Integer;
  Layer: TEzBaseLayer;
  DataType: TExprType;
  GIS: TEzBaseGIS;
  Accept: Boolean;

  Procedure LookupInLayerInfo;
  Var
    F: Integer;
  Begin
    If ReturnExpr = Nil Then
    Begin
      If ( Work = 'ENT' ) Or ( Work = 'ENTITY' ) Then
      Begin
        If ParameterList = Nil Then
          ReturnExpr := TEntExpr.Create( ParameterList, GIS, Layer )
        Else
          NumError := 1;
      End
      Else If Work = 'RECNO' Then
      Begin
        If ParameterList = Nil Then
          ReturnExpr := TRecNoExpr.Create( ParameterList, Layer )
        Else
          NumError := 1;
      End;

      If ( ReturnExpr = Nil ) And Assigned(Layer) And
         ( Layer.DBTable <> Nil ) Then
      Begin
        F := Layer.DBTable.FieldNo( Work );
        if F <= 0 then F := Layer.DBTable.FieldNoFromAlias( Work );
        If F > 0 Then
        Begin
          If ParameterList = Nil Then
          Begin
            ReturnExpr := TNativeExpr.Create( ParameterList, Layer, F );
          End Else
            Raise EExpression.CreateFmt( SCannotContainParams, [Work] );
        End;
      End;
    End;
  End;

Begin
  ReturnExpr := Nil;
  GIS := FGIS As TEzBaseGIS;
  NumError := 0;
  Layer := FDefaultLayer;
  LayerName := Group;
  Work := Identifier;
  If Length( LayerName ) > 0 Then
  Begin
    Layer := GIS.Layers.LayerByName( LayerName );
    If Layer = Nil Then
      Raise EExpression.Create( Format( SWrongLayername, [LayerName] ) );
    LookupInLayerInfo;
  End Else If Work = 'DISTANCE' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 4 ) Then
    Begin
      For I := 0 To 3 Do
        If Not ( ParameterList.ExprType[I] In [ttFloat, ttInteger] ) Then
        Begin
          NumError := 1;
          Break;
        End;
      If NumError = 0 Then
        ReturnExpr := TDistanceExpr.Create( ParameterList );
    End
    Else
      NumError := 1;
  End
  Else If Work = 'TO_DATE' Then
  Begin
    if ParameterList = Nil then
      ReturnExpr := TNowExpr.Create( ParameterList )
    else
      NumError := 1;
  End
  Else If Work = 'TO_DATE' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.ExprType[0] = ttString ) Then
      ReturnExpr := TToDateExpr.Create( ParameterList )
    Else
      NumError := 1;
  End
  Else If Work = 'TO_NUM' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.ExprType[0] = ttString ) Then
      ReturnExpr := TToNumExpr.Create( ParameterList )
    Else
      NumError := 1;
  End
  Else If Work = 'CRLF' Then
  Begin
    If ( ParameterList = Nil ) Then
      ReturnExpr := TStringLiteral.Create( EzConsts.CrLf )
    Else
      NumError := 1;
  End
  Else If Work = 'ISSELECTED' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TIsSelectedExpr.Create( ParameterList )
    Else
      NumError := 1;
  End
  Else If Work = 'AREA' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opArea )
    Else
      NumError := 1;
  End
  Else If Work = 'PERIMETER' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opPerimeter )
    Else
      NumError := 1;
  End
  Else If Work = 'MAXEXTENTX' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opMaxExtentX )
    Else
      NumError := 1;
  End
  Else If Work = 'MAXEXTENTY' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opMaxExtentY )
    Else
      NumError := 1;
  End
  Else If Work = 'MINEXTENTX' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opMinExtentX )
    Else
      NumError := 1;
  End
  Else If Work = 'MINEXTENTY' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opMinExtentY )
    Else
      NumError := 1;
  End
  Else If Work = 'CENTROIDX' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opCentroidX )
    Else
      NumError := 1;
  End
  Else If Work = 'CENTROIDY' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
       ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opCentroidY )
    Else
      NumError := 1;
  End
  Else If Work = 'TEXT' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opText )
    Else
      NumError := 1;
  End
  Else If Work = 'LAYERNAME' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opLayerName )
    Else
      NumError := 1;
  End
  Else If Work = 'COLOR' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opColor )
    Else
      NumError := 1;
  End
  Else If Work = 'FILLCOLOR' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opFillColor )
    Else
      NumError := 1;
  End
  Else If Work = 'TYPE' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opType )
    Else
      NumError := 1;
  End Else If Work = 'POINTS' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 1 ) And
      ( ParameterList.Param[0] Is TEntExpr ) Then
      ReturnExpr := TEntityOpExpr.Create( ParameterList, opPointsList )
    Else
      NumError := 1;
  End
  Else If Work = 'RGB' Then
  Begin
    If ( ParameterList <> Nil ) And ( ParameterList.Count = 3 ) Then
      ReturnExpr := TRGBExpr.Create( ParameterList )
    Else
      NumError := 1;
  End;
  // check for a color
  If ( NumError = 0 ) And ( ReturnExpr = Nil ) Then
  Begin
    // look for color
    For I := Low( Colors ) To High( Colors ) Do
      If Work = Colors[I].Name Then
      Begin
        If ParameterList = Nil Then
        Begin
          ReturnExpr := TIntegerLiteral.Create( Colors[I].Value );
          Break;
        End
        Else
        Begin
          NumError := 1;
          Break;
        End;
      End;
  End;
  // check for a custom global function
  If ( NumError = 0 ) And ( ReturnExpr = Nil ) And Assigned( GIS.OnUDFSolve )
    And Assigned( GIS.OnUDFCheck ) Then
  begin
    If Length( LayerName ) > 0 Then
    begin
      Layer:= FGis.Layers.LayerByName( LayerName );
      if Layer = Nil then
        Raise EExpression.Create( Format( SWrongLayername, [LayerName] ) );
    End ;
    DataType:= ttString;
    Accept := False;
    MaxLen:= 0;
    GIS.OnUDFCheck( GIS, Layer.Name, Identifier, ParameterList, DataType, MaxLen, Accept );
    If Accept Then
    Begin
      ReturnExpr := TUDFExpr.Create( ParameterList, GIS, Layer, Work, DataType, MaxLen );
      FHasUDFs := True;
    End;
  End;

  If ( ReturnExpr = Nil ) And Assigned(Layer) And ( Length( LayerName ) = 0 ) Then
  Begin
    LookupInLayerInfo;
  End;

  If NumError = 1 Then
  Begin
    Raise EExpression.CreateFmt( SWrongParameters, [Work] );
  End;

End;

Procedure TEzMainExpr.ParseExpression( Const s: String );
Var
  ExprStr: String;
  OrderByStrings: TStrings;
  I: Integer;

  Function DoParse( const ParseStr: string; OrderList: TStrings ): TExpression;
  Var
    lexer: TCustomLexer;
    parser: TCustomParser;
    outputStream: TMemoryStream;
    errorStream: TMemoryStream;
    stream: TMemoryStream;
    ErrLine, ErrCol: Integer;
    ErrMsg, Errtxt: String;
  Begin
    Result:= Nil;
    stream := TMemoryStream.create;
    stream.write( ParseStr[1], Length( ParseStr ) );
    stream.seek( 0, 0 );
    outputStream := TMemoryStream.create;
    errorStream := TMemoryStream.create;
    lexer := TExprLexer.Create;
    lexer.yyinput := Stream;
    lexer.yyoutput := outputStream;
    lexer.yyerrorfile := errorStream;
    parser := TExprParser.Create( self );
    // link to the identifier function
    TExprParser( parser ).OnIdentifierFunction := IDFunc;
    parser.yyLexer := lexer; // lexer and parser linked
    Try
      If parser.yyparse = 1 Then
      Begin
        ErrLine := lexer.yylineno;
        ErrCol:= lexer.yycolno - Lexer.yyTextLen - 1;
        ErrMsg := parser.yyerrormsg;
        lexer.GetyyText (Errtxt);
        Raise EExpression.CreateFmt( SExprParserError, [ ErrMsg, ErrLine, ErrCol, ErrTxt ] );
      End;
      Result := TExprParser( parser ).GetExpression;
      if Assigned( OrderList ) then
      begin
        OrderList.Assign( TExprParser( parser ).OrderBy );
      end;
    Finally
      stream.free;
      lexer.free;
      parser.free;
      outputstream.free;
      errorstream.free;
    End;
  End;

Begin
  Self.FCheckStr := ''; // reset to empty
  ExprStr := s;
  If Expression <> Nil Then
    FreeAndNil( Expression );
  ClearOrderBy;
  Try
    If Length( ExprStr ) > 0 Then
    Begin
      OrderByStrings:= TStringList.Create;
      Try
        Expression:= DoParse( ExprStr, OrderByStrings );
        { does it have order by list ?}
        if OrderByStrings.Count > 0 then
        begin
          for I:= 0 to OrderByStrings.Count-1 do
          begin
            FOrderByList.Add( DoParse( OrderByStrings[I], Nil ) );
            { the descending is stored as a value <> nil in the TStrings.Objects }
            FDescending[I] := OrderByStrings.Objects[I] <> Nil;
          end;
        end;
      Finally
        OrderByStrings.Free;
      End;
    End;
  Except
    On E: Exception Do
    Begin
      Expression := Nil;
      ClearOrderBy;
      //MessageToUser(E.Message, smsgerror,MB_ICONERROR);
      Raise;
    End;
  End;
End;

Function TEzMainExpr.CheckExpression( Const s, CheckforThis: String ): Boolean;
Var
  ExprStr: String;
  lexer: TCustomLexer;
  parser: TCustomParser;
  outputStream: TMemoryStream;
  errorStream: TMemoryStream;
  stream: TMemoryStream;
  ErrLine, ErrCol: Integer;
  ErrMsg, Errtxt: String;
Begin
  Result := False;
  FCheckStr := CheckforThis;
  ExprStr := s;
  If Expression <> Nil Then
    FreeAndNil( Expression );
  Try
    If Length( ExprStr ) > 0 Then
    Begin
      stream := TMemoryStream.create;
      stream.write( ExprStr[1], Length( ExprStr ) );
      stream.seek( 0, 0 );
      outputStream := TMemoryStream.create;
      errorStream := TMemoryStream.create;
      lexer := TExprLexer.Create;
      lexer.yyinput := Stream;
      lexer.yyoutput := outputStream;
      lexer.yyerrorfile := errorStream;
      parser := TExprParser.Create( self );
      // link to the identifier function
      TExprParser( parser ).OnIdentifierFunction := IDFunc;
      parser.yyLexer := lexer; // lexer and parser linked
      Try
        If parser.yyparse = 1 Then
        Begin
          ErrLine := lexer.yylineno;
          ErrCol := lexer.yycolno - lexer.yytextLen - 1;
          ErrMsg := parser.yyerrormsg;
          lexer.GetyyText( ErrTxt );
          Raise EExpression.CreateFmt( SExprParserError, [ErrMsg, ErrLine, ErrCol, ErrTxt] );
        End;
        Expression := TExprParser( parser ).GetExpression;
        Result := ( Expression <> Nil ) And ( Length( FCheckStr ) > 0 );
      Finally
        stream.free;
        lexer.free;
        parser.free;
        outputstream.free;
        errorstream.free;
      End;
    End;
  Finally
    If Expression <> Nil Then
      FreeAndNil( Expression );
  End;
End;


end.
