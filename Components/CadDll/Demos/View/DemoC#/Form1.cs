using System;
using System.Drawing;
using System.Collections;
using System.Drawing.Imaging;
using System.Windows.Forms;
using System.Text;
using System.Runtime.InteropServices;
using System.Xml;
using System.Xml.Serialization;
using CADDLL;

namespace CADImageDemoCS
{
	public class fmCADImage : System.Windows.Forms.Form
	{
		private const long FILE_SHARE_READ = 0x00000001;
		private const long CREATE_NEW = 1;
		private const long OPEN_EXISTING = 3;
		private const long GENERIC_READ = 0x80000000;
		private const long GENERIC_WRITE = 0x40000000;
		private const long CREATE_ALWAYS = 2;
		private const long FILE_ATTRIBUTE_NORMAL = 0x00000080;

        private static ProgressProc OnCADProgress = new ProgressProc(CADProgress);

		private System.Windows.Forms.OpenFileDialog dlgOpenFile;
		private System.Windows.Forms.Panel panel1;
		private lForm layerForm = new lForm();
        private IntPtr CADFile = new IntPtr();
		private RectangleF DrawRect = new RectangleF();
        private PointF DownPoint = new PointF();
        private bool Down = false;
        private Color defaultColor = Color.Black;
        private Color backgroundColor = Color.White;
        private static float absWidth, absHeight;
        private static int layoutsCount;

		internal System.Windows.Forms.MainMenu MainMenu1;
		internal System.Windows.Forms.MenuItem MenuItem1;
		internal System.Windows.Forms.MenuItem miLoad;
		internal System.Windows.Forms.MenuItem miSaveAsBMP;
		internal System.Windows.Forms.MenuItem miSaveAsJPG;
        internal System.Windows.Forms.MenuItem miExit;
        internal System.Windows.Forms.MenuItem MenuItem2;
        internal System.Windows.Forms.SaveFileDialog dlgSaveFile;
        private MenuItem miSaveAs;
        private ProgressBar progressBar;
        private static ProgressBar staticProgressBar = null;
        private MenuItem toolStripSeparator3;
        private MenuItem toolStripSeparator1;
        private ToolStrip toolStrip1;
        private ToolStripComboBox toolStripComboBox1;
        private MenuItem miClose;
        private MenuItem toolStripSeparator2;
        private MenuItem miView;
        private MenuItem miBlackWhite;
        private MenuItem toolStripSeparator4;
        private MenuItem miSetDefaultColor;
        private MenuItem miSetBGColor;
        private ColorDialog colorDialog1;
        private System.ComponentModel.IContainer components;

		public fmCADImage()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();
			this.MouseWheel += new MouseEventHandler(MouseZoom);

            sgUtils.InitSHX();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}
		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(fmCADImage));
            this.dlgOpenFile = new System.Windows.Forms.OpenFileDialog();
            this.panel1 = new System.Windows.Forms.Panel();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.MainMenu1 = new System.Windows.Forms.MainMenu(this.components);
            this.MenuItem1 = new System.Windows.Forms.MenuItem();
            this.miLoad = new System.Windows.Forms.MenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.MenuItem();
            this.miClose = new System.Windows.Forms.MenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.MenuItem();
            this.miSaveAsBMP = new System.Windows.Forms.MenuItem();
            this.miSaveAsJPG = new System.Windows.Forms.MenuItem();
            this.miSaveAs = new System.Windows.Forms.MenuItem();
            this.toolStripSeparator3 = new System.Windows.Forms.MenuItem();
            this.miExit = new System.Windows.Forms.MenuItem();
            this.miView = new System.Windows.Forms.MenuItem();
            this.miBlackWhite = new System.Windows.Forms.MenuItem();
            this.toolStripSeparator4 = new System.Windows.Forms.MenuItem();
            this.miSetDefaultColor = new System.Windows.Forms.MenuItem();
            this.miSetBGColor = new System.Windows.Forms.MenuItem();
            this.MenuItem2 = new System.Windows.Forms.MenuItem();
            this.dlgSaveFile = new System.Windows.Forms.SaveFileDialog();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.toolStripComboBox1 = new System.Windows.Forms.ToolStripComboBox();
            this.colorDialog1 = new System.Windows.Forms.ColorDialog();
            this.panel1.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // dlgOpenFile
            // 
            this.dlgOpenFile.DefaultExt = "*.dxf";
            this.dlgOpenFile.Filter = resources.GetString("dlgOpenFile.Filter");
            this.dlgOpenFile.RestoreDirectory = true;
            this.dlgOpenFile.Title = "Open File";
            // 
            // panel1
            // 
            this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.panel1.AutoScroll = true;
            this.panel1.BackColor = System.Drawing.Color.White;
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel1.Controls.Add(this.progressBar);
            this.panel1.Location = new System.Drawing.Point(0, 26);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(784, 513);
            this.panel1.TabIndex = 4;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            this.panel1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.panel1_MouseDown);
            this.panel1.MouseMove += new System.Windows.Forms.MouseEventHandler(this.panel1_MouseMove);
            this.panel1.MouseUp += new System.Windows.Forms.MouseEventHandler(this.panel1_MouseUp);
            // 
            // progressBar
            // 
            this.progressBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.progressBar.Location = new System.Drawing.Point(-2, 487);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(784, 24);
            this.progressBar.TabIndex = 0;
            this.progressBar.Visible = false;
            // 
            // MainMenu1
            // 
            this.MainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
            this.MenuItem1,
            this.miView,
            this.MenuItem2});
            // 
            // MenuItem1
            // 
            this.MenuItem1.Index = 0;
            this.MenuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
            this.miLoad,
            this.toolStripSeparator1,
            this.miClose,
            this.toolStripSeparator2,
            this.miSaveAsBMP,
            this.miSaveAsJPG,
            this.miSaveAs,
            this.toolStripSeparator3,
            this.miExit});
            this.MenuItem1.Text = "File";
            // 
            // miLoad
            // 
            this.miLoad.Index = 0;
            this.miLoad.Text = "Load...";
            this.miLoad.Click += new System.EventHandler(this.button1_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Index = 1;
            this.toolStripSeparator1.Text = "-";
            // 
            // miClose
            // 
            this.miClose.Enabled = false;
            this.miClose.Index = 2;
            this.miClose.Text = "Close";
            this.miClose.Click += new System.EventHandler(this.miClose_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Index = 3;
            this.toolStripSeparator2.Text = "-";
            // 
            // miSaveAsBMP
            // 
            this.miSaveAsBMP.Enabled = false;
            this.miSaveAsBMP.Index = 4;
            this.miSaveAsBMP.Text = "Save as BMP";
            this.miSaveAsBMP.Click += new System.EventHandler(this.miSaveAsBMP_Click);
            // 
            // miSaveAsJPG
            // 
            this.miSaveAsJPG.Enabled = false;
            this.miSaveAsJPG.Index = 5;
            this.miSaveAsJPG.Text = "Save as JPG";
            this.miSaveAsJPG.Click += new System.EventHandler(this.miSaveAsJPG_Click);
            // 
            // miSaveAs
            // 
            this.miSaveAs.Enabled = false;
            this.miSaveAs.Index = 6;
            this.miSaveAs.Text = "Save as...";
            this.miSaveAs.Click += new System.EventHandler(this.miSaveAs_Click);
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Index = 7;
            this.toolStripSeparator3.Text = "-";
            // 
            // miExit
            // 
            this.miExit.Index = 8;
            this.miExit.Text = "Exit";
            this.miExit.Click += new System.EventHandler(this.miExit_Click);
            // 
            // miView
            // 
            this.miView.Index = 1;
            this.miView.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
            this.miBlackWhite,
            this.toolStripSeparator4,
            this.miSetDefaultColor,
            this.miSetBGColor});
            this.miView.Text = "View";
            // 
            // miBlackWhite
            // 
            this.miBlackWhite.Enabled = false;
            this.miBlackWhite.Index = 0;
            this.miBlackWhite.Text = "Black-and-white";
            this.miBlackWhite.Click += new System.EventHandler(this.miBlackWhite_Click);
            // 
            // toolStripSeparator4
            // 
            this.toolStripSeparator4.Index = 1;
            this.toolStripSeparator4.Text = "-";
            // 
            // miSetDefaultColor
            // 
            this.miSetDefaultColor.Enabled = false;
            this.miSetDefaultColor.Index = 2;
            this.miSetDefaultColor.Text = "Set default color...";
            this.miSetDefaultColor.Click += new System.EventHandler(this.miSetDefaultColor_Click);
            // 
            // miSetBGColor
            // 
            this.miSetBGColor.Enabled = false;
            this.miSetBGColor.Index = 3;
            this.miSetBGColor.Text = "Set background color...";
            this.miSetBGColor.Click += new System.EventHandler(this.miSetBGColor_Click);
            // 
            // MenuItem2
            // 
            this.MenuItem2.Index = 2;
            this.MenuItem2.Text = "Layers";
            this.MenuItem2.Click += new System.EventHandler(this.button2_Click);
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripComboBox1});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(784, 25);
            this.toolStrip1.TabIndex = 5;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // toolStripComboBox1
            // 
            this.toolStripComboBox1.Name = "toolStripComboBox1";
            this.toolStripComboBox1.Size = new System.Drawing.Size(200, 25);
            this.toolStripComboBox1.DropDownClosed += new System.EventHandler(this.toolStripComboBox1_DropDownClosed);
            // 
            // fmCADImage
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(784, 543);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.panel1);
            this.Menu = this.MainMenu1;
            this.Name = "fmCADImage";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "CAD DLL - Viewer [C# Demo]";
            this.Closing += new System.ComponentModel.CancelEventHandler(this.Form1_Closing);
            this.Resize += new System.EventHandler(this.fmCADImage_Resize);
            this.panel1.ResumeLayout(false);
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new fmCADImage());
		}

        private void CloseCADImage()
        {
            toolStripComboBox1.Items.Clear();
            toolStripComboBox1.Text = "";
            if (CADFile != IntPtr.Zero)
            {
                try
                {
                    DLLWin32Import.CloseCAD(CADFile);
                }
                finally
                {
                    CADFile = IntPtr.Zero;
                }
            }  
        }

        private Color SetColorWithDialog(Color color)
        {
            colorDialog1.Color = color;
            if (colorDialog1.ShowDialog() == DialogResult.OK)
            {
                if (color == defaultColor)
                {
                    defaultColor = colorDialog1.Color;
                    return defaultColor;
                }
                if (color == backgroundColor)
                {
                    backgroundColor = colorDialog1.Color;
                    return backgroundColor;
                }
            }
            return color;
        }

        private void SetEnabledControls(bool enabled)
        {
            panel1.Visible = enabled;
            miClose.Enabled = enabled;
            miSaveAsBMP.Enabled = enabled;
            miSaveAsJPG.Enabled = enabled;
            miSaveAs.Enabled = enabled;
            miBlackWhite.Enabled = enabled;
            miSetDefaultColor.Enabled = enabled;
            miSetBGColor.Enabled = enabled;
        }

		private void button1_Click(object sender, System.EventArgs e)
		{	
            if (dlgOpenFile.ShowDialog() == DialogResult.OK)
            {
                CloseCADImage();
                CADFile = DLLWin32Import.CreateCAD(panel1.Handle, dlgOpenFile.FileName);
                if (CADFile != IntPtr.Zero)
                {
                    DLLWin32Import.SetCADBorderType(CADFile, 0);
                    DLLWin32Import.SetCADBorderSize(CADFile, 0);

                    DLLWin32Import.GetBoxCAD(CADFile, ref absWidth, ref absHeight);
                    DrawRect = FitToWindow(panel1.ClientRectangle);
                    layoutsCount = DLLWin32Import.CADLayoutsCount(CADFile);
                    for (int i = 0; i < layoutsCount; i++)
                    {
                        string str = new string(' ', 256);
                        DLLWin32Import.CADLayoutName(CADFile, i, str, str.Length);
                        toolStripComboBox1.Items.Add(str);
                    }
                    int layoutIndex = DLLWin32Import.DefaultLayoutIndex(CADFile);
                    toolStripComboBox1.Text = (string)toolStripComboBox1.Items[layoutIndex];
                    SetEnabledControls(true);
                    panel1.Invalidate();
                }
                else
                {
                    string ErrMsg = new string(new char[256]);
                    DLLWin32Import.GetLastErrorCAD(ErrMsg, 256);
                    MessageBox.Show(ErrMsg, "CAD DLL Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
		}

		private void Form1_Closing(object sender, System.ComponentModel.CancelEventArgs e)
		{
            CloseCADImage();
		}

		private void panel1_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
            if (CADFile != IntPtr.Zero)
            {
                Rect R = new Rect(Rectangle.Round(DrawRect));
                DLLWin32Import.DrawCAD(CADFile, e.Graphics.GetHdc(), ref R);
            }
		}

		private void cbStretch_CheckedChanged(object sender, System.EventArgs e)
		{
			panel1.Invalidate();
		}

		private void fmCADImage_Resize(object sender, System.EventArgs e)
		{
            DrawRect = FitToWindow(panel1.ClientRectangle);
			panel1.Invalidate();
		}

        private RectangleF FitToWindow(Rectangle ClientR)
        {
            RectangleF r = ClientR;
            if (CADFile != null)
                r = new RectangleF(r.Left, r.Top, r.Width, r.Width * absHeight / absWidth);
            r.Offset((ClientR.Width - r.Width) / 2, (ClientR.Height - r.Height) / 2);
            return r;
        }

		private void panel1_MouseDown(object sender, System.Windows.Forms.MouseEventArgs e)
		{
			if((e.Button == MouseButtons.Right)||(e.Button == MouseButtons.Middle))
			{
                if ((e.Button == MouseButtons.Middle) && (e.Clicks == 2))
                {
                    DrawRect = FitToWindow(panel1.ClientRectangle);
                    panel1.Invalidate();
                }
                else
                {
                    DownPoint = e.Location;
                    Down = true;
                    panel1.Cursor = Cursors.Hand;
                }
			}
		}

		private void panel1_MouseMove(object sender, System.Windows.Forms.MouseEventArgs e)
		{
            if (Down)
            {
				DrawRect.Offset(e.X - DownPoint.X, e.Y - DownPoint.Y);
                DownPoint = e.Location;
                panel1.Invalidate();
			} 
  		}

		private void panel1_MouseUp(object sender, System.Windows.Forms.MouseEventArgs e)
		{
			if (((e.Button == MouseButtons.Right) || (e.Button == MouseButtons.Middle)) && Down)
            {
				panel1.Cursor = Cursors.Default;
                Down = false;
			}
		}

		private void button2_Click(object sender, System.EventArgs e)
		{
            lForm layerForm = new lForm();
            try
            {
                layerForm.CADHandle = CADFile; 
                layerForm.layerList.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.chLay_ItemCheck);
                layerForm.ShowDialog();
            }
            finally
            {
                layerForm.Dispose();
            }
		}

        private void ScaleRectangleF(Double Scale, Point Pos, ref RectangleF Rect)
        {
            Rect.Size = new SizeF((float)(Rect.Width * Scale), (float)(Rect.Height * Scale));
            Rect.Location = new PointF((float)(Rect.Left * Scale), (float)(Rect.Top * Scale));
            Rect.Offset((float)(-Pos.X * Scale), (float)(-Pos.Y * Scale));
            Rect.Offset(Pos.X, Pos.Y);
            //return;
        }

		private void MouseZoom(object sender, System.Windows.Forms.MouseEventArgs e)
		{
            Double scale;
            if (e.Delta < 0)
                scale = .8;
            else
                scale = 1.25;
            ScaleRectangleF(scale, e.Location, ref DrawRect);
			panel1.Invalidate();			
		}

		private void chLay_ItemCheck(Object sender, System.Windows.Forms.ItemCheckEventArgs e)
		{
			panel1.Invalidate();
		}

		private void miExit_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void miSaveAsBMP_Click(object sender, System.EventArgs e)
		{
			dlgSaveFile.FileName = "";
            dlgSaveFile.Filter = "Windows Bitmap (*.bmp)|*.bmp";
            if (dlgSaveFile.ShowDialog() != DialogResult.OK) return;
            CADDraw CrDraw = new CADDraw();
			CrDraw.Size = Marshal.SizeOf(CrDraw); //size of CADDRAW
			CrDraw.R = new Rect();
            CrDraw.R.Right = (int)DrawRect.Width;
            CrDraw.R.Bottom = (int)DrawRect.Height; 
			CrDraw.DrawMode = 0; // color mode
			DLLWin32Import.SaveCADtoBitmap(CADFile, ref CrDraw, dlgSaveFile.FileName);
		}

		private void miSaveAsJPG_Click(object sender, System.EventArgs e)
		{
			dlgSaveFile.FileName = "";
			dlgSaveFile.Filter = "Jpg files (*.jpg)|*.jpg";
			if (dlgSaveFile.ShowDialog() != DialogResult.OK) return;
            CADDraw CrDraw = new CADDraw();
            CrDraw.Size = Marshal.SizeOf(CrDraw); //size of CADDRAW
            CrDraw.R = new Rect();
            CrDraw.R.Right = (int)DrawRect.Width;
            CrDraw.R.Bottom = (int)DrawRect.Height;
			CrDraw.DrawMode = 0; // color mode
			DLLWin32Import.SaveCADtoJpeg(CADFile, ref CrDraw, dlgSaveFile.FileName);
		}

        private void miSaveAs_Click(object sender, EventArgs e)
        {
            dlgSaveFile.FileName = "";
            dlgSaveFile.Filter = "Windows Bitmap (*.bmp)|*.bmp|JPEG image (*.jpg)|*.jpg|AutoCAD DXF (*.dxf)|*.dxf|Adobe Acrobat Document (*.pdf)|*.pdf|HPGL2 (*.plt)|*.plt|Adobe Flash File Format (*.swf)|*.swf|Computer Graphics Metafile (*.cgm)|*.cgm|Scalable Vector Graphics (*.svg)|*.svg";
            if (dlgSaveFile.ShowDialog() != DialogResult.OK) return;
#if SERIALIZED_XML_PARAMS
            ExportParams exportParams = new ExportParams();
            exportParams.Version = "1.0";
            exportParams.FileName = dlgSaveFile.FileName;
            exportParams.Ext = System.IO.Path.GetExtension(exportParams.FileName);

            exportParams.CADParametrs.XScale = 1.0;
            exportParams.CADParametrs.ColorBackground = Color.White;
            exportParams.CADParametrs.ColorDefault = Color.Black;

            //enum PixelFormat {pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom};
            exportParams.GraphicParametrs.PixelFormat = 6; //pf24bit
            exportParams.GraphicParametrs.DrawMode = (int)drawMode.dmNormal;
            RectangleF rectF;
            if (sgUtils.IsRasterFormat(exportParams.Ext))
            {
                float koef = Math.Min(800 / absWidth, 600 / absHeight);
                exportParams.GraphicParametrs.Width = (int)(absWidth * koef);
                exportParams.GraphicParametrs.Height = (int)(absHeight * koef);
                rectF = new RectangleF(0, 0, absWidth * koef, absHeight * koef);
            }
            else
            {
                exportParams.GraphicParametrs.Width = (int)absWidth;
                exportParams.GraphicParametrs.Height = (int)absHeight;
                rectF = new RectangleF(0, 0, absWidth, absHeight);
            }
            exportParams.GraphicParametrs.DrawRect = new Rect(Rectangle.Round(rectF));

            string xmlExportParamsString = exportParams.ToString();
#else
            string graphicParams = String.Format("<GraphicParametrs><PixelFormat>6</PixelFormat><Width>{0}</Width><Height>{1}</Height><DrawMode>0</DrawMode><DrawRect Left=\"0\" Top=\"0\" Right=\"{2}\" Bottom=\"{3}\"/></GraphicParametrs>", (int)absWidth, (int)absHeight, (int)absWidth, (int)absHeight);
            string cadParams = String.Format("<CADParametrs><BackgroundColor>{0}</BackgroundColor><DefaultColor>{1}</DefaultColor><XScale>1</XScale></CADParametrs>", ColorTranslator.ToWin32(Color.White), ColorTranslator.ToWin32(Color.Black));
            string xmlExportParamsString = String.Format("<?xml version=\"1.0\" encoding=\"utf-16\" ?><ExportParams><Filename>{0}</Filename><Ext>{1}</Ext>" + cadParams + graphicParams + "</ExportParams>", dlgSaveFile.FileName, System.IO.Path.GetExtension(dlgSaveFile.FileName));
#endif
            try
            {
                progressBar.Value = 0;
                progressBar.Visible = true;
                if (DLLWin32Import.SaveCADtoFileWithXMLParams(CADFile, xmlExportParamsString, null/*OnCADProgress*/) == 0)
                {
                    string ErrMsg = new string(new char[256]);
                    DLLWin32Import.GetLastErrorCAD(ErrMsg, 256);
                    MessageBox.Show(ErrMsg, "CAD DLL Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else
                    MessageBox.Show("File saved as: " + dlgSaveFile.FileName, "", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            finally
            {
                progressBar.Visible = false;
            }
        }

        private static int CADProgress(byte PercentDone)
        {
            staticProgressBar.Value = PercentDone;
            return 0;
        }

        private void toolStripComboBox1_DropDownClosed(object sender, EventArgs e)
        {
            DLLWin32Import.CurrentLayoutCAD(CADFile, toolStripComboBox1.SelectedIndex, true);
            DrawRect = FitToWindow(panel1.ClientRectangle);
            panel1.Focus();
            panel1.Invalidate();
        }

        private void miClose_Click(object sender, EventArgs e)
        {
            CloseCADImage();
            SetEnabledControls(false);
        }

        private void miBlackWhite_Click(object sender, EventArgs e)
        {
            miBlackWhite.Checked = !miBlackWhite.Checked;
            miSetDefaultColor.Enabled = !miBlackWhite.Checked;
            miSetBGColor.Enabled = !miBlackWhite.Checked;
            DLLWin32Import.SetBlackWhite(CADFile, Convert.ToByte(miBlackWhite.Checked));
            panel1.Invalidate();
        }

        private void miSetDefaultColor_Click(object sender, EventArgs e)
        {
            DLLWin32Import.SetDefaultColor(CADFile, ColorTranslator.ToWin32(SetColorWithDialog(defaultColor)));  
            panel1.Invalidate();
        }

        private void miSetBGColor_Click(object sender, EventArgs e)
        {
            panel1.BackColor = SetColorWithDialog(backgroundColor);
            panel1.Invalidate();
        }

	}
}
