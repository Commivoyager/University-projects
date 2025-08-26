#ifndef STRING_FUNCTIONS
#define STRING_FUNCTIONS
#include <tchar.h>
#include <vector>
#include<unordered_map>
#include<string>
#include<windows.h>

struct FileStructInfo;
using StrVectr = std::vector<FileStructInfo>;
using StrMap = std::unordered_map<std::basic_string<TCHAR>, FileStructInfo*>;


int getStrLength(const TCHAR* const str);
int strCompare(const TCHAR* str1, const TCHAR* str2);
int getIntLen(int num);
void getStrFromInt(int num, TCHAR* str, int strLen);
int fixOccurr(StrMap& fMap, TCHAR* fName);
int findDotInd(const TCHAR* fName, int startInd);
int addFName(StrVectr& files, StrMap& fMap, TCHAR* fName, DWORD SizeLow, DWORD SizeHigh, FILETIME createTime, int fileInd);
#endif