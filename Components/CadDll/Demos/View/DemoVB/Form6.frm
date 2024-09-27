VERSION 5.00
Begin VB.Form Form6 
   Caption         =   "Rotate"
   ClientHeight    =   2430
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   3630
   LinkTopic       =   "Form6"
   ScaleHeight     =   2430
   ScaleWidth      =   3630
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdRotate 
      Caption         =   "Rotate"
      Height          =   375
      Left            =   1080
      TabIndex        =   7
      Top             =   1920
      Width           =   1095
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   2280
      TabIndex        =   6
      Top             =   1920
      Width           =   1095
   End
   Begin VB.TextBox acisZ 
      Height          =   375
      Left            =   720
      TabIndex        =   5
      Text            =   "0"
      Top             =   1320
      Width           =   2655
   End
   Begin VB.TextBox acisY 
      Height          =   375
      Left            =   720
      TabIndex        =   3
      Text            =   "0"
      Top             =   840
      Width           =   2655
   End
   Begin VB.TextBox acisX 
      Height          =   375
      Left            =   720
      TabIndex        =   1
      Text            =   "0"
      Top             =   360
      Width           =   2655
   End
   Begin VB.Label Label3 
      Caption         =   "Z"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   1320
      Width           =   255
   End
   Begin VB.Label Label2 
      Caption         =   "Y"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label1 
      Caption         =   "X"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   255
   End
End
Attribute VB_Name = "Form6"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdClose_Click()
  Unload Me
End Sub

Private Sub cmdRotate_Click()
  Dim x, y, z As Single
  x = CDbl(acisX.Text)
  y = CDbl(acisY.Text)
  z = CDbl(acisZ.Text)
  Form1.Rotate x, y, z
End Sub
