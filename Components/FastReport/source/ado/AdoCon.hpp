// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AdoCon.pas' rev: 5.00

#ifndef AdoConHPP
#define AdoConHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ADODB.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Buttons.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Adocon
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TConnEditForm;
class PASCALIMPLEMENTATION TConnEditForm : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TButton* OkButton;
	Stdctrls::TButton* CancelButton;
	Stdctrls::TButton* HelpButton;
	Stdctrls::TGroupBox* SourceofConnection;
	Stdctrls::TRadioButton* UseDataLinkFile;
	Stdctrls::TRadioButton* UseConnectionString;
	Stdctrls::TComboBox* DataLinkFile;
	Stdctrls::TButton* Browse;
	Stdctrls::TEdit* ConnectionString;
	Stdctrls::TButton* Build;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall HelpButtonClick(System::TObject* Sender);
	void __fastcall BuildClick(System::TObject* Sender);
	void __fastcall BrowseClick(System::TObject* Sender);
	void __fastcall SourceButtonClick(System::TObject* Sender);
	
public:
	WideString __fastcall Edit(WideString ConnStr);
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TConnEditForm(Classes::TComponent* AOwner) : Forms::TForm(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TConnEditForm(Classes::TComponent* AOwner, int 
		Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TConnEditForm(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TConnEditForm(HWND ParentWindow) : Forms::TForm(
		ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE bool __fastcall EditConnectionString(WideString &ConnStr, const AnsiString ACaption);
	

}	/* namespace Adocon */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Adocon;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AdoCon
