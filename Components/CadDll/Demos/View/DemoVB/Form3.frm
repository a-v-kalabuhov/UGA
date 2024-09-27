VERSION 5.00
Begin VB.Form Form3 
   Caption         =   "Preview"
   ClientHeight    =   4185
   ClientLeft      =   8490
   ClientTop       =   1500
   ClientWidth     =   3945
   LinkTopic       =   "Form3"
   ScaleHeight     =   4185
   ScaleWidth      =   3945
   Begin VB.CommandButton Command1 
      Caption         =   "Close"
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   3720
      Width           =   1335
   End
   Begin VB.PictureBox Picture1 
      Height          =   3375
      Left            =   120
      ScaleHeight     =   3315
      ScaleWidth      =   3675
      TabIndex        =   0
      Top             =   120
      Width           =   3735
   End
End
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Hide
  Picture1.Picture = Nothing
End Sub

Private Sub Form_Resize()
  If Width - 400 > 0 Then
    Picture1.Width = Form3.Width - 400
  End If
  If Height - 1200 > 0 Then
    Picture1.Height = Form3.Height - 1200
  End If
  Command1.left = Picture1.left + Round(Picture1.Width / 2 - Command1.Width / 2)
  Command1.top = Picture1.top + Picture1.Height + Command1.Height - 250
End Sub

