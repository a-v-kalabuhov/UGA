// ChildView.cpp : implementation of the CChildView class
//

#include "stdafx.h"
#include "DEMO_EXPORT_MFC.h"
#include "ChildView.h"
#include <dxfexp.h>
#include <afxext.h>


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

const int Export = 33000;
const int UseMM = 33001;
const int Parse = 33002;
const int Alter = 33003;


EXPORTTODXF ExportToDXF;
EXPORTTOCADFILE ExportToCAD;
GETLASTERRORCAD GetLastErrorCAD;

/////////////////////////////////////////////////////////////////////////////
// CChildView

CChildView::CChildView()
{
	CADDLL = LoadLibrary(sgLibName);
	if (CADDLL)
	{
		ExportToDXF = (EXPORTTODXF) GetProcAddress(CADDLL, "ExportToDXF");
		ExportToCAD = (EXPORTTOCADFILE) GetProcAddress(CADDLL, "ExportToCADFile");
		GetLastErrorCAD = (GETLASTERRORCAD)GetProcAddress(CADDLL, "GetLastErrorCAD");
	}

	nFlag = 0;
}

CChildView::~CChildView()
{
}


BEGIN_MESSAGE_MAP(CChildView,CWnd )
	//{{AFX_MSG_MAP(CChildView)
	ON_WM_PAINT()
	ON_WM_CREATE()
	ON_COMMAND(Export, OnExport)
	ON_COMMAND(Parse, OnParse)
	ON_COMMAND(Alter, OnAlter)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CChildView message handlers

BOOL CChildView::PreCreateWindow(CREATESTRUCT& cs) 
{
	if (!CWnd::PreCreateWindow(cs))
		return FALSE;

	cs.lpszClass = AfxRegisterWndClass(CS_HREDRAW|CS_VREDRAW|CS_DBLCLKS, 
		::LoadCursor(NULL, IDC_ARROW), HBRUSH(COLOR_WINDOW), NULL);
	return TRUE;
}

int CChildView::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	btn1.Create(_T("Export MetaFile to DXF/DWG"), WS_VISIBLE | WS_CHILD, CRect(8,24,165,48), this, Export);
	cbParse.Create(_T("Parse write"), WS_VISIBLE | WS_CHILD | BS_CHECKBOX | BS_AUTOCHECKBOX, CRect(174, 5, 270, 29), this, Parse);
	cbAlternativeBlack.Create(_T("Alternative Black"), WS_VISIBLE | WS_CHILD | BS_CHECKBOX | BS_AUTOCHECKBOX, CRect(174, 37, 270, 61), this, Alter);
	::SendMessage(btn1.m_hWnd, WM_SETFONT, (WPARAM)GetStockObject(ANSI_VAR_FONT), 1);
	::SendMessage(cbParse.m_hWnd, WM_SETFONT, (WPARAM)GetStockObject(ANSI_VAR_FONT), 1);
	::SendMessage(cbAlternativeBlack.m_hWnd, WM_SETFONT, (WPARAM)GetStockObject(ANSI_VAR_FONT), 1);
	return 0;
}


void CChildView::OnPaint() 
{
	CPaintDC dc(this); // device context for painting
	
	
	// Do not call CWnd::OnPaint() for painting messages
}

void CChildView::ExportCAD(TCHAR *mf, int dotpos, HENHMETAFILE hmf, const TCHAR *ext)
{
	TCHAR msg[1024];

	mf[dotpos] = '\0';
	mf = StrCat(mf, ext);
	if (!ExportToCAD(hmf, mf, nFlag, acR2004)) {
		memset(msg, 0, sizeof(msg));
		GetLastErrorCAD(msg, 1024);
		CString s_msg = CString(msg);
		MessageBox(s_msg, _T("CAD DLL Error"), 0);
	}
}

void CChildView::OnExport() 
{
	if (!CADDLL) 
	{
		MessageBox(StrCat(sgLibName, _T(" not loaded")), _T("Error"), 0);
		return;
	}

	TCHAR *mf = new TCHAR [MAX_PATH];
	HENHMETAFILE hmf;
	TCHAR msg[1024];

	CFileDialog Dialog(TRUE, _T(""), NULL, OFN_PATHMUSTEXIST,
		_T("MetaFile|*.emf"), NULL);
	Dialog.m_ofn.lpstrTitle = _T("Export metafile");
	if (IDOK == Dialog.DoModal())
	{
		int dotpos = Dialog.GetPathName().GetLength() - 3;
		StrCpy(mf, Dialog.GetPathName());
		hmf = GetEnhMetaFile(mf);
		if (hmf){
		if (ExportToDXF)
		{
			mf[dotpos] = '\0';
			mf = StrCat(mf, _T("dxf"));
			if (!ExportToDXF(hmf, mf, nFlag)) {
				memset(msg, 0, sizeof(msg));
				GetLastErrorCAD(msg, 1024);
				CString s_msg = CString(msg);
				MessageBox(s_msg, _T("CAD DLL Error"), 0);
			}
		}
		if (ExportToCAD)
		{
			ExportCAD(mf, dotpos, hmf, _T("dwg"));
			ExportCAD(mf, dotpos, hmf, _T("nc"));
		}
		DeleteEnhMetaFile(hmf);}
	}
	delete[] mf;
}

void CChildView::OnParse() 
{
	nFlag = nFlag ^ 2;
}

void CChildView::OnAlter() 
{
	nFlag = nFlag ^ 4;
}
