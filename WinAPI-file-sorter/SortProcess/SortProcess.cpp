#include <vector>
#include <iostream>
#include <string>
#include <fstream>
#include <locale>
#include <codecvt>
#include <sstream>
#include <windows.h>
#include "../Lab3SP/ProgramFiles/Content/WindowContent.h"

int columnIndex;

void Merge(std::vector<SortInfo>& data, int left, int mid, int right) {
    std::vector<SortInfo> temp(right - left + 1); // Temporary array
    int i = left, j = mid + 1, k = 0;

    while (i <= mid && j <= right) {
        if (data[i].content < data[j].content) {
            temp[k++] = data[i++];
        }
        else {
            temp[k++] = data[j++];
        }
    }

    while (i <= mid) {
        temp[k++] = data[i++];
    }

    while (j <= right) {
        temp[k++] = data[j++];
    }

    for (k = 0; k < temp.size(); ++k) {
        data[left + k] = temp[k];
    }
}

void MergeSort(std::vector<SortInfo>& data, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;

        MergeSort(data, left, mid);
        MergeSort(data, mid + 1, right);

        Merge(data, left, mid, right);
    }
}

std::vector<SortInfo> ReadFromFile(const std::wstring& fileName) {
    std::wifstream file(fileName);
    std::vector<SortInfo> data;
    std::wstring line;

    while (std::getline(file, line)) {
        std::wstringstream ss(line);
        SortInfo entry;
        std::wstring token;

        if (std::getline(ss, token, L'*')) {
            entry.content = token;
        }
        if (std::getline(ss, token, L'*')) {
            entry.index = std::stol(token);
        }
        data.push_back(entry);
    }
    file.close();
    return data;
}

int wmain(int argc, wchar_t* argv[])
{
    if (argc < 4) {
        std::wcout << "Usage: ChildSortProcess <start> <end> <fileName>" << std::endl;
        Sleep(1000);
        return 1;
    }

    int start = std::stoi(argv[1]);
    int end = std::stoi(argv[2]);
    std::wstring fileName = argv[3];

    std::vector<SortInfo> data = ReadFromFile(fileName);
    MergeSort(data, 0, data.size() - 1);

    std::wofstream outFile(fileName);
    for (int j = 0; j < data.size(); j++) {
        outFile << data[j].content << L"*" << data[j].index << L"*" << "\n";
    }
    outFile.close();

    std::wcout << "Sorting is done between " << start << " and " << end;
    Sleep(1000);

    return 0;
}