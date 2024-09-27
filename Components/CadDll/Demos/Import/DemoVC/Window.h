#include <windows.h>
#include <commctrl.h>
#include <commdlg.h>
#include <TCHAR.h>

class CWindow 
{
protected:
	WNDCLASS WndClass;
	HWND hWnd;
	int nHeight, nWidth;

public:
	CWindow(LPCTSTR, WNDPROC, HINSTANCE, HICON, HICON, LPCTSTR, HBRUSH, UINT);
	~CWindow();


	HWND Create(LPCTSTR, DWORD, int, int, int, int, HMENU, LPVOID); 
	inline HWND GetWindow() {return hWnd;};
	int GetFile(HWND hwnd, PTCHAR fname, LPCTSTR filter, bool Open);
	void RePaint();
};
