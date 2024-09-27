/*
Copyright (c) 2002-2003 SoftGold software company

Module Name:

    dxfexp.h

Description:

    Master include file for DXF Exporter DLL version

*/
#ifndef _DXFEXP_
#define _DXFEXP_

#include <windows.h>

#define sgLibName _T("cad.dll")
#define         XP_USE01MM      1;
#define         XP_PARSEWHITE   2;
#define         XP_ALTERNATIVEBLACK   4;
const char acR2000 = 6; 
const char acR2004 = 7; 

typedef int     (WINAPI *EXPORTTODXF)(HANDLE, LPTSTR, DWORD);
typedef int     (WINAPI *EXPORTTOCADFILE)(HANDLE, LPTSTR, DWORD, CHAR);
typedef int     (WINAPI *GETLASTERRORCAD)(LPTSTR, DWORD);

#endif

