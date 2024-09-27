using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CADDLLDemoASP
{
    public partial class ShowFlash : System.Web.UI.Page
    {
        public string swfName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            swfName = Request["file"];
        }
    }
}