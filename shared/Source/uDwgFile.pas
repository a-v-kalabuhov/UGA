unit uDwgFile;

interface

uses
  SysUtils, Graphics, Forms,
  //
  sgcadimage, sgConsts,
  //
  uGraphics;

type
  ECADDLLException = class(Exception);
  TDwgFile = class
  private
    FCADFile: THandle;
    procedure RaiseError;
    function FindLayerHandle(const aLayerName: string): THandle;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure Open(const aFileName: string);
    procedure Close();
    //
    procedure ExportToBitmap(aBitmap: TBitmap);
    //
    procedure LayerHide(const aLayerName: string);
    procedure LayerShow(const aLayerName: string);
    procedure LayerShowAll();
    //
    procedure ShowLineWeights(const Value: Boolean); 
  public
    class procedure RegisterLibrary();
  end;

implementation

function _str(P: PWideChar): string;
begin
  Result := string(WideString(P));
end;

{ TDwgFile }

procedure TDwgFile.Close;
var
  vCADFile: THandle;
begin
  if FCADFile <> 0 then
  begin
    vCADFile := FCADFile;
    FCADFile := 0;
    CloseCAD(vCADFile);
  end;
end;

constructor TDwgFile.Create;
begin

end;

destructor TDwgFile.Destroy;
begin
  if CADImageInst <> 0 then
    if FCADFile <> 0 then
      Close();
  inherited;
end;

procedure TDwgFile.ExportToBitmap(aBitmap: TBitmap);
begin
  if FCADFile = 0 then
    Exit;
  if DrawCAD(FCADFile, aBitmap.Canvas.Handle, aBitmap.Bounds) = 0 then
    RaiseError();
end;

function TDwgFile.FindLayerHandle(const aLayerName: string): THandle;
var
  Cnt: Cardinal;
  I: Cardinal;
  LayerHandle: THandle;
  LayerName: string;
  LayerData: TcadData;
begin
  Result := 0;
  Cnt := CADLayerCount(FCADFile);
  if Cnt > 0 then
  begin
    for I := 0 to Cnt - 1 do
    begin
      LayerHandle := CADLayer(FCADFile, I, @LayerData);
      //C := Data.Color;
      //if Data.Flags and 1 <> 0 then C := C or $80000000;
      LayerName := _str(LayerData.Text);
      if LayerName = aLayerName then
      begin
        Result := LayerHandle;
        Exit;
      end;
    end;
  end;
end;

procedure TDwgFile.LayerHide(const aLayerName: string);
var
  LayerHandle: THandle;
begin
  LayerHandle := FindLayerHandle(aLayerName);
  if LayerHandle <> 0 then
    CADLayerVisible(LayerHandle, 0);
end;

procedure TDwgFile.LayerShow(const aLayerName: string);
var
  LayerHandle: THandle;
begin
  LayerHandle := FindLayerHandle(aLayerName);
  if LayerHandle <> 0 then
    CADLayerVisible(LayerHandle, 1);
end;

procedure TDwgFile.LayerShowAll;
var
  Cnt: Cardinal;
  I: Cardinal;
  LayerHandle: THandle;
  LayerData: TcadData;
begin
  Cnt := CADLayerCount(FCADFile);
  if Cnt > 0 then
  begin
    for I := 0 to Cnt - 1 do
    begin
      LayerHandle := CADLayer(FCADFile, I, @LayerData);
      CADLayerVisible(LayerHandle, 1);
    end;
  end;
end;

procedure TDwgFile.Open(const aFileName: string);
begin
  if CADImageInst = 0 then
    Exit;
  Close();
  FCADFile := CreateCAD(Application.MainForm.Handle, PWideChar(WideString(AFileName)));
  if FCADFile = 0 then
    RaiseError();
  SetCADBorderType(FCADFile, 0);
  SetCADBorderSize(FCADFile, 0);
//  SetCADBorderType(FCADFile, 0);
//  SetCADBorderSize(FCADFile, 0);
//  SetDefaultColor(FCADFile, FDefaultColor);
//  SetBlackWhite(FCADFile, FBlackWhite);
end;

procedure TDwgFile.RaiseError;
var
  Buffer: array[Byte] of WideChar;
begin
  GetLastErrorCAD(Buffer, 256);
  raise ECADDLLException.Create(_str(@Buffer[0]));

end;

class procedure TDwgFile.RegisterLibrary;
var
  User, EMail, Key: String;
begin
  User := 'Александр Калабухов';
  EMail := 'a.v.kalabuhov@gmail.com';
  Key := '2LHF2U-PHEQP1-587O9K-2IOU2O-4F4R81-QR3KAN';
  StRg(PChar(User), PChar(Email), PChar(Key));
end;

procedure TDwgFile.ShowLineWeights(const Value: Boolean);
begin
  SetShowLineWeightCAD(FCADFile, Integer(Value));
end;

end.
