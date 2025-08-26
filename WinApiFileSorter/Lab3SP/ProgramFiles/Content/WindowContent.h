#pragma once
#ifndef WINDOW_CONTENT
#define WINDOW_CONTENT
#include <windows.h>
#include<unordered_map>
#include<string>
#include <memory>
#include <deque>
#include <algorithm>
#include"StringFunctions.h"

#define NO_CLICKED -1

#define FILE_NO_SORTING -1
#define FILE_NAME_DATA 0
#define FILE_SIZE_DATA 1
#define FILE_CREATION_TIME_DATA 2
#define FILE_PARAMS_NUM 3

#define HEADER_FONT_NUMB 0
#define NAME_FONT_NUMB 1
#define SPEC_FONT_NUMB 2

#define COL_FILLING 0
#define ROW_FILLING 1

#define VECT_F_INF_CAPACITY 150000



using StrVectr = std::vector<FileStructInfo>;
using StrMap = std::unordered_map<std::basic_string<TCHAR>, FileStructInfo*>;

struct allWindsInfo;
struct fontInfo;
class TableObj;


typedef TableObj* (*ObjCreateFunc)(int rowNum, int colNum, int brdrThckns, int initWdth, int initHght, int scrollV,
	COLORREF brdrColor, COLORREF defHeadColor, COLORREF defCellColor,
	COLORREF clickedHeadColor, COLORREF clickedCellColor,
	HWND hParent, allWindsInfo* pallWInf,
	const WCHAR* headerFnt, int headerFntSize,
	const WCHAR* namesFnt, int namesFntSize,
	const WCHAR* specFnt, int specFntSize);

struct SortInfo {
	int index = 0;
	std::wstring content;
};


struct FileStructInfo
{

	std::wstring fileData[FILE_PARAMS_NUM];

	int occurCount = 0; // the number of occurrences of the same file name (to add the characters [])
	int sortInd = 0;


	FileStructInfo(const TCHAR* nameVal, std::wstring& fileSize, std::wstring& createTime, int count, int ind)
	{
		// for characters [] place
		const int addLen = 2;
		int nameIntLen = getStrLength(nameVal) + 1;
		WCHAR* buf;
		if (count) {
			int sourceLen = nameIntLen;
			nameIntLen += addLen + getIntLen(count);
			int dotInd = findDotInd(nameVal, sourceLen - 1);
			buf = new WCHAR[nameIntLen];
			if (dotInd < 0) {
				_snwprintf_s(buf, nameIntLen, nameIntLen - 1, L"%s%s%d%s", nameVal, L"[", count, L"]");
			}
			else {
				_snwprintf_s(buf, nameIntLen, nameIntLen - 1, L"%.*s%s%d%s%s", dotInd,
					nameVal, L"[", count, L"]", nameVal + dotInd);
			}
		}
		else {
			buf = new WCHAR[nameIntLen];
			wcscpy_s(buf, nameIntLen, nameVal);

		}
		fileData[FILE_NAME_DATA] = buf;
		delete[] buf;

		fileData[FILE_SIZE_DATA] = fileSize;
		fileData[FILE_CREATION_TIME_DATA] = createTime;

		sortInd = ind;
	}
	FileStructInfo() {
		fileData[FILE_NAME_DATA] = L"";
		fileData[FILE_SIZE_DATA] = L"";
		fileData[FILE_CREATION_TIME_DATA] = L"";

		occurCount = 0;
		sortInd = 0;
	}
};

struct fontInfo {
	HFONT hFont = NULL;
	int fontSize = 0;
	int fontPxHeight = 0;
	int textPxHeight = 0;
	std::wstring fontName;
};


struct fdWindInfo {
	//initialises at program start
	allWindsInfo* pallWInf;

	int wndWidth = 0;
	int wndHeight = 0;

	fontInfo fntInf;

	int fontInpNum = 3;
	int fdWCbIndexs[3];

	std::vector<std::wstring> fdTitles;

	HWND hFontEdtWnd;
	HWND hCBoxes[3];
	HWND hedtsSize[3];

};

struct tblInfo {
	int rNum, cNum;
	int brdrThckns;
	int scrollVal = 2;
	COLORREF tblClr;
	COLORREF defHeadClr;
	COLORREF defCellClr;
	COLORREF clkdHeadClr;
	COLORREF clkdCellClr;
	int defFontSizes[3];
	std::vector<std::wstring> headers;
	std::vector<std::wstring> events;
};

struct allWindsInfo {
	
	fdWindInfo* pfdWInf; 

	std::wstring mainWClassName;
	std::wstring tblWClassName;
	std::wstring fdWClassName;

	std::wstring defFontName;
	int defFontInd;
	
	std::vector<std::wstring> allFontNames;
	std::vector<std::wstring> loadedFontPaths;

	int mainWndWdth = 0;
	int mainWndHght = 0;

	std::wstring filesPath;
	tblInfo tblInf;
	TableObj* pTable = NULL; 

	HWND hMainWnd = NULL;
	HWND hFontDialog = NULL;

	WNDPROC DefaultEditProc;

	UINT dblClckInterval;

	ObjCreateFunc makeTableObj;
};

#pragma pack(push, 8)
class TableObj {
public:
	int x = 0, y = 0;
	int wdth = 0, hght = 0;
	// total number of files
	int filesCount = 0;
	int tableElCount = 0;
	StrVectr vect;
	int sortSign = FILE_NO_SORTING;
	// Index of first string in files vector shown in table
	int showStrInd = 0; // strNum
	int scrollVal = 0;
	int lastOutpStr = 0;

	int rowNum, colNum;
	int borderThckns = 1;
	COLORREF borderColor = RGB(255, 0, 0);
	COLORREF defHeadColor = NULL;
	COLORREF defCellColor = NULL;
	COLORREF clickedHeadColor = NULL;
	COLORREF clickedCellColor = NULL;

	int fntNum = 3;
	HWND hTableWnd = NULL;
	HWND hParentWnd = NULL;
	// "EDIT" windows for file path input
	HWND hCellEditWnd = NULL; 

	allWindsInfo* pallWInf;

	int fillingWay = ROW_FILLING;

	int clickedRow = NO_CLICKED;
	int clickedCol = NO_CLICKED;

	BOOL isClicked;
	SYSTEMTIME eventTime;
	LARGE_INTEGER startTime, endTime;

	BOOL isEditing = FALSE;

	fontInfo fntInf[3];



	virtual void UpdateFontsInfo() = 0;
	virtual void UpdatePlacement(int newWdth, int newHght, int newX, int newY) = 0;
	virtual void ResetFilesInfo() = 0;
	virtual void SortData() = 0;

	virtual void OutpTable(HDC hdc) = 0;

	virtual void scroll(int delta) = 0;
	virtual void updateTableData() = 0;

	virtual void UpdateCellsData() = 0;

	virtual void addCellInfo() = 0;

	virtual void clickCell(int clickedX, int clickedY) = 0;
	virtual void unclickCell() = 0;

	virtual void changeCellEditability(int cellRow, int cellCol) = 0;

	virtual void chngEdditing(BOOL state) = 0;

	virtual const WCHAR* getCellContent(int cellRow, int cellCol);

	virtual BOOL getCellsEditability(int cellRow, int cellCol);

	virtual void setCellsContent(int cellRow, int cellCol, WCHAR* newContent);

	virtual ~TableObj() = 0;

private:
	struct ClickedDir {
		int rowDir;
		int colDir;
	};

	int headerHght;
	int averCellWdth;
	int averCellHght;
	int indivWdth;
	int indivHght;

	int minTblWdth;
	int minTblHght;

	HBRUSH defHeadBrush = NULL;
	HBRUSH defCellBrush = NULL;
	HBRUSH clickedHeadBrush = NULL;
	HBRUSH clickedCellBrush = NULL;
	HPEN borderPen = NULL;

	RECT headerArea;
	RECT cellsArea;
};
#pragma pack(pop)

int GetPxFontSize(HDC hdc, int fontPtSize);
int GetPxTextSize(HDC hdc);
void GetSystFonts(HWND hWnd, allWindsInfo* allInf);
void initCBoxes(fdWindInfo* fdInf);
BOOL AddFont(WCHAR* fontName, allWindsInfo* allInf);
void addToCBoxes(fdWindInfo* fdInf, const WCHAR* str);


void changeFont(HWND hWnd, HDC hdc, fontInfo* pFntInf, std::wstring& fontName);


#endif
