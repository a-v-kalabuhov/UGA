// CADWindow.cpp: implementation of the CCADWindow class.
//
//////////////////////////////////////////////////////////////////////

#include "CADWindow.h"
#include "resource.h"
#include <stdio.h>
#include <math.h>
#include <sg.h>
#include <TCHAR.h>
#include <comutil.h>
#include <cad.h>
#include <sginitshx.h>

CCADWindow *MainWnd = NULL;
int WINAPI CADProgress(BYTE);

#pragma warning(disable : 4996) // sprintf


#define EntitiesOnLayers _T("There are %d entities on %s layer")

#define MAX_LAYERNAME 255
LAYER Layer;
double Scales[17] = {0.001, 0.0025, 0.005, 0.01, 0.02, 0.03, 0.05, 0.1, 0.25, 0.4, 
	1.0, 2.5, 5.0, 10.0, 25.0, 50.0, 100.0};

BOOL CALLBACK LayerNameDlgProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) 
{ 
	switch (message) 
	{
		case WM_INITDIALOG:   
			SetDlgItemText(hwnd, IDC_EDIT1, (LPCTSTR)_T("BOARD"));
			return TRUE; 

		case WM_CLOSE:             
			EndDialog(hwnd, TRUE);             
			return TRUE; 

		case WM_COMMAND:             
			if(LOWORD((DWORD)wParam) == IDOK)             
			{   
				GetDlgItemText(hwnd, IDC_EDIT1, Layer.Name, MAX_LAYERNAME);
				EndDialog(hwnd, TRUE);                 
				return TRUE;             
			} 
			if(LOWORD((DWORD)wParam) == IDCANCEL)             
			{                 			
				EndDialog(hwnd, FALSE);                 
				return TRUE;             
			} 
		break;     
	}      
	return FALSE;      
} 


HWND CCADWindow::hwndProgressDlg;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CADENUM CADEnum;
CADCREATE CADCreate;
CADCLOSE CADClose;
CADIS3D CADIs3D;
CADGETLASTERROR CADGetLastError;
GETLASTERRORCAD GetLastErrorCAD;
CADPROHIBITCURESASPOLY CADProhibitCurvesAsPoly;
CADLAYOUTCURRENT CADLayoutCurrent;
CADLAYOUTNAME CADLayoutName;
CADLAYOUTCOUNT CADLayoutCount;
CADGETBOX CADGetBox;
CADSETSHXOPTIONS CADSetSHXOptions;
SAVECADTOFILEWITHXMLPARAMS SaveCADtoFileWithXMLParams;

CCADWindow::CCADWindow(LPCTSTR szClassName, WNDPROC WndProc, HINSTANCE hInst,
                 HICON hIcon, HICON hCursor, LPCTSTR lpszMenuName,
                 HBRUSH color, UINT style):
CWindow(szClassName, WndProc, hInst, hIcon, hCursor, lpszMenuName, color, style)
{
	ScaleID = ID_FITWINDOW;
	offset.x = 2;
	offset.y = TOOLBAR_HEIGHT;
	PredPoint.x = 0;
	PredPoint.y = 0;
	DrwMode = 0;
	CircleDrwMode = 0;	
	Drag = FALSE;
	Cursor = LoadCursor(WndClass.hInstance, _T("CURSOR1"));
	HInst = hInst;
	ScaleRect.x = -1;
	nIsInsideInsert = 0;
	hwndToolBar = 0;
	hwndComboBox = 0;
	hwndLayoutsLabel = 0;
	hwndStatusBar = 0;
	bDoubleBuffered = true;
	bGetArcsAsCurves = false;
	bGetTextsAsCurves = false;
	hCAD = 0;
	hCADImporter = LoadLibrary(sgLibName);
	if (hCADImporter)
	{
		CADEnum = (CADENUM) GetProcAddress(hCADImporter, "CADEnum");
		CADCreate = (CADCREATE) GetProcAddress(hCADImporter, "CADCreate");
		CADClose = (CADCLOSE) GetProcAddress(hCADImporter, "CADClose");	
		CADIs3D = (CADIS3D) GetProcAddress(hCADImporter, "CADIs3D");
		CADGetLastError = (CADGETLASTERROR) GetProcAddress(hCADImporter, "CADGetLastError");
		GetLastErrorCAD = (GETLASTERRORCAD)GetProcAddress(hCADImporter, "GetLastErrorCAD");
		CADProhibitCurvesAsPoly = (CADPROHIBITCURESASPOLY) GetProcAddress(hCADImporter, "CADProhibitCurvesAsPoly");
		CADLayoutCount = (CADLAYOUTCOUNT) GetProcAddress(hCADImporter, "CADLayoutCount");
		CADLayoutCurrent = (CADLAYOUTCURRENT) GetProcAddress(hCADImporter, "CADLayoutCurrent");
		CADLayoutName = (CADLAYOUTNAME) GetProcAddress(hCADImporter, "CADLayoutName");
		CADGetBox = (CADGETBOX) GetProcAddress(hCADImporter, "CADGetBox");
		CADSetSHXOptions = (CADSETSHXOPTIONS) GetProcAddress(hCADImporter, "CADSetSHXOptions");
		SaveCADtoFileWithXMLParams = (SAVECADTOFILEWITHXMLPARAMS) GetProcAddress(hCADImporter, "SaveCADtoFileWithXMLParams");
	}
	else
	{
		TCHAR msg[32];
		_stprintf_s(msg, 32, _T("%s%s"), sgLibName, LIB_NOT_LOADED);
		MessageBox(0, msg, WARNING_CAPTION, MB_ICONWARNING || MB_TASKMODAL);
	}

	InitSHX(CADSetSHXOptions);
}

int WINAPI CADProgress(BYTE PercentDone)
{
	TCHAR mes[ERR_MSG_LEN];
	PTCHAR done = _T("% done");
	TCHAR ProgressMsg[ERR_MSG_LEN] = _T("");
	_tcscpy_s(ProgressMsg, MainWnd->GetProgressMessage());
	_itot_s(PercentDone, mes, 10);
	_tcscat_s(ProgressMsg, mes);
	_tcscat_s(ProgressMsg, done);
	//MainWnd->SetTextToStatusBar(ProgressMsg);
	//SendMessage(MainWnd->hwndProgressDlg, 40043, (WPARAM)PercentDone, 0);
	return 0;
}
CCADWindow::~CCADWindow()
{
  if (hCADImporter)
	  FreeLibrary(hCADImporter);
}

void CCADWindow::DoCreateToolBar(HWND hwndParent, HINSTANCE hInst) 
{	

	if (!hwndToolBar)
	{
		hwndToolBar = ::CreateWindowEx(
			WS_EX_WINDOWEDGE,      
			TOOLBARCLASSNAME,
			(LPCTSTR) NULL,  
			CCS_TOP | WS_CHILD | WS_BORDER | WS_CAPTION, 
			0, 0, 0, TOOLBAR_HEIGHT,        
			hwndParent,    
			NULL,
			hInst,         
			NULL);         

		hwndLayoutsLabel = ::CreateWindowEx(
			0,      
			_T("STATIC"),
			_T("Layouts:"),  
			WS_CHILD,			 
			4, 4, LABELLAYOUTWIDTH, TOOLBAR_BUTTON_SIZE,
			hwndToolBar,
			NULL,
			hInst,
			NULL);

		::ShowWindow(hwndToolBar, SW_SHOWNORMAL);    
		::ShowWindow(hwndLayoutsLabel, SW_SHOWNORMAL); 
	}
}

void CCADWindow::DoCreateComboBox(HINSTANCE hInst) 
{	
	if (!hwndToolBar) return;
	if (hCAD) 
	{
		sgChar LayoutName[100];		
		int i, currLayout, Count;		
		Count = CADLayoutCount(hCAD);
		if (hwndComboBox) 
			DestroyWindow(hwndComboBox);		
		hwndComboBox = ::CreateWindowEx(
			0,      
			_T("COMBOBOX"),
			NULL,  
			WS_CHILD | CBS_DROPDOWNLIST,			 
			LABELLAYOUTWIDTH + 4, 4, 200, 40+COMBOBOX_ITEM_SIZE*Count,        
			hwndToolBar,    
			NULL,
			hInst,         
			NULL);
	    for (i= 0; i < Count; ++i)
	    {
			CADLayoutName(hCAD, i, &LayoutName[0], 100);
			PTCHAR layautname = sgCharToTCHAR(LayoutName);
			SendMessage(hwndComboBox, (UINT) CB_ADDSTRING, 0, (LPARAM) layautname);
			free(layautname);
		}
		CADLayoutCurrent(hCAD, (int *)&currLayout, false);
		::SendMessage(hwndComboBox, (UINT) CB_SETCURSEL, (WPARAM) currLayout, 0);
		RePaint();
		::ShowWindow(hwndComboBox, SW_SHOWNORMAL);
	}	
}

void CCADWindow::DoCreateStatusBar(HWND hwndParent, HINSTANCE hInst)
{     
	if (!hwndStatusBar)
		hwndStatusBar = ::CreateWindowEx( 
			0,                        
			STATUSCLASSNAME,          
			(LPCTSTR) NULL,           
			WS_CHILD,
			0, 0, 0, 0,               
			hwndParent,               
			NULL,                     
			hInst,                    
			NULL);                    

	SplitStatusBar(); 
	SendMessage(hwndStatusBar, SB_SETTEXT, 0, (LPARAM)NULL);
	SendMessage(hwndStatusBar, SB_SETTEXT, 1, (LPARAM)NULL);
	SendMessage(hwndStatusBar, SB_SETTEXT, 2, (LPARAM)_T("Demo")); 
	ShowWindow(hwndStatusBar, SW_SHOWNORMAL);
}

void CCADWindow::SplitStatusBar(int nParts)
{
	RECT rect; 
    HLOCAL hloc; 
    LPINT lpParts; 
    int i, nWidth; 
	
    GetClientRect(hWnd, &rect); 
    hloc = LocalAlloc(LHND, sizeof(int) * nParts); 
    lpParts = (LPINT)LocalLock(hloc);  

    nWidth = rect.right / nParts; 
    for (i = 0; i < nParts; i++) 
	{ 
        lpParts[i] = nWidth; 
        nWidth+= nWidth; 
    } 	
	
    ::SendMessage(hwndStatusBar, SB_SETPARTS, (WPARAM) nParts, (LPARAM) lpParts); 	

    LocalUnlock(hloc); 
    LocalFree(hloc);   
}

bool CCADWindow::SetCurrentLayout()
{
    int lindex = ::SendMessage(hwndComboBox, (UINT) CB_GETCURSEL, 0, 0);
    CADLayoutCurrent(hCAD, (int *)&lindex, true);
	RecalculateExtents();
	RePaint();
	return true;
}

void CCADWindow::Load()
{
	sgChar cErrorCode[ERR_MSG_LEN];
	int nErrorCode;

	PTCHAR FileName = (PTCHAR)malloc((MAX_PATH + 1) * sizeof(TCHAR));
	*FileName = 0;
	if (this->GetFile(this->hWnd, FileName, CADFilter, true))
	{
	if (hCAD) CADClose(hCAD);

	if (hCADImporter)
	{
		SendMessage(hwndStatusBar, SB_SETTEXT, 0, (LPARAM)_T("Please wait..."));
		//CADSetSHXOptions(NULL, NULL, NULL, 1, 1);// please call it before CADCreate
		PsgChar sgFileName = TCHARtosgChar(FileName);
		hCAD = CADCreate(hWnd, sgFileName);
		free(sgFileName);
		nErrorCode = CADGetLastError(cErrorCode);
		if (nErrorCode == 0)
		{
			CADProhibitCurvesAsPoly(hCAD, (int(bGetArcsAsCurves)+1)%2);// 1 => permit conversion of arcs to polyline			
			ChangeScale(ID_FITWINDOW);
			DoCreateToolBar(hWnd, HInst);
			DoCreateComboBox(HInst);
			RecalculateExtents();
			PTCHAR chr = (PTCHAR)malloc(100 * sizeof(TCHAR));
			_stprintf_s(chr, 100, _T("(%6.6f x %6.6f)\0"), fAbsWidth, fAbsHeight);
			SendMessage(hwndStatusBar, SB_SETTEXT, 0, (LPARAM)FileName);
			SendMessage(hwndStatusBar, SB_SETTEXT, 1, (LPARAM)chr);
			free(chr);
		}
		else
		{
			PTCHAR errmsg = sgCharToTCHAR(cErrorCode);
			SendMessage(hwndStatusBar, SB_SETTEXT, 0, (LPARAM)errmsg);
			switch(nErrorCode)
			{			
			case 1006:
				MessageBox(hWnd, errmsg, NULL, MB_ICONERROR);
				SendMessage(hwndStatusBar, SB_SETTEXT, 0, (LPARAM)_T("No file loaded"));
			default:
				break;
			}
			free(errmsg);
		}
		RePaint();
	}
	}
	free((void *)FileName);
}

void CCADWindow::ReSize(WPARAM wParam,LPARAM lParam)
{
	SplitStatusBar();
  	::SendMessage(hwndStatusBar, WM_SIZE, wParam, lParam);
	::SendMessage(hwndToolBar, TB_AUTOSIZE, (WPARAM)0 , (LPARAM)0);
}

void CCADWindow::Draw(HWND Window, HDC DC)
{
RECT wndrect;
PARAM s;
PAINTSTRUCT paint;

	if (hCAD)
	{
		s.hWnd = Window;
    s.hDC = DC;
    if (!DC) s.hDC = BeginPaint(Window, &paint);
		s.offset = this->offset;
		s.Scale = Scale;
		s.DrawMode = DrwMode;
		s.CircleDrawMode = CircleDrwMode;
		s.GetArcsCurves = bGetArcsAsCurves;
		s.GetTextsCurves = bGetTextsAsCurves;
		s.IsInsideInsert = &nIsInsideInsert;
		GetClientRect(hWnd, &wndrect);
		FillRect(s.hDC, &wndrect, WndClass.hbrBackground);
		SetMapMode(s.hDC, MM_ANISOTROPIC);
		SetViewportOrgEx(s.hDC, 0, 0, 0);
		CADEnum(hCAD, (int(bGetTextsAsCurves) << 3), DoDraw, &s);
    if (!DC) EndPaint(Window, &paint);
	}
}

void CCADWindow::BeginDrag(POINTS Point)
{
	if (hCAD) 
	{
		SetCapture(hWnd);
		Drag = true;
		PredPoint = Point;
		SetCursor(Cursor);
	}
}

void CCADWindow::EndDrag(POINTS Point)
{
	if (hCAD) 
	{
		ReleaseCapture();
		Drag = false;
		SetCursor(WndClass.hCursor);
	}
}

void CCADWindow::MouseMove(POINTS Point)
{
	if (Drag)
	{
		SetCursor(Cursor);
		offset.x = offset.x + Point.x - PredPoint.x;
		offset.y = offset.y + Point.y - PredPoint.y;
		PredPoint = Point;
		RePaint();
	}
}

IXMLDOMNode * AddChild(IXMLDOMNode * owner, BSTR tag, VARIANT value)
{
	IXMLDOMDocument * doc = NULL;
	IXMLDOMNode * newNode;
	WCHAR tmp[30] = L"";

	if (owner->QueryInterface(IID_IXMLDOMDocument, (void **)&doc))
		owner->get_ownerDocument(&doc);
	doc->createElement(tag, (IXMLDOMElement **)&newNode);
	owner->appendChild(newNode, &newNode);

	switch (value.vt)
	{
		case VT_BSTR:				   
			if (value.bstrVal)
				newNode->put_text(value.bstrVal);
			break;
		case VT_INT:
			_itow_s(value.intVal, tmp, sizeof(tmp) / sizeof(WCHAR), 10);
			newNode->put_text(tmp);
			break;
		case VT_R4:
			_swprintf_s_l(tmp, sizeof(tmp) / sizeof(WCHAR), L"%f", CP_ACP, value.fltVal);
			newNode->put_text(tmp);
			break;
		case VT_R8:
			_swprintf_s_l(tmp, sizeof(tmp) / sizeof(WCHAR), L"%f", CP_ACP, value.dblVal);
			newNode->put_text(tmp);
			break;
	}
	return newNode;
}

BSTR GenerateXMLParams(TCHAR * FileName, TCHAR * FileExt, 
						  const int Width, const int Height,
						  const int Left, const int Top,
						  const int Right, const int Bottom,
						  const int DefaultColor, const int Background)
{
	CLSID MSXMLDOMDocementCLSID;
	BSTR result;
	IXMLDOMNode * graphicsParams = NULL;
	IXMLDOMNode * cadParametrs = NULL;
	IXMLDOMElement * drawRect = NULL;
	IXMLDOMElement * docElem = NULL;
	IXMLDOMDocument * xmlExportParams = NULL;
	IXMLDOMProcessingInstruction * ProcessingInstruction = NULL;
	VARIANT null = variant_t();
	::CoInitialize(NULL);

	HRESULT hr = S_FALSE;
	int i = 0;
	do{
		if (CLSIDFromProgID(MSXMLDOMDocProgIds[i], &MSXMLDOMDocementCLSID) == S_OK)
			hr = CoCreateInstance(MSXMLDOMDocementCLSID, NULL, CLSCTX_INPROC_SERVER || CLSCTX_LOCAL_SERVER, 
				IID_IDispatch, (LPVOID *)&xmlExportParams);
	}while ((i++ < XMLPROGIDSCOUNT) && (hr != S_OK));
	if (hr != S_OK) return NULL;
	
	xmlExportParams->createProcessingInstruction(L"xml", L"version=\"1.0\" encoding=\"utf-8\"", &ProcessingInstruction);
	xmlExportParams->appendChild(ProcessingInstruction, (IXMLDOMNode **)&ProcessingInstruction);
	AddChild(xmlExportParams, L"ExportParams", null);
	xmlExportParams->get_documentElement(&docElem);
	docElem->setAttribute(L"version", _variant_t("1.0"));

	AddChild(docElem, L"Filename", _variant_t(FileName));
	AddChild(docElem, L"Ext", _variant_t(FileExt));

	graphicsParams = AddChild(docElem, L"GraphicParametrs", null);
	//enum PixelFormat {pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom};
	AddChild(graphicsParams, L"PixelFormat", _variant_t(6)); // int(pf24bit)
	AddChild(graphicsParams, L"Width", _variant_t(Width));
	AddChild(graphicsParams, L"Height", _variant_t(Height));
	AddChild(graphicsParams, L"DrawMode", _variant_t((int)dmNormal));
	
	drawRect = (IXMLDOMElement *)AddChild(graphicsParams, L"DrawRect", null);
	drawRect->setAttribute(L"Left", _variant_t(Left));
	drawRect->setAttribute(L"Top", _variant_t(Top));
	drawRect->setAttribute(L"Right", _variant_t(Right));
	drawRect->setAttribute(L"Bottom", _variant_t(Bottom));

	cadParametrs = AddChild(docElem, L"CADParametrs", null);
	AddChild(cadParametrs, L"XScale", _variant_t(1));
	AddChild(cadParametrs, L"BackgroundColor", _variant_t(Background));
	AddChild(cadParametrs, L"DefaultColor", _variant_t(DefaultColor));
   
	xmlExportParams->get_xml(&result);
	
	graphicsParams = NULL;
	drawRect = NULL;
	docElem = NULL;
    xmlExportParams = NULL;
	CoUninitialize();
	return result;
}

void CCADWindow::SaveAs()
{	
	if (!hCAD)
		return;
	PTCHAR FileName = (PTCHAR)malloc((MAX_PATH + 1) * sizeof(TCHAR));
	*FileName = 0;
	if (this->GetFile (this->hWnd, FileName, SaveAsFilter, false))
	{
		RePaint();
		TCHAR * ext;
		int i = _tcslen(FileName);
		for (i = _tcslen(FileName); ((i >= 0) && (FileName[i] != _T('.'))); i--);
		if (i <= 0)
			ext = NULL;
		else
			ext = (TCHAR *)(&FileName[i]);
		double L, T, R, B, W, H, ratio;
		CADGetBox(hCAD, &L, &R, &T, &B);
		W = R - L;
		if (W == 0) W = 1;
		H = T - B;
		if (H == 0) H = 1;
		if (IsRasterFormat(ext))
		{
			ratio = min(800/W, 600/H);
			W *= ratio;
			H *= ratio;
		}
		else
		{
			ratio = W / H;
			if ((ratio >= 1) && (W > 5000))
			{
				W = 5000;
				H = W / ratio;
			}
			if ((ratio < 1) && (H > 5000))
			{
				H = 5000;
				W = H * ratio;
			}
		}
#ifdef GENERATE_XML_PARAMS
		BSTR xmlExportParams = GenerateXMLParams(FileName, ext, (int)W, (int)H, 0, 0, (int)W, (int)H, 0, colorBgrnd);
#else		
		TCHAR * graphicParams = (TCHAR *)malloc(1024 * sizeof(TCHAR));
		TCHAR * cadParams = (TCHAR *)malloc(1024 * sizeof(TCHAR));
		TCHAR * exportParams = (TCHAR *)malloc(1024 * sizeof(TCHAR));
		_stprintf_s(graphicParams, 1024, _T("<GraphicParametrs><PixelFormat>6</PixelFormat><Width>%i</Width><Height>%i</Height><DrawMode>0</DrawMode><DrawRect Left=\"0\" Top=\"0\" Right=\"%i\" Bottom=\"%i\"/></GraphicParametrs>"), (int)W, (int)H, (int)W, (int)H);
		_stprintf_s(cadParams, 1024, _T("<CADParametrs><BackgroundColor>%i</BackgroundColor><DefaultColor>%i</DefaultColor><XScale>1</XScale></CADParametrs>"), (int)colorBgrnd, (int)0);
		_stprintf_s(exportParams, 1024, _T("<?xml version=\"1.0\" encoding=\"utf-16\" ?><ExportParams><Filename>%s</Filename><Ext>%s</Ext>%s%s</ExportParams>"), FileName, ext, cadParams, graphicParams);
		PTCHAR xmlExportParams = exportParams;
#endif
		PsgChar xmlExParam;
		
#ifdef USE_UNICODE_SGDLL
		xmlExParam = (PsgChar)xmlExportParams;
#else
		xmlExParam = _com_util::ConvertBSTRToString(xmlExportParams);
#endif
		TCHAR msg[1024];
		memset(msg, 0, sizeof(msg));
		if (!SaveCADtoFileWithXMLParams(hCAD, xmlExParam, NULL))
		{			
			GetLastErrorCAD((PsgChar)msg, sizeof(msg));
    		MessageBox(hWnd, msg, ERROR_CAPTION, MB_ICONERROR);
		}
		else
		{
			_stprintf_s(msg, 1024, _T("File saved as: %s"), FileName);
			MessageBox(hWnd, msg, _T(""), MB_ICONINFORMATION);
		}
		free(graphicParams);
		free(cadParams);
		free(exportParams);
#ifndef USE_UNICODE_SGDLL
		delete[] xmlExParam;
#endif
	}
	free((void *)FileName);
}
void CCADWindow::ChangeScale(LONG ID)
{
	HMENU hMenu;
	hMenu = GetMenu(hWnd);
	CheckMenuItem(hMenu, ScaleID + ID_SCALE + 1, MF_BYCOMMAND | MF_UNCHECKED);
	ScaleID = ID - ID_SCALE - 1;
	CheckMenuItem(hMenu, ScaleID + ID_SCALE + 1, MF_BYCOMMAND | MF_CHECKED);
	if (ID == ID_FITWINDOW) 
		FitToWindow();
	else
	{
		Scale = Scales[ScaleID];
		RecalculateExtents();
		RePaint();
	}
}

void CCADWindow::RecalculateExtents()
{
	PredPoint.x = 0;
	PredPoint.y = 0; //TOOLBAR_HEIGHT;
	offset.x = 0;
	offset.y = TOOLBAR_HEIGHT;
	CADGetBox(hCAD, &BoxLeft, &BoxRight, &BoxTop, &BoxBottom);
	fAbsWidth = BoxRight - BoxLeft;
	fAbsHeight = BoxTop - BoxBottom;
	fCoef = fAbsHeight / fAbsWidth;
	ScaleRect.x = -1;
}

void CCADWindow::FitToWindow()
{
	double L, T, R, B, W, H;
	RECT rect;
	if (CADGetBox(hCAD, &L, &R, &T, &B) == 0) return;
    W = R - L;
    if (W == 0) W = 1;
	H = T - B;
    if (H == 0) H = 1;
	GetClientRect(hWnd, &rect);
    W = abs(rect.right - rect.left) / W;
    H = abs(rect.bottom - rect.top) / H;
    if (W > H) W = H;
	RecalculateExtents();
	Scale = W;	
	RePaint();
}

void CCADWindow::GetLayers()
{    
	if (hCAD)
	{			
		Layer.Name = (PTCHAR)malloc((MAX_LAYERNAME + 1) * sizeof(TCHAR));
		if (DialogBox(HInst, 
			MAKEINTRESOURCE(IDD_DIALOG1), 
			hWnd, 
			(DLGPROC)LayerNameDlgProc) != 0)
		{
			Layer.Count = 0;	  
			CADEnum(hCAD, 0, GetLayerFromData, &Layer);
			PTCHAR buffer = (PTCHAR)malloc(200 * sizeof(TCHAR));
			_stprintf_s(buffer, 200, EntitiesOnLayers, Layer.Count, Layer.Name);
			MessageBox(hWnd, buffer, Layer.Name, 0);
			free(buffer);
		}
		free(Layer.Name);
	}
}

void CCADWindow::DrawingMode(LONG mode)
{

	HMENU hMenu = GetMenu(hWnd);
	CheckMenuItem(hMenu, ID_DRAWINGSTYLE_DASHDOTS, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, ID_DRAWINGSTYLE_WINAPI, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, ID_DRAWINGSTYLE_SOLIDLINES, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, mode, MF_BYCOMMAND | MF_CHECKED);
	switch(mode)
		{
			case ID_DRAWINGSTYLE_DASHDOTS:				
				DrwMode = 0;
				break;
			case ID_DRAWINGSTYLE_WINAPI:
				DrwMode = 1;
				break;
			case ID_DRAWINGSTYLE_SOLIDLINES:
				DrwMode = 2;
				break;
		}			
	RePaint();
}
void CCADWindow::Circle(LONG mode)
{
	HMENU hMenu = GetMenu(hWnd);
	CheckMenuItem(hMenu, ID_CIRCLE_DRAWASARC, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, ID_CIRCLE_DRAWASPOLY_DASHDOTS, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, ID_CIRCLE_DRAWASPOLY_WINAPI, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, ID_CIRCLE_DRAWASPOLY_SOLIDLINES, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, mode, MF_BYCOMMAND | MF_CHECKED);
	switch(mode)
		{
			case ID_CIRCLE_DRAWASARC:				
				CircleDrwMode = 1;
				CheckMenuItem(hMenu, ID_CIRCLE_DRAWASPOLY_WINAPI, MF_BYCOMMAND | MF_CHECKED);
				break;
			case ID_CIRCLE_DRAWASPOLY_DASHDOTS:
				CircleDrwMode = 0;
				break;
			case ID_CIRCLE_DRAWASPOLY_WINAPI:
				CircleDrwMode = 1;
				CheckMenuItem(hMenu, ID_CIRCLE_DRAWASARC, MF_BYCOMMAND | MF_CHECKED);
				break;
			case ID_CIRCLE_DRAWASPOLY_SOLIDLINES:				
				CircleDrwMode = 2;
				break;
		}			
	RePaint();
}

void CCADWindow::ArcsAsCurves(LONG mode)
{
	HMENU hMenu = GetMenu(hWnd);
	CheckMenuItem(hMenu, ID_GETARCSASCURVES, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, ID_GETARCSASPOLY, MF_BYCOMMAND | MF_UNCHECKED);
	CheckMenuItem(hMenu, mode, MF_BYCOMMAND | MF_CHECKED);

	switch (mode)
	{
	case ID_GETARCSASCURVES:
		bGetArcsAsCurves = true;
		CADProhibitCurvesAsPoly(hCAD, 0);
		break;
	case ID_GETARCSASPOLY:
		bGetArcsAsCurves = false;
		CADProhibitCurvesAsPoly(hCAD, 1);
		break;
	}
	RePaint();
}

void CCADWindow::TextsAsCurves()
{
	HMENU hMenu = GetMenu(hWnd);
    if (bGetTextsAsCurves)
       CheckMenuItem(hMenu, ID_GETTEXTSASCURVES, MF_BYCOMMAND | MF_UNCHECKED);
    else
       CheckMenuItem(hMenu, ID_GETTEXTSASCURVES, MF_BYCOMMAND | MF_CHECKED);
	bGetTextsAsCurves = !bGetTextsAsCurves;
	RePaint();
}

void CCADWindow::SwitchDblBuf()
{
  if (bDoubleBuffered)
    CheckMenuItem(GetMenu(hWnd), ID_VIEW_DBLBUF, MF_BYCOMMAND | MF_UNCHECKED);
  else
    CheckMenuItem(GetMenu(hWnd), ID_VIEW_DBLBUF, MF_BYCOMMAND | MF_CHECKED);
  bDoubleBuffered = !bDoubleBuffered;
}

int CCADWindow::WMPaint(HWND wnd, int Msg, int wParam, int lParam)
{
	HDC DC, MemDC;
	HBITMAP MemBitmap;
	HGLOBAL OldBitmap;
	PAINTSTRUCT PS;
	RECT Rect;

	if ((!bDoubleBuffered) || (wParam)) //wParam }=> HDC
	{
		Draw(wnd, (HDC)wParam);
		return 0;
	}
	else
	{
		DC = GetDC(0);
		GetWindowRect(wnd, &Rect);
		InflateRect(&Rect, -Rect.left, -Rect.top);
		MemBitmap = CreateCompatibleBitmap(DC, Rect.right, Rect.bottom);
		ReleaseDC(0, DC);
		MemDC = CreateCompatibleDC(0);
		OldBitmap = SelectObject(MemDC, MemBitmap);
		DC = BeginPaint(wnd, &PS);
		DefWindowProcA(wnd, WM_ERASEBKGND, (unsigned int)MemDC, (unsigned int)MemDC);
		SendMessage(wnd, Msg, (int)MemDC, (int)lParam);
		BitBlt(DC, 0, 0, Rect.right, Rect.bottom, MemDC, 0, 0, SRCCOPY);
		EndPaint(wnd, &PS);    
		SelectObject(MemDC, OldBitmap);
		DeleteDC(MemDC);
		DeleteObject(MemBitmap);
		return 0;
	}
}

TCHAR * CCADWindow::GetProgressMessage()
{	
	return sProgressMessage;
} 