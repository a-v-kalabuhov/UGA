unit uMStClassesLots;

interface

uses
  SysUtils, Classes, DB, Clipbrd, Windows, Math, Graphics,
  uCommonUtils,
  uMStConsts,
  uMStKernelConsts, uMStKernelTypes, uMStKernelClasses;

type
  TmstLotPoint = class(TmstObject)
  private
    FY: Double;
    FX: Double;
    FName: String;
    procedure SetName(const Value: String);
    procedure SetX(const Value: Double);
    procedure SetY(const Value: Double);
  protected
    function GetText: String; override;
  public
    function Clone: TmstLotPoint;
    property X: Double read FX write SetX;
    property Y: Double read FY write SetY;
    property Name: String read FName write SetName;
  end;

  TmstLotPoints = class(TmstObjectList)
  private
    function GetLength(Index: Integer): Double;
    function GetAzimuth(Index: Integer): Double;
  protected
    function GetItem(Index: Integer): TmstLotPoint;
    procedure SetItem(Index: Integer; APoint: TmstLotPoint);
  public
    function AddPoint: TmstLotPoint;
    function GetByDatabaseId(const DatabaseID: Integer): TmstLotPoint;
    function LoadFromClipBoard(): Boolean;
    //
    property Azimuth[Index: Integer]: Double read GetAzimuth;
    property Items[Index: Integer]: TmstLotPoint read GetItem write SetItem; default;
    property Length[Index: Integer]: Double read GetLength;
  end;

  TmstLot = class;

  TmstLotContour = class(TmstObject)
  private
    FLot: TmstLot;
    FPositive: Boolean;
    FEnabled: Boolean;
    FPoints: TmstLotPoints;
    FSelectedPoint: Integer;
    FName: String;
    FClosed: Boolean;
    FColor: TColor;
    FHasColor: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetPositive(const Value: Boolean);
    procedure SetSelectedPoint(const Value: Integer);
    procedure SetClosed(const Value: Boolean);
    procedure SetColor(const Value: TColor);
    procedure SetHasColor(const Value: Boolean);
  protected
    function GetText: String; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    function Area: Double;
    function AreaStr: String;
    function Clone: TmstLotContour;
    procedure LoadPoints(DataSet: TDataSet);
    function PointsLoaded: Boolean;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Closed: Boolean read FClosed write SetClosed;
    property Name: String read FName write FName;
    property Owner: TmstLot read FLot;
    property Points: TmstLotPoints read FPoints;
    property Positive: Boolean read FPositive write SetPositive;
    property SelectedPoint: Integer read FSelectedPoint write SetSelectedPoint;
    property HasColor: Boolean read FHasColor write SetHasColor;
    property Color: TColor read FColor write SetColor;
  end;

  TmstLotContours = class(TmstObjectList)
  protected
    function GetItem(Index: Integer): TmstLotContour;
    procedure SetItem(Index: Integer; AContour: TmstLotContour);
  public
    function GetByDatabaseId(const DatabaseID: Integer): TmstLotContour;
    function AddContour: TmstLotContour;
    function EnabledCount: Integer;
    property Items[Index: Integer]: TmstLotContour read GetItem write SetItem; default;
  end;

  TmstLot = class(TmstObject)
  private
    FEntityID: Integer;
    FDocNumber: String;
    FDocDate: String;
    FAddress: String;
    FArea: Double;
    FRegionId: Integer;
    FErrorCoord: Boolean;
    FChecked: Boolean;
    FCancelled: Boolean;
    FVersion: Integer;
    FCancelDate: String;
    FInfoMonument: String;
    FPZ: String;
    FDocuments: String;
    FExecutor: String;
    FInfoLandscape: String;
    FCancelledInfo: String;
    FDescription: String;
    FInfoRealty: String;
    FNeighbours: String;
    FInfoMinerals: String;
    FCreator: String;
    FDecreeExecutor: String;
    FInfo: String;
    FInfoFlora: String;
    FNomenclature: String;
    FContours: TmstLotContours;
    FSelectedContour: Integer;
    FVisible: Boolean;
    FCategoryId: Integer;
    FCategorized: Boolean;
    procedure SetDocNumber(const Value: String);
    procedure SetDocDate(const Value: String);
    procedure SetAddress(const Value: String);
    procedure SetArea(const Value: Double);
    procedure SetRegionId(const Value: Integer);
    procedure SetCancelDate(const Value: String);
    procedure SetCancelled(const Value: Boolean);
    procedure SetCancelledInfo(const Value: String);
    procedure SetChecked(const Value: Boolean);
    procedure SetCreator(const Value: String);
    procedure SetDecreeExecutor(const Value: String);
    procedure SetDescription(const Value: String);
    procedure SetDocuments(const Value: String);
    procedure SetErrorCoord(const Value: Boolean);
    procedure SetExecutor(const Value: String);
    procedure SetInfo(const Value: String);
    procedure SetInfoFlora(const Value: String);
    procedure SetInfoLandscape(const Value: String);
    procedure SetInfoMinerals(const Value: String);
    procedure SetInfoMonument(const Value: String);
    procedure SetInfoRealty(const Value: String);
    procedure SetNeighbours(const Value: String);
    procedure SetNomenclature(const Value: String);
    procedure SetPZ(const Value: String);
    procedure SetVersion(const Value: Integer);
    procedure SetSelectedContour(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetEntityID(const Value: Integer);
    procedure SetCategorized(const Value: Boolean);
  protected
    function GetObjectId: Integer; override;
    function GetText: String; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    // Загрузка данных
    procedure CopyFrom(aLot: TmstLot);
    function HasColor: Boolean;
    procedure LoadMainData(DataSet: TDataSet; LoadState: Boolean = True);
    procedure LoadCoords(AContours: TDataSet; APoints: TDataSet);
    function  LoadContour(DataSet: TDataSet): TmstLotContour;
    function  PointsLoaded: Boolean;

    property EntityID: Integer read FEntityID write SetEntityID;
    property DocNumber: String read FDocNumber write SetDocNumber;
    property DocDate: String read FDocDate write SetDocDate;
    property Address: String read FAddress write SetAddress;
    property RegionId: Integer read FRegionId write SetRegionId;
    property Area: Double read FArea write SetArea;
    property Cancelled: Boolean read FCancelled write SetCancelled;
    property CancelDate: String read FCancelDate write SetCancelDate;
    property CancelledInfo: String read FCancelledInfo write SetCancelledInfo;
    property Categorized: Boolean read FCategorized write SetCategorized;
//    property CategoryId: Integer read FCategoryId write SetCategoryId;
    property Checked: Boolean read FChecked write SetChecked;
    property ErrorCoord: Boolean read FErrorCoord write SetErrorCoord;
    property Executor: String read FExecutor write SetExecutor;
    property Info: String read FInfo write SetInfo;
    property InfoLandscape: String read FInfoLandscape write SetInfoLandscape;
    property InfoRealty: String read FInfoRealty write SetInfoRealty;
    property InfoMonument: String read FInfoMonument write SetInfoMonument;
    property InfoMinerals: String read FInfoMinerals write SetInfoMinerals;
    property InfoFlora: String read FInfoFlora write SetInfoFlora;
    property Documents: String read FDocuments write SetDocuments;
    property Version: Integer read FVersion write SetVersion;
    property DecreeExecutor: String read FDecreeExecutor write SetDecreeExecutor;
    property Nomenclature: String read FNomenclature write SetNomenclature;
    property Neighbours: String read FNeighbours write SetNeighbours;
    property PZ: String read FPZ write SetPZ;
    property Description: String read FDescription write SetDescription;
    property Creator: String read FCreator write SetCreator;
    // Текущий выбранный контур. (-1) - нет выбранного контура
    property SelectedContour: Integer read FSelectedContour write SetSelectedContour;
    property Contours: TmstLotContours read FContours;
    property Visible: Boolean read FVisible write SetVisible;
  public
    class function CatToType(aCategoryId: Integer): TmstLotType;
    function GetCategoryId(): Integer;
    procedure SetCategoryId(const Value: Integer);
  end;

  TmstLotList = class;

  TBeforeAddLotEvent = procedure (aList: TmstLotList; var aLot: TmstLot) of object;

  TmstLotList = class(TmstObjectList)
  private
    FBeforeAddLot: TBeforeAddLotEvent;
    FCategoryId: Integer;
    procedure SetBeforeAddLot(const Value: TBeforeAddLotEvent);
    procedure SetCategoryId(const Value: Integer);
  protected
    procedure DoBeforeAddLot(aList: TmstLotList; var aLot: TmstLot);
    function GetItem(Index: Integer): TmstLot;
    procedure SetItem(Index: Integer; ALot: TmstLot);
  public
    function GetByDatabaseId(const DatabaseID: Integer): TmstLot;
    function GetByEntityId(const EntityID: Integer): TmstLot;
    function AddLot: TmstLot;
    property CategoryId: Integer read FCategoryId write SetCategoryId;
    property Items[Index: Integer]: TmstLot read GetItem write SetItem; default;
    property BeforeAddLot: TBeforeAddLotEvent read FBeforeAddLot write SetBeforeAddLot;
  end;

  ImstLotController = interface
    ['{A3133F92-F1AF-4D65-BBA0-4DA64B6193E5}']
    function GetSelectedLot: TmstLot;
    function GetLotList(const aCategoryId: Integer): TmstLotList;
    procedure UpdateLotEntity(Sender: TObject; AObject: TmstObject);
  end;

  TmstSelectedLotInfo = record
    Id: Integer; // Id представления участка в графическом слое
    CategoryId: Integer;
    ContourId: Integer; // DatabaseId контура, если выбран контур а не весь участок
    DatabaseId: Integer;
  end;

implementation

procedure NextIndex(const Max: Integer; var theNext: Integer);
begin
  Inc(theNext);
  while theNext >= Max do
    Dec(theNext, Max);
end;

{ TmstLotPoint }

function TmstLotPoint.CLone: TmstLotPoint;
begin
  Result := TmstLotPoint.Create;
  Result.FY := FY;
  Result.FX := FX;
  Result.FName := FName;
end;

function TmstLotPoint.GetText: String;
begin
  Result := Name;
end;

procedure TmstLotPoint.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TmstLotPoint.SetX(const Value: Double);
begin
  FX := Value;
end;

procedure TmstLotPoint.SetY(const Value: Double);
begin
  FY := Value;
end;

{ TmstLotPoints }

function TmstLotPoints.AddPoint: TmstLotPoint;
begin
  Result := TmstLotPoint.Create;
  Self.Add(Result);
end;

function TmstLotPoints.GetAzimuth(Index: Integer): Double;
var
  Pt1, Pt2: TmstLotPoint;
begin
  if Count < 2 then
    Result := 0
  else
  begin
    Pt1 := Items[Index];
    NextIndex(Count, Index);
    Pt2 := Items[Index];
    Result := uCommonUtils.Azimuth(Pt1.X, Pt1.Y, Pt2.X, Pt2.Y);
  end;
end;

function TmstLotPoints.GetByDatabaseId(
  const DatabaseID: Integer): TmstLotPoint;
begin
  Result := TmstLotPoint(inherited GetByDatabaseId(DatabaseID));
end;

function TmstLotPoints.GetItem(Index: Integer): TmstLotPoint;
begin
  Result := TmstLotPoint(inherited GetItem(Index));
end;

function TmstLotPoints.GetLength(Index: Integer): Double;
var
  Pt1, Pt2: TmstLotPoint;
begin
  if Count < 2 then
    Result := 0
  else
  begin
    Pt1 := Items[Index];
    NextIndex(Count, Index);
    Pt2 := Items[Index];
    Result := Sqrt(Sqr(Pt1.X - Pt2.X) + Sqr(Pt1.Y - Pt2.Y));
  end;
end;

function TmstLotPoints.LoadFromClipBoard: Boolean;
var
  S, S1: String;
  X, Y: Double;
  I, J, N, Cnt: Integer;
  L: TStringList;
  NewPt: TmstLotPoint;
begin
  Result := False;
  Clipboard.Open;
  try
    if ClipBoard.HasFormat(CF_TEXT) then
    begin
      S := ClipBoard.AsText;
      //AddPoints(0, s);
      L := TStringList.Create;
      try
        S := StringReplace(S, '.', ',', [rfReplaceAll]);
        L.Text := S;
        N := 0;
        for I := 0 to L.Count - 1 do
        if S <> '' then
        begin
          S := L.Strings[I];
          if S[1] <= #32 then
            raise EAbort.Create('');
          S1 := '';
          J := 1;
          Cnt := 0;
          X := 0;
          while J <= System.Length(S) do
          begin
            if (S[J] <= #32) or (J = System.Length(S)) then
            begin
              S1 := Copy(S, 1, Integer(IfThen((J = System.Length(S)), J, J - 1)));
              System.Delete(S, 1, J);
              J := 0;
              Inc(Cnt);
              case Cnt of
              1 : begin
                    if not TryStrToInt(S1, N) then
                      Inc(N);
                  end;
              2 : X := StrToFloat(S1);
              3 : begin
                    Y := StrToFloat(S1);
                    X := Round(X * 100) / 100;
                    Y := Round(Y * 100) / 100;
                    NewPt := Self.AddPoint;
                    NewPt.X := X;
                    NewPt.Y := Y;
                    NewPt.Name := IntToStr(N);
                  end;
              4 : Break;
              end;
            end;
            Inc(J);
          end;
        end;
        Result := True;
      except
        Result := False;
      end;
   end;
  finally
    ClipBoard.Close;
  end;
end;

procedure TmstLotPoints.SetItem(Index: Integer; APoint: TmstLotPoint);
begin
  inherited SetItem(Index, APoint);
end;

{ TmstLotContour }

function TmstLotContour.Area: Double;
var
  I, J, K, C: Integer;
begin
  if (Points.Count < 3) or not Closed then
    Result := 0
  else
  begin
    Result := 0;
    I := 0;
    J := 1;
    K := 2;
    C := Points.Count;
    while I < C do
    begin
      if I = Pred(C) then
        J := 0
      else
        J := Succ(I);
      Result := Result + (Points[K].X - Points[I].X) * Points[J].Y;
      Inc(I);
      NextIndex(C, J);
      NextIndex(C, K);
    end;
    Result := Abs(Result / 2);
  end;
end;

function TmstLotContour.AreaStr: String;
begin
  Result := '';
  if Points.Count = 0 then
    Result := 'не опред.'
  else
  if (Points.Count < 3) or not Closed then
    Result := '0'
  else
    Result := Format('%8.2f', [Area]);
end;

function TmstLotContour.Clone: TmstLotContour;
var
  I: Integer;
begin
  Result := TmstLotContour.Create;
  Result.FPositive := FPositive;
  Result.FEnabled := FEnabled;
  Result.FClosed := FClosed;
  Result.FSelectedPoint := FSelectedPoint;
  Result.FName := FName;
  Result.FColor := FColor;
  Result.FHasColor := FHasColor;
  for I := 0 to Pred(FPoints.Count) do
    Result.FPoints.Add(FPoints[I].Clone);
end;

constructor TmstLotContour.Create;
begin
  inherited;
  FPoints := TmstLotPoints.Create;
  FSelectedPoint := -1;
end;

destructor TmstLotContour.Destroy;
begin
  FPoints.Free;
  inherited;
end;

function TmstLotContour.GetText: String;
var
  DbId: string;
begin
  DbId := IntToStr(DatabaseId);
  if (Name = '') or (DbId = Name) then
  begin
    Result := DbId + '. ';
    if Closed then
      Result := Result + 'Контур'
    else
      Result := Result + 'Линия';
    Result := Result + ' ' + DbId
  end
  else
    Result := DbId + '. ' + Name;
end;

procedure TmstLotContour.LoadPoints(DataSet: TDataSet);
begin
  DataSet.First;
  while not DataSet.Eof do
  begin
    if DataSet.FieldByName(SF_CONTOURS_ID).AsInteger = Self.DatabaseId then
      with FPoints.AddPoint do
      begin
        X := DataSet.FieldByName('X').AsFloat;
        Y := DataSet.FieldByName('Y').AsFloat;
        Name := DataSet.FieldByName('NAME').AsString;
        DatabaseId := DataSet.FieldByname('ID').AsInteger;
      end;
    DataSet.Next;
  end;
end;

function TmstLotContour.PointsLoaded: Boolean;
begin
  Result := FPoints.Count > 0;
end;

procedure TmstLotContour.SetClosed(const Value: Boolean);
begin
  FClosed := Value;
end;

procedure TmstLotContour.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TmstLotContour.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TmstLotContour.SetHasColor(const Value: Boolean);
begin
  FHasColor := Value;
end;

procedure TmstLotContour.SetPositive(const Value: Boolean);
begin
  FPositive := Value;
end;

procedure TmstLotContour.SetSelectedPoint(const Value: Integer);
begin
  FSelectedPoint := Value;
end;

{ TmstLotContours }

function TmstLotContours.AddContour: TmstLotContour;
begin
  Result := TmstLotContour.Create;
  Self.Add(Result);
end;

function TmstLotContours.EnabledCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Pred(Count) do
    if Items[I].Enabled then
      Inc(Result);
end;

function TmstLotContours.GetByDatabaseId(
  const DatabaseID: Integer): TmstLotContour;
begin
  Result := TmstLotContour(inherited GetByDatabaseId(DatabaseID));
end;

function TmstLotContours.GetItem(Index: Integer): TmstLotContour;
begin
  Result := TmstLotContour(inherited GetItem(Index));
end;

procedure TmstLotContours.SetItem(Index: Integer;
  AContour: TmstLotContour);
begin
  inherited SetItem(Index, AContour);
end;

{ TmstLot }

class function TmstLot.CatToType(aCategoryId: Integer): TmstLotType;
begin
  case aCategoryId of
  -3 : Result := ltReg;
  -2 : Result := ltAnnuled;
  -1 : Result := ltActual;
  else
       Result := ltCategorized;
  end;
end;

procedure TmstLot.CopyFrom(aLot: TmstLot);
var
  I: Integer;
begin
  FEntityID := aLot.FEntityID;
  FDocNumber := aLot.FDocNumber;
  FDocDate := aLot.FDocDate;
  FAddress := aLot.FAddress;
  FArea := aLot.FArea;
  FRegionId := aLot.FRegionId;
  FErrorCoord := aLot.FErrorCoord;
  FChecked := aLot.FChecked;
  FCancelled := aLot.FCancelled;
  FVersion := aLot.FVersion;
  FCancelDate := aLot.FCancelDate;
  FInfoMonument := aLot.FInfoMonument;
  FPZ := aLot.FPZ;
  FDocuments := aLot.FDocuments;
  FExecutor := aLot.FExecutor;
  FInfoLandscape := aLot.FInfoLandscape;
  FCancelledInfo := aLot.FCancelledInfo;
  FDescription := aLot.FDescription;
  FInfoRealty := aLot.FInfoRealty;
  FNeighbours := aLot.FNeighbours;
  FInfoMinerals := aLot.FInfoMinerals;
  FCreator := aLot.FCreator;
  FDecreeExecutor := aLot.FDecreeExecutor;
  FInfo := aLot.FInfo;
  FInfoFlora := aLot.FInfoFlora;
  FNomenclature := aLot.FNomenclature;
  FSelectedContour := aLot.FSelectedContour;
  FVisible := aLot.FVisible;
  FCategoryId := aLot.FCategoryId;
  FCategorized := aLot.FCategorized;
  FContours.Clear;
  for I := 0 to Pred(aLot.FContours.Count) do
    FContours.Add(aLot.FContours.Items[I].Clone);
end;

constructor TmstLot.Create;
begin
  inherited;
  FContours := TmstLotContours.Create;
  FSelectedContour := -1;
  FVisible := True;
end;

destructor TmstLot.Destroy;
begin
  FContours.Free;
  inherited;
end;

function TmstLot.GetCategoryId: Integer;
begin
  if FCategorized then
    Result := FCategoryId
  else
  begin
    if Cancelled then
      Result := -2
    else
      if Checked then
        Result := -1
      else
        Result := -3;
  end;
end;

function TmstLot.GetObjectId: Integer;
begin
  if Cancelled then
    Result := ID_ANNULED_LOT1
  else
  if Checked then
    Result := ID_ACTUAL_LOT1
  else
    Result := ID_LOT;
end;

function TmstLot.GetText: String;
begin
  if Trim(Address) <> '' then
    Result := Address
  else
    Result := 'Без адреса';
  Result := Result + '; пл. ' + Format('%8.2f', [Area]);
  if Trim(Executor) <> '' then
    Result := Result + '; ' + Executor
  else
    Result := Result + '; Исполнитель неуказан';
  if Trim(DecreeExecutor) <> '' then
    Result := Result + '; Архитектор ' + DecreeExecutor
  else
    Result := Result + '; Архитектор неуказан';
end;

function TmstLot.HasColor: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FContours.Count - 1 do
    if FContours[I].HasColor then
    begin
      Result := True;
      Exit;
    end;
end;

function TmstLot.LoadContour(DataSet: TDataSet): TmstLotContour;
begin
  Result := FContours.AddContour;
  with Result do
  begin
    Enabled := Boolean(DataSet.FieldByName(SF_ENABLED).AsInteger);
    Closed := Boolean(DataSet.FieldByName(SF_CLOSED).AsInteger);
    Positive := Boolean(DataSet.FieldByName(SF_POSITIVE).AsInteger);
    DatabaseId := DataSet.FieldByName(SF_ID).AsInteger;
    Name := DataSet.FieldByName(SF_NAME).AsString;//'Контур ' + IntToStr(DatabaseId);
    if DataSet.FieldByName(SF_COLOR).IsNull then
      HasColor := False
    else
    begin
      HasColor := True;
      Color := DataSet.FieldByName(SF_COLOR).AsInteger;
    end;
  end;
end;

procedure TmstLot.LoadCoords(AContours, APoints: TDataSet);
begin
  Self.Contours.Clear;
  AContours.First;
  while not AContours.Eof do
  begin
    with LoadContour(AContours) do
      LoadPoints(APoints);
    AContours.Next;
  end;
end;

procedure TmstLot.LoadMainData(DataSet: TDataSet; LoadState: Boolean = True);
begin
  DatabaseId := DataSet.FieldByName('ID').AsInteger;
  DocNumber := DataSet.FieldByName('DOC_NUMBER').AsString;
  DocDate := DataSet.FieldByName('DOC_DATE').AsString;
  Address := DataSet.FieldByName('ADDRESS').AsString;
  Area := DataSet.FieldByName('AREA').AsFloat;
  if LoadState then
  begin
    if DataSet.FindField(SF_CHECKED) <> nil then
      Checked := Boolean(DataSet.FieldByName('CHECKED').AsInteger);
    if DataSet.FindField(SF_CANCELLED) <> nil then
      Cancelled := Boolean(DataSet.FieldByName('CANCELLED').AsInteger);
  end;
  Version := DataSet.FieldByName('VRS').AsInteger;
  Executor := DataSet.FieldByName('EXECUTOR').AsString;
  Categorized := not DataSet.FieldByName(SF_LOT_KINDS_ID).IsNull;
  SetCategoryId(DataSet.FieldByName(SF_LOT_KINDS_ID).AsInteger);
end;

function TmstLot.PointsLoaded: Boolean;
var
  I: Integer;
begin
  Result := FContours.Count > 0;
  if Result then
    for I := 0 to Pred(FContours.Count) do
    begin
      Result := Result and FContours[I].PointsLoaded;
      if not Result then
        Exit;
    end;
end;

procedure TmstLot.SetAddress(const Value: String);
begin
  FAddress := Value;
end;

procedure TmstLot.SetArea(const Value: Double);
begin
  FArea := Value;
end;

procedure TmstLot.SetCancelDate(const Value: String);
begin
  FCancelDate := Value;
end;

procedure TmstLot.SetCancelled(const Value: Boolean);
begin
  FCancelled := Value;
end;

procedure TmstLot.SetCancelledInfo(const Value: String);
begin
  FCancelledInfo := Value;
end;

procedure TmstLot.SetCategorized(const Value: Boolean);
begin
  FCategorized := Value;
end;

procedure TmstLot.SetCategoryId(const Value: Integer);
begin
  FCategoryId := Value;
end;

procedure TmstLot.SetChecked(const Value: Boolean);
begin
  FChecked := Value;
end;

procedure TmstLot.SetCreator(const Value: String);
begin
  FCreator := Value;
end;

procedure TmstLot.SetDecreeExecutor(const Value: String);
begin
  FDecreeExecutor := Value;
end;

procedure TmstLot.SetDescription(const Value: String);
begin
  FDescription := Value;
end;

procedure TmstLot.SetDocDate(const Value: String);
begin
  FDocDate := Value;
end;

procedure TmstLot.SetDocNumber(const Value: String);
begin
  FDocNumber := Value;
end;

procedure TmstLot.SetDocuments(const Value: String);
begin
  FDocuments := Value;
end;

procedure TmstLot.SetEntityID(const Value: Integer);
begin
  FEntityID := Value;
end;

procedure TmstLot.SetErrorCoord(const Value: Boolean);
begin
  FErrorCoord := Value;
end;

procedure TmstLot.SetExecutor(const Value: String);
begin
  FExecutor := Value;
end;

procedure TmstLot.SetInfo(const Value: String);
begin
  FInfo := Value;
end;

procedure TmstLot.SetInfoFlora(const Value: String);
begin
  FInfoFlora := Value;
end;

procedure TmstLot.SetInfoLandscape(const Value: String);
begin
  FInfoLandscape := Value;
end;

procedure TmstLot.SetInfoMinerals(const Value: String);
begin
  FInfoMinerals := Value;
end;

procedure TmstLot.SetInfoMonument(const Value: String);
begin
  FInfoMonument := Value;
end;

procedure TmstLot.SetInfoRealty(const Value: String);
begin
  FInfoRealty := Value;
end;

procedure TmstLot.SetNeighbours(const Value: String);
begin
  FNeighbours := Value;
end;

procedure TmstLot.SetNomenclature(const Value: String);
begin
  FNomenclature := Value;
end;

procedure TmstLot.SetPZ(const Value: String);
begin
  FPZ := Value;
end;

procedure TmstLot.SetRegionId(const Value: Integer);
begin
  FRegionId := Value;
end;

procedure TmstLot.SetSelectedContour(const Value: Integer);
begin
  FSelectedContour := Value;
end;

procedure TmstLot.SetVersion(const Value: Integer);
begin
  FVersion := Value;
end;

procedure TmstLot.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

{ TmstLotList }

function TmstLotList.AddLot: TmstLot;
begin
  Result := TmstLot.Create;
  DoBeforeAddLot(Self, Result);
  Self.Add(Result);
end;

procedure TmstLotList.DoBeforeAddLot(aList: TmstLotList; var aLot: TmstLot);
begin
  if Assigned(FBeforeAddLot) then
    FBeforeAddLot(aList, aLot);
end;

function TmstLotList.GetByDatabaseId(const DatabaseID: Integer): TmstLot;
begin
  Result := TmstLot(inherited GetByDatabaseId(DatabaseID));
end;

function TmstLotList.GetByEntityId(const EntityID: Integer): TmstLot;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].EntityID = EntityID then
    begin
      Result := Items[I];
      Exit;
    end;
  Result := nil;
end;

function TmstLotList.GetItem(Index: Integer): TmstLot;
begin
  Result := TmstLot(inherited GetItem(Index));
end;

procedure TmstLotList.SetBeforeAddLot(const Value: TBeforeAddLotEvent);
begin
  FBeforeAddLot := Value;
end;

procedure TmstLotList.SetCategoryId(const Value: Integer);
begin
  FCategoryId := Value;
end;

procedure TmstLotList.SetItem(Index: Integer; ALot: TmstLot);
begin
  DoBeforeAddLot(Self, aLot);
  inherited SetItem(Index, ALot);
end;

end.
