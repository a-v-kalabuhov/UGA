unit fRasterImageEd;

{$I EZ_FLAG.PAS}
interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, Buttons, EzBaseGIS, EzCmdLine, EzEntities, EzCtrls,
  ExtCtrls, Ezbase, EzLib, StdCtrls, EzBasicCtrls, EzActionLaunch,
  ActnList, ToolWin, ActnMan, ActnCtrls, ActnMenus, ImgList, XPStyleActnCtrls;

type
  TfrmRasterImgEditor = class(TForm)
    GIS1: TEzGIS;
    CmdLine1: TEzCmdLine;
    StatusBar1: TStatusBar;
    DrawBox1: TEzDrawBox;
    GeorefImage1: TEzGeorefImage;
    Launcher1: TEzActionLauncher;
    ActionManager1: TActionManager;
    ImageList1: TImageList;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action12: TAction;
    Action13: TAction;
    Action14: TAction;
    Action15: TAction;
    Action16: TAction;
    Action17: TAction;
    Action18: TAction;
    Action19: TAction;
    ActionToolBar1: TActionToolBar;
    ActionToolBar2: TActionToolBar;
    ActionToolBar3: TActionToolBar;
    Action20: TAction;
    Action21: TAction;
    Action22: TAction;
    Action23: TAction;
    Action24: TAction;
    Action25: TAction;
    Action26: TAction;
    Action27: TAction;
    Action28: TAction;
    Action29: TAction;
    Action30: TAction;
    Action31: TAction;
    Action32: TAction;
    OpenDialog1: TOpenDialog;
    procedure FormDestroy(Sender: TObject);
    procedure DrawBox1GridError(Sender: TObject);
    procedure DrawBox1MouseMove2D(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double);
    procedure CmdLine1StatusMessage(Sender: TObject;
      const Message: String);
    procedure DrawBox1ZoomChange(Sender: TObject; const Scale: Double);
    procedure DrawBox1BeginRepaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawBox1AfterInsert(Sender: TObject; Layer: TEzBaseLayer;
      RecNo: Integer);
    procedure GIS1BeforeSymbolPaint(Sender: TObject; Layer: TEzBaseLayer;
      Recno: Integer; Grapher: TEzGrapher; Canvas: TCanvas;
      const Clip: TEzRect; Style: TEzSymbolTool);
    procedure Launcher1TrackedEntityClick(Sender: TObject;
      const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer;
      Recno: Integer; var Accept: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Action19Execute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure Action13Execute(Sender: TObject);
    procedure Action20Execute(Sender: TObject);
    procedure Action21Execute(Sender: TObject);
    procedure Action22Execute(Sender: TObject);
    procedure Action23Execute(Sender: TObject);
    procedure Action24Execute(Sender: TObject);
    procedure Action25Execute(Sender: TObject);
    procedure Action26Execute(Sender: TObject);
    procedure Action27Execute(Sender: TObject);
    procedure Action28Execute(Sender: TObject);
    procedure Action29Execute(Sender: TObject);
    procedure Action30Execute(Sender: TObject);
    procedure Action31Execute(Sender: TObject);
    procedure Action32Execute(Sender: TObject);
    procedure Action10Update(Sender: TObject);
    procedure Action11Update(Sender: TObject);
    procedure Action12Update(Sender: TObject);
    procedure Action19Update(Sender: TObject);
  private
    { Private declarations }
    FTempPreferences: TEzPreferences;
    FTempSymbols: TEzSymbols;
    procedure CreateNewEditor(const FileName: string);
    procedure DeleteMapFiles(const s: string);
    procedure DefineCaption;
    procedure SaveGeoRefFile(const Filename: string);
    function CalcRealMaxMinExtents: Boolean;
    procedure EditEntity(Layer: TEzBaseLayer; Recno: Integer);
    procedure OpenGeorefFile(const FileName: string);
  public
    { Public declarations }
  end;
implementation

{$R *.DFM}

uses
  Ezimpl, ezsystem, ezgraphics, ezconsts, FNewPt
{$IFDEF USE_GRAPHICEX}
  , EzGisTiff
{$ENDIF}
  ;

resourcestring
  SRasterImageEditor= 'Raster Image Editor - ';
  SNotEnoughPoints= 'Not enough reference points';
  SWrongAlignedPointsX= 'Wrong points alignment along X axis';
  SWrongAlignedPointsY= 'Wrong points alignment along Y axis';
  SConversionSuccessful= 'Conversion successful';

type

  (* List used for sorting numbers *)
  PInfoRec = ^TInfoRec;
  TInfoRec = record
    Value: Double;
    Index: Integer;
  end;

  TInfoRecList = class
  private
    FList: TList;
    function GetCount : Integer;
    function GetItem( Index : Integer ) : TInfoRec;
    procedure SetItem( Index : Integer; const Value : TInfoRec );
  public
    constructor Create;
    destructor Destroy; override;
    function Add( const Value : TInfoRec ) : Integer;
    procedure Clear;
    procedure Delete( Index : Integer );
    procedure Insert( Index : Integer; const Value : TInfoRec );
    procedure Sort;

    property Count : Integer read GetCount;
    property Items[Index: Integer]: TInfoRec read GetItem write SetItem; default;
  end;

{ TInfoRecList }
constructor TInfoRecList.create;
begin
  inherited Create;
  FList:= TList.Create;
end;

destructor TInfoRecList.destroy;
begin
  Clear;
  FList.free;
  inherited destroy;
end;

function TInfoRecList.GetCount : Integer;
begin
  Result := FList.Count;
end;

function TInfoRecList.GetItem( Index : Integer ) : TInfoRec;
begin
  Result := PInfoRec( FList.Items[ Index ] )^;
end;

procedure TInfoRecList.SetItem( Index : Integer; const Value : TInfoRec );
begin
  PInfoRec( FList.Items[ Index ] )^ := Value;
end;

procedure TInfoRecList.Insert( Index : Integer; const Value : TInfoRec );
var
  P : PInfoRec;
begin
  New( P );      { Allocate Memory for Extended }
  P^ := Value;
  FList.Insert( Index, P );  { Insert onto Internal List }
end;

function TInfoRecList.Add( const Value : TInfoRec ) : Integer;
begin
  Result := Count;
  Insert( Count, Value );
end;

procedure TInfoRecList.Clear;
var
  I : Integer;
begin
  for I := 0 to Pred( FList.Count ) do
    Dispose( PInfoRec( FList.Items[ I ] ) );
  FList.Clear;
end;

procedure TInfoRecList.Delete( Index : Integer );
begin
  Dispose( PInfoRec( FList.Items[ Index ] ) );
  FList.Delete( Index );
end;

procedure TInfoRecList.Sort;

   procedure QuickSort(L, R: Integer);
   var
     I, J: Integer;
     P, T: PInfoRec;
   begin
     New(P); New(T);
     repeat
       I := L;
       J := R;
       P^ := PInfoRec(fList[(L + R) shr 1])^;
       repeat
         while PInfoRec(fList[I])^.Value < P^.Value do Inc(I);
         while PInfoRec(fList[J])^.Value > P^.Value do Dec(J);
         if I <= J then begin
            T^ := PInfoRec(FList[I])^;
            PInfoRec(fList[I])^ := PInfoRec(fList[J])^;
            PInfoRec(fList[J])^ := T^;
            Inc(I);
            Dec(J);
         end;
       until I > J;
       if L < J then QuickSort(L, J);
       L := I;
     until I >= R;
     Dispose(P); Dispose(T);
   end;

begin
   if FList.Count > 0 then
      QuickSort(0, FList.Count - 1);
end;


{ TfrmRasterImgEditor }
procedure TfrmRasterImgEditor.DefineCaption;
begin
  Self.Caption:= SRasterImageEditor + GeorefImage1.FileName;
end;

procedure TfrmRasterImgEditor.OpenGeorefFile(const FileName: string);
var
  i: integer;
  Subd: String;
  Ent: TEzEntity;
  BitmapWidth, BitmapHeight: Integer;
  IsCompressed: Boolean;
  Layer: TeZbASELayer;
  GeorefPoint: TEzGeorefPoint;
begin
  { receives a .gri file and create a new map for editing }
  if not FileExists(FileName) then exit;
  CreateNewEditor(FileName);
  Subd:= AddSlash(Ez_Preferences.CommonSubDir);

  GeorefImage1.FileName:= FileName;
  GeorefImage1.Open;
  if (Length(GeorefImage1.ImageName)>0) and FileExists(Subd+GeorefImage1.ImageName) then
  begin
    if not GetDIBDimensions( Subd + GeorefImage1.ImageName,
                             nil,
                             BitmapWidth,
                             BitmapHeight,
                             IsCompressed ) or IsCompressed then exit;

    DrawBox1.SetViewTo(0,-BitmapHeight,BitmapWidth,0);
    DefineCaption;
    Self.Caption:= Self.Caption + Format('- Image Width %d, Height %d',[BitmapWidth, BitmapHeight]);

    Ent:= TEzBandsBitmap.CreateEntity(Point2D(0,0), Point2D(BitmapWidth, -BitmapHeight), GeorefImage1.ImageName);
    try
      DrawBox1.AddEntity('',Ent);
    finally
      Ent.Free;
    end;
  end;
  for I:=0 to GeorefImage1.GeorefPoints.Count-1 do
  begin
    // add this point to the map
    GeorefPoint:= GeorefImage1.GeorefPoints[I];
    Ent:= TEzPlace.CreateEntity(Point2D(GeorefPoint.XPixel, -GeorefPoint.YPixel));
    try
      TEzPlace(Ent).Symboltool.Height:= DrawBox1.Grapher.PointsToDistY(12);
      TEzPlace(Ent).UpdateExtension;
      DrawBox1.AddEntity('',Ent);
      Layer:= GIS1.Layers[0];
      with Layer do
      begin
        Last;
        with DBTable do
        begin
          Recno:= Layer.Recno;
          Edit;
          FloatPut('X',GeorefPoint.XWorld);
          FloatPut('Y',GeorefPoint.YWorld);
          Post;
        end;
      end;
    finally
      Ent.Free;
    end;
  end;
  GIS1.UpdateExtension;
  DefineCaption;
end;

procedure TfrmRasterImgEditor.DeleteMapFiles(const s: string);
var
  tmp: string;
begin
  if Length(s) > 0 then
  begin
    tmp:= ChangeFileExt(s, '.EZM');
    if FileExists(tmp) then SysUtils.DeleteFile(tmp);
    tmp:= ChangeFileExt(s, '.EZD');
    if FileExists(tmp) then SysUtils.DeleteFile(tmp);
    tmp:= ChangeFileExt(s, '.EZX');
    if FileExists(tmp) then SysUtils.DeleteFile(tmp);
    tmp:= ChangeFileExt(s, '.RTC');
    if FileExists(tmp) then SysUtils.DeleteFile(tmp);
    tmp:= ChangeFileExt(s, '.RTX');
    if FileExists(tmp) then SysUtils.DeleteFile(tmp);
    with ezbasegis.basetableclass.CreateNoOpen( Gis1 ) do
      try
        DBDropTable( s );
      finally
        free;
      end;
    tmp:= ChangeFileExt(s, '.EPJ');
    if FileExists(tmp) then SysUtils.DeleteFile(tmp);
  end;
end;

procedure TfrmRasterImgEditor.CreateNewEditor(const Filename: string);
var
  Layname, s: string;
  FieldList: TStringList;
begin
  GIS1.Close;

  GeorefImage1.New;

  { create a fictitious map for editing }
  GeorefImage1.FileName:= ChangeFileExt(FileName, '.GRI');
  s:= ChangeFileExt(GeorefImage1.FileName, '.EZM');
  //GIS1.CreateNewFile(s);
  layname:= ChangeFileExt(GeorefImage1.FileName,'');
  DeleteMapFiles(layname);
  Gis1.CreateNew(ChangeFileExt(layname,'.EZM'));
  FieldList:= TStringList.Create;
  try
    FieldList.Add('UID;N;8;0');
    FieldList.Add('X;N;20;6');
    FieldList.Add('Y;N;20;6');
    GIS1.Layers.CreateNewEx(layname,
                            csCartesian,
                            cuM,
                            FieldList);
  finally
    FieldList.Free;
  end;
  GIS1.CurrentLayerName:= ExtractFileName(ExtractFileName( ChangeFileExt(GeorefImage1.FileName, '') ));
  Ez_Preferences.MinDrawLimit:= 0;
end;

procedure TfrmRasterImgEditor.FormDestroy(Sender: TObject);
begin
  CmdLine1.Clear;
  // restore global preferences
  Ez_Preferences.Assign(FTempPreferences);
  FTempPreferences.Free;
  Ez_Symbols.Assign(FTempSymbols);
  FTempSymbols.Free;

  GIS1.Close;
  DeleteMapFiles( GeorefImage1.FileName );
end;

procedure TfrmRasterImgEditor.DrawBox1GridError(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := SGridTooDense;
end;

procedure TfrmRasterImgEditor.DrawBox1MouseMove2D(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
begin
  StatusBar1.Panels[1].Text := DrawBox1.CoordsToDisplayText(WX,-WY);
end;

procedure TfrmRasterImgEditor.CmdLine1StatusMessage(Sender: TObject;
  const Message: String);
begin
  StatusBar1.Panels[0].Text := Message;
end;

procedure TfrmRasterImgEditor.DrawBox1ZoomChange(Sender: TObject;
  const Scale: Double);
begin
  StatusBar1.Panels[2].Text := '1:'+Format('%.2n',[Scale]);
end;

procedure TfrmRasterImgEditor.DrawBox1BeginRepaint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := '';
end;

procedure TfrmRasterImgEditor.FormCreate(Sender: TObject);
var
  S: TEzSymbol;
  E: TEzEntity;
begin
  // save global preferences
  FTempPreferences:= TEzPreferences.Create;
  FTempPreferences.Assign(Ez_Preferences);
  FTempSymbols:= TEzSymbols.Create;
  FTempSymbols.Assign(Ez_Symbols);

  { Create the symbol used for marking the georeferenced points }
  Ez_Symbols.Clear;
  S:= TEzSymbol.Create(Ez_Symbols);
  E:= TEzEllipse.CreateEntity(Point2D(0, 0), Point2D(10, 10));
  S.Add(E);
  E:= TEzPolyline.CreateEntity([Point2D(0, 0), Point2D(10, 10)]);
  S.Add(E);
  E:= TEzPolyline.CreateEntity([Point2D(0, 10), Point2D(10, 0)]);
  S.Add(E);

  Ez_Symbols.Add(S);
end;

procedure TfrmRasterImgEditor.SaveGeoRefFile(const Filename: string);
begin
  if not CalcRealMaxMinExtents then Exit;
  GeorefImage1.FileName:= FileName;
  GeorefImage1.Save;
end;

function TfrmRasterImgEditor.CalcRealMaxMinExtents: Boolean;
var
  GeoRefPt1, GeoRefPt2: TEzGeoRefPoint;
  Found: Boolean;
  dFirst, dNext, dDelta, xmin,ymin,xmax,ymax,RealWidth,RealHeight: Double;
  i,j,k,n,iDelta: integer;
  AvgNumPixels: integer;
  AvgNumUnits: Double;
  Subd,FmtString: string;
  TmpList: TEzGeorefImage;
  InfoRecList: TInfoRecList;
  InfoRec: TInfoRec;
  BitmapWidth, BitmapHeight: integer;
  IsCompressed: Boolean;
  TmpR: TEzRect;
  FileExt: string;
begin
  Result:=False;
  if GeorefImage1.GeorefPoints.Count < 2 then
  begin
     MessageDlg(SNotEnoughPoints, mtError, [mbOk],0); exit;
  end;
  InfoRecList:= TInfoRecList.Create;
  FmtString:= '%15.4f';

  Subd:= AddSlash(Ez_Preferences.CommonSubDir);
  FileExt:= ExtractFileExt(GeorefImage1.ImageName);
  If (AnsiCompareText(FileExt, '.bmp') = 0) And
    not GetDIBDimensions( Subd + GeorefImage1.ImageName, nil, BitmapWidth,
      BitmapHeight, IsCompressed ) or IsCompressed Then
    Exit
{$IFDEF USE_GRAPHICEX}
  else If (AnsiCompareText(FileExt, '.tif') = 0) And
    Not GetTiffDimensions( Subd + GeorefImage1.ImageName, Nil, BitmapWidth, BitmapHeight, IsCompressed ) then
      Exit
{$ENDIF}
  else if (AnsiCompareText(FileExt, '.bil') = 0) And
    Not GetBILDimensions( Subd + GeorefImage1.ImageName, BitmapWidth, BitmapHeight ) then
    Exit
  else
    Exit;

  TmpList:= TEzGeorefImage.Create(nil);
  TmpList.Assign(GeorefImage1);
  for i:= 0 to TmpList.GeorefPoints.Count - 1 do
  begin
     TmpList.GeorefPoints[I].YPixel:= BitmapHeight - TmpList.GeorefPoints[I].YPixel;
  end;

  // ************** first process the x coords *******************
  for i:= 0 to TmpList.GeorefPoints.Count - 1 do
  begin
     InfoRec.Value:= TmpList.GeorefPoints[i].XWorld;
     InfoRec.Index:= i;
     InfoRecList.Add(InfoRec);
  end;
  InfoRecList.Sort;      // sort the list
  AvgNumPixels:= 0;
  AvgNumUnits:=0;

  j:= InfoRecList[0].Index; GeoRefPt1:= TmpList.GeorefPoints[j];
  dFirst := GeoRefPt1.XWorld;
  i:= 1; n:= 0;
  found:= false;
  while i < InfoRecList.Count do
  begin
     j:= InfoRecList[i].Index;
     GeoRefPt1:= TmpList.GeorefPoints[j];
     dNext := GeoRefPt1.XWorld;
     if dNext > dFirst then
     begin
        j:= InfoRecList[i - 1].Index;
        k:= InfoRecList[i].Index;
        GeoRefPt1:= TmpList.GeorefPoints[j];
        GeoRefPt2:= TmpList.GeorefPoints[k];
        iDelta:= GeoRefPt2.XPixel - GeoRefPt1.XPixel;
        dDelta:= GeoRefPt2.XWorld - GeoRefPt1.XWorld;
        if (iDelta > 0) and (dDelta>0) then
        begin
           Inc(n);
           AvgNumPixels:= AvgNumPixels + iDelta;
           AvgNumUnits:= AvgNumUnits + dDelta;
           found:= true;
        end;
     end;
     dFirst:= dNext;
     inc(i);
  end;
  if not found then
  begin
     MessageDlg(SWrongAlignedPointsX, mtError, [mbOk],0);
     TmpList.Free;
     InfoRecList.Free;
     exit;
  end;
  AvgNumPixels:= round(AvgNumPixels/n);
  AvgNumUnits:= AvgNumUnits/n;

  RealWidth := (BitmapWidth / AvgNumPixels) * AvgNumUnits;
  // based on leftmost reference, find xmin, xmax
  j:= InfoRecList[0].Index;
  GeoRefPt1:= TmpList.GeorefPoints[j];
  xmin := GeoRefPt1.XWorld - (GeoRefPt1.XPixel / AvgNumPixels) * AvgNumUnits;
  xmax:= xmin + RealWidth;

  // ************* now process the y coords **********************
  InfoRecList.Clear;
  for i:= 0 to TmpList.GeorefPoints.Count - 1 do
  begin
     GeoRefPt1:= TmpList.GeorefPoints[i];
     InfoRec.Value:= GeoRefPt1.YWorld;
     InfoRec.Index:= i;
     InfoRecList.Add(InfoRec);
  end;
  InfoRecList.Sort;      // sort the list
  AvgNumPixels:= 0; AvgNumUnits:=0;

  j:= InfoRecList[0].Index;
  GeoRefPt1:= TmpList.GeorefPoints[j];
  dFirst := GeoRefPt1.YWorld;
  i:= 1; n:= 0;
  found:= false;
  while i < InfoRecList.Count do
  begin
     j:= InfoRecList[i].Index;
     GeoRefPt1:= TmpList.GeorefPoints[j];
     dNext := GeoRefPt1.YWorld;
     if dNext > dFirst then
     begin
        j:= InfoRecList[i - 1].Index;
        k:= InfoRecList[i].Index;
        GeoRefPt1:= TmpList.GeorefPoints[j];
        GeoRefPt2:= TmpList.GeorefPoints[k];
        iDelta:= GeoRefPt2.YPixel - GeoRefPt1.YPixel;
        dDelta:= GeoRefPt2.YWorld - GeoRefPt1.YWorld;
        if (iDelta > 0) and (dDelta>0) then
        begin
           Inc(n);
           AvgNumPixels:= AvgNumPixels + iDelta;
           AvgNumUnits:= AvgNumUnits + dDelta;
           found:= true;
        end;
     end;
     dFirst:= dNext;
     inc(i);
  end;
  if not found then
  begin
     MessageDlg(SWrongAlignedPointsY, mtError, [mbOk],0);
     TmpList.Free;
     InfoRecList.Free;
     exit;
  end;
  AvgNumPixels:= round(AvgNumPixels/n);
  AvgNumUnits:= AvgNumUnits/n;

  RealHeight := (BitmapHeight / AvgNumPixels) * AvgNumUnits;
  // based on leftmost reference, find xmin, xmax
  j:= InfoRecList[0].Index;
  GeoRefPt1:= TmpList.GeorefPoints[j];
  ymin := GeoRefPt1.YWorld - (GeoRefPt1.YPixel / AvgNumPixels) * AvgNumUnits;
  ymax:= ymin + RealHeight;

  TmpR.Emin.X:=xmin; TmpR.Emax.X:=xmax;
  TmpR.Emin.y:=ymin; TmpR.Emax.y:=ymax;
  GeorefImage1.Extents:= TmpR;

  TmpList.free;
  InfoRecList.Free;
  Result:= True;
end;

procedure TfrmRasterImgEditor.EditEntity(Layer: TEzBaseLayer; Recno: Integer);
var
  Ent: TEzEntity;
  WX,WY, X,Y: Double;
begin
  If ( Layer = Nil ) Or ( Recno < 1 ) Then Exit;
  Layer.Recno:= Recno;
  Layer.Synchronize;
  Ent:= Layer.RecLoadEntity;
  WX:= Layer.DBTable.FloatGet('X');
  WY:= Layer.DBTable.FloatGet('Y');
  X:=WX;
  Y:=WY;
  if Ent=nil then Exit;
  try
    with TfrmNewPt.Create(Nil) do
      try
        Edit1.numericValue:= X;
        Edit2.numericValue:= Y;
        EdX.numericValue:= Round(Ent.Points[0].X);
        EdY.numericValue:= Round(-Ent.Points[0].Y);

        if not (ShowModal=mrOk) then Exit;
        WX:= Edit1.numericValue;
        WY:= Edit2.numericValue;
        X:=WX;
        Y:=WY;
        Layer.DBTable.Recno:= Recno;
        Layer.DBTable.Edit;
        Layer.DBTable.FloatPut('X', X);
        Layer.DBTable.FloatPut('Y', Y);
        Layer.DBTable.Post;
        Ent.Points[0]:= Point2D(EdX.numericValue, -EdY.numericValue);
        Layer.UpdateEntity(Recno,Ent);
      finally
        Free;
      end;
  finally
    Ent.Free;
  end;
end;

procedure TfrmRasterImgEditor.DrawBox1AfterInsert(Sender: TObject;
  Layer: TEzBaseLayer; RecNo: Integer);
begin
  EditEntity(Layer,Recno);
end;

procedure TfrmRasterImgEditor.GIS1BeforeSymbolPaint(Sender: TObject;
  Layer: TEzBaseLayer; Recno: Integer; Grapher: TEzGrapher;
  Canvas: TCanvas; const Clip: TEzRect; Style: TEzSymbolTool);
begin
  Style.Index:= 0;
  Style.Rotangle:= 0;
  Style.Height:= Grapher.PointsToDistY(12);
end;

procedure TfrmRasterImgEditor.Launcher1TrackedEntityClick(Sender: TObject;
  const TrackID: String; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double; Layer: TEzBaseLayer; Recno: Integer;
  var Accept: Boolean);
begin
  EditEntity(Layer,Recno);
end;

procedure TfrmRasterImgEditor.Action1Execute(Sender: TObject);
var
  BitmapWidth, BitmapHeight: Integer;
  IsCompressed: boolean;
  Ent: TEzEntity;
  FileExt: string;
begin
  OpenDialog1.DefaultExt:='bmp';
  OpenDialog1.Filter:= 'Image files|*.bmp;*.tif;*.bil';
  OpenDialog1.InitialDir:= AddSlash(Ez_Preferences.CommonSubDir);
  If Not OpenDialog1.Execute then exit;
  FileExt:= ExtractFileExt(OpenDialog1.FileName);
  If AnsiCompareText(FileExt,'.bmp')=0 then
  begin
    if not GetDIBDimensions( OpenDialog1.FileName,
                             nil,
                             BitmapWidth,
                             BitmapHeight,
                             IsCompressed ) or IsCompressed then Exit;
  end else If AnsiCompareText(FileExt,'.tif')=0 then
  begin
{$IFDEF USE_GRAPHICEX}
    If Not GetTiffDimensions( OpenDialog1.FileName, Nil, BitmapWidth, BitmapHeight, IsCompressed ) Then Exit;
{$ENDIF}
  end else If AnsiCompareText(FileExt,'.bil')=0 then
  begin
    If Not GetBILDimensions( OpenDialog1.FileName, BitmapWidth, BitmapHeight ) Then Exit;
  end;
  DefineCaption;
  Self.Caption:= Self.Caption + Format('- Image Width %d, Height %d',[BitmapWidth, BitmapHeight]);

  CreateNewEditor(OpenDialog1.FileName);
  GeorefImage1.ImageName:= ExtractFileName(OpenDialog1.FileName);  // save only the file name

  Ent:= TEzBandsBitmap.CreateEntity(Point2D(0,0),
                                      Point2D(BitmapWidth, -BitmapHeight),
                                      ExtractFilename(OpenDialog1.FileName) );
  try
    DrawBox1.AddEntity('',Ent);
  finally
    Ent.Free;
  end;
  GIS1.UpdateExtension;
  DrawBox1.ZoomToExtension;
  DefineCaption;
end;

procedure TfrmRasterImgEditor.Action2Execute(Sender: TObject);
begin
  OpenDialog1.DefaultExt:= 'GRI';
  OpenDialog1.Filter:= 'Georeferenced Images (*.GRI)|*.GRI';
  OpenDialog1.InitialDir:= AddSlash(Ez_Preferences.CommonSubDir);
  If not OpenDialog1.Execute then Exit;
  If AnsiCompareText(ExtractFilePath(OpenDialog1.FileName), AddSlash(Ez_Preferences.CommonSubDir)) <> 0 then
  begin
    Showmessage('Wrong subdirectory');
    exit;
  end;
  OpenGeorefFile(OpenDialog1.FileName);
  DrawBox1.ZoomToExtension;
end;

procedure TfrmRasterImgEditor.Action3Execute(Sender: TObject);
var
  Ent: TEzEntity;
  Layer: TEzBaseLayer;
begin
  GeorefImage1.GeorefPoints.Clear;
  Layer:= GIS1.Layers[0]; if Layer=nil then Exit;
  Layer.First;
  while not Layer.Eof do
  begin
    try
      if Layer.RecIsDeleted then Continue;
      Ent:= Layer.RecLoadEntity;
      if Ent=nil then Continue;
      try
        if Ent.EntityID=idPlace then
        begin
          with GeorefImage1.GeorefPoints.Add do
          begin
            XPixel := Round(Ent.Points[0].X);
            YPixel := Round(-Ent.Points[0].Y);
            Layer.DBTable.Recno:= Layer.Recno;
            XWorld:= Layer.DBTable.FloatGet('X');
            YWorld:= Layer.DBTable.FloatGet('Y');
          end;
        end;
      finally
        Ent.Free;
      end;
    finally
      Layer.Next;
    end;
  end;
  { now save the file }
  SaveGeorefFile(GeorefImage1.FileName);
end;

procedure TfrmRasterImgEditor.Action4Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmRasterImgEditor.Action5Execute(Sender: TObject);
begin
  DrawBox1.Undo.Undo;
  DrawBox1.Repaint;
end;

procedure TfrmRasterImgEditor.Action6Execute(Sender: TObject);
begin
  DrawBox1.DeleteSelection;
end;

procedure TfrmRasterImgEditor.Action7Execute(Sender: TObject);
var
  BitmapWidth, BitmapHeight: integer;
  IsCompressed: boolean;
  Subd: string;
  Ent: TEzEntity;
  I: Integer;
  P: TEzPoint;
begin
  Subd:= AddSlash(Ez_Preferences.CommonSubDir);
  if not FileExists(Subd + GeorefImage1.ImageName) then Exit;
  if not GetDIBDimensions( Subd + GeorefImage1.ImageName,
                           nil,
                           BitmapWidth,
                           BitmapHeight,
                           IsCompressed ) or IsCompressed then Exit;
  for I:= 1 to 4 do
  begin
    case I of
      1: P:= Point2D(0,0);
      2: P:= Point2D(BitmapWidth,0);
      3: P:= Point2D(BitmapWidth,-BitmapHeight);
      4: P:= Point2D(0,-BitmapHeight);
    end;
    Ent:= TEzPlace.CreateEntity(P);
    try
      TEzPlace(Ent).Symboltool.Height:=DrawBox1.Grapher.getrealsize(Ez_Preferences.DefSymbolStyle.height);
      DrawBox1.AddEntity('',Ent);
    finally
      Ent.Free;
    end;
  end;
  DrawBox1.Repaint;
end;

procedure TfrmRasterImgEditor.Action8Execute(Sender: TObject);
begin
  DrawBox1.Repaint;
end;

procedure TfrmRasterImgEditor.Action9Execute(Sender: TObject);
var
  Subd: string;
  BitmapWidth, BitmapHeight: integer;
  IsCompressed: Boolean;
begin
  Subd:= AddSlash(Ez_Preferences.CommonSubDir);

  if not FileExists(Subd + GeorefImage1.ImageName) then Exit;

  if not GetDIBDimensions( Subd + GeorefImage1.ImageName,
                           nil,
                           BitmapWidth,
                           BitmapHeight,
                           IsCompressed) or IsCompressed then Exit;
  with DrawBox1 do
    SetViewTo(0, -ClientHeight, ClientWidth, 0);
end;

procedure TfrmRasterImgEditor.Action19Execute(Sender: TObject);
begin
  if Action19.Checked then
    DrawBox1.ScrollBars:= ssBoth
  else
    DrawBox1.ScrollBars:= ssNone;
end;

procedure TfrmRasterImgEditor.Action10Execute(Sender: TObject);
begin
  DrawBox1.GridInfo.ShowGrid:= Action10.Checked;
  DrawBox1.Refresh;
end;

procedure TfrmRasterImgEditor.Action11Execute(Sender: TObject);
begin
  DrawBox1.GridInfo.SnapToGrid:=Action11.Checked;
  DrawBox1.Refresh;
end;

procedure TfrmRasterImgEditor.Action12Execute(Sender: TObject);
begin
  DrawBox1.GridInfo.DrawAsCross:=Action12.Checked;
  DrawBox1.Refresh;
end;

procedure TfrmRasterImgEditor.Action13Execute(Sender: TObject);
begin
  with DrawBox1.GridInfo do
  begin
    Grid.X:= TAction(Sender).Tag;
    Grid.Y:= Grid.X;
    GridSnap.X:= Grid.X;
    GridSnap.Y:= Grid.X;
  end;
  DrawBox1.Refresh;
end;

procedure TfrmRasterImgEditor.Action20Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdSymbol, '');
end;

procedure TfrmRasterImgEditor.Action21Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  Launcher1.TrackEntityClick('CLICKIT','',True);  // ''= ALL LAYERS
end;

procedure TfrmRasterImgEditor.Action22Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdMove,'');
end;

procedure TfrmRasterImgEditor.Action23Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdHandScroll,'');
end;

procedure TfrmRasterImgEditor.Action24Execute(Sender: TObject);
begin
  DrawBox1.ZoomToExtension;
end;

procedure TfrmRasterImgEditor.Action25Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomIn,'');
end;

procedure TfrmRasterImgEditor.Action26Execute(Sender: TObject);
begin
  CmdLine1.Clear ;
  DrawBox1.Cursor := crDefault ;
end;

procedure TfrmRasterImgEditor.Action27Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdPolygonSelect,'');
end;

procedure TfrmRasterImgEditor.Action28Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdRealTimeZoomB,'');
end;

procedure TfrmRasterImgEditor.Action29Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomWindow,'');
end;

procedure TfrmRasterImgEditor.Action30Execute(Sender: TObject);
begin
  DrawBox1.ZoomPrevious;
end;

procedure TfrmRasterImgEditor.Action31Execute(Sender: TObject);
begin
  CmdLine1.DoCommand(SCmdZoomOut,'');
end;

procedure TfrmRasterImgEditor.Action32Execute(Sender: TObject);
begin
  CmdLine1.Clear;
  CmdLine1.DoCommand(SCmdSelect,'');
end;

procedure TfrmRasterImgEditor.Action10Update(Sender: TObject);
begin
  Action10.Checked:= DrawBox1.GridInfo.ShowGrid;
end;

procedure TfrmRasterImgEditor.Action11Update(Sender: TObject);
begin
  Action11.Checked:= DrawBox1.GridInfo.SnapToGrid;
end;

procedure TfrmRasterImgEditor.Action12Update(Sender: TObject);
begin
  Action12.Checked:= DrawBox1.GridInfo.DrawAsCross;
end;

procedure TfrmRasterImgEditor.Action19Update(Sender: TObject);
begin
  Action19.Checked:= DrawBox1.ScrollBars<>ssNone;
end;

end.
