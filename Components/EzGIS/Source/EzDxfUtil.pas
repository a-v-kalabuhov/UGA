Unit EzDxfUtil;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, windows, Graphics, Math;

Type
  Point3D = Record
    x, y, z: Double;
  End;

  Point2D = Record
    x, y: Double;
  End;

  PPoint3D = ^Point3D;
  ppointlist = ^pointlist;
  pointlist = Array[0..1000000] Of Point3D;

Const
  origin3D: Point3D = ( x: 0; y: 0; z: 0 );
  WCS_X: Point3D = ( x: 1; y: 0; z: 0 );
  WCS_Y: Point3D = ( x: 0; y: 1; z: 0 );
  WCS_Z: Point3D = ( x: 0; y: 0; z: 1 );

Type
  pMatrix = ^Matrix;
  pM = pMatrix;
  Matrix = Record
    val: Array[0..3, 0..3] Of Double;
  End;

Const
  identity: Matrix = ( val: ( ( 1, 0, 0, 0 ), ( 0, 1, 0, 0 ), ( 0, 0, 1, 0 ), ( 0, 0, 0, 1 ) ) );

Var
  Handle: longint;

  ///////////////////////////////////////////////////////////////////////////////
  // General point 3D stuff
  ///////////////////////////////////////////////////////////////////////////////
Function aPoint3D( a, b, c: Double ): Point3D;
Function p1_eq_p2_3D( p1, p2: Point3D ): boolean;
Function p1_eq_p2_2D( p1, p2: Point3D ): boolean;
Function p1_minus_p2( p1, p2: Point3D ): Point3D;
Function p1_plus_p2( p1, p2: Point3D ): Point3D;
Function normalize( p1: Point3D ): Point3D;
//Function mag( p1: Point3D ): Double;
Function dist3D( p1, p2: Point3D ): Double;
Function dist2D( p1, p2: Point3D ): Double;
Function sq_dist3D( p1, p2: Point3D ): Double;
Function sq_dist2D( p1, p2: Point3D ): Double;
Function sq_mag3D( p1: Point3D ): Double;
Function p1_x_n( p1: Point3D; n: Double ): Point3D;
Function set_accuracy( factor: Double; p: Point3D ): Point3D;
///////////////////////////////////////////////////////////////////////////////
// Vector 3D stuff
///////////////////////////////////////////////////////////////////////////////
//Function dot( p1, p2: Point3D ): Double;
Function cross( p1, p2: Point3D ): Point3D;
Function angle( p1, p2, p3: Point3D; do_3D: boolean ): Double;
///////////////////////////////////////////////////////////////////////////////
// Rotations for Insert/Block drawing
///////////////////////////////////////////////////////////////////////////////
Function XRotateMatrix( cos_a, sin_a: Double ): Matrix;
Function YRotateMatrix( cos_a, sin_a: Double ): Matrix;
Function ZRotateMatrix( cos_a, sin_a: Double ): Matrix;
Function ScaleMatrix( p: Point3D ): Matrix;
Function TranslateMatrix( p: Point3D ): Matrix;
Function MatrixMultiply( const matrix1, matrix2: Matrix ): Matrix;
Function CreateTransformation( const Ax, Ay, Az: Point3D ): Matrix;
Function TransformPoint( TM: Matrix; p: Point3D ): Point3D;
Function update_transformations( OCS_WCS, OCS: pMatrix ): pMatrix;
Function RotationAxis( const A: Point3D; angle: Double ): Matrix;
///////////////////////////////////////////////////////////////////////////////
// Bounds
///////////////////////////////////////////////////////////////////////////////
Procedure max_bound( Var bounds: Point3D; point: Point3D );
Procedure min_bound( Var bounds: Point3D; point: Point3D );
///////////////////////////////////////////////////////////////////////////////
// Memory
///////////////////////////////////////////////////////////////////////////////
Function allocate_points( n: integer ): ppointlist;
Procedure deallocate_points( Var pts: ppointlist; n: integer );
Function allocate_matrix: pMatrix;
Procedure deallocate_matrix( Var m: pMatrix );
///////////////////////////////////////////////////////////////////////////////
// String
///////////////////////////////////////////////////////////////////////////////
Function float_out( f: Double ): String;
Function BoolToStr( b: boolean ): String;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//Function NPoint2D( X, Y: Double ): Point2D;
//Function NPoint3D( X, Y, Z: Double ): Point3D;
//Function NDist2D( P: Point2D ): Double;
//Function NDist3D( P: Point3D ): Double;
Function RoundPoint( P: Point2D ): TPoint;
Function FloatPoint( P: TPoint ): Point2D;
//Function Angle2D( P: Point2D ): Double;
Function RelAngle2D( PA, PB: Point2D ): Double;
Function RelDist2D( PA, PB: Point2D ): Double;
Function RelDist3D( PA, PB: Point3D ): Double;
Procedure Rotate2D( Var P: Point2D; Angle2D: Double );
Procedure RelRotate2D( Var P: Point2D; PCentr: Point2D; Angle2D: Double );
Procedure Move2D( Var P: Point2D; Angle2D, Distance: Double );
Function Between( PA, PB: Point2D; Preference: Double ): Point2D;
//Function DistLine( A, B, C: Double; P: Point2D ): Double;
//Function Dist2P( P, P1, P2: Point2D ): Double;
//Function DistD1P( DX, DY: Double; P1, P: Point2D ): Double;
Function NearLine2P( P, P1, P2: Point2D; D: Double ): Boolean;
//Function AddPoints( P1, P2: Point2D ): Point2D;
//Function SubPoints( P1, P2: Point2D ): Point2D;

Function Invert( Col: TColor ): TColor;
Function Dark( Col: TColor; Percentage: Byte ): TColor;
Function Light( Col: TColor; Percentage: Byte ): TColor;
Function Mix( Col1, Col2: TColor; Percentage: Byte ): TColor;
Function MMix( Cols: Array Of TColor ): TColor;
Function Log( Base, Value: Double ): Double;
Function Modulator( Val, Max: Double ): Double;
Function M( I, J: Integer ): Integer;
Function Tan( Angle2D: Double ): Double;
Procedure Limit( Var Value: Integer; Min, Max: Integer );
Function Exp2( Exponent: Byte ): Word;

Implementation

Function aPoint3D( a, b, c: Double ): Point3D;
Begin
  result.x := a;
  result.y := b;
  result.z := c;
End;

Function p1_eq_p2_3D( p1, p2: Point3D ): boolean;
Begin
  result := ( p1.x = p2.x ) And ( p1.y = p2.y ) And ( p1.z = p2.z );
End;

Function p1_eq_p2_2D( p1, p2: Point3D ): boolean;
Begin
  result := ( p1.x = p2.x ) And ( p1.y = p2.y );
End;

Function p1_minus_p2( p1, p2: Point3D ): Point3D;
Begin
  Try
    result.x := p1.x - p2.x;
    result.y := p1.y - p2.y;
    result.z := p1.z - p2.z;
  Except
    result := p2;
  End;
End;

Function p1_plus_p2( p1, p2: Point3D ): Point3D;
Begin
  result.x := p1.x + p2.x;
  result.y := p1.y + p2.y;
  result.z := p1.z + p2.z;
End;

Function normalize( p1: Point3D ): Point3D;
Var
  mag: Double;
Begin
  mag := Sqrt( sqr( p1.x ) + sqr( p1.y ) + sqr( p1.z ) );
  If mag = 0 Then
    mag := 1;
  result.x := p1.x / mag;
  result.y := p1.y / mag;
  result.z := p1.z / mag;
End;

Function mag( p1: Point3D ): Double;
Begin
  With p1 Do
    result := Sqrt( sqr( x ) + sqr( y ) + sqr( z ) );
End;

Function dist3D( p1, p2: Point3D ): Double;
Begin
  With p1_minus_p2( p2, p1 ) Do
    result := Sqrt( sqr( x ) + sqr( y ) + sqr( z ) );
End;

Function dist2D( p1, p2: Point3D ): Double;
Begin
  With p1_minus_p2( p2, p1 ) Do
    result := Sqrt( sqr( x ) + sqr( y ) );
End;

Function sq_dist3D( p1, p2: Point3D ): Double;
Begin
  With p1_minus_p2( p2, p1 ) Do
    result := sqr( x ) + sqr( y ) + sqr( z );
End;

Function sq_dist2D( p1, p2: Point3D ): Double;
Begin
  Try
    With p1_minus_p2( p2, p1 ) Do
      result := sqr( x ) + sqr( y );
  Except
    result := 0;
  End;
End;

Function sq_mag3D( p1: Point3D ): Double;
Begin
  With p1 Do
    result := sqr( x ) + sqr( y ) + sqr( z );
End;

Function p1_x_n( p1: Point3D; n: Double ): Point3D;
Begin
  result.x := p1.x * n;
  result.y := p1.y * n;
  result.z := p1.z * n;
End;

Function set_accuracy( factor: Double; p: Point3D ): Point3D;
Begin
  result.x := round( p.x * factor ) / factor;
  result.y := round( p.y * factor ) / factor;
  result.z := round( p.z * factor ) / factor;
End;
///////////////////////////////////////////////////////////////////////////////
// Vector 3D stuff
///////////////////////////////////////////////////////////////////////////////

Function dot( p1, p2: Point3D ): Double;
Begin
  result := p1.x * p2.x + p1.y * p2.y + p1.z * p2.z;
End;

Function cross( p1, p2: Point3D ): Point3D;
Begin
  result.x := p1.y * p2.z - p1.z * p2.y;
  result.y := p1.z * p2.x - p1.x * p2.z;
  result.z := p1.x * p2.y - p1.y * p2.x;
End;

Function angle( p1, p2, p3: Point3D; do_3D: boolean ): Double;
Var
  v1, v2: Point3D;
  d1, d2: Double;
Begin
  v1 := p1_minus_p2( p2, p1 );
  v2 := p1_minus_p2( p3, p2 );
  If Not do_3D Then
  Begin
    v1.z := 0;
    v2.z := 0;
  End;
  d1 := Mag( v1 );
  d2 := Mag( v2 );
  If ( ( d1 = 0 ) Or ( d2 = 0 ) ) Then
    result := 0
  Else
  Begin
    d1 := dot( v1, v2 ) / ( d1 * d2 );
    If abs( d1 ) <= 1 Then
      result := ArcCos( d1 )
    Else
      result := 0;
  End;
End;
///////////////////////////////////////////////////////////////////////////////
// Rotations for Insert/Block drawing
///////////////////////////////////////////////////////////////////////////////

Function XRotateMatrix( cos_a, sin_a: Double ): Matrix;
Begin
  result := identity;
  result.val[1, 1] := cos_a;
  result.val[1, 2] := -sin_a;
  result.val[2, 1] := sin_a;
  result.val[2, 2] := cos_a;
End;

Function YRotateMatrix( cos_a, sin_a: Double ): Matrix;
Begin
  result := identity;
  result.val[0, 0] := cos_a;
  result.val[0, 2] := sin_a;
  result.val[2, 0] := -sin_a;
  result.val[2, 2] := cos_a;
End;

Function ZRotateMatrix( cos_a, sin_a: Double ): Matrix;
Begin
  result := identity;
  result.val[0, 0] := cos_a;
  result.val[0, 1] := -sin_a;
  result.val[1, 0] := sin_a;
  result.val[1, 1] := cos_a;
End;

Function ScaleMatrix( p: Point3D ): Matrix;
Begin
  result := identity;
  result.val[0, 0] := p.x;
  result.val[1, 1] := p.y;
  result.val[2, 2] := p.z;
End;

Function TranslateMatrix( p: Point3D ): Matrix;
Begin
  result := identity;
  result.val[3, 0] := p.x;
  result.val[3, 1] := p.y;
  result.val[3, 2] := p.z;
End;

Function MatrixMultiply( const matrix1, matrix2: matrix ): Matrix;
Var
  row, column: integer;
Begin
  For row := 0 To 3 Do
  Begin
    For column := 0 To 3 Do
      result.val[row, column] :=
        matrix1.val[row, 0] * matrix2.val[0, column] + matrix1.val[row, 1] * matrix2.val[1, column] +
        matrix1.val[row, 2] * matrix2.val[2, column] + matrix1.val[row, 3] * matrix2.val[3, column];
  End;
End;

Var
  GlobalTempMatrix: Matrix;

Function update_transformations( OCS_WCS, OCS: pMatrix ): pMatrix;
Begin
  If OCS = Nil Then
    result := OCS_WCS
  Else If OCS_WCS = Nil Then
    result := OCS
  Else
  Begin
    GlobalTempMatrix := MatrixMultiply( OCS_WCS^, OCS^ );
    result := @GlobalTempMatrix;
  End;
End;

{ Matrix order : For reference

  start with a point at ( cos(30),sin(30),0 )
  rotate by 30 degrees - shifts point to (1,0,0)
  then translate by (10,0,0) shifts to (11,0,0)
  then rotate by -45 degrees goes to (7.77, 7.77 ,0) 7.77 = Sqrt(11^2 /2 )
  NOTE THE ORDER OF MATRIX OPERATIONS !

    test := aPoint3D( cos(degtorad(30)) , sin(degtorad(30)) , 0);
    mat  := ZRotateMatrix( cos(degtorad(30)) , sin(degtorad(30)) );
    mat  := MatrixMultiply( mat , TranslateMatrix(aPoint3D(10,0,0)) );
    mat  := MatrixMultiply( mat , ZRotateMatrix( cos(degtorad(-45)) , sin(degtorad(-45)) ) );
    test := TransformPoint(mat,test);
}

Function CreateTransformation( const Ax, Ay, Az: Point3D ): Matrix;
Begin
  result := Identity;
  result.val[0, 0] := Ax.x;
  result.val[1, 0] := Ay.x;
  result.val[2, 0] := Az.x;
  result.val[0, 1] := Ax.y;
  result.val[1, 1] := Ay.y;
  result.val[2, 1] := Az.y;
  result.val[0, 2] := Ax.z;
  result.val[1, 2] := Ay.z;
  result.val[2, 2] := Az.z;
End;

Function TransformPoint( TM: Matrix; p: Point3D ): Point3D;
Begin
  With TM Do
  Begin
    result.x := p.x * val[0, 0] + p.y * val[1, 0] + p.z * val[2, 0] + val[3, 0];
    result.y := p.x * val[0, 1] + p.y * val[1, 1] + p.z * val[2, 1] + val[3, 1];
    result.z := p.x * val[0, 2] + p.y * val[1, 2] + p.z * val[2, 2] + val[3, 2];
  End;
End;

Function RotationAxis( const A: Point3D; angle: Double ): Matrix;
Var
  sin_a, cos_a: Double;
Begin
  result := Identity;
  sin_a := sin( angle );
  cos_a := cos( angle );
  result.val[0][0] := ( A.x * A.x + ( 1. - A.x * A.x ) * cos_a );
  result.val[1][0] := ( A.x * A.y * ( 1. - cos_a ) + A.z * sin_a );
  result.val[2][0] := ( A.x * A.z * ( 1. - cos_a ) - A.y * sin_a );

  result.val[0][1] := ( A.x * A.y * ( 1. - cos_a ) - A.z * sin_a );
  result.val[1][1] := ( A.y * A.y + ( 1. - A.y * A.y ) * cos_a );
  result.val[2][1] := ( A.y * A.z * ( 1. - cos_a ) + A.x * sin_a );

  result.val[0][2] := ( A.x * A.z * ( 1. - cos_a ) + A.y * sin_a );
  result.val[1][2] := ( A.y * A.z * ( 1. - cos_a ) - A.x * sin_a );
  result.val[2][2] := ( A.z * A.z + ( 1. - A.z * A.z ) * cos_a );
End;
///////////////////////////////////////////////////////////////////////////////
// Bounds
///////////////////////////////////////////////////////////////////////////////

Procedure max_bound( Var bounds: Point3D; point: Point3D );
Begin
  Try
    If point.x > bounds.x Then
      bounds.x := point.x;
  Except
    bounds.x := bounds.x;
  End;
  Try
    If point.y > bounds.y Then
      bounds.y := point.y;
  Except
    bounds.y := bounds.y;
  End;
  Try
    If point.z > bounds.z Then
      bounds.z := point.z;
  Except
    bounds.z := bounds.z;
  End;
End;

Procedure min_bound( Var bounds: Point3D; point: Point3D );
Begin
  Try
    If point.x < bounds.x Then
      bounds.x := point.x;
  Except
    bounds.x := bounds.x;
  End;
  Try
    If point.y < bounds.y Then
      bounds.y := point.y;
  Except
    bounds.y := bounds.y;
  End;
  Try
    If point.z < bounds.z Then
      bounds.z := point.z;
  Except
    bounds.z := bounds.z;
  End;
End;

///////////////////////////////////////////////////////////////////////////////
// Memory
///////////////////////////////////////////////////////////////////////////////

Function allocate_points( n: integer ): ppointlist;
Begin
  Getmem( result, n * SizeOf( Point3D ) );
End;

Procedure deallocate_points( Var pts: ppointlist; n: integer );
Begin
  Freemem( pts, n * SizeOf( Point3D ) );
  pts := Nil;
End;

Function allocate_matrix: pMatrix;
Begin
  Getmem( result, SizeOf( Matrix ) );
End;

Procedure deallocate_matrix( Var m: pMatrix );
Begin
  Freemem( m, SizeOf( Matrix ) );
  m := Nil;
End;
///////////////////////////////////////////////////////////////////////////////
// String
///////////////////////////////////////////////////////////////////////////////

Function float_out( f: Double ): String;
Begin
  //result := FloatToStrF( f, ffFixed, 7, 3 );
  result := FloatToStr(f);
End;

Function BoolToStr( b: boolean ): String;
Begin
  If b Then
    result := 'TRUE'
  Else
    result := 'FALSE';
End;

Function NPoint2D( X, Y: Double ): Point2D;
Begin
  NPoint2D.X := X;
  NPoint2D.Y := Y;
End;

Function NPoint3D( X, Y, Z: Double ): Point3D;
Begin
  NPoint3D.X := X;
  NPoint3D.Y := Y;
  NPoint3D.Z := Z;
End;

Function RoundPoint( P: Point2D ): TPoint;
Begin
  RoundPoint.X := Round( P.X );
  RoundPoint.Y := Round( P.Y );
End;

Function FloatPoint( P: TPoint ): Point2D;
Begin
  FloatPoint.X := P.X;
  FloatPoint.Y := P.Y;
End;

Function Angle2D( P: Point2D ): Double;
Begin
  Result := 0;
  If P.X = 0 Then
  Begin
    If P.Y > 0 Then
      Result := Pi / 2;
    If P.Y = 0 Then
      Result := 0;
    If P.Y < 0 Then
      Result := Pi / -2;
  End
  Else
    Result := Arctan( P.Y / P.X );

  If P.X < 0 Then
  Begin
    If P.Y < 0 Then
      Result := Result + Pi;
    If P.Y >= 0 Then
      Result := Result - Pi;
  End;

  If Result < 0 Then
    Result := Result + 2 * Pi;
End;

Function NDist2D( P: Point2D ): Double;
Begin
  Result := Sqrt( P.X * P.X + P.Y * P.Y );
End;

Function NDist3D( P: Point3D ): Double;
Begin
  Result := Sqrt( P.X * P.X + P.Y * P.Y + P.Z * P.Z );
End;

Function RelAngle2D( PA, PB: Point2D ): Double;
Begin
  RelAngle2D := Angle2D( NPoint2D( PB.X - PA.X, PB.Y - PA.Y ) );
End;

Function RelDist2D( PA, PB: Point2D ): Double;
Begin
  Result := NDist2D( NPoint2D( PB.X - PA.X, PB.Y - PA.Y ) );
End;

Function RelDist3D( PA, PB: Point3D ): Double;
Begin
  RelDist3D := NDist3D( NPoint3D( PB.X - PA.X, PB.Y - PA.Y, PB.Z - PA.Z ) );
End;

Procedure Rotate2D( Var P: Point2D; Angle2D: Double );
Var
  Temp: Point2D;
Begin
  Temp.X := P.X * Cos( Angle2D ) - P.Y * Sin( Angle2D );
  Temp.Y := P.X * Sin( Angle2D ) + P.Y * Cos( Angle2D );
  P := Temp;
End;

Function AddPoints( P1, P2: Point2D ): Point2D;
Begin
  Result := NPoint2D( P1.X + P2.X, P1.Y + P2.Y );
End;

Function SubPoints( P1, P2: Point2D ): Point2D;
Begin
  Result := NPoint2D( P1.X - P2.X, P1.Y - P2.Y );
End;

Procedure RelRotate2D( Var P: Point2D; PCentr: Point2D; Angle2D: Double );
Var
  Temp: Point2D;
Begin
  Temp := SubPoints( P, PCentr );
  Rotate2D( Temp, Angle2D );
  P := AddPoints( Temp, PCentr );
End;

Procedure Move2D( Var P: Point2D; Angle2D, Distance: Double );
Var
  Temp: Point2D;
Begin
  Temp.X := P.X + ( Cos( Angle2D ) * Distance );
  Temp.Y := P.Y + ( Sin( Angle2D ) * Distance );
  P := Temp;
End;

Function Between( PA, PB: Point2D; Preference: Double ): Point2D;
Begin
  Between.X := PA.X * Preference + PB.X * ( 1 - Preference );
  Between.Y := PA.Y * Preference + PB.Y * ( 1 - Preference );
End;

Function DistLine( A, B, C: Double; P: Point2D ): Double;
Begin
  Result := ( A * P.X + B * P.Y + C ) / Sqrt( Sqr( A ) + Sqr( B ) );
End;

Function Dist2P( P, P1, P2: Point2D ): Double;
Begin
  Result := DistLine( P1.Y - P2.Y, P2.X - P1.X, -P1.Y * P2.X + P1.X * P2.Y, P );
End;

Function DistD1P( DX, DY: Double; P1, P: Point2D ): Double;
Begin
  Result := DistLine( DY, -DX, -DY * P1.X + DX * P1.Y, P );
End;

Function NearLine2P( P, P1, P2: Point2D; D: Double ): Boolean;
Begin
  Result := False;
  If DistD1P( -( P2.Y - P1.Y ), P2.X - P1.X, P1, P ) * DistD1P( -( P2.Y - P1.Y ), P2.X - P1.X, P2, P ) <= 0 Then
    If Abs( Dist2P( P, P1, P2 ) ) < D Then
      Result := True;
End;

Function Invert( Col: TColor ): TColor;
Begin
  Result := Not Col;
End;

Function Dark( Col: TColor; Percentage: Byte ): TColor;
Var
  R, G, B: Byte;
Begin
  R := GetRValue( Col );
  G := GetGValue( Col );
  B := GetBValue( Col );
  R := Round( R * Percentage / 100 );
  G := Round( G * Percentage / 100 );
  B := Round( B * Percentage / 100 );
  Dark := RGB( R, G, B );
End;

Function Light( Col: TColor; Percentage: Byte ): TColor;
Var
  R, G, B: Byte;
Begin
  R := GetRValue( Col );
  G := GetGValue( Col );
  B := GetBValue( Col );
  R := Round( R * Percentage / 100 ) + Round( 255 - Percentage / 100 * 255 );
  G := Round( G * Percentage / 100 ) + Round( 255 - Percentage / 100 * 255 );
  B := Round( B * Percentage / 100 ) + Round( 255 - Percentage / 100 * 255 );
  Light := RGB( R, G, B );
End;

Function Mix( Col1, Col2: TColor; Percentage: Byte ): TColor;
Var
  R, G, B: Byte;
Begin
  R := Round( ( GetRValue( Col1 ) * Percentage / 100 ) + ( GetRValue( Col2 ) * ( 100 - Percentage ) / 100 ) );
  G := Round( ( GetGValue( Col1 ) * Percentage / 100 ) + ( GetGValue( Col2 ) * ( 100 - Percentage ) / 100 ) );
  B := Round( ( GetBValue( Col1 ) * Percentage / 100 ) + ( GetBValue( Col2 ) * ( 100 - Percentage ) / 100 ) );
  Mix := RGB( R, G, B );
End;

Function MMix( Cols: Array Of TColor ): TColor;
Var
  I, R, G, B, Length: Integer;
Begin
  Length := High( Cols ) - Low( Cols ) + 1;
  R := 0;
  G := 0;
  B := 0;
  For I := Low( Cols ) To High( Cols ) Do
  Begin
    R := R + GetRValue( Cols[I] );
    G := G + GetGValue( Cols[I] );
    B := B + GetBValue( Cols[I] );
  End;
  R := R Div Length;
  G := G Div Length;
  B := B Div Length;
  MMix := RGB( R, G, B );
End;

Function Log( Base, Value: Double ): Double;
Begin
  Log := Ln( Value ) / Ln( Base );
End;

Function Power( Base, Exponent: Double ): Double;
Begin
  Power := Ln( Base ) * Exp( Exponent );
End;

Function Modulator( Val, Max: Double ): Double;
Begin
  Modulator := ( Val / Max - Round( Val / Max ) ) * Max;
End;

Function M( I, J: Integer ): Integer;
Begin
  M := ( ( I Mod J ) + J ) Mod J;
End;

Function Tan( Angle2D: Double ): Double;
Begin
  Tan := Sin( Angle2D ) / Cos( Angle2D );
End;

Procedure Limit( Var Value: Integer; Min, Max: Integer );
Begin
  If Value < Min Then
    Value := Min;
  If Value > Max Then
    Value := Max;
End;

Function Exp2( Exponent: Byte ): Word;
Var
  Temp, I: Word;
Begin
  Temp := 1;
  For I := 1 To Exponent Do
    Temp := Temp * 2;
  Result := Temp;
End;

End.
