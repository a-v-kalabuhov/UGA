unit AString6;

interface

uses Windows, SysUtils, Classes, AProc6, Math, Graphics, StrUtils;

const
  DelimitersSet=[' ',',',';','.','|','/','\','+','-'];
  DigitsSet=['0','1','2','3','4','5','6','7','8','9'];

type
  CharSet=set of Char;

function GetFistWord(Str: string): string;
function GetNextNumber(Number: string; Order: Integer = 1): string;
function GetNextWord(var Str: string; Delimiters: CharSet=DelimitersSet): string;
function LastChar(const Str: string): Char;
function RPos(SubStr,S: string): Integer;
function DoublePos(SubStr1, SubStr2, S: string; var Pos1, Pos2: Integer): Boolean;
function WholeWordPos(Substr, S: string; Delimiters: CharSet=DelimitersSet): Integer;
function SubtractString(const FromStr, WhatStr: String): String;
function ValidChar(Key: Char): boolean;
//function Left(St: string; Count: Integer): string;
//function Right(St: string; Count: Integer): string;
procedure RealizeLength(var S: string);
function StrToOem(const Str: string): string;
function OemToStr(const Str: string): string;
procedure OEMFile(const SourceFileName: string; ToAnsi: Boolean = True;
  DestFileName: string = '');
function GetParamValue(St: string): string;
function GetStrValue(const St: string; NValue: Byte): string;
function GetParamName(St: string): string;
procedure RemoveWords(Words: string; var S: string);
procedure ReplaceString(const FindStr, ReplaceStr: string; var S: string);

implementation

uses AFile6;

function RPos(SubStr,S: string): Integer;
var
	I: Integer;
begin
	Result:=0;
  if Length(Substr)=0 then Exit;
	for I:=Length(S)-Length(Substr)+1 downto 1 do
  begin
  	if Copy(S,I,Length(Substr))=Substr then
		begin
      Result:=I;
      Exit;
    end;
  end;
end;

function ValidChar(Key: Char): boolean;
begin
  Result:=(Key in [#8,'0'..'9','A'..'Z','_','a'..'z']);
end;

function SubtractString(const FromStr, WhatStr: String): String;
var
  I, J: Integer;
begin
  Result := FromStr;
  for I := 1 to Length(WhatStr) do
  begin
    J := Pos(WhatStr[I], Result);
    if J > 0 then Delete(Result, J, 1);
  end;
end;

function LastChar(const Str: String): Char;
begin
  if Str = '' then
    Result := #0
  else
    Result := Str[Length(Str)];
end;

//Удаляет лидирующие, замыкающие и повторяющиеся пробелы
function GetFistWord(Str: string): string;
var
  InWord: Boolean;
  I: Integer;
begin
  InWord:=False;
  for I:=1 to Length(Str) do
    if Str[I] in DelimitersSet then begin
      if InWord then Exit;
    end
    else begin
      InWord:=True;
      Result:=Result+Str[I];
    end;
end;

function Left(St: string; Count: Integer): string;
begin
	Result:=Copy(St,1,Count);
end;

function Right(St: string; Count: Integer): string;
begin
	Result:=Copy(St,Length(St)-Count+1,Length(St));
end;

procedure RealizeLength(var S: string);
begin
  SetLength(S,StrLen(PChar(S)));
end;

//конвертирует файл из ASCII в ANSI и наоборот
//если DestFileName пусто, то файл сохраняется под своим именем
procedure OEMFile(const SourceFileName: String; ToAnsi: Boolean = True;
  DestFileName: String = '');
var
	SourceF, DestF: TextFile;
  St: string;
  ConvertToSelf: Boolean;
begin
	AssignFile(SourceF,SourceFileName);
  Reset(SourceF);
  ConvertToSelf:=False;
  if Empty(DestFileName) then
  begin
    ConvertToSelf:=True;
    DestFileName := AFile6.GetTempFileName;
  end;
  AssignFile(DestF,DestFileName);
	Rewrite(DestF);
  while not Eof(SourceF) do begin
  	Readln(SourceF,St);
    if ToAnsi then St:=OemToStr(St) else St:=StrToOem(St);
    Writeln(DestF,St);
  end;
	CloseFile(SourceF); CloseFile(DestF);
  if ConvertToSelf then begin
  	SysUtils.DeleteFile(SourceFileName);
		SysUtils.RenameFile(DestFileName,SourceFileName);
  end;
end;

function StrToOem(const Str: string): string;
begin
  SetLength(Result, Length(Str));
  if Length(Result)>0 then
    CharToOemBuff(PChar(Str), PChar(Result), Length(Result));
end;

function OemToStr(const Str: string): string;
begin
  SetLength(Result, Length(Str));
  if Length(Result)>0 then
    OemToCharBuff(PChar(Str), PChar(Result), Length(Result));
end;

//добавляет к числу с порядковым номером Order единицу
//GetNextNumber('001-500КГА')='001-501КГА'
function GetNextNumber(Number: string; Order: Integer = 1): string;
var
  I,J: Integer;
  //ищет позицию числа № Order
  function GetNumberPosition(Number: string; Order: Integer;
    var Position, Count: Integer): Boolean;
  var
    InNumber: Boolean;
    I, CurOrder: Integer;
  begin
    InNumber:=False;
    CurOrder:=0; Position:=0; Count:=0;
    for I:=1 to Length(Number) do
      if Number[I] in DigitsSet then begin
        if not InNumber then begin
          InNumber:=True;
          Inc(CurOrder);
          if CurOrder=Order then Position:=I;
        end;
        if CurOrder=Order then Inc(Count);
      end
      else begin
//        if CurOrder=Order then// Break;
        InNumber:=False;
      end;
    Result:=(Count>0);
  end;
begin
  if GetNumberPosition(Number,Order,I,J) then
    Result := Copy(Number,1,I-1) + Format('%0.'+IntToStr(J)+'d',[StrToInt(Copy(Number,I,J))+1])+
      Copy(Number,I+J,Length(Number));
  if Result='' then Result := '1';
end;

//вырезает и возвращает превое слово строки, т.е. символы до первого разделителя
function GetNextWord(var Str: string; Delimiters: CharSet=DelimitersSet): string;
var
  InWord: Boolean;
  I, Pos, Count: Integer;
begin
  InWord:=False; Pos:=0; Count:=0;
  for I:=1 to Length(Str) do
    if Str[I] in Delimiters then begin
      if InWord then Break
    end
    else begin
      if not InWord then begin
        InWord:=True;
        Pos:=I;
      end;
      Inc(Count);
    end;
  if Pos=0 then
    Str:=''
  else begin
    Result:=Copy(Str,Pos,Count);
    Str:=Copy(Str,Pos+Count+1,Length(Str));
  end;
end;

//возвращает строку '111' из строки '111=222'
function GetParamName(St: string): string;
var
  N: Integer;
begin
  N:=Pos('=',St);
  if N=0 then
    Result:=Trim(St)
  else
    Result:=Trim(Copy(St,1,N-1));
end;

//возвращает строку '222' из строки '111=222'
function GetParamValue(St: string): string;
var
  N: Integer;
begin
  N:=Pos('=',St);
  if N=0 then
    Result:=''
  else
    Result:=Trim(Copy(St,N+1,Length(St)));
end;

//возвращает N-е выражение из строки типа '123,cvbd,cvxc;453453'
//разделитель выражений - ',' или ';'
function GetStrValue(const St: string; NValue: Byte): string;
var
  I, N: Integer;
  function GetFirstDelimiterPos(const St: string): Integer;
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

//Words - строка типа 'Word1,Word2,Word3'
//процедура удаляет из строки Str все слова из строки Words
procedure RemoveWords(Words: string; var S: string);
  procedure RemoveWord;
  var
    Word: string;
    I: Integer;
  begin
    Word:=GetNextWord(Words,[',',';']);
    I:=Pos(Word,S);
    while I>0 do begin
      Delete(S,I,Length(Word));
      I:=Pos(Word,S);
    end;
  end;
begin
  while Words<>'' do RemoveWord;
end;

procedure ReplaceString(const FindStr, ReplaceStr: string; var S: string);
var
  I: Integer;
begin
  I:=Pos(FindStr,S);
  while I>0 do begin
    S:=Copy(S,1,I-1)+ReplaceStr+Copy(S,I+Length(FindStr),Length(S));
    I:=Pos(FindStr,S);
  end;
end;

//ищет позиции двух строк в третьей, причем вторая строка должна быть после первой
function DoublePos(SubStr1, SubStr2, S: string; var Pos1, Pos2: Integer): Boolean;
begin
  Pos1:=Pos(SubStr1,S);
  if Pos1=0 then SubStr1:='';
  S:=Copy(S,Pos1+Length(SubStr1),Length(S));
  Pos2:=Pos(SubStr2,S);
  if Pos2>0 then Pos2:=Pos2+Pos1+Length(SubStr1)-1;
  Result:=(Pos1>0)and(Pos2>0);
end;

function WholeWordPos(Substr, S: string; Delimiters: CharSet=DelimitersSet): Integer;
begin
  Result:=Pos(Substr,S);
  while Result>0 do begin
    if (Result=1)or(S[Result-1] in Delimiters)and
      (Length(S)=Result+Length(Substr)-1)or(S[Result+Length(Substr)] in Delimiters) then
      Break;
    S:=Copy(S,Result+1,Length(S));
    Result:=Pos(Substr,S);
  end;
end;

end.
