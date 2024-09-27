// MainWindow.cpp: implementation of the CMainWindow class.
//
//////////////////////////////////////////////////////////////////////

#include "MainWindow.h"
#include <memory.h>
#include "resource.h"
#include <stdio.h>
#include <math.h>
#include <TCHAR.h>
#include <msxml.h>
#include <comutil.h>
#include <sginitshx.h>

CMainWindow *MainWnd = NULL;
int WINAPI CADProgress(BYTE);

//
//  Functions for the mouse position definition
//
void Ort(LPFPOINT point)
{
  float len = (float)sqrt(point->x*point->x + point->y*point->y + point->z*point->z);
  point->x = point->x / len;
  point->y = point->y / len;
  point->z = point->z / len;
}

void MoveToPosition(LPFPOINT point, const FPOINT pos, const int direction)
{  
  point->x = point->x + direction * pos.x;
  point->y = point->y + direction * pos.y;
  point->z = point->z + direction * pos.z;
}

//////////////////////////////////////////////////////////////////////
// String conversion functions
//////////////////////////////////////////////////////////////////////

TCHAR * tsclone(TCHAR * src)
{
	int len = _tcslen(src);
	TCHAR * dst = new TCHAR[++len];
	memcpy(dst, src, len * sizeof(TCHAR));
	return dst;
}

PsgChar TCHARtosgChar(TCHAR * src)
{
	#ifdef UNICODE
		return tsclone(src);
    #else
		return _com_util::ConvertStringToBSTR(src);
	#endif
}

TCHAR * sgCharToTCHAR(PsgChar src)
{
	#ifdef UNICODE
		return tsclone(src);
    #else
		return _com_util::ConvertBSTRToString(src);
	#endif
}

/*PTCHAR strconcat(PTCHAR s1, PTCHAR s2)
{
	int len1 = _tcslen(s1);
	int len2 = _tcslen(s2);
	int len = len1 + len2;
	PTCHAR str = (PTCHAR)malloc((len + 1) * sizeof(TCHAR));
	_tcscpy_s(str, len1, s1);
	_tcscpy_s(&str[len1], len2, s2);
	str[len] = 0;
	return str;
}*/

//////////////////////////////////////////////////////////////////////
// Static members
//////////////////////////////////////////////////////////////////////
#ifndef CS_STATIC_DLL
    HINSTANCE CADDLL;
	CADLAYER CMainWindow::CADLayer;
	CADLAYERCOUNT CMainWindow::CADLayerCount;
	CADLAYERVISIBLE CMainWindow::CADLayerVisible;
	CADVISIBLE CMainWindow::CADVisible;	
	CLOSECAD CMainWindow::CloseCAD;
	CREATECAD CMainWindow::CreateCAD;
	CREATECADEX CMainWindow::CreateCADEx;
	CADLAYOUT CMainWindow::CADLayout;
	CADLAYOUTBOX CMainWindow::CADLayoutBox;
	CADLAYOUTNAME CMainWindow::CADLayoutName;
	CADLAYOUTSCOUNT CMainWindow::CADLayoutsCount;
	CADLAYOUTVISIBLE CMainWindow::CADLayoutVisible;
	CADSETSHXOPTIONS CMainWindow::CADSetSHXOptions;
	CURRENTLAYOUTCAD CMainWindow::CurrentLayoutCAD;
	DEFAULTLAYOUTINDEX CMainWindow::DefaultLayoutIndex;
	DRAWCADEX CMainWindow::DrawCADEx;
	DRAWCADTODIB CMainWindow::DrawCADtoDIB;
	DRAWCADTOJPEG CMainWindow::DrawCADtoJpeg;
	GETBOXCAD CMainWindow::GetBoxCAD;
	GETCADBORDERTYPE CMainWindow::GetCADBorderType;
	GETCADBORDERSIZE CMainWindow::GetCADBorderSize;
	GETCADCOORDS CMainWindow::GetCADCoords;
	GETEXTENTSCAD CMainWindow::GetExtentsCAD;
	GETIS3DCAD CMainWindow::GetIs3dCAD;
	GETLASTERRORCAD CMainWindow::GetLastErrorCAD;
	GETNEARESTENTITY CMainWindow::GetNearestEntity;
	GETPOINTCAD CMainWindow::GetPointCAD;	
	SETCADBORDERTYPE CMainWindow::SetCADBorderType;
	SETCADBORDERSIZE CMainWindow::SetCADBorderSize;
	RESETDRAWINGBOXCAD CMainWindow::ResetDrawingBoxCAD;
	SAVECADTOBITMAP CMainWindow::SaveCADtoBitmap;
	SAVECADTOEMF CMainWindow::SaveCADtoEMF;
	SAVECADTOCAD CMainWindow::SaveCADtoCAD;
	SETDEFAULTCOLOR CMainWindow::SetDefaultColor;
	SETDRAWINGBOXCAD CMainWindow::SetDrawingBoxCAD;
	SETNULLLINEWIDTHCAD CMainWindow::SetNullLineWidthCAD;
	SETPROCESSMESSAGESCAD CMainWindow::SetProcessMessagesCAD;
	SETPROGRESSPROC CMainWindow::SetProgressProc;
	SETROTATECAD CMainWindow::SetRotateCAD;	
	SETSHOWLINEWEIGHTCAD CMainWindow::SetShowLineWeightCAD;	
	STOPLOADING CMainWindow::StopLoading;
	SAVECADTOFILEWITHXMLPARAMS CMainWindow::SaveCADtoFileWithXMLParams;
	SAVECADWITHXMLPARAMETRS CMainWindow::SaveCADWithXMLParametrs;
#endif

bool CMainWindow::IsAppChangingList;
HWND CMainWindow::hwndLayersDlg;
HWND CMainWindow::hwndPropertiesDlg;
HWND CMainWindow::hwndProgressDlg;
HWND CMainWindow::hwndPictureDlg;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CMainWindow::CMainWindow(LPCTSTR szClassName, WNDPROC WndProc, HINSTANCE hInst,
                 HICON hIcon, HCURSOR hCursor, LPCTSTR lpszMenuName,
                 HBRUSH color, UINT style):
CWindow(szClassName, WndProc, hInst, hIcon, hCursor, lpszMenuName, color, style)
{		
	hInstance = hInst;
	hwndStatusBar = hwndToolBar = hwndComboBox = hwndLayersDlg = NULL;
	curWait = LoadCursor(NULL, IDC_WAIT);
	int r = GetLastError();
	PTCHAR hand = _T("HAND");
	curHand = LoadCursor(hInstance, hand);
	curTarget = LoadCursor(hInstance, _T("TARGET"));
	curDefault = hCursor;
	SetCursor(curDefault);
	ScaleRect.x = -1;
	fKoef = 1;
    colorBgrnd = RGB(255,255,255);
    fAbsWidth = 640.0; 
	fAbsHeight = 480.0;
	drag = false;
	bIsPocessing = false;
	DrwMode = 0;	
    brushBackground = WndClass.hbrBackground;	
	CADImage = 0;	
	optionsCAD.NullLineWidth = 0;
	optionsCAD.IsDrawingBox = false;
	optionsCAD.IsShowLineWeight = true;
	optionsCAD.IsNearestPointMode = false;
	iBorderType = 1;
	dBorderSize = 12.5;
    // Initialisation hyperlink controls for "About dialog" 
	WNDCLASSEX  wndclass;	      
	wndclass.cbSize        = sizeof(wndclass);
    wndclass.style         = CS_HREDRAW | CS_VREDRAW;
    wndclass.lpfnWndProc   = ControlProc;
    wndclass.cbClsExtra    = 0;
    wndclass.cbWndExtra    = 0;
    wndclass.hInstance     = hInstance;
	wndclass.hIcon         = NULL;
    wndclass.hCursor       = curHand;
    wndclass.hbrBackground = (HBRUSH) (COLOR_BTNFACE + 1);
    wndclass.lpszMenuName  = NULL;
    wndclass.lpszClassName = _T("HyperLink");
	wndclass.hIconSm       = NULL;
    RegisterClassEx(&wndclass);
	MainWnd = this;
#ifndef CS_STATIC_DLL 
	CADDLL = LoadLibrary(sgLibName);
	if (CADDLL!= NULL)
	{
		CADLayer = (CADLAYER) GetProcAddress(CADDLL, "CADLayer");
	    CADLayerCount = (CADLAYERCOUNT) GetProcAddress(CADDLL, "CADLayerCount");
	    CADLayerVisible = (CADLAYERVISIBLE) GetProcAddress(CADDLL, "CADLayerVisible");
	    CADVisible = (CADVISIBLE) GetProcAddress(CADDLL, "CADVisible");
		CreateCAD = (CREATECAD) GetProcAddress(CADDLL, "CreateCAD");
		CreateCADEx = (CREATECADEX) GetProcAddress(CADDLL, "CreateCADEx");
		CloseCAD  = (CLOSECAD)  GetProcAddress(CADDLL, "CloseCAD");
		CADLayout = (CADLAYOUT) GetProcAddress(CADDLL, "CADLayout");
		CADLayoutBox = (CADLAYOUTBOX) GetProcAddress(CADDLL, "CADLayoutBox");
		CADLayoutName = (CADLAYOUTNAME) GetProcAddress(CADDLL, "CADLayoutName");
		CADLayoutsCount = (CADLAYOUTSCOUNT) GetProcAddress(CADDLL, "CADLayoutsCount");
		CADLayoutVisible = (CADLAYOUTVISIBLE) GetProcAddress(CADDLL, "CADLayoutVisible");
		CADSetSHXOptions = (CADSETSHXOPTIONS) GetProcAddress(CADDLL, "CADSetSHXOptions");
		CurrentLayoutCAD = (CURRENTLAYOUTCAD) GetProcAddress(CADDLL, "CurrentLayoutCAD");
		DefaultLayoutIndex = (DEFAULTLAYOUTINDEX) GetProcAddress(CADDLL, "DefaultLayoutIndex");
		DrawCADEx = (DRAWCADEX) GetProcAddress(CADDLL, "DrawCADEx");
		DrawCADtoJpeg = (DRAWCADTOJPEG) GetProcAddress(CADDLL, "DrawCADtoJpeg");
		DrawCADtoDIB = (DRAWCADTODIB) GetProcAddress(CADDLL, "DrawCADtoDIB");
		GetBoxCAD = (GETBOXCAD) GetProcAddress(CADDLL, "GetBoxCAD");
		GetCADBorderType = (GETCADBORDERTYPE) GetProcAddress(CADDLL, "GetCADBorderType");
		GetCADBorderSize = (GETCADBORDERSIZE) GetProcAddress(CADDLL, "GetCADBorderSize");
		GetCADCoords = (GETCADCOORDS) GetProcAddress(CADDLL, "GetCADCoords");
        GetExtentsCAD = (GETEXTENTSCAD) GetProcAddress(CADDLL, "GetExtentsCAD");
		GetIs3dCAD = (GETIS3DCAD) GetProcAddress(CADDLL, "GetIs3dCAD");
		GetLastErrorCAD = (GETLASTERRORCAD) GetProcAddress(CADDLL, "GetLastErrorCAD");
		GetNearestEntity = (GETNEARESTENTITY) GetProcAddress(CADDLL, "GetNearestEntity");
		GetPointCAD = (GETPOINTCAD) GetProcAddress(CADDLL, "GetPointCAD");		
		ResetDrawingBoxCAD = (RESETDRAWINGBOXCAD) GetProcAddress(CADDLL, "ResetDrawingBoxCAD");
		SaveCADtoBitmap = (SAVECADTOBITMAP) GetProcAddress(CADDLL, "SaveCADtoBitmap");
		SaveCADtoEMF = (SAVECADTOEMF) GetProcAddress(CADDLL, "SaveCADtoEMF");
		SaveCADtoCAD = (SAVECADTOCAD) GetProcAddress(CADDLL, "SaveCADtoCAD");
		SetCADBorderType = (SETCADBORDERTYPE) GetProcAddress(CADDLL, "SetCADBorderType");
		SetCADBorderSize = (SETCADBORDERSIZE) GetProcAddress(CADDLL, "SetCADBorderSize");
		SetDefaultColor = (SETDEFAULTCOLOR) GetProcAddress(CADDLL, "SetDefaultColor");
		SetDrawingBoxCAD = (SETDRAWINGBOXCAD) GetProcAddress(CADDLL, "SetDrawingBoxCAD");
		SetNullLineWidthCAD = (SETNULLLINEWIDTHCAD) GetProcAddress(CADDLL, "SetNullLineWidthCAD");
		SetProcessMessagesCAD = (SETPROCESSMESSAGESCAD)  GetProcAddress(CADDLL, "SetProcessMessagesCAD");
		SetProgressProc = (SETPROGRESSPROC) GetProcAddress(CADDLL, "SetProgressProc");
		SetRotateCAD = (SETROTATECAD) GetProcAddress(CADDLL, "SetRotateCAD");
		SetShowLineWeightCAD = (SETSHOWLINEWEIGHTCAD)  GetProcAddress(CADDLL, "SetShowLineWeightCAD");
		StopLoading = (STOPLOADING)  GetProcAddress(CADDLL, "StopLoading");
		SetProgressProc((PROGRESSPROC)CADProgress);
		SaveCADtoFileWithXMLParams = (SAVECADTOFILEWITHXMLPARAMS)GetProcAddress(CADDLL, "SaveCADtoFileWithXMLParams");
		SaveCADWithXMLParametrs = (SAVECADWITHXMLPARAMETRS)GetProcAddress(CADDLL, "SaveCADWithXMLParametrs");
		InitSHX(CADSetSHXOptions);
	}
	else
	{
		CADLayer = NULL;
	    CADLayerCount = NULL;
	    CADLayerVisible = NULL;
	    CADVisible = NULL;				
		CloseCAD = NULL;
		CreateCAD = NULL;
		CreateCADEx = NULL;
		CADLayout = NULL;
		CADLayoutBox = NULL;
		CADLayoutName = NULL;
		CADLayoutsCount = NULL;
		CADLayoutVisible = NULL;
		CADSetSHXOptions = NULL;
		CurrentLayoutCAD = NULL;
		DefaultLayoutIndex = NULL;
		DrawCADEx = NULL;
		DrawCADtoJpeg = NULL;
		DrawCADtoDIB = NULL;
		GetBoxCAD = NULL;
		GetCADBorderType = NULL;
		GetCADBorderSize = NULL;
		GetCADCoords = NULL;
		GetIs3dCAD = NULL;
		GetLastErrorCAD = NULL;
		GetNearestEntity = NULL;
		GetPointCAD = NULL;
		GetExtentsCAD = NULL;
		ResetDrawingBoxCAD = NULL;
		SaveCADtoBitmap = NULL;
		SaveCADtoEMF = NULL;
		SaveCADtoCAD = NULL;
		SetCADBorderType = NULL;
		SetCADBorderSize = NULL;
		SetDrawingBoxCAD = NULL;
		SetDefaultColor = NULL;
		SetNullLineWidthCAD = NULL;
        SetProcessMessagesCAD = NULL;
		SetRotateCAD = NULL;
		SetShowLineWeightCAD = NULL;
		StopLoading = NULL;
		SaveCADWithXMLParametrs = NULL;
		TCHAR msg[32];
		_stprintf_s(msg, 32, _T("%s%s"), sgLibName, LIB_NOT_LOADED);
		MessageBox(0, msg, WARNING_CAPTION, MB_ICONWARNING || MB_TASKMODAL);
	}    
#endif	
}

int WINAPI CADProgress(BYTE PercentDone)
{
	TCHAR mes[MSG_LEN];
	PTCHAR done = _T("% done");
	TCHAR ProgressMsg[MSG_LEN] = _T("");
	_tcscpy_s(ProgressMsg, MainWnd->GetProgressMessage());
	_itot_s(PercentDone, mes, 10);
	_tcscat_s(ProgressMsg, mes);
	_tcscat_s(ProgressMsg, done);
	MainWnd->SetTextToStatusBar(ProgressMsg);
	SendMessage(MainWnd->hwndProgressDlg, IDM_PROGRESS, (WPARAM)PercentDone, 0);
	return 0;
}

CMainWindow::~CMainWindow()
{
#ifndef CS_STATIC_DLL
	if (CADDLL)
		FreeLibrary(CADDLL);
#endif	
}

void CMainWindow::CloseImage()
{
	if (CADImage)
	{
		CloseCAD(CADImage);
		CADImage = 0;
	}
}

HGLOBAL CMainWindow::LoadFile(char * FileName)
{
	HFILE hFile = NULL;
	OFSTRUCT ofs;
	char buff[0x4000];
	DWORD szFile, BytesRead, TotalRead = 0;
	HGLOBAL Result = NULL;
	char *memlock;

	hFile = OpenFile(FileName, &ofs, OF_READ);
	if (hFile != NULL)
	{
		szFile = GetFileSize((HANDLE)hFile, &szFile);
		Result = GlobalAlloc(GMEM_MOVEABLE, szFile);
		if (Result != NULL)
		{
			memlock = (char *)GlobalLock(Result);
			do
			{
				ReadFile((HANDLE)hFile, (void *)buff, sizeof(buff), &BytesRead, NULL);
				CopyMemory((void *)memlock, (void *)buff, BytesRead);
				memlock+=BytesRead;
				TotalRead+=BytesRead;
			}
			while (TotalRead < szFile);
			GlobalUnlock(Result);
		}
		CloseHandle((HANDLE)hFile);
	}
	return Result;
}

void CMainWindow::Load(CADOPTIONS CADOpts)
{
	int i;
	TCHAR * errmsg;
	if (bIsPocessing)
	{
		MessageBox(hWnd, WAIT_LABEL, WARNING_CAPTION, MB_ICONINFORMATION);
		return;
	}
	sgChar cErrorCode[MSG_LEN];
	//char CADProgressID[MSG_LEN];
	int nErrorCode;

#ifndef CS_STATIC_DLL
	if (!CADDLL) return;
#endif	
	PTCHAR FileName = (TCHAR *)malloc((MAX_PATH + 1) * sizeof(TCHAR));
	*FileName = 0;
	if (this->GetFile(this->hWnd, FileName, CADFilter, true))
	{
	CloseImage();	
    bRotated3D = false;
	bIsRotated = false;	
#ifndef CS_STATIC_DLL
	if (CADDLL)
#endif
	{			
		SetCursor(curWait);
		SetTextToStatusBar(WAIT_STATUS);
		for (i=1; i<QUANTITY_OF_PARTS; ++i)
		  SetTextToStatusBar(NULL, i);
		//itoa(CAD_PROGRESS, CADProgressID, 10);
		//CADImage = CreateCADEx(hWnd, FileName, CADProgressID);
		this->ShowProgressDlg(true, LOADING_STATUS);
		if (!CADOpts.IsLoadFromMemory)
		{
			//CADSetSHXOptions("", "", "", 1, 1);// please call it before CreateCAD
			PsgChar fname = TCHARtosgChar(FileName);
			CADImage = CreateCAD(hWnd, fname);
			delete[] fname;
		}
		else
		{
			HGLOBAL hMem;
			TCHAR FileExt[13];
#ifdef UNICODE
			char * fname = _com_util::ConvertBSTRToString(FileName);
			hMem = LoadFile(fname);
			delete[] fname;
#else
			hMem = LoadFile(FileName);
#endif
			if (hMem != NULL) 
			{
				int fnamelen = _tcslen(FileName);
				i = fnamelen;
				do {i--;}while (FileName[i] != '.');
				PTCHAR memoryPrefix = _T("memory");
				memcpy(FileExt, memoryPrefix, _tcslen(memoryPrefix) * sizeof(TCHAR));
				int j=6;
				do 
				{
					FileExt[j] = FileName[i];
					j++;
					i++;
				}while (i < fnamelen);
				FileExt[j] = 0;
				PsgChar sgfname = TCHARtosgChar(FileExt);
				CADImage = CreateCADEx(hWnd, (PsgChar)hMem, sgfname);
				delete[] sgfname;
				GlobalFree(hMem);
			}
		}
		this->ShowProgressDlg(false, LOADING_STATUS);
		nErrorCode = GetLastErrorCAD(cErrorCode, MSG_LEN);
		if (nErrorCode == 0)
		{
			SetCursor(curDefault);
			SetTextToStatusBar(FileName);
			FillLayersList();
			DoCreateComboBox(hInstance);					
			SetBorder();
			Fit();
		}
		else
		{
			switch(nErrorCode)
			{		
			case ERROR_CAD_GENERAL:
			case ERROR_CAD_INVALID_HANDLE:
			case ERROR_CAD_INVALID_INDEX:
			case ERROR_CAD_FILE_NOT_FOUND:
			case ERROR_CAD_FILE_READ:
			case ERROR_CAD_INVALID_CADDRAW:
			case ERROR_CAD_UNSUPFORMAT_FILE:
			case ERROR_CAD_OUTOFRESOURCES:
			case ERROR_CAD_LICENSE_RESTRICTIONS:
			case ERROR_CAD_TRIAL_PERIOD_EXPIRED:
				errmsg = sgCharToTCHAR(cErrorCode);
				MessageBox(hWnd, errmsg, ERROR_CAPTION, MB_ICONERROR);
				delete[] errmsg;
				SetTextToStatusBar(NO_FILE_LOADED_STATUS);
			default:
				break;
			}
		}
		SetOptionsCAD(CADOpts);
		RePaint();
	}
	}
	free((void *)FileName);
}

void CMainWindow::ScaleRectangleF(double Scale, POINT Pos, LPFRECT Rect)
{
	double W, H;
	W = (Rect->Points.Right - Rect->Points.Left) * Scale;
	H = (Rect->Points.Bottom - Rect->Points.Top) * Scale;
	Rect->Points.Left = (Rect->Points.Left * Scale) + (-Pos.x * Scale) + Pos.x;
	Rect->Points.Top = (Rect->Points.Top * Scale) + (-Pos.y * Scale) + Pos.y;
	Rect->Points.Right = Rect->Points.Left + W; 
	Rect->Points.Bottom = Rect->Points.Top + H;
    return;
}

void CMainWindow::FitToWindow(RECT ClientR, LPFRECT Rect)
{
	Rect->Points.Left = ClientR.left;
	Rect->Points.Top = ClientR.top;
	Rect->Points.Right = ClientR.right;
	Rect->Points.Bottom = ClientR.bottom;
    if (CADImage != NULL)
	{
		double koef = fAbsHeight / fAbsWidth;
		double d = (Rect->Points.Right - Rect->Points.Left) * koef;
		if (d > (Rect->Points.Bottom - Rect->Points.Top))
			Rect->Points.Right = Rect->Points.Left + (Rect->Points.Bottom - Rect->Points.Top) / koef;
		else
			Rect->Points.Bottom = Rect->Points.Top + d;
	}
	double dX = ((ClientR.right - ClientR.left) - (Rect->Points.Right - Rect->Points.Left)) / 2;
	double dY = ((ClientR.bottom - ClientR.top) - (Rect->Points.Bottom - Rect->Points.Top)) / 2;
    Rect->Points.Left = Rect->Points.Left + dX;
	Rect->Points.Right = Rect->Points.Right + dX;
	Rect->Points.Top = Rect->Points.Top + dY;
	Rect->Points.Bottom = Rect->Points.Bottom + dY;
    return;
}

void CMainWindow::Fit()
{
	RECT r;
	GetClientRect(hWnd, &r);
	FitToWindow(r, &DrawRect);
	RePaint(); 
}

void CMainWindow::RecalculateExtents()
{
	GetExtentsCAD(CADImage, &frectExtentsCAD);
	//fAbsHeight = frectExtentsCAD.Points.Top - frectExtentsCAD.Points.Bottom;
	//fAbsWidth  = frectExtentsCAD.Points.Right - frectExtentsCAD.Points.Left;
	GetBoxCAD(CADImage, &fAbsWidth, &fAbsHeight);		
	fKoef = fAbsHeight / fAbsWidth;
	ScaleRect.x = -1;
	RECT r;
	GetClientRect(hWnd, &r);
	FitToWindow(r, &DrawRect);
}

void CMainWindow::Draw()
{
    if (bIsPocessing) 
		return;
	
	PAINTSTRUCT Paint;
	HDC hDC;		

	hDC = BeginPaint(hWnd, &Paint);	
	OldNearestPoint.x = -10;
	OldNearestPoint.y = -10;
	SetBgrndColor(colorBgrnd);

	if ((CADImage) 
#ifndef CS_STATIC_DLL
		&& 
		(DrawCADEx)
#endif
		)
	{		
        if (fAbsHeight > 0)// when loading the CAD file
		{		
			memset(&CADDraw, 0, sizeof(CADDRAW));
			CADDraw.Size = sizeof(CADDRAW);		
			CADDraw.DrawMode = DrwMode;
			CADDraw.DC = hDC;
			ScaleRect.x = fAbsWidth / (DrawRect.Points.Right - DrawRect.Points.Left);
			ScaleRect.y = fAbsHeight / (DrawRect.Points.Bottom - DrawRect.Points.Top);
			CADDraw.R.left = (int)DrawRect.Points.Left;
			CADDraw.R.top = (int)DrawRect.Points.Top;
			CADDraw.R.right = (int)DrawRect.Points.Right;
			CADDraw.R.bottom = (int)DrawRect.Points.Bottom;
			DrawCADEx(CADImage, &CADDraw);			
		}		
	}
	EndPaint(hWnd, &Paint);	
}

void CMainWindow::MouseWheel(SHORT Keys, SHORT Delta, POINTS Point)
{
	double scale;
	if (Delta < 0)
		scale = 0.8;
	else
		scale = 1.25;
	POINT pt;
	pt.x = Point.x; 
	pt.y = Point.y;
	ScreenToClient(hWnd, &pt);
	ScaleRectangleF(scale, pt, &DrawRect);
	RePaint();
}

void CMainWindow::LButtonDown(POINTS Point)
{
	if (CADImage) 
	{
		drag = true;
		DownPoint.x = Point.x;
		DownPoint.y = Point.y;
		SetCursor(curHand);
		SetCapture(hWnd);		
		RePaint();
	}
}

void CMainWindow::LButtonUp(POINTS Point)
{
	if (drag)
	{
		DownPoint.x = Point.x;
		DownPoint.y = Point.y;
		drag = false;
		SetCursor(curDefault);	
		ReleaseCapture();
	}
}

void CMainWindow::MouseMove(POINTS Point)
{
	if (drag)
	{
		SetCursor(curHand);
		double dX, dY;
		dX = Point.x - DownPoint.x;
		dY = Point.y - DownPoint.y;
		DownPoint.x = Point.x; 
		DownPoint.y = Point.y; 
		DrawRect.Points.Left = DrawRect.Points.Left + dX;
		DrawRect.Points.Top = DrawRect.Points.Top + dY;
		DrawRect.Points.Right = DrawRect.Points.Right + dX;
		DrawRect.Points.Bottom = DrawRect.Points.Bottom + dY;
		RePaint();
	}
	else if (CADImage) 
	{  
		SetCursor(curTarget);
		DoMousePosition(Point);		
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

//  Example xml string
//<?xml version="1.0" encoding="utf-8"?>
//<ExportParams version="1.0"">
//  <FileName>C:\Tmp\2\test.cgm</FileName>
//  <Ext>.cgm</Ext>
//  <GraphicParametrs>
//    <PixelFormat>6</PixelFormat>
//    <Width>0</Width>
//    <Height>0</Height>
//    <DrawMode>0</DrawMode>
//    <DrawRect Left="0" Top="0" Right="0" Bottom="0"/>
//  </GraphicParametrs>
//  <CADParametrs>
//    <XScale>1</XScale>
//    <BackgroundColor>16777215</BackgroundColor>
//    <DefaultColor>0</DefaultColor>
//  </CADParametrs>
//</ExportParams>


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

void CMainWindow::SaveAsBMP()
{
	CADDRAW CADDraw;
	float AbsWidth, AbsHeight;
	double Koef;

	if ((!CADImage) 
#ifndef CS_STATIC_DLL
		|| (!CADDLL)
#endif
		) 
		return;

	PTCHAR FileName = (PTCHAR)malloc((MAX_PATH + 1) * sizeof(TCHAR));
	*FileName = 0;
	if (this->GetFile (this->hWnd, FileName, BMPFilter, false))
	{
		memset(&CADDraw, 0, sizeof(CADDraw));
		CADDraw.Size = sizeof(CADDraw);
		GetBoxCAD(CADImage, &AbsWidth, &AbsHeight);
		GetClientRect(hWnd, &CADDraw.R);
		if (AbsHeight != -1)
		{
			Koef = AbsHeight / AbsWidth;
			CADDraw.R.top = 0;
			CADDraw.R.left = 0;
			CADDraw.R.bottom = int(CADDraw.R.top + CADDraw.R.right * Koef);
			CADDraw.DrawMode = DrwMode;
			PsgChar sgFileName = TCHARtosgChar(FileName);

			if (SaveCADtoBitmap(CADImage, &CADDraw, sgFileName) == 0)
			{
				MessageBox(hWnd, FILE_NOT_SAVED, ERROR_CAPTION, MB_ICONERROR);
				SetTextToStatusBar(FILE_NOT_SAVED);
			}
			else
			{
				TCHAR fmt_msg[] = _T("File saved as: %s");
				int buflen = _tcslen(fmt_msg) + _tcslen(FileName) + 1;
				TCHAR * FILE_SAVED_AS = new TCHAR[buflen];
				_stprintf_s(FILE_SAVED_AS, buflen, fmt_msg, FileName);
				MessageBox(hWnd, FILE_SAVED_AS, _T(""), MB_ICONINFORMATION);
				delete[] FILE_SAVED_AS;
			}
			delete[] sgFileName;
		}
	}
	free((void *)FileName);
}

void CMainWindow::SaveAsEMF()
{
	CADDRAW CADDraw;	
    float AbsWidth, AbsHeight, scale;
	double Koef;		

	if ((!CADImage) 
#ifndef CS_STATIC_DLL
		|| (!CADDLL)
#endif
		) 
		return;		 
	PTCHAR FileName = (TCHAR *)malloc((MAX_PATH + 1) * sizeof(TCHAR));
	*FileName = 0;
	if (this->GetFile(this->hWnd, FileName, MetafileFilter, false))
	{
		memset(&CADDraw, 0, sizeof(CADDRAW));	
		CADDraw.Size = sizeof(CADDraw);
		scale = 10.0;
		GetBoxCAD(CADImage, &AbsWidth, &AbsHeight);	
		GetClientRect(hWnd, &CADDraw.R);
		if (AbsHeight != -1)
		{    
			Koef = min(1800 / AbsWidth, 1800 / AbsHeight);
			CADDraw.R.right = int(AbsWidth * Koef);
			CADDraw.R.bottom = int(AbsHeight * Koef);
			CADDraw.R.top = 0;
			CADDraw.R.left = 0;
			CADDraw.DrawMode = DrwMode;
			PsgChar sgFileName = TCHARtosgChar(FileName);
			SaveCADtoEMF(CADImage, &CADDraw, sgFileName);
			delete[] sgFileName;
		}
	}
	free((void *)FileName);
}

void CMainWindow::SaveAs()
{
	CADDRAW CADDraw;	
    float AbsWidht, AbsHeight, scale;
	double Koef;		

	if ((!CADImage) 
#ifndef CS_STATIC_DLL
		|| (!CADDLL)
#endif
		) 
		return;
	
	PTCHAR FileName = (PTCHAR)malloc((MAX_PATH + 1) * sizeof(TCHAR));
	*FileName = 0;
	if (this->GetFile (this->hWnd, FileName, SaveAsFilter, false))
	{
	if (_tcsstr(FileName, _T(".jpg")) > 0) // JPEG file format
	{
		memset(&CADDraw, 0, sizeof(CADDRAW));
		CADDraw.Size = sizeof(CADDraw);
		//scale = (float)(nScale / 100.0);
		scale = 10.0;
		GetBoxCAD(CADImage, &AbsWidht, &AbsHeight);
		GetClientRect(hWnd, &CADDraw.R);
		if (AbsHeight != -1)
		{    
			Koef = AbsHeight / AbsWidht;
			CADDraw.R.top = 0;
			CADDraw.R.left = 0;
			CADDraw.R.bottom = int(CADDraw.R.bottom * scale);
			CADDraw.R.right = int(CADDraw.R.right * scale);
			CADDraw.R.bottom = int(CADDraw.R.top + CADDraw.R.right * Koef);
			CADDraw.DrawMode = DrwMode;
			HANDLE Hnd = DrawCADtoJpeg(CADImage, &CADDraw);
			if (Hnd) 
			{
				DWORD Size = GlobalSize(Hnd);
				void *P = GlobalLock(Hnd);
				HANDLE FHnd = CreateFile(FileName, GENERIC_WRITE, FILE_SHARE_READ,
					NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
				if (FHnd) 
				{
					DWORD Wrt;
					WriteFile(FHnd, P, Size, &Wrt, NULL);
					CloseHandle(FHnd);			
				}
				GlobalUnlock(Hnd);    
				GlobalFree(Hnd);
			}
		}
	}
	else// CAD file format
	{
		this->ShowProgressDlg(true, EXPORT_STATUS);
		RePaint();		
		TCHAR * ext;
		int i = _tcslen(FileName);
		for (i = _tcslen(FileName); ((i >= 0) && (FileName[i] != _T('.'))); i--);
		if (i <= 0)
			ext = NULL;
		else
			ext = (TCHAR *)(&FileName[i]);
		float W, H;
		GetBoxCAD(CADImage, &W, &H);

		if (IsRasterFormat(ext))
		{
			float ratio;
			ratio = min(800 / W, 600 / H);
			W *= ratio;
			H *= ratio;
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
		xmlExParam = xmlExportParams;
		WCHAR * s_msg = (WCHAR *)malloc(1024*sizeof(WCHAR));
		if (!SaveCADtoFileWithXMLParams(CADImage, xmlExParam, (PROGRESSPROC)CADProgress))
		{
			WCHAR msg[1024];
			memset(msg, 0, sizeof(msg));			
			GetLastErrorCAD((PsgChar)msg, sizeof(msg));			
			_stprintf_s(s_msg, 1024, _T("%s %s"), FILE_NOT_SAVED, msg);
			MessageBox(hWnd, s_msg, ERROR_CAPTION, MB_ICONERROR);
			SetTextToStatusBar(FILE_NOT_SAVED);
		}
		else
		{			
			_stprintf_s(s_msg, 1024, _T("File saved as: %s"), FileName);
			MessageBox(hWnd, s_msg, _T(""), MB_ICONINFORMATION);
		}
		free(s_msg);
		this->ShowProgressDlg(false, EXPORT_STATUS);
		SetTextToStatusBar(FileName);
		free(graphicParams);
		free(cadParams);
		free(exportParams);

	}
	}
	free((void *)FileName);
}

void CMainWindow::ChangeView(BYTE View)
{
	HMENU hMenu;

	if ((DrwMode != View) && (CADImage))
	{
		hMenu = GetMenu(hWnd);		
		CheckMenuItem(hMenu, ID_VIEW + DrwMode + 1, MF_BYCOMMAND | MF_UNCHECKED);
		DrwMode = View;
		CheckMenuItem(hMenu, ID_VIEW + View + 1, MF_BYCOMMAND | MF_CHECKED);
		RePaint();
	}
}

void CMainWindow::SetDefColor()
{
	CHOOSECOLOR cc;                 
	static COLORREF acrCustClr[16]; 
	static DWORD rgbCurrent;        
	
	ZeroMemory(&cc, sizeof(CHOOSECOLOR));
	cc.lStructSize = sizeof(CHOOSECOLOR);
	cc.hwndOwner = hWnd;
	cc.hwndOwner = 0;
	cc.lpCustColors = (LPDWORD) acrCustClr;
	cc.rgbResult = rgbCurrent;
	cc.Flags = CC_FULLOPEN | CC_RGBINIT;

	if (ChooseColor(&cc)) 
	{
		  SetDefaultColor(CADImage, cc.rgbResult);
	}
	RePaint();
}

void CMainWindow::DoCreateStatusBar(HWND hwndParent, HINSTANCE hInst) 
{     
    ::InitCommonControls(); 

    hwndStatusBar = CreateWindowEx( 
        0,                        
        STATUSCLASSNAME,          
        (LPCTSTR) NULL,           
        WS_CHILD | WS_BORDER,
        0, 0, 0, 0,               
        hwndParent,               
        NULL,                     
        hInst,                    
        NULL);                    

	SplitStatusBar();  
	SetTextToStatusBar(_T("Demo")); 	
	ShowWindow(hwndStatusBar, SW_SHOWNORMAL);
}

void CMainWindow::SetTextToStatusBar(LPCTSTR str, int part)
{
	SendMessage(hwndStatusBar, SB_SETTEXT, part, (LPARAM)str); 
}

void CMainWindow::DoCreateToolBar(HWND hwndParent, HINSTANCE hInst) 
{	
	int i;
    TBADDBITMAP tbAddBitMap[QUANTITY_OF_BUTTONS];	
    TBBUTTON tbButton[QUANTITY_OF_BUTTONS];
    ::InitCommonControls(); 
    hwndToolBar = ::CreateWindowEx( 
        0,      
        TOOLBARCLASSNAME,
        (LPCTSTR) NULL,  
        CCS_TOP | WS_CHILD,			 
        0, 0, 0, 0,        
        hwndParent,    
        NULL,
        hInst,         
        NULL);         
    ::SendMessage(hwndToolBar, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof(TBBUTTON) , (LPARAM)0 );
	for (i=0; i< QUANTITY_OF_BUTTONS; i++) 
		tbAddBitMap[i].hInst = hInst;
	tbAddBitMap[0].nID = IDB_BMORBITUPX;
	tbAddBitMap[1].nID = IDB_BMORBITDOWNX;
	tbAddBitMap[2].nID = IDB_BMORBITUPY;
	tbAddBitMap[3].nID = IDB_BMORBITDOWNY;
	tbAddBitMap[4].nID = IDB_BMORBITUPZ;
	tbAddBitMap[5].nID = IDB_BMORBITDOWNZ;
	tbAddBitMap[6].nID = IDB_BMOPTIONSLAYERS;
	tbAddBitMap[7].nID = IDB_BMDRAWINGBOX;
	tbAddBitMap[8].nID = IDB_BMROTATE;
	tbButton[0].idCommand = IDM_ORBITUPX;
	tbButton[1].idCommand = IDM_ORBITDOWNX;
	tbButton[2].idCommand = IDM_ORBITUPY;
	tbButton[3].idCommand = IDM_ORBITDOWNY;
	tbButton[4].idCommand = IDM_ORBITUPZ;
	tbButton[5].idCommand = IDM_ORBITDOWNZ;
	tbButton[6].idCommand = IDM_OPTIONSLAYERS;
	tbButton[7].idCommand = IDM_OPTIONSDRAWINGBOX;
	tbButton[8].idCommand = IDM_ROTATE;
	::SendMessage(hwndToolBar, TB_SETBITMAPSIZE, (WPARAM) 0 , (LPARAM) MAKELONG(TOOLBAR_BUTTON_SIZE, TOOLBAR_BUTTON_SIZE));	
    
	for (i=0; i< QUANTITY_OF_BUTTONS; i++) 
	{
		tbButton[i].iBitmap = i;
		tbButton[i].fsState = (BYTE)TBSTATE_ENABLED;
	    tbButton[i].fsStyle = (BYTE)TBSTYLE_AUTOSIZE | TBSTYLE_BUTTON;
	    tbButton[i].dwData = (unsigned long)0;
		tbButton[i].iString = (int)0;		
		::SendMessage(hwndToolBar, TB_ADDBITMAP, (WPARAM) 0 , (LPARAM)&tbAddBitMap[i]);		
	}

    ::SendMessage(hwndToolBar, TB_SETBUTTONSIZE, (WPARAM) 0 , (LPARAM) MAKELONG(TOOLBAR_BUTTON_SIZE, TOOLBAR_BUTTON_SIZE));
	::SendMessage(hwndToolBar, TB_ADDBUTTONS , (WPARAM)i , (LPARAM)&tbButton); 		
	::SendMessage(hwndToolBar, TB_AUTOSIZE,   (WPARAM)0 , (LPARAM)0 );
	
	::ShowWindow(hwndToolBar, SW_SHOWNORMAL);    
}

void CMainWindow::DoCreateComboBox(HINSTANCE hInst) 
{	
	if (!hwndToolBar) return;
	if (CADImage) 
	{
		int i, defaultLayout, Count;		
		Count = CADLayoutsCount(CADImage);
		defaultLayout = DefaultLayoutIndex(CADImage);
		if (hwndComboBox) 
			DestroyWindow(hwndComboBox);		
		hwndComboBox = ::CreateWindowEx( 
			0,      
			_T("COMBOBOX"),
			(LPCTSTR) NULL,  
			CBS_DROPDOWNLIST | WS_CHILD,			 
			(TOOLBAR_BUTTON_SIZE+8)*QUANTITY_OF_BUTTONS, 4, 120, 40+COMBOBOX_ITEM_SIZE*Count,        
			hwndToolBar,    
			NULL,
			hInst,         
			NULL);		
	    for (i= 0; i < Count; ++i)
		{
			sgChar LayoutName[256];
			CADLayoutName(CADImage, i, LayoutName, 256);
			TCHAR * lname = sgCharToTCHAR(LayoutName);
			::SendMessage(hwndComboBox, (UINT) CB_ADDSTRING, 0, (LPARAM)(LPCTSTR)lname);			
			delete[] lname;
		}
		::SendMessage(hwndComboBox, (UINT) CB_SETCURSEL, (WPARAM) defaultLayout, 0);
		RePaint();
		::ShowWindow(hwndComboBox, SW_SHOWNORMAL);
	}	
}

int CMainWindow::SetBorder()
{
	if (CADImage != NULL)
	{
		SetCADBorderType(CADImage, iBorderType);
		if (iBorderType == 1)
			SetCADBorderSize(CADImage, dBorderSize / 100.0);
		else
			SetCADBorderSize(CADImage, dBorderSize);
		SetCurrentLayout();
	}
	return 1;
}

bool CMainWindow::SetCurrentLayout()
{
    int lindex;
    lindex = ::SendMessage(hwndComboBox, (UINT) CB_GETCURSEL, 0, 0);
	ResetDrawingBox();
    CurrentLayoutCAD(CADImage, lindex, TRUE);
	RecalculateExtents();
	RePaint();
	SetFocus(hWnd);
	return true;
}

bool CMainWindow::Is3D()
{
	int is3d;
	GetIs3dCAD(CADImage, &is3d);
	if (bRotated3D || (is3d == 1) )
		return true;
	return false;
}

void CMainWindow::DoMousePosition(POINTS PointOnScr)
{	
	if ((!CADImage) || (ScaleRect.x < 0 )) return;
	FPOINT newmousePt;
	POINT NearestPoint;
	TCHAR str[64];
	sgChar NearestEntityName[256];
	float sX, sY;

	if (Is3D())
	{
		SetTextToStatusBar(IS_3D_DRAWING_STATUS, 1);
		return;
	}	
	NearestPoint.x = (int)(PointOnScr.x - DrawRect.Points.Left);
	NearestPoint.y = (int)(PointOnScr.y - DrawRect.Points.Top);
	sX = (float)((PointOnScr.x - DrawRect.Points.Left) * ScaleRect.x / fAbsWidth);
	sY = (float)(1 - (PointOnScr.y - DrawRect.Points.Top) * ScaleRect.y / fAbsHeight);
	GetCADCoords(CADImage, sX, sY, &newmousePt);
	_stprintf_s(str, _T("(%6.6f, %6.6f)\0"), newmousePt.x, newmousePt.y);
	SetTextToStatusBar(str, 1);	
	if (GetIsNearestPointMode())
	{
		NearestEntityName[0] = 0;
		GetNearestEntity(CADImage, NearestEntityName, 255, &CADDraw.R, (LPPOINT)&NearestPoint);
		DrawNearestMark(NearestPoint, &OldNearestPoint);
		PTCHAR tmp1 = sgCharToTCHAR(NearestEntityName);
		SetTextToStatusBar(tmp1, 2);
		delete[] tmp1;
	}
}

void CMainWindow::SplitStatusBar(int nParts)
{
	RECT rcClient; 
    HLOCAL hloc; 
    LPINT lpParts; 
    int i, nWidth;
    GetClientRect(hWnd, &rcClient); 
    hloc = LocalAlloc(LHND, sizeof(int) * nParts); 
    lpParts = (LPINT)LocalLock(hloc); 
    nWidth = rcClient.right / nParts; 
    for (i = 0; i < nParts; i++) 
	{ 
        lpParts[i] = nWidth; 
        nWidth+= nWidth; 
    } 	
	
    ::SendMessage(hwndStatusBar, SB_SETPARTS, (WPARAM) nParts, (LPARAM) lpParts); 	

    LocalUnlock(hloc); 
    LocalFree(hloc);   
}

void CMainWindow::ReSize(WPARAM wParam,LPARAM lParam)
{
	SplitStatusBar();
  	::SendMessage(hwndStatusBar, WM_SIZE, wParam, lParam);
	::SendMessage(hwndToolBar, TB_AUTOSIZE, (WPARAM)0 , (LPARAM)0 );
}

void CMainWindow::RotateCAD(const AXES axis, const float angle)
{
	if (CADImage && !optionsCAD.IsDrawingBox) 
	{	
		FPOINT center, centerNew, delta;
		FPOINT scaleNew;
		double scale;		

		// calculate previous scale by extents
		scale = (DrawRect.Points.Right - DrawRect.Points.Left) / fAbsWidth;
		// calculate previous draw rect center point
		center.x = (DrawRect.Points.Left + DrawRect.Points.Right) / 2;
		center.y = (DrawRect.Points.Top + DrawRect.Points.Bottom) / 2;
		// do rotate
		SetRotateCAD(CADImage, angle, int(axis));
		// initialize new extents, reset darw rect
		RecalculateExtents();
		// calculate new scale (scaleNew.x)
		scaleNew.x = (DrawRect.Points.Right - DrawRect.Points.Left) / fAbsWidth;
		scaleNew.y = (DrawRect.Points.Bottom - DrawRect.Points.Top) / fAbsHeight;
		if (scaleNew.y > scaleNew.x) 
			scaleNew.x = scaleNew.y;
		// do scale draw rect
		POINT Pos;
		Pos.x = 0;
		Pos.y = 0;
		ScaleRectangleF(scale / scaleNew.x, Pos, &DrawRect);
		// calculate new draw rect center
		centerNew.x = (DrawRect.Points.Left + DrawRect.Points.Right) / 2;
		centerNew.y = (DrawRect.Points.Top + DrawRect.Points.Bottom) / 2;
		// calculate offset from previous draw rect center to default
		delta.x = center.x - centerNew.x;
		delta.y = center.y - centerNew.y;
		// offset draw rect co previous rect center
		DrawRect.Points.Left = DrawRect.Points.Left + delta.x;
		DrawRect.Points.Right = DrawRect.Points.Right + delta.x;
		DrawRect.Points.Top = DrawRect.Points.Top + delta.y;
		DrawRect.Points.Bottom = DrawRect.Points.Bottom + delta.y;	
		bIsRotated = true;
		if (axis != axisZ)
		{
		  bRotated3D = true;
		  SetTextToStatusBar(NULL, 2);	
		}
		RePaint();
	}
}

void CMainWindow::SetBgrndColor(const COLORREF color)
{
	colorBgrnd = color;
	RECT rect;
	GetClientRect(hWnd, &rect);
	LOGBRUSH brush;
	brush.lbStyle = BS_SOLID;
	brush.lbColor = colorBgrnd;
	brush.lbHatch = 0;
	brushBackground = CreateBrushIndirect(&brush);	
	FillRect(hMainWndDC, &rect, brushBackground);
	DeleteObject(brushBackground);
	RePaint();
}

void CMainWindow::ShowAboutDlg()
{
	::InitCommonControls();     
    DialogBox(hInstance, MAKEINTRESOURCE(IDD_ABOUT), hWnd, (DLGPROC) AboutDialogProc);	
}

void CMainWindow::ShowProgressDlg(bool Visible, const TCHAR * Msg)
{
	bIsPocessing = Visible;	
	_tcscpy_s(sProgressMessage, MSG_LEN, Msg);	
	if (hwndProgressDlg == NULL)
		hwndProgressDlg = CreateDialog(hInstance, MAKEINTRESOURCE(IDD_PROGRESS), hWnd, (DLGPROC) ProgressDialogProc);
	SetWindowText(hwndProgressDlg, Msg);
	if (Visible)
	{
		SetWindowLong(hwndProgressDlg, GWLP_USERDATA, (LONG) this);
		SendMessage(GetDlgItem(hwndProgressDlg, IDC_PROGRESS), (UINT) PBM_SETRANGE, (WPARAM) 0,  (LPARAM) MAKELPARAM (0, 100));  
		SendMessage(GetDlgItem(hwndProgressDlg, IDC_PROGRESS), (UINT) PBM_SETPOS, (WPARAM) 0,  (LPARAM) 0);
		ShowWindow(hwndProgressDlg, SW_SHOW);
		SetFocus(hwndProgressDlg);
	}
	else
	{
		ShowWindow(hwndProgressDlg, SW_HIDE);
		SetFocus(hWnd);
	}	
}

void CMainWindow::SetProgressValue(BYTE PercentDone)
{
	SendMessage(GetDlgItem(hwndProgressDlg, IDC_PROGRESS), (UINT) PBM_SETPOS, (WPARAM) PercentDone,  (LPARAM) 0);
	UpdateWindow(GetDlgItem(hwndProgressDlg, IDC_PROGRESS));
}

bool CMainWindow::StretchDrawDIB (HGLOBAL hMemDIB, HDC hDC, RECT * R)
{
    HBITMAP hBmp;
	BITMAPINFO *BitmapInfo;
	HDC hCompatibleDC;
	OSVERSIONINFOEX osvi;
	DWORDLONG dwlConditionMask = 0;
	int bltMode;

	int BmpWidth, BmpHeight;
	int NumColor;											
	void *P = NULL;
	if (hMemDIB)
	{  
		P = GlobalLock(hMemDIB);
		
		BitmapInfo = (BITMAPINFO *) malloc(sizeof(BITMAPINFOHEADER) + 256 * sizeof(RGBQUAD));
		memcpy(&BitmapInfo->bmiHeader, P, sizeof(BITMAPINFOHEADER));
		P = (void *)(int(P) + sizeof(BITMAPINFOHEADER));					
		NumColor = BitmapInfo->bmiHeader.biClrUsed;
		if (!NumColor)
		{
			NumColor = BitmapInfo->bmiHeader.biBitCount;
			if (NumColor > 8) NumColor = 0;
			else NumColor = 1 << NumColor;
		}
		void * Colors = (void *)(int(BitmapInfo) + BitmapInfo->bmiHeader.biSize);			
		memcpy(Colors, P, NumColor * sizeof(RGBQUAD));
		P = (void *)(int(P) + NumColor * sizeof(RGBQUAD));					
		BmpWidth = BitmapInfo->bmiHeader.biWidth;
		BmpHeight = BitmapInfo->bmiHeader.biHeight;
		if (BmpHeight < 0) BmpHeight = -BmpHeight;

		void *BitsMem = NULL;
		hBmp = CreateDIBSection(hDC, BitmapInfo, DIB_RGB_COLORS, &BitsMem, 0, 0);
		NumColor = BmpHeight * ((BmpWidth * BitmapInfo->bmiHeader.biBitCount + 31 & -32) >> 3);

		memcpy(BitsMem, P, NumColor);

		free(BitmapInfo);			
		hCompatibleDC = CreateCompatibleDC(hDC);			

		HGDIOBJ OldObject = SelectObject(hCompatibleDC, hBmp);

		bltMode = GetStretchBltMode(hDC);
		ZeroMemory(&osvi, sizeof(OSVERSIONINFOEX));
		osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
		osvi.dwPlatformId = VER_PLATFORM_WIN32_NT;
		VER_SET_CONDITION(dwlConditionMask, VER_PLATFORMID, VER_EQUAL);
		if(VerifyVersionInfo(&osvi, VER_PLATFORMID, dwlConditionMask))
			SetStretchBltMode(hDC,HALFTONE);
		else
			SetStretchBltMode(hDC,COLORONCOLOR);
		
		StretchBlt(hDC, 0, 0, R->right, R->bottom, hCompatibleDC, 0, 0, BmpWidth, BmpHeight, SRCCOPY);
		SetStretchBltMode(hDC, bltMode);

		SelectObject(hCompatibleDC, OldObject);
		DeleteObject(hBmp);				
		DeleteDC(hCompatibleDC);
	}
	if (hMemDIB) 
		GlobalFree(hMemDIB);
    return TRUE;
}


void CMainWindow::ShowPictureDlg(bool Visible)
{		
	if (hwndPictureDlg == NULL)
	{
		hwndPictureDlg = CreateDialog(hInstance, (LPCTSTR)IDD_PICTURE, hWnd, (DLGPROC)PictureDialogProc);	
		SetWindowLong(hwndPictureDlg, GWLP_USERDATA, (LONG) this);
	}
	if (Visible)
	{	
		ShowWindow(hwndPictureDlg, SW_SHOW);
		SetFocus(hwndPictureDlg);
	}
	else
	{
		ShowWindow(hwndPictureDlg, SW_HIDE);
		SetFocus(hWnd);
	}
}

void CMainWindow::ShowLayersDlg(bool Visible)
{		
	if (hwndLayersDlg == NULL)
		hwndLayersDlg = CreateDialog(hInstance, (LPCTSTR)IDD_LAYERS, hWnd, (DLGPROC)LayersDialogProc);	
	if (Visible)
	{
		ShowWindow(hwndLayersDlg, SW_SHOW);
		SetFocus(hwndLayersDlg);
	}
	else
	{
		ShowWindow(hwndLayersDlg, SW_HIDE);
		SetFocus(hWnd);
	}	
}

void CMainWindow::ShowPropertiesDlg(bool Visible)
{		
	if (hwndPropertiesDlg == NULL)
		hwndPropertiesDlg = CreateDialog(hInstance, (LPCTSTR)IDD_PROPERTIES, hWnd, (DLGPROC) PropertiesDialogProc);	
	if (Visible)
	{
		SetWindowLong(hwndPropertiesDlg, GWLP_USERDATA, (LONG) this);
		SendMessage(hwndPropertiesDlg, WM_INITDIALOG, 0, 0);
		ShowWindow(hwndPropertiesDlg, SW_SHOW);
		SetFocus(hwndPropertiesDlg);
	}
	else
	{
		ShowWindow(hwndPropertiesDlg, SW_HIDE);
		SetFocus(hWnd);
	}	
}

bool CMainWindow::ResetDrawingBox()
{
	if ((CADImage != NULL) && optionsCAD.IsDrawingBox && !bIsRotated)
	{
		ResetDrawingBoxCAD(CADImage);		
		RecalculateExtents();
		optionsCAD.IsDrawingBox = false;
		RePaint();		
	}
	return optionsCAD.IsDrawingBox;
}

bool CMainWindow::SetDrawingBox()
{
     FRECT rectDrawingBox, cadBox;
     cadBox = frectExtentsCAD;
     // For future versions
     //HANDLE hLayout = CADLayout(CADImage, 0);
     //CADLayoutBox(hLayout, &cadBox);    
     
     if ((CADImage != NULL) && !bIsRotated)
     {          
          rectDrawingBox.Points.Left = (cadBox.Points.Left + cadBox.Points.Right)/2;
          rectDrawingBox.Points.Top =  cadBox.Points.Top;
          rectDrawingBox.Points.Z1 = 0;  
          rectDrawingBox.Points.Right = cadBox.Points.Right; 
          rectDrawingBox.Points.Bottom = cadBox.Points.Bottom; 
          rectDrawingBox.Points.Z2 = 0;           
          SetDrawingBoxCAD(CADImage, &rectDrawingBox);
          RecalculateExtents();          
          RePaint();
		  optionsCAD.IsDrawingBox = true;
     }     
	 return optionsCAD.IsDrawingBox;
}

void CMainWindow::DrawNearestMark(POINT NewPoint, LPPOINT OldPoint)
{
	RECT NewR, OldR;
	HPEN hPen = CreatePen(PS_SOLID, 1, 0xFF0000);
	HPEN hOldPen = (HPEN)SelectObject(hMainWndDC, hPen);

	HBRUSH hBrush;
	HBRUSH hOldBrush;
	LOGBRUSH LogBrush;
	
	int Index = SaveDC(hMainWndDC);

	LogBrush.lbStyle = BS_SOLID;
	LogBrush.lbHatch = 0;
	LogBrush.lbColor = 0xFF0000;
	hBrush = CreateBrushIndirect(&LogBrush);
	hOldBrush = (HBRUSH)SelectObject(hMainWndDC, hBrush);

	hOldPen = (HPEN)SelectObject(hMainWndDC, hPen);
	SetROP2(hMainWndDC, R2_NOTXORPEN);
	SetBkColor(hMainWndDC, (COLORREF)(LogBrush.lbColor));
	SetBkMode(hMainWndDC, OPAQUE);

	NewR.left = NewPoint.x - 4;
	NewR.top = NewPoint.y - 4;
	NewR.right = NewPoint.x + 4;
	NewR.bottom = NewPoint.y + 4;

	OldR.left = OldPoint->x - 4;
	OldR.top = OldPoint->y - 4;
	OldR.right = OldPoint->x + 4;
	OldR.bottom = OldPoint->y + 4;

	Rectangle(hMainWndDC, OldR.left, OldR.top, OldR.right, OldR.bottom);
	Rectangle(hMainWndDC, NewR.left, NewR.top, NewR.right, NewR.bottom);

	DeleteObject(hPen);	
	SelectObject(hMainWndDC, hOldPen);
	DeleteObject(hBrush);	
	SelectObject(hMainWndDC, hOldBrush);
	RestoreDC(hMainWndDC, Index);

	*OldPoint = NewPoint;
}

bool CMainWindow::ShowLineWeight(bool IsShow)
{
	optionsCAD.IsShowLineWeight = IsShow;
	if ((CADImage != NULL) && (SetShowLineWeightCAD(CADImage, (IsShow ? 1: 0)) > 0))
	{	    
		RePaint();
		return true;
	}	
	return false;
}
bool CMainWindow::SetIsNearestPointMode(bool Checked)
{
	optionsCAD.IsNearestPointMode = Checked;
	if (CADImage != NULL) 
	{	    
		RePaint();
		return true;
	}	
	return false;
}

bool CMainWindow::SetNullLineWidth(int NullLineWidth)
{
	optionsCAD.NullLineWidth = NullLineWidth;
	if ((CADImage != NULL) && (SetNullLineWidthCAD(CADImage, optionsCAD.NullLineWidth) > 0))
	{	    
		RePaint();
		return true;
	}	
	return false;
}

void CMainWindow::StoppingLoad()
{
	StopLoading();
}

bool CMainWindow::SetOptionsCAD(CADOPTIONS CADOpts)
{
	if (CADImage != NULL) 
	{        
	    optionsCAD = CADOpts;
		SetShowLineWeightCAD(CADImage, (optionsCAD.IsShowLineWeight ? 1: 0));
		SetNullLineWidthCAD(CADImage, optionsCAD.NullLineWidth);
        if (optionsCAD.IsDrawingBox) 
			SetDrawingBox();
		else
			ResetDrawingBox(); 		
		return true;
	}	
	return false;
}

bool CMainWindow::GetIsShowLineWeight()
{
	return optionsCAD.IsShowLineWeight;
}

bool CMainWindow::GetIsDrawingBox()
{
	return optionsCAD.IsDrawingBox;
}

bool CMainWindow::GetIsNearestPointMode()
{
	return optionsCAD.IsNearestPointMode;
}

bool CMainWindow::GetIsPocessing()
{
	return bIsPocessing;
}

int  CMainWindow::GetNullLineWidth()
{
	return optionsCAD.NullLineWidth;
}

TCHAR * CMainWindow::GetProgressMessage()
{	
	return sProgressMessage;
} 

void CMainWindow::DestroyLayersDlg()
{
	if (hwndLayersDlg != NULL)
	{
		DestroyWindow(hwndLayersDlg);
		hwndLayersDlg = NULL;
	}
}

void CMainWindow::FillLayersList()
{
	if (CADImage == NULL) 
		return;
	DestroyLayersDlg();
	ShowLayersDlg(false);
	int i, Count, Vis;		
	LVCOLUMN lvCol;
	LVITEM lvItem;
	HANDLE hLayer;
	HWND hwndList;
	CADDATA cadData;	
	Count = CADLayerCount(CADImage);
	hwndList = GetDlgItem(hwndLayersDlg, IDC_LISTLAYERS);	
	ListView_DeleteAllItems(hwndList);
	ZeroMemory(&lvCol, sizeof(lvCol));
    // Initialize the columns
	lvCol.mask = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;
    lvCol.fmt = LVCFMT_LEFT; 
    lvCol.cx = 235; 	
	lvCol.pszText = _T("Layers names"); 	
	ListView_InsertColumn(hwndList, 0, &lvCol);
	ListView_SetItemCount(hwndList, Count);
	IsAppChangingList = true;
	ListView_SetExtendedListViewStyle(hwndList, LVS_EX_GRIDLINES | LVS_EX_CHECKBOXES);	
	for (i= 0; i< Count; i++)
	{		
		hLayer = CADLayer(CADImage, i, &cadData);
		Vis = (cadData.Flags & 1) != 0;
		ZeroMemory(&lvItem, sizeof(lvItem)); 
		lvItem.mask = LVIF_TEXT | LVIF_PARAM;		
		lvItem.iItem = i; 
		lvItem.iSubItem = 0;
		lvItem.pszText = cadData.Text;
		lvItem.lParam = (LPARAM) hLayer;		
		ListView_InsertItem(hwndList, &lvItem);		
		ListView_SetItemState(hwndList, i, INDEXTOSTATEIMAGEMASK(UINT((Vis)+1)), LVIS_STATEIMAGEMASK);
	}	
	IsAppChangingList = false;
}

void CMainWindow::ShellOpen(HWND hWindow, TCHAR * file)
{
	ShellExecute(hWindow, _T("open"), file, NULL, NULL, SW_SHOW);
	return;
}

bool CMainWindow::Print()
{
	if (CADImage == 0) return false;
	bool res = false;
	PRINTDLG pd;
	memset(&pd, 0, sizeof(PRINTDLG));
	pd.lStructSize = sizeof(PRINTDLG);
	pd.Flags = PD_USEDEVMODECOPIESANDCOLLATE | PD_RETURNDC;
	pd.hInstance = hInstance;
	pd.hwndOwner = hWnd;
	if (PrintDlg(&pd))
	__try
	{
		int PageWidth = GetDeviceCaps(pd.hDC, HORZRES);
		int PageHeight = GetDeviceCaps(pd.hDC, VERTRES);		

		memset(&CADDraw, 0, sizeof(CADDRAW));
		CADDraw.Size = sizeof(CADDRAW);
		CADDraw.DrawMode = DrwMode;
		CADDraw.DC = pd.hDC;
		
		RECT PageBounds;
		PageBounds.left = 0;
		PageBounds.top = 0;
		PageBounds.right = PageWidth;
		PageBounds.bottom = PageHeight;
		FRECT drawRect;
		FitToWindow(PageBounds, &drawRect);	
		
		CADDraw.R.left = (int)drawRect.Points.Left;
		CADDraw.R.top = (int)drawRect.Points.Top;
		CADDraw.R.right = (int)drawRect.Points.Right;
		CADDraw.R.bottom = (int)drawRect.Points.Bottom;
		
		DOCINFO dinfo;
		dinfo.cbSize = sizeof(DOCINFO);
		dinfo.fwType = 0;
		dinfo.lpszDatatype = 0;
		dinfo.lpszOutput = NULL;
		dinfo.lpszDocName = _T("CAD DLL Printing");
		StartDoc(pd.hDC, &dinfo);
		__try
		{
			DrawCADEx(CADImage, &CADDraw);
		}
		__finally
		{
			EndDoc(pd.hDC);
		}
		res = true;
	}
	__finally
	{
		if (pd.hDC != 0)
		  DeleteDC(pd.hDC);
	}
	return res;
}

/* 
  AboutDialogProc
  

*/
BOOL CALLBACK CMainWindow::AboutDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		case WM_INITDIALOG:
            return TRUE;
		case WM_COMMAND:
			switch (LOWORD(wParam))                   
            {
				case IDOK:
				case IDCANCEL: 
					EndDialog(hDlg, LOWORD(wParam));
				    return TRUE;
					break;
                case IDCC_MAILTO_SG: 
					ShellOpen(hDlg, (PTCHAR)&MailTo[0]);
					break; 
				case IDCC_HOMEPAGE_SG: 
					ShellOpen(hDlg, (PTCHAR)&URL[0]);
					break;
			}
			break;
	}
    return FALSE;
}

/* 
  ControlProc
  

*/
LRESULT CALLBACK CMainWindow::ControlProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
     switch (message)
          {
		  case WM_PAINT:
			  {
                  HDC hdc;
				  RECT rect;	 
				  TCHAR text[300];			  
				  PAINTSTRUCT ps;
				  HFONT hOldF, hF = CreateFont(8, 0, 0, 0, 400, FALSE, 1, 0, RUSSIAN_CHARSET, OUT_DEFAULT_PRECIS,
					CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_ROMAN, _T("MS Sans Serif"));
				  GetWindowText(hWnd, text, sizeof(text));			  
				  GetClientRect(hWnd, &rect);
				  hdc = BeginPaint(hWnd, &ps);
				  hOldF = (HFONT) SelectObject(hdc, hF);
				  SetBkMode(hdc, TRANSPARENT);
				  SetTextColor(hdc, RGB(0, 0, 255));
			      DrawText(hdc, text, -1, &rect, DT_SINGLELINE | DT_LEFT | DT_VCENTER);
			      DeleteObject(hF);
			      SelectObject(hdc, hOldF);
                  EndPaint(hWnd, &ps);			  
                  break;
			  }

		  case WM_LBUTTONDOWN :
              SendMessage(GetParent(hWnd), WM_COMMAND, GetWindowLong (hWnd, GWL_ID), (LPARAM) hWnd);
			  break;
          }
     return DefWindowProc (hWnd, message, wParam, lParam);
}

/* 
  LayersDialogProc
  

*/
BOOL CALLBACK CMainWindow::LayersDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{	
	if (hDlg != hwndLayersDlg)
		return FALSE;
	HWND hwndMainWnd = GetParent(hwndLayersDlg);

	switch (message)
	{
		case WM_INITDIALOG:			
			return TRUE;

		case WM_COMMAND:			
			switch (LOWORD(wParam))
			{
				case IDOK:
				case IDCANCEL:
					CheckMenuItem(GetMenu(hwndMainWnd), IDM_OPTIONSLAYERS, MF_UNCHECKED);
					ShowWindow(hwndLayersDlg, SW_HIDE);					
					break;
			}
		case WM_MOVE:
			InvalidateRect(hwndMainWnd, NULL, TRUE);
			break;		
		case WM_NOTIFY:
			switch (wParam)
			{	
				case IDC_LISTLAYERS:
					NMHDR nmHdr = *((LPNMHDR) lParam);
					if (!IsAppChangingList && (nmHdr.code == LVN_ITEMCHANGED))
					{						
						NMLISTVIEW nmListViewItem = *((LPNMLISTVIEW)lParam);
						int Vis = (::SendMessage(GetDlgItem(hwndLayersDlg, IDC_LISTLAYERS), LVM_GETITEMSTATE, nmListViewItem.iItem, LVIS_STATEIMAGEMASK) >> 12) - 1;			
						CADLayerVisible((HANDLE)(nmListViewItem.lParam), Vis);						
						InvalidateRect(hwndMainWnd, NULL, TRUE);
					}					
				break;
			}		
	}
    return FALSE;
}

char *double_to_char(double number)
{
	char *buffer, *temp;
	int  decimal_spot, sign, count, current_location = 0;
	int  PRECISION = 8;
	temp = (char *)malloc(256);
	_fcvt_s(temp, 255, number, PRECISION, &decimal_spot, &sign);
	if ((int)strlen(temp) > PRECISION)
		buffer = (char *)malloc (strlen (temp) + 3);
	else
		buffer = (char *)malloc (PRECISION + 3);
/* Add negative sign if required. */ 
	if (sign)
		buffer[current_location++] = '-';
/* Place decimal point in the correct location. */ 
	if (decimal_spot > 0)
	{
		memcpy(&buffer[current_location], temp, decimal_spot);
		buffer[decimal_spot + current_location] = '.';
		memcpy(&buffer[decimal_spot + current_location + 1], &temp[decimal_spot], strlen(temp) - decimal_spot + 1);
	}
	else
	{
		decimal_spot = -decimal_spot;
		buffer[current_location] = '.';
		for(count = current_location; count<decimal_spot+current_location; count++)
			buffer[count + 1] = '0';
		memcpy(&buffer[count + 1], temp, strlen(temp) + 1);
	}
	free(temp);
	return buffer;
}

/* 
  PropertiesDialogProc
  

*/
BOOL CALLBACK CMainWindow::PropertiesDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{	
	if (hDlg != hwndPropertiesDlg)
		return FALSE;
	int MAX_WIDTH_VALUE = 100;
	HWND hwndMainWnd = GetParent(hDlg);
	HWND hwndDlgItem = GetDlgItem(hDlg, IDE_NULLLINEWIDTH);
	CMainWindow* pMainWindow = (CMainWindow*) GetWindowLong(hDlg, GWLP_USERDATA);
	TCHAR text[MSG_LEN];
	switch (message)
	{
		case WM_CREATE:
			return TRUE;
		case WM_INITDIALOG:
			return TRUE;
		case WM_SHOWWINDOW:
			_itot_s(pMainWindow->GetNullLineWidth(), text, MSG_LEN, 10);
			SetWindowText(hwndDlgItem, text);
			if ((lParam != SW_OTHERZOOM) && (lParam != SW_OTHERUNZOOM))
				if (wParam)
				{
					SendDlgItemMessage(hDlg, IDR_GLOBAL, BM_SETCHECK, (WPARAM)(pMainWindow->iBorderType ^ 1), 0);
					SendDlgItemMessage(hDlg, IDR_RATIO, BM_SETCHECK, (WPARAM)(pMainWindow->iBorderType), 0);
					char * dval = double_to_char(pMainWindow->dBorderSize);
					SetWindowTextA(GetDlgItem(hDlg, IDE_BORDERSIZE), dval);
					free(dval);
				}
			break;
		case WM_COMMAND:			
			switch (LOWORD(wParam))
			{
				case IDOK:					
					if (pMainWindow != NULL)
					{
						GetWindowText(hwndDlgItem, text, MSG_LEN);
						pMainWindow->SetNullLineWidth(_tstoi(text)); 
						pMainWindow->iBorderType = SendDlgItemMessage(hDlg, IDR_RATIO, BM_GETCHECK, 0, 0);
						GetWindowText(GetDlgItem(hDlg, IDE_BORDERSIZE), text, MSG_LEN);
						pMainWindow->dBorderSize = _tstof(text);
						pMainWindow->SetBorder();
					}					
				case IDCANCEL:
					CheckMenuItem(GetMenu(hwndMainWnd), IDM_OPTIONSPROPERTIES, MF_UNCHECKED);
					ShowWindow(hDlg, SW_HIDE);
					break;
				case IDC_NEARESTPOINTMODE:
					if (pMainWindow != NULL)
					{
						if (!pMainWindow->GetIsDrawingBox())						
                            pMainWindow->SetIsNearestPointMode((SendDlgItemMessage(hwndPropertiesDlg, IDC_NEARESTPOINTMODE, BM_GETCHECK, 0, 0)) != 0);
						else	{
							SendDlgItemMessage(hwndPropertiesDlg, IDC_NEARESTPOINTMODE, BM_SETCHECK, 0, 1);
							MessageBox(hwndMainWnd, RESET_DRAWING_BOX_LABEL, WARNING_CAPTION, MB_ICONWARNING);
						}
					}
					break;
				case IDR_GLOBAL:
					pMainWindow->iBorderType = SendDlgItemMessage(hDlg, IDR_GLOBAL, BM_GETCHECK, 0, 0) ^ 1;
					SendDlgItemMessage(hDlg, IDR_RATIO, BM_SETCHECK, (WPARAM)(pMainWindow->iBorderType), 0);
					if (pMainWindow->iBorderType == 1)
						_tcscpy_s(text, MSG_LEN, _T("%"));
					else
						_tcscpy_s(text, MSG_LEN, UNITS_TEXT);
					SetWindowText(GetDlgItem(hDlg, IDL_BORDERUNITS), (LPCTSTR)text);
					break;
				case IDR_RATIO:
					pMainWindow->iBorderType = SendDlgItemMessage(hDlg, IDR_RATIO, BM_GETCHECK, 0, 0);
					SendDlgItemMessage(hDlg, IDR_GLOBAL, BM_SETCHECK, (WPARAM)(pMainWindow->iBorderType ^ 1), 0);
					if (pMainWindow->iBorderType == 1)
						_tcscpy_s(text, MSG_LEN, _T("%"));
					else
						_tcscpy_s(text, MSG_LEN, UNITS_TEXT);
					SetWindowText(GetDlgItem(hDlg, IDL_BORDERUNITS), (LPCTSTR)text);
					break;
			}
		case WM_MOVE:
			InvalidateRect(hwndMainWnd, NULL, TRUE);
			break;	
        case WM_NOTIFY:
            {
                LPNMHDR pnmh= (LPNMHDR) lParam;				
		   	    if (pnmh->code == UDN_DELTAPOS)
			    {
                    LPNMUPDOWN code= (LPNMUPDOWN) lParam;					
					GetWindowText(hwndDlgItem, text, MSG_LEN);
				    if (code->iDelta > 0)
						_itot_s(_tstoi(text) - 1, text, 10);
				    else
						_itot_s(_tstoi(text) + 1, text, 10);	
					SetWindowText(hwndDlgItem, text);
					// Correcting value
					GetWindowText(hwndDlgItem, text, MSG_LEN);
					if (_tcslen(text) > 5 || _tstoi(text) > MAX_WIDTH_VALUE)
						SetWindowText(hwndDlgItem, _T("100"));
					else if (_tcslen(text) == 0 || _tstoi(text) < 0)
						SetWindowText(hwndDlgItem, _T("0"));
				}			   
			    break;		  
			}
	}
    return FALSE;
}

/* 
  ProgressDialogProc
  

*/
BOOL CALLBACK CMainWindow::ProgressDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	if (hDlg != hwndProgressDlg)
		return FALSE;
	CMainWindow* pMainWindow = (CMainWindow*) GetWindowLong(hDlg, GWLP_USERDATA);
	switch (message)
	{
		case WM_INITDIALOG:
			break;
		case IDM_PROGRESS:
			pMainWindow->SetProgressValue((BYTE) wParam);
			break;
		case WM_COMMAND:
			switch (LOWORD(wParam))
			{
				case IDB_CANCEL_PROGRESS:
					pMainWindow->StoppingLoad();
					break;
			}
	}
	return FALSE;
}

/* 
  PictureDialogProc
  

*/
BOOL CALLBACK CMainWindow::PictureDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	HDC dlgDC;
	HANDLE hMemDIB;
    BOOL res = FALSE;
	if (hDlg != hwndPictureDlg)
		return FALSE;
	CMainWindow* pMainWindow = (CMainWindow*) GetWindowLong(hDlg, GWLP_USERDATA);
	switch (message)
	{
		case WM_INITDIALOG:
			break;
		case WM_SHOWWINDOW:
			break;
		case WM_PAINT:
			RECT R;
			GetClientRect(hDlg, &R);
			dlgDC = GetDC(hDlg);
			R.bottom = int(R.top  + (R.right - R.left) * pMainWindow->fKoef);
#ifndef CS_STATIC_DLL 
			hMemDIB = pMainWindow->DrawCADtoDIB(pMainWindow->CADImage, &R);
#else
			hMemDIB = DrawCADtoDIB(pMainWindow->CADImage, &R);
#endif			
			pMainWindow->StretchDrawDIB(hMemDIB, dlgDC, &R);
			ReleaseDC(hDlg, dlgDC); 
			break;
		case WM_SIZE:
			GetClientRect(hDlg, &R);
			InvalidateRect(hDlg, &R, true);
			break;
		case WM_COMMAND:
			break;
			//switch (LOWORD(wParam))
		case WM_CLOSE:
			EndDialog(hDlg, LOWORD(wParam));
			break;
	}
	return res;
}
