unit Unit1;

{$I EZ_FLAG.PAS}
    
{.$DEFINE VECTORIAL_TEXT_SAMPLE}   // sample with vectorial text
{$DEFINE TRUETYPE_TEXT_SAMPLE}         // sample with true type text
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, EzCtrls, EzBaseGIS, ExtCtrls, EzLib, EzBase,
  EzBasicCtrls, EzCmdLine, EzRTree;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    EzGIS1: TEzGIS;
    DrawBox1: TEzDrawBox;
    ZoomAll: TSpeedButton;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    PriorViewBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    CmdLine1: TEzCmdLine;
    ZoomWBtn: TSpeedButton;
    BtnHand: TSpeedButton;
    procedure ZoomAllClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure PriorViewBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnHandClick(Sender: TObject);
    procedure ZoomWBtnClick(Sender: TObject);
    procedure DrawBox1BeginRepaint(Sender: TObject);
    procedure DrawBox1EndRepaint(Sender: TObject);
    procedure EzGIS1BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Entity: TEzEntity; Grapher: TEzGrapher;
      Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
      var CanShow: Boolean; var EntList: TEzEntityList;
      var AutoFree: Boolean);
    procedure EzGIS1AfterPaintLayer(Sender: TObject; Layer: TEzBaseLayer;
      Grapher: TEzGrapher; var EntList: TEzEntityList;
      var AutoFree: Boolean);
  private
    { Private declarations }
    FEntList: TEzEntityList;
    FrtOverlap: TRTree;
    FOverlapList: TIntegerList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses Math, EzEntities, EzSystem, EzConsts;

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

procedure TForm1.FormCreate(Sender: TObject);
var
  Path: string;
begin
  { IMPORTANT !!! :

    1.-
    This demo will draw some labels for the STATES_ layer. Example, we could draw
    a Callout Text showing the name of the state and other information.

    The OnBeforeEntity event is used for that purposes.
    Unfortunately, the STATES_ layer is the bottom most layer, so the layers
    above the STATES_ will trash that label, so the implementation taken is:

    - Use global form variable FEntList: TEzEntityList;
    - Initialize this variable in the TEzDrawBox.OnBeginRePaint.
    - When the topmost layer is painted (CITIES_), draw all the entities
      created on this entity list on the OnAfterPaintLayer event.
    - Clear the variables on the TEzDrawBox.OnEndRepaint.

    The inconvenience for the above implementation is that a lot of entities
    can be added to the EntList, so in big maps (this is not the case) this could
    cause to exhaust memory, so some limitation must be imposed, like if the
    entity is too small, then to avoid drawing it.

    2.- In order to avoid overlapping texts an in-memory r-tree instance
        class is used. The form level variable rtOverlapped: TRtree is
        used for that purposes. Please check how it is used

  }


  Path:= AddSlash(ExtractFilePath(ExpandFilename('..\..\data\txt.fnt')));
  if not FileExists(Path+'txt.fnt') then
  begin
    ShowMessage('No font files found !');
  end;
  Ez_VectorFonts.AddFontFile(Path+'complex.fnt');
  Ez_VectorFonts.AddFontFile(Path+'txt.fnt');
  Ez_VectorFonts.AddFontFile(Path+'romanc.fnt');
  Ez_Preferences.DefFontStyle.Name:= 'romanc';

  //Ez_VectorFonts.AddFontFile(Path+'arial.fnt');

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

  EzGis1.FileName:= Path + 'SampleMap.Ezm';
  EzGis1.Open;
  DrawBox1.BeginUpdate;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
begin
  if EzGis1.Layers.Count=0 then exit;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  ShowMessage(
    'You can owner-draw additional entities by using the OnBeforePaintEntity,' + #13 +
    'OnBeforePaintLayer, OnAfterPaintlayer events on TEzGis component.'+#13+
    'This demo show special labels for States_ layer by showing some fields.'+#13+
    'Check events Gis1.OnBeforePaintEntity/OnAfterPaintLayer on this demo.'
    );
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
  DrawBox1.EndUpdate;
end;

procedure TForm1.BtnHandClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('SCROLL','');
end;

procedure TForm1.ZoomWBtnClick(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand('ZOOMWIN','');
end;

procedure TForm1.DrawBox1BeginRepaint(Sender: TObject);
Var
  TmpLayer: TEzBaseLayer;
begin
  FEntList:= TEzEntityList.Create;
  TmpLayer:= EzGIS1.Layers.LayerByName('STATES_');
  FrtOverlap:= TMemRtree.Create( TmpLayer, RTYPE, fmCreate );
  FrtOverlap.CreateIndex( '', TmpLayer.CoordMultiplier );
  FOverlapList:= TIntegerList.Create;
end;

procedure TForm1.DrawBox1EndRepaint(Sender: TObject);
begin
  FreeAndNil(FEntList);
  FreeAndNil(FrtOverlap);
  FreeAndNil(FOverlapList);
end;

procedure TForm1.EzGIS1BeforePaintEntity(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
  Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect;
  DrawMode: TEzDrawMode; var CanShow: Boolean; var EntList: TEzEntityList;
  var AutoFree: Boolean);
const
  ColorArr: Array[0..42]  Of TColor =
    (clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clLtGray,
    clDkGray, clWhite, clScrollBar, clBackground, clActiveCaption,
    clInactiveCaption, clMenu, clWindow, clWindowFrame, clMenuText,
    clWindowText, clCaptionText, clActiveBorder, clInactiveBorder,
    clAppWorkSpace, clHighlight, clHighlightText, clBtnFace,
    clBtnShadow, clGrayText, clBtnText, clInactiveCaptionText,
    clBtnHighlight, cl3DDkShadow, cl3DLight, clInfoText,
    clInfoBk );

var
{$IFDEF VECTORIAL_TEXT_SAMPLE}   // sample with vectorial text
  Ent: TEzEntity;
  TheWidth:double;
  TheText: string;
  NumTries: Integer;
  LastLeft: Double;
  LastTop: Double;
  Option: integer;
  x_left:double;
  x_right:double;
  y_top:double;
  y_bottom:double;
{$ENDIF}

  Box: TEzRect;
  TheHeight, CX, CY: Double;
  TextLocation: TEzPoint;
  StateName, SubregionName: string;
{$IFDEF TRUETYPE_TEXT_SAMPLE}
  pline: TEzEntity;
  StateNameEnt: TEzEntity;
  SubregionNameEnt: TEzEntity;
  RecordNumberEnt: TEzEntity;
  max_width: double;
{$ENDIF}

begin
  If AnsiCompareText(Layer.Name,'STATES_')<>0 then Exit;

  { the following means that the OnBeginRepaint event was not fired and is caused
    because the dynamic update sets a flag indicating it is in update mode }
  If FEntList = Nil then Exit;

  Entity.Centroid(CX,CY);

  // create a callout text entity
  Box:= Entity.FBox;

  Layer.DbTable.Recno:= Recno;

  StateName:= Layer.DbTable.StringGet('state_name');
  SubregionName:= Layer.DbTable.StringGet('sub_region');

{$IFDEF VECTORIAL_TEXT_SAMPLE}

  TheHeight:= 1.0;//Grapher.PointsToDistY(20);
  TheWidth:= 3.0;//TheHeight*4;   // width text

  { first text location is at center of bounding box and 1/2 of height }
  TextLocation:= Point2d( (Box.X1+Box.X2)/2 - TheWidth*0.50, (Box.Y2+Box.Y1)/2 + TheHeight*1.25);

  TheText:= Format( 'state_name : %s' + CrLf + 'sub_region : %s' + CrLf + 'Recno : %d',
    [ StateName, SubregionName, Recno ] );

  Ent:= TEzFittedVectorText.CreateEntity(TextLocation, TheText, TheHeight, TheWidth, 0);
  with TEzFittedVectorText(Ent) do
  begin
    TextBorderStyle:= tbsCallout;
    Brushtool.Pattern:= 1;
    Brushtool.ForeColor:= clInfoBk;

    Pivot:= Point2d(CX,CY);
  end;

  { check if the entity overlap to other text entities }
  x_left:= TextLocation.X;
  x_right:= TextLocation.X;
  y_top:= TextLocation.Y;
  y_bottom:= TextLocation.Y;
  LastLeft:= x_left;
  LastTop:= y_top;
  Box:= Ent.Points.Extension;
  NumTries:= 0;
  Repeat
    { do the search on the r-tree. If no entity overlaps to other texts, then
      we can place the text entity there, otherwise we must found some place
      for the entity }
    FrtOverlap.Search( stOverlap, Layer.FloatRect2Rect( Box ), FOverlapList, 100 ); // 100 = approx. capacity of FOverlapList

    If FOverlapList.Count = 0 Then Break;

    // If NumTries exhausted then break the loop
    If Numtries > 50 then Break;

    { we will rotate the point in order to }

    // pseudo algorithm for moving the entity
    Option:= (NumTries mod 4);
    case Recno Mod 2 of
      0:
        begin
          case Option of
            0:
              begin
              LastLeft:= x_left - abs(Box.x2-Box.x1)*1.05;
              x_left:= LastLeft;
              end;
            1:
              begin
              LastTop:= y_top + abs(Box.y2-Box.y1)*1.05;
              y_top:= LastTop;
              end;
            2:
              begin
              LastLeft:= x_right + abs(Box.x2-Box.x1)*1.05;
              x_right:= LastLeft;
              end;
            3:
              begin
              LastTop:= y_bottom - abs(Box.y2-Box.y1)*1.05;
              y_bottom:= LastTop;
              end;
          end;
        end;
      1:
        begin
          case Option of
            0:
              begin
              LastLeft:= x_right + abs(Box.x2-Box.x1)*1.05;
              x_right:= LastLeft;
              end;
            1:
              begin
              LastTop:= y_bottom - abs(Box.y2-Box.y1)*1.05;
              y_bottom:= LastTop;
              end;
            2:
              begin
              LastLeft:= x_left - abs(Box.x2-Box.x1)*1.05;
              x_left:= LastLeft;
              end;
            3:
              begin
              LastTop:= y_top + abs(Box.y2-Box.y1)*1.05;
              y_top:= LastTop;
              end;
          end;
        end;
    end;
    // this entity overlaps to other entity, so move it randomly until not found
    TextLocation:= Point2d(LastLeft, LastTop);
    TEzFittedVectorText(Ent).BasePoint:= TextLocation;

    Box:= Ent.Points.Extension;

    Inc(NumTries);

  Until False;

  // add to the list
  FEntList.Add( Ent );
  // also add to the r-tree in order to check for later additions
  FrtOverlap.Insert( Layer.FloatRect2Rect( Box ), Recno );  // 0=supposed to be the recno, but not used in this case that information

{$ENDIF}
{$IFDEF TRUETYPE_TEXT_SAMPLE}
  { IMPORTANT !!!: this does not check for overlapping.}

  {  State Name here
     -----------------------------
     Subregion name here          \
     Record number of entity here  \
                                    \
                                     \
                                      \
                                       \
  }
  TheHeight:= 0.50;

  { first text location is at center of bounding box and 1/2 of height }
  TextLocation:= Point2d( (Box.X1+Box.X2)/2 - 3.0, (Box.Y2+Box.Y1)/2 + 4.0);


  // create text above and below horizontal line on polyline
  StateNameEnt:= TEzTrueTypeText.CreateEntity( Point2d(TextLocation.X, TextLocation.Y + TheHeight*1.05),
    Format('state_name : %s',[StateName]), TheHeight, 0.0) ;
  SubregionNameEnt:= TEzTrueTypeText.CreateEntity( Point2d(TextLocation.X, TextLocation.Y - TheHeight*0.05),
    Format('subregion_name : %s',[SubregionName]), TheHeight, 0.0) ;
  RecordNumberEnt:= TEzTrueTypeText.CreateEntity( Point2d(TextLocation.X, TextLocation.Y - TheHeight*1.05),
    Format('record_num : %d',[Recno]), TheHeight, 0.0) ;

  // calculate maximum width of all the texts
  with StateNameEnt.FBox do
    max_width:=(x2-x1);
  with SubregionNameEnt.FBox do
    if (x2-x1) > max_width then max_width:= (x2-x1);
  with RecordNumberEnt.FBox do
    if (x2-x1) > max_width then max_width:= (x2-x1);

  // now reposition text entities
  with TEzTrueTypeText(StateNameEnt) do
    BasePoint:= Point2d(TextLocation.X - max_width, BasePoint.Y);

  with TEzTrueTypeText(SubregionNameEnt) do
    BasePoint:= Point2d(TextLocation.X - max_width, BasePoint.Y);

  with TEzTrueTypeText(RecordNumberEnt) do
    BasePoint:= Point2d(TextLocation.X - max_width, BasePoint.Y);

  // create the sample polyline
  pline := TEzPolyline.CreateEntity([Point2d(CX,CY),TextLocation,Point2d(TextLocation.X-max_width,TextLocation.Y)]);

  // add to the list
  FEntList.Add( StateNameEnt );
  FEntList.Add( SubregionNameEnt );
  FEntList.Add( RecordNumberEnt );
  FEntList.Add( pline );

  AutoFree:= False; // we will free on OnEndRepaint event

{$ENDIF}

  { "paint" the state }
  (Entity As TEzClosedEntity).Brushtool.Pattern:= 1;
  (Entity As TEzClosedEntity).Brushtool.ForeColor:= ColorArr[Recno mod 43];
end;

procedure TForm1.EzGIS1AfterPaintLayer(Sender: TObject;
  Layer: TEzBaseLayer; Grapher: TEzGrapher; var EntList: TEzEntityList;
  var AutoFree: Boolean);
begin
  If (FEntList <> Nil) And (AnsiCompareText(Layer.Name,'CITIES_')=0) then
  Begin
    If FEntList.Count > 0 Then
    Begin
      EntList:= FEntList;
      AutoFree:= False;
    End;
  End;
end;

end.
