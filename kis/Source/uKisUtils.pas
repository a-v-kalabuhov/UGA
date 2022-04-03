unit uKisUtils;

interface

uses
  SysUtils, Classes, Windows, StdCtrls, DB, Registry, StrUtils, Variants, Math,
  uGC, uCommonUtils,
  uKisConsts, uKisExceptions;

type
  TNumberMask = class
  private
    FPostfix: String;
    FNumberLength: Integer;
    FPrefix: String;
    FText: String;
    procedure Parse;
  public
    constructor Create(const MaskText: String);
    //
    function FormatNumber(const aNumber: String; var WellFormedNumber: String): Boolean;
    //
    property NumberLength: Integer read FNumberLength write FNumberLength;
    property Prefix: String read FPrefix;
    property Postfix: String read FPostfix;
    property Text: String read FText;
  end;

  function BackwardPos(const Substr, Str: String): Integer;
  function CharIsNumber(C: Char): Boolean;
  function StrIsNumberOrLetter(const S: String): Boolean;
  function CheckFIO(const Str: String): Boolean;
  function CheckStrIsFloat(const S: String): Boolean;
  function CheckKAccount(const S, BIK: String): Boolean;
  function CheckRAccount(const S, BIK: String): Boolean;
  function BadName(const Str: String; Strict: Boolean = True): Boolean;
  function BadFirmName(const Str: String; var StartPos, FinPos: Integer): Boolean;
  function GetNextNumber(const LastNumber, Mask: String): String;
  function GetNextNumber2(const LastNumber: String): String;
  function GetPrevNumber2(const LastNumber: String): String;
  function CurrentWindowsUserName: String;
  function CheckINN(const INN: String): Boolean;
  function ComboLocate(Combo: TComboBox; ID: Integer): Boolean;
  function GetBoolText(AField: TField): String;
  function StrDateToParamValue(const StrDate: String): Variant;
  procedure CopyDataSet(Source, Target: TDataSet);
  function IfNull(const Value: Variant; const ResIfNull: Variant): Variant;
  function GetOrgShortName(const OrgName: String; var OrgShortName: String): Boolean;
  function TrimToNumber(S: String): String;

implementation

type
  TOrgForms = array [0..23] of String;

const
  OrgForms: TOrgForms =
    ('ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ',
     'ЗАКРЫТОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО',
     'ОТКРЫТОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО',
     'ПОТРЕБИТЕЛЬСКИЙ АВТОГАРАЖНЫЙ КООПЕРАТИВ',
     'ПРОИЗВОДСТВЕННЫЙ КООПЕРАТИВ',
     'ФИНАНСОВАЯ КОМПАНИЯ',
     'ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ УЧРЕЖДЕНИЕ',
     'МУНИЦИПАЛЬНОЕ УЧРЕЖДЕНИЕ',
     'ВОЙСКОВАЯ ЧАСТЬ',
     'ГАРАЖНО-СТРОИТЕЛЬНЫЙ КООПЕРАТИВ',
     'ГОСУДАРСТВЕННОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ',
     'ГОСУДАРСТВЕННОЕ ПРЕДПРИЯТИЕ',
     'ГОСУДАРСТВЕННОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ',
     'ГОСУДАРKСТВЕННОЕ УЧРЕЖДЕНИЕ КУЛЬТУРЫ',
     'ДАЧНОЕ НЕКОММЕРЧЕСКОЕ ТОВАРИЩЕСТВО',
     'ЖИЛИЩНО-СТРОИТЕЛЬНЫЙ КООПЕРАТИВ',
     'МУНИЦИПАЛЬНОЕ ДОШКОЛЬНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ',
     'МУНИЦИПАЛЬНОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ',
     'НЕГОСУДАРСТВЕННОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ',
     'ПОТРЕБИТЕЛЬСКИЙ ГАРАЖНО-ЭКСПЛУАТАЦИОННЫЙ КООПЕРАТИВ',
     'ПОТРЕБИТЕЛЬСКИЙ ЖИЛИЩНО-СТРОИТЕЛЬНЫЙ КООПЕРАТИВ',
     'ПОТРЕБИТЕЛЬСКИЙ КООПЕРАТИВ',
     'ТОВАРИЩЕСТВО СОБСТВЕННИКОВ ЖИЛЬЯ',
     'ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ'
    );
    
    ShortOrgForms: TOrgForms =
    ('ООО',
     'ЗАО',
     'ОАО',
     'ПАГК',
     'ПК',
     'ФК',
     'ФГУ',
     'МУ',
     'в/ч',
     'ГСК',
     'ГУЗ',
     'ГП',
     'ГОУ',
     'ГУК',
     'ДНТ',
     'ЖСК',
     'МДОУ',
     'МУП',
     'НОУ',
     'ПГЭК',
     'ПЖСК',
     'ПК',
     'ТСЖ',
     'ФГУП'
    );

function BackwardPos(const Substr, Str: String): Integer;
var
  I, C: Integer;
  S: String;
begin
  Result := -1;
  I := Length(Str);
  C := Length(Substr);
  while (I >= C) and (Result < 0) do
  begin
    S := Copy(Str, I + 1 - C, C);
    if S = Substr then
      Result := I + 1 - C
    else
      Dec(I);
  end;
end;

function GetOrgShortName(const OrgName: String; var OrgShortName: String): Boolean;
var
  I: Integer;
begin
  OrgShortName := Trim(OrgName);
  for I := 0 to Pred(Length(OrgForms)) do
  begin
    OrgShortName := StringReplace(
      OrgShortName,
      OrgForms[I],
      ShortOrgForms[I],
      [rfReplaceAll, rfIgnoreCase]);
    if Pos(ShortOrgForms[I] + ' ', OrgShortName) = 1 then
      OrgShortName := Trim(
        Copy(OrgShortName, Length(ShortOrgForms[I] + ' '),
        Length(OrgShortName)) + ' ' + ShortOrgForms[I]);
  end;
  OrgShortName := StringReplace(OrgShortName, '"', '', [rfReplaceAll]);
  Result := OrgShortName <> OrgName;
end;

function ControlSumINN(N: Integer; const INN: String): Integer;
var
  S, I: integer;
  CheckSum: array [1..11] of Integer;
begin
  S := 0;
  CheckSum[1] := 3;
  CheckSum[2] := 7;
  CheckSum[3] := 2;
  CheckSum[4] := 4;
  CheckSum[5] := 10;
  CheckSum[6] := 3;
  CheckSum[7] := 5;
  CheckSum[8] := 9;
  CheckSum[9] := 4;
  CheckSum[10]:= 6;
  CheckSum[11]:= 8;
  for I := 1 to Pred(N) do
    S := S + (StrToInt(INN[I]) * CheckSum[12 - N + I]);
  Result := S mod 11 mod 10;
end;

function CheckINN(const INN: String): Boolean;
var
  L: Integer;
begin
  L := Length(INN);
  if L in [10, 11, 12] then
    Result := StrToInt(INN[L]) = ControlSumINN(L, INN)
  else
    Result := False;
end;

function CharIsNumber(C: Char): Boolean;
begin
  Result := C in NumberChars;
end;

function StrIsNumberOrLetter(const S: String): Boolean;
var
  I: Integer;
begin
  Result := Length(S) > 0;
  if Result then
    for I := 1 to Length(S) do
    if not ((S[I] in NumberChars) or (Ord(S[I]) > 32)) then
    begin
      Result := False;
      Exit;
    end
end;

function CheckFIO(const Str: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(Str) do
  if not (Str[I] in ['А'..'Я', 'а'..'я', #32, '.', '-']) then
    Exit;
  if (Pos('--', Str) > 0)
     or (Pos('..', Str) > 0)
     or (Pos('.-', Str) > 0)
     or (Pos('-.', Str) > 0) then
    Exit;
  Result := True;
end;

function CheckStrIsFloat(const S: String): Boolean;
begin
  try
    StrToFloat(S);
    Result := True;
  except
    Result := False;
  end;
end;

function CheckINN12(const INN: String): Boolean;
begin
  Result := False;
end;

function CheckINN10(const INN: String): Boolean;
var
  NomSimv, ZnSimv, ItSimv, ContrSimv, ItogSimv, ContrCislo: Integer;
begin
  if Length(INN) <> 10 then
  begin
    Result := False;
    Exit;
  end;
	NomSimv := 1;
//	ZnSimv := 0;
	ItSimv := 0;
  ItogSimv := 0;
  COntrSimv := 0;
	while NomSimv < 11 do
  begin
		ZnSimv := StrToInt(INN[NomSimv]);
		case NomSimv of
    1 :
			ItSimv := ZnSimv * 2;
		2 :
			ItSimv := ZnSimv * 4;
		3 :
			ItSimv := ZnSimv * 10;
		4 :
			ItSimv := ZnSimv * 3;
		5 :
			ItSimv := ZnSimv * 5;
		6 :
			ItSimv := ZnSimv * 9;
		7 :
			ItSimv := ZnSimv * 4;
		8 :
			ItSimv := ZnSimv * 6;
		9 :
			ItSimv := ZnSimv * 8;
		10 :
      begin
        ItSimv := 0;
        ContrSimv := ZnSimv;
      end;
    end;
		ItogSimv := ItogSimv + ItSimv;
		Inc(NomSimv);
	end;
	ContrCislo := ItogSimv - (Trunc(ItogSimv/11) * 11);
	if ContrCislo > 10 then
	    ContrCislo := ContrCislo mod 10;
	Result := ContrCislo = ContrSimv;
end;

function CheckINN10_v1(const INN: String): Boolean;
const
  Coeffs: array[1..9] of Byte = (2, 4, 10, 3, 5, 9, 4, 6, 8);
var
  I, Sum: Integer;
//  NomSimv, ZnSimv, ItSimv, ContrSimv, ItogSimv, ContrCislo: Integer;
begin
  Sum := 0;
  for I := 1 to 9 do
    Inc(Sum, StrToInt(INN[I]) * Coeffs[I]);
  I := Sum mod 11;
  if I > 10 then
    I := I mod 10;
  Result := I = StrToInt(INN[10]);
end;

function CheckINN_old(const INN: String): Boolean;
const
  Coeff1: array [0..8]  of Byte = (2, 4, 10, 3, 5, 9, 4, 6, 8);
  Coeff2: array [0..9]  of Byte = (7, 2, 4, 10, 3, 5, 9, 4, 6, 8);
  Coeff3: array [0..10] of Byte = (3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8);
var
  I: Byte;
  N1, N2: Word;
begin
  Result := StrIsNumber(INN);
  if Result then
    case Length(INN) of
    10 :
      begin
        N1 := 0;
        for I := 0 to 8 do
          Inc(N1, StrToInt(INN[Succ(I)]) * Coeff1[I]);
        N1 := N1 mod 11;
        N1 := N1 mod 10;
        Result := StrToInt(INN[10]) = N1;
      end;
    12 :
      begin
        N1 := 0;
        for I := 0 to 9 do
          Inc(N1, StrToInt(INN[Succ(I)]) * Coeff2[I]);
        N1 := (N1 mod 11) mod 10;
        N2 := 0;
        for I := 0 to 10 do
          Inc(N2, StrToInt(INN[Succ(I)]) * Coeff3[I]);
        N2 := N2 mod 11;
        N2 := N2 mod 10;
        Result := (StrToInt(INN[11]) = N1) and (StrToInt(INN[12]) = N2);
      end;
    end; // case
end;

function CheckAccountNumber(const S: String): Boolean;
const
  Coeffs: array [1..23] of Byte =
    (7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1, 3, 7, 1);
var
  I, Summa: Integer;
begin
 Result := StrIsNumber(S);
 if Result then
 begin
   Summa := 0;
   for I := 1 to 23 do
     Summa := Summa + (StrToInt(S[I]) * Coeffs[I]) mod 10;
   Result := (Summa mod 10) = 0;
 end;
end;

function CheckKAccount(const S, BIK: String): Boolean;
begin
  Result := (Length(S) = 20) and CheckAccountNumber('0' + Copy(BIK, 5, 2) + S);
end;

function CheckRAccount(const S, BIK: String): Boolean;
begin
  Result := (Length(S) = 20)
    and CheckAccountNumber(Copy(BIK, Length(BIK) - 2, 3) + S);
end;

function BadName(const Str: String; Strict: Boolean = True): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(Str) do
    if Strict then
    begin
      if Str[I] in NoNameChars then Exit
    end
    else
      if Str[I] in SmallNoNameChars then Exit;
  for I := 0 to High(Byte) do
    if Chr(I) in NoNameChars then
    if Pos(Chr(I) + Chr(I), Str) > 0 then
      Exit;
  Result := False;
end;

function BadFirmName(const Str: String; var StartPos, FinPos: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  StartPos := 0;
  FinPos := 0;
  for I := 1 to Pred(Length(Str)) do
    if (Str[I] in NoNameChars) and (Str[Succ(I)] in NoNameChars) then
    begin
      StartPos := I;
      FinPos := Succ(I);
      Exit;
    end;
  Result := False;
end;

function GetNextNumber(const LastNumber, Mask: String): String;
var
  Start, Fin, K, KK: Integer;
  S, SS: String;
begin
  // ищем положение числа для увеличения в номере
  Start := Pos('!(', Mask);
  if Start < 0 then
    raise Exception.Create(S_INVALID_MASK);
  Fin := PosEx(')', Mask, Start);
  if Fin < 0 then
    raise Exception.Create(S_INVALID_MASK);
  S := Copy(Mask, Start + 2, Fin - Start - 2);
  try
    K := StrToInt(S);
  except
    raise Exception.Create(S_INVALID_MASK);
  end;
  KK := K;
  if Trim(LastNumber) = '' then
    K := 0
  else
  try
    K := StrToInt(Copy(LastNumber, Start, KK));
  except
    begin
      KK := KK - 1;
      try
        K := StrToInt(Copy(LastNumber, Start, KK));
      except
        begin
          KK := KK - 1;
          try
            K := StrToInt(Copy(LastNumber, Start, KK));
          except
            //raise Exception.Create(S_INVALID_MASK);
            K := 1;
          end;
        end;
      end;
    end;
  end;
  Inc(K);
  SS := IntToStr(KK);
  Result := StringReplace(Mask, '!(' + S + ')', Format('%' + SS + '.' + SS + 'd', [K]), []);
//  if Result = '' then Result := '1';
end;

function GetNextNumber2(const LastNumber: String): String;
var
  Nstart, Nend: Integer;
  I, N: Integer;
  Parts: TStringList;
  Num: TObject;
begin
  // ищем часть с буквами
  // ищем часть с цифрами
  Parts := TStringList.Create;
  Parts.Forget;
  Nstart := 0;
  Nend := 0;
  Result := LastNumber;
  I := Length(Result);
  while (I > 0) do
  begin
    if Nend = 0 then
    begin
      if Result[I] in ['0'..'9'] then
        Nend := I;
    end
    else
    if Nstart = 0 then
    begin
      if not (Result[I] in ['0'..'9']) then
        Nstart := I;
    end;
    Dec(I);
  end;
  //
  if Nend = 0 then
  begin
    Parts.AddObject(Result, TObject(False));
    Parts.AddObject('0', TObject(True));
  end
  else
  begin
    if Nstart = 0 then
    begin
      Parts.AddObject(Copy(Result, 1, Nend), TObject(True));
    end
    else
    begin
      Parts.AddObject(Copy(Result, 1, Nstart), TObject(False));
      Parts.AddObject(Copy(Result, Nstart + 1, Nend - Nstart), TObject(True));
    end;
    if Nend < Length(Result) then
      Parts.AddObject(Copy(Result, Nend + 1, Length(Result) - Nend), TObject(False));
  end;
  for I := 0 to Parts.Count - 1 do
  begin
    Num := Parts.Objects[I];
    if Boolean(Num) then
    begin
      Parts[I] := IntToStr(Succ(StrToInt(Parts[I])));
    end;
  end;
  Result := '';
  for I := 0 to Parts.Count - 1 do
  begin
    Result := Result + Parts[I];
  end;
  Exit;
  N := 0;
  Result := LastNumber;
  I := Length(LastNumber);
  while (I > 0) and (LastNumber[I] in ['0'..'9']) do
    Dec(I);
  if I < Length(LastNumber) then
  begin
    N := StrToInt(Copy(LastNumber, Succ(I), Length(LastNumber) - I));
    SetLength(Result, I);
  end;
  Inc(N);
  Result := Result + IntToStr(N);
end;

function GetPrevNumber2(const LastNumber: String): String;
var
  Nstart, Nend: Integer;
  I, N: Integer;
  Parts: TStringList;
  Num: TObject;
begin
  // ищем часть с буквами
  // ищем часть с цифрами
  Parts := TStringList.Create;
  Parts.Forget;
  Nstart := 0;
  Nend := 0;
  Result := LastNumber;
  I := Length(Result);
  while (I > 0) do
  begin
    if Nend = 0 then
    begin
      if Result[I] in ['0'..'9'] then
        Nend := I;
    end
    else
    if Nstart = 0 then
    begin
      if not (Result[I] in ['0'..'9']) then
        Nstart := I;
    end;
    Dec(I);
  end;
  //
  if Nend = 0 then
  begin
    Parts.AddObject(Result, TObject(False));
    Parts.AddObject('0', TObject(True));
  end
  else
  begin
    if Nstart = 0 then
    begin
      Parts.AddObject(Copy(Result, 1, Nend), TObject(True));
    end
    else
    begin
      Parts.AddObject(Copy(Result, 1, Nstart), TObject(False));
      Parts.AddObject(Copy(Result, Nstart + 1, Nend - Nstart), TObject(True));
    end;
    if Nend < Length(Result) then
      Parts.AddObject(Copy(Result, Nend + 1, Length(Result) - Nend), TObject(False));
  end;
  for I := 0 to Parts.Count - 1 do
  begin
    Num := Parts.Objects[I];
    if Boolean(Num) then
    begin
      N := StrToInt(Parts[I]);
      if N > 1 then
        Parts[I] := IntToStr(N - 1);
    end;
  end;
  Result := '';
  for I := 0 to Parts.Count - 1 do
    Result := Result + Parts[I];
end;

function CurrentWindowsUserName: String;
begin
  Result := '';
  with IObject(TRegistry.Create).AObject as TRegistry do
  begin
    RootKey := Windows.HKEY_CURRENT_USER;
    if OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer', True) then
    begin
      Result := ReadString('Logon User Name');
      CloseKey;
    end;
  end;
end;

function ComboLocate(Combo: TComboBox; ID: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Pred(Combo.Items.Count) do
    if Integer(Combo.Items.Objects[I]) = ID then
    begin
      Combo.ItemIndex := I;
      Result := True;
      Exit;
    end;
end;

function GetBoolText(AField: TField): String;
begin
  if AField.AsInteger = 1 then
    Result := 'Да'
  else
    Result := 'Нет';
end;

function StrDateToParamValue(const StrDate: String): Variant;
begin
  if Trim(StrDate) <> '' then
    Result := StrToDate(StrDate)
  else
    Result := NULL;
end;

procedure CopyDataSet(Source, Target: TDataSet);
var
  I: Integer;
begin
  Source.First;
  while not Source.Eof do
  begin
    Target.Append;
    for I := 0 to Pred(Target.FieldCount) do
      Target.Fields[I].Value := Source.Fields[I].Value;
    Target.Post;
    Source.Next;
  end;
end;

function IfNull(const Value: Variant; const ResIfNull: Variant): Variant;
begin
  if VarIsNull(Value) or VarIsEmpty(Value) then
    Result := ResIfNull
  else
    Result := Value;
end;

{ TNumberMask }

constructor TNumberMask.Create(const MaskText: String);
begin
  FText := MaskText;
  Parse;
end;

function TNumberMask.FormatNumber(const aNumber: String;
  var WellFormedNumber: String): Boolean;
var
  S, L: String;
  N: Integer;
  Error: Boolean;
begin
  Result := False;
  S := Trim(aNumber);
  if (FPrefix <> '') and StartsStr(FPrefix, S) then
    Delete(S, 1, Length(FPrefix));
  if (FPostfix <> '') and EndsStr(FPostfix, S) then
    SetLength(S, Length(S) - Length(FPostfix));
  S := Trim(S);
  Error := True;
  if S <> '' then
  if TryStrToInt(S, N) then
  begin
    L := IntToStr(FNumberLength);
    S := '%' + L + '.' + L + 'd';
    WellFormedNumber := Prefix + Format(S, [N]) + Postfix;
    Result := True;
    Error := False;
  end;
  if Error then
    raise EKisExtException.Create('Неверный формат номера письма!', 'Номер: [' + aNumber + ']');
end;

procedure TNumberMask.Parse;
var
  Start, Fin: Integer;
  S: String;
begin
  // ищем положение числа для увеличения в номере
  Start := Pos('!(', FText);
  if Start < 0 then
    raise Exception.Create(S_INVALID_MASK);
  Fin := PosEx(')', FText, Start);
  if Fin < 0 then
    raise Exception.Create(S_INVALID_MASK);
  S := Copy(FText, Start + 2, Fin - Start - 2);
  if not TryStrToInt(S, FNumberLength) then
    raise Exception.Create(S_INVALID_MASK);
  FPrefix := Copy(FText, 1, Start - 1);
  FPostfix := Copy(FText, Fin + 1, Length(FText) - Fin);
end;

function TrimToNumber(S: string): string;
var
  NumFound: Boolean;
  I: Integer;
begin
  Result := '';
  NumFound := False;
  I := 1;
  while I <= Length(S) do
  begin
    if NumFound then
    begin
      if CharIsNumber(S[I]) then
        Result := Result + S[I]
      else
        if S[I] in ['.', ','] then
          Result := Result + S[I]
        else
          Break;
    end
    else
    begin
      if CharIsNumber(S[I]) or (S[I] = '-') then
      begin
        NumFound := True;
        Result := Result + S[I];
      end;
    end;
    Inc(I);
  end;
end;

end.
