#ifndef __SGINITSHX__
#define __SGINITSHX__

#include <windows.h>

typedef int    (WINAPI *CADSETSHX)(wchar_t*, wchar_t*, wchar_t*, BOOL, BOOL);

void InitSHX( CADSETSHX setoptions );
bool IsRasterFormat(TCHAR * ext);

#endif