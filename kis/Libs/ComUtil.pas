unit ComUtil;

interface

uses
  Windows, Classes, Forms, Controls, SysUtils, Registry, Menus,
  Math, StrUtils;

type
	AChar=Array[0..255] of Char;
  TByteSet=Set of Byte;
const
	//HINSTANCE_ERROR=32
  MMPerInch=25.4;
	//Константы режимов работы с таблицами
  fmLook=1;
  fmEdit=2;
  fmAppend=3;
  //Строковые константы
  stNoAccess='К сожалению, у Вас нет доступа';
  //Коды кнопок
  kkBackSpace=8;
  kkTab=9;
  kkEnter=13;
  kkShift=16;
  kkCtrl=17;
  kkAlt=18;
  kkPause=19;
  kkCaps=20;
  kkEsc=27;
  kkSpace=32;
  kkPgUp=33;
  kkPgDn=34;
  kkEnd=35;
  kkHome=36;
  kkLeft=37;
  kkUp=38;
  kkRight=39;
  kkDown=40;
  kkInsert=45;
  kkDelete=46;
  kk0=48;
  kk1=49;
  kk2=50;
  kk3=51;
  kk4=52;
  kk5=53;
  kk6=54;
  kk7=55;
  kk8=56;
  kk9=57;
  kkA=65;
  kkB=66;
  kkC=67;
  kkD=68;
  kkE=69;
  kkF=70;
  kkG=71;
  kkH=72;
  kkI=73;
  kkJ=74;
  kkK=75;
  kkL=76;
  kkM=77;
  kkN=78;
  kkO=79;
  kkP=80;
  kkQ=81;
  kkR=82;
  kkS=83;
  kkT=84;
  kkU=85;
  kkV=86;
  kkW=87;
  kkX=88;
  kkY=89;
  kkZ=90;
  kkF1=112;
  kkF2=113;
  kkF3=114;
  kkF4=115;
  kkF5=116;
  kkF6=117;
  kkF7=118;
  kkF8=119;
  kkF9=120;
  kkF10=121;
  kkF11=122;
  kkF12=123;

var
  ExePath: String;
  ScrPixPerMM: Real;

procedure SetHGCursor;
procedure SetNormCursor;
function AddLeft(st : string; len : integer) : string;
procedure SetMinimize(FormName: TObject);
function Space(Len: SmallInt): String;
function FindComp(CompName: String): Boolean;
function CompStr(Str1,Str2: String; ByLength,CaseSens: Boolean): Boolean;
function StrInclude(IncStr,BigStr: String; CaseSens: Boolean): Boolean;
function LCase(StrPar: String): String;
function UCase(StrPar: String): String;
function Minimum(X,Y: Integer): Integer;
function FirstZagl(St: String): String;
function FileDelete(FName: String): Boolean;
function RCompStr(IncStr,BigStr: String): Boolean;
function Iif(X: Boolean; Y,Z: Variant): Variant;
function ANSI_ASCIIchar(Ch: Char; Mode: Byte): Char;
function ANSI_ASCIIStr(S: String; Mode: Byte): String;
procedure StrToAChar(St: String; var A: Array of Char);
function MessageBox(MesStr: string; Icon: LongInt; CapStr: string): Integer;
procedure FileToStrings(FName: String; var Sts: TStrings);
function Left(St: String; Count: Integer): String;
function Right(St: String; Count: Integer): String;
function Replicate(St: String; Count: Byte): String;
function Year(Dat: TDateTime): Word;
function Month(Dat: TDateTime): Byte;
function Day(Dat: TDateTime): Byte;
function Hour(Time: TDateTime): Byte;
function Minute(Time: TDateTime): Byte;
function Second(Time: TDateTime): Byte;
function DayOfWeekStr(NDay: Byte): String;
function DayOfYearStr(Date: TDateTime): String;
function MonthStr(NMonth: Byte; Rod: Boolean): String;
function GoodDay: String;
function GetSystemInfo(Mode: TByteSet): String;
procedure CheckProgramRegistered;
function CodeStr(St: String): String;
function DeCodeStr(St: String): String;
procedure AddArray(var Source1: Array of Char; var Source2: Array of Char;
	var Dest: Array of Char);
function GetPcKey: String;
function FindMDIChild(Form: TForm; ChildName: String): TForm;
procedure FreeItem(Item: TMenuItem);
function GetDataFileName(Unique: Boolean; Directory, Extension: String): String;
function ParentForm(Control: TControl): TForm;
function ShortFileName(FileName: String): String;
function ControlByName(Parent: TWinControl; ControlName: String): TControl;
function GetParamValue(St: String): String;
function GetParamName(St: String): String;
function GetStrValue(const St: String; NValue: Byte): String;
function ArabianToLatin(Number: Integer): String;
function ExtractLastDir(FileName: String): String;
function PowerInt(Value: LongInt; Power: Integer): LongInt;
function RoundFloat(Value: Double; Precision: Byte): Double;
function CutStr(St: String; Len: Integer): String;
function GetWinError: String;
procedure CheckWinError;
function IncreaseYear(Date: TDateTime; Delta: Word): TDateTime;

implementation

uses
  StrUtil;

//Возвращает истину, если форма с указанным именем существует
function FindComp(CompName: String): Boolean;
var
	I: Integer;
begin
	Result:=False;
	with Application do
	for I:=0 to ComponentCount-1 do
		if (Components[I] is TForm) and
			(Trim(UpperCase(Components[I].Name))=Trim(UpperCase(CompName))) then
		begin
    	Result:=True;
      Break;
    end;
end;

function AddLeft(st : string; len : integer) : string;
begin
   while length(st) < len do st := ' ' + st;
   Result := st;
end;

procedure SetHGCursor;
begin
  Screen.Cursor:=crHourglass;
end;

procedure SetNormCursor;
begin
  Screen.Cursor:=crDefault;
end;

procedure SetMinimize(FormName: TObject);
begin
if FormName is TForm then with TForm(FormName) do
	if WindowState=wsMinimized then
	begin
  	Visible:=false;
		WindowState:=wsNormal;
  	Visible:=true;
  	Application.Minimize;
  end;
end;

function Space(Len: SmallInt): String;
var
	I: SmallInt;
begin
	Result:='';
	for I:=1 to Len do Result:=Result+' ';
end;

// Сравнивает две строки; если ByLength=True - также на совпадение по длине;
// CaseSens=True - чувтсвительна к регистру.
function CompStr(Str1,Str2: String; ByLength,CaseSens: Boolean): Boolean;
var
	I,LenS: Integer;
begin
	Result:=True;
	if ByLength and (Length(Str1)<>Length(Str2)) then
  	Result:=False
  else
  begin
  	LenS:=Minimum(Length(Str1),Length(Str2));
		if not CaseSens then
    begin
	    Str1:=UCase(Str1);
  	  Str2:=UCase(Str2);
    end;
    for I:=1 to LenS do
    	if Str1[I]<>Str2[I] then
      begin
      	Result:=False;
        break;
      end;
  end;
end;

// Сравнивает две строки на вложение справа
function RCompStr(IncStr,BigStr: String): Boolean;
var
	I: Integer;
begin
 	Result:=True;
	if Length(IncStr)>Length(BigStr) then
  	Result:=False
  else
  	for I:=0 to Length(IncStr)-1 do
    	if IncStr[Length(IncStr)-I]<>BigStr[Length(BigStr)-I] then
			begin
      	Result:=False;
        Exit;
      end;
end;

// Проверяет, включена ли одна строка в другую (в любом месте)
function StrInclude(IncStr,BigStr: String; CaseSens: Boolean): Boolean;
var
	AWord: Array[1..10] of String;
  I,NWord: Integer;
begin
	//Загоняем слова из искомой строки в массив
  if not CaseSens then
  begin
	  IncStr:=UCase(Trim(IncStr));
  	BigStr:=UCase(Trim(BigStr));
  end;
  NWord:=1;
  for I:=1 to 10 do AWord[I]:='';
	for I:=1 to Length(IncStr) do
    if IncStr[I]=Chr(32) then	//пробел
    begin
    	if AWord[NWord]<>'' then
	      NWord:=NWord+1;
      if NWord>10 then break;
    end
    else
    	AWord[NWord]:=AWord[NWord]+IncStr[I];
  //Проверяем вложенность во 2-ю строку всех слов из 1-й
  Result:=True;
  for I:=1 to NWord do
  begin
    if Pos(AWord[I],BigStr)=0 then
    begin
    	Result:=False;
      break;
    end;
  end;
end;

// Преобразует строку в нижний регистр
function LCase(StrPar: String): String;
var
	I: Integer;
  B: Byte;
begin
	Result:=StrPar;
	for I:=1 to Length(Result) do
  begin
  	B:=Ord(Result[I]);
    case B of
    	65..90,192..223: Result[I]:=Chr(B+32);	//'A'..'Z','А'..'Я'
			168: Result[I]:=Chr(184);	//'Ё'
    end;
  end;
end;

// Преобразует строку в верхний регистр
function UCase(StrPar: String): String;
var
	I: Integer;
  B: Byte;
begin
	Result:=StrPar;
	for I:=1 to Length(Result) do
  begin
  	B:=Ord(Result[I]);
    case B of
    	97..122,224..255: Result[I]:=Chr(B-32);	//'a'..'z','а'..'я'
			184: Result[I]:=Chr(168);	//'ё'
    end;
  end;
end;

// Минимальное из двух целых чисел
function Minimum(X,Y: Integer): Integer;
begin
	if X<Y then Result:=X else Result:=Y;
end;

function FirstZagl(St: String): String;
begin
  Result:=Ucase(St[1])+LCase(Copy(St,2,Length(St)-1));
end;

function FileDelete(FName: String): Boolean;
var
	St: String;
begin
	Result:=DeleteFile(FName);
  St:='Не удается удалить файл '+FName;
  if not Result then
		MessageBox(St,mb_IconStop,'');
end;

function GetDataFileName(Unique: Boolean; Directory,Extension: String): String;
var
	I: Integer;
begin
 	Directory:=Trim(Directory);
  if Directory='' then Directory:=ExePath;
  if (Directory[Length(Directory)]<>'\') then Directory:=Directory+'\';
  Extension:=Trim(Extension);
  if Extension='' then Extension:='.ini';
  if Unique then
  	for I:=1 to 999999 do begin
     	Result:=Directory+Format('%0:6.6d',[I]);
      Result:=ChangeFileExt(Result,Extension);
    	if not FileExists(Result) then exit;
    end
  else begin
  	Result:=Directory+FirstZagl(ShortFileName(Application.ExeName));
  	Result:=ChangeFileExt(Result,Extension);
  end;
end;

function Iif(X: Boolean; Y,Z: Variant): Variant;
begin
	if X then Result:=Y
	else Result:=Z;
end;

function ANSI_ASCIIchar(Ch: Char; Mode: Byte): Char;
//Mode=0: ANSI -> ASCII
//Mode=1: ASCII -> ANSI
begin
	case Mode of
  0:	case Ch of
			  #192..#239: Result:=Char(Byte(Ch)-64);
				#240..#255: Result:=Char(Byte(Ch)-16);
			else Result:=Ch;
      end;
  1:	case Ch of
			  #128..#175: Result:=Char(Byte(Ch)+64);
				#224..#239: Result:=Char(Byte(Ch)+16);
			else Result:=Ch;
			end;
	else Result:=Ch;
  end;
end;

function ANSI_ASCIIStr(S: String; Mode: Byte): String;
//Mode=0: ANSI -> ASCII
//Mode=1: ASCII -> ANSI
var
	I: Byte;
begin
	Result:=S;
	for I:=1 to Length(Result) do Result[I]:=ANSI_ASCIIchar(S[I],Mode);
end;

procedure StrToAChar(St: String; var A: Array of Char);
var
	I: Integer;
begin
	I:=1;
	while I<=Length(St) do
	begin
		A[I-1]:=St[I];
		I:=I+1;
	end;
	A[I-1]:=#0;
end;

function MessageBox(MesStr: string; Icon: LongInt; CapStr: string): Integer;
// Icon: mb_IconStop, mb_IconInformation, mb_IconQuestion, mb_IconExclamation
// Result: idYes, idNo, idOk, idCancel
var
	A1, A2: AChar;
begin
  if CapStr='' then
    if (Icon and MB_ICONINFORMATION)=MB_ICONINFORMATION then
      CapStr:='Информация'
    else if (Icon and MB_ICONWARNING)=MB_ICONWARNING then
      CapStr:='Внимание'
    else if (Icon and MB_ICONQUESTION)=MB_ICONQUESTION then
      CapStr:='Запрос'
    else if (Icon and MB_ICONSTOP)=MB_ICONSTOP then
      CapStr:='Ошибка';
	StrToAChar(MesStr,A1);
	StrToAChar(CapStr,A2);
	Result:=Application.MessageBox(A1,A2,Icon);
end;

procedure FileToStrings(FName: String; var Sts: TStrings);
var
	F: TextFile;
  St: String;
begin
	AssignFile(F,FName);
  Reset(F);
  Sts.Clear;
  while not Eof(F) do
  begin
  	Readln(F,St);
    Sts.Add(St);
  end;
  CloseFile(F);
end;

function Left(St: String; Count: Integer): String;
begin
	Result:=Copy(St,1,Count);
end;

function Right(St: String; Count: Integer): String;
begin
	Result:=Copy(St,Length(St)-Count+1,255);
end;

function Replicate(St: String; Count: Byte): String;
var
	I: Byte;
begin
	Result:='';
	for I:= 1 to Count do
		Result:=Result+St;
end;

function Year(Dat: TDateTime): Word;
var
	D,M,Y: Word;
begin
	DecodeDate(Dat,Y,M,D);
  Result:=Y;
end;

function Month(Dat: TDateTime): Byte;
var
	D,M,Y: Word;
begin
	DecodeDate(Dat,Y,M,D);
	Result:=M;
end;

function Day(Dat: TDateTime): Byte;
var
	D,M,Y: Word;
begin
	DecodeDate(Dat,Y,M,D);
	Result:=D;
end;

function Hour(Time: TDateTime): Byte;
var
	H,M,S,Ms: Word;
begin
	DecodeTime(Time,H,M,S,Ms);
  Result:=H;
end;

function Minute(Time: TDateTime): Byte;
var
	H,M,S,Ms: Word;
begin
	DecodeTime(Time,H,M,S,Ms);
  Result:=M;
end;

function Second(Time: TDateTime): Byte;
var
	H,M,S,Ms: Word;
begin
	DecodeTime(Time,H,M,S,Ms);
  Result:=S;
end;

function DayOfWeekStr(NDay: Byte): String;
begin
	case NDay of
  	1: Result:='Понедельник';
  	2: Result:='Вторник';
  	3: Result:='Среда';
  	4: Result:='Четверг';
  	5: Result:='Пятница';
  	6: Result:='Суббота';
  	7: Result:='Воскресенье';
  else
  	Result:='';
  end;
end;

function MonthStr(NMonth: Byte; Rod: Boolean): String;
begin
	case NMonth of
  	1: Result:=Iif(Rod,'Января','Январь');
  	2: Result:=Iif(Rod,'Февраля','Февраль');
  	3: Result:=Iif(Rod,'Марта','Март');
  	4: Result:=Iif(Rod,'Апреля','Апрель');
  	5: Result:=Iif(Rod,'Мая','Май');
  	6: Result:=Iif(Rod,'Июня','Июнь');
  	7: Result:=Iif(Rod,'Июля','Июль');
  	8: Result:=Iif(Rod,'Августа','Август');
  	9: Result:=Iif(Rod,'Сентября','Сентябрь');
  	10: Result:=Iif(Rod,'Октября','Октябрь');
  	11: Result:=Iif(Rod,'Ноября','Ноябрь');
  	12: Result:=Iif(Rod,'Декабря','Декабрь');
  end;
end;

function DayOfYearStr(Date: TDateTime): String;
begin
	Result:=IntToStr(Day(Date))+'-е '+MonthStr(Month(Date),True)+
	  Iif(Year(Date)=1900,'',' '+IntToStr(Year(Date))+' г.');
end;

function GoodDay: String;
var
  H,M,S,MS: Word;
begin
	DecodeTime(Time,H,M,S,MS);
	case H of
  	4..10: Result:='Доброе утро';
    11..16: Result:='Добрый день';
    17..22: Result:='Добрый вечер';
  else Result:='Уже пора спать';
  end;
end;

function GetSystemInfo(Mode: TByteSet): String;
//1-ProductId, 2-RegisteredOrganization, 3-RegisteredOwner,
//4-SystemBiosDate,5-VideoBiosDate
var
	Reg: TRegistry;
	St: String;

	function ReadIdentification: String;
  begin
  	Result:='';
  	with Reg do begin
	 		if (1 in Mode) and ValueExists('ProductId') then
		  	Result:=Result+ReadString('ProductId')+';';
	 		if (2 in Mode) and ValueExists('RegisteredOrganization') then
		  	Result:=Result+ReadString('RegisteredOrganization')+';';
	 		if (3 in Mode) and ValueExists('RegisteredOwner') then
		  	Result:=Result+ReadString('RegisteredOwner')+';';
			CloseKey;
    end;
  end;
begin
	Result:='';
	Reg:=TRegistry.Create;
	Reg.RootKey:=HKEY_LOCAL_MACHINE;
	if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion',False) then begin
   	St:=ReadIdentification;
    Result:=Result+St;
    if St='' then
			if Reg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion',False) then
   			Result:=Result+ReadIdentification;
  end;
	if Reg.OpenKey('HardWare\Description\System',False) then begin
    if 4 in Mode then Result:=Result+Reg.ReadString('SystemBiosDate')+';';
    if 5 in Mode then Result:=Result+Reg.ReadString('VideoBiosDate')+';';
  end;
  Result:=Copy(Result,1,Length(Result)-1);
end;

function GetPcKey: String;
begin
	Result:=GetSystemInfo([1,2,3,4,5]);
  Result:=Left(Result,50);
  Result:=Result+Replicate(' ',50-Length(Result));
end;

procedure CheckProgramRegistered;
const
	FindKey='S^(*>5?#GH';
var
  NeedKey, PcKey: String;
begin
	NeedKey:=FindKey+'                                                  ';
	PcKey:=GetPcKey;
	PcKey:=CodeStr(PcKey);
	PcKey:=FindKey+PcKey;
	if NeedKey<>PcKey then begin
		//Программа не зарегистрирована.'+#13+
    //'Если Вы хотите ее использовать, обратитесь к разработчику.
  	MessageBox('Ошибка № 10',mb_IconStop,'');
    halt;
  end;
end;

function CodeStr(St: String): String;
var
	I,J: Integer;
begin
	Result:=St;
	for	I:=1 to Length(Result) do begin
  	J:=Iif(I=Length(Result),1,I+1);
	  Result[J]:=Chr(Ord(Result[J])+Ord(Result[I]));
  end;
end;

function DeCodeStr(St: String): String;
var
	I,J: Integer;
begin
	Result:=St;
	for	I:=Length(Result) downto 1 do begin
  	J:=Iif(I=Length(Result),1,I+1);
	  Result[J]:=Chr(Ord(Result[J])-Ord(Result[I]));
  end;
end;

procedure AddArray(var Source1: Array of Char; var Source2: Array of Char;
	var Dest: Array of Char);
var
	I: Integer;
begin
	for I:=Low(Source1) to High(Source1) do
  	Dest[Low(Dest)+I]:=Source1[I];
	for I:=Low(Source2) to High(Source2) do
  	Dest[Low(Dest)+High(Source1)+I+1]:=Source2[I];
end;

function FindMDIChild(Form: TForm; ChildName: String): TForm;
var
	I: Integer;
begin
	Result:=nil;
	with Form do
		for I:=0 to MDIChildCount-1 do
    	if MDIChildren[I].Name=ChildName then begin
      	Result:=MDIChildren[I];
        exit;
      end;
end;

procedure FreeItem(Item: TMenuItem);
begin
	while Item.Count>0 do FreeItem(Item.Items[Item.Count-1]);
  Item.Free;
end;

function ParentForm(Control: TControl): TForm;
begin
  if Control.Owner=nil then
    Result:=nil
  else if Control.Owner is TForm then
    Result:=TForm(Control.Owner)
  else
    Result:=ParentForm(TControl(Control.Owner));
end;

function ShortFileName(FileName: String): String;
begin
	Result:=ExtractFileName(FileName);
  Result:=ChangeFileExt(Result,'');
end;

function ControlByName(Parent: TWinControl; ControlName: String): TControl;
var
  I: Integer;
begin
  ControlName:=UpperCase(ControlName);
  Result:=nil;
  with Parent do
    for I:=0 to ControlCount-1 do
      if UpperCase(Controls[I].Name)=ControlName then begin
        Result:=Controls[I];
        exit;
      end;
end;

function GetParamName(St: String): String;
begin
  Result:=Trim(Copy(St,1,Pos('=',St)-1));
end;

function GetParamValue(St: String): String;
var
  N: Integer;
begin
  N:=Pos('=',St);
  if N=0 then
    Result:=''
  else
    Result:=Trim(Copy(St,N+1,255));
end;

//возвращает N-е выражение из строки типа '123,cvbd,cvxc;453453'
//разделитель выражений - ',' или ';'
function GetStrValue(const St: String; NValue: Byte): String;
var
  I, N: Integer;
  function GetFirstDelimiterPos(const St: String): Integer;
  var
    X,Y: Integer;
  begin
    X:=Pos(',',St);
    Y:=Pos(';',St);
    if X*Y=0 then Result:=X+Y else Result:=Min(X,Y);
  end;
begin
  Result:=St;
  //отбрасываем первые NValue-1 значений
  for I:=1 to NValue-1 do begin
    N:=GetFirstDelimiterPos(Result);
    Result:=Copy(Result,N+1,255);
  end;
  N:=GetFirstDelimiterPos(Result);
  if N=0 then N:=256;
  Result:=Trim(Copy(Result,1,N-1));
end;

function ArabianToLatin(Number: Integer): String;
var
  S: Array[1..7] of Char;
  N: Array[1..7] of Integer;
  I: Integer;
  procedure Int(I,D: Integer);
  begin
    if Number div (N[I]-N[I-D])>0 then begin
      Result:=Result+S[I-D]+S[I];
      Number:=Number mod (N[I]-N[I-D]);
    end;
  end;
begin
  Result:='';
  S[1]:='I'; S[2]:='V'; S[3]:='X'; S[4]:='L'; S[5]:='C'; S[6]:='D'; S[7]:='M';
  N[1]:=1;   N[2]:=5;   N[3]:=10;  N[4]:=50;  N[5]:=100; N[6]:=500; N[7]:=1000;
  for I:=7 downto 1 do begin
    Result:=Result+Replicate(S[I],Number div N[I]);
    Number:=Number mod N[I];
    case I of
      7: Int(I,2);
      6: Int(I,1);
      5: Int(I,2);
      4: Int(I,1);
      3: Int(I,2);
      2: Int(I,1);
    end;
  end;
end;

function ExtractLastDir(FileName: String): String;
begin
  Result:=ExtractFilePath(FileName);
  Result:=Left(Result,Length(Result)-1);
  Result:=Copy(Result,RPos('\',Result)+1,255);
end;

function PowerInt(Value: LongInt; Power: Integer): LongInt;
var
  I: Integer;
begin
  Result:=Value;
  for I:=2 to Power do Result:=Result*Value;
end;

function RoundFloat(Value: Double; Precision: Byte): Double;
var
  I: Integer;
begin
  I:=PowerInt(10,Precision);
  Result:=Int(Value*I)/I;
end;

function CutStr(St: string; Len: Integer): String;
begin
  if Length(St)>Len then
    Result := DupeString('*',Len)
  else
    Result:=St;
end;

function GetWinError: String;
var
  PSt: PChar;
  ErrorCode: Integer;
begin
	ErrorCode:=Windows.GetLastError;
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER+FORMAT_MESSAGE_FROM_SYSTEM,
    nil,ErrorCode,0,@PSt,0,nil);
  Result:='['+IntToStr(ErrorCode)+'] '+PSt;
  if LocalFree(Cardinal(PSt))<>0 then
    MessageBox('LocalFree: Ошибка освобождения памяти',mb_IconStop,'');
end;

procedure CheckWinError;
begin
	if Windows.GetLastError<>0 then raise Exception.Create(GetWinError);
end;

function IncreaseYear(Date: TDateTime; Delta: Word): TDateTime;
var
  D,M,Y: Word;
begin
  DecodeDate(Date,Y,M,D);
  Y:=Y+Delta;
  Result:=EncodeDate(Y,M,D);
end;

begin
  ExePath:=ExtractFilePath(Application.ExeName);
  ScrPixPerMM:=Screen.PixelsPerInch/MMPerInch;
end.
