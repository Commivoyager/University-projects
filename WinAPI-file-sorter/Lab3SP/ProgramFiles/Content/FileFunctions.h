#ifndef FILE_FUNCTIONS
#define FILE_FUNCTIONS

#include <windows.h>
#include <tchar.h> 
#include "StringFunctions.h"
#include "WindowContent.h"

struct FileStructInfo;
using StrVectr = std::vector<FileStructInfo>;

DWORD getFileNames(StrVectr& files, StrMap& fMap, const TCHAR* dirPath, int& fCount, const TCHAR* optPath = L"");
extern TCHAR errorMessage[256];

#endif