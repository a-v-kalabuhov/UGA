VERSION 5.00
Begin VB.Form Form5 
   Caption         =   "Options"
   ClientHeight    =   2475
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form5"
   ScaleHeight     =   2475
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3000
      TabIndex        =   7
      Top             =   1920
      Width           =   1575
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   375
      Left            =   1320
      TabIndex        =   6
      Top             =   1920
      Width           =   1455
   End
   Begin VB.Frame frameBorder 
      Caption         =   "Border"
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
      Begin VB.TextBox txtSize 
         Height          =   375
         Left            =   720
         TabIndex        =   3
         Text            =   "12,5"
         Top             =   840
         Width           =   2775
      End
      Begin VB.OptionButton optRatio 
         Caption         =   "Ratio"
         Height          =   255
         Left            =   2280
         TabIndex        =   2
         Top             =   360
         Width           =   2055
      End
      Begin VB.OptionButton optGlobal 
         Caption         =   "Global"
         Height          =   255
         Left            =   120
         TabIndex        =   1
         Top             =   360
         Width           =   2055
      End
      Begin VB.Label lblUnits 
         Caption         =   "%"
         Height          =   255
         Left            =   3600
         TabIndex        =   5
         Top             =   960
         Width           =   615
      End
      Begin VB.Label lblSize 
         Caption         =   "Size:"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   960
         Width           =   495
      End
   End
End
Attribute VB_Name = "Form5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub InitControls()
  Dim bsz As Double
  Dim btp As Long
  If CADImage <> 0 Then
    GetCADBorderType CADImage, btp
    GetCADBorderSize CADImage, bsz
  Else
    btp = BorderType
    bsz = BorderSize
  End If
  If btp = 0 Then
    optGlobal.Value = True
    optRatio.Value = False
    lblUnits.Caption = "units"
  Else
    optGlobal.Value = False
    optRatio.Value = True
    lblUnits.Caption = "%"
  End If
  txtSize.Text = StrConv(bsz * 100#, vbUpperCase)
End Sub

Private Sub ApplyChanges()
  If optGlobal.Value Then
    BorderType = 0
  Else
    BorderType = 1
  End If
  BorderSize = CDbl(txtSize.Text) / 100#
  If CADImage <> 0 Then
    SetCADBorderType CADImage, BorderType
    SetCADBorderSize CADImage, BorderSize
  End If
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOk_Click()
  ApplyChanges
  Unload Me
End Sub

Private Sub Form_Load()
  InitControls
End Sub

Private Sub optGlobal_Click()
  optRatio.Value = Not optGlobal.Value
  If optGlobal.Value Then
    lblUnits.Caption = "units"
  Else
    lblUnits.Caption = "%"
  End If
End Sub

Private Sub optRatio_Click()
  optGlobal.Value = Not optRatio.Value
  If optGlobal.Value Then
    lblUnits.Caption = "units"
  Else
    lblUnits.Caption = "%"
  End If
End Sub
