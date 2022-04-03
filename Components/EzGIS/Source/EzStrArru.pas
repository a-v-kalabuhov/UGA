Unit EzStrarru;
{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses SysUtils, Classes;

Type
  TStringArray = Class;

  TStringArrayStrings = Class( TStrings )
  Private
    FIndex: Integer;
    FGrid: TStringArray;
    Procedure CalcXY( Index: Integer; Var X, Y: Integer );
  Protected
    Function Get( Index: Integer ): String; Override;
    Function GetCount: Integer; Override;
    Function GetObject( Index: Integer ): TObject; Override;
    Procedure Put( Index: Integer; Const S: String ); Override;
    Procedure PutObject( Index: Integer; AObject: TObject ); Override;
  Public
    Constructor Create( AGrid: TStringArray; AIndex: Longint );
    Procedure Assign( Source: TPersistent ); Override;

    Procedure Clear; Override;
    Function Add( Const S: String ): Integer; Override;
    Procedure Delete( Index: Integer ); Override;
    Procedure Insert( Index: Integer; Const S: String ); Override;
  End;

  TStringArray = Class
  Private
    FData: Pointer;
    FRows: Pointer;
    FCols: Pointer;
    FRowCount: longint;
    FColCount: longint;
    Procedure Initialize;
    Function GetCells( ACol, ARow: Integer ): String;
    Function GetCols( Index: Integer ): TStrings;
    Function GetObjects( ACol, ARow: Integer ): TObject;
    Function GetRows( Index: Integer ): TStrings;
    Procedure SetCells( ACol, ARow: Integer; Const Value: String );
    Procedure SetCols( Index: Integer; Value: TStrings );
    Procedure SetObjects( ACol, ARow: Integer; Value: TObject );
    Procedure SetRows( Index: Integer; Value: TStrings );
    Function EnsureColRow( Index: Integer; IsCol: Boolean ): TStringArrayStrings;
    Function EnsureDataRow( ARow: Integer ): Pointer;
    Procedure SetColCount( Value: longint );
    Procedure SetRowCount( Value: longint );
  Public
    Constructor Create( ARowCount, AColCount: longint );
    Destructor Destroy; Override;
    Procedure ColumnMove( FromIndex, ToIndex: Longint );
    Procedure RowMove( FromIndex, ToIndex: Longint );
    Procedure Clear;
    Property Cells[ACol, ARow: Integer]: String Read GetCells Write SetCells;
    Property Cols[Index: Integer]: TStrings Read GetCols Write SetCols;
    Property Objects[ACol, ARow: Integer]: TObject Read GetObjects Write SetObjects;
    Property Rows[Index: Integer]: TStrings Read GetRows Write SetRows;
    Property RowCount: longint Read FRowCount Write SetRowCount;
    Property ColCount: longint Read FColCount Write SetColCount;
  End;

  { Sparce array classes }

  PPointer = ^Pointer;

  { Exception classes }

  EStringSparseListError = Class( Exception );

  { TSparsePointerArray class}

  { Used by TSparseList.  Based on Sparse1Array, but has Pointer elements
    and Integer index, just like TPointerList/TList, and less indirection }

    { Apply function for the applicator:
          TheIndex        Index of item in array
          TheItem         Value of item (i.e pointer element) in section
          Returns: 0 if success, else error code. }
  TSPAApply = Function( TheIndex: Integer; TheItem: Pointer ): Integer;

  TSecDir = Array[0..4095] Of Pointer; { Enough for up to 12 bits of sec }
  PSecDir = ^TSecDir;
  TSPAQuantum = ( SPASmall, SPALarge ); { Section size }

  TSparsePointerArray = Class( TObject )
  Private
    secDir: PSecDir;
    slotsInDir: Word;
    indexMask, secShift: Word;
    FHighBound: Integer;
    FSectionSize: Word;
    cachedIndex: Integer;
    cachedPointer: Pointer;
    { Return item[i], nil if slot outside defined section. }
    Function GetAt( Index: Integer ): Pointer;
    { Return address of item[i], creating slot if necessary. }
    Function MakeAt( Index: Integer ): PPointer;
    { Store item at item[i], creating slot if necessary. }
    Procedure PutAt( Index: Integer; Item: Pointer );
  Public
    Constructor Create( Quantum: TSPAQuantum );
    Destructor Destroy; Override;

    { Traverse SPA, calling apply function for each defined non-nil
      item.  The traversal terminates if the apply function returns
      a value other than 0. }
    { NOTE: must be static method so that we can take its address in
      TSparseList.ForAll }
    Function ForAll( ApplyFunction: Pointer {TSPAApply} ): Integer;

    { Ratchet down HighBound after a deletion }
    Procedure ResetHighBound;

    Property HighBound: Integer Read FHighBound;
    Property SectionSize: Word Read FSectionSize;
    Property Items[Index: Integer]: Pointer Read GetAt Write PutAt; Default;
  End;

  { TSparseList class }

  TSparseList = Class( TObject )
  Private
    FList: TSparsePointerArray;
    FCount: Integer; { 1 + HighBound, adjusted for Insert/Delete }
    FQuantum: TSPAQuantum;
    Procedure NewList( Quantum: TSPAQuantum );
  Protected
    Procedure Error; Virtual;
    Function Get( Index: Integer ): Pointer;
    Procedure Put( Index: Integer; Item: Pointer );
  Public
    Constructor Create( Quantum: TSPAQuantum );
    Destructor Destroy; Override;
    Function Add( Item: Pointer ): Integer;
    Procedure Clear;
    Procedure Delete( Index: Integer );
    Procedure Exchange( Index1, Index2: Integer );
    Function First: Pointer;
    Function ForAll( ApplyFunction: Pointer {TSPAApply} ): Integer;
    Function IndexOf( Item: Pointer ): Integer;
    Procedure Insert( Index: Integer; Item: Pointer );
    Function Last: Pointer;
    Procedure Move( CurIndex, NewIndex: Integer );
    Procedure Pack;
    Function Remove( Item: Pointer ): Integer;
    Property Count: Integer Read FCount;
    Property Items[Index: Integer]: Pointer Read Get Write Put; Default;
    Property Quantum: TSPAQuantum Read FQuantum;
  End;

  { TStringSparseList class }

  TStringSparseList = Class( TStrings )
  Private
    FList: TSparseList; { of StrItems }
    FOnChange: TNotifyEvent;
  Protected
    Function Get( Index: Integer ): String; Override;
    Function GetCount: Integer; Override;
    Function GetObject( Index: Integer ): TObject; Override;
    Procedure Put( Index: Integer; Const S: String ); Override;
    Procedure PutObject( Index: Integer; AObject: TObject ); Override;
    Procedure Changed; Virtual;
    Procedure Error; Virtual;
  Public
    Constructor Create( Quantum: TSPAQuantum );
    Destructor Destroy; Override;
    Procedure ReadData( Reader: TReader );
    Procedure WriteData( Writer: TWriter );
    Procedure DefineProperties( Filer: TFiler ); Override;
    Procedure Delete( Index: Integer ); Override;
    Procedure Exchange( Index1, Index2: Integer ); Override;
    Procedure Insert( Index: Integer; Const S: String ); Override;
    Procedure Clear; Override;
    Property List: TSparseList Read FList;
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
  End;

Implementation

Uses ezsystem;

{ StrItem management for TStringSparseList }

Type
  PStrItem = ^TStrItem;
  TStrItem = Record
    FObject: TObject;
    FString: String;
  End;

Function NewStrItem( Const AString: String; AObject: TObject ): PStrItem;
Begin
  New( Result );
  Result^.FObject := AObject;
  Result^.FString := AString;
End;

Procedure DisposeStrItem( P: PStrItem );
Begin
  Dispose( P );
End;

{ TSparsePointerArray }

Const
  SPAIndexMask: Array[TSPAQuantum] Of Byte = ( 15, 255 );
  SPASecShift: Array[TSPAQuantum] Of Byte = ( 4, 8 );

  { Expand Section Directory to cover at least `newSlots' slots. Returns: Possibly
    updated pointer to the Section Directory. }

Function ExpandDir( secDir: PSecDir; Var slotsInDir: Word;
  newSlots: Word ): PSecDir;
Begin
  Result := secDir;
  ReallocMem( Result, newSlots * SizeOf( Pointer ) );
  FillChar( Result^[slotsInDir], ( newSlots - slotsInDir ) * SizeOf( Pointer ), 0 );
  slotsInDir := newSlots;
End;

{ Allocate a section and set all its items to nil. Returns: Pointer to start of
  section. }

Function MakeSec( SecIndex: Integer; SectionSize: Word ): Pointer;
Var
  SecP: Pointer;
  Size: Word;
Begin
  Size := SectionSize * SizeOf( Pointer );
  GetMem( secP, size );
  FillChar( secP^, size, 0 );
  MakeSec := SecP
End;

Constructor TSparsePointerArray.Create( Quantum: TSPAQuantum );
Begin
  SecDir := Nil;
  SlotsInDir := 0;
  FHighBound := -1;
  FSectionSize := Word( SPAIndexMask[Quantum] ) + 1;
  IndexMask := Word( SPAIndexMask[Quantum] );
  SecShift := Word( SPASecShift[Quantum] );
  CachedIndex := -1
End;

Destructor TSparsePointerArray.Destroy;
Var
  i: Integer;
  size: Word;
Begin
  { Scan section directory and free each section that exists. }
  i := 0;
  size := FSectionSize * SizeOf( Pointer );
  While i < slotsInDir Do
  Begin
    If secDir^[i] <> Nil Then
      FreeMem( secDir^[i], size );
    Inc( i )
  End;

  { Free section directory. }
  If secDir <> Nil Then
    FreeMem( secDir, slotsInDir * SizeOf( Pointer ) );
End;

Function TSparsePointerArray.GetAt( Index: Integer ): Pointer;
Var
  byteP: PChar;
  secIndex: Cardinal;
Begin
  { Index into Section Directory using high order part of
    index.  Get pointer to Section. If not null, index into
    Section using low order part of index. }
  If Index = cachedIndex Then
    Result := cachedPointer
  Else
  Begin
    secIndex := Index Shr secShift;
    If secIndex >= slotsInDir Then
      byteP := Nil
    Else
    Begin
      byteP := secDir^[secIndex];
      If byteP <> Nil Then
      Begin
        Inc( byteP, ( Index And indexMask ) * SizeOf( Pointer ) );
      End
    End;
    If byteP = Nil Then
      Result := Nil
    Else
      Result := PPointer( byteP )^;
    cachedIndex := Index;
    cachedPointer := Result
  End
End;

Function TSparsePointerArray.MakeAt( Index: Integer ): PPointer;
Var
  dirP: PSecDir;
  p: Pointer;
  byteP: PChar;
  secIndex: Word;
Begin
  { Expand Section Directory if necessary. }
  secIndex := Index Shr secShift; { Unsigned shift }
  If secIndex >= slotsInDir Then
    dirP := expandDir( secDir, slotsInDir, secIndex + 1 )
  Else
    dirP := secDir;

  { Index into Section Directory using high order part of
    index.  Get pointer to Section. If null, create new
    Section.  Index into Section using low order part of index. }
  secDir := dirP;
  p := dirP^[secIndex];
  If p = Nil Then
  Begin
    p := makeSec( secIndex, FSectionSize );
    dirP^[secIndex] := p
  End;
  byteP := p;
  Inc( byteP, ( Index And indexMask ) * SizeOf( Pointer ) );
  If Index > FHighBound Then
    FHighBound := Index;
  Result := PPointer( byteP );
  cachedIndex := -1
End;

Procedure TSparsePointerArray.PutAt( Index: Integer; Item: Pointer );
Begin
  If ( Item <> Nil ) Or ( GetAt( Index ) <> Nil ) Then
  Begin
    MakeAt( Index )^ := Item;
    If Item = Nil Then
      ResetHighBound
  End
End;

Function TSparsePointerArray.ForAll( ApplyFunction: Pointer {TSPAApply} ):
  Integer;
Var
  itemP: PChar; { Pointer to item in section }
  item: Pointer;
  i, callerBP: Cardinal;
  j, index: Integer;
Begin
  { Scan section directory and scan each section that exists,
    calling the apply function for each non-nil item.
    The apply function must be a far local function in the scope of
    the procedure P calling ForAll.  The trick of setting up the stack
    frame (taken from TurboVision's TCollection.ForEach) allows the
    apply function access to P's arguments and local variables and,
    if P is a method, the instance variables and methods of P's class }
  Result := 0;
  i := 0;
  Asm
    mov   eax,[ebp]                     { Set up stack frame for local }
    mov   callerBP,eax
  End;
  While ( i < slotsInDir ) And ( Result = 0 ) Do
  Begin
    itemP := secDir^[i];
    If itemP <> Nil Then
    Begin
      j := 0;
      index := i Shl SecShift;
      While ( j < FSectionSize ) And ( Result = 0 ) Do
      Begin
        item := PPointer( itemP )^;
        If item <> Nil Then
          { ret := ApplyFunction(index, item.Ptr); }
          Asm
            mov   eax,index
            mov   edx,item
            push  callerBP
            call  ApplyFunction
            pop   ecx
            mov   @Result,eax
          End;
        Inc( itemP, SizeOf( Pointer ) );
        Inc( j );
        Inc( index )
      End
    End;
    Inc( i )
  End;
End;

Procedure TSparsePointerArray.ResetHighBound;
Var
  NewHighBound: Integer;

  Function Detector( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    If TheIndex > FHighBound Then
      Result := 1
    Else
    Begin
      Result := 0;
      If TheItem <> Nil Then
        NewHighBound := TheIndex
    End
  End;

Begin
  NewHighBound := -1;
  ForAll( @Detector );
  FHighBound := NewHighBound
End;

{ TSparseList }

Constructor TSparseList.Create( Quantum: TSPAQuantum );
Begin
  Inherited Create;
  NewList( Quantum )
End;

Destructor TSparseList.Destroy;
Begin
  If FList <> Nil Then
    FreeAndNil( FList );
  Inherited Destroy;
End;

Function TSparseList.Add( Item: Pointer ): Integer;
Begin
  Result := FCount;
  FList[Result] := Item;
  Inc( FCount )
End;

Procedure TSparseList.Clear;
Begin
  If FList <> Nil Then
    FreeAndNil( FList );
  NewList( FQuantum );
  FCount := 0
End;

Procedure TSparseList.Delete( Index: Integer );
Var
  I: Integer;
Begin
  If ( Index < 0 ) Or ( Index >= FCount ) Then
    Exit;
  For I := Index To FCount - 1 Do
    FList[I] := FList[I + 1];
  FList[FCount] := Nil;
  Dec( FCount );
End;

Procedure TSparseList.Error;
Begin
  Raise EListError.Create( 'List Index Error!' )
End;

Procedure TSparseList.Exchange( Index1, Index2: Integer );
Var
  temp: Pointer;
Begin
  temp := Get( Index1 );
  Put( Index1, Get( Index2 ) );
  Put( Index2, temp );
End;

Function TSparseList.First: Pointer;
Begin
  Result := Get( 0 )
End;

{ Jump to TSparsePointerArray.ForAll so that it looks like it was called
  from our caller, so that the BP trick works. }

Function TSparseList.ForAll( ApplyFunction: Pointer {TSPAApply} ): Integer; Assembler;
Asm
        MOV     EAX,[EAX].TSparseList.FList
        JMP     TSparsePointerArray.ForAll
End;

Function TSparseList.Get( Index: Integer ): Pointer;
Begin
  If Index < 0 Then
    Error;
  Result := FList[Index]
End;

Function TSparseList.IndexOf( Item: Pointer ): Integer;
Var
  MaxIndex, Index: Integer;

  Function IsTheItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    If TheIndex > MaxIndex Then
      Result := -1 { Bail out }
    Else If TheItem <> Item Then
      Result := 0
    Else
    Begin
      Result := 1; { Found it, stop traversal }
      Index := TheIndex
    End
  End;

Begin
  Index := -1;
  MaxIndex := FList.HighBound;
  FList.ForAll( @IsTheItem );
  Result := Index
End;

Procedure TSparseList.Insert( Index: Integer; Item: Pointer );
Var
  i: Integer;
Begin
  If Index < 0 Then
    Error;
  I := FCount;
  While I > Index Do
  Begin
    FList[i] := FList[i - 1];
    Dec( i )
  End;
  FList[Index] := Item;
  If Index > FCount Then
    FCount := Index;
  Inc( FCount )
End;

Function TSparseList.Last: Pointer;
Begin
  Result := Get( FCount - 1 );
End;

Procedure TSparseList.Move( CurIndex, NewIndex: Integer );
Var
  Item: Pointer;
Begin
  If CurIndex <> NewIndex Then
  Begin
    Item := Get( CurIndex );
    Delete( CurIndex );
    Insert( NewIndex, Item );
  End;
End;

Procedure TSparseList.NewList( Quantum: TSPAQuantum );
Begin
  FQuantum := Quantum;
  If FList <> Nil Then
    FreeAndNil( FList );
  FList := TSparsePointerArray.Create( Quantum )
End;

Procedure TSparseList.Pack;
Var
  i: Integer;
Begin
  For i := FCount - 1 Downto 0 Do
    If Items[i] = Nil Then
      Delete( i )
End;

Procedure TSparseList.Put( Index: Integer; Item: Pointer );
Begin
  If Index < 0 Then
    Error;
  FList[Index] := Item;
  FCount := FList.HighBound + 1
End;

Function TSparseList.Remove( Item: Pointer ): Integer;
Begin
  Result := IndexOf( Item );
  If Result <> -1 Then
    Delete( Result )
End;

{ TStringSparseList }

Constructor TStringSparseList.Create( Quantum: TSPAQuantum );
Begin
  Inherited Create;
  FList := TSparseList.Create( Quantum )
End;

Destructor TStringSparseList.Destroy;
Begin
  If FList <> Nil Then
  Begin
    Clear;
    FreeAndNil( FList );
  End;
  Inherited Destroy;
End;

Procedure TStringSparseList.ReadData( Reader: TReader );
Var
  i: Integer;
Begin
  With Reader Do
  Begin
    i := Integer( ReadInteger );
    While i > 0 Do
    Begin
      InsertObject( Integer( ReadInteger ), ReadString, Nil );
      Dec( i )
    End
  End
End;

Procedure TStringSparseList.WriteData( Writer: TWriter );
Var
  itemCount: Integer;

  Function CountItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    Inc( itemCount );
    Result := 0
  End;

  Function StoreItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    With Writer Do
    Begin
      WriteInteger( TheIndex ); { Item index }
      WriteString( PStrItem( TheItem )^.FString );
    End;
    Result := 0
  End;

Begin
  With Writer Do
  Begin
    itemCount := 0;
    FList.ForAll( @CountItem );
    WriteInteger( itemCount );
    FList.ForAll( @StoreItem );
  End
End;

Procedure TStringSparseList.DefineProperties( Filer: TFiler );
Begin
  Filer.DefineProperty( 'List', ReadData, WriteData, True );
End;

Function TStringSparseList.Get( Index: Integer ): String;
Var
  p: PStrItem;
Begin
  p := PStrItem( FList[Index] );
  If p = Nil Then
    Result := ''
  Else
    Result := p^.FString
End;

Function TStringSparseList.GetCount: Integer;
Begin
  Result := FList.Count
End;

Function TStringSparseList.GetObject( Index: Integer ): TObject;
Var
  p: PStrItem;
Begin
  p := PStrItem( FList[Index] );
  If p = Nil Then
    Result := Nil
  Else
    Result := p^.FObject
End;

Procedure TStringSparseList.Put( Index: Integer; Const S: String );
Var
  p: PStrItem;
  obj: TObject;
Begin
  p := PStrItem( FList[Index] );
  If p = Nil Then
    obj := Nil
  Else
    obj := p^.FObject;
  If ( S = '' ) And ( obj = Nil ) Then { Nothing left to store }
    FList[Index] := Nil
  Else
    FList[Index] := NewStrItem( S, obj );
  If p <> Nil Then
    DisposeStrItem( p );
  Changed
End;

Procedure TStringSparseList.PutObject( Index: Integer; AObject: TObject );
Var
  p: PStrItem;
Begin
  p := PStrItem( FList[Index] );
  If p <> Nil Then
    p^.FObject := AObject
  Else If AObject <> Nil Then
    Error;
  Changed
End;

Procedure TStringSparseList.Changed;
Begin
  If Assigned( FOnChange ) Then
    FOnChange( Self )
End;

Procedure TStringSparseList.Error;
Begin
  Raise EStringSparseListError.Create( 'Put Object Error!' )
End;

Procedure TStringSparseList.Delete( Index: Integer );
Var
  p: PStrItem;
Begin
  p := PStrItem( FList[Index] );
  If p <> Nil Then
    DisposeStrItem( p );
  FList.Delete( Index );
  Changed
End;

Procedure TStringSparseList.Exchange( Index1, Index2: Integer );
Begin
  FList.Exchange( Index1, Index2 );
End;

Procedure TStringSparseList.Insert( Index: Integer; Const S: String );
Begin
  FList.Insert( Index, NewStrItem( S, Nil ) );
  Changed
End;

Procedure TStringSparseList.Clear;

  Function ClearItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    DisposeStrItem( PStrItem( TheItem ) ); { Item guaranteed non-nil }
    Result := 0
  End;

Begin
  FList.ForAll( @ClearItem );
  FList.Clear;
  Changed
End;

{ TStringArrayStrings }

{ AIndex < 0 is a column (for column -AIndex - 1)
  AIndex > 0 is a row (for row AIndex - 1)
  AIndex = 0 denotes an empty row or column }

Constructor TStringArrayStrings.Create( AGrid: TStringArray; AIndex: Longint );
Begin
  Inherited Create;
  FGrid := AGrid;
  FIndex := AIndex;
End;

Procedure TStringArrayStrings.Assign( Source: TPersistent );
Var
  I, Max: Integer;
Begin
  If Source Is TStrings Then
  Begin
    BeginUpdate;
    Max := TStrings( Source ).Count - 1;
    If Max >= Count Then
      Max := Count - 1;
    Try
      For I := 0 To Max Do
      Begin
        Put( I, TStrings( Source ).Strings[I] );
        PutObject( I, TStrings( Source ).Objects[I] );
      End;
    Finally
      EndUpdate;
    End;
    Exit;
  End;
  Inherited Assign( Source );
End;

Procedure TStringArrayStrings.CalcXY( Index: Integer; Var X, Y: Integer );
Begin
  If FIndex = 0 Then
  Begin
    X := -1;
    Y := -1;
  End
  Else If FIndex > 0 Then
  Begin
    X := Index;
    Y := FIndex - 1;
  End
  Else
  Begin
    X := -FIndex - 1;
    Y := Index;
  End;
End;

{ Changes the meaning of Add to mean copy to the first empty string }

Function TStringArrayStrings.Add( Const S: String ): Integer;
Var
  I: Integer;
Begin
  For I := 0 To Count - 1 Do
    If Strings[I] = '' Then
    Begin
      Strings[I] := S;
      Result := I;
      Exit;
    End;
  Result := -1;
End;

Procedure TStringArrayStrings.Clear;
Var
  SSList: TStringSparseList;
  I: Integer;

  Function BlankStr( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    Objects[TheIndex] := Nil;
    Strings[TheIndex] := '';
    Result := 0;
  End;

Begin
  If FIndex > 0 Then
  Begin
    SSList := TStringSparseList( TSparseList( FGrid.FData )[FIndex - 1] );
    If SSList <> Nil Then
      SSList.List.ForAll( @BlankStr );
  End
  Else If FIndex < 0 Then
    For I := Count - 1 Downto 0 Do
    Begin
      Objects[I] := Nil;
      Strings[I] := '';
    End;
End;

Function TStringArrayStrings.Get( Index: Integer ): String;
Var
  X, Y: Integer;
Begin
  CalcXY( Index, X, Y );
  If X < 0 Then
    Result := ''
  Else
    Result := FGrid.Cells[X, Y];
End;

Function TStringArrayStrings.GetCount: Integer;
Begin
  { Count of a row is the column count, and vice versa }
  If FIndex = 0 Then
    Result := 0
  Else If FIndex > 0 Then
    Result := Integer( FGrid.ColCount )
  Else
    Result := Integer( FGrid.RowCount );
End;

Function TStringArrayStrings.GetObject( Index: Integer ): TObject;
Var
  X, Y: Integer;
Begin
  CalcXY( Index, X, Y );
  If X < 0 Then
    Result := Nil
  Else
    Result := FGrid.Objects[X, Y];
End;

Procedure TStringArrayStrings.Put( Index: Integer; Const S: String );
Var
  X, Y: Integer;
Begin
  CalcXY( Index, X, Y );
  FGrid.Cells[X, Y] := S;
End;

Procedure TStringArrayStrings.PutObject( Index: Integer; AObject: TObject );
Var
  X, Y: Integer;
Begin
  CalcXY( Index, X, Y );
  FGrid.Objects[X, Y] := AObject;
End;

Procedure TStringArrayStrings.Delete( Index: Integer );
Begin
End;

Procedure TStringArrayStrings.Insert( Index: Integer; Const S: String );
Begin
End;

{ TStringArray }

Constructor TStringArray.Create( ARowCount, AColCount: longint );
Begin
  Inherited Create;
  FRowCount := ARowCount;
  FColCount := AColCount;
  Initialize;
End;

Procedure TStringArray.Clear;
  Function FreeItem( TheIndex: Integer; TheItem: Pointer ): Integer; Far;
  Begin
    TObject( TheItem ).Free;
    Result := 0;
  End;

Begin
  If FRows <> Nil Then
  Begin
    TSparseList( FRows ).ForAll( @FreeItem );
    TSparseList( FRows ).Free;
  End;
  If FCols <> Nil Then
  Begin
    TSparseList( FCols ).ForAll( @FreeItem );
    TSparseList( FCols ).Free;
  End;
  If FData <> Nil Then
  Begin
    TSparseList( FData ).ForAll( @FreeItem );
    TSparseList( FData ).Free;
  End;
  FRows := Nil;
  FCols := Nil;
  FData := Nil;
  Initialize;
End;

Destructor TStringArray.Destroy;
Begin
  Clear;
  Inherited Destroy;
End;

Procedure TStringArray.ColumnMove( FromIndex, ToIndex: Longint );

  Function MoveColData( Index: Integer; ARow: TStringSparseList ): integer; Far;
  Begin
    ARow.Move( FromIndex, ToIndex );
    Result := 0;
  End;

Begin
  TSparseList( FData ).ForAll( @MoveColData );
End;

Procedure TStringArray.RowMove( FromIndex, ToIndex: Longint );
Begin
  TSparseList( FData ).Move( FromIndex, ToIndex );
  {Invalidate;
  inherited RowMove(FromIndex, ToIndex);}
End;

Procedure TStringArray.Initialize;
Var
  quantum: TSPAQuantum;
Begin
  If FCols = Nil Then
  Begin
    If ColCount > 512 Then
      quantum := SPALarge
    Else
      quantum := SPASmall;
    FCols := TSparseList.Create( quantum );
  End;
  If RowCount > 256 Then
    quantum := SPALarge
  Else
    quantum := SPASmall;
  If FRows = Nil Then
    FRows := TSparseList.Create( quantum );
  If FData = Nil Then
    FData := TSparseList.Create( quantum );
End;

Function TStringArray.EnsureColRow( Index: Integer; IsCol: Boolean ):
  TStringArrayStrings;
Var
  RCIndex: Integer;
  PList: ^TSparseList;
Begin
  If IsCol Then
    PList := @FCols
  Else
    PList := @FRows;
  Result := TStringArrayStrings( PList^[Index] );
  If Result = Nil Then
  Begin
    If IsCol Then
      RCIndex := -Index - 1
    Else
      RCIndex := Index + 1;
    Result := TStringArrayStrings.Create( Self, RCIndex );
    PList^[Index] := Result;
  End;
End;

Function TStringArray.EnsureDataRow( ARow: Integer ): Pointer;
Var
  quantum: TSPAQuantum;
Begin
  Result := TStringSparseList( TSparseList( FData )[ARow] );
  If Result = Nil Then
  Begin
    If ColCount > 512 Then
      quantum := SPALarge
    Else
      quantum := SPASmall;
    Result := TStringSparseList.Create( quantum );
    TSparseList( FData )[ARow] := Result;
  End;
End;

Function TStringArray.GetCells( ACol, ARow: Integer ): String;
Var
  ssl: TStringSparseList;
Begin
  ssl := TStringSparseList( TSparseList( FData )[ARow] );
  If ssl = Nil Then
    Result := ''
  Else
    Result := ssl[ACol];
End;

Function TStringArray.GetCols( Index: Integer ): TStrings;
Begin
  Result := EnsureColRow( Index, True );
End;

Function TStringArray.GetObjects( ACol, ARow: Integer ): TObject;
Var
  ssl: TStringSparseList;
Begin
  ssl := TStringSparseList( TSparseList( FData )[ARow] );
  If ssl = Nil Then
    Result := Nil
  Else
    Result := ssl.Objects[ACol];
End;

Function TStringArray.GetRows( Index: Integer ): TStrings;
Begin
  Result := EnsureColRow( Index, False );
End;

Procedure TStringArray.SetCells( ACol, ARow: Integer; Const Value: String );
Begin
  TStringArrayStrings( EnsureDataRow( ARow ) )[ACol] := Value;
  EnsureColRow( ACol, True );
  EnsureColRow( ARow, False );
End;

Procedure TStringArray.SetCols( Index: Integer; Value: TStrings );
Begin
  EnsureColRow( Index, True ).Assign( Value );
End;

Procedure TStringArray.SetObjects( ACol, ARow: Integer; Value: TObject );
Begin
  TStringArrayStrings( EnsureDataRow( ARow ) ).Objects[ACol] := Value;
  EnsureColRow( ACol, True );
  EnsureColRow( ARow, False );
End;

Procedure TStringArray.SetRows( Index: Integer; Value: TStrings );
Begin
  EnsureColRow( Index, False ).Assign( Value );
End;

Procedure TStringArray.SetColCount( Value: longint );
Begin
  If Value <> FColCount Then
  Begin
    FColCount := Value;
    Initialize;
  End;
End;

Procedure TStringArray.SetRowCount( Value: longint );
Begin
  If Value <> FRowCount Then
  Begin
    FRowCount := Value;
    Initialize;
  End;
End;

End.
