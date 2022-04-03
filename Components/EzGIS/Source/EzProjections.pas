Unit EzProjections;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Classes, Windows, ezbase, ezlib ;

Const
  EN_SIZE = 5;
  APA_SIZE = 3;
  HUGE_VAL = 1.0E+300;
  HALFPI = PI / 2;
  FORTPI = PI / 4;
  TWOPI = 2 * PI;

  IS_ANAL_XL_YL = 01; //* derivatives of lon analytic */
  IS_ANAL_XP_YP = 02; //* derivatives of lat analytic */
  IS_ANAL_HK = 04; //* h and k analytic */
  IS_ANAL_CONV = 010; //* convergence analytic */

Type

  // commented projections will be implemented in near future
  TEzProjectionCode = (
    aea,
    //aeqd     ,
    airy,
    //aitoff   ,
    //alsk     ,
    //apian    ,
    //august   ,
    //bacon    ,
    //bipc     ,
    //boggs    ,
    bonne,
    cass,
    cc,
    cea,
    //chamb    ,
    //collg    ,
    //crast    ,
    //denoy    ,
    //eck1     ,
    //eck2     ,
    //eck3     ,
    eck4,
    eck5,
    eck6,
    //eqc      ,
    //eqdc     ,
    //euler    ,
    //fahey    ,
    //fouc     ,
    //fouc_s   ,
    //gall     ,
    //gins8    ,
    gn_sinu,
    //gnom     ,
    //goode    ,
    //gs48     ,
    //gs50     ,
    //hammer   ,
    //hatano   ,
    imw_p,
    //kav5     ,
    //kav7     ,
    //labrd    ,
    laea,
    //lagrng   ,
    //larr     ,
    //lask     ,
    lcc,
    leac,
    //lee_os   ,
    //loxim    ,
    //lsat     ,
    //mbt_s    ,
    //mbt_fps  ,
    //mbtfpp   ,
    //mbtfpq   ,
    mbtfps,
    merc,
    //mil_os   ,
    mill,
    //mpoly    ,
    moll,
    //murd1    ,
    //murd2    ,
    //murd3    ,
    //nell     ,
    //nell_h   ,
    //nicol    ,
    //nsper    ,
    //nzmg     ,
    //ob_tran  ,
    //ocea     ,
    //oea      ,
    omerc,
    //ortel    ,
    ortho,
    //pconic   ,
    poly,
    //putp1    ,
    //putp2    ,
    //putp3    ,
    //putp3p   ,
    //putp4p   ,
    //putp5    ,
    //putp5p   ,
    //putp6    ,
    //putp6p   ,
    //qua_aut  ,
    //robin    ,
    //rpoly    ,
    sinu,
    //somerc   ,
    stere,
    //tcc      ,
    tcea,
    //tissot   ,
    tmerc,
    tpeqd,
    //tpers    ,
    ups,
    //urm5     ,
    //urmfps   ,
    utm,
    //vandg    ,
    //vandg2   ,
    //vandg3   ,
    vandg4,
    //vitk1    ,
    //wag1     ,
    //wag2     ,
    //wag3     ,
    wag4,
    wag5,
    //wag6     ,
    wag7
    //weren    ,
    //wink1    ,
    //wink2    ,
    //wintri
    );

  TEzEllipsoidCode = (
    ecMERIT,
    ecSGS85,
    ecGRS80,
    ecIAU76,
    ecairy,
    ecAPL4_9,
    ecNWL9D,
    ecmod_airy,
    ecandrae,
    ecaust_SA,
    ecGRS67,
    ecbessel,
    ecbess_nam,
    ecclrk66,
    ecclrk80,
    ecCPM,
    ecdelmbr,
    ecengelis,
    ecevrst30,
    ecevrst48,
    ecevrst56,
    ecevrst69,
    ecevrstSS,
    ecfschr60,
    ecfschr60m,
    ecfschr68,
    echelmert,
    echough,
    ecintl,
    eckrass,
    eckaula,
    eclerch,
    ecmprts,
    ecnew_intl,
    ecplessis,
    ecSEasia,
    ecwalbeck,
    ecWGS60,
    ecWGS66,
    ecWGS72,
    ecWGS84,
    ecITRFMEX
    );

  { future use
  TUV = record
     u, v: Double;
  end;

  TCOMPLEX = record
     r, i: Double;
  end; }

  TXY = Record
    x, y: double;
  End;

  TLP = Record
    lam, phi: double;
  End;

  TPJ_ELLPS = Record
    //id: String;
    major: String;
    ell: String;
    name: String;
  End;

  TDERIVS = Record
    x_l, x_p: double;
    y_l, y_p: double;
  End;

  TFACTORS = Record
    der: TDERIVS;
    h, k: double;
    omega, thetap: double;
    conv: double;
    s: double;
    //a,
    b: double;
    code: integer;
  End;

  TEzGeoConvert = Class;

  TForward = Function( lp: TLP; P: TEzGeoConvert ): TXY;
  TInverse = Function( xy: TXY; P: TEzGeoConvert ): TLP;
  TProj = Function( P: TEzGeoConvert; init: boolean ): TEzGeoConvert;
  TSpecial = Procedure( lp: TLP; P: TEzGeoConvert; Var fac: TFACTORS );

  { the list of projections }
  TPJ_LIST = Record
    //ID: String;
    Descr: String;
    Proj: TProj; //projection entry point
  End;

  { projection parameters handling }
  TEzProjectParam = Class
  Private
    fGeoConvert: TEzGeoConvert;
  Public
    Constructor Create( GeoConvert: TEzGeoConvert );
    Function Defined( Const opt: String ): boolean;
    Function AsString( Const opt: String ): String;
    Function AsInteger( Const opt: String ): Integer;
    Function AsFloat( Const opt: String ): double;
    Function AsRadians( Const opt: String ): double;
    Function AsBoolean( Const opt: String ): boolean;
  End;

  //--------- the low level conversion object -------------------------//
  TEzGeoConvert = Class
  Private
    fParaList: TStringList;
    fpj_param: TEzProjectParam;
    Function pj_inv( Var xy: TXY ): TLP;
    Function pj_fwd( Var lp: TLP ): TXY;
    Function pj_ell_set( Var a, es: double ): integer;
  Public
    pj_errno: integer;

    { projection variables }
    fwd: TFarProc; // procedure pointer for converting from lat/long to projection
    inv: TFarProc; // procedure pointer for converting from projection to lat/lon
    spc: TFarProc; // procedure pointer for special processing

    over: boolean;
    geoc: boolean;
    a: double; { major axis or radius if es=0 }
    e: double; { eccentricity }
    es: double; { e ^ 2 }
    ra: double; { 1/A }
    one_es: double; { 1 - e^2 }
    rone_es: double; { 1/one_es }
    lam0, phi0: double; { central longitude, latitude }
    x0, y0: double; { false easting and northing }
    k0: double; { general scaling factor }
    to_meter, fr_meter: double; { cartesian scaling }
    units: String[8]; { for fast access}

    { additional info for every projection }
    ec: double;
    n: double;
    c: double;
    dd: double;
    n2: double;
    rho0: double;
    rho: double;
    phi1: double;
    phi2: double;
    ellips: boolean; // ellipsoid or spheroid

    sinph0: double;
    cosph0: double;
    M1: double;
    N1: double;
    Mp: double;
    He: double;
    G: double;
    mode: Integer;

    p_halfpi: double;
    Cb: double;
    no_cut: boolean; { do not cut at hemisphere limit }

    cosphi1: double;

    bacn: Integer;
    ortl: Integer;

    noskew: Integer;

    cphi1: double;
    am1: double;

    m0: double;
    t: double;
    a1: double;
    r: double;
    d2: double;
    a2: double;
    tn: double;

    ap: double;

    esp: double;
    ml0: double;
    en: Array[0..EN_SIZE] Of double;
    apa: Array[0..APA_SIZE] Of double;
    { oblique mercator data }
    bl: double;
    singam: double;
    al: double;
    el: double;
    cosgam: double;
    u_0: double;
    rot: boolean;
    cosrot: double;
    sinrot: double;
    Gamma: double;
    lamc: double;
    alpha: double;
    lam1: double;
    lam2: double;
    { mollweide}
    C_x: double;
    C_y: double;
    C_p: double;
    sinb1: double;
    cosb1: double;
    xmf: double;
    ymf: double;
    mmf: double;
    rq: double;
    phits: double;
    sinX1: double;
    cosX1: double;
    akm1: double;
    P, Pp, Q, Qp,
      R_1, R_2,
      sphi_1, sphi_2, C2: double;
    phi_1, phi_2,
      lam_1, m,
      sp1, cp1, sp2,
      dlam2, cp2,
      z02, r2z0, ccs, cs, sc, hz0,
      thz0, rhshz0, lp, sa, ca, rk0: double;

    { methods }
    Constructor Create;
    Destructor Destroy; Override;

    Procedure Geo_CoordSysInit( Params: TStringList );
    Procedure Geo_CoordSysFromLatLong( Const Long, Lat: Double; Var x, y: Double );
    Procedure Geo_CoordSysToLatLong( Const x, y: Double; Var Long, Lat: Double );
    Function Geo_Distance( Const Long1, Lat1, Long2, Lat2: Double ): Double;

    Property ParaList: TStringList Read fParaList;
    Property pj_param: TEzProjectParam Read fpj_param;
  End;

  {-----------------------------------------------------------------------------}
  {    TEzProjector - the component used to calculate for projections           }
  {-----------------------------------------------------------------------------}

  TEzProjector = Class( TComponent )
  Private
    FGC: TEzGeoConvert; (* the conversion object *)
    FParams: TStrings; (* the params for conversion *)
    Procedure SetParams( Value: TStrings );
  Public
    Constructor Create( AOwner: TComponent ); Override;
    Destructor Destroy; Override;
    Procedure CoordSysInit;
    Procedure InitDefault;
    Function CheckDefaultParams: Boolean;
    Procedure LoadFromStream( Stream: TStream );
    Procedure SaveToStream( Stream: TStream );
    Procedure LoadFromFile( Const FileName: String );
    Procedure SaveToFile( Const FileName: String );
    Procedure CoordSysFromLatLong( Const Long, Lat: double; Var X, Y: double );
    Procedure CoordSysToLatLong( Const X, Y: double; Var Long, Lat: double );
    Function HasProjection: Boolean;
    Class Function dmstor( Const ins: String ): double;
    {calculate distance from (long1,lat1) to (long2,lat2)
     geodetic inverse problem is used}
    Function GeoDistance( Const Long1, Lat1, Long2, Lat2: double ): double;

    Property GC: TEzGeoConvert Read FGC;
  Published
    Property Params: TStrings Read FParams Write SetParams;
  End;

Const
  { As projections are implemented, they will be uncommented }
  pj_list: Array[TEzProjectionCode] Of TPJ_LIST = (
    ( {id:'aea';    } descr: 'Albers Equal Area'; proj: Nil ),
    //(id:'aeqd';   descr:'Azimuthal Equidistant'                 ; proj:nil),
    ( {id:'airy';   } descr: 'Airy'; proj: Nil ),
    //(id:'aitoff'; descr:'Aitoff'                                ; proj:nil),
    //(id:'alsk';   descr:'Mod. Stererographics of Alaska'        ; proj:nil),
    //(id:'apian';  descr:'Apian Globular I'                      ; proj:nil),
    //(id:'august'; descr:'August Epicycloidal'                   ; proj:nil),
    //(id:'bacon';  descr:'Bacon Globular'                        ; proj:nil),
    //(id:'bipc';   descr:'Bipolar conic of western hemisphere'   ; proj:nil),
    //(id:'boggs';  descr:'Boggs Eumorphic'                       ; proj:nil),
    ( {id:'bonne';  } descr: 'Bonne (Werner lat_1=90)'; proj: Nil ),
    ( {id:'cass';   } descr: 'Cassini'; proj: Nil ),
    ( {id:'cc';     } descr: 'Central Cylindrical'; proj: Nil ),
    ( {id:'cea';    } descr: 'Equal Area Cylindrical'; proj: Nil ),
    //(id:'chamb';  descr:'Chamberlin Trimetric'                  ; proj:nil),
    //(id:'collg';  descr:'Collignon'                             ; proj:nil),
    //(id:'crast';  descr:'Craster Parabolic (Putnins P4)'        ; proj:nil),
    //(id:'denoy';  descr:'Denoyer Semi-Elliptical'               ; proj:nil),
    //(id:'eck1';   descr:'Eckert I'                              ; proj:nil),
    //(id:'eck2';   descr:'Eckert II'                             ; proj:nil),
    //(id:'eck3';   descr:'Eckert III'                            ; proj:nil),
    ( {id:'eck4';   } descr: 'Eckert IV'; proj: Nil ),
    ( {id:'eck5';   } descr: 'Eckert V'; proj: Nil ),
    ( {id:'eck6';   } descr: 'Eckert VI'; proj: Nil ),
    //(id:'eqc';    descr:'Equidistant Cylindrical (Plate Caree)' ; proj:nil),
    //(id:'eqdc';   descr:'Equidistant Conic'                     ; proj:nil),
    //(id:'euler';  descr:'Euler'                                 ; proj:nil),
    //(id:'fahey';  descr:'Fahey'                                 ; proj:nil),
    //(id:'fouc';   descr:'Foucaut'                               ; proj:nil),
    //(id:'fouc_s'; descr:'Foucaut Sinusoidal'                    ; proj:nil),
    //(id:'gall';   descr:'Gall (Gall Stereographic)'             ; proj:nil),
    //(id:'gins8';  descr:'Ginsburg VIII (TsNIIGAiK)'             ; proj:nil),
    ( {id:'gn_sinu';} descr: 'General Sinusoidal Series'; proj: Nil ),
    //(id:'gnom';   descr:'Gnomonic'                              ; proj:nil),
    //(id:'goode';  descr:'Goode Homolosine'                      ; proj:nil),
    //(id:'gs48';   descr:'Mod. Stererographics of 48 U.S.'       ; proj:nil),
    //(id:'gs50';   descr:'Mod. Stererographics of 50 U.S.'       ; proj:nil),
    //(id:'hammer'; descr:'Hammer & Eckert-Greifendorff'          ; proj:nil),
    //(id:'hatano'; descr:'Hatano Asymmetrical Equal Area'        ; proj:nil),
    ( {id:'imw_p';  } descr: 'Internation Map of the World Polyconic'; proj: Nil ),
    //(id:'kav5';   descr:'Kavraisky V'                           ; proj:nil),
    //(id:'kav7';   descr:'Kavraisky VII'                         ; proj:nil),
    //(id:'labrd';  descr:'Laborde'                               ; proj:nil),
    ( {id:'laea';   } descr: 'Lambert Azimuthal Equal Area'; proj: Nil ),
    //(id:'lagrng'; descr:'Lagrange'                              ; proj:nil),
    //(id:'larr';   descr:'Larrivee'                              ; proj:nil),
    //(id:'lask';   descr:'Laskowski'                             ; proj:nil),
    ( {id:'lcc';    } descr: 'Lambert Conformal Conic'; proj: Nil ),
    ( {id:'leac';   } descr: 'Lambert Equal Area Conic'; proj: Nil ),
    //(id:'lee_os'; descr:'Lee Oblated Stereographic'             ; proj:nil),
    //(id:'loxim';  descr:'Loximuthal'                            ; proj:nil),
    //(id:'lsat';   descr:'Space oblique for LANDSAT'             ; proj:nil),
    //(id:'mbt_s';  descr:'McBryde-Thomas Flat-Polar Sine'        ; proj:nil),
    //(id:'mbt_fps';descr:'McBryde-Thomas Flat-Pole Sine (No. 2)' ; proj:nil),
    //(id:'mbtfpp'; descr:'McBride-Thomas Flat-Polar Parabolic'   ; proj:nil),
    //(id:'mbtfpq'; descr:'McBryde-Thomas Flat-Polar Quartic'     ; proj:nil),
    ( {id:'mbtfps'; } descr: 'McBryde-Thomas Flat-Polar Sinusoidal'; proj: Nil ),
    ( {id:'merc';   } descr: 'Mercator'; proj: Nil ),
    //(id:'mil_os'; descr:'Miller Oblated Stereographic'          ; proj:nil),
    ( {id:'mill';   } descr: 'Miller Cylindrical'; proj: Nil ),
    //(id:'mpoly';  descr:'Modified Polyconic'                    ; proj:nil),
    ( {id:'moll';   } descr: 'Mollweide'; proj: Nil ),
    //(id:'murd1';  descr:'Murdoch I'                             ; proj:nil),
    //(id:'murd2';  descr:'Murdoch II'                            ; proj:nil),
    //(id:'murd3';  descr:'Murdoch III'                           ; proj:nil),
    //(id:'nell';   descr:'Nell'                                  ; proj:nil),
    //(id:'nell_h'; descr:'Nell-Hammer'                           ; proj:nil),
    //(id:'nicol';  descr:'Nicolosi Globular'                     ; proj:nil),
    //(id:'nsper';  descr:'Near-sided perspective'                ; proj:nil),
    //(id:'nzmg';   descr:'New Zealand Map Grid'                  ; proj:nil),
    //(id:'ob_tran';descr:'General Oblique Transformation'        ; proj:nil),
    //(id:'ocea';   descr:'Oblique Cylindrical Equal Area'        ; proj:nil),
    //(id:'oea';    descr:'Oblated Equal Area'                    ; proj:nil),
    ( {id:'omerc';  } descr: 'Oblique Mercator'; proj: Nil ),
    //(id:'ortel';  descr:'Ortelius Oval'                         ; proj:nil),
    ( {id:'ortho';  } descr: 'Orthographic'; proj: Nil ),
    //(id:'pconic'; descr:'Perspective Conic'                     ; proj:nil),
    ( {id:'poly';   } descr: 'Polyconic (American)'; proj: Nil ),
    //(id:'putp1';  descr:'Putnins P1'                            ; proj:nil),
    //(id:'putp2';  descr:'Putnins P2'                            ; proj:nil),
    //(id:'putp3';  descr:'Putnins P3'                            ; proj:nil),
    //(id:'putp3p'; descr:'Putnins P3'''                          ; proj:nil),
    //(id:'putp4p'; descr:'Putnins P4'''                          ; proj:nil),
    //(id:'putp5';  descr:'Putnins P5'                            ; proj:nil),
    //(id:'putp5p'; descr:'Putnins P5'''                          ; proj:nil),
    //(id:'putp6';  descr:'Putnins P6'                            ; proj:nil),
    //(id:'putp6p'; descr:'Putnins P6'''                          ; proj:nil),
    //(id:'qua_aut';descr:'Quartic Authalic'                      ; proj:nil),
    //(id:'robin';  descr:'Robinson'                              ; proj:nil),
    //(id:'rpoly';  descr:'Rectangular Polyconic'                 ; proj:nil),
    ( {id:'sinu';   } descr: 'Sinusoidal (Sanson-Flamsteed)'; proj: Nil ),
    //(id:'somerc'; descr:'Swiss. Obl. Mercator'                  ; proj:nil),
    ( {id:'stere';  } descr: 'Stereographic'; proj: Nil ),
    //(id:'tcc';    descr:'Transverse Central Cylindrical'        ; proj:nil),
    ( {id:'tcea';   } descr: 'Transverse Cylindrical Equal Area'; proj: Nil ),
    //(id:'tissot'; descr:'Tissot Conic'                          ; proj:nil),
    ( {id:'tmerc';  } descr: 'Transverse Mercator'; proj: Nil ),
    ( {id:'tpeqd';  } descr: 'Two Point Equidistant'; proj: Nil ),
    //(id:'tpers';  descr:'Tilted perspective'                    ; proj:nil),
    ( {id:'ups';    } descr: 'Universal Polar Stereographic'; proj: Nil ),
    //(id:'urm5';   descr:'Urmaev V'                              ; proj:nil),
    //(id:'urmfps'; descr:'Urmaev Flat-Polar Sinusoidal'          ; proj:nil),
    ( {id:'utm';    } descr: 'Universal Transverse Mercator (UTM)'; proj: Nil ),
    //(id:'vandg';  descr:'van der Grinten (I)'                   ; proj:nil),
    //(id:'vandg2'; descr:'van der Grinten II'                    ; proj:nil),
    //(id:'vandg3'; descr:'van der Grinten III'                   ; proj:nil),
    ( {id:'vandg4'; } descr: 'van der Grinten IV'; proj: Nil ),
    //(id:'vitk1';  descr:'Vitkovsky I'                           ; proj:nil),
    //(id:'wag1';   descr:'Wagner I (Kavraisky VI)'               ; proj:nil),
    //(id:'wag2';   descr:'Wagner II'                             ; proj:nil),
    //(id:'wag3';   descr:'Wagner III'                            ; proj:nil),
    ( {id:'wag4';   } descr: 'Wagner IV'; proj: Nil ),
    ( {id:'wag5';   } descr: 'Wagner V'; proj: Nil ),
    //(id:'wag6';   descr:'Wagner VI'                             ; proj:nil),
    ( {id:'wag7';   } descr: 'Wagner VII'; proj: Nil )
    //(id:'weren';  descr:'Werenskiold I'                         ; proj:nil),
    //(id:'wink1';  descr:'Winkel I'                              ; proj:nil),
    //(id:'wink2';  descr:'Winkel II'                             ; proj:nil),
    //(id:'wintri'; descr:'Winkel Tripel'                         ; proj:nil)
    );

  { NOTE: pj_units[] const array changed to unit ambase.pas }

  { ellipsoid data }
  pj_ellps: Array[TEzEllipsoidCode] Of TPJ_ELLPS = (
    ( {id:'MERIT';    } major: 'a=6378137.0'; ell: 'rf=298.257'; name: 'MERIT 1983'; ),
    ( {id:'SGS85';    } major: 'a=6378136.0'; ell: 'rf=298.257'; name: 'Soviet Geodetic System 85'; ),
    ( {id:'GRS80';    } major: 'a=6378137.0'; ell: 'rf=298.257222101'; name: 'GRS 1980(IUGG, 1980)'; ),
    ( {id:'IAU76';    } major: 'a=6378140.0'; ell: 'rf=298.257'; name: 'IAU 1976'; ),
    ( {id:'airy';     } major: 'a=6377563.396'; ell: 'b=6356256.910'; name: 'Airy 1830'; ),
    ( {id:'APL4.9';   } major: 'a=6378137.0.'; ell: 'rf=298.25'; name: 'Appl. Physics. 1965'; ),
    ( {id:'NWL9D';    } major: 'a=6378145.0.'; ell: 'rf=298.25'; name: 'Naval Weapons Lab., 1965'; ),
    ( {id:'mod_airy'; } major: 'a=6377340.189'; ell: 'b=6356034.446'; name: 'Modified Airy'; ),
    ( {id:'andrae';   } major: 'a=6377104.43'; ell: 'rf=300.0'; name: 'Andrae 1876 (Den., Iclnd.)'; ),
    ( {id:'aust_SA';  } major: 'a=6378160.0'; ell: 'rf=298.25'; name: 'Australian Natl & S. Amer. 196'; ),
    ( {id:'GRS67';    } major: 'a=6378160.0'; ell: 'rf=298.2471674270'; name: 'GRS 67(IUGG 1967)'; ),
    ( {id:'bessel';   } major: 'a=6377397.155'; ell: 'rf=299.1528128'; name: 'Bessel 1841'; ),
    ( {id:'bess_nam'; } major: 'a=6377483.865'; ell: 'rf=299.1528128'; name: 'Bessel 1841 (Namibia)'; ),
    ( {id:'clrk66';   } major: 'a=6378206.4'; ell: 'b=6356583.8'; name: 'Clarke 1866 (NAD-27)'; ),
    ( {id:'clrk80';   } major: 'a=6378249.145'; ell: 'rf=293.4663'; name: 'Clarke 1880 mod.'; ),
    ( {id:'CPM';      } major: 'a=6375738.7'; ell: 'rf=334.29'; name: 'Comm. des Poids et Mesures 179'; ),
    ( {id:'delmbr';   } major: 'a=6376428.'; ell: 'rf=311.5'; name: 'Delambre 1810 (Belgium)'; ),
    ( {id:'engelis';  } major: 'a=6378136.05'; ell: 'rf=298.2566'; name: 'Engelis 1985'; ),
    ( {id:'evrst30';  } major: 'a=6377276.345'; ell: 'rf=300.8017'; name: 'Everest 1830'; ),
    ( {id:'evrst48';  } major: 'a=6377304.063'; ell: 'rf=300.8017'; name: 'Everest 1948'; ),
    ( {id:'evrst56';  } major: 'a=6377301.243'; ell: 'rf=300.8017'; name: 'Everest 1956'; ),
    ( {id:'evrst69';  } major: 'a=6377295.664'; ell: 'rf=300.8017'; name: 'Everest 1969'; ),
    ( {id:'evrstSS';  } major: 'a=6377298.556'; ell: 'rf=300.8017'; name: 'Everest (Sabah & Sarawak)'; ),
    ( {id:'fschr60';  } major: 'a=6378166.'; ell: 'rf=298.3'; name: 'Fischer (Mercury Datum) 1960'; ),
    ( {id:'fschr60m'; } major: 'a=6378155.'; ell: 'rf=298.3'; name: 'Modified Fischer 1960'; ),
    ( {id:'fschr68';  } major: 'a=6378150.'; ell: 'rf=298.3'; name: 'Fischer 1968'; ),
    ( {id:'helmert';  } major: 'a=6378200.'; ell: 'rf=298.3'; name: 'Helmert 1906'; ),
    ( {id:'hough';    } major: 'a=6378270.0'; ell: 'rf=297.'; name: 'Hough'; ),
    ( {id:'intl';     } major: 'a=6378388.0'; ell: 'rf=297.'; name: 'International 1909 (Hayford)'; ),
    ( {id:'krass';    } major: 'a=6378245.0'; ell: 'rf=298.3'; name: 'Krassovsky, 1942'; ),
    ( {id:'kaula';    } major: 'a=6378163.'; ell: 'rf=298.24'; name: 'Kaula 1961'; ),
    ( {id:'lerch';    } major: 'a=6378139.'; ell: 'rf=298.257'; name: 'Lerch 1979'; ),
    ( {id:'mprts';    } major: 'a=6397300.'; ell: 'rf=191.'; name: 'Maupertius 1738'; ),
    ( {id:'new_intl'; } major: 'a=6378157.5'; ell: 'b=6356772.2'; name: 'New International 1967'; ),
    ( {id:'plessis';  } major: 'a=6376523.'; ell: 'b=6355863.'; name: 'Plessis 1817 (France)'; ),
    ( {id:'SEasia';   } major: 'a=6378155.0'; ell: 'b=6356773.3205'; name: 'Southeast Asia'; ),
    ( {id:'walbeck';  } major: 'a=6376896.0'; ell: 'b=6355834.8467'; name: 'Walbeck'; ),
    ( {id:'WGS60';    } major: 'a=6378165.0'; ell: 'rf=298.3'; name: 'WGS 60'; ),
    ( {id:'WGS66';    } major: 'a=6378145.0'; ell: 'rf=298.25'; name: 'WGS 66'; ),
    ( {id:'WGS72';    } major: 'a=6378135.0'; ell: 'rf=298.26'; name: 'WGS 72'; ),
    ( {id:'WGS84';    } major: 'a=6378137.0'; ell: 'rf=298.257223563'; name: 'WGS 84'; ),
    ( {id:'ITRFMEX';  } major: 'a=6378137'; ell: 'b=6356752.3141'; name: 'ITRF (Mexico)' ) );

Function ProjCodeFromID( Const id: String; Var found: boolean ): TEzProjectionCode;
Function EllpsCodeFromID( Const id: String ): TEzEllipsoidCode;
//function UnitCodeFromName(const name:String) : TEzCoordsUnits;
Procedure LatLonFromXYOffset( gc: TEzGeoConvert;
  Const Lat, Lon: double;
  Var Dy, Dx: double );

Implementation

Uses
  EzProjimpl, TypInfo, ezsystem, ezconsts, fProj, Math;

//---------------------------------------------------------------------//

Procedure LatLonFromXYOffset( gc: TEzGeoConvert;
  Const Lat, Lon: Double;
  Var Dy, Dx: Double );
Var
  X, Y: double;
  NewLat, NewLon: double;
Begin
  (* transform to XY *)
  gc.Geo_CoordSysFromLatLong( Lon, Lat, X, Y );
  (* offset the specified distance *)
  X := X + Dx;
  Y := Y + Dy;
  (* and reset back to lat/lon *)
  gc.Geo_CoordSysToLatLong( X, Y, NewLon, NewLat );
  Dy := ( NewLat - Lat );
  Dx := ( NewLon - Lon );
End;

{ Implements TEzProjector object }

Constructor TEzProjector.Create( AOwner: TComponent );
Begin
  Inherited Create( AOwner );
  FGC := TEzGeoConvert.Create;
  FParams := TStringList.Create;
  CheckDefaultParams;
End;

Destructor TEzProjector.Destroy;
Begin
  FGC.Free;
  FParams.Free;
  Inherited Destroy;
End;

Function TEzProjector.GeoDistance( Const Long1, Lat1, Long2, Lat2: double ): double;
Begin
  result := FGC.Geo_Distance( Long1, Lat1, Long2, Lat2 );
End;

Procedure TEzProjector.LoadFromStream( Stream: TStream );
Begin
  FParams.Clear;
  FParams.LoadFromStream( Stream );
  CheckDefaultParams;
  FGC.Geo_CoordSysInit( TStringList( FParams ) );
End;

Procedure TEzProjector.SaveToStream( Stream: TStream );
Begin
  CheckDefaultParams;
  FParams.SaveToStream( Stream );
End;

Procedure TEzProjector.LoadFromFile( Const FileName: String );
Var
  Stream: TStream;
Begin
  If Not FileExists( FileName ) Then
    Exit;
  Stream := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyNone );
  Try
    Self.LoadFromStream( Stream );
  Finally
    Stream.free;
  End;
End;

Procedure TEzProjector.SaveToFile( Const FileName: String );
Var
  Stream: TStream;
Begin
  If Not FileExists( FileName ) Then
    Exit;
  Stream := TFileStream.Create( FileName, fmCreate );
  Try
    Self.SaveToStream( Stream );
  Finally
    Stream.free;
  End;
End;

Procedure TEzProjector.InitDefault;
Begin
  FParams.Clear;
  CheckDefaultParams;
  CoordSysInit;
End;

Procedure TEzProjector.CoordSysInit;
Begin
  FGC.Geo_CoordSysInit( TStringList( FParams ) );
End;

Function TEzProjector.HasProjection: Boolean;
Begin
  result := FGC.fwd <> Nil;
End;

Function TEzProjector.CheckDefaultParams: Boolean;
Begin
  Result := True;
  If FParams.IndexOfName( 'units' ) < 0 Then
  Begin
    FParams.Insert( 0, 'units=m' );
    Result := False;
  End;
  If FParams.IndexOfName( 'ellps' ) < 0 Then
  Begin
    FParams.Insert( 0, 'ellps=WGS84' );
    Result := False;
  End;
  If FParams.IndexOfName( 'proj' ) < 0 Then
  Begin
    FParams.Insert( 0, 'proj=utm' );
    If FParams.IndexOfName( 'zone' ) < 0 Then
      FParams.Add( 'zone=12' ); // our zone :-)
    Result := False;
  End;
End;

Procedure TEzProjector.CoordSysFromLatLong( Const Long, Lat: double; Var X, Y: double );
Begin
  FGC.Geo_CoordSysFromLatLong( Long, Lat, X, Y );
End;

Procedure TEzProjector.CoordSysToLatLong( Const X, Y: double; Var Long, Lat: double );
Begin
  FGC.Geo_CoordSysToLatLong( X, Y, Long, Lat );
End;

Procedure TEzProjector.SetParams( Value: TStrings );
Begin
  FParams.Assign( Value );
End;

{ Convert DMS string to radians }

Class Function TEzProjector.dmstor( Const ins: String ): double;
Const
  sym = 'NnEeSsWw';
Var
  i, p, nl, last, code: integer;
  sign: char;
  work, temp: String;
  v, tv: double;
Begin
  result := 0;
  work := Trim( UpperCase( ins ) );
  If length( work ) = 0 Then Exit; //+46.65d57'8.660"N
  val( work, v, code );
  If code = 0 Then
  Begin
    result := v;
    exit;
  End;
  If ( length( work ) > 1 ) And ( work[length( work )] = 'R' ) Then
  Begin
    val( copy( work, 1, length( work ) - 1 ), v, code );
    If code = 0 Then
    Begin
      result := v;
      exit;
    End;
  End;
  sign := work[1];
  If Not ( sign In ['+', '-'] ) Then
    sign := '+';
  i := 1;
  last := i;
  v := 0;
  nl := 0;
  // +46.65d57'8.660"N
  While i <= length( work ) Do
  Begin
    If work[i] In ['D', #39, #34] Then
    Begin
      Val( copy( work, last, ( i - last ) ), tv, Code );
      Case work[i] Of
        'D':
          Begin
            v := v + tv * 0.0174532925199433;
            nl := 1;
          End;
        #39: // '
          Begin
            v := v + tv * 0.0002908882086657216;
            nl := 2;
          End;
        #34: // "
          Begin
            v := v + tv * 0.0000048481368110953599;
            nl := 3;
          End;
      End;
      last := i + 1;
    End;
    inc( i );
  End;
  If last <= length( work ) Then
  Begin
    p := AnsiPos( work[length( work )], sym );
    If p > 0 Then
    Begin
      temp := copy( work, last, length( work ) - last );
      If p >= 4 Then
        sign := '-'
      Else
        sign := '+';
    End
    Else
    Begin
      temp := copy( work, last, length( work ) );
    End;
    If length( temp ) > 0 Then
    Begin
      val( temp, tv, code );
      Case nl Of
        0: v := v + tv * 0.0174532925199433;
        1: v := v + tv * 0.0002908882086657216;
        2: v := v + tv * 0.0000048481368110953599;
      End;
    End;
  End;
  If sign = '-' Then
    v := -v;
  result := v;

End;

{ SOLUTION OF THE GEODETIC INVERSE PROBLEM
  MODIFIED RAINSFORD'S METHOD WITH HELMERT'S ELLIPTICAL TERMS
  EFFECTIVE IN ANY AZIMUTH AND AT ANY DISTANCE SHORT OF ANTIPODAL
  STANDPOINT / FOREPOINT MUST NOT BE THE GEOGRAPHIC POLE

  A IS THE SEMI-MAJOR AXIS OF THE REFERENCE ELLIPSOID
  F IS THE FLATTENING (NOT RECIPROCAL) OF THE REFERENCE ELLIPSOID
  LATITUDES AND LONGITUDES IN RADIANS POSITIVE NORTH AND EAST
  FORWARD AZIMUTHS AT BOTH POINTS RETURNED IN RADIANS FROM NORTH }

Procedure invert1( Const glat1, glon1, glat2, glon2, a, f: double;
  Var faz, baz, s: double );
Const
  EPS = 0.5E-13;
Var
  r, tu1, tu2, cu1, su1, cu2, x, sx, cx, sy, cy, y, sa, c2a, cz, e, c, d: double;
Begin
  r := 1.0 - f;
  tu1 := r * sin( glat1 ) / cos( glat1 );
  tu2 := r * sin( glat2 ) / cos( glat2 );
  cu1 := 1.0 / sqrt( tu1 * tu1 + 1.0 );
  su1 := cu1 * tu1;
  cu2 := 1.0 / sqrt( tu2 * tu2 + 1.0 );
  s := cu1 * cu2;
  baz := s * tu2;
  faz := baz * tu1;
  x := glon2 - glon1;
  Repeat
    sx := sin( x );
    cx := cos( x );
    tu1 := cu2 * sx;
    tu2 := baz - su1 * cu2 * cx;
    sy := sqrt( tu1 * tu1 + tu2 * tu2 );
    cy := s * cx + faz;
    y := Math.arctan2( sy, cy );
    sa := s * sx / sy;
    c2a := -sa * sa + 1.0;
    cz := faz + faz;
    If c2a > 0 Then
      cz := -cz / c2a + cy;
    e := cz * cz * 2.0 - 1.0;
    c := ( ( -3.0 * c2a + 4.0 ) * f + 4.0 ) * c2a * f / 16.0;
    d := x;
    x := ( ( e * cy * c + cz ) * sy * c + y ) * sa;
    x := ( 1.0 - c ) * x * f + glon2 - glon1;
  Until abs( d - x ) <= EPS;
  faz := Math.arctan2( tu1, tu2 );
  baz := Math.arctan2( cu1 * sx, baz * cx - su1 * cu2 ) + System.PI;
  x := sqrt( ( 1.0 / r / r - 1.0 ) * c2a + 1.0 ) + 1.0;
  x := ( x - 2.0 ) / x;
  c := 1.0 - x;
  c := ( x * x / 4.0 + 1.0 ) / c;
  d := ( 0.375 * x * x - 1.0 ) * x;
  x := e * cy;
  s := 1.0 - e - e;
  s := ( ( ( ( sy * sy * 4.0 - 3.0 ) * s * cz * d / 6.0 - x ) * d / 4.0 + cz ) * sy * d + y ) * c * a * r;
End;

Function ProjCodeFromID( Const ID: String; Var found: boolean ): TEzProjectionCode;
Var
  i: TEzProjectionCode;
Begin
  found := false;
  result := Low( TEzProjectionCode );
  For i := Low( pj_list ) To High( pj_list ) Do
    If AnsiCompareText( GetEnumName( System.TypeInfo( TEzProjectionCode ), Ord( i ) ), ID ) = 0 Then
    Begin
      result := i;
      found := true;
      exit;
    End;
End;

Function EllpsCodeFromID( Const ID: String ): TEzEllipsoidCode;
Var
  i: TEzEllipsoidCode;
  en: String;
Begin
  result := Low( TEzEllipsoidCode );
  For i := Low( TEzEllipsoidCode ) To High( TEzEllipsoidCode ) Do
  Begin
    en := GetEnumName( System.TypeInfo( TEzEllipsoidCode ), Ord( i ) );
    If AnsiCompareText( copy( en, 3, length( en ) ), ID ) = 0 Then //pj_ellps[i].ID
    Begin
      result := i;
      exit;
    End;
  End;
End;

//  -------------------------------------------------------------------- //

Constructor TEzProjectParam.Create( GeoConvert: TEzGeoConvert );
Begin
  Inherited Create;
  fGeoConvert := GeoConvert;
End;

Function TEzProjectParam.Defined( Const opt: String ): boolean;
Begin
  result := Length( fGeoConvert.fParaList.Values[opt] ) > 0;
End;

Function TEzProjectParam.AsString( Const opt: String ): String;
Begin
  Result := AnsiLowerCase( fGeoConvert.fParaList.Values[opt] );
End;

Function TEzProjectParam.AsInteger( Const opt: String ): Integer;
Var
  Value: String;
Begin
  Value := AnsiLowerCase( fGeoConvert.fParaList.Values[opt] );
  If Length( Value ) > 0 Then
    result := StrToInt( Value )
  Else
    result := 0;
End;

Function TEzProjectParam.AsFloat( Const opt: String ): double;
Var
  Value: String;
  code: integer;
Begin
  Value := AnsiLowerCase( fGeoConvert.fParaList.Values[opt] );
  If Length( Value ) > 0 Then
    val( Value, result, code )
  Else
    result := 0;
End;

Function TEzProjectParam.AsBoolean( Const opt: String ): boolean;
Begin
  result := AnsiCompareText( fGeoConvert.fParaList.Values[opt], 't' ) = 0;
End;

Function TEzProjectParam.AsRadians( Const opt: String ): double;
Var
  Value: String;
Begin
  Value := AnsiLowerCase( fGeoConvert.fParaList.Values[opt] );
  If Length( Value ) > 0 Then
    result := TEzProjector.dmstor( Value )
  Else
    result := 0;
End;

//  -------------------------------------------------------------------- //
Const
  SIXTH = 0.1666666666666666667; // 1/6
  RA4 = 0.04722222222222222222; // 17/360
  RA6 = 0.02215608465608465608; // 67/3024
  RV4 = 0.06944444444444444444; // 5/72
  RV6 = 0.04243827160493827160; // 55/1296

Constructor TEzGeoConvert.Create;
Begin
  Inherited Create;
  fpj_param := TEzProjectParam.Create( Self );
  fParaList := TStringList.Create;
  { default parameters }
  fParaList.Add( 'units=m' );
  fParaList.Add( 'ellps=WGS84' );
  fParaList.Add( 'proj=utm' );
  fParaList.Add( 'zone=12' ); // our zone :-)
End;

Destructor TEzGeoConvert.Destroy;
Begin
  fpj_param.free;
  fParaList.free;
  Inherited Destroy;
End;

{ initialize geographic shape parameters }

Function TEzGeoConvert.pj_ell_set( Var a, es: double ): integer;
Label
  bomb;
Var
  i, last: Integer;
  b, e: double;
  name, s, en: String;
  found, defined: boolean;
  tmp, tmp2: double;
  pl: TStringList;
  c: TEzEllipsoidCode;
Begin
  Result := 0;
  pl := fParaList;

  last := pl.count;
  // check for varying forms of ellipsoid input
  a := 0;
  es := 0;
  // R takes precedence
  If pj_param.Defined( 'R' ) Then
    a := pj_param.AsFloat( 'R' )
  Else
  Begin { probable elliptical figure }
    name := pj_param.AsString( 'ellps' );
    { check if ellps present and temporarily append its values to pl }
    If Length( name ) > 0 Then
    Begin
      found := false;
      For c := low( TEzEllipsoidCode ) To high( TEzEllipsoidCode ) Do
      Begin
        en := GetEnumName( System.TypeInfo( TEzEllipsoidCode ), Ord( c ) );
        If AnsiCompareText( copy( en, 3, length( en ) ), Name ) = 0 Then //pj_ellps[i].ID
        Begin
          pl.add( pj_ellps[c].major );
          pl.add( pj_ellps[c].ell );
          found := true;
          break;
        End;
      End;
      If Not found Then
      Begin
        pj_errno := -9;
        exit;
      End;
    End;
    a := pj_param.AsFloat( 'a' );
    b := 0;
    If pj_param.Defined( 'es' ) Then { eccentricity squared }
      es := pj_param.AsFloat( 'es' )
    Else If pj_param.Defined( 'e' ) Then
    Begin { eccentricity }
      e := pj_param.AsFloat( 'e' );
      es := e * e;
    End
    Else If pj_param.Defined( 'rf' ) Then
    Begin { reciprocal flattening }
      es := pj_param.AsFloat( 'rf' );
      If es = 0 Then
      Begin
        pj_errno := -10;
        Goto bomb;
      End;
      es := 1 / es;
      es := es * ( 2 - es );
    End
    Else If pj_param.Defined( 'f' ) Then
    Begin { flattening }
      es := pj_param.AsFloat( 'f' );
      es := es * ( 2 - es );
    End
    Else If pj_param.Defined( 'b' ) Then
    Begin { minor axis }
      b := pj_param.AsFloat( 'b' );
      es := 1 - ( b * b ) / ( a * a );
    End; { else es = 0 and sphere of radius a }
    If b = 0 Then
      b := a * sqrt( 1 - es );
    { following options turn ellipsoid into equivalent sphere }
    If pj_param.AsBoolean( 'R_A' ) Then
    Begin { sphere -- area of ellipsoid }
      a := a * ( 1 - es * ( SIXTH + es * ( RA4 + es * RA6 ) ) );
      es := 0;
    End
    Else If pj_param.AsBoolean( 'R_V' ) Then
    Begin { sphere -- vol. of ellipsoid }
      a := a * ( 1 - es * ( SIXTH + es * ( RV4 + es * RV6 ) ) );
      es := 0.0;
    End
    Else If pj_param.AsBoolean( 'R_a' ) Then
    Begin { sphere -- arithmetic mean }
      a := 0.5 * ( a + b );
      es := 0;
    End
    Else If pj_param.AsBoolean( 'R_g' ) Then
    Begin { sphere -- geometric mean }
      a := sqrt( a * b );
      es := 0.0;
    End
    Else If pj_param.AsBoolean( 'R_h' ) Then
    Begin { sphere -- harmonic mean }
      a := 2 * a * b / ( a + b );
      es := 0;
    End
    Else
    Begin
      defined := pj_param.Defined( 'R_lat_a' );
      If defined Or { sphere -- arith. }
      pj_param.Defined( 'R_lat_g' ) Then
      Begin { or geom. mean at latitude }
        If defined Then
          s := 'R_lat_a'
        Else
          s := 'R_lat_g';
        tmp := Sin( pj_param.AsFloat( s ) );
        If abs( tmp ) > HALFPI Then
        Begin
          pj_errno := -11;
          Goto bomb;
        End;
        tmp := 1 - es * tmp * tmp;
        If defined Then
          tmp2 := 0.5 * ( 1 - es + tmp ) / ( tmp * sqrt( tmp ) )
        Else
          tmp2 := sqrt( 1 - es ) / tmp;
        a := a * tmp2;
        es := 0;
      End;
    End;
    bomb:
    For i := last To pl.count - 1 Do
      pl.delete( last );
    If pj_errno <> 0 Then
    Begin
      result := 1;
      exit;
    End;
  End;
  { some remaining checks }
  If es < 0 Then
  Begin
    pj_errno := -12;
    result := 1;
    exit;
  End;
  If a <= 0 Then
  Begin
    pj_errno := -13;
    result := 1;
    exit;
  End;
  result := 0;
End;

// ----------------------------------------------------------------------
Const
  EPS = 1.0E-12;

  { forward projection entry }

Function TEzGeoConvert.pj_fwd( Var lp: TLP ): TXY;
Var
  xy: TXY;
  t: double;
Begin
  { check for forward and latitude or longitude overange }
  t := abs( lp.phi ) - HALFPI;
  If ( t > EPS ) Or ( abs( lp.lam ) > 10 ) Then
  Begin
    xy.y := HUGE_VAL;
    xy.x := xy.y;
    pj_errno := -14;
  End
  Else
  Begin { proceed with projection }
    pj_errno := 0;
    If abs( t ) <= EPS Then
    Begin
      If lp.phi < 0 Then
        lp.phi := -HALFPI
      Else
        lp.phi := HALFPI;
    End
    Else If geoc Then
      lp.phi := arctan( rone_es * tan( lp.phi ) );
    lp.lam := lp.lam - lam0; { compute del lp.lam }
    If Not over Then
      lp.lam := adjlon( lp.lam ); { adjust del longitude }
    xy := TForward( fwd )( lp, self ); { project }
    If pj_errno <> 0 Then
    Begin
      xy.y := HUGE_VAL;
      xy.x := xy.y;
    End
    Else
    Begin
      { adjust for major axis and easting/northings }
      xy.x := fr_meter * ( a * xy.x + x0 );
      xy.y := fr_meter * ( a * xy.y + y0 );
    End;
  End;
  result := xy;
End;

// ------------------------------------------------------------------ //
{ inverse projection entry }

resourcestring
  serr0 = 'Inverse conversion not implemented';
  
Function TEzGeoConvert.pj_inv( Var xy: TXY ): TLP;
Var
  lp: TLP;
Begin
  { can't do as much preliminary checking as with forward }
  If inv = Nil Then
    Raise Exception.Create( serr0 );
  If ( xy.x = HUGE_VAL ) Or ( xy.y = HUGE_VAL ) Then
  Begin
    lp.phi := HUGE_VAL;
    lp.lam := lp.phi;
    pj_errno := -15;
    exit;
  End;
  pj_errno := 0;
  xy.x := ( xy.x * to_meter - x0 ) * ra; { de-scale and de-offset }
  xy.y := ( xy.y * to_meter - y0 ) * ra;
  lp := TInverse( inv )( xy, Self ); { inverse project }
  If pj_errno <> 0 Then
  Begin
    lp.phi := HUGE_VAL;
    lp.lam := lp.phi;
  End
  Else
  Begin
    lp.lam := lp.lam + lam0; { reduce from del lp.lam }
    If Not over Then
      lp.lam := adjlon( lp.lam ); { adjust longitude to CM }
    If geoc And ( abs( abs( lp.phi ) - HALFPI ) > EPS ) Then
      lp.phi := arctan( one_es * tan( lp.phi ) );
  End;
  result := lp;
End;

// ------------------------------------------------------------------ //

Procedure TEzGeoConvert.Geo_CoordSysInit( Params: TStringList );
Var
  name, s, temp: String;
  proj: TProj;
  pc: TEzProjectionCode;
  found: boolean;
  pl: TStringList;

  Procedure SetUnits;
  Var
    i: TEzCoordsUnits;
    //en: String;
  Begin
    { set units }
    s := '';
    name := pj_param.AsString( 'units' );
    If Length( name ) > 0 Then
    Begin
      units := name;
      found := false;
      For i := low( pj_units ) To high( pj_units ) Do
      Begin
        //en := GetEnumName( System.TypeInfo( TEzCoordsUnits ), Ord( i ) );
        If AnsiCompareText( pj_units[i].ID{copy( en, 3, length( en ) )}, Name ) = 0 Then 
        Begin
          found := true;
          break;
        End;
      End;
      If Not found Then
      Begin
        pj_errno := -7;
        exit;
      End;
      s := FloatToStr( pj_units[i].to_meter );
    End;
    temp := pj_param.AsString( 'to_meter' );
    If Length( temp ) > 0 Then
      s := temp;
    If Length( s ) > 0 Then
    Begin
      to_meter := StrToFloat( s );
      fr_meter := 1 / to_meter;
    End
    Else
    Begin
      fr_meter := 1;
      to_meter := fr_meter;
    End;
  End;

Begin
  { this signals as not having a projection }
  fwd := Nil;
  inv := Nil;
  spc := Nil;

  fParaList.Assign( Params );

  pl := fParaList;
  pj_errno := 0;

  If pl.count = 0 Then
  Begin
    pj_errno := -1;
    exit;
  End;

  { find projection selection }
  name := pj_param.AsString( 'proj' );
  If Length( name ) = 0 Then
  Begin
    pj_errno := -4;
    exit;
  End;
  found := false;
  pc := ProjCodeFromID( name, found );
  {for pc := low(pj_list) to high(pj_list) do
  begin
     if AnsiCompareText(pj_list[pc].id,name)=0 then
     begin
        found := true;
        break;
     end;
  end;}
  If Not found Then
  Begin
    pj_errno := -5;
    exit;
  End;
  proj := pj_list[pc].proj;
  { initialize projection structure }
  proj( self, true );
  { set ellipsoid/sphere parameters }
  If pj_ell_set( a, es ) <> 0 Then
  Begin
    exit;
  End;
  e := sqrt( es );
  ra := 1 / a;
  one_es := 1 - es;
  If one_es = 0 Then
  Begin
    pj_errno := -6;
    exit;
  End;
  rone_es := 1 / one_es;
  { set PIN.geoc coordinate system }
  self.geoc := ( es <> 0 ) And pj_param.AsBoolean( 'geoc' );
  { over-ranging flag }
  self.over := pj_param.AsBoolean( 'over' );
  { central meridian }
  self.lam0 := pj_param.AsRadians( 'lon_0' );
  { central latitude }
  self.phi0 := pj_param.AsRadians( 'lat_0' );
  { false easting and northing }
  self.x0 := pj_param.asfloat( 'x_0' );
  self.y0 := pj_param.asfloat( 'y_0' );
  { general scaling factor }
  If pj_param.Defined( 'k_0' ) Then
    self.k0 := pj_param.asfloat( 'k_0' )
  Else If pj_param.Defined( 'k' ) Then
    self.k0 := pj_param.asfloat( 'k' )
  Else
    self.k0 := 1;
  If self.k0 <= 0 Then
  Begin
    pj_errno := -31;
    exit;
  End;

  { set units of projection }
  SetUnits;
  If pj_errno <> 0 Then
  Begin
    exit;
  End;

  { projection specific initialization }
  proj( self, false );
  //if pj_errno <> 0 then
  //begin
     // you can raise error here and clean up some memory if needed (not now)
  //end;
End;

Procedure TEzGeoConvert.Geo_CoordSysToLatLong( Const x, y: Double; Var Long, Lat: Double );
Var
  lp: TLP;
  xy: TXY;
Begin
  { returns Long, Lat in degrees }
  xy.x := x;
  xy.y := y;
  lp := pj_inv( xy );
  long := RadToDeg( lp.lam );
  lat := RadToDeg( lp.phi );
End;

Procedure TEzGeoConvert.Geo_CoordSysFromLatLong( Const Long, Lat: Double; Var x, y: Double );
Var
  lp: TLP;
  xy: TXY;
Begin
  { receives long,lat in degrees }
  lp.lam := DegToRad( long );
  lp.phi := DegToRad( lat );
  xy := pj_fwd( lp );
  x := xy.x;
  y := xy.y;
End;

{calculate distance from (long1,lat1) to (long2,lat2)
 geodetic inverse problem is used}

Function TEzGeoConvert.Geo_Distance( Const Long1, Lat1, Long2, Lat2: Double ): Double;
Var
  faz, baz, b: double; //Forward and Backward azimuth
Begin
  b := a * sqrt( 1 - es );
  invert1( DegToRad( lat1 ),
    DegToRad( long1 ),
    DegToRad( lat2 ),
    DegToRad( long2 ),
    a,
    ( a - b ) / a,
    faz,
    baz,
    Result );
  Result := Result * fr_meter; // return in units configured, example feet
End;
// ----------------------------------------------------------------------

Initialization
  pj_list[aea].proj := @EzProjImpl.aea;
  //pj_list[aeqd     ].proj := nil;
  pj_list[airy].proj := @EzProjImpl.airy;
  //pj_list[aitoff   ].proj := nil;
  //pj_list[alsk     ].proj := nil;
  //pj_list[apian    ].proj := nil;
  //pj_list[august   ].proj := nil;
  //pj_list[bacon    ].proj := nil;
  //pj_list[bipc     ].proj := nil;
  //pj_list[boggs    ].proj := nil;
  pj_list[bonne].proj := @EzProjImpl.bonne;
  pj_list[cass].proj := @EzProjImpl.cass;
  pj_list[cc].proj := @EzProjImpl.cc;
  pj_list[cea].proj := @EzProjImpl.cea;
  //pj_list[chamb    ].proj := nil;
  //pj_list[collg    ].proj := nil;
  //pj_list[crast    ].proj := nil;
  //pj_list[denoy    ].proj := nil;
  //pj_list[eck1     ].proj := nil;
  //pj_list[eck2     ].proj := nil;
  //pj_list[eck3     ].proj := nil;
  pj_list[eck4].proj := @EzProjImpl.eck4;
  pj_list[eck5].proj := @EzProjImpl.eck5;
  pj_list[eck6].proj := @EzProjImpl.eck6;
  //pj_list[eqc      ].proj := nil;
  //pj_list[eqdc     ].proj := nil;
  //pj_list[euler    ].proj := nil;
  //pj_list[fahey    ].proj := nil;
  //pj_list[fouc     ].proj := nil;
  //pj_list[fouc_s   ].proj := @EzProjImpl.fouc_s;
  //pj_list[gall     ].proj := nil;
  //pj_list[gins8    ].proj := nil;
  pj_list[gn_sinu].proj := @EzProjImpl.gn_sinu;
  //pj_list[gnom     ].proj := nil;
  //pj_list[goode    ].proj := nil;
  //pj_list[gs48     ].proj := nil;
  //pj_list[gs50     ].proj := nil;
  //pj_list[hammer   ].proj := nil;
  //pj_list[hatano   ].proj := nil;
  pj_list[imw_p].proj := @EzProjImpl.imw_p;
  //pj_list[kav5     ].proj := nil;
  //pj_list[kav7     ].proj := nil;
  //pj_list[labrd    ].proj := nil;
  pj_list[laea].proj := @EzProjImpl.laea;
  //pj_list[lagrng   ].proj := nil;
  //pj_list[larr     ].proj := nil;
  //pj_list[lask     ].proj := nil;
  pj_list[lcc].proj := @EzProjImpl.lcc;
  pj_list[leac].proj := @EzProjImpl.leac;
  //pj_list[lee_os   ].proj := nil;
  //pj_list[loxim    ].proj := nil;
  //pj_list[lsat     ].proj := nil;
  //pj_list[mbt_s    ].proj := nil;
  //pj_list[mbt_fps  ].proj := nil;
  //pj_list[mbtfpp   ].proj := nil;
  //pj_list[mbtfpq   ].proj := nil;
  pj_list[mbtfps].proj := @EzProjImpl.mbtfps;
  pj_list[merc].proj := @EzProjImpl.merc;
  //pj_list[mil_os   ].proj := nil;
  pj_list[mill].proj := @EzProjImpl.mill;
  //pj_list[mpoly    ].proj := nil;
  pj_list[moll].proj := @EzProjImpl.moll;
  //pj_list[murd1    ].proj := nil;
  //pj_list[murd2    ].proj := nil;
  //pj_list[murd3    ].proj := nil;
  //pj_list[nell     ].proj := nil;
  //pj_list[nell_h   ].proj := nil;
  //pj_list[nicol    ].proj := nil;
  //pj_list[nsper    ].proj := nil;
  //pj_list[nzmg     ].proj := nil;
  //pj_list[ob_tran  ].proj := nil;
  //pj_list[ocea     ].proj := nil;
  //pj_list[oea      ].proj := nil;
  pj_list[omerc].proj := @EzProjImpl.omerc;
  //pj_list[ortel    ].proj := nil;
  pj_list[ortho].proj := @EzProjImpl.ortho;
  //pj_list[pconic   ].proj := nil;
  pj_list[poly].proj := @EzProjImpl.poly;
  //pj_list[putp1    ].proj := nil;
  //pj_list[putp2    ].proj := nil;
  //pj_list[putp3    ].proj := nil;
  //pj_list[putp3p   ].proj := nil;
  //pj_list[putp4p   ].proj := nil;
  //pj_list[putp5    ].proj := nil;
  //pj_list[putp5p   ].proj := nil;
  //pj_list[putp6    ].proj := nil;
  //pj_list[putp6p   ].proj := nil;
  //pj_list[qua_aut  ].proj := nil;
  //pj_list[robin    ].proj := nil;
  //pj_list[rpoly    ].proj := nil;
  pj_list[sinu].proj := @EzProjImpl.sinu;
  //pj_list[somerc   ].proj := nil;
  pj_list[stere].proj := @EzProjImpl.stere;
  //pj_list[tcc      ].proj := nil;
  pj_list[tcea].proj := @EzProjImpl.tcea;
  //pj_list[tissot   ].proj := nil;
  pj_list[tmerc].proj := @EzProjImpl.tmerc;
  pj_list[tpeqd].proj := @EzProjImpl.tpeqd;
  //pj_list[tpers    ].proj := nil;
  pj_list[ups].proj := @EzProjImpl.ups;
  //pj_list[urm5     ].proj := nil;
  //pj_list[urmfps   ].proj := nil;
  pj_list[utm].proj := @EzProjImpl.utm;
  //pj_list[vandg    ].proj := nil;
  //pj_list[vandg2   ].proj := nil;
  //pj_list[vandg3   ].proj := nil;
  pj_list[vandg4].proj := @EzProjImpl.vandg4;
  //pj_list[vitk1    ].proj := nil;
  //pj_list[wag1     ].proj := nil;
  //pj_list[wag2     ].proj := nil;
  //pj_list[wag3     ].proj := nil;
  pj_list[wag4].proj := @EzProjImpl.wag4;
  pj_list[wag5].proj := @EzProjImpl.wag5;
  //pj_list[wag6     ].proj := nil;
  pj_list[wag7].proj := @EzProjImpl.wag7;
  //pj_list[weren    ].proj := nil;
  //pj_list[wink1    ].proj := nil;
  //pj_list[wink2    ].proj := nil;
  //pj_list[wintri   ].proj := nil;

End.
