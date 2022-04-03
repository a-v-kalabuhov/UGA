Unit EzLineDraw;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  Windows, SysUtils, Graphics, EzLib;

// remark next line to use standard LineDDA WIndows API ( WARNING: it is slower )

Procedure PolyDDA( Const PointArray: Array Of TPoint;
  Const Parts: Array Of Integer; PartCount: Integer; pCanvas: TCanvas;
  Grapher: TEzGrapher; PLineType: Integer; PLineColor: TColor; PLineWidth: Integer );

Implementation


Var
  PixelCount, iFactor: integer;

Type

  PDDAInfo = ^TDDAInfo;
  TDDAInfo = Record
    LineColor: TColor;  // line color
    DC: THandle;        // to avoid calling Canvas.Handle many times
  End;

Procedure PixelDraw1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 3 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 4 ) In [0..1] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 6 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 10 ) In [0..7] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw5( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) In [0..15] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw6( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 40 ) In [0..31] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw7( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 10 ) In [0..4] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw8( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 8 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw9( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 12 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw10( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 16 ) In [0..7] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw11( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 15 ) In [0..6] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw12( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 22 ) In [0..10, 16] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw15( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 62 ) In [0..31, 44..49] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw17( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 68 ) In [0..31, 38..41, 48..51, 58..61] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw18( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 28 ) In [0..10, 16, 22] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw19( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 34 ) In [0..19, 24, 29] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw21( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 11 ) In [0..5, 8] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw22( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 14 ) In [0..5, 8, 11] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw23( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 24 ) In [0..9, 12, 15..18, 21] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw24( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 9 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw25( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 15 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw26( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw27_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw27_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) + 10 ) Mod 20 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw28_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 24 ) In [21, 23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw28_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) + 12 ) Mod 24 ) In [21, 23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw29( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 22 ) In [19, 21] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw30_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 22 ) In [0..17] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw30_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 22 ) = 9 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw31_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 22 ) In [8, 10] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw32_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( ( PixelCount Div iFactor ) Div 22 ) Mod 2 ) <> 0 ) And ( ( ( PixelCount Div iFactor ) Mod 22 ) = 9 ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw32_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( ( PixelCount Div iFactor ) Div 22 ) Mod 2 ) = 0 ) And ( ( ( PixelCount Div iFactor ) Mod 22 ) = 9 ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw33_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( ( PixelCount Div iFactor ) Div 22 ) Mod 2 ) <> 0 ) And ( ( ( PixelCount Div iFactor ) Mod 22 ) In [8, 10] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw33_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( ( PixelCount Div iFactor ) Div 22 ) Mod 2 ) = 0 ) And ( ( ( PixelCount Div iFactor ) Mod 22 ) In [8, 10] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw34_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 12 ) In [0..8] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw34_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 12 ) In [0, 8] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw35_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 22 ) In [0..16] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw35_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 22 ) In [0, 16] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw36_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 34 ) In [24, 26] ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw36_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 34 ) = 27 ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw36_4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) Mod 34 ) = 23 ) Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw39_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 12 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw39_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 12 ) In [0..3, 6..9] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw40_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) In [0..3, 6..9, 13..17] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw40_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw41_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 27 ) In [0..3, 6..9, 13..16, 20..23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw41_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 27 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw42_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 34 ) In [0..3, 6..9, 13..16, 20..23, 27..30] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw42_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 34 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw43_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 26 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw44_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 4 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw45_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 12 ) In [0..3] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw45_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 12 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw46_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 3 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw48_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 6 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw50_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 19 ) In [0..14] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw50_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 19 ) In [5, 10] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw52_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) - 3 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw52_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) - 2 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw52_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) - 1 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw52_4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) - 0 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw53_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) + 3 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw53_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) + 2 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw53_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) + 1 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw53_4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( ( PixelCount Div iFactor ) + 0 ) Mod 10 ) = 0 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw54_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 26 ) In [0..15, 19, 23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw54_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 26 ) In [18, 20, 23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw54_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 26 ) In [17, 21, 23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw55_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) In [0..15, 19, 23] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw55_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) In [18, 20] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw55_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) In [17, 21] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw56_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 25 ) In [0..6, 9..15, 18..22] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw56_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 25 ) = 20 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw57_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 40 ) In [0..14, 17..31, 34..37] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw58_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 24 ) In [0..11, 14..16, 19..21] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw59_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 27 ) In [0..15, 18..22, 24] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw59_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 27 ) In [20, 24] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw60_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 25 ) In [0..15, 18..22] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw60_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 25 ) = 20 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw61_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) In [0..17, 20] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw61_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) = 20 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw62_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 25 ) In [0..17, 20..22] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw63_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 14 ) In [10, 12] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw63_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 14 ) In [9, 13] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw64_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 15 ) = 13 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw64_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 15 ) = 14 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw64_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 15 ) = 11 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw64_4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 15 ) = 10 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw65_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 23 ) In [0..10, 13..14, 16..17, 19..20] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw66_0( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) In [0..9, 13..14, 16..17] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw66_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) = 6 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw66_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) = 7 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw66_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) = 4 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw66_4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) = 3 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw67_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 20 ) In [0..10, 13..17] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw68_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 21 ) In [0..14, 17..18] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw68_2( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 21 ) = 8 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw68_3( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 21 ) = 9 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw68_4( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 21 ) = 6 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw68_5( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 21 ) = 5 Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Procedure PixelDraw69_1( X, Y: Integer; lpData: lParam );
Begin
  If ( ( PixelCount Div iFactor ) Mod 21 ) In [0..14, 17..18] Then
    With PDDAInfo( lpData )^ Do
      SetPixelV( DC, X, Y, lineColor );
  Inc( PixelCount );
End;

Type
  TDrawPixelProc = Procedure( X, Y: Integer; lpData: lParam );

  {Bresenham's Line Algorithm.  Byte, March 1988, pp. 249-253.}

Procedure DrawLine( xStart, yStart, xEnd, yEnd: INTEGER;
  DrawPixel: TFarProc; lpData: lParam );
Var
  a, b: INTEGER; {displacements in x and y}
  d: INTEGER; {decision variable}
  diag_inc: INTEGER; {d's increment for diagonal steps}
  dx_diag: INTEGER; {diagonal x step for next pixel}
  dx_nondiag: INTEGER; {nondiagonal x step for next pixel}
  dy_diag: INTEGER; {diagonal y step for next pixel}
  dy_nondiag: INTEGER; {nondiagonal y step for next pixel}
  i: INTEGER; {loop index}
  nondiag_inc: INTEGER; {d's increment for nondiagonal steps}
  swap: INTEGER; {temporary variable for swap}
  x, y: INTEGER; {current x and y coordinates}
Begin {DrawLine}
  x := xStart; {line starting point}
  y := yStart;
  {Determine drawing direction and step to the next pixel.}
  a := xEnd - xStart; {difference in x dimension}
  b := yEnd - yStart; {difference in y dimension}
  {Determine whether end point lies to right or left of start point.}
  If a < 0 Then {drawing towards smaller x values?}
  Begin
    a := -a; {make 'a' positive}
    dx_diag := -1
  End
  Else
    dx_diag := 1;
  {Determine whether end point lies above or below start point.}
  If b < 0 Then {drawing towards smaller x values?}
  Begin
    b := -b; {make 'a' positive}
    dy_diag := -1
  End
  Else
    dy_diag := 1;
  {Identify octant containing end point.}
  If a < b Then
  Begin
    swap := a;
    a := b;
    b := swap;
    dx_nondiag := 0;
    dy_nondiag := dy_diag
  End
  Else
  Begin
    dx_nondiag := dx_diag;
    dy_nondiag := 0
  End;
  d := b + b - a; {initial value for d is 2*b - a}
  nondiag_inc := b + b; {set initial d increment values}
  diag_inc := b + b - a - a;
  For i := 0 To a Do
  Begin {draw the a+1 pixels}
    TDrawPixelProc( DrawPixel )( x, y, lpData );
    If d < 0 Then {is midpoint above the line?}
    Begin {step nondiagonally}
      x := x + dx_nondiag;
      y := y + dy_nondiag;
      d := d + nondiag_inc {update decision variable}
    End
    Else
    Begin {midpoint is above the line; step diagonally}
      x := x + dx_diag;
      y := y + dy_diag;
      d := d + diag_inc
    End
  End;
End {DrawLine};


Procedure PolyDDA( Const PointArray: Array Of TPoint;
  Const Parts: Array Of integer; PartCount: Integer;
  pCanvas: TCanvas; Grapher: TEzGrapher; PlineType: integer;
  PLineColor: TColor; PLineWidth: Integer );

Var
  DDAInfo: TDDAInfo;
  I: Integer;

  Procedure DrawPoly( Proc: TFarProc );
  Var
    I, p, pStart, pEnd: Integer;
    pointarr: EzLib.PPointArray;
  Begin
    If Proc = Nil Then
    Begin
      If PartCount = 1 Then
        pCanvas.Polyline( Slice( PointArray, Parts[0] ) )
      Else
      Begin
        if Win32Platform = VER_PLATFORM_WIN32_NT then
          { WinNT or Win2000 }
          PolyPolyline( pCanvas.Handle, PointArray, Parts, PartCount )
        else
        begin
          { Win95 or Win98 }
          pStart := 0;
          For p := 0 To PartCount - 1 Do
          Begin
            pEnd := pStart + Parts[p] - 1;
            pointArr:= @PointArray[pStart];
            Polyline( pCanvas.Handle, pointarr^, Succ(pEnd - pStart) );
            pStart := pEnd + 1;
          End;
        end;
      End;
    End
    Else
    Begin
      PixelCount := 0;
      pStart := 0;
      For p := 0 To PartCount - 1 Do
      Begin
        pEnd := pStart + Parts[p] - 1;
        For I := pStart To pEnd - 1 Do
          DrawLine( PointArray[I].X, PointArray[I].Y,
                    PointArray[Succ( I )].X, PointArray[Succ( I )].Y, proc,
                    Longint( @DDAInfo ) );
        pStart := pEnd + 1;
      End;
    End;
  End;

  Procedure ReDrawPoly( Proc: TFarProc; pOffset: integer );
  Var
    I, f, n1, n2, p, pStart, pEnd: Integer;
    X1, Y1, X2, Y2, Dx, Dy, OffsX, OffsY: Integer;
  Begin
    If iFactor = 1 Then
    Begin
      n1 := abs( pOffset );
      n2 := abs( pOffset );
    End
    Else
    Begin
      n1 := ( abs( pOffset ) - 1 ) * iFactor + 1;
      n2 := n1 + abs( pOffset ) * iFactor;
    End;
    For f := n1 To n2 Do
    Begin
      PixelCount := 0;
      pStart := 0;
      For p := 0 To PartCount - 1 Do
      Begin
        pEnd := pStart + Parts[p] - 1;
        For I := pStart To pEnd - 1 Do
        Begin
          If pOffset < 0 Then
          Begin
            OffsX := -f;
            OffsY := -f;
          End
          Else
          Begin
            OffsX := f;
            OffsY := f;
          End;
          X1 := PointArray[I].X;
          Y1 := PointArray[I].Y;
          X2 := PointArray[Succ( I )].X;
          Y2 := PointArray[Succ( I )].Y;
          Dx := X2 - X1;
          Dy := Y2 - Y1;
          If Dy > 0 Then
            OffsX := -OffsX;
          If Dx < 0 Then
            OffsY := -OffsY;
          If Dx = 0 Then
          Begin
            // vertical line
            X1 := X1 + OffsX;
            X2 := X2 + OffsX;
          End
          Else If Dy = 0 Then
          Begin
            // horizontal line
            Y1 := Y1 + OffsY;
            Y2 := Y2 + OffsY;
          End
          Else
          Begin
            // line with angle
            X1 := X1 + OffsX;
            X2 := X2 + OffsX;
            Y1 := Y1 + OffsY;
            Y2 := Y2 + OffsY;
          End;
          If Proc <> Nil Then
            DrawLine( X1, Y1, X2, Y2, Proc, Longint( @DDAInfo ) )
          Else
          Begin
            pCanvas.MoveTo( X1, Y1 );
            pCanvas.LineTo( X2, Y2 );
          End;
        End;
        pStart := pEnd + 1;
      End;
    End;
  End;

Begin
  If PartCount = 0 Then Exit;
  If ( Grapher <> Nil ) And ( Grapher.Device = adPrinter ) Then
  begin
      iFactor := Trunc( Grapher.PrinterDpiY / Grapher.ScreenDpiY );
  end else
    iFactor := 1;
  With DDAInfo Do
  Begin
    LineColor := plineColor;
    DC := pCanvas.Handle;
  End;
  pCanvas.Pen.Color:= PLineColor;
  {if it is (-) goes up, if it is (+) goes down}
  Case plinetype Of
    1: DrawPoly( @PixelDraw1 );
    2: DrawPoly( @PixelDraw2 );
    3: DrawPoly( @PixelDraw3 );
    4: DrawPoly( @PixelDraw4 );
    5: DrawPoly( @PixelDraw5 );
    6: DrawPoly( @PixelDraw6 );
    7: DrawPoly( @PixelDraw7 );
    8: DrawPoly( @PixelDraw8 );
    9: DrawPoly( @PixelDraw9 );
    10: DrawPoly( @PixelDraw10 );
    11: DrawPoly( @PixelDraw11 );
    12: DrawPoly( @PixelDraw12 );
    13: DrawPoly( @PixelDraw15 );
    14: DrawPoly( @PixelDraw17 );
    15: DrawPoly( @PixelDraw18 );
    16: DrawPoly( @PixelDraw19 );
    17: DrawPoly( @PixelDraw21 );
    18: DrawPoly( @PixelDraw22 );
    19: DrawPoly( @PixelDraw23 );
    20:
      Begin
        DrawPoly( Nil );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw24, -I );
        RedrawPoly( @PixelDraw24, 1 );
      End;
    21:
      Begin
        DrawPoly( Nil );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw25, -I );
        RedrawPoly( @PixelDraw25, 1 );
      End;
    22:
      Begin
        DrawPoly( Nil );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw26, -I );
        RedrawPoly( @PixelDraw26, 1 );
      End;
    23:
      Begin
        DrawPoly( Nil );
        For I := 1 To 3 Do
          RedrawPoly( @PixelDraw27_1, -I );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw27_2, I );
      End;
    24:
      Begin
        DrawPoly( Nil );
        For I := 1 To 3 Do
          RedrawPoly( @PixelDraw28_1, -I );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw28_2, I );
      End;
    25:
      Begin
        DrawPoly( Nil );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw29, -I );
        RedrawPoly( @PixelDraw29, 1 );
      End;
    26:
      Begin
        DrawPoly( @PixelDraw30_1 );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw30_2, -I );
        RedrawPoly( @PixelDraw30_2, 1 );
      End;
    27:
      Begin
        DrawPoly( @PixelDraw30_1 );
        For I := 1 To 3 Do
          RedrawPoly( @PixelDraw32_2, -I );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw32_3, I );
      End;
    28:
      Begin
        DrawPoly( @PixelDraw30_1 );
        For I := 1 To 3 Do
          RedrawPoly( @PixelDraw33_2, -I );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw33_3, I );
      End;
    29:
      Begin
        DrawPoly( @PixelDraw34_1 );
        RedrawPoly( @PixelDraw34_2, -1 );
      End;
    30:
      Begin
        DrawPoly( @PixelDraw35_1 );
        For I := 1 To 2 Do
          RedrawPoly( @PixelDraw35_2, -I );
        For I := 1 To 1 Do
          RedrawPoly( @PixelDraw35_2, I );
      End;
    31:
      Begin
        DrawPoly( Nil );
        RedrawPoly( @PixelDraw36_2, -1 );
        RedrawPoly( @PixelDraw36_2, 1 );
        RedrawPoly( @PixelDraw36_3, -2 );
        RedrawPoly( @PixelDraw36_4, 2 );
      End;
    32:
      Begin
        DrawPoly( @PixelDraw39_2 );
        RedrawPoly( @PixelDraw39_1, -1 );
        RedrawPoly( @PixelDraw39_1, 1 );
      End;
    33:
      Begin
        DrawPoly( @PixelDraw40_1 );
        RedrawPoly( @PixelDraw40_2, -1 );
        RedrawPoly( @PixelDraw40_2, 1 );
      End;
    34:
      Begin
        DrawPoly( @PixelDraw41_1 );
        RedrawPoly( @PixelDraw41_2, -1 );
        RedrawPoly( @PixelDraw41_2, 1 );
      End;
    35:
      Begin
        DrawPoly( @PixelDraw42_1 );
        RedrawPoly( @PixelDraw42_2, -1 );
        RedrawPoly( @PixelDraw42_2, 1 );
      End;
    36:
      Begin
        DrawPoly( Nil );
        RedrawPoly( @PixelDraw43_2, -1 );
        RedrawPoly( @PixelDraw43_2, 1 );
      End;
    37:
      Begin
        DrawPoly( @PixelDraw44_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw44_1, -I );
        ReDrawPoly( @PixelDraw44_1, 1 );
      End;
    38:
      Begin
        DrawPoly( @PixelDraw45_1 );
        ReDrawPoly( @PixelDraw45_2, -1 );
      End;
    39:
      Begin
        DrawPoly( Nil );
        For I := 1 To 3 Do
          ReDrawPoly( @PixelDraw46_2, -I );
      End;
    40:
      Begin
        DrawPoly( Nil );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw46_2, I );
      End;
    41:
      Begin
        DrawPoly( Nil );
        For I := 1 To 3 Do
          ReDrawPoly( @PixelDraw48_2, -I );
      End;
    42:
      Begin
        DrawPoly( Nil );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw48_2, I );
      End;
    43:
      Begin
        DrawPoly( @PixelDraw50_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw50_2, -I );
      End;
    44:
      Begin
        DrawPoly( @PixelDraw50_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw50_2, I );
      End;
    45:
      Begin
        DrawPoly( @PixelDraw52_1 );
        ReDrawPoly( @PixelDraw52_2, -1 );
        ReDrawPoly( @PixelDraw52_3, -2 );
        ReDrawPoly( @PixelDraw52_2, 1 );
        ReDrawPoly( @PixelDraw52_3, 2 );
        ReDrawPoly( @PixelDraw52_4, 3 );
      End;
    46:
      Begin
        DrawPoly( @PixelDraw53_1 );
        ReDrawPoly( @PixelDraw53_2, -1 );
        ReDrawPoly( @PixelDraw53_3, -2 );
        ReDrawPoly( @PixelDraw53_2, 1 );
        ReDrawPoly( @PixelDraw53_3, 2 );
        ReDrawPoly( @PixelDraw53_4, 3 );
      End;
    47:
      Begin
        DrawPoly( @PixelDraw54_1 );
        ReDrawPoly( @PixelDraw54_2, -1 );
        ReDrawPoly( @PixelDraw54_3, -2 );
        ReDrawPoly( @PixelDraw54_2, 1 );
        ReDrawPoly( @PixelDraw54_3, 2 );
      End;
    48:
      Begin
        DrawPoly( @PixelDraw55_1 );
        ReDrawPoly( @PixelDraw55_2, -1 );
        ReDrawPoly( @PixelDraw55_3, -2 );
        ReDrawPoly( @PixelDraw55_2, 1 );
        ReDrawPoly( @PixelDraw55_3, 2 );
      End;
    49:
      Begin
        DrawPoly( @PixelDraw56_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw56_2, -I );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw56_2, I );
      End;
    50: DrawPoly( @PixelDraw57_1 );
    51: DrawPoly( @PixelDraw58_1 );
    52:
      Begin
        DrawPoly( @PixelDraw59_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw59_2, -I );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw59_2, I );
      End;
    53:
      Begin
        DrawPoly( @PixelDraw60_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw60_2, -I );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw60_2, I );
      End;
    54:
      Begin
        DrawPoly( @PixelDraw61_1 );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw61_2, -I );
        For I := 1 To 2 Do
          ReDrawPoly( @PixelDraw61_2, I );
      End;
    55: DrawPoly( @PixelDraw62_1 );
    56:
      Begin
        DrawPoly( Nil );
        ReDrawPoly( @PixelDraw63_1, -1 );
        ReDrawPoly( @PixelDraw63_2, -2 );
        ReDrawPoly( @PixelDraw63_1, 1 );
        ReDrawPoly( @PixelDraw63_2, 2 );
      End;
    57:
      Begin
        DrawPoly( Nil );
        ReDrawPoly( @PixelDraw64_1, -1 );
        ReDrawPoly( @PixelDraw64_2, -2 );
        ReDrawPoly( @PixelDraw64_3, 1 );
        ReDrawPoly( @PixelDraw64_4, 2 );
      End;
    58: DrawPoly( @PixelDraw65_1 );
    59:
      Begin
        DrawPoly( @PixelDraw66_0 );
        ReDrawPoly( @PixelDraw66_1, -1 );
        ReDrawPoly( @PixelDraw66_2, -2 );
        ReDrawPoly( @PixelDraw66_3, 1 );
        ReDrawPoly( @PixelDraw66_4, 2 );
      End;
    60: DrawPoly( @PixelDraw67_1 );
    61:
      Begin
        DrawPoly( @PixelDraw68_1 );
        ReDrawPoly( @PixelDraw68_2, -1 );
        ReDrawPoly( @PixelDraw68_3, -2 );
        ReDrawPoly( @PixelDraw68_4, 1 );
        ReDrawPoly( @PixelDraw68_5, 2 );
      End;
    62: DrawPoly( @PixelDraw69_1 );
  End;
End;

End.
