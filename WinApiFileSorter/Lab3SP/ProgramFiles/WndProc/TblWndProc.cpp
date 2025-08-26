#include "TblWndProc.h"
#include "../Content/WindowContent.h"
#include <windows.h>
#include "../Content/Definitions.h"
#include "EditWndProc.h"

LRESULT CALLBACK TblWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
	static TableObj* pTbl;
	static BOOL lClickStated = FALSE;
	static BOOL rClickStated = FALSE;
	switch (message) {
	case WM_CREATE: {
		CREATESTRUCT* pCreate = (CREATESTRUCT*)lParam;
		pTbl = (TableObj*)pCreate->lpCreateParams;
		SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)pTbl);
		break;
	}
	case WM_SIZE: {
		
		InvalidateRect(hWnd, NULL, TRUE);
		break;
	}
	case WM_MOUSEWHEEL: {
		int delta = GET_WHEEL_DELTA_WPARAM(wParam) / WHEEL_DELTA;
		pTbl->scroll(delta);
		
		InvalidateRect(hWnd, NULL, FALSE);
		break;
	}
	case WM_LBUTTONDOWN: {
		lClickStated = TRUE;
		SetTimer(hWnd, WM_TBL_LDBL_CLK, pTbl->pallWInf->dblClckInterval, NULL);
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		pTbl->clickCell(x, y);
		if (pTbl->isEditing) {
			pTbl->chngEdditing(FALSE);
		}
		break;
	}
	case WM_RBUTTONDOWN: {
		rClickStated = TRUE;
		SetTimer(hWnd, WM_TBL_RDBL_CLK, pTbl->pallWInf->dblClckInterval, NULL);
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		pTbl->clickCell(x, y);
		break;
	}
	case WM_TIMER: {
		if (wParam == WM_TBL_LDBL_CLK && lClickStated) {
			GetLocalTime(&pTbl->eventTime);
			lClickStated = FALSE;
			KillTimer(hWnd, WM_TBL_LDBL_CLK);
			InvalidateRect(hWnd, NULL, TRUE);
			SendMessage(pTbl->hParentWnd, WM_TBL_L_CLK, 0, 0);
		}
		else if(wParam == WM_TBL_RDBL_CLK && rClickStated) {
			GetLocalTime(&pTbl->eventTime);
			rClickStated = FALSE;
			KillTimer(hWnd, WM_TBL_RDBL_CLK);
			InvalidateRect(hWnd, NULL, TRUE);
			SendMessage(pTbl->hParentWnd, WM_TBL_R_CLK, 0, 0);
		}
		break;
	}
	case WM_LBUTTONDBLCLK: {
		GetLocalTime(&pTbl->eventTime);
		lClickStated = FALSE;
		KillTimer(hWnd, WM_TBL_LDBL_CLK);
		InvalidateRect(hWnd, NULL, TRUE);
		SendMessage(pTbl->hParentWnd, WM_TBL_LDBL_CLK, 0, 0);
		break;
	}
	case WM_RBUTTONDBLCLK: {
		GetLocalTime(&pTbl->eventTime);
		rClickStated = FALSE;
		KillTimer(hWnd, WM_TBL_RDBL_CLK);
		InvalidateRect(hWnd, NULL, TRUE);
		SendMessage(pTbl->hParentWnd, WM_TBL_RDBL_CLK, 0 ,0);
		break;
	}
	case WM_MBUTTONDOWN: {
		GetLocalTime(&pTbl->eventTime);
		SetTimer(hWnd, WM_TBL_LDBL_CLK, pTbl->pallWInf->dblClckInterval, NULL);
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		pTbl->clickCell(x, y);
		InvalidateRect(hWnd, NULL, FALSE);
		SendMessage(pTbl->hParentWnd, WM_TBL_M_CLK, 0, 0);
		break;
	}
	case WM_KEYDOWN: {
		int clkR = pTbl->clickedRow;
		int clkC = pTbl->clickedCol;
		const int KEY_DOWN_MASK = 0x8000;
		if (GetKeyState(VK_CONTROL) & KEY_DOWN_MASK) {
			if ('E' == wParam) {
				
				if (pTbl->isClicked && clkR != NO_CLICKED) {
					pTbl->changeCellEditability(clkR, clkC);
				}
			}
		}
		else if ('E' == wParam) {
			if (pTbl->isClicked && clkR != NO_CLICKED && (pTbl)->getCellsEditability(clkR,clkC)) {
				createEditField(pTbl->hParentWnd, pTbl);
				pTbl->chngEdditing(TRUE);
				SetFocus(pTbl->hCellEditWnd);
				InvalidateRect(hWnd, NULL, FALSE);
			}
		}
		else if (wParam == VK_ESCAPE) {
			pTbl->unclickCell();
			InvalidateRect(hWnd, NULL, TRUE);
		}
		break;
	}
	case WM_USER_EDIT_INP: {
		int clkR = pTbl->clickedRow;
		int clkC = pTbl->clickedCol;
		WCHAR textBuf[100];
		GetWindowText(pTbl->hCellEditWnd, textBuf, 100);
		pTbl->setCellsContent(clkR, clkC, textBuf);
		pTbl->addCellInfo();
		pTbl->chngEdditing(FALSE);
	}
	case WM_USER_EDIT_EXIT: {
		pTbl->chngEdditing(FALSE);
	}
	case WM_PAINT: {
		HDC hdc;
		PAINTSTRUCT ps;

		hdc = BeginPaint(hWnd, &ps);

		HDC hdcBuf = CreateCompatibleDC(hdc);
		RECT bufRect;
		GetClientRect(hWnd, &bufRect);
		HBITMAP hbmBuf = CreateCompatibleBitmap(hdc, bufRect.right - bufRect.left, bufRect.bottom - bufRect.top);
		HBITMAP hbmMain = (HBITMAP)SelectObject(hdcBuf, hbmBuf);
		FillRect(hdcBuf, &bufRect, (HBRUSH)pTbl->borderColor);
		
		int DEBUG = pTbl->clickedRow;
		pTbl->OutpTable(hdcBuf);
		
		BitBlt(hdc, 0, 0, bufRect.right - bufRect.left, bufRect.bottom - bufRect.top, hdcBuf, 0, 0, SRCCOPY);

		SelectObject(hdc, hbmMain);
		DeleteObject(hbmBuf);
		DeleteDC(hdcBuf);

		EndPaint(hWnd, &ps);

		break;
	}
	case WM_DESTROY:
	{
		PostQuitMessage(0);
		break;
	}
	default:
	{
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	}
	return 0;
}