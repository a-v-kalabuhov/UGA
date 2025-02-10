unit uMStClassesMPClassif;

interface

uses
  SysUtils, Classes, DB, Contnrs, Graphics,
  uCommonUtils;

const
  Kb = 1024;
  Kb16 = Kb * 16 - 1;

type
  TMPClassEntry = class
  public
    FVisible: Boolean;
//    FCategories: TStringList;
    FCats: array [0..Kb16] of TMPClassEntry;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function GetCategoryVisible(MpCategoryId: Integer): Boolean;
    procedure SetCategoryVisible(MpCategoryId: Integer; Value: Boolean);
  end;

  TMPObjClassEntry = class
  public
    fDbId: Integer;
    fObjClassId: string;
    fCatId: Integer;
    fObjClassName: string;
    fColor: TColor;
  end;

  TMPObjClassesList = class
  private
    FList: TObjectList;
    //
    FBinSearchDbId: Integer;
    function CheckDbId(Item: Pointer): Boolean;
    function CompareDbId(Item: Pointer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure AddClass(const DbId, CatId: Integer; const ObjClassId, ObjClassName: string; aColor: TColor);
    procedure Clear();
    procedure Reindex();
    function Find(const DbId: Integer; const BinSearch: Boolean): TMPObjClassEntry;
  end;

  TmstMPClassifier = class
  private
    FClasses: TMPObjClassesList;
    FStatusArr: array[0..Kb16] of TMPClassEntry;
    FMPVisible: Boolean;
//    FCacheStatusId: Integer;
//    FCacheEntry: TMPClassEntry;
    procedure SetMPVisible(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFromDataSet(DataSet: TDataSet);
    //
    function GetMPStatusVisible(MpStatusId: Integer): Boolean;
    procedure SetMPStatusVisible(MpStatusId: Integer; Visible: Boolean);
    function GetMPCategoryVisible(MpStatusId, MpCategoryId: Integer): Boolean;
    procedure SetMPCategoryVisible(MpStatusId, MpCategoryId: Integer; Visible: Boolean);
    //
    function GetClassName(const aClassId: Integer): string;
    function GetClassCategoryId(const aClassId: Integer): Integer;
    function GetClassCategoryColor(const aClassId: Integer): TColor;
    //
    property MPVisible: Boolean read FMPVisible write SetMPVisible;
  end;

implementation

uses
  uMStConsts;

function CompareMPObjClassEntries(Item1, Item2: Pointer): Integer;
begin
  Result := TMPObjClassEntry(Item1).fDbId - TMPObjClassEntry(Item2).fDbId;
end;

{ TmstMPClassifier }

constructor TmstMPClassifier.Create;
var
  I: Integer;
begin
  FClasses := TMPObjClassesList.Create;
  for I := 0 to 255 do
    FStatusArr[I] := nil;
  FMPVisible := True;
end;

destructor TmstMPClassifier.Destroy;
var
  I: Integer;
begin
  for I := 0 to 255 do
    if FStatusArr[I] <> nil then
      FStatusArr[I].Free;
  FClasses.Free;
  inherited;
end;

function TmstMPClassifier.GetClassCategoryColor(const aClassId: Integer): TColor;
var
  Entry: TMPObjClassEntry;
begin
  Entry := FClasses.Find(aClassId, True);
  if Assigned(Entry) then
    Result := Entry.fColor
  else
    Result := clBlack;
end;

function TmstMPClassifier.GetClassCategoryId(const aClassId: Integer): Integer;
var
  Entry: TMPObjClassEntry;
begin
  Entry := FClasses.Find(aClassId, True);
  if Assigned(Entry) then
    Result := Entry.fCatId
  else
    Result := -1;
end;

function TmstMPClassifier.GetClassName(const aClassId: Integer): string;
var
  Entry: TMPObjClassEntry;
begin
  Entry := FClasses.Find(aClassId, True);
  if Assigned(Entry) then
    Result := Entry.fObjClassName
  else
    Result := 'класс не найден';
end;

function TmstMPClassifier.GetMPCategoryVisible(MpStatusId, MpCategoryId: Integer): Boolean;
begin
  Result := False;
  if FStatusArr[MpStatusId] <> nil then
    Result := FStatusArr[MpStatusId].GetCategoryVisible(MpCategoryId);
end;

function TmstMPClassifier.GetMPStatusVisible(MpStatusId: Integer): Boolean;
begin
  Result := False;
  if FStatusArr[MpStatusId] <> nil then
    Result := FStatusArr[MpStatusId].FVisible;
end;

procedure TmstMPClassifier.LoadFromDataSet(DataSet: TDataSet);
var
  DbId: Integer;
  CatId: Integer;
  ObjClassId: string;
  ObjClassName: string;
  CatColor: Integer;
begin
//    'SELECT PL.ID, PL.NAME, PL.CLASS_ID, PL.MP_NET_TYPES_ID AS MP_CATEGORY_ID '
//  + 'FROM PROJECT_LAYERS PL '
//  + 'ORDER BY PL.NAME ';
  if not DataSet.Active then
    Exit;
  FClasses.Clear;
  DataSet.First;
  while not DataSet.Eof do
  begin
    DbId := DataSet.FieldByName(SF_ID).AsInteger;
    ObjClassName := DataSet.FieldByName(SF_NAME).AsString;
    ObjClassId := DataSet.FieldByName(SF_CLASS_ID).AsString;
    CatId := DataSet.FieldByName(SF_MP_CATEGORY_ID).AsInteger;
    CatColor := DataSet.FieldByName(SF_LINE_COLOR).AsInteger;
    FClasses.AddClass(DbId, CatId, ObjClassId, ObjClassName, CatColor);
    DataSet.Next;
  end;
  FClasses.Reindex();
end;

procedure TmstMPClassifier.SetMPCategoryVisible(MpStatusId, MpCategoryId: Integer; Visible: Boolean);
var
  I: Integer;
  Entry: TMPClassEntry;
begin
  Entry := FStatusArr[MpStatusId];
  if Entry = nil then
  begin
    Entry := TMPClassEntry.Create;
    FStatusArr[MpStatusId] := Entry;
  end;
  Entry.SetCategoryVisible(MpCategoryId, Visible);
end;

procedure TmstMPClassifier.SetMPStatusVisible(MpStatusId: Integer; Visible: Boolean);
var
  I: Integer;
  Entry: TMPClassEntry;
begin
  Entry := nil;
//  if MpStatusId < 0 then
//    Exit;
  if FStatusArr[MpStatusId] = nil then
  begin
    Entry := TMPClassEntry.Create;
    FStatusArr[MpStatusId] := Entry;
  end
  else
    Entry := FStatusArr[MpStatusId];
  Entry.FVisible := Visible;
end;

procedure TmstMPClassifier.SetMPVisible(const Value: Boolean);
begin
  FMPVisible := Value;
end;

{ TMPClassEntry }

constructor TMPClassEntry.Create;
var
  I: Integer;
begin
//  FCategories := TStringList.Create;
//  FCategories.Sorted := True;
  for I := 0 to 255 do
    FCats[I] := nil;
end;

destructor TMPClassEntry.Destroy;
var
  I: Integer;
begin
  for I := 0 to 255 do
    if FCats[I] <> nil then
      FCats[I].Free;
//  ClearList();
//  FCategories.Free;
  inherited;
end;

function TMPClassEntry.GetCategoryVisible(MpCategoryId: Integer): Boolean;
var
  I: Integer;
  Entry: TMPClassEntry;
begin
  Entry := FCats[MpCategoryId];
  if Entry <> nil then
    Result := Entry.FVisible
  else
    Result := False;
end;

procedure TMPClassEntry.SetCategoryVisible(MpCategoryId: Integer; Value: Boolean);
var
  I: Integer;
  Entry: TMPClassEntry;
begin
  Entry := FCats[MpCategoryId];
  if Entry = nil then
    FCats[MpCategoryId] := TMPClassEntry.Create;
  FCats[MpCategoryId].FVisible := Value;
end;

{ TMPObjClassesList }

procedure TMPObjClassesList.AddClass(const DbId, CatId: Integer; const ObjClassId, ObjClassName: string; aColor: TColor);
var
  Entry: TMPObjClassEntry;
begin
  Entry := TMPObjClassEntry.Create;
  Entry.fDbId := DbId;
  Entry.fObjClassId := ObjClassId;
  Entry.fCatId := CatId;
  Entry.fObjClassName := ObjClassName;
  Entry.fColor := aColor;
  FList.Add(Entry);
end;

function TMPObjClassesList.CheckDbId(Item: Pointer): Boolean;
begin
  Result := TMPObjClassEntry(Item).fDbId = FBinSearchDbId;
end;

procedure TMPObjClassesList.Clear;
begin
  FList.Clear;
end;

function TMPObjClassesList.CompareDbId(Item: Pointer): Integer;
begin
  Result := TMPObjClassEntry(Item).fDbId - FBinSearchDbId;
end;

constructor TMPObjClassesList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TMPObjClassesList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TMPObjClassesList.Find(const DbId: Integer; const BinSearch: Boolean): TMPObjClassEntry;
var
  I: Integer;
  Entry: TMPObjClassEntry;
begin
  Result := nil;
  if BinSearch then
  begin
    FBinSearchDbId := DbId;
    I := DoBinarySearch(FList, CheckDbId, CompareDbId);
    if I >= 0 then
      Result := TMPObjClassEntry(FList[I]);
  end
  else
  begin
    for I := 0 to FList.Count - 1 do
    begin  
      Entry := TMPObjClassEntry(FList[I]);
      if Entry.fDbId = DbId then
      begin
        Result := Entry;
        Exit;
      end;
    end;
  end;
end;

procedure TMPObjClassesList.Reindex;
begin
  FList.Sort(CompareMPObjClassEntries);
end;

end.
