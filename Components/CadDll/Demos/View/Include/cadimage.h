/*
Copyright (c) 2002-2011 SoftGold software company

Module Name:

    cadimage.h

Description:

    Master include file CAD Image DLL version

*/
#ifndef _CADIAMGE_
#define _CADIAMGE_

#include <windows.h>
#include <TCHAR.h>

#define sgLibName TEXT("cad.dll") 

#define ERROR_CAD_GENERAL 1000
#define ERROR_CAD_INVALID_HANDLE ERROR_CAD_GENERAL + 1
#define ERROR_CAD_INVALID_INDEX ERROR_CAD_GENERAL + 2
#define ERROR_CAD_FILE_NOT_FOUND ERROR_CAD_GENERAL + 3
#define ERROR_CAD_FILE_READ ERROR_CAD_GENERAL + 4
#define ERROR_CAD_INVALID_CADDRAW ERROR_CAD_GENERAL + 5
#define ERROR_CAD_UNSUPFORMAT_FILE ERROR_CAD_GENERAL + 6
#define ERROR_CAD_OUTOFRESOURCES ERROR_CAD_GENERAL + 7
#define ERROR_CAD_LICENSE_RESTRICTIONS ERROR_CAD_GENERAL + 8
#define ERROR_CAD_TRIAL_PERIOD_EXPIRED ERROR_CAD_GENERAL + 9

//#define CS_STATIC_DLL

#ifdef CADIMAGE_EXPORTS
	#define CS_DLL_EXPORT
#endif

#define sgChar WCHAR

typedef sgChar *PsgChar;

typedef enum AXES { axisX=0, axisY=1, axisZ=2 } TAxes;

typedef int (WINAPI *PROGRESSPROC)(BYTE);

enum drawMode
{
	dmNormal = 0,
	dmBlack = 1,
	dmGray = 2,
};

#pragma pack(push,1)
typedef struct _CADDRAW 
{  
    DWORD Size;
    HDC DC;
    RECT R;
    BYTE DrawMode;
} CADDRAW, *LPCADDRAW;

typedef struct _CADEXPORTPARAMS
{      
    double XScale;
    BYTE Units;
    PROGRESSPROC ProgressFunc;
} CADEXPORTPARAMS, *LPCADEXPORTPARAMS;
#pragma pack(pop)

/* for this construction use CreateCADEx with third parameter */
/* typedef struct _CADPROGRESS
{  
    HANDLE CADHandle; 
    BYTE Stage;
    BYTE PercentDone;
    BOOL RedrawNow;
    RECT R; 
    PsgChar Msg;
} CADPROGRESS, *LPCADPROGRESS; */

// Soft Gold float type (float in previous version)
typedef double sgFloat;

typedef struct _FPOINT
{
	sgFloat x;
	sgFloat y;
	sgFloat z;
} FPOINT, *LPFPOINT;

typedef union _FRECT
{
	struct
	{
		sgFloat Left;
		sgFloat Top;
		sgFloat Z1;
		sgFloat Right;
		sgFloat Bottom;
		sgFloat Z2;
	} Points;
	
	struct
	{
		FPOINT TopLeft;
		FPOINT BottomRight;
	} Corners;	
} FRECT, *LPFRECT;

#pragma pack(push,1)
typedef struct _CADDATA
{
	WORD Tag;
	WORD Count;
	WORD TickCount;
	BYTE Flags;
	BYTE Style;    
	int Dimension;
    LPFPOINT DashDots;
    int DashDotsCount;
	int Color;
	LPVOID *Ticks;
	sgFloat Thickness;
	sgFloat Rotation;
	LPWSTR Layer;
	LPWSTR Text;
	LPWSTR FontName;
	HANDLE Handle;
	int Undefined1;
	sgFloat Undefined2;
	sgFloat Undefined3;
	LPVOID CADExtendedData;
	FPOINT Point1;
	FPOINT Point2;
	FPOINT Point3;
	FPOINT Point4;
	union
	{		
		struct
		{
			sgFloat Radius;
			sgFloat StartAngle;
			sgFloat EndAngle;
		} Arc;
		struct
		{
			HANDLE Block;
			FPOINT Scale;
		} Blocks;
		struct
		{
			sgFloat FHeight;
			sgFloat FScale;
			sgFloat RWidth;
			sgFloat RHeight;
			BYTE HAlign;
			BYTE VAlign;
		} Text;
		struct
		{
			LPFPOINT PolyPoints;
			int CountPointOfSegments;
		} Points;
	} DATA;
} CADDATA, *LPCADDATA;
#pragma pack(pop)
#ifndef CS_STATIC_DLL 
	typedef HANDLE (WINAPI *CADLAYER)(HANDLE, DWORD, LPCADDATA);
	typedef int    (WINAPI *CADLAYERCOUNT)(HANDLE);
	typedef int    (WINAPI *CADLAYERVISIBLE)(HANDLE, int);
	typedef int    (WINAPI *CADVISIBLE)(HANDLE, PsgChar);
	typedef HANDLE (WINAPI *CREATECAD)(HWND, PsgChar);
	typedef HANDLE (WINAPI *CREATECADEX)(HWND, PsgChar, PsgChar);
	typedef int    (WINAPI *CLOSECAD)(HANDLE);
	typedef HANDLE (WINAPI *CADLAYOUT)(HANDLE, int);	  
	typedef int    (WINAPI *CADLAYOUTBOX)(HANDLE, LPFRECT);
	typedef int    (WINAPI *CADLAYOUTNAME)(HANDLE, DWORD, PsgChar, DWORD);
	typedef int    (WINAPI *CADLAYOUTSCOUNT)(HANDLE);                            
	typedef BOOL   (WINAPI *CADLAYOUTVISIBLE)(HANDLE, int, BOOL, BOOL);
	typedef int    (WINAPI *CADSETSHXOPTIONS)(PsgChar, PsgChar, PsgChar, BOOL, BOOL);
	typedef int    (WINAPI *CADUNITS)(HANDLE, int*);
	typedef HANDLE (WINAPI *CURRENTLAYOUTCAD)(HANDLE, int, BOOL);
	typedef int    (WINAPI *DEFAULTLAYOUTINDEX)(HANDLE);
	typedef int    (WINAPI *DRAWCAD)(HANDLE, HDC, LPRECT);
	typedef int    (WINAPI *DRAWCADEX)(HANDLE, LPCADDRAW);
	typedef HANDLE (WINAPI *DRAWCADTOBITMAP)(HANDLE, LPCADDRAW);
	typedef HANDLE (WINAPI *DRAWCADTODIB)(HANDLE, LPRECT);
	typedef HANDLE (WINAPI *DRAWCADTOJPEG)(HANDLE, LPCADDRAW);
	typedef HANDLE (WINAPI *DRAWCADTOGIF)(HANDLE, LPCADDRAW);
	typedef int    (WINAPI *GETBOXCAD)(HANDLE, float*, float*);
	typedef int    (WINAPI *GETCADBORDERTYPE)(HANDLE, int*);
	typedef int    (WINAPI *GETCADBORDERSIZE)(HANDLE, double*);
	typedef int    (WINAPI *GETCADCOORDS)(HANDLE, float, float, LPFPOINT);
	typedef int    (WINAPI *GETEXTENTSCAD)(HANDLE, LPFRECT);
	typedef int    (WINAPI *GETIS3DCAD)(HANDLE, int*);
	typedef int    (WINAPI *GETLASTERRORCAD)(PsgChar, DWORD);
	typedef int	   (WINAPI *GETNEARESTENTITY)(HANDLE, PsgChar, DWORD, LPRECT, LPPOINT);
	typedef int	   (WINAPI *GETNEARESTENTITYWCS)(HANDLE, PsgChar, DWORD, LPRECT, LPPOINT, LPFPOINT);
	typedef int    (WINAPI *GETPOINTCAD)(HANDLE, LPFPOINT);
	typedef int    (WINAPI *RESETDRAWINGBOXCAD)(HANDLE);
	typedef int    (WINAPI *SAVECADTOBITMAP)(HANDLE, LPCADDRAW, PsgChar);
	typedef int    (WINAPI *SAVECADTOJPEG)(HANDLE, LPCADDRAW, PsgChar);
	typedef int    (WINAPI *SAVECADTOGIF)(HANDLE, LPCADDRAW, PsgChar);
	typedef int    (WINAPI *SAVECADTOEMF)(HANDLE, LPCADDRAW, PsgChar);
	typedef int    (WINAPI *SAVECADTOCAD)(HANDLE, LPCADEXPORTPARAMS, PsgChar);
	typedef BOOL   (WINAPI *SETBMSIZE)(int); 
	typedef int    (WINAPI *SETCADBORDERTYPE)(HANDLE, int);
	typedef int    (WINAPI *SETCADBORDERSIZE)(HANDLE, double);
	typedef int    (WINAPI *SETDEFAULTCOLOR)(HANDLE, int);
	typedef int    (WINAPI *SETDRAWINGBOXCAD)(HANDLE, LPFRECT);
	typedef int    (WINAPI *SETCLIPPINGRECTCAD)(HANDLE, LPFRECT);
	typedef int    (WINAPI *SETNULLLINEWIDTHCAD)(HANDLE, int);	
	typedef int    (WINAPI *SETPROCESSMESSAGESCAD)(HANDLE, int);
	typedef int    (WINAPI *SETPROGRESSPROC)(PROGRESSPROC);		
	typedef int    (WINAPI *SETROTATECAD)(HANDLE, float, int);
	typedef int    (WINAPI *SETSHOWLINEWEIGHTCAD) (HANDLE, int);
	typedef int    (WINAPI *STOPLOADING)();
	typedef int    (WINAPI *STRG) (LPCSTR User, LPCSTR EMail, LPCSTR Key);
	typedef int    (WINAPI *STRGA)(LPCSTR User, LPCSTR EMail, LPCSTR Key);
	typedef int    (WINAPI *STRGW)(LPCWSTR User, LPCWSTR EMail, LPCWSTR Key);
	typedef int    (WINAPI *SAVECADTOFILEWITHXMLPARAMS)(HANDLE, PsgChar, PROGRESSPROC);
	typedef int    (WINAPI *PROCESSXML)(HANDLE, PsgChar, VARIANT*);
	typedef int    (WINAPI *SAVECADWITHXMLPARAMETRS)(HANDLE, PsgChar);
#else
	#ifdef CS_DLL_EXPORT
		#define CS_API __declspec(dllexport)
	#else
		#define CS_API __declspec(dllimport)
	#endif
	extern "C"
	{
		CS_API HANDLE WINAPI CADLayer(HANDLE, DWORD, LPCADDATA);
		CS_API int    WINAPI CADLayerCount(HANDLE);
		CS_API int    WINAPI CADLayerVisible(HANDLE, int);
		CS_API int    WINAPI CADVisible(HANDLE, PsgChar);
		CS_API HANDLE WINAPI CreateCAD(HWND, PsgChar);
		CS_API HANDLE WINAPI CreateCADEx(HWND, PsgChar, PsgChar);
		CS_API int    WINAPI CloseCAD(HANDLE);	
		CS_API HANDLE WINAPI CADLayout(HANDLE, int);
		CS_API int    WINAPI CADLayoutBox(HANDLE, LPFRECT);
		CS_API int    WINAPI CADLayoutName(HANDLE, DWORD, PsgChar, DWORD);
		CS_API int	  WINAPI CADLayoutsCount(HANDLE);
		CS_API BOOL   WINAPI CADLayoutVisible(HANDLE, int, BOOL, BOOL);
        CS_API int	  WINAPI CADSetSHXOptions(PsgChar, PsgChar, PsgChar, BOOL, BOOL);
		CS_API int    WINAPI CADUnits(HANDLE, int*);
		CS_API HANDLE WINAPI CurrentLayoutCAD(HANDLE, int, BOOL);
		CS_API int	  WINAPI DefaultLayoutIndex(HANDLE);
		CS_API int    WINAPI DrawCAD(HANDLE, HDC, LPRECT);
		CS_API int    WINAPI DrawCADEx(HANDLE, LPCADDRAW);
		CS_API HANDLE WINAPI DrawCADtoBitmap(HANDLE, LPCADDRAW);
		CS_API HANDLE WINAPI DrawCADtoDIB(HANDLE, LPRECT);
		CS_API HANDLE WINAPI DrawCADtoJpeg(HANDLE, LPCADDRAW);
		CS_API HANDLE WINAPI DrawCADtoGif(HANDLE, LPCADDRAW);
		CS_API int    WINAPI GetBoxCAD(HANDLE, float*, float*);
		CS_API int    WINAPI GetCADBorderType(HANDLE, int*);
		CS_API int    WINAPI GetCADBorderSize(HANDLE, double*);
		CS_API int    WINAPI GetCADCoords(HANDLE, float, float, LPFPOINT);
		CS_API int    WINAPI GetExtentsCAD(HANDLE, LPFRECT);
		CS_API int    WINAPI GetIs3dCAD(HANDLE, int*);
		CS_API int    WINAPI GetLastErrorCAD(PsgChar, DWORD);
		CS_API int    WINAPI GetNearestEntity(HANDLE, PsgChar, DWORD, LPRECT, LPPOINT);
        CS_API int    WINAPI GetNearestEntityWCS(HANDLE, PsgChar, DWORD, LPRECT, LPPOINT, LPFPOINT);
		CS_API int    WINAPI GetPointCAD(HANDLE, LPFPOINT);
		CS_API int    WINAPIV GetPlugInInfo(PsgChar, PsgChar);
		CS_API int    WINAPI ResetDrawingBoxCAD(HANDLE);
		CS_API int    WINAPI SaveCADtoBitmap(HANDLE, LPCADDRAW, PsgChar);
		CS_API int    WINAPI SaveCADtoGif(HANDLE, LPCADDRAW, PsgChar);
		CS_API int    WINAPI SaveCADtoJpeg(HANDLE, LPCADDRAW, PsgChar);
        CS_API int    WINAPI SaveCADtoEMF(HANDLE, LPCADDRAW, PsgChar);
		CS_API int    WINAPI SaveCADtoCAD(HANDLE, LPCADEXPORTPARAMS, PsgChar);
		CS_API BOOL   WINAPI SetBMSize(int);
		CS_API int    WINAPI SetDefaultColor(HANDLE, int);
		CS_API int    WINAPI SetDrawingBoxCAD(HANDLE, LPFRECT);
		CS_API int    WINAPI SetClippingRectCAD(HANDLE, LPFRECT);
		CS_API int    WINAPI SetCADBorderType(HANDLE, int);
		CS_API int    WINAPI SetCADBorderSize(HANDLE, double);
		CS_API int    WINAPI SetNullLineWidthCAD(HANDLE, int);
        CS_API int    WINAPI SetProcessMessagesCAD(HANDLE, int);
		CS_API void   WINAPI SetProgressProc(PROGRESSPROC);
		CS_API int    WINAPI SetRotateCAD(HANDLE, float, int);
		CS_API int    WINAPI SetShowLineWeightCAD(HANDLE, int);
		CS_API int    WINAPI StopLoading();
		CS_API int    WINAPI StRg(LPCSTR, LPCSTR, LPCSTR);
		CS_API int    WINAPI StRgA(LPCSTR, LPCSTR, LPCSTR);
		CS_API int    WINAPI StRgW(LPCWSTR, LPCWSTR, LPCWSTR);
		CS_API int    WINAPI SaveCADtoFileWithXMLParams(HANDLE, PsgChar, PROGRESSPROC);
		CS_API int    WINAPI ProcessXML(HANDLE, PsgChar, VARIANT*);
		CS_API int    WINAPI SaveCADWithXMLParametrs(HANDLE, PsgChar);		
	}
#endif

#endif
