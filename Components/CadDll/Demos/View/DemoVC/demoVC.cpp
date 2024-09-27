// DXF_DEMO_API.cpp : Defines the entry point for the application.
//

#include "Window.h"
#include "MainWindow.h"
#include "resource.h"
#include "resrc1.h"
#include <TCHAR.h>
#include <comutil.h>

CMainWindow *MainWindow = 0;

LRESULT CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
	HWND hWnd;
	MSG Msg;

	MainWindow = new CMainWindow(_T("MainWindow"), MainWndProc, hInstance,
		LoadIcon(hInstance, MAKEINTRESOURCE(IDI_ICON)), LoadCursor(0, IDC_ARROW), _T("MENU1"), (HBRUSH)COLOR_WINDOW, 0);
	hWnd = MainWindow->Create(
		_T("CAD DLL - Viewer [Visual C++ Demo]"), 
		WS_CLIPCHILDREN | WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 
		CW_USEDEFAULT, 
		800, 600, NULL, NULL);
	
	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);
    MainWindow->DoCreateStatusBar(hWnd, hInstance);
	MainWindow->DoCreateToolBar(hWnd, hInstance);
	MainWindow->DoCreateComboBox(hInstance);
	while (GetMessage(&Msg, NULL, 0, 0)) 
	{
		if (!IsDialogMessage(CMainWindow::hwndLayersDlg, &Msg))
		{
			TranslateMessage(&Msg);
			DispatchMessage(&Msg);
		}
	}
	return Msg.wParam;
}


LRESULT CALLBACK MainWndProc(HWND hWnd,UINT uiMessage,
                         WPARAM wParam,LPARAM lParam)
{ 
	bool stat;

  switch (uiMessage)
  {
	case WM_MBUTTONDBLCLK:
		MainWindow->Fit();
		break;
	case WM_MOUSEWHEEL:
		MainWindow->MouseWheel((SHORT)wParam, (SHORT)(wParam >> 16), MAKEPOINTS(lParam));
		break;
    case WM_COMMAND:
		switch (LOWORD(wParam))
		{
			case ID_HELP_ABOUT:				   
				MainWindow->ShowAboutDlg();				
				break;
			case ID_FILE_LOADFILEFROMMEMORY: 
			case ID_FILE_LOAD: 
			{				
				TCHAR text[MSG_LEN];
				memset(text, 0, sizeof(text));
				GetWindowText(GetDlgItem(CMainWindow::hwndPropertiesDlg, IDE_NULLLINEWIDTH), text, MSG_LEN);
				CADOPTIONS co;
				co.IsDrawingBox = (CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSDRAWINGBOX, MF_BYCOMMAND) == MF_CHECKED);
				co.IsShowLineWeight = (CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSSHOWLINEWEIGHT, MF_BYCOMMAND) == MF_CHECKED);
				co.IsNearestPointMode = (SendDlgItemMessage(CMainWindow::hwndPropertiesDlg, IDC_NEARESTPOINTMODE, BM_GETCHECK, 0, 0) != 0);
				co.NullLineWidth = _tstoi(text);
				co.IsLoadFromMemory = LOWORD(wParam) == ID_FILE_LOADFILEFROMMEMORY;
				MainWindow->Load(co);
				CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSSHOWLINEWEIGHT, ((co.IsShowLineWeight) ? MF_CHECKED : MF_UNCHECKED));
				CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSDRAWINGBOX, ((co.IsDrawingBox) ? MF_CHECKED : MF_UNCHECKED));
				break;
			}		
			case ID_FILE_PRINT:
				MainWindow->Print();
				break;
			case ID_FILE_SAVEAS:
				MainWindow->SaveAs();
				break;
			case ID_FILE_SAVEAS_BMP:
				MainWindow->SaveAsBMP();
				break;
			case ID_FILE_SAVEAS_EMF:
				MainWindow->SaveAsEMF();
				break;
			case ID_VIEW_NORMAL:
				MainWindow->ChangeView(0);
				break;
			case ID_VIEW_BLACKWHITE:
				MainWindow->ChangeView(1);
				break;				
			case ID_VIEW_GRAYSCALE:
				MainWindow->ChangeView(2);
				break;
			case ID_SETDEFAULTCOLOR:
				MainWindow->SetDefColor();
				break;
			case ID_SCALE_1:
				MainWindow->Fit();
				break;
			case IDM_COLORS_WHITE:				
				MainWindow->SetBgrndColor(RGB(255,255,255));
				break;
			case IDM_COLORS_GRAY:				
				MainWindow->SetBgrndColor(RGB(128,128,128));
				break;
			case IDM_COLORS_LYELLOW:				
				MainWindow->SetBgrndColor(RGB(255,239,182));
				break;
			case IDM_COLORS_BLACK:				
				MainWindow->SetBgrndColor(RGB(0,0,0));
				break;
			case IDM_ORBITUPX:
				MainWindow->RotateCAD(axisX, ROTATION_ANGLE);				
				break;
			case IDM_ORBITDOWNX:
				MainWindow->RotateCAD(axisX, -ROTATION_ANGLE);
				break;
			case IDM_ORBITUPY:
				MainWindow->RotateCAD(axisY, -ROTATION_ANGLE);
				break;
			case IDM_ORBITDOWNY:
				MainWindow->RotateCAD(axisY, ROTATION_ANGLE);
				break;
			case IDM_ORBITUPZ:
				MainWindow->RotateCAD(axisZ, -ROTATION_ANGLE);
				break;
			case IDM_ORBITDOWNZ:
				MainWindow->RotateCAD(axisZ, ROTATION_ANGLE);
				break;
			case IDM_ROTATE:
				MainWindow->RotateCAD(axisZ, 180.0f);
				break;
			case IDM_VIEW_PICTUREFROMDIB:
				MainWindow->ShowPictureDlg(true );
				break;
			case IDM_OPTIONSLAYERS:
				CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSLAYERS, MF_CHECKED);
				MainWindow->ShowLayersDlg(true);
				break;
			case IDM_OPTIONSPROPERTIES:
				CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSPROPERTIES, MF_CHECKED);
				MainWindow->ShowPropertiesDlg(true);
				break;
			case IDM_OPTIONSDRAWINGBOX:
				if (MainWindow->GetIsNearestPointMode())
				{
					CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSDRAWINGBOX, MF_UNCHECKED);
                    MessageBox(hWnd, _T("Please reset \"Nearest point mode\" for activation drawing box."), _T("Warning"), MB_ICONWARNING);
				}
				else
				{                   
					if (!MainWindow->GetIsDrawingBox())//!(CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSDRAWINGBOX, MF_BYCOMMAND) == MF_CHECKED);
	                    stat = MainWindow->SetDrawingBox();
					else
						stat = MainWindow->ResetDrawingBox();					 
					CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSDRAWINGBOX, ((stat) ? MF_CHECKED : MF_UNCHECKED));
				}
				break;
            case IDM_OPTIONSSHOWLINEWEIGHT:			
				stat = (CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSSHOWLINEWEIGHT, MF_BYCOMMAND) == MF_CHECKED);
				CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSSHOWLINEWEIGHT, ((stat) ? MF_UNCHECKED : MF_CHECKED));
				MainWindow->ShowLineWeight(!stat);
				break;
			case 0:
				if ((HIWORD(wParam) == CBN_SELENDOK) && (lParam == (LPARAM)MainWindow->hwndComboBox)) {
					CheckMenuItem(GetMenu(hWnd), IDM_OPTIONSDRAWINGBOX, MF_UNCHECKED);
                    MainWindow->SetCurrentLayout();
				}
				break;
		}
		break;

	case WM_PAINT:
		MainWindow->Draw();		
		break;

	case WM_MOVE:
		MainWindow->RePaint();
		break;

	case WM_SIZE:			
		MainWindow->RePaint();
		MainWindow->ReSize(wParam, lParam);			
		break;

	case WM_LBUTTONDOWN:
		MainWindow->LButtonDown(MAKEPOINTS(lParam));
		break;

	case WM_LBUTTONUP:
		MainWindow->LButtonUp(MAKEPOINTS(lParam));
		break;

	case WM_MOUSEMOVE:
		MainWindow->MouseMove(MAKEPOINTS(lParam));
		break;

    case WM_DESTROY:
		MainWindow->CloseImage();
        PostQuitMessage(0);
        break;
	/* for this construction use CreateCADEx with third parameter*/
	/*  case CAD_PROGRESS:
		LPCADPROGRESS p = (LPCADPROGRESS)lParam;
		TCHAR mes[MSG_LEN];
		TCHAR *done = _T("% done");
		TCHAR ProgressMsg[MSG_LEN] = _T("Load file... ");
		_itot(p->PercentDone, mes, 10);
		_tcsncat(ProgressMsg, mes, _tcslen(mes));
		_tcsncat(ProgressMsg, done, _tcslen(done));
		MainWindow->SetTextToStatusBar(ProgressMsg, 0);
		break;*/

  }
  return DefWindowProc(hWnd,uiMessage,wParam,lParam);
}
