{*******************************************************}
{                                                       }
{                                                       }
{       Custom DataSet Unit                             }
{                                                       }
{       Copyright (c) 2004, Калабухов А.В.              }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Custom DataSet
  Версия: 1.01
  Дата последнего изменения: 22.03.2005
  Цель: содержит классы-заготовки для создания произвольных датасетов.
  Используется:
  Использует: только системные юниты
  Исключения: нет }

{
  1.01
     - исправлена ошибка создания буфера (AV при Insert)
}

unit uDataSet;

interface

uses
  // System
  SysUtils, Classes, DB, Forms;

type
  TDBCursor = type Integer; //1,2,...
  TDefloatMode = (dmInsert, dmOverwrite);
  TRecordBuffer = packed record
    RecordIndex: TDBCursor; //Absolute index of record in DB (>=0)
    BookmarkFlag: TBookmarkFlag;
  end;
  PRecordBuffer = ^TRecordBuffer;

  TDataSetController = class(TComponent)
  public
    procedure ClearFields(Index : integer); virtual; abstract;
    function CreateFloatingRecord(SourceIndex : integer): Integer; virtual;
            abstract;
    procedure DefloatRecord(FlIndex, DestIndex:integer;
            DefloatMode:TDefloatMode); virtual; abstract;
    procedure DeleteRecord(Index:integer); virtual; abstract;
    procedure FillFieldDefs(FieldDefsRef:TFieldDefs); virtual; abstract;
    function FindBookmark(Bookmark:TBookmarkStr): Integer; virtual; abstract;
    procedure FreeFloatingRecord(Index : integer); virtual; abstract;
    function GetBookmark(Index:integer): TBookmarkStr; virtual; abstract;
    function GetBookmarkSize: Integer; virtual; abstract;
    function GetCanModify: Boolean; virtual; abstract;
    function GetFieldData(Index:integer; Field: TField; out Data): Boolean; virtual; 
            abstract;
    function GetRecordCount: Integer; virtual; abstract;
    procedure SetBookmark(Index:integer; NewBookmark:TBookmarkStr); virtual; 
            abstract;
    procedure SetFieldData(Index:integer; Field: TField; var Data); virtual; 
            abstract;
  end;
  
  TCustomDataSet = class(TDataSet)
  public type
    TFieldDefsNotifyEvent = procedure (FieldDefsRef: TFieldDefs) of object;
    TDataSetEvent = procedure (DS: TDataSet) of object;
    TSetFieldValueEvent = function (Index: Integer; Field: TField; out Data): Boolean of object;
    TGetFieldValueEvent = procedure (Index: Integer; Field: TField; var Data) of object;
  private
    FController: TDataSetController;
    FCursor: Integer;
    FEditingBuffer: PChar;
    FFloatingRecordIndex: Integer;
    FInsertingBefore: Integer;
    FIsOpen: Boolean;
    FPerformOpenConnection: TDataSetNotifyEvent;
    FPerformCloseConnection: TDataSetNotifyEvent;
    FPerformFillFieldDefs: TFieldDefsNotifyEvent;
    FPerformGetFieldData: TSetFieldValueEvent;
    FPerformSetFieldData: TGetFieldValueEvent;
    FPerformGetCanModify: function: Boolean of object;
    FPerformGetRecordCount: function: Integer of object;
    FPerformDeleteRecord: procedure (Index: Integer) of object;
    FPerformClearFields: procedure (Index: Integer) of object;
    FPerformCreateFloatingRecord: function (SourceIndex: Integer): Integer of object; //SourceIndex=0, если создаем
      //чистую запись, а не копию с SourceIndex
    FPerformFreeFloatingRecord: procedure (Index: Integer) of object;
    FPerformDefloatRecord: procedure (FlIndex, DestIndex: Integer; DefloatMode: TDefloatMode) of object;
    FPerformGetBookmarkSize: function: Integer of object;
    FPerformGetBookmark: function (Index: Integer): TBookmarkStr of object;
    FPerformSetBookmark: procedure (Index: Integer; NewBookmark: TBookmarkStr) of object;
    FPerformFindBookmark: function (Bookmark: TBookmarkStr): Integer of object;
    procedure SetController(Value: TDataSetController);
  protected
    function AllocRecordBuffer: PChar; override;
    procedure DoBeforeInsert; override;
    procedure Finalize; virtual;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetCanModify: Boolean; override;
    function GetRecNo: Integer; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): 
            TGetResult; override;
    function GetRecordCount: Integer; override;
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
    function IsCursorOpen: Boolean; override;
    procedure SetActive(Value: Boolean); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetRecNo(Value: Integer); override;
  public
    constructor Create(AOwner:TComponent); override;
    function BookmarkValid(Bookmark: TBookmark): Boolean; override;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
    function DataSetEquals(aDataSet: TCustomDataSet): Boolean;
  published
    property Controller: TDataSetController read FController write
            SetController;
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
  Variants;

constructor TCustomDataSet.Create(AOwner:TComponent);
begin
  inherited;
  FIsOpen := False;
  if Assigned(FPerformGetBookmarkSize) then
    BookmarkSize := FPerformGetBookmarkSize()
  else
    BookmarkSize := 0;
end;

function TCustomDataSet.AllocRecordBuffer: PChar;
begin
  GetMem(Result, SizeOf(TRecordBuffer));
  // 22.03.2005
  PRecordBuffer(Result)^.RecordIndex := 0;
  PRecordBuffer(Result)^.BookmarkFlag := bfCurrent;
end;

function TCustomDataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
  Result := Assigned(FPerformFindBookmark);
  if Result then
    Result := (-1 <> FPerformFindBookmark(String(Bookmark)))
end;

procedure TCustomDataSet.DoBeforeInsert;
begin
  inherited;
  FInsertingBefore := PRecordBuffer(ActiveBuffer)^.RecordIndex;
end;

procedure TCustomDataSet.Finalize;
begin
  Cancel; //вдруг что-то редактировалось
end;

procedure TCustomDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  FreeMem(Buffer, SizeOf(TRecordBuffer));
end;

procedure TCustomDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
var
  Res: String;
begin
  if BookmarkSize <> 0 then
  begin
    if Assigned(FPerformGetBookmark) then
      Res := FPerformGetBookmark(PRecordBuffer(Buffer)^.RecordIndex)
    else
      Res := '';
    StrPCopy(Data, Res);
  end;
end;

function TCustomDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecordBuffer(Buffer)^.BookmarkFlag;
end;

function TCustomDataSet.GetCanModify: Boolean;
begin
  if Assigned(FPerformGetCanModify) then
    Result := FPerformGetCanModify
  else
    Result := False;
end;

function TCustomDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  Index: Integer;
begin
  Result := Assigned(Buffer) and (not (Self.IsEmpty) and Assigned(FPerformGetFieldData));
  if Result then
  begin
    if (State in dsEditModes) and (ActiveBuffer = FEditingBuffer) then
      Index := FFloatingRecordIndex //перенаправляем к Floating record
    else
      Index := PRecordBuffer(ActiveBuffer)^.RecordIndex;
      Result := FPerformGetFieldData(Index, Field, Buffer^);
  end;
end;

function TCustomDataSet.GetRecNo: Integer;
begin
  Result := PRecordBuffer(ActiveBuffer)^.RecordIndex;
end;

function TCustomDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck:
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

function TCustomDataSet.GetRecordCount: Integer;
begin
  if Assigned(FPerformGetRecordCount) then
    Result := FPerformGetRecordCount()
  else
    raise EDatabaseError.Create('Для работы с ' + ClassName
      + ' требуется задать обработчик события OnGetRecordCount!');
end;

procedure TCustomDataSet.InternalAddRecord(Buffer: Pointer; DoAppend: Boolean);
  
  //По хелпу при вызове InsertRecord активной становится вставленная запись
  //Причем можно отследить, что заботиться об этом должна InternalAddRecord
  //Поэтому в случае DoAppend просто прыгаем в конец (вернее, за конец)
  
begin
  //В момент вызова уже создана Floating-запись, и в нее скопированы значения
  if DoAppend then
    InternalLast;
  FPerformDefloatRecord(FFloatingRecordIndex, FCursor, dmInsert);
end;

procedure TCustomDataSet.InternalCancel;
begin
  if Assigned(FPerformFreeFloatingRecord) then
    FPerformFreeFloatingRecord(FFloatingRecordIndex);
end;

procedure TCustomDataSet.InternalClose;
begin
  If Assigned(FPerformCloseConnection) then
    FPerformCloseConnection(Self);
  BindFields(False);
  if DefaultFields then
    DestroyFields;
  FIsOpen := False;
end;

procedure TCustomDataSet.InternalDelete;
begin
  if not Assigned(FPerformGetRecordCount) then
    raise EDatabaseError.Create('Для работы с ' + ClassName
      + ' требуется задать обработчик события PerformGetRecordCount!');
  if Assigned(FPerformDeleteRecord) then
    FPerformDeleteRecord(PRecordBuffer(ActiveBuffer)^.RecordIndex);
{  if FCursor >= FPerformGetRecordCount() then
    Last; }
  dec(FCursor);
end;

procedure TCustomDataSet.InternalEdit;
begin
  FEditingBuffer := ActiveBuffer;
  if Assigned(FPerformCreateFloatingRecord) then
    FFloatingRecordIndex := FPerformCreateFloatingRecord(PRecordBuffer(ActiveBuffer)^.RecordIndex);
end;

procedure TCustomDataSet.InternalFirst;
begin
  FCursor := 0;
end;

procedure TCustomDataSet.InternalGotoBookmark(Bookmark: Pointer);
var
  APos: Integer;
begin
  if not assigned(FPerformFindBookmark) then exit;
  APos := FPerformFindBookmark(String(Bookmark));
  if APos >= 0 then
    FCursor := APos;
end;

procedure TCustomDataSet.InternalHandleException;
begin
  Application.HandleException(Self)
end;

procedure TCustomDataSet.InternalInitFieldDefs;
begin
  If Assigned(FPerformFillFieldDefs) then
    FPerformFillFieldDefs(FieldDefs)
  else
    FieldDefs.Clear;
end;

procedure TCustomDataSet.InternalInitRecord(Buffer: PChar);
  //Вообще-то, это просто операция очистки записи.
  //Так как наш буфер не содержит указателей на динамически создаваемые структуры данных,
  //то нам не нужно удалять структуры, связанные с предыдущим содержимым буфера.
  //Но вот для слоя реализации (FPerformXXX) это может быть необходимо, и его надо
  //подробно уведомить о ситуации
begin
  //Если же это повторный вызов (когда TDataSet уже находится в одном из режимов
  //редактирования) - такой выполняется при ClearFields - то надо просто очистить запись.
  //В противном случае TDataSet хочет вставить новую запись, и мы ее сначала должны создать.
  if not (State in dsEditModes) then
    if Assigned(FPerformCreateFloatingRecord) then
      FFloatingRecordIndex := FPerformCreateFloatingRecord(0);
  if Assigned(FPerformClearFields) then
    FPerformClearFields(PRecordBuffer(ActiveBuffer)^.RecordIndex);
end;

procedure TCustomDataSet.InternalInsert;
begin
  FEditingBuffer := ActiveBuffer;
  //Чтобы InternalSetToRecord переходил на правильную позицию
  with PRecordBuffer(ActiveBuffer)^ do
    if BookmarkFlag = bfInserted
      then RecordIndex := FInsertingBefore;
  //А если bfEOF или bfBOF, то InternalSetToRecord и не будет вызываться
end;

procedure TCustomDataSet.InternalLast;
begin
  FCursor := Succ(RecordCount);
end;

procedure TCustomDataSet.InternalOpen;
begin
  InternalInitFieldDefs;
  if DefaultFields then
    CreateFields;
  BindFields(True);
  FIsOpen := True;
  FCursor := 0;
  if Assigned(FPerformGetBookmarkSize) then
    BookmarkSize := FPerformGetBookmarkSize()
  else
    BookmarkSize := 0;
  if Assigned(FPerformOpenConnection) then
    FPerformOpenConnection(Self);
end;

procedure TCustomDataSet.InternalPost;
begin
  inherited; //=CheckRequiredFields
  case State of
    dsEdit:
      if Assigned(FPerformDefloatRecord) then
        FPerformDefloatRecord(FFloatingRecordIndex, FCursor, dmOverwrite);
    dsInsert:
      begin
        if Assigned(FPerformDefloatRecord) then
          FPerformDefloatRecord(FFloatingRecordIndex, FCursor, dmInsert);
        PRecordBuffer(ActiveBuffer)^.RecordIndex := FCursor;
        PRecordBuffer(ActiveBuffer)^.BookMarkFlag := bfCurrent;
      end;
  end;
end;

procedure TCustomDataSet.InternalSetToRecord(Buffer: PChar);
begin
  FCursor := PRecordBuffer(Buffer)^.RecordIndex;
end;

function TCustomDataSet.IsCursorOpen: Boolean;
begin
  Result := FIsOpen;
end;

procedure TCustomDataSet.SetActive(Value: Boolean);
begin
  if (Value <> Active) and (Value = False) then Finalize;
  inherited;
end;

procedure TCustomDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  if Assigned(FPerformSetBookmark) then
    FPerformSetBookmark(PRecordBuffer(Buffer)^.RecordIndex, String(PChar(Data)));
end;

procedure TCustomDataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecordBuffer(Buffer)^.BookmarkFlag := Value;
end;

procedure TCustomDataSet.SetController(Value: TDataSetController);
begin
  FController := Value;
  if Assigned(FController) then
  begin
    FPerformFillFieldDefs := FController.FillFieldDefs;
    FPerformGetFieldData := FController.GetFieldData;
    FPerformGetRecordCount := FController.GetRecordCount;
    //Закладки
    FPerformGetBookmarkSize := FController.GetBookmarkSize;
    FPerformGetBookmark := FController.GetBookmark;
    FPerformSetBookmark := FController.SetBookmark;
    FPerformFindBookmark := FController.FindBookmark;
    {То, что нужно перекрыть для редактирования}
    FPerformGetCanModify := FController.GetCanModify;
    FPerformSetFieldData := FController.SetFieldData;
    FPerformDeleteRecord := FController.DeleteRecord;
    FPerformClearFields := FController.ClearFields;
    FPerformCreateFloatingRecord := FController.CreateFloatingRecord;
    FPerformFreeFloatingRecord := FController.FreeFloatingRecord;
    FPerformDefloatRecord := FController.DefloatRecord;
  end
  else
  begin
    FPerformOpenConnection := nil;
    FPerformCloseConnection := nil;
    FPerformFillFieldDefs := nil;
    FPerformGetFieldData := nil;
    FPerformSetFieldData := nil;
    FPerformGetCanModify := nil;
    FPerformGetRecordCount := nil;
    FPerformDeleteRecord := nil;
    FPerformClearFields := nil;
    FPerformCreateFloatingRecord := nil;
    FPerformFreeFloatingRecord := nil;
    FPerformDefloatRecord := nil;
    FPerformGetBookmarkSize := nil;
    FPerformGetBookmark := nil;
    FPerformSetBookmark := nil;
    FPerformFindBookmark := nil;
  end;
end;

procedure TCustomDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  //Для этой операции Index всегда является индексом плавающей записи
  //Перенаправляем изменения в Floating record
  if Assigned(FPerformSetFieldData) then
    FPerformSetFieldData(FFloatingRecordIndex, Field, Buffer^);
  DataEvent(deFieldChange, Cardinal(Field)); //Важно! Иначе DataSet не поймет,
                                             //что были изменения
end;

procedure TCustomDataSet.SetRecNo(Value: Integer);
begin
  CheckBrowseMode;
  if (Value < 1) or (Value >= Succ(RecordCount)) then Exit;
  FCursor := Value;
  Resync([]);
end;

function TCustomDataSet.DataSetEquals(aDataSet: TCustomDataSet): Boolean;
begin
  raise Exception.Create('Метод TCustomDataSet.DataSetEquals не реализован!');
end;

function TCustomDataSet.Locate(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
  aFieldList: TList;
  CurrentBkm: String;
  aField: Variant;
  aValues: array of Variant;
  I, FieldCnt: Integer;
  FieldStr : String;
begin
  aFieldList := TList.Create;
  try
    GetFieldList(aFieldList, KeyFields);
    FieldCnt := aFieldList.Count;
    CurrentBkm := Bookmark;
    result := False;
    SetLength(aValues, FieldCnt);
    if not Eof then
      for I := 0 to Pred(FieldCnt) do
      begin
        if VarIsArray(KeyValues) then
          aValues[I] := KeyValues[I]
        else
          aValues[I] := KeyValues;
        if (TField(aFieldList[I]).DataType = ftString) and
           not VarIsNull(aValues[I]) then
        begin
          if (loCaseInsensitive in Options) then
            aValues[I] := AnsiUpperCase(aValues[I]);
        end;
      end;
    while ((not Result) and (not Eof)) do
    begin
      I := 0;
      Result := True;
      while (Result and (I < FieldCnt)) do
      begin
        aField := TField(aFieldList[I]).Value;
        if VarIsNull(aField) then
          Result := Result and VarIsNull(aValues[I])
        else
        begin
          Result := Result and not VarIsNull(aValues[I]);
          if Result then
          begin
            try
              aField := VarAsType(aField, VarType(aValues[I]));
            except
              on E: EVariantError do Result := False;
            end;
            if TField(aFieldList[I]).DataType = ftString then
            begin
              FieldStr := TField(aFieldList[I]).AsString;
              if (loCaseInsensitive in Options) then
                FieldStr := AnsiUpperCase(FieldStr);
              if (loPartialKey in Options) then
                Result := Result and (AnsiPos(aValues[I], FieldStr) = 1)
              else
                Result := Result and (FieldStr = aValues[I]);
            end
            else
              if TField(aFieldList[I]).DataType in [ftDate, ftTime, ftDateTime] then
                Result := Result and (DateTimeToStr(aValues[I]) = DateTimeToStr(aField))
              else
                Result := Result and (aValues[i] = aField);
          end;
        end;
        Inc(I);
      end;
      if not Result then
        Next;
    end;
    if not Result then
      Bookmark := CurrentBkm
    else
      CursorPosChanged;
  finally
    aFieldList.Free;
    aValues := nil;
  end;
end;

end.
