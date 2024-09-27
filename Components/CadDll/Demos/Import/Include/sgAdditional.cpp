#include <sgAdditional.h>

#pragma warning(disable : 4996)

sgFloat BoxLeft, BoxRight, BoxTop, BoxBottom;

LONG Round(float a)
{
	LONG fa = (LONG)a;
	
	float b = a - fa;
	if (b < 0)
		return (b <= -0.5) ? (fa - 1):fa;
	else
		return (b >= 0.5) ? (fa + 1):fa;
}

POINT GetPoint(FPOINT Point, POINT offset, sgFloat Scale)
{
	POINT P;
	P.x = Round((float)((Point.x - BoxLeft) * Scale)) + offset.x;
	P.y = Round((float)((-Point.y + BoxTop) * Scale)) + offset.y;
	return P;
}

void sgMoveTo(HDC hDC, POINT Point)
{
	MoveToEx(hDC, Point.x, Point.y, 0);  
}

void sgLineTo(HDC hDC, POINT Point)
{
	LineTo(hDC, Point.x, Point.y);
}

void sgSetPixel(HDC hDC, POINT Point, COLORREF Color)
{
	SetPixel(hDC, Point.x, Point.y, Color);
}

void DrawPolyInsteadSpline(LPFPOINT DP, int Count, LPPARAM Param)
{
int i;
POINT *Pts;
	Pts = new POINT [Count];
	for (i = 0; i < Count; i++)
		Pts[i] = GetPoint(DP[i], Param->offset, Param->Scale);
	Polyline(Param->hDC, Pts, Count);
	delete [] Pts;
}

WCHAR * ConvertToUnicode(char * src)
{
	WCHAR * dst;
	int len = MultiByteToWideChar(CP_ACP, 0, src, -1, NULL, 0);
	if (len > 0)
	{
		dst = (WCHAR *)malloc(len * sizeof(WCHAR));
		len = MultiByteToWideChar(CP_ACP, 0, src, strlen(src), dst, len);
		dst[len] = 0;
	}
	else
	{
		dst = (WCHAR *)malloc(sizeof(WCHAR));
		*dst = 0x0000;
	}
	return dst;
}

char * ConvertToAnsi(WCHAR * src)
{
	char * dst;
	int len = WideCharToMultiByte(CP_ACP, 0, src, wcslen(src), NULL, 0, NULL, NULL);
	if (len > 0)
	{
		dst = (char *)malloc(len + 1);
		len = WideCharToMultiByte(CP_ACP, 0, src, wcslen(src), dst, len, NULL, NULL);
		dst[len] = 0;
	}
	else
	{
		dst = (char *)malloc(sizeof(char));
		*dst = '\0';
	}
	return dst;
}

TCHAR * GetConst(const char * src)
{
	TCHAR * dst;
#ifdef UNICODE
	dst = ConvertToUnicode((char *)src);
#else
	int len = strlen(src);
	dst = (char *)malloc(len + 1);
	strcpy(dst, src);
#endif
	return (TCHAR * )dst;
}

PsgChar TCHARtosgChar(TCHAR * src)
{
	PsgChar dst;
#ifdef USE_UNICODE_SGDLL
	#ifdef UNICODE
		int len = _tcslen(src);
		int sz = (len + 1) * sizeof(TCHAR);
		dst = (PsgChar)malloc(sz);
		memcpy(dst, src, sz);
    #else
		dst = ConvertToUnicode(src);
	#endif
#else
	#ifdef UNICODE
		dst = ConvertToAnsi(src);
	#else
		dst = GetConst(src);
	#endif
#endif	
	return dst;
}

TCHAR * sgCharToTCHAR(PsgChar src)
{
	TCHAR * dst;
#ifdef USE_UNICODE_SGDLL
	#ifdef UNICODE
		int len = _tcslen(src);
		int sz = (len + 1) * sizeof(TCHAR);
		dst = (TCHAR *)malloc(sz);
		memcpy(dst, src, sz);
    #else
		dst = ConvertToAnsi(src);
	#endif
#else
	#ifdef UNICODE
		dst = ConvertToUnicode(src);
	#else
		dst = GetConst(src);
	#endif
#endif	
	return dst;
}