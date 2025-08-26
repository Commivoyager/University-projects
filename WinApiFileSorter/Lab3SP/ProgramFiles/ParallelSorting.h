#pragma once
#include <fstream>
#include <locale>
#include <codecvt>
#include <sstream>

#include "WindowContent.h"
constexpr int procNum = 4;
void ParallelSorting(StrVectr& filesData, int sortParam, const int PartsNum);