unit EzNetwork;

{=============================================================================
  TEzNetworkAnalyst Class
  © 2002: EzSoft Engineering
  Email:  support@ezgis.com
 =============================================================================}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Graphics, Controls, Windows, Forms,
  EzLib, EzBase, EzBaseGis, EzEntities, Ezrtree, EzCmdLine ;

type

  { Restrictions:
      - Nodes and links must have its own same layer
      - Nodes and links can be moved only with the RESHAPE action/tool
      - You cannot use the MOVE, ROTATE, etc command with a lot of nodes,links selected at same time
  }

  { TEzNode }

  TEzNode = Class( TEzPlace )
  Private
    FLinks: TIntegerList;
    Function GetLinks: TIntegerList;
  Protected
    Function GetEntityID: TEzEntityID; Override;
  Public
    Constructor CreateEntity( Const Pt: TEzPoint );
    Destructor Destroy; Override;
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = false): Boolean; Override;
    function StorageSize: Integer; Override;
    { this must define invalid links }
    Procedure BeforeDelete( Recno: Integer; Layer: TEzBaseLayer );
    { update position of the links also }
    Procedure UpdatePosition( Recno: Integer; Layer: TEzBaseLayer );

    Property Links: TIntegerList read GetLinks;
  End;

  { TEzNodeLink }

  TEzTravelRestriction = ( trBothWays, trFromStartToEndOnly,
    trFromEndToStartOnly, trCannotTravel );

  TEzNodeLink = class( TEzPolyline )
  Private
    FFromNode: Integer;
    FToNode: Integer;
    FRestriction: TEzTravelRestriction;
  {$IFDEF BCB} (*_*)
    function GetFromNode: Integer;
    function GetRestriction: TEzTravelRestriction;
    function GetToNode: Integer;
    procedure SetFromNode(const Value: Integer);
    procedure SetRestriction(const Value: TEzTravelRestriction);
    procedure SetToNode(const Value: Integer);
  {$ENDIF}
  Protected
    Function GetEntityID: TEzEntityID; Override;
  Public
    Procedure LoadFromStream( Stream: TStream ); Override;
    Procedure SaveToStream( Stream: TStream ); Override;
    Function IsEqualTo( Entity: TEzEntity; IncludeAttribs: Boolean = false): Boolean; Override;
    { this must define invalid nodes }
    Procedure BeforeDelete( Recno: Integer; Layer: TEzBaseLayer );
    { update position of the links also }
    Procedure UpdatePosition( Recno: Integer; Layer: TEzBaseLayer );
    { link the vertex to a node. Index is the vertex}
    Procedure LinkToNode( Index: Integer; Recno: Integer; Layer: TEzBaseLayer;
      DrawBox: TEzBaseDrawBox );

    Property FromNode: Integer
      read {$IFDEF BCB} GetFromNode {$ELSE} FFromNode {$ENDIF}
      write {$IFDEF BCB} SetFromNode {$ELSE} FFromNode {$ENDIF}; (*_*)
    Property ToNode: Integer
      read {$IFDEF BCB} GetToNode {$ELSE} FToNode {$ENDIF}
      write {$IFDEF BCB} SetToNode{$ELSE} FToNode {$ENDIF}; (*_*)
    Property Restriction: TEzTravelRestriction
      read {$IFDEF BCB} GetRestriction {$ELSE} FRestriction {$ENDIF}
      write {$IFDEF BCB} SetRestriction {$ELSE} FRestriction {$ENDIF}; (*_*)
  End;

{ TRAVEL COST
     Any numeric expression including fields in the DBF file, or functions that
     return the distance/length will be used for costing the travel. The
     measure units(time, length, currency) will be parametric. There will be
     an expression for traveling from start to end and an expression for
     traveling from end to start.

  CLOSED STREETS
     To set a closed street:
     - set Restriction to trCannotTravel
     - The cost field used in an expression could have a negative number
     - Select the lines to be considered closed and in the network analyst
       dialog check the "Considere selected as closed" checkbox

}

  { insert a node link }
  TAddNodeLinkAction = Class( TEzAction )
  Private
    FEntity: TEzEntity;
    FCurrentIndex: Integer;
    FDraw: Boolean;
    FOldSnapLayer: string;
    FOldNoPickFilter: TEzEntityIDs ;
    Procedure SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
    Procedure SetAddActionCaption;
    Procedure MyMouseDown( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseUp( Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer; Const WX, WY: Double );
    Procedure MyMouseMove( Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Const WX, WY: Double );
    Procedure MyKeyPress( Sender: TObject; Var Key: Char );
    Procedure MyPaint( Sender: TObject );
    Procedure AddLink;
  Public
    Constructor CreateAction( CmdLine: TEzCmdLine; NodeSize: Integer );
    Destructor Destroy; Override;
  End;

  { TEzNetwork }

  TEzNodeCalc = Class;

  TEzPathAlgorithm = ( paLabelSetting, paLabelCorrecting );

  TEzListStatus = ( lsNotInList, lsNowInList, lsWasInList );

  // the record information needed when calculating the best route
  PNodeCalcInfo = ^TNodeCalcInfo;
  TNodeCalcInfo = Packed Record
    FromLink: Integer; // Path tree link.
    BestCost: Double; // calculated when network analyzed.
    Status: TEzListStatus; // Node status.
  End;

  TEzNetwork = Class( TComponent )
  Private
    FStartToEndExpression: String;
    FEndToStartExpression: String;
    { the name of the field that contains the name of the street }
    FStreetFieldName: string;
    { the picked points for searching paths }
    FPickedPoints: TEzVector;
    FSelectedAreClosed: Boolean;
    FUnits: string;

    { for calculation }
    FInPathList: TBits;
    FNodeCalc: TEzNodeCalc;
    { the shortest path of last calculation }
    FShortestPath: TIntegerList;
    FMAxRecno: Integer;
    FTotalCosts: TEzDoubleList;
    FDirections: TStrings;

    Procedure DoFindShortPath( DrawBox: TEzBaseDrawBox;
      NetworkLayer, RouteLayer: TEzBaseLayer; Algorithm: TEzPathAlgorithm );
    Procedure Prepare( Layer: TEzBaseLayer );
    Procedure UnPrepare;
  Public
    Constructor Create(Aowner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure FindShortPath( DrawBox: TEzBaseDrawBox; NetworkLayer, RouteLayer: TEzBaseLayer );
    Procedure FindShortPathC( DrawBox: TEzBaseDrawBox; NetworkLayer, RouteLayer: TEzBaseLayer );
    Procedure CleanUpLayer( DrawBox: TEzBaseDrawBox; ALayer: TEzBaseLayer;
      DeleteDuplicatedEntities, EraseShortEntities,
      BreakCrossingEntities, DisolvePseudoNodes: Boolean;
      Const ToleranceSeparation: Double;
      SymbolIndexForNodes, SymbolSize: Integer; OnlySelection: Boolean  );

    Property PickedPoints: TEzVector read FPickedPoints;
    Property TotalCosts: TEzDoubleList read FTotalCosts;
    Property Directions: TStrings read FDirections;
  Published
    Property StartToEndExpression: String read FStartToEndExpression write FStartToEndExpression;
    Property EndToStartExpression: String read FEndToStartExpression write FEndToStartExpression;
    Property StreetFieldName: string read FStreetFieldName write FStreetFieldName;
    Property SelectedAreClosed: Boolean read FSelectedAreClosed write FSelectedAreClosed;
    Property Units: string read FUnits write FUnits;
  End;

  // this class is used when calculating the nodes
  TNodeCalcArray = Array[0..0] Of TNodeCalcInfo;
  PNodeCalcArray = ^TNodeCalcArray;

  TEzNodeCalc = Class
  Private
    FNodeCalcArray: PNodeCalcArray;
    FSize: Integer;
    Function GetFromLink( Recno: Integer ): Integer;
    Procedure SetFromLink( Recno: Integer; Value: Integer );
    Function GetBestCost( Recno: Integer ): Double;
    Procedure SetBestCost( Recno: Integer; Const Value: Double );
    Function GetStatus( Recno: Integer ): TEzListStatus;
    Procedure SetStatus( Recno: Integer; Value: TEzListStatus );
    Function GetSize: Integer;
    Procedure SetSize( Value: Integer );
  Public
    Destructor Destroy; Override;

    Property Size: Integer Read GetSize Write SetSize;
    Property FromLink[Recno: Integer]: Integer Read GetFromLink Write SetFromLink;
    Property BestCost[Recno: Integer]: Double Read GetBestCost Write SetBestCost;
    Property Status[Recno: Integer]: TEzListStatus Read GetStatus Write SetStatus;
  End;

implementation

uses
  EzSystem, EzExpressions, EzActions, EzConsts, EzActionLaunch, Math, EzBaseExpr;

Const
  INFINITY = 1.0E100;

{ TEzNode }

constructor TEzNode.CreateEntity( Const Pt: TEzPoint );
begin
  Inherited CreateEntity( Pt );
  FLinks:= TIntegerList.Create;
end;

Destructor TEzNode.Destroy;
Begin
  if FLinks <> Nil then FLinks.Free;
  inherited Destroy;
End;

Function TEzNode.GetLinks: TIntegerList;
Begin
  if FLinks = Nil then FLinks := TIntegerList.Create;
  Result:= FLinks;
End;

function TEzNode.GetEntityID: TEzEntityID;
begin
  Result:= idNode;
end;

function TEzNode.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean= false): Boolean;
var
  I: Integer;
begin
  Result:= False;
  if ( Entity.EntityID <> idNode ) Or Not FPoints.IsEqualTo( Entity.Points )
     {$IFDEF FALSE}Or
      ( IncludeAttribs And
        ( Not CompareMem( @SymbolTool.FSymbolStyle,
                          @TEzNode(Entity).SymbolTool.FSymbolStyle,
                          SizeOf( TEzSymbolStyle ) ) Or
          ( Text <> TEzNode(Entity).Text ) ) ){$ENDIF} Then Exit;
  if TEzNode( Entity ).Links.Count <> Links.Count then Exit;
  for I:= 0 to Links.Count-1 do
    if TEzNode( Entity ).Links[I] <> Links[I] then Exit;
  Result:= True;
end;

procedure TEzNode.LoadFromStream(Stream: TStream);
begin
  Inherited LoadFromStream( Stream );
  FLinks.LoadFromStream(Stream);
end;

procedure TEzNode.SaveToStream(Stream: TStream);
begin
  Inherited SaveToStream( Stream );
  FLinks.SaveToStream(Stream);
end;

function TEzNode.StorageSize: Integer;
var
  I: Integer;
begin
  Result := Inherited StorageSize;
  for I := 0 to Links.Count-1 do
    Result := Result + SizeOf( Integer );
end;

{ Recno is the record number of this node,
  Layer is where the layer was saved this node.
  Use Layer to find the link and to mark as invalid nodes
}
procedure TEzNode.BeforeDelete( Recno: Integer; Layer: TEzBaseLayer );
var
  I: Integer;
  Link: TEzEntity;
  MustUpdate: Boolean;
begin
  for I:= 0 to Links.Count-1 do
  begin
    Link:= Layer.LoadEntityWithRecno( Links[I] );
    if (Link = Nil) Or Not (Link is TEzNodeLink) then Continue;
    MustUpdate:= false;
    with TEzNodeLink( Link ) do
    begin
      If FFromNode = Recno then
      begin
        FFromNode:= 0;
        MustUpdate:= true;
      end;
      If FToNode = Recno then
      begin
        FToNode:= 0;
        MustUpdate:= true;
      end;
    End;
    If MustUpdate then
      Layer.UpdateEntity( Links[I], Link );
  end;
end;

procedure TEzNode.UpdatePosition( Recno: Integer; Layer: TEzBaseLayer );
var
  I: Integer;
  Link: TEzEntity;
  MustUpdate: Boolean;
begin
  for I:= 0 to Links.Count-1 do
  begin
    Link:= Layer.LoadEntityWithRecno( Links[I] );
    if (Link = Nil) Or Not (Link is TEzNodeLink) then Continue;
    MustUpdate:= false;
    With TEzNodeLink( Link ) Do
    Begin
      If FFromNode = Recno then
      begin
        Points[0] := Self.FPoints[0];
        MustUpdate:= true;
      end;
      If FToNode = Recno then
      begin
        Points[Points.Count-1] := Self.FPoints[0];
        MustUpdate:= true;
      end;
    End;
    If MustUpdate then
      Layer.UpdateEntity( Links[I], Link );
  end;
end;

{ TEzNodeLink }

function TEzNodeLink.GetEntityID: TEzEntityID;
begin
  Result:= idNodeLink;
end;

{ Recno is where this link was saved on Layer }
procedure TEzNodeLink.LinkToNode(Index, Recno: Integer; Layer: TEzBaseLayer;
  DrawBox: TEzBaseDrawBox );

  Procedure BuildLink( Var NodeNo: Integer );
  var
    OldNoPickFilter: TEzEntityIDs;
    ALayer: TEzBaseLayer;
    ARecno: Integer;
    PickedPoint: Integer;
    Node: TEzEntity;
    Picked: Boolean;
    I: TEzEntityID;
    pf: TEzEntityIDs;
  Begin
    { try to link to a node }
    with Drawbox do
    begin
      OldNoPickFilter:= NoPickFilter;
      pf:= [];
      for I:= Low(TEzEntityID) to High(TEzEntityID) do
        If I <> idNode Then Include(pf, I );
      NoPickFilter := pf;
      Picked := PickEntity( FPoints[Index].X, FPoints[Index].Y,
        Ez_Preferences.ApertureWidth, Layer.Name, ALayer, ARecNo,
        PickedPoint, Nil );
      NoPickFilter:= OldNoPickFilter;
      If Picked then
      begin
        { link this to the node }
        NodeNo := ARecno ;
        { link the node to this }
        Node:= Layer.LoadEntityWithRecno( ARecno );
        If Node = Nil then Exit;
        If TEzNode( Node ).Links.IndexofValue(Recno) < 0 then
        begin
          TEzNode( Node ).Links.Add(Recno);
          Layer.UpdateEntity( ARecno, Node );
          FPoints[Index] := Node.Points[0];
        end;
      end;
    end;
  End;

begin
  If Not( ( Index = 0 ) Or ( Index = FPoints.Count - 1 ) ) then Exit;
  If (Index = 0) And ( FFromNode = 0 ) then
  begin
    BuildLink( FFromNode )
  end else If (Index = FPoints.Count-1) And (FToNode = 0) then
  begin
    BuildLink( FToNode );
  end;
end;

{ Recno is where this link was saved on Layer }
procedure TEzNodeLink.BeforeDelete( Recno: Integer; Layer: TEzBaseLayer );

  procedure UnlinkNode( NodeRecno: Integer );
  var
    Index: Integer;
    Node: TEzEntity;
  begin
    If NodeRecno <= 0 then Exit;
    Node := Layer.LoadEntityWithRecno( NodeRecno );
    if (Node = Nil) Or Not (Node Is TEzNode) then Exit;
    Index := TEzNode( Node ).FLinks.IndexOfValue( Recno );
    if Index >= 0 then
    begin
      TEzNode( Node ).FLinks.Delete( Index );
      Layer.UpdateEntity( NodeRecno, Node );
    end;
  end;

begin
  UnlinkNode( FFromNode );
  UnlinkNode( FToNode );
end;

procedure TEzNodeLink.UpdatePosition(Recno: Integer; Layer: TEzBaseLayer);

  procedure UpdateNode( NodeRecno, PointNo: Integer );
  var
    Index: Integer;
    Node: TEzEntity;
  begin
    If NodeRecno <= 0 then Exit;
    Node := Layer.LoadEntityWithRecno( NodeRecno );
    if (Node = Nil) Or Not (Node Is TEzNode) then Exit;
    Index := TEzNode( Node ).FLinks.IndexOfValue( Recno );
    if Index >= 0 then
    begin
      TEzNode( Node ).Points[0] := Self.Points[PointNo];
      Layer.UpdateEntity( NodeRecno, Node );
      TEzNode( Node ).UpdatePosition( NodeRecno, Layer );
    end;
  end;

begin
  UpdateNode( FFromNode, 0 );
  UpdateNode( FToNode, Points.Count - 1 );
end;

procedure TEzNodeLink.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  With Stream do
  begin
    Read(FFromNode,SizeOf(FFromNode));
    Read(FToNode,SizeOf(FToNode));
    Read(FRestriction,sizeof(FRestriction));
  end;
end;

procedure TEzNodeLink.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  With Stream do
  begin
    Write(FFromNode,SizeOf(FFromNode));
    Write(FToNode,SizeOf(FToNode));
    Write(FRestriction,sizeof(FRestriction));
  end;
end;

function TEzNodeLink.IsEqualTo(Entity: TEzEntity; IncludeAttribs: Boolean= false): Boolean;
begin
  Result:= False;
  if ( Entity.EntityID <> idNodeLink ) Or Not FPoints.IsEqualTo( Entity.Points ) Then Exit;
  If ( FFromNode <> TEzNodeLink( Entity ).FFromNode ) Or
     ( FToNode <> TEzNodeLink( Entity ).FToNode ) Then Exit;
  Result:= True;
end;

{$IFDEF BCB}
function TEzNodeLink.GetFromNode: Integer;
begin
  Result := FFromNode;
end;

function TEzNodeLink.GetRestriction: TEzTravelRestriction;
begin
  Result := FRestriction;
end;

function TEzNodeLink.GetToNode: Integer;
begin
  Result := FToNode;
end;

procedure TEzNodeLink.SetFromNode(const Value: Integer);
begin
  FFromNode := Value;
end;

procedure TEzNodeLink.SetRestriction(const Value: TEzTravelRestriction);
begin
  FRestriction := Value;
end;

procedure TEzNodeLink.SetToNode(const Value: Integer);
begin
  FToNode := Value;
end;
{$ENDIF}

{ TEzNodeCalc }

Destructor TEzNodeCalc.Destroy;
Begin
  FreeMem( FNodeCalcArray, FSize * SizeOf( TNodeCalcArray ) );
  Inherited Destroy;
End;

Function TEzNodeCalc.GetFromLink( Recno: Integer ): Integer;
Begin
  Result:= -1;
  If ( Recno < 1 ) Or ( Recno > FSize ) Then exit;
  Result := FNodeCalcArray^[Recno].FromLink;
End;

Procedure TEzNodeCalc.SetFromLink( Recno: Integer; Value: Integer );
Begin
  If ( Recno < 1 ) Or ( Recno > FSize ) Then exit;
  FNodeCalcArray^[Recno].FromLink := Value;
End;

Function TEzNodeCalc.GetBestCost( Recno: Integer ): Double;
Begin
  Result := 0;
  If ( Recno < 1 ) Or ( Recno > FSize ) Then exit;
  Result := FNodeCalcArray^[Recno].BestCost;
End;

Procedure TEzNodeCalc.SetBestCost( Recno: Integer; Const Value: Double );
Begin
  If ( Recno < 1 ) Or ( Recno > FSize ) Then exit;
  FNodeCalcArray^[Recno].BestCost := Value;
End;

Function TEzNodeCalc.GetStatus( Recno: Integer ): TEzListStatus;
Begin
  Result := Low(TEzListStatus);
  If ( Recno < 1 ) Or ( Recno > FSize ) Then exit;
  Result := FNodeCalcArray^[Recno].Status;
End;

Procedure TEzNodeCalc.SetStatus( Recno: Integer; Value: TEzListStatus );
Begin
  If ( Recno < 1 ) Or ( Recno > FSize ) Then exit;
  FNodeCalcArray^[Recno].Status := Value;
End;

Function TEzNodeCalc.GetSize: Integer;
Begin
  Result := FSize;
End;

Procedure TEzNodeCalc.SetSize( Value: Integer );
Begin
  If Value < 0 Then
    exit;
  //ReallocMem have problems when >=10MB, sorry
  If FNodeCalcArray <> Nil Then
    FreeMem( FNodeCalcArray, FSize * SizeOf( TNodeCalcArray ) );
  FSize := Value;
  GetMem( FNodeCalcArray, FSize * SizeOf( TNodeCalcArray ) );
End;


{-------------------------------------------------------------------------------}
//                  TAddNodeLinkAction - class implementation
{-------------------------------------------------------------------------------}

Constructor TAddNodeLinkAction.CreateAction( CmdLine: TEzCmdLine;
  NodeSize: Integer );
var
  I: TEzEntityID;
  pf: TEzEntityIDs;
Begin
  Inherited CreateAction( CmdLine );

  FEntity:= TEzNodeLink.CreateEntity( [ Point2d( 0, 0 ), Point2d( 0, 0 ) ] );
  FEntity.Points.Clear;

  CanDoOsnap := True;
  OnMouseDown := MyMouseDown;
  OnMouseUp := MyMouseUp;
  OnMouseMove := MyMouseMove;
  OnKeyPress := MyKeyPress;
  OnPaint := MyPaint;

  // set line width to the default
  TEzOpenedEntity( FEntity ).Pentool.Width := Ez_Preferences.DefPenStyle.Width;

  { this is used for snapping to this entity also because this entity is not yet
    saved to the database }
  EzSystem.GlobalTempEntity:= FEntity;

  with CmdLine.ActiveDrawBox do
  begin
    FOldSnapLayer:= CmdLine.AccuSnap.SnapLayerName ;
    CmdLine.AccuSnap.SnapLayerName := GIS.CurrentLayerName ;
    FOldNoPickFilter:= NoPickFilter;
    pf:=[];
    for I:= Low(TEzEntityID) to High(TEzEntityID) do
      If I <> idNode Then Include(pf,I);
    NoPickFilter:= pf ;
  end;

  Cursor := crCross;

  WaitingMouseClick := True;
  SetAddActionCaption;
  CmdLine.ActiveDrawBox.Refresh;
End;

Destructor TAddNodeLinkAction.Destroy;
Begin
  { If not nil then the entity was not added to the file/symbol and we must delete it }
  If FEntity <> Nil then FEntity.Free;
  EzSystem.GlobalTempEntity:= Nil;
  with CmdLine do
  begin
    AccuSnap.SnapLayerName:= FOldSnapLayer ;
    ActiveDrawBox.NoPickFilter:= FOldNoPickFilter;
  end;
  Inherited Destroy;
End;

Procedure TAddNodeLinkAction.SetCurrentPoint( Pt: TEzPoint; Orto: Boolean );
Var
  I: Integer;
Begin
  If Orto And ( FCurrentIndex > 0 ) Then
    Pt := ChangeToOrtogonal( FEntity.Points[FCurrentIndex - 1], Pt );
  FEntity.Points[FCurrentIndex] := Pt;
  For I := FCurrentIndex + 1 To FEntity.Points.Count - 1 Do
    FEntity.Points[I] := Pt;
  If FCurrentIndex = 0 Then
    WaitingMouseClick := False;
End;

Procedure TAddNodeLinkAction.MyMouseDown( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint: TEzPoint;
  Key: Char;
  PickedPoint: Integer;
  Picked: Boolean;
  ALayer: TEzBaseLayer;
  ARecno: Integer;
Begin
  If Button = mbRight Then
  begin
    Key:= #13 ;
    MyKeyPress( Nil, Key );
    Exit;
  end;
  FDraw := false;
  With CmdLine.ActiveDrawBox Do
  Begin
    If CmdLine.IsSnapped Then
      CurrPoint := CmdLine.GetSnappedPoint
    Else
      CurrPoint := CmdLine.CurrentPoint;

    If FCurrentIndex = 0 Then
    Begin
      { a TEzNode was clicked on first point ?}
      Picked := PickEntity( CurrPoint.X,
                            CurrPoint.Y,
                            Ez_Preferences.ApertureWidth,
                            GIS.CurrentLayerName,
                            ALayer,
                            ARecNo,
                            PickedPoint,
                            Nil );
      If Not Picked then
      Begin
        CmdLine.StatusMessage:= SNoNodeClicked;
        Invalidate;
        FDraw := True;
        Exit;
      End;
      { mark as the start node }
      TEzNodeLink( FEntity ).FromNode := ARecno ;
      
    End Else
    Begin
      { a TEzNode was clicked on first point ?}
      Picked := PickEntity( CurrPoint.X,
                            CurrPoint.Y,
                            Ez_Preferences.ApertureWidth,
                            GIS.CurrentLayerName,
                            ALayer,
                            ARecNo,
                            PickedPoint,
                            Nil );
      If Picked then
      Begin
        { mark as the end node}
        TEzNodeLink( FEntity ).ToNode := ARecno ;
        DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
        SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
        { take it as finished }
        DrawEntity2DRubberBand( FEntity, false, False );

        { add the link }
        AddLink;

        Self.Finished := true;
        Exit;
      End;
    End;

    DrawCross( Canvas, Grapher.RealToPoint( CurrPoint ) );
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );

    Inc( FCurrentIndex );

    { if end user holds down the ALT key, display an informative dialog form }
    {If ( GetAsyncKeyState( VK_menu ) Shr 1 ) <> 0 Then
    Begin
      For I := 0 To FEntity.Points.Count - 1 Do
        s := s + Format( '(%f, %f),' + CrLf, [FEntity.Points[I].X, FEntity.Points[I].Y] );
      Clipboard.SetTextBuf( PChar( s ) );
    End; }
    SetAddActionCaption;

    CmdLine.StatusMessage := '';
  end;
End;

Procedure TAddNodeLinkAction.AddLink;
var
  FromNode, ToNode, Link: TEzEntity;
  I, FromRecno, ToRecno, Recno: Integer;
  Found: Boolean;
Begin
  { link to nodes }
  FromRecno:= TEzNodeLink( FEntity ).FromNode;
  ToRecno:= TEzNodeLink( FEntity ).ToNode;
  If (FromRecno = 0 ) Or (ToRecno  = 0 ) Then  Exit;
  iF FromRecno = ToRecno then
  begin
    MessageToUser( SNetSameNodes, smsgerror, MB_ICONERROR );
    Exit;
  end;
  with CmdLine.ActiveDrawBox do
  begin
    FromNode:= GIS.CurrentLayer.LoadEntityWithRecno( FromRecno );
    If (FromNode = Nil) Or Not (FromNode is TEzNode) Then Exit;
    ToNode:= GIS.CurrentLayer.LoadEntityWithRecno( ToRecno );
    If ( ToNode = Nil ) Or Not (ToNode is TEzNode) Then Exit;

    Found:=false;
    { check if these nodes are already linked in other link }
    with TEzNode( FromNode ) do
      For I:= 0 to Links.Count - 1 do
      begin
        Link:= GIS.CurrentLayer.LoadEntityWithRecno( Links[I] );
        If Link = Nil then Continue;
        If ( TEzNodeLink( Link ).FFromNode = FromRecno ) And
           ( TEzNodeLink( Link ).FToNode   = ToRecno   ) Then
        Begin
          Found:=true;
        End Else If ( TEzNodeLink( Link ).FFromNode = ToRecno ) And
                    ( TEzNodeLink( Link ).FToNode = FromRecno ) Then
        Begin
          { only an update }
          TEzNodeLink( Link ).FFromNode:= FromRecno;
          TEzNodeLink( Link ).FToNode:= ToRecno;
          Link.Points.RevertDirection;
          GIS.CurrentLayer.UpdateEntity( Links[I], Link );
          Found:=true;
        End;
      end;
    If Not Found then
      with TEzNode( ToNode ) do
        For I:= 0 to Links.Count - 1 do
        begin
          Link:= GIS.CurrentLayer.LoadEntityWithRecno( Links[I] );
          If Link = Nil then Continue;
          If ( TEzNodeLink( Link ).FFromNode = FromRecno ) And
             ( TEzNodeLink( Link ).FToNode = ToRecno )     Then
          Begin
            Found:= true;
          End Else If ( TEzNodeLink( Link ).FFromNode = ToRecno ) And
                      ( TEzNodeLink( Link ).FToNode = FromRecno ) Then
          Begin
            { only an update }
            TEzNodeLink( Link ).FFromNode:= FromRecno;
            TEzNodeLink( Link ).FToNode:= ToRecno;
            Link.Points.RevertDirection;
            GIS.CurrentLayer.UpdateEntity( Links[I], Link );
            Found:=true;
          End;
        end;
    If Found then Exit;

    Recno:= ActionAddNewEntity( CmdLine, FEntity ) ;

    TEzNode( FromNode ).FLinks.Add( Recno );
    GIS.CurrentLayer.UpdateEntity( FromRecno, FromNode );

    TEzNode( ToNode ).FLinks.Add( Recno );
    GIS.CurrentLayer.UpdateEntity( ToRecno, ToNode );
  end;

End;

Procedure TAddNodeLinkAction.SetAddActionCaption;
Begin
  Case fCurrentIndex Of
    0: Caption := SFirstPoint;
    1: Caption := SSecondPoint;
    2: Caption := SThirdPoint;
    3: Caption := SFourthPoint;
    4: Caption := SFifthPoint;
  Else
    Caption := SNextPoint;
  End;
End;

Procedure TAddNodeLinkAction.MyMouseUp( Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Const WX, WY: Double );
Begin
  If FDraw Then Exit;
  FDraw := true;
End;

Procedure TAddNodeLinkAction.MyMouseMove( Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Const WX, WY: Double );
Var
  CurrPoint{, P1, P2}: TEzPoint;
  //DX, DY, Area, Perimeter, Angle: Double;
Begin
  If Not FDraw Then Exit;
  With CmdLine.ActiveDrawBox Do
  Begin

    if Not( (FEntity.Points.Count = 1 ) and
       EqualPoint2d(FEntity.Points[0], Point2d(0,0)) ) then
      DrawEntity2DRubberBand( FEntity, false, False );
    If CmdLine.IsSnapped Then
      CurrPoint := CmdLine.GetSnappedPoint
    Else
      CurrPoint := CmdLine.CurrentPoint;
    SetCurrentPoint( CurrPoint, CmdLine.UseOrto );
    DrawEntity2DRubberBand( FEntity, false, False );

    // Show some info
    If FCurrentIndex > 0 Then
    Begin
      {With CmdLine.ActiveDrawBox Do
      Begin
        P1 := FEntity.Points[FCurrentIndex - 1];
        P2 := FEntity.Points[FCurrentIndex];
        DX := Abs( P2.X - P1.X );
        DY := Abs( P2.Y - P1.Y );
        If ( DX = 0 ) And ( DY = 0 ) Then
        Begin
          Angle := 0;
          Area := 0;
          Perimeter := 0;
        End
        Else
        Begin
          Angle := RadToDeg( Angle2D( P1, P2 ) );
          With CmdLine.ActiveDrawBox Do
          Begin
            Area := FEntity.Area;
            Perimeter := FEntity.Perimeter;
          End;
        End;
        CmdLine.StatusMessage := Format( SNewEntityInfo,
          [NumDecimals, Angle, NumDecimals, DX, NumDecimals, DY, NumDecimals,
          Area, NumDecimals, Perimeter] );
      End }
    End ;
    //Else
    //  CmdLine.StatusMessage := '';
  End;
End;

Procedure TAddNodeLinkAction.MyPaint( Sender: TObject );
Begin
  If FDraw And ( FEntity <> Nil ) Then
    CmdLine.ActiveDrawBox.DrawEntity2DRubberBand( FEntity, false, False );
End;

Procedure TAddNodeLinkAction.MyKeyPress( Sender: TObject; Var Key: Char );
Begin
  With CmdLine.ActiveDrawBox Do
    Case Key Of
      #13:
        If FEntity.Points.CanGrow Then
        Begin
          If ( fCurrentIndex < 2 ) Or (TEzNodeLink( FEntity ).FromNode = 0) Or
             (TEzNodeLink( FEntity ).ToNode = 0) Then
          Begin
            MessageToUser( SNotEnoughData, smsgerror, MB_ICONERROR );
            Exit;
          End;
          (* Erase entity from screen and last point *)
          DrawEntity2DRubberBand( FEntity, false, False );
          FEntity.Points.Delete( FCurrentIndex );

          { add the link }
          AddLink;

          Self.Finished := true;
          Key := #0;
          Exit;
        End;
      #27:
        Begin
          DrawEntity2DRubberBand( FEntity, false, False );
          If FCurrentIndex = 0 Then
          Begin
            FreeAndNil( FEntity );
            Self.Finished := true;
            Exit;
          End;
          Dec( FCurrentIndex );
          SetCurrentPoint( CmdLine.CurrentPoint, CmdLine.UseOrto );
          DrawEntity2DRubberBand( FEntity, False, False );
        End;
    End;
End;

{ TEzNetwork }

constructor TEzNetwork.Create(Aowner: TComponent);
begin
  inherited Create(AOwner);
  FInPathList:= TBits.create;
  FPickedPoints:= TEzVector.Create(4);
  FNodeCalc:= TEzNodeCalc.Create;
  FShortestPath:= TIntegerList.create;
  FTotalCosts := TEzDoubleList.Create;
  FDirections := TStringList.Create;
  FUnits:= SNetUnits;
end;

destructor TEzNetwork.Destroy;
begin
  FInPathList.Free;
  FPickedPoints.Free;
  FNodeCalc.Free;
  FShortestPath.Free;
  FTotalCosts.Free;
  FDirections.Free;
  inherited Destroy;
end;

Procedure TEzNetwork.FindShortPath( DrawBox: TEzBaseDrawBox;
  NetworkLayer, RouteLayer: TEzBaseLayer );
begin
  DoFindShortPath( DrawBox, NetworkLayer, RouteLayer, paLabelSetting );
end;

Procedure TEzNetwork.FindShortPathC( DrawBox: TEzBaseDrawBox;
  NetworkLayer, RouteLayer: TEzBaseLayer );
begin
  DoFindShortPath( DrawBox, NetworkLayer, RouteLayer, paLabelCorrecting );
end;

// main calculation procedure.
//add the route entities found to RouteLayer

Procedure TEzNetwork.DoFindShortPath( DrawBox: TEzBaseDrawBox;
  NetworkLayer, RouteLayer: TEzBaseLayer; Algorithm: TEzPathAlgorithm );
Var
  // Find the shortest path tree.
  StartNodeRecno, EndNodeRecno: Integer;
  StartToEndSolver: TEzMainExpr;
  EndToStartSolver: TEzMainExpr;
  SelectionLayer: TEzSelectionLayer;
  I, J, Index: Integer;
  StreetField, node_num: Integer;
  Saved: TCursor;
  StartNode, EndNode: TEzNode;
  P1, P2: TEzPoint;
  node, Node1, Node2: TEzNode;
  link: TEzNodeLink;
  S, stname: string;
  Angle, TestAngle: Double;
  Reversed: boolean;
  TotalCost: Double;
  link_cost: double;
  link_recno: integer;

  Function CalcLinkCost( numlink: integer; IsReversed: Boolean ): Double;
  begin
    Result:= 0;
    if IsReversed then
    begin
      If Assigned( EndToStartSolver ) then
      begin
        NetworkLayer.Recno:= numlink;
        NetworkLayer.Synchronize;
        Result := EndToStartSolver.Expression.AsFloat;
      end;
    end else
    begin
      If Assigned( StartToEndSolver ) then
      begin
        NetworkLayer.Recno:= numlink;
        NetworkLayer.Synchronize;
        Result := StartToEndSolver.Expression.AsFloat;
      end;
    end;
  end;

  Procedure FindPathTree;
  Var
    I, link_num, best_node, to_node: Integer;
    link_cost, best_cost: Double;
    new_cost: Double;
    node: TEzNode;
    link: TEzNodeLink;
    candidates: TIntegerList;
    pass: boolean;
    Reversed: Boolean;
    node_num: integer;
  Begin

    node:= Nil;
    link:= Nil;
    candidates := TIntegerList.Create;
    Try
      // Clear previous path tree data.
      For I := 1 To FMaxRecno Do
      Begin
        FNodeCalc.FromLink[I] := 0;
        FNodeCalc.BestCost[I] := INFINITY;
        FNodeCalc.Status[I]   := lsNotInList;
      End;

      // Create the candidate list and add the root to it.
      candidates.Add( StartNodeRecno );
      FNodeCalc.BestCost[StartNodeRecno] := 0.0;
      FNodeCalc.Status[StartNodeRecno] := lsNowInList;

      // While the candidate list is not empty, process it.
      While candidates.Count > 0 Do
      Begin
        If Algorithm = paLabelSetting Then
        Begin
          // Find the node with the smallest cost.
          node_num := candidates[0];
          best_cost := FNodeCalc.BestCost[node_num];
          best_node := 0;
          For I := 1 To candidates.Count - 1 Do
          Begin
            node_num := candidates[I];
            If FNodeCalc.BestCost[node_num] < best_cost Then
            Begin
              best_cost := FNodeCalc.BestCost[node_num];
              best_node := I;
            End;
          End;
        End
        Else
          best_node := 0;

        // Remove this node from the candidate list.
        node_num := candidates[best_node];
        candidates.Delete( best_node );

        If Assigned(Node) then
          FreeAndNil( Node );

        Node:= NetworkLayer.LoadEntityWithRecno( node_num ) As TEzNode;
        FNodeCalc.Status[node_num] := lsWasInList;

        // Add the node's neighbors to the candidate list.
        For I := 0 To node.links.Count - 1 Do
        Begin
          // Get the neighbor node.
          link_num := node.links[I];
          if link_num = 0 then Continue;
          If Assigned( Link ) then
            FreeAndNil( Link );
          Link:= NetworkLayer.LoadEntityWithRecno( link_num ) As TEzNodeLink;
          If Link = Nil Then
            Continue;

          { All selected entities in this layer are considered
            closed ? }
          If FSelectedAreClosed And ( SelectionLayer <> Nil ) And
            SelectionLayer.IsSelected(link_num) Then
            Continue;

          Reversed := false;

          to_node := -1;
          Case link.Restriction Of
            trCannotTravel:
              Continue;
            trFromStartToEndOnly:
              If link.FromNode = node_num Then
                to_node := link.ToNode
              Else
                Continue; // not allowed from end to start
            trFromEndToStartOnly:
              If link.ToNode = node_num Then
              Begin
                to_node := link.FromNode;
                Reversed := true;
              End
              Else
                Continue; // not allowed to travel from start to end
            trBothWays:
              If link.FromNode = node_num Then
                to_node := link.ToNode // from start to end
              Else
              Begin
                to_node := link.FromNode; // from end to start
                Reversed := true;
              End;
          End;

          { calculate link cost }
          link_cost := CalcLinkCost( link_num, Reversed );

          If link_cost < 0 Then
            Continue; // negative costs mean cannot travel

          pass := true;
          If Algorithm = paLabelSetting Then // See if the node had been on the candidate list before.
            pass := FNodeCalc.Status[to_node] <> lsWasInList;
          If pass Then
          Begin
            // See if we can improve its best_cost
            new_cost := FNodeCalc.BestCost[node_num] + link_cost;
            If new_cost < FNodeCalc.BestCost[to_node] Then
            Begin
              // This is an improvement. Update the
              // neighbor and add it to the list.
              FNodeCalc.BestCost[to_node] := new_cost;
              FNodeCalc.FromLink[to_node] := link_num;
              If FNodeCalc.Status[to_node] = lsNotInList Then
              Begin
                FNodeCalc.Status[to_node] := lsNowInList;
                candidates.Add( to_node );
              End;
            End;
          End;
        End; // End examining the node's neighbors.
      End; // Repeat until candidate list is empty.

    Finally
      candidates.Free;
      If Assigned( node ) then
        node.free;
      If Assigned( link ) then
        link.free;
    End;
  End;

  // Find the shortest path from StartNode to EndNode.
  Procedure FindPath;
  Var
    I: Integer;
    node, link_recno: Integer;
    link: TEzNodeLink;
    link_cost: Double;
    Reversed: Boolean;
    TempEnt: TEzOpenedEntity;
    Polyline: TEzOpenedEntity;
  Begin
    link := Nil;
    Try
      // Clear the previous data.
      For I:= 1 to FMaxRecno do
      begin
        FInPathList[I]:= False;
      end;

      // Do no mode if StartNode = nil or EndNode = nil.
      If ( ( StartNode = Nil ) Or ( EndNode = Nil ) ) Then Exit;

      // Trace the path from EndNode back to StartNode
      // marking the links' InPath fields.
      TotalCost := 0.0;
      node := EndNodeRecno;
      While node <> StartNodeRecno Do
      Begin

        If Assigned( link ) then
          FreeAndNil( link );

        link_recno := FNodeCalc.FromLink[node];
        link := NetworkLayer.LoadEntityWithRecno( link_recno ) As TEzNodeLink;

        FShortestPath.Add( link_recno );

        If link.FromNode = node Then
        Begin
          node := link.ToNode;
          Reversed := true;
        End
        Else
        Begin
          node := link.FromNode;
          Reversed := false;
        End;

        FInPathList[link_recno] := true;

        // add this link record to the RouteLayer
        If RouteLayer <> Nil Then
        Begin
          TempEnt := NetworkLayer.LoadEntityWithRecno( link_recno ) As TEzOpenedEntity;
          Polyline:= TEzPolyline.Create( TempEnt.Points.Count );
          Try
            Polyline.Points.Assign( TempEnt.Points );
            With Polyline.PenTool Do
            Begin
              Style := 1;
              Color := clBlue;
              Width := DrawBox.Grapher.PointsToDistY( 2 );
            End;
            RouteLayer.AddEntity( Polyline );
          Finally
            TempEnt.Free;
            Polyline.Free;
          End;
        End;

        { calculate cost of the link }
        link_cost := CalcLinkCost( link_recno, Reversed );

        TotalCost := TotalCost + link_cost;
      End;
    Finally
      If Assigned( link ) then
        link.free;
    End;
  End;

Begin
  Assert( ( DrawBox <> Nil ) And ( DrawBox.GIS <> Nil ) );

  If (NetworkLayer = Nil) Or (FPickedPoints.Count = 0) Then Exit;

  SelectionLayer := Nil;
  Index := DrawBox.Selection.IndexOf( NetworkLayer );
  If Index >= 0 Then
    SelectionLayer := DrawBox.Selection[Index];

  { create the resolvers }
  If ( Length( FStartToEndExpression ) > 0 ) And ( Length( FEndToStartExpression ) > 0 ) Then
  Begin
    StartToEndSolver := TEzMainExpr.Create( DrawBox.GIS, NetworkLayer );
    EndToStartSolver := TEzMainExpr.Create( DrawBox.GIS, NetworkLayer );
    Try
      StartToEndSolver.ParseExpression( FStartToEndExpression );
      If Not ( StartToEndSolver.Expression.ExprType In [ttInteger, ttFloat] ) Then
        Exception.Create( SNetExpressionNotNumeric );
    Except
      FreeAndNil( StartToEndSolver );
      Raise;
    End;

    Try
      EndToStartSolver.ParseExpression( FEndToStartExpression );
      If Not ( EndToStartSolver.Expression.ExprType In [ttInteger, ttFloat] ) Then
        Exception.Create( SNetExpressionNotNumeric );
    Except
      FreeAndNil( EndToStartSolver );
      Raise;
    End;
  End;

  FTotalCosts.Clear;
  FDirections.Clear;
  FShortestPath.Clear;
  StreetField := NetworkLayer.DbTable.FieldNo( FStreetFieldName );

  Prepare( NetworkLayer );

  Saved := Screen.Cursor;
  Screen.Cursor := crHourglass;

  Angle:= 0;  // to make happy the compiler

  Try

    // First, delete all entities in result layer
    RouteLayer.Zap;

    For I := 0 To FPickedPoints.Count - 2 Do
    Begin
      StartNode := Nil;
      EndNode := Nil;

      P1 := FPickedPoints[I];

      S:= NetworkLayer.Name;
      If Not DrawBox.FindClosestEntity( P1.X, P1.Y, '', [idNode], S, StartNodeRecno ) then
        Continue;

      Node1 := NetworkLayer.LoadEntityWithRecno( StartNodeRecno ) As TEzNode;
      If Node1 = Nil then Continue;

      StartNode := Node1;

      // Find the shortest path tree.
      FindPathTree;

      P2 := FPickedPoints[I + 1];
      // find closest node to this point

      S:= NetworkLayer.Name;
      If Not DrawBox.FindClosestEntity( P2.X, P2.Y, '', [idNode], S, EndNodeRecno ) then
        Continue;

      Node2 := NetworkLayer.LoadEntityWithRecno( EndNodeRecno ) As TEzNode;
      If Node2 = Nil then
      begin
        FreeAndNil( Node1 );
        Continue;
      end;

      Try

        // Find the shortest path.
        EndNode := Node2;

        FindPath;

        { create the description directions for traveling }
        FDirections.Add( Format( SNetDirections1, [I + 1] ) );

        node:= NetworkLayer.LoadEntityWithRecno( StartNodeRecno ) As TEzNode;
        P1:= node.Points[0];
        node.free;

        node_num := StartNodeRecno;

        For J := FShortestPath.Count - 1 Downto 0 Do
        Begin
          link_recno:= FShortestPath[J];
          link:= NetworkLayer.LoadEntityWithRecno( link_recno ) As TEzNodeLink;

          try
            If link.FromNode = node_num Then
            begin
              node_num := link.ToNode;
              Reversed:=false;
            End Else
            begin
              node_num := link.FromNode;
              Reversed:=true;
            end;

            node:= NetworkLayer.LoadEntityWithRecno( node_num ) As TEzNode;
            P2 := node.Points[0];
            node.Free;
            If StreetField <> 0 Then
            begin
              NetworkLayer.Recno:= link_recno;
              NetworkLayer.Synchronize;
              stname := NetworkLayer.DbTable.StringGetN( StreetField )
            End Else
              stname := '';
            If J < FShortestPath.count - 1 Then
            Begin
              TestAngle := RadToDeg( Angle2D( P1, P2 ) );
              If Abs( TestAngle - Angle ) <= 15 Then
              Begin
                FDirections.Add( Format( SNetContinueStraight, [stname] ) );
              End
              Else If TestAngle < Angle Then
              Begin
                S := SNetRight;
                FDirections.Add( Format( SNetDirections3, [S, stname] ) );
              End
              Else
              Begin
                S := SNetLeft;
                FDirections.Add( Format( SNetDirections3, [S, stname] ) );
              End;
            End;

            link_cost := CalcLinkCost( link_recno, Reversed );

            FDirections.Add( Format( SNetDirections2, [stname, DrawBox.NumDecimals, link_cost, FUnits] ) );
            Angle := RadToDeg( Angle2D( P1, P2 ) );
            P1 := P2;

          finally
            link.free;
          end;
        End;
      Finally
        FreeAndNil( Node1 );
        FreeAndNil( Node2 );
      End;
      FDirections.Add( '' );
      FDirections.Add( Format( SNetDirections4, [DrawBox.NumDecimals, TotalCost, FUnits] ) );
      FDirections.Add( '' );
      FDirections.Add( '' );

      FTotalCosts.Add( TotalCost );

    End;
    FDirections.Add( SNetDirections5 );
    DrawBox.Repaint;
  Finally
    UnPrepare;
    Screen.Cursor := Saved;
    StartToEndSolver.Free;
    EndToStartSolver.Free;
  End;
End;

Procedure TEzNetwork.Prepare( Layer: TEzBaseLayer );
Begin
  FMaxRecno:= 0;
  Layer.First;
  while not Layer.Eof do
  begin
    if Layer.RecIsDeleted then
    begin
      Layer.Next;
      Continue;
    end;
    FMaxRecno:= IMax( Layer.Recno, FMaxRecno );

    Layer.Next;
  end;
  FNodeCalc.Size := FMaxRecno + 1;
  FInPathList.Size := FMaxRecno + 1;
End;

Procedure TEzNetwork.UnPrepare;
Begin
  FNodeCalc.Size := 0;
  FInPathList.Size := 0;
End;


{ This method will perform a cleanup of the given layer.
  entities will be created at the intersections and short segments will
  be deleted }
Procedure TEzNetwork.CleanUpLayer(
  DrawBox: TEzBaseDrawBox; ALayer: TEzBaseLayer;
  DeleteDuplicatedEntities, EraseShortEntities,
  BreakCrossingEntities, DisolvePseudoNodes: Boolean;
  Const ToleranceSeparation: Double;
  SymbolIndexForNodes, SymbolSize: Integer; OnlySelection: Boolean  );
Var
  Entities: Array[TEzEntityID] Of TEzEntity;
  Cont: TEzEntityID;
  I, J, K1, Index, NewRecno: Integer;
  searchEnt: TEzEntity;
  VectList, DistList: TList;
  selOnly: Boolean;
  LineR: TEzLineRelations;
  IntPt, tmpPt: TEzPoint;
  intersVect, tmpVect: TEzVector;
  Found: Boolean;
  PDR: PDistRec;
  targetEnt: TEzEntity;
  SelectionLayer: TEzSelectionLayer;
  bookmark, searchRecno: Integer;

  Procedure clearDistList;
  Var
    I: Integer;
  Begin
    For I := 0 To DistList.Count - 1 Do
      Dispose( PDistRec( DistList[I] ) );
    DistList.Clear;
  End;

  Procedure clearVectList;
  Var
    I: Integer;
  Begin
    For I := 0 To VectList.Count - 1 Do
      TEzVector( VectList[I] ).Free;
    VectList.Clear;
  End;

  Procedure DeleteDuplicatePoints( Ent: TEzEntity );
  Var
    I, J: Integer;
    found: boolean;
  Begin
    Repeat
      found := false;
      For I := 0 To Ent.Points.Count - 2 Do
      Begin
        For J := I + 1 To Ent.Points.Count - 1 Do
        Begin
          If Dist2D( Ent.Points[I], Ent.Points[J] ) <= 0.00001 Then
          Begin
            Ent.Points.Delete( J );
            found := true;
            break;
          End;
        End;
        If found Then
          break;
      End;
    Until Not found;
  End;

  Function isSameLocation( srcEnt, destEnt: TEzEntity ): Boolean;
  Var
    I, n: Integer;
  Begin
    Result:= False;
    If srcEnt.Points.Count = destEnt.Points.Count Then
    Begin
      n := 0;
      For I := 0 To srcEnt.Points.Count - 1 Do
        If Dist2D( srcEnt.Points[I], destEnt.Points[I] ) <= ToleranceSeparation then // 0=delete duplicate entities
          inc( n );
      result := ( n = srcEnt.Points.Count ) And ( n = destEnt.Points.Count );
    End;
  End;

Begin
  // network
  If ALayer = Nil Then exit;

  If DrawBox = Nil Then Exit;

  // prepare ALayer for a network.
  For Cont := Low( TEzEntityID ) To Pred( idPreview ) Do
    Entities[Cont] := GetClassFromID( Cont ).Create( 4 );
  VectList := TList.Create;
  DistList := TList.Create;
  intersVect := TEzVector.Create( 10 );
  TmpVect:= Nil;

  DrawBox.SymbolMarker := SymbolIndexForNodes;

  Ez_Preferences.DefSymbolStyle.Height := DrawBox.Grapher.PointsToDistY( SymbolSize );

  DrawBox.Gis.StartProgress( SNetCleaning, 1, ALayer.RecordCount );
  ALayer.First;
  Try
    I:= 0;
    SelectionLayer := Nil;
    Index := DrawBox.Selection.IndexOf( ALayer );
    If (Index >= 0) And OnlySelection Then
      SelectionLayer := DrawBox.Selection[Index];
    While Not ALayer.Eof Do
    Begin
      Inc( I );
      DrawBox.GIS.UpdateProgress( I );
      Try
        If ALayer.RecIsDeleted Then Continue;
        searchEnt := ALayer.RecLoadEntity;
        searchRecno := ALayer.Recno;
        If ( searchEnt = Nil ) Or ( ( SelectionLayer <> Nil ) And
          Not ( SelectionLayer.IsSelected(searchRecno) ) ) Then
          Continue;
        Try

          // save the current recno
          bookmark := searchRecno;

          // Disolve Pseudo Nodes ?
          If DisolvePseudoNodes Then
          Begin
            // count the number of links for the future nodes at the two endpoints
            ALayer.SetGraphicFilter( stOverlap, searchEnt.FBox );
            found := false;
            ALayer.First;
            While Not ALayer.Eof Do
            Begin
              Try
                If ALayer.RecIsDeleted Then Continue;

                //TmpRecno := ALayer.Recno;
                targetEnt := Entities[ALayer.RecEntityID];

                ALayer.RecLoadEntity2( targetEnt );

                If Not ( targetEnt.EntityID = idPolyline ) Or
                  Not IsBoxInBox2D( targetEnt.FBox, searchEnt.FBox ) Then
                  Continue;

                // check if targetEnt intersects to searchEnt
                For J := 0 To searchEnt.Points.Count - 2 Do
                Begin
                  For K1 := 0 To targetEnt.Points.Count - 2 Do
                  Begin
                    LineR := LineRel( searchEnt.Points[J],
                                      searchEnt.Points[J + 1],
                                      targetEnt.Points[K1],
                                      targetEnt.Points[K1 + 1],
                                      IntPt );

                    If ( LineR * [lrBetweenDiv, lrBetweenPar] = [lrBetweenDiv, lrBetweenpar] ) Or
                      ( lrAtDivStart In LineR ) Or ( lrAtDivEnd In LineR ) Or
                      ( lrAtParStart In LineR ) Or ( lrAtParEnd In LineR ) Then
                    Begin
                      Found := true;
                      break;
                    End;
                  End;
                  If found Then Break;

                End;
              Finally
                ALayer.Next;
              End;
            End;

            ALayer.CancelFilter;

            If Not Found Then
            Begin
              //DeleteEntity(I);
              // add a marker on this entity
              With searchEnt.Points[0] Do
                ezsystem.AddMarker( DrawBox, X, Y, false );
              Continue;
            End;
          End;

          // break crossing entities ?
          If BreakCrossingEntities Then
          Begin

            clearVectList;
            For J := 0 To searchEnt.Points.Count - 2 Do
            Begin
              tmpVect := Nil;
              found := False;
              clearDistList;
              intersVect.Clear;

              ALayer.SetGraphicFilter( stOverlap, searchEnt.FBox );
              ALayer.First;
              While Not ALayer.Eof Do
              Begin
                Try
                  If ALayer.RecIsDeleted Then Continue;

                  //TmpRecno := ALayer.Recno;
                  targetEnt := Entities[ALayer.RecEntityID];
                  ALayer.RecLoadEntity2( targetEnt );
                  If Not ( targetEnt.EntityID = idPolyline ) Or
                    Not IsBoxInBox2D( targetEnt.FBox, searchEnt.FBox ) Then
                    continue;

                  For K1 := 0 To targetEnt.Points.Count - 2 Do
                  Begin
                    LineR := LineRel( searchEnt.Points[J], searchEnt.Points[J + 1],
                      targetEnt.Points[K1], targetEnt.Points[K1 + 1], IntPt );
                    If ( LineR * [lrBetweenDiv, lrBetweenPar] = [lrBetweenDiv, lrBetweenpar] ) Or
                      ( lrAtDivStart In LineR ) Or ( lrAtDivEnd In LineR ) Or
                      ( lrAtParStart In LineR ) Or ( lrAtParEnd In LineR ) Then
                    Begin
                      intersVect.Add( IntPt );
                      New( PDR );
                      PDR^.D := Dist2D( searchEnt.Points[J], IntPt );
                      PDR^.Index := intersVect.Count - 1;
                      DistList.Add( PDR );
                      found := true;
                    End;
                  End;
                Finally
                  ALayer.Next;
                End;
              End;
              ALayer.CancelFilter;
              If found Then
              Begin
                // sort the list
                QuickSortDistList( DistList, 0, DistList.Count - 1 );
                If tmpVect = Nil Then
                  tmpVect := TEzVector.Create( 4 );
                tmpVect.Add( searchEnt.Points[J] );
                For K1 := 0 To DistList.Count - 1 Do
                Begin
                  PDR := PDistRec( DistList[K1] );
                  tmpPt := intersVect.Points[PDR^.Index];
                  tmpVect.Add( tmpPt );
                  VectList.Add( tmpVect );
                  tmpVect := TEzVector.Create( 4 );
                  tmpVect.Add( tmpPt );
                End;
                tmpVect.Add( searchEnt.Points[J + 1] );
                VectList.Add( tmpVect );
                tmpVect := Nil;
              End
              Else
              Begin
                If tmpVect = Nil Then
                  tmpVect := TEzVector.Create( 4 );
                tmpVect.Add( searchEnt.Points[J] );
              End;
            End;
            If ( tmpVect <> Nil ) And ( tmpVect.Count > 0 ) Then
            Begin
              With searchEnt Do
                tmpVect.Add( Points[Points.Count - 1] );
              VectList.Add( tmpVect );
            End;
            // save first entity and create all other entities
            For J := 0 To VectList.Count - 1 Do
            Begin
              searchEnt.Points.Assign( TEzVector( VectList[J] ) );
              { are there duplicated points ? }
              DeleteDuplicatePoints( searchEnt );
              If searchEnt.Points.Count < 2 Then Continue;
              If J = 0 Then
                ALayer.UpdateEntity( searchRecno, searchEnt )
              Else
              Begin
                NewRecno := ALayer.AddEntity( searchEnt );
                ALayer.CopyRecord( searchRecno, NewRecno );
              End;
            End;
            clearVectList;
          End;

          // restore current record
          ALayer.Recno := bookmark;
        Finally
          searchEnt.Free;
        End;
      Finally
        ALayer.Next;
      End;
    End;
    I := 0;
    ALayer.First;
    While Not ALayer.Eof Do
    Begin
      Inc( I );
      DrawBox.GIS.UpdateProgress( I );
      Try
        If ALayer.RecIsDeleted Then Continue;

        searchEnt := ALayer.RecLoadEntity;
        searchRecno := ALayer.Recno;
        If ( searchEnt = Nil ) Or ( ( SelectionLayer <> Nil ) And
          Not ( SelectionLayer.IsSelected(searchRecno) ) ) Then
          Continue;
        Try

          // Erase short entities ?
          If EraseShortEntities Then
          Begin
            If searchEnt.Perimeter( ) <= ToleranceSeparation Then
            Begin
              ALayer.DeleteEntity( searchRecno );
              Continue;
            End;
          End;

          bookmark := ALayer.Recno;
          // Delete duplicated entities ?
          If DeleteDuplicatedEntities Then
          Begin
            ALayer.First;
            While Not ALayer.Eof Do
            Begin
              Try
                If ( searchRecno = ALayer.Recno ) Or ALayer.RecIsDeleted Then Continue;

                targetEnt := ALayer.RecLoadEntity;
                If targetEnt = Nil Then Continue;

                Try
                  If IsSameLocation( SearchEnt, targetEnt ) Then
                    ALayer.DeleteEntity( ALayer.Recno );
                Finally
                  targetEnt.Free;
                End;
              Finally
                ALayer.Next;
              End;
            End;
          End;
          ALayer.Recno := bookmark;
        Finally
          searchEnt.Free;
        End;
      Finally
        ALayer.Next;
      End;
    End;
  Finally
    DrawBox.GIS.EndProgress;
    //ALayer.EndBuffering;
    For Cont := Low( TEzEntityID ) To Pred( idPreview ) Do
      Entities[Cont].Free;
    clearVectList;
    VectList.Free;
    clearDistList;
    DistList.Free;
    intersVect.Free;
  End;
  DrawBox.Selection.Clear;
  DrawBox.Repaint;
End;

end.
