VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "CAD DLL - Import [Visual Basic 6.0 Demo]"
   ClientHeight    =   6660
   ClientLeft      =   3090
   ClientTop       =   4470
   ClientWidth     =   9765
   LinkTopic       =   "Form1"
   ScaleHeight     =   6660
   ScaleWidth      =   9765
   Begin MSComDlg.CommonDialog CD 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu File 
      Caption         =   "File"
      Begin VB.Menu Load 
         Caption         =   "Load..."
      End
      Begin VB.Menu Save_As 
         Caption         =   "Save As..."
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
      Begin VB.Menu mmiThickness 
         Caption         =   "Thickness"
         Checked         =   -1  'True
      End
   End
   Begin VB.Menu mScale 
      Caption         =   "Scale"
      Begin VB.Menu m1 
         Caption         =   "1"
         Tag             =   "1"
      End
      Begin VB.Menu m2 
         Caption         =   "2"
         Tag             =   "2"
      End
      Begin VB.Menu m5 
         Caption         =   "5"
         Tag             =   "5"
      End
      Begin VB.Menu m10 
         Caption         =   "10"
         Tag             =   "10"
      End
      Begin VB.Menu m25 
         Caption         =   "25"
         Tag             =   "25"
      End
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
      Begin VB.Menu m400 
         Caption         =   "400"
         Tag             =   "400"
      End
      Begin VB.Menu m1000 
         Caption         =   "1000"
         Tag             =   "1000"
      End
      Begin VB.Menu m5000 
         Caption         =   "5000"
         Tag             =   "5000"
      End
      Begin VB.Menu mmi10000 
         Caption         =   "10000"
         Tag             =   "10000"
      End
   End
   Begin VB.Menu Tools 
      Caption         =   "Tools"
      Begin VB.Menu Layers 
         Caption         =   "Layers"
      End
      Begin VB.Menu Layouts 
         Caption         =   "Layouts"
      End
      Begin VB.Menu Arcs 
         Caption         =   "Arcs"
         Begin VB.Menu As_Curves 
            Caption         =   "As Curves"
         End
         Begin VB.Menu As_Poly 
            Caption         =   "As Poly"
            Checked         =   -1  'True
         End
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim KX As Double
Dim KY As Double
Dim PreviousPoint As POINTAPI
Dim offset As POINTAPI
Dim drag As Boolean
Dim FScale As Long
Dim Thickness As Boolean
Dim FBoxLeft As Double
Dim FBoxRight As Double
Dim FBoxTop As Double
Dim FBoxBottom As Double
Dim FWidth As Double
Dim FHeight As Double

Private Sub As_Curves_Click()
   If CADHandle <> 0 Then
     Cls
     CADProhibitCurvesAsPoly CADHandle, 0
     Form_Paint
     As_Poly.Checked = False
     As_Curves.Checked = True
   End If
End Sub

Private Sub As_Poly_Click()
   If CADHandle <> 0 Then
     Cls
     CADProhibitCurvesAsPoly CADHandle, 1
     Form_Paint
     As_Curves.Checked = False
     As_Poly.Checked = True
   End If
End Sub

Private Sub comboLayouts_Change()
  Dim I, LayoutIndex As Long
  If CADHandle <> 0 Then
    LayoutIndex = Form3.comboLayouts.ListIndex
    I = CADLayoutCurrent(CADHandle, LayoutIndex, True)
    Form1.Refresh
  End If
End Sub

Private Sub comboLayouts_KeyDown(KeyCode As Integer, Shift As Integer)
  comboLayouts_Change
End Sub

Private Sub Form_Initialize()
  Dim nRes As Integer
  AllLayersVisible = 0
  Thickness = False
  mmiThickness.Checked = Thickness
  ChDir App.Path
  nRes = CADSetSHXOptions(StrConv(App.Path & "\..\..\..\SHX\", vbUnicode), StrConv(App.Path & "\..\..\..\SHX\", vbUnicode), StrConv("simplex.shx", vbUnicode), True, False)
End Sub

Private Sub Form_Load()
Dim R As Rect
    GetClientRect Form1.hWnd, R
    KX = Form1.Width / R.Right
    KY = Form1.Height / R.Bottom
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    PreviousPoint.X = X
    PreviousPoint.Y = Y
    Form1.MousePointer = 5
    drag = True
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If drag = True Then
        offset.X = offset.X - (PreviousPoint.X - X) / KX
        offset.Y = offset.Y - (PreviousPoint.Y - Y) / KY
        PreviousPoint.X = X
        PreviousPoint.Y = Y
        Refresh
    End If
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    drag = False
    Form1.MousePointer = 0
    Refresh
End Sub

Private Sub Form_Paint()
Dim Param As CADParam
    If CADHandle <> 0 Then
      GetExtentsRect (CADHandle)
      Param.hdc = hdc
      Param.hWnd = hWnd
      Param.offset = offset
      Param.ScaleFactor = FScale / 100#
      Param.Thickness = Thickness
      CADEnum CADHandle, AllLayersVisible, AddressOf DoPaint, VarPtr(Param)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If CADHandle <> 0 Then
      CADClose CADHandle
      CADHandle = 0
    End If
End Sub

Private Sub Layers_Click()
  Dim LayersForm As Form2
  If CADHandle <> 0 Then
    Set LayersForm = New Form2
    On Error GoTo DeleteForm
    LayersForm.Show vbModal, Me
    Unload LayersForm
DeleteForm:
    Set LayersForm = Nothing
    Refresh
  End If
End Sub

Private Sub Layouts_Click()
  Form3.Show 1, Form1
End Sub

Private Sub Load_Click()
    CD.Filter = "CAD Drawings (*.dxf;*.dwg;*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt;*.svg;*.cgm)|*.dxf;*.dwg;*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt;*.svg;*.cgm"
    
    On Error GoTo ErrorHandler
    CD.ShowOpen
      If CADHandle <> 0 Then
        CADClose (CADHandle)
        CADHandle = 0
        offset.X = 0
        offset.Y = 0
      End If
      
      Dim FileName As String
      Dim Msg As String
      Dim MsgA As String
      
      FileName = VBStringTosgString(CD.FileName)
      CADHandle = CADCreate(hWnd, FileName)
      If CADHandle <> 0 Then
        m100_Click
        Tools.Enabled = True
        As_Curves.Checked = False
        As_Poly.Checked = True
        CADGetBox CADHandle, FBoxLeft, FBoxRight, FBoxTop, FBoxBottom
        FWidth = FBoxRight - FBoxLeft
        FHeight = FBoxTop - FBoxBottom
        Dim ratio As Double
        ratio = FWidth / FHeight
        If (ratio >= 1) & (FWidth > 5000) Then
          FWidth = 5000
          FHeight = FWidth / ratio
        End If
        If (ratio < 1) & (FHeight > 5000) Then
          FHeight = 5000
          FWidth = FHeight * ratio
        End If
      Else
        Msg = StrConv(String(256, " "), vbUnicode)
        GetLastErrorCAD Msg, 256
        MsgA = Trim(StrConv(Msg, vbFromUnicode))
        MsgBox MsgA, vbOKOnly, "CAD DLL Error"
      End If
ErrorHandler:
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

Private Sub m25_Click()
  ScaleClick m25
End Sub

Private Sub m10_Click()
  ScaleClick m10
End Sub

Private Sub m5_Click()
  ScaleClick m5
End Sub

Private Sub m2_Click()
  ScaleClick m2
End Sub

Private Sub m1_Click()
  ScaleClick m1
End Sub

Private Sub m400_Click()
    ScaleClick m400
End Sub

Private Sub m50_Click()
    ScaleClick m50
End Sub

Sub UnCheckScale()
    Select Case FScale
      Case 1: m1.Checked = False
      Case 2: m2.Checked = False
      Case 5: m5.Checked = False
      Case 10: m10.Checked = False
      Case 25: m25.Checked = False
      Case 50: m50.Checked = False
      Case 100: m100.Checked = False
      Case 200: m200.Checked = False
      Case 400: m400.Checked = False
      Case 1000: m1000.Checked = False
      Case 5000: m5000.Checked = False
      Case 10000: mmi10000.Checked = False
    End Select
End Sub

Sub ScaleClick(Item As Menu)
    UnCheckScale
    Item.Checked = True
    FScale = Item.Tag
    Refresh
End Sub

Private Sub m5000_Click()
    ScaleClick m5000
End Sub

Private Sub mmi10000_Click()
    ScaleClick mmi10000
End Sub

Private Sub mmiExit_Click()
    Unload Me
End Sub

Private Sub Units_Click()
  Dim Units As Long
  If CADUnits(CADHandle, Units) = 1 Then
    If Units = 1 Then
      MsgBox "Millimeters"
    Else
      MsgBox "Inches"
    End If
  End If
End Sub

Private Sub mmiThickness_Click()
  Thickness = Not Thickness
  mmiThickness.Checked = Thickness
  Refresh
End Sub

Private Sub Save_As_Click()
Dim ratio As Double
Dim Msg As String
Dim MsgA As String
Dim ResCode As Long

Msg = StrConv(Strings.Space(260), vbUnicode)

If CADHandle <> 0 Then
  CD.FileName = ""
  CD.Filter = "Windows Bitmap (bmp)|*.bmp|JPEG image|*.jpg|AutoCAD DXF (dxf)|*.dxf|Adobe Acrobat Document (pdf)|*.pdf|HPGL2 (plt)|*.plt|Adobe Flash File Format (swf)|*.swf|Computer Graphics Metafile (cgm)|*.cgm|Scalable Vector Graphics (svg)|*.svg"
  CD.InitDir = App.Path
  CD.ShowSave
  
  If CD.FileName <> "" Then
    Dim xmlParams As New ExportParams
    xmlParams.Version = """1.0"""
    xmlParams.FileName = CD.FileName
    xmlParams.Ext = GetExtension(CD.FileName)
    xmlParams.GraphicParameters.Width = FWidth
    xmlParams.GraphicParameters.Height = FHeight
    xmlParams.GraphicParameters.Left = 0
    xmlParams.GraphicParameters.Top = 0
    xmlParams.GraphicParameters.Right = FWidth
    xmlParams.GraphicParameters.Bottom = FHeight
  
    If xmlParams.Ext = "bmp" Or xmlParams.Ext = "png" Or xmlParams.Ext = "jpg" Or xmlParams.Ext = "gif" Then
      ratio = 800 / FWidth
      If ratio > 600 / FHeight Then
        ratio = 600 / FHeight
      End If
      xmlParams.GraphicParameters.Width = ratio * FWidth
      xmlParams.GraphicParameters.Height = ratio * FHeight
      xmlParams.GraphicParameters.Right = ratio * FWidth
      xmlParams.GraphicParameters.Bottom = ratio * FHeight
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
  
    If (SaveCADtoFileWithXMLParams(CADHandle, xmlParamsStringU, 0) = 0) Then
        ResCode = GetLastErrorCAD(Msg, 256)
        MsgA = Trim(StrConv(Msg, vbFromUnicode))
        MsgBox MsgA, vbOKOnly, "CAD DLL Error"
    Else
        MsgBox "File saved as: " & Chr$(34) & CD.FileName & Chr$(34)
    End If
  End If
End If
 
End Sub
