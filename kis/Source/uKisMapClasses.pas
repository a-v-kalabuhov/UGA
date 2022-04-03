unit uKisMapClasses;

interface

uses
  SysUtils, Classes, DB, Contnrs, Graphics, 
  //
  EzBaseGIS, EzEntities,
  //
  uGeoUtils;

type
  TKisMapImage = class
  private
    FName: String;
    FId: Integer;
    FFileName: String;
  public
    property Id: Integer read FId write FId;
    property FileName: String read FFileName write FFileName;
    property Name: String read FName write FName;
  end;

  TKisMapImageList = class(TObjectList)
  private
    function GetItems(Index: Integer): TKisMapImage;
    procedure SetItems(Index: Integer; const Value: TKisMapImage);
  public
    procedure AddMapImage(Id: Integer; const Name, FileName: String);
    //
    property Items[Index: Integer]: TKisMapImage read GetItems write SetItems; default;
  end;

  TKisLayer = class
  private
    FCaption: String;
    FName: String;
    FPosition: Integer;
    FLayerType: TEzLayerType;
    FVisible: Boolean;
    FId: Integer;
  public
    constructor Create; overload;
    constructor Create(DataSet: TDataSet); overload;
    //
    property Id: Integer read FId write FId;
    property Caption: String read FCaption write FCaption;
    property Name: String read FName write FName;
    property Position: Integer read FPosition write FPosition;
    property LayerType: TEzLayerType read FLayerType write FLayerType;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TKisLayerList = class(TObjectList)
  private
    function GetItems(Index: Integer): TKisLayer;
    procedure SetItems(Index: Integer; const Value: TKisLayer);
  public
    function IndexOfName(const Name: String): Integer;
    procedure LoadFromDataSet(DataSet: TDataSet);
    //
    property Items[Index: Integer]: TKisLayer read GetItems write SetItems; default;
  end;

  function GetMap500Entity(const Nomenclature: String; const Color: TColor; const BkColor: TColor = clNone): TEzEntity;
  function GetMap500SquareEntity(const Nomenclature: String; const Number: Integer; const Color: TColor; const BkColor: TColor = clNone): TEzEntity;

implementation

uses
  uKisConsts;

function GetMap500Entity(const Nomenclature: String; const Color, BkColor: TColor): TEzEntity;
begin
  Result := TEzMap500Entity.CreateEntity(Nomenclature);
  TEzMap500Entity(Result).FontTool.Color := Color;
  TEzMap500Entity(Result).PenTool.Color := Color;
end;

function GetMap500SquareEntity(const Nomenclature: String; const Number: Integer; const Color: TColor; const BkColor: TColor = clNone): TEzEntity;
var
  aTop, aLeft: Integer;
  IdxTop, IdxLeft: Integer;
begin
  aTop := 0;
  aLeft := 0;
  TGeoUtils.MapTopLeft(Nomenclature, aTop, aLeft);
  IdxTop := Pred(Number) div 5;
  IdxLeft := Pred(Number) - IdxTop * 5;
  aLeft := aLeft + IdxLeft * 50;
  aTop := aTop - IdxTop * 50;
  Result := TEzSquareText.CreateEntity(IntToStr(Number), aTop, aLeft, 50);
  TEzSquareText(Result).FontTool.Color := Color;
  TEzSquareText(Result).PenTool.Color := Color;
  TEzSquareText(Result).BrushTool.Color := BkColor;
  TEzSquareText(Result).BrushTool.Pattern := 1;
end;

{ TKisLayer }

constructor TKisLayer.Create;
begin
  inherited Create;
end;

constructor TKisLayer.Create(DataSet: TDataSet);
begin
  inherited Create;
  if Assigned(DataSet) then
  begin
    FId := DataSet.FieldByName(SF_ID).AsInteger;
    FName := DataSet.FieldByName(SF_NAME).AsString;
    FCaption := DataSet.FieldByName(SF_VISIBLE_NAME).AsString;
    FPosition := DataSet.FieldByName(SF_LAYER_POSITION).AsInteger;
    FVisible := Boolean(DataSet.FieldByName(SF_VISIBLE).AsInteger);
    if DataSet.FieldByName(SF_LAYER_TYPE).AsInteger = 1 then
      FLayerType := ltDesktop
    else
      FLayerType := ltMemory;
  end;
end;

{ TKisLayerList }

function TKisLayerList.GetItems(Index: Integer): TKisLayer;
begin
  Result := TKisLayer(inherited Items[Index]);
end;

function TKisLayerList.IndexOfName(const Name: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Count) do
    if Items[I].Name = Name then
    begin
      Result := I;
      Break;
    end; 
end;

procedure TKisLayerList.LoadFromDataSet(DataSet: TDataSet);
begin
  Clear;
  while not DataSet.Eof do
  begin
    Add(TKisLayer.Create(DataSet));
    DataSet.Next;
  end;
end;

procedure TKisLayerList.SetItems(Index: Integer; const Value: TKisLayer);
begin
  inherited Items[Index] := Value;
end;

{ TKisMapImageList }

procedure TKisMapImageList.AddMapImage(Id: Integer; const Name, FileName: String);
var
  Tmp: TKisMapImage;
begin
  Tmp := TKisMapImage.Create;
  Tmp.Id := Id;
  Tmp.Name := Name;
  Tmp.FileName := FileName;
  inherited Add(Tmp);
end;

function TKisMapImageList.GetItems(Index: Integer): TKisMapImage;
begin
  Result := TKisMapImage(inherited Items[Index]);
end;

procedure TKisMapImageList.SetItems(Index: Integer; const Value: TKisMapImage);
begin
  inherited Items[Index] := Value;
end;

end.
