unit Geodesy;

interface

uses SysUtils, AProc6;

function CalcLength(P1, P2: TFloatPoint): Extended;
function CalcAzimuth(P1, P2: TFloatPoint): Extended;
procedure CalcTakingSituation(StationX, StationY, StationAzimuth, PointCorner,
  PointLength: Double; var PointX, PointY: Double);
function GetNomenclature(X, Y: Double; M500: Boolean): string;

implementation

function CalcLength(P1, P2: TFloatPoint): Extended;
begin
  Result:=Sqrt(Sqr(P2.X-P1.X)+Sqr(P2.Y-P1.Y));
end;

function CalcAzimuth(P1, P2: TFloatPoint): Extended;
begin
  if P2.X=P1.X then
    if P2.Y>=P1.Y then Result:=Pi/2 else Result:=-Pi/2
  else
    Result:=ArcTan((P2.Y-P1.Y)/(P2.X-P1.X));
  if P2.X>=P1.X then begin
    if P2.Y<P1.Y then Result:=Result+2*Pi end
  else
    Result:=Result+Pi;
end;

procedure CalcTakingSituation(StationX, StationY, StationAzimuth, PointCorner,
  PointLength: Double; var PointX, PointY: Double);
begin
  PointX:=StationX+PointLength*Cos(StationAzimuth+PointCorner+Pi);
  PointY:=StationY+PointLength*Sin(StationAzimuth+PointCorner+Pi);
end;

function GetNomenclature(X, Y: Double; M500: Boolean): string;
var
  NX: array[-15..12] of string;
  NY: array[-14..14] of string;
  I, J, MinX, MaxX, MinY, MaxY: Integer;
begin
  //проверяем значения параметров
  MinX:=Low(NX)*1000; MaxX:=(High(NX)+1)*1000-1;
  MinY:=Low(NY)*1000; MaxY:=(High(NY)+1)*1000-1;
  if (X<MinX)or(X>MaxX)or(Y<MinY)or(Y>MaxY) then
  begin
    Result := '';
    Exit;
  end;
{    raise Exception.Create('Координаты должны лежать в пределах:'+#13+
      'X: '+IntToStr(MinX)+'..'+IntToStr(MaxX)+', '+
      'Y: '+IntToStr(MinY)+'..'+IntToStr(MaxY));}
  //заполняем массивы
  NX[-15]:='Я'; NX[-14]:='Ю'; NX[-13]:='Э'; NX[-12]:='Щ'; NX[-11]:='Ш';
  NX[-10]:='Ч'; NX[-9]:='Ц'; NX[-8]:='Х'; NX[-7]:='Ф'; NX[-6]:='У'; NX[-5]:='Т';
  NX[-4]:='С'; NX[-3]:='Р'; NX[-2]:='П'; NX[-1]:='О'; NX[0]:='Н'; NX[1]:='М';
  NX[2]:='Л'; NX[3]:='К'; NX[4]:='И'; NX[5]:='З'; NX[6]:='Ж'; NX[7]:='Е';
  NX[8]:='Д'; NX[9]:='Г'; NX[10]:='В'; NX[11]:='Б'; NX[12]:='А';

  NY[-14]:='0III'; NY[-13]:='0II'; NY[-12]:='0I'; NY[-11]:='00'; NY[-10]:='I';
  NY[-9]:='II'; NY[-8]:='III'; NY[-7]:='IV'; NY[-6]:='V'; NY[-5]:='VI';
  NY[-4]:='VII'; NY[-3]:='VIII'; NY[-2]:='IX'; NY[-1]:='X'; NY[0]:='XI';
  NY[1]:='XII'; NY[2]:='XIII'; NY[3]:='XIV'; NY[4]:='XV'; NY[5]:='XVI';
  NY[6]:='XVII'; NY[7]:='XVIII'; NY[8]:='XIX'; NY[9]:='XX'; NY[10]:='XXI'; NY[11]:='XXII';
  NY[12]:='XXIII'; NY[13]:='XXIV'; NY[14]:='XXV';
  //вычисляем номенклатуру 1:2000
  I:=TruncMin(X/1000);
  J:=TruncMin(Y/1000);
  Result:=NX[I]+'-'+NY[J];
  //вычисляем номенклатуру 1:500
  if M500 then begin
    I:=Trunc(GetNextMultiple(X,1000,True,False)-X);
    J:=Trunc(Y-GetNextMultiple(Y,1000,False,True));
    Result:=Result+'-'+IntToStr(((I-1) div 250)*4+J div 250+1);
  end;
end;

end.
