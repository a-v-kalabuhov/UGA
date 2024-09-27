using System;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Drawing;
using CADDLL;

namespace CADImageDemoCS
{
    [Serializable]
    public class ExportParams
    {
        [XmlAttribute]
        public string Version = "1.0";
        public string FileName;
        public string Ext;
        public CADParams CADParametrs = new CADParams();
        public GraphicParams GraphicParametrs = new GraphicParams();

        public override string ToString()
        {
            string rez = "";            
            StringBuilder sb = new StringBuilder();
            try
            {
                TextWriter wr = new StringWriter(sb);
                try
                {
                    XmlSerializer serializer = new XmlSerializer(typeof(ExportParams));
                    try
                    {
                        serializer.Serialize(wr, this);
                    }
                    finally
                    {
                        serializer = null;
                    }
                }
                finally
                {
                    wr.Close();
                    wr = null;
                }
                rez = sb.ToString();
            }
            finally
            {                    
                sb = null;
            }                
            return rez;
        }
    }

    [Serializable]
    public class CADParams
    {
        public int BackgroundColor = ColorTranslator.ToWin32(Color.White);
        public int DefaultColor = ColorTranslator.ToWin32(Color.Black);
        public Double XScale = 1.0;

        [XmlIgnore]
        public Color ColorBackground
        {
            get { return ColorTranslator.FromWin32(BackgroundColor); }
            set { BackgroundColor = ColorTranslator.ToWin32(value); }
        }

        [XmlIgnore]
        public Color ColorDefault
        {
            get { return ColorTranslator.FromWin32(DefaultColor); }
            set { DefaultColor = ColorTranslator.ToWin32(value); }
        }
    }

    [Serializable]
    public class GraphicParams
    {
        public int PixelFormat = 6;
        public int Width = 800;
        public int Height = 600;
        public int DrawMode = 0;
        public Rect DrawRect = new Rect();
    }
}