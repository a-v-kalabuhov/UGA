using System;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using CADDLL;

namespace DemoCS
{
    public partial class Layers : Form
    {
        private IntPtr cadHandle = IntPtr.Zero;
        public ArrayList fLayers = new ArrayList();

        public Layers()
        {
            InitializeComponent();
        }

        public IntPtr CADHandle
        {
            get { return cadHandle; }
            set
            {
                if ((value == null) || (value.Equals(IntPtr.Zero)))
                {
                    fLayers.Clear();
                    listBox1.Items.Clear();
                    cadHandle = IntPtr.Zero;
                }
                else
                {
                    int count = DLLWin32Import.CADLayerCount(value);
                    IntPtr hLayer;
                    CADData EData = new CADData();
                    fLayers.Clear();
                    listBox1.Items.Clear();
                    for (int I = 0; I < count; I++)
                    {
                        hLayer = (IntPtr)DLLWin32Import.CADLayer(value, I, ref EData);
                        fLayers.Add(hLayer);
#if USE_UNICODE_SGDLL
                        string name = Marshal.PtrToStringUni(EData.Text);
#else
                        string name = Marshal.PtrToStringAnsi(EData.Text);
#endif
                        listBox1.Items.Add(name);
                    }
                }
            }
        }
    }
}