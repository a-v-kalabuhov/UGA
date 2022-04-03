unit uMStKernelClassesSearch;

interface

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

uses
  SysUtils, Classes,
  EzLib,
  uMStKernelClasses, uMStKernelConsts, uMStKernelStack;

type
  TmstSearchData = class(TObject)
  private
    FFound: Boolean;
  public
    procedure DoSearch(AStack: TmstObjectStack); virtual; abstract;
    property Found: Boolean read FFound write FFound;
  end;

  TmstRectSearchData = class(TObject)
  private
    FBottom: Double;
    FLeft: Double;
    FRight: Double;
    FTop: Double;
  public
    property Bottom: Double read FBottom write FBottom;
    property Left: Double read FLeft write FLeft;
    property Right: Double read FRight write FRight;
    property Top: Double read FTop write FTop;
  end;

  TmstTextSearchData = class(TmstSearchData)
  protected
    FText: string;
    procedure SetText(const Value: string); virtual;
  public
    constructor Create(const AText: String);
    property Text: string read FText write SetText;
  end;

  TmstAddressSearchData = class(TmstSearchData)
  private
    FBuilding: string;
    FStreetName: string;
  public
    constructor Create(const AStreetName, ABuilding: String);
    procedure DoSearch(AStack: TmstObjectStack); override;
    property Building: string read FBuilding write FBuilding;
    property StreetName: string read FStreetName write FStreetName;
  end;

  TmstLotAddressSearchData = class(TmstTextSearchData)
  private
    FStack: TmstObjectStack;
    procedure OnLotLoaded(Sender: TObject);
  public
    procedure DoSearch(AStack: TmstObjectStack); override;
    function SearchText: String;
  end;

  TmstSearchMapData = class(TmstTextSearchData)
  private
    FMapRect: TEzRect;
    procedure OnMapFound(Sender: TObject);
    procedure SetMapRect(const Value: TEzRect);
  public
    procedure DoSearch(AStack: TmstObjectStack); override;
    property Nomenclature: String read FText;
    property MapRect: TEzRect read FMapRect write SetMapRect;
  end;

  TmstFinder = class(TComponent)
  private
    FStack: TmstObjectStack;
  public
    procedure DoFind(AData: TmstSearchData);
    property Stack: TmstObjectStack read FStack write FStack;
  end;


implementation

uses
  EzBaseGIS,
  uMStModuleApp;

{ TmstTextSearchData }
constructor TmstTextSearchData.Create(const AText: String);
begin
  FText := AText;
end;

procedure TmstTextSearchData.SetText(const Value: string);
begin
  FText := Value;
end;

{ TmstAddressSearchData }

constructor TmstAddressSearchData.Create(const AStreetName, ABuilding: String);
begin
  FStreetName := AStreetName;
  FBuilding := ABuilding;
end;

procedure TmstAddressSearchData.DoSearch(AStack: TmstObjectStack);
var
  I: Integer;
  Street: TmstStreet;
begin
  inherited;
  with mstClientAppModule do
  for I := 0 to Pred(Addresses.Count) do
  begin
    if Pos(FBuilding, Addresses[I].Name) = 1 then
      if Addresses[I].StreetDatabaseId > 0 then
      begin
        Street := Streets.GetByDatabaseId(Addresses[I].StreetDatabaseId);
        if Assigned(Street) then
          if Pos(FStreetName, Street.Name) = 1 then
          begin
            AStack.AddObject(Street);
            AStack.AddObject(Addresses[I]);
          end;
      end;
  end;
end;

{ TmstFinder }

procedure TmstFinder.DoFind(AData: TmstSearchData);
begin
  FStack.BeginUpdate;
  try
    AData.DoSearch(FStack);
  finally
    FStack.EndUpdate;
    FStack.UpdateView;
  end;
end;

{ TmstLotAddressSearchData }

procedure TmstLotAddressSearchData.DoSearch(AStack: TmstObjectStack);
begin
  inherited;
  FStack := aStack;
  with mstClientAppModule do
    LoadLotsByField(SF_ADDRESS, SearchText, OnLotLoaded);
end;

procedure TmstLotAddressSearchData.OnLotLoaded(Sender: TObject);
begin
  if Assigned(Sender) then
  if Assigned(FStack) then
  begin
    FStack.AddObject(TmstObject(Sender));
    Found := True;
  end;
end;

function TmstLotAddressSearchData.SearchText: String;
begin
  Result := StringReplace(FText, ' ', '%', [rfReplaceAll]);
  Result := '%' + Result + '%';
  while Pos('%%', Result) > 0 do
    Result := StringReplace(Result, '%%', '%', [rfReplaceAll]);
end;

{ TmstSearchMapData }

procedure TmstSearchMapData.DoSearch(AStack: TmstObjectStack);
begin
  inherited;
  mstClientAppModule.FindMap(Nomenclature, OnMapFound);
end;

procedure TmstSearchMapData.OnMapFound(Sender: TObject);
var
  aId: Integer;
begin
  if Assigned(Sender) then
  begin
    aId := Integer(Sender);
    with mstClientAppModule.GIS.Layers.LayerByName(SL_MAP_LAYER) do
    begin
      RecNo := aId;
      Found := RecNo = aId;
      if Found then
       FMapRect := RecExtension;
    end;
  end;
end;

procedure TmstSearchMapData.SetMapRect(const Value: TEzRect);
begin
  FMapRect := Value;
end;

end.
