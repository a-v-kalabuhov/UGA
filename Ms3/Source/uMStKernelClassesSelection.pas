unit uMStKernelClassesSelection;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

uses
  Classes,
  EzBase, EzBaseGIS;

type
  TEzEntityIDSet = set of TEzEntityID;

  {
    Этот класс позволяет выбирать объекты
    только по определенным слоям и типам объектов.
    метод DoSelect выбирает объекты.
  }
  TmstGUISelector = class
  private
    FLayers: TStringList;
    FEntityIDs: TList;
    function GetActiveLayers(const Index: Integer): String;
    function GetEntityIDs(const Index: Integer): TEzEntityID;
    function GetLayerCount: Integer;
    function GetEntityIDCount: Integer;
    procedure InternalSelect(DrawBox: TEzBaseDrawBox; Layer: TEzBaseLayer;
      Recno: Integer; var CanUnselect: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddLayer(const LayerName: String);
    procedure AddEntityID(const EntityID: TEzEntityID);
    procedure ClearLayers;
    procedure ClearEntityIDs;
    procedure DeleteLayer(const LayerName: String);
    procedure DeleteEntityID(const EntityID: TEzEntityID);
    procedure DoSelect(const X, Y: Double; DrawBox: TEzBaseDrawBox;
      ClearSelection: Boolean);
    property Layers[const Index: Integer]: String read GetActiveLayers;
    property LayerCount: Integer read GetLayerCount;
    property EntityIDs[const Index: Integer]: TEzEntityID read GetEntityIDs;
    property EntityIDCount: Integer read GetEntityIDCount;
  end;

  function SelectionIsInIDSet(DrawBox: TEzBaseDrawBox; IDs: TEzEntityIDSet): Boolean;

implementation

function SelectionIsInIDSet(DrawBox: TEzBaseDrawBox; IDs: TEzEntityIDSet): Boolean;
var
  I, J: Integer;
  Layer: TEzBaseLayer;
begin
  Result := True;
  for I := 0 to Pred(DrawBox.Selection.Count) do
  begin
    Layer := DrawBox.Selection[I].Layer;
    for J := 0 to Pred(DrawBox.Selection[I].SelList.Count) do
    begin
      Layer.Recno := DrawBox.Selection[I].SelList[J];
      Result := Result and (layer.RecEntityID in IDs);
      if not Result then
        Exit;
    end;
  end;
end;

{ TmstGUISelector }

constructor TmstGUISelector.Create;
begin
  FLayers := TStringLIst.Create;
  FLayers.Duplicates := dupIgnore;
  FEntityIDs := TList.Create;
end;

destructor TmstGUISelector.Destroy;
begin
  FLayers.Free;
  FEntityIDs.Free;
  inherited;
end;

procedure TmstGUISelector.DoSelect(const X, Y: Double;
  DrawBox: TEzBaseDrawBox; ClearSelection: Boolean);
var
  Layer: TEzBaseLayer;
  aRecNo, aPointNumber, I: Integer;
  SelList: TStringList;
  CanUnselect: Boolean;
begin
  if Assigned(DrawBox) then
  begin
    SelList := TStringList.Create;
    if ClearSelection then
      DrawBox.Selection.Clear;
    if DrawBox.PickEntity(X, Y, 0, '', Layer, aRecNo, aPointNumber, SelList) then
    begin
      SelList.Sorted := True;
      CanUnSelect := not ClearSelection;
      for I := 0 to Pred(SelList.Count) do
        if FLayers.IndexOf(SelList[I]) >= 0 then
        begin
          Layer := DrawBox.GIS.Layers.LayerByName(SelList[I]);
          Layer.Recno := Integer(SelList.Objects[I]);
          if FEntityIDs.IndexOf(Pointer(Integer(Layer.RecEntityID))) >= 0 then
          begin
            InternalSelect(DrawBox, Layer, Integer(SelList.Objects[I]), CanUnSelect);
            if ClearSelection then
              if DrawBox.Selection.NumSelected > 0 then
                Break;
          end;
        end;
    end;
    SelList.Free;
  end;
end;

function TmstGUISelector.GetActiveLayers(const Index: Integer): String;
begin
  Result := FLayers[Index];
end;

function TmstGUISelector.GetEntityIDs(const Index: Integer): TEzEntityID;
begin
  Result := TEzEntityID(FEntityIDs[Index]);
end;

function TmstGUISelector.GetEntityIDCount: Integer;
begin
  Result := FEntityIDs.Count;
end;

function TmstGUISelector.GetLayerCount: Integer;
begin
  Result := FLayers.Count;
end;

procedure TmstGUISelector.AddEntityID(const EntityID: TEzEntityID);
var
  I: Integer;
begin
  I := Integer(EntityID);
  if FEntityIDs.IndexOf(Pointer(I)) < 0 then
    FEntityIDs.Add(Pointer(I));
end;

procedure TmstGUISelector.AddLayer(const LayerName: String);
begin
  FLayers.Add(LayerName);
end;

procedure TmstGUISelector.DeleteEntityID(const EntityID: TEzEntityID);
var
  I, J: Integer;
begin
  I := Integer(EntityID);
  J := FEntityIDs.IndexOf(Pointer(I));
  while J >= 0 do
  begin
    FEntityIDs.Delete(J);
    J := FEntityIDs.IndexOf(Pointer(I));
  end;
end;

procedure TmstGUISelector.DeleteLayer(const LayerName: String);
var
  I: Integer;
begin
  I := FLayers.IndexOf(LayerName);
  if I >= 0 then
    FLayers.Delete(I);
end;

procedure TmstGUISelector.InternalSelect(DrawBox: TEzBaseDrawBox;
  Layer: TEzBaseLayer; Recno: Integer; var CanUnSelect: Boolean);
begin
  if not DrawBox.Selection.IsSelected(Layer, Recno) then
    DrawBox.Selection.Add(Layer, Recno)
  else
    if CanUnSelect then
    begin
      CanUnSelect := False;
      DrawBox.Selection.Delete(Layer, Recno);
    end;
end;

procedure TmstGUISelector.ClearEntityIDs;
begin
  FEntityIDs.Clear;
end;

procedure TmstGUISelector.ClearLayers;
begin
  FLayers.Clear;
end;

end.
