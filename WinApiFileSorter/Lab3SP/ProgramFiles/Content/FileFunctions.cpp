#include <windows.h>
#include <vector>
#include <tchar.h> 
#include<stack>
#include "FileFunctions.h"
#include "StringFunctions.h"

TCHAR errorMessage[256]{};

DWORD getFileNames(StrVectr& files, StrMap& fMap, const TCHAR* dirPath, int &fCount, const TCHAR* optPath){
	WIN32_FIND_DATA fileData;
	HANDLE hFile = INVALID_HANDLE_VALUE;
	int pathLen = getStrLength(dirPath) + getStrLength(optPath) + getStrLength(L"\\*") + 1;
	TCHAR* path = new TCHAR[pathLen];
	_snwprintf_s(path, pathLen, pathLen, L"%s%s%s", dirPath, optPath, L"\\*");

	DWORD dwError = 0;
	hFile = FindFirstFile(path, &fileData);

	if (INVALID_HANDLE_VALUE == hFile) {
		wcscpy_s(errorMessage, L"The files could not be found");
		return 1;
	}

	path[pathLen - 2] = '\0';
	static int fileInd = 0;
	do {
		if (fileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
			if (strCompare(L".", fileData.cFileName) != 0 &&
				strCompare(L"..", fileData.cFileName) != 0) {
				if (getFileNames(files, fMap, path, fCount, fileData.cFileName)) {
				}
			}
		}
		else {
			addFName(files, fMap, fileData.cFileName, fileData.nFileSizeLow, fileData.nFileSizeHigh, fileData.ftCreationTime, fCount);
			fCount++;
			
		}
	} while (FindNextFile(hFile, &fileData) != 0);

	dwError = GetLastError();
	if (dwError != ERROR_NO_MORE_FILES) {
		wcscpy_s(errorMessage, L"Error with file finding");
		return 1;
	}
	
	FindClose(hFile);
	delete[] path;
	return 0;
}
