using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using CADDLL;

namespace CADImageDemoCS
{
	/// <summary>
	/// Summary description for lForm.
	/// </summary>
	public class lForm : System.Windows.Forms.Form
	{
        private IntPtr cadHandle = IntPtr.Zero;
		public System.Windows.Forms.CheckedListBox layerList;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		public ArrayList layers = new ArrayList();

		public lForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

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
				if(components != null)
				{
					components.Dispose();
				}
                layers.Clear();
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
            this.layerList = new System.Windows.Forms.CheckedListBox();
            this.SuspendLayout();
            // 
            // layerList
            // 
            this.layerList.CheckOnClick = true;
            this.layerList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.layerList.Location = new System.Drawing.Point(0, 0);
            this.layerList.Name = "layerList";
            this.layerList.Size = new System.Drawing.Size(216, 319);
            this.layerList.TabIndex = 0;
            this.layerList.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.layerList_ItemCheck);
            // 
            // lForm
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(216, 320);
            this.Controls.Add(this.layerList);
            this.Name = "lForm";
            this.Text = "Layers";
            this.ResumeLayout(false);

		}
		#endregion

        public IntPtr CADHandle
        {
            get { return cadHandle; }
            set
            {
                if ((value == null) || (value.Equals(IntPtr.Zero)))
                {
                    layers.Clear();
                    layerList.Items.Clear();
                    cadHandle = IntPtr.Zero;
                }
                else
                {
                    //Layers
                    int Cnt = DLLWin32Import.CADLayerCount(value);
                    int Layer;
                    CADData EData = new CADData();
                    layers.Clear();
                    layerList.Items.Clear();
                    for (int I = 0; I < Cnt; I++)
                    {
                        Layer = DLLWin32Import.CADLayer(value, I, ref EData);
                        layers.Add(Layer);
                        string name = Marshal.PtrToStringUni(EData.Text);
                        layerList.Items.Add(name, DLLWin32Import.CADVisible(value, name) == 1);
                    }
                    cadHandle = value;
                }
            }
        }

        private void layerList_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            if (e.NewValue == CheckState.Checked)
                DLLWin32Import.CADLayerVisible(((int)layers[e.Index]), 1);
            if (e.NewValue == CheckState.Unchecked)
                DLLWin32Import.CADLayerVisible(((int)layers[e.Index]), 0);
        }
	}
}
