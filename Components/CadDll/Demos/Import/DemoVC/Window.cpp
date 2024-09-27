// Window.cpp: implementation of the CWindow class.
//
//////////////////////////////////////////////////////////////////////
#include "Window.h"
#include <TCHAR.h>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CWindow::CWindow(LPCTSTR szClassName, WNDPROC WndProc, HINSTANCE hInst,
                 HICON hIcon, HICON hCursor, LPCTSTR lpszMenuName,
                 HBRUSH color, UINT style)
{
    WndClass.lpszClassName = szClassName;
    WndClass.lpfnWndProc = WndProc;
    WndClass.hInstance = hInst;
    WndClass.hIcon = hIcon;
    WndClass.hCursor = hCursor;
    WndClass.lpszMenuName = lpszMenuName;
    WndClass.hbrBackground = color;
    WndClass.style = style;
    WndClass.cbClsExtra = 0;
    WndClass.cbWndExtra = 0;

    RegisterClass(&WndClass);
}

CWindow::~CWindow()
{

}

HWND CWindow::Create(LPCTSTR lpWindowName, DWORD dwStyle,
                     int x, int y, int nWidth, int nHeight,
                       HMENU hMenu, LPVOID lpParam)
{
	this->nHeight = nHeight;
	this->nWidth = nWidth;
	hWnd = CreateWindow(WndClass.lpszClassName, lpWindowName, dwStyle,
		x, y, nWidth, nHeight, NULL, hMenu, WndClass.hInstance, lpParam);
	return hWnd;
}

int CWindow::GetFile(HWND hwnd, PTCHAR fname, LPCTSTR filter, bool Open)
{
	OPENFILENAME fn;

	int filterlen = _tcslen(filter);
	PTCHAR cfilter = (PTCHAR) malloc((filterlen + 1) * sizeof(TCHAR));
	memcpy(cfilter, filter, (filterlen + 1) * sizeof(TCHAR));

	int len = _tcslen(cfilter);
	for(int i=0; i < len; i++)
	{
		if (cfilter[i] == _T('|'))
			cfilter[i] = _T('\0');
	}
	memset(&fn, 0, sizeof(OPENFILENAME));
	fn.lStructSize = sizeof(OPENFILENAME);
	fn.hwndOwner = hwnd;
	fn.hInstance = WndClass.hInstance;
	if (!Open) fn.lpstrDefExt = _T("jpg");
	fn.lpstrFilter = cfilter;
	fn.nFilterIndex = 1;
	fn.lpstrFile = fname;
	fn.nMaxFile = 256;
	fn.nMaxFileTitle = 1;
	fn.Flags = OFN_HIDEREADONLY | OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST;

	BOOL result;
	if (Open) 
		result = GetOpenFileName(&fn);
	else
		result = GetSaveFileName(&fn);
	free(cfilter);
	return result;
}

void CWindow::RePaint()
{
	RECT rect;

	GetClientRect(hWnd, &rect);
	InvalidateRect(hWnd, &rect, FALSE);
}
