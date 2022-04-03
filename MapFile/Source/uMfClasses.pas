unit uMfClasses;

interface

uses
  SysUtils, Types, Classes, Contnrs, Math;

type
  TEntityHeader = class
    I1, I2: Word;
    Mode: Byte;
    X, Y: Double;
    //
    DrawState: Word;
    ClassId: Word;
    Data: String;
    Title: String;
    DskCount: Word;
    DskList: TObjectList;
    ID: Word;
    LinkID: String;
    Flags: Word;
    LongId: LongWord;
    //
    DrawStateColor: Byte;
    DrawStateFill: Byte;
    DrawStateLSize: Byte;
    DrawStateLStyle: Byte;
    DrawStateFillColor: Byte;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFromStream(Stream: TStream);
    function  IsRealPoints: Boolean;
  end;

  TMapEntity = class
  private
    FHeader: TEntityHeader;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    //
    procedure LoadFromStream(Stream: TStream); virtual;
  end;

  TMapRectangle = class(TMapEntity)
  public
    Angle: Word;
    X1, X2, Y1, Y2: Double;
    //
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapPoint = record
    X, Y: Double;
  end;

  TMapPoint3 = record
    C, R, L: TSmallPoint;
  end;

  TMapEllipse = class(TMapEntity)
  public
    A1, A2: SmallInt;
    X1, X2, Y1, Y2: Double;
    //
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapPolygon = class(TMapEntity)
  public
    PointCount: SmallInt;
    Points: array of TMapPoint3;
    //
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapText = class(TMapEntity)
  public
    LinkID: SmallInt;
    Font: Byte;
    Justify: Byte;
    JAngle: SmallInt;
    CharW, CharH : Word;
    X1, X2, Y1, Y2: Double;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapSign = class(TMapEntity)
  public
    Angle: SmallInt;
    iKGrow: Double;
    NameIndex: Smallint;
    Name: String;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapLine = class(TMapEntity)
  public
    PCount: SmallInt;
    Points1: array of TSmallPoint;
    Points2: array of TMapPoint;
    CCount: SmallInt;
    Chars: array of TSmallPoint; { x - index, y - cchar }
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapSPoint = class(TMapEntity)
  public
    Angle: SmallInt;
    iKGrow: Double;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMap3Point = class(TMapEntity)
  public
    P1, P2: TMapPoint;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TMapGroup = class(TMapEntity)
  public
    FList: TObjectList;
    constructor Create; override;
    destructor Destroy; override;
    //
    procedure LoadFromStream(Stream: TStream); override;
  end;

   TTitleDsk = class
   public
     X, Y: SmallInt;
     Justify: Word;
     Pattern: String;
     Angle: SmallInt;
     Hy: SmallInt;
     procedure LoadFromStream(Stream: TStream);
   end;


  TMapFile = class
  private
    FStrings: TStringList;
    FEntities: TObjectList;
    FEntityCount: Word;
  protected
    procedure ReadStrings(Stream: TStream);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFromStream(Stream: TStream);
  end;

implementation

const
  ID_Group = 1004;
  ID_Rectangle = 1005;
  ID_Ellipse = 1006;
  ID_Polygon = 1007;
  ID_Text = 1008;
  ID_Sign = 1009;
  ID_Line = 1010;
  ID_SPoint = 1011;
  ID_Custom3Point = 1012;

function ReadFloat(Stream: TStream): Double;
var
  R: Real48;
  I: Integer;
{  Bin: array[0..5] of Byte;
  B: Byte;
  E, S: SmallInt;
  F: Int64; }
begin
  I := SizeOf(R);
  Stream.Read(R, I);
  Result := R;
{  Stream.Read(Bin[0], 6);
  if Bin[0] = 0 then
    Result := 0
  else
  begin
    if Bin[5] and 128 <> 0 then
      S := -1
    else
      S := 1;
    E := Bin[0];
    B := Bin[5];
    if B > 128 then
      B := B - 128;
    F := B * $FFFFFFFF + Bin[4] * $FFFFFF + Bin[3] * $FFFF + Bin[2] * $FF + Bin[1];
    Result := S * Power(2, E - 129) * F;
  end; }
end;

function ReadSmallInt(Stream: TStream): SmallInt;
begin
  Stream.Read(Result, 2);
end;

function ReadString(Stream: TStream): String;
var
  L, I: Byte;
  C: Char;
begin
  Stream.Read(L, 1);
  SetLength(Result, L);
  for I := 1 to L do
  begin
    Stream.Read(C, 1);
    Result[I] := C;
  end;
end;

function ReadWord(Stream: TStream): Word;
begin
  Stream.Read(Result, 2);
end;

function ReadEntity(Stream: TStream; var EntId: Word): TMapEntity;
begin
  Result := nil;
  EntId := ReadWord(Stream);
  case EntId of
  ID_Group:
    begin
      Result := TMapGroup.Create;
    end;
  ID_Rectangle:
    begin
      Result := TMapRectangle.Create;
    end;
  ID_Ellipse:
    begin
      Result := TMapEllipse.Create;
    end;
  ID_Polygon:
    begin
      Result := TMapPolygon.Create;
    end;
  ID_Text:
    begin
      Result := TMapText.Create;
    end;
  ID_Sign:
    begin
      Result := TMapSign.Create;
    end;
  ID_Line:
    begin
      Result := TMapLine.Create;
    end;
  ID_SPoint:
    begin
      Result := TMapSPoint.Create;
    end;
  ID_Custom3Point:
    begin
      Result := TMap3Point.Create;
    end;
  end;
  if Assigned(Result) then
    Result.LoadFromStream(Stream);
end;

{ TMapFile }

constructor TMapFile.CReate;
begin
  FStrings := TStringList.Create;
  FEntities := TObjectList.Create;
end;

destructor TMapFile.Destroy;
begin
  FEntities.Free;
  FStrings.Free;
  inherited;
end;

procedure TMapFile.LoadFromStream(Stream: TStream);
var
  EntId: Word;
  Id, I: Word;
  Version: String;
  EH: TEntityHeader;
  E: TMapEntity;
  //
  ePoint3: Integer;
  eEllipse: Integer;
  eLine: Integer;
  ePolygon: Integer;
  eRectangle: Integer;
  eSign: Integer;
  eSPoint: Integer;
  eText: Integer;
  eGroups: Integer;
begin
  FEntities.Clear;
  Stream.Seek(0, soBeginning);
  Id := ReadWord(Stream);
  if Id <> 1003 then
    Exit;
  Version := ReadString(Stream);
  WriteLn('File Version: ', Version);
  //
  Stream.Seek(130, soBeginning);
  //
  ReadStrings(Stream);
  WriteLn;
  WriteLn('Strings: ', FStrings.Count);
  if FStrings.Count > 0 then
    for I := 0 to FStrings.Count - 1 do
      WriteLn('     ' + FStrings[I]);
  WriteLn;
  //
  Id := ReadWord(Stream);
  if Id <> 1004 then
    Exit;
  //
  EH := TEntityHeader.Create;
  EH.LoadFromStream(Stream);
  //
  Id := ReadWord(Stream);
  if Id <> 1002 then
    Exit;
  //
  FEntityCount := ReadWord(Stream);
  ReadWord(Stream);
  ReadWord(Stream);
  //
  ePoint3 := 0;
  eEllipse := 0;
  eLine := 0;
  ePolygon := 0;
  eRectangle := 0;
  eSign := 0;
  eSPoint := 0;
  eText := 0;
  eGroups := 0;
  WriteLn('Entity Count: ', FEntityCount);
  for I := 1 to FEntityCount do
  begin
    E := ReadEntity(Stream, EntId);
    if E = nil then
    begin
      WriteLn('Read Error: Row=' + IntToStr(I));
      Break;
    end
    else
    begin
      FEntities.Add(E);
      case EntId of
      ID_Group: Inc(eGroups);
      ID_Rectangle: Inc(eRectangle);
      ID_Ellipse: Inc(eEllipse);
      ID_Polygon: Inc(ePolygon);
      ID_Text: Inc(eText);
      ID_Sign: Inc(eSign);
      ID_Line: Inc(eLine);
      ID_SPoint: Inc(eSPoint);
      ID_Custom3Point: Inc(ePoint3);
      end;
    end;
  end;
  //
  WriteLn('=========');
  WriteLn('Line    :', eLine);
  WriteLn('Poly    :', ePolygon);
  WriteLn('Rect    :', eRectangle);
  WriteLn('Text    :', eText);
  WriteLn('Ellipse :', eEllipse);
  WriteLn('Point   :', ePoint3);
  WriteLn('Symbol  :', eSign);
  WriteLn('Height  :', eSPoint);
  WriteLn('Groups  :', eGroups);
  WriteLn('=========');
  ReadLn;
end;

procedure TMapFile.ReadStrings(Stream: TStream);
var
  C, I: Integer;
  W: Word;
  S: String;
begin
  FStrings.Clear;
  W := ReadWord(Stream);
  if W <> 51 then
    Exit;
  C := ReadWord(Stream);
  ReadWord(Stream);
  ReadWord(Stream);
  for I := 0 to C - 1 do
  begin
    S := ReadString(Stream);
    FStrings.Add(S);
  end;
  Stream.Seek(1, soFromCurrent);
end;

{ TEntityHeader }

constructor TEntityHeader.Create;
begin
  DskList := TObjectList.Create;
end;

destructor TEntityHeader.Destroy;
begin
  DskList.Free;
  inherited;
end;

function TEntityHeader.IsRealPoints: Boolean;
begin
  Result := (Flags and $0200) <> 0;
end;

procedure TEntityHeader.LoadFromStream(Stream: TStream);
var
  I: Word;
  Dsk: TTitleDsk;
begin
  Stream.Read(I1, 2);
  Stream.Read(I2, 2);
  Stream.Read(Mode, 1);
  Mode := Mode xor 0;
  if Mode and $01 <> 0 then
  begin
    Stream.Read(DrawState, 2);
    DrawStateColor := DrawState mod 16;
    DrawStateFill :=(DrawState shl 8) shr 12;
    DrawStateLSize :=(DrawState shl 4) shr 12;
    DrawStateLStyle := DrawState shr 12;
    if DrawStateFill <> 0 then
    begin
      DrawStateFillColor := DrawStateLStyle;
      DrawStateLStyle := 0;
    end;
   end;
   if Mode and $02 <> 0 then
      Stream.Read(ClassId, 2);
   if Mode and $04 <> 0 then
     Data := ReadString(Stream);
   if Mode and $08 <> 0 then
     Title := ReadString(Stream);
   if Mode and $10 <> 0 then
   begin
      Stream.Read(DskCount, 2);
      for I := 1 to DskCount do
      begin
        Dsk := TTitleDsk.Create;
        DskList.Add(Dsk);
        Dsk.LoadFromStream(Stream);
      end;
   end;
   if Mode and $20 <> 0 then
     ID := ReadWord(Stream);
   if Mode and $40 <> 0 then
     LinkID := ReadString(Stream);
   if Mode and $80 <> 0 then
     Flags := ReadWord(Stream)
   else
     Flags := 0;
   if Flags and $100 <> 0 then
     Stream.Read(LongID, 4);
   if IsRealPoints then
   begin
     X := ReadFloat(Stream);
     Y := ReadFloat(Stream);
   end;
end;

{ TMapEntity }

constructor TMapEntity.Create;
begin
  FHeader := TEntityHeader.Create;
end;

destructor TMapEntity.Destroy;
begin
  FHeader.Free;
  inherited;
end;

procedure TMapEntity.LoadFromStream(Stream: TStream);
begin
  FHeader.LoadFromStream(Stream);
end;

{ TMapRectangle }

procedure TMapRectangle.LoadFromStream(Stream: TStream);
begin
  inherited;
  if FHeader.IsRealPoints then
  begin
    X1 := ReadFloat(Stream);
    Y1 := ReadFloat(Stream);
    X2 := ReadFloat(Stream);
    Y2 := ReadFloat(Stream);
  end
  else
  begin
    X1 := ReadSmallInt(Stream);
    Y1 := ReadSmallInt(Stream);
    X2 := ReadSmallInt(Stream);
    Y2 := ReadSmallInt(Stream);
  end;
  Angle := ReadWord(Stream);
end;

{ TMapEllipse }

procedure TMapEllipse.LoadFromStream(Stream: TStream);
begin
  inherited;
  if FHeader.IsRealPoints then
  begin
    X1 := ReadFloat(Stream);
    Y1 := ReadFloat(Stream);
    X2 := ReadFloat(Stream);
    Y2 := ReadFloat(Stream);
  end
  else
  begin
    X1 := ReadSmallInt(Stream);
    Y1 := ReadSmallInt(Stream);
    X2 := ReadSmallInt(Stream);
    Y2 := ReadSmallInt(Stream);
  end;
  A1 := ReadSmallInt(Stream);
  A2 := ReadSmallInt(Stream);
end;

{ TMapPolygon }

procedure TMapPolygon.LoadFromStream(Stream: TStream);
var
  I: Integer;
  B: Boolean;
  Pt: TMapPoint3;
begin
  inherited;
  PointCount := ReadSmallInt(Stream);
  SetLength(Points, PointCount);
  B := True;
  for I := 1 to PointCount do
  begin
    FillChar(Pt, SizeOf(Pt), 0);
    Pt.C.x := ReadSmallInt(Stream);
    if Pt.C.x = -32768 then
    begin
      B := not B;
      Pt.C.x := ReadSmallInt(Stream);
    end;
    Pt.C.y := ReadSmallInt(Stream);
    if not B then
    begin
      Pt.R.x := ReadSmallInt(Stream);
      Pt.R.y := ReadSmallInt(Stream);
      Pt.L.x := ReadSmallInt(Stream);
      Pt.L.y := ReadSmallInt(Stream);
    end;
    Points[I - 1] := Pt;
  end;
end;

{ TMapText }

procedure TMapText.LoadFromStream(Stream: TStream);
begin
  inherited;
  if FHeader.IsRealPoints then
  begin
    X1 := ReadFloat(Stream);
    Y1 := ReadFloat(Stream);
    X2 := ReadFloat(Stream);
    Y2 := ReadFloat(Stream);
  end
  else
  begin
    X1 := ReadSmallInt(Stream);
    Y1 := ReadSmallInt(Stream);
    X2 := ReadSmallInt(Stream);
    Y2 := ReadSmallInt(Stream);
  end;
  Stream.Read(Font, 1);
  Font := $FF;
  if (FHeader.Flags and 1) <> 0 then
  begin
    Stream.Read(Justify, 1);
    Stream.Read(JAngle, 2);
  end;
end;

{ TMapSign }

procedure TMapSign.LoadFromStream(Stream: TStream);
begin
  inherited;
  Angle := ReadSmallInt(Stream);
  iKGrow := ReadFloat(Stream);
  NameIndex := ReadSmallInt(Stream);
  if NameIndex = -1 then
    Name := ReadString(Stream);
end;

{ TMapLine }

procedure TMapLine.LoadFromStream(Stream: TStream);
var
  B: Boolean;
  I: Integer;
begin
  inherited;
  //
  PCount := ReadSmallInt(Stream);
  B := FHeader.IsRealPoints;
  if B then
    SetLength(Points2, PCount)
  else
    SetLength(Points1, PCount);
  for I := 0 to PCount - 1 do
    if B then
    begin
      Points2[I].x := ReadFloat(Stream);
      Points2[I].y := ReadFloat(Stream);
    end
    else
    begin
      Points1[I].x := ReadSmallInt(Stream);
      Points1[I].y := ReadSmallInt(Stream);
    end;
  //
  CCount := ReadSmallInt(Stream);
  SetLength(Chars, CCount);
  for I := 0 to CCount - 1 do
  begin
    Chars[I].x := ReadSmallInt(Stream);
    Chars[I].y := ReadSmallInt(Stream);
  end;
end;

{ TMapSPoint }

procedure TMapSPoint.LoadFromStream(Stream: TStream);
begin
  inherited;
  Angle := ReadSmallInt(Stream);
  iKGrow := ReadFloat(Stream);
end;

{ TMap3Point }

procedure TMap3Point.LoadFromStream(Stream: TStream);
begin
  inherited;
  if FHeader.IsRealPoints then
  begin
    P1.X := ReadFloat(Stream);
    P1.Y := ReadFloat(Stream);
    P2.X := ReadFloat(Stream);
    P2.Y := ReadFloat(Stream);
  end
  else
  begin
    P1.X := ReadSmallInt(Stream);
    P1.Y := ReadSmallInt(Stream);
    P2.X := ReadSmallInt(Stream);
    P2.Y := ReadSmallInt(Stream);
  end;
end;

{ TMapGroup }

constructor TMapGroup.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TMapGroup.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TMapGroup.LoadFromStream(Stream: TStream);
var
  Cnt, EntId: Word;
  E: TMapEntity;
  I: Integer;
begin
  inherited;
  if ReadWord(Stream) <> 1002 then
    raise Exception.Create('Wrong Group structure');
  //
  Cnt := ReadWord(Stream);
  ReadWord(Stream);
  ReadWord(Stream);
  //
  for I := 1 to Cnt do
  begin
    E := ReadEntity(Stream, EntId);
    if E = nil then
      raise Exception.Create('Wrong Group child')
    else
      FList.Add(E);
  end;
end;

{ TTitleDsk }

procedure TTitleDsk.LoadFromStream(Stream: TStream);
begin
  X := ReadSmallInt(Stream);
  Y := ReadSmallInt(Stream);
  Justify := ReadWord(Stream);
  Justify := Justify and $f * 2 + Justify and $f0 * 2;
  Angle := ReadSmallInt(Stream);
  Hy := ReadSmallInt(Stream);
  Pattern := ReadString(Stream);
end;

end.
