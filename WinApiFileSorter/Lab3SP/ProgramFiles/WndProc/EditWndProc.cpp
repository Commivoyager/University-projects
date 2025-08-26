#include "EditWndProc.h"
#include "../Content/Definitions.h"

LRESULT CALLBACK EditPath(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	const int ENTER_VAL = 0xD;
	static WNDPROC DefProc = NULL;
	if (DefProc == NULL && message != WM_SET_OLD_EDIT_PROC) {
		return 0;
	}
	switch (message) {
	case WM_SET_OLD_EDIT_PROC: {
		DefProc = (WNDPROC)lParam;
		return 0;
	}
	case WM_CHAR:
	{
		if (wParam == ENTER_VAL)
		{
			SendMessage(GetParent(hWnd), WM_USER_EDIT_INP, 0, (LPARAM)hWnd);
			return 0;
		}
		break;
	}
	case WM_KILLFOCUS: {
		SendMessage(GetParent(hWnd), WM_USER_EDIT_EXIT, 0, 0);
		return (LRESULT)CallWindowProc((WNDPROC)DefProc, hWnd, message, wParam, lParam);
		break;
	}
	}
	return (LRESULT)CallWindowProc((WNDPROC)DefProc, hWnd, message, wParam, lParam);
}

BOOL createEditField(HWND hPrntWnd, TableObj* pTbl) {
	int clkR = pTbl->clickedRow;
	int clkC = pTbl->clickedCol;
	HWND hEdit = CreateWindowEx(
		0,
		_T("EDIT"),
		pTbl->getCellContent(clkR, clkC),
		WS_CHILD | WS_VISIBLE | ES_LEFT| ES_MULTILINE| ES_AUTOVSCROLL,
		0, 0, 0, 0,
		pTbl->hTableWnd,
		(HMENU)IDC_CELL_EDIT,
		GetModuleHandle(NULL),
		NULL
	);

	if (!hEdit) {
		MessageBox(hPrntWnd, L"Edit window creation error", L"Error", MB_OK);
		return FALSE;
	}
	SendMessage(hEdit, WM_SETFONT, (WPARAM)pTbl->fntInf[SPEC_FONT_NUMB].hFont, TRUE);

	// replacing of message processing function
	pTbl->pallWInf->DefaultEditProc = (WNDPROC)GetWindowLongPtr(hEdit, GWLP_WNDPROC);
	SetWindowLongPtr(hEdit, GWLP_WNDPROC, (LPARAM)EditPath);
	SendMessage(hEdit, WM_SET_OLD_EDIT_PROC, 0, (LPARAM)pTbl->pallWInf->DefaultEditProc);

	pTbl->hCellEditWnd = hEdit;
	return TRUE;
}