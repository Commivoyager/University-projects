#pragma once

#include <windows.h>
#include "../Content/WindowContent.h"

LRESULT CALLBACK FontDialogWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);
BOOL CreateFontDControls(HWND hFDWnd, fdWindInfo* pFDInf);