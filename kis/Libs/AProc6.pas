unit AProc6;

interface

uses
  Windows, Forms, Controls, Classes, SysUtils, IniFiles, Math;

const
  MMPerInch = 25.43;

type
  TAEvent=procedure of object;

  TFloatPoint = record
    X: Double;
    Y: Double;
  end;

//var
//  IniFile: TIniFile;
//  ExePath: string;

function Empty(const Value: String): boolean; overload;
function FindChildControlByClass(Parent: TWinControl; ChildClass: TClass): TControl;
//function Iif(X: Boolean; Y,Z: Variant): Variant;
//function MessageBox(MesStr: string; Icon: Cardinal=0; ParentHandle: HWND=0;
//  CapStr: string=''): Integer;
function MinNotZero(A,B: Integer): Integer;
procedure SetHGCursor;
procedure SetNormCursor;
function Year(Dat: TDateTime): Word;
function Month(Dat: TDateTime): Byte;
function Day(Dat: TDateTime): Byte;
function GetOwnerForm(Component: TComponent): TForm;
{function ReadProperty(Component: TComponent; const PropertyName: string;
  DataType: Integer; IniF: TIniFile): Variant;
procedure WriteProperty(Component: TComponent; const PropertyName: string;
  Value: Variant; IniF: TIniFile);}
function IncYear(const Date: TDateTime; NumberOfYears: Integer): TDateTime;
procedure SetWallpaper(FileName: string);
function RoundFloat(Value: Double; Precision: Byte): Double;
function FloatPoint(X, Y: Double): TFloatPoint;
function GetDegreeCorner(Corner: Double; Minutes: Boolean=True): string;
function GetNextMultiple(Number: Double; Divisor: Integer;
  GoForward: Boolean=True; EnableEqual: Boolean=True): Integer;
function TruncMin(X: Extended): Int64;

implementation

{$WARNINGS OFF}

uses AString6, Variants;

function Iif(X: Boolean; Y,Z: Variant): Variant;
begin
	if X then Result:=Y
	else Result:=Z;
end;

function MessageBox(MesStr: string; Icon: Cardinal=0; ParentHandle: HWND=0;
  CapStr: string=''): Integer;
begin
  if ParentHandle=0 then ParentHandle:=Screen.ActiveForm.Handle;
  if CapStr='' then
    if (Icon and MB_ICONINFORMATION)=MB_ICONINFORMATION then
      CapStr:='Информация'
    else if (Icon and MB_ICONWARNING)=MB_ICONWARNING then
      CapStr:='Внимание'
    else if (Icon and MB_ICONQUESTION)=MB_ICONQUESTION then
      CapStr:='Запрос'
    else if (Icon and MB_ICONSTOP)=MB_ICONSTOP then
      CapStr:='Ошибка';
	Result:=Windows.MessageBox(ParentHandle,PChar(MesStr),PChar(CapStr),Icon);
end;

function MinNotZero(A,B: Integer): Integer;
begin
  if A=0 then Result:=B else
    if B=0 then Result:=A else
      if A<B then Result:=A else Result:=B;
end;

procedure SetHGCursor;
begin
  Screen.Cursor := crHourglass;
end;

procedure SetNormCursor;
begin
  Screen.Cursor := crDefault;
end;

function FindChildControlByClass(Parent: TWinControl; ChildClass: TClass): TControl;
var
  I: Integer;
begin
  Result:=nil;
  for I:=0 to Parent.ControlCount-1 do
    if Parent.Controls[I] is ChildClass then begin
      Result:=Parent.Controls[I];
      Exit;
    end;
end;

function Empty(const Value: String): boolean;
begin
  Result:= Trim(Value) = '';
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

function GetOwnerForm(Component: TComponent): TForm;
var
  Owner: TComponent;
begin
  Result:=nil;
  Owner:=Component.Owner;
  while Owner<>nil do begin
    if Owner is TForm then begin
      Result:=TForm(Owner);
      Exit;
    end;
    Owner:=Owner.Owner;
  end;
end;

procedure WriteProperty(Component: TComponent; const PropertyName: string;
  Value: Variant; IniF: TIniFile);
var
  OwnerForm: TForm;
  SectionName: string;
begin
  OwnerForm:=GetOwnerForm(Component);
  if OwnerForm=nil then
    raise Exception.Create('Невозможно записать значение')
  else begin
    SectionName:=OwnerForm.Name+': '+Component.Name;
    case VarType(Value) of
      varSmallInt, varInteger, varError, varByte:
        IniF.WriteInteger(SectionName,PropertyName,Value);
      varSingle, varDouble, varCurrency:
        IniF.WriteFloat(SectionName,PropertyName,Value);
      varDate:
        IniF.WriteDateTime(SectionName,PropertyName,Value);
      varOleStr, varStrArg, varString:
        IniF.WriteString(SectionName,PropertyName,Value);
      varBoolean:
        IniF.WriteBool(SectionName,PropertyName,Value);
    end;
  end;
end;

function ReadProperty(Component: TComponent; const PropertyName: string;
  DataType: Integer; IniF: TIniFile): Variant;
var
  OwnerForm: TForm;
  SectionName: string;
begin
//  if IniF=nil then IniF:=IniFile;
  OwnerForm := GetOwnerForm(Component);
  if OwnerForm=nil then
    raise Exception.Create('Невозможно прочитать значение')
  else begin
    SectionName:=OwnerForm.Name+': '+Component.Name;
    case DataType of
      varSmallInt, varInteger, varError, varByte:
        Result:=IniF.ReadInteger(SectionName,PropertyName,0);
      varSingle, varDouble, varCurrency:
        Result:=IniF.ReadFloat(SectionName,PropertyName,0);
      varDate:
        Result:=IniF.ReadDateTime(SectionName,PropertyName,0);
      varOleStr, varStrArg, varString:
        Result:=IniF.ReadString(SectionName,PropertyName,'');
      varBoolean:
        Result:=IniF.ReadBool(SectionName,PropertyName,False);
    end;
  end;
end;

function IncYear(const Date: TDateTime; NumberOfYears: Integer): TDateTime;
var
  D, M, Y: Word;
begin
  DecodeDate(Date, Y, M, D);
  Y := Y + NumberOfYears;
  Result := EncodeDate(Y, M, D);
end;

procedure SetWallpaper(FileName: string);
begin
  if Integer(SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, PChar(FileName),
             SPIF_UPDATEINIFILE)) = 0 then RaiseLastWin32Error;
end;

function RoundFloat(Value: Double; Precision: Byte): Double;
var
  I: Integer;
begin
  I:=Trunc(Power(10,Precision));
  Result:=Round(Value*I)/I;
end;

function FloatPoint(X, Y: Double): TFloatPoint;
begin
  Result.X:=X;
  Result.Y:=Y;
end;

function GetDegreeCorner(Corner: Double; Minutes: Boolean=True): string;
begin
  Corner:=RadToDeg(Corner);
  if Minutes then
    Result:=Format('%3d° %3.1f'+#39,[Trunc(Corner),60*Frac(Corner)])
  else
    Result:=Format('%6.2f°',[Corner]);
end;

//выдает следующее большее или меньшее число, кратное Divisor
function GetNextMultiple(Number: Double; Divisor: Integer;
  GoForward: Boolean=True; EnableEqual: Boolean=True): Integer;
var
  I: Integer;
begin
  //если число уже кратно, возвращаем его само
  if EnableEqual and ((Trunc(Number) div Divisor)*Divisor=Number) then
  begin
    Result:=Trunc(Number);
    Exit;
  end;
  I:=Trunc(Number) div Divisor;
  if Number>=0 then
    Result:=Iif(GoForward,I+1,I)*Divisor
  else
    Result:=Iif(GoForward,I,I-1)*Divisor;
end;

//обрезает в меньшую сторону, а не к нулю, как Trunc(),
//т.е. для положительных никакой разницы, а отрицательные станут еще меньше
function TruncMin(X: Extended): Int64;
begin
  Result:=Trunc(X);
  if (X<0)and(Result<>X) then Dec(Result,1);;
end;

{initialization
  ExePath:=ExtractFilePath(Application.ExeName);}
end.
