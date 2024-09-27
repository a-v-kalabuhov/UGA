Attribute VB_Name = "Module1"
Type POINTAPI
    X As Long
    Y As Long
End Type

Type RECTAPI
    TopLeft As POINTAPI
    BottomRight As POINTAPI
End Type

Type Rect
  Left As Long
  Top As Long
  Right As Long
  Bottom As Long
End Type

Public Const LF_FACESIZE = 31

Type LOGFONT
    lfHeight            As Long
    lfWidth             As Long
    lfEscapement        As Long
    lfOrientation       As Long
    lfWeight            As Long
    lfItalic            As Byte
    lfUnderline         As Byte
    lfStrikeOut         As Byte
    lfCharSet           As Byte
    lfOutPrecision      As Byte
    lfClipPrecision     As Byte
    lfQuality           As Byte
    lfPitchAndFamily    As Byte
    lfFaceName          As String * LF_FACESIZE
End Type

Public Type CADParam ' User type
  hWnd As Long
  hdc As Long
  offset As POINTAPI
  ScaleFactor As Single
  DrawMode As Long
  CircleDrawMode As Long
  GetArcsCurves As Boolean
  IsInsideInsert As Long
  Thickness As Boolean
End Type

Type OSVERSIONINFO
  dwOSVersionInfoSize As Long
  dwMajorVersion As Long
  dwMinorVersion As Long
  dwBuildNumber As Long
  dwPlatformId As Long
  szCSDVersion As String * 128 'Maintenance string for PSS usage
End Type

Const VER_PLATFORM_WIN32s = 0
Const VER_PLATFORM_WIN32_WINDOWS = 1
Const VER_PLATFORM_WIN32_NT = 2

Type BITMAP
   bmType As Long
   bmWidth As Long
   bmHeight As Long
   bmWidthBytes As Long
   bmPlanes As Integer
   bmBitsPixel As Integer
   bmBits As Long
End Type

Type BITMAPINFOHEADER
   biSize As Long
   biWidth As Long
   biHeight As Long
   biPlanes As Integer
   biBitCount As Integer
   biCompression As Long
   biSizeImage As Long
   biXPelsPerMeter As Long
   biYPelsPerMeter As Long
   biClrUsed As Long
   biClrImportant As Long
End Type

Type RGBQUAD
    rgbBlue As Byte
    rgbGreen  As Byte
    rgbRed As Byte
    rgbReserved As Byte
  End Type

Type BITMAPINFO
  bmiHeader As BITMAPINFOHEADER
  bmiColors(255) As RGBQUAD ' Enough for 256 colors.
End Type

Const CBM_INIT = 4
   
  Type DIBSECTION
    dsBm As BITMAP
    dsBmih As BITMAPINFOHEADER
    dsBitfields(3) As Long
    dshSection As Long
    dsOffset As Long
  End Type
            
Global Const DIB_RGB_COLORS = 0
Global Const DIB_PAL_COLORS = 1

Global Const SRCCOPY = &HCC0020

' StretchBlt() Modes
Global Const BLACKONWHITE = 1
Global Const WHITEONBLACK = 2
Global Const COLORONCOLOR = 3
Global Const HALFTONE = 4
Global Const MAXSTRETCHBLTMODE = 4

' PolyFill() Modes
Const ALTERNATE = 1
Const WINDING = 2

' CombineRgn() Styles
Const RGN_AND = 1
Const RGN_OR = 2
Const RGN_XOR = 3
Const RGN_DIFF = 4
Const RGN_COPY = 5


Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, lpPoint As POINTAPI) As Long
Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Boolean
Declare Function Polygon Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI, ByVal nCount As Long) As Long
Declare Function PolyBezier Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI, ByVal nCount As Long) As Long
Declare Function Arc Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long, ByVal X4 As Long, ByVal Y4 As Long) As Long
Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
Declare Function CreateFontIndirect Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long
Declare Function CreateRectRgnIndirect Lib "gdi32" (lprc As RECTAPI) As Long
Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal iCapabilitiy As Long) As Long
Declare Function SetTextAlign Lib "gdi32" (ByVal hdc As Long, ByVal wFlags As Long) As Long
Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Declare Function RestoreDC Lib "gdi32" (ByVal hdc As Long, ByVal nSavedDC As Long) As Boolean
Declare Function Rectangle Lib "gdi32" (ByVal hdc As Long, ByVal nLeftRect As Integer, ByVal nTopRect As Integer, ByVal nRightRect As Integer, ByVal nBottomRect As Integer) As Boolean
Declare Function CreatePolygonRgn Lib "gdi32" (lppt As POINTAPI, ByVal cPoints As Integer, ByVal fnPolyFillMode As Integer) As Long
Declare Function CreateRectRgn Lib "gdi32" (ByVal nLeftRect As Integer, ByVal nTopRect As Integer, ByVal nRightRect As Integer, ByVal nBottomRect As Integer) As Long
Declare Function CombineRgn Lib "gdi32" (ByVal hrgnDest As Long, ByVal hrgnSrc1 As Long, ByVal hrgnSrc2 As Long, ByVal fnCombineMode As Integer) As Integer
Declare Function SaveDC Lib "gdi32" (ByVal hdc As Long) As Boolean
Declare Function LPtoDP Lib "gdi32" (ByVal hdc As Long, lpPoints As POINTAPI, ByVal nCount As Integer) As Boolean
Declare Function OffsetRgn Lib "gdi32" (ByVal hrgn As Long, ByVal nXOffset As Integer, ByVal nYOffset As Integer) As Integer
Declare Function SelectClipRgn Lib "gdi32" (ByVal hdc As Long, ByVal hrgn As Long) As Integer
Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
Declare Function TextOutW Lib "gdi32.dll" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal lpString As Long, ByVal nCount As Long) As Long
Declare Function CreateDIBSection Lib "gdi32" (ByVal hdc As Long, bi As BITMAPINFO, ByVal iUsage As Long, Bits As Any, ByVal hSection As Long, ByVal dwOffset As Long) As Long
Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function SetStretchBltMode Lib "gdi32" (ByVal hdc As Long, ByVal iStretchMode As Long) As Long
Declare Function GetStretchBltMode Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function StretchBlt Lib "gdi32" (ByVal hdcDest As Long, ByVal nXOriginDest As Long, ByVal nYOriginDest As Long, _
  ByVal nWidthDest As Long, ByVal nHeightDest As Long, ByVal hdcSrc As Long, ByVal nXOriginSrc As Long, _
  ByVal nYOriginSrc As Long, ByVal nWidthSrc As Long, ByVal nHeightSrc As Long, ByVal dwRop As Long) As Long
Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function CreateDIBitmap Lib "gdi32" (ByVal hdc As Long, lpbmih As BITMAPINFOHEADER, ByVal fdwInit As Long, lpbInit As Any, ByRef lpbmi As BITMAPINFO, ByVal fuUsage As Long) As Long
Private Declare Function FillRgn Lib "gdi32" (ByVal hdc As Long, ByVal hrgn As Long, ByVal hbr As Long) As Boolean


Declare Function CADConvert Lib "cad.dll" (Massiv As Variant, ByRef EData As CADData) As Long
Declare Function CADGetSingleFromBytes Lib "cad.dll" (ByVal B1 As Byte, ByVal B2 As Byte, ByVal B3 As Byte, ByVal B4 As Byte) As Single
Declare Function CADGetSplinePointsCount Lib "cad.dll" (ByVal Index As Long, ByRef EData As CADData) As Long
Declare Function CADGetSplineParams Lib "cad.dll" (ByVal Index As Long, ByRef EData As CADData, Param As Variant) As Long
Declare Function CADLayoutCurrent Lib "cad.dll" (ByVal Handle As Long, ByRef Index As Long, ByVal DoChange As Boolean) As Long
Declare Function CADGetBox Lib "cad.dll" (ByVal Handle As Long, ByRef Left As Double, ByRef Right As Double, ByRef Top As Double, ByRef Bottom As Double) As Long
Declare Function CADGetViewPortPointsCount Lib "cad.dll" (ByVal Index As Long, ByRef EData As CADData) As Long
Declare Function CADGetViewPortParams Lib "cad.dll" (ByVal Index As Long, ByRef EData As CADData, Param As Variant) As Long
Declare Function CADLayerCount Lib "cad.dll" (ByVal Handle As Long) As Long
Declare Function CADLayer Lib "cad.dll" (ByVal Handle As Long, ByVal Index As Long, ByRef EData As CADData) As Long
Declare Function CADLayoutCount Lib "cad.dll" (ByVal Handle As Long) As Long
Declare Function CADLayoutName Lib "cad.dll" (ByVal Handle As Long, ByVal Index As Long, ByVal Name As String, ByVal nSize As Long) As Long
Declare Function CADCreate Lib "cad.dll" (ByVal Window As Long, ByVal FileName As String) As Long
Declare Function CADEnum Lib "cad.dll" (ByVal Handle As Long, ByVal EnumAll As Long, ByVal Proc As Long, ByVal Param As Long) As Long
Declare Function CADClose Lib "cad.dll" (ByVal Handle As Long) As Long
Declare Function CADUnits Lib "cad.dll" (ByVal Handle As Long, ByRef Untis As Long) As Long
Declare Function CADProhibitCurvesAsPoly Lib "cad.dll" (ByVal Handle As Long, ByVal Untis As Long) As Long
Declare Function SaveCADtoFileWithXMLParams Lib "cad.dll" (ByVal Handle As Long, ByVal AParam As String, ByVal AProc As Integer) As Long
Declare Function CADSetMeshQuality Lib "cad.dll" (ByVal Handle As Long, ByRef NewValue As Double, ByRef OldValue As Double) As Long
Declare Function GetLastErrorCAD Lib "cad.dll" (ByVal Msg As String, ByVal Size As Long) As Long
Public Declare Function CADSetSHXOptions Lib "cad.dll" (ByVal ASearchPaths As String, ByVal ADefaultPath As String, ByVal ADefaultFont As String, ByVal AUseSHX As Boolean, ByVal AUseACAD As Boolean) As Long

Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
Declare Sub lstrcpyn Lib "kernel32" (Destination As Long, Source As Single, ByVal Length As Long)
Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInfo As OSVERSIONINFO) As Long

Declare Function GetClientRect Lib "user32" (ByVal hWnd As Long, lpRect As Rect) As Long

Const CAD_UNKNOWN = 0
Const CAD_TABLE = 1
Const CAD_BLOCK = 2
Const CAD_LTYPE = 3
Const CAD_LAYER = 4
Const CAD_VERTEX = 5
Const CAD_LINE = 6
Const CAD_SOLID = 7
Const CAD_CIRCLE = 8
Const CAD_ARC = 9
Const CAD_POLYLINE = 10
Const CAD_LWPOLYLINE = 11
Const CAD_SPLINE = 12
Const CAD_INSERT = 13
Const CAD_DIMENSION = 14
Const CAD_TEXT = 15
Const CAD_MTEXT = 16
Const CAD_ATTDEF = 17
Const CAD_ELLIPSE = 18
Const CAD_POINT = 19
Const CAD_3DFACE = 20
Const CAD_IMAGE_ENT = 22
Const CAD_HATCH = 21
Const CAD_ATTRIB = 23

Const FLAT_POLY = 99
Const CAD_BEGIN_POLYLINE = 100
Const CAD_END_POLYLINE = 101
Const CAD_BEGIN_INSERT = 102
Const CAD_END_INSERT = 103
Const CAD_BEGIN_VIEWPORT = 104
Const CAD_END_VIEWPORT = 105

Public Type CADPoint
  X As Double
  Y As Double
  Z As Double
End Type

' Extended CAD data
Public Type CADExtendedData
  Param1 As Long
  ' ... fields below may be added in future versions
End Type

Public Type CADData
    Tag As Integer   'classindex, DXF_LINE, DXF_SOLID etc.
    Count As Integer 'number of child entities
    TickCount As Integer
    Flags As Byte  'Flags byte
         ' for polylines: low bit <> 0 - is closed
         ' for layers: low bit <> 0 - is invisible
    Style As Byte  ' Style (pen, brush...) - for future versions
    Dimension As Long
    DashDots As Long
    DashDotsCount As Long
    Color As Long ' Color of entity
    Ticks As Long
    Thickness As Double ' for future versions
    Rotation As Double ' Text or block rotation angle
    Layer As Long ' Pointer to text string (Layer name (only one layer for element))
    Text As Long  ' Pointer to text string (Layer name for Layer element)
    FontName As String ' text string
    Handle As Long
    Undefined1 As Long
    Undefined2 As Double
    Undefined3 As Double
    CADExtData As Long ' pointer
    Point1 As CADPoint ' Coordinates of the first point
    Point2 As CADPoint ' Coordinates of the second point
    Point3 As CADPoint ' Coordinates of the third point
    Point4 As CADPoint ' Coordinates of the fourth point

    '0: (Radius, StartAngle, EndAngle, Ratio as  Single; EntityType: Byte) for arcs (NOT in DXFEnum)
    '1: (Block as Long; Scale as CADPOINT)  for Inserts (NOT in DXFEnum)
    '2: (FHeight, FScale, RWidth, RHeight as  Single; HAlign, VAlign as Byte) for Text
    '3: (Points as Long) pointer to CADPOINT
    Var1(0 To 33) As Byte
End Type

Public AllLayersVisible As Long
Dim BoxLeft, BoxRight, BoxTop, BoxBottom As Double
Dim ViewPortClippingRect As CADPoint
Public CADHandle As Long
Public UpdateCount As Long

Public Sub SwapInts(a As Long, B As Long)
    Dim tmp As Long
    tmp = a
    a = B
    B = tmp
End Sub

Function GetDouble(ByVal Position As Long) As Double
  CopyMemory GetDouble, ByVal Position&, Len(GetDouble)
End Function

Function GetLong(ByVal Position As Long) As Long
  Dim L As Long
  CopyMemory L, ByVal Position&, Len(L)
  GetLong = L
End Function

Function GetCADPoint(ByVal Position As Long) As CADPoint
  CopyMemory GetCADPoint, ByVal Position&, Len(GetCADPoint)
End Function

Function GetPoint(Point As CADPoint, Param As CADParam) As POINTAPI
  GetPoint.X = ((Point.X - BoxLeft) * Param.ScaleFactor) + Param.offset.X
  GetPoint.Y = ((-Point.Y + BoxTop) * Param.ScaleFactor) + Param.offset.Y
End Function
  
Public Function DoPaint(ByRef EData As CADData, Param As CADParam) As Long
Dim PreviousPen As Long
Dim Pen As Long
Dim PenWidth As Long
Dim mmToPixelX As Double

  HS = GetDeviceCaps(Param.hdc, 4)
  HR = GetDeviceCaps(Param.hdc, 8)
  If HR <> 0 Then
    mmToPixelX = HS / HR
  Else
    mmToPixelX = 1
  End If
  If Param.Thickness Then
    PenWidth = Round(EData.Thickness / mmToPixelX)
  Else
    PenWidth = 1
  End If
  Pen = CreatePen(0, PenWidth, EData.Color)
  PreviousPen = SelectObject(Param.hdc, Pen)
    
    Select Case EData.Tag
    Case CAD_LINE
     DrawLine Param, EData
    Case CAD_SOLID, CAD_3DFACE
      DrawSolid Param, EData, EData.Color
    Case CAD_CIRCLE, CAD_ARC, CAD_ELLIPSE
      DrawArc Param, EData
    Case CAD_POLYLINE, CAD_LWPOLYLINE
      DrawPoly Param, EData
    Case CAD_SPLINE
      DrawSpline Param, EData
    Case CAD_TEXT, CAD_ATTDEF, CAD_ATTRIB
      DrawText Param, EData
    Case CAD_POINT
      DrawPoint Param, EData.Point1, EData.Color
    Case CAD_IMAGE_ENT
      DrawImageEnt Param, EData
    Case CAD_BEGIN_VIEWPORT
      BeginViewport Param, EData
    Case CAD_END_VIEWPORT
      EndViewport Param
    Case CAD_HATCH
      DrawHatch Param, EData
  End Select
  SelectObject Param.hdc, PreviousPen
  DeleteObject Pen
End Function

Public Sub GetExtentsRect(ByVal hCAD As Long)
  CADGetBox hCAD, BoxLeft, BoxRight, BoxTop, BoxBottom
End Sub

' DrawGlobal
'
'  Draws a (poly)line in global coordinates. }
Public Sub DrawGlobal(Param As CADParam, ByVal Points As Long, ByVal Count As Long)
  Dim I, N, PrevX, PrevY As Long
  Dim P As POINTAPI
  Dim LastPoint As POINTAPI
  Dim PCAD As CADPoint
  If Count > 0 Then
    I = 0
    While I < Count
      PCAD = GetCADPoint(Points)
      Points = Points + Len(PCAD)
      P = GetPoint(PCAD, Param)
      PrevX = P.X
      PrevY = P.Y
      MoveToEx Param.hdc, P.X, P.Y, LastPoint
      PCAD = GetCADPoint(Points)
      Points = Points + Len(PCAD)
      P = GetPoint(PCAD, Param)
      ' For correct drawing and scaling dots
      If (P.X = PrevX) And (P.Y = PrevY) Then
        LineTo Param.hdc, P.X, P.Y + 1
      Else
        LineTo Param.hdc, P.X, P.Y
      End If
      I = I + 2
    Wend
  End If
End Sub

Public Sub DrawLine(Param As CADParam, EData As CADData)
  DrawGlobal Param, EData.DashDots, EData.DashDotsCount
End Sub

Public Sub DrawSolid(Param As CADParam, EData As CADData, Color As Long)
Dim Brush As Long
Dim PreviousBrush As Long
Dim Massiv(0 To 3) As POINTAPI

  Brush = CreateSolidBrush(Color)
  PreviousBrush = SelectObject(Param.hdc, Brush)

  Massiv(0) = GetPoint(EData.Point1, Param)
  Massiv(1) = GetPoint(EData.Point2, Param)
  Massiv(3) = GetPoint(EData.Point3, Param)
  Massiv(2) = GetPoint(EData.Point4, Param)
  
  Polygon Param.hdc, Massiv(0), 4
  SelectObject Param.hdc, PreviousBrush
  DeleteObject Brush
End Sub

'Public Sub Draw3DFace(Param As CADParam, EData As CADData, ByVal Color As Long)
'Dim Brush As Long
'Dim PreviousBrush As Long
'Dim Pt(1) As POINTAPI
'
'  Brush = CreateSolidBrush(Color)
'  PreviousBrush = SelectObject(Param.hDC, Brush)
'
'  If EData.Flags Mod 2 = 0 Then
'    Pt(0) = GetPoint(EData.Point1, Param)
'    Pt(1) = GetPoint(EData.Point2, Param)
'    Polygon DC, Pt(0), 2
'  End If
'  If (EData.Flags / 2) Mod 2 = 0 Then
'    Pt(0) = GetPoint(EData.Point2, Param)
'    Pt(1) = GetPoint(EData.Point3, Param)
'    Polygon DC, Pt(0), 2
'  End If
'  If (EData.Flags / 4) Mod 2 = 0 Then
'    Pt(0) = GetPoint(EData.Point3, Param)
'    Pt(1) = GetPoint(EData.Point4, Param)
'    Polygon DC, Pt(0), 2
'  End If
'  If EData.Flags And 8 = 0 Then
'    Pt(0) = GetPoint(EData.Point4, Param)
'    Pt(1) = GetPoint(EData.Point1, Param)
'    Polygon DC, Pt(0), 2
'  End If
'  SelectObject Param.hDC, PreviousBrush
'  DeleteObject Brush
'End Sub

Public Sub DrawArc(Param As CADParam, EData As CADData)
Dim Massiv(0 To 3) As POINTAPI
Dim Pt As POINTAPI
Dim Pt1 As POINTAPI
Dim PCAD As CADPoint
Dim MajorLength As Double
Dim Rect As RECTAPI
Dim ratio, StartAngle, EndAngle As Double
        
Massiv(0) = GetPoint(EData.Point1, Param)
Massiv(1) = GetPoint(EData.Point2, Param)
Massiv(2) = GetPoint(EData.Point3, Param)
Massiv(3) = GetPoint(EData.Point4, Param)
        
If EData.Var1(32) = 1 Then
  ratio = GetDouble(VarPtr(EData.Var1(24)))
  Pt = GetPoint(EData.Point1, Param)
  PCAD.X = EData.Point2.X + EData.Point3.X
  PCAD.Y = EData.Point2.Y + EData.Point3.Y
  PCAD.Z = 0
  Pt1 = GetPoint(PCAD, Param)
  MajorLength = Sqr(((Pt1.X - Pt.X) ^ 2) + ((Pt1.Y - Pt.Y) ^ 2))
  Rect.TopLeft.X = Pt.X - MajorLength
  Rect.TopLeft.Y = Pt.Y - MajorLength * ratio
  Rect.BottomRight.X = Pt.X + MajorLength
  Rect.BottomRight.Y = Pt.Y + MajorLength * ratio
        
  Arc Param.hdc, Rect.TopLeft.X, Rect.TopLeft.Y, Rect.BottomRight.X, Rect.BottomRight.Y, Massiv(2).X, Massiv(2).Y, Massiv(3).X, Massiv(3).Y
Else
  If (EData.Tag = CAD_ARC) Then
    If (((EData.Point3.X <> EData.Point4.X) Or (EData.Point3.Y <> EData.Point4.Y)) And (Massiv(2).X = Massiv(3).X) And (Massiv(2).Y = Massiv(3).Y)) Then
      SetPixel Param.hdc, Massiv(2).X, Massiv(2).Y, Color
      Exit Sub
    Else
      StartAngle = GetDouble(VarPtr(EData.Var1(8)))
      EndAngle = GetDouble(VarPtr(EData.Var1(16)))
      If (StartAngle = EndAngle) Then
        SetPixel Param.hdc, Massiv(2).X, Massiv(2).Y, Color
      Else
        Arc Param.hdc, Massiv(0).X, Massiv(1).Y, Massiv(1).X, Massiv(0).Y, Massiv(2).X, Massiv(2).Y, Massiv(3).X, Massiv(3).Y
      End If
    End If
  Else
    Arc Param.hdc, Massiv(0).X, Massiv(1).Y, Massiv(1).X, Massiv(0).Y, Massiv(2).X, Massiv(2).Y, Massiv(3).X, Massiv(3).Y
  End If
End If
End Sub

Public Sub DrawPoly(Param As CADParam, EData As CADData)
Dim I As Long
Dim Massiv As Variant
Dim LastPoint As POINTAPI
Dim P As POINTAPI
Dim P1 As POINTAPI
Dim PCAD As CADPoint

  If EData.Count > 0 Then
    If (EData.Count < EData.DashDotsCount) Then
      DrawGlobal Param, EData.DashDots, EData.DashDotsCount
    Else
      ReDim Massiv(EData.Count - 1, 2)
      CADConvert Massiv, EData
      PCAD.X = Massiv(0, 0)
      PCAD.Y = Massiv(0, 1)
      P = GetPoint(PCAD, Param)
      MoveToEx Param.hdc, P.X, P.Y, LastPoint
      For I = 1 To EData.Count - 1
        PCAD.X = Massiv(I, 0)
        PCAD.Y = Massiv(I, 1)
        P = GetPoint(PCAD, Param)
        LineTo Param.hdc, P.X, P.Y
      Next I
    End If
  End If
End Sub


Public Sub DrawText(Param As CADParam, EData As CADData)
Dim P As POINTAPI
Dim Mode As Long
Dim hFont As Long
Dim hPreviousFont As Long
Dim lf As LOGFONT
Dim S As String
Dim chPointer As Long
Dim strPointer As Long
Dim CADExtData As CADExtendedData
Dim attdef_tag As String
       

  If (EData.CADExtData <> 0) Then
    CopyMemory CADExtData, ByVal EData.CADExtData&, Len(CADExtData)
    If (CADExtData.Param1 <> 0) And ((EData.Tag = CAD_ATTDEF) Or (EData.Tag = CAD_ATTRIB)) Then
    
      ' IMPORTANT
      '   CADData->CADExtendedData->Param1 - is a LPVOID type but the
      '   value for CAD_ATTDEF and CAD_ATTRIB must be read as LPCSTR,
      '   i.e. LPVOID four bytes are a 32-bit LPCSTR value
      '
      attdef_tag = sgStringToVBString(CADExtData.Param1)
      ' MsgBox attdef_tag
    End If
  End If
  
  S = sgStringToVBString(EData.Text)
  If S <> "" Then
    'S = StrConv(S, VbStrConv.vbUnicode)
    I = Len(EData)
    If S <> "" Then
      If (EData.Var1(32) = 0) And (EData.Var1(33) = 0) Then
        P = GetPoint(EData.Point1, Param)
      Else
        P = GetPoint(EData.Point2, Param)
      End If
      
      lf.lfCharSet = 1 ' DEFAULT_CHARSET
      
      lf.lfHeight = GetDouble(VarPtr(EData.Var1(0))) * Param.ScaleFactor
      If lf.lfHeight = 0 Then
        lf.lfHeight = 1
      End If
      lf.lfEscapement = EData.Rotation * 10
      lf.lfOrientation = lf.lfEscapement
      
      chPointer = VarPtr(EData.FontName)
      CopyMemory strPointer, ByVal chPointer&, Len(chPointer)
      lf.lfFaceName = sgStringToVBString(strPointer) & Chr$(0)
      
      hFont = CreateFontIndirect(lf)
      hPreviousFont = SelectObject(Param.hdc, hFont)
      SetTextAlign Param.hdc, 24 'TA_BASELINE
      SetTextColor Param.hdc, EData.Color
      SetBkMode Param.hdc, 1 'TRANSPARENT
#If USE_UNICODE_SGDLL Then
      TextOutW Param.hdc, P.X, P.Y, StrPtr(S), Len(S)
#Else
      TextOut Param.hdc, P.X, P.Y, S, Len(S)
#End If
      SelectObject Param.hdc, hPreviousFont
      DeleteObject hFont
    End If
  End If
End Sub

Public Sub DrawPoint(Param As CADParam, Point As CADPoint, Color As Long)
Dim P As POINTAPI
    P = GetPoint(Point, Param)
    SetPixel Param.hdc, P.X, P.Y, Color
End Sub

Public Function NF(N, I As Long, t As Single, Knot() As CADPoint) As Single
Dim v1, d1, v2, d2 As Single
    If N = 0 Then
        If (Knot(I).X <= t) And (t < Knot(I + 1).X) Then
            NF = 1
        Else
            NF = 0
        End If
    Else
      d1 = (Knot(I + N).X - Knot(I).X)
      v1 = (t - Knot(I).X) * NF(N - 1, I, t, Knot)
      If d1 = 0 Then
          v1 = 0
      Else
          v1 = v1 / d1
      End If
  
      d2 = (Knot(I + N + 1).X - Knot(I + 1).X)
      v2 = (Knot(I + N + 1).X - t) * NF(N - 1, I + 1, t, Knot)
      If d2 = 0 Then
        v2 = 0
      Else
        v2 = v2 / d2
      End If
      NF = v1 + v2
    End If
End Function

Public Function NURBS_3(ByRef DP() As CADPoint, ByRef Knot() As CADPoint, j As Long, t As Single) As CADPoint
Dim R As CADPoint, I As Long, Ni As Single

    R.X = 0
    R.Y = 0
    R.Z = 0

    I = j - 3
    While I < j + 1
        Ni = NF(3, I, t, Knot)
        R.X = R.X + DP(I).X * Ni
        R.Y = R.Y + DP(I).Y * Ni
        R.Z = R.Z + DP(I).Z * Ni
        I = I + 1
    Wend
    NURBS_3 = R
End Function

Public Sub DrawNURBS(Param As CADParam, DP() As CADPoint, Knot() As CADPoint, ByVal Count As Long)
Dim t As Single
Dim j As Long
Dim P As POINTAPI
Dim P1 As CADPoint
Dim LastPoint As POINTAPI
    P1.X = DP(0).X
    P1.Y = DP(0).Y
    P1.Z = DP(0).Z
    P = GetPoint(P1, Param)
    MoveToEx Param.hdc, P.X, P.Y, LastPoint
    j = 3
    While j < Count
        t = Knot(j).X
        While t < Knot(j + 1).X
            P = GetPoint(NURBS_3(DP, Knot, j, t), Param)
            LineTo Param.hdc, P.X, P.Y
            t = t + 1
        Wend
        j = j + 1
    Wend
    P1.X = DP(Count - 1).X
    P1.Y = DP(Count - 1).Y
    P1.Z = DP(Count - 1).Z
    P = GetPoint(P1, Param)
    LineTo Param.hdc, P.X, P.Y
End Sub
Private Sub ConvVariantToArray(VarArray As Variant, CadArray() As CADPoint, ByVal Size As Long)
Dim I As Long
    I = 0
    For I = 0 To Size - 1
        CadArray(I).X = VarArray(I, 0)
        CadArray(I).Y = VarArray(I, 1)
        CadArray(I).Z = VarArray(I, 2)
    Next I
End Sub
Public Sub GetSplineParam(ByVal Index As Long, EData As CADData, ByRef Count As Long, Pts() As CADPoint)
Dim Param As Variant
    ReDim Pts(Count - 1)
    ReDim Param(Count - 1, 2)
    'CADGetSplineParams returns control, fit or knot points list
    '0 control points list
    '1 fit points list
    '2 knot points list
    CADGetSplineParams Index, EData, Param
    ConvVariantToArray Param, Pts(), Count
End Sub
Public Sub DrawSpline(Param As CADParam, EData As CADData)
Dim Pts(0 To 3) As POINTAPI, I As Long
Dim CP() As CADPoint, FP() As CADPoint, Knot() As CADPoint
Dim CCount As Long, FCount As Long, KCount As Long

  CCount = CADGetSplinePointsCount(0, EData) '0 control points count
  FCount = CADGetSplinePointsCount(1, EData) '1 fit points count
  KCount = CADGetSplinePointsCount(2, EData) '2 knot points count
  
  If CCount > 0 Then
    GetSplineParam 0, EData, CCount, CP() '0 get control points list
  End If
  
  If FCount > 0 Then
    GetSplineParam 1, EData, FCount, FP() '1 get fit points list
  End If
  
  If KCount > 0 Then
    GetSplineParam 2, EData, KCount, Knot() '2 get knot points list
  End If
  
  If CCount = 0 Then
    Pts(0) = GetPoint(FP(0), Param)
    MoveToEx Param.hdc, Pts(0).X, Pts(0).Y, Pts(1)
    For I = 1 To FCount - 1
      Pts(0) = GetPoint(FP(I), Param)
      LineTo Param.hdc, Pts(0).X, Pts(0).Y
    Next I
  Else
    If (FCount = 0) Then
      I = 0
      While I < CCount - 4
        Pts(0) = GetPoint(CP(I), Param)
        Pts(1) = GetPoint(CP(I + 1), Param)
        Pts(2) = GetPoint(CP(I + 2), Param)
        Pts(3) = GetPoint(CP(I + 3), Param)
        PolyBezier Param.hdc, Pts(0), 4
        I = I + 4
      Wend
    Else
      DrawNURBS Param, CP(), Knot(), CCount
    End If
  End If
End Sub

'{ BeginViewport
'
'  Creates a clipping region according to the VIEWPORT's boundary.
'  Makes necessary actions before drawing the VIEWPORT and his "contents".
'
'  Use fmCADDLLdemo.cbViewportRect.Checked (set to True) for setting a way of
'  cutting a viewport's contents to fit a "rectangular" VIEWPORT by the algorithm
'  of the LineIntersectRect function, without using Windows API REGIONS.
'  If you have no possibility to use Windows API REGIONS
'  (for example, you use OpenGL or something similar), set this flag.      }
Public Sub BeginViewport(Param As CADParam, EData As CADData)
  Dim Massiv As Variant
  Dim P As CADPoint
  Dim TP() As POINTAPI
  Dim Pt As POINTAPI
  Dim I, j As Integer
  Dim K, FCount As Long
  Dim MainRgn, Rgn As Long
  Dim hPen As Long
  Dim R As RECTAPI
  Dim CCount As Long
  Dim FP() As CADPoint
  
  hPen = CreatePen(0, 1, EData.Color)
  SelectObject Param.hdc, hPen
  
  R.TopLeft = GetPoint(EData.Point1, Param)
  R.BottomRight = GetPoint(EData.Point2, Param)
  If R.TopLeft.X > R.BottomRight.X Then
    SwapInts R.TopLeft.X, R.BottomRight.X
  End If
  If R.TopLeft.Y > R.BottomRight.Y Then
    SwapInts R.TopLeft.Y, R.BottomRight.Y
  End If
  SaveDC (Param.hdc)
  If EData.Count = 0 Then
    MainRgn = CreateRectRgnIndirect(R)
    If EData.Flags And 1 <> 0 Then
      Rectangle Param.hdc, R.TopLeft.X, R.TopLeft.Y, R.BottomRight.X, R.BottomRight.Y
    End If
  Else
    MainRgn = CreateRectRgn(0, 0, 0, 0)
    CCount = EData.Count
    I = 0
    K = 0
    Do While I < CCount
      FCount = CADGetViewPortPointsCount(K, EData)
      ReDim Massiv(FCount - 1, 2)
      ReDim FP(FCount - 1)
      CADGetViewPortParams K, EData, Massiv
      ConvVariantToArray Massiv, FP(), FCount
      K = K + FCount + I
      I = I + 1
      ReDim TP(FCount)
      For j = 0 To FCount - 1
        TP(j) = GetPoint(FP(j), Param)
      Next j
      Rgn = CreatePolygonRgn(TP(0), FCount, ALTERNATE)
      CombineRgn MainRgn, MainRgn, Rgn, RGN_XOR
      DeleteObject Rgn
    Loop
  End If
  
  Pt.X = 0
  Pt.Y = 0
  LPtoDP Param.hdc, Pt, 1
  OffsetRgn MainRgn, Pt.X, Pt.Y
  SelectClipRgn Param.hdc, MainRgn
  
  DeleteObject hPen
  DeleteObject MainRgn
End Sub


'{ EndViewport
'
'  Makes necessary actions after drawing the VIEWPORT and his "contents".    }
Public Sub EndViewport(Param As CADParam)
  RestoreDC Param.hdc, -1
End Sub

Public Sub DrawImageEnt(Param As CADParam, EData As CADData)
Dim hBmp As Long
Dim hCompatibleDC As Long
Dim Pt As POINTAPI
Dim Pt1 As POINTAPI
Dim vx As OSVERSIONINFO
Dim BmpWidth, BmpHeight, w, h As Long
Dim NumColor As Long
Dim bltMode As Long
Dim bi As BITMAPINFO
Dim P As Long
Dim pColors As Long
Dim pBitsMem As Long
Dim OldObject As Long

  If (EData.Ticks <> 0) And (EData.Handle > 0) Then
    Pt = GetPoint(EData.Point2, Param)
    Pt1 = GetPoint(EData.Point3, Param)
    If (Pt.X < Pt1.X) Then
      SwapInts Pt.X, Pt1.X
    End If
    If (Pt.Y < Pt1.Y) Then
      SwapInts Pt.Y, Pt1.Y
    End If
    w = Pt.X - Pt1.X
    h = Pt.Y - Pt1.Y
    P = EData.Ticks + 14
    CopyMemory bi.bmiHeader, ByVal P&, Len(bi.bmiHeader)
    P = P + Len(bi.bmiHeader)
    NumColor = bi.bmiHeader.biClrUsed
    If NumColor = 0 Then
      NumColor = bi.bmiHeader.biBitCount
      If (NumColor > 8) Then
        NumColor = 0
      Else
        NumColor = 2 ^ NumColor
      End If
    End If
    pColors = VarPtr(bi) + bi.bmiHeader.biSize
    CopyMemory ByVal pColors&, P, NumColor * Len(bi.bmiColors(0))
    P = P + NumColor * Len(bi.bmiColors(0))
    BmpWidth = bi.bmiHeader.biWidth
    BmpHeight = bi.bmiHeader.biHeight
    If BmpHeight < 0 Then
      BmpHeight = -BmpHeight
    End If
    pBitsMem = 0
    hBmp = CreateDIBSection(Param.hdc, bi, DIB_RGB_COLORS, pBitsMem, 0, 0)
    If hBmp <> 0 Then
      NumColor = BmpHeight * ((BmpWidth * bi.bmiHeader.biBitCount) / 8)
      CopyMemory ByVal pBitsMem&, ByVal P&, NumColor
      hCompatibleDC = CreateCompatibleDC(Param.hdc)
      If hCompatibleDC <> 0 Then
        OldObject = SelectObject(hCompatibleDC, hBmp)
        bltMode = GetStretchBltMode(Param.hdc)
        vx.dwOSVersionInfoSize = Len(vx)
        GetVersionEx vx
        If vx.dwPlatformId = VER_PLATFORM_WIN32_NT Then
          SetStretchBltMode Param.hdc, HALFTONE
        Else
          SetStretchBltMode Param.hdc, COLORONCOLOR
        End If
        StretchBlt Param.hdc, Pt1.X, Pt1.Y, w, h, hCompatibleDC, _
          0, 0, BmpWidth, BmpHeight, SRCCOPY
        SetStretchBltMode Param.hdc, bltMode
        SelectObject hCompatibleDC, OldObject
        DeleteDC hCompatibleDC
      End If
      DeleteObject hBmp
    End If
  End If
End Sub

'  Draws a hatch.
'  EData.Count - number of polyline vertices
'  EData.Points - pointer to point array
Public Sub DrawHatch(Param As CADParam, EData As CADData)
Dim I, j, K, SaveIndex, Index As Long
Dim PolyCount As Long
Dim vPoly() As POINTAPI
Dim Pt As CADPoint
Dim vRGN, vMainRGN As Long
Dim Brush As Long
Dim PreviousBrush As Long
Dim P As Long
Dim StopHatch As Boolean
        
  If EData.Flags = 16 Then            ' hatch is SOLID
    Brush = CreateSolidBrush(EData.Color)
    PreviousBrush = SelectObject(Param.hdc, Brush)
    SaveIndex = SaveDC(Param.hdc)
    vMainRGN = CreateRectRgn(0, 0, 0, 0)
    Index = 0 ' this is a counter of points for each boundary
    I = 0     ' this is a counter of boundaries themselves
    K = 0     ' DATA.PolyPoints index
    StopHatch = False
    While (I <= EData.Count) And Not StopHatch
      If Index = 0 Then
        If I <> 0 Then
          vRGN = CreatePolygonRgn(vPoly(0), PolyCount, ALTERNATE)
          CombineRgn vMainRGN, vRGN, vMainRGN, RGN_XOR
          DeleteObject vRGN
          StopHatch = (I = EData.Count)
        End If
        If Not StopHatch Then
          '  IMPORTANT
          ' if I == Index then Data->DATA.PolyPoints[I].X - is a
          ' float type but the value must be read as integer
          ' (count of points in the current hatch boundary),
          ' i.e. float four bytes are a 32-bit integer value
          P = GetLong(VarPtr(EData.Var1(0)))
          PolyCount = GetLong(P + K * Len(Pt))
          Index = PolyCount
          I = I + 1
          j = 0
          ReDim vPoly(PolyCount - 1)
        End If
      Else
        Pt = GetCADPoint(P + K * Len(Pt))
        vPoly(j) = GetPoint(Pt, Param)
        Index = Index - 1
        j = j + 1
      End If
      K = K + 1
    Wend
    FillRgn Param.hdc, vMainRGN, Brush
    DeleteObject vMainRGN
    RestoreDC Param.hdc, SaveIndex
    SelectObject Param.hdc, PreviousBrush
    DeleteObject Brush
  Else
    DrawGlobal Param, EData.DashDots, EData.DashDotsCount
  End If
End Sub

Public Function sgStringToVBString(ByVal sgString As Long) As String
#If USE_UNICODE_SGDLL Then
   Dim Ch As Integer
#Else
   Dim Ch As Byte
#End If
  sgStringToVBString = ""
  CopyMemory Ch, ByVal sgString&, Len(Ch)
  Do While Ch <> 0
#If USE_UNICODE_SGDLL Then
    sgStringToVBString = sgStringToVBString & ChrW(Ch)
#Else
    sgStringToVBString = sgStringToVBString & Chr(Ch)
#End If
    sgString = sgString + Len(Ch)
    CopyMemory Ch, ByVal sgString&, Len(Ch)
  Loop
End Function

Public Function VBStringTosgString(ByVal VBString As String) As String
#If USE_UNICODE_SGDLL Then
   VBStringTosgString = StrConv(VBString, vbUnicode)
#Else
   VBStringTosgString = VBString
#End If
End Function

Public Function GetExtension(sFile As String) As String
  Dim iPos As Long
  Dim iPosPrev As Long
  
  ' search last dot
  Do
    iPosPrev = iPos
    iPos = InStr(iPos + 1, sFile, ".", vbBinaryCompare)
  Loop While iPos > 0
  
  If iPosPrev > 0 Then
    ' must be right of last backslash
    If InStr(iPosPrev + 1, sFile, "\", vbBinaryCompare) = 0 Then
      GetExtension = Mid$(sFile, iPosPrev + 1)
    End If
  End If
  
End Function



