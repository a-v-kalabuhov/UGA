// CAD_DEMO_API.cpp : Defines the entry point for the application.
//
#include "sgAdditional.h"
#include "CADWindow.h"
#include "resource.h"

CCADWindow *MainWindow = 0;

LRESULT CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
HWND hWnd;
MSG Msg;

	MainWindow = new CCADWindow(_T("MainWindow"), MainWndProc, hInstance,
		0, LoadCursor(0, IDC_ARROW), _T("MENU1"), (HBRUSH)COLOR_WINDOW, 0);
	hWnd = MainWindow->Create(_T("CAD DLL - Import [Visual C++ Demo]"), WS_CLIPCHILDREN | WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, CW_USEDEFAULT, 640, 480, NULL, NULL);
	MainWindow->DoCreateStatusBar(hWnd, hInstance);

	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	while(GetMessage(&Msg, 0, 0, 0))
	{
		TranslateMessage(&Msg);
		DispatchMessage(&Msg);
	}
	return 0;
}


LRESULT CALLBACK MainWndProc(HWND hWnd,UINT uiMessage,
                         WPARAM wParam,LPARAM lParam)
{
  switch (uiMessage)
  {
    case WM_COMMAND:
		switch(LOWORD(wParam))
		{
			case ID_FILE_LOAD: 
				MainWindow->Load();
				break;
			case ID_FILE_SAVEAS:
				MainWindow->SaveAs();
				break;
			case ID_FILE_EXIT: 
				DestroyWindow(hWnd);
				break;	
			case ID_SCALE_1:
			case ID_SCALE_2:
			case ID_SCALE_3:
			case ID_SCALE_4:
			case ID_SCALE_5:
			case ID_SCALE_6:
			case ID_SCALE_7:
			case ID_SCALE_8:
			case ID_SCALE_9:
			case ID_SCALE_10:
			case ID_SCALE_11:
			case ID_SCALE_12:
			case ID_SCALE_13:
			case ID_SCALE_14:
			case ID_SCALE_15:
			case ID_SCALE_16:
			case ID_SCALE_17:
			case ID_FITWINDOW:
				MainWindow->ChangeScale((LONG)wParam);
				break;
			case ID_LAYERS_GETLAYERSLIST:
				MainWindow->GetLayers();
				break;
			case ID_DRAWINGSTYLE_DASHDOTS:
			case ID_DRAWINGSTYLE_WINAPI:
			case ID_DRAWINGSTYLE_SOLIDLINES:
				MainWindow->DrawingMode(LOWORD(wParam));
				break;
			case ID_CIRCLE_DRAWASARC:
			case ID_CIRCLE_DRAWASPOLY_DASHDOTS:
			case ID_CIRCLE_DRAWASPOLY_WINAPI:
			case ID_CIRCLE_DRAWASPOLY_SOLIDLINES:
				MainWindow->Circle(LOWORD(wParam));
				break;
			case ID_GETARCSASCURVES:			
			case ID_GETARCSASPOLY:
				MainWindow->ArcsAsCurves(LOWORD(wParam));
				break;
            case ID_GETTEXTSASCURVES:				
				MainWindow->TextsAsCurves();
				break;
			case ID_VIEW_DBLBUF:
				MainWindow->SwitchDblBuf();
			case 0:
				if ((HIWORD(wParam) == CBN_SELENDOK) && (lParam == (LPARAM)MainWindow->hwndComboBox)) 
                    MainWindow->SetCurrentLayout();
				break;
		}
		break;

		case WM_PAINT:
			MainWindow->WMPaint(hWnd, uiMessage, wParam, lParam);
		  break;

		case WM_RBUTTONDOWN:
			MainWindow->BeginDrag(MAKEPOINTS(lParam));
			break;

		case WM_RBUTTONUP:
			MainWindow->EndDrag(MAKEPOINTS(lParam));
			break;
		
		case WM_MOUSEMOVE:
			MainWindow->MouseMove(MAKEPOINTS(lParam));
			break;

		case WM_SIZE:
			MainWindow->RePaint();
			MainWindow->ReSize(wParam, lParam);
			break;


    case WM_DESTROY: 
      PostQuitMessage(0);
      break;
	}
  return DefWindowProc(hWnd,uiMessage,wParam,lParam);
}
