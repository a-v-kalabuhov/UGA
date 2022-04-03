unit uEcwDecompress;

interface

uses
  SysUtils, Classes, Types, Windows, Graphics,
  uEcwFuncs;

type
  TEcwDecompressor = class(TComponent)
  private
    FFileName: String;
    FError: String;
    FWidth: Integer;
    FHeight: Integer;
    FFileView: PNCSFileView;
    FFileInfo: PNCSFileViewFileInfo;
    FBands: TBandList;
    FBandCount: Integer;
    procedure SetFileName(const Value: String);
  protected
    procedure DoError(aError: TNCSError);
  public
    destructor Destroy; override;
    //
    function Decompress(Bitmap: TBitmap; const Rect: TRect): Boolean; overload;
    function Decompress(Canvas: TCanvas; const DestRect, SourceRect: TRect): Boolean; overload;
    //
    property Error: String read FError;
    property FileName: String read FFileName write SetFileName;
    property Height: Integer read FHeight;
    property Width: Integer read FWidth;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ECW Components', [TEcwDecompressor]);
end;

{ TEcwDecompressor }

function TEcwDecompressor.Decompress(Bitmap: TBitmap; const Rect: TRect): Boolean;
var
  aError: TNCSError;
  I, Size: Integer;
  Triplets, Current: Pointer;
  Status: TNCSEcwReadStatus;
begin
  Result := False;
  if not Assigned(Bitmap) then
    Exit;
  Bitmap.PixelFormat := pf24bit;
  aError := NCScbmSetFileView(FFileView, FBandCount, @FBands[0], Rect.Left,
    Rect.Top, Rect.Right, Rect.Bottom, Bitmap.Width, Bitmap.Height);
{  aError := NCScbmSetFileView(FFileView, FBandCount, FBands, 0,
    0, 10, 10, 10, 10);//Bitmap.Width, Bitmap.Height); }
  if aError <> NCS_SUCCESS then
    DoError(aError);
  Size := Bitmap.Width * 3;
  GetMem(Triplets, Size);
  try
    for I := 0 to Bitmap.Height - 1 do
    begin
      Status := NCScbmReadViewLineBGR(FFileView, Triplets);
      if Status <> NCSECW_READ_OK then
        Break;
      Current := Bitmap.ScanLine[I];
      Move(Triplets^, Current^, Size);
    end;
    Result := True;
  finally
    FreeMem(Triplets, Size);
  end;
  FError := '';
end;

function GetPartRect(const PartDestRect, DestRect, SourceRect: TRect): TRect;
var
  LPercent: Double;
  TPercent: Double;
  WPercent: Double;
  HPercent: Double;
begin
  LPercent := Abs(-DestRect.Left + PartDestRect.Left) / (DestRect.Right - DestRect.Left);
  TPercent := (-DestRect.Top + PartDestRect.Top) / (DestRect.Bottom - DestRect.Top);
  WPercent := (PartDestRect.Right - PartDestRect.Left) / (DestRect.Right - DestRect.Left);
  HPercent := (PartDestRect.Bottom - PartDestRect.Top) / (DestRect.Bottom - DestRect.Top);

  Result.Left := SourceRect.Left + Round(LPercent * (SourceRect.Right - SourceRect.Left));
  Result.Top := SourceRect.Top + Round(TPercent * (SourceRect.Bottom - SourceRect.Top));
  Result.Right := Result.Left + Round(WPercent * (SourceRect.Right - SourceRect.Left));
  Result.Bottom := Result.Top + Round(HPercent * (SourceRect.Bottom - SourceRect.Top));
end;

function TEcwDecompressor.Decompress(Canvas: TCanvas; const DestRect,
  SourceRect: TRect): Boolean;
var
  W, H, Ws, Hs: Integer;
  R1, R2: TRect;
  X1, X2, Y1, Y2: Integer;
  Bmp: TBitmap;
begin
  Result := False;
  if not Assigned(Canvas) then
    Exit;
//  Bitmap.PixelFormat := pf24bit;
  W := DestRect.Right - DestRect.Left;
  H := DestRect.Bottom - DestRect.Top;
  if (W = 0) or (H = 0) then
    Exit;
  //
  if H > 1050 then
  begin
    X1 := 0;
    X2 := W - 1;
    Y1 := 0;
    while Y1 < (H - 1) do
    begin
      if (Y1 + 1000) < H then
        Y2 := Y1 + 1000
      else
        Y2 := H - 1;
      //
      R1 := Rect(DestRect.Left + X1, DestRect.Top + Y1, DestRect.Left + X2, DestRect.Top + Y2);
      R2 := GetPartRect(R1, DestRect, SourceRect);
      Decompress(Canvas, R1, R2);
      //
      Y1 := Y2;
    end;
  end
  else
  begin
    Ws := SourceRect.Right - SourceRect.Left;
    Hs := SourceRect.Bottom - SourceRect.Top;
    if (Ws = 0) or (Hs = 0) then
      Exit;
    if (W > Ws) or (H > Hs) then
    begin
      Bmp := TBitmap.Create;
      try
        Bmp.PixelFormat := pf24bit;
        Bmp.SetSize(Ws, Hs);
        Decompress(Bmp, SourceRect);
        Canvas.StretchDraw(DestRect, Bmp);
      finally
        Bmp.Free;
      end;
    end
    else
    begin
      Bmp := TBitmap.Create;
      try
        Bmp.PixelFormat := pf24bit;
        Bmp.SetSize(W, H);
        Decompress(Bmp, SourceRect);
        Canvas.Draw(DestRect.Left, DestRect.Top, Bmp);
      finally
        Bmp.Free;
      end;
    end;
  end;
end;

destructor TEcwDecompressor.Destroy;
var
  aError: TNCSError;
begin
  if FFileView <> nil then
  begin
    aError := NCScbmCloseFileView(FFileView);
    {$IFDEF DEBUG}
    if aError <> NCS_SUCCESS then
      DoError(aError)
    else
      FFileView := nil;
    {$ENDIF}
  end;
  inherited;
end;

procedure TEcwDecompressor.DoError(aError: TNCSError);
begin
  FError := NCSGetErrorText(aError);
  raise Exception.Create(FError);
end;

procedure TEcwDecompressor.SetFileName(const Value: String);
var
  aError: TNCSError;
begin
  if not FileExists(Value) then
    Exit;
  FFileName := Value;

  if FFileView <> nil then
  begin
    aError := NCScbmCloseFileView(FFileView);
    if aError <> NCS_SUCCESS then
      DoError(aError)
    else
      FFileView := nil;
  end;

  aError := NCScbmOpenFileView(PChar(FFileName), FFileView, nil);
  if aError <> NCS_SUCCESS then
    DoError(aError);

  FBands[0] := 0;
  FBands[1] := 1;
  FBands[2] := 2;
  aError := NCScbmGetViewFileInfo(FFileView, FFileInfo);
  if aError <> NCS_SUCCESS then
    DoError(aError);
  if FFileInfo.nBands < 3 then
    FBandCount := 1
  else
    FBandCount := 3;
  FWidth := FFileInfo.nSizeX;
  FHeight := FFileInfo.nSizeY;
  FError := '';
end;

initialization
  NCSecwInit;

finalization
  NCSecwShutdown;

end.
