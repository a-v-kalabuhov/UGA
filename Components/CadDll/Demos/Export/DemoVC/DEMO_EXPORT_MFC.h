// DEMO_EXPORT_MFC.h : main header file for the DEMO_EXPORT_MFC application
//

#if !defined(AFX_DEMO_EXPORT_MFC_H__1AD52AA3_EFD1_11D7_BE83_444553540001__INCLUDED_)
#define AFX_DEMO_EXPORT_MFC_H__1AD52AA3_EFD1_11D7_BE83_444553540001__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

/////////////////////////////////////////////////////////////////////////////
// CDEMO_EXPORT_MFCApp:
// See DEMO_EXPORT_MFC.cpp for the implementation of this class
//

class CDEMO_EXPORT_MFCApp : public CWinApp
{
public:
	CDEMO_EXPORT_MFCApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDEMO_EXPORT_MFCApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

public:
	//{{AFX_MSG(CDEMO_EXPORT_MFCApp)

	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DEMO_EXPORT_MFC_H__1AD52AA3_EFD1_11D7_BE83_444553540001__INCLUDED_)
