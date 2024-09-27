//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
#include <cadimage.h>
#include <sgcommon.h>
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfrmCADImageDLLdemo *frmCADImageDLLdemo;

inline float min(float a, float b)
{
	return (a < b)? a: b;
}

void TfrmCADImageDLLdemo::Error()
{
  sgChar buff[256];
  if (GetLastErrorCAD(buff, sizeof(buff) % sizeof(sgChar)));
    throw(Exception(buff));
}

//---------------------------------------------------------------------------
__fastcall TfrmCADImageDLLdemo::TfrmCADImageDLLdemo(TComponent* Owner)
		: TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TfrmCADImageDLLdemo::FormCreate(TObject *Sender)
{
  PaintBox1->Align = alClient;
  OpenDialog1->Filter = "CAD Drawings|*.dwg;*.dxf;*.plt;*.hgl;*.hg;*.hpg;*.plo;*.hp;*.hp1;*.hp2;*.hpgl;*.hpgl2;*.gl2;*.prn;*.spl;*.rtl;*.cgm;*.svg";
  OpenDialog1->Filter = OpenDialog1->Filter + "|All files|*.*";
  CADHandle = 0;
  nDestOffX = 0;
  nDestOffY = 0;
  bFileLoaded = false;
	#ifndef CS_STATIC_DLL
	CADImageDLL = LoadLibrary(sgLibName);
  if (CADImageDLL)
  {
	CADLayout = (CADLAYOUT) GetProcAddress(CADImageDLL, "CADLayout");
	CADLayoutName = (CADLAYOUTNAME) GetProcAddress(CADImageDLL, "CADLayoutName");
	CADLayoutsCount = (CADLAYOUTSCOUNT) GetProcAddress(CADImageDLL, "CADLayoutsCount");
	CADUnits = (CADUNITS) GetProcAddress(CADImageDLL, "CADUnits");
	CloseCAD = (CLOSECAD) GetProcAddress(CADImageDLL, "CloseCAD");
	CreateCAD = (CREATECAD) GetProcAddress(CADImageDLL, "CreateCAD");
	CurrentLayoutCAD = (CURRENTLAYOUTCAD) GetProcAddress(CADImageDLL, "CurrentLayoutCAD");
	DefaultLayoutIndex = (DEFAULTLAYOUTINDEX) GetProcAddress(CADImageDLL, "DefaultLayoutIndex");
	DrawCAD = (DRAWCAD) GetProcAddress(CADImageDLL, "DrawCAD");
	DrawCADEx = (DRAWCADEX) GetProcAddress(CADImageDLL, "DrawCADEx");
	GetBoxCAD = (GETBOXCAD) GetProcAddress(CADImageDLL, "GetBoxCAD");
	SaveCADtoBitmap = (SAVECADTOBITMAP) GetProcAddress(CADImageDLL, "SaveCADtoBitmap");
	SaveCADtoJpeg = (SAVECADTOJPEG) GetProcAddress(CADImageDLL, "SaveCADtoJpeg");
	SaveCADtoGif = (SAVECADTOGIF) GetProcAddress(CADImageDLL, "SaveCADtoGif");
	SaveCADtoEMF = (SAVECADTOEMF) GetProcAddress(CADImageDLL, "SaveCADtoEMF");
	SaveCADtoFileWithXMLParams = (SAVECADTOFILEWITHXMLPARAMS) GetProcAddress(CADImageDLL, "SaveCADtoFileWithXMLParams");
	GetLastErrorCAD = (GETLASTERRORCAD)GetProcAddress(CADImageDLL, "GetLastErrorCAD");
	CADSetSHXOptions = (CADSETSHXOPTIONS)GetProcAddress(CADImageDLL, "CADSetSHXOptions");
	InitSHX(CADSetSHXOptions);
  }
  else
  {
	CADLayout = NULL;
	CADLayoutName = NULL;
	CADLayoutsCount = NULL;
	CADUnits = NULL;
	CloseCAD = NULL;
	CreateCAD = NULL;
	CurrentLayoutCAD = NULL;
	DefaultLayoutIndex = NULL;
	DrawCAD = NULL;
	DrawCADEx = NULL;
	GetBoxCAD = NULL;
	SaveCADtoBitmap = NULL;
	SaveCADtoGif = NULL;
	SaveCADtoJpeg = NULL;
	SaveCADtoEMF = NULL;
	SaveCADtoFileWithXMLParams = NULL;
	GetLastErrorCAD = NULL;
	MessageDLLNotLoaded();
  }
  #endif
  FDown = false;
  FOffset = Point(0, 0);
  FDownPos = Point(0, 0);
}
//---------------------------------------------------------------------------

void __fastcall TfrmCADImageDLLdemo::Open1Click(TObject *Sender)
{
//  if (!OpenDialog1->Execute()) return;

//  if (CADHandle) CloseCAD(CADHandle);
//  CADHandle = CreateCAD(Application->Handle, OpenDialog1->FileName.c_str());
//  PaintBox1->Refresh();
}
//---------------------------------------------------------------------------
void __fastcall TfrmCADImageDLLdemo::FormDestroy(TObject *Sender)
{
  if (CADHandle) CloseCAD(CADHandle);
  if (CADImageDLL) FreeLibrary(CADImageDLL);
}
//---------------------------------------------------------------------------
void __fastcall TfrmCADImageDLLdemo::PaintBox1Paint(TObject *Sender)
{
  if ((CADHandle) && !bFileLoaded)
  {
//    int nDestOffX = 0;
//    int nDestOffY = 0;

	int nUnits;
	CADUnits(CADHandle,&nUnits);

	HDC hDC = GetDC(0);
	float horRes = 0;
//    float vertRes = 0;
	if (nUnits == 1)
	{
	  horRes = (float)GetDeviceCaps(hDC,HORZSIZE) / GetDeviceCaps(hDC,HORZRES);
//      vertRes = (float)GetDeviceCaps(hDC,VERTSIZE) / GetDeviceCaps(hDC,VERTRES);
	}
	else
	{
	  horRes = (float)GetDeviceCaps(hDC,HORZSIZE) / GetDeviceCaps(hDC,HORZRES) / 25.4;
//      vertRes = (float)GetDeviceCaps(hDC,VERTSIZE) / GetDeviceCaps(hDC,VERTRES) / 25.4;
	}
	ReleaseDC(0, hDC);

	GetBoxCAD(CADHandle,&CADWidth, &CADHeight);

	float fCADSidesRatio = (float)CADWidth / CADHeight;
	float fDestRatio = (float)PaintBox1->ClientRect.Width() / (float)PaintBox1->ClientRect.Height();

    RECT rect;

	rect.left = 0;
    rect.top = 0;

    if (fDestRatio > fCADSidesRatio)
      rect.right = PaintBox1->ClientRect.Bottom * fCADSidesRatio;
    else
	  rect.right = PaintBox1->ClientRect.Right;
    rect.bottom = rect.right / fCADSidesRatio;

	nScale = (float)ClientRect.Right/CADWidth * horRes;
    cbScale->Text = IntToStr(int(nScale * 100)) + "%";

	RefreshDrawing();
  }
  else
  {
   RefreshDrawing();
  }

}
//---------------------------------------------------------------------------
void __fastcall TfrmCADImageDLLdemo::tbOpenClick(TObject *Sender)
{
  if (!CADImageDLL)
  {
	   MessageDLLNotLoaded();
	   return;
	}
	int Cnt, i;
	sgChar LayoutName[100];
	HANDLE Layout;
  if (!OpenDialog1->Execute()) return;

  if (CADHandle)
	CloseCAD(CADHandle);

  AnsiString s = __CGVER__;
  CADHandle = CreateCAD(Application->Handle, OpenDialog1->FileName.t_str());
  if (CADHandle == NULL) Error();

  cbLayouts->Clear();
  Cnt = CADLayoutsCount(CADHandle);
  for ( i=0;i < Cnt;i++)
  {
	CADLayoutName(CADHandle, i, LayoutName, 100);
	Layout = CADLayout(CADHandle, i);
		cbLayouts->Items->AddObject(LayoutName, (TObject*)Layout);
  }
  cbLayouts->ItemIndex = DefaultLayoutIndex(CADHandle);

  PaintBox1->Refresh();
  bFileLoaded = true;
  ProcessMenuItems(true);
}
//---------------------------------------------------------------------------


void __fastcall TfrmCADImageDLLdemo::cbScaleChange(TObject *Sender)
{
  AnsiString cScaleValue;

  cScaleValue = cbScale->Items->Strings[cbScale->ItemIndex];
  cScaleValue.Delete(cScaleValue.Length(), 1);

  nScale = (double)StrToFloat(cScaleValue)/100;
  RefreshDrawing();
}
//---------------------------------------------------------------------------

void __fastcall TfrmCADImageDLLdemo::mmiSaveAsClick(TObject *Sender)
{
	if (!SaveDialog1->Execute() || (!(bool)CADHandle && !bFileLoaded)) return;

	String FileName = SaveDialog1->FileName;
	String FileExt = ExtractFileExt(FileName);
	float W, H, koef;
	GetBoxCAD(CADHandle, &W, &H);
	koef = min(800 / W, 600 / H);
	W *= koef;
	H *= koef;
	String GraphicParams = Format(TEXT("<GraphicParametrs><PixelFormat>6</PixelFormat><Width>%d</Width><Height>%d</Height><DrawMode>0</DrawMode><DrawRect Left=\"0\" Top=\"0\" Right=\"%d\" Bottom=\"%d\"/></GraphicParametrs>"), OPENARRAY(TVarRec, ((int)W, (int)H, (int)W, (int)H)));
	String CADParams = Format(TEXT("<CADParametrs><BackgroundColor>%d</BackgroundColor><DefaultColor>%d</DefaultColor><XScale>1</XScale></CADParametrs>"), OPENARRAY(TVarRec, (16777216, 0)));
	String ExportParams = Format(TEXT("<?xml version=\"1.0\" encoding=\"utf-16\" ?><ExportParams><Filename>%s</Filename><Ext>%s</Ext>") + CADParams + GraphicParams + TEXT("</ExportParams>"), OPENARRAY(TVarRec, (FileName, FileExt)));

	if (SaveCADtoFileWithXMLParams(CADHandle, ExportParams.c_str(), NULL) == 0)
	{
		MessageBox(this->Handle, TEXT("File not saved"), TEXT("CAD DLL Error"), MB_ICONERROR);
	}
	else
	{
		String FILE_SAVED_AS = TEXT("File saved as: ") + FileName;
		MessageBox(this->Handle, FILE_SAVED_AS.c_str(), TEXT(""), MB_ICONINFORMATION);
	}
}
//---------------------------------------------------------------------------

void TfrmCADImageDLLdemo::ProcessMenuItems(bool bEnable)
{
  mmiSaveAs->Enabled = bEnable;
  tbSave->Enabled = bEnable;
}

//---------------------------------------------------------------------------
void TfrmCADImageDLLdemo::MessageDLLNotLoaded()
{
	TVarRec vr[] = {sgLibName, TEXT("not loaded!")};
	MessageBox(Handle, Format(TEXT("%s %s"), vr, 2).t_str(), TEXT("Error"), 0);
}

//---------------------------------------------------------------------------
void TfrmCADImageDLLdemo::RefreshDrawing()
{
  if (CADHandle)
  {
    float vHorRes, vVertRes;
    GetResolutionParams(&vHorRes, &vVertRes);

    GetBoxCAD(CADHandle,&CADWidth, &CADHeight);
    float fCADSidesRatio = (float)CADWidth / CADHeight;

    CADDRAW vCADDraw;

	vCADDraw.R.left = 0;//nDestOffX;
	vCADDraw.R.top = 0;//nDestOffY;
	vCADDraw.R.right = CADWidth / vHorRes * nScale;// + nDestOffX;
	vCADDraw.R.bottom = vCADDraw.R.right / fCADSidesRatio;// + nDestOffY;

	vCADDraw.R.left += FOffset.x;
	vCADDraw.R.right += FOffset.x;

	vCADDraw.R.top += FOffset.y;
	vCADDraw.R.bottom += FOffset.y;

    vCADDraw.DC = PaintBox1->Canvas->Handle;
    vCADDraw.DrawMode = dmNormal;
    vCADDraw.Size = sizeof(vCADDraw);

    TColor vColorBrush = PaintBox1->Canvas->Brush->Color;
    TBrushStyle vBrushStyle = PaintBox1->Canvas->Brush->Style;
    PaintBox1->Canvas->Brush->Color = PaintBox1->Color;
    PaintBox1->Canvas->Brush->Style = bsSolid;
    PaintBox1->Canvas->FillRect(PaintBox1->ClientRect);
    PaintBox1->Canvas->Brush->Color = vColorBrush;
    PaintBox1->Canvas->Brush->Style = vBrushStyle;
    DrawCADEx(CADHandle, &vCADDraw);
  }
}

//---------------------------------------------------------------------------

void __fastcall TfrmCADImageDLLdemo::FormMouseWheel(TObject *Sender,
      TShiftState Shift, int WheelDelta, TPoint &MousePos, bool &Handled)
{
//  float prev_scale = nScale;

  if (nScale <= 0.1)
    nScale += (float)WheelDelta / 4800;
  else
	nScale += (float)WheelDelta / 1200;
//  float fs = nScale / prev_scale;

//  nDestOffX = (int)((nDestOffX - MousePos.x) * abs(fs) + MousePos.x);
//  nDestOffY = (int)((nDestOffY - MousePos.y) * abs(fs) + MousePos.y);

  cbScale->Text = IntToStr(int(nScale * 100)) + "%";
  RefreshDrawing();
}
//---------------------------------------------------------------------------

void TfrmCADImageDLLdemo::GetResolutionParams(float* vHorRes, float* vVertRes)
{
    int nUnits;
    CADUnits(CADHandle,&nUnits);

    HDC hDC = GetDC(0);
    if (nUnits == 1)
    {
      *vHorRes = (float)GetDeviceCaps(hDC,HORZSIZE) / GetDeviceCaps(hDC,HORZRES);
      *vVertRes = (float)GetDeviceCaps(hDC,VERTSIZE) / GetDeviceCaps(hDC,VERTRES);
    }
    else
    {
      *vHorRes = (float)GetDeviceCaps(hDC,HORZSIZE) / GetDeviceCaps(hDC,HORZRES) / 25.4;
      *vVertRes = (float)GetDeviceCaps(hDC,VERTSIZE) / GetDeviceCaps(hDC,VERTRES) / 25.4;
    }
    ReleaseDC(0, hDC);
}
//---------------------------------------------------------------------------
void __fastcall TfrmCADImageDLLdemo::cbLayoutsCloseUp(TObject *Sender)
{
  if (cbLayouts->ItemIndex != -1)
  {
    CurrentLayoutCAD(CADHandle, cbLayouts->ItemIndex, True);
  }
  RefreshDrawing();
}
//---------------------------------------------------------------------------


void __fastcall TfrmCADImageDLLdemo::PaintBox1MouseUp(TObject *Sender, TMouseButton Button,
		  TShiftState Shift, int X, int Y)
{
  if(FDown)
  {
	FDown = false;
	FDownPos = Point(X, Y);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmCADImageDLLdemo::PaintBox1MouseDown(TObject *Sender, TMouseButton Button,
		  TShiftState Shift, int X, int Y)
{
  if( Button == mbMiddle || Button == mbRight )
  {
	  FDownPos = Point(X, Y);
	  FDown = true;
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmCADImageDLLdemo::PaintBox1MouseMove(TObject *Sender, TShiftState Shift,
		  int X, int Y)
{
  if(FDown)
  {
	  FOffset.x += X - FDownPos.x;
	  FOffset.y += Y - FDownPos.y;
	  FDownPos = Point(X, Y);
      Invalidate();
  }
}
//---------------------------------------------------------------------------

