Attribute VB_Name = "Module1"
Public Type POINTAPI
    X As Long
    Y As Long
End Type

Public Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Type CADDRAW
    Size As Long
    DC As Long
    R As RECT
    DrawMode As Byte
End Type

Public Type CADPOINT
  X As Double
  Y As Double
  Z As Double
End Type

Public Type CADDATA
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
    FontName As Long ' Pointer to text string
    Handle As Long
    Undefined1 As Long
    Undefined2 As Double
    Undefined3 As Double
    CADExtendedData As Long 'pointer
    Point1 As CADPOINT ' Coordinates of the first point
    Point2 As CADPOINT ' Coordinates of the second point
    Point3 As CADPOINT ' Coordinates of the third point
    Point4 As CADPOINT ' Coordinates of the fourth point

    '0: (Radius, StartAngle, EndAngle, Ratio as  Single; EntityType: Byte) for arcs (NOT in DXFEnum)
    '1: (Block as Long; Scale as CADPOINT)  for Inserts (NOT in DXFEnum)
    '2: (FHeight, FScale, RWidth, RHeight as  Single; HAlign, VAlign as Byte) for Text
    '3: (Points as Long) pointer to CADPOINT
    Var1(0 To 33) As Byte
End Type

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

Type BITMAPFILEHEADER
    bfType As Integer
    bfSize As Long
    bfReserved1 As Integer
    bfReserved2 As Integer
    bfOffBits As Long
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
   
  Type DIBSECTION
    dsBm As BITMAP
    dsBmih As BITMAPINFOHEADER
    dsBitfields(3) As Long
    dshSection As Long
    dsOffset As Long
  End Type
            
Global Const DIB_RGB_COLORS = 0
Global Const SRCCOPY = &HCC0020

Global Const MMPerInch = 25.4
Global Const HORZSIZE = 4 'Horizontal size in millimeters
Global Const VERTSIZE = 6 'Vertical size in millimeters
Global Const HORZRES = 8  'Horizontal width in pixels
Global Const VERTRES = 10 'Vertical height in pixels

Public Declare Function CreateCAD Lib "cad.dll" (ByVal Window As Long, ByVal FileName As String) As Long
Public Declare Function CreateCADEx Lib "cad.dll" (ByVal Window As Long, ByVal FileName As String, ByVal Param As String) As Long
Public Declare Function CloseCAD Lib "cad.dll" (ByVal Handle As Long) As Long
Public Declare Function DrawCAD Lib "cad.dll" (ByVal Handle As Long, ByVal DC As Long, R As RECT) As Long
Public Declare Function DrawCADEx Lib "cad.dll" (ByVal Handle As Long, CdDraw As CADDRAW) As Long
Public Declare Function DrawCADtoBitmap Lib "cad.dll" (ByVal Handle As Long, CdDraw As CADDRAW) As Long
Public Declare Function DrawCADtoJpeg Lib "cad.dll" (ByVal Handle As Long, CdDraw As CADDRAW) As Long
Public Declare Function DrawCADtoGif Lib "cad.dll" (ByVal Handle As Long, CdDraw As CADDRAW) As Long
Public Declare Function GetBoxCAD Lib "cad.dll" (ByVal Handle As Long, AbsWidth As Single, AbsHeight As Single) As Long
Public Declare Function GetLastErrorCAD Lib "cad.dll" (ByVal Buf As String, ByVal Size As Long) As Long
Public Declare Function CADLayoutsCount Lib "cad.dll" (ByVal Handle As Long) As Integer
Public Declare Function CADLayoutName Lib "cad.dll" (ByVal Handle As Long, ByVal Index As Integer, ByVal Name As String, ByVal nSize As Integer) As Integer
Public Declare Function CADLayout Lib "cad.dll" (ByVal Handle As Long, ByVal Index As Integer) As Long
Public Declare Function DefaultLayoutIndex Lib "cad.dll" (ByVal Handle As Long) As Integer
Public Declare Function SetProgressProc Lib "cad.dll" (ByVal Proc As Long) As Integer
Public Declare Function StopLoading Lib "cad.dll" () As Integer
Public Declare Function DrawCADtoDIB Lib "cad.dll" (ByVal Handle As Long, ByRef R As RECT) As Long
Public Declare Function CADLayerCount Lib "cad.dll" (ByVal Handle As Long) As Long
Public Declare Function CADLayer Lib "cad.dll" (ByVal Handle As Long, ByVal Index As Long, ByRef ACADDATA As CADDATA) As Long
Public Declare Function CADVisible Lib "cad.dll" (ByVal Handle As Long, ByVal LayerName As String) As Long
Public Declare Function CADLayerVisible Lib "cad.dll" (ByVal Handle As Long, ByVal Visible As Long) As Long
Public Declare Function SetBMSize_stdcall Lib "cad.dll" (ByVal BMSize As Long) As Integer
Public Declare Function ReadCADInBMP Lib "cad.dll" (ByVal FileName As String, ByVal ErrorText As String) As Long
Public Declare Function CurrentLayoutCAD Lib "cad.dll" (ByVal Handle As Long, ByVal Index As Long, ByVal DoChange As Boolean) As Long
Public Declare Function SetCADBorderSize Lib "cad.dll" (ByVal Handle As Long, ByVal szBorder As Double) As Long
Public Declare Function GetCADBorderSize Lib "cad.dll" (ByVal Handle As Long, ByRef szBorder As Double) As Long
Public Declare Function SetCADBorderType Lib "cad.dll" (ByVal Handle As Long, ByVal BorderType As Long) As Long
Public Declare Function GetCADBorderType Lib "cad.dll" (ByVal Handle As Long, ByRef BorderType As Long) As Long
Public Declare Function CADUnits Lib "cad.dll" (ByVal Handle As Long, ByRef Units As Long) As Long
Public Declare Function SaveCADtoFileWithXMLParams Lib "cad.dll" (ByVal Handle As Long, ByVal AParam As String, ByVal AProc As Integer) As Long
Public Declare Function CADSetSHXOptions Lib "cad.dll" (ByVal ASearchPaths As String, ByVal ADefaultPath As String, ByVal ADefaultFont As String, ByVal AUseSHX As Boolean, ByVal AUseACAD As Boolean) As Long
Public Declare Function SetRotateCAD Lib "cad.dll" (ByVal Handle As Long, ByVal AAngle As Single, ByVal AAxis As Long) As Long

Public Declare Function BitBlt Lib "gdi32.dll" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function CreateEnhMetaFile Lib "gdi32.dll" Alias "CreateEnhMetaFileA" (ByVal RefDC As Long, ByVal FileName As Long, R As RECT, Desc As String) As Long
Public Declare Function PlayEnhMetaFile Lib "gdi32.dll" (ByVal dstDC As Long, ByVal hMetafile As Long, R As RECT) As Boolean
Public Declare Function CloseEnhMetaFile Lib "gdi32.dll" (ByVal DC As Long) As Long
Public Declare Function CopyEnhMetaFile Lib "gdi32.dll" Alias "CopyEnhMetaFileA" (ByVal hMetafile As Long, FileName As String) As Long
Public Declare Function GetEnhMetaFileBits Lib "gdi32.dll" (ByVal hMetafile As Long, ByVal Length As Long, ByVal Bits As Long) As Long
Public Declare Function GetDC Lib "user32.dll" (ByVal Window As Long) As Long
Public Declare Function ReleaseDC Lib "user32.dll" (ByVal Window As Long, ByVal DC As Long) As Long

Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)

Public CADImage As Long
Public BorderSize As Double
Public BorderType As Long
Public UpdateCount As Long
Public CurrLayoutIndex As Long

Public Function CADProgress(ByVal PercentDone As Byte) As Long
    If PercentDone <= 100 Then
      Form1.pbBar.Value = PercentDone
    Else
      Form1.pbBar.Value = 100
    End If
    
    Form1.sbBar.Panels(1) = "Load file... " + Str(PercentDone) + "% done"
    CADProgress = 0
End Function

Public Function AnsiToVBString(ByVal AnsiCharPtr As Long) As String
  Dim Ch As Byte
  CopyMemory Ch, ByVal AnsiCharPtr&, Len(Ch)
  Do While Ch <> 0
    AnsiToVBString = AnsiToVBString & Chr(Ch)
    AnsiCharPtr = AnsiCharPtr + 1
    CopyMemory Ch, ByVal AnsiCharPtr&, Len(Ch)
  Loop
End Function

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
   Dim s As String
#If USE_UNICODE_SGDLL Then
   s = StrConv(VBString, vbUnicode)
#Else
   s = VBString
#End If
  VBStringTosgString = s
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



