unit uKisAllotmentClasses;

interface

uses
  SysUtils, Classes, Contnrs, Types, Math, Graphics,
  uGC;

type
  TCoordSystem = (csVrn, csMCK36);

  TKisPoint = class
  private
    fX, fY: Double;
    fX36, fY36: Double;
    fName: String;
    FId: Integer;
    FScreenPt: TPoint;
    procedure SetName(const Value: String);
    procedure SetX(const Value: Double);
    procedure SetX36(const Value: Double);
    procedure SetY(const Value: Double);
    procedure SetY36(const Value: Double);
    procedure SetId(const Value: Integer);
    procedure SetScreenPt(const Value: TPoint);
    function GetX36: Double;
    function GetY36: Double;
  public
    constructor Create(const aX, aY: Double);
    //
    function AsString: String;
    function Clone: TKisPoint;
    //
    property Id: Integer read FId write SetId;
    property Name: String read FName write SetName;
    property ScreenPt: TPoint read FScreenPt write SetScreenPt;
    property X: Double read FX write SetX;
    property Y: Double read FY write SetY;
    property X36: Double read GetX36 write SetX36;
    property Y36: Double read GetY36 write SetY36;
  end;

  TKisExtent = class
  public
    FXmin, FXmax, FYmin, FYmax: Double;
    constructor Create(aSource: TKisExtent); overload;
    constructor Create(const aXmin, aXmax, aYmin, aYmax: Double); overload;
    procedure Join(E: TKisExtent);
  end;

  TContour = class(TObjectList)
  private
    FName: String;
    FId: Integer;
    FEnabled: Boolean;
    FPositive: Boolean;
    FClosed: Boolean;
    FColor: Integer;
    FImageIndex: Integer;
    function GetPoints(Index: Integer): TKisPoint;
    procedure SetId(const Value: Integer);
    procedure SetName(const Value: String);
    procedure SetPoints(Index: Integer; const Value: TKisPoint);
    procedure SetEnabled(const Value: Boolean);
    procedure SetPositive(const Value: Boolean);
    procedure SetClosed(const Value: Boolean);
    procedure SetColor(const Value: Integer);
    procedure SetImageIndex(const Value: Integer);
  public type
    TContourLoadError = (cleWrongFormat, cleWrongColumnNumber);
    TContourLoadErrors = set of TContourLoadError;
  public
    constructor Create;
    //
    function AddPoint(const X, Y: Double; const PtName: String = ''): Integer;
    procedure Append(Source: TContour; var Renamed: Boolean);
    function Area(aSystem: TCoordSystem): Double;
    function Azimuth(Index: Integer; Cs: TCoordSystem): Double;
    procedure CalcPointIds;
    function FindPointByName(const aName: String): TKisPoint;
    function GetDrawColor: TColor;
    function GetExtent: TKisExtent;
    function GetLength(Index: Integer; Cs: TCoordSystem): Double;
    function Last: TKisPoint;
    procedure LoadFromText(const aText: String; Cs: TCoordSystem;
      const Delimiter: Char; var Rows, Inserted: Integer; var Errors: TContourLoadErrors);
    procedure LoadFromTextConsultant(const aText: String; Cs: TCoordSystem;
      var Inserted: Integer; var Errors: TContourLoadErrors);
    procedure LoadFromTextConsultant2(const aText: String; Cs: TCoordSystem);
    procedure LoadFromTextConsultant3(const aText: String; Cs: TCoordSystem);
    procedure RenamePoints(const PointNameTemplate: String);
    procedure ToStrings(Strings: TStrings);
    //
    property Id: Integer read FId write SetId;
    property Closed: Boolean read FClosed write SetClosed;
    property Color: Integer read FColor write SetColor;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Name: String read FName write SetName;
    property Positive: Boolean read FPositive write SetPositive;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    //
    property Points[Index: Integer]: TKisPoint read GetPoints write SetPoints; default;
  end;

  TContours = class(TObjectList)
  private
    function GetItems(Index: Integer): TContour;
    procedure SetItems(Index: Integer; const Value: TContour);
  public
    function EnabledCount: Integer;
    procedure ToStrings(Strings: TStrings);
    //
    property Items[Index: Integer]: TContour read GetItems write SetItems; default;
  end;

implementation

uses
  uCK36, uKisUtils;

{ TContour }

function TContour.AddPoint(const X, Y: Double; const PtName: String): Integer;
var
  Pt: TKisPoint;
begin
  Pt := TKisPoint.Create(X, Y);
  if PtName <> '' then
    Pt.Name := PtName;
  Result := inherited Add(Pt);
end;

procedure TContour.Append(Source: TContour; var Renamed: Boolean);
var
  I, J, Num: Integer;
  NewPt, OldPt: TKisPoint;
  Prefix: String;
begin
  Renamed := False;
  for I := 0 to Source.Count - 1 do
  begin
    NewPt := Source[I].Clone;
    if Trim(NewPt.Name) = '' then
      NewPt.Name := IntToStr(Count);
    OldPt := FindPointByName(NewPt.Name);
    if Assigned(OldPt) then
      repeat
        J := BackwardPos('_', OldPt.Name);
        if (J > 0) and
           TryStrToInt(Copy(OldPt.Name, J + 1, Length(OldPt.Name) - J), Num)
        then
          Prefix := Copy(OldPt.Name, 1, J - 1)
        else
        begin
          Prefix := OldPt.Name;
          Num := 1;
        end;
        NewPt.Name := Prefix + '_' + IntToStr(Succ(Num));
        Renamed := True;
        OldPt := FindPointByName(NewPt.Name);
      until not Assigned(OldPt);
    Add(NewPt);
  end;
end;

function TContour.Area(aSystem: TCoordSystem): Double;
var
  I, J, K: Integer;
  Xi, Xk, Yj: Double;
begin
  Result := 0;
  if not Closed then
    Exit;
  if Count < 3 then
    Exit;
  ///
  J := Pred(Count);
  K := Pred(J);
  for I := 0 to Pred(Count) do
  begin
    if aSystem = csVrn then
    begin
      Xi := Points[I].X;
      Xk := Points[K].X;
      Yj := Points[J].Y;
    end
    else
    begin
      Xi := Points[I].X36;
      Xk := Points[K].X36;
      Yj := Points[J].Y36;
    end;
    Result := Result + (Xi - Xk) * Yj;
    K := J;
    J := I;
  end;
  ///
  Result := Abs(Result / 2);
end;

function TContour.Azimuth(Index: Integer; Cs: TCoordSystem): Double;
var
  I, J: Integer;
  Xi, Xj, Yi, Yj: Double;
begin
  I := Index;
  J := Succ(Index);
  if J = Count then
    J := 0;
  if Cs = csVrn then
  begin
    Xi := Points[I].X;
    Xj := Points[J].X;
    Yi := Points[I].Y;
    Yj := Points[J].Y;
  end
  else
  begin
    Xi := Points[I].X36;
    Xj := Points[J].X36;
    Yi := Points[I].Y36;
    Yj := Points[J].Y36;
  end;
  if Xj = Xi then
  begin
    if Yj >= Yi then
      Result := Pi/2
    else
      Result := -Pi/2;
  end
  else
    Result := ArcTan((Yj - Yi) / (Xj - Xi));

  if Xj >= Xi then
  begin
    if Yj < Yi then
      Result := Result+2*Pi
  end
  else
    Result := Result + Pi;
end;

procedure TContour.CalcPointIds;
var
  I: Integer;
//  ChangeName: Boolean;
begin
  for I := 0 to Count - 1 do
  begin
//    ChangeName := Points[I].Name = IntToStr(Points[I].Id);
    Points[I].Id := I + 1;
///ed
//    if ChangeName then
//      Points[I].Name := IntToStr(Points[I].Id);
  end;
end;

constructor TContour.Create;
begin
  FClosed := True;
  FColor := 0;
end;

function TContour.FindPointByName(const aName: String): TKisPoint;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Points[I].Name = aName then
    begin
      Result := Points[I];
      Exit;
    end;
  Result := nil;
end;

function TContour.GetDrawColor: TColor;
begin
  if Color = 0 then
  begin
    case Id of
      1: Color := clBlack;
      2: Color := clMaroon;
      3: Color := clGreen;
      4: Color := clOlive;
      5: Color := clNavy;
      6: Color := clPurple;
      7: Color := clTeal;
      8: Color := clGray;
      9: Color := clSilver;
      10: Color := clRed;
      11: Color := clLime;
      12: Color := clYellow;
      13: Color := clBlue;
      14: Color := clFuchsia;
    else
      Color := clAqua;
    end;
  end
  else
    Result := Color;
end;

function TContour.GetExtent: TKisExtent;
var
  I: Integer;
begin
  Result := nil;
  if Count > 0 then
  begin
    with Points[0] do
      Result := TKisExtent.Create(X, X, Y, Y);
    for I := 1 to Count - 1 do
    begin
      Result.FXmin := Min(Points[I].X, Result.FXmin);
      Result.FXmax := Max(Points[I].X, Result.FXmax);
      Result.FYmin := Min(Points[I].Y, Result.FYmin);
      Result.FYmax := Max(Points[I].Y, Result.FYmax);
    end;
  end;
end;

function TContour.GetPoints(Index: Integer): TKisPoint;
begin
  Result := Items[Index] as TKisPoint;
end;

function TContour.Last: TKisPoint;
begin
  if Count = 0 then
    Result := nil
  else
    Result := TKisPoint(inherited Last);
end;

function TContour.GetLength(Index: Integer; Cs: TCoordSystem): Double;
var
  I, J: Integer;
  Xi, Xj, Yi, Yj: Double;
begin
///  посмотреть координату по Х - если > 100000 это csMCK36 иначе csVrn
///  и тут нельзя..
  I := Index;
  J := Succ(Index);
  if J = Count then
    J := 0;

  //if Points[I].X > 100000 then
  //   Cs := csMCK36
  //   else
  //   Cs := csVrn;

  if Cs = csVrn then
  begin
    Xi := Points[I].X;
    Xj := Points[J].X;
    Yi := Points[I].Y;
    Yj := Points[J].Y;
  end
  else
  begin
    Xi := Points[I].X36;
    Xj := Points[J].X36;
    Yi := Points[I].Y36;
    Yj := Points[J].Y36;
  end;
  Result := Sqrt(Sqr(Xj - Xi) + Sqr(Yj - Yi));
end;

procedure TContour.LoadFromText(const aText: String; Cs: TCoordSystem;
  const Delimiter: Char; var Rows, Inserted: Integer; var Errors: TContourLoadErrors);
var
  S, Xs, Ys: String;
  theX, theY: Double;
  I, J: Integer;
  Lst, RowLst: TStringList;
  B: Boolean;
begin
  Lst := TStringList.Create;
  RowLst := TStringList.Create;
  try
    RowLst.Delimiter := Delimiter;
    // Загоняем точки в List
    S := StringReplace(aText, '.', DecimalSeparator, [rfReplaceAll]);
    S := StringReplace(S, ',', DecimalSeparator, [rfReplaceAll]);
    /// ed из планшетки точки приходят с пробелами перед координатой
    /// (видимо для форматирования)
    ///  заодно и пробелы уничтожаем
    Lst.Text := StringReplace(S, ' ', '', [rfReplaceAll]);
    ///  ed
    Rows := Lst.Count;
    Inserted := 0;
    for I := 0 to Pred(Lst.Count) do
    begin
      S := Lst[I];
      while (Length(S) > 0) and (S[Length(S)] in [',', Delimiter]) do
        System.Delete(S, Length(S), 1);
      RowLst.DelimitedText := S;
      /// удаляем пустые строки в списке
      for J := Pred(RowLst.Count) downto 0 do
        if Trim(RowLst[J]) = '' then
          RowLst.Delete(J)
        else
          RowLst[J] := Trim(RowLst[J]);
      /// пытаемся преобразовать текст в параметры точки
      if RowLst.Count in [0, 1] then
        Errors := Errors + [cleWrongColumnNumber]
      else
      if RowLst.Count = 2 then
      begin
        Xs := TrimToNumber(RowLst[0]);
        Ys := TrimToNumber(RowLst[1]);
        B := TryStrToFloat(Xs, theX);
        if B then
          B := TryStrToFloat(Ys, theY);
        if B then
        begin
          case Cs of
          csVrn :
            AddPoint(theX, theY, IntToStr(Succ(Count)));
          csMCK36:
            begin
              Add(TKisPoint.Create(0, 0));
              with Last do
              begin
                X36 := theX;
                Y36 := theY;
                Name := IntToStr(Succ(Count));
              end;
            end;
          end;
          Inc(Inserted);
        end
        else
        begin
          Errors := Errors + [cleWrongFormat];
        end;
      end
      else
      if RowLst.Count > 2 then
      begin
        Xs := RowLst[1];
        Xs := TrimToNumber(Xs);
        Ys := RowLst[2];
        Ys := TrimToNumber(Ys);
        B := TryStrToFloat(Xs, theX);
        if B then
          B := TryStrToFloat(Ys, theY);
        if B then
        begin
          case Cs of
          csVrn :
            AddPoint(theX, theY, RowLst[0]);
          csMCK36:
            begin
              Add(TKisPoint.Create(0, 0));
              with Last do
              begin
                X36 := theX;
                Y36 := theY;
                Name := RowLst[0];
              end;
            end;
          end;
          Inc(Inserted);
        end
        else
        begin
          Errors := Errors + [cleWrongFormat];
        end;
      end;
    end;
  finally
    FreeAndNil(RowLst);
    FreeAndNil(Lst);
  end;
end;

procedure TContour.LoadFromTextConsultant(const aText: String; Cs: TCoordSystem; var Inserted: Integer; var Errors: TContourLoadErrors);
var
  S: String;
  theX, theY: Double;
  I: Integer;
  Lst: TStringList;
  B, Found: Boolean;

  function Check3Rows(Rows: TStringList; Start: Integer; var Num: string; var X, Y: Double): Boolean;
  var
    B1, B2, B3: Boolean;
    S1, S2, S3: string;
  begin
    try
      S1 := Rows[Start];
      S2 := Rows[Start + 1];
      S3 := Rows[Start + 2];
      //
      B1 := Length(S1) <= 10;
      S2 := StringReplace(S2, '.', DecimalSeparator, [rfReplaceAll]);
      S2 := StringReplace(S2, ',', DecimalSeparator, [rfReplaceAll]);
      S2 := StringReplace(S2, ' ', '', [rfReplaceAll]);
      B2 := TryStrToFloat(S3, X);
      S3 := StringReplace(S3, '.', DecimalSeparator, [rfReplaceAll]);
      S3 := StringReplace(S3, ',', DecimalSeparator, [rfReplaceAll]);
      S3 := StringReplace(S3, ' ', '', [rfReplaceAll]);
      B3 := TryStrToFloat(S3, Y);
      //
      Result := B1 and B2 and B3;
      if Result then
      begin
        Num := S1;
      end;
    except
      Result := False;
    end;
  end;

begin
  // весь текст пишем в список
  // получаем список строк
  // анализируем строки
  // если две строки подряд преобразуются в числа, то мы что-то нашли
  // перед ними должен идти номер - строка не более 10 символов длиной
  // этот паттерн повторяется
  // как только он перестал повторяться, то контур кончается
  Lst := TStringList.Create;
  Lst.Forget();

  Lst.Text := aText;
  for I := Lst.Count - 1 downto 0 do
    if Trim(Lst[I]) = '' then
      Lst.Delete(I);
  I := 0;
  Found := False;
  while I < Lst.Count - 3 do
  begin
    B := Check3Rows(Lst, I, S, theX, theY);
    if B then
    begin
      if not Found then
        Found := True;
      case Cs of
      csVrn :
        AddPoint(theX, theY, S);
      csMCK36:
        begin
          Add(TKisPoint.Create(0, 0));
          with Last do
          begin
            X36 := theX;
            Y36 := theY;
            Name := S;
          end;
        end;
      end;
      Inc(Inserted);
      I := I + 3;
    end;
    if not B then
    begin
      if Found then
        Break;
      Inc(I);
    end
    else
    begin
      Errors := Errors + [cleWrongFormat];
    end;
  end;
end;

procedure TContour.LoadFromTextConsultant2(const aText: String; Cs: TCoordSystem);
var
  S: String;
  theX, theY: Double;
  I: Integer;
  Lst: TStringList;
  B, Found: Boolean;

  function Check3Rows(Rows: TStringList; Start: Integer; var Num: string; var X, Y: Double): Boolean;
  var
    B1, B2, B3: Boolean;
    S1, S2, S3: string;
  begin
    try
      S1 := Rows[Start];
      S2 := Rows[Start + 1];
      S3 := Rows[Start + 2];
      //
      B1 := Length(S1) <= 10;
      S2 := StringReplace(S2, '.', DecimalSeparator, [rfReplaceAll]);
      S2 := StringReplace(S2, ',', DecimalSeparator, [rfReplaceAll]);
      S2 := StringReplace(S2, ' ', '', [rfReplaceAll]);
      B2 := TryStrToFloat(S2, X);
      S3 := StringReplace(S3, '.', DecimalSeparator, [rfReplaceAll]);
      S3 := StringReplace(S3, ',', DecimalSeparator, [rfReplaceAll]);
      S3 := StringReplace(S3, ' ', '', [rfReplaceAll]);
      B3 := TryStrToFloat(S3, Y);
      //
      Result := B1 and B2 and B3;
      if Result then
      begin
        Num := S1;
      end;
    except
      Result := False;
    end;
  end;

  function FindStart(Lst: TStringList): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 1 to Lst.Count - 1 do
    begin
      if (Trim(Lst[I - 1]) = 'X') and (Trim(Lst[I]) = 'Y') then
      begin
        Result := I + 1;
        Exit;
      end;
    end;
  end;

begin
  // весь текст пишем в список
  // получаем список строк
  // анализируем строки
  // если две строки подряд преобразуются в числа, то мы что-то нашли
  // перед ними должен идти номер - строка не более 10 символов длиной
  // этот паттерн повторяется
  // как только он перестал повторяться, то контур кончается
  Lst := TStringList.Create;
  Lst.Forget();

  Lst.Text := aText;
  for I := Lst.Count - 1 downto 0 do
    if Trim(Lst[I]) = '' then
      Lst.Delete(I);
  I := FindStart(Lst);
  Found := False;
  while I < Lst.Count - 3 do
  begin
    B := Check3Rows(Lst, I, S, theX, theY);
    if B then
    begin
      if not Found then
        Found := True;
      case Cs of
      csVrn :
        AddPoint(theX, theY, S);
      csMCK36:
        begin
          Add(TKisPoint.Create(0, 0));
          with Last do
          begin
            X36 := theX;
            Y36 := theY;
            Name := S;
          end;
        end;
      end;
      I := I + 3;
    end;
    if not B then
    begin
      if Found then
        Break;
      Inc(I);
    end;
  end;
end;

procedure TContour.LoadFromTextConsultant3(const aText: String; Cs: TCoordSystem);
var
  S: String;
  theX, theY: Double;
  I: Integer;
  Lst: TStringList;
  B, Found: Boolean;

  function Check5Rows(Rows: TStringList; Start: Integer; var Num: string; var X, Y: Double): Boolean;
  var
    B1, B2, B3, B4, B5: Boolean;
    S1, S2, S3, S4, S5: string;
    Dummy: Double;
  begin
    try
      Result := Start + 4 < Rows.Count;
      if not Result then
        Exit;
      S1 := Rows[Start];
      S2 := Rows[Start + 1];
      S3 := Rows[Start + 2];
      S4 := Rows[Start + 3];
      S5 := Rows[Start + 4];
      //
      B1 := Length(S1) <= 10;
      B2 := not TryStrToFloat(S2, Dummy);
      B3 := not TryStrToFloat(S3, Dummy);
      S4 := StringReplace(S4, '.', DecimalSeparator, [rfReplaceAll]);
      S4 := StringReplace(S4, ',', DecimalSeparator, [rfReplaceAll]);
      S4 := StringReplace(S4, ' ', '', [rfReplaceAll]);
      B4 := TryStrToFloat(S4, X);
      S5 := StringReplace(S5, '.', DecimalSeparator, [rfReplaceAll]);
      S5 := StringReplace(S5, ',', DecimalSeparator, [rfReplaceAll]);
      S5 := StringReplace(S5, ' ', '', [rfReplaceAll]);
      B5 := TryStrToFloat(S5, Y);
      //
      Result := B1 and B2 and B3 and B4 and B5;
      if Result then
      begin
        Num := S1;
      end;
    except
      Result := False;
    end;
  end;

  function FindStart(Lst: TStringList): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 1 to Lst.Count - 1 do
    begin
      if (Trim(Lst[I - 1]) = 'X') and (Trim(Lst[I]) = 'Y') then
      begin
        Result := I + 1;
        Exit;
      end;
    end;
  end;

begin
  // весь текст пишем в список
  // получаем список строк
  // анализируем строки
  // если две строки подряд преобразуются в числа, то мы что-то нашли
  // перед ними должен идти номер - строка не более 10 символов длиной
  // этот паттерн повторяется
  // как только он перестал повторяться, то контур кончается
  Lst := TStringList.Create;
  Lst.Forget();

  Lst.Text := aText;
  for I := Lst.Count - 1 downto 0 do
    if Trim(Lst[I]) = '' then
      Lst.Delete(I);
  I := FindStart(Lst);
  Found := False;
  while I < Lst.Count - 4 do
  begin
    B := Check5Rows(Lst, I, S, theX, theY);
    if B then
    begin
      if not Found then
        Found := True;
      case Cs of
      csVrn :
        AddPoint(theX, theY, S);
      csMCK36:
        begin
          Add(TKisPoint.Create(0, 0));
          with Last do
          begin
            X36 := theX;
            Y36 := theY;
            Name := S;
          end;
        end;
      end;
      I := I + 5;
    end;
    if not B then
    begin
      if Found then
        Break;
      Inc(I);
    end;
  end;
end;

procedure TContour.RenamePoints(const PointNameTemplate: String);
var
  I, J, K: Integer;
  Prefix, Postfix, Num: String;
begin
  I := Length(PointNameTemplate);
  while (I > 0) and not (PointNameTemplate[I] in ['0'..'9']) do
    Dec(I);
  Postfix := Copy(PointNameTemplate, I + 1, Length(PointNameTemplate) - I);
  J := I;
  while (J > 0) and (PointNameTemplate[J] in ['0'..'9']) do
    Dec(J);
  Prefix := Copy(PointNameTemplate, 1, J);
  Num := Copy(PointNameTemplate, J + 1, Length(PointNameTemplate) - J - Length(Postfix));
  if not TryStrToInt(Num, K) then
    K := 0;
  for I := 0 to Count - 1 do
  begin
    Inc(K);
    Points[I].Name := Prefix + IntToStr(K) + Postfix;
  end;
end;

procedure TContour.SetClosed(const Value: Boolean);
begin
  FClosed := Value;
end;

procedure TContour.SetColor(const Value: Integer);
begin
  FColor := Value;
end;

procedure TContour.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TContour.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TContour.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
end;

procedure TContour.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TContour.SetPoints(Index: Integer; const Value: TKisPoint);
begin
  Items[Index] := Value;
end;

procedure TContour.SetPositive(const Value: Boolean);
begin
  FPositive := Value;
end;

procedure TContour.ToStrings(Strings: TStrings);
var
  I: Integer;
begin
  if Assigned(Strings) then
  begin
    Strings.Add('Id = ' + IntToStr(Id));
    Strings.Add('Enabled = ' + BooltoStr(Enabled));
    Strings.Add('Name = ' + Name);
    Strings.Add('Positive = ' + BooltoStr(Positive));
    Strings.Add('Точки = ' + IntToStr(Count));
    for I := 0 to Count - 1 do
    begin
      if Assigned(Points[I]) then
      try
        Strings.Add(Points[I].AsString)
      except
        Strings.Add('Ошибка в точке ' + IntToStr(I));
      end
      else
        Strings.Add('nil');
    end;
  end;
end;

{ TKisPoint }

function TKisPoint.AsString: String;
begin
  Result := IntToStr(Id) + ';' + Name + ';' + FloatToStr(X) + ';' + FloatToStr(Y);// + '.';  
end;

function TKisPoint.Clone: TKisPoint;
begin
  Result := TKisPoint.Create(fX, fY);
  Result.fX36 := fX36;
  Result.fY36 := fY36;
  Result.fName := fName;
  Result.FId := FId;
  Result.FScreenPt := FScreenPt;
end;

constructor TKisPoint.Create(const aX, aY: Double);
begin
  fX := aX;
  fY := aY;
  ToCK36(fX, fY, fX36, fY36);
end;

function TKisPoint.GetX36: Double;
begin
  //Result := Round(fX36 * 100) / 100;
  Result := fX36;
end;

function TKisPoint.GetY36: Double;
begin
  //Result := Round(fY36 * 100) / 100;
  Result := fY36;
end;

procedure TKisPoint.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TKisPoint.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TKisPoint.SetScreenPt(const Value: TPoint);
begin
  FScreenPt := Value;
end;

procedure TKisPoint.SetX(const Value: Double);
begin
  FX := Value;
  ToCK36(fX, fY, fX36, fY36);
end;

procedure TKisPoint.SetX36(const Value: Double);
begin
  FX36 := Value;
  ToVRN(fX36, fY36, fX, fY);
end;

procedure TKisPoint.SetY(const Value: Double);
begin
  FY := Value;
  ToCK36(fX, fY, fX36, fY36);
end;

procedure TKisPoint.SetY36(const Value: Double);
begin
  FY36 := Value;
  ToVRN(fX36, fY36, fX, fY);
end;

{ TKisExtent }

constructor TKisExtent.Create(aSource: TKisExtent);
begin
  inherited Create;
  FXmin := aSource.FXmin;
  FXmax := aSource.FXmax;
  FYmin := aSource.FYmin;
  FYmax := aSource.FYmax;
end;

constructor TKisExtent.Create(const aXmin, aXmax, aYmin, aYmax: Double);
begin
  inherited Create;
  FXmin := aXmin;
  FXmax := aXmax;
  FYmin := aYmin;
  FYmax := aYmax;
end;

procedure TKisExtent.Join(E: TKisExtent);
begin
  if Assigned(E) then
  begin
    FXmin := Min(FXmin, E.FXmin);
    FXmax := Max(FXmax, E.FXmax);
    FYmin := Min(FYmin, E.FYmin);
    FYmax := Max(FYmax, E.FYmax);
  end;
end;

{ TContours }

function TContours.EnabledCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I].Enabled then
      Inc(Result);
end;

function TContours.GetItems(Index: Integer): TContour;
begin
  Result := inherited Items[Index] as TContour;
end;

procedure TContours.SetItems(Index: Integer; const Value: TContour);
begin
  inherited Items[Index] := Value;
end;

procedure TContours.ToStrings(Strings: TStrings);
var
  I: Integer;
begin
  if Assigned(Strings) then
    for I := 0 to Count - 1 do
    begin
      Strings.Add('Контур ' + IntToStr(I));
      if Assigned(Items[I]) then
      begin
        try
          Items[I].ToStrings(Strings);
        except
          Strings.Add('Ошибка в контуре');
        end;
      end
      else
        Strings.Add('nil');
    end;
end;

end.
