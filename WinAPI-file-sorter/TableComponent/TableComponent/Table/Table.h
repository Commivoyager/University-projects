#pragma once

#ifdef TABLECOMPONENT_EXPORTS
#define TABLECOMPONENT_API __declspec(dllexport)
#else
#define TABLECOMPONENT_API __declspec(dllimport)
#endif


#include <windows.h>
#include "..\..\..\Lab3SP\ProgramFiles\WindowContent.h"
#include "TableCell.h"
#include "TableHeader.h"
#include <string>
#include <sstream>


#pragma pack(push, 8)
class TABLECOMPONENT_API Table {
public:
	int x = 0, y = 0;
	int wdth = 0, hght = 0;
	// total number of files
	int filesCount = 0;
	int tableElCount = 0;
	StrVectr vect;
	int sortSign = FILE_NO_SORTING;
	// Index of first string in files vector shown in table
	int showStrInd = 0;
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

	// EDIT window for files path input
	HWND hCellEditWnd = NULL; 
	
	allWindsInfo* pallWInf;

	int fillingWay = COL_FILLING;

	int clickedRow = NO_CLICKED;
	int clickedCol = NO_CLICKED;

	BOOL isClicked;
	SYSTEMTIME eventTime;
	LARGE_INTEGER startTime, endTime;

	BOOL isEditing = FALSE;

	fontInfo fntInf[3];

	virtual void UpdateFontsInfo();
	virtual  void UpdatePlacement(int newWdth, int newHght, int newX, int newY);
	virtual  void ResetFilesInfo();
	virtual  void SortData();

	virtual  void OutpTable(HDC hdc);

	virtual  void scroll(int delta);
	virtual  void updateTableData();

	virtual  void UpdateCellsData();

	virtual  void addCellInfo();

	virtual  void clickCell(int clickedX, int clickedY);
	virtual  void unclickCell();

	virtual  void changeCellEditability(int cellRow, int cellCol);

	virtual void chngEdditing(BOOL state);

	virtual const WCHAR* getCellContent(int cellRow, int cellCol);

	virtual BOOL getCellsEditability(int cellRow, int cellCol);

	virtual void setCellsContent(int cellRow, int cellCol, WCHAR* newContent);


	Table(int rowNum, int colNum, int brdrThckns, int initWdth, int initHght, int scrollV,
		COLORREF tblColor, COLORREF defHeadColor, COLORREF defCellColor,
		COLORREF clickedHeadColor, COLORREF clickedCellColor,
		HWND hParent, allWindsInfo* pallWInf,
		const WCHAR* headerFnt, int headerFntSize,
		const WCHAR* namesFnt, int namesFntSize,
		const WCHAR* specFnt, int specFntSize
		);
	virtual ~Table();

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


	void indSwap(int* pInd1, int* pInd2);
	int qSortPartition(int lInd, int hInd);
	void qSortFileData(int lInd, int hInd);

	void createTable();
	void getHeaderHght();
	void getMinSizes();

	void resizeContent();
	
	void initHeaders(std::vector<std::wstring> headersArr);
	

	BOOL determClickedCell(int clickedX, int clickedY);

	BOOL isCellClicked(int clickedX, int clickedY);
	
	void highlightCell(HDC hdc);

	void closeEdit(BOOL applyChngs);
	void resizeEditField();


	TableCell** Cells = NULL;
	TableHeader* Headers = NULL;
	
};
#pragma pack(pop)

extern "C" TABLECOMPONENT_API Table* CreateTableObj(int rowNum, int colNum, int brdrThckns, int initWdth, int initHght, int scrollV,
	COLORREF brdrColor, COLORREF defHeadColor, COLORREF defCellColor,
	COLORREF clickedHeadColor, COLORREF clickedCellColor,
	HWND hParent, allWindsInfo* pallWInf,
	const WCHAR* headerFnt, int headerFntSize,
	const WCHAR* namesFnt, int namesFntSize,
	const WCHAR* specFnt, int specFntSize);
