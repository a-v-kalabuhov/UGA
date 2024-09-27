using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CADDLLWrapper;

namespace CADDLLDemoASP
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public Int32 OnProgressChange(byte nPercentDone)
        {
            return 0;
        }

        protected void buttonLoad_Click(object sender, EventArgs e)
        {
            int sourceLength = fileCAD.PostedFile.ContentLength;
            if (sourceLength == 0)
                return;
            byte[] sourceFile = new byte[sourceLength];
            int byteReaded = fileCAD.PostedFile.InputStream.Read(sourceFile, 0, sourceLength);
            string swfExt = ".svg";
            string swfName = Guid.NewGuid().ToString() + swfExt;
            string swfPath = "~/" + swfName;
            CADImage.ConverterResult result = CADImage.ConvertCADFromMemory(ref sourceFile, System.IO.Path.GetExtension(fileCAD.FileName), Server.MapPath(swfPath), "", OnProgressChange);
            if (result != CADImage.ConverterResult.Success)
                return;
            //Response.Redirect(swfPath);
            Response.Redirect("~/ShowFlash.aspx?file=" + swfName);
        }
    }
}