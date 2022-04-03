unit StrUtil;

interface

uses SysUtils, Graphics;

type
  //падежи
  {»менительный (кто, что), –одительный (кого, что), ƒательный (кому, чему),
   ¬инительный (кого, чего), “ворительный (кем,чем), ѕредложный (о ком, о чем)}
  TWordCase=(Nominative,Genitive,Dative,Accusative,Instrumental,Prepositional);
  //мес€цы
  TMonth=(January,February,March,April,May,June,July,August,September,October,
    November,December);

function MonthDeclension(Month: TMonth; WordCase: TWordCase): String;
function WordDate(Date: TDateTime): String;
function WordYearCount(Year: Integer): String;
function GetStringByLen(var St: String; Length: Integer; WordWrap: Boolean;
  Canvas: TCanvas; Font: TFont): String;
function StringsFind(Strings: Array of String; Source: String): Boolean;
function GetNewDocNumber(OldNumber: String): String;
procedure RealizeLength(var S: string);
function RPos(SubStr,S: String): Integer;

//—м. StrUtils
implementation

uses ComUtil;

function MonthDeclension(Month: TMonth; WordCase: TWordCase): String;
var
  MA: array[Low(TMonth)..High(TMonth),Low(TWordCase)..High(TWordCase)] of String;
begin
  MA[January,Nominative]:='€нварь'; MA[January,Genitive]:='€нварь';
  MA[January,Dative]:='€нварю'; MA[January,Accusative]:='€нвар€';
  MA[January,Instrumental]:='€нварем'; MA[January,Prepositional]:='€нваре';

  MA[February,Nominative]:='февраль'; MA[February,Genitive]:='февраль';
  MA[February,Dative]:='февралю'; MA[February,Accusative]:='феврал€';
  MA[February,Instrumental]:='февралем'; MA[February,Prepositional]:='феврале';

  MA[March,Nominative]:='март'; MA[March,Genitive]:='март';
  MA[March,Dative]:='марту'; MA[March,Accusative]:='марта';
  MA[March,Instrumental]:='мартом'; MA[March,Prepositional]:='марте';

  MA[April,Nominative]:='апрель'; MA[April,Genitive]:='апрель';
  MA[April,Dative]:='апрелю'; MA[April,Accusative]:='апрел€';
  MA[April,Instrumental]:='апрелем'; MA[April,Prepositional]:='апреле';

  MA[May,Nominative]:='май'; MA[May,Genitive]:='май';
  MA[May,Dative]:='маю'; MA[May,Accusative]:='ма€';
  MA[May,Instrumental]:='маем'; MA[May,Prepositional]:='мае';

  MA[June,Nominative]:='июнь'; MA[June,Genitive]:='июнь';
  MA[June,Dative]:='июню'; MA[June,Accusative]:='июн€';
  MA[June,Instrumental]:='июнем'; MA[June,Prepositional]:='июне';

  MA[July,Nominative]:='июль'; MA[July,Genitive]:='июль';
  MA[July,Dative]:='июлю'; MA[July,Accusative]:='июл€';
  MA[July,Instrumental]:='июлем'; MA[July,Prepositional]:='июле';

  MA[August,Nominative]:='август'; MA[August,Genitive]:='август';
  MA[August,Dative]:='августу'; MA[August,Accusative]:='августа';
  MA[August,Instrumental]:='августом'; MA[August,Prepositional]:='августе';

  MA[September,Nominative]:='сент€брь'; MA[September,Genitive]:='сент€брь';
  MA[September,Dative]:='сент€брю'; MA[September,Accusative]:='сент€бр€';
  MA[September,Instrumental]:='сент€брем'; MA[September,Prepositional]:='сент€бре';

  MA[October,Nominative]:='окт€брь'; MA[October,Genitive]:='окт€брь';
  MA[October,Dative]:='окт€брю'; MA[October,Accusative]:='окт€бр€';
  MA[October,Instrumental]:='окт€брем'; MA[October,Prepositional]:='окт€бре';

  MA[November,Nominative]:='но€брь'; MA[November,Genitive]:='но€брь';
  MA[November,Dative]:='но€брю'; MA[November,Accusative]:='но€бр€';
  MA[November,Instrumental]:='но€брем'; MA[November,Prepositional]:='но€бре';

  MA[December,Nominative]:='декабрь'; MA[December,Genitive]:='декабрь';
  MA[December,Dative]:='декабрю'; MA[December,Accusative]:='декабр€';
  MA[December,Instrumental]:='декабрем'; MA[December,Prepositional]:='декабре';

  Result:=MA[Month,WordCase];
end;

function WordDate(Date: TDateTime): String;
begin
  Result:=IntToStr(Day(Date))+' '+MonthDeclension(TMonth(Month(Date)-1),
    Accusative)+' '+IntToStr(Year(Date))+' г.';
end;

function GetStringByLen(var St: String; Length: Integer; WordWrap: Boolean;
  Canvas: TCanvas; Font: TFont): String;
var
  I,M,N: Integer;
  OldFont: TFont;
begin
  M:=0; N:=0;
  St:=Trim(St);
  OldFont:=Canvas.Font;
  Canvas.Font:=Font;
  for I:=System.Length(St) downto 1 do begin
    M:=I;
    if (N=0)and(Canvas.TextWidth(Copy(St,1,I))<=Length) then N:=I;
    if (N>0)and((not WordWrap)or(St[I] in [' ',',','.',';','-'])or
      (I=System.Length(St))) then break;
  end;
  N:=Iif(M=1,N,M);
  Result:=Trim(Copy(St,1,N));
  St:=Trim(Copy(St,N+1,255));
  Canvas.Font:=OldFont;
end;

function StringsFind(Strings: Array of String; Source: String): Boolean;
var
  I: Integer;
begin
  Result:=False;
  for I:=Low(Strings) to High(Strings) do
    if Pos(Strings[I],Source)>0 then begin
      Result:=True;
      exit;
    end;
end;

function WordYearCount(Year: Integer): String;
var
  LastDigit: Byte;
begin
  LastDigit:=Abs(Year-10*Trunc(Year/10));
  case LastDigit of
    1: Result:='год';
    2..4:  Result:='года';
  else
     Result:='лет';
  end;
  Result:=IntToStr(Year)+' '+Result;
end;

//добавл€ет к последнему числу в строке единицу
//GetNewDocNumber('001-500 √ј')='001-501 √ј'
function GetNewDocNumber(OldNumber: String): String;
var
  I,Pos: Integer;
  ASt: array[1..3] of String;
begin
  OldNumber:=Trim(OldNumber);
	if OldNumber='' then
    Result:='001'
  else begin
    ASt[1]:=''; ASt[2]:=''; ASt[3]:='';
    Pos:=3;
    //разбиваем строку на три части: символы, номер, символы
    for I:=Length(OldNumber) downto 1 do begin
      if OldNumber[I] in ['0','1','2','3','4','5','6','7','8','9'] then begin
        if Pos=3 then Pos:=2; end
      else
        if Pos=2 then Pos:=1;
      ASt[Pos]:=OldNumber[I]+ASt[Pos];
    end;
    if ASt[2]='' then
      Result:=OldNumber
    else
      Result:=Format(ASt[1]+'%'+IntToStr(Length(ASt[2]))+'.'+
        IntToStr(Length(ASt[2]))+'d'+ASt[3],[StrToInt(ASt[2])+1]);
  end;
end;

procedure RealizeLength(var S: string);
begin
  SetLength(S,StrLen(PChar(S)));
end;

function RPos(SubStr,S: String): Integer;
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

end.
