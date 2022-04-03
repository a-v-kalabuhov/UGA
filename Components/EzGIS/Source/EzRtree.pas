Unit EzRtree;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Classes, SysUtils, EzLib;

Const
  RTCEXT = '.RTC';
  RTXEXT = '.RTX';

  // Internal message codes
  TREE_VERSION = 1001;
  TREE_ERROR = -1;
  OK = 0;
  ROOT_CHANGED = 1;

  // Configuration parameters
  BUCKETSIZE = 50; // before can be as much as 140, must be set to 100
  LOWERBOUND = 20;
  NOTFOUND = -1;
  HALF_BUCKET = BUCKETSIZE Div 2;

  DSIZE = BUCKETSIZE + 2 - 2 * LOWERBOUND; // Size of the distribution table
  XAXIS = 0;
  YAXIS = 1;
  MININT = Low( Integer );
  DEG_MULTIPLIER = 1000000;

Type
  // Rectangle class declaration
  TRect_rt = Record
    x1, y1, x2, y2: integer; // corner coordinates
  End;

  PIntegerArray = ^TIntegerArray;
  TIntegerArray = Array[0..1000000] Of Integer;

  // Sort List class declaration
  TSortList = Class( TObject )
  Private
    dist: PIntegerArray; // Value array to be sorted
    indx: PIntegerArray; // Initial indices of the sorted values
    size, len: integer; // Size of the list, and # of values inserted

  Public

    Constructor Create( l: integer );
    Destructor Destroy; Override;

    Procedure Insert( d, i: integer );
    Procedure Sort;
    Function valAt( p: integer ): integer;
    Function Length: integer;
  End;

  // Structure of an object list element
  POLstElem = ^TOLstElem;
  TOLstElem = Record
    obj: Longint; // disk address of the spatial object
    r: TRect_rt; // MBR of the object
    lev: integer; // level of the object in the tree
    Next: POLstElem; // Next element in the list
  End;

  // Object list class declaration
  TOList = Class
  Private
    Head, Tail, Curr: POLstElem;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function isEmpty: boolean;
    Function Insert( o: Longint; Const r: TRect_rt ): integer;
    Function Insertl( o: Longint; Const r: TRect_rt; l: integer ): integer;
    Function FetchORL( Var o: Longint; Var r: TRect_rt; Var l: integer ): integer;
    Function FetchOR( Var o: Longint; Var r: TRect_rt ): integer;
    Function FetchO: Longint;
    Function FetchR: TRect_rt;
    Procedure Zap;
    Procedure Rewind;
  End;

  TSearchList = Class
  Private
    b: TBits;
    MinRecno: Integer;
    MaxRecno: Integer;
    ReferenceCount: Integer;
  Public
    Constructor Create( RecCount: Integer );
    Destructor Destroy; Override;
    Procedure Add( Recno: Integer );
  End;

  TSearchType = ( stEnclosure, stOverlap, stEquality, stExist );
  TTreeType = ( ttRTree, ttRStar );

  { - xxx.rtx the table index (the node pages)
    - xxx.rtc the catalog for the index
      the catalog will have a header as follows, and
      followed by a list of free page number in file .rtx resulting from
      deleted nodes
  }

  TRTCatalog = Packed Record
    RootNode: Integer; // Address of root node
    Depth: Integer; // depth of the tree
    PageCount: Integer; // number of occupied pages on disk
    FreePageCount: Integer; // the count of free pages in this same file
    Implementor: longint; // Luis = #1, Garry = #2
    FileType: byte;
    PageSize: byte; // in k
    TreeType: TTreeType;
    Version: longint;
    Multiplier: integer;
    BucketSize: Integer; // number of entries per node
    LowerBound: Integer; // minimum no. of entries per node
    LastUpdate: TDateTime; // last updated
    Reserved: Array[0..32] Of char; // for future use
  End;

  TCompareOperator = ( coBT, coEQ, coGT, coGE, coLT, coLE );
  TRTNode = Class;

  TRTree = Class
  Private
    FOpenMode: Word; // fmOpenReadWrite or fmShareDenyNone or other
    levFlags: byte; // Used for rstar trees only.
    Function chooseLeaf( Const r: TRect_rt ): TRTNode;
    Function chooseNode( Const r: TRect_rt; lev: integer ): TRTNode;
    Function IntInsert( Const r: TRect_rt; o, lev: Integer ): integer;
  Public
    FLayer: TObject; { the layer that created this r-tree}
    TreeType: TTreeType; // The type of this tree
    RootNode: TRTNode; // The root object
    Depth: Word; // The depth of the rtree
    RootId: Longint; // Root object disk address
    FName: String;

    Constructor Create( Layer: TObject; t: TTreeType; Mode: Word );
    Constructor CreateName( Layer: TObject; t: TTreeType; Const Name: String; Mode: Word );
    Destructor Destroy; Override;
    Function CreateNewNode: TRTNode; Virtual; Abstract;
    Function CreateIndex( Const Name: String; Multiplier: Integer ): integer; Virtual; Abstract;
    Procedure DropIndex; Virtual; Abstract;
    Function Open( Const Name: String; Mode: Word ): integer; Virtual; Abstract;
    Procedure Close; Virtual; Abstract;
    Procedure ReadCatalog( Var IdxInfo: TRTCatalog ); Virtual; Abstract;
    Procedure WriteCatalog( Const IdxInfo: TRTCatalog ); Virtual; Abstract;
    Function Insert( Const r: TRect_rt; o: Longint ): integer;
    Function Delete( Const r: TRect_rt; o: Longint ): integer;
    Function Update( Const r: TRect_rt; o: Longint; Const newr: TRect_rt ): integer;
    Procedure Search( s: TSearchType; Const r: TRect_rt; ol: TIntegerList;
      RecordCount: Integer );
    Procedure GetAllNodes( ol: TIntegerList );
    Function RootExtent: TRect_rt;
    Function FillFactor( Var NodeCount, Entries: Integer ): Double;
    Procedure FlushFiles; Virtual; Abstract;
    Procedure FindArea( Compare: TCompareOperator; Area1, Area2: Integer; ol: TList );

    Property OpenMode: Word Read FOpenMode Write FOpenMode;
    Property Layer: TObject Read FLayer Write FLayer;
  End;

  // Data structure of an R(*)tree entry
  TRTEntry = Packed Record
    R: TRect_rt; // The MBR and ...
    Child: Integer; // ... disk address of the child object or record number in .ENX file
  End;

  // Structure of a node disk image
  PDiskPage = ^TDiskPage;
  TDiskPage = Packed Record
    Parent: Longint; // Parent node object disk address
    FullEntries: Word; // # of entries in use
    Leaf: Boolean; // The leaf flag
    Dum: Char;
    Entries: Array[0..BUCKETSIZE - 1] Of TRTEntry; // Entries
    Dummy: Array[0..15] Of byte; // every disk node page is of 1024 bytes
  End;

  // Class declaration of an R-tree node
  TRTNode = Class
  Private
    Function bestEntry( Const r: TRect_rt ): Longint;
    Function findLeaf( const r: TRect_rt; o: Longint ): integer;
    Procedure enclosureSearch( Const r: TRect_rt; ol: TSearchList );
    Procedure overlapSearch( Const r: TRect_rt; ol: TSearchList );
    Procedure equalitySearch( Const r: TRect_rt; ol: TSearchList );
    Procedure existSearch( Const r: TRect_rt; ol: TSearchList );
    Procedure FillFactor( Var NodeCount, Entries: Integer );
    Procedure FindArea( Compare: TCompareOperator; Const Area1, Area2: double; ol: TList );
    Procedure GetAllNodes( ol: TIntegerList );
  Protected
    rt: TRTree; // the tree that this node belongs to
    oid: Longint; // disk address of the node object
    Data: TDiskPage; // Pointer into a copy of the info. Used in updates.
  Public
    Constructor Create( rtree: TRTree );
    Function isLeaf: boolean;
    Function isRoot: boolean;
    Procedure Read( NId: Integer ); Virtual; Abstract;
    Procedure Write; Virtual; Abstract;
    Procedure AddNodeToFile; Virtual; Abstract;
    Procedure DeleteNodeFromFile; Virtual; Abstract;
    Function Delete( o: Longint; l: integer; rl: TOList ): integer;
    Function Insert( Const r: TRect_rt; o: Longint; Var newo: longint ): integer;
    Function Locate( o: Longint ): integer;
    Procedure Compact;
    Procedure propagate( n: integer );
  End;

{$IFDEF FALSE}
  TDistribution = Record
    margin, overlap, area: double;
    mbr1, mbr2: TRect_rt;
  End;

  // R*tree node class declaration
  TRSTNode = Class( TRTNode )
  Public
    Function Insert( Const r: TRect_rt; o: Longint; lev: integer;
      ol: TOList; Var lflags: byte; Var newo: Longint ): integer;
  Private
    Function fReinsert( Const r: TRect_rt; o: Longint; lev: integer; ril: TOList ): word;
    Procedure evalMargin( Var dTab: Array Of TDistribution; sl: TSortList;
      Const newRect: TRect_rt );
    Function evalOverlap( Var dTab: Array Of tDistribution ): integer;
  End;
{$ENDIF}

  // utilities
Function Contains_rect( Const r1, r2: TRect_rt ): boolean;
//Function Overlaps_rect( Const r1, r2: TRect_rt ): boolean;

Implementation

Uses
  EzSystem;

Const
  NULL_RECT: TRect_rt = ( x1: MININT; y1: MININT; x2: MININT; y2: MININT );

Function max( a, b: integer ): integer;
Begin
  If a > b Then
    result := a
  Else
    result := b;
End;

Function min( a, b: integer ): integer;
Begin
  If a < b Then
    result := a
  Else
    result := b;
End;

Procedure memswap( Var Source, Dest; Size: Integer );
Var
  tmp: Pointer;
Begin
  GetMem( tmp, Size );
  Move( Source, tmp^, size );
  Move( Dest, Source, size );
  Move( tmp^, Dest, size );
  FreeMem( tmp, Size );
End;

Function PDIST( Const x1, y1, x2, y2: double ): double;
Begin
  If x1 = MININT Then
    result := 0
  Else
    result := sqrt( sqr( x1 - x2 ) + sqr( y1 - y2 ) );
End;

// Return the intersection rectangle (if any) of this and r

Function Intersect_rect( Const r1, r2: TRect_rt ): TRect_rt;
Begin

  result.x1 := max( r1.x1, r2.x1 );
  result.y1 := max( r1.y1, r2.y1 );
  result.x2 := min( r1.x2, r2.x2 );
  result.y2 := min( r1.y2, r2.y2 );

  If ( result.x1 > result.x2 ) Or ( result.y1 > result.y2 ) Then
    result.x1 := MININT; // no intersection

End;

// Return the mbr of r1 and r2

Function Extent_rect( Const r1, r2: TRect_rt ): TRect_rt;
Begin
  result := r1;
  {result.x1 := r1.x1; result.y1 := r1.y1;
  result.x2 := r1.x2; result.y2 := r1.y2; }
  If r1.x1 = MININT Then
    result := r2
  Else If Not ( r2.x1 = MININT ) Then
  Begin
    result.x1 := min( r1.x1, r2.x1 );
    result.y1 := min( r1.y1, r2.y1 );
    result.x2 := max( r1.x2, r2.x2 );
    result.y2 := max( r1.y2, r2.y2 );
  End;
End;

// Return the area of this

Function Area_rect( Const r: TRect_rt ): double;
Var
  dx, dy: double;
Begin
  If r.x1 = MININT Then
    result := 0
  Else
  Begin
    dx := ( r.x2 - r.x1 );
    dy := ( r.y2 - r.y1 );
    result := abs( dx * dy );
  End;
End;

// Return the margin of this

Function Margin_rect( Const r: TRect_rt ): integer;
Begin
  If r.x1 = MININT Then
    result := 0
  Else
    result := 2 * ( abs( r.x2 - r.x1 ) + abs( r.y2 - r.y1 ) );
End;

// Return delta(Area) if this is extended with a rect r.

Function Delta_rect( Const r1, r2: TRect_rt ): double;
Begin
  result := Area_rect( Extent_rect( r1, r2 ) ) - Area_rect( r1 );
End;

// Return whether r1 contains r2

Function Contains_rect( Const r1, r2: TRect_rt ): boolean;
Begin
  result := ( ( r2.x1 >= r1.x1 ) And ( r2.x1 <= r1.x2 ) And
    ( r2.x2 >= r1.x1 ) And ( r2.x2 <= r1.x2 ) And
    ( r2.y1 >= r1.y1 ) And ( r2.y1 <= r1.y2 ) And
    ( r2.y2 >= r1.y1 ) And ( r2.y2 <= r1.y2 ) );
End;

// Return whether this and r overlaps

Function Overlaps_rect( Const r1, r2: TRect_rt ): boolean;
Begin
  If max( r2.x1, r1.x1 ) > min( r2.x2, r1.x2 ) Then
  Begin
    result := false;
    exit;
  End;
  If max( r2.y1, r1.y1 ) > min( r2.y2, r1.y2 ) Then
  Begin
    result := false;
    exit;
  End;
  result := true;
End;

// Return whether r equals this

Function Equals_rect( Const r1, r2: TRect_rt ): boolean;
Begin
  result := CompareMem( @r1, @r2, sizeof( TRect_rt ) );
  //(r2.x1=r1.x1) and (r2.x2=r1.x2) and
  //         (r2.y1=r1.y1) and (r2.y2=r1.y2);
End;

{$IFDEF FALSE}
// The following is used to obtain a single value from two integers A&B.

Function compose( A, B: integer ): integer;
Begin
  result := ( ( A And $0000FFFF ) Shl 16 ) Or ( B And $0000FFFF );
  //#define compose(A,B)   ((uint)((((A)&0x0000FFFF)<<16) | ((B)&0x0000FFFF)))
End;
{$ENDIF}

// TSortList class implementation

Constructor TSortList.Create( l: integer );
Begin
  Inherited Create;
  GetMem( dist, l * sizeof( integer ) );
  GetMem( indx, l * sizeof( integer ) );

  size := l;
  len := 0;
End;

Destructor TSortList.Destroy;
Begin
  FreeMem( dist, size * sizeof( integer ) );
  FreeMem( indx, size * sizeof( integer ) );
  Inherited Destroy;
End;

Procedure TSortList.Insert( d, i: integer );
Begin
  dist[len] := d;
  indx[len] := i;
  inc( len );
End;

// Quick sort algorithm; Sort len numbers at the address dist.

Procedure TSortList.Sort;
{var
  i, j: integer; }

  Procedure QuickSort( L, R: Integer );
  Var
    I, J, P, T: Integer;
  Begin
    Repeat
      I := L;
      J := R;
      P := dist[( L + R ) Shr 1];
      Repeat
        While dist[I] < P Do
          Inc( I );
        While dist[J] > P Do
          Dec( J );
        If I <= J Then
        Begin
          //swap(dist[i], dist[j]);
          T := dist[I];
          dist[I] := dist[J];
          dist[J] := T;
          //swap(indx[i], indx[j]);
          T := indx[I];
          indx[I] := indx[J];
          indx[J] := T;
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

  If len > 0 Then
    QuickSort( 0, len - 1 );

  {for i := 1 to len-1 do              // For each position in the array
   if dist[i] < dist[i-1] then
   begin      // If this number is out of seq
     j := i-1;                        // j points to one step back
     while dist[j]>dist[j+1] do begin   // until our number finds its position
       swap(dist[j],dist[j+1]);    // swap it with its left neighbor
       swap(indx[j],indx[j+1]);
       if j=0 then break;            // and go one more step left
       dec(j);
     end;
   end; }
End;

Function TSortList.valAt( p: integer ): integer;
Begin
  If p >= len Then
  Begin
    result := -1;
  End
  Else
    result := indx[p];
End;

Function TSortList.Length: integer;
Begin
  result := len;
End;

// TRTree class implementation

Constructor TRTree.Create( Layer: TObject; t: TTreeType; Mode: Word );
Begin
  Inherited Create;
  FLayer := Layer;
  TreeType := t;
  RootNode := CreateNewNode;
  RootId := -1;
  FOpenMode := Mode;
End;

Constructor TRTree.CreateName( Layer: TObject; t: TTreeType; Const Name: String; Mode: Word );
Begin
  Create( Layer, t, Mode );
  Open( Name, Mode );
End;

Destructor TRTree.Destroy;
Begin
  {if IsOpened then} Close;
  RootNode.Free;
  Inherited Destroy;
End;

// Insert object o with mbr r into rtree

Function TRTree.Insert( Const r: TRect_rt; o: Longint ): integer;
Var
  //ol: TOList;
  L: TRTNode;
  retCode: integer;
  IdxInfo: TRTCatalog;
  newo: Longint;
  //i: integer;
  //r: TRect_rt;
Begin

  {r:= wr;
  if CompareMem(@r.x1, @r.x2, SizeOf(Integer)*2) then
  begin
    r.x1:= r.x1 - 100;
    r.y1:= r.y1 - 100;
    r.x2:= r.x2 + 100;
    r.y2:= r.y2 + 100;
  end; }

  //if not IsOpened then begin result := TREE_ERROR; exit; end;
  levFlags := 0;

  L := chooseLeaf( r );
{$IFDEF FALSE}
  If TreeType = ttRStar Then
  Begin // R*-tree
    ol := TOList.Create;
    newo := -1;
    retCode := TRSTNode( L ).Insert( r, o, 0, ol, levFlags, newo );
    If retcode = TREE_ERROR Then
    Begin
      L.free;
      ol.free;
      result := TREE_ERROR;
      exit;
    End;

    ol.Rewind;
    While Not ol.isEmpty Do
      IntInsert( ol );
    ol.Zap;
    ol.free;
  End
  Else
  Begin // RTree
{$ENDIF}
    newo := -1;
    retCode := L.Insert( r, o, newo );
    If retcode = TREE_ERROR Then
    Begin
      L.free;
      result := TREE_ERROR;
      exit;
    End;
{$IFDEF FALSE}
  End;
{$ENDIF}
  L.free;

  If retCode = ROOT_CHANGED Then
  Begin
    Inc( Depth ); // Grow tree taller
    RootNode.Read( RootId ); // Read the old root
    RootId := RootNode.Data.Parent; // Take its parent id

    // Update the catalog entry
    ReadCatalog( IdxInfo );
    IdxInfo.RootNode := RootId;
    IdxInfo.Depth := Depth;
    WriteCatalog( IdxInfo );
  End;

  result := OK;
End;

// Insert internal node

Function TRTRee.IntInsert( Const r: TRect_rt; o, lev: Integer ): integer;
Var
  L: TRTNode;
  newo, retCode: integer;
  IdxInfo: TRTCatalog;
Begin

  //  RootNode.Read(&RootId);
  L := chooseNode( r, lev );

  newo := -1;
{$IFDEF FALSE}
  If TreeType = ttRTree Then
{$ENDIF}
    retCode := L.Insert( r, o, newo );
{$IFDEF FALSE}
  Else
    retCode := TRSTNode( L ).Insert( r, o, lev, ol, levFlags, newo );
{$ENDIF}

    L.free;

    If retCode = TREE_ERROR Then
    Begin
      result := TREE_ERROR;
      exit;
    End;

    If retCode = ROOT_CHANGED Then
    Begin
      Inc( Depth );
      RootNode.Read( RootId ); // Read the old root
      RootId := RootNode.Data.Parent; // Take its parent id

      //    RootNode.Read(RootId);             // Read the new root

      // Read the catalog entry
      ReadCatalog( IdxInfo );

      // Assign the new values
      IdxInfo.RootNode := RootId;
      IdxInfo.Depth := Depth;

      // Update it
      WriteCatalog( IdxInfo );
    End;

    result := OK;
End;

// Delete the object o from the rtree

Function TRTree.Delete( Const r: TRect_rt; o: Longint ): integer;
Var
  L: TRTNode;
  rl: TOList;
  rc, il: integer;
  IdxInfo: TRTCatalog;
  rr: TRect_rt;
  ro: Longint;
Begin

  L := CreateNewNode;

  rl := TOList.Create;

  L.Read( RootId );
  If L.findLeaf( r, o ) = TREE_ERROR Then
  Begin
    result := TREE_ERROR;
    exit;
  End;

  rc := L.Delete( o, 0, rl );

  If rc = TREE_ERROR Then
  Begin
    result := TREE_ERROR;
    exit;
  End;

  If rc = ROOT_CHANGED Then
  Begin
    Dec( Depth );
    RootNode.Read( RootId ); // Read the old root
    RootId := RootNode.Data.Entries[0].Child; // Take the new root id
    RootNode.DeleteNodeFromFile;

    RootNode.Read( RootId ); // Read the new root

    // Update the catalog entry
    ReadCatalog( IdxInfo );

    IdxInfo.RootNode := RootId;
    IdxInfo.Depth := Depth;

    WriteCatalog( IdxInfo );
  End;

  While Not rl.isEmpty Do
  Begin
    rl.FetchORL( ro, rr, il );
    If il = 0 Then
      Insert( rr, ro ) // leaf level
    Else
      IntInsert( rr, ro, il ); // internal
  End;

  rl.Zap;

  L.free;
  rl.free;

  result := OK;
End;

Function TRTree.Update( Const r: TRect_rt; o: Longint; Const newr: TRect_rt ): integer;
Begin
  result := Delete( r, o );
  If Not ( result = OK ) Then
  Begin
    exit;
  End;
  result := Insert( newr, o );
End;

// Choose the best place to create the new internal node

Function TRTree.chooseNode( Const r: TRect_rt; lev: integer ): TRTNode;
Var
  best: Longint;
  l: integer;
Begin

  result := CreateNewNode;

  result.Read( RootId ); // Read the root node into work space

  l := Depth;
  While l > lev Do
  Begin
    best := result.bestEntry( r );
    result.Read( best );
    Dec( l );
  End;

End;

// Choose the best leaf node to insert the new rect r.

Function TRTree.chooseLeaf( Const r: TRect_rt ): TRTNode;
Var
  best: Longint;
Begin

  result := CreateNewNode;

  result.Read( RootId ); // Read the root node into work space

  While Not result.isLeaf Do
  Begin
    best := result.bestEntry( r );
    result.Read( best );
  End;
End;

// Look up rectangle r with search type s

Procedure TRTree.Search( s: TSearchType; Const r: TRect_rt; ol: TIntegerList;
  RecordCount: Integer );
Var
  sl: TSearchList;
  I: Integer;
Begin
  //if not IsOpened then exit;
  ol.clear;
  sl := TSearchList.Create( RecordCount );
  RootNode.Read( RootId );
  Case s Of
    stEnclosure: RootNode.enclosureSearch( r, sl );
    stOverlap: RootNode.overlapSearch( r, sl );
    stEquality: RootNode.equalitySearch( r, sl );
    stExist: RootNode.existSearch( r, sl );
  End;
  If sl.ReferenceCount = 0 Then
  Begin
    sl.free;
    exit;
  End;
  ol.Capacity := sl.ReferenceCount;
  For I := sl.MinRecno To sl.MaxRecno Do
    If sl.b[I] Then ol.Add( I );
  sl.free;
End;

Procedure TRTree.GetAllNodes( ol: TIntegerList );
Begin
  ol.clear;
  RootNode.Read( RootID );
  RootNode.GetAllNodes( ol );
End;

Function TRTree.RootExtent: TRect_rt;
Var
  i: integer;
Begin
  RootNode.Read( RootID );
  result := RootNode.Data.Entries[0].R;
  For i := 1 To RootNode.Data.FullEntries - 1 Do
    result := Extent_rect( result, RootNode.Data.Entries[i].R );
End;

Procedure TRTree.FindArea( Compare: TCompareOperator; Area1, Area2: Integer; ol: TList );
Begin
  RootNode.Read( RootID );
  RootNode.FindArea( Compare, Area1, Area2, ol );
End;

Function TRTree.FillFactor( Var NodeCount, Entries: Integer ): Double;
Begin
  RootNode.Read( RootID );
  NodeCount := 0;
  Entries := 0;
  RootNode.FillFactor( NodeCount, Entries );
  Result := Entries / NodeCount;
End;

{ TRTNode class implementation }

Constructor TRTNode.Create( rtree: TRTree );
Begin
  Inherited Create;
  rt := rtree;
End;

Procedure TRTNode.FillFactor( Var NodeCount, Entries: Integer );
Var
  i, me: Integer;
  TmpDiskPage: TDiskPage;
Begin
  If Not Data.Leaf Then
  Begin
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      TmpDiskPage := Data;
      me := oid;
      Read( Data.Entries[i].Child );
      FillFactor( NodeCount, Entries );
      oid := me;
      Data := TmpDiskPage;
    End;
  End;
  If Data.Leaf Then
  Begin
    Inc( Entries, Data.FullEntries );
    Inc( NodeCount );
  End;
End;

Procedure TRTNode.FindArea( Compare: TCompareOperator;
  Const Area1, Area2: double; ol: TList );
Var
  i, me: Integer;
  tmpArea: double;
  rslt: Boolean;
  TmpDiskPage: TDiskPage;
Begin
  If Data.Leaf Then
  Begin
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      tmpArea := Area_rect( Data.Entries[i].R );
      Case Compare Of
        coBT: rslt := ( tmpArea >= Area1 ) And ( tmpArea <= Area2 );
        coEQ: rslt := tmpArea = Area1;
        coGT: rslt := tmpArea > Area1;
        coGE: rslt := tmpArea >= Area1;
        coLT: rslt := tmpArea < Area1;
        coLE: rslt := tmpArea <= Area1;
      Else
        rslt := false;
      End;
      If rslt Then
        ol.Add( Pointer( Data.Entries[i].Child ) );
    End
  End
  Else
  Begin
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      tmpArea := Area_rect( Data.Entries[i].R );
      If tmpArea >= Area1 Then
      Begin
        me := oid;
        TmpDiskPage := Data;
        Read( Data.Entries[i].Child );
        FindArea( Compare, Area1, Area2, ol );
        //Read(me);                        // Refresh
        oid := me;
        Data := TmpDiskPage;
      End;
    End;
  End;
End;

// Locate the smallest entry in which r fits

Function TRTNode.bestEntry( Const r: TRect_rt ): Longint;
Var
  i, mini: integer;
  mina, mind, delta: double;
Begin
  mini := 0;

  mina := area_rect( Data.Entries[0].R );
  mind := delta_rect( Data.Entries[0].R, r );

  For i := 1 To Data.FullEntries - 1 Do
  Begin
    delta := delta_rect( Data.Entries[i].R, r );
    If ( delta < mind ) Or ( ( delta = mind ) And ( mina > area_rect( Data.Entries[i].R ) ) ) Then
    Begin
      mini := i;
      mina := area_rect( Data.Entries[i].R );
      mind := delta;
    End;
  End;

  result := Data.Entries[mini].Child;
End;

Procedure TRTNode.GetAllNodes( ol: TIntegerList );
Var
  I, me: integer;
  TmpDiskPage: TDiskPage;
Begin
  If Data.Leaf Then
  Begin
    For i := 0 To Data.FullEntries - 1 Do
      ol.Add( Data.Entries[i].Child );
  End Else
  Begin
    For i := 0 To Data.FullEntries - 1 Do
      Begin
        me := oid;
        TmpDiskPage := Data;
        Read( Data.Entries[i].Child );
        GetAllNodes( ol );
        Data := TmpDiskPage;
        oid := me;
      End;
  End;
end;

// Add all objects contained in r to ol, and return it.

Procedure TRTNode.enclosureSearch( Const r: TRect_rt; ol: TSearchList );
Var
  I, me: integer;
  TmpDiskPage: TDiskPage;
Begin
  If Data.Leaf Then
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      If Contains_rect( r, Data.Entries[i].R ) Then
        ol.Add( Data.Entries[i].Child );
    End
  Else
    For i := 0 To Data.FullEntries - 1 Do
      If Overlaps_rect( r, Data.Entries[i].R ) Then
      Begin
        me := oid;
        TmpDiskPage := Data;
        Read( Data.Entries[i].Child );
        enclosureSearch( r, ol );
        Data := TmpDiskPage;
        oid := me;
        //Read(me);                        // Refresh
      End;
End;

// Add all objects overlapping with r to ol, and return it.

Procedure TRTNode.overlapSearch( Const r: TRect_rt; ol: TSearchList );
Var
  i: integer;
  me: Longint;
  TmpDiskPage: TDiskPage;
Begin
  If Data.Leaf Then
  Begin
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      If Overlaps_rect( r, Data.Entries[i].R ) Then
        ol.Add( Data.Entries[i].Child );
    End
  End
  Else
  Begin
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      If Overlaps_rect( r, Data.Entries[i].R ) Then
      Begin
        me := oid;
        TmpDiskPage := Data;
        Read( Data.Entries[i].Child );
        overlapSearch( r, ol );
        Data := TmpDiskPage;
        oid := me;
        //Read(me);                        // Refresh
      End;
    End;
  End;
End;

// Add all objects equal to r to ol, and return it.

Procedure TRTNode.equalitySearch( Const r: TRect_rt; ol: TSearchList );
Var
  i: integer;
  me: Longint;
  TmpDiskPage: TDiskPage;
Begin
  If Data.Leaf Then
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      If Equals_rect( r, Data.Entries[i].R ) Then
        ol.Add( Data.Entries[i].Child );
    End
  Else
    For i := 0 To Data.FullEntries - 1 Do
      If Overlaps_rect( r, Data.Entries[i].R ) Then
      Begin
        me := oid;
        TmpDiskPage := Data;
        Read( Data.Entries[i].Child );
        equalitySearch( r, ol );
        //Read(me);                        // Refresh
        oid := me;
        Data := TmpDiskPage;
      End;

End;

// Add all objects containing r to ol, and return it.

Procedure TRTNode.existSearch( Const r: TRect_rt; ol: TSearchList );
Var
  i: Integer;
  me: Longint;
  TmpDiskPage: TDiskPage;
Begin
  If Data.Leaf Then
    For i := 0 To Data.FullEntries - 1 Do
    Begin
      If Contains_rect( Data.Entries[i].R, r ) Then
        ol.Add( Data.Entries[i].Child );
    End
  Else
    For i := 0 To Data.FullEntries - 1 Do
      If Overlaps_rect( r, Data.Entries[i].R ) Then
      Begin
        me := oid;
        TmpDiskPage := Data;
        Read( Data.Entries[i].Child );
        existSearch( r, ol );
        Data := TmpDiskPage;
        oid := me;
        //Read(me);                        // Refresh
      End;
End;

// Find the pair of entries in r which have the largest distance

Procedure PickSeed( Var r: Array Of TRTEntry; n: integer );
Var
  i, j, im, jm: integer;
  dmax, d: double;
Begin

  im := 0;
  jm := 1;
  dmax := Area_rect( Extent_rect( r[0].R, r[1].R ) );
  dmax := dmax - ( Area_rect( r[0].R ) + Area_rect( r[1].R ) );
  For i := 1 To n - 2 Do
    For j := i + 1 To n - 1 Do
    Begin
      d := Area_rect( Extent_rect( r[i].R, r[j].R ) ) - ( Area_rect( r[i].R ) + Area_rect( r[j].R ) );
      If d > dmax Then
      Begin
        im := i;
        jm := j;
        dmax := d;
      End;
    End;

  memswap( r[im], r[n - 2], SizeOf( TRTEntry ) );
  memswap( r[jm], r[n - 1], SizeOf( TRTEntry ) );

End;

Function PickNext( Var r: Array Of TRTEntry; n: integer; Const mbr0, mbr1: TRect_rt ): integer;
Var
  i, im, mm: integer;
  d0, d1, dmin: double;
Begin
  im := 0;

  d0 := Delta_rect( r[0].R, mbr0 );
  d1 := Delta_rect( r[0].R, mbr1 );

  If d0 < d1 Then
  Begin
    dmin := d0;
    mm := 0;
  End
  Else
  Begin
    dmin := d1;
    mm := 1;
  End;

  For i := 1 To n - 1 Do
  Begin
    d0 := Delta_rect( r[i].R, mbr0 );
    d1 := Delta_rect( r[i].R, mbr1 );
    If ezlib.dmin( d0, d1 ) < dmin Then
    Begin
      im := i;
      If d0 < d1 Then
      Begin
        dmin := d0;
        mm := 0;
      End
      Else
      Begin
        dmin := d1;
        mm := 1;
      End;
    End;
  End;
  memswap( r[n - 1], r[im], SizeOf( TRTEntry ) );
  result := mm;
End;

Procedure TRTNode.propagate( n: integer );
Var
  me: integer;
  MyOid, Par: Longint;
  r: TRect_rt;
  //oldData: TDiskPage;
Begin

  If isRoot Then
    exit;

  MyOid := oid;
  Par := Data.Parent;

  r := Data.Entries[n].R;

  Read( Par );

  me := Locate( MyOid );
  If me = NOTFOUND Then
    EzGISError( 'propagate' );

  //oldData := Data;

  Data.Entries[me].R := Extent_rect( Data.Entries[me].R, r );
  Write;
  //Data := oldData;

  propagate( me );
End;

// Insert r into this. Make all arrangements like splitting.
// Return ROOT_CHANGED if it changes.

Function TRTNode.Insert( Const r: TRect_rt; o: Longint; Var newo: Longint ): integer;
Var
  s1, s2, node, m, n, na, nb, me, ric, ret: integer;
  newNode, newRoot, parNode, childNode: TRTNode;
  temp: Array[0..BUCKETSIZE] Of TRTEntry;
  MBRa, MBRb: TRect_rt;
  MyOid, parNewo: Longint;
Begin
  ric := OK;
  na := 0;
  nb := 0;

  If Data.FullEntries < BUCKETSIZE Then // Trivial case.
  Begin
    Data.Entries[Data.FullEntries].R := r; // Put it at the end
    Data.Entries[Data.FullEntries].Child := o;
    Inc( Data.FullEntries );
    Write;

    If Not Data.Leaf Then
    Begin
      childNode := rt.CreateNewNode;
      childNode.Read( Data.Entries[Data.FullEntries - 1].Child );
      childNode.Data.Parent := oid;
      childNode.Write;
      childNode.free;
    End;

    MyOid := oid;
    propagate( Data.FullEntries - 1 );
    Read( MyOid );

    result := OK;
    exit;
  End;

  // This node is full. It needs to be splitted.

  If isRoot Then // If this is the root
  Begin
    newRoot := rt.CreateNewNode;
    newRoot.Data.Parent := -1; // invalidate the parent
    newRoot.Data.Leaf := False;
    newRoot.Data.FullEntries := 1; // One entry.

    // First son of the new root is the old root
    newRoot.Data.Entries[0].Child := oid;

    newRoot.AddNodeToFile;

    Data.Parent := newRoot.oid; // The same parent
    ric := ROOT_CHANGED; // Mark root is changed
    newRoot.free;
  End;

  newNode := rt.CreateNewNode;
  parNode := rt.CreateNewNode;
  Try

    newNode.Data.Leaf := Data.Leaf; // Initialize the new node
    newNode.Data.FullEntries := 0; // It's empty yet
    newNode.Data.Parent := Data.Parent; // The same parent
    newNode.AddNodeToFile; // Create it on disk
    newo := newNode.oid;

    parNode.Read( Data.Parent );

    me := parNode.Locate( oid ); // Which entry is pointing to me?
    If me = NOTFOUND Then
      EzGISError( 'Insert' );

    parNode.Data.Entries[me].R := NULL_RECT; // Replace the old mbr with
    // Nil rect
    parNode.Write;

    // Insert the new node into the parent

    parNewo := -1;
    ret := parNode.Insert( NULL_RECT, newNode.oid, parNewo );
    If ret = TREE_ERROR Then
    Begin
      result := TREE_ERROR;
      exit;
    End;
    If parNewo >= 0 Then
    Begin
      If parNode.Locate( oid ) = NOTFOUND Then
      Begin
        Data.Parent := parNewO;
        Write;
      End;
      If parNode.Locate( newNode.oid ) = NOTFOUND Then
      Begin
        newNode.Data.Parent := parNewO;
        newNode.Write;
      End;
    End;
    If ret = ROOT_CHANGED Then
      ric := ret;

    Move( Data.Entries[0], temp[0], SizeOf( TRTEntry ) * BUCKETSIZE );

    temp[BUCKETSIZE].R := r; // The entry to be inserted is placed
    temp[BUCKETSIZE].Child := o; // ...at the last position in the temp

    Data.FullEntries := 0; // Empty the node

    // Select the first pair of entries and move to the last 2 positions
    PickSeed( temp, BUCKETSIZE + 1 );

    s1 := BUCKETSIZE - 1;
    s2 := BUCKETSIZE; // Initialize the MBRs
    MBRa := temp[s1].R;
    MBRb := temp[s2].R; // of the nodes

    // Insert the first into this, and the second into the new node
       {parNewo := -1;} ret := Insert( MBRa, temp[s1].Child, parNewo );
    If ret = ROOT_CHANGED Then
      ric := ret;
    {parNewo := -1;} ret := newNode.Insert( MBRb, temp[s2].Child, parNewo );
    If ret = ROOT_CHANGED Then
      ric := ret;

    n := BUCKETSIZE - 1;
    m := HALF_BUCKET;

    While n <> 0 Do
    Begin
      If na = m Then
        node := 1 // node A is full, pick B
      Else If nb = m Then
        node := 0 // node B is full, pick A
      Else
        node := PickNext( temp, n, MBRa, MBRb ); // pick the next node

      If node <> 0 Then
      Begin
        {parNewo := -1;} ret := newNode.Insert( temp[n - 1].R, temp[n - 1].Child, parNewo );
        If ret = ROOT_CHANGED Then
          ric := ret;
        MBRb := Extent_rect( MBRb, temp[n - 1].R );
        inc( nb );
      End
      Else
      Begin
        {parNewo := -1;} ret := Insert( temp[n - 1].R, temp[n - 1].Child, parNewo );
        If ret = ROOT_CHANGED Then
          ric := ret;
        MBRa := Extent_rect( MBRa, temp[n - 1].R );
        Inc( na );
      End;
      Dec( n );
    End;

  Finally
    newNode.free;
    parNode.free;
  End;

  result := ric;

End;

Function TRTNode.IsRoot: boolean;
Begin
  result := ( Data.Parent = -1 );
End;

Procedure TRTNode.Compact;
Var
  r: TRect_rt;
  i, me: integer;
  MyOid, Par: Longint;
Begin

  If isRoot Then
    exit; // cannot compact root...

  MyOid := oid;
  Par := Data.Parent;

  r := Data.Entries[0].R;
  For i := 1 To Data.FullEntries - 1 Do
    r := Extent_rect( r, Data.Entries[i].R );

  Read( Par );

  me := Locate( MyOid );
  If me = NOTFOUND Then
    EzGISError( 'Compact' );

  Data.Entries[me].R := r;
  Write;

  Compact;
End;

// Delete r from this. Make all arrangements like condensing the tree
// Return Root if it changes.

Function TRTNode.Delete( o: Longint; l: integer; rl: TOList ): integer;
Var
  n, i: integer;
  child, parent: TRTNode;
  choid: Longint;
  retCode: integer;
Begin
  parent := rt.CreateNewNode;
  Try

    retcode := OK;

    n := Locate( o ); // Find the entry for this obj.

    If n = NOTFOUND Then
      EzGISError( 'Unrecoverable error! Aborting.' );

    If Not Data.Leaf Then
    Begin
      child := rt.CreateNewNode;
      child.Read( Data.Entries[n].Child );
      child.DeleteNodeFromFile; // Destroy the deleted node
      child.free;
    End;

    // Replace the entry with the last entry and decrement Full Entries
    Dec( Data.FullEntries );
    Data.Entries[n] := Data.Entries[Data.FullEntries];
    Write;

    If Data.FullEntries < LOWERBOUND Then // Condense
    Begin
      If isRoot Then // if this is the root
      Begin
        If Data.FullEntries <> 1 Then
        Begin
          result := OK;
          exit;
        End;
        If Not Data.Leaf Then
        Begin
          choid := Data.Entries[0].Child;
          child := rt.CreateNewNode;
          child.Read( choid );
          child.Data.Parent := -1;
          child.Write;
          child.free;
          result := ROOT_CHANGED;
          exit;
        End;
        result := OK;
        exit;
      End;

      For i := 0 To Data.FullEntries - 1 Do // copy rest of the entries into temp
        rl.Insertl( Data.Entries[i].Child, Data.Entries[i].R, l );

      parent.Read( Data.Parent );
      retCode := parent.Delete( oid, l + 1, rl ); // Delete this node from parent
    End
    Else
      Compact;

    result := retCode;
  Finally
    parent.free;
  End;
End;

// Return the index of the entry in this TRTNode which points to o.

Function TRTNode.Locate( o: Longint ): integer;
Var
  i: integer;
Begin
  result := NOTFOUND;
  For i := 0 To Data.FullEntries - 1 Do
    If Data.Entries[i].Child = o Then
    Begin
      result := i;
      exit;
    End;
End;

Function TRTNode.findLeaf( const r: TRect_rt; o: Longint ): integer;
Var
  i: integer;
  me: Longint;
Begin
  If Data.Leaf Then
  Begin
    If Locate( o ) = NOTFOUND Then
    Begin
      result := TREE_ERROR;
      exit;
    End
    Else
    Begin
      result := OK;
      exit;
    End; // it is here!
  End
  Else
    For i := 0 To Data.FullEntries - 1 Do
      If Contains_rect( Data.Entries[i].R, r ) Then
      Begin
        me := oid;
        Read( Data.Entries[i].Child );
        If findLeaf( r, o ) = OK Then
        Begin
          result := OK;
          exit;
        End;
        Read( me );
      End;

  result := TREE_ERROR;
End;

Function TRTNode.isLeaf: boolean;
Begin
  result := Data.Leaf;
End;

{$IFDEF FALSE}
// TRSTNode class implementation R*-tree

Function TRSTNode.fReinsert( Const r: TRect_rt; o: Longint; lev: integer; ril: TOList ): word;
Var
  sl: TSortList;
  reorg: TOlist; // reinsert & reorganize lists.
  ro: Longint;
  rr: TRect_rt;
  i, j, dist: integer;
  minx, maxx, miny, maxy, crx, cry, cx, cy: integer;
Begin

  reorg := TOlist.Create;
  sl := TSortList.Create( BUCKETSIZE + 1 );

  minx := r.x1;
  maxx := r.x2;
  miny := r.y1;
  maxy := r.y2;
  crx := ( minx + maxx ) Div 2;
  cry := ( miny + maxy ) Div 2;

  For i := 0 To BUCKETSIZE - 1 Do
  Begin
    If Data.Entries[i].R.x1 < minx Then
      minx := Data.Entries[i].R.x1;
    If Data.Entries[i].R.x2 > maxx Then
      maxx := Data.Entries[i].R.x2;
    If Data.Entries[i].R.y1 < miny Then
      miny := Data.Entries[i].R.y1;
    If Data.Entries[i].R.y2 > maxy Then
      maxy := Data.Entries[i].R.y2;
  End;

  cx := ( minx + maxx ) Div 2;
  cy := ( miny + maxy ) Div 2;

  sl.Insert( trunc( PDIST( cx, cy, crx, cry ) ), BUCKETSIZE );

  For i := 0 To BUCKETSIZE - 1 Do
  Begin
    crx := ( Data.Entries[i].R.x1 + Data.Entries[i].R.x2 ) Div 2;
    cry := ( Data.Entries[i].R.y1 + Data.Entries[i].R.y2 ) Div 2;
    dist := trunc( PDIST( cx, cy, crx, cry ) );
    sl.Insert( dist, i );
  End;

  sl.Sort;

  For i := 0 To BUCKETSIZE Do
  Begin
    j := sl.valAt( i );
    If i < HALF_BUCKET Then
    Begin
      If j = BUCKETSIZE Then
        reorg.Insertl( o, r, lev )
      Else
        reorg.Insertl( Data.Entries[j].Child, Data.Entries[j].R, lev );
    End
    Else
    Begin
      If j = BUCKETSIZE Then
        ril.Insertl( o, r, lev )
      Else
        ril.Insertl( Data.Entries[j].Child, Data.Entries[j].R, lev );
    End;
  End;

  For i := 0 To HALF_BUCKET - 1 Do
  Begin
    reorg.FetchOR( ro, rr );
    Data.Entries[i].R := rr;
    Data.Entries[i].Child := ro;
  End;
  Data.FullEntries := HALF_BUCKET;

  Write;
  Compact;

  reorg.free;
  sl.free;

  result := OK;
End;

Function first( f, l: integer ): boolean;
Begin
  result := ( ( 1 Shl l ) And f ) = 0;
  //  (!((1<<l)&f))
End;

// Insert r into this. Make all arrangements like splitting.
// Return ROOT_CHANGED if it changes.

Function TRSTNode.Insert( Const r: TRect_rt; o: Longint; lev: integer;
  ol: TOList; Var lflags: byte; Var newo: Longint ): integer;
Var
  s1, s2, node, m, n, na, nb, i, me, ric, ret: integer;
  newNode, newRoot, parNode, childNode: TRSTNode;
  temp: Array[0..BUCKETSIZE] Of TRTEntry;
  MBRa, MBRb: TRect_rt;
  MyOid, parNewo: Longint;
  slx, sly, sl: TSortList;
  xDist: Array[0..DSIZE - 1] Of TDistribution;
  yDist: Array[0..DSIZE - 1] Of TDistribution;
  axis, cut, indx: integer;
  tmp: double;
  Iamroot: boolean;
Begin
  newNode := TRSTNode.Create( rt );
  newRoot := TRSTNode.Create( rt );
  parNode := TRSTNode.Create( rt );
  childNode := TRSTNode.Create( rt );
  slx := TSortList.Create( BUCKETSIZE + 1 );
  sly := TSortList.Create( BUCKETSIZE + 1 );
  Try
    ric := OK;

    If Data.FullEntries < BUCKETSIZE Then
    Begin // Trivial case.

      Data.Entries[Data.FullEntries].R := r; // Put it at the end
      Data.Entries[Data.FullEntries].Child := o;
      Inc( Data.FullEntries );
      Write;

      If Not Data.Leaf Then
      Begin
        childNode.Read( Data.Entries[Data.FullEntries - 1].Child );
        childNode.Data.Parent := oid;
        childNode.Write;
      End;

      MyOid := oid;
      propagate( Data.FullEntries - 1 );
      Read( MyOid );

      result := OK;
      exit;
    End;

    // This node is full. It needs to be splitted.

    Iamroot := isRoot;
    If Iamroot Then
    Begin // If this is the root

      newRoot.Data.Parent := -1;
      newRoot.Data.Leaf := False;
      newRoot.Data.FullEntries := 1; // One entry.

      // First son of the new root is the old root
      newRoot.Data.Entries[0].Child := oid;

      newRoot.AddNodeToFile;

      Data.Parent := newRoot.oid;
      Write;

      ric := ROOT_CHANGED; // Mark root is changed

    End
    Else If Not Iamroot And first( lflags, lev ) Then
    Begin
      lflags := lflags Or ( 1 Shl lev ); // Set the level flag
      result := fReinsert( r, o, lev, ol ); // Forced re-insertion
      exit;
    End;

    // Split this node -- there has been a previous forced reinsertion
    // at this level or this is the root node

    newNode.Data.Leaf := Data.Leaf; // Initialize the new node
    newNode.Data.FullEntries := 0; // It's empty yet
    newNode.Data.Parent := Data.Parent; // The same parent
    newNode.AddNodeToFile; // Create it on disk
    newo := newNode.oid;

    parNode.Read( Data.Parent );

    me := parNode.Locate( oid ); // Which entry is pointing to me?
    If me = NOTFOUND Then
      EzGISError( 'Insert' );

    parNode.Data.Entries[me].R := NULL_RECT; // Replace the old mbr with NULL
    // rectangle
    parNode.Write;

    // Insert the new node into the parent
    parNewo := -1;
    ret := parNode.Insert( NULL_RECT, newNode.oid, lev + 1, ol, lflags, parNewo );
    If ret = TREE_ERROR Then
    Begin
      result := TREE_ERROR;
      exit;
    End;
    If parNewo >= 0 Then
    Begin
      If parNode.Locate( oid ) = NOTFOUND Then
      Begin
        Data.Parent := parNewO;
        Write;
      End;
      If parNode.Locate( newNode.oid ) = NOTFOUND Then
      Begin
        newNode.Data.Parent := parNewO;
        newNode.Write;
      End;
    End;
    If ret = ROOT_CHANGED Then
      ric := ret;

    slx.Insert( compose( r.x1, r.x2 ), BUCKETSIZE );
    For i := 0 To BUCKETSIZE - 1 Do
      slx.Insert( compose( Data.Entries[i].R.x1, Data.Entries[i].R.x2 ), i );

    slx.Sort;

    sly.Insert( compose( r.y1, r.y2 ), BUCKETSIZE );
    For i := 0 To BUCKETSIZE - 1 Do
      sly.Insert( compose( Data.Entries[i].R.y1, Data.Entries[i].R.y2 ), i );

    sly.Sort;

    evalMargin( xDist, slx, r );
    evalMargin( yDist, sly, r );

    tmp := xDist[0].margin;
    axis := XAXIS;
    For i := 0 To DSIZE - 1 Do
    Begin
      If xDist[i].margin < tmp Then
      Begin
        tmp := xDist[i].margin;
        axis := XAXIS;
      End;
      If yDist[i].margin < tmp Then
      Begin
        tmp := yDist[i].margin;
        axis := YAXIS;
      End;
    End;

    If axis = XAXIS Then
    Begin
      cut := evalOverlap( xDist );
      sl := slx;
    End
    Else
    Begin
      cut := evalOverlap( yDist );
      sl := sly;
    End;

    // Distribute the entries in the sortlist between 0 - LOWERBOUND+cut-1 to
    //  the first, and the ones between LOWERBOUND+cut - BUCKETSIZE to 2nd node

    Move( Data.Entries[0], temp[0], SizeOf( TRTEntry ) * BUCKETSIZE );
    temp[BUCKETSIZE].R := r; // The entry to be inserted is placed
    temp[BUCKETSIZE].Child := o; // ...at the last position in the temp

    Data.FullEntries := 0; // Empty the node

    // Insert the first into this, and the second into the new node
    For i := 0 To LOWERBOUND + cut - 2 Do
    Begin
      indx := sl.valAt( i );
      ret := Insert( temp[indx].R, temp[indx].Child, lev, ol, lflags, newo );
      If ret = ROOT_CHANGED Then
        ric := ret;
    End;

    While i < BUCKETSIZE + 1 Do
    Begin
      indx := sl.valAt( i );
      ret := newNode.Insert( temp[indx].R, temp[indx].Child, lev, ol, lflags, newo );
      If ret = ROOT_CHANGED Then
        ric := ret;

      inc( i );
    End;

    result := ric;
  Finally
    newNode.free;
    newRoot.free;
    parNode.free;
    childNode.free;
    slx.free;
    sly.free;
  End;
End;

Procedure TRSTNode.evalMargin( Var dTab: Array Of TDistribution; sl: TSortList;
  Const newRect: TRect_rt );
Var
  tr1, tr2, r: TRect_rt;
  i, indx, Ix1, Ix2: integer;
Begin

  tr1 := NULL_RECT;
  tr2 := NULL_RECT;
  For i := 0 To LOWERBOUND - 1 Do
  Begin
    indx := sl.valAt( i );
    If indx = BUCKETSIZE Then
      tr1 := Extent_rect( tr1, newRect )
    Else
      tr1 := Extent_rect( tr1, Data.Entries[indx].R );

    indx := sl.valAt( BUCKETSIZE - i );
    If indx = BUCKETSIZE Then
      tr2 := Extent_rect( tr2, newRect )
    Else
      tr2 := Extent_rect( tr2, Data.Entries[indx].R );
  End;

  dTab[0].mbr1 := tr1;
  dTab[DSIZE - 1].mbr2 := tr2;
  Ix1 := 1;
  Ix2 := DSIZE - 2;

  For i := LOWERBOUND To DSIZE + LOWERBOUND - 2 Do
  Begin

    indx := sl.valAt( i );
    If indx = BUCKETSIZE Then
      r := newRect
    Else
      r := Data.Entries[indx].R;
    dTab[Ix1].mbr1 := Extent_rect( dTab[Ix1 - 1].mbr1, r );

    indx := sl.valAt( BUCKETSIZE - i );
    If indx = BUCKETSIZE Then
      r := newRect
    Else
      r := Data.Entries[indx].R;
    dTab[Ix2].mbr2 := Extent_rect( dTab[Ix2 + 1].mbr2, r );

    inc( Ix1 );
    dec( Ix2 );

  End;

  i := 0;
  Ix1 := 0;
  While i < DSIZE Do
  Begin
    dTab[Ix1].margin := Margin_rect( dTab[Ix1].mbr1 ) + Margin_rect( dTab[Ix1].mbr2 );
    inc( Ix1 );
    inc( i );
  End;
End;

Function TRSTNode.evalOverlap( Var dTab: Array Of TDistribution ): integer;
Var
  i, min: integer;
  mino, mina: double;
Begin

  For i := 0 To DSIZE - 1 Do
  Begin
    dTab[i].overlap := Area_rect( Intersect_rect( dTab[i].mbr1, dTab[i].mbr2 ) );
    dTab[i].area := Area_rect( Extent_rect( dTab[i].mbr1, dTab[i].mbr2 ) );
  End;

  min := 0;
  mino := dTab[0].overlap;
  mina := dTab[0].area;
  For i := 1 To DSIZE - 1 Do
    If ( dTab[i].overlap < mino ) Or ( dTab[i].overlap = mino ) And ( dTab[i].area < mina ) Then
    Begin
      min := i;
      mino := dTab[i].overlap;
      mina := dTab[i].area;
    End;

  result := min;
End;
{$ENDIF}

// TOList - class implementation

Constructor TOList.Create;
Begin
  Inherited Create;
  Curr := Nil;
  Head := Nil;
  Tail := Nil;
End;

Destructor TOList.destroy;
Begin
  Zap;
  Inherited Destroy;
End;

// Destroy the elements currently in the list.

Procedure TOList.Zap;
Var
  p: POLstElem;
Begin

  While Head <> Nil Do
  Begin
    p := Head;
    Head := Head.Next;
    dispose( p );
  End;
  Tail := Nil;
  Curr := Nil;
End;

// Reposition the current pointer at the Head;

Procedure TOList.Rewind;
Begin
  Curr := Head;
End;

// Insert to tail

Function TOList.Insert( o: Longint; Const r: TRect_rt ): integer;
Var
  p: POLstElem;
Begin
  New( p );

  p.obj := o;
  p.r := r;
  p.lev := 0;
  p.Next := Nil;

  If Tail <> Nil Then
    Tail.Next := p;
  If Head = Nil Then
    Head := p;
  Tail := p;

  Rewind;

  result := OK;
End;

Function TOList.Insertl( o: Longint; Const r: TRect_rt; l: integer ): integer;
Var
  p: POLstElem;
Begin
  new( p );

  p.obj := o;
  p.r := r;
  p.lev := l;
  p.Next := Nil;

  If Tail <> Nil Then
    Tail.Next := p;
  If Head = Nil Then
    Head := p;
  Tail := p;

  Rewind;

  result := OK;
End;

// Fetch from head.

Function TOList.FetchORL( Var o: Longint; Var r: TRect_rt; Var l: integer ): integer;
Begin
  If Curr = Nil Then
  Begin
    result := TREE_ERROR;
    exit;
  End;

  o := Curr.obj;
  r := Curr.r;
  l := Curr.lev;
  Curr := Curr.Next;

  result := OK;
End;

// Fetch from head.

Function TOList.FetchOR( Var o: Longint; Var r: TRect_rt ): integer;
Begin
  If Curr = Nil Then
  Begin
    result := TREE_ERROR;
    exit;
  End;

  o := Curr.obj;
  r := Curr.r;
  Curr := Curr.Next;

  result := OK;
End;

// Delete from Head, return the OID

Function TOList.FetchO: Longint;
Var
  o: Longint;
Begin
  If Curr = Nil Then
  Begin
    result := TREE_ERROR;
    exit;
  End;

  o := Curr.obj;
  Curr := Curr.Next;

  result := o;
End;

// Delete from Head, return the rect

Function TOList.FetchR: TRect_rt;
Begin

  result := Curr.r;
  Curr := Curr.Next;

End;

Function TOList.isEmpty: boolean;
Begin
  result := ( Curr = Nil );
End;

{ TSearchList }

Constructor TSearchList.Create( RecCount: Integer );
Begin
  Inherited Create;
  b := TBits.Create;
  b.Size := RecCount + 1;
  MinRecno := RecCount;
  MaxRecno := 0;
End;

Destructor TSearchList.Destroy;
Begin
  b.free;
  Inherited Destroy;
End;

Procedure TSearchList.Add( Recno: Integer );
Begin
  b[Recno] := true;
  Inc( ReferenceCount );
  If Recno < MinRecno Then
    MinRecno := Recno;
  If Recno > MaxRecno Then
    MaxRecno := Recno;
End;

End.
