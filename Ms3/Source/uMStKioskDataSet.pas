unit uMStKioskDataSet;

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

interface

uses
  SysUtils, Windows, Classes, DB, Forms, Contnrs,
  uMStKernelClasses;

type
  TDBCursor = type Integer; //1,2,...
  TDefloatMode = (dmInsert, dmOverwrite);
  TRecordBuffer = packed record
    RecordIndex: TDBCursor; //Absolute index of record in DB (>=0)
    BookmarkFlag: TBookmarkFlag;
  end;
  PRecordBuffer = ^TRecordBuffer;

  TmstObjectCompareEvent = function (Obj1, Obj2: TmstObject): Integer of object;

  TBkmList = class
  private
    FData: TStringList; // список закладка + объект, индекс равен номеру записи
    FDataSorted: TStringList; // список закладок дл быстрого поиска по закладке
    function GetBkms(Index: Integer): TBookmarkStr;
    procedure SetBkms(Index: Integer; const Value: TBookmarkStr);
    function GetObject(Index: Integer): TmstObject;
    procedure SetObject(Index: Integer; const Value: TmstObject);
    procedure DoQuickSort(L, R: Integer; Compare: TmstObjectCompareEvent);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(Bkm: TBookmarkStr; anObject: TmstObject);
    procedure Clear;
    function  Count: Integer;
    procedure Delete(Bookmark: TBookmarkStr);
    function  FindBkm(Bookmark: TBookmarkStr): Integer;
    procedure Sort(Compare: TmstObjectCompareEvent);
    //
    property Bkms[Index: Integer]: TBookmarkStr read GetBkms write SetBkms;
    property Objects[Index: Integer]: TmstObject read GetObject write SetObject;
  end;

  TmstKioskDataSet = class(TDataSet)
  private
    FBkmList: TBkmList;
    FList: TmstKioskList;
    FCursor: Integer;
    FIsOpen: Boolean;
    FIndexField: String;
    procedure SetIndexField(const Value: String);
  protected
    function  CompareObjects(Obj1, Obj2: TmstObject): Integer;
    function  GetKiosk: TmstKiosk;
    function  IntGetFieldData(Index: Integer; Field: TField; out Data): Boolean;
  protected
    function  AllocRecordBuffer: PChar; override;
    procedure DoBeforeInsert; override;
    procedure Finalize; virtual;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function  GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function  GetCanModify: Boolean; override;
    function  GetRecNo: Integer; override;
    function  GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean):
      TGetResult; override;
    function  GetRecordCount: Integer; override;
    procedure InternalAddRecord(Buffer: Pointer; DoAppend: Boolean); override;
    procedure InternalCancel; override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalEdit; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalInsert; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function  IsCursorOpen: Boolean; override;
    procedure SetActive(Value: Boolean); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetRecNo(Value: Integer); override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    //
    function BookmarkValid(Bookmark: TBookmark): Boolean; override;
    function  GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    //
    procedure DeleteKiosk(Bkm: TBookmarkStr);
    procedure LoadData(aList: TmstKioskList);
    //
    property IndexField: String read FIndexField write SetIndexField;
  published
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  end;

implementation

uses
  DateUtils, Math,
  uKisConsts, uMStKernelConsts;

function CompareDateStr(const S1, S2: String): Integer;
var
  D1, D2: TDateTime;
  B1, B2: Boolean;
begin
  B1 := TryStrToDate(S1, D1);
  B2 := TryStrToDate(S2, D2);
  if B1 and B2 then
    Result := CompareDate(D1, D2)
  else
  if B1 then
    Result := 1
  else
  if B2 then
    Result := -1
  else
    Result := 0;
end;

function TmstKioskDataSet.CompareObjects(Obj1, Obj2: TmstObject): Integer;
var
  K1, K2: TmstKiosk;
  S1, S2: String;
  I1, I2: Integer;
begin
  Result := 0;
  K1 := TmstKiosk(Obj1);
  K2 := TmstKiosk(Obj2);
  if (FIndexField = '') or (FIndexField = SF_ID) then
  begin
    Result := Sign(Obj1.DatabaseId - Obj2.DatabaseId);
  end
  else
  if FIndexField = SF_REGION then
  begin
    Result := AnsiCompareStr(K1.Region, K2.Region);
  end
  else
  if FIndexField = SF_ADDRESS then
  begin
    Result := AnsiCompareStr(K1.Address, K2.Address);
  end
  else
  if FIndexField = SF_KIND then
  begin
    if K1.Kind = kkKiosk then
      S1 := ' иоск'
    else
      S1 := 'ѕавильон';
    if K2.Kind = kkKiosk then
      S2 := ' иоск'
    else
      S2 := 'ѕавильон';
    Result := AnsiCompareStr(S1, S2);
  end
  else
  if FIndexField = SF_CUSTOMER_NAME then
  begin
    Result := AnsiCompareStr(K1.CustomerName, K2.CustomerName);
  end
  else
  if FIndexField = SF_ORDER_NUMBER then
  begin
    Result := AnsiCompareStr(K1.OrderNumber, K2.OrderNumber);
  end
  else
  if FIndexField = SF_ORDER_DATE then
  begin
    Result := CompareDateStr(K1.OrderDate, K2.OrderDate);
  end
  else
  if FIndexField = SF_STATUS then
  begin
    if K1.Actual then
      I1 := 1
    else
      I1 := 0;
    if K2.Actual then
      I2 := 1
    else
      I2 := 0;
    Result := I1 - I2;
  end
  else
  if FIndexField = SF_ANNUL_DATE then
  begin
    Result := CompareDateStr(K1.AnnulDate, K2.AnnulDate);
  end
  else
  if FIndexField = SF_EXECUTOR then
  begin
    Result := AnsiCompareStr(K1.Executor, K2.Executor);
  end
  else
  if FIndexField = SF_AREA then
  begin
    Result := Sign(K1.Area - K2.Area);
  end;
  //
  if Result = 0 then
  begin
    Result := Sign(Obj1.DatabaseId - Obj2.DatabaseId);
  end;
end;

constructor TmstKioskDataSet.Create(AOwner:TComponent);
begin
  inherited;
  FBkmList := TBkmList.Create;
  FList := TmstKioskList.Create;
  FIsOpen := False;
  BookmarkSize := 10;
end;

function TmstKioskDataSet.AllocRecordBuffer: PChar;
begin
  GetMem(Result, SizeOf(TRecordBuffer));
  PRecordBuffer(Result)^.RecordIndex := 0;
  PRecordBuffer(Result)^.BookmarkFlag := bfCurrent;
end;

function TmstKioskDataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
  Result := FBkmList.FindBkm(String(Bookmark)) >= 0;
end;

procedure TmstKioskDataSet.DeleteKiosk(Bkm: TBookmarkStr);
var
  I: Integer;
begin
  DisableControls;
  try
    I := FBkmList.FindBkm(Bkm);
    if I >= 0 then
    begin
      FList.Remove(FBkmList.Objects[I]);
      FBkmList.Delete(Bkm);
      if FCursor = I then
        if FCursor >= FList.Count then
          Dec(FCursor);
    end;
  finally
    EnableControls;
  end;
end;

destructor TmstKioskDataSet.Destroy;
begin
  FList.Free;
  FBkmList.Free;
  inherited;
end;

procedure TmstKioskDataSet.DoBeforeInsert;
begin
  inherited;
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.DoBeforeInsert is not implemented');
end;

procedure TmstKioskDataSet.Finalize;
begin
  //Cancel; //вдруг что-то редактировалось
end;

procedure TmstKioskDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  FreeMem(Buffer);
end;

procedure TmstKioskDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
var
  Res: String;
begin
  if BookmarkSize <> 0 then
  begin
    Res := FBkmList.Bkms[PRecordBuffer(Buffer)^.RecordIndex];
    StrPCopy(Data, Res);
  end;
end;

function TmstKioskDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecordBuffer(Buffer)^.BookmarkFlag;
end;

function TmstKioskDataSet.GetCanModify: Boolean;
begin
  Result := False;
end;

function TmstKioskDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  Index: Integer;
begin
  Result := not Self.IsEmpty;
  if Result then
  begin
    Index := PRecordBuffer(ActiveBuffer)^.RecordIndex;
    Result := IntGetFieldData(Index, Field, Buffer^);
  end;
end;

function TmstKioskDataSet.GetKiosk: TmstKiosk;
begin
  Result := FBkmList.Objects[FCursor] as TmstKiosk;
end;

function TmstKioskDataSet.GetRecNo: Integer;
begin
  Result := PRecordBuffer(ActiveBuffer)^.RecordIndex;
end;

function TmstKioskDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck:
  Boolean): TGetResult;
begin
  Result := grOK;
  case GetMode of
    gmPrior :
      if FCursor <= 1 then
        Result := grBOF
      else
        Dec(FCursor);
    gmNext :
      if FCursor >= RecordCount then
        Result := grEOF
      else
        Inc(FCursor);
    gmCurrent :
      if (FCursor < 1) or (FCursor > RecordCount) then
        Result := grError;
  end;
  if Result = grOK then
  with PRecordBuffer(Buffer)^ do
  begin
    RecordIndex := FCursor;
    BookmarkFlag := bfCurrent;
  end;
  if (Result = grError) and DoCheck then
    DatabaseError('Error in GetRecord()!');
end;

function TmstKioskDataSet.GetRecordCount: Integer;
begin
  if Assigned(FList) then
    Result := FList.Count
  else
    Result := 0;
end;

procedure TmstKioskDataSet.InternalAddRecord(Buffer: Pointer; DoAppend: Boolean);
begin
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalAddRecord is not implemented');
end;

procedure TmstKioskDataSet.InternalCancel;
begin
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalCancel is not implemented');
end;

procedure TmstKioskDataSet.InternalClose;
begin
  BindFields(False);
  if DefaultFields then
    DestroyFields;
  FIsOpen := False;
end;

procedure TmstKioskDataSet.InternalDelete;
begin
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalDelete is not implemented');
{  if FCursor >= FPerformGetRecordCount() then
    Last; }
  //Dec(FCursor);
end;

procedure TmstKioskDataSet.InternalEdit;
begin
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalEdit is not implemented');
end;

procedure TmstKioskDataSet.InternalFirst;
begin
  FCursor := 0;
end;

procedure TmstKioskDataSet.InternalGotoBookmark(Bookmark: Pointer);
var
  APos: Integer;
begin
  APos := FBkmList.FindBkm(String(Bookmark));
  if APos >= 0 then
    FCursor := APos;
end;

procedure TmstKioskDataSet.InternalHandleException;
begin
  Application.HandleException(Self)
end;

procedure TmstKioskDataSet.InternalInitFieldDefs;
begin
  FieldDefs.Clear;
  FieldDefs.Add(SF_ID, ftInteger);
  FieldDefs.Add(SF_REGION, ftString, 20);
  FieldDefs.Add(SF_ADDRESS, ftString, 5000);
  FieldDefs.Add(SF_KIND, ftString, 10);
  FieldDefs.Add(SF_CUSTOMER_NAME, ftString, 5000);
  FieldDefs.Add(SF_ORDER_NUMBER, ftString, 20);
  FieldDefs.Add(SF_ORDER_DATE, ftString, 20);
  FieldDefs.Add(SF_STATUS, ftString, 15);
  FieldDefs.Add(SF_ANNUL_DATE, ftString, 20);
  FieldDefs.Add(SF_EXECUTOR, ftString, 250);
  FieldDefs.Add(SF_AREA, ftString, 15);
end;

procedure TmstKioskDataSet.InternalInitRecord(Buffer: PChar);
begin
  inherited;
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalInitRecord is not implemented');
end;

procedure TmstKioskDataSet.InternalInsert;
begin
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalInsert is not implemented');
end;

procedure TmstKioskDataSet.InternalLast;
begin
  FCursor := Succ(RecordCount);
end;

procedure TmstKioskDataSet.InternalOpen;
begin
  InternalInitFieldDefs;
  if DefaultFields then
    CreateFields;
  BindFields(True);
  FIsOpen := True;
  FCursor := 0;
  BookmarkSize := 10;
end;

procedure TmstKioskDataSet.InternalPost;
begin
//  inherited; //=CheckRequiredFields
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.InternalPost is not implemented');
end;

procedure TmstKioskDataSet.InternalSetToRecord(Buffer: PChar);
begin
  FCursor := PRecordBuffer(Buffer)^.RecordIndex;
end;

function TmstKioskDataSet.IntGetFieldData(Index: Integer; Field: TField; out Data): Boolean;
var
  Kiosk: TmstKiosk;
  PI: PInteger;
  PS: PChar;
  StrValue: String;

  procedure GetStrValue();
  begin
    StrValue := IntToStr(Index);
    if Length(StrValue) > Field.DataSize then
      SetLength(StrValue, Field.DataSize);
    PS := PChar(StrValue);
    StrLCopy(@Data, PS, Length(StrValue));
  end;

begin
  Kiosk := GetKiosk;
  Result := Assigned(Kiosk);
  if not Result then
    Exit;
  //
  if Field.Name = SF_ID then
  begin
    PI := @Data;
    PI^ := Kiosk.DatabaseId;
  end
  else
  if Field.Name = SF_REGION then
  begin
    StrValue := Kiosk.Region;
    GetStrValue;
  end
  else
  if Field.Name = SF_ADDRESS then
  begin
    StrValue := Kiosk.Address;
    GetStrValue;
  end
  else
  if Field.Name = SF_KIND then
  begin
    if Kiosk.Kind = kkKiosk then
      StrValue := ' иоск'
    else
      StrValue := 'ѕавильон';
    GetStrValue;
  end
  else
  if Field.Name = SF_CUSTOMER_NAME then
  begin
    StrValue := Kiosk.CustomerName;
    GetStrValue;
  end
  else
  if Field.Name = SF_ORDER_NUMBER then
  begin
    StrValue := Kiosk.OrderNumber;
    GetStrValue;
  end
  else
  if Field.Name = SF_ORDER_DATE then
  begin
    StrValue := Kiosk.OrderDate;
    GetStrValue;
  end
  else
  if Field.Name = SF_STATUS then
  begin
    if Kiosk.Actual then
      StrValue := 'действует'
    else
      StrValue := 'аннулирован';
    GetStrValue;
  end
  else
  if Field.Name = SF_ANNUL_DATE then
  begin
    StrValue := Kiosk.AnnulDate;
    GetStrValue;
  end
  else
  if Field.Name = SF_EXECUTOR then
  begin
    StrValue := Kiosk.Executor;
    GetStrValue;
  end
  else
  if Field.Name = SF_AREA then
  begin
    StrValue := Format('%8.2f', [Kiosk.Area]);
    GetStrValue;
  end;
end;

function TmstKioskDataSet.IsCursorOpen: Boolean;
begin
  Result := FIsOpen;
end;

procedure TmstKioskDataSet.LoadData(aList: TmstKioskList);
var
  I: Integer;
  Ksk: TmstKiosk;
begin
  // присоедин€ем список
  FList := aList;
  FCursor := 0;
  // заполн€ем букмарки
  FBkmList.Clear;
  for I := 0 to Pred(aList.Count) do
  begin
    Ksk := aList[I];
    FBkmList.Add(IntToHex(Ksk.DatabaseId, 10), Ksk);
  end;
  //
  FBkmList.Sort(CompareObjects);
end;

procedure TmstKioskDataSet.SetActive(Value: Boolean);
begin
  if (Value <> Active) and (Value = False) then Finalize;
  inherited;
end;

procedure TmstKioskDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  //FBkmList.Bkms[PRecordBuffer(Buffer)^.RecordIndex] := String(PChar(Data));
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.SetBookmarkData is not implemented');
end;

procedure TmstKioskDataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecordBuffer(Buffer)^.BookmarkFlag := Value;
end;

procedure TmstKioskDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  raise Exception.Create('¬нутренн€€ ошибка!' + #13#10 + 'TmstDataSet.SetFieldData is not implemented');
end;

procedure TmstKioskDataSet.SetIndexField(const Value: String);
begin
  FIndexField := Value;
  FBkmList.Sort(CompareObjects);
end;

procedure TmstKioskDataSet.SetRecNo(Value: Integer);
begin
  CheckBrowseMode;
  if (Value < 1) or (Value >= Succ(RecordCount)) then
    Exit;
  FCursor := Value;
  Resync([]);
end;

{ TBkmList }

procedure TBkmList.Add(Bkm: TBookmarkStr; anObject: TmstObject);
var
  I: Integer;
begin
  I := FData.AddObject(Bkm, anObject);
  FDataSorted.AddObject(Bkm, Pointer(I));
end;

procedure TBkmList.Clear;
begin
  FData.Clear;
  FDataSorted.Clear;
end;

function TBkmList.Count: Integer;
begin
  Result := FData.Count;
end;

constructor TBkmList.Create;
begin
  FData := TStringList.Create;
  FDataSorted := TStringList.Create;
  FDataSorted.Sorted := True;
end;

procedure TBkmList.Delete(Bookmark: TBookmarkStr);
var
  I: Integer;
begin
  I := FindBkm(Bookmark);
  if I >= 0 then
  begin
    FDataSorted.Delete(FDataSorted.IndexOf(Bookmark));
    FData.Delete(I);
  end;
end;

destructor TBkmList.Destroy;
begin
  FDataSorted.Free;
  FData.Free;
  inherited;
end;

procedure TBkmList.DoQuickSort(L, R: Integer; Compare: TmstObjectCompareEvent);
var
  I, J: Integer;
  P: TmstObject;
begin
  repeat
    I := L;
    J := R;
    P := Objects[(L + R) shr 1];
    repeat
      while Compare(Objects[I], P) < 0 do
        Inc(I);
      while Compare(Objects[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        FData.Exchange(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      DoQuickSort(L, J, Compare);
    L := I;
  until I >= R;
end;

function TBkmList.FindBkm(Bookmark: TBookmarkStr): Integer;
var
  I: Integer;
begin
  I := FDataSorted.IndexOf(Bookmark);
  Result := Integer(FDataSorted.Objects[I]);
end;

function TBkmList.GetBkms(Index: Integer): TBookmarkStr;
begin
  Result := FData[Index];
end;

function TBkmList.GetObject(Index: Integer): TmstObject;
begin
  Result := TmstObject(FData.Objects[Index]);
end;

procedure TBkmList.SetBkms(Index: Integer; const Value: TBookmarkStr);
var
  Old: TBookmarkStr;
  I: Integer;
begin
  Old := FData[Index];
  FData[Index] := Value;
  //
  I := FDataSorted.IndexOf(Old);
  if I >= 0 then
    FDataSorted.Delete(I);
  FDataSorted.AddObject(Value, Pointer(Index));
end;

procedure TBkmList.SetObject(Index: Integer; const Value: TmstObject);
begin
  FData.Objects[Index] := Value;
end;

procedure TBkmList.Sort(Compare: TmstObjectCompareEvent);
var
  I: Integer;
begin
  if Assigned(Compare) and (Count > 0) then
  begin
    DoQuickSort(0, Count - 1, Compare);
    FDataSorted.Clear;
    for I := 0 to Pred(FData.Count) do
      FDataSorted.AddObject(FData[I], Pointer(I));
  end;
end;

end.
