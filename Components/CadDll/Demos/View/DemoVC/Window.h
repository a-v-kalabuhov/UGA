#ifndef _WINDOW_
#define _WINDOW_
#include <windows.h>
#include <commctrl.h>
#include <commdlg.h>

class CWindow 
{
protected:
	WNDCLASS WndClass;
	HWND hWnd;
	int nHeight, nWidth;
	HDC hMainWndDC;

public:
	CWindow(LPCTSTR, WNDPROC, HINSTANCE, HICON, HCURSOR, LPCTSTR, HBRUSH, UINT);
	~CWindow();

	HWND Create(LPCTSTR, DWORD, int, int, int, int, HMENU, LPVOID); 
	inline HWND GetWindow() {return hWnd;};
	int GetFile(HWND hwnd, PTCHAR fname, LPCTSTR filter, bool Open);
	void RePaint();
};
#endif