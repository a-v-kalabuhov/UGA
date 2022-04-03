unit ImagePrint;

interface

uses
  SysUtils, EzLib;

type
  TMapPage = record
    Rect: TEzRect;
    Selected: Boolean;
  end;

  TMapPages = class
  private
    FCount: Integer;
    FPages: array of TMapPage;
    function GetPage(Index: Integer): TMapPage;
  public
    property Count: Integer read FCount;
    property Page[Index: Integer]: TMapPage read GetPage;
    procedure AddPage(pRect: TEzRect);
    procedure SelectPage(Index: Integer);
    procedure UnSelectPage(Index: Integer);
    procedure Clear;
  published
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TMapPages }

procedure TMapPages.AddPage;
begin
  SetLength(FPages, FCount + 1);
  inc(FCount);
  FPages[FCount - 1].Rect := pRect;
  FPages[FCount - 1].Selected := False;
end;

procedure TMapPages.Clear;
begin
  FCount := 0;
  SetLength(FPages, 0);
end;

constructor TMapPages.Create;
begin
  Clear;
end;

destructor TMapPages.Destroy;
begin
  SetLength(FPages, 0);
  inherited;
end;

function TMapPages.GetPage(Index: Integer): TMapPage;
begin
  if (index >= 0) and (index < FCount) then
    result := FPages[index]
  else
    raise EAbort.Create('Invalid page index');
end;

procedure TMapPages.SelectPage(Index: Integer);
begin
  if (index >= 0) and (index < FCount) then
    FPages[index].Selected := True
  else
    raise EAbort.Create('Invalid page index');
end;

procedure TMapPages.UnSelectPage(Index: Integer);
begin
  if (index >= 0) and (index < FCount) then
    FPages[index].Selected := False
  else
    raise EAbort.Create('Invalid page index');
end;

end.
