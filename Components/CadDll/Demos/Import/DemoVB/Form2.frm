VERSION 5.00
Begin VB.Form Form2 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Layers"
   ClientHeight    =   7245
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4665
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7245
   ScaleWidth      =   4665
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame layerPropsFrame 
      Height          =   1215
      Left            =   120
      TabIndex        =   2
      Top             =   5400
      Width           =   4455
      Begin VB.CheckBox ckbAllLayersVisible 
         Caption         =   "All Layers Visible"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   720
         Width           =   1695
      End
      Begin VB.TextBox layerName 
         Height          =   285
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   4215
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Close"
      Height          =   375
      Left            =   3480
      TabIndex        =   1
      Top             =   6720
      Width           =   1095
   End
   Begin VB.ListBox lstLayers 
      Height          =   5130
      ItemData        =   "Form2.frx":0000
      Left            =   120
      List            =   "Form2.frx":0007
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub ckbAllLayersVisible_Click()
  AllLayersVisible = ckbAllLayersVisible.Value
  Form1.Refresh
End Sub

Private Sub Command1_Click()
  Hide
End Sub

Private Sub Form_Load()
  Dim I, C As Long
  Dim LayerData As CADData
    lstLayers.Clear
    If CADHandle <> 0 Then
      C = CADLayerCount(CADHandle)
      For I = 0 To C - 1
        CADLayer CADHandle, I, LayerData
        lstLayers.AddItem sgStringToVBString(LayerData.Text)
      Next I
      If lstLayers.ListCount > 0 Then
        lstLayers.ListIndex = 0
        lstLayers_Click
      End If
    End If
End Sub

Private Sub lstLayers_Click()
  layerName.Text = lstLayers.List(lstLayers.ListIndex)
End Sub
