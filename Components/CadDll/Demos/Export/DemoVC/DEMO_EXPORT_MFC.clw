; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CChildView
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "DEMO_EXPORT_MFC.h"
LastPage=0

ClassCount=4
Class1=CDEMO_EXPORT_MFCApp
Class3=CMainFrame
Class4=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX (English (U.S.))
Resource2=IDR_MAINFRAME (English (U.S.))
Class2=CChildView
Resource3=IDD_FORMVIEW (English (U.S.))

[CLS:CDEMO_EXPORT_MFCApp]
Type=0
HeaderFile=DEMO_EXPORT_MFC.h
ImplementationFile=DEMO_EXPORT_MFC.cpp
Filter=N

[CLS:CChildView]
Type=0
HeaderFile=ChildView.h
ImplementationFile=ChildView.cpp
Filter=N
BaseClass=CWnd 
VirtualFilter=WC
LastObject=ID_FILE_SAVE_AS

[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T
LastObject=CMainFrame




[CLS:CAboutDlg]
Type=0
HeaderFile=DEMO_EXPORT_MFC.cpp
ImplementationFile=DEMO_EXPORT_MFC.cpp
Filter=D

[MNU:IDR_MAINFRAME (English (U.S.))]
Type=1
Class=CMainFrame
Command1=ID_APP_EXIT
Command2=ID_EXPORTPROPERTIES_NONE
Command3=ID_EXPORTPROPERTIES_USE01MM
Command4=ID_EXPORTPROPERTIES_PARSEWRITE
Command5=ID_APP_ABOUT
CommandCount=5

[ACL:IDR_MAINFRAME (English (U.S.))]
Type=1
Class=?
Command1=ID_EDIT_COPY
Command2=ID_EDIT_PASTE
Command3=ID_EDIT_UNDO
Command4=ID_EDIT_CUT
Command5=ID_NEXT_PANE
Command6=ID_PREV_PANE
Command7=ID_EDIT_COPY
Command8=ID_EDIT_PASTE
Command9=ID_EDIT_CUT
Command10=ID_EDIT_UNDO
CommandCount=10

[DLG:IDD_ABOUTBOX (English (U.S.))]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_FORMVIEW (English (U.S.))]
Type=1
Class=?
ControlCount=1
Control1=IDC_BUTTON1,button,1342242816

