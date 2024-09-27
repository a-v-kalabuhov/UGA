namespace DemoCS
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.menuStrip = new System.Windows.Forms.MenuStrip();
            this.miFile = new System.Windows.Forms.ToolStripMenuItem();
            this.miLoad = new System.Windows.Forms.ToolStripMenuItem();
            this.miClose = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.miSaveAsDXF = new System.Windows.Forms.ToolStripMenuItem();
            this.miSaveAs = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.miExit = new System.Windows.Forms.ToolStripMenuItem();
            this.miLayers = new System.Windows.Forms.ToolStripMenuItem();
            this.miOptions = new System.Windows.Forms.ToolStripMenuItem();
            this.miCurvesAsPolylines = new System.Windows.Forms.ToolStripMenuItem();
            this.toolCADEnum = new System.Windows.Forms.ToolStripMenuItem();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.chb3DFace = new System.Windows.Forms.CheckBox();
            this.chbTextAsCurves = new System.Windows.Forms.CheckBox();
            this.cbLayouts = new System.Windows.Forms.ComboBox();
            this.menuStrip.SuspendLayout();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip
            // 
            this.menuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.miFile,
            this.miLayers,
            this.miOptions});
            this.menuStrip.Location = new System.Drawing.Point(0, 0);
            this.menuStrip.Name = "menuStrip";
            this.menuStrip.Size = new System.Drawing.Size(784, 24);
            this.menuStrip.TabIndex = 0;
            // 
            // miFile
            // 
            this.miFile.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.miLoad,
            this.miClose,
            this.toolStripSeparator1,
            this.miSaveAsDXF,
            this.miSaveAs,
            this.toolStripSeparator2,
            this.miExit});
            this.miFile.Name = "miFile";
            this.miFile.Size = new System.Drawing.Size(37, 20);
            this.miFile.Text = "File";
            // 
            // miLoad
            // 
            this.miLoad.Name = "miLoad";
            this.miLoad.Size = new System.Drawing.Size(136, 22);
            this.miLoad.Text = "Load...";
            this.miLoad.Click += new System.EventHandler(this.loadMenuItem_Click);
            // 
            // miClose
            // 
            this.miClose.Name = "miClose";
            this.miClose.Size = new System.Drawing.Size(136, 22);
            this.miClose.Text = "Close";
            this.miClose.Click += new System.EventHandler(this.miClose_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(133, 6);
            // 
            // miSaveAsDXF
            // 
            this.miSaveAsDXF.Name = "miSaveAsDXF";
            this.miSaveAsDXF.Size = new System.Drawing.Size(136, 22);
            this.miSaveAsDXF.Text = "Save as DXF";
            this.miSaveAsDXF.Click += new System.EventHandler(this.miSaveAsDXF_Click);
            // 
            // miSaveAs
            // 
            this.miSaveAs.Name = "miSaveAs";
            this.miSaveAs.Size = new System.Drawing.Size(136, 22);
            this.miSaveAs.Text = "Save as...";
            this.miSaveAs.Click += new System.EventHandler(this.saveAsMenuItem_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(133, 6);
            // 
            // miExit
            // 
            this.miExit.Name = "miExit";
            this.miExit.Size = new System.Drawing.Size(136, 22);
            this.miExit.Text = "Exit";
            this.miExit.Click += new System.EventHandler(this.exitMenuItem_Click);
            // 
            // miLayers
            // 
            this.miLayers.Name = "miLayers";
            this.miLayers.Size = new System.Drawing.Size(52, 20);
            this.miLayers.Text = "Layers";
            this.miLayers.Click += new System.EventHandler(this.layersMenuItem_Click);
            // 
            // miOptions
            // 
            this.miOptions.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.miCurvesAsPolylines,
            this.toolCADEnum});
            this.miOptions.Name = "miOptions";
            this.miOptions.Size = new System.Drawing.Size(61, 20);
            this.miOptions.Text = "Options";
            // 
            // miCurvesAsPolylines
            // 
            this.miCurvesAsPolylines.Checked = true;
            this.miCurvesAsPolylines.CheckOnClick = true;
            this.miCurvesAsPolylines.CheckState = System.Windows.Forms.CheckState.Checked;
            this.miCurvesAsPolylines.Name = "miCurvesAsPolylines";
            this.miCurvesAsPolylines.Size = new System.Drawing.Size(174, 22);
            this.miCurvesAsPolylines.Text = "Curves as polylines";
            this.miCurvesAsPolylines.CheckStateChanged += new System.EventHandler(this.miCurvesAsPolylines_CheckStateChanged);
            // 
            // toolCADEnum
            // 
            this.toolCADEnum.CheckOnClick = true;
            this.toolCADEnum.Name = "toolCADEnum";
            this.toolCADEnum.Size = new System.Drawing.Size(174, 22);
            this.toolCADEnum.Text = "CADEnum";
            this.toolCADEnum.Click += new System.EventHandler(this.toolCADEnum_Click);
            // 
            // openFileDialog
            // 
            this.openFileDialog.Filter = resources.GetString("openFileDialog.Filter");
            // 
            // panel1
            // 
            this.panel1.AutoScroll = true;
            this.panel1.BackColor = System.Drawing.Color.White;
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 24);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(784, 540);
            this.panel1.TabIndex = 7;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            this.panel1.MouseMove += new System.Windows.Forms.MouseEventHandler(this.panel1_MouseMove);
            this.panel1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.panel1_MouseDown);
            this.panel1.MouseUp += new System.Windows.Forms.MouseEventHandler(this.panel1_MouseUp);
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.chb3DFace);
            this.panel2.Controls.Add(this.chbTextAsCurves);
            this.panel2.Controls.Add(this.cbLayouts);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 24);
            this.panel2.MaximumSize = new System.Drawing.Size(0, 25);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(784, 25);
            this.panel2.TabIndex = 8;
            // 
            // chb3DFace
            // 
            this.chb3DFace.AutoSize = true;
            this.chb3DFace.Location = new System.Drawing.Point(234, 5);
            this.chb3DFace.Name = "chb3DFace";
            this.chb3DFace.Size = new System.Drawing.Size(104, 17);
            this.chb3DFace.TabIndex = 2;
            this.chb3DFace.Text = "3dFace for ACIS";
            this.chb3DFace.UseVisualStyleBackColor = true;
            this.chb3DFace.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // chbTextAsCurves
            // 
            this.chbTextAsCurves.AutoSize = true;
            this.chbTextAsCurves.Location = new System.Drawing.Point(139, 5);
            this.chbTextAsCurves.Name = "chbTextAsCurves";
            this.chbTextAsCurves.Size = new System.Drawing.Size(96, 17);
            this.chbTextAsCurves.TabIndex = 1;
            this.chbTextAsCurves.Text = "Text as curves";
            this.chbTextAsCurves.UseVisualStyleBackColor = true;
            this.chbTextAsCurves.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // cbLayouts
            // 
            this.cbLayouts.FormattingEnabled = true;
            this.cbLayouts.Location = new System.Drawing.Point(12, 3);
            this.cbLayouts.Name = "cbLayouts";
            this.cbLayouts.Size = new System.Drawing.Size(121, 21);
            this.cbLayouts.TabIndex = 0;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.ClientSize = new System.Drawing.Size(784, 564);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.menuStrip);
            this.MainMenuStrip = this.menuStrip;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "CAD DLL - Import [C# Demo]";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseWheel);
            this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseUp);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseDown);
            this.Resize += new System.EventHandler(this.Form1_Resize);
            this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseMove);
            this.menuStrip.ResumeLayout(false);
            this.menuStrip.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip;
        private System.Windows.Forms.ToolStripMenuItem miFile;
        private System.Windows.Forms.ToolStripMenuItem miLoad;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripMenuItem miExit;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        internal System.Windows.Forms.SaveFileDialog saveFileDialog;
        private System.Windows.Forms.ToolStripMenuItem miSaveAs;
        private System.Windows.Forms.ToolStripMenuItem miClose;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripMenuItem miLayers;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.ToolStripMenuItem miOptions;
        private System.Windows.Forms.ToolStripMenuItem miCurvesAsPolylines;
        private System.Windows.Forms.ToolStripMenuItem miSaveAsDXF;
        private System.Windows.Forms.ToolStripMenuItem toolCADEnum;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.ComboBox cbLayouts;
        private System.Windows.Forms.CheckBox chb3DFace;
        private System.Windows.Forms.CheckBox chbTextAsCurves;


    }
}

