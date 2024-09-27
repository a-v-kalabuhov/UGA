Imports System.Collections

Public Class Form2
    Inherits System.Windows.Forms.Form

    Private CADObj As CADImage = Nothing
    Private layers As ArrayList = New ArrayList

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    Public Sub New(ByVal CADImg As CADImage)
        MyBase.New()
        InitializeComponent()
        CADImage = CADImg
    End Sub

    Public Property CADImage() As CADImage
        Get
            Return CADObj
        End Get
        Set(ByVal value As CADImage)
            layers.Clear()
            Me.CheckedListBox1.Items.Clear()
            CADObj = value
            If Not (CADObj Is Nothing) Then
                Dim I As Integer
                For I = 0 To CADImage.LayersCount - 1
                    layers.Add(CADImage.Layer(I))
                    Dim name As String = CADImage.LayerName(I)
                    CheckedListBox1.Items.Add(Name, CADImage.IsLayerVisible(Name))
                Next I
            End If
        End Set
    End Property

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            layers = Nothing
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents CheckedListBox1 As System.Windows.Forms.CheckedListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.CheckedListBox1 = New System.Windows.Forms.CheckedListBox
        Me.SuspendLayout()
        '
        'CheckedListBox1
        '
        Me.CheckedListBox1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.CheckedListBox1.Location = New System.Drawing.Point(0, 0)
        Me.CheckedListBox1.Name = "CheckedListBox1"
        Me.CheckedListBox1.Size = New System.Drawing.Size(224, 274)
        Me.CheckedListBox1.TabIndex = 0
        '
        'Form2
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(224, 284)
        Me.Controls.Add(Me.CheckedListBox1)
        Me.Name = "Form2"
        Me.Text = "Layers"
        Me.ResumeLayout(False)

    End Sub
#End Region


    Private Sub chLay_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles CheckedListBox1.ItemCheck
        Select Case e.NewValue
            Case CheckState.Checked
                CADImageLib.CADLayerVisible(layers(e.Index), 1)
            Case CheckState.Unchecked
                CADImageLib.CADLayerVisible(layers(e.Index), 0)
        End Select
    End Sub
End Class
