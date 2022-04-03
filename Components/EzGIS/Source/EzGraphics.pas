Unit EzGraphics;

{***********************************************************}
{     EzGIS/CAD Components                                  }
{   (c) 2002 EzSoft Engineering                             }
{         All Rights Reserved                               }
{***********************************************************}

{$I EZ_FLAG.PAS}
Interface

Uses
  SysUtils, Windows, Classes, Graphics, Controls, EzBaseGIS, EzLib, ezbase;

Type

  TRGBTripleArray = Array[WORD] Of TRGBTriple;
  pRGBTripleArray = ^TRGBTripleArray;

  TRGBQuadArray = Array[WORD] Of TRGBQuad;
  pRGBQuadArray = ^TRGBQuadArray;

  TEzTileGlobalInfo = Record
    dc: HDC;
    TheStream: TStream;
    bmf: TBITMAPFILEHEADER;
    lpBitmapInfo: PBITMAPINFO;
    BitmapHeaderSize: integer;
    TotalBitmapWidth: integer;
    TotalBitmapHeight: integer;
    SourceIsTopDown: Boolean;
    SourceRect: TRect;
    SourceBytesPerScanLine: integer;
    SourceLastScanLine: extended;
    SourceBandHeight: extended;
    SourceFirstTileHeight: extended;
  End;

  TEzBitmapEx = Class
  Private
    { internal data }
    FBlendTable: Array[-255..255] Of Smallint;
    { configuration }
    FPainterObject: TEzPainterObject;
    FWasSuspended: Boolean;
    FAlphaChannel: Byte;
    FBufferBitmap: TBitmap;
    FTileGlobalInfo: TEzTileGlobalInfo;

    Function TileCurrentBand( const CurrentTileRect: TRect): Boolean;
    Procedure SetAlphaChannel( Value: Byte );
  Public
    { methods }
    Function BitDIBFromFileInBands( Const FileName: String;
      Stream: TStream; dc: HDC; DestLeft, DestTop, DestWidth, DestHeight,
      DestTotalHeight, SourceLeft, SourceTop, SourceWidth, SourceHeight,
      BufferSize: integer ): Boolean;
    { properties }
    Property PainterObject: TEzPainterObject Read FPainterObject Write FPainterObject;
    Property WasSuspended: Boolean Read FWasSuspended;
    { AlphaChannel, 0= opaque, >0 = transparent }
    Property AlphaChannel: byte Read FAlphaChannel Write SetAlphaChannel;
    { the bitmap agains with which will be made transparent this bitmap }
    Property BufferBitmap: TBitmap Read FBufferBitmap Write FBufferBitmap;
  End;

  TEzBILReader = Class
  Private
    { internal data }
    FFileName: string;
    FBlendTable: Array[-255..255] Of Smallint;
    { configuration }
    FPainterObject: TEzPainterObject;
    FWasSuspended: Boolean;
    FAlphaChannel: Byte;
    FBufferBitmap: TBitmap;
    FTileGlobalInfo: TEzTileGlobalInfo;

    Function TileCurrentBand( const CurrentTileRect: TRect): Boolean;
    Procedure SetAlphaChannel( Value: Byte );
    function ReadHdr: Boolean;
  Public
    BIGENDIAN: Boolean;
    SKIPBYTES: integer;
    NROWS: integer;
    NCOLS: integer;
    NBANDS: integer;
    NBITS: integer;
    BANDROWBYTES: integer;
    TOTALROWBYTES: integer;
    BANDGAPBYTES: integer;
    NODATA: integer;
    ULXMAP: double;
    ULYMAP: double;
    XDIM: double;
    YDIM: double;

    Constructor Create(const Filename: string);
    { methods }
    Function BILFromFileInBands( Stream: TStream; DC: HDC;
      DestLeft, DestTop, DestWidth, DestHeight,
      DestTotalHeight, SourceLeft, SourceTop, SourceWidth, SourceHeight,
      BufferSize: Integer ): Boolean;
    { Properties }
    Property PainterObject: TEzPainterObject Read FPainterObject Write FPainterObject;
    Property WasSuspended: Boolean Read FWasSuspended;
    { AlphaChannel, 0= opaque, >0 = transparent }
    Property AlphaChannel: byte Read FAlphaChannel Write SetAlphaChannel;
    { the bitmap agains with which will be made transparent this bitmap }
    Property BufferBitmap: TBitmap Read FBufferBitmap Write FBufferBitmap;
  End;


{ useful routines }
procedure CyrusBeckLineClip(Polyline, Polygon, Result: TEzVector);
Function CreateText( Const AText: String; APosition: TEzLabelPos;
  Const AAngle: Double; Const Pt1, Pt2: TEzPoint; Const AFont: TEzFontStyle;
  TrueType: Boolean ): TEzEntity;
Procedure SaveClippedAreaTo( DrawBox: TEzBaseDrawBox; Const NewGis: TEzBaseGis );
Function GetMemEx( size: DWORD ): pointer;
Function FreeMemEx( p: pointer ): pointer;
{Function LoadDIBFromStream( TheStream: TStream;
  Var lpBitmapInfo: PBITMAPINFO;
  Var lpBits: Pointer;
  Var BitmapWidth, BitmapHeight: integer ): Boolean; }
Function LoadDIBFromFile( Const FileName: String;
  Var lpBitmapInfo: PBITMAPINFO;
  Var lpBits: Pointer;
  Var BitmapWidth, BitmapHeight: integer ): Boolean;
Function LoadDIBFromTBitmap( ABitmap: TBitmap;
  Var lpBitmapInfo: PBITMAPINFO;
  Var lpBits: Pointer;
  Var BitmapWidth, BitmapHeight: integer ): Boolean;
Function GetDIBDimensions( Const FileName: String;
  Stream: TStream;
  Var BitmapWidth, BitmapHeight: integer;
  Var IsCompressed: Boolean ): Boolean;
Function GetBILDimensions( Const FileName: String;
  Var BitmapWidth, BitmapHeight: integer ): Boolean;

Procedure PrintBitmapEx( Canvas: TCanvas;
  Const DestinationRect: TRect;
  ABitmap: TBitmap;
  Const SourceRect: TRect );
Procedure Fill8X8Bitmap( ACanvas: TCanvas;
  DestRect: TRect;
  Bitmap: TBitmap;
  ForeColor, BackColor: TColor );
Procedure PrinterFill8X8Bitmap( ACanvas: TCanvas;
  DestRect: TRect;
  Bitmap: TBitmap;
  ForeColor, BackColor: TColor;
  Factor: Double );
Procedure PolygonScreenFill8X8Bitmap( Canvas: TCanvas;
  Grapher: TEzGrapher; Var Vertices: Array Of TPoint; Var Parts: Array Of Integer;
  PartCount: Integer; Bitmap: TBitmap; ForeColor, BackColor: TColor );
Procedure PolygonPrinterFill8X8Bitmap( Canvas: TCanvas;
  Grapher: TEzGrapher; Var Vertices: Array Of TPoint; Var Parts: Array Of Integer;
  PartCount: Integer; Bitmap: TBitmap; ForeColor, BackColor: TColor;
  Factor: Double; PlotterOptimized: Boolean );
PROCEDURE RotateBitmap(
  const BitmapOriginal:TBitMap;//input bitmap (possibly converted)
  out   BitMapRotated:TBitMap; //output bitmap
  const theta:Double;  // rotn angle in radians counterclockwise in windows
  const oldAxis:TPOINT; 	// center of rotation in pixels, rel to bmp origin
  var   newAxis:TPOINT);  // center of rotated bitmap, relative to bmp origin

function FindContrastColor(aColor: TColor): TColor;

Implementation

Uses
  Math, ezsystem, ezentities, ezpolyclip, ezconsts, ezrtree;


{ CreateText procedure used for on the fly labeling }

Function CreateText( Const AText: String;
  APosition: TEzLabelPos;
  Const AAngle: Double;
  Const Pt1, Pt2: TEzPoint;
  Const AFont: TEzFontStyle;
  TrueType: Boolean ): TEzEntity;
Const
  ENLARGE_FACTOR = 0.15;

Var
  Angle: Double;
  DX, DY, MidY: Double;
  P, TmpPt1, TmpPt2: TEzPoint;
Begin
  Angle := AAngle;
  If Pt1.X < Pt2.X Then
  Begin
    TmpPt1 := Pt1;
    TmpPt2 := Pt2;
  End
  Else
  Begin
    TmpPt1 := Pt2;
    TmpPt2 := Pt1;
  End;
  { a veces el angulo es recibido con valor 0 }
  If Angle = 0 Then
  Begin
    MidY := ( TmpPt1.Y + TmpPt2.Y ) / 2;
    TmpPt1.Y := MidY;
    TmpPt2.Y := MidY;
  End
  Else
  Begin
    Angle := Angle2d( TmpPt1, TmpPt2 );
  End;
  TmpPt2.X := TmpPt1.X + Dist2d( Pt1, Pt2 );
  If TrueType Then
  Begin
    Result := TEzTrueTypeText.CreateEntity( Tmppt1, AText, AFont.Height, 0 );
    TEzTrueTypeText( Result ).FontTool.FFontStyle := AFont;
  End
  Else
  Begin
    Result := TEzFittedVectorText.CreateEntity( TmpPt1,
      AText,
      AFont.Height,
      -1, // calculate text width
      0 );
    TEzFittedVectorText( Result ).FontColor := AFont.Color;
  End;

  With Result.FBox Do
  Begin
    DX := abs( Emax.X - Emin.X );
    DY := abs( Emax.Y - Emin.Y );
  End;
  { posicion as if the angle was cero }
  Case APosition Of
    lpCenter:
      Begin
        p.X := ( TmpPt1.X + TmpPt2.X ) / 2 - DX / 2;
        p.y := TmpPt1.Y + DY / 2;
      End;
    lpCenterUp:
      Begin
        p.X := ( TmpPt1.X + TmpPt2.X ) / 2 - DX / 2;
        p.Y := TmpPt1.Y + DY * ( 1 + ENLARGE_FACTOR );
      End;
    lpUpperLeft:
      Begin
        p.X := TmpPt1.X;
        p.Y := TmpPt1.Y + DY * ( 1 + ENLARGE_FACTOR );
      End;
    lpUpperRight:
      Begin
        p.X := TmpPt2.X - DX;
        p.Y := TmpPt1.Y + DY * ( 1 + ENLARGE_FACTOR );
      End;
    lpCenterLeft:
      Begin
        p.X := TmpPt1.X;
        p.Y := TmpPt1.Y + DY / 2;
      End;
    lpCenterRight:
      Begin
        p.X := TmpPt2.X - DX;
        p.Y := TmpPt1.Y + DY / 2;
      End;
    lpLowerLeft:
      Begin
        p.X := TmpPt1.X;
        p.Y := TmpPt1.Y - DY * ENLARGE_FACTOR;
      End;
    lpCenterDown:
      Begin
        p.X := ( TmpPt1.X + TmpPt2.X ) / 2 - DX / 2;
        p.Y := TmpPt1.Y - DY * ENLARGE_FACTOR;
      End;
    lpLowerRight:
      Begin
        p.X := TmpPt2.X - DX;
        p.Y := TmpPt1.Y - DY * ENLARGE_FACTOR;
      End;
  End;
  { now apply the angle }
  If Angle <> 0 Then
  Begin
    If TrueType Then
    Begin
      Result.BeginUpdate;
      TEzTrueTypeText( Result ).Points[0] := TransformPoint2d( p, Rotate2d( Angle, TmpPt1 ) );
      TEzTrueTypeText( Result ).FontTool.Angle := Angle;
      Result.EndUpdate;
    End
    Else
    Begin
      TEzFittedVectorText( Result ).BasePoint := TransformPoint2d( p, Rotate2d( Angle, TmpPt1 ) );
      TEzFittedVectorText( Result ).Angle := Angle;
    End;
  End
  Else
  Begin
    If TrueType Then
      TEzTrueTypeText( Result ).Points[0] := p
    Else
      TEzFittedVectorText( Result ).BasePoint := p;
  End;
End;

function FindContrastColor(aColor: TColor): TColor;
begin
  if ((aColor and $FF)*77 + ((aColor shr 8) and $FF)*150 + ((aColor shr 16) and $FF)*29) > 127 * 256 then
    Result := clBlack
  else
    Result := clWhite;
end;

///////////////////////////////////////////////////////////////////////////////
//Rotate  a bitmap about an arbritray center point;
///////////////////////////////////////////////////////////////////////////////
//a structure to hold sine,cosine,distance (faster than angle)
type SiCoDiType=
  record
	 si, co, di:Double; {sine, cosine, distance 6/29/98}
  end;

{	Calculate sine/cosine/distance from INTEGER coordinates}
function SiCoDiPoint ( const p1, p2: TPoint ): SiCoDiType; {out}
{	This is MUCH faster than using angle functions such as arctangent}
{11.96    Jim Hargis  original SiCoDi for rotations.
{11/22/96 modified for Zero length check, and replace SiCodi}
{6/14/98  modified  for Delphi}
{6/29/98  renamed from SiCo point}
{8/3/98	  set Zero angle for Zero length line}
{10/24/99 use hypot from math.pas}
var
  dx, dy: Integer;
begin
  dx := ( p2.x - p1.x ); 	dy := ( p2.y - p1.y );
  with RESULT do
    begin
      di := HYPOT( dx, dy ); //10/24/99 	di := Sqrt( dx * dx + dy * dy );
      if abs( di )<1
        then begin si := 0.0; co := 1.0 end//Zero length line
        else begin si := dy/di; co := dx/di end;
    end;
end;

// read time stamp in CPU Cycles for Pentium
function RDTSC: Int64;
asm
  DB 0FH, 31H   //allows out-of-sequence execution, caching
end;

	PROCEDURE RotateBitmap(
		const BitmapOriginal:TBitMap;//input bitmap (possibly converted)
		out   BitMapRotated:TBitMap; //output bitmap
		const theta:Double;  // rotn angle in radians counterclockwise in windows
		const oldAxis:TPOINT; 	// center of rotation in pixels, rel to bmp origin
		var   newAxis:TPOINT);  // center of rotated bitmap, relative to bmp origin
{
  (c) har*GIS L.L.C., 1999
  	You are free to use this in any way, but please retain this comment block.
  	Please email questions to jim@har-gis.com .
  Doc & Updates: http://www.efg2.com/Lab/ImageProcessing/RotateScanline.htm
  and http://www.efg2.com/Lab/Library/Delphi/Graphics/JimHargis_RotateBitMap.zip
}
{Notes...
  Coordinates and rotation are adjusted for 'flipped' Y axis (+Y is down)
  Bitmap origins are (0,0) in top-left.
  BitMapRotated is enlarged to contain the rotated bitmap
  BitMapOriginal may be changed from 1,2,4 bit to pf8Bit, if needed.
//	rotate about center, Oldaxis:=POINT( bmp.width div 2, bmp.height div 2 );
//  rotate about origin top-left, Oldaxis:=POINT( 0,0 );
//  rotate about bottom-center, Oldaxis:=POINT( bmp.width div 2, bmp.height )
  NewAxis: is the new center of rotation for BitMapRotated;
}
{Usage...
  var Inbmp,Newbmp:TbitMap;
  var Center, NewCenter: TPoint;
  begin  //draw at 45 degrees rotated about center
    inbmp:=Tbitmap.Create; Newbmp:=Tbitmap.Create;
    InBMP.LoadFromFile( '..\Athena.bmp'); InBMP.Transparent:=True;
    Center:=POINT( inbmp.width div 2, inbmp.height div 2 );
    RotateBitMap( inBMP, 45*pi/180, NewBMP, Center, NewCenter );
    //place the bmp rotation axis at 100,100...
    Canvas.Draw( 100-NewCenter.x, 100-NewCenter.y, NewBMP );
    inbmp.free; newbmp.free;
  end;
}
{Features/ improvements over original EFG RotateBitMap:
  This is generalized procedure; application independent.
  Does NOT clip corners; Enlarges Output bmp if needed.
  Output keeps same transparency and pallette as set by BitMapOriginal.
	Handles all pixel formats, format converted to least one byte per pixel.
	Axis of rotation specified by caller, but new axis will differ from oldaxis.
	Minor Delphi performance optimizations (about 8 instructions per pixel)
  Skips "null" angles which have no discernable effect.
}
{Restrictions:
	Caller responsible for create/destroy bitmaps.  This improves perfc in loops.
  Caller must provide the following:
    AngleType: the user-specified float format for real angle.
      can be single, double or extended; you won't see any difference.
    function min( const i,j:integer ):integer;  // from Math.pas
    procedure sincos(const theta:real; var sine,cosine:Extended );//from Math.pas
	Uses nearest neighbor sampling, no antialiasing: poor quality;
	Not optimized for Pentium;  no MMX. (see Intel Image Processing Library)
}
{Revisions...
12/1/99 original code extracted from Earl F. Glynn
		Copyright (C) 1997-1998 Earl F. Glynn, Overland Park, KS  USA.
		All Rights Reserved.
12/10/99 new code added to make a standalone method. Original in (*comments*)
		Copyright (c) 1999-2000 har*GIS LLC, Englewood CO USA; jim@har-gis.com
    V1.0.0 release
12/15/99 add rotation axis to be specified
		add transparent color, add rotated rectangle output (non-clipped).
12/25/99  recomputed  new rotation axis.
1/6/2000  allow multibyte pixel formats. Translate 1bit and 4bit to 8bit.
10/31/00  add support for pixel formats pfDevice, pfCustom (from Rob Rossmair);
  drop err and debug message I/O;
  deleted the changed code from EFG; use "with" for efficiency;
  add check for nil angle (rotates less than 1 pizel;
  publish as general function, not a method.
11/5/00 allow variable real formats (but only need single precision);
  drop temp bitmap (BM8),  OriginalBitmap is converted if needed.
  fix BUG which ignored OldAxis, always rotated about center, set bad NewAxis
  fix BUG in false optimization for angle zero, which overwrote the input bmp)
11/12/00 fix BUG in calc of NewAxis; simplify math for center rotation.
  V1.0.5 release}
{ToDo.. use pointer arithmetic instead of type subscripting for faster pixels.
  Test pfDevice and pfCustom, test palettes. <no data>. }
	VAR
		cosTheta       :  Single;   {in windows}
		sinTheta       :  Single;
		i              :  INTEGER;
		iOriginal      :  INTEGER;
		iPrime         :  INTEGER;
		j              :  INTEGER;
		jOriginal      :  INTEGER;
		jPrime         :  INTEGER;
		NewWidth,NewHeight:INTEGER;
		nBytes, nBits: Integer;//no. bytes per pixelformat
		Oht,Owi,Rht,Rwi: Integer;//Original and Rotated subscripts to bottom/right
//The variant pixel formats for subscripting       1/6/00
	type // from Delphi
		TRGBTripleArray = array [0..32767] of TRGBTriple; //allow integer subscript
		pRGBTripleArray = ^TRGBTripleArray;
		TRGBQuadArray = array [0..32767]  of TRGBQuad;//allow integer subscript
		pRGBQuadArray = ^TRGBQuadArray;
	var //each of the following points to the same scanlines
		RowRotatedB: pByteArray; 			//1 byte
		RowRotatedW: pWordArray;  		//2 bytes
		RowRotatedT: pRGBtripleArray;	//3 bytes
		RowRotatedQ: pRGBquadArray;  	//4 bytes
	var //a single pixel for each format 	1/8/00
		TransparentB: Byte;
		TransparentW: Word;
		TransparentT: TRGBTriple;
		TransparentQ: TRGBQuad;
  var
    DIB: TDIBSection;//10/31/00
    //Center:  TPOINT; //the middle of the bmp relative to bmp origin.
    SiCoPhi: SiCoDiType;//sine,cosine, distance
  {=======================================}
  begin
    with BitMapOriginal do
    begin
      //Decipher the appropriate pixelformat to use Delphi byte subscripting 1/6/00
      //pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit,pfCustom;
      case pixelformat of
        pfDevice:
          begin //handle only pixelbits= 1..8,16,24,32 //10/31/00
            nbits := GetDeviceCaps( Canvas.Handle,BITSPIXEL ) + 1;
            nbytes := nbits div 8; //no. bytes for bits per pixel
            if (nbytes>0) and (nbits mod 8 <> 0) then
              Exit;//ignore if invalid
          end;
        pf1bit:  nBytes := 0;// 1bit, TByteArray      //2 color pallete , re-assign byte value to 8 pixels, for entire scan line
        pf4bit:	 nBytes := 0;// 4bit, PByteArray     // 16 color pallette; build nibble for pixel pallette index; convert to 8 pixels
        pf8bit:  nBytes := 1;// 8bit, PByteArray     // byte pallette, 253 out of 256 colors; depends on display mode, needs Truecolor ;
        pf15bit: nBytes := 2;// 15bit,PWordArrayType // 0rrrrr ggggg bbbbb  0+5+5+5
        pf16bit: nBytes := 2;// 16bit,PWordArrayType // rrrrr gggggg bbbbb  5+6+5
        pf24bit: nBytes := 3;// 24bit,pRGBtripleArray// bbbbbbbb gggggggg rrrrrrrr  8+8+8
        pf32bit: nBytes := 4;// 32bit,pRGBquadArray  // bbbbbbbb gggggggg rrrrrrrr aaaaaaaa 8+8+8+alpha
                           // can assign 'Single' reals to this for generating displays/plasma!
        pfCustom:
          begin  //handle only pixelbits= 1..8,16,24,32  //10/31/00
            GetObject( Handle, SizeOf(DIB), @DIB );
            nbits := DIB.dsBmih.biSizeImage;
            nbytes := nbits div 8;
            if (nbytes>0)and(nbits mod 8 <> 0) then
              Exit;//ignore if invalid
          end;// pfcustom
        else
          Exit;// 10/31/00 ignore invalid formats
      end;// case

    // BitmapRotated.PixelFormat is the same as BitmapOriginal.PixelFormat;
    // IF PixelFormat is less than 8 bit, then BitMapOriginal.PixelFormat = pf8Bit,
    //  because Delphi can't index to bits, just bytes;
    // The next time BitMapOriginal is used it will already be converted.
    //( bmp storage may increase by factor of n*n, where n=8/(no. bits per pixel)  )
      if nBytes=0 then
        PixelFormat := pf8bit; //note that input bmp is changed

    //assign copies all properties, including pallette and transparency   11/7/00
    //fix bug 1/30/00 where BitMapOriginal was overwritten bec. pointer was copied
      BitmapRotated.Assign( BitMapOriginal);

      //COUNTERCLOCKWISE rotation angle in radians. 12/10/99
      sinTheta := SIN( theta ); cosTheta := COS( theta );
      //SINCOS( theta, sinTheta, cosTheta ) ; math.pas requires extended reals.

      //calculate the enclosing rectangle  12/15/00
      NewWidth  := ABS( ROUND( Height*sinTheta) ) + ABS( ROUND( Width*cosTheta ) );
      NewHeight := ABS( ROUND( Width*sinTheta ) ) + ABS( ROUND( Height*cosTheta) );

      //diff size bitmaps have diff resolution of angle, ie r*sin(theta)<1 pixel
      //use the small angle approx: sin(theta) ~~ theta   //11/7/00
      if ( ABS(theta)*MAX( width,height ) ) > 1 then
      begin//non-zero rotation
        //set output bitmap formats; we do not assume a fixed format or size 1/6/00
        BitmapRotated.Width  := NewWidth;   //resize it for rotation
        BitmapRotated.Height := NewHeight;
        //center of rotation is center of bitmap
        //iRotationAxis := width div 2;
        //jRotationAxis := height div 2;

        //local constants for loop, each was hit at least width*height times   1/8/00
        Rwi := NewWidth - 1; //right column index
        Rht := NewHeight - 1;//bottom row index
        Owi := Width - 1;    //transp color column index
        Oht := Height - 1;   //transp color row  index

        TransparentB := 0;
        TransparentW := 0;
        TransparentT.rgbtBlue := 0;
        TransparentT.rgbtGreen := 0;
        TransparentT.rgbtRed := 0;
        TransparentQ.rgbBlue := 0;
        TransparentQ.rgbGreen := 0;
        TransparentQ.rgbRed := 0;
        //Transparent pixel color used for out of range pixels 1/8/00
        //how to translate a Bitmap.TransparentColor=Canvas.Pixels[0, Height - 1];
        // from Tcolor into pixelformat..
        case nBytes of
          0,1:TransparentB := PByteArray     ( Scanline[ Oht ] )[0];
          2:	TransparentW := PWordArray     ( Scanline[ Oht ] )[0];
          3:	TransparentT := pRGBtripleArray( Scanline[ Oht ] )[0];
          4:	TransparentQ := pRGBquadArray  ( Scanline[ Oht ] )[0];
        end;//case *)

        RowRotatedB := nil;
        RowRotatedW := nil;
        RowRotatedT := nil;
        RowRotatedQ := nil;
        // Step through each row of rotated image.
        FOR j := Rht DOWNTO 0 DO   //1/8/00
        BEGIN //for j
          case nBytes of  //1/6/00
          0,1:RowRotatedB := BitmapRotated.Scanline[ j ] ;
          2:	RowRotatedW := BitmapRotated.Scanline[ j ] ;
          3:	RowRotatedT := BitmapRotated.Scanline[ j ] ;
          4:	RowRotatedQ := BitmapRotated.Scanline[ j ] ;
          end;//case

          // offset origin by the growth factor     //12/25/99
          //	jPrime := 2*(j - (NewHeight - Height) div 2 - jRotationAxis) + 1 ;
          jPrime := 2*j - NewHeight + 1 ;

          // Step through each column of rotated image
          FOR i := Rwi DOWNTO 0 DO   //1/8/00
          BEGIN //for i
            // offset origin by the growth factor  //12/25/99
            iPrime := 2*i - NewWidth + 1;

            // Rotate (iPrime, jPrime) to location of desired pixel	(iPrimeRotated,jPrimeRotated)
            // Transform back to pixel coordinates of image, including translation
            // of origin from axis of rotation to origin of image.
            iOriginal := ( ROUND( iPrime*CosTheta - jPrime*sinTheta ) -1 + width ) DIV 2;
            jOriginal := ( ROUND( iPrime*sinTheta + jPrime*cosTheta ) -1 + height) DIV 2 ;

            // Make sure (iOriginal, jOriginal) is in BitmapOriginal.  If not,
            // assign background color to corner points.
            IF   ( iOriginal >= 0 ) AND ( iOriginal <= Owi ) AND
                 ( jOriginal >= 0 ) AND ( jOriginal <= Oht )    //1/8/00
            THEN
            BEGIN //inside
              // Assign pixel from rotated space to current pixel in BitmapRotated
              //( nearest neighbor interpolation)
              case nBytes of  //get pixel bytes according to pixel format   1/6/00
              0,1:RowRotatedB[i] := pByteArray(      scanline[joriginal] )[iOriginal];
              2:	RowRotatedW[i] := pWordArray(      Scanline[jOriginal] )[iOriginal];
              3:	RowRotatedT[i] := pRGBtripleArray( Scanline[jOriginal] )[iOriginal];
              4:	RowRotatedQ[i] := pRGBquadArray(   Scanline[jOriginal] )[iOriginal];
              end;//case
            END //inside
            ELSE
            BEGIN //outside
              //12/10/99 set background corner color to transparent (lower left corner)
              //	RowRotated[i]:=tpixelformat(BitMapOriginal.TRANSPARENTCOLOR) ; wont work
              case nBytes of
              0,1:RowRotatedB[i] := TransparentB;
              2:	RowRotatedW[i] := TransparentW;
              3:	RowRotatedT[i] := TransparentT;
              4:	RowRotatedQ[i] := TransparentQ;
              end;//case
            END //if inside
          END //for i
        END;//for j
      end;//non-zero rotation

      //offset to the apparent center of rotation   11/12/00 12/25/99
      //rotate/translate the old bitmap origin to the new bitmap origin,FIXED 11/12/00
      sicoPhi := sicodiPoint(  POINT( width div 2, height div 2 ),oldaxis );
      //sine/cosine/dist of axis point from center point
      with sicoPhi do
      begin
        NewAxis.x := newWidth div 2 + ROUND( di*(CosTheta*co - SinTheta*si) );
        NewAxis.y := newHeight div 2- ROUND( di*(SinTheta*co + CosTheta*si) );//flip yaxis
      end;
    end;//with
  END; {RotateBitmap}

{ save clipped area to procedure }

Procedure SaveClippedAreaTo( DrawBox: TEzBaseDrawBox; Const NewGis: TEzBaseGis );
Var
  hasClipped, hasClippedThis: Boolean;
  I, J, N, ARecno, ClipIndex: Integer;
  Layer, NewLayer: TEzBaseLayer;
  WCRect: TEzRect;
  Entities: Array[TEzEntityID] Of TEzEntity;
  Cont: TEzEntityID;
  SavedCursor: TCursor;
  FieldList: TStringList;
  SavedLimit: SmallInt;

  Procedure ClipOpenedEntity( Ent: TEzEntity; Const Clip: TEzRect );
  Var
    VisPoints, cnt, n, Idx1, Idx2: Integer;
    TmpPt1, TmpPt2: TEzPoint;
    TmpPts, EntPts: PEzPointArray;
    Parts: PIntegerArray;
    TmpSize, PartSize: Integer;
    ClipRes: TEzClipCodes;
    n1, PartCount, PartStart: integer;

    Procedure AddPolyline;
    Var
      cnt: integer;
    Begin
      For cnt := 0 To VisPoints - 1 Do
      Begin
        EntPts^[n1] := TmpPts^[cnt];
        Inc( n1 );
      End;
      Parts^[PartCount] := PartStart;
      Inc( PartStart, VisPoints );
      Inc( PartCount );
    End;

  Begin
    If Ent.Points.Count = 0 Then Exit;

    n := 0;
    If Ent.Points.Parts.Count < 2 Then
    Begin
      Idx1 := 0;
      Idx2 := Ent.Points.Count - 1;
    End
    Else
    Begin
      Idx1 := Ent.Points.Parts[n];
      Idx2 := Ent.Points.Parts[n + 1] - 1;
    End;
    PartSize := ( Ent.Points.Parts.Count + 4 ) * sizeOf( Integer ) * 2;
    TmpSize := ( Ent.Points.Count + 4 ) * sizeof( TEzPoint );

    GetMem( TmpPts, TmpSize );
    GetMem( EntPts, TmpSize * 2 );
    GetMem( Parts, PartSize );

    Try
      n1 := 0;
      PartCount := 0;
      PartStart := 0;
      Repeat
        VisPoints := 0;
        If IsBoxFullInBox2D( Ent.FBox, Clip ) Then
        Begin
          For cnt := Idx1 To Idx2 Do
            TmpPts^[cnt - Idx1] := Ent.Points[cnt];
          VisPoints := Succ( Idx2 - Idx1 );
        End
        Else
        Begin
          For cnt := Idx1 + 1 To Idx2 Do
          Begin
            TmpPt1 := Ent.Points[cnt - 1];
            TmpPt2 := Ent.Points[cnt];
            ClipRes := ClipLine2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              TmpPts^[VisPoints] := TmpPt1;
              Inc( VisPoints );
            End;
            If ccSecond In ClipRes Then
            Begin
              TmpPts^[VisPoints] := TmpPt2;
              Inc( VisPoints );

              AddPolyline;

              VisPoints := 0;
            End;
          End;
          If Not ( ccNotVisible In ClipRes ) Then
          Begin
            TmpPts^[VisPoints] := TmpPt2;
            Inc( VisPoints );
          End;
        End;
        If VisPoints > 0 Then
          AddPolyline;

        If Ent.Points.Parts.Count < 2 Then
          Break;
        Inc( n );
        If n >= Ent.Points.Parts.Count Then
          Break;
        Idx1 := Ent.Points.Parts[n];
        If n < Ent.Points.Parts.Count - 1 Then
          Idx2 := Ent.Points.Parts[n + 1] - 1
        Else
          Idx2 := Ent.Points.Count - 1;
      Until false;
      Ent.Points.Clear;
      If PartCount > 1 Then
        For cnt := 0 To PartCount - 1 Do
          Ent.Points.Parts.Add( Parts[cnt] );
      For cnt := 0 To n1 - 1 Do
        Ent.Points.Add( EntPts^[cnt] );
    Finally
      FreeMem( TmpPts, TmpSize );
      FreeMem( EntPts, TmpSize * 2 );
      FreeMem( Parts, PartSize );
    End;
  End;

  Procedure ClipClosedEntity( Ent: TEzEntity; Const Clip: TEzRect );
  Var
    cnt, VisPoints, VisPoints1, PartStart, Idx1, Idx2, PartCount, n, n1: integer;
    TmpPts, FirstClipPts, EntPts: PEzPointArray;
    Parts: PIntegerArray;
    TmpSize, PartSize: Integer;
    TmpPt1, TmpPt2: TEzPoint;
    ClipRes: TEzClipCodes;
  Begin
    If Ent.Points.Count = 0 Then
      exit;
    If Ent.Points.Count = 2 Then
    Begin
      ClipOpenedEntity( Ent, Clip );
      exit;
    End;
    n := 0;
    If Ent.Points.Parts.Count < 2 Then
    Begin
      Idx1 := 0;
      Idx2 := Ent.Points.Count - 1;
    End
    Else
    Begin
      Idx1 := Ent.Points.Parts[n];
      Idx2 := Ent.Points.Parts[n + 1] - 1;
    End;

    TmpSize := ( Ent.Points.Count + 4 ) * sizeof( TEzPoint );
    PartSize := ( Ent.Points.Count + 4 ) * sizeof( Integer );

    GetMem( TmpPts, TmpSize );
    GetMem( FirstClipPts, TmpSize );
    GetMem( EntPts, TmpSize * 2 );
    GetMem( Parts, PartSize );

    Try
      PartCount := 0;
      n1 := 0;
      PartStart := 0;
      Repeat
        VisPoints1 := 0;
        If IsBoxFullInBox2D( Ent.FBox, Clip ) Then
        Begin
          For cnt := Idx1 To Idx2 Do
            TmpPts^[cnt - Idx1] := Ent.Points[cnt];
          VisPoints := ( Idx2 - Idx1 ) + 1;
        End
        Else
        Begin
          For cnt := Idx1 To Idx2 Do
          Begin
            TmpPt1 := Ent.Points[cnt];
            If cnt < Idx2 Then
              TmpPt2 := Ent.Points[cnt + 1]
            Else
              TmpPt2 := Ent.Points[Idx1];
            ClipRes := ClipLineLeftRight2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              FirstClipPts^[VisPoints1] := TmpPt1;
              Inc( VisPoints1 );
            End;
            If ccSecond In ClipRes Then
            Begin
              FirstClipPts^[VisPoints1] := TmpPt2;
              Inc( VisPoints1 );
            End;
          End;
          FirstClipPts^[VisPoints1] := FirstClipPts^[0];
          Inc( VisPoints1 );
          VisPoints := 0;
          For cnt := 0 To VisPoints1 - 2 Do
          Begin
            TmpPt1 := FirstClipPts^[cnt];
            TmpPt2 := FirstClipPts^[cnt + 1];
            ClipRes := ClipLineUpBottom2D( Clip, TmpPt1.X, TmpPt1.Y, TmpPt2.X, TmpPt2.Y );
            If Not ( ccNotVisible In ClipRes ) Then
            Begin
              TmpPts^[VisPoints] := TmpPt1;
              Inc( VisPoints );
            End;
            If ccSecond In ClipRes Then
            Begin
              TmpPts^[VisPoints] := TmpPt2;
              Inc( VisPoints );
            End;
          End;
        End;
        If VisPoints > 1 Then
        Begin
          { save to total array of points }
          For cnt := 0 To VisPoints - 1 Do
          Begin
            EntPts^[n1] := TmpPts^[cnt];
            Inc( n1 );
          End;
          Parts^[PartCount] := PartStart;
          Inc( PartStart, VisPoints );
          Inc( PartCount );
        End;
        If Ent.Points.Parts.Count < 2 Then
          Break;
        Inc( n );
        If n >= Ent.Points.Parts.Count Then
          Break;
        Idx1 := Ent.Points.Parts[n];
        If n < Ent.Points.Parts.Count - 1 Then
          Idx2 := Ent.Points.Parts[n + 1] - 1
        Else
          Idx2 := Ent.Points.Count - 1;
      Until False;
      Ent.Points.Clear;
      If PartCount > 1 Then
        For cnt := 0 To PartCount - 1 Do
          Ent.Points.Parts.Add( Parts^[cnt] );
      For cnt := 0 To n1 - 1 Do
        Ent.Points.Add( EntPts^[cnt] );
    Finally
      FreeMem( TmpPts, TmpSize );
      FreeMem( FirstClipPts, TmpSize );
      FreeMem( EntPts, TmpSize * 2 );
      FreeMem( Parts, PartSize );
    End;
  End;

  Procedure AddToNewLayer( ALayer: TEzBaseLayer; ARecno: Integer );
  Var
    TmpEntity, WorkEnt, clipent, rsltent: TEzEntity;
    TheRecno, I, J, n, PartCount: Integer;
    Pass, MustFree: Boolean;
    subject, clipping, rslt: TEzEntityList;
    EntityID: TEzEntityID;
  Begin
    Try
      With DrawBox, ALayer Do
      Begin
        EntityID := RecEntityID;
        TmpEntity := Entities[EntityID];
        RecLoadEntity2( TmpEntity );
        // clip the entity
        Pass := False;
        MustFree := False;
        WorkEnt := TmpEntity;
        If hasClippedThis Then
          Pass := True
            // clipped the selected entities (not need to clip against anything)
        Else If DrawBox.Gis.MapInfo.IsAreaClipped Then
        Begin
          // first check if entity is inside area clipped
          If Not IsBoxInBox2D( WorkEnt.FBox, WCRect ) Then Exit;
          // detect the entities that can be clipped
          If EntityID In [idPolyline, idPolygon, idRectangle, idArc, idEllipse, idSpline] Then
          Begin
            If DrawBox.Gis.MapInfo.ClipAreaKind = cpkPolygonal Then
            Begin
              // clip to a polygonal area
              If WorkEnt.IsClosed Then
              Begin
                If Not ( EntityID = idPolygon ) Then
                Begin
                  WorkEnt := TEzPolygon.CreateEntity( [Point2D( 0, 0 )] );
                  WorkEnt.Points.Assign( TmpEntity.DrawPoints );
                  TEzClosedEntity( WorkEnt ).Pentool.Assign( TEzClosedEntity( TmpEntity ).Pentool );
                  TEzClosedEntity( WorkEnt ).Brushtool.assign( TEzClosedEntity( TmpEntity ).Brushtool );
                  MustFree := True;
                End;
                subject := TEzEntityList.Create;
                clipping := TEzEntityList.Create;
                rslt := TEzEntityList.Create;
                clipent := DrawBox.CreateEntity( idPolygon );
                Try
                  clipent.Points.Assign( DrawBox.Gis.ClipPolygonalArea );
                  clipping.add( clipent );
                  subject.add( WorkEnt );
                  PolygonClip( pcINT, subject, clipping, rslt, Nil );
                  For I := 0 To rslt.count - 1 Do
                    With TEzEntity( rslt[I] ) Do
                      If Not EzLib.EqualPoint2D( Points[0],
                        Points[Points.Count - 1] ) Then
                        Points.Add( Points[0] );
                  WorkEnt.Points.Clear;
                  PartCount := 0;
                  For I := 0 To rslt.count - 1 Do
                  Begin
                    rsltent := TEzEntity( rslt[I] );
                    n := rsltent.Points.Count;
                    For J := 0 To n - 1 Do
                      WorkEnt.Points.add( rsltent.Points[J] );
                    WorkEnt.Points.Parts.Add( PartCount );
                    Inc( PartCount, n );
                  End;
                  With WorkEnt.Points.Parts Do
                    If Count < 2 Then
                      Clear;
                Finally
                  clipent.free;
                  subject.free;
                  clipping.free;
                  rslt.free;
                  //rslt.free;
                End;
              End
              Else
              Begin
                // warning: the entity is clipped against the bounding box of
                // the polygonal defined in this release
                {clipent:= DrawBox.CreateEntity(idPolygon);
                try
                   clipent.Points.Assign(DrawBox.Gis.FClipPolygonalArea);
                   if TmpEntity.IsInsideEntity(clipent,false) then }
                If Not ( EntityID = idPolyline ) Then
                Begin
                  WorkEnt := TEzPolyline.CreateEntity( [Point2D( 0, 0 )] );
                  WorkEnt.Points.Assign( TmpEntity.DrawPoints );
                  TEzClosedEntity( WorkEnt ).Pentool.assign( TEzClosedEntity( TmpEntity ).Pentool );
                  TEzClosedEntity( WorkEnt ).Brushtool.assign( TEzClosedEntity( TmpEntity ).Brushtool );
                  MustFree := True;
                End;
                ClipOpenedEntity( WorkEnt, WCRect );
                {finally
                   clipent.free;
                end; }
              End;
            End
            Else
            Begin
              // clip to a rectangular area
              If WorkEnt.IsClosed Then
                ClipClosedEntity( WorkEnt, WCRect )
              Else
                ClipOpenedEntity( WorkEnt, WCRect );
            End;
            Pass := WorkEnt.Points.Count > 0;
          End
          Else
          Begin
            // all other entities are considered if are full or partially inside the clipped area
            clipent := DrawBox.CreateEntity( idPolygon );
            Try
              If DrawBox.Gis.MapInfo.ClipAreaKind = cpkPolygonal Then
              Begin
                clipent.Points.Assign( DrawBox.Gis.ClipPolygonalArea );
                Pass := WorkEnt.IsInsideEntity( clipent, false );
              End
              Else
              Begin
                Pass := IsRectVisible( WorkEnt.FBox, WCRect );
              End;
            Finally
              clipent.free;
            End;
          End;
        End;
        If Not Pass Then Exit;

        // EXPORT THIS ENTITY TO NEW LAYER
        TheRecno:= NewLayer.AddEntity( WorkEnt );
        If MustFree Then
          WorkEnt.Free;
        // now copy DB record information
        If ( ALayer.DBTable <> Nil ) And ( NewLayer.DBTable <> Nil ) Then
        Begin
          //ALayer.Recno:= ARecno;
          ALayer.DBTable.Recno := ARecno;
          NewLayer.DBTable.Recno:= TheRecno;
          NewLayer.DBTable.Edit;
          For J := 1 To ALayer.DBTable.FieldCount Do
            NewLayer.DBTable.AssignFrom( ALayer.DBTable, J, J );
          NewLayer.DBTable.Post;
        End;
      End;
    Except
      // ignore errors
    End;
  End;

Begin

  With DrawBox, DrawBox.Gis.MapInfo Do
  Begin
    //WCRect := Extension;
    hasClipped := Gis.ClippedEntities.Count > 0;
    If Not ( IsAreaClipped Or HasClipped ) Then  Exit;
    If IsAreaClipped Then
    Begin
      If ClipAreaKind = cpkPolygonal Then
        WCRect := Gis.ClipPolygonalArea.Extension
      Else
        WCRect := AreaClipped;
    End
    Else
    Begin
      Gis.ClippedEntities.DrawBox := DrawBox;
      WCRect := Gis.ClippedEntities.GetExtension;
    End;
    For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
      Entities[Cont] := GetClassFromID( Cont ).Create( 4 );
    SavedLimit := Ez_Preferences.MinDrawLimit;
    Ez_Preferences.MinDrawLimit := 0;
    SavedCursor:= crDefault;
    If Gis.ShowWaitCursor Then
    Begin
      SavedCursor := DrawBox.Cursor;
      DrawBox.Cursor := crHourglass;
    End;
    Try
      NewGis.MapInfo.Assign( Gis.MapInfo );
      With NewGis.MapInfo Do
      Begin
        Extension := INVALID_EXTENSION;
        NumLayers := 0;
      End;
      NewGis.ClearClippedArea;
      // now search all the layers
      For I := 0 To Gis.Layers.Count - 1 Do
      Begin
        Layer := Gis.Layers[I];
        ClipIndex:= -1;
        If HasClipped Then
        Begin
          ClipIndex := Gis.ClippedEntities.IndexOf( Layer );
          hasClippedThis := ClipIndex >= 0;
        End
        Else
          hasClippedThis := false;
        With Layer Do
        Begin
          If Not LayerInfo.Visible Or ( Layer.Recordcount = 0 ) Or
            ( HasClipped And Not hasClippedThis ) Then
            Continue;

          // Create the new layer
          FieldList := TStringList.Create;
          Try
            With Layer Do
            Begin
              If Layer.DBTable <> Nil Then
              Begin
                For J := 1 To Layer.DBTable.FieldCount Do
                  FieldList.Add( Format( '%s;%s;%d;%d', [Layer.DBTable.Field( J ),
                    Layer.DBTable.FieldType( J ),
                      Layer.DBTable.FieldLen( J ),
                      Layer.DBTable.FieldDec( J )] ) );
              End;
              With LayerInfo Do
                NewLayer :=
                  //NewGis.Layers.CreateNew(ExtractFilePath(Filename) +
                NewGis.Layers.CreateNewEx( ExtractFilePath( NewGis.Filename ) +
                  Layer.Name + '_', CoordSystem, CoordsUnits, FieldList );
            End;
          Finally
            FieldList.Free;
          End;

          NewGis.MapInfo.CurrentLayer := NewLayer.Name;

          SetGraphicFilter( stOverlap, WCRect );

          Gis.StartProgress( Layer.Name, 1, Layer.RecordCount );
          N := 0;
          First;
          StartBuffering;
          Try
            While Not Eof Do
            Begin
              Try
                Inc( N );
                Gis.UpdateProgress( N );
                ARecno := Recno;

                If RecIsDeleted Or
                  ( hasClippedThis And Not Gis.ClippedEntities[ClipIndex].IsSelected( ARecno ) ) Then
                  Continue;

                AddToNewLayer( Layer, ARecno );
              Finally
                Next;
              End;
            End;
          Finally
            EndBuffering;
            CancelFilter;
            Gis.EndProgress;
          End;
        End;
      End;
      NewGis.Save;
    Finally
      NewGis.Free;
      For Cont := Low( TEzEntityID ) To High( TEzEntityID ) Do
        Entities[Cont].Free;
      Ez_Preferences.MinDrawLimit := SavedLimit;
      If Gis.ShowWaitCursor Then
        DrawBox.Cursor := SavedCursor;
    End;
  End;
End;


{ Procedure for clipping a line against a polygon
  Polygon is the source polygons
  Polyline is the polyline to clip against Polygon
  Result is the resulting polylines
}

type
  Tedge = record
    xA, yA, xB, yB: Double;
    nx, ny: Double;
  end;

Function ClipParam(const denom, num: Double; var tE, tL: Double): Boolean;
Var
  t: Double;
begin
  Result:= False;
  if denom > 0 then
  begin
    t := num / denom;
    if t > tL then Exit;
    tE := t;
  end else if denom < 0 then
  begin
    t := num / denom;
    if t < tE then Exit;
    tL := t;
  end else if num > 0 then
    Exit;
  Result:= True;
end;

procedure CyrusBeckLineClip(Polyline, Polygon, Result: TEzVector);
Var
  num, denom, dx, dy, tE, tL: Double;
  e: TEdge;
  I, J, N: Integer;
  p: TEzPoint;
  x0, y0, x1, y1: Double;
  LastPt: TEzPoint;
  Accepted: Boolean;
begin
  if EzLib.IsCounterClockWise( Polygon ) then
    Polygon.RevertDirection;

  LastPt:= Point2d(MAXCOORD, MAXCOORD);
  N:= 0;
  for J:= 0 to Polyline.Count-2 do
  begin
    x0:= Polyline[J].x;
    y0:= Polyline[J].y;
    x1:= Polyline[J + 1].x;
    y1:= Polyline[J + 1].y;
    dx:= x1 - x0;
    dy:= y1 - y0;
    tE:= 0.0;
    tL:= 1.0;
    Accepted:= True;
    for I:= 0 to Polygon.Count-2 do
    begin
      e.xA := Polygon[I].x;
      e.yA := Polygon[I].y;
      e.xB := Polygon[I + 1].x;
      e.yB := Polygon[I + 1].y;
      { compute normal }
      p:= TransformPoint2d( Polygon[I + 1], Rotate2d( System.Pi / 2, Polygon[I] ) );
      e.nx:= p.x;
      e.ny:= p.y;
      // denom is -Ni.D; num is Ni.(A-P)
      denom := -e.nx * dx - e.ny * dy;
      num := e.nx * (e.xA - x0) + e.ny * (e.yA - y0);
      if not ClipParam (denom, num, tE, tL) then
      begin
        Accepted:= False;
        Break;
      end;
    end;
    if not Accepted then Continue;

    // compute clipped end points
    if tL < 1 then
    begin
      x1 := x0 + tL*dx;
      y1 := y0 + tL*dy;
    end;
    if tE > 0 then
    begin
      x0 := x0 + tE*dx;
      y0 := y0 + tE*dy;
    end;
    Result.AddPoint(x0, y0);
    Result.AddPoint(x1, y1);
    Result.Parts.Add(N);
    Inc(N, 2);
  end;
  if Result.Parts.Count < 2 then
    Result.Parts.Clear;
end;


{ ******************** bitmaps sections *********************** }

{$R-}
Procedure PrintBitmapEx( Canvas: TCanvas; Const DestinationRect: TRect;
  ABitmap: TBitmap; Const SourceRect: TRect );
Var
  Info: PBitmapInfo;
  Image: Pointer;
  Tc: Integer;
  InfoSize, ImageSize: DWORD;
  SourceHeight, SourceWidth: Integer;
Begin
  SourceHeight := Abs( SourceRect.Bottom - SourceRect.Top );
  SourceWidth := Abs( SourceRect.Right - SourceRect.Left );
  GetDIBSizes( ABitmap.Handle, InfoSize, ImageSize );
  Info := GetMemEx( InfoSize );
  Image := GetMemEx( ImageSize );
  Try
    GetDIB( ABitmap.Handle, ABitmap.Palette, Info^, Image^ );
    Tc := SourceRect.Top;
    If Info^.bmiHeader.biHeight > 0 Then
      Tc := Info^.bmiHeader.biHeight - SourceHeight - SourceRect.Top;
    SetStretchBltMode( Canvas.Handle, COLORONCOLOR );
    With DestinationRect Do
      StretchDIBits( Canvas.Handle,
        Left, Top, ( Right - Left ), ( Bottom - Top ),
        SourceRect.Left, Tc, SourceWidth, SourceHeight,
        Image, Info^, DIB_RGB_COLORS, SRCCOPY );
  Finally
    FreeMemEx( Info );
    FreeMemEx( Image );
  End;
End;

Procedure Fill8X8Bitmap( ACanvas: TCanvas;
  DestRect: TRect;
  Bitmap: TBitmap;
  ForeColor, BackColor: TColor );
Var
  Bits: Pointer;
  p1: Integer;
  HeaderSize, BitsSize: DWORD;
  OldHandle, ABrush: HBrush;
  compbitmap: HBitmap;
  BitmapInfo: PBitmapInfo;
Begin

  GetDIBSizes( Bitmap.Handle, HeaderSize, BitsSize );
  BitmapInfo := GetMemEx( HeaderSize );
  Bits := GetMemEx( BitsSize );
  Try
    GetDIB( Bitmap.Handle, Bitmap.Palette, BitmapInfo^, Bits^ );
    With BitmapInfo^.bmiHeader Do
    Begin
      biClrUsed := 2;
      biClrImportant := 0;
    End;
    p1 := 0;
    With BitmapInfo^.bmiColors[p1] Do
    Begin
      rgbRed := GetRValue( ForeColor );
      rgbGreen := GetGValue( ForeColor );
      rgbBlue := GetBValue( ForeColor );
    End;
    p1 := 1;
    With BitmapInfo^.bmiColors[p1] Do
    Begin
      rgbRed := GetRValue( BackColor );
      rgbGreen := GetGValue( BackColor );
      rgbBlue := GetBValue( BackColor );
    End;

    compbitmap := CreateDIBitmap( ACanvas.Handle, BitmapInfo^.bmiHeader,
      CBM_INIT, Bits, BitmapInfo^, DIB_RGB_COLORS );

    ABrush := CreatePatternBrush( compbitmap );

    DeleteObject( compbitmap );

    OldHandle := SelectObject( ACanvas.Handle, ABrush );

    With DestRect Do
      PatBlt( ACanvas.Handle, left, top, ( right - left ), ( bottom - top ), PATCOPY );

    SelectObject( ACanvas.handle, OldHandle );

    DeleteObject( ABrush );

  Finally
    FreeMemEx( BitmapInfo );
    FreeMemEx( Bits );
  End;
End;

Procedure PrinterFill8X8Bitmap( ACanvas: TCanvas;
  DestRect: TRect;
  Bitmap: TBitmap;
  ForeColor, BackColor: TColor;
  Factor: Double );
Var
  Header, Bits: Pointer;
  p1: Integer;
  HeaderSize, BitsSize: DWORD;
  ScaledWidth, ScaledHeight,
    DeltaX, DeltaY: integer;
  ScaledRect: TRect;
  WorkBmp: TBitmap;
Begin
  GetDIBSizes( Bitmap.Handle, HeaderSize, BitsSize );
  Header := GetMemEx( HeaderSize );
  Bits := GetMemEx( BitsSize );

  WorkBmp := TBitmap.Create;
  Try

    With WorkBmp, DestRect Do
    Begin
      Width := Right - Left;
      Height := Bottom - Top;
    End;

    GetDIB( Bitmap.Handle, Bitmap.Palette, Header^, Bits^ );
    ScaledWidth := trunc( PBitmapInfo( Header )^.bmiHeader.biWidth * factor );
    ScaledHeight := trunc( PBitmapInfo( Header )^.bmiHeader.biHeight * factor );

    { modify the bitmap }
    If ( Bitmap.WIdth = 8 ) And ( Bitmap.Height = 8 ) And Bitmap.Monochrome Then
    Begin
      With PBitmapInfo( Header )^.bmiHeader Do
      Begin
        biClrUsed := 2;
        biClrImportant := 0;
      End;
      p1 := 0;
      With PBitmapInfo( Header )^.bmiColors[p1] Do
      Begin
        rgbRed := GetRValue( ForeColor );
        rgbGreen := GetGValue( ForeColor );
        rgbBlue := GetBValue( ForeColor );
      End;
      p1 := 1;
      With PBitmapInfo( Header )^.bmiColors[p1] Do
      Begin
        rgbRed := GetRValue( BackColor );
        rgbGreen := GetGValue( BackColor );
        rgbBlue := GetBValue( BackColor );
      End;
    End;

    DeltaX := 0;
    While DeltaX < WorkBmp.Width Do
    Begin
      DeltaY := 0;
      While DeltaY < WorkBmp.Height Do
      Begin
        ScaledRect := Rect( DeltaX, DeltaY, DeltaX + ScaledWidth, DeltaY + ScaledHeight );
        With ScaledRect Do
          StretchDIBits( WorkBmp.Canvas.Handle,
            Left,
            Top,
            Right - Left,
            Bottom - Top,
            0,
            0,
            Bitmap.Width,
            Bitmap.Height,
            Bits,
            Windows.TBitmapInfo( Header^ ),
            DIB_RGB_COLORS,
            SRCCOPY );
        Inc( DeltaY, ScaledHeight );
      End;
      Inc( DeltaX, ScaledWidth );
    End;
    PrintBitmapEx( ACanvas,
      DestRect,
      WorkBmp,
      Rect( 0, 0, WorkBmp.Width, WorkBmp.Height ) );
  Finally
    WorkBmp.free;
    FreeMemEx( Header );
    FreeMemEx( Bits );
  End;
End;

Procedure PolygonScreenFill8X8Bitmap( Canvas: TCanvas; Grapher: TEzGrapher;
  Var Vertices: Array Of TPoint; Var Parts: Array Of Integer;
  PartCount: Integer; Bitmap: TBitmap; ForeColor, BackColor: TColor );
Var
  Bits: Pointer;
  Index: Integer;
  HeaderSize, BitsSize: DWORD;
  OldHandle, TmpBrush: HBrush;
  CompBitmap: HBitmap;
  BitmapInfo: PBitmapInfo;
  SavedBitMap: TBitmap;
  I, N, K, Idx1, Idx2, BW, BH: Integer;
  Xmin, Ymin, Xmax, Ymax: Integer;
  PolyRgn: HRgn;
  pointarr: PPointArray;
Begin
  if PartCount = 0 then Exit;
  If Not ( Bitmap.Monochrome And ( Bitmap.Width = 8 ) And ( Bitmap.Height = 8 ) ) Then
  Begin
    PolygonPrinterFill8X8Bitmap( Canvas, Grapher, Vertices, Parts, PartCount,
      Bitmap, ForeColor, BackColor, 1, False );
    Exit;
  End;

  GetDIBSizes( Bitmap.Handle, HeaderSize, BitsSize );
  BitmapInfo := GetMemEx( HeaderSize );
  Bits := GetMemEx( BitsSize );
  Try
    GetDIB( Bitmap.Handle, Bitmap.Palette, BitmapInfo^, Bits^ );
    With BitmapInfo^.bmiHeader Do
    Begin
      biClrUsed := 2;
      biClrImportant := 0;
    End;
    With BitmapInfo^.bmiColors[0] Do
    Begin
      rgbRed := GetRValue( ForeColor );
      rgbGreen := GetGValue( ForeColor );
      rgbBlue := GetBValue( ForeColor );
    End;
    Index := 1;
    With BitmapInfo^.bmiColors[Index] Do
    Begin
      rgbRed := GetRValue( BackColor );
      rgbGreen := GetGValue( BackColor );
      rgbBlue := GetBValue( BackColor );
    End;

    CompBitmap := CreateDIBitmap( Canvas.Handle, BitmapInfo^.bmiHeader,
      CBM_INIT, Bits, BitmapInfo^, DIB_RGB_COLORS );

    TmpBrush := CreatePatternBrush( CompBitmap );

    DeleteObject( CompBitmap );

    {Create Transparent Bitmap}

    Xmin := 0;  // to make happy the compiler
    Ymin := 0;  // to make happy the compiler
    BW := 0;    // to make happy the compiler
    BH := 0;    // to make happy the compiler

    SavedBitMap := nil;
    if BackColor=clNone then
    begin
      Xmin := MaxInt;
      Ymin := MaxInt;
      Xmax := 0;
      Ymax := 0;
      N := 0;
      for I:= 0 to PartCount - 1 do Inc(N, Parts[I]);
      for I := Low(vertices) to N - 1 do
      begin
        Xmin := EzLib.IMin(Vertices[I].X, Xmin);
        Ymin := EzLib.IMin(Vertices[I].Y, Ymin);
        Xmax := EzLib.IMax(Vertices[I].X, Xmax);
        Ymax := EzLib.IMax(Vertices[I].Y, Ymax);
      end;
      BW := Xmax - Xmin;
      BH := Ymax - Ymin;
      if ( BW > 0 ) and ( BH > 0 ) then
      begin
        SavedBitMap := TBitmap.Create;
        SavedBitMap.PixelFormat:= pf24bit;
        SavedBitMap.Width := BW;
        SavedBitMap.Height:= BH;
        OldHandle := SelectObject(SavedBitMap.Canvas.Handle, TmpBrush);
        Bitblt( SavedBitMap.Canvas.Handle, 0, 0, BW, BH,
                     Bitmap.Canvas.handle, 0, 0, PATCOPY );
        SelectObject(SavedBitMap.Canvas.handle, OldHandle);
      end else
        BackColor:= clBlack;
    end;

    OldHandle := SelectObject( Canvas.Handle, TmpBrush );

    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      Idx1:= 0;
      Idx2:= 0;
    end else
    begin
      Idx1:= 0;
      Idx2:= PartCount - 1;
    end;

    K:= 0;

    For I:= Idx1 to Idx2 do
    begin

      PolyRgn:= 0;  // to make happy the compiler
      if BackColor=clNone then
      begin
        if PartCount = 1 then
           PolyRgn := CreatePolygonRgn( Vertices, Parts[I], WINDING)
        else
        begin
           if Win32Platform = VER_PLATFORM_WIN32_NT then
             PolyRgn := CreatePolyPolygonRgn( Vertices, Parts, PartCount, Alternate)
           else
           begin
             pointarr:= @Vertices[K];
             PolyRgn := CreatePolygonRgn( pointarr^, Parts[I], WINDING);
             Inc( K, Parts[I] );
           end;
        end;
        if PolyRgn=0 then Exit;

        if Grapher<>nil then
           Grapher.CanvasRegionStacker.Push(Canvas,PolyRgn)
        else
           SelectClipRgn(Canvas.Handle, PolyRgn);

        BitBlt(Canvas.handle, Xmin, Ymin, BW, BH, SavedBitmap.Canvas.Handle, 0,0, SRCAND);

      end else
      begin
        If PartCount = 1 Then
          Polygon( Canvas.Handle, Vertices, Parts[0] )
        Else
        Begin
          if Win32Platform = VER_PLATFORM_WIN32_NT then
            PolyPolygon( Canvas.Handle, Vertices, Parts, PartCount )
          else
          begin
            pointarr:= @Vertices[K];
            Polygon( Canvas.Handle, pointarr^, Parts[I] );
            Inc( K, Parts[I] );
          end;
        End;
      end;

      SelectObject( Canvas.handle, OldHandle );

      DeleteObject( TmpBrush );

      if BackColor=clNone then
      begin
        if Grapher<>nil then
          Grapher.CanvasRegionStacker.Pop(Canvas)
        else
        begin
          SelectClipRgn(Canvas.Handle, 0);
          DeleteObject(PolyRgn);
        end;
      end;
    end;
    if BackColor=clNone then
      SavedBitMap.Free;
  Finally
    FreeMemEx( BitmapInfo );
    FreeMemEx( Bits );
  End;
End;

// Print polygon filled with 8x8 bitmap pattern

Procedure PolygonPrinterFill8X8Bitmap( Canvas: TCanvas; Grapher: TEzGrapher;
  Var Vertices: Array Of TPoint; Var Parts: Array Of Integer;
  PartCount: Integer; Bitmap: TBitmap; ForeColor, BackColor: TColor;
  Factor: Double; PlotterOptimized: Boolean );
Var
  Header, Bits: Pointer;
  HeaderSize, BitsSize: DWORD;
  ScaledRect: TRect;
  DestRect: TRect;
  PolyRgn: HRgn;
  I, K, Idx1, Idx2, p1, N: Integer;
  ScaledWidth: Integer;
  ScaledHeight: Integer;
  DeltaX: Integer;
  DeltaY: integer;
  TmpWidth: Integer;
  TmpHeight: Integer;
  cnt: Integer;
  Xmin: Integer;
  Xmax: Integer;
  Ymin: Integer;
  Ymax: Integer;
  XRop: DWORD;
  pointarr: EzLib.PPointArray;

  { some plotters will gets full printing patterns as bitmaps }
  Procedure DrawAsBitmap;
  Begin
    GetDIBSizes( Bitmap.Handle, HeaderSize, BitsSize );
    Header := GetMemEx( HeaderSize );
    Bits := GetMemEx( BitsSize );

    Try
      With DestRect Do
      Begin
        TmpWidth := Right - Left;
        TmpHeight := Bottom - Top;
      End;

      GetDIB( Bitmap.Handle, Bitmap.Palette, Header^, Bits^ );
      If Trunc( Factor ) <> Factor Then
      Begin
        ScaledWidth := Round( Factor + 0.5 ) * PBitmapInfo( Header )^.bmiHeader.biWidth;
        ScaledHeight := Round( Factor + 0.5 ) * PBitmapInfo( Header )^.bmiHeader.biHeight;
      End
      Else
      Begin
        ScaledWidth := Round( Factor * PBitmapInfo( Header )^.bmiHeader.biWidth );
        ScaledHeight := Round( Factor * PBitmapInfo( Header )^.bmiHeader.biHeight );
      End;

      If ( Bitmap.Width = 8 ) And ( Bitmap.Height = 8 ) And Bitmap.Monochrome Then
      Begin
        With PBitmapInfo( Header )^.bmiHeader Do
        Begin
          biClrUsed := 2;
          biClrImportant := 0;
        End;
        p1 := 0;
        With PBitmapInfo( Header )^.bmiColors[p1] Do
        Begin
          rgbRed := GetRValue( ForeColor );
          rgbGreen := GetGValue( ForeColor );
          rgbBlue := GetBValue( ForeColor );
        End;
        p1 := 1;
        With PBitmapInfo( Header )^.bmiColors[p1] Do
        Begin
          rgbRed := GetRValue( BackColor );
          rgbGreen := GetGValue( BackColor );
          rgbBlue := GetBValue( BackColor );
        End;
      End;

      if BackColor=clNone then XRop := SRCAND else XRop := SRCCOPY;

      DeltaX := 0;
      While DeltaX < TmpWidth Do
      Begin
        DeltaY := 0;
        While DeltaY < TmpHeight Do
        Begin
          ScaledRect := Rect( DeltaX, DeltaY, DeltaX + ScaledWidth, DeltaY + ScaledHeight );
          OffsetRect( ScaledRect, xmin, ymin );
          With ScaledRect Do
            StretchDIBits( Canvas.Handle, Left, Top, Right - Left, Bottom - Top,
              0, 0, Bitmap.Width, Bitmap.Height, Bits,
              Windows.TBitmapInfo( Header^ ), DIB_RGB_COLORS, XRop );
          Inc( DeltaY, ScaledHeight );
        End;
        Inc( DeltaX, ScaledWidth );
      End;
    Finally
      FreeMemEx( Header );
      FreeMemEx( Bits );
    End;
  End;

  {This method will print 8x8 bitmap patterns as small rectangles.
   That way the plotter will not crash with so much bitmaps}
  Procedure DrawAsVectors;
  Var
    cntleft, cnttop, StartLeft, StartTop, ifactor, bw, bh, tmpleft, tmptop: Integer;
    WorkArray: Array[0..1000, 0..1000] Of Boolean;
    TmpRect: TRect;
  Begin
    For cntleft := 0 To Bitmap.Width - 1 Do
      For cnttop := 0 To Bitmap.Height - 1 Do
        WorkArray[cntleft, cnttop] := Bitmap.Canvas.Pixels[cnttop, cntleft] = clBlack;
    ifactor := Round( Factor + 0.5 );
    bw := Bitmap.Width * ifactor;
    bh := Bitmap.Height * ifactor;
    If Grapher <> Nil Then
      Grapher.SaveCanvas( Canvas );
    (* Paint the background color*)
    Canvas.Brush.Style := bsSolid;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Mode := pmCopy;
    If BackColor <> clWhite Then
    Begin
      Canvas.Brush.Color := BackColor;
      Canvas.Pen.Color := BackColor;
      With DestRect Do
        Canvas.Rectangle( Left, Top, Right, Bottom );
    End;
    (* now the forecolor *)
    Canvas.Brush.Color := ForeColor;
    Canvas.Pen.Color := ForeColor;

    StartTop := DestRect.Top;
    While StartTop <= DestRect.Bottom Do
    Begin
      StartLeft := DestRect.Left;
      While StartLeft <= DestRect.Right Do
      Begin
        cnttop := 0;
        While cnttop <= 7 Do
        Begin
          cntleft := 0;
          While cntleft <= 7 Do
          Begin
            If WorkArray[cntleft, cnttop] Then
            Begin
              tmpleft := StartLeft + cntleft * ifactor;
              tmptop := StartTop + cnttop * ifactor;
              TmpRect := Rect( tmpleft, tmptop, tmpleft + Pred( ifactor ), tmptop + Pred( ifactor ) );
              With TmpRect Do
                Canvas.Rectangle( Left, Top, Right, Bottom );
            End;
            Inc( cntleft );
          End;
          Inc( cnttop );
        End;
        Inc( StartLeft, bw );
      End;
      Inc( StartTop, bh );
    End;
    If Grapher <> Nil Then
      Grapher.RestoreCanvas( Canvas );
  End;

Begin
  If PartCount = 0 Then Exit;

  Xmin := MaxInt;
  Ymin := MaxInt;
  Xmax := 0;
  Ymax := 0;
  N := 0;
  For cnt := 0 To PartCount - 1 Do
    Inc( N, Parts[cnt] );
  For cnt := Low( Vertices ) To N - 1 Do
  Begin
    Xmin := EzLib.IMin( Vertices[cnt].X, Xmin );
    Ymin := EzLib.IMin( Vertices[cnt].Y, Ymin );
    Xmax := EzLib.IMax( Vertices[cnt].X, Xmax );
    Ymax := EzLib.IMax( Vertices[cnt].Y, Ymax );
  End;
  DestRect := Rect( Xmin, Ymin, Xmax, Ymax );

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Idx1:= 0;
    Idx2:= 0;
  end else
  begin
    Idx1:= 0;
    Idx2:= PartCount - 1;
  end;

  K:= 0;

  For I:= Idx1 to Idx2 do
  begin
    If PartCount = 1 Then
      PolyRgn := CreatePolygonRgn( Vertices, Parts[0], WINDING )
    Else
    begin
      if Win32Platform = VER_PLATFORM_WIN32_NT then
        PolyRgn := CreatePolyPolygonRgn( Vertices, Parts, PartCount, ALTERNATE )
      else
      begin
        pointarr:= @Vertices[K];
        PolyRgn := CreatePolygonRgn( pointarr^, Parts[I], WINDING);
        Inc( K, Parts[I] );
      end;
    end;
    If PolyRgn = 0 Then Exit;

    If Grapher <> Nil Then
      Grapher.CanvasRegionStacker.Push( Canvas, PolyRgn )
    Else
      SelectClipRgn( Canvas.Handle, PolyRgn );

    Try
      If ( Bitmap.Monochrome ) And ( Bitmap.Width = 8 ) And ( Bitmap.Height = 8 ) Then
      Begin
        If PlotterOptimized Then
          { draw as vectors }
          DrawAsVectors
        Else
          { draw as bitmap }
          DrawAsBitmap;
      End
      Else
        DrawAsBitmap;
    Finally
      If Grapher <> Nil Then
        Grapher.CanvasRegionStacker.Pop( Canvas )
      Else
      Begin
        SelectClipRgn( Canvas.Handle, 0 );
        DeleteObject( PolyRgn );
      End;
    End;
  End;
End;
{$R-}

Function GetMemEx( size: DWORD ): pointer;
Begin
  Try
    result := Pointer( GlobalAlloc( GPTR, size ) );
  Except
    result := Nil;
  End;
End;

Function FreeMemEx( p: pointer ): pointer;
Begin
  Try
    If p = Nil Then
    Begin
      result := Nil;
    End
    Else
    Begin
      result := Pointer( GlobalFree( THandle( p ) ) );
    End;
  Except
    result := Nil;
  End;
End;

{ LoadDIBFromStream }

Function LoadDIBFromStream( TheStream: TStream;
  Var lpBitmapInfo: PBITMAPINFO;
  Var lpBits: Pointer;
  Var BitmapWidth: integer;
  Var BitmapHeight: integer ): Boolean;
Var
  bmf: TBITMAPFILEHEADER;
  TheFileSize: integer;
  BitmapHeaderSize: integer;
  TheImageSize: integer;
Begin
  lpBitmapInfo := Nil;
  lpBits := Nil;
  BitmapWidth := 0;
  BitmapHeight := 0;
  If TheStream = Nil Then
  Begin
    result := FALSE;
    exit;
  End;
  Try
    TheFileSize := TheStream.Size - TheStream.Position;
    TheStream.ReadBuffer( bmf, sizeof( TBITMAPFILEHEADER ) );
  Except
    result := FALSE;
    exit;
  End;
  BitmapHeaderSize := bmf.bfOffBits - sizeof( TBITMAPFILEHEADER );
  TheImageSize := TheFileSize - integer( bmf.bfOffBits );
  If ( ( bmf.bfType <> $4D42 ) Or ( integer( bmf.bfOffBits ) < 1 ) Or
    ( TheFileSize < 1 ) Or ( BitmapHeaderSize < 1 ) Or ( TheImageSize < 1 ) Or
    ( TheFileSize < ( sizeof( TBITMAPFILEHEADER ) + BitmapHeaderSize + TheImageSize ) ) ) Then
  Begin
    result := FALSE;
    exit;
  End;
  lpBitmapInfo := GetMemEx( BitmapHeaderSize );
  Try
    TheStream.ReadBuffer( lpBitmapInfo^, BitmapHeaderSize );
  Except
    Try
      FreeMemEx( lpBitmapInfo );
    Except
    End;
    lpBitmapInfo := Nil;
    result := FALSE;
    exit;
  End;
  Try
    BitmapWidth := lpBitmapInfo^.bmiHeader.biWidth;
    BitmapHeight := abs( lpBitmapInfo^.bmiHeader.biHeight );
    If lpBitmapInfo^.bmiHeader.biSizeImage <> 0 Then
    Begin
      TheImageSize := lpBitmapInfo^.bmiHeader.biSizeImage;
    End
    Else
    Begin
      TheImageSize := ( ( ( ( ( lpBitmapInfo^.bmiHeader.biWidth *
        lpBitmapInfo^.bmiHeader.biBitCount ) + 31 ) And Not 31 ) shr 3 ) *
        ABS( lpBitmapInfo^.bmiHeader.biHeight ) );
    End;
  Except
    Try
      FreeMemEx( lpBitmapInfo );
    Except
    End;
    lpBitmapInfo := Nil;
    BitmapWidth := 0;
    BitmapHeight := 0;
    result := FALSE;
    exit;
  End;
  If ( BitmapWidth < 1 ) Or ( BitmapHeight < 1 ) Or ( TheImageSize < 32 ) Then
  Begin
    Try
      FreeMemEx( lpBitmapInfo );
    Except
    End;
    lpBitmapInfo := Nil;
    BitmapWidth := 0;
    BitmapHeight := 0;
    result := FALSE;
    exit;
  End;
  lpBits := GetMemEx( TheImageSize );
  Try
    TheStream.ReadBuffer( lpBits^, TheImageSize );
  Except
    Try
      FreeMemEx( lpBits );
    Except
    End;
    Try
      FreeMemEx( lpBitmapInfo );
    Except
    End;
    lpBits := Nil;
    lpBitmapInfo := Nil;
    result := FALSE;
    exit;
  End;
  result := True;
End;

{ LoadDIBFromFile }

Function LoadDIBFromFile( Const FileName: String;
  Var lpBitmapInfo: PBITMAPINFO;
  Var lpBits: Pointer;
  Var BitmapWidth: integer;
  Var BitmapHeight: integer ): Boolean;
Var
  TheFileStream: TFileStream;
Begin
  lpBitmapInfo := Nil;
  lpBits := Nil;
  BitmapWidth := 0;
  BitmapHeight := 0;
  Try
    TheFileStream := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyWrite );
  Except
    result := FALSE;
    exit;
  End;
  result := LoadDIBFromStream( TheFileStream,
    lpBitmapInfo,
    lpBits,
    BitmapWidth,
    BitmapHeight );

  TheFileStream.Free;
End;

{ LoadDIBFromTBitmap }

Function LoadDIBFromTBitmap( ABitmap: TBitmap;
  Var lpBitmapInfo: PBITMAPINFO;
  Var lpBits: Pointer;
  Var BitmapWidth: integer;
  Var BitmapHeight: integer ): Boolean;
Var
  TheStream: TMemoryStream;
Begin
  lpBitmapInfo := Nil;
  lpBits := Nil;
  BitmapWidth := 0;
  BitmapHeight := 0;
  TheStream := TMemoryStream.Create;
  Try
    ABitmap.SaveToStream( TheStream );
    TheStream.Position := 0;
  Except
    TheStream.Free;
    result := FALSE;
    exit;
  End;
  result := LoadDIBFromStream( TheStream, lpBitmapInfo, lpBits, BitmapWidth, BitmapHeight );
  TheStream.Free;
End;

{Constructor TEzBitmapEx.Create;
Var
  HeaderSize: Integer;
Begin
  Inherited Create;
  HeaderSize := SizeOf( TBitmapInfoHeader ) + 3 * SizeOf( TRGBQuad );
  Fbmi := GetMemEx( HeaderSize );
  With Fbmi^.bmiHeader Do
  Begin
    biSize := SizeOf( Fbmi^.bmiHeader );
    biWidth := 0;
    biHeight := 0;
    biPlanes := 1;
    biBitCount := 24;
    biCompression := BI_RGB;
    biSizeImage := 0;
    biXPelsPerMeter := 1; //dont care
    biYPelsPerMeter := 1; //dont care
    biClrUsed := 0;
    biClrImportant := 0;
  End;
  FTempBitmap := TBitmap.Create;
  FTempStream := TMemoryStream.Create;

End; }

{Destructor TEzBitmapEx.Destroy;
Begin
  FTempBitmap.Free;
  FTempStream.Free;
  FreeMemEx( Fbmi );
  Inherited Destroy;
End; }

Procedure TEzBitmapEx.SetAlphaChannel( Value: Byte );
Var
  x: Integer;
Begin
  For x := -255 To 255 Do
    FBlendTable[x] := ( Value * x ) Shr 8;
  FAlphaChannel := Value;
End;

Function TEzBitmapEx.TileCurrentBand( const CurrentTileRect: TRect ): Boolean;
Var
  img_start: integer;
  img_end: integer;
  img_numscans: integer;
  ScanOffsetInFile: integer;
  OldHeight: integer;
  Bits: pointer;
  TmpBitmap: TBitmap;
  x, y, bgx, bgy, bgw, bgh: Integer;
  p1_32: pRGBQuadArray;
  p1_24, p2: pRGBTripleArray;
  scanlin: Pointer;
  BackgFormat: TPixelFormat;
Begin
  img_start := Round( FTileGlobalInfo.SourceLastScanLine );
  If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
  Begin
    FTileGlobalInfo.SourceLastScanLine := FTileGlobalInfo.SourceLastScanLine +
                                          FTileGlobalInfo.SourceFirstTileHeight;
    FTileGlobalInfo.SourceFirstTileHeight := 0;
  End
  Else
  Begin
    FTileGlobalInfo.SourceLastScanLine := FTileGlobalInfo.SourceLastScanLine +
                                          FTileGlobalInfo.SourceBandHeight;
  End;
  img_end := Round( FTileGlobalInfo.SourceLastScanLine );
  If img_end > FTileGlobalInfo.TotalBitmapHeight - 1 Then
  Begin
    img_end := FTileGlobalInfo.TotalBitmapHeight - 1;
  End;
  img_numscans := img_end - img_start;
  If img_numscans < 1 Then
  Begin
    result := True;
    Exit;
  End;
  OldHeight := FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight;
  If FTileGlobalInfo.SourceIsTopDown Then
  Begin
    FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := -img_numscans;
  End
  Else
  Begin
    FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := img_numscans;
  End;
  bits := GetMemEx( Abs(FTileGlobalInfo.SourceBytesPerScanLine) * img_numscans);
  ScanOffsetInFile := FTileGlobalInfo.TotalBitmapHeight - (img_start + img_numscans);
  FTileGlobalInfo.TheStream.Seek( integer( FTileGlobalInfo.bmf.bfOffBits ) +
    ( ScanOffsetInFile * abs( FTileGlobalInfo.SourceBytesPerScanLine ) ), soFromBeginning );
  FTileGlobalInfo.TheStream.ReadBuffer( bits^, abs( FTileGlobalInfo.SourceBytesPerScanLine ) * img_numscans );

  If ( FAlphaChannel = 0 ) Or ( FBufferBitmap = Nil ) Then
  Begin
    // FBufferBitmap=nil means we are printing
    Try
      { draw the bitmap }
      SetStretchBltMode( FTileGlobalInfo.dc, COLORONCOLOR );
      StretchDIBits(
        FTileGlobalInfo.dc,
        CurrentTileRect.Left,
        CurrentTileRect.Top,
        Abs(CurrentTileRect.Right - CurrentTileRect.Left),
        abs(CurrentTileRect.Bottom - CurrentTileRect.Top),
        FTileGlobalInfo.SourceRect.Left, // left
        0, // top
        FTileGlobalInfo.SourceRect.Right - FTileGlobalInfo.SourceRect.Left, // width
        img_numscans, // height
        Bits,
        FTileGlobalInfo.lpBitmapInfo^,
        DIB_RGB_COLORS, SRCCOPY );

    Finally
      FreeMemEx( bits );
      FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := OldHeight;
    End;
  End
  Else If ( FAlphaChannel > 0 ) And ( FBufferBitmap <> Nil ) And
    ( FBufferBitmap.PixelFormat In [pf24bit, pf32bit] ) Then
  Begin
    { will do it transparent }
{$IFDEF FALSE}
    BmpBits := Nil;
    If FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biBitCount < 24 Then
    Begin
      { We will convert the bitmap to 24 bpp
        this will slow down the redrawing so better you use 24 or 32 bpp bitmaps}

      // write the "bitmap" to temporary stream
      ( FTempStream As TMemoryStream ).Clear;
      //write the bitmap file header
      Tmpbmf := FTileGlobalInfo.bmf;
      Tmpbmf.bfSize := SizeOf( TBITMAPFILEHEADER ) +
        FTileGlobalInfo.BitmapHeaderSize +
        Abs( FTileGlobalInfo.SourceBytesPerScanLine ) * img_numscans;
      FTempStream.Write( Tmpbmf, SizeOf( TBITMAPFILEHEADER ) );
      //write the bitmap info
      FTempStream.Write( FTileGlobalInfo.lpBitmapInfo^, FTileGlobalInfo.BitmapHeaderSize );
      //write the bitmap pixel information
      FTempStream.WriteBuffer( bits^, Abs( FTileGlobalInfo.SourceBytesPerScanLine ) * img_numscans );

      FTempStream.Position := 0;
      // now load into a temporary bitmap
      FTempBitmap.LoadFromStream( FTempStream );

      //w:= FTempBitmap.Width;
      h := FTempBitmap.Height;
      With Fbmi^.bmiheader Do
      Begin
        biWidth := FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biWidth;
        biHeight := FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight;
      End;

      //generate a 24 bpp bitmap
      TmpSourceBytesPerScanLine := ((((Fbmi^.bmiHeader.biWidth *
        Fbmi^.bmiHeader.biBitCount) + 31) And Not 31) shr 3);
      BmpBits := GetMemEx( h * TmpSourceBytesPerScanLine );

      { retrieve the bits for 24 bits bitmap }
      ScreenDC := GetDC( 0 );
      GetDIBits( ScreenDC, FTempBitmap.Handle, 0, h, BmpBits, Fbmi^, DIB_RGB_COLORS );
      ReleaseDC( 0, ScreenDC );

      TmpBitmapInfo := Fbmi;
      TmpBits := BmpBits;

    End
    Else
    Begin
      TmpBitmapInfo := FTileGlobalInfo.lpBitmapInfo;
      TmpBits := Bits;
{$ENDIF}
      //end;
      TmpBitmap := TBitmap.Create;
      Try
        { create a temporary bitmap }
        TmpBitmap.PixelFormat := pf24bit;
        TmpBitmap.Width := abs(CurrentTileRect.Right - CurrentTileRect.Left);
        TmpBitmap.Height := abs(CurrentTileRect.Bottom - CurrentTileRect.Top);
        { now stretch the original bitmap onto this one }
        SetStretchBltMode( TmpBitmap.Canvas.Handle, COLORONCOLOR );
        StretchDIBits(
          TmpBitmap.Canvas.Handle,
          0,
          0,
          abs(CurrentTileRect.Right - CurrentTileRect.Left),
          abs(CurrentTileRect.Bottom - CurrentTileRect.Top),
          FTileGlobalInfo.SourceRect.Left, // left
          0, // top
          FTileGlobalInfo.SourceRect.Right - FTileGlobalInfo.SourceRect.Left, // width
          img_numscans, // height
          Bits,
          FTileGlobalInfo.lpBitmapInfo^,
          DIB_RGB_COLORS, SRCCOPY );
        { now combine the two bitmaps: FBufferBitmap and TmpBitmap }
        BackgFormat := FBufferBitmap.PixelFormat;

        bgw := FBufferBitmap.Width;
        bgh := FBufferBitmap.Height;
        For y := 0 To TmpBitmap.Height - 1 Do
        Begin
          { it is assumed that FBufferBitmap.PixelFormat = pf24bit }
          bgy := y + CurrentTileRect.Top;
          If ( bgy < 0 ) Or ( bgy > bgh - 1 ) Then
            Continue;
          scanlin := FBufferBitmap.ScanLine[bgy];
          p1_24 := scanlin;
          p1_32 := scanlin;
          p2 := TmpBitmap.ScanLine[y];
          For x := 0 To TmpBitmap.Width - 1 Do
          Begin
            bgx := x + CurrentTileRect.Left;
            If ( bgx < 0 ) Or ( bgx > bgw - 1 ) Then
              Continue;
            Case BackgFormat Of
              pf24bit:
                With p1_24^[bgx] Do
                Begin
                  rgbtBlue := FBlendTable[rgbtBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                  rgbtGreen := FBlendTable[rgbtGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                  rgbtRed := FBlendTable[rgbtRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                End;
              pf32bit:
                With p1_32^[bgx] Do
                Begin
                  rgbBlue := FBlendTable[rgbBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                  rgbGreen := FBlendTable[rgbGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                  rgbRed := FBlendTable[rgbRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                End;
            End;
          End;
        End;
      Finally
        TmpBitmap.free;
        //if BmpBits <> nil then FreeMemEx(BmpBits);
        FreeMemEx( bits );
        FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := OldHeight;
      End;
  End;

  result := True;
End;

{ This code will fill a bitmap by resampling an image coming from a big bitmap on disk.
  Only the area on interest will be accessed on disk and in scanlines, that is to say,
  not all the image will be read.

  FileName.- Name of the uncompressed bitamp to read
  Stream.- If <> Nil, the bitmap info will be read from here instead of FileName.
  dc.- Target device context where the bitmap section will be resampled.
  DestLeft, DestTop.- Top left of the dc where the resampling will take place
  DestWidth, DestHeight.- dimensions of the target area where the bitmap section will be resampled
  DestTotalHeight.- Usually this is equal to DestHeight, but sometimes this can be greater because
    this is used for obtaining a scale factor of the bitmap on disk against a target rectangle on the
    device context.
  SourceLeft, SourceTop.- Topleft of physical source bitmap on disk.
  SourceWidth, SourceHeight.- Dimensions of the physical bitmap section that will be extracted from disk.
  BufferSize.- The size of a memory buffer used for reading scanlines from the physical bitmap on disk.
    This value will decide how many scanlines can be read from disk at the same time, with always a
    minimum value of 2 scanlines.
}
Function TEzBitmapEx.BitDIBFromFileInBands( Const FileName: String;
  Stream: TStream; dc: HDC;
  DestLeft, DestTop, DestWidth, DestHeight, DestTotalHeight,
  SourceLeft, SourceTop, SourceWidth, SourceHeight,
  BufferSize: integer ): Boolean;
Var
  TheFileSize: integer;
  TheImageSize: integer;
  TheBitmapInfo: PBITMAPINFO;
  dest_MaxScans, dsty_top, vdest_TilesDown: integer;
  dy: extended;
  dest_Residual: integer;
  vdest_TileHeight: Integer;
  CurrentTileRect: TRect;
  DestBottom: Integer;
  SourceScaleY: extended;
  C: Cardinal;
Begin
  result := FALSE;
  FTileGlobalInfo.SourceRect := Rect( SourceLeft,
                                      SourceTop,
                                      SourceLeft + SourceWidth,
                                      SourceTop + SourceHeight );
  If Stream = Nil Then
    FTileGlobalInfo.TheStream := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyWrite )
  Else
  Begin
    Stream.Seek( 0, 0 );
    FTileGlobalInfo.TheStream := Stream;
  End;
  TheFileSize := FTileGlobalInfo.TheStream.Size;
  FTileGlobalInfo.TheStream.ReadBuffer( FTileGlobalInfo.bmf, sizeof( TBITMAPFILEHEADER ) );
  FTileGlobalInfo.BitmapHeaderSize := FTileGlobalInfo.bmf.bfOffBits - sizeof( TBITMAPFILEHEADER );
  TheImageSize := TheFileSize - integer( FTileGlobalInfo.bmf.bfOffBits );
  If ( ( FTileGlobalInfo.bmf.bfType <> $4D42 ) Or
    ( integer( FTileGlobalInfo.bmf.bfOffBits ) < 1 ) Or
    ( TheFileSize < 1 ) Or ( FTileGlobalInfo.BitmapHeaderSize < 1 ) Or ( TheImageSize < 1 ) Or
    ( TheFileSize < ( sizeof( TBITMAPFILEHEADER ) + FTileGlobalInfo.BitmapHeaderSize + TheImageSize ) ) ) Then
  Begin
    If Stream = Nil Then
      FTileGlobalInfo.TheStream.Free;
    exit;
  End;
  FTileGlobalInfo.lpBitmapInfo := GetMemEx( FTileGlobalInfo.BitmapHeaderSize );
  Try
    FTileGlobalInfo.TheStream.ReadBuffer( FTileGlobalInfo.lpBitmapInfo^, FTileGlobalInfo.BitmapHeaderSize );
  Except
    FreeMemEx( FTileGlobalInfo.lpBitmapInfo );
    If Stream = Nil Then
      FTileGlobalInfo.TheStream.Free;
    exit;
  End;
  TheBitmapInfo := FTileGlobalInfo.lpBitmapInfo;
  If ( ( TheBitmapInfo^.bmiHeader.biCompression = BI_RLE4 ) Or
    ( TheBitmapInfo^.bmiHeader.biCompression = BI_RLE8 ) ) Then
  Begin
    FreeMemEx( FTileGlobalInfo.lpBitmapInfo );
    If Stream = Nil Then
      FTileGlobalInfo.TheStream.Free;
    Exit;
  End;
  FTileGlobalInfo.TotalBitmapWidth := TheBitmapInfo^.bmiHeader.biWidth;
  FTileGlobalInfo.TotalBitmapHeight := abs( TheBitmapInfo^.bmiHeader.biHeight );
  FTileGlobalInfo.SourceIsTopDown := ( TheBitmapInfo^.bmiHeader.biHeight < 0 );
  FTileGlobalInfo.SourceBytesPerScanLine := ((((TheBitmapInfo^.bmiHeader.biWidth *
    TheBitmapInfo^.bmiHeader.biBitCount) + 31) And Not 31) shr 3);

  FTileGlobalInfo.dc := dc;
  SourceScaleY := FTileGlobalInfo.TotalBitmapHeight / DestTotalHeight;
  FTileGlobalInfo.SourceLastScanLine := SourceTop;

  If BufferSize < abs( FTileGlobalInfo.SourceBytesPerScanLine ) Then
  Begin
    BufferSize := abs( FTileGlobalInfo.SourceBytesPerScanLine );
  End;

  dest_MaxScans := round( BufferSize / abs( FTileGlobalInfo.SourceBytesPerScanLine ) );
  dest_MaxScans := round( dest_MaxScans * ( DestTotalHeight / FTileGlobalInfo.TotalBitmapHeight ) );

  If dest_MaxScans < 2 Then
    dest_MaxScans := 2;

  If dest_MaxScans > FTileGlobalInfo.TotalBitmapHeight Then
    dest_MaxScans := FTileGlobalInfo.TotalBitmapHeight;

  { count the tiles down }
  dsty_top := 0;
  vdest_TilesDown := 0;
  While ( dsty_Top + dest_MaxScans ) <= DestTotalHeight Do
  Begin
    inc( vdest_TilesDown );
    inc( dsty_top, dest_MaxScans );
  End;
  //if (dest_Residual = 0) or (vdest_TilesDown = 1) then
  //  FTileGlobalInfo.SourceBandHeight:= FTileGlobalInfo.SourceHeight / vdest_TilesDown
  //else
  If vdest_TilesDown = 0 Then
  Begin
    FTileGlobalInfo.SourceBandHeight := 0;
    FTileGlobalInfo.SourceFirstTileHeight := FTileGlobalInfo.TotalBitmapHeight;
  End
  Else
  Begin
    dest_Residual := DestTotalHeight Mod dest_MaxScans;

    FTileGlobalInfo.SourceBandHeight :=
      ( FTileGlobalInfo.TotalBitmapHeight * ( 1 - ( dest_Residual / DestTotalHeight ) ) ) / vdest_TilesDown;

    If SourceTop > 0 Then
    Begin
      dy := 0;
      While dy < SourceTop Do
        dy := dy + FTileGlobalInfo.SourceBandHeight;
      FTileGlobalInfo.SourceFirstTileHeight := ( dy - SourceTop );
    End
    Else
    Begin
      FTileGlobalInfo.SourceFirstTileHeight := 0;
    End;
  End;

  { tile the scanlines }
  FWasSuspended := FALSE;

  CurrentTileRect.Top := DestTop;
  If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
  Begin
    vdest_TileHeight := Round( FTileGlobalInfo.SourceFirstTileHeight * ( 1 / SourceScaleY ) );
    If vdest_TileHeight = 0 Then
    Begin
      vdest_TileHeight := dest_MaxScans;
      FTileGlobalInfo.SourceFirstTileHeight := 0;
    End;
  End
  Else
    vdest_TileHeight := dest_MaxScans;
  CurrentTileRect.Bottom := DestTop + vdest_TileHeight;
  DestBottom:= DestTop + DestHeight;
  If CurrentTileRect.Bottom > DestBottom Then
  Begin
    CurrentTileRect.Bottom := DestBottom;
    If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
      FTileGlobalInfo.SourceFirstTileHeight :=
        FTileGlobalInfo.SourceFirstTileHeight * (Abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / vdest_TileHeight)
    Else
      FTileGlobalInfo.SourceBandHeight :=
        FTileGlobalInfo.SourceBandHeight * ( Abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / vdest_TileHeight );
  End;
  CurrentTileRect.Left := DestLeft;
  CurrentTileRect.Right := DestLeft + DestWidth;
  While CurrentTileRect.Top < DestBottom Do
  Begin
    If Not Windows.IsRectEmpty( CurrentTileRect ) Then
    Begin
      If Not TileCurrentBand( CurrentTileRect ) Then Break;
    End;
    CurrentTileRect.Top := CurrentTileRect.Bottom;
    CurrentTileRect.Bottom := CurrentTileRect.Top + dest_MaxScans;
    If CurrentTileRect.Bottom > DestBottom Then
    Begin
      CurrentTileRect.Bottom := DestBottom;
      FTileGlobalInfo.SourceBandHeight :=
        ( Abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / dest_MaxScans ) * FTileGlobalInfo.SourceBandHeight;
    End;

    If PainterObject <> Nil Then
    Begin
      If PainterObject.Thread = Nil Then
      Begin
        If PainterObject.IsTimer then
        begin
          C := PainterObject.TickStart + PainterObject.SourceGis.TimerFrequency;
          if GetTickCount > C then
          Begin
            PainterObject.SourceGis.OnGisTimer( PainterObject.SourceGis, FWasSuspended );
            If FWasSuspended Then
              Exit;
            PainterObject.TickStart := GetTickCount;
          End;
        end;
      End
      Else
      If PainterObject.Thread.Terminated Then
      Begin
        FWasSuspended:= True;
        Exit;
      End;
    End;
  End;

  If Stream = Nil Then
    FTileGlobalInfo.TheStream.Free;
  FreeMemEx( FTileGlobalInfo.lpBitmapInfo );
End;

Function GetDIBDimensions( Const FileName: String; Stream: TStream;
  Var BitmapWidth, BitmapHeight: integer; Var IsCompressed: Boolean ): Boolean;
Var
  bmf: TBITMAPFILEHEADER;
  AFileSize: integer;
  AHeaderSize: integer;
  AImageSize: integer;
  ABitmapInfo: PBITMAPINFO;
  lpBitmapInfo: pointer;
  AStream: TStream;
Begin
  Result := False;
  IsCompressed := False;
  BitmapWidth := 0;
  BitmapHeight := 0;
  If Stream = Nil Then
    AStream := TFileStream.Create( FileName, fmOpenRead Or fmShareDenyWrite )
  Else
  Begin
    Stream.Seek( 0, 0 );
    AStream := Stream;
  End;
  Try
    AFileSize := AStream.Size;
    AStream.ReadBuffer( bmf, sizeof( TBITMAPFILEHEADER ) );
  Except
    If Stream = Nil Then
      AStream.Free;
    exit;
  End;
  AHeaderSize := bmf.bfOffBits - sizeof( TBITMAPFILEHEADER );
  AImageSize := AFileSize - integer( bmf.bfOffBits );
  If ( ( bmf.bfType <> $4D42 ) Or ( integer( bmf.bfOffBits ) < 1 ) Or
    ( AFileSize < 1 ) Or ( AHeaderSize < 1 ) Or ( AImageSize < 1 ) Or
    ( AFileSize < ( sizeof( TBITMAPFILEHEADER ) + AHeaderSize + AImageSize ) ) ) Then
  Begin
    If Stream = Nil Then
      AStream.Free;
    Exit;
  End;
  lpBitmapInfo := GetMemEx( AHeaderSize );
  Try
    AStream.ReadBuffer( lpBitmapInfo^, AHeaderSize );
  Except
    FreeMemEx( lpBitmapInfo );
    If Stream = Nil Then
      AStream.Free;
    Exit;
  End;
  Try
    ABitmapInfo := lpBitmapInfo;
    BitmapWidth := ABitmapInfo^.bmiHeader.biWidth;
    BitmapHeight := Abs( ABitmapInfo^.bmiHeader.biHeight );
    If ( ABitmapInfo^.bmiHeader.biSizeImage <> 0 ) Then
    Begin
      AImageSize := ABitmapInfo^.bmiHeader.biSizeImage;
    End
    Else
    Begin
      AImageSize := (((((ABitmapInfo^.bmiHeader.biWidth *
        ABitmapInfo^.bmiHeader.biBitCount) + 31) And Not 31) shr 3) *
        ABS(ABitmapInfo^.bmiHeader.biHeight));
    End;
    IsCompressed := (ABitmapInfo^.bmiHeader.biCompression = BI_RLE4 ) Or
      (ABitmapInfo^.bmiHeader.biCompression = BI_RLE8);
  Except
    FreeMemEx( lpBitmapInfo );
    If Stream = Nil Then
      AStream.Free;
    BitmapWidth := 0;
    BitmapHeight := 0;
    Exit;
  End;
  FreeMemEx( lpBitmapInfo );
  If Stream = Nil Then
    AStream.Free;
  If ( BitmapWidth < 1 ) Or ( BitmapHeight < 1 ) Or ( AImageSize < 32 ) Then
  Begin
    BitmapWidth := 0;
    BitmapHeight := 0;
    Exit;
  End;
  result := True;
End;

Function GetBILDimensions( Const FileName: String;
  Var BitmapWidth, BitmapHeight: integer ): Boolean;
begin
  Result:= False;
  If Not FileExists(FileName) then Exit;
  with TEzBILReader.Create(FileName) do
    try
      If Not ReadHdr then Exit;
      BitmapWidth:= NCOLS;
      BitmapHeight:= NROWS;
      Result:= True;
    finally
      Free;
    end;
end;

{ BIL format support }

Constructor TEzBILReader.Create(const FileName: string);
begin
  inherited Create;
  FFileName:= FileName;
end;

{ Reads .HDR file }
function TEzBILReader.ReadHdr: Boolean ;
var
  val1: String;
  val2: String;
  buf: string;
  TempFilename: string;
  Lines: TStrings;
  temp, loop: integer;
  SaveSeparator: Char;
begin

  Result := False ;

  TempFilename:= ChangeFileExt(FFileName, '.hdr');

  if not FileExists(TempFileName) then Exit ;

  // default values
  BigEndian := False;
  self.NBANDS:= 1;
  self.NBITS:= 8;
  self.SKIPBYTES:= 0;
  self.BANDROWBYTES:= 0;
  self.TOTALROWBYTES:= 0;

  SaveSeparator := DecimalSeparator;
  DecimalSeparator:= '.';
  Lines:= TStringList.create;
  try
     Lines.LoadFromFile(TempFilename);
     for loop:= 0 to Lines.Count-1 do
     begin

       buf:= StringReplace(Lines[loop], #9, #32, [rfReplaceAll]);

       temp:= AnsiPos('#', buf);
       if temp > 0 then
        buf:= Trim(copy(buf,1,temp-1));
       If Length(buf) = 0 then Continue;

       temp:= AnsiPos(#32, buf);
       if temp = 0 then continue;
       val1:= AnsiUpperCase(Trim(Copy(buf,1,temp-1)));
       val2:= Trim(Copy(buf,temp,length(buf)));
       If AnsiCompareText( 'BYTEORDER', val1)=0 then
       begin
         // M = Motorola byte order (most significant byte first)
         if val2 = 'M' then BigEndian := True else BigEndian := False ;
       end else If AnsiCompareText( 'LAYOUT', val1)=0 then
       begin
         // BIL = band interleaved by line
         if val2 <> 'BIL' then exit;  // can be BIP
       end else If AnsiCompareText( 'SKIPBYTES', val1)=0 then
       begin
        // number of rows in the image
         SKIPBYTES:= StrToInt(val2);
       end else If AnsiCompareText( 'NROWS', val1)=0 then
       begin
        // number of rows in the image
         NROWS:= StrToInt(val2);
       end else If AnsiCompareText( 'NCOLS', val1)=0 then
       begin
         //number of columns in the image
         NCOLS:= StrToInt(val2);
       end else If AnsiCompareText( 'NBANDS', val1)=0 then
       begin
         // number of spectral bands in the image
         NBANDS:= StrToInt(val2);
       end else If AnsiCompareText( 'NBITS', val1)=0 then
       begin
         // number of bits per pixel
         NBITS:= StrToInt(val2);
       end else If AnsiCompareText( 'BANDROWBYTES', val1)=0 then
       begin
         // number of bytes per band per row
         BANDROWBYTES:= StrToInt(val2);
       end else If AnsiCompareText( 'TOTALROWBYTES', val1)=0 then
       begin
         // total number of bytes of data per row
         TOTALROWBYTES:= StrToInt(val2);
       end else If AnsiCompareText( 'BANDGAPBYTES', val1)=0 then
       begin
         // the number of bytes between bands in a BSQ format image
         BANDGAPBYTES:= StrToInt(val2);
       end else If AnsiCompareText( 'NODATA', val1)=0 then
       begin
         // value used for masking purposes
         NODATA:= StrToInt(val2);
       end else If AnsiCompareText( 'ULXMAP', val1)=0 then
       begin
         // longitude of the center of the upper-left pixel (decimal degrees)
         ULXMAP:= StrToFloat(val2);
       end else If AnsiCompareText( 'ULYMAP', val1)=0 then
       begin
         // latitude  of the center of the upper-left pixel (decimal degrees)
         ULYMAP:= StrToFloat(val2);
       end else If AnsiCompareText( 'XDIM', val1)=0 then
       begin
         // x dimension of a pixel in geographic units (decimal degrees)
         XDIM:= StrToFloat(val2);
       end else If AnsiCompareText( 'YDIM', val1)=0 then
       begin
         // Y dimension of a pixel in geographic units (decimal degrees)
         YDIM:= StrToFloat(val2);
       end;

     end;

     If self.BANDROWBYTES = 0 then
       self.BANDROWBYTES:= Round((Self.NCOLS * Self.NBITS) div 8);

     If self.TOTALROWBYTES = 0 then
       self.TOTALROWBYTES:= self.NBANDS * self.BANDROWBYTES;

    Result := True;

  finally
    Lines.free;
    DecimalSeparator:= SaveSeparator;
  end;

end;

Procedure TEzBILReader.SetAlphaChannel( Value: Byte );
Var
  x: Integer;
Begin
  For x := -255 To 255 Do
    FBlendTable[x] := ( Value * x ) Shr 8;
  FAlphaChannel := Value;
End;

Function TEzBILReader.TileCurrentBand( const CurrentTileRect: TRect ): Boolean;
Var
  img_start: integer;
  img_end: integer;
  img_numscans: integer;
  ScanOffsetInFile: integer;
  OldHeight: integer;
  srcBits, destBits: PByte;
  TmpBitmap: TBitmap;
  x, y, bgx, bgy, bgw, bgh: Integer;
  p1_32: pRGBQuadArray;
  p1_24, p2: pRGBTripleArray;
  scanlin: Pointer;
  BackgFormat: TPixelFormat;
  DestBytesPerScanLine: integer;

  procedure ConvertToColor24;
  var
    i, j, SrcOffset, DstOffset, width2, t: Integer ;
  begin
    for i := 0 to img_numscans - 1 do
    begin
      SrcOffset:= i*self.TOTALROWBYTES;
      DstOffset:= i*DestBytesPerScanLine;
      width2 := 2*self.BANDROWBYTES;
      for j := 0 to self.BANDROWBYTES - 1 do
      begin
        // red byte
        t := PByte(Integer(SrcBits) + SrcOffset + j + 0 )^;
        PByte( Integer(DestBits) + DstOffset + 3*j + 2 )^ := ezlib.IMin(t,255);

        // green byte
         t := PByte(Integer(SrcBits) + SrcOffset + j + self.BANDROWBYTES)^;
         PByte( Integer(DestBits) + DstOffset + 3*j + 1 )^ := ezlib.IMin(t,255);

        // blue byte
         t := PByte(Integer(SrcBits) + SrcOffset + j + width2)^;
         PByte( Integer(DestBits) + DstOffset + 3*j + 0 )^ := ezlib.IMin(t,255);
      end;
    end;
  end;

  procedure BILToBitmap;
  var
    i, srcOffset, destOffset: integer;
  begin
    for i := 0 to img_numscans - 1 do
    begin
      srcOffset:= i*self.TOTALROWBYTES;
      destOffset:= i*DestBytesPerScanLine;
      CopyMemory(PByte(Integer(destBits) + destOffset), PByte(Integer(srcBits) + srcOffset), self.TOTALROWBYTES);
    end;
  end;

Begin

  img_start := Round( FTileGlobalInfo.SourceLastScanLine );
  If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
  Begin
    FTileGlobalInfo.SourceLastScanLine := FTileGlobalInfo.SourceLastScanLine +
                                          FTileGlobalInfo.SourceFirstTileHeight;
    FTileGlobalInfo.SourceFirstTileHeight := 0;
  End
  Else
  Begin
    FTileGlobalInfo.SourceLastScanLine := FTileGlobalInfo.SourceLastScanLine +
                                          FTileGlobalInfo.SourceBandHeight;
  End;
  img_end := Round( FTileGlobalInfo.SourceLastScanLine );
  If img_end > FTileGlobalInfo.TotalBitmapHeight - 1 Then
  Begin
    img_end := FTileGlobalInfo.TotalBitmapHeight - 1;
  End;
  img_numscans := img_end - img_start;
  If img_numscans < 1 Then
  Begin
    Result := True;
    Exit;
  End;
  OldHeight := FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight;
  If FTileGlobalInfo.SourceIsTopDown Then
  Begin
    FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := -img_numscans;
  End
  Else
  Begin
    FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := img_numscans;
  End;

  DestBytesPerScanLine:= ((((self.NCOLS * FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biBitCount) + 31) And Not 31) shr 3);
  destBits:= GetMemEx( DestBytesPerScanLine * img_numscans );

  srcBits:= GetMemEx(self.TOTALROWBYTES * img_numscans);

  ScanOffsetInFile := self.SKIPBYTES + img_start * self.TOTALROWBYTES;
  FTileGlobalInfo.TheStream.Seek(ScanOffsetInFile, soFromBeginning);
  FTileGlobalInfo.TheStream.ReadBuffer(srcbits^, self.TOTALROWBYTES * img_numscans);

  if Self.NBANDS >= 3 then
    { will convert to 24 bpp }
    ConvertToColor24
  else
    BILToBitmap;

  If ( FAlphaChannel = 0 ) Or ( FBufferBitmap = Nil ) Then
  Begin
    // FBufferBitmap=nil means we are printing
    Try
      { draw the bitmap }
      SetStretchBltMode( FTileGlobalInfo.dc, COLORONCOLOR );
      StretchDIBits(
        FTileGlobalInfo.dc,
        CurrentTileRect.Left,
        CurrentTileRect.Top,
        Abs(CurrentTileRect.Right - CurrentTileRect.Left),
        abs(CurrentTileRect.Bottom - CurrentTileRect.Top),
        FTileGlobalInfo.SourceRect.Left, // left
        0, // top
        FTileGlobalInfo.SourceRect.Right - FTileGlobalInfo.SourceRect.Left, // width
        img_numscans, // height
        destBits,
        FTileGlobalInfo.lpBitmapInfo^,
        DIB_RGB_COLORS,
        SRCCOPY );
    Finally
      FreeMemEx( srcbits );
      FreeMemEx( destbits );
      FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := OldHeight;
    End;
  End
  Else If ( FAlphaChannel > 0 ) And ( FBufferBitmap <> Nil ) And
    ( FBufferBitmap.PixelFormat In [pf24bit, pf32bit] ) Then
  Begin
    { will do it transparent }
      //end;
      TmpBitmap := TBitmap.Create;
      Try
        { create a temporary bitmap }
        TmpBitmap.PixelFormat := pf24bit;
        TmpBitmap.Width := abs(CurrentTileRect.Right - CurrentTileRect.Left);
        TmpBitmap.Height := abs(CurrentTileRect.Bottom - CurrentTileRect.Top);
        { now stretch the original bitmap onto this one }
        SetStretchBltMode( TmpBitmap.Canvas.Handle, COLORONCOLOR );
        StretchDIBits(
          TmpBitmap.Canvas.Handle,
          0,
          0,
          abs(CurrentTileRect.Right - CurrentTileRect.Left),
          abs(CurrentTileRect.Bottom - CurrentTileRect.Top),
          FTileGlobalInfo.SourceRect.Left, // left
          0, // top
          FTileGlobalInfo.SourceRect.Right - FTileGlobalInfo.SourceRect.Left, // width
          img_numscans, // height
          destBits,
          FTileGlobalInfo.lpBitmapInfo^,
          DIB_RGB_COLORS,
          SRCCOPY );
        { now combine the two bitmaps: FBufferBitmap and TmpBitmap }
        BackgFormat := FBufferBitmap.PixelFormat;

        bgw := FBufferBitmap.Width;
        bgh := FBufferBitmap.Height;
        For y := 0 To TmpBitmap.Height - 1 Do
        Begin
          { it is assumed that FBufferBitmap.PixelFormat = pf24bit }
          bgy := y + CurrentTileRect.Top;
          If ( bgy < 0 ) Or ( bgy > bgh - 1 ) Then
            Continue;

          scanlin := FBufferBitmap.ScanLine[bgy];
          p1_24 := scanlin;
          p1_32 := scanlin;
          p2 := TmpBitmap.ScanLine[y];
          For x := 0 To TmpBitmap.Width - 1 Do
          Begin
            bgx := x + CurrentTileRect.Left;
            If ( bgx < 0 ) Or ( bgx > bgw - 1 ) Then
              Continue;
            Case BackgFormat Of
              pf24bit:
                With p1_24^[bgx] Do
                Begin
                  rgbtBlue := FBlendTable[rgbtBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                  rgbtGreen := FBlendTable[rgbtGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                  rgbtRed := FBlendTable[rgbtRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                End;
              pf32bit:
                With p1_32^[bgx] Do
                Begin
                  rgbBlue := FBlendTable[rgbBlue - p2^[x].rgbtBlue] + p2^[x].rgbtBlue;
                  rgbGreen := FBlendTable[rgbGreen - p2^[x].rgbtGreen] + p2^[x].rgbtGreen;
                  rgbRed := FBlendTable[rgbRed - p2^[x].rgbtRed] + p2^[x].rgbtRed;
                End;
            End;
          End;
        End;
      Finally
        TmpBitmap.Free;
        //if BmpBits <> nil then FreeMemEx(BmpBits);
        FreeMemEx( srcbits );
        FreeMemEx( destbits );
        FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight := OldHeight;
      End;
  End;

  Result := True;
End;

Function TEzBILReader.BILFromFileInBands( Stream: TStream; dc: HDC;
  DestLeft, DestTop, DestWidth, DestHeight, DestTotalHeight,
  SourceLeft, SourceTop, SourceWidth, SourceHeight,
  BufferSize: integer ): Boolean;
var
//  TheFileSize: integer;
  TheImageSize: integer;
  TheBitmapInfo: PBITMAPINFO;
  dest_MaxScans, dsty_top, vdest_TilesDown: integer;
  dy: extended;
  t, loop, dest_Residual: integer;
  vdest_TileHeight: Integer;
  CurrentTileRect: TRect;
  DestBottom: Integer;
  SourceScaleY: extended;
  pcolors : PRGBQuad;
  NumEntries: integer;
  StreamUsed: Boolean;
  C: Cardinal;
Begin
  Result := FALSE;

  If Not ReadHDR then Exit;

  FTileGlobalInfo.SourceRect := Rect( SourceLeft,
                                      SourceTop,
                                      SourceLeft + SourceWidth,
                                      SourceTop + SourceHeight );
  StreamUsed:= Stream <> Nil;
  If StreamUsed then
    FTileGlobalInfo.TheStream := Stream
  else
    FTileGlobalInfo.TheStream := TFileStream.Create( FFileName, fmOpenRead Or fmShareDenyWrite );

  case self.NBITS of
    1: NumEntries:= 2;
    4: NumEntries:= 16;
    8: NumEntries:= 256;
  else
    NumEntries:= 0;
  end;

  If Self.NBANDS >= 3 then
    NumEntries:= 0;

  FTileGlobalInfo.lpBitmapInfo := GetMemEx( sizeof(TBitmapInfoHeader) + NumEntries * sizeof(TRGBQuad) );
  try
    with FTileGlobalInfo.lpBitmapInfo^ do
    begin
      bmiHeader.biSize:= sizeof(TBitmapInfoHeader);
      bmiHeader.biWidth := self.NCOLS ;
      bmiHeader.biHeight:= -self.NROWS ;
      bmiHeader.biPlanes:= 1 ;
      If self.NBANDS >= 3 then
        bmiHeader.biBitCount:= 24
      else
        bmiHeader.biBitCount:= self.NBITS ;
      for loop:= 0 to NumEntries-1 do
      begin
        pcolors := PRGBQuad( Integer(@bmiColors[0] ) + loop*sizeof(TRGBQuad) ) ;
        t:= loop;
        pcolors^.rgbRed   := t;
        pcolors^.rgbGreen := t;
        pcolors^.rgbBlue  := t;
      end;
      bmiHeader.biSizeImage:= 0 ;
      bmiHeader.biCompression:= BI_RGB ;
      bmiHeader.biXPelsPerMeter:= 0 ;
      bmiHeader.biYPelsPerMeter:= 0 ;
      bmiHeader.biClrUsed:= 0;
      bmiHeader.biClrImportant:= 0;
    end;

    FTileGlobalInfo.TotalBitmapWidth := self.NCOLS;
    FTileGlobalInfo.TotalBitmapHeight := self.NROWS;
    FTileGlobalInfo.SourceIsTopDown := ( FTileGlobalInfo.lpBitmapInfo^.bmiHeader.biHeight < 0 );

    FTileGlobalInfo.dc := dc;
    SourceScaleY := FTileGlobalInfo.TotalBitmapHeight / DestTotalHeight;
    FTileGlobalInfo.SourceLastScanLine := SourceTop;

    FTileGlobalInfo.SourceBytesPerScanLine := self.TOTALROWBYTES;

    If BufferSize < abs( FTileGlobalInfo.SourceBytesPerScanLine ) Then
    Begin
      BufferSize := abs( FTileGlobalInfo.SourceBytesPerScanLine );
    End;

    dest_MaxScans := round( BufferSize / FTileGlobalInfo.SourceBytesPerScanLine );
    dest_MaxScans := round( dest_MaxScans * ( DestTotalHeight / FTileGlobalInfo.TotalBitmapHeight ) );

    If dest_MaxScans < 2 Then
      dest_MaxScans := 2;

    If dest_MaxScans > FTileGlobalInfo.TotalBitmapHeight Then
      dest_MaxScans := FTileGlobalInfo.TotalBitmapHeight;

    { count the tiles down }
    dsty_top := 0;
    vdest_TilesDown := 0;
    While ( dsty_Top + dest_MaxScans ) <= DestTotalHeight Do
    Begin
      inc( vdest_TilesDown );
      inc( dsty_top, dest_MaxScans );
    End;
    If vdest_TilesDown = 0 Then
    Begin
      FTileGlobalInfo.SourceBandHeight := 0;
      FTileGlobalInfo.SourceFirstTileHeight := FTileGlobalInfo.TotalBitmapHeight;
    End
    Else
    Begin
      dest_Residual := DestTotalHeight Mod dest_MaxScans;

      FTileGlobalInfo.SourceBandHeight :=
        ( FTileGlobalInfo.TotalBitmapHeight * ( 1 - ( dest_Residual / DestTotalHeight ) ) ) / vdest_TilesDown;

      If SourceTop > 0 Then
      Begin
        dy := 0;
        While dy < SourceTop Do
          dy := dy + FTileGlobalInfo.SourceBandHeight;
        FTileGlobalInfo.SourceFirstTileHeight := ( dy - SourceTop );
      End
      Else
      Begin
        FTileGlobalInfo.SourceFirstTileHeight := 0;
      End;
    End;

    { tile the scanlines }
    FWasSuspended := FALSE;

    CurrentTileRect.Top := DestTop;
    If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
    Begin
      vdest_TileHeight := Round( FTileGlobalInfo.SourceFirstTileHeight * ( 1 / SourceScaleY ) );
      If vdest_TileHeight = 0 Then
      Begin
        vdest_TileHeight := dest_MaxScans;
        FTileGlobalInfo.SourceFirstTileHeight := 0;
      End;
    End
    Else
      vdest_TileHeight := dest_MaxScans;
    CurrentTileRect.Bottom := DestTop + vdest_TileHeight;
    DestBottom:= DestTop + DestHeight;
    If CurrentTileRect.Bottom > DestBottom Then
    Begin
      CurrentTileRect.Bottom := DestBottom;
      If FTileGlobalInfo.SourceFirstTileHeight <> 0 Then
        FTileGlobalInfo.SourceFirstTileHeight :=
          FTileGlobalInfo.SourceFirstTileHeight * (Abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / vdest_TileHeight)
      Else
        FTileGlobalInfo.SourceBandHeight :=
          FTileGlobalInfo.SourceBandHeight * ( Abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / vdest_TileHeight );
    End;
    CurrentTileRect.Left := DestLeft;
    CurrentTileRect.Right := DestLeft + DestWidth;
    While CurrentTileRect.Top < DestBottom Do
    Begin
      If Not Windows.IsRectEmpty( CurrentTileRect ) Then
      Begin
        If Not TileCurrentBand( CurrentTileRect ) Then
          Break;
      End;
      CurrentTileRect.Top := CurrentTileRect.Bottom;
      CurrentTileRect.Bottom := CurrentTileRect.Top + dest_MaxScans;
      If CurrentTileRect.Bottom > DestBottom Then
      Begin
        CurrentTileRect.Bottom := DestBottom;
        FTileGlobalInfo.SourceBandHeight :=
          ( Abs(CurrentTileRect.Bottom - CurrentTileRect.Top) / dest_MaxScans ) * FTileGlobalInfo.SourceBandHeight;
      End;

      If PainterObject <> Nil Then
      Begin
        If PainterObject.Thread = Nil Then
        Begin
          If PainterObject.IsTimer then
          begin
            C := PainterObject.TickStart + PainterObject.SourceGis.TimerFrequency;
            if GetTickCount > C Then
            Begin
              PainterObject.SourceGis.OnGisTimer( PainterObject.SourceGis, FWasSuspended );
              If FWasSuspended Then
                Exit;
              PainterObject.TickStart := GetTickCount;
            End;
          end;
        End
        Else
        If PainterObject.Thread.Terminated Then
        Begin
          FWasSuspended:= True;
          Exit;
        End;
      End;
    End;
  finally
    If Not StreamUsed then
      FTileGlobalInfo.TheStream.Free;
    FreeMemEx( FTileGlobalInfo.lpBitmapInfo );
  end;
End;


End.
