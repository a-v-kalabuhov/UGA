#ifndef _SGADD_
#define _SGADD_

#include <windows.h>
#include "cad.h"
#include <TCHAR.h>

typedef struct _PARAM
{
	HWND hWnd;
	HDC hDC;
	POINT offset;
	double Scale;
	LONG DrawMode;
	LONG CircleDrawMode;
	bool GetArcsCurves;
	bool GetTextsCurves;
	int *IsInsideInsert;
} PARAM, *LPPARAM;

typedef struct _LAYER
{
	PTCHAR Name;
	int Count;	
} LAYER, *LPLAYER;

LONG Round(float a);
POINT GetPoint(FPOINT Point, POINT offset, double Scale);
void sgMoveTo(HDC hDC, POINT Point);
void sgLineTo(HDC hDC, POINT Point);
void sgSetPixel(HDC hDC, POINT Point, COLORREF Color);
void DrawPolyInsteadSpline(LPFPOINT DP, int Count, LPPARAM Param);
WCHAR * ConvertToUnicode(char * src);
char * ConvertToAnsi(WCHAR * src);
TCHAR * GetConst(const char * src);
TCHAR * sgCharToTCHAR(PsgChar src);
PsgChar TCHARtosgChar(TCHAR * src);

extern double BoxLeft, BoxRight, BoxTop, BoxBottom;

#endif
