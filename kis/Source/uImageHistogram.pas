unit uImageHistogram;

interface

uses
  Windows, Classes, SysUtils, Graphics, Contnrs, SyncObjs,
  uTasks;

type
  TColorCount = class
  private
    FCount: Integer;
    FColor: TColor;
  public
    constructor Create(aColor, aCount: Integer);
    property Color: TColor read FColor;
    property Count: Integer read FCount;
  end;

  TColorIndex = class
  private
    FList: TObjectList;
    function FindColorPos(const aColor: TColor; var Exists: Boolean): Integer;
    function GetItems(Index: Integer): TColorCount;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Add(aColors: TColorIndex);
    procedure Clear;
    function Count: Integer;
    procedure CountColor(const aColor: TColor);
    procedure Join;
    procedure Sort;
    //
    property Items[Index: Integer]: TColorCount read GetItems; default;
  end;

  TImageHistogram = class
  private
    FColors: TColorIndex;
    FTotalCount: Integer;
    FPrepared: Boolean;
    function GetCount: Integer;
    function GetColors(Index: Integer): TColorCount;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFromBitmap(Bitmap: TBitmap; Interlaced: Boolean; ThreadsCount: Byte = 0);
    //
    property Count: Integer read GetCount;
    property Colors[Index: Integer]: TColorCount read GetColors;
    property Prepared: Boolean read FPrepared;
    property TotalCount: Integer read FTotalCount;
  end;

  THistogramTask = class(TTask)
  private
    FBitmap: TBitmap;
    FRect: TRect;
    FInterlaced: Boolean;
    FColors: TColorIndex;
  protected
    procedure Execute; override;
  public
    constructor Create(aBmp: TBitmap; const aRect: TRect; Interlaced: Boolean);
    destructor Destroy; override;
    //
    property Colors: TColorIndex read FColors;
  end;

implementation

{ TImageHistogram }

constructor TImageHistogram.Create;
begin
  inherited;
  FColors := TColorIndex.Create;
end;

destructor TImageHistogram.Destroy;
begin
  FreeAndNil(FColors);
  inherited;
end;

function TImageHistogram.GetColors(Index: Integer): TColorCount;
begin
  Result := TColorCount(FColors[Index]);
end;

function TImageHistogram.GetCount: Integer;
begin
  Result := FColors.Count;
end;

function SortColors(Item1, Item2: Pointer): Integer;
begin
  Result := TColorCount(Item2).Count - TColorCount(Item1).Count;
end;

function CompareColorCount(Item1, Item2: Pointer): Integer;
begin
  Result := THistogramTask(Item2).Colors.Count - THistogramTask(Item2).Colors.Count;
end;

procedure TImageHistogram.LoadFromBitmap;
var
  Y, H: Integer;
  I: Integer;
  R: TRect;
  Exec: TTaskExecutor;
  Tasks: TObjectList;
  Task: THistogramTask;
begin
  FColors.Clear;

  FTotalCount := Bitmap.Height * Bitmap.Width;
  if FTotalCount = 0 then
    FTotalCount := 1;

  if ThreadsCount = 0 then
    ThreadsCount := 1;

  Y := Bitmap.Height div ThreadsCount;
  if Y > 0 then
  begin
    Exec := TTaskExecutor.Create();
    Tasks := TObjectList.Create;
    try
      R := Rect(0, 0, Bitmap.Width, Bitmap.Height);
      H := 0;
      for I := 0 to ThreadsCount - 1 do
      begin
        R.Top := H;
        if I = Pred(ThreadsCount) then
          R.Bottom := Bitmap.Height
        else
          R.Bottom := H + Y;
        Task := THistogramTask.Create(Bitmap, R, Interlaced);
        Tasks.Add(Task);
        Exec.AddTask(Task);
        H := Y + H;
      end;
      //
      Exec.Execute('Построение гистограммы', 1800000);
      //
      for I := 0 to Tasks.Count - 1 do
      begin
        Task := Tasks[I] as THistogramTask;
        FColors.Add(Task.Colors);
      end;
      FColors.Join();
    finally
      FreeAndNil(Tasks);
      FreeAndNil(Exec);
    end;
  end;
  //
  FPrepared := (Bitmap.Height > 0) and (Bitmap.Width > 0);
  //
  FColors.Sort;
end;

{ TColorCount }

constructor TColorCount.Create(aColor, aCount: Integer);
begin
  inherited Create;
  FCount := aCount;
  FColor := aColor;
end;

{ TColorIndex }

procedure TColorIndex.Add(aColors: TColorIndex);
var
  I: Integer;
begin
  for I := 0 to aColors.Count - 1 do
    FList.Add(TColorCount.Create(aColors[I].FColor, aColors[I].FCount));
end;

procedure TColorIndex.Clear;
begin
  FList.Clear;
end;

function TColorIndex.COunt: Integer;
begin
  Result := FList.Count;
end;

procedure TColorIndex.CountColor(const aColor: TColor);
var
  I: Integer;
  Exists: Boolean;
begin
  Exists := False;
  I := FindColorPos(aColor, Exists);
  if Exists then
    Inc(TColorCount(FList[I]).FCount)
  else
    FList.Insert(I, TColorCount.Create(aColor, 1));
end;

constructor TColorIndex.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
end;

destructor TColorIndex.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TColorIndex.FindColorPos(const aColor: TColor;
  var Exists: Boolean): Integer;
var
  First, Last, Middle: Integer;
begin
  Exists := False;
  Result := 0;
  if FList.Count > 0 then
  begin
    First := 0;
    Last := Pred(FList.Count);
    if aColor >= TColorCount(FList[First]).FColor then
    begin
      if aColor > TColorCount(FList[Last]).FColor then
        Result := FList.Count
      else
      begin
        while First < Last do
        begin
          Middle := First + (Last - First) div 2;
          if aColor = TColorCount(FList[Middle]).FColor then
          begin
            First := Last + 1;
            Last := Middle;
          end
          else
          if aColor < TColorCount(FList[Middle]).FColor then
            Last := Middle
          else
            First := Middle + 1;
        end;
        Result := Last;
        Exists := aColor = TColorCount(FList[Result]).FColor;
        if not Exists then
          if aColor > TColorCount(FList[Result]).FColor then
            Inc(Result);
      end;
    end;
  end;
end;

function TColorIndex.GetItems(Index: Integer): TColorCount;
begin
  Result := TColorCount(FList[Index]);
end;

procedure TColorIndex.Join;
var
  I1, I2: Integer;
  Item1, Item2: TColorCount;
begin
  Sort;
  I1 := 0;
  I2 := 1;
  while I2 < Count do
  begin
    Item1 := Items[I1];
    Item2 := Items[I2];
    if Item1.Color = Item2.Color then
    begin
      Item1.FCount := Item1.Count + Item2.Count;
      FList.Delete(I2);
    end
    else
    begin
      I1 := I2;
      Inc(I2);
    end;
  end;
end;

procedure TColorIndex.Sort;
begin
  FList.Sort(SortColors);
end;

{ THistogramTask }

constructor THistogramTask.Create;
begin
  inherited Create;
  FColors := TColorIndex.Create;
  FBitmap := aBmp;
  FRect := aRect;
  FInterlaced := Interlaced;
end;

destructor THistogramTask.Destroy;
begin
  FreeAndNil(FColors);
  inherited;
end;

procedure THistogramTask.Execute;
var
  X, Y, Idx: Integer;
  Clr: TColor;
  R1, G1, B1: Byte;
  aScanLine: PByteArray;
begin
  FColors.Clear;

  Y := FRect.Top;
  while Y < FRect.Bottom do
  begin
    aScanLine := FBitmap.ScanLine[Y];
    //
    X := FRect.Left;
    while X < FRect.Right do
    begin
      if FBitmap.PixelFormat = pf24bit then
      begin
        Idx := X * 3;
        R1 := aScanLine[Idx];
        G1 := aScanLine[Idx + 1];
        B1 := aScanLine[Idx + 2];
        Clr := RGB(R1, G1, B1);
      end
      else
      begin
        Clr := FBitmap.Canvas.Pixels[X, Y];
      end;
      //
      FColors.CountColor(Clr);
      //
      Inc(X);
      if FInterlaced then
        Inc(X);
    end;
    //
    Inc(Y);
    if FInterlaced then
      Inc(Y);
  end;
end;

end.
