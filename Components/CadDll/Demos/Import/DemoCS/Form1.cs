#define USE_UNICODE_SGDLL
#define SERIALIZED_XML_PARAMS

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Drawing.Drawing2D;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Diagnostics;
using CADDLL;

namespace DemoCS
{
    public partial class Form1 : Form
    {
        private IntPtr CADFile = new IntPtr();
        private PointF DownPoint = new PointF();
        private RectangleF DrawRect = new RectangleF();
        private bool Down = false;
        private string FileName;
        private static bool use3dFaceForACIS = false;
        public static CADEnumProc DrawEntityProc = new CADEnumProc(DrawEntity);

        private static double FBoxLeft = new double();
        private static double FBoxRight = new double();
        private static double FBoxTop = new double();
        private static double FBoxBottom = new double();
        private static double FWidth = new double();
        private static double FHeight = new double();
        private static float FRatio = new float();
        private static double FOffsX = 0;
        private static double FOffsY = 0;
        private static double FScale = 1;
        private int FDownPosX;
        private int FDownPosY;

        public Form1()
        {
            InitializeComponent();
            sgUtils.InitSHX();
            toolCADEnum.Checked = true;
        }

        public static Point GetPoint(CADPoint Point)
        {
            Point point = new Point(0, 0);
            point.X = (int)(FOffsX + (Point.X - FBoxLeft) / FScale);
            point.Y = (int)(FOffsY + (FBoxTop - Point.Y) / FScale);
            return point;
        }

        private void CloseCADFile()
        {
            cbLayouts.Items.Clear();
            cbLayouts.Text = "";
            if (CADFile != IntPtr.Zero)
            {
                DLLWin32Import.CADClose(CADFile);
                CADFile = IntPtr.Zero;
            }
            FBoxLeft = 0;
            FBoxRight = 0;
            FBoxTop = 0;
            FBoxBottom = 0;
            FOffsX = 0;
            FOffsY = this.menuStrip.Height;
            FHeight = 1;
            FWidth = 1;
        }

        private void ZoomExtents()
        {
            double scalew, scaleh;
            scalew = (FBoxRight - FBoxLeft) / (this.ClientRectangle.Width);
            scaleh = (FBoxTop - FBoxBottom) / (this.ClientRectangle.Height);
            if ((scalew * this.ClientRectangle.Height) > (scaleh * this.ClientRectangle.Width))
                FScale = scalew;
            else
                FScale = scaleh;
            FOffsX = 0;
            FOffsY = this.menuStrip.Height;
            Invalidate();
        }

        private RectangleF FitToWindow(Rectangle ClientR)
        {
            float vD, vdX, vdY, vHWRatio;
            vHWRatio = (float)(FHeight / FWidth);
            RectangleF r = new RectangleF(ClientR.Location, ClientR.Size);
                
              vD = (r.Right - r.Left) * vHWRatio;
              if (vD > (r.Bottom - r.Top)) 
              {
                  r.Width = (float)((r.Bottom - r.Top) / vHWRatio);
              }
              else
              {
                 r.Height = vD;
              }
              vdX = ((ClientR.Right - ClientR.Left) - (r.Right - r.Left)) / 2;
              vdY = ((ClientR.Bottom - ClientR.Top) - (r.Bottom - r.Top)) / 2;
              r.Location = new PointF(r.Left + vdX, r.Top + vdY);
            return r;
        }

        private void loadMenuItem_Click(object sender, EventArgs e)
        {
            if (openFileDialog.ShowDialog(this) == DialogResult.OK)
            {    
                CloseCADFile();
                FileName = System.IO.Path.GetFileNameWithoutExtension(openFileDialog.FileName);
                CADFile = DLLWin32Import.CADCreate(Handle, openFileDialog.FileName);
                if (CADFile != IntPtr.Zero)
                {
                    DLLWin32Import.CADGetBox(CADFile, ref FBoxLeft, ref FBoxRight, ref FBoxTop, ref FBoxBottom);
                    FWidth = FBoxRight - FBoxLeft;
                    FHeight = FBoxTop - FBoxBottom;
                    FRatio = (float)(FWidth / FHeight);
                    if ((FRatio >= 1) && (FWidth > 5000))
                    {
                        FWidth = 5000;
                        FHeight = FWidth / FRatio;
                        FRatio = (float)(FWidth / FHeight);
                    }
                    if ((FRatio < 1) && (FHeight > 5000))
                    {
                        FHeight = 5000;
                        FWidth = FHeight * FRatio;
                        FRatio = (float)(FWidth / FHeight);
                    }
                    int count = DLLWin32Import.CADLayoutCount(CADFile);
                    for (int i = 0; i < count; i++)
                    {
                        string str = new string(' ', 256);
                        DLLWin32Import.CADLayoutName(CADFile, i, str, str.Length);
                        cbLayouts.Items.Add(str);
                    }
                    DLLWin32Import.CADProhibitCurvesAsPoly(CADFile, 1);
                    cbLayouts.Text = cbLayouts.Items[0].ToString();
                    DrawRect = FitToWindow(panel1.ClientRectangle);
                    ZoomExtents();
                    panel1.Invalidate();
                }
            }
        }

        private void exitMenuItem_Click(object sender, EventArgs e)
        {
            CloseCADFile();
            Application.Exit();
        }

        public static void DrawEntity(ref CADData EntData, IntPtr Param)
        {
            Color entityColor = ColorTranslator.FromWin32(EntData.Color);
            Pen pen = new Pen(entityColor);
            pen.DashStyle = (DashStyle)(EntData.Style);
            SolidBrush solidBrush = new SolidBrush(entityColor);
            PaintEventArgs e = (PaintEventArgs)Marshal.GetObjectForIUnknown(Param);
            switch (EntData.Tag)
            {
                case DLLWin32Import.CAD_3DFACE: 
                    {
                        if (!use3dFaceForACIS) break;
                        Point[] facePts = new Point[4];
                        facePts[0] = GetPoint(EntData.Point);
                        facePts[1] = GetPoint(EntData.Point1);
                        facePts[2] = GetPoint(EntData.Point2);
                        facePts[3] = GetPoint(EntData.Point3);
                        e.Graphics.DrawPolygon(pen, facePts);
                        break;
                    }
                case DLLWin32Import.CAD_LINE:
                    e.Graphics.DrawLine(pen, GetPoint(EntData.Point), GetPoint(EntData.Point1));
                    break;
                case DLLWin32Import.CAD_CIRCLE:
                    {
                        Point center = GetPoint(EntData.Point);
                        Rectangle rect = new Rectangle();
                        rect.X = center.X - (int)EntData.Radius;
                        rect.Y = center.Y - (int)EntData.Radius;
                        rect.Width = (int)(EntData.Radius * 2);
                        rect.Height = (int)(EntData.Radius * 2);
                        e.Graphics.DrawEllipse(pen, rect);
                        break;
                    }
                case DLLWin32Import.CAD_ARC:
                    {
                        double ratio = EntData.Ratio;
                        Point center = GetPoint(EntData.Point);
                        CADPoint p1 = new CADPoint(EntData.Point.X + EntData.Point1.X, EntData.Point.Y + EntData.Point1.Y, 0);
                        Point point1 = GetPoint(p1);

                        double majorLength = Math.Sqrt(Math.Pow((point1.X - center.X), 2) + Math.Pow((point1.Y - center.Y), 2));
                        Rectangle rect = new Rectangle();
                        rect.X = center.X - (int)majorLength;
                        rect.Y = center.Y - (int)(majorLength * ratio);
                        rect.Width = (int)majorLength * 2;
                        rect.Height = (int)(majorLength * ratio) * 2;

                        float startAngle = 360 - (float)EntData.EndAngle;
                        float sweepAngle = (float)(EntData.EndAngle - EntData.StartAngle);

                        e.Graphics.DrawArc(pen, rect, startAngle, sweepAngle);
                        break;
                    }
                case DLLWin32Import.CAD_POLYLINE:
                case DLLWin32Import.CAD_LWPOLYLINE:
                    if (EntData.Count < EntData.DashDotsCount)
                        for (int i = 0; i < EntData.DashDotsCount; i += 2)
                            e.Graphics.DrawLine(pen, GetPoint(new CADPoint(EntData.DashDots, i)), 
                                GetPoint(new CADPoint(EntData.DashDots, i + 1)));
                    else
                        if (EntData.Count > 0)
                        {
                            Point[] points = new Point[EntData.Count];
                            for (int i = 0; i < EntData.Count; i++)
                                points[i] = GetPoint(new CADPoint(EntData.Points, i));
                            e.Graphics.DrawLines(pen, points);
                        }
                    break;
                case DLLWin32Import.CAD_TEXT:
                    {
                        string text = Marshal.PtrToStringAuto(EntData.Text);
                        string fontname = Marshal.PtrToStringAuto(EntData.FontName);
                        Font font = new Font(fontname, (float)EntData.FHeight, FontStyle.Regular);
                        //e.Graphics.DrawString(text, font, solidBrush, (float)EntData.Point.X, (float)EntData.Point.Y);
                        TextRenderer.DrawText(e.Graphics, text, font, GetPoint(EntData.Point), Color.Black);
                        break;
                    }
                case DLLWin32Import.CAD_SPLINE:
                    {
                        if (EntData.Count < EntData.DashDotsCount)
                        {
                            Point[] points = new Point[EntData.DashDotsCount];
                            for (int i = 0; i < EntData.DashDotsCount; i++)
                            {
                                points[i] = GetPoint(new CADPoint(EntData.DashDots, i));

                            }
                            e.Graphics.DrawCurve(pen, points);
                        }
                        break;
                    }
            }
        }

        private void Form1_MouseWheel(object sender, MouseEventArgs e)
        {
            float mult = 3f / 2f;
            if (e.Delta > -120)
            {
                FScale = FScale / mult;
                FOffsX -= e.X ;
                FOffsY -= e.Y ;

            }
            else
            {
                FScale = FScale * mult;
                FOffsX += e.X ;
                FOffsY += e.Y ;
            }
            panel1.Refresh();
        }

        private void Form1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Middle)
                if (e.Clicks == 2)
                    ZoomExtents();
                else
                    if (Capture)
                    {
                        FDownPosX = e.X - (int)FOffsX;
                        FDownPosY = e.Y - (int)FOffsY;
                        Cursor = Cursors.Hand;
                    }
        }

        private void Form1_MouseMove(object sender, MouseEventArgs e)
        {
            if (Capture && (e.Button == MouseButtons.Middle))
            {
                FOffsX = e.X - FDownPosX;
                FOffsY = e.Y - FDownPosY;
                panel1.Refresh();
            }
        }

        private void Form1_MouseUp(object sender, MouseEventArgs e)
        {
            if (Capture && (e.Button == MouseButtons.Middle))
                Cursor = Cursors.Default;
        }

        private string sgIntPtrToString(IntPtr StrPtr)
        {
#if USE_UNICODE_SGDLL
            return Marshal.PtrToStringUni(StrPtr);
#else
            return Marshal.PtrToStringAnsi(StrPtr);
#endif
        }

        private void saveAsMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog.FileName = FileName;
            saveFileDialog.Filter = "Windows Bitmap (*.bmp)|*.bmp|JPEG image (*.jpg)|*.jpg|AutoCAD DXF (*.dxf)|*.dxf|Adobe Acrobat Document (*.pdf)|*.pdf|HPGL2 (*.plt)|*.plt|Adobe Flash File Format (*.swf)|*.swf|Computer Graphics Metafile (*.cgm)|*.cgm|Scalable Vector Graphics (*.svg)|*.svg";
            if (saveFileDialog.ShowDialog() != DialogResult.OK) return;
#if SERIALIZED_XML_PARAMS

            double ratio = 1;
            string ext = System.IO.Path.GetExtension(saveFileDialog.FileName);

            if (sgUtils.IsRasterFormat(ext))
                ratio = Math.Min(800 / FWidth, 600 / FHeight);

            ExportParams exportParams = new ExportParams();
            exportParams.Version = "1.0";
            exportParams.FileName = saveFileDialog.FileName;
            exportParams.Ext = ext;

            exportParams.CADParametrs.XScale = 1;
            exportParams.CADParametrs.ColorBackground = Color.White;
            exportParams.CADParametrs.ColorDefault = Color.Black;

            //enum PixelFormat {pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom};
            exportParams.GraphicParametrs.PixelFormat = 6; //pf24bit
            exportParams.GraphicParametrs.DrawMode = (int)drawMode.dmNormal;
            exportParams.GraphicParametrs.Width = (int)(ratio * FWidth);
            exportParams.GraphicParametrs.Height = (int)(ratio * FHeight);
            exportParams.GraphicParametrs.DrawRect.Left = 0;
            exportParams.GraphicParametrs.DrawRect.Top = 0;
            exportParams.GraphicParametrs.DrawRect.Right = (int)(ratio * FWidth);
            exportParams.GraphicParametrs.DrawRect.Bottom = (int)(ratio * FHeight);

            string xmlExportParamsString = exportParams.ToString();
#else            
            string graphicParams = String.Format("<GraphicParametrs><PixelFormat>6</PixelFormat><Width>{0}</Width><Height>{1}</Height><DrawMode>0</DrawMode><DrawRect Left=\"0\" Top=\"0\" Right=\"{2}\" Bottom=\"{3}\"/></GraphicParametrs>", (int)FWidth, (int)FHeight, (int)FWidth, (int)FHeight);
            string cadParams = String.Format("<CADParametrs><BackgroundColor>{0}</BackgroundColor><DefaultColor>{1}</DefaultColor><XScale>1</XScale></CADParametrs>", ColorTranslator.ToWin32(Color.White), ColorTranslator.ToWin32(Color.Black));
            string xmlExportParamsString = String.Format("<?xml version=\"1.0\" encoding=\"utf-16\" ?><ExportParams><Filename>{0}</Filename><Ext>{1}</Ext>" + cadParams + graphicParams + "</ExportParams>", saveFileDialog.FileName, System.IO.Path.GetExtension(saveFileDialog.FileName));
#endif
            if (DLLWin32Import.SaveCADtoFileWithXMLParams(CADFile, xmlExportParamsString, null) == 0)
            {
                string ErrMsg = new string(new char[256]);
                DLLWin32Import.GetLastErrorCAD(ErrMsg, 256);
                MessageBox.Show(ErrMsg, "\"SaveCADtoFileWithXMLParams\" Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
                MessageBox.Show("File saved as: " + saveFileDialog.FileName, "", MessageBoxButtons.OK, MessageBoxIcon.Information);  
        }

        private void miClose_Click(object sender, EventArgs e)
        {
            CloseCADFile();
            panel1.Invalidate();
        }

        private void Form1_Resize(object sender, EventArgs e)
        {
            DrawRect = FitToWindow(panel1.ClientRectangle);
            //ZoomExtents();
            panel1.Invalidate();
        }

        private void layersMenuItem_Click(object sender, EventArgs e)
        {
            Layers layersForm = new Layers();
            try
            {
                layersForm.CADHandle = CADFile;
                layersForm.ShowDialog();
            }
            finally
            {
                layersForm.Dispose();
            }
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            if (CADFile != IntPtr.Zero)
            {
                if (toolCADEnum.Checked)
                {
                    IntPtr Param = Marshal.GetIUnknownForObject(e);
                    int all =chbTextAsCurves.Checked ? 1 : 1 | (1 << 4);
                    DLLWin32Import.CADEnum(CADFile, 1 | (1 << 4), DrawEntityProc, Param);
                }
                else
                {
                    Rect R = new Rect(Rectangle.Round(DrawRect));
                    DLLWin32Import.CADDraw(CADFile, e.Graphics.GetHdc(), ref R);
                }
            }
        }

        private void miCurvesAsPolylines_CheckStateChanged(object sender, EventArgs e)
        {
            DLLWin32Import.CADProhibitCurvesAsPoly(CADFile, System.Convert.ToByte(miCurvesAsPolylines.Checked));
            DrawRect = FitToWindow(panel1.ClientRectangle);
            panel1.Invalidate();
        }

        private void panel1_MouseDown(object sender, MouseEventArgs e)
        {

            if ((e.Button == MouseButtons.Middle) && (e.Clicks == 2))
            {
                DrawRect = FitToWindow(panel1.ClientRectangle);
                panel1.Invalidate();
            }
                
            
            if (e.Button == MouseButtons.Right)
                {
                    DownPoint = e.Location;
                    Down = true;
                    panel1.Cursor = Cursors.Hand;
                }
            }

        private void panel1_MouseMove(object sender, MouseEventArgs e)
        {
            panel1.Focus();
            if (Down)
            {
                DrawRect.Offset(e.X - DownPoint.X, e.Y - DownPoint.Y);
                FOffsX+=  e.X - DownPoint.X;
                FOffsY+=  e.Y - DownPoint.Y;
                DownPoint = e.Location;
                panel1.Invalidate();
            } 
        }

        private void panel1_MouseUp(object sender, MouseEventArgs e)
        {
            if (((e.Button == MouseButtons.Right) || (e.Button == MouseButtons.Middle)) && Down)
            {
                panel1.Cursor = Cursors.Default;
                Down = false;
            }
        }

        private void cbLayouts_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (CADFile != IntPtr.Zero)
            {
                int index = cbLayouts.SelectedIndex;
                DLLWin32Import.CADLayoutCurrent(CADFile, ref index, true);
                DrawRect = FitToWindow(panel1.ClientRectangle);
                panel1.Invalidate();
            }
        }

        private void miSaveAsDXF_Click(object sender, EventArgs e)
        {
            saveFileDialog.FileName = FileName;
            saveFileDialog.Filter = "AutoCAD DXF (*.dxf)|*.dxf";
            if (saveFileDialog.ShowDialog() != DialogResult.OK) return;
            if (DLLWin32Import.CADtoDXFExport(CADFile, saveFileDialog.FileName) == 0)
            {
                string ErrMsg = new string(new char[256]);
                DLLWin32Import.GetLastErrorCAD(ErrMsg, 256);
                MessageBox.Show(ErrMsg, "\"CADtoDXFExport\" Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
                MessageBox.Show("File saved as: " + saveFileDialog.FileName, "", MessageBoxButtons.OK, MessageBoxIcon.Information);  
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            FHeight = 1;
            FWidth = 1;
        }

        private void toolCADEnum_Click(object sender, EventArgs e)
        {
            panel1.Refresh();
        }

        private void checkBox_CheckedChanged(object sender, EventArgs e)
        {
            use3dFaceForACIS = chb3DFace.Checked;
            panel1.Refresh();
        }

    }
}