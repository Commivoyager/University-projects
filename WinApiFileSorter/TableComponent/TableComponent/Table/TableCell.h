#pragma once
#include <windows.h>
#include<string>


class TableCell {
public:
	RECT cell;

	std::wstring content;
	BOOL isEditable = FALSE;


	void chngEditability();
};