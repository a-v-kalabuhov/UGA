unit uKisGivenScanEditor2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uKisEntityEditor, StdCtrls, ExtCtrls, Contnrs, ActnList, Buttons,
  JvBaseDlg, JvDesktopAlert,
  EzBaseGIS, EzBasicCtrls, EzCADCtrls, EzLib, EzEntities, EzBase, EzCmdLine, EzActions,
  VirtualTrees,
  uKisConsts, uKisScanOrders, uKisMapScanGeometry, uKisMapClasses,
  uMStGISEzActionsAutoScroll;

type
  TKisGivenScanEditor2 = class(TKisEntityEditor)
    Panel1: TPanel;
    EzDrawBox1: TEzDrawBox;
    vstMaps: TVirtualStringTree;
    EzCmdLine1: TEzCmdLine;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    ActionList1: TActionList;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    btnAllUnchanged: TButton;
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
    procedure vstMapsCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      out EditLink: IVTEditLink);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAllUnchangedClick(Sender: TObject);
    procedure vstMapsAddToSelection(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure Map1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vstMapsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EzDrawBox1MouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; const WX,
      WY: Double);
    procedure EzDrawBox1BeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; var CanSelect: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
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
    function AddMap(const aNomenclature: string): PVirtualNode;
    procedure AddMapToGis(aMap: TMapInfo);
    procedure AddSquaresToGis(aMap: TMapInfo);
    procedure DisplayMapsInGis();
    procedure DisplayNodeMapInfo(Node: PVirtualNode);
    procedure FillGeometry(aGeometry: TKisMapScanGeometry);
    function FindMapByNomenclature(aNomenclature: string): TMapInfo;
    function FindMapBySquare(Recno: Integer): TMapInfo;
    function GetSelectedMap(): TMapInfo;
    procedure PrepareGis();
    procedure RemoveSquaresFromGis(aMap: TMapInfo);
    procedure SelectFirstMap();
    procedure UpdateMapControls(aMap: TMapInfo);
    procedure BeforePaintEntity(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer; Entity: TEzEntity;
      Grapher: TEzGrapher; Canvas: TCanvas; const Clip: TEzRect; DrawMode: TEzDrawMode; var CanShow: Boolean;
      var EntList: TEzEntityList; var AutoFree: Boolean);
  public
    class function Execute(ScanOrder: TKisScanOrder; Geometry: TKisMapScanGeometry): Boolean;
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
  L1: TEzBaseLayer;
begin
  aMap.fSquareEntities.Clear;
  // добавляем объекты для кусочков
  if not aMap.fFull then
    AddSquaresToGis(aMap);
  // добавляем объект для планшета
  L1 := fGis.Layers.LayerByName(SL_MAP500);
  MapEnt := GetMap500Entity(aMap.fNomenclature, RedColor);
  try
    L1.AddEntity(MapEnt);
  finally
    MapEnt.Free;
  end;
end;

procedure TKisGivenScanEditor2.AddSquaresToGis(aMap: TMapInfo);
var
  Layer: TEzBaseLayer;
  I: Integer;
  SquareEnt: TEzEntity;
  Rn: Integer;
begin
  aMap.fSquareEntities.Clear;
  Layer := fGis.Layers.LayerByName(SL_SQUARES);
  for I := 1 to 25 do
  begin
    SquareEnt := GetMap500SquareEntity(aMap.fNomenclature, I, GrayColor, clNone);
    try
      Rn := Layer.AddEntity(SquareEnt);
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

procedure TKisGivenScanEditor2.btnAllUnchangedClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: ^TMapInfoRec;
begin
  inherited;
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
  EzDrawBox1.RegenDrawing();
  vstMaps.Invalidate;
end;

procedure TKisGivenScanEditor2.btnOkClick(Sender: TObject);
var
  I, J: Integer;
  Map: TMapInfo;
  B: Boolean;
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

class function TKisGivenScanEditor2.Execute(ScanOrder: TKisScanOrder; Geometry: TKisMapScanGeometry): Boolean;
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
      Frm.FillGeometry(Geometry);
  finally
    FreeAndNil(Frm);
  end;
end;

procedure TKisGivenScanEditor2.EzDrawBox1BeforeSelect(Sender: TObject; Layer: TEzBaseLayer; Recno: Integer;
  var CanSelect: Boolean);
begin
  inherited;
  CanSelect := False;
end;

procedure TKisGivenScanEditor2.EzDrawBox1MouseDown2D(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
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
  if (Button = mbMiddle) then
  begin
    EzCmdLine1.Clear;
    ActId := EzCmdLine1.CurrentAction.ActionID;
    if ActId <> 'SCROLL' then
      EzCmdLine1.DoCommand('SCROLL', 'SCROLL');
  end
  else
  if Button = mbLeft then
  begin
    if ssCtrl in Shift then
    begin
      ScrollAction := TmstAutoHandScrollAction.CreateAction(EzCmdLine1);
      ScrollAction.OnMouseDown(Self, mbLeft, Shift, X, Y, WX, WY);
      EzCmdLine1.Push(TmstAutoHandScrollAction.CreateAction(EzCmdLine1), False, 'AUTOSCROLL', '');
    end
    else
    begin
      if EzCmdLine1.CurrentAction is TTheDefaultAction then
      begin
        if EzDrawBox1.PickEntity(WX, WY, 0, SL_SQUARES, Layer, Recno, DummyNPt, nil) then
        begin
          Map := FindMapBySquare(Recno);
          if Assigned(Map) then
          begin
            I := Map.fSquareEntities.IndexOfValue(Recno);
            Map.fSquares[I] := not Map.fSquares[I];
            EzDrawBox1.RegenDrawing();
            if GetSelectedMap() = Map then
              UpdateMapControls(Map);
          end;
        end;
      end;
    end;
  end;
end;

procedure TKisGivenScanEditor2.FillGeometry(aGeometry: TKisMapScanGeometry);
var
  I: Integer;
  Map: TMapInfo;
  J: Integer;
  GMap: TKisMapGeometry;
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
end;

procedure TKisGivenScanEditor2.FormShow(Sender: TObject);
begin
  inherited;
  EzDrawBox1.ZoomToExtension();
  EzDrawBox1.ZoomOut(97);
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
        EzDrawBox1.RegenDrawing();
      finally

      end;
    end;
  end;
end;

procedure TKisGivenScanEditor2.PrepareGis;
var
  L1, L2, L3: TEzBaseLayer;
begin
  if fGis = nil then
  begin
    fGis := TEzCAD.Create(Self);
    fGis.Active := True;
    L3 := fGis.CreateLayer(SL_ZONE, ltMemory);
    L2 := fGis.CreateLayer(SL_SQUARES, ltMemory);
    L1 := fGis.CreateLayer(SL_MAP500, ltMemory);
    fGis.OnBeforePaintEntity := BeforePaintEntity;
    EzDrawBox1.GIS := fGis;
  end;
end;

procedure TKisGivenScanEditor2.RemoveSquaresFromGis(aMap: TMapInfo);
var
  Layer: TEzBaseLayer;
  I: Integer;
  Rn: Integer;
begin
  Layer := fGis.Layers.LayerByName(SL_SQUARES);
  for I := 0 to aMap.fSquareEntities.Count - 1 do
  begin
    Rn := aMap.fSquareEntities[I];
    Layer.DeleteEntity(Rn);
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
  EzDrawBox1.ZoomIn(95);
end;

procedure TKisGivenScanEditor2.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  EzDrawBox1.ZoomOut(95);
end;

procedure TKisGivenScanEditor2.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  EzDrawBox1.ZoomToExtension;
end;

procedure TKisGivenScanEditor2.SpeedButton4Click(Sender: TObject);
var
  Map: TMapInfo;
begin
  inherited;
  Map := GetSelectedMap();
  if Assigned(Map) and not Map.fFull then
  begin
    Map.fFull := True;
    RemoveSquaresFromGis(Map);
    EzDrawBox1.RegenDrawing();
    UpdateMapControls(Map);
    vstMaps.Invalidate;
  end;
end;

procedure TKisGivenScanEditor2.SpeedButton5Click(Sender: TObject);
var
  Map: TMapInfo;
begin
  inherited;
  Map := GetSelectedMap();
  if Assigned(Map) and Map.fFull then
  begin
    Map.fFull := False;
    AddSquaresToGis(Map);
    EzDrawBox1.RegenDrawing();
    UpdateMapControls(Map);
    vstMaps.Invalidate;
  end;
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
    pnlSquares.Visible := not aMap.fFull;
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
//  FEdit.Items.Add('Область на карте');
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
  else
      begin
        Data.Map.fFull := False;
        FForm.AddSquaresToGis(Data.Map);
      end;
  end;
  if FTree.Selected[FNode] then
    FForm.UpdateMapControls(Data.Map);
  FForm.EzDrawBox1.RegenDrawing();
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

