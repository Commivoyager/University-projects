#include <windows.h>
#include "WindowContent.h"
#include "FileFunctions.h"


void initCBoxes(fdWindInfo* fdInf) {
	allWindsInfo* allInf = fdInf->pallWInf;
	int allFontsNum = allInf->allFontNames.size();
	for (int j = 0; j < fdInf->fontInpNum; j++) {
		for (int i = 0; i < allFontsNum; i++) {
			SendMessage(fdInf->hCBoxes[j], (UINT)CB_ADDSTRING, 0, (LPARAM)((allInf->allFontNames)[i]).c_str());
		}
		SendMessage(fdInf->hCBoxes[j], CB_SETCURSEL, fdInf->fdWCbIndexs[j], 0);
	}
}

void FindDefFontInd(allWindsInfo* allInf, const TCHAR* defFName) {
	int defInd = 0;
	for (int i = 0; i < allInf->allFontNames.size(); i++) {
		if (0 == allInf->allFontNames[i].compare(defFName)) {
			defInd = i;
			break;
		}
	}
	allInf->defFontInd = defInd;
	for (int i = 0; i < allInf->pfdWInf->fontInpNum; i++) {
		allInf->pfdWInf->fdWCbIndexs[i] = defInd;
	}
}

void addToCBoxes(fdWindInfo* fdInf, const WCHAR* str) {
	for (int j = 0; j < fdInf->fontInpNum; j++) {
		SendMessage(fdInf->hCBoxes[j], (UINT)CB_ADDSTRING, 0, (LPARAM)str);
	}
}

BOOL AddFont(WCHAR* fontName,/*LOGFONT* pfontInf, */allWindsInfo* allInf) {
	if (fontName[0] == '@') {
		return FALSE;
	}
	allInf->allFontNames.push_back(fontName);
	return TRUE;
}

int CALLBACK EnumFontFamExProc(LOGFONT* lpelfe, TEXTMETRIC* lpntme,
	DWORD FontType, LPARAM lParam) {
	allWindsInfo* allInf = (allWindsInfo*)lParam;
	AddFont(lpelfe->lfFaceName, allInf);
	return 1;
}

void GetSystFonts(HWND hWnd, allWindsInfo* allInf) {
	HDC hdc = GetDC(hWnd);
	LOGFONT lf = { 0 };
	
	std::vector<std::wstring> vect = allInf->allFontNames;
	EnumFontFamiliesEx(hdc, &lf, (FONTENUMPROC)EnumFontFamExProc, (LPARAM)(allInf), 0);
	std::sort(allInf->allFontNames.begin(), allInf->allFontNames.end());
	FindDefFontInd(allInf, allInf->defFontName.c_str());

	ReleaseDC(hWnd, hdc);
}


int GetPxFontSize(HDC hdc, int fontPtSize) {
	int dpi = GetDeviceCaps(hdc, LOGPIXELSY);
	int pxSize = MulDiv(fontPtSize, dpi, 72);
	return pxSize;
}

int GetPxTextSize(HDC hdc) {
	TEXTMETRIC tm;
	GetTextMetrics(hdc, &tm);
	return tm.tmHeight;
}

void changeFont(HWND hWnd, HDC hdc, fontInfo* pFntInf, std::wstring& fontName) {
	HFONT hPrevFont = (HFONT)GetCurrentObject(hdc, OBJ_FONT);

	int fPxHeight = GetPxFontSize(hdc, pFntInf->fontSize);
	pFntInf->fontPxHeight = fPxHeight;

	HFONT hFont = CreateFont(
		-fPxHeight,
		0, // width
		0, 0, // tilt angle
		FW_NORMAL, // fonts thickness
		FALSE, FALSE, FALSE, // italics, underscores, strikeouts
		DEFAULT_CHARSET, // encoding
		OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY, // of font 
		DEFAULT_PITCH | FF_SWISS,
		fontName.c_str()
	);
	if (hFont == NULL) {
		MessageBox(hWnd, L"Font dialog windows font creation error", L"Error", NULL);
		pFntInf->hFont = hPrevFont;
	}
	else {
		pFntInf->hFont = hFont;
		hPrevFont = (HFONT)SelectObject(hdc, hFont);
		pFntInf->textPxHeight = GetPxTextSize(hdc);

		SelectObject(hdc, hPrevFont);
	}
}
