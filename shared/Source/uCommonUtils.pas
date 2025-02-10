{*******************************************************}
{                                                       }
{                                                       }
{       Common Utilities Unit                           }
{                                                       }
{       Copyright (c) 2002-2004, Калабухов А.В.         }
{                                                       }
{       Автор: Калабухов А.В.                           }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Common Utilities
  Версия: 1.1
  Дата последнего изменения: 20.07.2004
  Цель: содержит различные полезные утилиты.
  Используется: ох-ох-ох :)
  Использует: только системные юниты
  Исключения: нет }

unit uCommonUtils;

interface

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

uses
  // System - ONLY!!!! This is COMMON unit!!!
  SysUtils, Classes, Types, Windows, Graphics, ComCtrls, Contnrs, ComObj,
  Math, Printers, WinSock, StrUtils, Registry,
  uGC;

type
  TNumberChars = set of Char;
  
const
// ???. Если не понадобится убрать
{  GeoChars = ['.', 'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З', 'И', 'К', 'Л', 'М', 'Н', 'О',
              'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Э', 'Ю', 'Я'];}
  GeoStr = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ';
  DB_BOOL_TRUE = 1;
  DB_BOOL_FALSE = 0;
  NumberChars: TNumberChars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

type
  TLayout = (loRus, loEng);

  TObjectMethod = procedure of object;

  function WithSelf(const MethodPointer: TObjectMethod): TObject;
  procedure FreeList(List: TList); overload;
  procedure FreeList(List: TStringList); overload;
  // Строки
  function ArabianToLatin(Number: Integer): string;
  function IncludeDigits(const S: String): Boolean;
  function OnlySpaces(const S: String): Boolean;
  function StrIsNumber(const S: String): Boolean; overload;
  function StrIsNumber(const S: String; var Number: Int64): Boolean; overload;
  // Математика
  function Between(const X, XMin, XMax: Double; WithLimits: Boolean = True): Boolean;
  function LatinToArabian(const Latin: String): Integer;
  function RoundX(const X: Double; DigitsAfterDot: Integer): Double;
  // Файлы
  // TODO : перенести в uFileUtils
  function Bytes2File(const FileName: String; const Bytes: TByteDynArray): Boolean; 
  function File2Bytes(const FileName: String; var Bytes: TByteDynArray): Boolean; overload;
  function File2Bytes(const FileName: String): TByteDynArray; overload;
  function CheckDir(Dir: String): Boolean;
  procedure DeleteFiles(const Path: String; const Mask: String = '*.*');
  function AddDelimiter(const Path: String): String;
  function DirUp(const Path: String): String;
  function GetVersionInfo(const FileName: String): String;
  // Система
  procedure Run(const Exe: String);
  function ExecAndWait(const ExeName, Params: string; Hide: Boolean; out ExitCode: Cardinal; Timeout: Cardinal = MaxInt): Boolean;
  procedure SetLayout(pLayout: TLayout);
  function GetPrinterPhisHorizOffset: Integer; // физический отступ в пикселях
  function GetPrinterPhisVertOffset: Integer; // физический отступ в пикселях
  procedure RotatedTextOut(Handle: HDC; StartPoint: TPoint; Angle: Integer; const Text: String);
  function GetIP: String;
  // TODO : перенести в uFileUtils
  function TempDir: String;
  function LocalTemp: String;
  function SystemDir: String;
  // Функции для ГИС
  function Azimuth(X1, Y1, X2, Y2: Double): Double;
  function Radius(x, y: Double): Double;
  function PointInRect(const Point: Windows.TPoint; const Rect: Windows.TRect): Boolean;
  function RectInRect(const Rect1, Rect2: Windows.TRect): Boolean;
  function WorldFontHeight500(fnt: TFont): Double;
  function ScreenFontHeight500(H: Double; PixelsPerInch: Integer): Integer;
  // Разное
  function IfElse(B: Boolean; Res1, Res2: Variant): Variant; overload;
  function IfElse(B: Boolean; Res1, Res2: TObject): TObject; overload;
  function GetDegreeCorner(Corner: Double; Minutes: Boolean = True): String;
  // RichEdit
  procedure ReplaceText(RichEdit: TRichEdit; const OldText, NewText: String);
  //
  function GetUniqueString(RemoveDash: Boolean = True; RemoveBrackets: Boolean = True): String;
  function ColorToHex(Color: TColor): string;
  function HexToColor(Hex: string): TColor;

type
  TGetValueFunc = function (Item: Pointer): Boolean of object;
  TCompareValueFunc = function (Item: Pointer): Integer of object;

  function DoBinarySearch(aList: TList; CheckValue: TGetValueFunc; CompareValue: TCompareValueFunc): Integer;

implementation

function DoBinarySearch(aList: TList; CheckValue: TGetValueFunc; CompareValue: TCompareValueFunc): Integer;
var
  nLow: Integer;
  nHigh: Integer;
  nCheckPos: Integer;
  Found: Boolean;
  CompareResult: Integer;
begin
  Result := -1;
  if aList.Count = 1 then
  begin
    Found := CheckValue(aList[0]);
    if Found then
      Result := 0;
    Exit;
  end;
  //
  nLow := 0;
  nHigh := Pred(aList.Count);
  // keep searching until found or
  // no more items to search
  while nLow <= nHigh do
  begin
     nCheckPos := (nLow + nHigh) div 2;
     CompareResult := CompareValue(aList[nCheckPos]);
     if CompareResult < 0 then  // less than
       nLow := Succ(nCheckPos)
     else
     if CompareResult > 0 then  // greater than
       nHigh := Pred(nCheckPos)
     else                       // equal to
     begin
       Result := nCheckPos;
       Exit;
     end;
  end;
end;

function ArabianToLatin(Number: Integer): String;
var
  S: array[1..7] of Char;
  N: array[1..7] of Integer;
  I, D: Integer;
{
procedure Int(const I, D: Integer);
begin
  if (Number div (N[I] - N[I - D])) > 0 then
  begin
    Result := Result + S[I-D] + S[I];
    Number := Number mod (N[I] - N[I - D]);
  end;
end;
}
begin
  Result := '';
  S[1] := 'I';
  S[2] := 'V';
  S[3] := 'X';
  S[4] := 'L';
  S[5] := 'C';
  S[6] := 'D';
  S[7] := 'M';
  N[1] := 1;
  N[2] := 5;
  N[3] := 10;
  N[4] := 50;
  N[5] := 100;
  N[6] := 500;
  N[7] := 1000;
  for I := 7 downto 1 do
  begin
    Result := Result + DupeString(S[I], Number div N[I]);
    Number := Number mod N[I];
    if I > 1 then
    begin
      if Odd(I) then
        D := 2
      else
        D := 1;
      if (Number div (N[I] - N[I - D])) > 0 then
      begin
        Result := Result + S[I - D] + S[I];
        Number := Number mod (N[I] - N[I - D]);
      end;
    end;
{    case I of
      2: Int(I, 1);
      3: Int(I, 2);
      4: Int(I, 1);
      5: Int(I, 2);
      6: Int(I, 1);
      7: Int(I, 2);
    end;  }
  end;
end;

function Between(const X, XMin, XMax: Double; WithLimits: Boolean = True): Boolean;
var
  D1, D2: Double;
begin
  D1 := Min(XMin, XMax);
  D2 := Max(XMin, XMax);
  if withlimits then
    Result :=((X >= D1) and (X <= D2))
  else
    Result := (X > D1) and (X < D2);
end;

procedure FreeList(List: TList);
var
  I, C: Integer;
begin
  C := Pred(List.Count);
  for I := 0 to C do
  begin
    TObject(List[I]).Free;
  end;
  FreeAndNil(List);
end;

procedure FreeList(List: TStringList);
var
  I, C: Integer;
begin
  C := Pred(List.Count);
  for I := 0 to C do
  begin
    List.Objects[I].Free;
  end;
  FreeAndNil(List);
end;

function Bytes2File(const FileName: String; const Bytes: TByteDynArray): Boolean;
begin
  with TFileStream.Create(FileName, fmCreate) do
  begin
    try
      Write(Bytes[0], Length(Bytes));
      Result := True;
    except
      Result := False;
    end;
    Free;
  end;
end;

function File2Bytes(const FileName: String; var Bytes: TByteDynArray): Boolean;
begin
  Result := FileExists(Filename);
  if Result then
    with IObject(TFileStream.Create(FileName, fmOpenRead)).AObject as TStream do
    try
      SetLength(Bytes, Size);
      Read(Bytes[0], Size);
      Result := True;
    except
      Result := False;
    end;
end;

function File2Bytes(const filename: String): TByteDynArray;
begin
  with TFileStream.Create(FileName, fmOpenRead) do
  try
    SetLength(Result, Size);
    Read(Result[0], Size);
  finally
    Free;
  end;
end;

procedure Run(const Exe: String);
var
  ErrStr: String;
  App: PChar;
begin
  try
    App := PChar(Exe);
    WinExec(app, SW_SHOWNORMAL);
  except
    ErrStr := 'Невозможно запустить ' + Exe;
    MessageBox(0, PChar(ErrStr), PChar('Внимание!'), MB_OK);
  end;
end;

function ExecAndWait(const ExeName, Params: string; Hide: Boolean; out ExitCode: Cardinal; Timeout: Cardinal = MaxInt): Boolean;
var
  sui: TStartupInfo;
  pi: TProcessInformation;
begin
  ZeroMemory(@sui, SizeOf(sui));
  sui.cb := SizeOf(sui);
  sui.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
  if Hide then
    sui.wShowWindow := SW_HIDE
  else
    sui.wShowWindow := SW_SHOWNORMAL;
  Win32Check(CreateProcess(PChar(ExeName), PChar(Params), nil, nil, False, 0, nil, nil, sui, pi));
  try
    CloseHandle(pi.hThread);
    Result := WaitForSingleObject(pi.hProcess, Timeout) = WAIT_OBJECT_0;
    if Result then
      Win32Check(GetExitCodeProcess(pi.hProcess, ExitCode));
  finally
    CloseHandle(pi.hProcess);
  end;
end;

procedure SetLayout(pLayout: TLayout);
var
  Layout: array[0..KL_NAMELENGTH] of Char;
begin
  case pLayout of
    loRus  :  LoadKeyboardLayout(StrCopy(Layout, '00000419'), KLF_ACTIVATE);
    loEng  :  LoadKeyboardLayout(StrCopy(Layout, '00000409'), KLF_ACTIVATE);
  end;
end;

function LatinToArabian(const Latin: String): Integer;
var
  I, L1, L2, Last: Integer;

  function GetNumber(const A: Char): Integer;
  begin
    case A of
    'X' : Result := 10;
    'I' : Result := 1;
    'V' : Result := 5;
    else  Result := 0;
    end;
  end;

begin
  Result := 0;
  Last := 0;
  L2 := 0;
  case Length(Latin) of
  0 : Exit;
  1 : Result := GetNumber(Latin[1]);
  else
      begin
        I := 2;
        while I <= Length(Latin) do
        begin
          L1 := GetNumber(Latin[Pred(I)]);
          L2 := GetNumber(Latin[I]);
          if L2 > L1 then
          begin
            Dec(L2, L1);
            Inc(Result, L2);
            Last := I;
            Inc(I, 2);
          end
          else
          begin
            Inc(Result, L1);
            Last := Pred(I);
            Inc(I);
          end;
        end;
        if Last < Length(Latin) then
          Inc(Result, L2);
      end;
  end;
end;

function IncludeDigits(const S: String): Boolean;
var
  C: Char;
begin
  Result := False;
  C := '1';
  while not Result and (C < '9') do
  begin
    Result := Pos(C, S) > 0;
    Inc(Byte(C));
  end;
end;

function OnlySpaces(const S: String): Boolean;
begin
  Result := Trim(S) = '';
end;

function IfElse(B: Boolean; Res1, Res2: Variant): Variant;
begin
  if B then
    Result := Res1
  else
    Result := Res2;
end;

function IfElse(B: Boolean; Res1, Res2: TObject): TObject;
begin
  if B then
    Result := Res1
  else
    Result := Res2;
end;

function GetDegreeCorner(Corner: Double; Minutes: Boolean = True): String;
begin
  Corner := RadToDeg(Corner);
  if Minutes then
    Result := Format('%3d° %3.1f' + #39, [Trunc(Corner), 60 * Frac(Corner)])
  else
    Result := Format('%6.2f°', [Corner]);
end;

function GetPrinterPhisHorizOffset: Integer;
begin
  Result := Round(
            GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX) /
            GetDeviceCaps(Printer.Handle, PHYSICALWIDTH) *
            GetDeviceCaps(Printer.Handle, HORZRES));
end;

function GetPrinterPhisVertOffset: Integer;
begin
  Result := Round(
            GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY) /
            GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT) *
            GetDeviceCaps(Printer.Handle, VERTRES));
end;

function CheckDir(Dir: String): Boolean;
var
  S: String;
  I: Integer;
begin
  Result := DirectoryExists(Dir);
  if not Result then
  begin
    S := '';
    I := Pos('\', Dir);
    while I > 0 do
    begin
      S := S + Copy(Dir, 1, I);
      Delete(Dir, 1, I);
      I := Pos('\', Dir);
      if DirectoryExists(S) then
        Result := True
      else
        Result := CreateDir(S);
      if not Result then
        Exit;
    end;
  end;
end;

function Radius(x, y: Double): Double;
begin
  result := sqrt(sqr(x) + sqr(y));
end;

function Azimuth(X1, Y1, X2, Y2: Double): Double;
begin
  if X2 = X1 then
    if Y2 >= Y1 then Result := Pi / 2 else Result := - Pi / 2
  else
    Result := ArcTan( (Y2 - Y1) / (X2 - X1) );
  if X2 >= X1 then
  begin
    if Y2 < Y1 then
      Result := Result + 2 * Pi
  end
  else
    Result := Result + Pi;
end;

procedure DeleteFiles(const Path: String; const Mask: String = '*.*');
var
  I: Integer;
  SR: TSearchRec;
begin
  // Удаляем временные файлы
  I := FindFirst(Path + Mask, faAnyFile, SR);
  try
    while I = 0 do
    begin
      if (SR.Name <> '.') and (SR.Name <> '..') then
        if not SysUtils.DeleteFile(Path + SR.Name) then
        begin
          OutputDebugString(PChar(Path + SR.Name));
        end;
      I := FindNext(SR);
    end;
  finally
    SysUtils.FindClose(SR);
  end;
end;

function GetIP: String;
var
  WSAData : TWSAData;
  p : PHostEnt;
  Name : array [0..$FF] of Char;
begin
  WSAStartup($0101, WSAData);
  GetHostName(name, $FF);
  p := GetHostByName(Name);
  result := inet_ntoa(PInAddr(p.h_addr_list^)^);
  WSACleanup;
end;

function RoundX(const X: Double; DigitsAfterDot: Integer): Double;
var
  LFactor, D1, D2: Extended;
  X1, X2, I: Integer;
begin
{  LFactor := IntPower(10, DigitsAfterDot);
  D1 := X * LFactor;
  I := Trunc(D1);
  X1 := I * 10; // менее точное
  D2 := X * LFactor * 10;
  X2 := Trunc(D2); // более точное
  if (X2 - X1) > 4 then
    Inc(I);
  Result := I / LFactor;}
  LFactor := IntPower(10, DigitsAfterDot);
  D1 := X * LFactor;
  I := Round(D1);
  X1 := I * 10; // менее точное
  D2 := X * LFactor * 10;
  X2 := Round(D2); // более точное
  if (X2 - X1) > 4 then
    Inc(I);
  Result := I / LFactor;
//  Result := Round(X * LFactor) / LFactor;
end;

function WorldFontHeight500(fnt: TFont): Double;
begin
  with fnt do
    result := Abs(Height) / PixelsPerInch / 2.54 * 30;
end;

function ScreenFontHeight500(H: Double; PixelsPerInch: Integer): Integer;
begin
  Result := - Trunc(H * PixelsPerInch * 2.54 / 30);
end;

procedure RotatedTextOut(Handle: HDC; StartPoint: TPoint;
  Angle: Integer; const Text: String);
var
  CurFnt, Fnt, OldFnt: HFONT;
  LFnt: LOGFONT;
begin
  CurFnt := GetCurrentObject(Handle, OBJ_FONT);
  if GetObject(CurFnt, SizeOf(LFnt), @LFnt) = 0 then
    raise EAbort.Create('Font Error!');
  LFnt.lfCharSet := RUSSIAN_CHARSET;
  LFnt.lfEscapement := Angle * 10;
  Fnt := CreateFontIndirect(LFnt);
  OldFnt := SelectObject(Handle, Fnt);
  SetBkMode(Handle, Windows.TRANSPARENT);
  TextOut(Handle, StartPoint.X, StartPoint.Y, PChar(Text), Length(Text));
  SelectObject(Handle, OldFnt);
end;

function PointInRect(const Point: Windows.TPoint;
  const Rect: Windows.TRect): Boolean;
begin
  Result := ((Point.X > Rect.Left) and (Point.X < Rect.Right)) and
            ((Point.Y > Rect.Top) and (Point.Y < Rect.Bottom));
end;

function RectInRect(const Rect1, Rect2: Windows.TRect): Boolean;
begin
  Result := (Rect1.Left >= Rect2.Left) and
            (Rect1.Top >= Rect2.Top) and
            (Rect1.Right <= Rect2.Right) and
            (Rect1.Bottom <= Rect2.Bottom);
end;

procedure ReplaceText(RichEdit: TRichEdit; const OldText, NewText: String);
var
  StartPos, I: Integer;
begin
  StartPos := 0;
  I := RichEdit.FindText(OldText, StartPos, -1, []);
  while I >= 0 do
  begin
    RichEdit.SelStart := I;
    RichEdit.SelLength := Length(OldText);
    RichEdit.SelText := NewText;
    I := RichEdit.FindText(OldText, StartPos, -1, []);
  end;
end;

function AddDelimiter(const Path: String): String;
begin
  if Path[Length(Path)] <> PathDelim then
    Result := Path + PathDelim;
end;

function DirUp(const Path: String): String;
var
  I, L: Integer;
begin
  if Path[Length(Path)] = PathDelim then
    L := Pred(Length(Path))
  else
    L := Length(Path);
  for I := L downto 1 do
  if Path[I] = PathDelim then
  begin
    Result := Copy(Path, 1, I);
    BREAK;
  end;
end;

function TempDir: String;
var
  Buff: PAnsiChar;
begin
  GetMem(Buff, 256);
  Windows.GetTempPath(256, Buff);
  Result := Buff;
  FreeMem(Buff, 256);
end;

function LocalTemp: String;
begin
  with TRegistry.Create do
  try
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\', False);
    Result := ReadString('Local Settings') + '\Temp\';
  finally
    Free;
  end;
end;

function SystemDir: String;
var
  Buffer: PAnsiChar;
begin
  Buffer := StrAlloc(255);
  try
    GetSystemDirectory(Buffer, 255);
    SystemDir := StrPas(Buffer) ;
  finally
    StrDispose(Buffer);
  end;
end;

function ColorToHex(Color: TColor): string;
begin
  Result :=
    IntToHex(GetRValue(Color), 2) +
    IntToHex(GetGValue(Color), 2) +
    IntToHex(GetBValue(Color), 2) ;
end;

function HexToColor(Hex: string): TColor;
begin
  Result :=
      RGB(
        StrToInt('$'+Copy(Hex, 1, 2)),
        StrToInt('$'+Copy(Hex, 3, 2)),
        StrToInt('$'+Copy(Hex, 5, 2))
      ) ;
end;

function WithSelf(const MethodPointer: TObjectMethod): TObject; register;
{begin
  Result := TMethod(MethodPointer).Data;}
asm
end;

const
  TOKEN_ASSIGN_PRIMARY = $1;
  TOKEN_DUPLICATE = $2;
  TOKEN_IMPERSONATE = $4;
  TOKEN_QUERY = $8;
  TOKEN_QUERY_SOURCE = $10;
  TOKEN_ADJUST_PRIVILEGES = $20;
  TOKEN_ADJUST_GROUPS = $40;
  TOKEN_ADJUST_DEFAULT = $80;
  SECURITY_DIALUP_RID = $1;
  SECURITY_NETWORK_RID = $2;
  SECURITY_BATCH_RID = $3;
  SECURITY_INTERACTIVE_RID = $4;
  SECURITY_SERVICE_RID = $6;
  SECURITY_ANONYMOUS_LOGON_RID = $7;
  SECURITY_LOGON_IDS_RID = $5      ;
  SECURITY_LOCAL_SYSTEM_RID = $12;
  SECURITY_NT_NON_UNIQUE = $15;
  SECURITY_BUILTIN_DOMAIN_RID = $20;
  DOMAIN_ALIAS_RID_ADMINS = $220;
  DOMAIN_ALIAS_RID_USERS = $221;
  DOMAIN_ALIAS_RID_GUESTS = $222;
  DOMAIN_ALIAS_RID_POWER_USERS = $223;
  DOMAIN_ALIAS_RID_ACCOUNT_OPS = $224;
  DOMAIN_ALIAS_RID_SYSTEM_OPS = $225;
  DOMAIN_ALIAS_RID_PRINT_OPS = $226;
  DOMAIN_ALIAS_RID_BACKUP_OPS = $227;
  DOMAIN_ALIAS_RID_REPLICATOR = $228; 
  SECURITY_NT_AUTHORITY = $5;
  SECURITY_LOCAL_SID_AUTHORITY = $2;  

function UserIsLocalAdmin: Boolean;
var
  Tokens: TTokenGroups;
  SidIdAuth: TSIDIdentifierAuthority;
  Sid: PSid;
  ProcessToken, BufferSize: Cardinal;
  I: Integer;
  Buffer: array of Byte;
begin
  Result := False;
  Sid := nil;
  SidIdAuth.Value[5] := SECURITY_NT_AUTHORITY;
  if not (OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, ProcessToken) or
          OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, ProcessToken))
  then
    Exit;
  if GetTokenInformation(ProcessToken, TokenGroups, nil, 0, BufferSize) then
  begin
    SetLength(Buffer, BufferSize);
    if GetTokenInformation(ProcessToken, TokenGroups, @Buffer[0], BufferSize, BufferSize) then
    begin
      Move(Buffer[0], Tokens, SizeOf(Tokens));
      if AllocateAndInitializeSid(SidIdAuth,
            SECURITY_LOCAL_SID_AUTHORITY,
            SECURITY_BUILTIN_DOMAIN_RID,
            DOMAIN_ALIAS_RID_ADMINS,
            0, 0, 0, 0, 0, 0, Sid)
      then
      begin
        if IsValidSid(Sid) then
          for I := 0 to Tokens.GroupCount do
            if IsValidSid(Tokens.Groups[I].Sid) then
              if EqualSid(Tokens.Groups[I].Sid, Sid) then
              begin
                Result := True;
                Break;
              end;
        if Assigned(Sid) then
          FreeSid(Sid);
      end;
    end;
  end;
  CloseHandle(ProcessToken);
end;

function GetVersionInfo(const FileName: String): String;
var
  n, Len: DWORD;
  Buf: PChar;
  info: ^VS_FIXEDFILEINFO;
begin
    n := GetFileVersionInfoSize(PChar(FileName), n);
    if n > 0 then
    begin
      Buf := AllocMem(n);
      try
        GetFileVersionInfo(PChar(FileName), 0, n, Buf);
        VerQueryValue(Buf, '\', Pointer(info), Len);
        Result :=
          IntToStr(info^.dwProductVersionMS shr $10) + '.' +
          IntToStr(info^.dwProductVersionMS and $ffff) + '.' +
          IntToStr(info^.dwProductVersionLS shr $10) + '.' +
          IntToStr(info^.dwProductVersionLS and $ffff);
      finally
        FreeMem(Buf, n);
      end;
    end;
end;

function StrIsNumber(const S: String): Boolean;
var
  I: Integer;
begin
  Result := Length(S) > 0;
  if Result then
    for I := 1 to Length(S) do
    if not (S[I] in NumberChars) then
    begin
      Result := False;
      Exit;
    end;
end;

function StrIsNumber(const S: String; var Number: Int64): Boolean;
begin
  Result := StrIsNumber(S);
  if Result then
    Number := StrToInt64(S);
end;

function CoCreateGuid(var guid: TGUID): integer; stdcall; external 'ole32.dll';

function GetUniqueString(RemoveDash: Boolean = True; RemoveBrackets: Boolean = True): String;
var
  ClassID: TGUID;
begin
  OleCheck(CoCreateGuid(ClassID));
  Result := GUIDToString(ClassID);
  if RemoveDash then
    Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  if RemoveBrackets then
  begin
    Result := StringReplace(Result, '{', '', [rfReplaceAll]);
    Result := StringReplace(Result, '}', '', [rfReplaceAll]);
  end;
end;

end.
