#pragma once

#include <windows.h>
#include "../Content/WindowContent.h"

LRESULT CALLBACK EditPath(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

BOOL createEditField(HWND hPrntWnd, TableObj* pTbl);
