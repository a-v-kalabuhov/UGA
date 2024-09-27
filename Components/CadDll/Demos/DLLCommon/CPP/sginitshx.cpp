#include <windows.h>
#include <TCHAR.h>
#include <sginitshx.h>

void InitSHX( CADSETSHX setoptions )
{
	wchar_t path_name[MAX_PATH];
	wchar_t *def_font_name = L"simplex.shx";
	int i = GetModuleFileNameW(0, path_name, sizeof(path_name) / sizeof(wchar_t));
	while (path_name[--i] != '\\') {};
	path_name[i] = 0;
	wcscat_s(path_name, L"\\..\\..\\..\\SHX\\");
	setoptions(path_name, path_name, def_font_name, true, false);
}

bool IsRasterFormat(TCHAR * ext)
{
	if (ext == NULL)
		return false;

	if (_tcscmp(ext, _T(".bmp")) == 0)
		return true;
	if (_tcscmp(ext, _T(".png")) == 0)
		return true;
	if (_tcscmp(ext, _T(".jpg")) == 0)
		return true;
	if (_tcscmp(ext, _T(".gif")) == 0)
		return true;
	if (_tcscmp(ext, _T(".jpeg")) == 0)
		return true;
	if (_tcscmp(ext, _T(".tif")) == 0)
		return true;
	if (_tcscmp(ext, _T(".tiff")) == 0)
		return true;
	return false;
}
