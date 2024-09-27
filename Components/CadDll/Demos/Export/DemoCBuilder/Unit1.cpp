//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include <tchar.h>

#include "Unit1.h"
#include <dxfexp.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::RaiseError(String err)
{
  wchar_t msg[1024];
  memset(msg, 0, sizeof(msg));
  GetLastErrorCAD(msg, sizeof(msg));
  throw(Exception(err + " " + String(msg)));
}

void __fastcall TForm1::Button1Click(TObject *Sender)
{
  if (!ExportToDXF) return;
  if (!OpenDialog1->Execute()) return;
  TMetafile *MF = new TMetafile(); 

  DWORD F = 0;
  if (CheckBox2->Checked) F = F | XP_PARSEWHITE;
  if (CheckBox3->Checked) F = F | XP_ALTERNATIVEBLACK;
  try
  {
    MF->LoadFromFile(OpenDialog1->FileName);
	String S = ChangeFileExt(OpenDialog1->FileName, ".dxf");
	if (ExportToDXF((HANDLE)MF->Handle, S.c_str(), F) == 0)
	  RaiseError("");
	S = ChangeFileExt(OpenDialog1->FileName, ".dwg");
	if (ExportToCAD((HANDLE)MF->Handle, S.c_str(), F, acR2004) == 0)
	  RaiseError("");
  }
  __finally
  {
	delete MF;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Close();        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  CADExp = LoadLibrary(sgLibName);
  if (CADExp)
  {
	ExportToDXF = (EXPORTTODXF) GetProcAddress(CADExp, "ExportToDXF");
	ExportToCAD = (EXPORTTOCADFILE) GetProcAddress(CADExp, "ExportToCADFile");
	GetLastErrorCAD = (GETLASTERRORCAD) GetProcAddress(CADExp, "GetLastErrorCAD");
  }
  else
  {
	ExportToDXF = NULL;
	ExportToCAD = NULL;
	GetLastErrorCAD = NULL;
	TVarRec vr[] = {sgLibName, TEXT("not loaded!")};
	MessageBox(Application->Handle, Format(TEXT("%s %s"), vr, 2).t_str(), sgLibName), _T("Error"), 0);
  }

}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormDestroy(TObject *Sender)
{
  if (CADExp)  FreeLibrary(CADExp);
}
//---------------------------------------------------------------------------

 
