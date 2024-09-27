<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowFlash.aspx.cs" Inherits="CADDLLDemoASP.ShowFlash" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script language="javascript" type="text/javascript">
// <![CDATA[
        function getFlashObject(strName) {
            if (window.document[strName]) {
                return window.document[strName];
            }

            if (navigator.appName.indexOf("Microsoft Internet") == -1) {
                if (document.embeds && document.embeds[strName]) {
                    return document.embeds[strName];
                }
                else
                    return document.getElementById(strName);
            }
            else {
                return document.getElementById(strName);
            }

            return null;
        }

        function ZoomFlash(nZoom) {
            var flashview = getFlashObject("flashview");
            if (flashview != null) {
                var svgDoc = flashview.contentDocument.rootElement;

                if (!viewBox) {
                    var vbox = svgDoc.viewBox.baseVal;
                    viewBox = { x: vbox.x, y: vbox.y, w: vbox.width, h: vbox.height };
                }

                var w = viewBox.w;
                var h = viewBox.h;
                var mx = svgSize.w / 2;
                var my = svgSize.h / 2;
                var dw = w * nZoom * 0.05;
                var dh = h * nZoom * 0.05;
                var dx = dw * mx / svgSize.w;
                var dy = dh * my / svgSize.h;
                viewBox = { x: viewBox.x + dx, y: viewBox.y + dy, w: viewBox.w - dw, h: viewBox.h - dh };
                scale = svgSize.w / viewBox.w;
                svgDoc.setAttribute('viewBox', `${viewBox.x} ${viewBox.y} ${viewBox.w} ${viewBox.h}`);
            }
        }

        function buttonZoomIn_onclick() {
            ZoomFlash(0.8);
        }

        function buttonZoomOut_onclick() {
            ZoomFlash(-0.8); 
        }

        function buttonZoomAll_onclick() {
            ZoomFlash(0);
        }


// ]]>
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <object id="flashview" type="image/svg+xml" data="<%= swfName %>" width="750" height="750">
        </object>
        <br />
        <input id="buttonZoomIn" type="button" value="Zoom In" onclick="return buttonZoomIn_onclick()" />
        <input id="buttonZoomOut" type="button" value="Zoom Out" onclick="return buttonZoomOut_onclick()" />
        <input id="buttonZoomAll" type="button" value="Zoom All" onclick="return buttonZoomAll_onclick()" />
    </div>
    </form>
            <script type="text/javascript">
                var viewBox = null;
                const svgSize = { w: flashview.clientWidth, h: flashview.clientHeight };
                var isPanning = false;
                var startPoint = { x: 0, y: 0 };
                var endPoint = { x: 0, y: 0 };
                var scale = 1;

                function hookEvent(element, eventName, callback) {
                    if (typeof (element) == "string")
                        element = document.getElementById(element);

                    if (element == null)
                        return;

                    if (element.addEventListener) {
                        if (eventName == 'mousewheel')
                            element.addEventListener('DOMMouseScroll', callback, false);

                        element.addEventListener(eventName, callback, false);
                    } else if (element.attachEvent)
                        element.attachEvent("on" + eventName, callback);

                }

                function cancelEvent(e) {
                    e = e ? e : window.event;

                    if (e.stopPropagation)
                        e.stopPropagation();

                    if (e.preventDefault)
                        e.preventDefault();

                    e.cancelBubble = true;
                    e.cancel = true;
                    e.returnValue = false;
                    return false;
                }

                function printInfo(e) {
                    e = e ? e : window.event;
                    var raw = e.detail ? e.detail : e.wheelDelta;
                    var normal = e.detail ? e.detail * -1 : e.wheelDelta / 40;

                    //document.getElementById('scrollContent').innerHTML = "<br/>&nbsp;Raw Value: " + raw + "<br/>&nbsp;Normalized Value: " + normal; cancelEvent(e); }

                    if (raw > 0)
                        ZoomFlash(75);

                    if (raw < 0)
                        ZoomFlash(150);
                }

                hookEvent('flashview', 'mousewheel', printInfo);
            </script>
</body>
</html>
