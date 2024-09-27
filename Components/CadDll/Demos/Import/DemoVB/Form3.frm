VERSION 5.00
Begin VB.Form Form3 
   Caption         =   "Layouts"
   ClientHeight    =   1395
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6975
   LinkTopic       =   "Form3"
   ScaleHeight     =   1395
   ScaleWidth      =   6975
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox comboLayouts 
      Height          =   315
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   240
      Width           =   6735
   End
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   375
      Left            =   2640
      TabIndex        =   0
      Top             =   840
      Width           =   1695
   End
End
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Combo1_KeyPress(KeyAscii As Integer)
  KeyAscii = 0
End Sub

Private Sub Command1_Click()
  If comboLayouts.ListIndex <> -1 Then
    CADLayoutCurrent CADHandle, comboLayouts.ListIndex, True
  End If
  Form1.Refresh
  Unload Me
End Sub

Private Sub Form_Load()
Dim vName As String
Dim I, Cnt As Integer
  comboLayouts.Clear
  If CADHandle <> 0 Then
    vName = String(100, " ")
    Cnt = CADLayoutCount(CADHandle)
    For I = 0 To Cnt - 1
      CADLayoutName CADHandle, I, vName, Len(vName)
#If USE_UNICODE_SGDLL Then
      Dim S As String
      S = StrConv(vName, vbFromUnicode)
      comboLayouts.AddItem S
#Else
      comboLayouts.AddItem vName
#End If
    Next I
    If CADLayoutCurrent(CADHandle, I, False) = 1 Then comboLayouts.ListIndex = I
  End If
End Sub
