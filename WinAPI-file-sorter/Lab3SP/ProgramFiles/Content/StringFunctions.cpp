#include "StringFunctions.h"
#include <tchar.h>
#include "FileFunctions.h"
#include <sstream>
#include <iomanip>

int getStrLength(const TCHAR* const str) {
	int len = 0;
	while (str[len]) {
		len++;
	}
	return len;
}

int getIntLen(int num) {
	int len = 0;
	do {
		num /= 10;
		len++;
	} while (num);
	return len;
}

void getStrFromInt(int num, TCHAR* str, int strSize) {
	_snwprintf_s(str, strSize, strSize-1, L"%d", num);
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

bool isNum(TCHAR symb) {
	if (symb >= '0' && symb <= '9') {
		return true;
	}
	return false;
}


int addFName(StrVectr& files, StrMap& fMap, TCHAR* fName, DWORD SizeLow, DWORD SizeHigh, FILETIME createTime, int fileInd) {
	SYSTEMTIME createTimeSyst;
	FileTimeToSystemTime(&createTime, &createTimeSyst);
	std::wstringstream wss;
	wss << std::setfill(L'0')
		<< std::setw(3) << createTimeSyst.wMilliseconds << L" " 
		<< std::setw(2) << createTimeSyst.wSecond << L" "      
		<< std::setw(2) << createTimeSyst.wMinute << L" "      
		<< std::setw(2) << createTimeSyst.wHour << L" "         
		<< std::setw(2) << createTimeSyst.wDay << L"."          
		<< std::setw(2) << createTimeSyst.wMonth << L"."    
		<< createTimeSyst.wYear;

	uint64_t fileSize = (static_cast<uint64_t>(SizeHigh) << 32) | SizeLow;

	int fNum = files.size();
	int occurCount = fixOccurr(fMap, fName);

	std::wstring fSize = std::to_wstring(fileSize);
	std::wstring fCreateDate = wss.str();
	files.emplace_back(fName, fSize, fCreateDate, occurCount, fileInd);
	// adding new value in map
	fMap[files[fNum].fileData[FILE_NAME_DATA]] = &files[fNum];
	return fNum;
}

int findDotInd(const TCHAR* fName, int startInd) {
	while (startInd >= 0 && fName[startInd] != '.') {
		startInd--;
	}
	return startInd;
}

int fixOccurr(StrMap& fMap, TCHAR* fName) {
	auto iterator = fMap.find(fName);
	if (iterator != fMap.end()) {
		return ++iterator->second->occurCount;
	}
	return 0;
}
