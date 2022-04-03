unit ShowHintsU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EzCtrls, ExtCtrls, StdCtrls, ComCtrls, EzBaseGis,
  ezsystem,EzBaseexpr, EzCmdLine, Buttons, EzBasicCtrls, EzActionLaunch,
  Menus;

type
  TForm1 = class(TForm)
    Gis1: TEzGis;
    DrawBox1: TEzDrawBox;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    CmdLine1: TEzCmdLine;
    AerialView1: TEzAerialView;
    ZoomAll: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BtnHand: TSpeedButton;
    ZoomWBtn: TSpeedButton;
    Launcher1: TEzActionLauncher;
    MainMenu1: TMainMenu;
    WhattoTrack1: TMenuItem;
    Exit1: TMenuItem;
    TrackEntityClick1: TMenuItem;
    Trackapolygon1: TMenuItem;
    TrackaPolyline1: TMenuItem;
    TrackaSymbol1: TMenuItem;
    TrackaRectangle1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    TrackTrueTypeText1: TMenuItem;
    TrackVectorialText1: TMenuItem;
    TrackJustifiedVectorialText1: TMenuItem;
    TrackanArc1: TMenuItem;
    TrackanEllipse1: TMenuItem;
    TrackaCircle2P1: TMenuItem;
    TrackaCircle3P1: TMenuItem;
    TrackaCircleCR1: TMenuItem;
    TrackaBandsBitmap1: TMenuItem;
    TrackaBandsTiff1: TMenuItem;
    TrackaSpline1: TMenuItem;
    TrackaBlockInsert1: TMenuItem;
    TrackanEntity1: TMenuItem;
    TrackaBuffer1: TMenuItem;
    N4: TMenuItem;
    TrackEntityMouseMove1: TMenuItem;
    Label1: TLabel;
    N3: TMenuItem;
    rackaPolygonPowerSample1: TMenuItem;
    N5: TMenuItem;
    SetAstheDefaultAction1: TMenuItem;
    CancelAsTheDefaultAction1: TMenuItem;
    Launcher2: TEzActionLauncher;
    TrackanArcStartAngleEndAngle1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure ZoomAllClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure Trackapolygon1Click(Sender: TObject);
    procedure TrackaPolyline1Click(Sender: TObject);
    procedure TrackaSymbol1Click(Sender: TObject);
    procedure TrackaRectangle1Click(Sender: TObject);
    procedure TrackTrueTypeText1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Launcher1TrackedEntity(Sender: TObject;
      const TrackID: String; var TrackedEntity: TEzEntity);
    procedure TrackEntityClick1Click(Sender: TObject);
    procedure TrackEntityMouseMove1Click(Sender: TObject);
    procedure TrackVectorialText1Click(Sender: TObject);
    procedure TrackJustifiedVectorialText1Click(Sender: TObject);
    procedure TrackanArc1Click(Sender: TObject);
    procedure TrackanEllipse1Click(Sender: TObject);
    procedure TrackaCircle2P1Click(Sender: TObject);
    procedure TrackaCircle3P1Click(Sender: TObject);
    procedure TrackaCircleCR1Click(Sender: TObject);
    procedure TrackaSpline1Click(Sender: TObject);
    procedure TrackaBuffer1Click(Sender: TObject);
    procedure TrackaBlockInsert1Click(Sender: TObject);
    procedure TrackaBandsBitmap1Click(Sender: TObject);
    procedure TrackaBandsTiff1Click(Sender: TObject);
    procedure rackaPolygonPowerSample1Click(Sender: TObject);
    procedure SetAstheDefaultAction1Click(Sender: TObject);
    procedure CancelAsTheDefaultAction1Click(Sender: TObject);
    procedure Launcher2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure Launcher2DblClick(Sender: TObject);
    procedure Launcher2KeyPress(Sender: TObject; var Key: Char);
    procedure TrackanArcStartAngleEndAngle1Click(Sender: TObject);
    procedure Launcher1Finished(Sender: TObject);
    procedure Launcher1TrackedEntityClick(Sender: TObject;
      const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer;
      Recno: Integer; var Accept: Boolean);
    procedure Launcher1TrackedEntityMouseMove(Sender: TObject;
      const TrackID: String; Layer: TEzBaseLayer; Recno: Integer;
      var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  fExpress, fPictureDef, ezconsts, ezbase, ezlib,
  EzEntities, EzMiscelEntities, EzGisTiff, EzPolyClip , ezactions;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path: string;
begin
  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');

  { ALWAYS load the symbols after the vectorial fonts
    because the symbols can include vectorial fonts entities and
    if the vector font is not found, then the entity will be configured
    with another font }
  if FileExists(Path + 'symbols.ezs') then
  begin
    Ez_Symbols.FileName:= Path + 'symbols.ezs';
    Ez_Symbols.Open;
  end;

  // load line types
  if FileExists(Path + 'Linetypes.ezl') then
  begin
    Ez_LineTypes.FileName:=Path + 'Linetypes.ezl';
    Ez_LineTypes.Open;
  end;

  Ez_Preferences.CommonSubDir:= Path;

  Gis1.FileName:= Path + 'SampleMap.Ezm';
  Gis1.Open;
  DrawBox1.Resync;
  DrawBox1.ZoomToExtension;
  AerialView1.ZoomToExtension;
end;

procedure TForm1.DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  if Gis1.Layers.Count=0 then exit;
  AerialView1.Refresh;
end;

procedure TForm1.ZoomAllClick(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TForm1.ZoomInClick(Sender: TObject);
begin
  DrawBox1.ZoomIn(85);
end;

procedure TForm1.ZoomOutClick(Sender: TObject);
begin
  DrawBox1.ZoomOut(85);
end;

procedure TForm1.PriorViewBtnClick(Sender: TObject);
begin
  DrawBox1.ZoomPrevious;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  showmessage( 'This demo shows the power of using the TEzActionLauncher component' );
end;

procedure TForm1.BtnHandClick(Sender: TObject);
begin
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.Trackapolygon1Click(Sender: TObject);
begin
  // POLYGON IS ANY IDENTIFIER FOR THE TRACKING
  // AND IS CHECKED IN EVENT OnTrackedEntity
  Launcher1.Cursor:= crCross;
  Launcher1.TrackPolygon('IDPOLYGON');
end;

procedure TForm1.TrackaPolyline1Click(Sender: TObject);
begin
  Launcher1.TrackPolyline('IDPOLYLINE');
end;

procedure TForm1.TrackaSymbol1Click(Sender: TObject);
begin
  Launcher1.TrackPlace('IDPLACE');
end;

procedure TForm1.TrackaRectangle1Click(Sender: TObject);
begin
  Launcher1.TrackRectangle('IDRECTANGLE');
end;

procedure TForm1.TrackTrueTypeText1Click(Sender: TObject);
var
  TrackedEnt: TEzEntity;
begin
  TrackedEnt:= TEzTrueTypeText.CreateEntity( Point2d(0,0), 'Dummy', 1, 0 );
  Launcher1.TrackEntity('IDENTITY', TrackedEnt);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Launcher1TrackedEntity(Sender: TObject;
  const TrackID: String; var TrackedEntity: TEzEntity);
var
  Layer: TEzBaseLayer;
  Scope: string;
  State: TEzEntity;
  Area: Double;
  subject : TEzEntityList;
  clipping : TEzEntityList;
  clipresult : TEzEntityList;
  I: Integer;
  TempPolygon: TEzEntity;
begin
  if TrackID = 'POWERSAMPLE' then
  begin
    { the power sample goes here !!! }

    Layer:= Gis1.Layers.LayerByName( 'STATES_' );

    if (Layer=nil) or (Layer.DbTable=Nil) then exit;
    Screen.Cursor:= crHourglass;
    { this expression will locate all the entities that are partial or fully
      inside the tracked polygon}
    Scope:= Format( '%s.ENT WITHIN POLYGON ([%s])', [Layer.Name,
      TrackedEntity.Points.AsString] );
    Layer.DefineScope( Scope );
    try
      { Get the percent in that every entity on STATES_ layers is inside the Tracked polygon  }

      Layer.First;
      while not Layer.Eof do
      begin
        State:= Layer.RecLoadEntity;  // deleted records not included in filter
        subject := TEzEntityList.Create;
        clipping := TEzEntityList.Create;
        clipresult := TEzEntityList.Create;
        try
          subject.Add( State );
          clipping.Add( TrackedEntity );
          { call to the clipping polygon method.
            pcInt means to find the intersection of the subject and clipping polygon

            EzPolyClip is the unit where the PolygonClip procedure is located }
          EzPolyClip.PolygonClip( pcInt, subject, clipping, ClipResult, Nil );
          Area:= 0;
          { ClipResult can return more than one polygon that is the resulting of the
            clipping (intersection) operation }
          For I := 0 To ClipResult.Count - 1 Do
          begin
            Area := Area + ClipResult[I].Area;	// ClipResult[I] = TEzEntity
          end;

          { create a temp polygon in order to avoid disposing TrackedEntity in
            TEzDrawBox.TempEntities list }
          TempPolygon:= TEzPolygon.Create( TrackedEntity.Points.Count );
          TempPolygon.Assign( TrackedEntity );
          { now show on the map }
          with TEzClosedEntity( TempPolygon ) do
          begin
            BrushTool.Pattern := 2;
            BrushTool.ForeColor:= clGreen;
            BrushTool.BackColor:= clNone;  // causes to be transparent
            Pentool.Style:= 1;
            Pentool.Color:= clRed;
            Pentool.Width:= 0;   // hairline
          end;
          { dispose previous entities }
          DrawBox1.TempEntities.Clear;
          DrawBox1.TempEntities.Add( TempPolygon );
          { now add the source entity }
          with TEzClosedEntity( State ) do
          begin
            BrushTool.Pattern := 2;
            BrushTool.ForeColor:= clRed;
            BrushTool.BackColor:= clNone;  // causes to be transparent
            Pentool.Style:= 1;
            Pentool.Color:= clBlue;
            Pentool.Width:= 0;   // hairline
          end;
          DrawBox1.TempEntities.Add( State );
          DrawBox1.Refresh;  // causes to show the entities on the draw box

          ShowMessage(
            Format('Tracked Area = %.4f, Original Area = %.4f, Intersected Area = %.4f, ' + #13 +
                   ' Percent = %.4f%%',
              [TrackedEntity.Area, State.Area, Area, (Area / State.Area ) * 100]));

          // this will avoid disposing the TrackedEntity polygon
          clipping.ExtractAll;
          // this will avoid disposing the State polygon
          subject.ExtractAll;
        finally
          subject.free;
          clipping.free;
          clipresult.free;
        end;

        Layer.Next;
      end;
    finally
      Layer.CancelScope;
      Screen.Cursor:= crDefault;
    end;
    DrawBox1.TempEntities.Clear;
    DrawBox1.Refresh;

  end else if TrackID = 'IDENTITY' then
  begin
  end else if TrackID = 'IDBLOCK' then
  begin
  end else if TrackID = 'IDPOLYGON' then
  begin
    ShowMessage( 'Polygon with coordinates '#13#10 + TrackedEntity.Points.AsString );
  end else if TrackID = 'IDPOLYLINE' then
  begin
    ShowMessage( 'Polyline with coordinates '#13#10 + TrackedEntity.Points.AsString );
  end else if TrackID = 'IDPLACE' then
  begin
  end else if TrackID = 'IDRECTANGLE' then
  begin
    { you can free here the entity and nothing will happen. Example:}
    FreeAndNil( TrackedEntity );
  end;
end;

procedure TForm1.TrackEntityClick1Click(Sender: TObject);
begin
  ShowMessage('The entitis clicked are restricted to layer STATES_');
  { this tracking will fire event OnTrackedEntityClick }
  Launcher1.MouseDrawElements:= [mdCursor];
  Launcher1.Cursor:= crHandPoint;
  Launcher1.TrackEntityClick('IDCLICK', 'STATES_', True);   // True = highlight clicked entity
end;

procedure TForm1.TrackEntityMouseMove1Click(Sender: TObject);
begin
  { this tracking will fire event OnTrackedEntityMouseMove }
  Launcher1.MouseDrawElements:= [mdCursor];
  Launcher1.Cursor:= crHandPoint;
  Launcher1.TrackEntityMouseMove('IDMOUSEMOVE', 'STATES_', True);    // true = hilite entity detected
end;

procedure TForm1.TrackVectorialText1Click(Sender: TObject);
var
  Entity: TEzEntity;
begin
  // the height and width and insertion point will be defined interactively (by end user)
  Entity := TEzFittedVectorText.CreateEntity( Point2d(0,0), 'This is my text', 1, 1, 0 );
  Launcher1.TrackEntity('IDENTITY', Entity);
end;

procedure TForm1.TrackJustifiedVectorialText1Click(Sender: TObject);
var
  Entity: TEzEntity;
begin
  // the rectangle box will be defined interactively (by end user)
  Entity := TEzJustifVectorText.CreateEntity( Rect2d(0,0,1,1), 0.5, 'This is my text' );
  Launcher1.TrackEntity('IDENTITY', Entity);
end;

procedure TForm1.TrackanArc1Click(Sender: TObject);
begin
  Launcher1.TrackArc3P('IDENTITY');
end;

procedure TForm1.TrackanEllipse1Click(Sender: TObject);
begin
  Launcher1.TrackEllipse('IDENTITY');
end;

procedure TForm1.TrackaCircle2P1Click(Sender: TObject);
begin
  Launcher1.TrackCircle('IDENTITY',ct2P);
end;

procedure TForm1.TrackaCircle3P1Click(Sender: TObject);
begin
  Launcher1.TrackCircle('IDENTITY',ct3P);
end;

procedure TForm1.TrackaCircleCR1Click(Sender: TObject);
begin
  Launcher1.TrackCircle('IDENTITY',ctCR);
end;

procedure TForm1.TrackaSpline1Click(Sender: TObject);
begin
  Launcher1.TrackSpline('IDENTITY');
end;

procedure TForm1.TrackaBuffer1Click(Sender: TObject);
begin
  Launcher1.TrackBuffer('IDENTITY');
end;

procedure TForm1.TrackaBlockInsert1Click(Sender: TObject);
var
  Entity: TEzEntity;
  BlockName: string;
begin
  { define the block to insert
    Blocks must be that blocks that are placed only on subdirectory
    Ez_Preferences.CommonSubDir
  }
  BlockName:=SelectCommonElement(AddSlash(Ez_Preferences.CommonSubDir), '', liBlocks);
  If Length(BlockName)=0 then exit;
  { insertion point is not important because it will be defined interactively }
  Entity:= TEzBlockInsert.CreateEntity( BlockName, Point2D( 0.0, 0.0 ), 0.0, 0.1, 0.1 );
  Launcher1.Cursor:= crCross;
  Launcher1.TrackEntity('IDBLOCK', Entity);
end;

procedure TForm1.TrackaBandsBitmap1Click(Sender: TObject);
var
  PicFileName: string;
  Entity: TEzEntity;
begin
  { create the entity }
  Entity:= TEzBandsBitmap.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ), '' );
  { define which one is the bitmap }
  With TfrmPict1.Create( Nil ) Do
    Try
      If Not ( Enter( Entity.EntityID, '', Ez_Preferences.CommonSubDir ) = mrOk ) Then
      Begin
        Entity.Free;
        Exit;
      End;
      PicFileName:= ExtractFileName( EditFileName );
    Finally
      Free;
    End;
  { reasign the choosed bitmap to the FileName property (without path) }
  TEzBandsBitmap( Entity ).FileName := PicFileName;
  { now place on the map }
  Launcher1.Cursor:= crCross;
  Launcher1.TrackEntity('IDENTITY', Entity);
end;

procedure TForm1.TrackaBandsTiff1Click(Sender: TObject);
var
  PicFileName: string;
  Entity: TEzEntity;
begin
  { create the tiff entity }
  Entity:= TEzBandsBitmap.CreateEntity( Point2D( 0, 0 ), Point2D( 0, 0 ), '' );
  { define which one tiff file will be used }
  With TfrmPict1.Create( Nil ) Do
    Try
      If Not ( Enter( Entity.EntityID, '', Ez_Preferences.CommonSubDir ) = mrOk ) Then
      Begin
        Entity.Free;
        Exit;
      End;
      PicFileName:= ExtractFileName( EditFileName );
    Finally
      Free;
    End;
  { assign the choosed tiff to FileName property }
  TEzBandsBitmap( Entity ).FileName := PicFileName;
  { now place on the map. Check event OnTrackedEntity }
  Launcher1.Cursor:= crCross;
  Launcher1.TrackEntity('IDENTITY', Entity);
end;

procedure TForm1.rackaPolygonPowerSample1Click(Sender: TObject);
begin
  ShowMessage( 'We will start to drawing a polygon' + #13 +
               'After you finished defining the polygon, all the polygons of'+ #13 +
               'Layer STATES_ that are partial or fully inside the tracked polygon' + #13 +
               'will be showed and the area that is inside the tracked polyon' + #13 +
               'will be calculated.' );
  Launcher1.Cursor:= crCross;
  Launcher1.TrackPolygon('POWERSAMPLE');
end;

procedure TForm1.SetAstheDefaultAction1Click(Sender: TObject);
begin
  ShowMessage('This will replace the default action on the CmdLine1' + #13 +
              'You can check the events of Launcher2 in order to know'+ #13+
              'how to code for some events on the TEzActionLauncher component' );
  { this causes to fire the following events ( if the event is defined ):
       OnMouseDown;
       OnMouseMove;
       OnMouseUp;
       OnClick;
       OnDblClick;
       OnKeyDown;
       OnKeyPress;
       OnKeyUp;
       OnActionDoCommand;
       OnSuspendOperation;
       OnContinueOperation;
       OnUndo;
       OnInitialize;
  }
  Launcher2.DefaultAction:= True;
end;

procedure TForm1.CancelAsTheDefaultAction1Click(Sender: TObject);
begin
  Launcher2.DefaultAction:= False;
end;

procedure TForm1.Launcher2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
Var
  Picked: Boolean;
  CurrPoint: TEzPoint;
  TmpLayer: TEzBaseLayer;
  TmpRecno: Integer;
  FPickedPoint: Integer;    { the index of picked point in the list of points for the entity }
  Key: Char;
begin
  ShowMessage('mouse down');
  If Button = mbRight Then Exit;
  { here an entity is selected. No stacked entities as in the default action }
  CurrPoint := CmdLine1.CurrentPoint;
  Picked := Drawbox1.PickEntity( CurrPoint.X, CurrPoint.Y, 4, '',
    TmpLayer, TmpRecNo, FPickedPoint, Nil );  // Nil = return only one entity of clicked point ( the topmost entity )

  { unselect all }
  Key:= #27;
  Launcher2KeyPress(Nil, Key);

  If Picked then
  begin
    { by default, select the entity clicked }
    Drawbox1.Selection.Add( TmpLayer, TmpRecNo );
    { repaint only the selection area }
    Drawbox1.Selection.RepaintSelectionArea;
  End;
end;

procedure TForm1.Launcher2DblClick(Sender: TObject);
begin
  If DrawBox1.Selection.NumSelected = 1 Then
  Begin
    ShowMessage( Format( 'Double clicked on entity from Layer = %s, Recno = %d',
      [DrawBox1.Selection[0].Layer.Name, DrawBox1.Selection[0].SelList[0]] ) );
  End;
end;

procedure TForm1.Launcher2KeyPress(Sender: TObject; var Key: Char);
Var
  CurrSelExtension: TEzRect;
  IsSelected: Boolean;
begin
  If Key = #27 Then
  begin
    { obtain the current extension of selected entities }
    IsSelected := DrawBox1.Selection.Count > 0;
    if IsSelected then
    begin
      CurrSelExtension := DrawBox1.Selection.GetExtension;
      Drawbox1.Selection.Clear;
      If Not EqualRect2D( CurrSelExtension, INVALID_EXTENSION ) Then
        Drawbox1.RepaintRect( CurrSelExtension );
    end;
  end;
end;

procedure TForm1.TrackanArcStartAngleEndAngle1Click(Sender: TObject);
begin
  Launcher1.TrackArcSE('IDENTITY');
end;

procedure TForm1.Launcher1Finished(Sender: TObject);
begin
  Launcher1.MouseDrawElements:= [mdCursorFrame,mdFullViewCursor];
end;

procedure TForm1.Launcher1TrackedEntityClick(Sender: TObject;
  const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer; Recno: Integer;
  var Accept: Boolean);
begin
  //If (Layer<>Nil) And (AnsiCompareText(Layer.Name, 'STATES_')<>0) Then
  //Begin
  //  Label1.Caption:= 'No Entity Clicked';
  //  Accept:= false; // restricted to click on layer STATES_ only (by default Accept:=true);
  //  Exit;
  //End;
  if TrackID = 'IDCLICK' then  // this can be used if action started from several places
  begin
    if Layer = Nil then
      { this can be used as an example, if you are showing information in a form, then
        you clean the previous information }
      Label1.Caption:= 'No Entity Clicked'
    else
      { this can be used for showing in a custom form, the information of the entity
        clicked }
      Label1.Caption:= Format('Entity Clicked on Layer %s, Recno %d', [Layer.Name, Recno]);
  end;
end;

procedure TForm1.Launcher1TrackedEntityMouseMove(Sender: TObject;
  const TrackID: String; Layer: TEzBaseLayer; Recno: Integer;
  var Accept: Boolean);
begin
  //If (Layer <> Nil) And (AnsiComparetext(Layer.name,'STATES_')<>0) then
  //begin
  //  accept:=false;
  //  exit;
  //end;
  if TrackID = 'IDMOUSEMOVE' then
  begin
    if Layer = Nil then
      Label1.Caption:= ''
    else
      Label1.Caption:= 'Tracked Mouse Move On Entity ' + #13 +
        Format( 'Layer Name %s, Recno %d', [Layer.Name, Recno] );
  end;
end;

end.
