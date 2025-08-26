#include "FontDialogWndProc.h"
#include "../Content/WindowContent.h"
#include "../Content/Definitions.h"

LRESULT CALLBACK FontDialogWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
	static fdWindInfo* pFDInf;
	static BOOL isLoaded = FALSE;
	switch (message) {
	case WM_CREATE: {
		CREATESTRUCT* pCreate = (CREATESTRUCT*)lParam;
		pFDInf = (fdWindInfo*)pCreate->lpCreateParams;
		SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)pFDInf);



		HDC hdc = GetDC(hWnd);

		changeFont(hWnd, hdc, &pFDInf->fntInf, pFDInf->pallWInf->defFontName);

		ReleaseDC(hWnd, hdc);

		CreateFontDControls(hWnd, pFDInf);

		initCBoxes(pFDInf);
		isLoaded = FALSE;
		break;
	}
	case WM_COMMAND:
	{
		switch (LOWORD(wParam)) {
		case IDC_FD_BTN_CANCEL: {
			SendMessage(hWnd, WM_CLOSE, 0, 0);
			break;
		}
		case IDC_FD_BTN_OK: {
			allWindsInfo* pallInf = pFDInf->pallWInf;
			TableObj* pTable = pallInf->pTable;
			TCHAR* buf = new TCHAR[10];

			if (isLoaded) {
				std::sort(pallInf->allFontNames.begin(), pallInf->allFontNames.end());
				isLoaded = FALSE;
			}
			
			for (int i = 0; i < pFDInf->fontInpNum; i++) {
				GetWindowText((pFDInf->hedtsSize)[i], buf, 10);
				int fontInd = (int)SendMessage((pFDInf->hCBoxes)[i], CB_GETCURSEL, 0, 0);
				if (fontInd != CB_ERR) {
					std::wstring wstr(buf);
					(pTable->fntInf)[i].fontSize = std::stoi(wstr);
					pTable->fntInf[i].fontName = ((pallInf->allFontNames)[fontInd]);
					pFDInf->fdWCbIndexs[i] = fontInd;
				}
			}
			pTable->UpdateFontsInfo();

			SendMessage(hWnd, WM_CLOSE, 0, 0);

			break;
		}
		case IDC_FD_BTN_LOAD: {
			WCHAR fontPath[MAX_PATH];
			WCHAR fontName[LF_FACESIZE];
			GetWindowText(pFDInf->hFontEdtWnd, fontPath, MAX_PATH);
		
			DWORD funcCode = GetFileAttributes(fontPath);
			if (funcCode == INVALID_FILE_ATTRIBUTES) {
				MessageBox(hWnd, fontPath, L"This file doesn't exist", MB_OK);
				break;
			}
			else {
				int pathLen = wcslen(fontPath);
				int startInd = pathLen;
				int lastInd = startInd - 1;
				while (fontPath[startInd] != '\\' && startInd >= 0) {
					if (fontPath[startInd] == L'.') {
						lastInd = startInd;
					}
					--startInd;
				}
				if (lastInd == pathLen - 1) {
					MessageBox(hWnd, fontPath, L"Incorrect file for font", MB_OK);
					break;
				}
				startInd++;
				wcsncpy_s(fontName, LF_FACESIZE, fontPath + startInd, lastInd - startInd);

				if (0 == AddFontResourceEx(fontPath, FR_PRIVATE/*FR_NOT_ENUM */, NULL)) {
					MessageBox(hWnd, fontPath, L"Font loading error", MB_OK);
					break;
				}
				if (AddFont(fontName, pFDInf->pallWInf)) {
					pFDInf->pallWInf->loadedFontPaths.push_back(fontPath);
				}
				else {
					MessageBox(hWnd, fontPath, L"This type of font is't supported", MB_OK);
					break;
				}
				addToCBoxes(pFDInf, fontName);
				isLoaded = TRUE;
				SetWindowText(pFDInf->hFontEdtWnd, L"");
			}
			break;
		}
		case IDC_FD_BTN_BROWSE: {
			//Structure for dialog
			OPENFILENAME ofn;
			// path buffer
			WCHAR szFile[MAX_PATH] = L""; 
			ZeroMemory(&ofn, sizeof(ofn));
			ofn.lStructSize = sizeof(ofn);
			ofn.hwndOwner = hWnd;
			ofn.lpstrFilter = L"Все файлы\0*.*\0";
			ofn.lpstrFile = szFile;
			ofn.nMaxFile = MAX_PATH;
			ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;
			ofn.lpstrInitialDir = L"..\\..\\..\\Fonts";
			if (GetOpenFileName(&ofn)) {
				SendMessage(pFDInf->hFontEdtWnd, WM_SETTEXT, 0, (LPARAM)szFile);
			}
		}
		}
		break;
	}
	case WM_CTLCOLORSTATIC: {
		HDC hdcStatic = (HDC)wParam;
		SetBkMode(hdcStatic, TRANSPARENT);
		return (INT_PTR)GetStockObject(NULL_BRUSH);
	}
	case WM_DESTROY: {
		DeleteObject(pFDInf->fntInf.hFont);
		PostQuitMessage(0);
		break;
	}
	default: {
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	}
	return 0;
}

BOOL CreateFontDControls(HWND hFDWnd, fdWindInfo* pFDInf) {
	allWindsInfo* pAllInf = pFDInf->pallWInf;
	HINSTANCE hInstance = (HINSTANCE)GetWindowLongPtr(hFDWnd, GWLP_HINSTANCE);
	const int wndWdth = pFDInf->wndWidth;
	const int wndHght = pFDInf->wndHeight;
	const int contrHght = pFDInf->fntInf.textPxHeight;
	const int btnHght = contrHght;
	const int btnWdth = 100;
	const int sizeEditWdth = btnWdth / 4 * 3;
	const int contrWdth = wndWdth * 3 / 4 - btnWdth;
	const int cbNum = 3;

	int xShft = (wndWdth - contrWdth - btnWdth) / 2;
	int yShft = wndHght / 5 - contrHght;
	int shift = yShft;
	HWND hCreatedWnd;
	HFONT hFont = pFDInf->fntInf.hFont;

	int contrlCount = 0;

	const int bufSize = 10;
	WCHAR sizeVal[bufSize];
	for (int i = 0; i < cbNum; i++) {
		hCreatedWnd = CreateWindowEx(
			0,
			_T("COMBOBOX"),
			NULL,
			WS_VISIBLE | WS_CHILD | CBS_DROPDOWNLIST | CBS_HASSTRINGS | WS_VSCROLL | CBS_SORT,
			xShft, yShft, contrWdth, shift + shift,
			hFDWnd,
			(HMENU)(IDC_FD_CBX_HEADER + i),
			hInstance,
			NULL
		);
		if (!hCreatedWnd) {
			MessageBox(hFDWnd, L"Font dialog windows combobox creation error", L"Error", MB_OK);
			return FALSE;
		}

		SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);
		pFDInf->hCBoxes[i] = hCreatedWnd;

		hCreatedWnd = CreateWindowEx(0, L"STATIC", pFDInf->fdTitles[i].c_str(),
			WS_CHILD | WS_VISIBLE,
			xShft, yShft - contrHght, contrWdth, shift + shift, hFDWnd, NULL, hInstance, NULL);
		SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);


		swprintf(sizeVal, bufSize, L"%d", pAllInf->pTable->fntInf[i].fontSize);
		hCreatedWnd = CreateWindowEx(
			0,
			_T("EDIT"),
			sizeVal,
			WS_CHILD | WS_VISIBLE | ES_LEFT | ES_AUTOHSCROLL,
			xShft + contrWdth + sizeEditWdth, yShft, sizeEditWdth, contrHght + 7,
			hFDWnd,
			(HMENU)(IDC_FD_EDT_HEADER + i),
			hInstance,
			NULL
		);

		if (!hCreatedWnd) {
			MessageBox(hFDWnd, L"Font dialog windows edit control creation error", L"Error", MB_OK);
			return FALSE;
		}
		SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);
		pFDInf->hedtsSize[i] = hCreatedWnd;
		yShft += shift;

	}

	//font file path input 
	hCreatedWnd = CreateWindowEx(
		0,
		_T("EDIT"),
		_T(""),
		WS_CHILD | WS_VISIBLE | ES_LEFT | ES_AUTOHSCROLL,
		xShft, yShft, contrWdth - btnWdth - 10, contrHght,
		hFDWnd,
		(HMENU)IDC_FD_EDIT,
		hInstance,
		NULL
	);
	if (!hCreatedWnd) {
		MessageBox(hFDWnd, L"Font dialog windows edit control creation error", L"Error", MB_OK);
		return FALSE;
	}
	pFDInf->hFontEdtWnd = hCreatedWnd;
	SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);

	hCreatedWnd = CreateWindowEx(0, L"STATIC", pFDInf->fdTitles[3].c_str(),
		WS_CHILD | WS_VISIBLE,
		xShft, yShft - contrHght, contrWdth, shift + shift, hFDWnd, NULL, hInstance, NULL);
	SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);


	hCreatedWnd = CreateWindowEx(
		0,
		_T("BUTTON"),
		_T("Browse..."),
		WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
		xShft + contrWdth - btnWdth - 5, yShft, btnWdth, btnHght,
		hFDWnd,
		(HMENU)IDC_FD_BTN_BROWSE,
		hInstance,
		NULL
	);
	if (!hCreatedWnd) {
		MessageBox(hFDWnd, L"Font dialog windows \"Browse\" button control creation error", L"Error", MB_OK);
		return FALSE;
	}
	SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);

	hCreatedWnd = CreateWindowEx(
		0,
		_T("BUTTON"),
		_T("Load"),
		WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
		xShft + contrWdth, yShft, btnWdth, btnHght,
		hFDWnd,
		(HMENU)IDC_FD_BTN_LOAD,
		hInstance,
		NULL
	);
	if (!hCreatedWnd) {
		MessageBox(hFDWnd, L"Font dialog windows \"Browse\" button control creation error", L"Error", MB_OK);
		return FALSE;
	}
	SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);

	yShft += shift;

	hCreatedWnd = CreateWindowEx(
		0,
		_T("BUTTON"),
		_T("Ok"),
		WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
		xShft + contrWdth / 7 * 2, yShft, btnWdth, btnHght,
		hFDWnd,
		(HMENU)IDC_FD_BTN_OK,
		hInstance,
		NULL
	);
	if (!hCreatedWnd) {
		MessageBox(hFDWnd, L"Font dialog windows \"Ok\" button control creation error", L"Error", MB_OK);
		return FALSE;
	}
	SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);

	hCreatedWnd = CreateWindowEx(
		0,
		_T("BUTTON"),
		_T("Cancel"),
		WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
		xShft + contrWdth * 5 / 7, yShft, btnWdth, btnHght,
		hFDWnd,
		(HMENU)IDC_FD_BTN_CANCEL,
		hInstance,
		NULL
	);
	if (!hCreatedWnd) {
		MessageBox(hFDWnd, L"Font dialog windows \"Cancel\" button control creation error", L"Error", MB_OK);
		return FALSE;
	}
	SendMessage(hCreatedWnd, WM_SETFONT, (WPARAM)hFont, TRUE);
	return TRUE;
}
