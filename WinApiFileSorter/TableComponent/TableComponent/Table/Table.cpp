#include "..\\pch.h"
#include "Table.h"


Table::Table(int rowNum, int colNum, int brdrThckns, int initWdth, int initHght, int scrollV,
	COLORREF brdrColor, COLORREF defHeadColor, COLORREF defCellColor, 
	COLORREF clickedHeadColor, COLORREF clickedCellColor,
	HWND hParent, allWindsInfo* pallWInf,
	const WCHAR* headerFnt, int headerFntSize,
	const WCHAR* namesFnt, int namesFntSize,
	const WCHAR* specFnt, int specFntSize) : rowNum(rowNum-1), colNum(colNum), scrollVal(scrollV),
	borderThckns(brdrThckns), borderColor(brdrColor), 
	defHeadColor(defHeadColor), defCellColor(defCellColor),
	clickedHeadColor(clickedHeadColor), clickedCellColor(clickedCellColor),
	hParentWnd(hParent), pallWInf(pallWInf),
	wdth(initWdth), hght(initHght)
{

	fntInf[HEADER_FONT_NUMB].fontSize = headerFntSize;
	fntInf[NAME_FONT_NUMB].fontSize = namesFntSize;
	fntInf[SPEC_FONT_NUMB].fontSize = specFntSize;

	fntInf[HEADER_FONT_NUMB].fontName = headerFnt;
	fntInf[NAME_FONT_NUMB].fontName = namesFnt;
	fntInf[SPEC_FONT_NUMB].fontName = specFnt;

	defHeadBrush = CreateSolidBrush(defHeadColor);
	defCellBrush = CreateSolidBrush(defCellColor);
	clickedHeadBrush = CreateSolidBrush(clickedHeadColor);
	clickedCellBrush = CreateSolidBrush(clickedCellColor);
	borderPen = CreatePen(PS_SOLID, borderThckns, borderColor);
	//headers = pallWInf->tblInf.headers;


	wdth = initWdth;
	hght = initHght;
	createTable();
	vect.reserve(VECT_F_INF_CAPACITY);
}


Table* CreateTableObj(int rowNum, int colNum, int brdrThckns, int initWdth, int initHght, int scrollV,
	COLORREF brdrColor, COLORREF defHeadColor, COLORREF defCellColor,
	COLORREF clickedHeadColor, COLORREF clickedCellColor,
	HWND hParent, allWindsInfo* pallWInf,
	const WCHAR* headerFnt, int headerFntSize,
	const WCHAR* namesFnt, int namesFntSize,
	const WCHAR* specFnt, int specFntSize) {
	Table* pTble =  new Table(rowNum, colNum, brdrThckns, initWdth, initHght, scrollV,
		brdrColor, defHeadColor, defCellColor,
		clickedHeadColor, clickedCellColor,
		hParent, pallWInf,
		headerFnt, headerFntSize,
		namesFnt, namesFntSize,
		specFnt, specFntSize);
	return pTble;
}

Table::~Table() {
	if (Cells != NULL) {
		for (int i = 0; i < rowNum; i++) {
			if (Cells[i] != NULL) {
				delete[] Cells[i];
			}
		}
		delete[] Cells;
		Cells = NULL;
	}
	if (Headers != NULL) {
		delete[] Headers;
		Headers = NULL;
	}
	DeleteObject(defHeadBrush);
	DeleteObject(defCellBrush);
	DeleteObject(clickedHeadBrush);
	DeleteObject(clickedCellBrush);
	DeleteObject(borderPen);
	defHeadBrush = NULL;
	defCellBrush = NULL;
	clickedHeadBrush = NULL;
	clickedCellBrush = NULL;
	borderPen = NULL;
}

void Table::UpdateFontsInfo() {
	HWND hWnd = hTableWnd;


	HDC hdc = GetDC(hWnd);

	for (int i = 0; i < fntNum; i++) {
		changeFont(hWnd, hdc, fntInf, fntInf[i].fontName);
	}

	ReleaseDC(hWnd, hdc);
}

void Table::UpdatePlacement(int newWdth, int newHght, int newX, int newY){
	x = newX; y = newY;
	wdth = newWdth; hght = newHght;
	MoveWindow(hTableWnd, x, y, wdth, hght, FALSE);
	resizeContent();
}


void Table::ResetFilesInfo() {
	filesCount = 0;
	vect.clear();
	showStrInd = 0;
}

void Table::SortData() {
	if (sortSign >= 0) {
		qSortFileData(0, filesCount);
	}
}



void Table::OutpTable(HDC hdc) {
	int DEBUG_ROW = clickedRow;
	HPEN hDefPen = (HPEN)SelectObject(hdc, borderPen);
	SetBkMode(hdc, TRANSPARENT);

	FillRect(hdc, &headerArea, defHeadBrush);
	FillRect(hdc, &cellsArea, defCellBrush);

	HFONT hPrevFont = (HFONT)SelectObject(hdc, fntInf[HEADER_FONT_NUMB].hFont);
	if (clickedCol != NO_CLICKED) {
		if (clickedRow == NO_CLICKED) {
			FillRect(hdc, &Headers[clickedCol].cell, clickedHeadBrush);
		}
		else {
			FillRect(hdc, &Cells[clickedRow][clickedCol].cell, clickedCellBrush);
		}
	}
	int ShiftX = 0;
	int ShiftY = 0;
	for (int i = 0; i < colNum; i++) {
		DrawText(hdc, (Headers[i]).content.c_str(), -1, &Headers[i].cell, DT_CENTER | DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);
		MoveToEx(hdc, ShiftX, ShiftY, NULL);
		LineTo(hdc, ShiftX, hght);
		ShiftX = Headers[i].cell.right;
	}
	MoveToEx(hdc, ShiftX, ShiftY, NULL);
	LineTo(hdc, ShiftX, hght);

	ShiftX = 0;
	ShiftY = 0;

	MoveToEx(hdc, ShiftX, ShiftY, NULL);
	LineTo(hdc, wdth, ShiftY);

	ShiftY += borderThckns + headerHght;

	MoveToEx(hdc, ShiftX, ShiftY, NULL);
	LineTo(hdc, wdth, ShiftY);

	SelectObject(hdc, fntInf[NAME_FONT_NUMB].hFont);


	for (int i = 0; i < rowNum; i++) {
		for (int j = 0; j < colNum; j++) {
			ShiftY = Cells[i][j].cell.bottom;
			DrawText(hdc, Cells[i][j].content.c_str(), -1, &Cells[i][j].cell, DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS);
			MoveToEx(hdc, ShiftX, ShiftY, NULL);
			LineTo(hdc, wdth, ShiftY);
		}
	}
	SelectObject(hdc, hDefPen);
	SelectObject(hdc, hPrevFont);
}


void Table::scroll(int delta) {
	unclickCell();
	delta *= scrollVal;
	if (delta >= 0) {
		if (showStrInd - delta > 0) {
			showStrInd -= delta;
		}
		else {
			showStrInd = 0;
		}
	}
	else {
		// minus - because delta is negative
		if (fillingWay == COL_FILLING) {
			if (showStrInd - delta + (rowNum - 1) < vect.size()) { 
				showStrInd -= delta;
			}
			else {
				showStrInd = lastOutpStr - (rowNum - 1);
				if (showStrInd < 0) {
					showStrInd = 0;
				}
			}
		}
		else if (ROW_FILLING == fillingWay) {
			if (showStrInd - delta + (rowNum - 1) < lastOutpStr) {
				showStrInd -= delta;
			}
			else {
				showStrInd = lastOutpStr - (rowNum - 1);
			}
		}
	}
	UpdateCellsData();
}



void Table::updateTableData() {
	if (ROW_FILLING == fillingWay) {
		lastOutpStr = filesCount / colNum;
		tableElCount = filesCount;

		int extraElNum = 0;

		int cellArrElNum = rowNum * colNum;
		extraElNum = colNum - filesCount % colNum;
		if (extraElNum == 0) {
			lastOutpStr--;
		}
		if (filesCount < cellArrElNum) {
			extraElNum = cellArrElNum - filesCount;
			lastOutpStr += extraElNum / colNum;
		}
		extraElNum += colNum;
		tableElCount += extraElNum;
		FileStructInfo debug;
		vect.resize(tableElCount, debug);
	}
	else if (COL_FILLING == fillingWay) {
		Headers[0].content += L" (" + std::to_wstring(filesCount) + L")";
		lastOutpStr = filesCount;
		tableElCount = filesCount;
	}
}



void Table::UpdateCellsData() {
	switch (fillingWay) {
	case ROW_FILLING:
	{
		int k = showStrInd * colNum;
		for (int i = 0; i < rowNum; i++) {
			for (int j = 0; j < colNum; j++) {
				if (k < tableElCount) {
					Cells[i][j].content = vect[k++].fileData[FILE_NAME_DATA];
				}
				else {
					Cells[i][j].content = L"";
				}
			}
		}
		break;
	}
	case COL_FILLING: {
		int k = showStrInd;
		int lastRow = rowNum;
		if (rowNum >= tableElCount - showStrInd) {
			lastRow = tableElCount - showStrInd;
		}
		for (int i = 0; i < lastRow; i++) {
			Cells[i][FILE_NAME_DATA].content = vect[k + i].fileData[FILE_NAME_DATA];
			Cells[i][FILE_SIZE_DATA].content = vect[k + i].fileData[FILE_SIZE_DATA];
			Cells[i][FILE_CREATION_TIME_DATA].content = vect[k + i].fileData[FILE_CREATION_TIME_DATA];
		
			Cells[i][FILE_NAME_DATA + 3].content = vect[vect[k + i].sortInd].fileData[FILE_NAME_DATA];
			Cells[i][FILE_SIZE_DATA + 3].content = vect[vect[k + i].sortInd].fileData[FILE_SIZE_DATA];
			Cells[i][FILE_CREATION_TIME_DATA + 3].content = vect[vect[k + i].sortInd].fileData[FILE_CREATION_TIME_DATA];
		}
		break;
	}
	}

}

void Table::addCellInfo() {
	switch (fillingWay) {
	case ROW_FILLING: {
		int vectInd = showStrInd * colNum + clickedRow * colNum + clickedCol;
		vect[vectInd].fileData[FILE_NAME_DATA] = Cells[clickedRow][clickedCol].content;
	}
	case COL_FILLING: {
		int vectInd = showStrInd + clickedRow;
		
		if (clickedCol < FILE_PARAMS_NUM) {
			vect[vectInd].fileData[clickedCol] = Cells[clickedRow][clickedCol].content;
		}
		else {
			vect[vect[vectInd].sortInd].fileData[clickedCol] = Cells[clickedRow][clickedCol].content;
		}
	}
	}
}


void Table::clickCell(int clickedX, int clickedY) {
	isClicked = determClickedCell(clickedX, clickedY);
}

void Table::unclickCell() {
	clickedRow = NO_CLICKED;
	clickedCol = NO_CLICKED;
	isClicked = FALSE;
}

void Table::changeCellEditability(int cellRow, int cellCol) {
	(Cells[cellRow][cellCol]).chngEditability();
}


void Table::chngEdditing(BOOL state) {
	isEditing = state;
	if (FALSE == state) {
		closeEdit(FALSE);
	}
	else {
		resizeEditField();
	}
}

const WCHAR* Table::getCellContent(int cellRow, int cellCol) {
	return (Cells[cellRow][cellCol]).content.c_str();
}

BOOL Table::getCellsEditability(int cellRow, int cellCol) {
	return Cells[cellRow][cellCol].isEditable;
}

void Table::setCellsContent(int cellRow, int cellCol, WCHAR* newContent){
	Cells[cellRow][cellCol].content = newContent;
}


void Table::indSwap(int* pInd1, int* pInd2) {
	int temp = *pInd1;
	*pInd1 = *pInd2;
	*pInd2 = temp;
}

int Table::qSortPartition(int lInd, int hInd) {
	int pivInd = hInd;
	const WCHAR* pivotEl = vect[vect[pivInd].sortInd].fileData[sortSign].c_str();
	int i = lInd - 1;
	for (int j = lInd; j < hInd; j++) {
		if (strCompare(vect[vect[j].sortInd].fileData[sortSign].c_str(), pivotEl) <= 0) {
			i++;
			indSwap(&vect[i].sortInd, &vect[j].sortInd);
		}
	}
	indSwap(&vect[i + 1].sortInd, &vect[pivInd].sortInd);
	return i + 1;
}

void Table::qSortFileData(int lInd, int hInd) {
	if (lInd < hInd) {
		int pivotInd = qSortPartition(lInd, hInd);
		qSortFileData(lInd, pivotInd - 1);
		qSortFileData(pivotInd, hInd);
	}
}



void Table::createTable() {
	Cells = new TableCell * [rowNum];
	for (int i = 0; i < rowNum; i++) {
		Cells[i] = new TableCell [colNum];
	}
	Headers = new TableHeader [colNum];

	initHeaders(pallWInf->tblInf.headers);
	getHeaderHght();
	getMinSizes();
	resizeContent();
}

void Table::getHeaderHght() {
	int allRowNum = rowNum + 1;
	int cleanHght = hght - (allRowNum + 1) * borderThckns;
	int averCellHght = cleanHght / allRowNum;
	int extraHght = cleanHght - averCellHght * allRowNum;
	int addCellHght = extraHght / allRowNum;

	averCellHght += addCellHght;

	int indivHght = extraHght - addCellHght * allRowNum;

	int hdrHght = averCellHght;
	if (indivHght > 0) {
		hdrHght++;
	}
	for (int i = 0; i < colNum; i++) {
		Headers[i].hght = hdrHght;
	}
	headerHght = hdrHght;
}

void Table::getMinSizes() {
	minTblWdth = (colNum + 1) * borderThckns;
	// +2 - because rownum - number of lines without header
	//but it's necessary to take into account top border
	minTblHght = (rowNum + 2) * borderThckns + headerHght;
}


void Table::resizeContent() {
	// clean - without borders
	if (hght > minTblHght) {
		int cleanHght = hght - minTblHght;
		averCellHght = cleanHght / rowNum;
		int extraHght = cleanHght - averCellHght * rowNum;
		int addCellHght = extraHght / rowNum;
		averCellHght += addCellHght;
		indivHght = extraHght - addCellHght * rowNum;
	}
	else {
		averCellHght = 1;
		indivHght = 0;
	}
	if (wdth > minTblWdth) {
		int cleanWdth = wdth - minTblWdth;
		averCellWdth = cleanWdth / colNum;

		int extraWdth = cleanWdth - averCellWdth * colNum;
		int addCellWdth = extraWdth / colNum;
		averCellWdth += addCellWdth;

		indivWdth = extraWdth - addCellWdth * colNum;
	}
	else {
		averCellWdth = 1;
		indivWdth = 0;
	}

	int startX = borderThckns;
	int startY = borderThckns + headerHght + borderThckns;

	int shiftY = startY;
	int indivY = indivHght;
	RECT sizes;
	for (int i = 0; i < rowNum; i++) {
		int indivX = indivWdth;
		int shiftX = startX;
		for (int j = 0; j < colNum; j++) {
			sizes.left = shiftX;
			sizes.right = shiftX + averCellWdth;
			if (indivX > 0) {
				sizes.right++;
				indivX--;
			}
			sizes.top = shiftY;
			sizes.bottom = shiftY + averCellHght;
			if (indivY > 0) {
				sizes.bottom++;
			}

			Cells[i][j].cell = sizes;
			shiftX = sizes.right + borderThckns;
		}
		shiftY = sizes.bottom + borderThckns;
		indivY--;
	}

	int shiftX = borderThckns;
	shiftY = borderThckns;
	int indivX = indivWdth;
	for (int i = 0; i < colNum; i++) {
		sizes.left = shiftX;
		sizes.right = shiftX + averCellWdth;
		if (indivX > 0) {
			sizes.right++;
			indivX--;
		}
		sizes.top = shiftY;
		sizes.bottom = shiftY + headerHght;
		Headers[i].cell = sizes;

		shiftX = sizes.right + borderThckns;
	}

	headerArea.left = Headers[0].cell.left;
	headerArea.top = Headers[0].cell.top;
	headerArea.right = Headers[colNum - 1].cell.right;
	headerArea.bottom = Headers[colNum - 1].cell.bottom;

	cellsArea.left = Cells[0][0].cell.left;
	cellsArea.top = Cells[0][0].cell.top;
	cellsArea.right = Cells[rowNum-1][colNum-1].cell.right;
	cellsArea.bottom = Cells[rowNum - 1][colNum - 1].cell.bottom;

	resizeEditField();
}

void Table::initHeaders(std::vector<std::wstring> headersArr) {
	for (int i = 0; i < colNum; i++) {
		Headers[i].content = headersArr[i];
	}
}


BOOL Table::determClickedCell(int clickedX, int clickedY) {
	int clkdRow, clkdCol;

	int headerPart = borderThckns + headerHght;
	int incrPart = (borderThckns + averCellHght + 1) * indivHght;
	
	if (clickedY >= headerPart) {
		// situation when click occured in area where cells width didn't incremented
		if (headerPart + incrPart <= clickedY) {
			int shft = clickedY - (headerPart + incrPart);

			clkdRow = shft / (borderThckns + averCellHght) + indivHght;
			if (clkdRow >= this->rowNum) {
				// when not a single cell is clicked
				clickedRow = NO_CLICKED;
				clickedCol = NO_CLICKED;
				return FALSE;
			}
		}
		else { 
			// area where cells width is incremented
			int shft = clickedY - headerPart;
			clkdRow = shft / (borderThckns + 1 + averCellHght);
		}
	}
	else {
		clkdRow = NO_CLICKED;
	}
	incrPart = (borderThckns + averCellWdth + 1) * indivWdth;
	if (incrPart <= clickedX) {
		int shft = clickedX - incrPart;
		clkdCol = shft / (borderThckns + averCellWdth) + indivWdth;
		if (clkdCol >= this->colNum) {
			clickedRow = NO_CLICKED;
			clickedCol = NO_CLICKED;
			return FALSE;
		}
	}
	else {
		int shft = clickedX;
		clkdCol = shft / (borderThckns + 1 + averCellWdth);
	}
	clickedRow = clkdRow;
	clickedCol = clkdCol; 
	if (!isCellClicked(clickedX, clickedY)) {
		clickedRow = NO_CLICKED;
		clickedCol = NO_CLICKED;
		return FALSE;
	}
	return TRUE;
}

BOOL Table::isCellClicked(int clickedX, int clickedY) {
	RECT cell; 
	if (clickedCol != NO_CLICKED) {
		if (clickedRow == NO_CLICKED) {
			cell = Headers[clickedCol].cell;
		}
		else {
			cell = Cells[clickedRow][clickedCol].cell;
		}
	}
	else {
		clickedRow = NO_CLICKED;
		return FALSE;
	}
	if (cell.right > clickedX &&
		cell.left <= clickedX &&
		cell.bottom > clickedY &&
		cell.top <= clickedY) {
		return TRUE;
	}
	else {
		clickedRow = NO_CLICKED;
		clickedCol = NO_CLICKED;
		return FALSE;
	}
}

void Table::highlightCell(HDC hdc) {
	if (clickedCol != NO_CLICKED) {
		HBRUSH hBrush = CreateSolidBrush(RGB(121, 121, 121));
		if (clickedRow == NO_CLICKED) {
			FillRect(hdc, &Headers[clickedCol].cell, hBrush);
		}
		else {
			FillRect(hdc, &Cells[clickedRow][clickedCol].cell, hBrush);
		}
		
	}

}

void Table::closeEdit(BOOL applyChngs) {
	DestroyWindow(hCellEditWnd);
	hCellEditWnd = NULL;
}

void Table::resizeEditField() {
	if (clickedRow != NO_CLICKED && clickedCol != NO_CLICKED && isEditing) {
		RECT cell = Cells[clickedRow][clickedCol].cell;
		MoveWindow(hCellEditWnd, cell.left, cell.top, cell.right - cell.left, cell.bottom - cell.top, NULL);
	}
}


void changeFont(HWND hWnd, HDC hdc, fontInfo* pFntInf, std::wstring& fontName) {
	HFONT hPrevFont = (HFONT)GetCurrentObject(hdc, OBJ_FONT);

	int fPxHeight = GetPxFontSize(hdc, pFntInf->fontSize);
	pFntInf->fontPxHeight = fPxHeight;

	HFONT hFont = CreateFont(
		-fPxHeight,
		0, // width of characteres
		0, 0, // tilt corner
		FW_NORMAL, // font thickness
		FALSE, FALSE, FALSE, // italics, underline, strikethrough
		DEFAULT_CHARSET, // encoding
		OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY, // fonts quality
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

int strCompare(const TCHAR* str1, const TCHAR* str2) {
	int str1Len = getStrLength(str1);
	int str2Len = getStrLength(str2);
	int len;

	if (str1Len > str2Len) {
		len = str1Len;
	}
	else {
		len = str2Len;
	}


	int ind = 0;

	while (ind < len && str1[ind]) {
		if (str1[ind] == str2[ind]) {
			ind++;
		}
		else if (str1[ind] > str2[ind]) {
			return 1;
		}
		else {
			return -1;
		}
	}

	if (str1Len > str2Len) {
		return 1;
	}
	if (str1Len < str2Len) {
		return -1;
	}
	return 0;
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

int getStrLength(const TCHAR* const str) {
	int len = 0;
	while (str[len]) {
		len++;
	}
	return len;
}
