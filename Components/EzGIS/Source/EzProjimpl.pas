Unit EzProjImpl;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, EzProjections, Math;

{ implemented projections  }

Procedure airy( P: TEzGeoConvert; init: boolean ); // Airy
Procedure merc( P: TEzGeoConvert; init: boolean ); // Mercator
Procedure tmerc( P: TEzGeoConvert; init: boolean ); // Transverse Mercator
Procedure utm( P: TEzGeoConvert; init: boolean ); // Universal Transverse Mercator (UTM)
Procedure omerc( P: TEzGeoConvert; init: boolean ); // Oblique mercator
Procedure aea( P: TEzGeoConvert; init: boolean ); // Albers Equal Area
Procedure leac( P: TEzGeoConvert; init: boolean ); // Lambert Equal Area Conic
Procedure lcc( P: TEzGeoConvert; init: boolean ); // Lambert Conformal Conic
Procedure bonne( P: TEzGeoConvert; init: boolean ); // Bonne (Werner lat_1=90)
Procedure cass( P: TEzGeoConvert; init: boolean ); // cassini
Procedure cc( P: TEzGeoConvert; init: boolean ); //  central cylindrical
Procedure cea( P: TEzGeoConvert; init: boolean ); // Equal Area Cylindrical
Procedure mill( P: TEzGeoConvert; init: boolean ); // Miller Cylindrical
Procedure moll( P: TEzGeoConvert; init: boolean ); // Mollweide
Procedure wag4( P: TEzGeoConvert; init: boolean ); // Wagner IV
Procedure wag5( P: TEzGeoConvert; init: boolean ); // Wagner V
Procedure eck4( P: TEzGeoConvert; init: boolean ); // Eckert IV
Procedure eck5( P: TEzGeoConvert; init: boolean ); // Eckert IV
Procedure eck6( P: TEzGeoConvert; init: boolean ); // Eckert IV
Procedure sinu( P: TEzGeoConvert; init: boolean );
Procedure gn_sinu( P: TEzGeoConvert; init: boolean );
Procedure mbtfps( P: TEzGeoConvert; init: boolean );
Procedure wag7( P: TEzGeoConvert; init: boolean );
Procedure tpeqd( P: TEzGeoConvert; init: boolean ); // Two Point Equidistant
Procedure tcea( P: TEzGeoConvert; init: boolean ); // Transverse Cylindrical Equal Area
Procedure vandg4( P: TEzGeoConvert; init: boolean ); // van der Grinten IV
Procedure laea( P: TEzGeoConvert; init: boolean ); // Lambert Azimuthal Equal Area
Procedure stere( P: TEzGeoConvert; init: boolean ); //Stereographic
Procedure ups( P: TEzGeoConvert; init: boolean ); //Universal Polar Stereographic
Procedure ortho( P: TEzGeoConvert; init: boolean ); // Orthographic
Procedure imw_p( P: TEzGeoConvert; init: boolean ); // International Map of the World Polyconic
Procedure poly( P: TEzGeoConvert; init: boolean ); // Polyconic (American)

{ general procedures }

//Procedure pj_enfn( P: TEzGeoConvert );
//Function pj_mlfn( phi, sphi, cphi: double; P: TEzGeoConvert ): double;
//Function pj_inv_mlfn( arg: double; P: TEzGeoConvert ): double;
//Function pj_tsfn( phi, sinphi, e: double ): double;
//Function pj_qsfn( sinphi, e, one_es: double ): double;
//Function pj_msfn( sinphi, cosphi, es: double ): double;
Function adjlon( Const lon: double ): double;
//Function pj_phi2( Const ts, e: double ): double;
//Function asqrt( Const v: double ): double;
// determine latitude from authalic latitude
//Procedure pj_authset( P: TEzGeoConvert );
//Function pj_authlat( Const beta: double; P: TEzGeoConvert ): double;

Implementation

{ general procedures }

Const
  ONE_TOL = 1.00000000000001;
  TOL =     0.000000001;
  ATOL =    1E-50;
  SPI =     3.14159265359;
  TWOPI =   6.2831853071795864769;
  HALFPI =  1.5707963267948966;
  TOL2 =    1.0E-10;
  N_ITER =  15;
  EPSILON = 1.0E-7;
  C00 =     1.0;
  C02 =     0.25;
  C04 =     0.046875;
  C06 =     0.01953125;
  C08 =     0.01068115234375;
  C22 =     0.75;
  C44 =     0.46875;
  C46 =     0.01302083333333333333;
  C48 =     0.00712076822916666666;
  C66 =     0.36458333333333333333;
  C68 =     0.00569661458333333333;
  C88 =     0.3076171875;
  EPS11 =   1E-11;
  MAX_ITER = 10;

Resourcestring
  serr0 = 'Inverse conversion not implemented';
  //serr1=	'no arguments in initialization list'; future use
  //serr2=	'no options found in ''init'' file"';
  //serr3=	'no colon in init= string';
  //serr4=	'projection not named';
  //serr5=	'unknown projection id';
  //serr6=	'effective eccentricity = 1.0';
  //serr7=	'unknown unit conversion id';
  //serr8=	'invalid boolean param argument';
  //serr9=	'unknown elliptical parameter name';
  //serr10=	'reciprocal flattening (1/f) = 0';
  //serr11=	'|radius reference latitude| > 90';
  //serr12=	'squared eccentricity < 0';
  //serr13=	'major axis or radius = 0 or not given';
  //serr14=	'latitude or longitude exceeded limits';
  //serr15=	'invalid x or y';
  //serr16=	'improperly formed DMS value';
  //serr17=	'non-convergent inverse meridinal dist';
  serr18 = 'non-convergent inverse phi2';
  serr19 = 'acos/asin: |arg| >1.+1e-14';
  //serr20=	'tolerance condition error';
  //serr21=	'conic lat_1 = -lat_2';
  //serr22=	'lat_1 >= 90';
  serr23 = 'lat_1 = 0';
  serr24 = 'lat_ts >= 90';
  serr25 = 'no distance between control points';
  //serr26=	'projection not selected to be rotated';
  //serr27=	'W <= 0 or M <= 0';
  //serr28=	'lsat not in 1-5 range';
  //serr29=	'path not in range';
  //serr30=	'h <= 0';
  //serr31=	'k <= 0';
  serr32 = 'lat_0 = 0 or 90 or alpha = 90';
  serr33 = 'lat_1=lat_2 or lat_1=0 or lat_2=90';
  serr34 = 'elliptical usage required';
  serr35 = 'invalid UTM zone number';
  serr36 = 'arg(s) out of range for Tcheby eval';
  //serr37=	'failed to find projection to be rotated';
  //serr38=	'failed to load NAD27-83 correction file';
  //serr39=	'both n & m must be spec''d and > 0';
  //serr40=	'n <= 0, n > 1 or not specified';
  //serr41=	'lat_1 or lat_2 not specified';
  //serr42=	'|lat_1| = |lat_2|';
  //serr43=	'lat_0 is pi/2 from mean lat';

  //projection dialog messages
  //SToXY = 'X = %.4f, Y = %.4f';
  //SToLatLong= 'Long = %.5n, Lat = %.5n';
  //SToLatLongCaption= 'Test X,Y to Lon,Lat';


Function adjlon( Const lon: double ): double;
Begin
  result := lon;
  While abs( result ) > SPI Do
    If result < 0 Then
      result := result + TWOPI
    Else
      result := result - TWOPI;
End;

// arc sin, cosine, tan2 and sqrt that will NOT fail
Function aasin( Const v: double ): double;
Var
  av: double;
Begin
  av := abs( v );
  If av >= 1.0 Then
  Begin
    If av > ONE_TOL Then
    Begin
      Raise Exception.Create( serr19 );
      //pj_errno := -19;
      exit;
    End;
    If v < 0 Then
      result := -HALFPI
    Else
      result := HALFPI;
    exit;
  End;
  result := arcsin( v );
End;

Function aacos( Const v: double ): double;
Var
  av: double;
Begin
  av := abs( v );
  If av >= 1.0 Then
  Begin
    If av > ONE_TOL Then
    Begin
      Raise Exception.Create( serr19 );
      //pj_errno := -19;
      exit;
    End;
    If v < 0 Then
      result := PI
    Else
      result := 0;
    exit;
  End;
  result := arccos( v );
End;

Function asqrt( Const v: double ): double;
Begin
  If v <= 0 Then
    result := 0
  Else
    result := sqrt( v );
End;

Function aatan2( Const n, d: double ): double;
Begin
  If ( abs( n ) < ATOL ) And ( abs( d ) < ATOL ) Then
    result := 0
  Else
    result := arctan2( n, d );
End;

Function pj_phi2( Const ts, e: double ): double;
Var
  eccnth, Phi, con, dphi: double;
  i: integer;
Begin
  eccnth := 0.5 * e;
  Phi := HALFPI - 2 * arctan( ts );
  i := N_ITER;
  Repeat
    con := e * sin( Phi );
    dphi := HALFPI - 2 * arctan( ts * power( ( 1 - con ) /
      ( 1 + con ), eccnth ) ) - Phi;
    Phi := Phi + dphi;
    Dec( i );
  Until ( abs( dphi ) <= TOL2 ) Or ( i <= 0 );
  If i <= 0 Then
    Raise Exception.Create( serr18 );
  //pj_errno := -18;
  result := Phi;
End;

Function pj_msfn( sinphi, cosphi, es: double ): double;
Begin
  result := ( cosphi / sqrt( 1 - es * sinphi * sinphi ) );
End;

//---------------------------

Function pj_qsfn( const sinphi, e, one_es: double ): double;
Var
  con: double;
Begin
  If e >= EPSILON Then
  Begin
    con := e * sinphi;
    result := ( one_es * ( sinphi / ( 1 - con * con ) -
      ( 0.5 / e ) * ln( ( 1 - con ) / ( 1 + con ) ) ) );
  End
  Else
    result := sinphi + sinphi;
End;

//---------------------------------------

Function pj_tsfn( const phi, sinphi, e: double ): double;
var
  sinphie: Double;
Begin
  sinphie := sinphi * e;
  result := ( tan( 0.5 * ( HALFPI - phi ) ) /
    power( ( 1.0 - sinphie ) / ( 1.0 + sinphie ), 0.5 * e ) );
End;

//-------------------------------------------------------------------//
(* meridiOnal distance for ellipsoid and inverse
**	8th degree - accurate to < 1e-5 meters when used in conjunction
**		with typical major axis values.
**	Inverse determines phi to EPS (1e-11) radians, about 1e-6 seconds.
*)

Procedure pj_enfn( P: TEzGeoConvert );
Var
  t, es: double;
Begin
  es := P.es;
  P.en[0] := C00 - es * ( C02 + es * ( C04 + es * ( C06 + es * C08 ) ) );
  P.en[1] := es * ( C22 - es * ( C04 + es * ( C06 + es * C08 ) ) );
  t := es * es;
  P.en[2] := t * ( C44 - es * ( C46 + es * C48 ) );
  t := t * es;
  P.en[3] := t * ( C66 - es * C68 );
  P.en[4] := t * es * C88;
End;

Function pj_mlfn( phi, sphi, cphi: double; P: TEzGeoConvert ): double;
Begin
  cphi := cphi * sphi;
  sphi := sphi * sphi;
  result := ( P.en[0] * phi - cphi * ( P.en[1] + sphi * ( P.en[2]
    + sphi * ( P.en[3] + sphi * P.en[4] ) ) ) );
End;

Function pj_inv_mlfn( arg: double; P: TEzGeoConvert ): double;
Var
  s, t, phi, k, es: double;
  i: integer;
Begin
  es := P.es;
  k := 1.0 / ( 1.0 - es );

  phi := arg;
  For i := 1 To MAX_ITER Do
  Begin (* rarely goes over 2 iterations *)
    s := sin( phi );
    t := 1.0 - es * s * s;
    t := ( pj_mlfn( phi, s, cos( phi ), P ) - arg ) * ( t * sqrt( t ) ) * k;
    phi := phi - t;
    If abs( t ) < EPS11 Then
    Begin
      result := phi;
      exit;
    End;
  End;
  //pj_errno := -17;
  result := phi;
End;

Const
  P00 = 0.33333333333333333333;
  P01 = 0.17222222222222222222;
  P02 = 0.10257936507936507936;
  P10 = 0.06388888888888888888;
  P11 = 0.06640211640211640211;
  P20 = 0.01641501294219154443;

Procedure pj_authset( P: TEzGeoConvert );
Var
  t: double;
  es: double;
Begin
  es := P.es;
  P.APA[0] := es * P00;
  t := es * es;
  P.APA[0] := P.APA[0] + ( t * P01 );
  P.APA[1] := t * P10;
  t := t * es;
  P.APA[0] := P.APA[0] + ( t * P02 );
  P.APA[1] := P.APA[1] + ( t * P11 );
  P.APA[2] := P.APA[2] + ( t * P20 );
End;

Function pj_authlat( Const beta: double; P: TEzGeoConvert ): double;
Var
  t: double;
Begin
  t := beta + beta;
  result := beta + P.APA[0] * sin( t ) + P.APA[1] * sin( t + t ) + P.APA[2] * sin( t + t + t );
End;

{ ***************** airy - Airy ***************** }

Const
  EPS = 1.E-10;
  N_POLE = 0;
  S_POLE = 1;
  EQUIT = 2;
  OBLIQ = 3;

Function s_forward_airy( lp: TLP; P: TEzGeoConvert ): TXY; (* spheroid *)
Var
  xy: TXY;
  sinlam, coslam, cosphi, sinphi, t, s, Krho, cosz: double;
Begin
  sinlam := sin( lp.lam );
  coslam := cos( lp.lam );
  Case P.mode Of
    EQUIT, OBLIQ:
      Begin
        sinphi := sin( lp.phi );
        cosphi := cos( lp.phi );
        cosz := cosphi * coslam;
        If P.mode = OBLIQ Then
          cosz := P.sinph0 * sinphi + P.cosph0 * cosz;
        If ( P.no_cut = false ) And ( cosz < -EPS ) Then
        Begin
          P.pj_errno := -20;
          result := xy;
          exit;
        End;
        s := 1 - cosz;
        If abs( s ) > EPS Then
        Begin
          t := 0.5 * ( 1 + cosz );
          Krho := -ln( t ) / s - P.Cb / t;
        End
        Else
          Krho := 0.5 - P.Cb;
        xy.x := Krho * cosphi * sinlam;
        If P.mode = OBLIQ Then
          xy.y := Krho * ( P.cosph0 * sinphi - P.sinph0 * cosphi * coslam )
        Else
          xy.y := Krho * sinphi;
      End;
    S_POLE, N_POLE:
      Begin
        lp.phi := abs( P.p_halfpi - lp.phi );
        If ( P.no_cut = false ) And ( ( lp.phi - EPS ) > HALFPI ) Then
        Begin
          P.pj_errno := -20;
          result := xy;
          exit;
        End;
        lp.phi := lp.phi * 0.5;
        If lp.phi > EPS Then
        Begin
          t := tan( lp.phi );
          Krho := -2 * ( ln( cos( lp.phi ) ) / t + t * P.Cb );
          xy.x := Krho * sinlam;
          xy.y := Krho * coslam;
          If P.mode = N_POLE Then
            xy.y := -xy.y
        End
        Else
        Begin
          xy.y := 0;
          xy.x := 0;
        End;
      End;
  End;
  result := xy;
End;

Procedure airy( P: TEzGeoConvert; init: boolean );
Var
  beta: double;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  P.no_cut := P.pj_param.asboolean( 'no_cut' );
  beta := 0.5 * ( HALFPI - P.pj_param.asradians( 'lat_b' ) );
  If abs( beta ) < EPS Then
    P.Cb := -0.5
  Else
  Begin
    P.Cb := 1 / tan( beta );
    P.Cb := P.Cb * P.Cb * ln( cos( beta ) );
  End;
  If abs( abs( P.phi0 ) - HALFPI ) < EPS Then
  Begin
    If P.phi0 < 0 Then
    Begin
      P.p_halfpi := -HALFPI;
      P.mode := S_POLE;
    End
    Else
    Begin
      P.p_halfpi := HALFPI;
      P.mode := N_POLE;
    End;
  End
  Else
  Begin
    If abs( P.phi0 ) < EPS Then
      P.mode := EQUIT
    Else
    Begin
      P.mode := OBLIQ;
      P.sinph0 := sin( P.phi0 );
      P.cosph0 := cos( P.phi0 );
    End;
  End;
  P.fwd := @s_forward_airy;
  P.es := 0;

End;

{ ***************** merc - Mercator ***************** }

Const
  EPS10 = 1.E-10;

Function e_forward_merc( const lp: TLP; P: TEzGeoConvert ): TXY; (* ellipsoid *)
Var
  xy: TXY;
Begin
  If abs( abs( lp.phi ) - HALFPI ) <= EPS10 Then
  Begin
    P.pj_errno := -20;
    result := xy;
    exit;
  End;
  xy.x := P.k0 * lp.lam;
  xy.y := -P.k0 * ln( pj_tsfn( lp.phi, sin( lp.phi ), P.e ) );
  result := xy;
End;

Function s_forward_merc( const lp: TLP; P: TEzGeoConvert ): TXY; (* spheroid *)
Var
  xy: TXY;
Begin
  If abs( abs( lp.phi ) - HALFPI ) <= EPS10 Then
  Begin
    P.pj_errno := -20;
    result := xy;
    exit;
  End;
  xy.x := P.k0 * lp.lam;
  xy.y := P.k0 * ln( tan( FORTPI + 0.5 * lp.phi ) );
  result := xy;
End;

Function e_inverse_merc( const xy: TXY; P: TEzGeoConvert ): TLP; (* ellipsoid *)
Var
  lp: TLP;
Begin
  lp.phi := pj_phi2( exp( -xy.y / P.k0 ), P.e );
  If lp.phi = HUGE_VAL Then
  Begin
    P.pj_errno := -20;
    result := lp;
    exit;
  End;
  lp.lam := xy.x / P.k0;
  result := lp;
End;

Function s_inverse_merc( const xy: TXY; P: TEzGeoConvert ): TLP; (* spheroid *)
Begin
  result.phi := HALFPI - 2 * arctan( exp( -xy.y / P.k0 ) );
  result.lam := xy.x / P.k0;
End;

Procedure merc( P: TEzGeoConvert; init: boolean );
Var
  phits: double;
  is_phits: boolean;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  is_phits := P.pj_param.defined( 'lat_ts' );
  phits := 0;
  If is_phits Then
  Begin
    phits := abs( P.pj_param.asradians( 'lat_ts' ) );
    If phits >= HALFPI Then
    Begin
      P.pj_errno := -24;
      exit;
    End;
  End;
  If P.es <> 0 Then
  Begin (* ellipsoid *)
    If is_phits Then
      P.k0 := pj_msfn( sin( phits ), cos( phits ), P.es );
    P.inv := @e_inverse_merc;
    P.fwd := @e_forward_merc;
  End
  Else
  Begin (* sphere *)
    If is_phits Then
      P.k0 := cos( phits );
    P.inv := @s_inverse_merc;
    P.fwd := @s_forward_merc;
  End;
End;

{ ***************** tmerc - Traverse Mercator ***************** }

Const
  FC1 = 1.0;
  FC2 = 0.5;
  FC3 = 0.16666666666666666666;
  FC4 = 0.08333333333333333333;
  FC5 = 0.05;
  FC6 = 0.03333333333333333333;
  FC7 = 0.02380952380952380952;
  FC8 = 0.01785714285714285714;

Function e_forward_tmerc( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipse
Var
  xy: TXY;
  al, als, n, cosphi, sinphi, t: double;
Begin
  sinphi := sin( lp.phi );
  cosphi := cos( lp.phi );
  If abs( cosphi ) > 1E-10 Then
    t := sinphi / cosphi
  Else
    t := 0;
  t := t * t;
  al := cosphi * lp.lam;
  als := al * al;
  al := al / sqrt( 1.0 - P.es * sinphi * sinphi );
  n := P.esp * cosphi * cosphi;
  xy.x := P.k0 * al * ( FC1 +
    FC3 * als * ( 1.0 - t + n +
    FC5 * als * ( 5.0 + t * ( t - 18 ) + n * ( 14.0 - 58.0 * t )
    + FC7 * als * ( 61.0 + t * ( t * ( 179.0 - t ) - 479.0 ) ) ) ) );
  xy.y := P.k0 * ( pj_mlfn( lp.phi, sinphi, cosphi, P ) - P.ml0 +
    sinphi * al * lp.lam * FC2 * ( 1.0 +
    FC4 * als * ( 5.0 - t + n * ( 9.0 + 4.0 * n ) +
    FC6 * als * ( 61.0 + t * ( t - 58.0 ) + n * ( 270.0 - 330 * t ) + FC8 * als * ( 1385.0 + t * ( t * ( 543.0 - t ) - 3111.0 )
      ) ) ) ) );
  result := xy;
End;

Function s_forward_tmerc( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
  b, cosphi: double;
Begin
  cosphi := cos( lp.phi );
  b := cosphi * sin( lp.lam );
  If abs( abs( b ) - 1.0 ) <= EPS10 Then
  Begin
    P.pj_errno := -20;
    result := xy;
    exit;
  End;
  xy.x := P.ml0 * ln( ( 1.0 + b ) / ( 1.0 - b ) ); //falta checar funcion log
  xy.y := cosphi * cos( lp.lam ) / sqrt( 1.0 - b * b );
  b := abs( xy.y );
  If b >= 1.0 Then
  Begin
    If ( b - 1.0 ) > EPS10 Then
    Begin
      P.pj_errno := -20;
      result := xy;
      exit;
    End
    Else
      xy.y := 0.0;
  End
  Else
    xy.y := arccos( xy.y );
  If lp.phi < 0 Then
    xy.y := -xy.y;
  xy.y := P.esp * ( xy.y - P.phi0 );
  result := xy;
End;

Function e_inverse_tmerc( const xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  lp: TLP;
  n, con, cosphi, d, ds, sinphi, t: double;
Begin
  lp.phi := pj_inv_mlfn( P.ml0 + xy.y / P.k0, P );
  If abs( lp.phi ) >= HALFPI Then
  Begin
    If xy.y < 0.0 Then
      lp.phi := -HALFPI
    Else
      lp.phi := HALFPI;
    lp.lam := 0.0;
  End
  Else
  Begin
    sinphi := sin( lp.phi );
    cosphi := cos( lp.phi );
    If abs( cosphi ) > 1E-10 Then
      t := sinphi / cosphi
    Else
      t := 0;
    n := P.esp * cosphi * cosphi;
    con := 1.0 - P.es * sinphi * sinphi;
    d := xy.x * sqrt( con ) / P.k0;
    con := con * t;
    t := t * t;
    ds := d * d;
    lp.phi := lp.phi - ( con * ds / ( 1.0 - P.es ) ) * FC2 * ( 1.0 -
      ds * FC4 * ( 5.0 + t * ( 3.0 - 9.0 * n ) + n * ( 1.0 - 4 * n ) -
      ds * FC6 * ( 61.0 + t * ( 90.0 - 252.0 * n +
      45.0 * t ) + 46.0 * n - ds * FC8 * ( 1385.0 + t * ( 3633.0 + t * ( 4095.0 + 1574.0 * t ) ) ) ) ) );
    lp.lam := d * ( FC1 - ds * FC3 * ( 1.0 + 2. * t + n - ds * FC5 * ( 5.0 + t * ( 28.0 + 24.0 * t + 8. * n ) + 6.0 * n
      - ds * FC7 * ( 61.0 + t * ( 662.0 + t * ( 1320.0 + 720.0 * t ) ) ) ) ) ) / cosphi;
  End;
  result := lp;
End;

Function s_inverse_tmerc( const xy: TXY; P: TEzGeoConvert ): TLP; // sphere
Var
  lp: TLP;
  h, g: double;
Begin
  h := exp( xy.x / P.esp );
  g := 0.5 * ( h - 1.0 / h );
  h := cos( P.phi0 + xy.y / P.esp );
  lp.phi := arcsin( sqrt( ( 1.0 - h * h ) / ( 1.0 + g * g ) ) );
  If xy.y < 0 Then
    lp.phi := -lp.phi;
  If ( g <> 0 ) And ( h <> 0 ) Then
    lp.lam := arctan2( g, h )
  Else
    lp.lam := 0;
  result := lp;
End;

Procedure setup_tmerc( P: TEzGeoConvert );
Begin
  If P.es <> 0 Then
  Begin
    pj_enfn( P );
    P.ml0 := pj_mlfn( P.phi0, sin( P.phi0 ), cos( P.phi0 ), P );
    P.esp := P.es / ( 1.0 - P.es );
    P.inv := @e_inverse_tmerc;
    P.fwd := @e_forward_tmerc;
  End
  Else
  Begin
    P.esp := P.k0;
    P.ml0 := 0.5 * P.esp;
    P.inv := @s_inverse_tmerc;
    P.fwd := @s_forward_tmerc;
  End;
End;

Procedure tmerc( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  setup_tmerc( P );
End;

Procedure utm( P: TEzGeoConvert; init: boolean );
Var
  zone: integer;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  If p.es = 0 Then
    Raise Exception.Create( SErr34 );
  If P.pj_param.asboolean( 'south' ) Then
    p.y0 := 10000000.0
  Else
    p.y0 := 0;
  p.x0 := 500000.;
  If P.pj_param.defined( 'zone' ) Then
  Begin //* zone input ? */
    zone := P.pj_param.asinteger( 'zone' );
    If ( zone > 0 ) And ( zone <= 60 ) Then
      Dec( zone )
    Else
      Raise Exception.Create( SErr35 );
  End
  Else
  Begin //* nearest central meridian input */
    zone := floor( ( adjlon( P.lam0 ) + PI ) * 30. / PI );
    If zone < 0 Then
      zone := 0
    Else If zone >= 60 Then
      zone := 59;
  End;
  p.lam0 := ( zone + 0.5 ) * PI / 30.0 - PI;
  p.k0 := 0.9996;
  p.phi0 := 0.0;

  setup_tmerc( P );
End;

{ ***************** omerc - oblique mercator ***************** }

Const
  TOL7 = 1.0E-7;

Function TSFN0( Const x: double ): double;
Begin
  result := tan( 0.5 * ( HALFPI - x ) );
End;

Function omerc_forward( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid & spheroid */
Var
  con, q, s, ul, us, vl, vs, temp: double;
  xy: TXY;
Begin
  vl := sin( P.bl * lp.lam );
  If ( abs( abs( lp.phi ) - HALFPI ) <= EPS ) Then
  Begin
    If lp.phi < 0 Then
      ul := -P.singam
    Else
      ul := P.singam;
    us := P.al * lp.phi / P.bl;
  End
  Else
  Begin
    If P.ellips Then
      temp := power( pj_tsfn( lp.phi, sin( lp.phi ), P.e ), P.bl )
    Else
      temp := TSFN0( lp.phi );
    q := P.el / temp;
    s := 0.5 * ( q - 1 / q );
    ul := 2 * ( s * P.singam - vl * P.cosgam ) / ( q + 1 / q );
    con := cos( P.bl * lp.lam );
    If ( abs( con ) >= TOL7 ) Then
    Begin
      us := P.al * arctan( ( s * P.cosgam + vl * P.singam ) / con ) / P.bl;
      If ( con < 0 ) Then
        us := us + PI * P.al / P.bl;
    End
    Else
      us := P.al * P.bl * lp.lam;
  End;
  If ( abs( abs( ul ) - 1 ) <= EPS ) Then
    exit; //F_ERROR;
  vs := 0.5 * P.al * ln( ( 1 - ul ) / ( 1 + ul ) ) / P.bl; // falta checar si log = ln
  us := us - P.u_0;
  If P.rot Then
  Begin
    xy.x := us;
    xy.y := vs;
  End
  Else
  Begin
    xy.x := vs * P.cosrot + us * P.sinrot;
    xy.y := us * P.cosrot - vs * P.sinrot;
  End;
  result := xy;
End;

Function omerc_inverse( const xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid & spheroid */
Var
  q, s, ul, us, vl, vs: double;
  lp: TLP;
Begin
  If P.rot Then
  Begin
    us := xy.x;
    vs := xy.y;
  End
  Else
  Begin
    vs := xy.x * P.cosrot - xy.y * P.sinrot;
    us := xy.y * P.cosrot + xy.x * P.sinrot;
  End;
  us := us + P.u_0;
  q := exp( -P.bl * vs / P.al );
  s := 0.5 * ( q - 1 / q );
  vl := sin( P.bl * us / P.al );
  ul := 2 * ( vl * P.cosgam + s * P.singam ) / ( q + 1 / q );
  If ( abs( abs( ul ) - 1 ) < EPS ) Then
  Begin
    lp.lam := 0;
    If ul < 0 Then
      lp.phi := -HALFPI
    Else
      lp.phi := HALFPI;
  End
  Else
  Begin
    lp.phi := P.el / sqrt( ( 1 + ul ) / ( 1 - ul ) );
    If P.ellips Then
    Begin
      lp.phi := pj_phi2( power( lp.phi, 1 / P.bl ), P.e );
      If ( lp.phi = HUGE_VAL ) Then
        exit; // I_ERROR;
    End
    Else
      lp.phi := HALFPI - 2 * abs( lp.phi );
    lp.lam := -aatan2( ( s * P.cosgam - vl * P.singam ), cos( P.bl * us / P.al ) ) / P.bl;
  End;
  result := lp;
End;

Procedure omerc( P: TEzGeoConvert; init: boolean );
Var
  con, com, cosph0, d, f, h, l, sinph0, pd, j: double;
  azi: boolean;
Begin
  P.rot := P.pj_param.asboolean( 'no_rot' ) = false;
  azi := P.pj_param.defined( 'alpha' );
  If azi Then
  Begin
    P.lamc := P.pj_param.asradians( 'lonc' );
    P.alpha := P.pj_param.asradians( 'alpha' );
    If ( ( abs( P.alpha ) <= TOL7 ) Or
      ( abs( abs( P.phi0 ) - HALFPI ) <= TOL7 ) Or
      ( abs( abs( P.alpha ) - HALFPI ) <= TOL7 ) ) Then
      Raise Exception.Create( SErr32 );
    //E_ERROR(-32);
  End
  Else
  Begin
    P.lam1 := P.pj_param.asradians( 'lon_1' );
    P.phi1 := P.pj_param.asradians( 'lat_1' );
    P.lam2 := P.pj_param.asradians( 'lon_2' );
    P.phi2 := P.pj_param.asradians( 'lat_2' );
    con := abs( P.phi1 );
    If ( ( abs( P.phi1 - P.phi2 ) <= TOL7 ) Or
      ( con <= TOL7 ) Or
      ( abs( con - HALFPI ) <= TOL7 ) Or
      ( abs( abs( P.phi0 ) - HALFPI ) <= TOL7 ) Or
      ( abs( abs( P.phi2 ) - HALFPI ) <= TOL7 ) ) Then
      Raise Exception.Create( SErr33 );
    //  E_ERROR(-33);
  End;
  P.ellips := P.es > 0;
  If P.ellips Then
    com := sqrt( P.one_es )
  Else
    com := 1;
  If abs( P.phi0 ) > EPS Then
  Begin
    sinph0 := sin( P.phi0 );
    cosph0 := cos( P.phi0 );
    If ( P.ellips ) Then
    Begin
      con := 1 - P.es * sinph0 * sinph0;
      P.bl := cosph0 * cosph0;
      P.bl := sqrt( 1 + P.es * P.bl * P.bl / P.one_es );
      P.al := P.bl * P.k0 * com / con;
      d := P.bl * com / ( cosph0 * sqrt( con ) );
    End
    Else
    Begin
      P.bl := 1;
      P.al := P.k0;
      d := 1 / cosph0;
    End;
    f := d * d - 1;
    If ( f <= 0 ) Then
      f := 0
    Else
    Begin
      f := sqrt( f );
      If ( P.phi0 < 0 ) Then
        f := -f;
    End;
    f := f + d;
    P.el := f;
    If ( P.ellips ) Then
      P.el := P.el * power( pj_tsfn( P.phi0, sinph0, P.e ), P.bl )
    Else
      P.el := P.el * TSFN0( P.phi0 );
  End
  Else
  Begin
    P.bl := 1 / com;
    P.al := P.k0;
    f := 1;
    d := 1;
    P.el := 1;
  End;
  If azi Then
  Begin
    P.Gamma := arcsin( sin( P.alpha ) / d );
    P.lam0 := P.lamc - arcsin( ( 0.5 * ( f - 1 / f ) ) * tan( P.Gamma ) ) / P.bl;
  End
  Else
  Begin
    If P.ellips Then
    Begin
      h := power( pj_tsfn( P.phi1, sin( P.phi1 ), P.e ), P.bl );
      l := power( pj_tsfn( P.phi2, sin( P.phi2 ), P.e ), P.bl );
    End
    Else
    Begin
      h := TSFN0( P.phi1 );
      l := TSFN0( P.phi2 );
    End;
    f := P.el / h;
    pd := ( l - h ) / ( l + h );
    j := P.el * P.el;
    j := ( j - l * h ) / ( j + l * h );
    con := P.lam1 - P.lam2;
    If ( con < -PI ) Then
      P.lam2 := P.lam2 - TWOPI
    Else If ( con > PI ) Then
      P.lam2 := P.lam2 + TWOPI;
    P.lam0 := adjlon( 0.5 * ( P.lam1 + P.lam2 ) - arctan(
      j * tan( 0.5 * P.bl * ( P.lam1 - P.lam2 ) ) / pd ) / P.bl );
    P.Gamma := arctan( 2 * sin( P.bl * adjlon( P.lam1 - P.lam0 ) ) /
      ( f - 1 / f ) );
    P.alpha := arcsin( d * sin( P.Gamma ) );
  End;
  P.singam := sin( P.Gamma );
  P.cosgam := cos( P.Gamma );
  If P.pj_param.asboolean( 'rot_conv' ) Then
    f := P.Gamma
  Else
    f := P.alpha;
  P.sinrot := sin( f );
  P.cosrot := cos( f );
  If P.pj_param.asboolean( 'no_uoff' ) Then
    P.u_0 := 0
  Else
    P.u_0 := abs( P.al * arctan( sqrt( d * d - 1 ) / P.cosrot ) / P.bl );
  If P.phi0 < 0 Then
    P.u_0 := -P.u_0;
  P.inv := @omerc_inverse;
  P.fwd := @omerc_forward;
End;

{ ***************** aea - Albers Equal Area *****************}

// determine latitude angle phi-1
Const
  TOL10 = 1.0E-10;

Function phi1_( Const qs, Te, Tone_es: double ): double;
Var
  i: integer;
  Phi, sinpi, cospi, con, com, dphi: double;
Begin
  Phi := arcsin( 0.5 * qs );
  If Te < EPSILON Then
  Begin
    result := Phi;
    exit;
  End;
  i := N_ITER;
  Repeat
    sinpi := sin( Phi );
    cospi := cos( Phi );
    con := Te * sinpi;
    com := 1.0 - con * con;
    dphi := 0.5 * com * com / cospi * ( qs / Tone_es -
      sinpi / com + 0.5 / Te * ln( ( 1.0 - con ) / ( 1.0 + con ) ) );
    Phi := Phi + dphi;
  Until ( abs( dphi ) <= TOL10 ) Or ( i <= 0 );
  If i > 0 Then
    result := Phi
  Else
    result := HUGE_VAL;
End;

Function e_forward_aea( lp: TLP; P: TEzGeoConvert ): TXY; (* ellipsoid & spheroid *)
Var
  tmp: double;
  xy: TXY;
Begin
  If P.ellips Then
    tmp := P.n * pj_qsfn( sin( lp.phi ), P.e, P.one_es )
  Else
    tmp := P.n2 * sin( lp.phi );
  P.rho := P.c - tmp;
  If P.rho < 0 Then
  Begin
    P.pj_errno := -20;
    result := xy;
    exit;
  End;
  P.rho := P.dd * sqrt( P.rho );
  lp.lam := lp.lam * P.n;
  xy.x := P.rho * sin( lp.lam );
  xy.y := P.rho0 - P.rho * cos( lp.lam );
  result := xy;
End;

Function e_inverse_aea( xy: TXY; P: TEzGeoConvert ): TLP; (* ellipsoid & spheroid *)
Var
  lp: TLP;
Begin
  xy.y := P.rho0 - xy.y;
  P.rho := hypot( xy.x, xy.y );
  If P.rho <> 0 Then
  Begin
    If P.n < 0 Then
    Begin
      P.rho := -P.rho;
      xy.x := -xy.x;
      xy.y := -xy.y;
    End;
    lp.phi := P.rho / P.dd;
    If P.ellips Then
    Begin
      lp.phi := ( P.c - lp.phi * lp.phi ) / P.n;
      If abs( P.ec - abs( lp.phi ) ) > TOL7 Then
      Begin
        lp.phi := phi1_( lp.phi, P.e, P.one_es );
        If lp.phi = HUGE_VAL Then
        Begin
          P.pj_errno := -20;
          result := lp;
          exit;
        End;
      End
      Else
      Begin
        If lp.phi < 0 Then
          lp.phi := -HALFPI
        Else
          lp.phi := HALFPI;
      End;
    End;
    lp.phi := ( P.c - lp.phi * lp.phi ) / P.n2;
    If abs( lp.phi ) <= 1 Then
    Begin
      lp.phi := arcsin( lp.phi );
    End
    Else
    Begin
      If lp.phi < 0 Then
        lp.phi := -HALFPI
      Else
        lp.phi := HALFPI;
    End;
    lp.lam := arctan2( xy.x, xy.y ) / P.n;
  End
  Else
  Begin
    lp.lam := 0;
    If P.n > 0 Then
      lp.phi := HALFPI
    Else
      lp.phi := -HALFPI;
  End;
  result := lp;
End;

Procedure setup_aea( P: TEzGeoConvert );
Var
  cosphi, sinphi: double;
  secant: boolean;
  ml1, m1: double;
  ml2, m2: double;
Begin
  If abs( P.phi1 + P.phi2 ) < EPS10 Then
  Begin
    P.pj_errno := -21;
    exit;
  End;
  sinphi := sin( P.phi1 );
  P.n := sinphi;
  cosphi := cos( P.phi1 );
  secant := abs( P.phi1 - P.phi2 ) >= EPS10;
  P.ellips := P.es > 0;
  If P.ellips Then
  Begin
    pj_enfn( P );
    m1 := pj_msfn( sinphi, cosphi, P.es );
    ml1 := pj_qsfn( sinphi, P.e, P.one_es );
    If secant Then
    Begin (* secant cone *)
      sinphi := sin( P.phi2 );
      cosphi := cos( P.phi2 );
      m2 := pj_msfn( sinphi, cosphi, P.es );
      ml2 := pj_qsfn( sinphi, P.e, P.one_es );
      P.n := ( m1 * m1 - m2 * m2 ) / ( ml2 - ml1 );
    End;
    P.ec := 1 - 0.5 * P.one_es * ln( ( 1 - P.e ) /
      ( 1 + P.e ) ) / P.e;
    P.c := m1 * m1 + P.n * ml1;
    P.dd := 1 / P.n;
    P.rho0 := P.dd * sqrt( P.c - P.n * pj_qsfn( sin( P.phi0 ),
      P.e, P.one_es ) );
  End
  Else
  Begin
    If secant Then
      P.n := 0.5 * ( P.n + sin( P.phi2 ) );
    P.n2 := P.n + P.n;
    P.c := cosphi * cosphi + P.n2 * sinphi;
    P.dd := 1 / P.n;
    P.rho0 := P.dd * sqrt( P.c - P.n2 * sin( P.phi0 ) );
  End;
  P.inv := @e_inverse_aea;
  P.fwd := @e_forward_aea;
End;

Procedure aea( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  P.phi1 := P.pj_param.AsRadians( 'lat_1' );
  P.phi2 := P.pj_param.AsRadians( 'lat_2' );

  setup_aea( P );
End;

Procedure leac( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  P.phi2 := P.pj_param.asradians( 'lat_1' );
  If P.pj_param.AsBoolean( 'south' ) Then
    P.phi1 := -HALFPI
  Else
    P.phi1 := HALFPI;

  setup_aea( P );
End;

{ lcc - Lambert Conformal Conic }

Function e_forward_lcc( lp: TLP; P: TEzGeoConvert ): TXY; (* ellipsoid & spheroid *)
Var
  xy: TXY;
  tmp: double;
Begin
  If abs( abs( lp.phi ) - HALFPI ) < EPS10 Then
  Begin
    If ( lp.phi * P.n ) <= 0 Then
    Begin
      P.pj_errno := -20;
      result := xy;
      exit;
    End;
    P.rho := 0;
  End
  Else
  Begin
    If P.ellips Then
      tmp := power( pj_tsfn( lp.phi, sin( lp.phi ), P.e ), P.n )
    Else
      tmp := power( tan( FORTPI + 0.5 * lp.phi ), -P.n );
    P.rho := P.c * tmp;
  End;
  lp.lam := lp.lam * P.n;
  xy.x := P.k0 * ( P.rho * sin( lp.lam ) );
  xy.y := P.k0 * ( P.rho0 - P.rho * cos( lp.lam ) );
  result := xy;
End;

Function e_inverse_lcc( xy: TXY; P: TEzGeoConvert ): TLP; (* ellipsoid & spheroid *)
Var
  lp: TLP;
Begin
  xy.x := xy.x / P.k0;
  xy.y := xy.y / P.k0;
  xy.y := P.rho0 - xy.y;
  P.rho := hypot( xy.x, xy.y );
  If P.rho <> 0 Then
  Begin
    If P.n < 0 Then
    Begin
      P.rho := -P.rho;
      xy.x := -xy.x;
      xy.y := -xy.y;
    End;
    If P.ellips Then
    Begin
      lp.phi := pj_phi2( power( P.rho / P.c, 1 / P.n ), P.e );
      If lp.phi = HUGE_VAL Then
      Begin
        P.pj_errno := -20;
        result := lp;
        exit;
      End;
    End
    Else
      lp.phi := 2 * arctan( power( P.c / P.rho, 1 / P.n ) ) - HALFPI;
    lp.lam := arctan2( xy.x, xy.y ) / P.n;
  End
  Else
  Begin
    lp.lam := 0;
    If P.n > 0 Then
      lp.phi := HALFPI
    Else
      lp.phi := -HALFPI;
  End;
  result := lp;
End;

Procedure factors( const lp: TLP; P: TEzGeoConvert; Var fac: TFACTORS );
Var
  tmp: double;
Begin
  If abs( abs( lp.phi ) - HALFPI ) < EPS10 Then
  Begin
    If ( lp.phi * P.n ) <= 0 Then
      exit;
    P.rho := 0;
  End
  Else
  Begin
    If P.ellips Then
      tmp := power( pj_tsfn( lp.phi, sin( lp.phi ), P.e ), P.n )
    Else
      tmp := power( tan( FORTPI + 0.5 * lp.phi ), -P.n );
    P.rho := P.c * tmp;
  End;
  fac.code := fac.code Or ( IS_ANAL_HK + IS_ANAL_CONV );
  fac.h := P.k0 * P.n * P.rho / pj_msfn( sin( lp.phi ), cos( lp.phi ), P.es );
  fac.k := fac.h;
  fac.conv := -P.n * lp.lam;
End;

Procedure lcc( P: TEzGeoConvert; init: boolean );
Var
  cosphi, sinphi: double;
  secant: boolean;
  ml1, m1, tmp: double;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  P.phi1 := P.pj_param.asradians( 'lat_1' );
  If P.pj_param.defined( 'lat_2' ) Then
    P.phi2 := P.pj_param.asradians( 'lat_2' )
  Else
  Begin
    P.phi2 := P.phi1;
    If Not P.pj_param.defined( 'lat_0' ) Then
      P.phi0 := P.phi1;
  End;
  If abs( P.phi1 + P.phi2 ) < EPS10 Then
  Begin
    P.pj_errno := -21;
    exit;
  End;
  sinphi := sin( P.phi1 );
  P.n := sinphi;
  cosphi := cos( P.phi1 );
  secant := abs( P.phi1 - P.phi2 ) >= EPS10;
  P.ellips := P.es <> 0;
  If P.ellips Then
  Begin
    P.e := sqrt( P.es );
    m1 := pj_msfn( sinphi, cosphi, P.es );
    ml1 := pj_tsfn( P.phi1, sinphi, P.e );
    If secant Then
    Begin (* secant cone *)
      sinphi := sin( P.phi2 );
      P.n := ln( m1 / pj_msfn( sinphi, cos( P.phi2 ), P.es ) );
      P.n := P.n / ln( ml1 / pj_tsfn( P.phi2, sinphi, P.e ) );
    End;
    P.rho0 := m1 * power( ml1, -P.n ) / P.n;
    P.c := P.rho0;
    If abs( abs( P.phi0 ) - HALFPI ) < EPS10 Then
      tmp := 0
    Else
      tmp := power( pj_tsfn( P.phi0, sin( P.phi0 ), P.e ), P.n );
    P.rho0 := P.rho0 * tmp;
  End
  Else
  Begin
    If secant Then
      P.n := ln( cosphi / cos( P.phi2 ) ) /
        ln( tan( FORTPI + 0.5 * P.phi2 ) /
        tan( FORTPI + 0.5 * P.phi1 ) );
    P.c := cosphi * power( tan( FORTPI + 0.5 * P.phi1 ), P.n ) / P.n;
    If abs( abs( P.phi0 ) - HALFPI ) < EPS10 Then
      tmp := 0
    Else
      tmp := P.c * power( tan( FORTPI + 0.5 * P.phi0 ), -P.n );
    P.rho0 := tmp;
  End;
  P.inv := @e_inverse_lcc;
  P.fwd := @e_forward_lcc;
  P.spc := @factors;

End;

{ bonne - Bonne (Werner lat_1=90)}

Function e_forward_bonne( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid
Var
  rh, E, c: double;
  xy: TXY;
Begin
  E := sin( lp.phi );
  c := cos( lp.phi );
  rh := P.am1 + P.m1 - pj_mlfn( lp.phi, E, c, P );
  E := c * lp.lam / ( rh * sqrt( 1.0 - P.es * E * E ) );
  xy.x := rh * sin( E );
  xy.y := P.am1 - rh * cos( E );
  result := xy;
End;

Function s_forward_bonne( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  E, rh: double;
  xy: TXY;
Begin
  rh := P.cphi1 + P.phi1 - lp.phi;
  If ( abs( rh ) > EPS10 ) Then
  Begin
    E := lp.lam * cos( lp.phi ) / rh;
    xy.x := rh * sin( E );
    xy.y := P.cphi1 - rh * cos( E );
  End
  Else
  Begin
    xy.y := 0.0;
    xy.x := 0.0;
  End;
  result := xy;
End;

Function s_inverse_bonne( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  rh: double;
  lp: TLP;
Begin
  xy.y := P.cphi1 - xy.y;
  rh := hypot( xy.x, xy.y );
  lp.phi := P.cphi1 + P.phi1 - rh;
  If abs( lp.phi ) > HALFPI Then
    Raise Exception.Create( 'Error' );
  If abs( abs( lp.phi ) - HALFPI ) <= EPS10 Then
    lp.lam := 0.0
  Else
    lp.lam := rh * aatan2( xy.x, xy.y ) / cos( lp.phi );
  result := lp;
End;

Function e_inverse_bonne( xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  s, rh: double;
  lp: TLP;
Begin
  xy.y := P.am1 - xy.y;
  rh := hypot( xy.x, xy.y );
  lp.phi := pj_inv_mlfn( P.am1 + P.m1 - rh, P );
  s := abs( lp.phi );
  If s < HALFPI Then
  Begin
    s := sin( lp.phi );
    lp.lam := rh * aatan2( xy.x, xy.y ) * sqrt( 1.0 - P.es * s * s ) / cos( lp.phi );
  End
  Else If abs( s - HALFPI ) <= EPS10 Then
    lp.lam := 0.0
  Else
    Raise Exception.Create( 'Error' );
  result := lp;
End;

Procedure bonne( P: TEzGeoConvert; init: boolean );
Var
  c: double;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.phi1 := P.pj_param.asradians( 'lat_1' );
  If abs( P.phi1 ) < EPS10 Then
    Raise Exception.Create( SErr23 );
  If P.es <> 0 Then
  Begin
    pj_enfn( P );
    P.am1 := sin( P.phi1 );
    c := cos( P.phi1 );
    P.m1 := pj_mlfn( P.phi1, P.am1, c, P );
    P.am1 := c / ( sqrt( 1.0 - P.es * P.am1 * P.am1 ) * P.am1 );
    P.inv := @e_inverse_bonne;
    P.fwd := @e_forward_bonne;
  End
  Else
  Begin
    If abs( P.phi1 ) + EPS10 >= HALFPI Then
      P.cphi1 := 0.0
    Else
      P.cphi1 := 1.0 / tan( P.phi1 );
    P.inv := @s_inverse_bonne;
    P.fwd := @s_forward_bonne;
  End
End;

{ cassini }
Const
  C1 = 0.16666666666666666666;
  C2 = 0.00833333333333333333;
  C3 = 0.04166666666666666666;
  C4 = 0.33333333333333333333;
  C5 = 0.06666666666666666666;

Function e_forward_cass( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid
Var
  xy: TXY;
Begin
  P.n := sin( lp.phi );
  P.c := cos( lp.phi );
  xy.y := pj_mlfn( lp.phi, P.n, P.c, P );
  P.n := 1.0 / sqrt( 1.0 - P.es * P.n * P.n );
  P.tn := tan( lp.phi );
  P.t := P.tn * P.tn;
  P.a1 := lp.lam * P.c;
  P.c := P.c * ( P.es * P.c / ( 1.0 - P.es ) );
  P.a2 := P.a1 * P.a1;
  xy.x := P.n * P.a1 * ( 1.0 - P.a2 * P.t * ( C1 - ( 8.0 - P.t + 8.0 * P.c ) * P.a2 * C2 ) );
  xy.y := xy.y - ( P.m0 - P.n * P.tn * P.a2 * ( 0.5 + ( 5.0 - P.t + 6.0 * P.c ) * P.a2 * C3 ) );
  result := xy;
End;

Function s_forward_cass( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid */
Var
  xy: TXY;
Begin
  xy.x := aasin( cos( lp.phi ) * sin( lp.lam ) );
  xy.y := aatan2( tan( lp.phi ), cos( lp.lam ) ) - P.phi0;
  result := xy;
End;

Function e_inverse_cass( const xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  ph1: double;
  lp: TLP;
Begin
  ph1 := pj_inv_mlfn( P.m0 + xy.y, P );
  P.tn := tan( ph1 );
  P.t := P.tn * P.tn;
  P.n := sin( ph1 );
  P.r := 1.0 / ( 1.0 - P.es * P.n * P.n );
  P.n := sqrt( P.r );
  P.r := P.r * ( ( 1.0 - P.es ) * P.n );
  P.dd := xy.x / P.n;
  P.d2 := P.dd * P.dd;
  lp.phi := ph1 - ( P.n * P.tn / P.r ) * P.d2 * ( 0.5 - ( 1.0 + 3.0 * P.t ) * P.d2 * C3 );
  lp.lam := P.dd * ( 1.0 + P.t * P.d2 * ( -C4 + ( 1.0 + 3.0 * P.t ) * P.d2 * C5 ) ) / cos( ph1 );
  result := lp;
End;

Function s_inverse_cass( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  lp: TLP;
Begin
  P.dd := xy.y + P.phi0;
  lp.phi := aasin( sin( P.dd ) * cos( xy.x ) );
  lp.lam := aatan2( tan( xy.x ), cos( P.dd ) );
  result := lp;
End;

Procedure cass( P: TEzGeoConvert; init: boolean );
Begin
  If P.es <> 0 Then
  Begin
    pj_enfn( P );
    //if (!(P.en = pj_enfn(P.es))) then raise exception.create('Error 0');
    P.m0 := pj_mlfn( P.phi0, sin( P.phi0 ), cos( P.phi0 ), P );
    P.inv := @e_inverse_cass;
    P.fwd := @e_forward_cass;
  End
  Else
  Begin
    P.inv := @s_inverse_cass;
    P.fwd := @s_forward_cass;
  End;
End;

{ cc - central cylindrical }

Function s_forward_cc( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
Begin
  If abs( abs( lp.phi ) - HALFPI ) <= EPS10 Then
    Raise exception.create( 'error' );
  xy.x := lp.lam;
  xy.y := tan( lp.phi );
  result := xy;
End;

Function s_inverse_cc( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  lp: TLP;
Begin
  lp.phi := arctan( xy.y );
  lp.lam := xy.x;
  result := lp;
End;

Procedure cc( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.es := 0.0;
  P.inv := @s_inverse_cc;
  P.fwd := @s_forward_cc;
End;

{ cea - Equal Area Cylindrical }

Function e_forward_cea( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
Begin
  xy.x := P.k0 * lp.lam;
  xy.y := 0.5 * pj_qsfn( sin( lp.phi ), P.e, P.one_es ) / P.k0;
  result := xy;
End;

Function s_forward_cea( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
Begin
  xy.x := P.k0 * lp.lam;
  xy.y := sin( lp.phi ) / P.k0;
  result := xy;
End;

Function e_inverse_cea( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  lp: TLP;
Begin
  lp.phi := pj_authlat( arcsin( 2.0 * xy.y * P.k0 / P.qp ), P );
  lp.lam := xy.x / P.k0;
  result := lp;
End;

Function s_inverse_cea( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  t: double;
  lp: TLP;
Begin
  xy.y := xy.y * P.k0;
  t := abs( xy.y );
  If t - EPS <= 1.0 Then
  Begin
    If ( t >= 1.0 ) Then
    Begin
      If xy.y < 0 Then
        lp.phi := -HALFPI
      Else
        lp.phi := HALFPI;
    End
    Else
      lp.phi := arcsin( xy.y );
    lp.lam := xy.x / P.k0;
  End
  Else
    Raise exception.create( 'error' );
  result := lp;
End;

Procedure cea( P: TEzGeoConvert; init: boolean );
Var
  t: double;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  If P.pj_param.defined( 'lat_ts' ) Then
  Begin
    t := P.pj_param.asradians( 'lat_ts' );
    P.k0 := cos( t );
    If P.k0 < 0 Then
      Raise exception.create( serr24 )
  End
  Else
    t := 0;
  If P.es <> 0 Then
  Begin
    t := sin( t );
    P.k0 := P.k0 / sqrt( 1.0 - P.es * t * t );
    P.e := sqrt( P.es );
    pj_authset( P );
    //if (!(P->apa = pj_authset(P->es))) E_ERROR_0;
    P.qp := pj_qsfn( 1., P.e, P.one_es );
    P.inv := @e_inverse_cea;
    P.fwd := @e_forward_cea;
  End
  Else
  Begin
    P.inv := @s_inverse_cea;
    P.fwd := @s_forward_cea;
  End;
End;

{ mill - miller cylindrical }

Function s_forward_mill( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
Begin
  xy.x := lp.lam;
  xy.y := ln( tan( FORTPI + lp.phi * 0.4 ) ) * 1.25;
  result := xy;
End;

Function s_inverse_mill( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  lp: TLP;
Begin
  lp.lam := xy.x;
  lp.phi := 2.5 * ( arctan( exp( 0.8 * xy.y ) ) - FORTPI );
  result := lp;
End;

Procedure mill( P: TEzGeoConvert; init: boolean ); //Miller Cylindrical
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.es := 0.0;
  P.inv := @s_inverse_mill;
  P.fwd := @s_forward_mill;
End;

{ Mollweide, Wagner IV, Wagner V}
Const
  LOOP_TOL = 1E-7;

Function s_forward_moll( lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
  k, V: double;
  i: integer;
Begin
  k := P.C_p * sin( lp.phi );
  i := MAX_ITER;
  While i > 0 Do
  Begin
    V := ( lp.phi + sin( lp.phi ) - k ) / ( 1.0 + cos( lp.phi ) );
    lp.phi := lp.phi - V;
    If abs( V ) < LOOP_TOL Then
      break;
    dec( i );
  End;
  If i = 0 Then
  Begin
    If lp.phi < 0 Then
      lp.phi := -HALFPI
    Else
      lp.phi := HALFPI;
  End
  Else
    lp.phi := lp.phi * 0.5;
  xy.x := P.C_x * lp.lam * cos( lp.phi );
  xy.y := P.C_y * sin( lp.phi );
  result := xy;
End;

Function s_inverse_moll( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  lp: TLP;
  //th, s:double;
Begin
  lp.phi := aasin( xy.y / P.C_y );
  lp.lam := xy.x / ( P.C_x * cos( lp.phi ) );
  lp.phi := lp.phi + lp.phi;
  lp.phi := aasin( ( lp.phi + sin( lp.phi ) ) / P.C_p );
  result := lp;
End;

Procedure setup_moll( P: TEzGeoConvert; Const dp: double );
Var
  r, sp, p2: double;
Begin
  p2 := dp + dp;
  P.es := 0;
  sp := sin( dp );
  r := sqrt( TWOPI * sp / ( p2 + sin( p2 ) ) );
  P.C_x := 2.0 * r / PI;
  P.C_y := r / sp;
  P.C_p := p2 + sin( p2 );
  P.inv := @s_inverse_moll;
  P.fwd := @s_forward_moll;
End;

Procedure moll( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  setup_moll( P, HALFPI );
End;

Procedure wag4( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  setup_moll( P, PI / 3 );
End;

Procedure wag5( P: TEzGeoConvert; init: boolean ); //Miller Cylindrical
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.es := 0;
  P.C_x := 0.90977;
  P.C_y := 1.65014;
  P.C_p := 3.00896;
  P.inv := @s_inverse_moll;
  P.fwd := @s_forward_moll;
End;

{ eck4 - Eckert IV }
Const
  C_x = 0.42223820031577120149;
  C_y = 1.32650042817700232218;
  RC_y = 0.75386330736002178205;
  C_p = 3.57079632679489661922;
  RC_p = 0.28004957675577868795;
  EPS7 = 1E-7;
  NITER = 6;

Function s_forward_eck4( lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
  dp, V, s, c: double;
  i: integer;
Begin
  dp := C_p * sin( lp.phi );
  V := lp.phi * lp.phi;
  lp.phi := lp.phi * ( 0.895168 + V * ( 0.0218849 + V * 0.00826809 ) );
  i := NITER;
  While i > 0 Do
  Begin
    c := cos( lp.phi );
    s := sin( lp.phi );
    V := ( lp.phi + s * ( c + 2.0 ) - dp ) / ( 1.0 + c * ( c + 2.0 ) - s * s );
    lp.phi := lp.phi - V;
    If abs( V ) < EPS7 Then
      break;
    dec( i );
  End;
  If i = 0 Then
  Begin
    xy.x := C_x * lp.lam;
    If lp.phi < 0 Then
      xy.y := -C_y
    Else
      xy.y := C_y;
  End
  Else
  Begin
    xy.x := C_x * lp.lam * ( 1.0 + cos( lp.phi ) );
    xy.y := C_y * sin( lp.phi );
  End;
  result := xy;
End;

Function s_inverse_eck4( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid */
Var
  lp: TLP;
  c: double;
Begin
  lp.phi := aasin( xy.y / C_y );
  c := cos( lp.phi );
  lp.lam := xy.x / ( C_x * ( 1.0 + c ) );
  lp.phi := aasin( ( lp.phi + sin( lp.phi ) * ( c + 2.0 ) ) / C_p );
  result := lp;
End;

Procedure eck4( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.es := 0.0;
  P.inv := @s_inverse_eck4;
  P.fwd := @s_forward_eck4;
End;

{ eck5 - Eckert V}
Const
  XF = 0.44101277172455148219;
  RXF = 2.26750802723822639137;
  YF = 0.88202554344910296438;
  RYF = 1.13375401361911319568;

Function s_forward( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
Begin
  xy.x := XF * ( 1.0 + cos( lp.phi ) ) * lp.lam;
  xy.y := YF * lp.phi;
  result := xy;
End;

Function s_inverse( const xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  lP: TLP;
Begin
  lp.phi := RYF * xy.y;
  lp.lam := RXF * xy.x / ( 1.0 + cos( lp.phi ) );
  result := lp;
End;

Procedure eck5( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.es := 0.0;
  P.inv := @s_inverse;
  P.fwd := @s_forward;
End;

{ eck6 - Eckert VI }
Const
  MAX_ITER8 = 8;

  // Ellipsoidal Sinusoidal only

Function e_forward_eck6( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid
Var
  s, c: double;
  xy: TXY;
Begin
  s := sin( lp.phi );
  c := cos( lp.phi );
  xy.y := pj_mlfn( lp.phi, s, c, P );
  xy.x := lp.lam * c / sqrt( 1.0 - P.es * s * s );
  result := xy;
End;

Function e_inverse_eck6( const xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  lp: TLP;
  s: double;
Begin
  lp.phi := pj_inv_mlfn( xy.y, P );
  s := abs( lp.phi );
  If s < HALFPI Then
  Begin
    s := sin( lp.phi );
    lp.lam := xy.x * sqrt( 1.0 - P.es * s * s ) / cos( lp.phi );
  End
  Else If ( ( s - EPS10 ) < HALFPI ) Then
    lp.lam := 0.0
  Else
    Raise Exception.create( 'error' );
  result := lp;
End;

// General spherical sinusoidals
Const
  MAXITER8 = 8;

Function s_forward_eck6( lp: TLP; P: TEzGeoConvert ): TXY; // sphere
Var
  xy: TXY;
  k, V: double;
  i: integer;
Begin
  If P.m = 0 Then
  Begin
    If P.n <> 1.0 Then
      lp.phi := aasin( P.n * sin( lp.phi ) );
  End
  Else
  Begin
    k := P.n * sin( lp.phi );
    i := MAXITER8;
    While i > 0 Do
    Begin
      V := ( P.m * lp.phi + sin( lp.phi ) - k ) / ( P.m + cos( lp.phi ) );
      lp.phi := lp.phi - V;
      If abs( V ) < LOOP_TOL Then
        break;
      dec( i );
    End;
    If i = 0 Then
      Raise Exception.create( 'error' );
  End;
  xy.x := P.C_x * lp.lam * ( P.m + cos( lp.phi ) );
  xy.y := P.C_y * lp.phi;
  result := xy;
End;

Function s_inverse_eck6( xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  //s:double;
  lp: TLP;
Begin
  xy.y := xy.y / P.C_y;
  If P.m <> 0 Then
    lp.phi := aasin( ( P.m * xy.y + sin( xy.y ) ) / P.n )
  Else
  Begin
    If P.n <> 1.0 Then
      lp.phi := aasin( sin( xy.y ) / P.n )
    Else
      lp.phi := xy.y;
  End;
  lp.lam := xy.x / ( P.C_x * ( P.m + cos( xy.y ) ) );
  result := lp;
End;

// for spheres, only

Procedure setup_eck6( P: TEzGeoConvert );
Begin
  P.es := 0;
  P.C_y := sqrt( ( P.m + 1.0 ) / P.n );
  P.C_x := P.C_y / ( P.m + 1.0 );
  P.inv := @s_inverse_eck6;
  P.fwd := @s_forward_eck6;
End;

Procedure sinu( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  pj_enfn( P );
  If P.es <> 0 Then
  Begin
    pj_enfn( P );
    P.inv := @e_inverse_eck6;
    P.fwd := @e_forward_eck6;
  End
  Else
  Begin
    P.n := 1.0;
    P.m := 0.0;
    setup_eck6( P );
  End;
End;

Procedure eck6( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.m := 1.0;
  P.n := 2.570796326794896619231321691;
  setup_eck6( P );
End;

Procedure mbtfps( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.m := 0.5;
  P.n := 1.785398163397448309615660845;
  setup_eck6( P );
End;

Procedure gn_sinu( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  If P.pj_param.defined( 'n' ) And P.pj_param.defined( 'm' ) Then
  Begin
    P.n := P.pj_param.asfloat( 'n' );
    P.m := P.pj_param.asfloat( 'm' );
  End
  Else
    exception.create( 'error 99' );
  setup_eck6( P );
End;

{ wag7 - Wagner VII }

Function s_forward_wag7( lp: TLP; P: TEzGeoConvert ): TXY; // sphere
Var
  xy: TXY;
  theta, ct, D: double;
Begin
  xy.y := 0.90630778703664996 * sin( lp.phi );
  theta := arcsin( xy.y );
  ct := cos( theta );
  lp.lam := lp.lam / 3.0;
  xy.x := 2.66723 * ct * sin( lp.lam );
  D := 1 / ( sqrt( 0.5 * ( 1 + ct * cos( lp.lam ) ) ) );
  xy.y := xy.y * ( 1.24104 * D );
  xy.x := xy.x * D;
  result := xy;
End;

Procedure wag7( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.fwd := @s_forward_wag7;
  P.inv := Nil;
  P.es := 0.0;
End;

{ tpeqd - two point equidistant }

Function s_forward_tpeqd( const lp: TLP; P: TEzGeoConvert ): TXY; // sphere
Var
  t, z1, z2, dl1, dl2, sp, cp: double;
  xy: TXY;
Begin
  sp := sin( lp.phi );
  cp := cos( lp.phi );
  dl1 := lp.lam + P.dlam2;
  z1 := aacos( P.sp1 * sp + P.cp1 * cp * cos( dl1 ) );
  dl2 := lp.lam - P.dlam2;
  z2 := aacos( P.sp2 * sp + P.cp2 * cp * cos( dl2 ) );
  z1 := z1 * z1;
  z2 := z2 * z2;
  t := z1 - z2;
  xy.x := P.r2z0 * t;
  t := P.z02 - t;
  xy.y := P.r2z0 * asqrt( 4.0 * P.z02 * z2 - t * t );
  If ( P.ccs * sp - cp * ( P.cs * sin( dl1 ) - P.sc * sin( dl2 ) ) ) < 0.0 Then
    xy.y := -xy.y;
  result := xy;
End;

Function s_inverse_tpeqd( const xy: TXY; P: TEzGeoConvert ): TLP; // sphere
Var
  cz1, cz2, s, d, cp, sp: double;
  lp: TLP;
Begin
  cz1 := cos( hypot( xy.y, xy.x + P.hz0 ) );
  cz2 := cos( hypot( xy.y, xy.x - P.hz0 ) );
  s := cz1 + cz2;
  d := cz1 - cz2;
  lp.lam := -aatan2( d, ( s * P.thz0 ) );
  lp.phi := aacos( hypot( P.thz0 * s, d ) * P.rhshz0 );
  If xy.y < 0.0 Then
    lp.phi := -lp.phi;
  // lam--phi now in system relative to P1--P2 base equator
  sp := sin( lp.phi );
  cp := cos( lp.phi );
  lp.lam := lp.lam - P.lp;
  s := cos( lp.lam );
  lp.phi := aasin( P.sa * sp + P.ca * cp * s );
  lp.lam := arctan2( cp * sin( lp.lam ), P.sa * cp * s - P.ca * sp ) + P.lamc;
  result := lp;
End;

Procedure tpeqd( P: TEzGeoConvert; init: boolean );
Var
  lam_1, lam_2, phi_1, phi_2, A12, pp: double;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;

  // get control point locations
  phi_1 := P.pj_param.asradians( 'lat_1' );
  lam_1 := P.pj_param.asradians( 'lon_1' );
  phi_2 := P.pj_param.asradians( 'lat_2' );
  lam_2 := P.pj_param.asradians( 'lon_2' );
  If ( phi_1 = phi_2 ) And ( lam_1 = lam_2 ) Then
    Raise exception.create( serr25 );
  P.lam0 := adjlon( 0.5 * ( lam_1 + lam_2 ) );
  P.dlam2 := adjlon( lam_2 - lam_1 );
  P.cp1 := cos( phi_1 );
  P.cp2 := cos( phi_2 );
  P.sp1 := sin( phi_1 );
  P.sp2 := sin( phi_2 );
  P.cs := P.cp1 * P.sp2;
  P.sc := P.sp1 * P.cp2;
  P.ccs := P.cp1 * P.cp2 * sin( P.dlam2 );
  P.z02 := aacos( P.sp1 * P.sp2 + P.cp1 * P.cp2 * cos( P.dlam2 ) );
  P.hz0 := 0.5 * P.z02;
  A12 := arctan2( P.cp2 * sin( P.dlam2 ), P.cp1 * P.sp2 - P.sp1 * P.cp2 * cos( P.dlam2 ) );
  pp := aasin( P.cp1 * sin( A12 ) );
  P.ca := cos( pp );
  P.sa := sin( pp );
  P.lp := adjlon( arctan2( P.cp1 * cos( A12 ), P.sp1 ) - P.hz0 );
  P.dlam2 := p.dlam2 * 0.5;
  P.lamc := HALFPI - arctan2( sin( A12 ) * P.sp1, cos( A12 ) ) - P.dlam2;
  P.thz0 := tan( P.hz0 );
  P.rhshz0 := 0.5 / sin( P.hz0 );
  P.r2z0 := 0.5 / P.z02;
  P.z02 := P.z02 * P.z02;
  P.inv := @s_inverse_tpeqd;
  P.fwd := @s_forward_tpeqd;
  P.es := 0.0;
End;

{ tcea - Transverse Cylindrical Equal Area}

Function s_forward_tcea( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
Begin
  xy.x := P.rk0 * cos( lp.phi ) * sin( lp.lam );
  xy.y := P.k0 * ( arctan2( tan( lp.phi ), cos( lp.lam ) ) - P.phi0 );
  result := xy;
End;

Function s_inverse_tcea( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  t: double;
  lp: TLP;
Begin
  xy.y := xy.y * P.rk0 + P.phi0;
  xy.x := xy.x * P.k0;
  t := sqrt( 1.0 - xy.x * xy.x );
  lp.phi := arcsin( t * sin( xy.y ) );
  lp.lam := arctan2( xy.x, t * cos( xy.y ) );
  result := lp;
End;

Procedure tcea( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.rk0 := 1 / P.k0;
  P.inv := @s_inverse_tcea;
  P.fwd := @s_forward_tcea;
  P.es := 0.0;
End;

{ vandg4 - van der Grinten IV}
Const

  TWORPI = 0.63661977236758134308;

Function s_forward_vandg4( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  xy: TXY;
  x1, t, bt, ct, ft, bt2, ct2, dt, dt2: double;
Begin
  If abs( lp.phi ) < TOL10 Then
  Begin
    xy.x := lp.lam;
    xy.y := 0.0;
  End
  Else If ( abs( lp.lam ) < TOL10 ) Or ( abs( abs( lp.phi ) - HALFPI ) < TOL10 ) Then
  Begin
    xy.x := 0.0;
    xy.y := lp.phi;
  End
  Else
  Begin
    bt := abs( TWORPI * lp.phi );
    bt2 := bt * bt;
    ct := 0.5 * ( bt * ( 8.0 - bt * ( 2.0 + bt2 ) ) - 5.0 ) / ( bt2 * ( bt - 1.0 ) );
    ct2 := ct * ct;
    dt := TWORPI * lp.lam;
    dt := dt + 1. / dt;
    dt := sqrt( dt * dt - 4.0 );
    If ( ( abs( lp.lam ) - HALFPI ) < 0.0 ) Then
      dt := -dt;
    dt2 := dt * dt;
    x1 := bt + ct;
    x1 := x1 * x1;
    t := bt + 3 * ct;
    ft := x1 * ( bt2 + ct2 * dt2 - 1.0 ) + ( 1.0 - bt2 ) *
      ( bt2 * ( t * t + 4.0 * ct2 ) + ct2 * ( 12.0 * bt * ct + 4.0 * ct2 ) );
    x1 := ( dt * ( x1 + ct2 - 1.0 ) + 2.0 * sqrt( ft ) ) / ( 4.0 * x1 + dt2 );
    xy.x := HALFPI * x1;
    xy.y := HALFPI * sqrt( 1.0 + dt * abs( x1 ) - x1 * x1 );
    If ( lp.lam < 0.0 ) Then
      xy.x := -xy.x;
    If ( lp.phi < 0.0 ) Then
      xy.y := -xy.y;
  End;
  result := xy;
End;

Procedure vandg4( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  P.es := 0.0;
  P.fwd := @s_forward_vandg4;
End;

{ laea - lambert azimuthal equal area }
Var
  sinph0: double;
  cosph0: double;

Function e_forward_laea( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid
Label
  eqcon;
Var
  xy: TXY;
  coslam, sinlam, sinphi, q, sinb, cosb, b: double;
Begin
  sinb := 0.0;
  cosb := 0.0;
  b := 0.0;
  coslam := cos( lp.lam );
  sinlam := sin( lp.lam );
  sinphi := sin( lp.phi );
  q := pj_qsfn( sinphi, P.e, P.one_es );
  If ( P.mode = OBLIQ ) Or ( P.mode = EQUIT ) Then
  Begin
    sinb := q / P.qp;
    cosb := sqrt( 1.0 - sinb * sinb );
  End;
  Case P.mode Of
    OBLIQ:
      b := 1.0 + P.sinb1 * sinb + P.cosb1 * cosb * coslam;
    EQUIT:
      b := 1.0 + cosb * coslam;
    N_POLE:
      Begin
        b := HALFPI + lp.phi;
        q := P.qp - q;
      End;
    S_POLE:
      Begin
        b := lp.phi - HALFPI;
        q := P.qp + q;
      End;
  End;
  If abs( b ) < EPS10 Then
    Raise exception.create( 'error' );
  Case P.mode Of
    OBLIQ:
      Begin
        b := sqrt( 2.0 / b );
        xy.y := P.ymf * b * ( P.cosb1 * sinb - P.sinb1 * cosb * coslam );
        Goto eqcon;
      End;
    EQUIT:
      Begin
        b := sqrt( 2.0 / ( 1.0 + cosb * coslam ) );
        xy.y := b * sinb * P.ymf;
        eqcon:
        xy.x := P.xmf * b * cosb * sinlam;
      End;
    N_POLE, S_POLE:
      If q >= 0.0 Then
      Begin
        b := sqrt( q );
        xy.x := b * sinlam;
        If P.mode = S_POLE Then
          xy.y := coslam * b
        Else
          xy.y := coslam * ( -b );
      End
      Else
      Begin
        xy.y := 0.0;
        xy.x := 0.0;
      End;
  End;
  result := xy;
End;

Function s_forward_laea( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Label
  oblcon;
Var
  xy: TXY;
  coslam, cosphi, sinphi: double;
Begin
  sinphi := sin( lp.phi );
  cosphi := cos( lp.phi );
  coslam := cos( lp.lam );
  Case P.mode Of
    EQUIT:
      Begin
        xy.y := 1.0 + cosphi * coslam;
        Goto oblcon;
      End;
    OBLIQ:
      Begin
        xy.y := 1.0 + sinph0 * sinphi + cosph0 * cosphi * coslam;
        oblcon:
        If xy.y <= EPS10 Then
          Raise exception.create( 'error' );
        xy.y := sqrt( 2.0 / xy.y );
        xy.x := xy.y * cosphi * sin( lp.lam );
        If P.mode = EQUIT Then
          xy.y := xy.y * sinphi
        Else
          xy.y := xy.y * ( cosph0 * sinphi - sinph0 * cosphi * coslam );
      End;
    N_POLE, S_POLE:
      Begin
        If P.Mode = N_POLE Then
          coslam := -coslam;
        If abs( lp.phi + P.phi0 ) < EPS10 Then
          Raise exception.create( 'error' );
        xy.y := FORTPI - lp.phi * 0.5;
        If P.mode = S_POLE Then
          xy.y := 2.0 * cos( xy.y )
        Else
          xy.y := 2.0 * sin( xy.y );
        xy.x := xy.y * sin( lp.lam );
        xy.y := xy.y * coslam;
      End;
  End;
  result := xy;
End;

Function e_inverse_laea( xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  lp: TLP;
  cCe, sCe, q, rho, ab: double;
Begin
  ab := 0.0;
  Case P.mode Of
    EQUIT,
      OBLIQ:
      Begin
        xy.x := xy.x / P.dd;
        xy.y := xy.y * P.dd;
        rho := hypot( xy.x, xy.y );
        If rho < EPS10 Then
        Begin
          lp.lam := 0.0;
          lp.phi := P.phi0;
          result := lp;
          exit;
        End;
        sCe := 2.0 * arcsin( 0.5 * rho / P.rq );
        cCe := cos( sCe );
        sCe := sin( sCe );
        xy.x := xy.x * sCe;
        If P.mode = OBLIQ Then
        Begin
          ab := cCe * P.sinb1 + xy.y * sCe * P.cosb1 / rho;
          //q := P.qp * ab;
          xy.y := rho * P.cosb1 * cCe - xy.y * P.sinb1 * sCe;
        End
        Else
        Begin
          ab := xy.y * sCe / rho;
          //q := P.qp * ab;
          xy.y := rho * cCe;
        End;
      End;
    N_POLE, S_POLE:
      Begin
        If P.Mode = N_POLE Then
          xy.y := -xy.y;
        q := xy.x * xy.x + xy.y * xy.y;
        If q = 0 Then
        Begin
          lp.lam := 0.0;
          lp.phi := P.phi0;
          result := lp;
        End;
        (*
        q := P.qp - q;
        *)
        ab := 1.0 - q / P.qp;
        If P.mode = S_POLE Then
          ab := -ab;
      End;
  End;
  lp.lam := arctan2( xy.x, xy.y );
  lp.phi := pj_authlat( arcsin( ab ), P );
  result := lp;
End;

Function s_inverse_laea( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  cosz, rh, sinz: double;
  lp: TLP;
Begin
  cosz := 0.0;
  sinz := 0.0;
  rh := hypot( xy.x, xy.y );
  lp.phi := rh * 0.5;
  If lp.phi > 1.0 Then
    Raise exception.create( 'error' );
  lp.phi := 2.0 * arcsin( lp.phi );
  If ( P.mode = OBLIQ ) Or ( P.mode = EQUIT ) Then
  Begin
    sinz := sin( lp.phi );
    cosz := cos( lp.phi );
  End;
  Case P.mode Of
    EQUIT:
      Begin
        If abs( rh ) <= EPS10 Then
          lp.phi := 0
        Else
          lp.phi := arcsin( xy.y * sinz / rh );
        xy.x := xy.x * sinz;
        xy.y := cosz * rh;
      End;
    OBLIQ:
      Begin
        If abs( rh ) <= EPS10 Then
          lp.phi := P.phi0
        Else
          lp.phi := arcsin( cosz * sinph0 + xy.y * sinz * cosph0 / rh );
        xy.x := xy.x * ( sinz * cosph0 );
        xy.y := ( cosz - sin( lp.phi ) * sinph0 ) * rh;
      End;
    N_POLE:
      Begin
        xy.y := -xy.y;
        lp.phi := HALFPI - lp.phi;
      End;
    S_POLE:
      lp.phi := lp.phi - HALFPI;
  End;
  If ( xy.y = 0.0 ) And ( ( P.mode = EQUIT ) Or ( P.mode = OBLIQ ) ) Then
    lp.lam := 0
  Else
    lp.lam := arctan2( xy.x, xy.y );
  result := lp;
End;

Procedure laea( P: TEzGeoConvert; init: boolean );
Var
  t: double;
  sinphi: double;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  sinph0 := P.sinb1;
  cosph0 := P.cosb1;
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  t := abs( P.phi0 );
  If abs( t - HALFPI ) < EPS10 Then
  Begin
    If P.phi0 < 0.0 Then
      P.mode := S_POLE
    Else
      P.mode := N_POLE;
  End
  Else If abs( t ) < EPS10 Then
    P.mode := EQUIT
  Else
    P.mode := OBLIQ;
  If P.es <> 0 Then
  Begin
    P.e := sqrt( P.es );
    P.qp := pj_qsfn( 1.0, P.e, P.one_es );
    P.mmf := 0.5 / ( 1.0 - P.es );
    pj_authset( P );
    Case P.mode Of
      N_POLE,
        S_POLE:
        P.dd := 1.0;
      EQUIT:
        Begin
          P.rq := sqrt( 0.5 * P.qp );
          P.dd := 1.0 / P.rq;
          P.xmf := 1.0;
          P.ymf := 0.5 * P.qp;
        End;
      OBLIQ:
        Begin
          P.rq := sqrt( 0.5 * P.qp );
          sinphi := sin( P.phi0 );
          P.sinb1 := pj_qsfn( sinphi, P.e, P.one_es ) / P.qp;
          P.cosb1 := sqrt( 1.0 - P.sinb1 * P.sinb1 );
          P.dd := cos( P.phi0 ) / ( sqrt( 1.0 - P.es * sinphi * sinphi ) * P.rq * P.cosb1 );
          P.xmf := P.rq;
          P.ymf := P.xmf / P.dd;
          P.xmf := P.dd;
        End;
    End;
    P.inv := @e_inverse_laea;
    P.fwd := @e_forward_laea;
  End
  Else
  Begin
    If P.mode = OBLIQ Then
    Begin
      sinph0 := sin( P.phi0 );
      cosph0 := cos( P.phi0 );
    End;
    P.inv := @s_inverse_laea;
    P.fwd := @s_forward_laea;
  End;
End;

{ stere, ups - Universal Polar Stereographic }
Const
  TOL8 = 1.E-8;
  NITER8 = 8;
  S_POLEa = 0;
  N_POLEa = 1;
  OBLIQa = 2;
  EQUITa = 3;
  CONV = 1E-10;

Function ssfn_( Const phit: double; Var sinphi: double; Const eccen: double ): double;
Begin
  sinphi := sinphi * eccen;
  result := ( tan( 0.5 * ( HALFPI + phit ) ) * power( ( 1.0 - sinphi ) / ( 1.0 + sinphi ), 0.5 * eccen ) );
End;

Function e_forward_stere( lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoide
Label
  xmul;
Var
  xy: TXY;
  coslam, sinlam, sinX, cosX, X, A, sinphi: double;
Begin
  sinX := 0.0;
  cosX := 0.0;
  coslam := cos( lp.lam );
  sinlam := sin( lp.lam );
  sinphi := sin( lp.phi );
  If ( P.mode = OBLIQa ) Or ( P.mode = EQUITa ) Then
  Begin
    X := 2 * arctan( ssfn_( lp.phi, sinphi, P.e ) ) - HALFPI;
    sinX := sin( X );
    cosX := cos( X );
  End;
  Case P.mode Of
    OBLIQa:
      Begin
        A := P.akm1 / ( P.cosX1 * ( 1. + P.sinX1 * sinX + P.cosX1 * cosX * coslam ) );
        xy.y := A * ( P.cosX1 * sinX - P.sinX1 * cosX * coslam );
        Goto xmul;
      End;
    EQUITa:
      Begin
        A := 2.0 * P.akm1 / ( 1.0 + cosX * coslam );
        xy.y := A * sinX;
        xmul:
        xy.x := A * cosX;
      End;
    S_POLEa, N_POLEa:
      Begin
        If P.Mode = S_POLEa Then
        Begin
          lp.phi := -lp.phi;
          coslam := -coslam;
          sinphi := -sinphi;
        End;
        xy.x := P.akm1 * pj_tsfn( lp.phi, sinphi, P.e );
        xy.y := -xy.x * coslam;
      End;
  End;
  xy.x := xy.x * sinlam;
  result := xy;
End;

Function s_forward_stere( lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Label
  oblcon;
Var
  sinphi, cosphi, coslam, sinlam: double;
  xy: TXY;
Begin
  sinphi := sin( lp.phi );
  cosphi := cos( lp.phi );
  coslam := cos( lp.lam );
  sinlam := sin( lp.lam );
  Case P.mode Of
    EQUITa:
      Begin
        xy.y := 1.0 + cosphi * coslam;
        Goto oblcon;
      End;
    OBLIQa:
      Begin
        xy.y := 1.0 + sinph0 * sinphi + cosph0 * cosphi * coslam;
        oblcon:
        If xy.y <= EPS10 Then
          Raise exception.create( 'error' );
        xy.y := P.akm1 / xy.y;
        xy.x := xy.y * cosphi * sinlam;
        If P.mode = EQUITa Then
          xy.y := xy.y * sinphi
        Else
          xy.y := cosph0 * sinphi - sinph0 * cosphi * coslam;
      End;
    N_POLEa, S_POLEa:
      Begin
        If P.Mode = N_POLEa Then
        Begin
          coslam := -coslam;
          lp.phi := -lp.phi;
        End;
        If abs( lp.phi - HALFPI ) < TOL8 Then
          Raise exception.create( 'error' );
        xy.y := P.akm1 * tan( FORTPI + 0.5 * lp.phi );
        xy.x := sinlam * xy.y;
        xy.y := xy.y * coslam;
      End;
  End;
  result := xy;
End;

Function e_inverse_stere( xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  cosphi, sinphi, tp, phi_l, rho, halfe, halfpi: double;
  i: integer;
  lp: TLP;
Begin
  tp := 0.0;
  phi_l := 0.0;
  halfe := 0.0;
  halfpi := 0.0;
  rho := hypot( xy.x, xy.y );
  Case P.mode Of
    OBLIQa,
      EQUITa:
      Begin
        tp := 2.0 * arctan2( rho * P.cosX1, P.akm1 );
        cosphi := cos( tp );
        sinphi := sin( tp );
        If rho = 0.0 Then
          phi_l := arcsin( cosphi * P.sinX1 )
        Else
          phi_l := arcsin( cosphi * P.sinX1 + ( xy.y * sinphi * P.cosX1 / rho ) );
        tp := tan( 0.5 * ( HALFPI + phi_l ) );
        xy.x := xy.x * sinphi;
        xy.y := rho * P.cosX1 * cosphi - xy.y * P.sinX1 * sinphi;
        halfpi := HALFPI;
        halfe := 0.5 * P.e;
      End;
    N_POLEa, S_POLEa:
      Begin
        If P.Mode = N_POLEa Then
          xy.y := -xy.y;
        tp := -rho / P.akm1;
        phi_l := HALFPI - 2.0 * arctan( tp );
        halfpi := -HALFPI;
        halfe := -0.5 * P.e;
      End;
  End;
  i := NITER8;
  While i > 0 Do
  Begin
    //for (i = NITER8; i--; phi_l = lp.phi) {
    sinphi := P.e * sin( phi_l );
    lp.phi := 2.0 * arctan( tp * power( ( 1.0 + sinphi ) / ( 1.0 - sinphi ), halfe ) ) - halfpi;
    If ( abs( phi_l - lp.phi ) < CONV ) Then
    Begin
      If P.mode = S_POLEa Then
        lp.phi := -lp.phi;
      If ( xy.x = 0 ) And ( xy.y = 0 ) Then
        lp.lam := 0
      Else
        lp.lam := arctan2( xy.x, xy.y );
      result := lp;
      exit;
    End;
    phi_l := lp.phi;
    dec( i );
  End;
  Raise exception.create( 'error' );
End;

Function s_inverse_stere( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  c, rh, sinc, cosc: double;
  lp: TLP;
Begin
  rh := hypot( xy.x, xy.y ) / P.akm1;
  c := 2.0 * arctan( rh );
  sinc := sin( c );
  cosc := cos( c );
  lp.lam := 0.0;
  Case P.mode Of
    EQUITa:
      Begin
        If abs( rh ) <= EPS10 Then
          lp.phi := 0
        Else
          lp.phi := arcsin( xy.y * sinc / rh );
        If ( cosc <> 0 ) Or ( xy.x <> 0 ) Then
          lp.lam := arctan2( xy.x * sinc, cosc * rh );
      End;
    OBLIQa:
      Begin
        If abs( rh ) <= EPS10 Then
          lp.phi := P.phi0
        Else
          lp.phi := arcsin( cosc * sinph0 + xy.y * sinc * cosph0 / rh );
        c := cosc - sinph0 * sin( lp.phi );
        If ( c <> 0 ) Or ( xy.x <> 0 ) Then
          lp.lam := arctan2( xy.x * sinc * cosph0, c * rh )
      End;
    N_POLEa, S_POLEa:
      Begin
        If P.Mode = N_POLEa Then
          xy.y := -xy.y;
        If abs( rh ) <= EPS10 Then
          lp.phi := P.phi0
        Else
        Begin
          If P.mode = S_POLEa Then
            lp.phi := arcsin( -cosc )
          Else
            lp.phi := arcsin( cosc );
        End;
        If ( xy.x = 0 ) And ( xy.y = 0 ) Then
          lp.lam := 0
        Else
          lp.lam := arctan2( xy.x, xy.y );
      End;
  End;
  result := lp;
End;

Procedure setup_stere( P: TEzGeoConvert ); // general initialization
Var
  t, x: double;
Begin
  t := abs( P.phi0 );
  If abs( t - HALFPI ) < EPS10 Then
  Begin
    If P.phi0 < 0 Then
      P.mode := S_POLEa
    Else
      P.mode := N_POLEa
  End
  Else
  Begin
    If t > EPS10 Then
      P.mode := OBLIQa
    Else
      P.mode := EQUITa;
  End;
  P.phits := abs( P.phits );
  If P.es <> 0 Then
  Begin
    Case P.mode Of
      N_POLEa,
        S_POLEa:
        Begin
          If abs( P.phits - HALFPI ) < EPS10 Then
            P.akm1 := 2.0 * P.k0 / sqrt( power( 1 + P.e, 1 + P.e ) * power( 1 - P.e, 1 - P.e ) )
          Else
          Begin
            t := sin( P.phits );
            P.akm1 := cos( P.phits ) / pj_tsfn( P.phits, t, P.e );
            t := t * P.e;
            P.akm1 := P.akm1 / sqrt( 1.0 - t * t );
          End;
        End;
      EQUITa:
        P.akm1 := 2.0 * P.k0;
      OBLIQa:
        Begin
          t := sin( P.phi0 );
          X := 2.0 * arctan( ssfn_( P.phi0, t, P.e ) ) - HALFPI;
          t := t * P.e;
          P.akm1 := 2.0 * P.k0 * cos( P.phi0 ) / sqrt( 1.0 - t * t );
          P.sinX1 := sin( X );
          P.cosX1 := cos( X );
        End;
    End;
    P.inv := @e_inverse_stere;
    P.fwd := @e_forward_stere;
  End
  Else
  Begin
    Case P.mode Of
      OBLIQa,
        EQUITa:
        Begin
          If P.Mode = OBLIQa Then
          Begin
            sinph0 := sin( P.phi0 );
            cosph0 := cos( P.phi0 );
          End;
          P.akm1 := 2.0 * P.k0;
        End;
      S_POLEa,
        N_POLEa:
        If abs( P.phits - HALFPI ) >= EPS10 Then
          P.akm1 := cos( P.phits ) / tan( FORTPI - 0.5 * P.phits )
        Else
          P.akm1 := 2.0 * P.k0;
    End;
    P.inv := @s_inverse_stere;
    P.fwd := @s_forward_stere;
  End;
End;

Procedure stere( P: TEzGeoConvert; init: boolean );
Begin
  sinph0 := P.sinX1;
  cosph0 := P.cosX1;
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  If P.pj_param.defined( 'lat_ts' ) Then
    P.phits := P.pj_param.asinteger( 'lat_ts' )
  Else
    P.phits := HALFPI;
  setup_stere( P );
End;

Procedure ups( P: TEzGeoConvert; init: boolean );
Begin
  sinph0 := P.sinX1;
  cosph0 := P.cosX1;
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  // International Ellipsoid
  If P.pj_param.asboolean( 'south' ) Then
    P.phi0 := -HALFPI
  Else
    P.phi0 := HALFPI;
  If P.es = 0 Then
    Raise exception.create( serr34 );
  P.k0 := 0.994;
  P.x0 := 2000000.;
  P.y0 := 2000000.;
  P.phits := HALFPI;
  P.lam0 := 0.0;
  setup_stere( P );
End;

{ ortho - Ortographic}
{ note : this have same constants than in airy }

Function s_forward_ortho( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  coslam, cosphi, sinphi: double;
  xy: TXY;
Begin
  cosphi := cos( lp.phi );
  coslam := cos( lp.lam );
  Case P.mode Of
    EQUIT:
      Begin
        If cosphi * coslam < -EPS10 Then
          Raise exception.create( 'error' );
        xy.y := sin( lp.phi );
      End;
    OBLIQ:
      Begin
        sinphi := sin( lp.phi );
        If P.sinph0 * sinphi + P.cosph0 * cosphi * coslam < -EPS10 Then
          Raise exception.create( 'error' );
        xy.y := P.cosph0 * sinphi - P.sinph0 * cosphi * coslam;
      End;
    N_POLE, S_POLE:
      Begin
        If P.mode = N_POLE Then
          coslam := -coslam;
        If abs( lp.phi - P.phi0 ) - EPS10 > HALFPI Then
          Raise exception.create( 'error' );
        xy.y := cosphi * coslam;
      End;
  End;
  xy.x := cosphi * sin( lp.lam );
  result := xy;
End;

Function s_inverse_ortho( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Label
  sinchk;
Var
  rh, cosc, sinc: double;
  lp: TLP;
Begin
  rh := hypot( xy.x, xy.y );
  sinc := rh;
  If sinc > 1.0 Then
  Begin
    If ( sinc - 1.0 ) > EPS10 Then
      Raise exception.create( 'error' );
    sinc := 1.0;
  End;
  cosc := sqrt( 1.0 - sinc * sinc ); // in this range OK
  If abs( rh ) <= EPS10 Then
  Begin
    lp.phi := P.phi0;
    lp.lam := 0.0;
  End
  Else
  Begin
    Case P.mode Of
      N_POLE:
        Begin
          xy.y := -xy.y;
          lp.phi := arccos( sinc );
        End;
      S_POLE:
        lp.phi := -arccos( sinc );
      EQUIT:
        Begin
          lp.phi := xy.y * sinc / rh;
          xy.x := xy.x * sinc;
          xy.y := cosc * rh;
          Goto sinchk;
        End;
      OBLIQ:
        Begin
          lp.phi := cosc * P.sinph0 + xy.y * sinc * P.cosph0 / rh;
          xy.y := ( cosc - P.sinph0 * lp.phi ) * rh;
          xy.x := xy.x * ( sinc * P.cosph0 );
          sinchk:
          If abs( lp.phi ) >= 1.0 Then
          Begin
            If lp.phi < 0 Then
              lp.phi := -HALFPI
            Else
              lp.phi := HALFPI;
          End
          Else
            lp.phi := arcsin( lp.phi );
        End;
    End;
    If ( xy.y = 0 ) And ( ( P.mode = OBLIQ ) Or ( P.mode = EQUIT ) ) Then
    Begin
      If xy.x = 0 Then
        lp.lam := 0
      Else
      Begin
        If xy.x < 0 Then
          lp.lam := -HALFPI
        Else
          lp.lam := HALFPI;
      End;
    End
    Else
      lp.lam := arctan2( xy.x, xy.y );
  End;
  result := lp;
End;

Procedure ortho( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  If abs( abs( P.phi0 ) - HALFPI ) <= EPS10 Then
  Begin
    If P.phi0 < 0 Then
      P.mode := S_POLE
    Else
      P.mode := N_POLE;
  End
  Else If abs( P.phi0 ) > EPS10 Then
  Begin
    P.mode := OBLIQ;
    P.sinph0 := sin( P.phi0 );
    P.cosph0 := cos( P.phi0 );
  End
  Else
    P.mode := EQUIT;
  P.inv := @s_inverse_ortho;
  P.fwd := @s_forward_ortho;
  P.es := 0.0;
End;

{ imw_p - International Map of the World Polyconic}

Function phi12( P: TEzGeoConvert; Var del, sig: double ): integer;
Var
  err: integer;
Begin
  If Not P.pj_param.defined( 'lat_1' ) Or Not P.pj_param.defined( 'lat_2' ) Then
  Begin
    err := -41;
  End
  Else
  Begin
    P.phi_1 := P.pj_param.asradians( 'rlat_1' );
    P.phi_2 := P.pj_param.asradians( 'rlat_2' );
    del := 0.5 * ( P.phi_2 - P.phi_1 );
    sig := 0.5 * ( P.phi_2 + P.phi_1 );
    If ( abs( del ) < EPS ) Or ( abs( sig ) < EPS ) Then
      err := -42
    Else
      err := 0;
  End;
  result := err;
End;

Function loc_for( const lp: TLP; P: TEzGeoConvert; Var yc: double ): TXY;
Var
  xy: TXY;
  xa, ya, xb, yb, xc, D, B, m, sp, t, R, C: double;
Begin
  If lp.phi = 0 Then
  Begin
    xy.x := lp.lam;
    xy.y := 0;
  End
  Else
  Begin
    sp := sin( lp.phi );
    m := pj_mlfn( lp.phi, sp, cos( lp.phi ), P );
    xa := P.Pp + P.Qp * m;
    ya := P.P + P.Q * m;
    R := 1.0 / ( tan( lp.phi ) * sqrt( 1.0 - P.es * sp * sp ) );
    C := sqrt( R * R - xa * xa );
    If lp.phi < 0 Then
      C := -C;
    C := C + ( ya - R );
    If P.mode < 0 Then
    Begin
      xb := lp.lam;
      yb := P.C2;
    End
    Else
    Begin
      t := lp.lam * P.sphi_2;
      xb := P.R_2 * sin( t );
      yb := P.C2 + P.R_2 * ( 1 - cos( t ) );
    End;
    If P.mode > 0 Then
    Begin
      xc := lp.lam;
      yc := 0;
    End
    Else
    Begin
      t := lp.lam * P.sphi_1;
      xc := P.R_1 * sin( t );
      yc := P.R_1 * ( 1 - cos( t ) );
    End;
    D := ( xb - xc ) / ( yb - yc );
    B := xc + D * ( C + R - yc );
    xy.x := D * sqrt( R * R * ( 1 + D * D ) - B * B );
    If lp.phi > 0 Then
      xy.x := -xy.x;
    xy.x := ( B + xy.x ) / ( 1 + D * D );
    xy.y := sqrt( R * R - xy.x * xy.x );
    If lp.phi > 0 Then
      xy.y := -xy.y;
    xy.y := xy.y + ( C + R );
  End;
  result := xy;
End;

Function e_forward_imw_p( const lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid
Var
  yc: double;
  xy: TXY;
Begin
  xy := loc_for( lp, P, yc );
  result := xy;
End;

Function e_inverse_imw_p( const xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  t: TXY;
  yc: double;
  lp: TLP;
Begin
  lp.phi := P.phi_2;
  lp.lam := xy.x / cos( lp.phi );
  Repeat
    t := loc_for( lp, P, yc );
    lp.phi := ( ( lp.phi - P.phi_1 ) * ( xy.y - yc ) / ( t.y - yc ) ) + P.phi_1;
    lp.lam := lp.lam * xy.x / t.x;
  Until Not ( ( abs( t.x - xy.x ) > TOL10 ) Or ( abs( t.y - xy.y ) > TOL10 ) );
  result := lp;
End;

Procedure p_xy( P: TEzGeoConvert; Const phi: double; Var x: double; Var y: double;
  Var sp: double; Var R: double );
Var
  F: double;
Begin
  sp := sin( phi );
  R := 1 / ( tan( phi ) * sqrt( 1 - P.es * sp * sp ) );
  F := P.lam_1 * sp;
  y := R * ( 1 - cos( F ) );
  x := R * sin( F );
End;

Procedure imw_p( P: TEzGeoConvert; init: boolean );
Var
  del, sig, s, t, x1, x2, T2, y1, m1, m2, y2: double;
  i: integer;
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  i := phi12( P, del, sig );
  If i <> 0 Then
    Raise exception.create( 'error ' + inttostr( i ) );
  If P.phi_2 < P.phi_1 Then // make sure P.phi_1 most southerly
  Begin
    del := P.phi_1;
    P.phi_1 := P.phi_2;
    P.phi_2 := del;
  End;
  If P.pj_param.defined( 'lon_1' ) Then
    P.lam_1 := P.pj_param.asradians( 'lon_1' )
  Else // use predefined based upon latitude
  Begin
    sig := abs( RadToDeg( sig ) );
    If sig <= 60 Then
      sig := 2
    Else If sig <= 76 Then
      sig := 4
    Else
      sig := 8;
    P.lam_1 := DegToRad( sig );
  End;
  P.mode := 0;
  If P.phi_1 <> 0 Then
    p_xy( P, P.phi_1, x1, y1, P.sphi_1, P.R_1 )
  Else
  Begin
    P.mode := 1;
    y1 := 0;
    x1 := P.lam_1;
  End;
  If P.phi_2 <> 0 Then
    p_xy( P, P.phi_2, x2, T2, P.sphi_2, P.R_2 )
  Else
  Begin
    P.mode := -1;
    T2 := 0;
    x2 := P.lam_1;
  End;
  m1 := pj_mlfn( P.phi_1, P.sphi_1, cos( P.phi_1 ), P );
  m2 := pj_mlfn( P.phi_2, P.sphi_2, cos( P.phi_2 ), P );
  t := m2 - m1;
  s := x2 - x1;
  y2 := sqrt( t * t - s * s ) + y1;
  P.C2 := y2 - T2;
  t := 1 / t;
  P.P := ( m2 * y1 - m1 * y2 ) * t;
  P.Q := ( y2 - y1 ) * t;
  P.Pp := ( m2 * x1 - m1 * x2 ) * t;
  P.Qp := ( x2 - x1 ) * t;
  P.fwd := @e_forward_imw_p;
  P.inv := @e_inverse_imw_p;
End;

{ poly - Polyconic (American) }

Const
  N_ITER10 = 10;
  I_ITER = 20;
  ITOL = 1.E-12;

Function e_forward_poly( lp: TLP; P: TEzGeoConvert ): TXY; // ellipsoid
Var
  ms, sp, cp: double;
  xy: TXY;
Begin
  If abs( lp.phi ) <= TOL10 Then
  Begin
    xy.x := lp.lam;
    xy.y := -P.ml0;
  End
  Else
  Begin
    sp := sin( lp.phi );
    cp := cos( lp.phi );
    If abs( cp ) > TOL10 Then
      ms := pj_msfn( sp, cp, P.es ) / sp
    Else
      ms := 0;
    lp.lam := lp.lam * sp;
    xy.x := ms * sin( lp.lam );
    xy.y := ( pj_mlfn( lp.phi, sp, cp, P ) - P.ml0 ) + ms * ( 1 - cos( lp.lam ) );
  End;
  result := xy;
End;

Function s_forward_poly( const lp: TLP; P: TEzGeoConvert ): TXY; // spheroid
Var
  cot, E: double;
  xy: TXY;
Begin
  If abs( lp.phi ) <= TOL10 Then
  Begin
    xy.x := lp.lam;
    xy.y := P.ml0;
  End
  Else
  Begin
    cot := 1 / tan( lp.phi );
    E := lp.lam * sin( lp.phi );
    xy.x := sin( E ) * cot;
    xy.y := lp.phi - P.phi0 + cot * ( 1 - cos( E ) );
  End;
  result := xy;
End;

Function e_inverse_poly( xy: TXY; P: TEzGeoConvert ): TLP; // ellipsoid
Var
  r, c, sp, cp, s2ph, ml, mlb, mlp, dPhi: double;
  i: integer;
  lp: TLP;
Begin
  xy.y := xy.y + P.ml0;
  If abs( xy.y ) <= TOL10 Then
  Begin
    lp.lam := xy.x;
    lp.phi := 0;
  End
  Else
  Begin
    r := xy.y * xy.y + xy.x * xy.x;
    lp.phi := xy.y;
    i := I_ITER;
    While i > 0 Do
    Begin
      //for (lp.phi = xy.y, i = I_ITER; i ; --i)
      sp := sin( lp.phi );
      cp := cos( lp.phi );
      s2ph := sp * ( cp );
      If abs( cp ) < ITOL Then
        Raise exception.create( 'error' );
      mlp := sqrt( 1 - P.es * sp * sp );
      c := sp * mlp / cp;
      ml := pj_mlfn( lp.phi, sp, cp, P );
      mlb := ml * ml + r;
      mlp := P.one_es / ( mlp * mlp * mlp );
      dPhi := ( ml + ml + c * mlb - 2 * xy.y * ( c * ml + 1 ) ) / (
        P.es * s2ph * ( mlb - 2 * xy.y * ml ) / c +
        2 * ( xy.y - ml ) * ( c * mlp - 1 / s2ph ) - mlp - mlp );
      lp.phi := lp.phi + dPhi;
      If abs( dPhi ) <= ITOL Then
        break;
      dec( i );
    End;
    If i = 0 Then
      Raise exception.create( 'error' );
    c := sin( lp.phi );
    lp.lam := arcsin( xy.x * tan( lp.phi ) * sqrt( 1 - P.es * c * c ) ) / sin( lp.phi );
  End;
  result := lp;
End;

Function s_inverse_poly( xy: TXY; P: TEzGeoConvert ): TLP; // spheroid
Var
  B, dphi, tp: double;
  i: integer;
  lp: TLP;
Begin
  xy.y := P.phi0 + xy.y;
  If abs( xy.y ) <= TOL10 Then
  Begin
    lp.lam := xy.x;
    lp.phi := 0;
  End
  Else
  Begin
    lp.phi := xy.y;
    B := xy.x * xy.x + xy.y * xy.y;
    i := N_ITER10;
    Repeat
      tp := tan( lp.phi );
      dphi := ( xy.y * ( lp.phi * tp + 1 ) - lp.phi -
        0.5 * ( lp.phi * lp.phi + B ) * tp ) / ( ( lp.phi - xy.y ) / tp - 1 );
      lp.phi := lp.phi - dphi;
      dec( i );
    Until Not ( ( abs( dphi ) > CONV ) And ( i > 0 ) );
    If i = 0 Then
      Raise exception.create( 'error' );
    lp.lam := arcsin( xy.x * tan( lp.phi ) ) / sin( lp.phi );
  End;
  result := lp;
End;

Procedure poly( P: TEzGeoConvert; init: boolean );
Begin
  If init Then
  Begin
    P.fwd := Nil;
    P.inv := Nil;
    exit;
  End;
  If P.es <> 0 Then
  Begin
    pj_enfn( P );
    P.ml0 := pj_mlfn( P.phi0, sin( P.phi0 ), cos( P.phi0 ), P );
    P.inv := @e_inverse_poly;
    P.fwd := @e_forward_poly;
  End
  Else
  Begin
    P.ml0 := -P.phi0;
    P.inv := @s_inverse_poly;
    P.fwd := @s_forward_poly;
  End;
End;

End.
