unit AllotmentReportLibrary;

interface

uses
  FR_Class, SysUtils, uCommonUtils, AProc6, Allotment, Variants;

type

  TAllotmentsReportLibrary = class(TfrFunctionLibrary)
  public
    constructor Create; override;
    procedure DoFunction(FNo: Integer; p1, p2, p3: Variant; var val: Variant); override;
  end;

implementation

constructor TAllotmentsReportLibrary.Create;
begin
  inherited Create;
  with List do
  begin
    Add('ARCTAN');
    Add('GET_DOC_NAME');
    Add('GRAD');
    Add('LATIN');
    Add('PI');
    Add('SQRTFUNCTION');
  end;
end;

  function ArabToLatin(const Arab: Variant): String;
  var
    S: String;
    I: Integer;
  begin
    try
      S := VarToStr(Arab);
      I := StrToInt(S);
      Result := uCommonutils.ArabianToLatin(I);
    except
      Result := '';
    end;
  end;

  function FormatCorner(const Corner: Double; const Part, OnlyMinutes: Boolean): String;
  var
    i: Integer;
  begin
    result := AProc6.GetDegreeCorner(corner);
    if part then
    begin
      i := pos('°', result);
      if onlyminutes then
      begin
        if i > 0 then result := Trim(Copy(result, i + 1, Length(result) - i - 1));
      end
      else
      begin
        if i > 0 then result := Trim(Copy(result, 1, i - 1));
      end;
    end;
  end;

  function GetDocName(const v1, v2, v3: Variant): String;
  begin
    result := '';
    try
      result := #39 + VarToStr(v1) + ' № ' + VarToStr(v2) + ' от ' + VarToStr(v3) + ', ' + #39;
    except
    end;
  end;

  function SQRTFUNCTION(d: Real): Real;
  begin
    result := SQRT(d);
  end;

procedure TAllotmentsReportLibrary.DoFunction(FNo: Integer; p1, p2, p3: Variant; var val: Variant);
begin
  val := 0;
  case FNo of
    0: val := ArcTan(frParser.Calc(p1));
    1: val := GetDocName(frParser.Calc(p1), frParser.Calc(p2), frParser.Calc(p3));
    2: val := FormatCorner(frParser.Calc(p1), frParser.Calc(p2), frParser.Calc(p3));
    3: val := ArabToLatin(frParser.Calc(p1));
    4: val := Pi;
    5: val := SQRTFUNCTION(frParser.Calc(p1));
  end;
end;

initialization

  frRegisterFunctionLibrary(TAllotmentsReportLibrary);

finalization
  frUnRegisterFunctionLibrary(TAllotmentsReportLibrary);

end.
