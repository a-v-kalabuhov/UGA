Unit EzPolyClip;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Windows, Classes, ezbasegis, ezbase, ezlib;

Type

  {------------------------------------------------------------------------------}
  {                  Define TEzPolygonClipper                                    }
  {------------------------------------------------------------------------------}

  TEzPolygonClipper = Class( TComponent )
  Private
    FDrawBox: TEzBaseDrawBox;
    FClipOperation: TEzPolyClipOp;
    FClipping: TEzEntityList;
    FClipSubject: TEzEntityList;
    FClipResult: TEzEntityList;
    FHoles: TBits;
    Procedure SetDrawBox( Value: TEzBaseDrawBox );
  Protected
    Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure Clear;
    Procedure Execute;
    Procedure ClipAgainstRectangle( Const Axmin, Aymin, Axmax, Aymax: double );

    Property ClipSubject: TEzEntityList Read FClipSubject;
    Property Clipping: TEzEntityList Read FClipping;
    Property ClipResult: TEzEntityList Read FClipResult;
    Property Holes: TBits Read FHoles;
  Published
    Property ClipOperation: TEzPolyClipOp Read FClipOperation Write FClipOperation;
    Property DrawBox: TEzBaseDrawBox Read FDrawBox Write SetDrawBox;
  End;

Procedure PolygonClip( op: TEzPolyClipOp;
  subject, clipping, result: TEzEntityList; Holes: TBits );
//procedure tristripClip(vp: CustomDrawBox; op: TEzPolyClipOp; subject, clipping, result: TList);

Implementation

Uses
  ezSystem, ezconsts, EzEntities;

{ TEzPolygonClipper }

Constructor TEzPolygonClipper.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FClipSubject := TEzEntityList.Create;
  FClipResult := TEzEntityList.Create;
  FClipping := TEzEntityList.Create;
  FHoles := TBits.Create;
End;

Destructor TEzPolygonClipper.Destroy;
Begin
  FClipping.Free;
  FClipResult.free;
  FClipSubject.Free;
  FHoles.Free;
  Inherited Destroy;
End;

Procedure TEzPolygonClipper.SetDrawBox( Value: TEzBaseDrawBox );
Begin
{$IFDEF LEVEL5}
  if Assigned( FDrawBox ) then FDrawBox.RemoveFreeNotification( Self );
{$ENDIF}
  If Value <> Nil Then
    Value.FreeNotification( Self );
  FDrawBox := Value;
End;

Procedure TEzPolygonClipper.Notification( AComponent: TComponent; Operation: TOperation );
Begin
  Inherited Notification( AComponent, Operation );
  If ( Operation = opRemove ) And ( AComponent = FDrawBox ) Then
    FDrawBox := Nil;
End;

Procedure TEzPolygonClipper.Execute;
Var
  tempresult: TEzEntityList;
  tmpOp: TEzPolyClipOp;
  I: Integer;
Begin
  If FDrawBox = Nil Then
    MessageToUser( SUnconnectedDrawBox, smsgerror, MB_ICONERROR );
  If ( FClipping.Count = 0 ) Or ( FClipSubject.Count = 0 ) Then
    exit;
  FClipResult.Clear;
  tmpOP := FClipOperation;
  If FClipOperation = pcSPLIT Then
    tmpOp := pcDIFF;
  PolygonClip( tmpOp, FClipSubject, FClipping, FClipResult, FHoles );
  If FClipOperation = pcSPLIT Then
  Begin
    tempresult := TEzEntityList.Create;
    Try
      tmpOp := pcINT;
      polygonClip( tmpOp, clipping, FClipSubject, tempresult, FHoles );
      For I := 0 To tempresult.count - 1 Do
        FClipResult.Add( tempresult[i] );
    Finally
      tempresult.free;
    End;
  End;
End;

Procedure TEzPolygonClipper.ClipAgainstRectangle( Const Axmin, Aymin, Axmax, Aymax: double );
Var
  I: Integer;
  ent: TEzEntity;

  { polylines }
  VisPoints, cnt, n, K, Idx1, Idx2: Integer;
  TmpPt1, TmpPt2: TEzPoint;
  TmpPts: PEzPointArray;
  ClipRes: TEzClipCodes;
  Clip: TEzRect;
  { polygons }
  VisPoints1, TmpSize, MaxCount: Integer;
  FirstClipPts: PEzPointArray;
  PartCount: Integer;
  temp: TEzEntity;
Begin
  If FClipSubject.Count = 0 Then Exit;
  MaxCount := 0;
  For I := 0 To FClipSubject.Count - 1 Do
  Begin
    ent := TEzEntity( FClipSubject[I] );
    MaxCount := ezlib.IMax( MaxCount, ent.Points.Count );
  End;
  If MaxCount = 0 Then
    exit;
  Inc( MaxCount, 4 );

  TmpSize := ( MaxCount * sizeof( TEzPoint ) );

  GetMem( TmpPts, TmpSize );
  GetMem( FirstClipPts, TmpSize );

  Try
    FClipResult.clear;
    Clip := Rect2D( Axmin, Aymin, Axmax, Aymax );
    { clip this entity }
    For I := 0 To FClipSubject.Count - 1 Do
    Begin
      ent := TEzEntity( FClipSubject[I] );
      If ent.isclosed Then
      Begin
        If ent.points.Count = 0 Then
          Exit;
        If ent.points.Count = 2 Then
          continue;
        n := 0;
        K := 0;
        If ent.points.Parts.Count < 2 Then
        Begin
          Idx1 := 0;
          Idx2 := ent.points.Count - 1;
        End
        Else
        Begin
          Idx1 := ent.points.Parts[n];
          Idx2 := ent.points.Parts[n + 1] - 1;
        End;
        PartCount := 0;
        temp := TEzPolygon.CreateEntity( [Point2D( 0, 0 )] );
        temp.points.clear;
        Repeat
          //VisPoints  := 0;
          VisPoints1 := 0;
          If IsBoxFullInBox2D( ent.points.Extension, Clip ) Then
          Begin
            For cnt := Idx1 To Idx2 Do
              TmpPts[cnt - Idx1] := ent.points[cnt];
            VisPoints := ( Idx2 - Idx1 ) + 1;
          End
          Else
          Begin
            For cnt := Idx1 To Idx2 Do
            Begin
              TmpPt1 := ent.points[cnt];
              If cnt < Idx2 Then
                TmpPt2 := ent.points[cnt + 1]
              Else
                TmpPt2 := ent.Points[Idx1];
              ClipRes := ClipLineLeftRight2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
              If Not ( ccNotVisible In ClipRes ) Then
              Begin
                FirstClipPts[VisPoints1] := TmpPt1;
                Inc( VisPoints1 );
              End;
              If ccSecond In ClipRes Then
              Begin
                FirstClipPts[VisPoints1] := TmpPt2;
                Inc( VisPoints1 );
              End;
            End;
            FirstClipPts[VisPoints1] := FirstClipPts[0];
            Inc( VisPoints1 );
            VisPoints := 0;
            For cnt := 0 To VisPoints1 - 2 Do
            Begin
              TmpPt1 := FirstClipPts[cnt];
              TmpPt2 := FirstClipPts[cnt + 1];
              ClipRes := ClipLineUpBottom2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
              If Not ( ccNotVisible In ClipRes ) Then
              Begin
                TmpPts[VisPoints] := TmpPt1;
                Inc( VisPoints );
              End;
              If ccSecond In ClipRes Then
              Begin
                TmpPts[VisPoints] := TmpPt2;
                Inc( VisPoints );
              End;
            End;
          End;
          If VisPoints > 1 Then
          Begin
            Inc( PartCount );
            For cnt := 0 To VisPoints - 1 Do
              temp.points.add( TmpPts[cnt] );
            inc( K, vispoints );
            temp.points.parts.add( k );
          End;
          If ent.points.Parts.Count < 2 Then
            Break;
          Inc( n );
          If n >= ent.points.Parts.Count Then
            Break;
          Idx1 := ent.points.Parts[n];
          If n < ent.points.Parts.Count - 1 Then
            Idx2 := ent.points.Parts[n + 1] - 1
          Else
            Idx2 := ent.points.Count - 1;
        Until False;
        { create the polygon }
        If PartCount > 1 Then
          temp.points.parts.insert( 0, 0 )
        Else
          temp.points.parts.clear;
        FClipResult.Add( temp );
      End
      Else
      Begin
        If ent.points.Count = 0 Then
          Exit;
        n := 0;
        If ent.points.Parts.Count < 2 Then
        Begin
          Idx1 := 0;
          Idx2 := ent.points.Count - 1;
        End
        Else
        Begin
          Idx1 := ent.points.Parts[n];
          Idx2 := ent.points.Parts[n + 1] - 1;
        End;
        Repeat
          VisPoints := 0;
          If IsBoxFullInBox2D( ent.points.Extension, Clip ) Then
          Begin
            For cnt := Idx1 To Idx2 Do
              TmpPts[cnt - Idx1] := ent.Points[cnt];
            VisPoints := Succ( Idx2 - Idx1 );
          End
          Else
          Begin
            For cnt := Idx1 + 1 To Idx2 Do
            Begin
              TmpPt1 := ent.Points[cnt - 1];
              TmpPt2 := ent.Points[cnt];
              ClipRes := ClipLine2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
              If Not ( ccNotVisible In ClipRes ) Then
              Begin
                TmpPts[VisPoints] := TmpPt1;
                Inc( VisPoints );
              End;
              If ccSecond In ClipRes Then
              Begin
                TmpPts[VisPoints] := TmpPt2;
                Inc( VisPoints );

                FClipResult.Add( TEzPolyLine.CreateEntity( Slice( TmpPts^, VisPoints ) ) );

                VisPoints := 0;
              End;
            End;
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              TmpPts[VisPoints] := TmpPt2;
              Inc( VisPoints );
            End;
          End;
          If VisPoints > 0 Then
            FClipResult.Add( TEzPolyLine.CreateEntity( Slice( TmpPts^, VisPoints ) ) );

          If ent.Points.Parts.Count < 2 Then
            Break;
          Inc( n );
          If n >= ent.Points.Parts.Count Then
            Break;
          Idx1 := ent.Points.Parts[n];
          If n < ent.Points.Parts.Count - 1 Then
            Idx2 := ent.Points.Parts[n + 1] - 1
          Else
            Idx2 := ent.Points.Count - 1;
        Until false;
      End;
    End;
  Finally
    FreeMem( TmpPts, TmpSize );
    FreeMem( FirstClipPts, TmpSize );
  End;
End;

Procedure TEzPolygonClipper.Clear;
Begin
  FClipResult.clear;
  FClipSubject.clear;
  FClipping.clear;
End;

{ main clipping procedures }

Const
  GPC_EPSILON = 0.000001;
  LEFT = 0;
  RIGHT = 1;

  ABOVE = 0;
  BELOW = 1;

  CLIP = 0;
  SUBJ = 1;

  //INVERT_TRISTRIPS = FALSE;

  DBL_MAX = 1E20;

Type

  PEzPointList = ^TEzPointList;
  TEzPointList = Record (* Vertex list structure             *)
    NumVertices: integer; (* Number of vertices in list        *)
    vertex: PEzPointArray; (* Vertex array pointer              *)
  End;

  TEzClipPolygon = Class
  Private
    FList: TList; // list of PEzPointList records
    Fhole: TList; // list of booleans
    Function GetItem( Index: Integer ): TEzPointList;
    Procedure SetItem( Index: Integer; Const Value: TEzPointList );
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Add( Const Value: TEzPointList ): Integer;
    Function num_contours: integer; (* Number of contours in polygon *)
    Function num_strips: integer; (* Number of tristrips (if it is a)*)
    Procedure Clear;
    Procedure Delete( Index: Integer );
    Procedure Insert( Index: Integer; Const Value: TEzPointList );

    Property contour[Index: Integer]: TEzPointList Read GetItem Write SetItem;
    //property strip[Index: Integer]: TEzPointList read GetItem write SetItem;
    Property hole: TList Read Fhole; (* Hole / external contour flags *)
  End;

  //Tgpc_tristrip = class(TEzClipPolygon)
  //end;

  TVertexType = (* Edge intersection classes         *)
  ( vtNUL, (* Empty non-intersection            *)
    vtEMX, (* External maximum                  *)
    vtELI, (* External left intermediate        *)
    vtTED, (* Top edge                          *)
    vtERI, (* External right intermediate       *)
    vtRED, (* Right edge                        *)
    vtIMM, (* Internal maximum and minimum      *)
    vtIMN, (* Internal minimum                  *)
    vtEMN, (* External minimum                  *)
    vtEMM, (* External maximum and minimum      *)
    vtLED, (* Left edge                         *)
    vtILI, (* Internal left intermediate        *)
    vtBED, (* Bottom edge                       *)
    vtIRI, (* Internal right intermediate       *)
    vtIMX, (* Internal maximum                  *)
    vtFUL (* Full non-intersection             *)
    );

  THState = (* Horizontal edge states            *)
  ( hsNH, (* No horizontal edge                *)
    hsBH, (* Bottom horizontal edge            *)
    hsTH (* Top horizontal edge               *)
    );

  TBundleState = (* Edge bundle state                 *)
  ( bsUNBUNDLED, (* Isolated edge not within a bundle *)
    bsBUNDLE_HEAD, (* Bundle head node                  *)
    bsBUNDLE_TAIL (* Passive bundle tail node          *)
    );

  PVertexNode = ^TVertexNode;
  TVertexNode = Record (* Internal vertex list datatype     *)
    x: double; (* X coordinate component            *)
    y: double; (* Y coordinate component            *)
    next: PVertexNode; (* Pointer to next vertex in list    *)
  End;

  PPolygonNode = ^TPolygonNode;
  TPolygonNode = Record (* Internal contour / tristrip type  *)
    active: integer; (* Active flag / vertex count        *)
    hole: boolean; (* Hole / external contour flag      *)
    v: Array[0..1] Of PVertexNode; (* Left and right vertex list ptrs   *)
    next: PPolygonNode; (* Pointer to next polygon contour   *)
    proxy: PPolygonNode; (* Pointer to actual structure used  *)
  End;

  PEdgeNode = ^TEdgeNode;
  TEdgeNode = Record
    vertex: TEzPoint; (* Piggy-backed contour vertex data  *)
    bot: TEzPoint; (* Edge lower (x, y) coordinate      *)
    top: TEzPoint; (* Edge upper (x, y) coordinate      *)
    xb: double; (* Scanbeam bottom x coordinate      *)
    xt: double; (* Scanbeam top x coordinate         *)
    dx: double; (* Change in x for a unit y increase *)
    istype: integer; (* Clip / subject edge flag          *)
    bundle: Array[0..1, 0..1] Of integer; (* Bundle edge flags                 *)
    bside: Array[0..1] Of integer; (* Bundle left / right indicators    *)
    bstate: Array[0..1] Of TBundleState; (* Edge bundle state                 *)
    outp: Array[0..1] Of PPolygonNode; (* Output polygon / tristrip pointer *)
    prev: PEdgeNode; (* Previous edge in the AET          *)
    next: PEdgeNode; (* Next edge in the AET              *)
    pred: PEdgeNode; (* Edge connected at the lower end   *)
    succ: PEdgeNode; (* Edge connected at the upper end   *)
    next_bound: PEdgeNode; (* Pointer to next bound in LMT      *)
  End;

  PEdgeNodeArray = ^TEdgeNodeArray;
  TEdgeNodeArray = Array[0..0] Of TEdgeNode;

  PLMTNode = ^TLMTNode;
  TLMTNode = Record (* Local minima table                *)
    y: double; (* Y coordinate at local minimum     *)
    first_bound: PEdgeNode; (* Pointer to bound list             *)
    next: PLMTNode; (* Pointer to next local minimum     *)
  End;

  PSBTree = ^TSBTree;
  TSBTree = Record (* Scanbeam tree                     *)
    y: double; (* Scanbeam node y value             *)
    less: PSBTree; (* Pointer to nodes with lower y     *)
    more: PSBTree; (* Pointer to nodes with higher y    *)
  End;

  PITNode = ^TITNode;
  TITNode = Record (* Intersection table                *)
    ie: Array[0..1] Of PEdgeNode; (* Intersecting edge (bundle) pair   *)
    point: TEzPoint; (* Point of intersection             *)
    next: PITNode; (* The next intersection table node  *)
  End;

  PStNode = ^TStNode;
  TStNode = Record (* Sorted edge table                 *)
    edge: PEdgeNode; (* Pointer to AET edge               *)
    xb: double; (* Scanbeam bottom x coordinate      *)
    xt: double; (* Scanbeam top x coordinate         *)
    dx: double; (* Change in x for a unit y increase *)
    prev: PStNode; (* Previous edge in sorted list      *)
  End;

  (* Horizontal edge state transitions within scanbeam boundary *)
Const
  next_hstate: Array[0..2, 0..5] Of THState = (
    (*   ABOVE     BELOW     CROSS *)
    (*   L   R     L   R     L   R *)
    ( hsBH, hsTH, hsTH, hsBH, hsNH, hsNH ),
    ( hsNH, hsNH, hsNH, hsNH, hsTH, hsTH ),
    ( hsNH, hsNH, hsNH, hsNH, hsBH, hsBH )
    );
  {*)}

Constructor TEzClipPolygon.Create;
Begin
  Inherited Create;
  FList := TList.Create;
  Fhole := TList.Create;
End;

Destructor TEzClipPolygon.destroy;
Begin
  Clear;
  FList.free;
  Fhole.Free;
  Inherited destroy;
End;

Function TEzClipPolygon.num_contours: Integer;
Begin
  Result := FList.Count;
End;

Function TEzClipPolygon.num_strips: integer;
Begin
  Result := FList.Count;
End;

Function TEzClipPolygon.GetItem( Index: Integer ): TEzPointList;
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    Exit;
  Result := PEzPointList( FList.Items[Index] )^;
End;

Procedure TEzClipPolygon.SetItem( Index: Integer; Const Value: TEzPointList );
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    Exit;
  PEzPointList( FList.Items[Index] )^ := Value;
End;

Procedure TEzClipPolygon.Insert( Index: Integer; Const Value: TEzPointList );
Var
  P: PEzPointList;
Begin
  New( P ); { Allocate Memory}
  P^ := Value;
  FList.Insert( Index, P ); { Insert onto Internal List }
  Fhole.Insert( Index, Pointer( 0 ) );
End;

Function TEzClipPolygon.Add( Const Value: TEzPointList ): Integer;
Begin
  Result := num_contours;
  Insert( FList.Count, Value );
End;

Procedure TEzClipPolygon.Clear;
Var
  I: Integer;
Begin
  For I := 0 To Pred( FList.Count ) Do
    Delete( 0 );
  FList.Clear;
  Fhole.Clear;
End;

Procedure TEzClipPolygon.Delete( Index: Integer );
Var
  v: PEzPointList;
Begin
  If ( Index < 0 ) Or ( Index > FList.Count - 1 ) Then
    Exit;
  v := PEzPointList( FList.Items[Index] );
  FreeMem( v.vertex, v.NumVertices * sizeof( TEzPoint ) );
  Dispose( v );
  FList.Delete( Index );
  Fhole.Delete( Index );
End;
//-----------------------------------------------------------------------

Function EQ( Const a, b: Double ): Boolean;
Begin
  Result := ( abs( a - b ) <= GPC_EPSILON );
End;

Function PREV_INDEX( i, n: Integer ): Integer;
Begin
  Result := ( i - 1 + n ) Mod n;
End;

Function NEXT_INDEX( i, n: Integer ): Integer;
Begin
  Result := ( i + 1 ) Mod n;
End;

Function OPTIMAL( v: PEzPointArray; i, n: Integer ): Boolean;
Begin
  Result := ( ( v[PREV_INDEX( i, n )].y <> v[i].y ) Or
    ( v[NEXT_INDEX( i, n )].y <> v[i].y ) );
End;

Function FWD_MIN( v: PEdgeNodeArray; i, n: integer ): boolean;
Begin
  Result := ( ( v[PREV_INDEX( i, n )].vertex.y >= v[i].vertex.y )
    And ( v[NEXT_INDEX( i, n )].vertex.y > v[i].vertex.y ) );
End;

Function NOT_FMAX( v: PEdgeNodeArray; i, n: integer ): boolean;
Begin
  Result := ( v[NEXT_INDEX( i, n )].vertex.y > v[i].vertex.y );
End;

Function REV_MIN( v: PEdgeNodeArray; i, n: integer ): boolean;
Begin
  Result := ( ( v[PREV_INDEX( i, n )].vertex.y > v[i].vertex.y )
    And ( v[NEXT_INDEX( i, n )].vertex.y >= v[i].vertex.y ) );
End;

Function NOT_RMAX( v: PEdgeNodeArray; i, n: integer ): boolean;
Begin
  Result := ( v[PREV_INDEX( i, n )].vertex.y > v[i].vertex.y );
End;

Procedure add_vertex( Var t: PVertexNode; Const x, y: double );
Begin
  If t = Nil Then
  Begin
    New( t );
    t.x := x;
    t.y := y;
    t.next := Nil;
  End
  Else
    (* Head further down the list *)
    add_vertex( t.next, x, y );
End;

Procedure VERTEX( e: PEdgeNode; p, s: integer; Const x, y: double );
Begin
  add_vertex( e.outp[p].v[s], x, y );
  Inc( e.outp[p].active );
End;

Procedure P_EDGE( Var d: PEdgeNode; e: PEdgeNode; p: integer; Var i: double; const j: double );
Begin
  d := e;
  Repeat
    d := d.prev;
  Until d.outp[p] <> Nil;
  i := d.bot.x + d.dx * ( j - d.bot.y );
End;

Procedure N_EDGE( Var d: PEdgeNode; e: PEdgeNode; p: integer;
  Var i: double; const j: Double );
Begin
  d := e;
  Repeat
    d := d.next;
  Until d.outp[p] <> Nil;
  i := d.bot.x + d.dx * ( j - d.bot.y );
End;

Procedure reset_it( Var it: PITNode );
Var
  itn: PITNode;
Begin
  While it <> Nil Do
  Begin
    itn := it.next;
    Dispose( it );
    it := Nil;
    it := itn;
  End;
End;

Procedure reset_lmt( Var lmt: PLMTNode );
Var
  lmtn: PLMTNode;
Begin
  While lmt <> Nil Do
  Begin
    lmtn := lmt.next;
    Dispose( lmt );
    lmt := Nil;
    lmt := lmtn;
  End;
End;

Procedure insert_bound( Var b: PEdgeNode; e: PEdgeNode );
Var
  existing_bound: PEdgeNode;
Begin
  If b = Nil Then
    (* Link node e to the tail of the list *)
    b := e
  Else
  Begin
    (* Do primary sort on the x field *)
    If e.bot.x < b.bot.x Then
    Begin
      (* Insert a new node mid-list *)
      existing_bound := b;
      b := e;
      b.next_bound := existing_bound;
    End
    Else
    Begin
      If e.bot.x = b.bot.x Then
      Begin
        (* Do secondary sort on the dx field *)
        If e.dx < b.dx Then
        Begin
          (* Insert a new node mid-list *)
          existing_bound := b;
          b := e;
          b.next_bound := existing_bound;
        End
        Else
        Begin
          (* Head further down the list *)
          insert_bound( b.next_bound, e );
        End;
      End
      Else
      Begin
        (* Head further down the list *)
        insert_bound( b.next_bound, e );
      End;
    End;
  End;
End;

Function bound_list( Var lmt: PLMTNode; Const y: double ): Pointer;
Var
  existing_node: PLMTNode;
Begin
  If lmt = Nil Then
  Begin
    (* Add node onto the tail end of the LMT *)
    New( lmt );
    fillchar( lmt^, sizeof( TLMTNode ), 0 );
    lmt.y := y;
    lmt.first_bound := Nil;
    lmt.next := Nil;
    result := @lmt.first_bound;
  End
  Else
  Begin
    If y < lmt.y Then
    Begin
      (* Insert a new LMT node before the current node *)
      existing_node := lmt;
      New( lmt );
      FillChar( lmt^, sizeof( TLMTNode ), 0 );
      lmt.y := y;
      lmt.first_bound := Nil;
      lmt.next := existing_node;
      result := @lmt.first_bound;
    End
    Else
    Begin
      If y > lmt.y Then
        (* Head further up the LMT *)
        result := bound_list( lmt.next, y )
      Else
        (* Head further up the LMT *)
        result := @lmt.first_bound;
    End;
  End;
End;

Procedure add_to_sbtree( Var entries: integer; Var sbtree: PSBTree; Const y: double );
Begin
  If sbtree = Nil Then
  Begin
    (* Add a new tree node here *)
    New( sbtree );
    FillChar( sbtree^, sizeof( TSBTree ), 0 );
    sbtree.y := y;
    sbtree.less := Nil;
    sbtree.more := Nil;
    Inc( entries );
  End
  Else
  Begin
    If sbtree.y > y Then
    Begin
      (* Head into the 'less' sub-tree *)
      add_to_sbtree( entries, sbtree.less, y );
    End
    Else
    Begin
      If sbtree.y < y Then
      Begin
        (* Head into the 'more' sub-tree *)
        add_to_sbtree( entries, sbtree.more, y );
      End;
    End;
  End;
End;

Procedure build_sbt( Var entries: integer; sbt: PDoubleArray; sbtree: PSBTree );
Begin
  If sbtree.less <> Nil Then
    build_sbt( entries, sbt, sbtree.less );
  sbt[entries] := sbtree.y;
  Inc( entries );
  If sbtree.more <> Nil Then
    build_sbt( entries, sbt, sbtree.more );
End;

Procedure free_sbtree( Var sbtree: PSBTree );
Begin
  If sbtree <> Nil Then
  Begin
    free_sbtree( sbtree.less );
    free_sbtree( sbtree.more );
    Dispose( sbtree );
    sbtree := Nil;
  End;
End;

Function count_optimal_vertices( Const c: TEzPointList ): integer;
Var
  i: integer;
Begin
  result := 0;

  (* Ignore non-contributing contours *)
  If c.NumVertices > 0 Then
  Begin
    For i := 0 To c.NumVertices - 1 Do
      (* Ignore superfluous vertices embedded in horizontal edges *)
      If OPTIMAL( c.vertex, i, c.NumVertices ) Then
        Inc( result );
  End;
End;

Function build_lmt( Var lmt: PLMTNode; Var sbtree: PSBTree;
  Var sbt_entries: integer; p: TEzClipPolygon; istype: integer;
  op: TEzPolyClipOp ): PEdgeNodeArray;
Var
  total_vertices: integer;
  e_index: integer;
  c, i, min, max, num_edges, v, NumVertices: integer;
  e, edge_table: PEdgeNodeArray;
  tmp_node: pointer;
  temp: TEzPointList;
Begin
  total_vertices := 0;
  e_index := 0;

  For c := 0 To p.num_contours - 1 Do
    Inc( total_vertices, count_optimal_vertices( p.contour[c] ) );

  (* Create the entire input polygon edge table in one go *)
  GetMem( edge_table, total_vertices * sizeof( TEdgeNode ) );
  FillChar( edge_table^, total_vertices * sizeof( TEdgeNode ), 0 );

  For c := 0 To p.num_contours - 1 Do
  Begin
    If p.contour[c].NumVertices < 0 Then
    Begin
      (* Ignore the non-contributing contour and repair the vertex count *)
      temp := p.contour[c];
      temp.NumVertices := -p.contour[c].NumVertices;
      p.contour[c] := temp;
    End
    Else
    Begin
      (* Perform contour optimization *)
      NumVertices := 0;
      For i := 0 To p.contour[c].NumVertices - 1 Do
        If OPTIMAL( p.contour[c].vertex, i, p.contour[c].NumVertices ) Then
        Begin
          edge_table[NumVertices].vertex.x := p.contour[c].vertex[i].x;
          edge_table[NumVertices].vertex.y := p.contour[c].vertex[i].y;

          (* Record vertex in the scanbeam table *)
          add_to_sbtree( sbt_entries, sbtree,
            edge_table[NumVertices].vertex.y );

          Inc( NumVertices );
        End;

      (* Do the contour forward pass *)
      For min := 0 To NumVertices - 1 Do
      Begin
        (* If a forward local minimum... *)
        If FWD_MIN( edge_table, min, NumVertices ) Then
        Begin
          (* Search for the next local maximum... *)
          num_edges := 1;
          max := NEXT_INDEX( min, NumVertices );
          While NOT_FMAX( edge_table, max, NumVertices ) Do
          Begin
            Inc( num_edges );
            max := NEXT_INDEX( max, NumVertices );
          End;

          (* Build the next edge list *)
          e := @edge_table^[e_index];
          Inc( e_index, num_edges );
          v := min;
          e[0].bstate[BELOW] := bsUNBUNDLED;
          e[0].bundle[BELOW, CLIP] := ord( False );
          e[0].bundle[BELOW, SUBJ] := ord( False );
          For i := 0 To num_edges - 1 Do
          Begin
            e[i].xb := edge_table[v].vertex.x;
            e[i].bot.x := edge_table[v].vertex.x;
            e[i].bot.y := edge_table[v].vertex.y;

            v := NEXT_INDEX( v, NumVertices );

            e[i].top.x := edge_table[v].vertex.x;
            e[i].top.y := edge_table[v].vertex.y;
            e[i].dx := ( edge_table[v].vertex.x - e[i].bot.x ) /
              ( e[i].top.y - e[i].bot.y );
            e[i].istype := istype;
            e[i].outp[ABOVE] := Nil;
            e[i].outp[BELOW] := Nil;
            e[i].next := Nil;
            e[i].prev := Nil;
            If ( num_edges > 1 ) And ( i < ( num_edges - 1 ) ) Then
              e[i].succ := @e^[i + 1]
            Else
              e[i].succ := Nil;
            If ( num_edges > 1 ) And ( i > 0 ) Then
              e[i].pred := @e^[i - 1]
            Else
              e[i].pred := Nil;
            e[i].next_bound := Nil;
            If op = pcDIFF Then
              e[i].bside[CLIP] := RIGHT
            Else
              e[i].bside[CLIP] := LEFT;
            e[i].bside[SUBJ] := LEFT;
          End;
          tmp_node := bound_list( lmt, edge_table[min].vertex.y );
          insert_bound( PEdgeNode( tmp_node^ ), @e^[0] );
        End;
      End;

      (* Do the contour reverse pass *)
      For min := 0 To NumVertices - 1 Do
      Begin
        (* If a reverse local minimum... *)
        If REV_MIN( edge_table, min, NumVertices ) Then
        Begin
          (* Search for the previous local maximum... *)
          num_edges := 1;
          max := PREV_INDEX( min, NumVertices );
          While ( NOT_RMAX( edge_table, max, NumVertices ) ) Do
          Begin
            Inc( num_edges );
            max := PREV_INDEX( max, NumVertices );
          End;

          (* Build the previous edge list *)
          e := @edge_table^[e_index];
          Inc( e_index, num_edges );
          v := min;
          e[0].bstate[BELOW] := bsUNBUNDLED;
          e[0].bundle[BELOW, CLIP] := ord( FALSE );
          e[0].bundle[BELOW, SUBJ] := ord( FALSE );
          For i := 0 To num_edges - 1 Do
          Begin
            e[i].xb := edge_table[v].vertex.x;
            e[i].bot.x := edge_table[v].vertex.x;
            e[i].bot.y := edge_table[v].vertex.y;

            v := PREV_INDEX( v, NumVertices );

            e[i].top.x := edge_table[v].vertex.x;
            e[i].top.y := edge_table[v].vertex.y;
            e[i].dx := ( edge_table[v].vertex.x - e[i].bot.x ) /
              ( e[i].top.y - e[i].bot.y );
            e[i].istype := istype;
            e[i].outp[ABOVE] := Nil;
            e[i].outp[BELOW] := Nil;
            e[i].next := Nil;
            e[i].prev := Nil;
            If ( num_edges > 1 ) And ( i < ( num_edges - 1 ) ) Then
              e[i].succ := @e^[i + 1]
            Else
              e[i].succ := Nil;
            If ( num_edges > 1 ) And ( i > 0 ) Then
              e[i].pred := @e^[i - 1]
            Else
              e[i].pred := Nil;
            e[i].next_bound := Nil;
            If op = pcDIFF Then
              e[i].bside[CLIP] := RIGHT
            Else
              e[i].bside[CLIP] := LEFT;
            e[i].bside[SUBJ] := LEFT;
          End;
          tmp_node := bound_list( lmt, edge_table[min].vertex.y );
          insert_bound( PEdgeNode( tmp_node^ ), @e^[0] );
        End;
      End;
    End;
  End;
  result := edge_table;
End;

Procedure add_edge_to_aet( Var aet: PEdgeNode; edge, prev: PEdgeNode );
Begin
  If aet = Nil Then
  Begin
    (* Append edge onto the tail end of the AET *)
    aet := edge;
    edge.prev := prev;
    edge.next := Nil;
  End
  Else
  Begin
    (* Do primary sort on the xb field *)
    If edge.xb < aet.xb Then
    Begin
      (* Insert edge here (before the AET edge) *)
      edge.prev := prev;
      edge.next := aet;
      aet.prev := edge;
      aet := edge;
    End
    Else
    Begin
      If edge.xb = aet.xb Then
      Begin
        (* Do secondary sort on the dx field *)
        If edge.dx < aet.dx Then
        Begin
          (* Insert edge here (before the AET edge) *)
          edge.prev := prev;
          edge.next := aet;
          aet.prev := edge;
          aet := edge;
        End
        Else
        Begin
          (* Head further into the AET *)
          add_edge_to_aet( aet.next, edge, aet );
        End;
      End
      Else
      Begin
        (* Head further into the AET *)
        add_edge_to_aet( aet.next, edge, aet );
      End;
    End;
  End;
End;

Procedure add_intersection( Var it: PITNode; edge0, edge1: PEdgeNode;
  Const x, y: double );
Var
  existing_node: PITNode;
Begin
  If it = Nil Then
  Begin
    (* Append a new node to the tail of the list *)
    New( it );
    FillChar( it^, sizeof( TITNode ), 0 );
    it.ie[0] := edge0;
    it.ie[1] := edge1;
    it.point.x := x;
    it.point.y := y;
    it.next := Nil;
  End
  Else
  Begin
    If it.point.y > y Then
    Begin
      (* Insert a new node mid-list *)
      existing_node := it;
      New( it );
      fillchar( it^, sizeof( TITNode ), 0 );
      it.ie[0] := edge0;
      it.ie[1] := edge1;
      it.point.x := x;
      it.point.y := y;
      it.next := existing_node;
    End
    Else
      (* Head further down the list *)
      add_intersection( it.next, edge0, edge1, x, y );
  End;
End;

Procedure add_st_edge( Var st: PStNode; Var it: PITNode; edge: PEdgeNode;
  Const dy: double );
Var
  existing_node: PStNode;
  den, r, x, y: double;
Begin
  If st = Nil Then
  Begin
    (* Append edge onto the tail end of the ST *)
    New( st );
    fillchar( st^, sizeof( TStNode ), 0 );
    st.edge := edge;
    st.xb := edge.xb;
    st.xt := edge.xt;
    st.dx := edge.dx;
    st.prev := Nil;
  End
  Else
  Begin
    den := ( st.xt - st.xb ) - ( edge.xt - edge.xb );

    (* If new edge and ST edge don't cross *)
    If ( edge.xt >= st.xt ) Or ( edge.dx = st.dx ) Or ( abs( den ) <= GPC_EPSILON ) Then
    Begin
      (* No intersection - insert edge here (before the ST edge) *)
      existing_node := st;
      New( st );
      fillchar( st^, sizeof( TStNode ), 0 );
      st.edge := edge;
      st.xb := edge.xb;
      st.xt := edge.xt;
      st.dx := edge.dx;
      st.prev := existing_node;
    End
    Else
    Begin
      (* Compute intersection between new edge and ST edge *)
      r := ( edge.xb - st.xb ) / den;
      x := st.xb + r * ( st.xt - st.xb );
      y := r * dy;

      (* Insert the edge pointers and the intersection point in the IT *)
      add_intersection( it, st.edge, edge, x, y );

      (* Head further into the ST *)
      add_st_edge( st.prev, it, edge, dy );
    End;
  End;
End;

Procedure build_intersection_table( Var it: PITNode; aet: PEdgeNode; Const dy: double );
Var
  st, stp: PStNode;
  edge: PEdgeNode;
Begin

  (* Build intersection table for the current scanbeam *)
  reset_it( it );
  st := Nil;

  (* Process each AET edge *)
  edge := aet;
  While edge <> Nil Do
  Begin
    If ( ( edge.bstate[ABOVE] = bsBUNDLE_HEAD ) Or
      boolean( edge.bundle[ABOVE, CLIP] ) Or
      boolean( edge.bundle[ABOVE, SUBJ] ) ) Then
      add_st_edge( st, it, edge, dy );
    edge := edge.next;
  End;

  (* Free the sorted edge table *)
  While st <> Nil Do
  Begin
    stp := st.prev;
    Dispose( st );
    st := stp;
  End;
End;

Function count_contours( polygon: PPolygonNode ): integer;
Var
  nc, nv: integer;
  v, nextv: PVertexNode;
Begin

  nc := 0;
  While polygon <> Nil Do
  Begin
    If polygon.active <> 0 Then
    Begin
      (* Count the vertices in the current contour *)
      nv := 0;
      v := polygon.proxy.v[LEFT];
      While v <> Nil Do
      Begin
        inc( nv );
        v := v.next;
      End;

      (* Record valid vertex counts in the active field *)
      If nv > 2 Then
      Begin
        polygon.active := nv;
        inc( nc );
      End
      Else
      Begin
        (* Invalid contour: just free the heap *)
        v := polygon.proxy.v[LEFT];
        While v <> Nil Do
        Begin
          nextv := v.next;
          dispose( v );
          v := nextv;
        End;
        polygon.active := 0;
      End;
    End;
    polygon := polygon.next;
  End;
  result := nc;
End;

Procedure add_left( p: PPolygonNode; Const x, y: double );
Var
  nv: PVertexNode;
Begin

  (* Create a new vertex node and set its fields *)
  New( nv );
  fillchar( nv^, sizeof( TVertexNode ), 0 );
  nv^.x := x;
  nv^.y := y;

  (* Add vertex nv to the left end of the polygon's vertex list *)
  nv^.next := p.proxy.v[LEFT];

  (* Update proxy.[LEFT] to point to nv *)
  p.proxy.v[LEFT] := nv;
End;

Procedure merge_left( p, q, list: PPolygonNode );
Var
  target: PPolygonNode;
Begin

  (* Label contour as a hole *)
  q.proxy.hole := TRUE;

  If p.proxy <> q.proxy Then
  Begin
    (* Assign p's vertex list to the left end of q's list *)
    p.proxy.v[RIGHT].next := q.proxy.v[LEFT];
    q.proxy.v[LEFT] := p.proxy.v[LEFT];

    (* Redirect any p.proxy references to q.proxy *)
    target := p.proxy;
    While list <> Nil Do
    Begin
      If list.proxy = target Then
      Begin
        list.active := Ord( FALSE ); //=0
        list.proxy := q.proxy;
      End;
      list := list.next;
    End;
  End;
End;

Procedure add_right( p: PPolygonNode; Const x, y: double );
Var
  nv: PVertexNode;
Begin

  (* Create a new vertex node and set its fields *)
  New( nv );
  fillchar( nv^, sizeof( TVertexNode ), 0 );
  nv.x := x;
  nv.y := y;
  nv.next := Nil;

  (* Add vertex nv to the right end of the polygon's vertex list *)
  p.proxy.v[RIGHT].next := nv;

  (* Update proxy.v[RIGHT] to point to nv *)
  p.proxy.v[RIGHT] := nv;
End;

Procedure merge_right( p, q, list: PPolygonNode );
Var
  target: PPolygonNode;
Begin

  (* Label contour as external *)
  q.proxy.hole := FALSE;

  If p.proxy <> q.proxy Then
  Begin
    (* Assign p's vertex list to the right end of q's list *)
    q.proxy.v[RIGHT].next := p.proxy.v[LEFT];
    q.proxy.v[RIGHT] := p.proxy.v[RIGHT];

    (* Redirect any p.proxy references to q.proxy *)
    target := p.proxy;
    While list <> Nil Do
    Begin
      If list.proxy = target Then
      Begin
        list.active := Ord( FALSE );
        list.proxy := q.proxy;
      End;
      list := list.next;
    End;
  End;
End;

Procedure add_local_min( Var p: PPolygonNode; edge: PEdgeNode; Const x, y: double );
Var
  existing_min: PPolygonNode;
  nv: PVertexNode;
Begin

  existing_min := p;

  New( p );
  fillchar( p^, sizeof( TPolygonNode ), 0 );

  (* Create a new vertex node and set its fields *)
  New( nv );
  fillchar( nv^, sizeof( TVertexNode ), 0 );
  nv.x := x;
  nv.y := y;
  nv.next := Nil;

  (* Initialise proxy to point to p itself *)
  p.proxy := p;
  p.active := Ord( TRUE );
  p.next := existing_min;

  (* Make v[LEFT] and v[RIGHT] point to new vertex nv *)
  p.v[LEFT] := nv;
  p.v[RIGHT] := nv;

  (* Assign polygon p to the edge *)
  edge^.outp[ABOVE] := p;
End;

{$IFDEF FALSE}

Function count_tristrips( tn: PPolygonNode ): integer;
Begin
  result := 0;
  While tn <> Nil Do
  Begin
    If tn.active > 2 Then
      Inc( result );
    tn := tn.next;
  End;
End;

Procedure new_tristrip( Var tn: PPolygonNode; edge: PEdgeNode; Const x, y: double );
Begin
  If tn = Nil Then
  Begin
    New( tn );
    fillchar( tn^, sizeof( TPolygonNode ), 0 );
    tn.next := Nil;
    tn.v[LEFT] := Nil;
    tn.v[RIGHT] := Nil;
    tn.active := 1;
    add_vertex( tn.v[LEFT], x, y );
    edge.outp[ABOVE] := tn;
  End
  Else
    (* Head further down the list *)
    new_tristrip( tn.next, edge, x, y );
End;
{$ENDIF}

Function create_contour_bboxes( p: TEzClipPolygon ): PEzRectArray;
Var
  box: PEzRectArray;
  c, v: integer;
Begin

  GetMem( box, p.num_contours * sizeof( TEzRect ) );
  fillchar( box^, p.num_contours * sizeof( TEzRect ), 0 );

  (* Construct contour bounding boxes *)
  For c := 0 To p.num_contours - 1 Do
  Begin
    (* Initialise bounding box extent *)
    box[c].xmin := DBL_MAX;
    box[c].ymin := DBL_MAX;
    box[c].xmax := -DBL_MAX;
    box[c].ymax := -DBL_MAX;

    For v := 0 To p.contour[c].NumVertices - 1 Do
    Begin
      (* Adjust bounding box *)
      box[c].xmin := dmin( box[c].xmin, p.contour[c].vertex[v].x );
      box[c].ymin := dmin( box[c].ymin, p.contour[c].vertex[v].y );
      box[c].xmax := dmax( box[c].xmax, p.contour[c].vertex[v].x );
      box[c].ymax := dmax( box[c].ymax, p.contour[c].vertex[v].y );
    End;
  End;
  result := box;
End;

Procedure minimax_test( subj, clip: TEzClipPolygon; op: TEzPolyClipOp );
Var
  s_bbox, c_bbox: PEzRectArray;
  s, c, arrsize: integer;
  overlap: boolean;
  o_table: PBooleanArray;
  temp: TEzPointList;
Begin

  s_bbox := create_contour_bboxes( subj );
  c_bbox := create_contour_bboxes( clip );

  arrsize := subj.num_contours * clip.num_contours;
  GetMem( o_table, arrsize * sizeof( boolean ) );
  fillchar( o_table^, arrsize * sizeof( boolean ), 0 );

  (* Check all subject contour bounding boxes against clip boxes *)
  For s := 0 To subj.num_contours - 1 Do
    For c := 0 To clip.num_contours - 1 Do
      o_table[c * subj.num_contours + s] :=
        ( Not ( ( s_bbox[s].xmax < c_bbox[c].xmin ) Or
        ( s_bbox[s].xmin > c_bbox[c].xmax ) ) ) And
        ( Not ( ( s_bbox[s].ymax < c_bbox[c].ymin ) Or
        ( s_bbox[s].ymin > c_bbox[c].ymax ) ) );

  (* For each clip contour, search for any subject contour overlaps *)
  For c := 0 To clip.num_contours - 1 Do
  Begin
    overlap := false;
    s := 0;
    While ( Not overlap ) And ( s < subj.num_contours ) Do
    Begin
      overlap := o_table[c * subj.num_contours + s];
      Inc( s );
    End;

    If Not overlap Then
    Begin
      (* Flag non contributing status by negating vertex count *)
      temp := clip.contour[c];
      temp.NumVertices := -clip.contour[c].NumVertices;
      clip.contour[c] := temp;
    End;
  End;

  If op = pcINT Then
  Begin
    (* For each subject contour, search for any clip contour overlaps *)
    For s := 0 To subj.num_contours - 1 Do
    Begin
      overlap := false;
      c := 0;
      While ( Not overlap ) And ( c < clip.num_contours ) Do
      Begin
        overlap := o_table[c * subj.num_contours + s];
        Inc( c );
      End;
      If Not overlap Then
      Begin
        (* Flag non contributing status by negating vertex count *)
        temp := clip.contour[s];
        temp.NumVertices := -subj.contour[s].NumVertices;
        clip.contour[s] := temp;
      End;
    End;
  End;
  FreeMem( s_bbox, subj.num_contours * sizeof( TEzRect ) );
  FreeMem( c_bbox, clip.num_contours * sizeof( TEzRect ) );
  FreeMem( o_table, arrsize * sizeof( boolean ) );
End;

Procedure freeheap( p: TEzClipPolygon; heap: PEdgeNodeArray );
Var
  c, total_vertices: integer;
Begin
  total_vertices := 0;
  For c := 0 To p.num_contours - 1 Do
    Inc( total_vertices, count_optimal_vertices( p.contour[c] ) );
  FreeMem( heap, total_vertices * sizeof( TEdgeNode ) );
End;

Procedure GPCPolygonClip( op: TEzPolyClipOp; subject, clipping, result: TEzClipPolygon );
Var
  sbtree: PSBTree;
  it: PITNode;
  aet: PEdgeNode;
  c_heap: PEdgeNodeArray;
  s_heap: PEdgeNodeArray;
  lmt: PLMTNode;
  out_poly: PPolygonNode;
  cf: PPolygonNode;
  parity: Array[0..1] Of integer;
  scanbeam: integer;
  sbt_entries: integer;
  sbt: PDoubleArray;

  intersect: PITNode;
  edge, prev_edge, next_edge, succ_edge, e0, e1: PEdgeNode;
  local_min: PLMTNode;
  p, q, poly, npoly: PPolygonNode;
  vtx, nv: PVertexNode;
  horiz: Array[0..1] Of THState;
  ain, exists: Array[0..1] Of integer;
  c, v, tmpcontours: integer;
  contour: TEzPointList;
  search, contributing: boolean;
  vclass, bl, br, tl, tr: integer;
  xb, px, yb, yt, dy, ix, iy: double;
Begin

  sbtree := Nil;
  it := Nil;
  aet := Nil;
  c_heap := Nil;
  s_heap := Nil;
  lmt := Nil;
  out_poly := Nil;
  cf := Nil;
  parity[0] := LEFT;
  parity[1] := LEFT;

  scanbeam := 0;
  sbt_entries := 0;
  //sbt:= nil;

  (* Test for trivial NIL result cases *)
  If ( ( ( subject.num_contours = 0 ) And ( clipping.num_contours = 0 ) )
    Or ( ( subject.num_contours = 0 ) And ( ( op = pcINT ) Or ( op = pcDIFF ) ) )
    Or ( ( clipping.num_contours = 0 ) And ( op = pcINT ) ) ) Then
  Begin
    result.clear;
    exit;
  End;

  (* Identify potentialy contributing contours *)
  If ( ( ( op = pcINT ) Or ( op = pcDIFF ) ) And
    ( subject.num_contours > 0 ) And ( clipping.num_contours > 0 ) ) Then
    minimax_test( subject, clipping, op );

  (* Build LMT *)
  If subject.num_contours > 0 Then
    s_heap := build_lmt( lmt, sbtree, sbt_entries, subject, SUBJ, op );
  If clipping.num_contours > 0 Then
    c_heap := build_lmt( lmt, sbtree, sbt_entries, clipping, CLIP, op );

  (* Return a NIL result if no contours contribute *)
  If lmt = Nil Then
  Begin
    result.clear;
    freeheap( subject, s_heap );
    freeheap( clipping, c_heap );
    exit;
  End;

  (* Build scanbeam table from scanbeam tree *)
  GetMem( sbt, sbt_entries * sizeof( double ) );
  fillchar( sbt^, sbt_entries * sizeof( double ), 0 );
  build_sbt( scanbeam, sbt, sbtree );
  scanbeam := 0;
  free_sbtree( sbtree );

  (* Invert clipping polygon for difference operation *)
  If op = pcDIFF Then
    parity[CLIP] := RIGHT;

  local_min := lmt;

  (* Process each scanbeam *)
  While scanbeam < sbt_entries Do
  Begin
    (* Set yb and yt to the bottom and top of the scanbeam *)
    yb := sbt[scanbeam];
    yt := 0;
    Inc( scanbeam );
    If scanbeam < sbt_entries Then
    Begin
      yt := sbt[scanbeam];
      dy := yt - yb;
    End;

    (* === SCANBEAM BOUNDARY PROCESSING ================================ *)

    (* If LMT node corresponding to yb exists *)
    If ( local_min <> Nil ) And ( local_min.y = yb ) Then
    Begin
      (* Add edges starting at this local minimum to the AET *)
      edge := local_min.first_bound;
      While edge <> Nil Do
      Begin
        add_edge_to_aet( aet, edge, Nil );
        edge := edge.next_bound;
      End;

      local_min := local_min.next;
    End;

    (* Set dummy previous x value *)
    px := -DBL_MAX;

    (* Create bundles within AET *)
    e0 := aet;
    //e1:= aet;

    (* Set up bundle fields of first edge *)
    aet.bundle[ABOVE, aet.istype] := Ord( ( aet.top.y <> yb ) );
    aet.bundle[ABOVE, ( 1 - aet.istype )] := ord( FALSE );
    aet.bstate[ABOVE] := bsUNBUNDLED;

    next_edge := aet.next;
    While next_edge <> Nil Do
    Begin

      (* Set up bundle fields of next edge *)
      next_edge.bundle[ABOVE, next_edge.istype] := ord( ( next_edge.top.y <> yb ) );
      next_edge.bundle[ABOVE, ( 1 - next_edge.istype )] := ord( FALSE );
      next_edge.bstate[ABOVE] := bsUNBUNDLED;

      (* Bundle edges above the scanbeam boundary if they coincide *)
      If next_edge.bundle[ABOVE, next_edge.istype] <> 0 Then
      Begin
        If ( EQ( e0.xb, next_edge.xb ) And EQ( e0.dx, next_edge.dx ) And
          ( e0.top.y <> yb ) ) Then
        Begin
          next_edge.bundle[ABOVE, next_edge.istype] :=
            next_edge.bundle[ABOVE, next_edge.istype] Xor
            e0.bundle[ABOVE, next_edge.istype];
          next_edge.bundle[ABOVE, ( 1 - next_edge.istype )] :=
            e0.bundle[ABOVE, ( 1 - next_edge.istype )];
          next_edge.bstate[ABOVE] := bsBUNDLE_HEAD;
          e0.bundle[ABOVE, CLIP] := ord( FALSE );
          e0.bundle[ABOVE, SUBJ] := ord( FALSE );
          e0.bstate[ABOVE] := bsBUNDLE_TAIL;
        End;
        e0 := next_edge;
      End;

      next_edge := next_edge.next;
    End;

    horiz[CLIP] := hsNH;
    horiz[SUBJ] := hsNH;

    (* Process each edge at this scanbeam boundary *)
    edge := aet;
    While edge <> Nil Do
    Begin
      exists[CLIP] := edge.bundle[ABOVE, CLIP] +
        ( edge.bundle[BELOW, CLIP] Shl 1 );
      exists[SUBJ] := edge.bundle[ABOVE, SUBJ] +
        ( edge.bundle[BELOW, SUBJ] Shl 1 );

      If boolean( exists[CLIP] ) Or boolean( exists[SUBJ] ) Then
      Begin
        (* Set bundle side *)
        edge.bside[CLIP] := parity[CLIP];
        edge.bside[SUBJ] := parity[SUBJ];

        (* Determine contributing status and quadrant occupancies *)
        bl := 0;
        br := 0;
        tl := 0;
        tr := 0;
        contributing := false;
        Case op Of
          pcDIFF, pcINT:
            Begin
              contributing := ( ( exists[CLIP] <> 0 ) And ( ( parity[SUBJ] <> 0 ) Or
                ( ord( horiz[SUBJ] ) <> 0 ) ) )
                Or ( ( exists[SUBJ] <> 0 ) And ( ( parity[CLIP] <> 0 ) Or
                ( ord( horiz[CLIP] ) <> 0 ) ) )
                Or ( ( exists[CLIP] <> 0 ) And ( exists[SUBJ] <> 0 )
                And ( parity[CLIP] = parity[SUBJ] ) );
              br := parity[CLIP] And parity[SUBJ];
              bl := ( parity[CLIP] Xor edge.bundle[ABOVE, CLIP] )
                And ( parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ] );
              tr := ( parity[CLIP] Xor ord( horiz[CLIP] <> hsNH ) )
                And ( parity[SUBJ] Xor ord( horiz[SUBJ] <> hsNH ) );
              tl := ( parity[CLIP] Xor ord( horiz[CLIP] <> hsNH ) Xor
                edge.bundle[BELOW, CLIP] )
                And ( parity[SUBJ] Xor ord( horiz[SUBJ] <> hsNH ) Xor
                edge.bundle[BELOW, SUBJ] );
            End;
          pcXOR:
            Begin
              contributing := ( exists[CLIP] <> 0 ) Or ( exists[SUBJ] <> 0 );
              br := ( parity[CLIP] )
                Xor ( parity[SUBJ] );
              bl := ( parity[CLIP] Xor edge.bundle[ABOVE, CLIP] )
                Xor ( parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ] );
              tr := ( parity[CLIP] Xor ord( horiz[CLIP] <> hsNH ) )
                Xor ( parity[SUBJ] Xor ord( horiz[SUBJ] <> hsNH ) );
              tl := ( parity[CLIP] Xor ord( horiz[CLIP] <> hsNH ) Xor
                edge.bundle[BELOW, CLIP] )
                Xor ( parity[SUBJ] Xor ord( horiz[SUBJ] <> hsNH ) Xor
                edge.bundle[BELOW, SUBJ] );
            End;
          pcUNION:
            Begin
              contributing := ( ( exists[CLIP] <> 0 ) And ( ( parity[SUBJ] = 0 ) Or
                ( ord( horiz[SUBJ] ) <> 0 ) ) )
                Or ( ( exists[SUBJ] <> 0 ) And ( ( parity[CLIP] = 0 ) Or
                ( ord( horiz[CLIP] ) <> 0 ) ) )
                Or ( ( exists[CLIP] <> 0 ) And ( exists[SUBJ] <> 0 )
                And ( parity[CLIP] = parity[SUBJ] ) );
              br := ( parity[CLIP] )
                Or ( parity[SUBJ] );
              bl := ( parity[CLIP] Xor edge.bundle[ABOVE, CLIP] )
                Or ( parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ] );
              tr := ( parity[CLIP] Xor ord( horiz[CLIP] <> hsNH ) )
                Or ( parity[SUBJ] Xor ord( horiz[SUBJ] <> hsNH ) );
              tl := ( parity[CLIP] Xor ord( horiz[CLIP] <> hsNH ) Xor
                edge.bundle[BELOW, CLIP] )
                Or ( parity[SUBJ] Xor ord( horiz[SUBJ] <> hsNH ) Xor
                edge.bundle[BELOW, SUBJ] );
            End;
        End;

        (* Update parity *)
        parity[CLIP] := parity[CLIP] Xor edge.bundle[ABOVE, CLIP];
        parity[SUBJ] := parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ];

        (* Update horizontal state *)
        If boolean( exists[CLIP] ) Then
          horiz[CLIP] := next_hstate[ord( horiz[CLIP] ), ( ( exists[CLIP] - 1 ) Shl 1 ) + parity[CLIP]];
        If boolean( exists[SUBJ] ) Then
          horiz[SUBJ] :=
            next_hstate[ord( horiz[SUBJ] ),
            ( ( exists[SUBJ] - 1 ) Shl 1 ) + parity[SUBJ]];

        vclass := tr + ( tl Shl 1 ) + ( br Shl 2 ) + ( bl Shl 3 );

        If contributing Then
        Begin
          xb := edge.xb;

          Case TVertexType( vclass ) Of
            vtEMN, vtIMN:
              Begin
                add_local_min( out_poly, edge, xb, yb );
                px := xb;
                cf := edge.outp[ABOVE];
              End;
            vtERI:
              Begin
                If xb <> px Then
                Begin
                  add_right( cf, xb, yb );
                  px := xb;
                End;
                edge.outp[ABOVE] := cf;
                cf := Nil;
              End;
            vtELI:
              Begin
                add_left( edge.outp[BELOW], xb, yb );
                px := xb;
                cf := edge.outp[BELOW];
              End;
            vtEMX:
              Begin
                If xb <> px Then
                Begin
                  add_left( cf, xb, yb );
                  px := xb;
                End;
                merge_right( cf, edge.outp[BELOW], out_poly );
                cf := Nil;
              End;
            vtILI:
              Begin
                If xb <> px Then
                Begin
                  add_left( cf, xb, yb );
                  px := xb;
                End;
                edge.outp[ABOVE] := cf;
                cf := Nil;
              End;
            vtIRI:
              Begin
                add_right( edge.outp[BELOW], xb, yb );
                px := xb;
                cf := edge.outp[BELOW];
                edge.outp[BELOW] := Nil;
              End;
            vtIMX:
              Begin
                If xb <> px Then
                Begin
                  add_right( cf, xb, yb );
                  px := xb;
                End;
                merge_left( cf, edge.outp[BELOW], out_poly );
                cf := Nil;
                edge.outp[BELOW] := Nil;
              End;
            vtIMM:
              Begin
                If xb <> px Then
                Begin
                  add_right( cf, xb, yb );
                  px := xb;
                End;
                merge_left( cf, edge.outp[BELOW], out_poly );
                edge.outp[BELOW] := Nil;
                add_local_min( out_poly, edge, xb, yb );
                cf := edge.outp[ABOVE];
              End;
            vtEMM:
              Begin
                If xb <> px Then
                Begin
                  add_left( cf, xb, yb );
                  px := xb;
                End;
                merge_right( cf, edge.outp[BELOW], out_poly );
                edge.outp[BELOW] := Nil;
                add_local_min( out_poly, edge, xb, yb );
                cf := edge.outp[ABOVE];
              End;
            vtLED:
              Begin
                If edge.bot.y = yb Then
                  add_left( edge.outp[BELOW], xb, yb );
                edge.outp[ABOVE] := edge.outp[BELOW];
                px := xb;
              End;
            vtRED:
              Begin
                If edge.bot.y = yb Then
                  add_right( edge.outp[BELOW], xb, yb );
                edge.outp[ABOVE] := edge.outp[BELOW];
                px := xb;
              End;
          End; (* End of switch *)
        End; (* End of contributing conditional *)
      End; (* End of edge exists conditional *)

      edge := edge.next;
    End; (* End of AET loop *)

    (* Delete terminating edges from the AET, otherwise compute xt *)
    edge := aet;
    While edge <> Nil Do
    Begin
      If edge.top.y = yb Then
      Begin
        prev_edge := edge.prev;
        next_edge := edge.next;
        If prev_edge <> Nil Then
          prev_edge.next := next_edge
        Else
          aet := next_edge;
        If next_edge <> Nil Then
          next_edge.prev := prev_edge;

        (* Copy bundle head state to the adjacent tail edge if required *)
        If ( ( edge.bstate[BELOW] = bsBUNDLE_HEAD ) And ( prev_edge <> Nil ) ) And
          ( prev_edge.bstate[BELOW] = bsBUNDLE_TAIL ) Then
        Begin
          prev_edge.outp[BELOW] := edge.outp[BELOW];
          prev_edge.bstate[BELOW] := bsUNBUNDLED;
          If ( prev_edge.prev <> Nil ) And
            ( prev_edge.prev.bstate[BELOW] = bsBUNDLE_TAIL ) Then
            prev_edge.bstate[BELOW] := bsBUNDLE_HEAD;
        End;
      End
      Else
      Begin
        If edge.top.y = yt Then
          edge.xt := edge.top.x
        Else
          edge.xt := edge.bot.x + edge.dx * ( yt - edge.bot.y );
      End;

      edge := edge.next;
    End;

    If scanbeam < sbt_entries Then
    Begin
      (* === SCANBEAM INTERIOR PROCESSING ============================== *)

      build_intersection_table( it, aet, dy );

      (* Process each node in the intersection table *)
      intersect := it;
      While intersect <> Nil Do
      Begin
        e0 := intersect.ie[0];
        e1 := intersect.ie[1];

        (* Only generate output for contributing intersections *)
        If ( boolean( e0.bundle[ABOVE, CLIP] ) Or boolean( e0.bundle[ABOVE, SUBJ] ) ) And
          ( boolean( e1.bundle[ABOVE, CLIP] ) Or boolean( e1.bundle[ABOVE, SUBJ] ) ) Then
        Begin
          p := e0.outp[ABOVE];
          q := e1.outp[ABOVE];
          ix := intersect.point.x;
          iy := intersect.point.y + yb;

          ain[CLIP] := integer( ( boolean( e0.bundle[ABOVE, CLIP] ) And Not
            boolean( e0.bside[CLIP] ) )
            Or ( boolean( e1.bundle[ABOVE, CLIP] ) And boolean( e1.bside[CLIP] ) )
            Or ( Not boolean( e0.bundle[ABOVE, CLIP] ) And Not
            boolean( e1.bundle[ABOVE, CLIP] )
            And boolean( e0.bside[CLIP] ) And boolean( e1.bside[CLIP] ) ) );
          ain[SUBJ] := integer( ( boolean( e0.bundle[ABOVE, SUBJ] ) And Not
            boolean( e0.bside[SUBJ] ) )
            Or ( boolean( e1.bundle[ABOVE, SUBJ] ) And boolean( e1.bside[SUBJ] ) )
            Or ( Not boolean( e0.bundle[ABOVE, SUBJ] ) And Not
            boolean( e1.bundle[ABOVE, SUBJ] )
            And boolean( e0.bside[SUBJ] ) And boolean( e1.bside[SUBJ] ) ) );
          (* Determine quadrant occupancies *)
          bl := 0;
          br := 0;
          tl := 0;
          tr := 0;
          Case op Of
            pcDIFF, pcINT:
              Begin
                tr := ( ain[CLIP] ) And ( ain[SUBJ] );
                tl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] )
                  And ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] );
                br := ( ain[CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  And ( ain[SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
                bl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] Xor e0.bundle[ABOVE,
                  CLIP] )
                  And ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] Xor e0.bundle[ABOVE,
                  SUBJ] );
              End;
            pcXOR:
              Begin
                tr := ( ain[CLIP] ) Xor ( ain[SUBJ] );
                tl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] )
                  Xor ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] );
                br := ( ain[CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  Xor ( ain[SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
                bl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] Xor e0.bundle[ABOVE,
                  CLIP] )
                  Xor ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] Xor e0.bundle[ABOVE,
                  SUBJ] );
              End;
            pcUNION:
              Begin
                tr := ( ain[CLIP] ) Or ( ain[SUBJ] );
                tl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] )
                  Or ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] );
                br := ( ain[CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  Or ( ain[SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
                bl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] Xor e0.bundle[ABOVE,
                  CLIP] )
                  Or ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] Xor e0.bundle[ABOVE,
                  SUBJ] );
              End;
          End;

          vclass := tr + ( tl Shl 1 ) + ( br Shl 2 ) + ( bl Shl 3 );

          Case TVertexType( vclass ) Of
            vtEMN:
              Begin
                add_local_min( out_poly, e0, ix, iy );
                e1.outp[ABOVE] := e0.outp[ABOVE];
              End;
            vtERI:
              If p <> Nil Then
              Begin
                add_right( p, ix, iy );
                e1.outp[ABOVE] := p;
                e0.outp[ABOVE] := Nil;
              End;
            vtELI:
              If q <> Nil Then
              Begin
                add_left( q, ix, iy );
                e0.outp[ABOVE] := q;
                e1.outp[ABOVE] := Nil;
              End;
            vtEMX:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                add_left( p, ix, iy );
                merge_right( p, q, out_poly );
                e0.outp[ABOVE] := Nil;
                e1.outp[ABOVE] := Nil;
              End;
            vtIMN:
              Begin
                add_local_min( out_poly, e0, ix, iy );
                e1.outp[ABOVE] := e0.outp[ABOVE];
              End;
            vtILI:
              If p <> Nil Then
              Begin
                add_left( p, ix, iy );
                e1.outp[ABOVE] := p;
                e0.outp[ABOVE] := Nil;
              End;
            vtIRI:
              If q <> Nil Then
              Begin
                add_right( q, ix, iy );
                e0.outp[ABOVE] := q;
                e1.outp[ABOVE] := Nil;
              End;
            vtIMX:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                add_right( p, ix, iy );
                merge_left( p, q, out_poly );
                e0.outp[ABOVE] := Nil;
                e1.outp[ABOVE] := Nil;
              End;
            vtIMM:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                add_right( p, ix, iy );
                merge_left( p, q, out_poly );
                add_local_min( out_poly, e0, ix, iy );
                e1.outp[ABOVE] := e0.outp[ABOVE];
              End;
            vtEMM:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                add_left( p, ix, iy );
                merge_right( p, q, out_poly );
                add_local_min( out_poly, e0, ix, iy );
                e1.outp[ABOVE] := e0.outp[ABOVE];
              End;
          End; (* End of switch *)

        End; (* End of contributing intersection conditional *)

        (* Swap bundle sides in response to edge crossing *)
        If boolean( e0.bundle[ABOVE, CLIP] ) Then
          e1.bside[CLIP] := ( 1 - e1.bside[CLIP] );
        If boolean( e1.bundle[ABOVE, CLIP] ) Then
          e0.bside[CLIP] := ( 1 - e0.bside[CLIP] );
        If boolean( e0.bundle[ABOVE, SUBJ] ) Then
          e1.bside[SUBJ] := ( 1 - e1.bside[SUBJ] );
        If boolean( e1.bundle[ABOVE, SUBJ] ) Then
          e0.bside[SUBJ] := ( 1 - e0.bside[SUBJ] );

        (* Swap e0 and e1 bundles in the AET *)
        prev_edge := e0.prev;
        next_edge := e1.next;
        If next_edge <> Nil Then
          next_edge.prev := e0;

        If e0.bstate[ABOVE] = bsBUNDLE_HEAD Then
        Begin
          search := TRUE;
          While ( search ) Do
          Begin
            prev_edge := prev_edge.prev;
            If prev_edge <> Nil Then
            Begin
              If prev_edge.bstate[ABOVE] <> bsBUNDLE_TAIL Then
                search := FALSE;
            End
            Else
              search := FALSE;
          End;
        End;
        If prev_edge = Nil Then
        Begin
          aet.prev := e1;
          e1.next := aet;
          aet := e0.next;
        End
        Else
        Begin
          prev_edge.next.prev := e1;
          e1.next := prev_edge.next;
          prev_edge.next := e0.next;
        End;
        e0.next.prev := prev_edge;
        e1.next.prev := e1;
        e0.next := next_edge;

        intersect := intersect.next;
      End; (* End of IT loop*)

      (* Prepare for next scanbeam *)
      edge := aet;
      While edge <> Nil Do
      Begin
        next_edge := edge.next;
        succ_edge := edge.succ;

        If ( edge.top.y = yt ) And ( succ_edge <> Nil ) Then
        Begin
          (* Replace AET edge by its successor *)
          succ_edge.outp[BELOW] := edge.outp[ABOVE];
          succ_edge.bstate[BELOW] := edge.bstate[ABOVE];
          succ_edge.bundle[BELOW, CLIP] := edge.bundle[ABOVE, CLIP];
          succ_edge.bundle[BELOW, SUBJ] := edge.bundle[ABOVE, SUBJ];
          prev_edge := edge.prev;
          If prev_edge <> Nil Then
            prev_edge.next := succ_edge
          Else
            aet := succ_edge;
          If next_edge <> Nil Then
            next_edge.prev := succ_edge;
          succ_edge.prev := prev_edge;
          succ_edge.next := next_edge;
        End
        Else
        Begin
          (* Update this edge *)
          edge.outp[BELOW] := edge.outp[ABOVE];
          edge.bstate[BELOW] := edge.bstate[ABOVE];
          edge.bundle[BELOW, CLIP] := edge.bundle[ABOVE, CLIP];
          edge.bundle[BELOW, SUBJ] := edge.bundle[ABOVE, SUBJ];
          edge.xb := edge.xt;
        End;
        edge.outp[ABOVE] := Nil;

        edge := next_edge
      End;
    End;
  End; (* === END OF SCANBEAM PROCESSING ================================== *)

  (* Generate result polygon from out_poly *)
  result.clear;
  result.hole.clear;
  tmpcontours := count_contours( out_poly );
  If tmpcontours > 0 Then
  Begin

    c := 0;
    poly := out_poly;
    While poly <> Nil Do
    Begin
      npoly := poly.next;
      If poly.active <> 0 Then
      Begin

        contour.NumVertices := poly.active;
        GetMem( contour.vertex, contour.NumVertices * sizeof( TEzPoint ) );
        fillchar( contour.vertex^, contour.NumVertices * sizeof( TEzPoint ), 0 );
        result.Add( contour );
        result.hole[c] := Pointer( poly.proxy.hole );

        v := contour.NumVertices - 1;
        vtx := poly.proxy.v[LEFT];
        While vtx <> Nil Do
        Begin
          nv := vtx.next;
          contour.vertex[v].x := vtx.x;
          contour.vertex[v].y := vtx.y;
          Dispose( vtx );
          Dec( v );

          vtx := nv;
        End;
        Inc( c );
      End;
      Dispose( poly );

      poly := npoly;
    End;
  End;

  (* Tidy up *)
  reset_it( it );
  reset_lmt( lmt );
  freeheap( subject, s_heap );
  freeheap( clipping, c_heap );
  FreeMem( sbt, sbt_entries * sizeof( double ) );
End;

{$IFDEF FALSE}

Procedure gpc_tristrip_clip( op: TEzPolyClipOp; subject, clipping: TEzClipPolygon;
  result: Tgpc_tristrip );
Var
  sbtree: PSBTree;
  it: PITNode;
  aet: PEdgeNode;
  c_heap: PEdgeNodeArray;
  s_heap: PEdgeNodeArray;
  lmt: PLMTNode;
  tlist: PPolygonNode;
  cf: PEdgeNode;
  parity: Array[0..1] Of integer;
  scanbeam: integer;
  sbt_entries: integer;
  sbt: PDoubleArray;

  intersect: PITNode;
  edge, prev_edge, next_edge, succ_edge, e0, e1: PEdgeNode;
  local_min: PLMTNode;
  p, q, tn, tnn: PPolygonNode;
  lt, ltn, rt, rtn: PVertexNode;
  horiz: Array[0..1] Of THState;
  cft: TVertexType;
  ain, exists: Array[0..1] Of integer;
  s, v: integer;
  search, contributing: boolean;
  vclass, bl, br, tl, tr: integer;
  xb, px, nx, yb, yt, dy, ix, iy: double;
  num_strips: integer;
  strip: TEzPointList;
Begin
  sbtree := Nil;
  it := Nil;
  aet := Nil;
  c_heap := Nil;
  s_heap := Nil;
  lmt := Nil;
  tlist := Nil;
  cf := Nil;
  parity[0] := LEFT;
  parity[1] := LEFT;
  scanbeam := 0;
  sbt_entries := 0;
  sbt := Nil;

  (* Test for trivial NIL result cases *)
  If ( ( ( subject.num_contours = 0 ) And ( clipping.num_contours = 0 ) ) Or
    ( ( subject.num_contours = 0 ) And ( ( op = pcINT ) Or ( op = pcDIFF ) ) ) Or
    ( ( clipping.num_contours = 0 ) And ( op = pcINT ) ) ) Then
  Begin
    result.clear;
    exit;
  End;

  (* Identify potentialy contributing contours *)
  If ( ( ( op = pcINT ) Or ( op = pcDIFF ) )
    And ( subject.num_contours > 0 ) And ( clipping.num_contours > 0 ) ) Then
    minimax_test( subject, clipping, op );

  (* Build LMT *)
  If subject.num_contours > 0 Then
    s_heap := build_lmt( lmt, sbtree, sbt_entries, subject, SUBJ, op );
  If clipping.num_contours > 0 Then
    c_heap := build_lmt( lmt, sbtree, sbt_entries, clipping, CLIP, op );

  (* Return a NIL result if no contours contribute *)
  If lmt = Nil Then
  Begin
    result.clear;
    reset_lmt( lmt );
    freeheap( subject, s_heap );
    freeheap( clipping, c_heap );
    exit;
  End;

  (* Build scanbeam table from scanbeam tree *)
  GetMem( sbt, sbt_entries * sizeof( double ) );
  fillchar( sbt^, sbt_entries * sizeof( double ), 0 );
  build_sbt( scanbeam, sbt, sbtree );
  scanbeam := 0;
  free_sbtree( sbtree );

  (* Invert clipping polygon for difference operation *)
  If op = pcDIFF Then
    parity[CLIP] := RIGHT;

  local_min := lmt;

  (* Process each scanbeam *)
  While scanbeam < sbt_entries Do
  Begin
    (* Set yb and yt to the bottom and top of the scanbeam *)
    yb := sbt[scanbeam];
    Inc( scanbeam );
    If scanbeam < sbt_entries Then
    Begin
      yt := sbt[scanbeam];
      dy := yt - yb;
    End;

    (* === SCANBEAM BOUNDARY PROCESSING ================================ *)

    (* If LMT node corresponding to yb exists *)
    If ( local_min <> Nil ) And ( local_min.y = yb ) Then
      //(EQ(local_min.y, yb)) then
    Begin
      (* Add edges starting at this local minimum to the AET *)
      edge := local_min.first_bound;
      While edge <> Nil Do
      Begin
        add_edge_to_aet( aet, edge, Nil );
        edge := edge.next_bound;
      End;

      local_min := local_min.next;
    End;

    (* Set dummy previous x value *)
    px := -DBL_MAX;

    (* Create bundles within AET *)
    e0 := aet;
    e1 := aet;

    (* Set up bundle fields of first edge *)
    aet.bundle[ABOVE, aet.istype] := ord( aet.top.y <> yb );
    //ord(NE(aet.top.y, yb));
    aet.bundle[ABOVE, ( 1 - aet.istype )] := ord( FALSE );
    aet.bstate[ABOVE] := UNBUNDLED;

    next_edge := aet.next;
    While next_edge <> Nil Do
    Begin

      (* Set up bundle fields of next edge *)
      next_edge.bundle[ABOVE, next_edge.istype] := ord( next_edge.top.y <> yb );
      next_edge.bundle[ABOVE, ( 1 - next_edge.istype )] := ord( FALSE );
      next_edge.bstate[ABOVE] := UNBUNDLED;

      (* Bundle edges above the scanbeam boundary if they coincide *)
      If next_edge.bundle[ABOVE, next_edge.istype] <> 0 Then
      Begin
        If EQ( e0.xb, next_edge.xb ) And EQ( e0.dx, next_edge.dx )
          And ( e0.top.y <> yb ) Then
        Begin
          next_edge.bundle[ABOVE, next_edge.istype] :=
            e0.bundle[ABOVE, next_edge.istype];
          {next_edge.bundle[ABOVE, next_edge.istype] xor
          e0.bundle[ABOVE, next_edge.istype]; }
          next_edge.bundle[ABOVE, ( 1 - next_edge.istype )] :=
            e0.bundle[ABOVE, ( 1 - next_edge.istype )];
          next_edge.bstate[ABOVE] := bsBUNDLE_HEAD;
          e0.bundle[ABOVE, CLIP] := ord( FALSE );
          e0.bundle[ABOVE, SUBJ] := ord( FALSE );
          e0.bstate[ABOVE] := BUNDLE_TAIL;
        End;
        e0 := next_edge;
      End;

      next_edge := next_edge.next;
    End;

    horiz[CLIP] := NH;
    horiz[SUBJ] := NH;

    (* Process each edge at this scanbeam boundary *)
    edge := aet;
    While edge <> Nil Do
    Begin
      exists[CLIP] := edge.bundle[ABOVE, CLIP] +
        ( edge.bundle[BELOW, CLIP] Shl 1 );
      exists[SUBJ] := edge.bundle[ABOVE, SUBJ] +
        ( edge.bundle[BELOW, SUBJ] Shl 1 );

      If boolean( exists[CLIP] ) Or boolean( exists[SUBJ] ) Then
      Begin
        (* Set bundle side *)
        edge.bside[CLIP] := parity[CLIP];
        edge.bside[SUBJ] := parity[SUBJ];

        (* Determine contributing status and quadrant occupancies *)
        Case op Of
          pcDIFF, pcINT:
            Begin
              contributing := ( ( exists[CLIP] <> 0 ) And ( ( parity[SUBJ] <> 0 ) Or ( ord( horiz[SUBJ] ) <> 0 ) ) )
                Or ( ( exists[SUBJ] <> 0 ) And ( ( parity[CLIP] <> 0 ) Or ( ord( horiz[CLIP] ) <> 0 ) ) )
                Or ( ( exists[CLIP] <> 0 ) And ( exists[SUBJ] <> 0 )
                And ( parity[CLIP] = parity[SUBJ] ) );
              br := parity[CLIP] And parity[SUBJ];
              bl := ( parity[CLIP] Xor edge.bundle[ABOVE, CLIP] )
                And ( parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ] );
              tr := ( parity[CLIP] Xor ord( horiz[CLIP] <> NH ) )
                And ( parity[SUBJ] Xor ord( horiz[SUBJ] <> NH ) );
              tl := ( parity[CLIP] Xor ord( horiz[CLIP] <> NH ) Xor edge.bundle[BELOW, CLIP] )
                And ( parity[SUBJ] Xor ord( horiz[SUBJ] <> NH ) Xor edge.bundle[BELOW, SUBJ] );
            End;
          pcXOR:
            Begin
              contributing := ( exists[CLIP] <> 0 ) Or ( exists[SUBJ] <> 0 );
              br := ( parity[CLIP] ) Xor ( parity[SUBJ] );
              bl := ( parity[CLIP] Xor edge.bundle[ABOVE, CLIP] )
                Xor ( parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ] );
              tr := ( parity[CLIP] Xor ord( horiz[CLIP] <> NH ) )
                Xor ( parity[SUBJ] Xor ord( horiz[SUBJ] <> NH ) );
              tl := ( parity[CLIP] Xor ord( horiz[CLIP] <> NH ) Xor
                edge.bundle[BELOW, CLIP] )
                Xor ( parity[SUBJ] Xor ord( horiz[SUBJ] <> NH ) Xor
                edge.bundle[BELOW, SUBJ] );
            End;
          pcUNION:
            Begin
              contributing := ( ( exists[CLIP] <> 0 ) And ( ( parity[SUBJ] = 0 ) Or ( ord( horiz[SUBJ] ) <> 0 ) ) )
                Or ( ( exists[SUBJ] <> 0 ) And ( ( parity[CLIP] = 0 ) Or
                ( ord( horiz[CLIP] ) <> 0 ) ) )
                Or ( ( exists[CLIP] <> 0 ) And ( exists[SUBJ] <> 0 )
                And ( parity[CLIP] = parity[SUBJ] ) );
              br := ( parity[CLIP] )
                Or ( parity[SUBJ] );
              bl := ( parity[CLIP] Xor edge.bundle[ABOVE, CLIP] )
                Or ( parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ] );
              tr := ( parity[CLIP] Xor ord( horiz[CLIP] <> NH ) )
                Or ( parity[SUBJ] Xor ord( horiz[SUBJ] <> NH ) );
              tl := ( parity[CLIP] Xor ord( horiz[CLIP] <> NH ) Xor
                edge.bundle[BELOW, CLIP] )
                Or ( parity[SUBJ] Xor ord( horiz[SUBJ] <> NH ) Xor
                edge.bundle[BELOW, SUBJ] );
            End;
        End;

        (* Update parity *)
        parity[CLIP] := parity[CLIP] Xor edge.bundle[ABOVE, CLIP];
        parity[SUBJ] := parity[SUBJ] Xor edge.bundle[ABOVE, SUBJ];

        (* Update horizontal state *)
        If exists[CLIP] <> 0 Then
          horiz[CLIP] :=
            next_hstate[ord( horiz[CLIP] ),
            ( ( exists[CLIP] - 1 ) Shl 1 ) + parity[CLIP]];
        If exists[SUBJ] <> 0 Then
          horiz[SUBJ] :=
            next_hstate[ord( horiz[SUBJ] ),
            ( ( exists[SUBJ] - 1 ) Shl 1 ) + parity[SUBJ]];

        vclass := tr + ( tl Shl 1 ) + ( br Shl 2 ) + ( bl Shl 3 );

        If contributing Then
        Begin
          xb := edge.xb;

          Case TVertexType( vclass ) Of
            EMN:
              Begin
                new_tristrip( tlist, edge, xb, yb );
                cf := edge;
              End;
            ERI:
              Begin
                edge.outp[ABOVE] := cf.outp[ABOVE];
                If xb <> cf.xb Then
                  VERTEX( edge, ABOVE, RIGHT, xb, yb );
                cf := Nil;
              End;
            ELI:
              Begin
                VERTEX( edge, BELOW, LEFT, xb, yb );
                edge.outp[ABOVE] := Nil;
                cf := edge;
              End;
            EMX:
              Begin
                If xb <> cf.xb Then
                  VERTEX( edge, BELOW, RIGHT, xb, yb );
                edge.outp[ABOVE] := Nil;
                cf := Nil;
              End;
            IMN:
              Begin
                If cft = LED Then
                Begin
                  If cf.bot.y <> yb Then
                    VERTEX( cf, BELOW, LEFT, cf.xb, yb );
                  new_tristrip( tlist, cf, cf.xb, yb );
                End;
                edge.outp[ABOVE] := cf.outp[ABOVE];
                VERTEX( edge, ABOVE, RIGHT, xb, yb );
              End;
            ILI:
              Begin
                new_tristrip( tlist, edge, xb, yb );
                cf := edge;
                cft := ILI;
              End;
            IRI:
              Begin
                If cft = LED Then
                Begin
                  If cf.bot.y <> yb Then
                    VERTEX( cf, BELOW, LEFT, cf.xb, yb );
                  new_tristrip( tlist, cf, cf.xb, yb );
                End;
                VERTEX( edge, BELOW, RIGHT, xb, yb );
                edge.outp[ABOVE] := Nil;
              End;
            IMX:
              Begin
                VERTEX( edge, BELOW, LEFT, xb, yb );
                edge.outp[ABOVE] := Nil;
                cft := IMX;
              End;
            IMM:
              Begin
                VERTEX( edge, BELOW, LEFT, xb, yb );
                edge.outp[ABOVE] := cf.outp[ABOVE];
                If xb <> cf.xb Then
                  VERTEX( cf, ABOVE, RIGHT, xb, yb );
                cf := edge;
              End;
            EMM:
              Begin
                VERTEX( edge, BELOW, RIGHT, xb, yb );
                edge.outp[ABOVE] := Nil;
                new_tristrip( tlist, edge, xb, yb );
                cf := edge;
              End;
            LED:
              Begin
                If edge.bot.y = yb Then
                  VERTEX( edge, BELOW, LEFT, xb, yb );
                edge.outp[ABOVE] := edge.outp[BELOW];
                cf := edge;
                cft := LED;
              End;
            RED:
              Begin
                edge.outp[ABOVE] := cf.outp[ABOVE];
                If cft = LED Then
                Begin
                  If cf.bot.y = yb Then
                  Begin
                    VERTEX( edge, BELOW, RIGHT, xb, yb );
                  End
                  Else
                  Begin
                    If edge.bot.y = yb Then
                    Begin
                      VERTEX( cf, BELOW, LEFT, cf.xb, yb );
                      VERTEX( edge, BELOW, RIGHT, xb, yb );
                    End;
                  End;
                End
                Else
                Begin
                  VERTEX( edge, BELOW, RIGHT, xb, yb );
                  VERTEX( edge, ABOVE, RIGHT, xb, yb );
                End;
                cf := Nil;
              End;
          End; (* End of switch *)
        End; (* End of contributing conditional *)
      End; (* End of edge exists conditional *)

      edge := edge.next;
    End; (* End of AET loop *)

    (* Delete terminating edges from the AET, otherwise compute xt *)
    edge := aet;
    While edge <> Nil Do
    Begin
      If edge.top.y = yb Then
      Begin
        prev_edge := edge.prev;
        next_edge := edge.next;
        If prev_edge <> Nil Then
          prev_edge.next := next_edge
        Else
          aet := next_edge;
        If next_edge <> Nil Then
          next_edge.prev := prev_edge;

        (* Copy bundle head state to the adjacent tail edge if required *)
        If ( ( edge.bstate[BELOW] = bsBUNDLE_HEAD ) And ( prev_edge <> Nil ) ) And
          ( prev_edge.bstate[BELOW] = bsBUNDLE_TAIL ) Then
        Begin
          prev_edge.outp[BELOW] := edge.outp[BELOW];
          prev_edge.bstate[BELOW] := bsUNBUNDLED;
          If ( prev_edge.prev <> Nil ) And
            ( prev_edge.prev.bstate[BELOW] = BUNDLE_TAIL ) Then
            prev_edge.bstate[BELOW] := bsBUNDLE_HEAD;
        End;
      End
      Else
      Begin
        If edge.top.y = yt Then
          edge.xt := edge.top.x
        Else
          edge.xt := edge.bot.x + edge.dx * ( yt - edge.bot.y );
      End;

      edge := edge.next;
    End;

    If scanbeam < sbt_entries Then
    Begin
      (* === SCANBEAM INTERIOR PROCESSING ============================== *)

      build_intersection_table( it, aet, dy );

      (* Process each node in the intersection table *)
      intersect := it;
      While intersect <> Nil Do
      Begin
        e0 := intersect.ie[0];
        e1 := intersect.ie[1];

        (* Only generate output for contributing intersections *)
        If ( ( e0.bundle[ABOVE, CLIP] <> 0 ) Or ( e0.bundle[ABOVE, SUBJ] <> 0 ) )
          And ( ( e1.bundle[ABOVE, CLIP] <> 0 ) Or ( e1.bundle[ABOVE, SUBJ] <> 0 ) ) Then
        Begin
          p := e0.outp[ABOVE];
          q := e1.outp[ABOVE];
          ix := intersect.point.x;
          iy := intersect.point.y + yb;

          ain[CLIP] := integer( ( ( e0.bundle[ABOVE, CLIP] <> 0 ) And Not ( e0.bside[CLIP] <> 0 ) )
            Or ( ( e1.bundle[ABOVE, CLIP] <> 0 ) And ( e1.bside[CLIP] <> 0 ) )
            Or ( Not ( e0.bundle[ABOVE, CLIP] <> 0 ) And Not ( e1.bundle[ABOVE, CLIP] <> 0 )
            And ( e0.bside[CLIP] <> 0 ) And ( e1.bside[CLIP] <> 0 ) ) );
          ain[SUBJ] := integer( ( ( e0.bundle[ABOVE, SUBJ] <> 0 ) And Not ( e0.bside[SUBJ] <> 0 ) )
            Or ( ( e1.bundle[ABOVE, SUBJ] <> 0 ) And ( e1.bside[SUBJ] <> 0 ) )
            Or ( Not boolean( e0.bundle[ABOVE, SUBJ] ) And Not ( e1.bundle[ABOVE, SUBJ] <> 0 )
            And ( e0.bside[SUBJ] <> 0 ) And ( e1.bside[SUBJ] <> 0 ) ) );
          (* Determine quadrant occupancies *)
          Case op Of
            pcDIFF, pcINT:
              Begin
                tr := ( ain[CLIP] ) And ( ain[SUBJ] );
                tl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] )
                  And ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] );
                br := ( ain[CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  And ( ain[SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
                bl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  And ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
              End;
            pcXOR:
              Begin
                tr := ( ain[CLIP] ) Xor ( ain[SUBJ] );
                tl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] )
                  Xor ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] );
                br := ( ain[CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  Xor ( ain[SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
                bl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  Xor ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
              End;
            pcUNION:
              Begin
                tr := ( ain[CLIP] ) Or ( ain[SUBJ] );
                tl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] )
                  Or ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] );
                br := ( ain[CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  Or ( ain[SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
                bl := ( ain[CLIP] Xor e1.bundle[ABOVE, CLIP] Xor e0.bundle[ABOVE, CLIP] )
                  Or ( ain[SUBJ] Xor e1.bundle[ABOVE, SUBJ] Xor e0.bundle[ABOVE, SUBJ] );
              End;
          End;

          vclass := tr + ( tl Shl 1 ) + ( br Shl 2 ) + ( bl Shl 3 );

          Case TVertexType( vclass ) Of
            EMN:
              Begin
                new_tristrip( tlist, e1, ix, iy );
                e0.outp[ABOVE] := e1.outp[ABOVE];
              End;
            ERI:
              If p <> Nil Then
              Begin
                P_EDGE( prev_edge, e0, ABOVE, px, iy );
                VERTEX( prev_edge, ABOVE, LEFT, px, iy );
                VERTEX( e0, ABOVE, RIGHT, ix, iy );
                e1.outp[ABOVE] := e0.outp[ABOVE];
                e0.outp[ABOVE] := Nil;
              End;
            ELI:
              If q <> Nil Then
              Begin
                N_EDGE( next_edge, e1, ABOVE, nx, iy );
                VERTEX( e1, ABOVE, LEFT, ix, iy );
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
                e0.outp[ABOVE] := e1.outp[ABOVE];
                e1.outp[ABOVE] := Nil;
              End;
            EMX:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                VERTEX( e0, ABOVE, LEFT, ix, iy );
                e0.outp[ABOVE] := Nil;
                e1.outp[ABOVE] := Nil;
              End;
            IMN:
              Begin
                P_EDGE( prev_edge, e0, ABOVE, px, iy );
                VERTEX( prev_edge, ABOVE, LEFT, px, iy );
                N_EDGE( next_edge, e1, ABOVE, nx, iy );
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
                new_tristrip( tlist, prev_edge, px, iy );
                e1.outp[ABOVE] := prev_edge.outp[ABOVE];
                VERTEX( e1, ABOVE, RIGHT, ix, iy );
                new_tristrip( tlist, e0, ix, iy );
                next_edge.outp[ABOVE] := e0.outp[ABOVE];
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
              End;
            ILI:
              If p <> Nil Then
              Begin
                VERTEX( e0, ABOVE, LEFT, ix, iy );
                N_EDGE( next_edge, e1, ABOVE, nx, iy );
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
                e1.outp[ABOVE] := e0.outp[ABOVE];
                e0.outp[ABOVE] := Nil;
              End;
            IRI:
              If q <> Nil Then
              Begin
                VERTEX( e1, ABOVE, RIGHT, ix, iy );
                P_EDGE( prev_edge, e0, ABOVE, px, iy );
                VERTEX( prev_edge, ABOVE, LEFT, px, iy );
                e0.outp[ABOVE] := e1.outp[ABOVE];
                e1.outp[ABOVE] := Nil;
              End;
            IMX:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                VERTEX( e0, ABOVE, RIGHT, ix, iy );
                VERTEX( e1, ABOVE, LEFT, ix, iy );
                e0.outp[ABOVE] := Nil;
                e1.outp[ABOVE] := Nil;
                P_EDGE( prev_edge, e0, ABOVE, px, iy );
                VERTEX( prev_edge, ABOVE, LEFT, px, iy );
                new_tristrip( tlist, prev_edge, px, iy );
                N_EDGE( next_edge, e1, ABOVE, nx, iy );
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
                next_edge.outp[ABOVE] := prev_edge.outp[ABOVE];
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
              End;
            IMM:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                VERTEX( e0, ABOVE, RIGHT, ix, iy );
                VERTEX( e1, ABOVE, LEFT, ix, iy );
                P_EDGE( prev_edge, e0, ABOVE, px, iy );
                VERTEX( prev_edge, ABOVE, LEFT, px, iy );
                new_tristrip( tlist, prev_edge, px, iy );
                N_EDGE( next_edge, e1, ABOVE, nx, iy );
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
                e1.outp[ABOVE] := prev_edge.outp[ABOVE];
                VERTEX( e1, ABOVE, RIGHT, ix, iy );
                new_tristrip( tlist, e0, ix, iy );
                next_edge.outp[ABOVE] := e0.outp[ABOVE];
                VERTEX( next_edge, ABOVE, RIGHT, nx, iy );
              End;
            EMM:
              If ( p <> Nil ) And ( q <> Nil ) Then
              Begin
                VERTEX( e0, ABOVE, LEFT, ix, iy );
                new_tristrip( tlist, e1, ix, iy );
                e0.outp[ABOVE] := e1.outp[ABOVE];
              End;
          End; (* End of switch *)

        End; (* End of contributing intersection conditional *)

        (* Swap bundle sides in response to edge crossing *)
        If e0.bundle[ABOVE, CLIP] <> 0 Then
          e1.bside[CLIP] := ( 1 - e1.bside[CLIP] );
        If e1.bundle[ABOVE, CLIP] <> 0 Then
          e0.bside[CLIP] := ( 1 - e0.bside[CLIP] );
        If e0.bundle[ABOVE, SUBJ] <> 0 Then
          e1.bside[SUBJ] := ( 1 - e1.bside[SUBJ] );
        If e1.bundle[ABOVE, SUBJ] <> 0 Then
          e0.bside[SUBJ] := ( 1 - e0.bside[SUBJ] );

        (* Swap e0 and e1 bundles in the AET *)
        prev_edge := e0.prev;
        next_edge := e1.next;
        If e1.next <> Nil Then
          e1.next.prev := e0;
        //if next_edge <> nil then
        //  next_edge.prev:= e0;

        If e0.bstate[ABOVE] = BUNDLE_HEAD Then
        Begin
          search := TRUE;
          While ( search ) Do
          Begin
            prev_edge := prev_edge.prev;
            If prev_edge <> Nil Then
            Begin
              If ( ( prev_edge.bundle[ABOVE, CLIP] <> 0 )
                Or ( prev_edge.bundle[ABOVE, SUBJ] <> 0 )
                Or ( prev_edge.bstate[ABOVE] = BUNDLE_HEAD ) ) Then
                search := FALSE;
            End
            Else
              search := FALSE;
          End;
        End;
        If prev_edge = Nil Then
        Begin
          e1.next := aet;
          aet := e0.next;
        End
        Else
        Begin
          e1.next := prev_edge.next;
          prev_edge.next := e0.next;
        End;
        e0.next.prev := prev_edge;
        e1.next.prev := e1;
        e0.next := next_edge;

        intersect := intersect.next;
      End; (* End of IT loop*)

      (* Prepare for next scanbeam *)
      edge := aet;
      While edge <> Nil Do
      Begin
        next_edge := edge.next;
        succ_edge := edge.succ;

        If ( edge.top.y = yt ) And ( succ_edge <> Nil ) Then
        Begin
          (* Replace AET edge by its successor *)
          succ_edge.outp[BELOW] := edge.outp[ABOVE];
          succ_edge.bstate[BELOW] := edge.bstate[ABOVE];
          succ_edge.bundle[BELOW, CLIP] := edge.bundle[ABOVE, CLIP];
          succ_edge.bundle[BELOW, SUBJ] := edge.bundle[ABOVE, SUBJ];
          prev_edge := edge.prev;
          If prev_edge <> Nil Then
            prev_edge.next := succ_edge
          Else
            aet := succ_edge;
          If next_edge <> Nil Then
            next_edge.prev := succ_edge;
          succ_edge.prev := prev_edge;
          succ_edge.next := next_edge;
        End
        Else
        Begin
          (* Update this edge *)
          edge.outp[BELOW] := edge.outp[ABOVE];
          edge.bstate[BELOW] := edge.bstate[ABOVE];
          edge.bundle[BELOW, CLIP] := edge.bundle[ABOVE, CLIP];
          edge.bundle[BELOW, SUBJ] := edge.bundle[ABOVE, SUBJ];
          edge.xb := edge.xt;
        End;
        edge.outp[ABOVE] := Nil;

        edge := next_edge
      End;
    End;
  End; (* === END OF SCANBEAM PROCESSING ================================== *)

  (* Generate result tristrip from tlist *)
  result.clear;
  num_strips := count_tristrips( tlist );
  If num_strips > 0 Then
  Begin

    s := 0;
    tn := tlist;
    While tn <> Nil Do
    Begin
      tnn := tn.next;
      If tn.active > 2 Then
      Begin

        strip.NumVertices := tn.active;
        GetMem( strip.vertex, tn.active * sizeof( TEzPoint ) );
        fillchar( strip.vertex^, tn.active * sizeof( TEzPoint ), 0 );
        result.Add( strip );

        v := 0;
        If INVERT_TRISTRIPS Then
        Begin
          lt := tn.v[RIGHT];
          rt := tn.v[LEFT];
        End
        Else
        Begin
          lt := tn.v[LEFT];
          rt := tn.v[RIGHT];
        End;
        While ( lt <> Nil ) Or ( rt <> Nil ) Do
        Begin
          If lt <> Nil Then
          Begin
            ltn := lt.next;
            strip.vertex[v].x := lt.x;
            strip.vertex[v].y := lt.y;
            inc( v );
            Dispose( lt );
            lt := ltn;
          End;
          If rt <> Nil Then
          Begin
            rtn := rt.next;
            strip.vertex[v].x := rt.x;
            strip.vertex[v].y := rt.y;
            inc( v );
            Dispose( rt );
            rt := rtn;
          End;
        End;
        inc( s );
      End
      Else
      Begin
        (* Invalid tristrip: just free the heap *)
        lt := tn.v[LEFT];
        While lt <> Nil Do
        Begin
          ltn := lt.next;
          Dispose( lt );

          lt := ltn;
        End;
        rt := tn.v[RIGHT];
        While rt <> Nil Do
        Begin
          rtn := rt.next;
          Dispose( rt );

          rt := rtn
        End;
      End;
      Dispose( tn );

      tn := tnn
    End;
  End;

  (* Tidy up *)
  reset_it( it );
  reset_lmt( lmt );
  freeheap( subject, s_heap );
  freeheap( clipping, c_heap );
  FreeMem( sbt, sbt_entries * sizeof( double ) );

End;

Procedure gpc_polygon_to_tristrip( s: TEzClipPolygon; t: Tgpc_tristrip );
Var
  c: TEzClipPolygon;
Begin
  c := TEzClipPolygon.create;
  gpc_tristrip_clip( pcDIFF, s, c, t );
  c.free;
End;
{$ENDIF}

Type
  TClipProc = Procedure( op: TEzPolyClipOp; subject, clipping, result: TEzClipPolygon );

Procedure dothejob( proc: Pointer;
  op: TEzPolyClipOp;
  subject, clipping, result: TEzEntityList;
  Holes: TBits );
Var
  subj, clip, rslt: TEzClipPolygon;
  TmpEnt: TEzEntity;
  I, J: integer;

  Procedure FillGPCPolygon( L: TEzEntityList; p: TEzClipPolygon );
  Var
    cnt, I, J: integer;
    temp: TEzPointList;
    TempL: TList;
    Vect: TEzVector;

  Begin
    For cnt := 0 To L.count - 1 Do
    Begin
      TempL := EzSystem.GetListOfVectors( L[cnt] );
      For I := 0 To TempL.Count - 1 Do
      Begin
        Vect := TEzVector( TempL[I] );
        temp.NumVertices := Vect.Count;
        GetMem( temp.vertex, temp.NumVertices * SizeOf( TEzPoint ) );
        For J := 0 To Vect.Count - 1 Do
          temp.vertex^[J] := Vect[J];
        p.Add( temp );
      End;
      EzSystem.freelist( TempL );
    End;
  End;

Begin
  subj := TEzClipPolygon.create;
  clip := TEzClipPolygon.create;
  rslt := TEzClipPolygon.create;
  Try
    FillGPCPolygon( subject, subj );
    FillGPCPolygon( clipping, clip );
    TClipProc( proc )( op, subj, clip, rslt );
    For I := 0 To rslt.num_contours - 1 Do
    Begin
      TmpEnt := TEzPolygon.CreateEntity( [Point2d( 0, 0 )] );
      TmpEnt.Points.Clear;
      With rslt.contour[I] Do
        For J := 0 To NumVertices - 1 Do
        Begin
          TmpEnt.Points.Add( vertex^[J] );
        End;
      result.Add( TmpEnt );
    End;
    If Holes <> Nil Then
    Begin
      Holes.Size := rslt.hole.Count + 1;
      For I := 0 To rslt.Hole.Count - 1 Do
        Holes[I] := rslt.Hole[i] <> Nil;
    End;
  Finally
    subj.free;
    clip.free;
    rslt.free;
  End;

End;

Procedure polygonClip( op: TEzPolyClipOp; subject, clipping, result: TEzEntityList; Holes: TBits );
Begin
  dothejob( @GPCPolygonClip, op, subject, clipping, result, Holes );
End;

{$IFDEF FALSE}

Procedure tristripClip( op: TEzPolyClipOp; subject, clipping, result: TEzEntityList );
Begin
  dothejob( @gpc_tristrip_clip, op, subject, clipping, result );
End;
{$ENDIF}

End.
