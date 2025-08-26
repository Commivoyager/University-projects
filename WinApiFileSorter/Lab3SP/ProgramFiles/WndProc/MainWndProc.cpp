#include <sstream>
#include "MainWndProc.h"
#include "../Content/WindowContent.h"
#include "../Content/Definitions.h"
#include "../Content/FileFunctions.h"
#include "../ParallelSorting.h"

LRESULT CALLBACK MainWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	static allWindsInfo* pAllInf;
	switch (message)
	{
	case WM_CREATE:
	{
		CREATESTRUCT* pCreate = (CREATESTRUCT*)lParam;
		pAllInf = (allWindsInfo*)pCreate->lpCreateParams;
		SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)pAllInf);

		pAllInf->hMainWnd = hWnd;
		RECT windRect;
		GetClientRect(hWnd, &windRect);
		int wdth = windRect.right - windRect.left;
		int hght = windRect.bottom - windRect.top;
		pAllInf->mainWndWdth = wdth;
		pAllInf->mainWndHght = hght;

		SendMessage(hWnd, WM_GET_SYST_FONTS, 0, 0);

		int defFontInd = pAllInf->defFontInd;

		const WCHAR* defFont;
		if (pAllInf->allFontNames.empty()) {
			defFont = pAllInf->defFontName.c_str();
		}
		else {
			defFont = pAllInf->allFontNames[defFontInd].c_str();
		}
		tblInfo tblInf = pAllInf->tblInf;
		TableObj* pTbl = NULL; 
		pTbl = pAllInf->makeTableObj(tblInf.rNum, tblInf.cNum, tblInf.brdrThckns,
			pAllInf->mainWndWdth, pAllInf->mainWndHght, tblInf.scrollVal, tblInf.tblClr,
			tblInf.defHeadClr, tblInf.defCellClr, tblInf.clkdHeadClr, tblInf.clkdCellClr,
			hWnd, pAllInf,
			defFont, tblInf.defFontSizes[HEADER_FONT_NUMB],
			defFont, tblInf.defFontSizes[NAME_FONT_NUMB],
			defFont, tblInf.defFontSizes[SPEC_FONT_NUMB]);

		HWND hTable;
		hTable = CreateWindowEx(0, pAllInf->tblWClassName.c_str(), L"", WS_CHILD | WS_VISIBLE,
			0, 0, 0, 0, hWnd, NULL, GetModuleHandle(NULL), pTbl);
		if (!hTable) {
			MessageBox(hWnd, L"Table window creation error", L"Error", MB_OK);
			return FALSE; //?
		}
		pTbl->hTableWnd = hTable;
		pTbl->UpdateFontsInfo();
		pAllInf->pTable = pTbl;
		PostMessage(hWnd, WM_USER_FIND_FILES, 0, 0);
		PostMessage(hWnd, WM_SIZE, 0, 0);


		break;
	}
	case WM_SIZE:
	{
		RECT windRect;
		GetClientRect(hWnd, &windRect);
		int wdth = windRect.right - windRect.left;
		int hght = windRect.bottom - windRect.top;
		pAllInf->mainWndWdth = wdth;
		pAllInf->mainWndHght = hght;
		
		pAllInf->pTable->UpdatePlacement(wdth, hght, 0, 0);

		InvalidateRect(hWnd, NULL, TRUE);
		break;
	}
	case WM_TBL_L_CLK: 
	case WM_TBL_R_CLK:
	case WM_TBL_LDBL_CLK:
	case WM_TBL_RDBL_CLK:
	case WM_TBL_M_CLK:
	{
		int clkdR = pAllInf->pTable->clickedRow;
		int clkdC = pAllInf->pTable->clickedCol;

		std::wstring mess = formTblMessText((pAllInf->tblInf.events[message - WM_TBL_EVENTS]).c_str(), pAllInf->pTable->eventTime,
			clkdR, clkdC);
		MessageBox(hWnd, mess.c_str(), L"Table event", MB_OK);
		if (clkdR == NO_CLICKED) {
			if (clkdC != NO_CLICKED) {
				ParallelSorting(pAllInf->pTable->vect, clkdC % FILE_PARAMS_NUM, procNum);
				pAllInf->pTable->UpdateCellsData();
				InvalidateRect(hWnd, NULL, TRUE);

			}
		}

		break;
	}
	case WM_GET_SYST_FONTS: {
		GetSystFonts(hWnd, pAllInf);
		break;
	}
	case WM_CREATE_TABLE: {

	}
	case WM_USER_FIND_FILES:
	{
		WCHAR pathBuf[MAX_PATH] = L"";
		wcscpy_s(pathBuf, MAX_PATH, pAllInf->filesPath.c_str());

		DWORD funcCode = GetFileAttributes(pathBuf);
		if (funcCode == INVALID_FILE_ATTRIBUTES) {
			MessageBox(hWnd, pathBuf, L"This directory doesn't exist", MB_OK);
			break;
		}
		else {
			StrMap fMap;
			fMap.reserve(VECT_F_INF_CAPACITY);
			fMap.clear();
			pAllInf->pTable->ResetFilesInfo();

			if (getFileNames(pAllInf->pTable->vect, fMap, pathBuf, pAllInf->pTable->filesCount)) {
				MessageBox(hWnd, errorMessage, L"Error", MB_OK);
				break;
			}
			pAllInf->pTable->SortData();
			pAllInf->pTable->updateTableData();
			pAllInf->pTable->UpdateCellsData();
		}
		InvalidateRect(hWnd, NULL, TRUE);
		break;
	}

	case WM_KEYDOWN: {
		const int KEY_IS_DOWN = 0x8000;
		HWND hFDWnd;
		MSG msg;
		if (GetKeyState(VK_CONTROL) & KEY_IS_DOWN) {
			if (wParam == 'D') {
				if (!CreateFontDWind(&hFDWnd, hWnd, pAllInf))
				{
					break;
				}

				EnableWindow(hWnd, FALSE);
				ShowWindow(hFDWnd, SW_SHOW);
				UpdateWindow(hFDWnd);
				SetForegroundWindow(hFDWnd);

				while (GetMessage(&msg, NULL, 0, 0)) {

					if (msg.hwnd != hWnd) {
						if (IsWindow(hFDWnd)) {
							TranslateMessage(&msg);
							DispatchMessage(&msg);
						}
					}
				}
				EnableWindow(hWnd, TRUE);
				// switch input focus on parent window
				SetForegroundWindow(hWnd);
				SendMessage(hWnd, WM_SIZE, 0, 0);
			}
			else if ('E' == wParam) {
				SendMessage(pAllInf->pTable->hTableWnd, WM_KEYDOWN, 'E', lParam);
			}
		}
		else if ('E' == wParam) {
			SendMessage(pAllInf->pTable->hTableWnd, WM_KEYDOWN, 'E', lParam);
		}
		else if (VK_ESCAPE == wParam) {
			SendMessage(pAllInf->pTable->hTableWnd, WM_KEYDOWN, VK_ESCAPE, lParam);
		}
		break;
	}
	case WM_PAINT: {
		HDC hdc;
		PAINTSTRUCT ps;
		hdc = BeginPaint(hWnd, &ps);
		EndPaint(hWnd, &ps);
		break;
	}
	case WM_DESTROY: {
		for (int i = 0; i < pAllInf->loadedFontPaths.size(); i++) {
			RemoveFontResourceEx(pAllInf->loadedFontPaths[i].c_str(), FR_PRIVATE/* FR_NOT_ENUM*/, NULL);
		}
		PostQuitMessage(0);
		break;
	}
	default: {
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	}
	return 0;
}

BOOL CreateFontDWind(HWND* hFDWnd, HWND hParentWnd, allWindsInfo* pAllInf) {
	int wndWidth = pAllInf->mainWndWdth;
	int wndHeight = pAllInf->mainWndHght;

	const int xSize = pAllInf->pfdWInf->wndWidth, ySize = pAllInf->pfdWInf->wndHeight;
	const int xPos = (wndWidth - xSize) / 2, yPos = (wndHeight - ySize) / 2;

	*hFDWnd = CreateWindowEx(
		0,
		pAllInf->fdWClassName.c_str(),
		L"Font dialog",
		WS_POPUP,
		xPos, yPos,
		xSize, ySize,
		hParentWnd,
		NULL,
		GetModuleHandle(NULL),
		pAllInf->pfdWInf
	);
	if (!*hFDWnd) {
		MessageBox(hParentWnd, L"Font dialog window creation error", L"Error", MB_OK);
		return FALSE;
	}
	return TRUE;
}

std::wstring formTblMessText(const WCHAR* eventType, SYSTEMTIME evTime,
	int clkdRow, int clkdCol) {
	std::wostringstream mess;
	std::wstring cellInfo = L" was made on the ";
	if (clkdRow == NO_CLICKED) {
		if (clkdCol == NO_CLICKED) {
			cellInfo += L"border";
		}
		else {
			cellInfo += std::to_wstring(clkdCol) + L"header cell";
		}
	}
	else {
		cellInfo += L"(" + std::to_wstring(clkdRow) + L"; " + std::to_wstring(clkdCol) + L") cell";
	}
	mess 
		<< "Time: "
		<< evTime.wHour << L":"
		<< evTime.wMinute << L":"
		<< evTime.wSecond << L" "
		<< evTime.wMilliseconds << L"milliseconds, date: "
		<< evTime.wDay << L"."
		<< evTime.wMonth << L"."
		<< evTime.wYear << L", event type: "
		<< eventType << cellInfo;
	return mess.str();
}
