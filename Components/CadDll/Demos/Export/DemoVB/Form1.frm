VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "CAD DLL - Export [VB6 Sample]"
   ClientHeight    =   2700
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5520
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2700
   ScaleWidth      =   5520
   StartUpPosition =   3  'Windows Default
   Begin ComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   5
      Top             =   2400
      Width           =   5520
      _ExtentX        =   9737
      _ExtentY        =   529
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   1
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   9684
            TextSave        =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog CD 
      Left            =   0
      Top             =   1800
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "dxf"
      DialogTitle     =   "Save as"
   End
   Begin VB.CheckBox Check3 
      Caption         =   "Alternative Black"
      Height          =   375
      Left            =   3360
      TabIndex        =   3
      Top             =   840
      Width           =   1575
   End
   Begin VB.CommandButton btnExport2 
      Caption         =   "Create metafile and save to DXF"
      Height          =   375
      Left            =   360
      TabIndex        =   2
      Top             =   960
      Width           =   2535
   End
   Begin VB.CheckBox Check2 
      Caption         =   "Parse white"
      Height          =   375
      Left            =   3360
      TabIndex        =   1
      Top             =   480
      Width           =   1335
   End
   Begin VB.CommandButton btnExport 
      Caption         =   "Metafile to DXF/DWG"
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   2535
   End
   Begin VB.Frame Frame1 
      Caption         =   "Export flags"
      Height          =   1095
      Left            =   3120
      TabIndex        =   4
      Top             =   240
      Width           =   2175
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Type RECT
    left As Long
    top As Long
    right As Long
    bottom As Long
End Type

Private Type point
  X As Long
  Y As Long
End Type

Const acR2000 = 6
Const acR2004 = 7


Private Declare Function ExportToDXF Lib "cad.dll" (ByVal Handle As Long, ByVal FileName As String, ByVal Flag As Integer) As Long
Private Declare Function ExportToCADFile Lib "cad.dll" (ByVal Handle As Long, ByVal FileName As String, ByVal Flag As Integer, ByVal Version As Byte) As Long
Private Declare Function GetLastErrorCAD Lib "cad.dll" (ByVal Msg As String, ByVal Size As Long) As Long
Private Declare Function StRg Lib "cad.dll" (ByVal User As String, ByVal EMail As String, ByVal Key As String) As Long

Private Declare Function GetEnhMetaFile Lib "gdi32" Alias "GetEnhMetaFileA" (ByVal lpszMetaFile As String) As Long
Private Declare Function CreateEnhMetaFile Lib "gdi32" Alias "CreateEnhMetaFileA" (ByVal HDC As Long, ByVal MetafileName As String, ByRef R As RECT, ByVal Description As String) As Long
Private Declare Function CloseEnhMetaFile Lib "gdi32" (ByVal HDC As Long) As Long
Private Declare Function DeleteEnhMetaFile Lib "gdi32" (ByVal HDC As Long) As Long
Private Declare Function Ellipse Lib "gdi32" (ByVal HDC As Long, ByVal left As Integer, ByVal top As Integer, ByVal right As Integer, ByVal bottom As Integer) As Boolean
Private Declare Function Arc Lib "gdi32" (ByVal HDC As Long, ByVal L As Integer, ByVal T As Integer, ByVal R As Integer, ByVal B As Integer, ByVal XS As Integer, ByVal YS As Integer, ByVal XE As Integer, ByVal YE As Integer) As Boolean
Private Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal HDC As Long, ByVal nXStart As Integer, ByVal nYStart As Integer, ByVal Text As String, ByVal TextLength As Integer) As Boolean
Private Declare Function MoveToEx Lib "gdi32" (ByVal HDC As Long, ByVal X As Integer, ByVal Y As Integer, ByVal P As Long) As Boolean
Private Declare Function LineTo Lib "gdi32" (ByVal HDC As Long, ByVal X As Integer, ByVal Y As Integer) As Boolean
Private Declare Function Polyline Lib "gdi32" (ByVal HDC As Long, ByRef arr As point, ByVal count As Integer) As Boolean
Private Declare Function PolyBezier Lib "gdi32" (ByVal HDC As Long, ByRef arr As point, ByVal count As Integer) As Boolean
Dim Flag As Integer

Private Sub btnExport_Click()
Dim hEmf As Long
Dim FileName, Result As String
Dim MetafileName As String
Dim Msg As String
Dim ResCode As Long
Dim MsgA As String

CD.Filter = "Enhanced Metafiles (*.emf)|*.emf||"
CD.DefaultExt = emf

CD.ShowOpen

MetafileName = CD.FileName
 
  If MetafileName <> "" Then
    hEmf = GetEnhMetaFile(MetafileName)
    If hEmf <> 0 Then
      FileName = StrConv(Mid(MetafileName, 1, Len(MetafileName) - 3) + "dxf", vbUnicode)
      
      StatusBar1.Panels(1).Text = "Please, wait until conversion is done"
      
      If ExportToDXF(hEmf, FileName, Flag) Then
        Result = "DXF: Successfully"
      Else
        Msg = StrConv(String(256, " "), vbUnicode)
        ResCode = GetLastErrorCAD(Msg, 256)
        MsgA = Trim(StrConv(Trim(Msg), vbFromUnicode))
        MsgA = Mid(MsgA, 1, Len(MsgA) - 1)
        Result = "DXF: " & MsgA
      End If
      FileName = StrConv(Mid(MetafileName, 1, Len(MetafileName) - 3) + "dwg", vbUnicode)
      If ExportToCADFile(hEmf, FileName, Flag, acR2000) Then
        Result = Result & "; DWG: Successfully"
      Else
        Msg = StrConv(String(256, " "), vbUnicode)
        ResCode = GetLastErrorCAD(Msg, 256)
        MsgA = Trim(StrConv(Trim(Msg), vbFromUnicode))
        MsgA = Mid(MsgA, 1, Len(MsgA) - 1)
        Result = Result & "; DWG: " & MsgA
      End If
      
      StatusBar1.Panels(1).Text = Result
      StatusBar1.Panels.Item(1).ToolTipText = Result

    End If
  End If
End Sub

Private Sub Check1_Click()
  Flag = Flag Xor 1
End Sub

Private Sub Check2_Click()
  Flag = Flag Xor 2
End Sub

Private Sub btnExport2_Click()
    Dim HDC As Long
    Dim hEmf As Long
    Dim R As RECT
    Dim Description As String
    Dim FileName As String
    Dim MetafileName As String
    
    CD.Filter = "AutoCAD DXF (*.dxf)|*.dxf||"
    CD.DefaultExt = "dxf"
    CD.ShowSave
    MetafileName = CD.FileName
    
    If MetafileName <> "" Then
        
    R.left = 0
    R.top = 0
    R.right = 10000
    R.bottom = 10000
    
    Description = "test drawing"

    FileName = Mid(MetafileName, 1, Len(MetafileName) - 3) + "emf"
    
    HDC = CreateEnhMetaFile(0, FileName, R, Description)
    
    Ellipse HDC, 30, 30, 300, 300
    
    Arc HDC, 50, 50, 250, 200, 0, 50, 500, 0
    
    TextOut HDC, 100, 100, Description, 12
    
    MoveToEx HDC, 200, 400, 0
    LineTo HDC, 20, 70
    
    K = 25
    Dim pts(10) As point
    pts(1).X = 10 * K
    pts(1).Y = 5 * K
    pts(2).X = 15 * K
    pts(2).Y = 7 * K
    pts(3).X = 9 * K
    pts(3).Y = 8 * K
    pts(4).X = 13 * K
    pts(4).Y = 15 * K
    pts(5).X = 0 * K
    pts(5).Y = 0 * K
    pts(6).X = 17 * K
    pts(6).Y = 2 * K
    pts(7).X = 3 * K
    pts(7).Y = 3 * K
    pts(8).X = 8 * K
    pts(8).Y = 5 * K
    pts(9).X = 9 * K
    pts(9).Y = 7 * K
    pts(10).X = 10 * K
    pts(10).Y = 14 * K
    
    Polyline HDC, pts(1), 4
    
    PolyBezier HDC, pts(1), 10
    
    hEmf = CloseEnhMetaFile(HDC)
        
    StatusBar1.Panels(1).Text = "Please, wait until conversion is done"
        
    FileName = StrConv(Mid(MetafileName, 1, Len(MetafileName) - 3) + "dxf", vbUnicode)
    
    If ExportToDXF(hEmf, FileName, 0) Then
        Result = "DXF: Successfully"
    Else
        Result = "DXF: Error"
    End If
    
    StatusBar1.Panels(1).Text = "Done. " & Result
    DeleteEnhMetaFile hEmf
    
    End If
End Sub
 
Private Sub Check3_Click()
  Flag = Flag Xor 4
End Sub

Private Sub Form_Load()
    StatusBar1.Panels(1).Width = Form1.Width
    ' Replace these strings with your license data to register the DLL
    StRg "John Doe", "johndoe@example.com", "XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX"
End Sub

