//---------------------------------------------------------------------------

#ifndef sgCommonH
#define sgCommonH

#include <windows.h>
#include <vcl.h>

typedef int    (WINAPI *CADSETSHX)(wchar_t*, wchar_t*, wchar_t*, BOOL, BOOL);

void InitSHX(CADSETSHX fn);
bool IsRasterFormat(WideString ext);

//---------------------------------------------------------------------------
#endif
