unit ObjectPooler;

interface

uses SysUtils, Classes, Forms, SyncObjs, Windows;

type

  TObjectClass = class of TComponent; // "class" reference

  TPooledObject = record
    Object_: TObject; // Point to a TDataModule descendant instance
    InUse: Boolean;      // Indicates, whether Module is in use or not
  end;

  TObjectPooler = class
  private
    FCSect: TCriticalSection;       
    FObjectClass: TObjectClass;
    FObjects: array of TPooledObject;
    FSemaphore: THandle;
  public
    property ObjectClass: TObjectClass read FObjectClass write FObjectClass;
    constructor Create;
    destructor Destroy; override;
    function GetObject: TObject;
    procedure FreeObject(Obj: TObject);
  end;

implementation

const PoolSize = 127;

{ TObjectPooler }

constructor TObjectPooler.Create;
begin
  IsMultiThread := True;
  FCSect := TCriticalSection.Create;
  FSemaphore := CreateSemaphore(nil, PoolSize, PoolSize, nil);
end;

destructor TObjectPooler.Destroy;
begin
  FCSect.Free;
  CloseHandle(FSemaphore);
end;

procedure TObjectPooler.FreeObject(Obj: TObject);
var
  I: Integer;
begin
  FCSect.Enter;
  try
    for I := 0 to Length(FObjects) - 1 do
      if FObjects[I].Object_ = Obj then
        FObjects[I].InUse := False;
    ReleaseSemaphore(FSemaphore, 1, nil);
  finally
    FCSect.Leave;
  end;
end;

function TObjectPooler.GetObject: TObject;
var
  I: Integer;
begin
  Result := nil;
  if WaitForSingleObject(FSemaphore, 5000) = WAIT_TIMEOUT then
    raise Exception.Create('Server too busy');
  FCSect.Enter;
  try
    if Length(FObjects) = 0 then
    begin
      SetLength(FObjects, PoolSize);
      for I := 0 to PoolSize - 1 do
        begin
          FObjects[I].InUse := False;
          FObjects[I].Object_ := FObjectClass.Create(Application);
        end;
    end;
    for I := 0 to Length(FObjects) - 1 do
      if not FObjects[I].InUse then
      begin
        FObjects[I].InUse := True;
        Result := FObjects[I].Object_;
        Break;
      end;
  finally
    FCSect.Leave;
  end;
  //Check if we ran out of connections
  if not Assigned(Result) then
    raise Exception.Create('Pool is out of capacity');
end;

end.
 