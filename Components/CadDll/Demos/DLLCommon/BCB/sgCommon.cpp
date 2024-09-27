//---------------------------------------------------------------------------

#pragma hdrstop

#include "sgCommon.h"
#include <vcl.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)

void InitSHX(CADSETSHX fn)
{
  WideString shx_path = ExtractFilePath(Application->ExeName) + "..\\..\\..\\SHX\\";
  WideString def_font = "simplex.shx";
  fn(shx_path.c_bstr(), shx_path.c_bstr(), def_font.c_bstr(), true, false);
}

bool IsRasterFormat(WideString ext)
{
	if (ext.LowerCase() == ".bmp")
		return true;
	if (ext.LowerCase() == ".png")
		return true;
	if (ext.LowerCase() == ".jpg")
		return true;
	if (ext.LowerCase() == ".gif")
		return true;
	if (ext.LowerCase() == ".jpeg")
		return true;
	return false;
}

