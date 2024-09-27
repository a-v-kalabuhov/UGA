// DEMO_EXPORT_MFC.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "DEMO_EXPORT_MFC.h"

#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDEMO_EXPORT_MFCApp

BEGIN_MESSAGE_MAP(CDEMO_EXPORT_MFCApp, CWinApp)
	//{{AFX_MSG_MAP(CDEMO_EXPORT_MFCApp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDEMO_EXPORT_MFCApp construction

CDEMO_EXPORT_MFCApp::CDEMO_EXPORT_MFCApp()
{
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CDEMO_EXPORT_MFCApp object

CDEMO_EXPORT_MFCApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CDEMO_EXPORT_MFCApp initialization

BOOL CDEMO_EXPORT_MFCApp::InitInstance()
{
	AfxEnableControlContainer();

	// Standard initialization

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	//Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	// Change the registry key under which our settings are stored.
	SetRegistryKey(_T("Local AppWizard-Generated Applications"));



	CMainFrame* pFrame = new CMainFrame;
	m_pMainWnd = pFrame;

	// create and load the frame with its resources

	pFrame->Create(0, _T("CAD DLL - Export [VC++ Demo]"));
	pFrame->ShowWindow(SW_SHOW);
	pFrame->UpdateWindow();

	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CDEMO_EXPORT_MFCApp message handlers

