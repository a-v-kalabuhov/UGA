Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Runtime.InteropServices
Imports System.IO
Imports System.Diagnostics

Public Class Form1
    Inherits System.Windows.Forms.Form

    Public ReadOnly GENERIC_WRITE As Long = &H40000000
    Public ReadOnly FILE_SHARE_READ As Long = &H1
    Public ReadOnly CREATE_ALWAYS As Long = 1
    Public ReadOnly FILE_ATTRIBUTE_NORMAL As Long = &H80000000

    Private DownPoint As PointF
    Private DrawRect As RectangleF
    Private Down As Boolean = False
    Private DefaultColor As Color = Color.Black
    Friend WithEvents CADImage As CADImage = New CADImage()

    Friend WithEvents MenuItemSaveAs As System.Windows.Forms.MenuItem
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents CADProgressBar As System.Windows.Forms.ProgressBar
    Friend WithEvents MenuItemBackColor As System.Windows.Forms.MenuItem
    Friend WithEvents LayoutsCombo As System.Windows.Forms.ToolStripComboBox

#Region " Windows Form Designer generated code "
    Public Sub New()
        MyBase.New()
        'This call is required by the Windows Form Designer.
        InitializeComponent()
        'Add any initialization after the InitializeComponent() call
    End Sub
    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                CADImage.Dispose()
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
    Friend WithEvents panel1 As System.Windows.Forms.Panel
    Friend WithEvents dlgOpenDXFFile As System.Windows.Forms.OpenFileDialog
    Friend WithEvents CD As System.Windows.Forms.SaveFileDialog
    Friend WithEvents MainMenu1 As System.Windows.Forms.MainMenu
    Friend WithEvents MenuItem1 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem3 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem10 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem11 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem4 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem12 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem14 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem15 As System.Windows.Forms.MenuItem
    Friend WithEvents ColorDialog1 As System.Windows.Forms.ColorDialog
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.panel1 = New System.Windows.Forms.Panel()
        Me.CADProgressBar = New System.Windows.Forms.ProgressBar()
        Me.dlgOpenDXFFile = New System.Windows.Forms.OpenFileDialog()
        Me.CD = New System.Windows.Forms.SaveFileDialog()
        Me.MainMenu1 = New System.Windows.Forms.MainMenu(Me.components)
        Me.MenuItem1 = New System.Windows.Forms.MenuItem()
        Me.MenuItem3 = New System.Windows.Forms.MenuItem()
        Me.MenuItem11 = New System.Windows.Forms.MenuItem()
        Me.MenuItem4 = New System.Windows.Forms.MenuItem()
        Me.MenuItemSaveAs = New System.Windows.Forms.MenuItem()
        Me.MenuItem10 = New System.Windows.Forms.MenuItem()
        Me.MenuItem14 = New System.Windows.Forms.MenuItem()
        Me.MenuItem15 = New System.Windows.Forms.MenuItem()
        Me.MenuItemBackColor = New System.Windows.Forms.MenuItem()
        Me.MenuItem12 = New System.Windows.Forms.MenuItem()
        Me.ColorDialog1 = New System.Windows.Forms.ColorDialog()
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip()
        Me.LayoutsCombo = New System.Windows.Forms.ToolStripComboBox()
        Me.panel1.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'panel1
        '
        Me.panel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.panel1.AutoScroll = True
        Me.panel1.BackColor = System.Drawing.Color.White
        Me.panel1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.panel1.Controls.Add(Me.CADProgressBar)
        Me.panel1.Location = New System.Drawing.Point(0, 26)
        Me.panel1.Name = "panel1"
        Me.panel1.Size = New System.Drawing.Size(784, 517)
        Me.panel1.TabIndex = 7
        '
        'CADProgressBar
        '
        Me.CADProgressBar.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CADProgressBar.Location = New System.Drawing.Point(-2, 489)
        Me.CADProgressBar.Name = "CADProgressBar"
        Me.CADProgressBar.Size = New System.Drawing.Size(782, 24)
        Me.CADProgressBar.TabIndex = 0
        Me.CADProgressBar.Visible = False
        '
        'dlgOpenDXFFile
        '
        Me.dlgOpenDXFFile.DefaultExt = "*.dxf"
        Me.dlgOpenDXFFile.RestoreDirectory = True
        Me.dlgOpenDXFFile.Title = "Open File"
        '
        'CD
        '
        Me.CD.Title = "Save as"
        '
        'MainMenu1
        '
        Me.MainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem1, Me.MenuItem14, Me.MenuItem12})
        '
        'MenuItem1
        '
        Me.MenuItem1.Index = 0
        Me.MenuItem1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem3, Me.MenuItem11, Me.MenuItem4, Me.MenuItemSaveAs, Me.MenuItem10})
        Me.MenuItem1.Text = "File"
        '
        'MenuItem3
        '
        Me.MenuItem3.Index = 0
        Me.MenuItem3.Text = "Load..."
        '
        'MenuItem11
        '
        Me.MenuItem11.Enabled = False
        Me.MenuItem11.Index = 1
        Me.MenuItem11.Text = "Save as BMP"
        '
        'MenuItem4
        '
        Me.MenuItem4.Enabled = False
        Me.MenuItem4.Index = 2
        Me.MenuItem4.Text = "Save as JPG"
        '
        'MenuItemSaveAs
        '
        Me.MenuItemSaveAs.Enabled = False
        Me.MenuItemSaveAs.Index = 3
        Me.MenuItemSaveAs.Text = "Save as..."
        '
        'MenuItem10
        '
        Me.MenuItem10.Index = 4
        Me.MenuItem10.Text = "Exit"
        '
        'MenuItem14
        '
        Me.MenuItem14.Index = 1
        Me.MenuItem14.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem15, Me.MenuItemBackColor})
        Me.MenuItem14.Text = "View"
        '
        'MenuItem15
        '
        Me.MenuItem15.Enabled = False
        Me.MenuItem15.Index = 0
        Me.MenuItem15.Text = "Set Default Color..."
        '
        'MenuItemBackColor
        '
        Me.MenuItemBackColor.Index = 1
        Me.MenuItemBackColor.Text = "Set Background Color..."
        '
        'MenuItem12
        '
        Me.MenuItem12.Index = 2
        Me.MenuItem12.Text = "Layers"
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.LayoutsCombo})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(784, 25)
        Me.ToolStrip1.TabIndex = 8
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'LayoutsCombo
        '
        Me.LayoutsCombo.Name = "LayoutsCombo"
        Me.LayoutsCombo.Size = New System.Drawing.Size(200, 25)
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(784, 543)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.panel1)
        Me.Menu = Me.MainMenu1
        Me.Name = "Form1"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "CAD DLL – Viewer [Visual Basic .NET Demo]"
        Me.panel1.ResumeLayout(False)
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

    Private Sub CloseCADImage()
        LayoutsCombo.Items.Clear()
        If Not IsEmptyCADImage() Then
            CADImage.Close()
        End If
        SetEnabledControls(False)
    End Sub

    Private Sub ScaleRectangleF(ByVal Scale As Double, ByVal Pos As Point, ByRef Rect As RectangleF)
        Rect.Size = New SizeF(Rect.Width * Scale, Rect.Height * Scale)
        Rect.Location = New PointF(Rect.Left * Scale, Rect.Top * Scale)
        Rect.Offset(-Pos.X * Scale, -Pos.Y * Scale)
        Rect.Offset(Pos.X, Pos.Y)
    End Sub

    Private Sub SetEnabledControls(ByVal Enabled As Boolean)
        panel1.Visible = Enabled
        Me.MainMenu1.MenuItems(0).MenuItems(1).Enabled = Enabled
        Me.MainMenu1.MenuItems(0).MenuItems(2).Enabled = Enabled
        Me.MainMenu1.MenuItems(1).MenuItems(0).Enabled = Enabled
        Me.MenuItemSaveAs.Enabled = Enabled
    End Sub

    Private Sub Form1_MouseWheel(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles Me.MouseWheel
        If Not IsEmptyCADImage() Then
            Dim scale As Double
            If e.Delta < 0 Then
                scale = 4 / 5
            Else
                scale = 5 / 4
            End If
            ScaleRectangleF(scale, panel1.PointToClient(Me.PointToScreen(e.Location)), DrawRect)
            panel1.Invalidate()
        End If
    End Sub

    Private Sub btnLoadFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem3.Click
        If dlgOpenDXFFile.ShowDialog() = Windows.Forms.DialogResult.OK Then
            CloseCADImage()
            Try
                CADProgressBar.Value = 0
                CADProgressBar.Visible = True
                CADImage.Load(panel1.Handle, dlgOpenDXFFile.FileName)
                If Not IsEmptyCADImage() Then
                    DrawRect = FitToWindow(panel1.ClientRectangle)
                    CADImage.SetDefaultColor(DefaultColor)
                    Dim I As Integer
                    'layouts
                    For I = 0 To CADImage.LayoutsCount - 1
                        LayoutsCombo.Items.Add(CADImage.LayoutName(I))
                    Next I
                    LayoutsCombo.Text = LayoutsCombo.Items.Item(CADImage.DefaultLayoutIndex)
                    SetEnabledControls(True)
                Else
                    Dim S As String
                    S = New String(" ", 256)
                    CADImageLib.GetLastErrorCAD(S, S.Length)
                    MsgBox(Trim(S), MsgBoxStyle.Critical, "CAD DLL Error")
                End If
            Finally
                CADProgressBar.Visible = False
            End Try
        End If
    End Sub

    Private Sub Form1_Closed(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Closed
        CloseCADImage()
    End Sub

    Private Sub panel1_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles panel1.Paint
        Dim p As Pen = New Pen(panel1.BackColor)
        e.Graphics.FillRectangle(p.Brush, e.ClipRectangle)
        If Not IsEmptyCADImage() Then
            CADImage.Draw(e.Graphics, Rectangle.Round(DrawRect))
            'CADImage.DrawCADEx(e.Graphics, Rectangle.Round(DrawRect), 3)
        End If
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        dlgOpenDXFFile.Filter = "CAD files (*.dwg *.dxf *.rtl *.spl *.prn *.gl2 *.hpgl2 *.hpgl *.hp2 *.hp1 *.hp *.plo *.hpg *.hg *.hgl *.plt *.cgm *.svg *.svgz)|*.dwg;*.dxf;*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt;*.cgm;*.svg;*.svgz|" + _
            "AutoCAD files (*.dwg *.dxf)|*.dwg;*.dxf;|" + _
            "HPGL/2 files (*.rtl *.spl *.prn *.gl2 *.hpgl2 *.hpgl *.hp2 *.hp1 *.hp *.plo *.hpg *.hg *.hgl *.plt)|*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt;|" + _
            "Computer Graphics Metafile (*.cgm)|*.cgm;|" + _
            "Scalable Vector Graphics (*.svg *.svgz)|*.svg;*.svgz;|" + _
            "All files (*.*)|*.*"

        Dim shxPath As String = Process.GetCurrentProcess().MainModule.FileName
        shxPath = Path.GetDirectoryName(shxPath) + "\..\..\..\SHX\"
        CADImageLib.CADSetSHXOptions(shxPath, shxPath, "simplex.shx", True, False)
    End Sub

    Private Sub panel1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles panel1.MouseDown
        If ((e.Button = Windows.Forms.MouseButtons.Middle) Or (e.Button = Windows.Forms.MouseButtons.Right)) Then
            If (e.Button = Windows.Forms.MouseButtons.Middle) And (e.Clicks >= 2) Then
                DrawRect = FitToWindow(panel1.ClientRectangle)
                panel1.Invalidate()
            Else
                DownPoint = e.Location
                panel1.Cursor = Cursors.Hand
                Down = True
            End If
        Else
            Down = False
        End If
    End Sub

    Private Sub panel1_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles panel1.MouseMove
        If Down Then
            If Not ((e.Button = Windows.Forms.MouseButtons.Middle) Or (e.Button = Windows.Forms.MouseButtons.Right)) Then
                panel1.Cursor = Cursors.Default
                Down = False
            Else
                DrawRect.Offset(e.X - DownPoint.X, e.Y - DownPoint.Y)
                DownPoint = New PointF(e.X, e.Y)
                panel1.Invalidate()
            End If
        End If
    End Sub

    Private Sub panel1_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles panel1.MouseUp
        If ((e.Button = Windows.Forms.MouseButtons.Middle) Or (e.Button = Windows.Forms.MouseButtons.Right)) And Down Then
            panel1.Cursor = Cursors.Default
            Down = False
        End If
    End Sub

    Private Sub Form1_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Activated
        panel1.Visible = True
    End Sub

    Private Sub Form1_Deactivate(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Deactivate
        'panel1.Visible = False
    End Sub

    Private Sub MenuItem10_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem10.Click
        Close()
    End Sub

    Private Sub MenuItem11_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem11.Click
        CD.FileName = ""
        CD.Filter = "Bmp files (*.bmp)|*.bmp"
        If CD.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Dim box As RectangleF = CADImage.Box
            If box.Width > 0 Then
                Dim CrDraw As CADDRAW = New CADDRAW
                CrDraw.Size = Len(CrDraw) 'size of CADDRAW
                Dim r As Rectangle = Rectangle.Round(DrawRect)
                r.Offset(-r.X, -r.Y)
                CrDraw.R = New Rect(r)
                CrDraw.DrawMode = 0 ' color mode
                CADImage.SaveCADtoBitmap(CrDraw, CD.FileName) 'deprecated, use CADImage.SaveToFileWithXMLParams
            End If
        End If
    End Sub

    Private Sub MenuItem4_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem4.Click
        CD.FileName = ""
        CD.Filter = "Jpg files (*.jpg)|*.jpg"
        If CD.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Dim box As RectangleF = CADImage.Box
            If box.Width > 0 Then
                Dim CrDraw As CADDRAW = New CADDRAW
                CrDraw.Size = Len(CrDraw) 'size of CADDRAW
                Dim r As Rectangle = Rectangle.Round(DrawRect)
                r.Offset(-r.X, -r.Y)
                CrDraw.R = New Rect(r)
                CrDraw.DrawMode = 0 ' color mode
                CADImage.SaveCADtoJpeg(CrDraw, CD.FileName) 'deprecated, use CADImage.SaveToFileWithXMLParams
            End If
        End If
    End Sub

    Private Sub MenuItem12_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem12.Click
        Dim LayersForm As Form2 = New Form2(CADImage)
        Try
            LayersForm.ShowDialog()
        Finally
            LayersForm = Nothing
        End Try
    End Sub

    Private Sub MenuItem15_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem15.Click
        If GetColor(DefaultColor, DefaultColor) Then
            CADImage.SetDefaultColor(DefaultColor)
        End If
    End Sub

    Private Function FitToWindow(ByVal ClientR As Rectangle) As RectangleF
        Dim r As RectangleF = RectangleF.FromLTRB(ClientR.Left, ClientR.Top, ClientR.Right, ClientR.Bottom)
        If Not IsEmptyCADImage() Then
            If (CADImage.Box.Width > CADImage.Box.Height) Then
                ' Recalculate a height of the drawing rectangle
                r = New RectangleF(r.Left, r.Top, r.Width, r.Width * CADImage.Box.Height / CADImage.Box.Width)
            Else
                ' Recalculate a width of the drawing rectangle
                r = New RectangleF(r.Left, r.Top, r.Height * CADImage.Box.Width / CADImage.Box.Height, r.Height)
            End If
            r.Offset((ClientR.Width - r.Width) / 2, (ClientR.Height - r.Height) / 2)
        End If
        Return r
    End Function

    Private Sub LayoutsCombo_DropDownClosed(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LayoutsCombo.DropDownClosed
        CADImage.SetCurrentLayout(LayoutsCombo.SelectedIndex)
        DrawRect = FitToWindow(panel1.ClientRectangle)
        panel1.Focus()
        panel1.Invalidate()
    End Sub

    Private Function IsEmptyCADImage() As Boolean
        If CADImage Is Nothing Then
            Return True
        Else
            Return CADImage.Empty
        End If
    End Function

    Private Sub Form1_FormClosing(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles MyBase.FormClosing
        If e.CloseReason <> CloseReason.None Then
            CloseCADImage()
        End If
    End Sub

    Private Sub MenuItemSaveAs_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItemSaveAs.Click
        If Not IsEmptyCADImage() Then
            CD.FileName = ""
            CD.Filter = "Windows Bitmap (*.bmp)|*.bmp|JPEG image (*.jpg)|*.jpg|AutoCAD DXF (*.dxf)|*.dxf|Adobe Acrobat Document (*.pdf)|*.pdf|HPGL2 (*.plt)|*.plt|Adobe Flash File Format (*.swf)|*.swf|Computer Graphics Metafile (*.cgm)|*.cgm|Scalable Vector Graphics (*.svg)|*.svg"
            If CD.ShowDialog() = DialogResult.OK Then
                Dim s_ext As String = System.IO.Path.GetExtension(CD.FileName)
                Dim r As Rectangle

                If s_ext = ".bmp" Or s_ext = ".gif" Or s_ext = ".png" Or s_ext = ".jpg" Or s_ext = ".jpeg" Then
                    r = Rectangle.Round(DrawRect)
                    r.Offset(-r.X, -r.Y)
                Else
                    r = Rectangle.Round(CADImage.Box)
                End If



#If SERIALIZED_XML_PARAMS = 1 Then
                Dim exportParams As ExportParams = New ExportParams()
                exportParams.Version = "1.0"
                exportParams.FileName = CD.FileName
                exportParams.Ext = s_ext

                exportParams.CADParametrs.XScale = 1
                exportParams.CADParametrs.ColorBackground = Color.White
                exportParams.CADParametrs.ColorDefault = Color.Black

                'enum PixelFormat {pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom};
                exportParams.GraphicParametrs.PixelFormat = 6 'pf24bit
                exportParams.GraphicParametrs.DrawMode = DrawMode.Normal
                exportParams.GraphicParametrs.Width = CInt(r.Width)
                exportParams.GraphicParametrs.Height = CInt(r.Height)
                exportParams.GraphicParametrs.DrawRect = New Rect(r)

                Dim xmlExportParamsString As String = exportParams.ToString()
#Else
                Dim graphicParams As String = String.Format("<GraphicParametrs><PixelFormat>6</PixelFormat><Width>{0}</Width><Height>{1}</Height><DrawMode>0</DrawMode><DrawRect Left=""0"" Top=""0"" Right=""{2}"" Bottom=""{3}""/></GraphicParametrs>", CInt(r.Width), CInt(r.Height), CInt(r.Width), CInt(r.Height))
                Dim cadParams As String = String.Format("<CADParametrs><BackgroundColor>{0}</BackgroundColor><DefaultColor>{1}</DefaultColor><XScale>1</XScale></CADParametrs>", ColorTranslator.ToWin32(Color.White), ColorTranslator.ToWin32(Color.Black))
                Dim xmlExportParamsString As String = String.Format("<?xml version=""1.0"" encoding=""utf-16"" ?><ExportParams><Filename>{0}</Filename><Ext>{1}</Ext>" + cadParams + graphicParams + "</ExportParams>", CD.FileName, s_ext)
#End If
                Try
                    CADProgressBar.Value = 0
                    CADProgressBar.Visible = True
                    If (CADImage.SaveToFileWithXMLParams(xmlExportParamsString) = 0) Then
                        Dim msg As String = New String(" ", 260)
                        CADImageLib.GetLastErrorCAD(msg, 256)
                        MessageBox.Show(msg, "CAD DLL Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Else
                        MessageBox.Show("File saved as: " + CD.FileName, "", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    End If
                Finally
                    CADProgressBar.Visible = False
                End Try
            End If
        End If
    End Sub

    Private Sub CADImage_Progress(ByVal sender As System.Object, ByVal e As CADImageEventsArgs) Handles CADImage.Progress
        If e.PercentDone <= 100 Then
            CADProgressBar.Value = e.PercentDone
        Else
            CADProgressBar.Value = 100
        End If

        e.Result = 0
    End Sub

    Private Function GetColor(ByVal ColorIn As Color, ByRef ColorOut As Color) As Boolean
        Me.ColorDialog1.AllowFullOpen = True
        Me.ColorDialog1.AnyColor = False
        Me.ColorDialog1.Color = ColorIn
        Me.ColorDialog1.CustomColors = Nothing
        Me.ColorDialog1.FullOpen = False
        Me.ColorDialog1.ShowHelp = True
        Me.ColorDialog1.SolidColorOnly = False
        Dim result As Boolean = Me.ColorDialog1.ShowDialog() = DialogResult.OK
        If result Then
            ColorOut = Me.ColorDialog1.Color
        End If
        Return result
    End Function

    Private Sub MenuItemBackColor_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItemBackColor.Click
        Dim newcolor As Color
        If GetColor(panel1.BackColor, newcolor) Then
            panel1.BackColor = Me.ColorDialog1.Color
        End If
    End Sub

    Private Sub Form1_Resize(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        DrawRect = FitToWindow(panel1.ClientRectangle)
        panel1.Invalidate()
    End Sub
End Class