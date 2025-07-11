// модуль пересчета координат из местной Воронежской в СК-36 и наоборот
// создан на основе декомпилированого файла
// апрель-май 2011
// edvrn

// процедура ToCK36 получает Х и У как double
// возвращает новые Х и У как double
// при установленном flag в true выдает данные в геодезическом округлении

// процедура ToVRN получает Х и У как double
// возвращает новые Х и У как double
// при установленном flag в ture выдает данные в геодезтческом округлении



unit uCK36;

interface
uses
  SysUtils, Math;

type
  TProgressEvent = procedure(const VarName: String; D: Extended) of object;

const
   var_48 = 0.9999847;
   var_50 = 0.0024039;
   var_58 = 5725278.885;
   const1 = 2.0626480625e5;
   const2 = 500000.0;
   const3 = 1.0;
   const4 = 0.25;
   const5 = 3.333333e-1;
   const6 = 0.166667;
   const7 = 0.5;
   const22 = 4e-3;
   cnt1 = 22.0;
   cnt2 = 2350.0;
   cnt3 = 293622.0;
   cnt4 = 1.0e-10;
   cnt5 = 5.0221746e7;
   cnt6 = 108.973;
   cnt7 = 0.612;
   cnt8 = 2.1562267e4;
   cnt9 = 0.001123;
   cnt10 = 0.6716608738092;
   cnt11 = 1.08973e2;
   cnt12 = 6.399698902e6;
   cnt13 = 3.2140404e4;
   cnt14 = 12900.571;
   cnt15 = 5200000.0;
   cnt16 = 250000;
   cnt17 = 1.123e-3;
   cnt18 = 3.98e-3;
   cnt19 = 7.0e6;
   cnt20 = 0.68067840828;
   cnt21 = 3.369e-3;

   V30 = 1.000009499999999 ;
   V38 = -2.4042e-3; // -0.0024042    -2.4042e-3
   V40 = -5.724097206e6;
   V50 = -5.28076231e5;
   Cosn2 = 2.15622669e4;
   Cosn3 = 6.3675584969e6;

  procedure ToCK36(const _X, _Y: double; var X, Y: double; DoRound: boolean = false); overload;
  procedure ToCK36(var X, Y: double; DoRound: boolean = false); overload;
  procedure ToVRN(const _X, _Y: double; var X, Y: double; DoRound: boolean = false); overload;
  procedure ToVRN(var X, Y: double; DoRound: boolean = false); overload;

implementation

//гедезическое округление  оно же "банковское"
function GeoRound(I: double):Double;
var
  B, C, D: string;
  A : Double;
begin {GeoRound}
  A := I;
  B := FormatFloat('0.0000',a);
  C :=  Copy (B,Length(b)-1,1); //последний символ
  D :=  Copy (B,Length(b)-2,1); //пердпосл символ
  if C = '5' then
    Case D[1] of
        '0','2','4','6','8' : A := ((A * 1000 - 5) / 1000);
        '1','3','5','7','9' : A := ((A * 1000 + 5) / 1000);
    End;
  Result := SimpleRoundTo(A,-2);
end;{GeoRound}

procedure ToCK36(var X, Y: double; DoRound: boolean = false); overload;
var
  X1, Y1: Double;
begin
  ToCK36(X, Y, X1, Y1, DoRound);
  X := X1;
  Y := Y1;
end;

// пересчет из местной в СК-36
procedure ToCK36(const _X, _Y: double; var X, Y: double; DoRound: boolean = false);
var
  v8, v10, v70, v78: Double;
  v30, v28: double;
  St0, St1, st2: Extended;
  var_81, var_101, var_181, var_201, var_281, var_301, var_381, var_401, var_481, var_501, var_581, var_641: double;
  var_82, var_102, var_182, var_202, var_282, var_302, var_382, var_402, var_482, var_542: double;
begin  //ToCK36
  v8 := ((_Y * var_50) + (_X * var_48)) + var_58;
  v10 := ((_Y * var_48) + (_X *  - var_50)) + 514306.708;
  v70 := v8;
  v78 := v10 - const2;
  var_381 := v70 / 6367558.4969;
  var_481 := Sqr(Cos(var_381));
  St1 := ((((cnt1 * var_481) + cnt2) * var_481) + cnt3) * var_481;
  var_641 := (cnt4 * (St1 + cnt5)) * (Sin(var_381));
  var_301 := (cos(var_381) * var_641) + var_381;
  var_401 := Sqr(Cos(var_301));
  St1 := (cnt6 - (cnt7 * var_401)) * var_401;
  St1 := (cnt8 - St1) * var_401;
  var_281 := 6399698.902 - St1;
  var_641 := ((cnt21 * var_401) + const7) * (Sin(var_301));
  var_81 := cos(var_301) * var_641;
  var_101 := const5 - ((const6 - (cnt9 * var_401)) * var_401);
  var_181 := (((0.00562 * var_401) + 0.16161) * var_401) + const4;
  var_201 := (0.2 - ((const6 - (0.0088 * var_401)) * var_401));
  var_501 := v78 / (Cos(var_301) * var_281);
  St0 := (var_181 - ((0.12 * var_501) * var_501));
  St0 := (St0 * var_501) * var_501;
  St0 := ((const3 - St0) * var_501) * var_501;
  v28 := var_301 - (St0 * var_81);
  St0 := var_101 - ((var_201 * var_501) * var_501);
  St0 := const3 - ((St0 * var_501) * var_501);
  var_581 := St0 * var_501;
  v30 := (cnt20 + var_581);
  v28 := v28 * const1;
  v30 := (v30 - cnt10) * const1;
  var_102 := v28 / const1;
  var_482 := Sqr(Cos(var_102));
  St0 := (cnt11 - (cnt7 * var_482)) * var_482;
  St0 := (cnt8 - St0) * var_482;
  var_402 := cnt12 - St0;
  St0 := (7.092e-1 - (const22 * var_482)) * var_482;
  St0 := (1.353302e2 - St0) * var_482;
  var_182 := cnt13 - St0;
  St0 := ((2.52e-3 * var_482) + const4) * var_482;
  var_282 := St0 - 0.04166;
  var_382 := ((const6 * var_482) - 0.084) * var_482;
  St0 := ((cnt9 * var_482) + const5) * var_482;
  var_202 := St0 - const6;
  St0 := ((const22 * var_482) + 0.1968) * var_482;
  St0 := (const6 - St0) * var_482;
  var_302 := 8.3e-3 - St0;
  var_82 := v30 / const1;
  St1 := sin(var_102);
  st2 := Sqr(var_82);
  St0 := var_382 * st2;
  St0 := (St0 + var_282) * st2;
  St0 := (St0 + const7) * st2 * var_402;
  var_542 := (var_182 - St0) * St1;
  St0 := 6.3675584969e6 * var_102;
  v70 := St0 - (cos(var_102) * var_542);
  St0 := (var_302 * st2) + var_202;
  St0 := (St0 * st2) + const3;
  St0 := (St0 * var_82 * var_402) * (cos(var_102));
  v78 := 3000000 + (St0 + const2);
      //готовый Х
  X := v70 - cnt14 - cnt15;
  // готовый У
  Y := ((v78 + cnt16) - const2) - 2000000.0;
  //если передан влаг округления - выполняем округление
  if DoRound then
  begin
    X := GeoRound(X);
    Y := GeoRound(Y);
  end;
end;

procedure ToVRN(const _X, _Y: double; var X, Y: double; DoRound: boolean = false);
var
  edi, esi1: Extended;
  st0, st1, st2: Extended;
  V10, V8, v18, V20, V28, V47C, V68, V70, V78, V80: Extended;
  Var_A0, Var_98, Var_90: Extended;
  Var_B8, var_B0, var_A8: Extended;
  Arg_0_3, Arg_8_3, Arg_10_3, Var_18_3, Var_20_3, Var_28_3, Var_30_3, Var_38_3, Var_40_3, VAr_48_3: extended;
  Var_8_3, Var_10_3, Var_54_3, ebx3, edi3: Extended;
  V_8, V_10, V_18, V_20, V_28, v_30, V_38, V_40, V_48, V_50, V_58, V_64: Extended;
  Var_8: Extended;
begin //  ToVRN
  V8 := _X + cnt15;
  V10 := _Y - 1000000.0;
  V8 := V8 + cnt14;
  V10 := V10 - cnt16;

  V_38 := V8 / Cosn3;
  V_48 := Sqr(Cos(V_38));
  st0 := (((((cnt1 * V_48) + cnt2) * V_48) + cnt3) * V_48) + cnt5;
  V_64 := (st0 * cnt4) * sin(V_38);
  v_30 := (Cos(V_38) * V_64) + V_38;
  V_40 := Sqr(Cos(v_30));
  V_28 := cnt12 - ((Cosn2 - ((cnt11 - (cnt7 * V_40)) * V_40)) * V_40);

{if Assigned(Prog) then
 Prog('V_28', V_28); }

  V_8 := Cos(v_30) * (((V_40 * cnt21) + const7) * Sin(v_30));
  V_10 := const5 - (const6 - (cnt17 * V_40)) * V_40;
  V_18 := ((1.6161e-1 + (5.6198e-3 * V_40)) * V_40) + const4;
  V_20 := 2.0e-1 - ((const6 - (8.79e-3 * V_40)) * V_40);
  V_50 := V10 / (Cos(v_30) * V_28);
  st0 := const3 - ((V_18 - (1.2e-1 * Sqr(V_50))) * Sqr(V_50));
  st0 := (st0 * Sqr(V_50)) * V_8;
  V20 := (((const3 - ((V_10 - (V_20 * Sqr(V_50))) * Sqr(V_50))) * V_50) + cnt10) * const1;
  Var_10_3 := ((v_30 - st0) * const1) / const1;
  VAr_48_3 := Sqr(Cos(Var_10_3));
  Var_40_3 := cnt12 - ((Cosn2 - ((cnt6 - (cnt7 * VAr_48_3)) * VAr_48_3)) * VAr_48_3);
  Var_18_3 := cnt13 - ((1.35330199e2 - ((0.7092 - (cnt18 * VAr_48_3)) * VAr_48_3)) * VAr_48_3);
  Var_28_3 := (((2.52e-3 * VAr_48_3) + const4) * VAr_48_3) - 4.1659e-2;
  Var_38_3 := ((1.66e-1 * VAr_48_3) - 8.4e-2) * VAr_48_3;
  Var_20_3 := ((const5 + (cnt17 * VAr_48_3)) * VAr_48_3) - const6;
  Var_30_3 := 8.29e-3 - ((const6 - (((cnt18 * VAr_48_3) + 1.968e-1) * VAr_48_3)) * VAr_48_3);
  Var_8_3 := (V20 - 140400.000002433) / const1;
  Var_54_3 := (Var_18_3 - ((((((Var_38_3 * Sqr(Var_8_3)) + Var_28_3) * Sqr(Var_8_3)) + const7) * Sqr(Var_8_3)) * Var_40_3)) * Sin(Var_10_3);
  ebx3 := Var_54_3 * (Cos(Var_10_3));
  ebx3 := (Cosn3 * Var_10_3) - ebx3;
  st0 := (((((Var_30_3 * Sqr(Var_8_3)) + Var_20_3) * SQr(Var_8_3)) + const3) * Var_8_3) * Var_40_3;
  edi3 := ((st0 * (Cos(Var_10_3))) + const2) + cnt19;
  V80 := edi3 - cnt19;
  V68 := (V80 * V38) + (ebx3 * v30) + V40;
  V70 := (((V80 * v30) + (ebx3 * abs(V38))) * const3) + V50;
  V68 := 0.425 + V68;  //X   оригинальный коэф был 0.389
  V70 := V70 - 0.080;  //Y  оригинальный коэф был 0.189
  X := V68;
  Y := V70;
    //если передан влаг округления - выполняем округление
  if DoRound then
  begin
    X := GeoRound(X);
    Y := GeoRound(Y);
  end;
end;

procedure ToVRN(var X, Y: double; DoRound: boolean = false);
var
  X1, Y1: Double;
begin
  ToVRN(X, Y, X1, Y1, DoRound);
  X := X1;
  Y := Y1;
end;

end.