#include "Window.h"
#include "cadimage.h"
#include "TCHAR.h"

//#pragma warning(disable : 4996)

#define MSG_LEN 256 //the length of cErrorCode (has to be defined by user) or other message-strings

#define XMLPROGIDSCOUNT 7
#define XML_MAX_PROGIDS_LEN 23

const WCHAR MSXMLDOMDocProgIds[XMLPROGIDSCOUNT][XML_MAX_PROGIDS_LEN] = 
	{{L"Msxml2.DOMDocument.6.0"}, {L"Msxml2.DOMDocument.5.0"}, 
	 {L"Msxml2.DOMDocument.4.0"}, {L"Msxml2.DOMDocument.3.0"}, 
	 {L"Msxml2.DOMDocument.2.6"}, {L"Msxml.DOMDocument"}};

const float ROTATION_ANGLE = 10.0f;

const int QUANTITY_OF_PARTS = 3;
const int QUANTITY_OF_BUTTONS = 9;
const int TOOLBAR_BUTTON_SIZE = 26;
const int COMBOBOX_ITEM_SIZE = 20;

const TCHAR LOADING_STATUS[MSG_LEN] = _T("Load file... ");
const TCHAR EXPORT_STATUS[MSG_LEN] = _T("Export file... ");
const TCHAR MailTo[] = _T("Mailto:info@cadsofttools.com");
const TCHAR URL[] = _T("http://www.cadsofttools.com/");

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
const TCHAR BMPFilter[] = _T("Windows Bitmap (*.bmp)|*.bmp|");
const TCHAR MetafileFilter[] = _T("Windows Enhanced Metafile (*.emf)|*.emf|");
const TCHAR SaveAsFilter[] = _T("Windows Bitmap (*.bmp)|*.bmp|JPEG image (*.jpg)|*.jpg|\
AutoCAD DXF (*.dxf)|*.dxf|\
HPGL/2 (*.plt)|*.plt|\
Adobe Acrobat Document (*.pdf)|*.pdf|\
Adobe Flash File Format (*.swf)|*.swf|\
Computer Graphics Metafile (*.cgm)|*.cgm|\
Scalable Vector Graphics (*.svg)|*.svg|");

const TCHAR FILE_NOT_SAVED[] = _T("File not saved");
const TCHAR ERROR_CAPTION[] = _T("Error");
const TCHAR LIB_NOT_LOADED[] = _T(" not loaded!");
const TCHAR WARNING_CAPTION[] = _T("Warning");
const TCHAR WAIT_LABEL[] = _T("The program is in progress. Please wait.");
const TCHAR WAIT_STATUS[] = _T("Please wait...");
const TCHAR NO_FILE_LOADED_STATUS[] = _T("No file loaded");
const TCHAR IS_3D_DRAWING_STATUS[] = _T("Is 3D drawing");
const TCHAR RESET_DRAWING_BOX_LABEL[] = _T("Please reset drawing box for activation \"Nearest point mode\".");
const TCHAR UNITS_TEXT[] = _T("units");

const int TOOLBAR_SIZE = 32;

typedef struct _CADOPTIONS 
{
	int NullLineWidth;
	bool IsDrawingBox;
	bool IsShowLineWeight;
    bool IsNearestPointMode;
	int IsLoadFromMemory;
} CADOPTIONS, *LPCADOPTIONS;

class CMainWindow : public CWindow
{
#ifndef CS_STATIC_DLL 
	HINSTANCE CADDLL;
	static CADLAYER CADLayer;
	static CADLAYERCOUNT CADLayerCount;
	static CADLAYERVISIBLE CADLayerVisible;
	static CADVISIBLE CADVisible;	
	static CLOSECAD CloseCAD;
	static CREATECAD CreateCAD;
	static CREATECADEX CreateCADEx;
	static CADLAYOUT CADLayout;
    static CADLAYOUTBOX CADLayoutBox;
	static CADLAYOUTNAME CADLayoutName;
	static CADLAYOUTSCOUNT CADLayoutsCount;
	static CADSETSHXOPTIONS CADSetSHXOptions;
	static CADLAYOUTVISIBLE CADLayoutVisible;
	static CURRENTLAYOUTCAD CurrentLayoutCAD;
	static DEFAULTLAYOUTINDEX DefaultLayoutIndex;
	static DRAWCADEX DrawCADEx;
	static DRAWCADTOJPEG DrawCADtoJpeg;
	static DRAWCADTODIB DrawCADtoDIB;
	static GETBOXCAD GetBoxCAD;
	static GETCADBORDERTYPE GetCADBorderType;
	static GETCADBORDERSIZE GetCADBorderSize;
	static GETCADCOORDS GetCADCoords;
	static GETEXTENTSCAD GetExtentsCAD;
	static GETIS3DCAD GetIs3dCAD;
	static GETLASTERRORCAD GetLastErrorCAD;
	static GETNEARESTENTITY GetNearestEntity;
	static GETPOINTCAD GetPointCAD;	
	static RESETDRAWINGBOXCAD ResetDrawingBoxCAD;
	static SAVECADTOBITMAP SaveCADtoBitmap;
	static SAVECADTOJPEG SaveCADtoJpeg;
	static SAVECADTOEMF SaveCADtoEMF;
	static SAVECADTOCAD SaveCADtoCAD;
	static SETDEFAULTCOLOR SetDefaultColor;
	static SETCADBORDERTYPE SetCADBorderType;
	static SETCADBORDERSIZE SetCADBorderSize;
	static SETDRAWINGBOXCAD SetDrawingBoxCAD;
	static SETNULLLINEWIDTHCAD SetNullLineWidthCAD;
	static SETPROCESSMESSAGESCAD SetProcessMessagesCAD;
	static SETPROGRESSPROC SetProgressProc;
	static SETROTATECAD SetRotateCAD;	
	static SETSHOWLINEWEIGHTCAD SetShowLineWeightCAD;
	static STOPLOADING StopLoading;
	static SAVECADTOFILEWITHXMLPARAMS SaveCADtoFileWithXMLParams;
	static SAVECADWITHXMLPARAMETRS SaveCADWithXMLParametrs;
#endif
	CADOPTIONS optionsCAD;
	BOOL drag;
	BYTE DrwMode;
	COLORREF colorBgrnd;
	FRECT frectExtentsCAD;
	HANDLE CADImage;
	HBRUSH brushBackground;
	HCURSOR curWait, curHand, curTarget, curDefault;
	float fAbsWidth; 
	float fAbsHeight;
	TCHAR sProgressMessage[MSG_LEN];
	FPOINT ScaleRect;
	double fKoef;		
	int nScale;
	bool bIsPocessing;
	static bool IsAppChangingList;	
	CADDRAW CADDraw;
	POINT OldNearestPoint;
	int iBorderType;
	double dBorderSize;
	FRECT DrawRect;
	POINT DownPoint;
	bool Is3D();
	void DestroyLayersDlg();
	void DoMousePosition(POINTS PointOnScr);	
	void FillLayersList();
	static BOOL CALLBACK AboutDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK ControlProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);
	static BOOL CALLBACK LayersDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam);
	static BOOL CALLBACK PropertiesDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam);
	static BOOL CALLBACK ProgressDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam);
	static BOOL CALLBACK PictureDialogProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam);
	void SplitStatusBar(int nParts= QUANTITY_OF_PARTS);			
	void RecalculateExtents();
	HGLOBAL LoadFile(char * FileName);
	static void ShellOpen(HWND hWindow, TCHAR * file);
public:
	bool bRotated3D, bIsRotated;
	HINSTANCE hInstance;
	HWND hwndStatusBar, hwndToolBar, hwndComboBox;		
	static HWND hwndLayersDlg;
	static HWND hwndPropertiesDlg;
	static HWND hwndProgressDlg;
	static HWND hwndPictureDlg;

	CMainWindow(LPCTSTR, WNDPROC, HINSTANCE, HICON, HCURSOR, LPCTSTR, HBRUSH, UINT);
	virtual ~CMainWindow();
	void Load(CADOPTIONS CADOpts);
	void Draw();
	void LButtonDown(POINTS);
	void LButtonUp(POINTS);
	void MouseMove(POINTS);		
	void ChangeView(BYTE);	
	void CloseImage();	
	void DoCreateStatusBar(HWND hwndParent, HINSTANCE hInst);
	void DoCreateToolBar(HWND hwndParent, HINSTANCE hInst);
	void DoCreateComboBox(HINSTANCE hInst);
	void DrawNearestMark(POINT NewPoint, LPPOINT OldPoint);
	bool GetIsDrawingBox();
	bool GetIsPocessing();
	bool GetIsShowLineWeight();
	bool GetIsNearestPointMode();
	int  GetNullLineWidth();
	PTCHAR GetProgressMessage();
	bool ResetDrawingBox();
	void ReSize(WPARAM wParam,LPARAM lParam);		
	void RotateCAD(const AXES axis, const float angle);		
	void SaveAs();
	void SaveAsBMP();
	void SaveAsEMF();
	bool SetDrawingBox();	
	void SetBgrndColor(const COLORREF color);
	void SetDefColor();
	bool SetCurrentLayout();
	bool SetNullLineWidth(int NullLineWidth);
	bool SetIsNearestPointMode(bool Checked);
	bool SetOptionsCAD(CADOPTIONS CADOpts);
	void SetTextToStatusBar(LPCTSTR str, int part = 0);	
	void ShowAboutDlg();
	void ShowProgressDlg(bool Visible, const TCHAR * Msg);
	void SetProgressValue(BYTE PercentDone);
	void ShowLayersDlg(bool Visible=true);
	void ShowPropertiesDlg(bool Visible=true);
	void ShowPictureDlg(bool Visible);
	bool ShowLineWeight(bool IsShow=false);
	void StoppingLoad();
	bool StretchDrawDIB (HGLOBAL hMemDIB, HDC dstDC, RECT * R);
	int SetBorder();
	void FitToWindow(RECT ClientR, LPFRECT Rect);
	void ScaleRectangleF(double Scale, POINT Pos, LPFRECT Rect);
	void MouseWheel(SHORT Keys, SHORT Delta, POINTS Point);
	void Fit();
	bool Print();
};

