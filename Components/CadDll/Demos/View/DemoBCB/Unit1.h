//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <Menus.hpp>
#include <cadimage.h>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ImgList.hpp>
#include <ToolWin.hpp>
//---------------------------------------------------------------------------
class TfrmCADImageDLLdemo : public TForm
{
__published:	// IDE-managed Components
        TMainMenu *MainMenu1;
        TMenuItem *mmiFile;
        TMenuItem *mmiOpen;
        TPaintBox *PaintBox1;
        TOpenDialog *OpenDialog1;
        TControlBar *clbBar;
        TToolBar *tlbBar;
        TToolButton *tbOpen;
        TImageList *imLarge;
        TComboBox *cbScale;
        TToolButton *tbSave;
        TMenuItem *mmiSaveAs;
	TSaveDialog *SaveDialog1;
        TPanel *plPanel;
        TComboBox *cbLayouts;
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall Open1Click(TObject *Sender);
        void __fastcall FormDestroy(TObject *Sender);
        void __fastcall PaintBox1Paint(TObject *Sender);
        void __fastcall tbOpenClick(TObject *Sender);
        void __fastcall cbScaleChange(TObject *Sender);
        void __fastcall mmiSaveAsClick(TObject *Sender);
        void __fastcall FormMouseWheel(TObject *Sender, TShiftState Shift,
          int WheelDelta, TPoint &MousePos, bool &Handled);
		void __fastcall cbLayoutsCloseUp(TObject *Sender);
	void __fastcall PaintBox1MouseUp(TObject *Sender, TMouseButton Button, TShiftState Shift,
          int X, int Y);
	void __fastcall PaintBox1MouseDown(TObject *Sender, TMouseButton Button, TShiftState Shift,
          int X, int Y);
	void __fastcall PaintBox1MouseMove(TObject *Sender, TShiftState Shift, int X, int Y);

private:	// User declarations
        HINSTANCE CADImageDLL;
		HANDLE CADHandle;
#ifndef CS_STATIC_DLL
        CADLAYOUT CADLayout;
        CADLAYOUTNAME CADLayoutName;
        CADLAYOUTSCOUNT CADLayoutsCount;
		CADUNITS CADUnits;
		CADSETSHXOPTIONS CADSetSHXOptions;
        CLOSECAD CloseCAD;
        CREATECAD CreateCAD;
        CURRENTLAYOUTCAD CurrentLayoutCAD;
        DEFAULTLAYOUTINDEX DefaultLayoutIndex;
        DRAWCAD DrawCAD;
        DRAWCADEX DrawCADEx;
        GETBOXCAD GetBoxCAD;
        SAVECADTOBITMAP SaveCADtoBitmap;
        SAVECADTOGIF SaveCADtoGif;
				SAVECADTOJPEG SaveCADtoJpeg;
				SAVECADTOEMF SaveCADtoEMF;
				SAVECADTOFILEWITHXMLPARAMS SaveCADtoFileWithXMLParams;
		GETLASTERRORCAD GetLastErrorCAD;
#endif
				float CADWidth;
        float CADHeight;
        int nDestOffX;
        int nDestOffY;
        double nScale;
		bool bFileLoaded;
		bool FDown;
		TPoint FDownPos;
		TPoint FOffset;
		void GetResolutionParams(float* vHorRes, float* vVertRes);
        void ProcessMenuItems(bool bEnable);
		void RefreshDrawing();
		void MessageDLLNotLoaded();
		void Error();
public:		// User declarations
        __fastcall TfrmCADImageDLLdemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmCADImageDLLdemo *frmCADImageDLLdemo;
//---------------------------------------------------------------------------
#endif
