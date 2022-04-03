unit uEcwCompress;

interface

uses
  SysUtils, Windows, Classes, uEcwFuncs, Graphics, UQPIXELS;

type
  TOnStatus = procedure(Percent: Integer) of object;
  TOnCancel = function(const Client: TNCSEcwCompressClient): Boolean of object;
  TFileName = string[255];

  TEcwCompressor = class(TComponent)
  private
    FOnCancel: TOnCancel;
    FOnStatus: TOnStatus;
    FTargetCompression: IEEE4;
    QPix: TQuickPixels;
    nPercent: UINT32;
    pClient: PNCSEcwCompressClient;
    FError: String;
    eError: TNCSError;
    procedure SetOnCancel(const Value: TOnCancel);
    procedure SetOnStatus(const Value: TOnStatus);
    procedure SetTargetCompression(const Value: IEEE4);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    property Error: String read FError; // Описание ошибки, если она была и пусто в противном случае
    function Compress(Bitmap: TBitmap; outFile: TFileName): Boolean; overload;
    function Compress(inFile, outFile: TFileName): Boolean; overload;
  published
    property TargetCompression: IEEE4 read FTargetCompression write SetTargetCompression;
    property OnStatus: TOnStatus read FOnStatus write SetOnStatus;
    property OnCancel: TOnCancel read FOnCancel write SetOnCancel;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ECW Components', [TEcwCompressor]);
end;

function ReadCallback(pClient: PNCSEcwCompressClient; nNextLine: UINT32;
  ppInputArray: TppInputArray): BOOLEAN; cdecl;
var
  nCell: UINT32;
  pLineR, pLineG, pLineB: TInputArray;
  rgb: TCOLOR;
  qpix: TQuickPixels;
begin
  Result := False;
  if pClient = nil then
    Exit;
  qpix := TEcwCompressor(pClient.pClientData).QPix;
  if pClient.nInputBands = 1 then
    Result := False
  else
    if pClient.nInputBands = 3 then
    begin
      pLineR := ppInputArray[0];
      pLineG := ppInputArray[1];
      pLineB := ppInputArray[2];
      for nCell := 0 to pClient.nInOutSizeX - 1 do
      begin
        rgb := qpix.Pixels[nCell, nNextLine];
        pLineR[nCell] := Byte(rgb); //GetRValue(rgb);
        pLineG[nCell] := Byte(rgb shr 8); //GetGValue(rgb);
        pLineB[nCell] := Byte(rgb shr 16); //GetBValue(rgb);
        Result := True;
      end;
    end
    else
      Result := False;
end;

procedure StatusCallback(pClient: PNCSEcwCompressClient; nCurrentLine: UINT32); cdecl;
var
  nPercent: UINT32;
  Sender: TEcwCompressor;
begin
  Sender := pClient.pClientData;

  nPercent := round((nCurrentLine * 100) / (pClient.nInOutSizeY - 1));
  if (nPercent <> Sender.nPercent) then
  begin
    if Assigned(Sender.FOnStatus) then
      Sender.FOnStatus(nPercent);
    Sender.nPercent := nPercent;
  end;
end;

function CancelCallback(pClient: PNCSEcwCompressClient): BOOLEAN; cdecl;
var
  Sender: TEcwCompressor;
begin
  Sender := pClient.pClientData;
  if Assigned(Sender.FOnCancel) then
    Result := Sender.FOnCancel(Sender.PClient^)
  else
    Result := False;
end;

{ TNCSEcwConverter }

function TEcwCompressor.Compress(Bitmap: TBitmap;
  outFile: TFileName): Boolean;
var
  I: Integer;
begin
  Result := False;
  FError := '';
  if not Assigned(Bitmap) then
  begin
    FError := 'Bitmap=nil';
    Exit;
  end;
  NCSecwInit;
  try
    qpix.Attach(Bitmap);
    pClient := NCSEcwCompressAllocClient;
    try
      nPercent := 0;

      if Assigned(pClient) then
      begin
        pClient.nInputBands := 3;
        pClient.nInOutSizeX := Bitmap.Width;
        pClient.nInOutSizeY := Bitmap.Height;
        pClient.eCompressFormat := COMPRESS_RGB;
        pClient.fTargetCompression := FTargetCompression;
        for I := 1 to Length(outFile) do
          pClient.szOutputFilename[I - 1] := outFile[I];
//        StrCopy(PChar(@pClient.szOutputFilename[0]), PChar(@outFile[1]));
        pClient.pReadCallback := ReadCallback;
        pClient.pStatusCallback := StatusCallback;
        pClient.pCancelCallback := CancelCallback;
        pClient.pClientData := Self;
        eError := NCSEcwCompressOpen(pClient, FALSE);
        if (eError = NCS_SUCCESS) then
        begin
          eError := NCSEcwCompress(pClient);
          NCSEcwCompressClose(pClient);
        end;
        FError := NCSGetErrorText(eError);
        Result := eError = 0;
      end
      else
      begin
        fError := 'not created NCSEcwCompressAllocClient';
        Result := False;
      end;
    finally
      NCSEcwCompressFreeClient(pClient);
    end;
  finally
    NCSecwShutdown;
  end;
end;

function TEcwCompressor.Compress(inFile, outFile: TFileName): Boolean;
var
  I: Integer;
  Bmp: TBitmap;
begin
  FError := '';
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile(inFile);
    Result := Compress(Bmp, outFile);
  finally
    FreeAndNil(Bmp);
  end;
  Exit;
  NCSecwInit;
  try
    pClient := NCSEcwCompressAllocClient;
    try
      nPercent := 0;

      if Assigned(pClient) then
      begin
        pClient.nInputBands := 3;
//        pClient.nInOutSizeX := Bitmap.Width;
//        pClient.nInOutSizeY := Bitmap.Height;
        pClient.eCompressFormat := COMPRESS_RGB;
        pClient.fTargetCompression := FTargetCompression;
        for I := 1 to Length(inFile) do
          pClient.szInputFilename[I - 1] := inFile[I];
        for I := 1 to Length(outFile) do
          pClient.szOutputFilename[I - 1] := outFile[I];
//        StrCopy(PChar(@pClient.szOutputFilename[0]), PChar(@outFile[1]));
        pClient.pStatusCallback := StatusCallback;
        pClient.pCancelCallback := CancelCallback;
        pClient.pClientData := Self;
        eError := NCSEcwCompressOpen(pClient, FALSE);
        if (eError = NCS_SUCCESS) then
        begin
          eError := NCSEcwCompress(pClient);
          NCSEcwCompressClose(pClient);
        end;
//        else
//          MessageBox(0, 'Опа 2', '', MB_OK);
        FError := NCSGetErrorText(eError);
        Result := eError = 0;
      end
      else
      begin
        fError := 'not created NCSEcwCompressAllocClient';
        Result := False;
      end;
    finally
      NCSEcwCompressFreeClient(pClient);
    end;
  finally
    NCSecwShutdown;
  end;
end;

constructor TEcwCompressor.Create(AOwner: TComponent);
begin
  inherited;
  FOnCancel := nil;
  FOnStatus := nil;
  FTargetCompression := 10;
  QPix := TQuickPixels.Create;
end;

destructor TEcwCompressor.Destroy;
begin
  QPix.Free;
  inherited;
end;


procedure TEcwCompressor.SetOnCancel(const Value: TOnCancel);
begin
  FOnCancel := Value;
end;

procedure TEcwCompressor.SetOnStatus(const Value: TOnStatus);
begin
  FOnStatus := Value;
end;

procedure TEcwCompressor.SetTargetCompression(const Value: IEEE4);
begin
  FTargetCompression := Value;
end;

end.

