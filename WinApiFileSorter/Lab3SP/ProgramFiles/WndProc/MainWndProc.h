#pragma once
#include <windows.h>
#include "../Content/WindowContent.h"

LRESULT CALLBACK MainWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);
BOOL CreateFontDWind(HWND* hFDWnd, HWND hParentWnd, allWindsInfo* pAllInf);
std::wstring formTblMessText(const WCHAR* eventType, SYSTEMTIME evTime, int rowNum, int colNum);
