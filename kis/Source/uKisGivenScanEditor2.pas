unit uKisGivenScanEditor2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs, ActnList, Buttons, Types, FileCtrl,
  JvBaseDlg, JvDesktopAlert,
  EzBaseGIS, EzBasicCtrls, EzCADCtrls, EzLib, EzEntities, EzBase, EzCmdLine, EzActions,
  VirtualTrees,
  uGC, uGeoUtils, uGeoTypes,
  uEzActionsAutoScroll, uEzEntityCSConvert,
  uKisEntityEditor, uKisConsts, uKisScanOrders, uKisMapScanGeometry, uKisMapClasses, uKisScanAreaFile,
  uKisExceptions;

type
  TKisGivenScanEditor2 = class(TKisEntityEditor)
    Panel1: TPanel;
    DrawBoxMapsGiveOut: TEzDrawBox;
    vstMaps: TVirtualStringTree;
    EzCmdLine1: TEzCmdLine;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    ActionList1: TActionList;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btnFullMap: TSpeedButton;
    btnSquaresMap: TSpeedButton;
    btnFullMapsAll: TButton;
    pnlSquares: TPanel;
    Map25: TCheckBox;
    Map24: TCheckBox;
    Map23: TCheckBox;
    Map22: TCheckBox;
    Map21: TCheckBox;
    Map20: TCheckBox;
    Map19: TCheckBox;
    Map18: TCheckBox;
    Map17: TCheckBox;
    Map16: TCheckBox;
    Map15: TCheckBox;
    Map14: TCheckBox;
    Map13: TCheckBox;
    Map12: TCheckBox;
    Map11: TCheckBox;
    Map10: TCheckBox;
    Map9: TCheckBox;
    Map8: TCheckBox;
    Map7: TCheckBox;
    Map6: TCheckBox;
    Map5: TCheckBox;
    Map4: TCheckBox;
    Map3: TCheckBox;
    Map2: TCheckBox;
    Map1: TCheckBox;
    Label1: TLabel;
    cbAlpha: TComboBox;
    btnArea: TSpeedButton;
    lblCoords: TLabel;
    Label2: TLabel;
    edArea: TEdit;
    SpeedButton4: TSpeedButton;
    procedure vstMapsCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      out EditLink: IVTEditLink);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFullMapsAllClick(Sender: TObject);
    procedure vstMapsAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure Map1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vstMapsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DrawBoxMapsGiveOutMouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
      WY: Double);
    procedure DrawBoxMapsGiveOutBeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; var CanSelect: Boolean);
    procedure btnFullMapClick(Sender: TObject);
    procedure btnSquaresMapClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnAreaClick(Sender: TObject);
    procedure DrawBoxMapsGiveOutMouseLeave(Sender: TObject);
    procedure DrawBoxMapsGiveOutMouseMove2D(Sender: TObject; Shift: TShiftState; X, Y: Integer; const WX, WY: Double);
    procedure DrawBoxMapsGiveOutMouseEnter(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private type
    TComboEditLink = class(TInterfacedObject, IVTEditLink)
    private
      FColumn: Integer;
      FEdit: TComboBox;
      FForm: TKisGivenScanEditor2;
      FNode: PVirtualNode;
      FTree: TVirtualStringTree;
    private
      function BeginEdit: Boolean; stdcall;
      function CancelEdit: Boolean; stdcall;
      function EndEdit: Boolean; stdcall;
      function GetBounds: TRect; stdcall;
      function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
      procedure ProcessMessage(var Message: TMessage); stdcall;
      procedure SetBounds(R: TRect); stdcall;
    protected
      procedure UpdateComboItems; virtual; abstract;
      procedure UpdateNodeData; virtual; abstract;
      procedure EditCloseUp(Sender: TObject);
      procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    public
      constructor Create(aFrm: TKisGivenScanEditor2);
    end;
    TMapTypeEditLink = class(TComboEditLink)
    protected
      procedure UpdateComboItems; override;
      procedure UpdateNodeData; override;
    end;
    TMapInfo = class
    public
      fNomenclature: string;
      fSquares: TBits;
      fSquareEntities: TIntegerList;
      fFull: Boolean;
    public
      constructor Create(const aNomenclature: string);
      destructor Destroy; override;
      //
      procedure SetAll(Value: Boolean);
    end;
    TMapInfoRec = record
      Map: TMapInfo;
    end;
  private
    fCheckBoxUpdate: Boolean;
    fGis: TEzCAD;
    FMaps: TObjectList;
    FArea: Boolean;
    FAreaPoly: TEzPolygon;
    FLayerSquares: TEzBaseLayer;
    FLayerMap500: TEzBaseLayer;
    FLayerZone: TEzBaseLayer;
    FTargetDir: string;
    function AddMap(const aNomenclature: string): PVirtualNode;
    procedure AddMapToGis(aMap: TMapInfo);
    procedure AddSquaresToGis(aMap: TMapInfo);
    procedure ClearArea();
    procedure DisplayMapsInGis();
    procedure DisplayNodeMapInfo(Node: PVirtualNode);
    procedure FillGeometry(aGeometry: TKisMapScanGeometry);
    function FindMapByNomenclature(aNomenclature: string): TMapInfo;
    function FindMapBySquare(Recno: Integer): TMapInfo;
    function GetSelectedMap(): TMapInfo;
    procedure PrepareGis();
    function ReadAreaFile(CheckLayer, SelectLayer: Boolean): Boolean;
    procedure RemoveSquaresFromGis(aMap: TMapInfo);
    procedure SelectFirstMap();
    procedure UpdateMapControls(aMap: TMapInfo);
    procedure BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode; var CanShow: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
    function CheckAreaPolyPlacement(): Boolean;
    procedure UpdateWorkArea();
    procedure AddAreaPolyToGis();
  public
    class function Execute(ScanOrder: TKisScanOrder; Geometry: TKisMapScanGeometry; out TargetDir: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  uKisMapScans;

const
  GreenColor = $88FF88;
  RedColor = clRed;
  GrayColor = clGray;
  EmptyColor = $7F007F;

  SL_MAP500 = 'MAP500';
  SL_SQUARES = 'SQUARES';
  SL_ZONE = 'ZONE';
  SL_WORK_AREA = 'Граница работ';

procedure TKisGivenScanEditor2.AddAreaPolyToGis;
begin
  FLayerZone.First;
  while not FLayerZone.Eof do
  begin
    if not FLayerZone.RecIsDeleted() then
      FLayerZone.DeleteEntity(FLayerZone.Recno);
    FLayerZone.Next;
  end; 
  FAreaPoly.PenTool.FPenStyle.Style := 1;
  FAreaPoly.PenTool.FPenStyle.Color := clRed;
  FAreaPoly.PenTool.FPenStyle.Width := -2;
  FAreaPoly.BrushTool.FBrushStyle.Pattern := 1;
  FAreaPoly.BrushTool.FBrushStyle.Color := clWhite;

  FLayerZone.AddEntity(FAreaPoly);
  FLayerZone.LayerInfo.Visible := True;
end;

function TKisGivenScanEditor2.AddMap(const aNomenclature: string): PVirtualNode;
var
  Data: ^TMapInfoRec;
begin
  Result := vstMaps.AddChild(nil);
  Data := vstMaps.GetNodeData(Result);
  Data.Map := TMapInfo.Create(aNomenclature);
  FMaps.Add(Data.Map);
  Data.Map.fFull := False;
  Data.Map.SetAll(False);
end;

procedure TKisGivenScanEditor2.AddMapToGis(aMap: TMapInfo);
var
  MapEnt: TEzEntity;
begin
  aMap.fSquareEntities.Clear;
  // добавляем объекты для кусочков
  if not aMap.fFull then
    AddSquaresToGis(aMap);
  // добавляем объект для планшета
  MapEnt := GetMap500Entity(aMap.fNomenclature, RedColor);
  try
    FLayerMap500.AddEntity(MapEnt);
  finally
    MapEnt.Free;
  end;
end;

procedure TKisGivenScanEditor2.AddSquaresToGis(aMap: TMapInfo);
var
  I: Integer;
  SquareEnt: TEzEntity;
  Rn: Integer;
begin
  aMap.fSquareEntities.Clear;
  for I := 1 to 25 do
  begin
    SquareEnt := GetMap500SquareEntity(aMap.fNomenclature, I, GrayColor, clNone);
    try
      Rn := FLayerSquares.AddEntity(SquareEnt);
      aMap.fSquareEntities.Add(Rn);
    finally
      SquareEnt.Free;
    end;
  end;
end;

procedure TKisGivenScanEditor2.BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  Entity: TEzEntity; Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode;
  var CanShow: Boolean; var EntList: TEzEntityList; var AutoFree: Boolean);
var
  Square: TEzSquareText;
  I: Integer;
  Accepted: Boolean;
  Map: TMapInfo;
begin
  if Layer.Name = SL_SQUARES then
  begin
    if Entity.EntityID = idSquareText then
    begin
      I := 0;
      Square := TEzSquareText(Entity);
      TryStrToInt(Square.Caption, I);
      if (I > 0) and (I <= 25) then
      begin
        Map := FindMapBySquare(Recno);
        Accepted := Map.fSquares[I - 1];
        if Accepted then
        begin
          Square.PenTool.Color := GrayColor;
          Square.FontTool.Color := GrayColor;
          Square.BrushTool.ForeColor := clWhite;
          Square.BrushTool.BackColor := clWhite;
          Square.BrushTool.Pattern := 1;
        end
        else
        begin
          Square.PenTool.Color := clWhite;
          Square.FontTool.Color := clWhite;
          Square.BrushTool.ForeColor := EmptyColor;
          Square.BrushTool.BackColor := EmptyColor;
          Square.BrushTool.Pattern := 1;
        end;
      end
      else
      begin
        Square.PenTool.Color := RedColor;
        Square.FontTool.Color := RedColor;
        Square.BrushTool.BackColor := clWhite;
        Square.BrushTool.Pattern := 1;
      end;
    end;
  end
  else
  if Layer.Name = SL_MAP500 then
  begin
    if Entity.EntityID = idMap500 then
    begin
      Map := FindMapByNomenclature(TEzMap500Entity(Entity).Nomenclature);
      if Map.fFull then
      begin
        TEzMap500Entity(Entity).BrushTool.ForeColor := clWhite;
        TEzMap500Entity(Entity).BrushTool.BackColor := clWhite;
        TEzMap500Entity(Entity).BrushTool.Pattern := 1;
      end
      else
      begin
//        TEzMap500Entity(Entity).PenTool.Color := clWhite;
//        TEzMap500Entity(Entity).FontTool.Color := clWhite;
        TEzMap500Entity(Entity).BrushTool.ForeColor := clNone;
        TEzMap500Entity(Entity).BrushTool.BackColor := clNone;
        TEzMap500Entity(Entity).BrushTool.Pattern := 0;
      end;
//      if Map = GetSelectedMap() then
//      begin
//        TEzMap500Entity(Entity).PenTool.Color := RedColor;
//        TEzMap500Entity(Entity).PenTool.Width := -2;
//        TEzMap500Entity(Entity).FontTool.Color := RedColor;
//      end
//      else
//      begin
//        TEzMap500Entity(Entity).PenTool.Color := GreenColor;
//        TEzMap500Entity(Entity).PenTool.Width := 0;
//        TEzMap500Entity(Entity).FontTool.Color := GreenColor;
//      end;
    end;
  end;
end;

procedure TKisGivenScanEditor2.btnFullMapsAllClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: ^TMapInfoRec;
begin
  inherited;
  ClearArea();
  //
  Node := vstMaps.GetFirst();
  while Assigned(Node) do
  begin
    Data := vstMaps.GetNodeData(Node);
    if not Data.Map.fFull then
    begin
      Data.Map.fFull := True;
      RemoveSquaresFromGis(Data.Map);
      if vstMaps.Selected[Node] then
        UpdateMapControls(Data.Map);
    end;
    Node := Node.NextSibling;
  end;
  DrawBoxMapsGiveOut.GIS.UpdateExtension();
  DrawBoxMapsGiveOut.ZoomToExtension();
  vstMaps.Invalidate;
  btnFullMap.Enabled := not FArea;
  SpeedButton4.Enabled := FArea;
  UpdateWorkArea();
end;

procedure TKisGivenScanEditor2.btnOkClick(Sender: TObject);
var
  I, J: Integer;
  Map: TMapInfo;
  B: Boolean;
  Geo: TKisMapScanGeometry;
  MapGeo: TKisMapGeometry;
  Skipped: TStringList;
  MsgText: string;
begin
  if FArea then
  begin
    Geo := TKisMapScanGeometry.Create;
    Geo.Forget;
    Skipped := TStringList.Create;
    Skipped.Forget;
    FillGeometry(Geo);
    for I := 0 to fMaps.Count - 1 do
    begin
      Map := TMapInfo(fMaps[I]);
      MapGeo := Geo.GetMapGeometry(Map.fNomenclature);
      if MapGeo.Skip then
        Skipped.Add(Map.fNomenclature);
    end;
    if Skipped.Count > 0 then
    begin
      if Skipped.Count = 1 then
      begin
        MsgText := 'Планшет ' + Skipped[0] + ' не используется.';
      end
      else
      begin
        MsgText := 'Планшеты не используются:' + sLineBreak;
        for I := 0 to Skipped.Count - 1 do
          MsgText := MsgText + Skipped[I] + sLineBreak;
        MsgText := MsgText + sLineBreak;
      end;
      MsgText := MsgText + 'Эти сканы не будут выданы. ' + sLineBreak + 'Продолжить?';
      J := MessageBox(Self.Handle, PChar(MsgText), 'Внимание!', MB_YESNO + MB_ICONWARNING);
      if J <> ID_YES then
        Exit;
    end;
  end
  else
  begin
    for I := 0 to fMaps.Count - 1 do
    begin
      Map := TMapInfo(fMaps[I]);
      if not Map.fFull then
      begin
        B := False;
        for J := 0 to Map.fSquares.Size - 1 do
        begin
          B := Map.fSquares[J];
          if B then
            Break;
        end;
        if not B then
        begin
          ShowMessage('Нет выбранных квадратов на планшете ' + Map.fNomenclature + '!');
          Exit;
        end;
      end;
    end;
  end;
  if SelectDirectory('Куда копировать?', '', FTargetDir) then
    ModalResult := mrOK;
end;

procedure TKisGivenScanEditor2.DisplayMapsInGis;
var
  I: Integer;
  Map: TMapInfo;
begin
  PrepareGis();
  for I := 0 to FMaps.Count - 1 do
  begin
    Map := TMapInfo(FMaps[I]);
    AddMapToGis(Map);
  end;
end;

procedure TKisGivenScanEditor2.DisplayNodeMapInfo(Node: PVirtualNode);
var
  Data: ^TMapInfoRec;
begin
  // показываем параметры карты
  fCheckBoxUpdate := True;
  try
    Data := vstMaps.GetNodeData(Node);
    UpdateMapControls(Data.Map);
  finally
    fCheckBoxUpdate := False;
  end;
end;

class function TKisGivenScanEditor2.Execute(ScanOrder: TKisScanOrder; Geometry: TKisMapScanGeometry; out TargetDir: string): Boolean;
var
  Frm: TKisGivenScanEditor2;
begin
  Frm := TKisGivenScanEditor2.Create(Application);
  try
    Frm.Caption := 'Заявка №' + ScanOrder.OrderNumber + ' от ' + ScanOrder.OrderDate;
    //
    ScanOrder.Maps.First;
    while not ScanOrder.Maps.Eof do
    begin
      Frm.AddMap(ScanOrder.Maps.FieldByName(SF_NOMENCLATURE).AsString);
      ScanOrder.Maps.Next;
    end;
    //
    Frm.DisplayMapsInGis();
    //
    Frm.vstMaps.SortTree(0, sdAscending);
    Frm.SelectFirstMap();
    //
    Result := Frm.ShowModal = mrOk;
    if Result then
    begin
      Frm.FillGeometry(Geometry);
      TargetDir := Frm.FTargetDir; 
    end;
  finally
    FreeAndNil(Frm);
  end;
end;

procedure TKisGivenScanEditor2.DrawBoxMapsGiveOutBeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  var CanSelect: Boolean);
begin
  inherited;
  CanSelect := False;
end;

procedure TKisGivenScanEditor2.DrawBoxMapsGiveOutMouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer; const WX, WY: Double);
var
  ActId: string;
  ScrollAction: TmstAutoHandScrollAction;
  Map: TMapInfo;
  I: Integer;
  Layer: TezBaseLayer;
  Recno: Integer;
  DummyNPt: Integer;
begin
  // скролл по средней кнопке
  if Button = mbMiddle then
  begin
    EzCmdLine1.Clear;
    ActId := EzCmdLine1.CurrentAction.ActionID;
    if ActId <> 'SCROLL' then
      EzCmdLine1.DoCommand('SCROLL', 'SCROLL');
  end
  else
  if Button = mbLeft then
  begin
    // скролл с зажатым контролом
    if ssCtrl in Shift then
    begin
      ScrollAction := TmstAutoHandScrollAction.CreateAction(EzCmdLine1);
      ScrollAction.OnMouseDown(Self, mbLeft, Shift, X, Y, WX, WY);
      EzCmdLine1.Push(TmstAutoHandScrollAction.CreateAction(EzCmdLine1), False, 'AUTOSCROLL', '');
    end
    else
    begin
      // переключаем видимость квадрата по клику на нём
      if EzCmdLine1.CurrentAction is TTheDefaultAction then
      begin
        if FArea then
          Exit;
        if DrawBoxMapsGiveOut.PickEntity(WX, WY, 0, SL_SQUARES, Layer, Recno, DummyNPt, nil) then
        begin
          Map := FindMapBySquare(Recno);
          if Assigned(Map) then
          begin
            I := Map.fSquareEntities.IndexOfValue(Recno);
            Map.fSquares[I] := not Map.fSquares[I];
            DrawBoxMapsGiveOut.RegenDrawing();
            if GetSelectedMap() = Map then
              UpdateMapControls(Map);
            UpdateWorkArea();
          end;
        end;
      end;
    end;
  end;
end;

procedure TKisGivenScanEditor2.DrawBoxMapsGiveOutMouseEnter(Sender: TObject);
begin
  inherited;
  lblCoords.Visible := True;
end;

procedure TKisGivenScanEditor2.DrawBoxMapsGiveOutMouseLeave(Sender: TObject);
begin
  inherited;
  //lblCoords.Visible := False;
end;

procedure TKisGivenScanEditor2.DrawBoxMapsGiveOutMouseMove2D(Sender: TObject; Shift: TShiftState; X, Y: Integer;
  const WX, WY: Double);
begin
  inherited;
  lblCoords.Caption := IntToStr(Round(WY)) + ';' + IntToStr(Round(WX));
end;

procedure TKisGivenScanEditor2.FillGeometry(aGeometry: TKisMapScanGeometry);
var
  I: Integer;
  Map: TMapInfo;
  J: Integer;
  GMap: TKisMapGeometry;
begin
  aGeometry.BackgroundAlpha := cbAlpha.ItemIndex * 10;
  if FArea then
  begin
    aGeometry.Polygon.Assign(FAreaPoly.Points);
    for I := 0 to FMaps.Count - 1 do
    begin
      Map := TMapInfo(FMaps[I]);
      aGeometry.AddMap(Map.fNomenclature, Map.fFull);
    end;
  end
  else
  begin
    for I := 0 to FMaps.Count - 1 do
    begin
      Map := TMapInfo(FMaps[I]);
      GMap := aGeometry.AddMap(Map.fNomenclature, Map.fFull);
      if not Map.fFull then
      begin
        for J := 0 to Map.fSquares.Size - 1 do
          GMap.Squares[J + 1] := Map.fSquares[J];
      end;
    end;
  end;
end;

function TKisGivenScanEditor2.FindMapByNomenclature(aNomenclature: string): TMapInfo;
var
  I: Integer;
  Map: TMapInfo;
begin
  for I := 0 to FMaps.Count - 1 do
  begin
    Map := TmapInfo(FMaps[I]);
    if Map.fNomenclature = aNomenclature then
    begin
      Result := Map;
      Exit;
    end;
  end;
  Result := nil;
end;

function TKisGivenScanEditor2.FindMapBySquare(Recno: Integer): TMapInfo;
var
  I: Integer;
  Idx: Integer;
  Map: TMapInfo;
begin
  for I := 0 to FMaps.Count - 1 do
  begin
    Map := TmapInfo(FMaps[I]);
    Idx := Map.fSquareEntities.IndexOfValue(Recno);
    if Idx >= 0 then
    begin
      Result := Map;
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TKisGivenScanEditor2.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  fMaps := TObjectList.Create;
  for I := 0 to pnlSquares.ControlCount - 1 do
  begin
    if pnlSquares.Controls[I] is TCheckBox then
      TCheckBox(pnlSquares.Controls[I]).OnClick := Map1Click;
  end;  
end;

procedure TKisGivenScanEditor2.FormDestroy(Sender: TObject);
begin
  inherited;
  FMaps.Free;
  FreeAndNil(FAreaPoly);
end;

procedure TKisGivenScanEditor2.FormShow(Sender: TObject);
begin
  inherited;
  DrawBoxMapsGiveOut.ZoomToExtension();
  DrawBoxMapsGiveOut.ZoomOut(97);
end;

function TKisGivenScanEditor2.GetSelectedMap: TMapInfo;
var
  N: PVirtualNode;
  Data: ^TMapInfoRec;
begin
  Result := nil;
  N := vstMaps.GetFirstSelected();
  if Assigned(N) then
  begin
    Data := vstMaps.GetNodeData(N);
    Result := Data.Map;
  end;
end;

procedure TKisGivenScanEditor2.Map1Click(Sender: TObject);
var
  Chb: TCheckBox;
  Idx: Integer;
  Map: TMapInfo;
begin
  inherited;
  if not fCheckBoxUpdate then
  begin
    if Sender is TCheckBox then
    begin
      Chb := TCheckBox(Sender);
      try
        Idx := StrToInt(Chb.Caption) - 1;
        Map := GetSelectedMap();
        Map.fSquares[Idx] := Chb.Checked;
        DrawBoxMapsGiveOut.RegenDrawing();
        UpdateWorkArea();
      finally

      end;
    end;
  end;
end;

procedure TKisGivenScanEditor2.PrepareGis;
begin
  if fGis = nil then
  begin
    fGis := TEzCAD.Create(Self);
    fGis.Active := True;
    FLayerSquares := fGis.CreateLayer(SL_SQUARES, ltMemory);
    FLayerZone := fGis.CreateLayer(SL_ZONE, ltMemory);
    FLayerMap500 := fGis.CreateLayer(SL_MAP500, ltMemory);
    fGis.OnBeforePaintEntity := BeforePaintEntity;
    DrawBoxMapsGiveOut.GIS := fGis;
  end;
end;

function TKisGivenScanEditor2.ReadAreaFile(CheckLayer, SelectLayer: Boolean): Boolean;
var
  Poly: TEzPolygon;
  Reader: TKisScanAreaFile;
  I: Integer;
begin
  Result := False;
  // загружаем область из файла
  if SelectLayer then    
    Reader := TKisScanAreaFileMultipleLayers.Create
  else
    Reader := TKisScanAreaFileSingleLayer.Create;
  try
    Poly := Reader.ReadPoly();
  finally
    Reader.Free;
  end;
  if Poly <> nil then
  begin
    // TODO : добавить проверку, что область работ пересекается с планшетами
    // добавляем область в слой, она должна быть поверх заливки фоном
    FreeAndNil(FAreaPoly);
    FAreaPoly := Poly.Clone as TEzPolygon;
    if not CheckAreaPolyPlacement() then
    begin
      I := MessageBox(0,
              PChar('Область работ находится за пределами выбранных планшетов!' +
                    sLineBreak +
                    'Всё равно открыть этот файл?'),
              PChar('Внимание!'),
              MB_YESNO + MB_ICONQUESTION
           );
      if I = ID_NO then
        Exit;
    end;
    //
    AddAreaPolyToGis();
    Result := True;
  end;
end;

procedure TKisGivenScanEditor2.RemoveSquaresFromGis(aMap: TMapInfo);
var
  I: Integer;
  Rn: Integer;
begin
  for I := 0 to aMap.fSquareEntities.Count - 1 do
  begin
    Rn := aMap.fSquareEntities[I];
    FLayerSquares.DeleteEntity(Rn);
  end;
  aMap.fSquareEntities.Clear;
end;

procedure TKisGivenScanEditor2.SelectFirstMap;
var
  Node: PVirtualNode;
begin
  Node := vstMaps.GetFirst();
  vstMaps.Selected[Node] := True;
end;

procedure TKisGivenScanEditor2.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  DrawBoxMapsGiveOut.ZoomIn(95);
end;

procedure TKisGivenScanEditor2.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  DrawBoxMapsGiveOut.ZoomOut(95);
end;

procedure TKisGivenScanEditor2.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  DrawBoxMapsGiveOut.GIS.UpdateExtension;
  DrawBoxMapsGiveOut.ZoomToExtension;
end;

procedure TKisGivenScanEditor2.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  if Assigned(FAreaPoly) and FArea then
  begin
    TEzCSConverter.ExchangeXY(FAreaPoly);
    AddAreaPolyToGis();
    DrawBoxMapsGiveOut.GIS.UpdateExtension;
    DrawBoxMapsGiveOut.ZoomToExtension;
  end;
end;

procedure TKisGivenScanEditor2.btnFullMapClick(Sender: TObject);
var
  Map: TMapInfo;
begin
  inherited;
  Map := GetSelectedMap();
  if Assigned(Map) then
  begin
    FArea := False;
    SpeedButton4.Enabled := FArea;
    if not Map.fFull then
    begin
      Map.fFull := True;
      RemoveSquaresFromGis(Map);
      DrawBoxMapsGiveOut.RegenDrawing();
      UpdateMapControls(Map);
      vstMaps.Invalidate;
      UpdateWorkArea();
    end;
  end;
end;

procedure TKisGivenScanEditor2.btnSquaresMapClick(Sender: TObject);
var
  Map: TMapInfo;
  Node: PVirtualNode;
  Data: ^TMapInfoRec;
begin
  inherited;
  if FArea then
  begin
    ClearArea();
    //
    FArea := False;
    Node := vstMaps.GetFirst();
    while Assigned(Node) do
    begin
      Data := vstMaps.GetNodeData(Node);
      Data.Map.fFull := False;
      AddSquaresToGis(Data.Map);
      Node := Node.NextSibling;
    end;
  end;
  //
  Map := GetSelectedMap();
  if Assigned(Map) and Map.fFull then
  begin
    Map.fFull := False;
    AddSquaresToGis(Map);
    UpdateMapControls(Map);
  end;
  btnFullMap.Enabled := not FArea;
  SpeedButton4.Enabled := FArea;
  vstMaps.Invalidate;
  DrawBoxMapsGiveOut.GIS.UpdateExtension();
  DrawBoxMapsGiveOut.ZoomToExtension();
//  DrawBoxMapsGiveOut.RegenDrawing();
  UpdateWorkArea();
end;

function TKisGivenScanEditor2.CheckAreaPolyPlacement: Boolean;
var
  I: Integer;
  Map: TMapInfo;
  N: TNomenclature;
  R0: TRect;
  Ri: TRect;
begin
//  raise Exception.Create('TKisGivenScanEditor2.CheckAreaPolyPlacement');
  Result := False;
  // ищем область покрытия планшетами
  Map := TMapInfo(fMaps[0]);
  N.Init(Map.fNomenclature, False);
  R0 := N.Bounds();
  for I := 1 to FMaps.Count - 1 do
  begin
    Map := TMapInfo(fMaps[I]);
    N.Init(Map.fNomenclature, False);
    Ri := N.Bounds();
    if R0.Left > Ri.Left then
      R0.Left := Ri.Left;
    if R0.Bottom > Ri.Bottom then
      R0.Bottom := Ri.Bottom;
    if R0.Top < Ri.Top then
      R0.Top := Ri.Top;
    if R0.Right < Ri.Right then
      R0.Right := Ri.Right;
  end;
  // проверяем, что область работ пересекается с планшетами
  if  (FAreaPoly.FBox.xmax < R0.Left)
      or
      (FAreaPoly.FBox.xmin > R0.Right)
      or
      (FAreaPoly.FBox.ymax < R0.Bottom)
      or
      (FAreaPoly.FBox.ymin > R0.Top)
  then
    Exit;
  Result := True;
end;

procedure TKisGivenScanEditor2.ClearArea;
begin
  // удаляем всё что есть в слое границ работ
  FLayerZone.First;
  while not FLayerZone.Eof do
  begin
    if not FLayerZone.RecIsDeleted then
      FLayerZone.DeleteEntity(FLayerZone.Recno);
    FLayerZone.Next;
  end;
  FArea := False;
  SpeedButton4.Enabled := FArea;
  FreeAndNil(FAreaPoly);
end;

procedure TKisGivenScanEditor2.btnAreaClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: ^TMapInfoRec;
begin
  inherited;
  // загружаем область из файла
  if not ReadAreaFile(False, True) then
    Exit;
  // для всех планшетов ставим признак "область"
  // обновляем элементы управления
  FArea := True;
  Node := vstMaps.GetFirst();
  while Assigned(Node) do
  begin
    Data := vstMaps.GetNodeData(Node);
    Data.Map.fFull := False;
    RemoveSquaresFromGis(Data.Map);
    if vstMaps.Selected[Node] then
      UpdateMapControls(Data.Map);
    Node := Node.NextSibling;
  end;
  DrawBoxMapsGiveOut.GIS.UpdateExtension();
  DrawBoxMapsGiveOut.ZoomToExtension();
//  DrawBoxMapsGiveOut.RegenDrawing();
  vstMaps.Invalidate;
  btnFullMap.Enabled := not FArea;
  SpeedButton4.Enabled := FArea;
  UpdateWorkArea();
end;

procedure TKisGivenScanEditor2.UpdateMapControls;
var
  I: Integer;
  Chb: TCheckBox;
  ChbName: string;
  Ctrl: TControl;
begin
  // показываем параметры карты
  fCheckBoxUpdate := True;
  try
    pnlSquares.Visible := (not aMap.fFull) and not FArea;
    if pnlSquares.Visible then
    begin
      for I := 0 to aMap.fSquares.Size - 1 do
      begin
        ChbName := 'Map' + IntToStr(Succ(I));
        Ctrl := pnlSquares.FindChildControl(ChbName);
        Chb := Ctrl as TCheckBox;
        Chb.Checked := aMap.fFull or aMap.fSquares[I];
      end;
    end;
  finally
    fCheckBoxUpdate := False;
  end;
  SpeedButton4.Enabled := FArea;
end;

procedure TKisGivenScanEditor2.UpdateWorkArea;
var
  I: Integer;
  Area: Double;
  Map: TMapInfo;
  J: Integer;
  N: TNomenclature;
  EzR: TEzEntity;
  TempEnt: TEzEntity;
begin
  Area := 0;
  for I := 0 to FMaps.Count - 1 do
  begin
    Map := TMapInfo(fMaps[I]);
    if Map.fFull then
      Area := Area + 250 * 250
    else
    if FArea then
    begin
      N.Init(Map.fNomenclature, False);
      EzR := TEzRectangle.CreateEntity(N.Bounds());
      try
        TempEnt := DrawBoxMapsGiveOut.GIS.EntityIntersect(EzR, FAreaPoly);
        if Assigned(TempEnt) then
        try
          Area := Area + TempEnt.Area;
        finally
          TempEnt.Free;
        end;
      finally
        EzR.Free;
      end;
    end
    else
    begin
      for J := 0 to Map.fSquares.Size - 1 do
        if Map.fSquares[J] then
          Area := Area + 2500;
    end;
  end;
  if Area = 0 then
    edArea.Text := '-'
  else
    edArea.Text := IntToStr(Round(Area)) + ' кв.м.';
end;

procedure TKisGivenScanEditor2.vstMapsAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  inherited;
  DisplayNodeMapInfo(Node);
//  EzDrawBox1.RegenDrawing();
end;

procedure TKisGivenScanEditor2.vstMapsCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  out EditLink: IVTEditLink);
begin
  EditLink := nil;
  if FArea then
    Exit;
  if Column = 1 then
    EditLink := TMapTypeEditLink.Create(Self);
end;

procedure TKisGivenScanEditor2.vstMapsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  Data: ^TMapInfoRec;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
  0 :
      begin
        CellText := Data.Map.fNomenclature;
      end;
  1 :
      begin
//      FEdit.Items.Add('Планшет целиком');
//      FEdit.Items.Add('По квадратам');
//      FEdit.Items.Add('Область на карте');
        if FArea then
          CellText := 'Область работ'
        else
        if Data.Map.fFull then
          CellText := 'Планшет целиком'
        else
          CellText := 'По квадратам';
      end;
  end;
end;

{ TKisGivenScanEditor2.TComboEditLink }

function TKisGivenScanEditor2.TComboEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TKisGivenScanEditor2.TComboEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

constructor TKisGivenScanEditor2.TComboEditLink.Create(aFrm: TKisGivenScanEditor2);
begin
  inherited Create;
  FForm := aFrm;
end;

procedure TKisGivenScanEditor2.TComboEditLink.EditCloseUp(Sender: TObject);
begin
  FTree.EndEditNode;
end;

procedure TKisGivenScanEditor2.TComboEditLink.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
begin
  CanAdvance := True;
  case Key of
    VK_ESCAPE:
      begin
        Key := 0;//ESC will be handled in EditKeyUp()
      end;
    VK_RETURN:
      if CanAdvance then
      begin
        FTree.EndEditNode;
        Key := 0;
      end;
    VK_UP, VK_DOWN:
      begin
        CanAdvance := Shift = [];
        CanAdvance := CanAdvance and not FEdit.DroppedDown;
        if CanAdvance then
        begin
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

procedure TKisGivenScanEditor2.TComboEditLink.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
  end;
end;

function TKisGivenScanEditor2.TComboEditLink.EndEdit: Boolean;
begin
  Result := True;
  UpdateNodeData;
  FTree.InvalidateNode(FNode);
  FEdit.Hide;
  FTree.SetFocus;
end;

function TKisGivenScanEditor2.TComboEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

function TKisGivenScanEditor2.TComboEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex): Boolean;
var
  Txt: WideString;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FEdit := TComboBox.Create(nil);
  FEdit.Parent := Tree;
  FEdit.Visible := False;
  FEdit.Style := csDropDownList;
  FEdit.OnKeyDown := EditKeyDown;
  FEdit.OnKeyUp := EditKeyUp;
  FEdit.OnCloseUp := EditCloseUp;
  UpdateComboItems;
  //
  Txt := '';
  FTree.OnGetText(FTree, Node, Column, ttNormal, Txt);
  FEdit.ItemIndex := FEdit.Items.IndexOf(Txt);
end;

procedure TKisGivenScanEditor2.TComboEditLink.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TKisGivenScanEditor2.TComboEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

{ TKisGivenScanEditor2.TMapTypeEditLink }

procedure TKisGivenScanEditor2.TMapTypeEditLink.UpdateComboItems;
begin
  inherited;
  FEdit.Items.Add('Планшет целиком');
  FEdit.Items.Add('По квадратам');
//  FEdit.Items.Add('Область работ');
end;

procedure TKisGivenScanEditor2.TMapTypeEditLink.UpdateNodeData;
var
  Data: ^TMapInfoRec;
begin
  inherited;
  Data := FTree.GetNodeData(FNode);
  case FEdit.ItemIndex of
  0 :
      begin
        Data.Map.fFull := True;
        FForm.RemoveSquaresFromGis(Data.Map);
      end;
  1:
      begin
        Data.Map.fFull := False;
        FForm.AddSquaresToGis(Data.Map);
      end;
  else
      begin
        Data.Map.fFull := False;
        FForm.AddSquaresToGis(Data.Map);
      end;
  end;
  if FTree.Selected[FNode] then
    FForm.UpdateMapControls(Data.Map);
  FForm.DrawBoxMapsGiveOut.RegenDrawing();
  FForm.UpdateWorkArea();
end;

{ TKisGivenScanEditor2.TMapInfo }

constructor TKisGivenScanEditor2.TMapInfo.Create;
begin
  fSquareEntities := TIntegerList.Create;
  fSquares := TBits.Create;
  fSquares.Size := 25;
  fNomenclature := aNomenclature;
end;

destructor TKisGivenScanEditor2.TMapInfo.Destroy;
begin
  fSquares.Free;
  fSquareEntities.Free;
  inherited;
end;

procedure TKisGivenScanEditor2.TMapInfo.SetAll;
var
  i: Integer;
begin
  for I := 0 to fSquares.Size - 1 do
    fSquares.Bits[I] := Value;
end;

end.

