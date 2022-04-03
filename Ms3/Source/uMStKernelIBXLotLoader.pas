unit uMStKernelIBXLotLoader;

interface

uses
  DB,
  uMStKernelClasses, uMStKernelConsts,
  uMstCLassesLots;

type
  TIBXLotLoader = class
  private
    FDataSet: TDataSet;
    FLotList: TmstLotList;
    FLot: TmstLot;
    procedure LoadContourInfo(Cnt: TmstLotContour);
    procedure LoadPointInfo(Point: TmstLotPoint);
  public
    constructor Create(aDataSet: TDataSet; LotList: TmstLotList);
    //
    procedure AddPoint();
    procedure StartNewLot();
    function FinishLot(): TmstLot;
  end;

implementation

{ TIBXLotLoader }

procedure TIBXLotLoader.AddPoint();
var
  Cnt: TmstLotContour;
  Point: TmstLotPoint;
  CntId: Integer;
begin
  CntId := FDataSet.FieldByName(SF_CONTOURS_ID).AsInteger;
  Cnt := FLot.Contours.GetByDatabaseId(CntId);
  if Cnt = nil then
  begin
    Cnt := FLot.Contours.AddContour();
    LoadContourInfo(Cnt);
  end;
  Point := Cnt.Points.AddPoint;
  LoadPointInfo(Point);
end;

constructor TIBXLotLoader.Create(aDataSet: TDataSet; LotList: TmstLotList);
begin
  FDataSet := aDataSet;
  FLotList := LotList;
end;

function TIBXLotLoader.FinishLot(): TmstLot;
begin
  Result := FLot;
  FLot := nil;
end;

procedure TIBXLotLoader.LoadContourInfo(Cnt: TmstLotContour);
begin
  Cnt.Enabled := Boolean(FDataSet.FieldByName(SF_CNT_ENABLED).AsInteger);
  Cnt.Positive := Boolean(FDataSet.FieldByName(SF_CNT_POSITIVE).AsInteger);
  Cnt.Name := FDataSet.FieldByName(SF_CNT_ID).AsString;
  Cnt.DatabaseId := FDataSet.FieldByName(SF_CNT_ID).AsInteger;
end;

procedure TIBXLotLoader.LoadPointInfo(Point: TmstLotPoint);
begin
  Point.X := FDataSet.FieldByName(SF_X).AsFloat;
  Point.Y := FDataSet.FieldByName(SF_Y).AsFloat;
  Point.Name := FDataSet.FieldByName(SF_PT_NAME).AsString;
  Point.DatabaseId := FDataSet.FieldByName(SF_PT_ID).AsInteger;
end;

procedure TIBXLotLoader.StartNewLot;
begin
  FLot := TmstLot.Create;
  FLot.LoadMainData(FDataSet, True);
end;

end.
