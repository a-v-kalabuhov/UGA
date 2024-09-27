VERSION 5.00
Begin VB.Form Form4 
   Caption         =   "Layouts"
   ClientHeight    =   1395
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6975
   LinkTopic       =   "Form4"
   ScaleHeight     =   1395
   ScaleWidth      =   6975
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   345
      Left            =   2640
      TabIndex        =   1
      Top             =   840
      Width           =   1695
   End
   Begin VB.ComboBox comboLayouts 
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   6735
   End
End
Attribute VB_Name = "Form4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
  Hide
End Sub

Private Sub comboLayouts_KeyPress(KeyAscii As Integer)
  KeyAscii = 0
End Sub

Private Sub Form_Load()
  Dim I As Long
  Dim Cnt As Long
  Dim vName As String
  If CADImage <> 0 Then
    vName = String(100, " ")
    Cnt = CADLayoutsCount(CADImage)
    For I = 0 To Cnt - 1
      CADLayoutName CADImage, I, vName, Len(vName)
#If USE_UNICODE_SGDLL Then
      Dim S As String
      S = StrConv(vName, vbFromUnicode)
      comboLayouts.AddItem S
#Else
      comboLayouts.AddItem vName
#End If
    Next I
    comboLayouts.ListIndex = CurrLayoutIndex
  End If
End Sub

