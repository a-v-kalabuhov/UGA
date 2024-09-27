/*
              DXF Importer SDK DLL Version demo

      Copyright (c) 2002-2003 SoftGold software company
*/
//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <Menus.hpp>
#include <cad.h>
//---------------------------------------------------------------------------
class TfmCADDLLdemo : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *lblMeasure;
        TSpeedButton *sbLoad;
        TSpeedButton *sbHome;
        TComboBox *cbScale;
        TComboBox *cbLayers;
        TMainMenu *MainMenu1;
        TMenuItem *mmiHome;
        TMenuItem *mmiOpen;
        TMenuItem *Placeimagetohome1;
        TMenuItem *N1;
        TMenuItem *Exit1;
  TPageControl *pgcPages;
        TTabSheet *TabSheet1;
        TTabSheet *TabSheet2;
  TPaintBox *pbDrawing;
        TTreeView *TreeView1;
        TSplitter *Splitter1;
        TListBox *ListBox1;
  TComboBox *cbLayouts;
  TOpenDialog *OpenDialog;
	TMenuItem *mmiSaveAs;
	TSaveDialog *SaveDialog;
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall FormDestroy(TObject *Sender);
        void __fastcall pbDrawingPaint(TObject *Sender);
        void __fastcall TreeView1Change(TObject *Sender, TTreeNode *Node);
        void __fastcall cbScaleChange(TObject *Sender);
        void __fastcall pbDrawingMouseDown(TObject *Sender,
          TMouseButton Button, TShiftState Shift, int X, int Y);
        void __fastcall pbDrawingMouseMove(TObject *Sender,
          TShiftState Shift, int X, int Y);
        void __fastcall pbDrawingMouseUp(TObject *Sender,
          TMouseButton Button, TShiftState Shift, int X, int Y);
        void __fastcall cbLayersDrawItem(TWinControl *Control, int Index,
          TRect &Rect, TOwnerDrawState State);
        void __fastcall sbLoadClick(TObject *Sender);
        void __fastcall sbHomeClick(TObject *Sender);
        void __fastcall Exit1Click(TObject *Sender);
  void __fastcall cbLayoutsChange(TObject *Sender);
	void __fastcall mmiSaveAsClick(TObject *Sender);
private:	// User declarations
        int FX;
        int FY;
        int FScale;
        TPoint FStart;
        TPoint FOld;
        CADCREATE CADCreate;
        CADCLOSE CADClose;
        CADGETBOX CADGetBox;
        CADGETSECTION CADGetSection;
        CADGETCHILD CADGetChild;
        CADGETDATA CADGetData;
        CADLAYERCOUNT CADLayerCount;
        CADLAYER CADLayer;
        CADLAYOUTCOUNT CADLayoutCount;
        CADLAYOUTCURRENT CADLayoutCurrent;
        CADLAYOUTNAME CADLayoutName;
        CADENUM CADEnum;
        CADUNITS CADUnits;
        CADLTSCALE CADLTScale;
        CADVISIBLE CADVisible;
		CADGETLASTERROR CADGetLastError;
		GETLASTERRORCAD GetLastErrorCAD;
		CADSETSHXOPTIONS CADSetSHXOptions;
		SAVECADTOFILEWITHXMLPARAMS SaveCADtoFileWithXMLParams;
        CADDATA Data;
        HANDLE FCAD;
        HINSTANCE CADDLL;
        double LScale;
        bool IsError;

        void LoadStructure();
        void Base(int Index, AnsiString AName);
        void Scan(HANDLE H, TTreeNode* Parent);
        void Error();
        void SetValuesToZero(void);

public:		// User declarations
        __fastcall TfmCADDLLdemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfmCADDLLdemo *fmCADDLLdemo;
//---------------------------------------------------------------------------
#endif
