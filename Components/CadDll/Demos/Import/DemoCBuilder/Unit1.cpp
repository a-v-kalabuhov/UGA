//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include <algorithm>
#include "Unit1.h"
#include <cad.h>
#include <sg.h>
#include <sgAdditional.h>
#include <sgCommon.h>
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"

TfmCADDLLdemo *fmCADDLLdemo;

class TMyPaint : public TPaintBox
{
public:
        __property MouseCapture;
};

AnsiString Names[22] =
{
      "UNKNOWN", "TABLE", "BLOCK", "LTYPE", "LAYER", "VERTEX", "LINE", "SOLID",
      "CIRCLE", "ARC", "POLYLINE", "LWPOLYLINE", "SPLINE", "INSERT",
      "DIMENSION", "TEXT", "MTEXT", "ATTDEF", "ELLIPSE", "POINT", "3DFACE",
      "HATCH"
 };

//---------------------------------------------------------------------------
__fastcall TfmCADDLLdemo::TfmCADDLLdemo(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void TfmCADDLLdemo::LoadStructure()
{
  memset(&Data, 0, sizeof(Data));
  TreeView1->Items->Clear();
  ListBox1->Clear();
  Base(CAD_SEC_TABLES, "TABLES");
  Base(CAD_SEC_BLOCKS, "BLOCKS");
  Base(CAD_SEC_ENTITIES, "ENTITIES");
  memset(&Data, 0, sizeof(Data));
}

void TfmCADDLLdemo::Scan(HANDLE H, TTreeNode* Parent)
{
    HANDLE Ch;
    TTreeNode* Node;
    int i, Count;
    Count = Data.Count;
    for (i = 0; i < Count; i++)
    {
      Ch = CADGetChild(H, i, &Data);
      if (Ch == 0)
      {
        Error();
      }
      if (Data.Tag < 22)
      {
        Node = TreeView1->Items->AddChildObject(Parent, Names[Data.Tag], Ch);
        Scan(Ch, Node);
      }
    }
}

void TfmCADDLLdemo::Base(int Index, AnsiString AName)
{
    TTreeNode* Node;
    HANDLE H = CADGetSection(FCAD, Index, &Data);
    if (H == 0)
    {
        Error();
    }
    Node = TreeView1->Items->AddObject(NULL, AName, H);
    Scan(H, Node);
}
void __fastcall TfmCADDLLdemo::FormCreate(TObject *Sender)
{
  pgcPages->Align = alClient;
  pbDrawing->Align = alClient;
	IsError = true;
	AnsiString S;
	S = "CAD Drawings|*.dwg;*.dxf;*.plt;*.hgl;*.hg;*.hpg;*.plo;*.hp;*.hp1;*.hp2;*.hpgl;*.hpgl2;*.gl2;*.prn;*.spl;*.rtl;*.cgm;*.svg";
	S = S + "AutoCAD drawings (*.dxf;*.dwg)|*.dxf;*.dwg|AutoCAD FCAD (*.dxf)|*.dxf|AutoCAD DWG (*.dwg)|*.dwg|";
	S = S + "HPGL/2 image (*.rtl)|*.rtl|HPGL/2 image (*.spl)|*.spl|HPGL/2 image (*.prn)|*.prn|";
	S = S + "HPGL/2 image (*.gl2)|*.gl2|HPGL/2 image (*.hpgl2)|*.hpgl2|HPGL/2 image (*.hpgl)|*.hpgl|";
	S = S + "HPGL/2 image (*.hp2)|*.hp2|HPGL/2 image (*.hp1)|*.hp1|HPGL/2 image (*.hp)|*.hp|";
	S = S + "HPGL/2 image (*.plo)|*.plo|HPGL/2 image (*.hpg)|*.hpg|HPGL/2 image (*.hg)|*.hg|";
	S = S + "HPGL/2 image (*.hgl)|*.hgl|HPGL/2 image (*.plt)|*.plt|";
	S = S + "Computer Graphics Metafile (*.cgm)|*.cgm|Scalable Vector Graphics (*.svg)|*.svg";
	OpenDialog->Filter = S;
  sbHomeClick(NULL);
  FCAD = 0;
	CADDLL = LoadLibrary(sgLibName);
  if (CADDLL)
  {
    CADCreate = (CADCREATE) GetProcAddress(CADDLL, "CADCreate");
    CADClose = (CADCLOSE) GetProcAddress(CADDLL, "CADClose");
    CADGetBox = (CADGETBOX) GetProcAddress(CADDLL, "CADGetBox");
    CADGetSection = (CADGETSECTION) GetProcAddress(CADDLL, "CADGetSection");
    CADGetChild = (CADGETCHILD) GetProcAddress(CADDLL, "CADGetChild");
    CADGetData = (CADGETDATA) GetProcAddress(CADDLL, "CADGetData");
    CADLayerCount = (CADLAYERCOUNT) GetProcAddress(CADDLL, "CADLayerCount");
    CADLayer = (CADLAYER) GetProcAddress(CADDLL, "CADLayer");
    CADLayoutCount = (CADLAYOUTCOUNT) GetProcAddress(CADDLL, "CADLayoutCount");
    CADLayoutCurrent = (CADLAYOUTCURRENT) GetProcAddress(CADDLL, "CADLayoutCurrent");
    CADLayoutName = (CADLAYOUTNAME) GetProcAddress(CADDLL, "CADLayoutName");
    CADEnum = (CADENUM) GetProcAddress(CADDLL, "CADEnum");
    CADUnits = (CADUNITS) GetProcAddress(CADDLL, "CADUnits");
    CADLTScale = (CADLTSCALE) GetProcAddress(CADDLL, "CADLTScale");
    CADVisible = (CADVISIBLE) GetProcAddress(CADDLL, "CADVisible");
	CADGetLastError = (CADGETLASTERROR) GetProcAddress(CADDLL, "CADGetLastError");
	GetLastErrorCAD = (GETLASTERRORCAD) GetProcAddress(CADDLL, "GetLastErrorCAD");
	SaveCADtoFileWithXMLParams = (SAVECADTOFILEWITHXMLPARAMS) GetProcAddress(CADDLL, "SaveCADtoFileWithXMLParams");
	CADSetSHXOptions = (CADSETSHXOPTIONS) GetProcAddress(CADDLL, "CADSetSHXOptions");
	InitSHX(CADSetSHXOptions);
    IsError = false;
  }
  else
  {
    CADCreate = NULL;
    CADClose = NULL;
    CADGetBox = NULL;
    CADGetSection = NULL;
    CADGetChild = NULL;
    CADGetData = NULL;
    CADLayerCount = NULL;
    CADLayer = NULL;
    CADLayoutCount = NULL;
    CADLayoutCurrent = NULL;
    CADLayoutName = NULL;
    CADEnum = NULL;
    CADUnits = NULL;
    CADLTScale = NULL;
    CADVisible = NULL;
	CADGetLastError = NULL;
	SaveCADtoFileWithXMLParams = NULL;
	String str = sgLibName;
	str  = str + _T(" not loaded!");
	MessageBox(0, str.t_str(), _T("Error"), 0);
  }

}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::FormDestroy(TObject *Sender)
{
  if (FCAD) CADClose(FCAD);
  if (CADDLL) FreeLibrary(CADDLL);
}
//---------------------------------------------------------------------------

void TfmCADDLLdemo::Error()
{
	sgChar Buf[255];
	CADGetLastError(Buf);
	throw(Exception(Buf));
}
//---------------------------------------------------------------------------
void __fastcall TfmCADDLLdemo::pbDrawingPaint(TObject *Sender)
{
  pbDrawing->Canvas->FillRect(pbDrawing->Canvas->ClipRect);
  if ((FCAD) && (DoDraw))
  {
    PARAM s;
    memset(&s, 0, sizeof(s));
    s.hWnd = Handle;
    s.hDC = pbDrawing->Canvas->Handle;
    s.Scale = FScale / 100.0;
    s.offset = Point(FX, FY);
    //RECT rect = pbDrawing->Canvas->ClipRect;
    //SetMapMode(s.hDC, MM_ANISOTROPIC);
    //SetViewportOrgEx(s.hDC, 0, rect.bottom / 2, 0);
    CADEnum(FCAD, 0, DoDraw, &s);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::TreeView1Change(TObject *Sender,
      TTreeNode *Node)
{
    ListBox1->Items->BeginUpdate();
    try
    {
      ListBox1->Items->Clear();
      // TTreeNode.Data contains a FCAD entity handle
      if (CADGetData(HANDLE(TreeView1->Selected->Data), &Data) == 0)
      {
        Error();
      }
      if (Data.Layer)
      {
        ListBox1->Items->Add(AnsiString("Layer: ") + AnsiString(Data.Layer));
      }
      ListBox1->Items->Add(Format("Flags: %.2x", ARRAYOFCONST((Data.Flags))));
      ListBox1->Items->Add(Format("Style: %.2x", ARRAYOFCONST((Data.Style))));
      ListBox1->Items->Add(Format("Color: %.6x", ARRAYOFCONST((Data.Color))));
      ListBox1->Items->Add(Format("Thickness: %.5f", ARRAYOFCONST((Data.Thickness))));
      ListBox1->Items->Add(Format("Rotation: %.5f", ARRAYOFCONST((Data.Rotation))));
      if (Data.Text)
      {
        ListBox1->Items->Add(Format("Text: %s", ARRAYOFCONST((Data.Text))));
      }
      ListBox1->Items->Add(Format("%s: %.5f %.5f %.5f",
        ARRAYOFCONST(("Point", Data.Point1.x, Data.Point1.y, Data.Point1.z))));
      ListBox1->Items->Add(Format("%s: %.5f %.5f %.5f",
        ARRAYOFCONST(("Point", Data.Point2.x, Data.Point2.y, Data.Point2.z))));
      switch (Data.Tag)
      {
        case CAD_SOLID:
                ListBox1->Items->Add(Format("%s: %.5f %.5f %.5f",
                  ARRAYOFCONST(("Point", Data.Point3.x,
                    Data.Point3.y, Data.Point3.z))));
                ListBox1->Items->Add(Format("%s: %.5f %.5f %.5f",
                  ARRAYOFCONST(("Point", Data.Point4.x,
                    Data.Point4.y, Data.Point4.z))));
                break;
	case CAD_CIRCLE:
        case CAD_ARC:
	        ListBox1->Items->Add(Format("Radius: %.5f",
                  ARRAYOFCONST((Data.DATA.Arc.Radius))));
	        if (Data.Tag == CAD_CIRCLE) break;
	        ListBox1->Items->Add(Format("StartAngle: %.5f",
                  ARRAYOFCONST((Data.DATA.Arc.StartAngle))));
	        ListBox1->Items->Add(Format("EndAngle: %.5f",
                  ARRAYOFCONST((Data.DATA.Arc.EndAngle))));
                break;
        case CAD_TEXT:
        case CAD_ATTDEF:
        case CAD_ATTRIB:
                ListBox1->Items->Add(Format("Height: %.5f",
                  ARRAYOFCONST((Data.DATA.Text.FHeight))));
	        ListBox1->Items->Add(Format("Scale: %.5f",
                  ARRAYOFCONST((Data.DATA.Text.FScale))));
	        ListBox1->Items->Add(Format("HAlign: %d",
                  ARRAYOFCONST((Data.DATA.Text.HAlign))));
	        ListBox1->Items->Add(Format("VAlign: %d",
                  ARRAYOFCONST((Data.DATA.Text.VAlign))));
	        break;
	case CAD_INSERT:
        case CAD_DIMENSION:
                ListBox1->Items->Add(Format("%s: %.5f %.5f %.5f",
                 ARRAYOFCONST(("Scale", Data.DATA.Blocks.Scale.x,
                 Data.DATA.Blocks.Scale.y, Data.DATA.Blocks.Scale.z))));
                if (Data.DATA.Blocks.Block)
                {
                  CADDATA BData;
                  if (!CADGetData(Data.DATA.Blocks.Block, &BData)) Error();
                  ListBox1->Items->Add("Block: ");
	          ListBox1->Items->Add(Format("Block: %s",
                    ARRAYOFCONST((BData.Text))));
                }
                else
                {
                  ListBox1->Items->Add("Block: ");
                }
      }
    }
    __finally
    {
      ListBox1->Items->EndUpdate();
    }
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::cbScaleChange(TObject *Sender)
{
  FScale = StrToIntDef(cbScale->Text, 100);
  pbDrawing->Invalidate();
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::pbDrawingMouseDown(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y)
{
  if (Button == mbRight)
  {
    FStart = Point(X, Y);
    FOld = Point(FX, FY);
    pbDrawing->Cursor = crHandPoint;
    dynamic_cast<TMyPaint *>(pbDrawing)->MouseCapture = true;
    TabSheet1->Perform(WM_SETCURSOR, (int)TabSheet1->Handle, HTCLIENT);
  }
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::pbDrawingMouseMove(TObject *Sender,
      TShiftState Shift, int X, int Y)
{
  if (pbDrawing->Cursor == crHandPoint)
  {
    FX = FOld.x + X - FStart.x;
    FY = FOld.y + Y - FStart.y;
    pbDrawing->Invalidate();
  }
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::pbDrawingMouseUp(TObject *Sender,
      TMouseButton Button, TShiftState Shift, int X, int Y)
{
  if ((Button == mbRight) && (pbDrawing->Cursor == crHandPoint))
  {
    dynamic_cast<TMyPaint *>(pbDrawing)->MouseCapture = false;
    pbDrawing->Cursor = crDefault;
  }
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::cbLayersDrawItem(TWinControl *Control,
      int Index, TRect &Rect, TOwnerDrawState State)
{
  TColor C = TColor(cbLayers->Items->Objects[Index]);
  cbLayers->Canvas->Brush->Color = clWindow;
  cbLayers->Canvas->FillRect(Rect);
  if (C < 0)
  {
    cbLayers->Canvas->Font->Color = clGray;
  }
  else
  {
    cbLayers->Canvas->Font->Color = clBlack;
  }
  cbLayers->Canvas->TextRect(Rect, Rect.Left+16, Rect.Top,
    cbLayers->Items->Strings[Index]);
  cbLayers->Canvas->Brush->Color = TColor(C & MaxInt);
  cbLayers->Canvas->Rectangle(Rect.Left + 2, Rect.Top+2,
    Rect.Left + 12, Rect.Top + 12);
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::sbLoadClick(TObject *Sender)
{
	AnsiString S[2] =
  {
        "Inches", "Millimeters"
  };

  int I, C, Cnt;
  CADDATA Data;
  int szLayotName = 256;
  PsgChar vLayoutName;
  if (IsError) return;

  if (!OpenDialog->Execute()) return;

  if (!FCAD) CADClose(FCAD);
  cbLayouts->Items->Clear();
  cbScale->ItemIndex = 4;
  FCAD = CADCreate(Application->Handle, OpenDialog->FileName.c_str());// Open FCAD file
  pbDrawing->Invalidate();
  if (!FCAD) Error();
  if (!CADUnits(FCAD, &I)) Error();    // Drawing units (inches or millimeters)
	if (!CADLTScale(FCAD, &LScale)) Error();

	lblMeasure->Caption = S[I];
  sbHomeClick(NULL);
  FScale = 100;
  cbLayers->Items->Clear();
  Cnt = CADLayerCount(FCAD);
  for (I = 0; I < Cnt; I++)
  {
    CADLayer(FCAD, I, &Data);
    C = Data.Color;
    if (Data.Flags & 1) C = C || 0x80000000L;
    cbLayers->Items->AddObject(Data.Text, (TObject *) C);
  }
  cbLayouts->OnChange = NULL;
	vLayoutName = (PsgChar)malloc(szLayotName * sizeof(sgChar));
	try
	{
		Cnt = CADLayoutCount(FCAD);
		for (I = 0; I < Cnt; I++)
		{
			CADLayoutName(FCAD, I, vLayoutName, szLayotName);
			cbLayouts->Items->Add(vLayoutName);
		}
    CADLayoutCurrent(FCAD, &I, false);
    cbLayouts->ItemIndex = I;
  }
	__finally
  {
    free((void *)vLayoutName);
    cbLayouts->OnChange = cbLayoutsChange;
  }
  LoadStructure();
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::sbHomeClick(TObject *Sender)
{
  FX = 0;
  FY = 0;
  if (FCAD)
  {
    CADGetBox(FCAD, &BoxLeft, &BoxRight, &BoxTop, &BoxBottom);
    FY = Round((BoxBottom) * FScale / 100.0);
    if (FY < 0) FY = 0;
  }
  FOld.x = 0;
  FOld.y = 0;
  FStart.x = 0;
  FStart.y = 0;
  pbDrawing->Invalidate();
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::Exit1Click(TObject *Sender)
{
  Close();        
}
//---------------------------------------------------------------------------


void __fastcall TfmCADDLLdemo::cbLayoutsChange(TObject *Sender)
{
  int vLayoutIndex = cbLayouts->ItemIndex;
  if (vLayoutIndex > -1)
  {
    CADLayoutCurrent(FCAD, &vLayoutIndex, true);
    pbDrawing->Invalidate();
  }
}
//---------------------------------------------------------------------------

void __fastcall TfmCADDLLdemo::mmiSaveAsClick(TObject *Sender)
{
	if (!FCAD)
	  return;
	if (!SaveDialog->Execute())
	  return;
	String FileName = SaveDialog->FileName;
	String FileExt = ExtractFileExt(FileName);

	double L, T, R, B, W, H, ratio;
	CADGetBox(FCAD, &L, &R, &T, &B);
	W = R - L;
	if (W == 0) W = 1;
	H = T - B;
	if (H == 0) H = 1;
	if (IsRasterFormat(FileExt)) {
		ratio = std::min(800/W, 600*H);
		W *= ratio;
		H *= ratio;
	}
	else {
		ratio = W / H;
		if ((ratio >= 1) && (W > 5000))
		{
			W = 5000;
			H = W / ratio;
		}
		if ((ratio < 1) && (H > 5000))
		{
			H = 5000;
			W = H * ratio;
		}
	}
	String GraphicParams = Format(TEXT("<GraphicParametrs><PixelFormat>6</PixelFormat><Width>%d</Width><Height>%d</Height><DrawMode>0</DrawMode><DrawRect Left=\"0\" Top=\"0\" Right=\"%d\" Bottom=\"%d\"/></GraphicParametrs>"), OPENARRAY(TVarRec, ((int)W, (int)H, (int)W, (int)H)));
	String CADParams = Format(TEXT("<CADParametrs><BackgroundColor>%d</BackgroundColor><DefaultColor>%d</DefaultColor><XScale>1</XScale></CADParametrs>"), OPENARRAY(TVarRec, (16777216, 0)));
	String ExportParams = Format(TEXT("<?xml version=\"1.0\" encoding=\"utf-16\" ?><ExportParams><Filename>%s</Filename><Ext>%s</Ext>") + CADParams + GraphicParams + TEXT("</ExportParams>"), OPENARRAY(TVarRec, (FileName, FileExt)));

	if (SaveCADtoFileWithXMLParams(FCAD, ExportParams.c_str(), NULL) == 0)
	{
		wchar_t msg[1024];
		GetLastErrorCAD(msg, sizeof(msg));
		String s_msg = String(msg);
		MessageBox(this->Handle, s_msg.c_str(), TEXT("CAD DLL Error"), MB_ICONERROR);
  }
	else
	{
		String FILE_SAVED_AS = TEXT("File saved as: ") + FileName;
		MessageBox(this->Handle, FILE_SAVED_AS.c_str(), TEXT(""), MB_ICONINFORMATION);
} }
//---------------------------------------------------------------------------

