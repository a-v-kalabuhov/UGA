VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H80000005&
   Caption         =   "CAD DLL - Viewer [Visual Basic 6.0 demo]"
   ClientHeight    =   8160
   ClientLeft      =   225
   ClientTop       =   855
   ClientWidth     =   11760
   LinkTopic       =   "Form1"
   ScaleHeight     =   8160
   ScaleWidth      =   11760
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox comboLayouts 
      Height          =   315
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   3000
   End
   Begin ComctlLib.ProgressBar pbBar 
      Height          =   375
      Left            =   5760
      TabIndex        =   1
      Top             =   7800
      Visible         =   0   'False
      Width           =   5715
      _ExtentX        =   10081
      _ExtentY        =   661
      _Version        =   327682
      Appearance      =   1
      Max             =   101
   End
   Begin ComctlLib.StatusBar sbBar 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   7785
      Width           =   11760
      _ExtentX        =   20743
      _ExtentY        =   661
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   2
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Bevel           =   0
            Object.Width           =   7056
            MinWidth        =   7056
            TextSave        =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   13123
            TextSave        =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog CD 
      Left            =   0
      Top             =   1560
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu mFile 
      Caption         =   "File"
      Begin VB.Menu mLoad 
         Caption         =   "Load..."
      End
      Begin VB.Menu mSaveAs 
         Caption         =   "Save as..."
      End
      Begin VB.Menu bmp 
         Caption         =   "Save as bitmap"
      End
      Begin VB.Menu JPG 
         Caption         =   "Save as JPG"
      End
      Begin VB.Menu mmiSaveMetafile 
         Caption         =   "Save to Metafile"
      End
      Begin VB.Menu mPrint 
         Caption         =   "Print"
      End
      Begin VB.Menu mmiSep 
         Caption         =   "-"
      End
      Begin VB.Menu mmiExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mmiView 
      Caption         =   "View"
      Begin VB.Menu mmiRotate 
         Caption         =   "Rotate..."
      End
      Begin VB.Menu mmiDrawPicture 
         Caption         =   "Draw CAD to picture"
      End
   End
   Begin VB.Menu mScale 
      Caption         =   "Scale"
      Begin VB.Menu m50 
         Caption         =   "50"
         Tag             =   "50"
      End
      Begin VB.Menu m100 
         Caption         =   "100"
         Tag             =   "100"
      End
      Begin VB.Menu m200 
         Caption         =   "200"
         Tag             =   "200"
      End
      Begin VB.Menu m500 
         Caption         =   "500"
         Tag             =   "500"
      End
      Begin VB.Menu m1000 
         Caption         =   "1000"
         Tag             =   "1000"
      End
   End
   Begin VB.Menu NLayers 
      Caption         =   "Layers"
   End
   Begin VB.Menu NLayouts 
      Caption         =   "Layouts"
   End
   Begin VB.Menu mmiOptions 
      Caption         =   "Options"
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Type GUID
     Data1 As Long
     Data2 As Integer
     Data3 As Integer
     Data4(7) As Byte
End Type

Private Type PicBmp
     Size As Long
     Type As Long
     hbmp As Long
     hPal As Long
     Reserved As Long
End Type

Private Declare Function SetMapMode Lib "gdi32" (ByVal hDC As Long, ByVal nMapMode As Long) As Long
Private Declare Function SetBkColor Lib "gdi32" (ByVal hDC As Long, ByVal crColor As Long) As Long
'Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function ReleaseDC Lib "user32" (ByVal hWnd As Long, ByVal hDC As Long) As Long
Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (PicDesc As PicBmp, RefIID As GUID, ByVal fPictureOwnHandle As Long, iPic As IPicture) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function GetObject Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
Private Declare Function GetMapMode Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function CreateDIBSection Lib "gdi32" (ByVal hDC As Long, pbmi As BITMAPINFO, ByVal iUsage As Long, ppvBits As Long, ByVal hSection As Long, ByVal dwOffset As Long) As Long
Private Declare Function SetDIBits Lib "gdi32" (ByVal hDC As Long, ByVal hbmp As Long, ByVal uStartScan As Long, ByVal cScanLines As Long, lpvBits As Any, lpbmi As BITMAPINFO, ByVal fuColorUse As Long) As Long
Private Declare Function CreateDIBitmap Lib "gdi32" (ByVal hDC As Long, lpbmih As BITMAPINFOHEADER, ByVal fdwInit As Long, lpbInit As Any, ByRef lpbmi As BITMAPINFO, ByVal fuUsage As Long) As Long
Private Declare Function CreateBitmapIndirect Lib "gdi32" (ByRef lpBITMAP As BITMAP) As Long
Private Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal cPlanes As Long, ByVal cBitsPerPel As Long, lpvBits As Any) As Long
Private Declare Function SetBitmapBits Lib "gdi32" (ByVal hBitmap As Long, ByVal cBytes As Long, lpBits As Any) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)

Private Declare Function CLSIDFromString Lib "ole32" (ByVal lpsz As Any, pclsid As GUID) As Long
Private Declare Function OleLoadPicture Lib "olepro32" (pStream As Any, ByVal lSize As Long, ByVal fRunmode As CBoolean, riid As GUID, ppvObj As Any) As Long

Public Enum CBoolean ' enum members are Long data types
CFalse = 0
CTrue = 1
End Enum
Private Declare Function CreateStreamOnHGlobal Lib "ole32" (ByVal hGlobal As Long, ByVal fDeleteOnRelease As CBoolean, ppstm As Any) As Long
Private Const S_OK = 0 ' indicates successful HRESULT
Private Const sIID_IPicture = "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"

Const CBM_INIT = 4

Const MOVEFILE_REPLACE_EXISTING = &H1
Const FILE_ATTRIBUTE_TEMPORARY = &H100
Const FILE_BEGIN = 0
Const FILE_SHARE_READ = &H1
Const FILE_SHARE_WRITE = &H2
Const CREATE_NEW = 1
Const OPEN_EXISTING = 3
Const GENERIC_READ = &H80000000
Const GENERIC_WRITE = &H40000000
Const CREATE_ALWAYS = 1
Const FILE_ATTRIBUTE_NORMAL = &H80000000
Const GMEM_MOVEABLE = 2

Private Declare Function WriteFile Lib "kernel32" (ByVal hFile As Long, lpBuffer As Any, ByVal nNumberOfBytesToWrite As Long, lpNumberOfBytesWritten As Long, ByVal lpOverlapped As Any) As Long
Private Declare Function CreateFile Lib "kernel32" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As Any, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Private Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
Private Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWnd As Long, ByVal MSG As Any, ByVal wParam As Any, ByVal lParam As Any) As Long

Private Declare Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As Long) As Long
Private Declare Function GlobalFree Lib "kernel32" (ByVal hMem As Long) As Long
Private Declare Function GlobalLock Lib "kernel32" (ByVal hMem As Long) As Long
Private Declare Function GlobalUnlock Lib "kernel32" (ByVal hMem As Long) As Long
Private Declare Function GlobalSize Lib "kernel32" (ByVal hMem As Long) As Long

Private Declare Function GetClientRect Lib "user32.dll" (ByVal hWnd As Long, R As RECT) As Boolean
Private Declare Function GetDeviceCaps Lib "gdi32.dll" (ByVal hWnd As Long, ByVal nIndex As Long) As Long

Dim KX As Single
Dim KY As Single
Dim PreviousPoint As POINTAPI
Dim Offset As POINTAPI
Dim drag As Boolean
Dim FScale As Long
Dim FAbsWidth As Single
Dim FAbsHeight As Single
Dim FDrawRect As RECT

Function GetLastCADErrorString() As String
    Dim message As String
    message = StrConv(String(256, " "), vbUnicode)
    GetLastErrorCAD message, 256
    GetLastCADErrorString = StrConv(message, vbFromUnicode)
End Function

Private Sub OffsetDrawRect(ByVal dx As Double, ByVal dy As Double)
  FDrawRect.Left = FDrawRect.Left + dx
  FDrawRect.Right = FDrawRect.Right + dx
  
  FDrawRect.Top = FDrawRect.Top + dy
  FDrawRect.Bottom = FDrawRect.Bottom + dy
End Sub

Private Sub GetDrawRect(ByRef R As RECT, ByRef ClientRect As RECT)
    Dim AbsWidth As Single
    Dim AbsHeight As Single
    Dim K As Double

    R = ClientRect
    If CADImage <> 0 Then
      GetBoxCAD CADImage, AbsWidth, AbsHeight
      If AbsHeight <> -1 Then
        
        If AbsWidth = 0 Then
          K = 1
        Else
          K = AbsHeight / AbsWidth
        End If
        R.Bottom = (R.Top + (R.Right - R.Left) * K)
      End If
    End If
End Sub

Private Sub ScaleDrawRect(ByVal AScale As Double, ByVal x As Double, ByVal y As Double)
    Dim W As Double
    Dim H As Double

    W = (FDrawRect.Right - FDrawRect.Left) * AScale
    H = (FDrawRect.Bottom - FDrawRect.Top) * AScale

    FDrawRect.Left = FDrawRect.Left * AScale - x * AScale + x
    FDrawRect.Top = FDrawRect.Top * AScale - y * AScale + y

    FDrawRect.Right = FDrawRect.Left + W
    FDrawRect.Bottom = FDrawRect.Top + H
End Sub

Private Sub bmp_Click()
Dim CrDraw As CADDRAW
Dim AbsWidth As Single
Dim AbsHeight As Single
Dim K As Double
Dim Hnd As Long, Size As Long, p As Long, FHnd As Long, Ret As Long

  If CADImage <> 0 Then
    CD.FileName = ""
    CD.Filter = "Bmp files (bmp)|*.bmp"
    CD.ShowSave
    GetBoxCAD CADImage, AbsWidth, AbsHeight
    If AbsHeight <> -1 Then
        GetClientRect Form1.hWnd, CrDraw.R
        If AbsWidth = 0 Then
          K = 1
        Else
          K = AbsHeight / AbsWidth
        End If
        CrDraw.Size = Len(CrDraw) 'size of CADDRAW
        CrDraw.R.Top = 0
        CrDraw.R.Left = 0
        CrDraw.R.Bottom = CrDraw.R.Right * K
        CrDraw.R.Right = CrDraw.R.Right * FScale / 100
        CrDraw.R.Bottom = CrDraw.R.Bottom * FScale / 100
        ' color mode
        ' 0 - color
        ' 1 - black and white
        ' 2 - glayscale mode
        CrDraw.DrawMode = 0 ' color mode
        Hnd = DrawCADtoBitmap(CADImage, CrDraw)
        If Hnd <> 0 Then
            Size = GlobalSize(Hnd)
            p = GlobalLock(Hnd)
            FHnd = CreateFile(CD.FileName, GENERIC_WRITE, FILE_SHARE_READ, ByVal 0&, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0)
            If FHnd <> 0 Then
                WriteFile FHnd, ByVal p&, Size, Ret, ByVal 0&
                CloseHandle FHnd
            End If
            GlobalUnlock Hnd
            GlobalFree Hnd
        End If
    End If
  End If
End Sub

Function CreatePicture(ByVal Handle As Long, ByVal PicType As Byte, iPic As IPicture) As Boolean
    Dim Pic As PicBmp
    Dim IID_IDispatch As GUID
    Dim lRC As Long
    Dim bSize As Integer
    IID_IDispatch.Data1 = &H20400
    IID_IDispatch.Data4(0) = &HC0
    IID_IDispatch.Data4(7) = &H46
    Pic.Size = Len(Pic)
    Pic.Type = PicType
    Pic.hbmp = Handle
    Pic.hPal = 0
    CreatePicture = OleCreatePictureIndirect(Pic, IID_IDispatch, 1, iPic) = 0
End Function

Private Sub LoadPreview(ByVal FileName As String)
     Dim hbmp As Long
     Dim iPic As IPicture
     Dim S As String
     Dim vFileName As String
     
     If SetBMSize_stdcall(200) Then
        S = StrConv(String(100, " "), vbUnicode)
        vFileName = VBStringTosgString(FileName)
        hbmp = ReadCADInBMP(vFileName, S)
        If hbmp <> 0 Then
             If CreatePicture(hbmp, vbPicTypeBitmap, iPic) Then
                  Form3.Picture1 = iPic
                  Set iPic = Nothing
             Else
                  Call DeleteObject(hbmp)
             End If
             Form3.Show vbModeless, Form1
        Else
          MsgBox Trim(StrConv(S, vbFromUnicode)), vbCritical, "CAD DLL Error"
        End If
     End If
End Sub

Private Sub Form_GotFocus()
  IMWheel_Hook
End Sub

Private Sub Form_Initialize()
  Dim nRes As Integer
  CurrLayoutIndex = -1
  BorderType = 1
  BorderSize = 0
  ChDir App.Path
  nRes = CADSetSHXOptions(StrConv(App.Path & "\..\..\..\SHX\", vbUnicode), StrConv(App.Path & "\..\..\..\SHX\", vbUnicode), StrConv("simplex.shx", vbUnicode), True, False)
End Sub

Private Sub Form_Load()
    Dim R As RECT
    Offset.x = 0
    Offset.y = 0
    PreviousPoint.x = 0
    PreviousPoint.y = 0
    GetClientRect Form1.hWnd, R
    KX = Form1.Width / R.Right
    KY = Form1.Height / R.Bottom
    SetProgressProc AddressOf CADProgress
    IMWheel_Hook
End Sub

Public Sub DrawToPictureBox()
  Dim AbsWidth, AbsHeight As Single
  Dim R As RECT
  Dim bih As BITMAPINFOHEADER
  Dim bi As BITMAPINFO
  Dim hbmp As Long
  Dim BitsMem As Long
  Dim hMemDib As Long
  Dim MemLockDib As Long
  
  Dim Pic As PicBmp
  Dim iPic As IPicture
  Dim IID_IDispatch As GUID
  Dim lRC As Long
  Dim bSize As Integer
  Dim Bits() As Byte
  
  If CADImage <> 0 Then
    R.Left = 0
    R.Top = 0
    ' set image width
    R.Right = Form3.Picture1.Width / Screen.TwipsPerPixelX
    ' set image height
    GetBoxCAD CADImage, AbsWidth, AbsHeight
    R.Bottom = (AbsHeight / AbsWidth) * Form3.Picture1.Height / Screen.TwipsPerPixelY
    ' fill memory: [BITMAPINFOHEADER][Color table][bitmap data]
    hMemDib = DrawCADtoDIB(CADImage, R)
    ' locate memory
    MemLockDib = GlobalLock(hMemDib)
    CopyMemory bi, ByVal MemLockDib&, Len(bi)
       
    BitsMem = MemLockDib + Len(bi)
    ReDim Bits(bi.bmiHeader.biSizeImage - 1)
    CopyMemory Bits(0), ByVal BitsMem&, bi.bmiHeader.biSizeImage
    hbmp = CreateDIBitmap(Form3.Picture1.hDC, bi.bmiHeader, CBM_INIT, Bits(0), bi, DIB_RGB_COLORS)
       
    If hbmp <> 0 Then
      IID_IDispatch.Data1 = &H20400
      IID_IDispatch.Data4(0) = &HC0
      IID_IDispatch.Data4(7) = &H46
      Pic.Size = Len(Pic)
      Pic.Type = vbPicTypeBitmap
      Pic.hbmp = hbmp
      Pic.hPal = 0
      lRC = OleCreatePictureIndirect(Pic, IID_IDispatch, 1, iPic)
      If lRC = 0 Then
        Form3.Picture1 = iPic
        Set iPic = Nothing
      Else
        Form3.Picture1 = Nothing
        Call DeleteObject(hbmp)
      End If
      Form3.Show vbModeless, Form1
    End If
    GlobalFree (hMemDib)
  End If
End Sub

Private Sub Form_LostFocus()
  IMWheel_Unhook
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    PreviousPoint.x = x
    PreviousPoint.y = y
    Form1.MousePointer = 5
    drag = True
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If drag = True Then
        Offset.x = Offset.x - (PreviousPoint.x - x) / KX
        Offset.y = Offset.y - (PreviousPoint.y - y) / KY
        OffsetDrawRect (x - PreviousPoint.x) / KX, (y - PreviousPoint.y) / KY
        PreviousPoint.x = x
        PreviousPoint.y = y
        Refresh
    End If
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    drag = False
    Form1.MousePointer = 0
    Refresh
End Sub

Public Sub WheelMoved(ByVal delta As Long, x As Long, y As Long)
    Dim ZScale As Double

    If Screen.ActiveForm.hWnd = Me.hWnd Then
      If delta < 0 Then
        ZScale = 0.8
      Else
        ZScale = 1.25
      End If
      FScale = FScale * ZScale
      ScaleDrawRect ZScale, x, y
      Refresh
    End If
End Sub

Private Sub Form_Paint()
  If CADImage <> 0 Then
    DrawCAD CADImage, Form1.hDC, FDrawRect
  End If
End Sub

Private Sub CloseImage()
  Dim TmpCADImage As Long
  If CADImage <> 0 Then
    TmpCADImage = CADImage
    CADImage = 0
    CloseCAD TmpCADImage
  End If
  CurrLayoutIndex = -1
End Sub

Private Sub Form_Resize()
  Refresh
End Sub

Private Sub Form_Terminate()
    IMWheel_Unhook
End Sub

Private Sub Form_Unload(Cancel As Integer)
    CloseImage
    Unload Form3
    Unload Form6
    IMWheel_Unhook
End Sub

Sub Uncheck()
  m50.Checked = False
  m100.Checked = False
  m200.Checked = False
  m500.Checked = False
  m1000.Checked = False
End Sub

Private Sub JPG_Click()
Dim CrDraw As CADDRAW
Dim AbsWidth As Single
Dim AbsHeight As Single
Dim K As Double
Dim Hnd As Long, Size As Long, p As Long, FHnd As Long, Ret As Long

  If CADImage <> 0 Then
    CD.FileName = ""
    CD.Filter = "Jpg files (jpg)|*.jpg"
    CD.ShowSave
    GetBoxCAD CADImage, AbsWidth, AbsHeight
    If AbsHeight <> -1 Then
        GetClientRect Form1.hWnd, CrDraw.R
        If AbsWidth = 0 Then
          K = 1
        Else
          K = AbsHeight / AbsWidth
        End If
        CrDraw.Size = Len(CrDraw) 'size of CADDRAW
        CrDraw.R.Top = 0
        CrDraw.R.Left = 0
        CrDraw.R.Bottom = CrDraw.R.Right * K
        CrDraw.R.Right = CrDraw.R.Right * FScale / 100
        CrDraw.R.Bottom = CrDraw.R.Bottom * FScale / 100
        ' color mode
        ' 0 - color
        ' 1 - black and white
        ' 2 - glayscale mode
        CrDraw.DrawMode = 0 ' color mode
        Hnd = DrawCADtoJpeg(CADImage, CrDraw)
        If Hnd <> 0 Then
            Size = GlobalSize(Hnd)
            p = GlobalLock(Hnd)
            FHnd = CreateFile(CD.FileName, GENERIC_WRITE, FILE_SHARE_READ, ByVal 0&, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0)
            If FHnd <> 0 Then
                WriteFile FHnd, ByVal p&, Size, Ret, ByVal 0&
                CloseHandle FHnd
            End If
            GlobalUnlock Hnd
            GlobalFree Hnd
        End If
    End If
  End If
End Sub

Private Sub m100_Click()
  ScaleClick m100
End Sub

Private Sub m1000_Click()
  ScaleClick m1000
End Sub

Private Sub m200_Click()
  ScaleClick m200
End Sub

Private Sub m50_Click()
  ScaleClick m50
End Sub

Private Sub m500_Click()
  ScaleClick m500
End Sub

Private Sub mLoad_Click()
  CD.Filter = "CAD files (*.dwg *.dxf *.rtl *.spl *.prn *.gl2 *.hpgl2 *.hpgl *.hp2 *.hp1 *.hp *.plo *.hpg *.hg *.hgl *.plt *.cgm *.svg)|"
  CD.Filter = CD.Filter + "*.dwg;*.dxf;*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt;*.cgm;*.svg|"
  CD.Filter = CD.Filter + "Metafiles (*.wmf *.emf)|*.wmf;*.emf|"
  CD.Filter = CD.Filter + "Raster Images|*.bmp;*.rle;*.dib;*.ico;*.jpg;*.jpeg;*.gif;*.pcx;*.tif;*.tiff;*.emf;*.wmf;*.fax;" + _
    "*.bw;*.rgb;*.rgba;*.sgi;*.cel;*.pic;*.tga;*.vst;*.icb;*.vda;*.win;*.pcd;*.ppm;*.pgm;*.pbm;*.cut;*.pal;*.rla;*.rpf;*.psd;" + _
    "*.pdd;*.psp;*.png;*.ged|"
  CD.Filter = CD.Filter + "All files (*.*)|*.*"
  CD.FileName = ""
  CD.ShowOpen
  If CD.FileName <> "" Then
    OpenFile CD.FileName
  End If
End Sub

Private Sub OpenFile(ByVal FileName As String)

  Dim EData As CADDATA
  Dim Cnt As Long
  Dim I As Integer
  Dim Layer As Long
  Dim C As Long
  Dim vNum As String
  Dim szBorder As Double
  Dim vFileName As String
  Dim VeiwPort As RECT
  
    CloseImage
    pbBar.Left = sbBar.Panels(1).Width
    pbBar.Top = sbBar.Top
    pbBar.Width = sbBar.Panels(2).Width
    pbBar.Visible = True
    vFileName = VBStringTosgString(FileName)
    CADImage = CreateCAD(hWnd, vFileName)
    pbBar.Visible = False
    If CADImage <> 0 Then
      LoadPreview FileName
      CurrLayoutIndex = DefaultLayoutIndex(CADImage)
      GetBoxCAD CADImage, FAbsWidth, FAbsHeight
      SetCADBorderType CADImage, BorderType
      SetCADBorderSize CADImage, BorderSize
      
      Dim LayoutName As String
      LayoutName = String(100, " ")
      Cnt = CADLayoutsCount(CADImage)
      For I = 0 To Cnt - 1
        CADLayoutName CADImage, I, LayoutName, Len(LayoutName)
    #If USE_UNICODE_SGDLL Then
        Dim S As String
        S = StrConv(LayoutName, vbFromUnicode)
        comboLayouts.AddItem S
    #Else
        comboLayouts.AddItem LayoutName
    #End If
      Next I
      comboLayouts.Text = comboLayouts.List(CurrLayoutIndex)
      GetClientRect hWnd, VeiwPort
      VeiwPort.Bottom = VeiwPort.Bottom - sbBar.Height
      GetDrawRect FDrawRect, VeiwPort
      m100_Click
      Refresh
      sbBar.Panels(1).Text = StrConv(vFileName, vbFromUnicode)
    Else
      MsgBox GetLastCADErrorString, vbCritical, "CAD DLL Error"
    End If
End Sub

Sub ScaleClick(Item As Menu)
    Uncheck
    Item.Checked = True
    FScale = Item.Tag
    ScaleDrawRect FScale / 100, (FDrawRect.Right - FDrawRect.Left) / 2, (FDrawRect.Bottom - FDrawRect.Top) / 2
    Refresh
End Sub

Private Sub mmiDrawPicture_Click()
  DrawToPictureBox
End Sub

Private Sub mmiExit_Click()
    Unload Me
End Sub

Private Sub mmiOptions_Click()
  Form5.Show vbModal, Form1
  Form1.Refresh
End Sub

Private Sub mmiRotate_Click()
  Form6.Show
End Sub

Private Sub mmiSaveMetafile_Click()
    Dim ScreenDC As Long
    Dim AbsWidth, AbsHeight As Single
    Dim Aspect As Double
    Dim FileName As String
    Dim mfLen As Long
    Dim Bits() As Byte
    Dim CADDrawParms As CADDRAW
    Dim hMf As Long
    Dim MfRect As RECT
        
    If CADImage <> 0 Then
        CD.FileName = ""
        CD.Filter = "Metafile (*.emf)|*.emf"
        CD.ShowSave
        If CD.FileName <> "" Then
            FileName = CD.FileName
            GetBoxCAD CADImage, AbsWidth, AbsHeight
            Aspect = 1#
            If (AbsWidth > 0) And (AbsHeight > 0) Then Aspect = AbsWidth / AbsHeight
            ScreenDC = GetDC(0)
            CADDrawParms.Size = Len(CADDrawParms)
            CADDrawParms.DrawMode = 0
            MfRect.Left = 0
            MfRect.Top = 0
            CADDrawParms.R.Left = 0
            CADDrawParms.R.Top = 0
            If Aspect > 1# Then
                MfRect.Right = GetDeviceCaps(ScreenDC, HORZSIZE) * 100
                MfRect.Bottom = Round(MfRect.Right / Aspect)
                CADDrawParms.R.Right = GetDeviceCaps(ScreenDC, HORZRES)
                CADDrawParms.R.Bottom = Round(CADDrawParms.R.Right / Aspect)
            Else
                MfRect.Bottom = GetDeviceCaps(ScreenDC, VERTSIZE) * 100
                MfRect.Right = Round(MfRect.Bottom * Aspect)
                CADDrawParms.R.Bottom = GetDeviceCaps(ScreenDC, VERTRES)
                CADDrawParms.R.Right = Round(CADDrawParms.R.Bottom * Aspect)
            End If
            CADDrawParms.DC = CreateEnhMetaFile(ScreenDC, 0, MfRect, "")
            If CADDrawParms.DC <> 0 Then
                DrawCADEx CADImage, CADDrawParms
                hMf = CloseEnhMetaFile(CADDrawParms.DC)
                If hMf <> 0 Then
                    mfLen = GetEnhMetaFileBits(hMf, 0, 0)
                    If mfLen > 0 Then
                        Open FileName For Binary Access Write As #1
                        ReDim Bits(mfLen - 1)
                        mfLen = GetEnhMetaFileBits(hMf, mfLen, VarPtr(Bits(0)))
                        Put #1, , Bits
                        Close #1
                    End If
                End If
            End If
            ReleaseDC 0, ScreenDC
        End If
    End If
End Sub

Private Sub mPrint_Click()
Dim R As RECT
Dim AbsWidth As Single
Dim AbsHeight As Single
Dim K As Double
  If CADImage <> 0 Then
    GetBoxCAD CADImage, AbsWidth, AbsHeight
    If AbsHeight <> -1 Then
        R.Left = 0
        R.Top = 0
        R.Right = GetDeviceCaps(Printer.hDC, HORZRES) 'Horizontal width in pixels
        R.Bottom = GetDeviceCaps(Printer.hDC, VERTRES) 'Vertical height in pixels
        If AbsWidth = 0 Then
          K = 1
        Else
          K = AbsHeight / AbsWidth
        End If
        R.Bottom = (R.Right - R.Left) * K
        On Error GoTo Done
        Printer.Line (0, 0)-(0, 0)
        DrawCAD CADImage, Printer.hDC, R
        Printer.EndDoc
Done:
    End If
  End If
End Sub

Private Sub mSaveAs_Click()
If CADImage <> 0 Then
  CD.FileName = ""
  CD.Filter = "Windows Bitmap (*.bmp)|*.bmp|JPEG image|*.jpg|AutoCAD DXF (*.dxf)|*.dxf|Adobe Acrobat Document (*.pdf)|*.pdf|HPGL2 (*.plt)|*.plt|Adobe Flash File Format (*.swf)|*.swf|Computer Graphics Metafile (*.cgm)|*.cgm|Scalable Vector Graphics (*.svg)|*.svg"
  CD.InitDir = App.Path
  CD.ShowSave
  
  If CD.FileName <> "" Then
    Dim xmlParams As New ExportParams
    xmlParams.Version = """1.0"""
    xmlParams.FileName = CD.FileName
    xmlParams.Ext = GetExtension(CD.FileName)
    xmlParams.GraphicParameters.Left = 0
    xmlParams.GraphicParameters.Top = 0
    
    Dim SRect As RECT
    If xmlParams.Ext = "bmp" Or xmlParams.Ext = "png" Or xmlParams.Ext = "jpg" Or xmlParams.Ext = "gif" Then
      Dim K As Double
      Dim AbsWidth As Single
      Dim AbsHeight As Single
      
      GetBoxCAD CADImage, AbsWidth, AbsHeight
      GetClientRect Form1.hWnd, SRect
      
      If AbsWidth = 0 Then
        K = 1
      Else
        K = AbsHeight / AbsWidth
      End If

      SRect.Bottom = SRect.Right * K
      SRect.Right = SRect.Right * FScale / 100
      SRect.Bottom = SRect.Bottom * FScale / 100
      
      xmlParams.GraphicParameters.Width = SRect.Right
      xmlParams.GraphicParameters.Height = SRect.Bottom
      xmlParams.GraphicParameters.Right = SRect.Right
      xmlParams.GraphicParameters.Bottom = SRect.Bottom
    Else
      xmlParams.GraphicParameters.Width = FAbsWidth
      xmlParams.GraphicParameters.Height = FAbsHeight
      xmlParams.GraphicParameters.Right = FAbsWidth
      xmlParams.GraphicParameters.Bottom = FAbsHeight
    End If

    Dim xmlParamsString As String
    Dim CADParamsString As String
    Dim graphicParamsString As String
    
    CADParamsString = "<CADParametrs>" & _
      "<BackgroundColor>" & Str(xmlParams.CADParameters.BackgroundColor) & "</BackgroundColor>" & _
      "<DefaultColor>" & Str(xmlParams.CADParameters.DefaultColor) & "</DefaultColor>" & _
      "<XScale>" & Str(xmlParams.CADParameters.XScale) & "</XScale>" & _
    "</CADParametrs>"
    
    graphicParamsString = "<GraphicParametrs>" & _
      "<PixelFormat>" & Str(xmlParams.GraphicParameters.PixelFormat) & "</PixelFormat>" & _
      "<Width>" & Str(xmlParams.GraphicParameters.Width) & "</Width>" & _
      "<Height>" & Str(xmlParams.GraphicParameters.Height) & "</Height>" & _
      "<DrawMode>" & Str(xmlParams.GraphicParameters.DrawMode) & "</DrawMode>" & _
      "<DrawRect Left=" & Chr$(34) & Str(xmlParams.GraphicParameters.Left) & Chr$(34) & " Top=" & Chr$(34) & Str(xmlParams.GraphicParameters.Top) & Chr$(34) & " Right=" & Chr$(34) & Str(xmlParams.GraphicParameters.Right) & Chr$(34) & " Bottom=" & Chr$(34) & Str(xmlParams.GraphicParameters.Bottom) & Chr$(34) & " />" & _
    "</GraphicParametrs>"
    
    xmlParamsString = "<ExportParams Version=" & xmlParams.Version & ">" & _
    "<FileName>" & xmlParams.FileName & "</FileName>" & _
    "<Ext>" & "." & xmlParams.Ext & "</Ext>" & _
    CADParamsString & graphicParamsString & _
    "</ExportParams>"
    
    Dim xmlParamsStringU As String
    
    xmlParamsStringU = StrConv(xmlParamsString, vbUnicode)
    
    If (SaveCADtoFileWithXMLParams(CADImage, xmlParamsStringU, 0) = 0) Then
      MsgBox GetLastCADErrorString, vbOKOnly, "CAD DLL Error"
    Else
      MsgBox "File saved as: " & Chr$(34) & CD.FileName & Chr$(34)
    End If
  End If
End If

End Sub

Private Sub NLayers_Click()
  If CADImage <> 0 Then
    Dim LayersForm As Form2
    Set LayersForm = New Form2
    On Error GoTo DeleteForm
    LayersForm.Show vbModal, Me
    Unload LayersForm
DeleteForm:
    Set LayersForm = Nothing
    Refresh
  End If
End Sub

Private Sub NLayouts_Click()
  Dim LayoutForm As Form4
  If CADImage <> 0 Then
    On Error GoTo DeleteForm
    Set LayoutForm = New Form4
    LayoutForm.Show vbModal, Form1
    CurrLayoutIndex = LayoutForm.comboLayouts.ListIndex
    If CurrLayoutIndex <> -1 Then
      CurrentLayoutCAD CADImage, CurrLayoutIndex, True
    End If
    Unload LayoutForm
DeleteForm:
    Set LayoutForm = Nothing
    Refresh
  End If
End Sub

Public Sub Rotate(ByVal AX As Single, ByVal AY As Single, ByVal AZ As Single)
  Dim R As RECT
  Dim prevcenterx, prevcentery As Single
  Dim curcenterx, curcentery As Single
  Dim scaleprev As Double
  
  If CADImage <> 0 Then
    prevcenterx = (FDrawRect.Right + FDrawRect.Left) / 2#
    prevcentery = (FDrawRect.Top + FDrawRect.Bottom) / 2#
    scaleprev = (FDrawRect.Right - FDrawRect.Left) / FAbsWidth
    
    SetRotateCAD CADImage, AX, 0
    SetRotateCAD CADImage, AY, 1
    SetRotateCAD CADImage, AZ, 2
    
    SetCADBorderSize CADImage, BorderSize ' need to call for recalc CADImage current layout extents
    GetBoxCAD CADImage, FAbsWidth, FAbsHeight
    
    FDrawRect.Left = 0
    FDrawRect.Top = 0
    FDrawRect.Right = Round(FAbsWidth * scaleprev)
    FDrawRect.Bottom = Round(FDrawRect.Right * FAbsHeight / FAbsWidth)
    
    curcenterx = (FDrawRect.Right + FDrawRect.Left) / 2#
    curcentery = (FDrawRect.Top + FDrawRect.Bottom) / 2#
    OffsetDrawRect prevcenterx - curcenterx, prevcentery - curcentery
    Refresh
  End If
End Sub
