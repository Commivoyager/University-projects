#include <windows.h>
#include <stdlib.h>
#include <tchar.h>
#include <vector>
#include "Content/StringFunctions.h"
#include "Content/FileFunctions.h"

#include "Content/WindowContent.h"
#include "Content/Definitions.h"
#include "WndProc/MainWndProc.h"
#include "WndProc/FontDialogWndProc.h"
#include "WndProc/TblWndProc.h"

//
void InitProgram(allWindsInfo& pallInf, fdWindInfo& pfdInf);
BOOL InitWndClasses(HINSTANCE hInst, allWindsInfo* wndInf);
BOOL CreateMainWnd(HINSTANCE hInst, int nCmdShow, allWindsInfo* lvInfArr);


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE);
	HWND hWnd;
	MSG msg;

	allWindsInfo allWInf;
	fdWindInfo fdWInf;

	// Info structures initialization
	InitProgram(allWInf, fdWInf);

	HINSTANCE hDll = LoadLibraryEx(L"TableComponent.Dll", NULL, NULL);
	if (!hDll) {
		MessageBox(NULL, L"Dll error", L"Error", NULL);
		return 1;
	}
	allWInf.makeTableObj = (ObjCreateFunc)GetProcAddress(hDll, "CreateTableObj");
	if (!allWInf.makeTableObj) {
		MessageBox(allWInf.hMainWnd, L"Dll error", L"Error", NULL);
		FreeLibrary(hDll);
		return 1;
	}

	if (!InitWndClasses(hInstance, &allWInf)) {
		return 1;
	}

	if (!CreateMainWnd(hInstance, nCmdShow, &allWInf)) {
		return 1;
	}
	
	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	FreeLibrary(hDll);
	return (int)msg.wParam;
}





void InitProgram(allWindsInfo& allWInf, fdWindInfo& fdWInf) {
	const int ROW_NUM = 25;
	const int COL_NUM = 6;
	std::wstring TABLE_HEADER = L"Header ";

	allWInf.pfdWInf = &fdWInf;
	allWInf.mainWClassName = L"MyWindowClass";
	allWInf.tblWClassName = L"MyTableWClass";
	allWInf.fdWClassName = L"MyFontDWClass";
	allWInf.defFontName = L"Times New Roman";
	allWInf.defFontInd = 0;

	allWInf.allFontNames.reserve(500);
	allWInf.loadedFontPaths.reserve(10);

	allWInf.filesPath = L"C:\\Program Files";

	allWInf.tblInf.brdrThckns = 1;
	allWInf.tblInf.tblClr = RGB(255, 0, 0);
	allWInf.tblInf.rNum = ROW_NUM;
	allWInf.tblInf.cNum = COL_NUM;
	allWInf.tblInf.defFontSizes[HEADER_FONT_NUMB] = 16;
	allWInf.tblInf.defFontSizes[NAME_FONT_NUMB] = 11;
	allWInf.tblInf.defFontSizes[SPEC_FONT_NUMB] = 11;
	{
		allWInf.tblInf.headers.push_back(L"File name");
		allWInf.tblInf.headers.push_back(L"File size");
		allWInf.tblInf.headers.push_back(L"Creation date");

		allWInf.tblInf.headers.push_back(L"File name");
		allWInf.tblInf.headers.push_back(L"File size");
		allWInf.tblInf.headers.push_back(L"Creation date");

	}

	allWInf.tblInf.events.reserve(5);
	allWInf.tblInf.events.push_back(L"mouse left button click (WM_TBL_L_CLK)");
	allWInf.tblInf.events.push_back(L"mouse left double button click (WM_TBL_LDBL_CLK)");
	allWInf.tblInf.events.push_back(L"mouse right button click (WM_TBL_R_CLK)");
	allWInf.tblInf.events.push_back(L"mouse right double button click (WM_TBL_RDBL_CLK)");
	allWInf.tblInf.events.push_back(L"mouse middle button click  (WM_TBL_M_CLK)");

	allWInf.tblInf.defHeadClr = RGB(13, 172, 56);
	allWInf.tblInf.defCellClr = RGB(255, 255, 255);
	allWInf.tblInf.clkdHeadClr = RGB(144, 238, 144);
	allWInf.tblInf.clkdCellClr = RGB(220, 220, 220);

	allWInf.tblInf.scrollVal = 1;
	allWInf.dblClckInterval = GetDoubleClickTime()/2;

	fdWInf.pallWInf = &allWInf;
	fdWInf.wndWidth = 800;
	fdWInf.wndHeight = 800;
	fdWInf.fntInf.fontSize = 14;
	for (int i = 0; i < fdWInf.fontInpNum; i++) {
		fdWInf.fdWCbIndexs[i] = 0;
	}

	fdWInf.fdTitles.push_back(L"Headers fonts");
	fdWInf.fdTitles.push_back(L"File names font");
	fdWInf.fdTitles.push_back(L"File specifications font");
	fdWInf.fdTitles.push_back(L"Path to the font file");
}

BOOL InitWndClasses(HINSTANCE hInst, allWindsInfo* pAllInf)
{
	WNDCLASSEX wcex;
	WNDCLASSEX tblwcex;
	WNDCLASSEX fdwcex;
	WNDCLASSEX fdTitleWcex;

	// wcex initialization
	{
		wcex.cbSize = sizeof(WNDCLASSEX);
		wcex.style = CS_HREDRAW | CS_VREDRAW| CS_DBLCLKS;
		wcex.lpfnWndProc = MainWndProc;
		wcex.cbClsExtra = 0;
		wcex.cbWndExtra = 0;
		wcex.hInstance = hInst;
		wcex.hIcon = LoadIcon(NULL, IDI_APPLICATION);
		wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
		wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
		wcex.lpszMenuName = NULL;
		wcex.lpszClassName = pAllInf->mainWClassName.c_str();
		wcex.hIconSm = wcex.hIcon;
	}
	// wcex registration errors processing
	if (!RegisterClassEx(&wcex)) {
		MessageBox(NULL, _T("Main window class can not be registered"), _T("Error"), MB_OK);
		return FALSE;
	}

	// lwcex initialization
	{
		tblwcex = { 0 };
		tblwcex.cbSize = sizeof(WNDCLASSEX);
		tblwcex.style = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
		tblwcex.lpfnWndProc = TblWndProc;
		tblwcex.hInstance = hInst;
		wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
		tblwcex.lpszClassName = pAllInf->tblWClassName.c_str();
	}
	// lwcex registration errors processing
	if (!RegisterClassEx(&tblwcex)) {
		MessageBox(NULL, _T("ListView class can not be registered"), _T("Error"), MB_OK);
		return FALSE;
	}

	// fdwcex initialization
	{
		HBRUSH hBckgrndBrush = CreateSolidBrush(RGB(163, 204, 201));
		fdwcex.cbSize = sizeof(WNDCLASSEX);
		fdwcex.style = CS_HREDRAW | CS_VREDRAW;
		fdwcex.lpfnWndProc = FontDialogWndProc;
		fdwcex.cbClsExtra = 0;
		fdwcex.cbWndExtra = 0;
		fdwcex.hInstance = hInst;
		fdwcex.hIcon = NULL;
		fdwcex.hCursor = NULL;
		fdwcex.hbrBackground = hBckgrndBrush;
		fdwcex.lpszMenuName = NULL;
		fdwcex.lpszClassName = pAllInf->fdWClassName.c_str();
		fdwcex.hIconSm = NULL;
		//DeleteObject(hBckgrndBrush);
	}

	// fdwcex registration errors processing
	if (!RegisterClassEx(&fdwcex)) {
		MessageBox(NULL, _T("Font dialog window class can not be registered"), _T("Error"), MB_OK);
		return FALSE;
	}

	return TRUE;
}

BOOL CreateMainWnd(HINSTANCE hInst, int nCmdShow, allWindsInfo* pAllInf){
	HWND hWnd;
	int screenW, screenH;
	screenW = GetSystemMetrics(SM_CXMAXIMIZED);
	screenH = GetSystemMetrics(SM_CYMAXIMIZED);
	hWnd = CreateWindowEx(
		WS_EX_WINDOWEDGE,
		pAllInf->mainWClassName.c_str(),
		L"SPLab1",
		WS_OVERLAPPEDWINDOW,//WS_POPUP,
		0, 0,
		screenW,
		screenH,
		NULL,
		NULL,
		hInst,
		pAllInf);

	if (!hWnd) {
		MessageBox(NULL, _T("Main window can not be created"), _T("Error"), MB_OK);
		return FALSE;
	}

	ShowWindow(hWnd, SW_MAXIMIZE/*nCmdShow*/);
	UpdateWindow(hWnd);
	return TRUE;
}

