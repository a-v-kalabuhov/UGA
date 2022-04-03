unit uClipboardSaver;

interface

uses
  Windows, Classes, Clipbrd, Contnrs;

type
  TClipboardSaver = class(TComponent)
  private
    FList: TObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure BackUp;
    procedure Restore;
  end;

implementation

type
  TDataFormat = Word;

  TClipboardAction = procedure of object;

  TBaseClipboardDataStorage = class
  private
    FFormat: TDataFormat;
    FFormatName: String;
    procedure LoadName;
  protected
    procedure DoClipboardAction(Action: TClipboardAction);
    procedure LoadFromClipboard; virtual;
    procedure SaveToClipboard; virtual; abstract;
  public
    constructor Create(aFormat: TDataFormat); virtual;
    property Format: TDataFormat read FFormat;
    property FormatName: String read FFormatName write FFormatName;
  end;

  TClipboardDataStorageFactory = class
  public
    function CreateStorage(aFormat: TDataFormat): TBaseClipboardDataStorage;
  end;

var
  StorageFactory: TClipboardDataStorageFactory;

type
  TGlobalMemStorage = class(TBaseClipboardDataStorage)
  private
    FData: TMemoryStream;
  protected
    procedure LoadFromClipboard; override;
    procedure SaveToClipboard; override;
  public
    constructor Create(aFormat: TDataFormat); override;
    destructor Destroy; override;
  end;

  TTextStorage = class(TBaseClipboardDataStorage)
  private
    FText: String;
  protected
    procedure LoadFromClipboard; override;
    procedure SaveToClipboard; override;
  end;

{ TClipboardData }

constructor TGlobalMemStorage.Create;
begin
  FData := TMemoryStream.Create;
end;

destructor TGlobalMemStorage.Destroy;
begin
  FData.Free;
  inherited;
end;

{ TClipboardSaver }

procedure TClipboardSaver.BackUp;
var
  I: Integer;
  aData: TBaseClipboardDataStorage;
begin
  Clear;
  Clipboard.Open;
  try
    for I := 0 to Pred(Clipboard.FormatCount) do
    begin
      aData := StorageFactory.CreateStorage(Clipboard.Formats[I]);
      if Assigned(aData) then
        FList.Add(aData);
    end;
  finally
    Clipboard.Close;
  end;
end;

procedure TClipboardSaver.Clear;
begin
  FList.Clear;
end;

constructor TClipboardSaver.Create(AOwner: TComponent);
begin
  inherited;
  FList := TObjectList.Create(True);
end;

destructor TClipboardSaver.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TClipboardSaver.Restore;
var
  I: Integer;
begin
	Clipboard.Open;
  try
    Clipboard.Clear;
    for I := 0 to Pred(FList.Count) do
      (FList[I] as TBaseClipboardDataStorage).SaveToClipboard;
  finally
  	Clipboard.Close;
  end;
end;

{ TBaseClipboardData }

constructor TBaseClipboardDataStorage.Create(aFormat: TDataFormat);
begin
  FFormat := aFormat;
  LoadFromClipboard;
end;

{ TClipboardDataStorageFactory }

function TClipboardDataStorageFactory.CreateStorage(
  aFormat: TDataFormat): TBaseClipboardDataStorage;
begin
//  case aFormat of
  Result := nil;
//  end;
end;

procedure TGlobalMemStorage.LoadFromClipboard;
var
  DataHandle: THandle;
  DataPointer: Pointer;
  DataSize: Integer;
begin
  inherited;
  ClipBoard.Open;
  try
    DataHandle := GetClipboardData(Format);
    if DataHandle = 0 then
      Exit;
    DataSize := GlobalSize(DataHandle);
    if DataSize > 0 then
    begin
      DataPointer := GlobalLock(DataHandle);
      FData.Write(Byte(DataPointer^), DataSize);
    end;
  finally
    Clipboard.Close;
  end;
end;

procedure TBaseClipboardDataStorage.DoClipboardAction(
  Action: TClipboardAction);
begin
  Clipboard.Open;
  try
    Action;
  finally
    Clipboard.Close;
  end;
end;

procedure TBaseClipboardDataStorage.LoadFromClipboard;
begin
  LoadName;
end;

procedure TBaseClipboardDataStorage.LoadName;
var
  S: String;
begin
  SetLength(S, 255);
  if GetClipboardFormatName(Format, @S[1], 255) = 0 then
    FFormatName := ''
  else
    FFormatName := S;
end;

procedure TGlobalMemStorage.SaveToClipboard;
var
  TmpFormat: TDataFormat;
  DataHandle: THandle;
  DataPointer, SavedDataPointer: Pointer;
begin
  inherited;
  TmpFormat := Format;
  if FormatName <> '' then
  begin
		TmpFormat := RegisterClipboardFormat(PChar(FormatName));
		if TmpFormat = 0 then
      TmpFormat := Format;
  end;
  DataHandle := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, FData.Size);
	DataPointer := GlobalLock(DataHandle);
  SavedDataPointer := FData.Memory;
	Move(Byte(DataPointer^), Byte(SavedDataPointer^), Fdata.Size);
  GlobalUnlock(DataHandle);
	SetClipboardData(TmpFormat, DataHandle);
end;

{ TTextStorage }

procedure TTextStorage.LoadFromClipboard;
begin
  inherited;
  Clipboard.Open;
  try

  finally
  end;
end;

procedure TTextStorage.SaveToClipboard;
begin
  inherited;

end;

initialization
  StorageFactory := TClipboardDataStorageFactory.Create;

finalization
  if Assigned(StorageFactory) then
    StorageFactory.Free;

end.
