#ifndef _CADWINDOW_
#define _CADWINDOW_

#include "Window.h"
#include <cad.h>

//#define MSG_LEN 256 //the length of cErrorCode (has to be defined by user) or other message-strings

#define XMLPROGIDSCOUNT 7
#define XML_MAX_PROGIDS_LEN 23
//#define GENERATE_XML_PARAMS

const WCHAR MSXMLDOMDocProgIds[XMLPROGIDSCOUNT][XML_MAX_PROGIDS_LEN] = 
	{{L"Msxml2.DOMDocument.6.0"}, {L"Msxml2.DOMDocument.5.0"}, 
	 {L"Msxml2.DOMDocument.4.0"}, {L"Msxml2.DOMDocument.3.0"}, 
	 {L"Msxml2.DOMDocument.2.6"}, {L"Msxml.DOMDocument"}};

const int QUANTITY_OF_PARTS = 3;
const int TOOLBAR_BUTTON_SIZE = 26;
const int TOOLBAR_HEIGHT = TOOLBAR_BUTTON_SIZE + 4;
const int COMBOBOX_ITEM_SIZE = 20;
const int LABELLAYOUTWIDTH = 80;
const int ERR_MSG_LEN = 256;


const TCHAR CADFilter[] = _T("CAD files (*.dwg *.gp2 *.dxf *.rtl *.spl *.prn *.gl2 *.hpgl2 *.hpgl *.hp2 *.hp1 *.hp *.plo *.hpg *.hg *.hgl *.plt *.cgm *.svg *.svgz)|\
*.dwg;*.gp2;*.dxf;*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt;*.cgm;*.svg;*.svgz|\
AutoCAD files (*.dwg *.gp2 *.dxf)|\
*.dwg;*.gp2;*.dxf|\
HPGL/2 files (*.rtl *.spl *.prn *.gl2 *.hpgl2 *.hpgl *.hp2 *.hp1 *.hp *.plo *.hpg *.hg *.hgl *.plt)|\
*.rtl;*.spl;*.prn;*.gl2;*.hpgl2;*.hpgl;*.hp2;*.hp1;*.hp;*.plo;*.hpg;*.hg;*.hgl;*.plt|\
Computer Graphics Metafile (*.cgm)|\
*.cgm|\
Scalable Vector Graphics (*.svg *.svgz)|\
*.svg;*.svgz|\
All files (*.*)|\
*.*|");

const TCHAR SaveAsFilter[] = _T("Windows Bitmap (*.bmp)|*.bmp|JPEG image (*.jpg)|*.jpg|AutoCAD DXF (*.dxf)|*.dxf|\
Adobe Acrobat Document (*.pdf)|*.pdf;|\
HPGL/2 (*.plt)|*.plt|Adobe Flash File Format (*.swf)|*.swf|\
Computer Graphics Metafile (*.cgm)|*.cgm|\
Scalable Vector Graphics (*.svg)|*.svg|");

const TCHAR FILE_NOT_SAVED[] = _T("File not saved");
const TCHAR ERROR_CAPTION[] = _T("CAD DLL Error");
const TCHAR LIB_NOT_LOADED[] = _T(" not loaded!");
const TCHAR WARNING_CAPTION[] = _T("Warning");

class CCADWindow : public CWindow  
{
	HANDLE hCAD;
	HINSTANCE hCADImporter;
	BOOL Drag;
	HCURSOR Cursor;
	int ScaleID;
	POINTS PredPoint;
	POINT offset;
	LONG DrwMode;	
	LONG CircleDrwMode;	
	int nIsInsideInsert;
	FPOINT ScaleRect;
	double fCoef, fAbsHeight, fAbsWidth;	
	bool bDoubleBuffered;
	bool bGetArcsAsCurves;
	bool bGetTextsAsCurves;
	TCHAR sProgressMessage[ERR_MSG_LEN];
	COLORREF colorBgrnd;
public:
//	int nIsInsideInsert;
	LPARAM lScalePoint;
	HINSTANCE HInst;
	double Scale;
	HWND hwndToolBar, hwndComboBox, hwndLayoutsLabel, hwndStatusBar;
	static HWND hwndProgressDlg;
	void GetLayers();
	CCADWindow(LPCTSTR, WNDPROC, HINSTANCE, HICON, HICON, LPCTSTR, HBRUSH, UINT);
	virtual ~CCADWindow();
	void DoCreateToolBar(HWND hwndParent, HINSTANCE hInst);
	void DoCreateComboBox(HINSTANCE hInst);
	void DoCreateStatusBar(HWND hwndParent, HINSTANCE hInst);
	void SplitStatusBar(int nParts= QUANTITY_OF_PARTS);
	//void SetTextToStatusBar(LPSTR str, int part = 0);
	bool SetCurrentLayout();
	void ReSize(WPARAM wParam,LPARAM lParam);
	void MouseMove(POINTS Point);
	void RecalculateExtents();
	void FitToWindow();
	void Load();
	void SaveAs();
	void Draw(HWND Window, HDC DC);
	void BeginDrag(POINTS);
	void EndDrag(POINTS);
	void ChangeScale(LONG);
	void DrawingMode(LONG);
	void Circle(LONG);
	void ArcsAsCurves(LONG);
	void SwitchDblBuf();
	void TextsAsCurves();
	int WMPaint(HWND wnd, int Msg, int wParam, int lParam);
	PTCHAR GetProgressMessage();
};

#endif