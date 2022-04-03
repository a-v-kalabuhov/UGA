unit uMStKioskDataSet2;

interface

uses
  uMStDataSet;

type
  TKioskController = class(TmstDataSetController)
  private
    FList: TmstKioskList;
    FTmpRecord: TmstKiosk;
  public
    procedure ClearFields(Index: Integer); override;
    function  CreateFloatingRecord(DataSet: TDataSet; SourceIndex: Integer): Integer; override;
    procedure DefloatRecord(FlIndex, DestIndex: Integer; DefloatMode: TDefloatMode); virtual; abstract;
    procedure DeleteRecord(Index:integer); virtual; abstract;
    procedure FillFieldDefs(FieldDefsRef:TFieldDefs); virtual; abstract;
    function FindBookmark(Bookmark:TBookmarkStr): Integer; virtual; abstract;
    procedure FreeFloatingRecord(Index : integer); virtual; abstract;
    function GetBookmark(Index:integer): TBookmarkStr; virtual; abstract;
    function GetBookmarkSize: Integer; virtual; abstract;
    function GetCanModify: Boolean; virtual; abstract;
    procedure GetFieldData(Index:integer; Field: TField; out Data); virtual; 
            abstract;
    function GetRecordCount: Integer; virtual; abstract;
    procedure SetBookmark(Index: Integer; NewBookmark:TBookmarkStr); override;
    procedure SetFieldData(Index: Integer; Field: TField; var Data); override;
  end;

  TKioskDataSet = class(TmstDataSet)
  private
    FCtrlr: TKioskController;
    FList: TmstKioskList;
    FIndexField: String;
    procedure SetIndexField(const Value: String);
    procedure SetList(const Value: TmstKioskList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure UpdateIndex;
    //
    property List: TmstKioskList read FList write SetList;
    property IndexField: String read FIndexField write SetIndexField;
  end;

implementation

{ TKioskController }

procedure TKioskController.ClearFields(Index: Integer);
begin
  inherited;
  FreeAndNil(FTmpRecord);
  FTmpRecord := TmstKiosk.Create;
end;

function TKioskController.CreateFloatingRecord(DataSet: TDataSet;
  SourceIndex: Integer): Integer;
begin
  Result := -1;
  FTmpRecord.CopyFrom(FList[SourceIndex]);
end;

procedure TKioskController.SetBookmark(Index: Integer;
  NewBookmark: TBookmarkStr);
begin
  inherited;

end;

procedure TKioskController.SetFieldData(Index: Integer; Field: TField;
  var Data);
begin
  inherited;
  raise EException.Create('¬нутренн€€ ошибка!' + #13#10 + 'TKioskController.SetFieldData is not implemented.');
end;

{ TKioskDataSet }

constructor TKioskDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FCtrlr := TKioskController.Create(Self);
end;

destructor TKioskDataSet.Destroy;
begin
  
  inherited;
end;

procedure TKioskDataSet.SetIndexField(const Value: String);
begin
  FIndexField := Value;
  if FindField(Value) = nil then
    raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TKioskDataSet.SetIndexField: ѕоле ' + Value + ' не обнаружено.');
  UpdateIndex;
end;

procedure TKioskDataSet.SetList(const Value: TmstKioskList);
begin
  FCtrlr.FList := Value;
  UpdateIndex;
end;

procedure TKioskDataSet.UpdateIndex;
begin

end;

end.
