unit uGeoUtils;

interface

uses
  Windows, Classes, SysUtils, StrUtils,
  uGC, uGeoTypes, uCommonUtils, uCK36;

type
  TPart1 = record
    FoundKrasnolesny, FoundSecret: Boolean;
    //ValidPart: string;
    Valid: Boolean;
    //
    Zero: Boolean; // есть ноль перед буквой
    Letter: Char;  // буква планшета
  public
    procedure Clear();
    function GetValidText(): string;
  end;
  TPart2 = record
    Valid: Boolean;
    Zero: Boolean;   // есть ноль перед номером
    Number: Integer; // номер планшета
  public
    procedure Clear();
    function GetValidText(): string;
  end;
  TPart3 = record
    FoundKrasnolesny: Boolean;
    Valid: Boolean;
    Number: Integer; // номер хвоста
  public
    procedure Clear();
    function GetValidText(AddK: Boolean): string;
  end;

  TNomenclature = record
  private
    fP1: TPart1;
    fP2: TPart2;
    fP3: TPart3;
    function GetParts(const Index: Integer): string;
    procedure Clear();
    procedure CalcTopLeft1();
    procedure CalcTopLeft2();
    function GetNeighbour(const Position: TNeighbour4): TNomenclature;
  public
    Part1: string;
    Part2: string;
    Part3: string;
    Secret: Boolean;
    Krasnolesny: Boolean;
    Scale: TGeoScale;
    PartCount: Integer;
    Top500, Left500, Bottom500, Right500: Integer;
    Top2000, Left2000: Integer;
    Valid: Boolean;
    procedure Init(const aNomenclature: string; const StrictNumbers: Boolean);
    function Nomenclature(): string;
    function AsStrings(const Delimiter: Char): TStrings;
    function GetValidParts(): string;
    /// <summary>
    /// Возвращает коорлинаты прямоугольника планшета в городской системе координат.
    /// </summary>
    function Bounds: TRect;
    //
    property Parts[const Index: Integer]: string read GetParts;
    property Neighbour[const Position: TNeighbour4]: TNomenclature read GetNeighbour;
  public
    function Build(P1: TPart1; P2: TPart2; P3: TPart3): TNomenclature;
    procedure ReBuild(const Secret: Boolean);
  end;

  TGeoUtils = class
  public
    class procedure GetNomenclatureParts(const Name: String; var Parts: TStringList);
    class function GetNomenclature2000(const X, Y: Double): String; 
    class function GetNomenclature500(const X, Y: Double): String;
    class function MapTopLeft(const Nomenclature: String; var aTop, aLeft: Integer): Boolean; overload;
    class function MapTopLeft(const Nomen: String; Scale: TGeoScale; var aTop, aLeft: Integer): Boolean; overload;
    class function GetNeighbourMap(const Nomenclature: String; const Position: TNeighbour4): string;
    class function IsNomenclatureValid(const aNomenclature: String; const StrictNumbers: Boolean): Boolean;
    class function GetNomenclature(const aNomenclature: String; const StrictNumbers: Boolean): TNomenclature;
    class function IsMCK36(const Xgeo, Ygeo: Double): Boolean;
  private
    class function GetPart1(const aValue: String): TPart1;
    class function GetPart2(const aValue: String; const StrictCheck: Boolean): TPart2;
    class function GetPart3(const aValue: String): TPart3;
    class function ConvertPartChar(const PartIdx: Integer; const aChar: Char): Char;
    class function IsValidPostfix(const aValue: String): Boolean;
  end;

  TCoords = record
    X, Y: Double;
    /// <summary>
    /// True - Если это геодезические координаты (x - вверх, y - вправо)
    /// </summary>
    Geo: Boolean;
    function GetCoordSystem(): TCoordSystem;
    procedure Convert(ToCs: TCoordSystem);
  end;

  function GetNomenclatureCoords500(var aNomenclature: String; var aTop, aLeft: Integer): Boolean;

implementation

function GetNomenclatureCoords500(var aNomenclature: String; var aTop, aLeft: Integer): Boolean;
var
  N: TNomenclature;
  S: string;
begin
  Result := False;
  S := aNomenclature;
  N.Init(S, False);
  if N.Valid and (N.Scale = gs500) then
    Result := (N.Top500 <> -1) and (N.Left500 <> -1);
  if Result then
  begin
    S := N.Nomenclature();
    if S <> aNomenclature then
      aNomenclature := S;
    aTop := N.Top500;
    aLeft := N.Left500;
  end;
end;

function MapTopLeft500(const Nomenclature: String; var X, Y: Integer): Boolean;
const
  S_NOMENCLATURE_CHARS = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ';
  S_NOMENCLATURE_CHARS_LAT = 'AБBГДEЖЗИKЛMHOПPCTУФXЦЧШЩЭЮЯ';
var
  Parts: TStringList;
  K, I: Integer;
  S: String;
  Sk: Char;
  LeftSide: Boolean;
  Krasnolesny: Boolean;
begin
  Result := False;
  Parts := TStringList.Create;
  Parts.Forget();
  if Length(Nomenclature) > 0 then
  begin
    Parts.Delimiter := '-';
    Parts.DelimitedText := Nomenclature;
  end;
  //
  Krasnolesny := False;
  if Parts.Count = 3 then
  begin
    S := Parts[2];
    if Length(S) > 0 then
      Sk := S[Length(S)]
    else
      Sk := '0';
    if Sk in ['k', 'K', 'к', 'К'] then
    begin
      Krasnolesny := True;
      SetLength(S, Length(S) - 1);
      Parts[2] := S;
    end;
  end;
  //
  // считаем x
  S := Parts.Strings[0];
  if S[1] = '0' then
  begin
    I := Pos(S[2], S_NOMENCLATURE_CHARS);
    if I < 1 then
    begin
      I := Pos(S[2], S_NOMENCLATURE_CHARS_LAT);
      if I < 1 then
        Exit;
    end;
    if I < 23 then
      X := I + 13
    else
      X := I - 43;
  end
  else
  begin
    I := Pos(S[1], S_NOMENCLATURE_CHARS);
    if I < 1 then
    begin
      I := Pos(S[2], S_NOMENCLATURE_CHARS_LAT);
      if I < 1 then
        Exit;
    end;
    X := 14 - I;
  end;
  X := X * 1000;
  K := StrToInt(Parts.Strings[2]);
  case K of
  1, 2, 3, 4     : ;//X := X;
  5, 6, 7, 8     : Dec(X, 250);
  9, 10, 11, 12  : Dec(X, 500);
  13, 14, 15, 16 : Dec(X, 750);
  else
    Exit;
  end;
  // считаем y
  S := Parts.Strings[1];
  LeftSide := False;
  if (S[1] = '0') and (Length(S) > 1) then
  begin
    Delete(S, 1, 1);
    LeftSide := True;
  end;
  I := LatinToArabian(S);
  Y := (I - 11) * 1000;
  //сдвигаем координату Y на 2000 влево
  if LeftSide then
    Y := Y + (-2000 * I);
  case K of
  1, 5, 9, 13  : ;//Y := Y;
  2, 6, 10, 14 : Y := Y + 250;
  3, 7, 11, 15 : Y := Y + 500;
  4, 8, 12, 16 : Y := Y + 750;
  else
    Exit;
  end;
  //
  if Krasnolesny then
  begin
    X := X + 43000;
    Y := Y + 38000;
  end;
  Result := True;
end;

function MapTopLeft500_2(const Nomenclature: String; var X, Y: Integer): Boolean;
const
  S_NOMENCLATURE_CHARS = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ';
var
  Parts: TStringList;
  K, I: Integer;
  S: String;
  LeftSide: Boolean;
//  b: Boolean;
begin
  Result := False;
  Parts := TStringList.Create;
  Parts.Forget();
  TGeoUtils.GetNomenclatureParts(Nomenclature, Parts);
  // считаем x
  S := Parts.Strings[0];
  if S[1] = '0' then
  begin
    I := Pos(S[2], S_NOMENCLATURE_CHARS);
    if I < 1 then
      Exit;
    if I < 23 then
      X := I + 13
    else
      X := I - 42;
  end
  else
  begin
    I := Pos(S[1], S_NOMENCLATURE_CHARS);
    if I < 1 then
      Exit;
    X := 14 - I;
  end;
  X := X * 1000;
  K := StrToInt(Parts.Strings[2]);
  case K of
  1, 2, 3, 4     : ;//X := X;
  5, 6, 7, 8     : Dec(X, 250);
  9, 10, 11, 12  : Dec(X, 500);
  13, 14, 15, 16 : Dec(X, 750);
  else
    Exit;
  end;
  // считаем y
  S := Parts.Strings[1];
  LeftSide := False;
  if (S[1] = '0') and (Length(S) > 1) then
  begin
    Delete(S, 1, 1);
    LeftSide := True;
  end;
  I := LatinToArabian(S);
  Y := (I - 11) * 1000;
  //сдвигаем координату Y на 2000 влево
  if LeftSide then
    Y := Y + (-2000 * I);
  case K of
  1, 5, 9, 13  : ;//Y := Y;
  2, 6, 10, 14 : Y := Y + 250;
  3, 7, 11, 15 : Y := Y + 500;
  4, 8, 12, 16 : Y := Y + 750;
  else
    Exit;
  end;
  Result := True;
end;

{ TGeoUtils }

class function TGeoUtils.ConvertPartChar(const PartIdx: Integer; const aChar: Char): Char;
var
  Tmp: string;
begin
  Result := #0;
  case PartIdx of
  0 :
      begin
        if (aChar >= 'А') and (aChar <= 'Я') then
          Result := aChar
        else
        if (aChar >= 'а') and (aChar <= 'я') then
        begin
          Tmp := aChar;
          Tmp := AnsiUpperCase(Tmp);
          Result := Tmp[1]
        end
        else
          case aChar of
          'A', 'a' : Result := 'А';
          'B', 'b' : Result := 'В';
          'C', 'c' : Result := 'С';
          'T', 't' : Result := 'Т';
          'Y', 'y' : Result := 'У';
          'E', 'e' : Result := 'Е';
          'O', 'o' : Result := 'О';
          'P', 'p' : Result := 'Р';
          'H', 'h' : Result := 'Н';
          'K', 'k' : Result := 'К';
          'X', 'x' : Result := 'Х';
          'M', 'm' : Result := 'М';
          '3'      : Result := 'З';
          '0'      : Result := 'О';
          end;
      end;
  1 :
      begin
        case aChar of
        'X', 'x', // Lat
        'Х', 'х' :  // Rus
          begin
            Result := 'X'; // Lat
          end;
        '1', 'I', 'i', '!', '|':
          begin
            Result := 'I';
          end;
        '5', 'V', 'v':
          begin
            Result := 'V';
          end;
        end;
      end;
  2 :
      begin
        Result := String(UpperCase(aChar))[1];
      end;
  else
      begin
        Result := #0;
      end;
  end;
end;

class function TGeoUtils.GetNeighbourMap(const Nomenclature: String; const Position: TNeighbour4): string;
var
  X, Y: Integer;
begin
  Result := '';
  if MapTopLeft(Nomenclature, X, Y) then
  begin
    case Position of
      n4Left:
        begin
          Dec(X, 10);
          Dec(Y, 10);
        end;
      n4Top:
        begin
          Inc(X, 10);
          Inc(Y, 10);
        end;
      n4Right:
        begin
          Dec(X, 10);
          Inc(Y, 260);
        end;
      n4Bottom:
        begin
          Dec(X, 260);
          Inc(Y, 10);
        end;
    end;
    Result := GetNomenclature500(X, Y);
  end;
end;

class function TGeoUtils.GetNomenclature2000(const X, Y: Double): String;
var
  N: Integer;
  P1, P2: String;
begin
  // calc Y
  N := (Trunc(Y + 10000) div 1000);
  if Y > -10000 then Inc(N); 
  if N = 0 then
    P2 := '0'
  else
  begin
    if N < 0 then P2 := '0' else P2 := '';
    P2 := P2 + ArabianToLatin(Abs(N));
  end;
  // calc X
  N := Trunc(X) div 1000 - 13; // отняли 13, стобы переместить координаты X от 0 до -1000 в положение А
  if N > -14 then
  if X > 0 then
  Inc(N);
  if N > 0 then
    P1 := '0' + GeoStr[N]
  else
  if N < -27 then
    P1 := '0' + GeoStr[2 * Length(GeoStr) + N]
  else
    P1 := GeoStr[Abs(N) + 1];
  Result := P1 + '-' + P2;
end;

class function TGeoUtils.GetNomenclature500(const X, Y: Double): String;
var
  P1, P2: String;
  iX, iY: Integer;
begin
  P1 := GetNomenclature2000(X, Y);
  iX := (Trunc(X) mod 1000);
  if iX > 0 then iX := iX - 1000;
  iY := (Trunc(Y) mod 1000);
  if iY < 0 then iY := iY + 1000;
  iX := Abs(iX) div 250;
  iY := iY div 250 + 1;
  P2 := IntToStr( 4 * iX + iY );
  Result := P1 + '-' + P2;
end;

class procedure TGeoUtils.GetNomenclatureParts(const Name: String; var Parts: TStringList);
begin
  if not Assigned(Parts) then
    Parts := TStringList.Create;
  if Length(Name) > 0 then
  begin
    Parts.Delimiter := '-';
    Parts.DelimitedText := Name;
  end;
end;

class function TGeoUtils.GetPart1(const aValue: String): TPart1;
var
  L: Integer;
  Postfix, S: String;
  Ch2, Ch3: Char;
begin
  // Формат номенклатуры:
  // X[C]
  // 0X[C]
  // X(КР)[C]
  // XК[C]
  Result.Clear();
  S := Trim(aValue);
  Result.Valid := S <> '';
  if Result.Valid then
  begin
    L := Length(S);
    Result.Zero := S[1] = '0';
    if Result.Zero then
    begin
      Result.Valid := L in [2, 3];
      if Result.Valid then
      begin
        Result.Letter := TGeoUtils.ConvertPartChar(0, S[2]);
        Result.Valid := Result.Letter <> #0;
        if Result.Valid and (L = 3) then
        begin
          Result.Valid := S[3] in ['C', 'c', 'С', 'с'];
          if Result.Valid then
            Result.FoundSecret := True
          else
          begin
            Result.Valid := S[3] in ['К', 'к', 'K', 'k'];
            if Result.Valid then
              Result.FoundKrasnolesny := True;
          end;
        end;
      end;
    end
    else
    begin
      Result.Valid := L in [1, 2, 3, 5, 6];
      if Result.Valid then
      begin
        Result.Letter := TGeoUtils.ConvertPartChar(0, S[1]);
        Result.Valid := Result.Letter <> #0;
        if Result.Valid then
        begin
          case L of
            2 :
                begin
                  Ch2 := TGeoUtils.ConvertPartChar(0, S[2]);
                  Result.Valid := Ch2 in ['К', 'С'];
                  if Result.Valid then
                  begin
                    Result.FoundKrasnolesny := Ch2 = 'К';
                    Result.FoundSecret := Ch2 = 'С';
                  end;
                end;
            3 :
                begin
                  Ch2 := TGeoUtils.ConvertPartChar(0, S[2]);
                  Ch3 := TGeoUtils.ConvertPartChar(0, S[3]);
                  Result.Valid := (Ch2 in ['К', 'С']) and (Ch3 in ['К', 'С']);
                  if Result.Valid then
                  begin
                    Result.FoundKrasnolesny := True;
                    Result.FoundSecret := True;
                  end;
                end;
            5 :
                begin
                  PostFix := UpperCase(Copy(S, L - 4, 4));
                  if TGeoUtils.IsValidPostfix(PostFix) then
                  begin
                    Result.FoundKrasnolesny := True;
                  end
                  else
                    Result.Valid := False;
                end;
            6 :
                begin
                  Ch2 := TGeoUtils.ConvertPartChar(0, S[2]);
                  Result.Valid := Ch2 = 'С';
                  if Result.Valid then
                  begin
                    PostFix := UpperCase(Copy(S, 3, 4));
                    Result.Valid := TGeoUtils.IsValidPostfix(PostFix);
                    if Result.Valid then
                    begin
                      Result.FoundKrasnolesny := True;
                      Result.FoundSecret := True;
                    end;
                  end
                  else
                  begin
                    Ch2 := TGeoUtils.ConvertPartChar(0, S[6]);
                    Result.Valid := Ch2 = 'С';
                    if Result.Valid then
                    begin
                      PostFix := UpperCase(Copy(S, 2, 4));
                      Result.Valid := TGeoUtils.IsValidPostfix(PostFix);
                      if Result.Valid then
                      begin
                        Result.FoundKrasnolesny := True;
                        Result.FoundSecret := True;
                      end;
                    end;
                  end;
                end;
          end;
        end;
      end;
    end;
  end;
end;

class function TGeoUtils.GetPart2(const aValue: String; const StrictCheck: Boolean): TPart2;
var
  I: Integer;
  S: String;
  Ch: Char;
begin
  // Формат
  // 0
  // 0XXX
  // XXX
  Result.Clear();
  S := Trim(aValue);
  Result.Valid := S <> '';
  if Result.Valid then
  begin
    if S = '0' then
    begin
      Result.Number := 0;
    end
    else
    begin
      Result.Zero := S[1] = '0';
      if Result.Zero then
        Delete(S, 1, 1);
      if not StrictCheck then
        if TryStrToInt(S, I) then
        begin
          Result.Number := I;
          Exit;
        end;
      for I := 1 to Length(S) do
      begin
        Ch := ConvertPartChar(1, S[I]);
        if Ch = #0 then
        begin
          Result.Valid := False;
          Exit;
        end;
        S[I] := Ch;
      end;
      I := LatinToArabian(S);
      Result.Valid := I > 0;
      if Result.Valid then
        Result.Number := I;
    end;
  end;
end;

class function TGeoUtils.GetPart3(const aValue: String): TPart3;
var
  S: String;
  K: Integer;
begin
  S := Trim(aValue);
  Result.Clear();
  Result.Valid := S <> '';
  if Result.Valid then
  begin
    if Length(S) > 1 then
    begin
      if S[Length(S)] in ['k', 'K', 'к', 'К'] then
      begin
        Result.FoundKrasnolesny := True;
        SetLength(S, Length(S) - 1);
      end;
    end;
    if TryStrToInt(S, K) then
    begin
      Result.Valid := K in [1..16];
      if Result.Valid then
        Result.Number := K;
    end;
  end;
end;

class function TGeoUtils.GetNomenclature(const aNomenclature: String; const StrictNumbers: Boolean): TNomenclature;
begin
  Result.Init(aNomenclature, StrictNumbers);
end;

class function TGeoUtils.IsValidPostfix(const aValue: String): Boolean;
const
  RR = '(КР)';
  LL = '(KP)';
  RL = '(КP)';
  LR = '(KР)';
begin
  Result := (aValue = RR) or (aValue = LL) or (aValue = RL) or (aValue = LR);
end;

class function TGeoUtils.IsMCK36(const Xgeo, Ygeo: Double): Boolean;
var
  Coords: TCoords;
begin
  Coords.X := Xgeo;
  Coords.Y := Ygeo;
  Coords.Geo := True;
  Result := Coords.GetCoordSystem() = csMCK36;
end;

class function TGeoUtils.IsNomenclatureValid(const aNomenclature: String; const StrictNumbers: Boolean): Boolean;
var
  N: TNomenclature;
begin
  N.Init(aNomenclature, StrictNumbers);
  Result := N.Valid;
end;

class function TGeoUtils.MapTopLeft(const Nomen: String; Scale: TGeoScale; var aTop, aLeft: Integer): Boolean;
var
//  Parts: TStringList;
//  K, I: Integer;
//  S: String;
//  b: Boolean;
  N: TNomenclature;
begin
  Result := False;
  N.Init(Nomen, False);
  case Scale of
    gs500:
      begin
        if N.Scale = gs500 then
        if N.Valid then
        begin
          aTop := N.Top500;
          aLeft := N.Left500;
        end;
      end;
    gs2000:
      begin
        if N.Scale in [gs500, gs2000] then
        if N.Valid then
        begin
          aTop := N.Top2000;
          aLeft := N.Left2000;
        end;
      end;
  else
      raise Exception.Create('Неверный тип масштаба в функции MapTopLeft!');
  end;
//  Parts := TStringList.Create;
//  Parts.Forget();
//  GetNomenclatureParts(nomen, Parts);
//  case Scale of
//  gs500 :
//    begin
//      K := StrToInt(Parts.Strings[2]);
//      // считаем x
//      S := Parts.Strings[0];
//      b := S[1] = '0';
//      if b then
//      begin
//        I := Pos(S[2], GeoStr);
//        if I > 0 then
//        if I < 14 then
//          x := (I + 13) * 1000
//        else
//          x := (Length(GeoStr) - 13 - I) * 1000;
//      end
//      else
//      begin
//        I := Pos(S[1], GeoStr);
//        if I > 0 then
//          x := (14 - I) * 1000;
//      end;
//      x := x - (Pred(K) div 4) * 250;
//{            case K of
//      1, 2, 3, 4     : x := x;
//      5, 6, 7, 8     : x := x - 250;
//      9, 10, 11, 12  : x := x - 500;
//      13, 14, 15, 16 : x := x - 750;
//      else exit;
//      end;        }
//      // считаем y
//      s := Parts.Strings[1];
//      b := (s[1] = '0') and (Length(s) > 1);
//      if b then Delete(s, 1, 1);
//      i := LatinToArabian(s);
//      y := i * 1000 - 11000;
//      case k of
//      1, 5, 9, 13  : y := y;
//      2, 6, 10, 14 : y := y + 250;
//      3, 7, 11, 15 : y := y + 500;
//      4, 8, 12, 16 : y := y + 750;
//      else exit;
//      end;
//      result := True;
//    end;
//  else
//    begin
//      raise Exception.Create('Неверный тип масштаба в функции MapTopLeft!');
//    end;
//  end;
end;

class function TGeoUtils.MapTopLeft(const Nomenclature: String; var aTop, aLeft: Integer): Boolean;
var
  N: TNomenclature;
begin
  N.Init(Nomenclature, False);
  if N.Valid then
  begin
    aTop := N.Top500;
    aLeft := N.Left500;
    Result := True;
  end
  else
    Result := False;
end;

{ TNomenclature }

function TNomenclature.AsStrings(const Delimiter: Char): TStrings;
var
  I: Integer;
begin
  Result := TStringList.Create;
  Result.Delimiter := Delimiter;
  Result.StrictDelimiter := True;
  for I := 0 to Pred(PartCount) do
    Result.Add(Parts[I]);
end;

function TNomenclature.Bounds: TRect;
begin
  Result.Left := Left500;
  Result.Right := Result.Left + 250;
  Result.Top := Top500;
  Result.Bottom := Result.Top - 250;
end;

function TNomenclature.Build(P1: TPart1; P2: TPart2; P3: TPart3): TNomenclature;
var
  NomenclatureText: string;
begin
  P1.FoundKrasnolesny := P1.FoundKrasnolesny or P3.FoundKrasnolesny;
  P3.FoundKrasnolesny := False;
  NomenclatureText := P1.GetValidText() + '-' + P2.GetValidText() + '-' + P3.GetValidText(False);
  Result.Init(NomenclatureText, False);
end;

procedure TNomenclature.CalcTopLeft1;
var
  I: Integer;
begin
  if not Valid then
    Exit;
  if fP1.Valid and fP2.Valid then
  begin
    if fP1.Zero then
    begin
      I := Pos(fP1.Letter, GeoStrTop);
      if I > 0 then
        Top2000 := (13 + I) * 1000
      else
      begin
        I := Pos(fP1.Letter, GeoStrBottom);
        if I > 0 then
          Top2000 := -(14 + I) * 1000
        else
          Exit;
      end;
    end
    else
    begin
      I := Pos(fP1.Letter, GeoStr);
      if I > 0 then
        Top2000 := (14 - I) * 1000
      else
        Exit;
    end;
    //
    if fP2.Number = 0 then
      Left2000 := -11000
    else
    begin
      if fP2.Zero then
        Left2000 := -(11 + fP2.Number) * 1000
      else
        Left2000 := (fP2.Number - 11) * 1000;
    end;
    //
    if Krasnolesny then
    begin
      Top2000 := Top2000 + 43000;
      Left2000 := Left2000 + 38000;
    end;
    //
    if fP3.Valid then
    begin
      Top500 := Top2000 - (Pred(fP3.Number) div 4) * 250;
      Left500 := Left2000 + (Pred(fP3.Number) mod 4) * 250;
    end;
  end;
end;

procedure TNomenclature.CalcTopLeft2;
const
  S_NOMENCLATURE_CHARS = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ';
  S_NOMENCLATURE_CHARS_LAT = 'AБBГДEЖЗИKЛMHOПPCTУФXЦЧШЩЭЮЯ';
var
  I: Integer;
  X: Integer;
begin
  if fP1.Valid and fP2.Valid then
  begin
    // считаем x
    I := Pos(fP1.Letter, S_NOMENCLATURE_CHARS);
    if I < 1 then
    begin
      I := Pos(fP1.Letter, S_NOMENCLATURE_CHARS_LAT);
      if I < 1 then
        Exit;
    end;
    if fP1.Zero then
    begin
      if I < 23 then
        X := I + 13
      else
        X := I - 43;
    end
    else
      X := 14 - I;
    Top2000 := X * 1000;
    // считаем y
    Left2000 := (fP2.Number - 11) * 1000;
    //сдвигаем координату Y на 2000 влево
    if fP2.Zero then
      Left2000 := Left2000 + (-2000 * fP2.Number);
    //
    if Krasnolesny then
    begin
      Top2000 := Top2000 + 43000;
      Left2000 := Left2000 + 38000;
    end;
    //
    if fP3.Valid then
    begin
      case fP3.Number of
        1, 2, 3, 4     : Top500 := Top2000;
        5, 6, 7, 8     : Top500 := Top2000 - 250;
        9, 10, 11, 12  : Top500 := Top2000 - 500;
        13, 14, 15, 16 : Top500 := Top2000 - 750;
      else
        Exit;
      end;
      case fP3.Number of
      1, 5, 9, 13  : Left500 := Left2000;
      2, 6, 10, 14 : Left500 := Left2000 + 250;
      3, 7, 11, 15 : Left500 := Left2000 + 500;
      4, 8, 12, 16 : Left500 := Left2000 + 750;
      else
        Exit;
      end;
    end;
  end;
end;

procedure TNomenclature.Clear;
begin
  Part1 := '';
  Part2 := '';
  Part3 := '';
  Secret := False;
  Krasnolesny := False;
  Scale := gs500;
  PartCount := 0;
  Valid := False;
  //
  fP1.Clear();
  fP2.Clear();
  fP3.Clear();
  //
  Left500 := -1;
  Top500 := -1;
  Left2000 := -1;
  Top2000 := -1;
end;

function TNomenclature.GetNeighbour(const Position: TNeighbour4): TNomenclature;
var
  S: string;
begin
  S := TGeoUtils.GetNeighbourMap(Nomenclature, Position);
  Result.Init(S, False);
end;

function TNomenclature.GetParts(const Index: Integer): string;
begin
  case Index of
  0 : Result := Part1;
  1 : Result := Part2;
  2 : Result := Part3;
  else
    raise Exception.Create('Неверный индекс в функции TNomenclature.GetParts!');
  end;
end;

function TNomenclature.GetValidParts: string;
begin
  Result := '';
  if fP1.Valid then
  begin
    Result := fP1.GetValidText();
    if fP2.Valid then
    begin
      Result := Result + '-' + fP2.GetValidText();
      if fP3.Valid then
        Result := Result + '-' + fP3.GetValidText(True);
    end;
  end;
end;

procedure TNomenclature.Init(const aNomenclature: string; const StrictNumbers: Boolean);
var
  Parts: TStringList;
  Tmp1: TPart1;
  Tmp3: TPart3;
begin
  Clear();
  Parts := TStringList.Create;
  Parts.Forget();
  TGeoUtils.GetNomenclatureParts(aNomenclature, Parts);
  if Parts.Count = 1 then
    fP1 := TGeoUtils.GetPart1(Parts[0])
  else
  if Parts.Count in [2, 3] then
  begin
    fP1 := TGeoUtils.GetPart1(Parts[0]);
    fP2 := TGeoUtils.GetPart2(Parts[1], StrictNumbers);
    if fP1.Valid and fP2.Valid then
    begin
      if Parts.Count = 3 then
      begin
        fP3 := TGeoUtils.GetPart3(Parts[2]);
        Valid := fP3.Valid;
        if Valid then
        begin
          Scale := gs500;
          Secret := fP1.FoundSecret;
          Krasnolesny := fP1.FoundKrasnolesny or fP3.FoundKrasnolesny;
          Tmp1 := fP1;
          Tmp1.FoundKrasnolesny := Krasnolesny;
          Tmp3 := fP3;
          Tmp3.FoundKrasnolesny := False;
          Part1 := Tmp1.GetValidText();
          Part2 := fP2.GetValidText();
          Part3 := Tmp3.GetValidText(False);
          PartCount := 3;
          CalcTopLeft2();
        end;
      end
      else
      begin
        Scale := gs2000;
        Krasnolesny := fP1.FoundKrasnolesny;
        Secret := fP1.FoundSecret;
        Part1 := fP1.GetValidText();
        Part2 := fP2.GetValidText();
        PartCount := 2;
        Valid := True;
        CalcTopLeft2();
      end;
    end;
  end;
end;

function TNomenclature.Nomenclature: string;
begin
  Result := '';
  if Valid then
  begin
    if PartCount > 1 then
      Result := Part1 + '-' + Part2;
    if PartCount > 2 then
      Result := Result + '-' + Part3;
  end;
end;

procedure TNomenclature.ReBuild(const Secret: Boolean);
var
  Tmp1: TPart1;
  Tmp2: TPart2;
  Tmp3: TPart3;
  N: TNomenclature;
begin
  Tmp1 := fP1;
  Tmp1.FoundSecret := Secret;
  Tmp2 := fP2;
  Tmp3 := fP3;
  N := Build(Tmp1, Tmp2, Tmp3);
  Init(N.Nomenclature, False);
end;

{ TPart1 }

procedure TPart1.Clear;
begin
  FoundKrasnolesny := False;
  FoundSecret := False;
  Valid := False;
  Zero := False;
  Letter := #0;
end;

function TPart1.GetValidText: string;
begin
  if Valid then
  begin
    if Zero then
      Result := '0'
    else
      Result := '';
    Result := Result + Letter;
    if FoundKrasnolesny then
      Result := Result + 'К';
    if FoundSecret then
      Result := Result + 'С';
  end
  else
    Result := '';
end;

{ TPart2 }

procedure TPart2.Clear;
begin
  Valid := False;
  Zero := False;
  Number := -1;
end;

function TPart2.GetValidText: string;
begin
  if Valid then
  begin
    if Number = 0 then
      Result := '0'
    else
    begin
      if Zero then
        Result := '0'
      else
        Result := '';
      Result := Result + ArabianToLatin(Number);
    end;
  end
  else
    Result := '';
end;

{ TPart3 }

procedure TPart3.Clear;
begin
  FoundKrasnolesny := False;
  Valid := False;
  Number := 0;
end;

function TPart3.GetValidText(AddK: Boolean): string;
begin
  if Valid then
  begin
    Result := IntToStr(Number);
    if FoundKrasnolesny and AddK then
      Result := Result + 'К';
  end
  else
    Result := '';
end;

{ TCoords }

procedure TCoords.Convert(ToCs: TCoordSystem);
var
  TheCs: TCoordSystem;
  X1, Y1, X2, Y2: Double;
begin
  if not (ToCs in [csVrn, csMCK36]) then
    raise Exception.Create('Неизвестная координатная система!');

  TheCs := GetCoordSystem();
  if TheCs = ToCs then
    Exit;
  case ToCs of
    csVrn:
      begin
        if Geo then
        begin
          X1 := X;
          Y1 := Y;
        end
        else
        begin
          X1 := Y;
          Y1 := X;
        end;
        uCK36.ToVRN(X1, Y1, X2, Y2);
        if Geo then
        begin
          X := X2;
          Y := Y2;
        end
        else
        begin
          X := Y2;
          Y := X2;
        end;
      end;
    csMCK36:
      begin
        if Geo then
        begin
          X1 := X;
          Y1 := Y;
        end
        else
        begin
          X1 := Y;
          Y1 := X;
        end;
        uCK36.ToCK36(X1, Y1, X2, Y2);
        if Geo then
        begin
          X := X2;
          Y := Y2;
        end
        else
        begin
          X := Y2;
          Y := X2;
        end;
      end;
  else
    raise Exception.Create('Неизвестная координатная система!');
  end;
end;

function TCoords.GetCoordSystem: TCoordSystem;
var
  Is36: Boolean;
begin
  if Geo then
  begin
    Is36 := (X > 400000) or (Y > 1000000);
  end
  else
  begin
    Is36 := (Y > 400000) or (X > 1000000);
  end;
  if Is36 then
    Result := csMCK36
  else
    Result := csVrn;
end;

end.
