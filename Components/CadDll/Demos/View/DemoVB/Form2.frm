VERSION 5.00
Begin VB.Form Form2 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Layers"
   ClientHeight    =   6270
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4980
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6270
   ScaleWidth      =   4980
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cndClose 
      Caption         =   "Close"
      Height          =   345
      Left            =   1800
      TabIndex        =   1
      Top             =   5760
      Width           =   1575
   End
   Begin VB.ListBox List1 
      Height          =   5460
      ItemData        =   "Form2.frx":0000
      Left            =   120
      List            =   "Form2.frx":0002
      Style           =   1  'Checkbox
      TabIndex        =   0
      Top             =   120
      Width           =   4695
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cndClose_Click()
  Hide
End Sub

Private Sub Form_Initialize()
  UpdateCount = 0
End Sub

Private Sub Form_Load()
  Dim LayerHandle As Long
  Dim EData As CADDATA
  Dim Cnt As Long
  Dim I As Long
  Dim S As String
  UpdateCount = UpdateCount + 1
  On Error GoTo DecUpdateCounter
  If CADImage <> 0 Then
    Cnt = CADLayerCount(CADImage)
    For I = 0 To Cnt - 1
      LayerHandle = CADLayer(CADImage, I, EData)
      S = sgStringToVBString(EData.Text)
      List1.AddItem S
      List1.ItemData(List1.ListCount - 1) = LayerHandle
      List1.Selected(List1.ListCount - 1) = (EData.Flags Mod 2 <> 0)
    Next I
  End If
DecUpdateCounter:
  UpdateCount = UpdateCount - 1
End Sub

Private Sub List1_ItemCheck(Item As Integer)
  Dim LayerHandle As Long
  If UpdateCount = 0 Then
    LayerHandle = List1.ItemData(Item)
    CADLayerVisible LayerHandle, List1.Selected(Item)
    Form1.Refresh
  End If
End Sub
