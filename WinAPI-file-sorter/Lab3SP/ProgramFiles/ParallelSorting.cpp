#include "ParallelSorting.h"

std::vector<SortInfo> ReadFromFile(const std::wstring& fileName) {

    std::vector<SortInfo> data;

    std::wifstream file(fileName);
    // Set UTF-8 encoding
    file.imbue(std::locale(file.getloc(), new std::codecvt_utf8<wchar_t>));
    std::wstring line;

    while (std::getline(file, line)) {
        std::wstringstream ss(line);
        SortInfo entry;
        std::wstring token;

        // fromat: content*index
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

std::vector<SortInfo> MergeTwoSortedLists(const std::vector<SortInfo>& list1, const std::vector<SortInfo>& list2/*, int columnIndex*/)
{
    std::vector<SortInfo> merged;
    size_t i = 0, j = 0;

    while (i < list1.size() && j < list2.size()) {
        if (list1[i].content < list2[j].content) { 
            merged.push_back(list1[i++]);
        }    
        else {
            merged.push_back(list2[j++]);
        }
    }
    while (i < list1.size()) {
        merged.push_back(list1[i++]);
    }
    while (j < list2.size()) {
        merged.push_back(list2[j++]);
    }
    return merged;
}

std::vector<SortInfo> MergeKSortedLists(const std::vector<std::vector<SortInfo>>& sortedParts) {
    if (sortedParts.empty()) return {};

    std::vector<std::vector<SortInfo>> lists = sortedParts;
    int interval = 1;
    int length = static_cast<int>(lists.size());

    // At fiirst merge every two neighbour arrays into the 1st of them
    // then merge all arrays through one into the 1st
    // until all arrays merge into the very 1st array of vector
    while (interval < length) {
        for (int i = 0; i < length - interval; i += interval * 2) {
            lists[i] = MergeTwoSortedLists(lists[i], lists[i + interval]);
        }
        interval *= 2;
    }

    return lists[0];
}

void CreateSortProcess(const std::wstring& processName, const std::wstring fileName, int start, int end, PROCESS_INFORMATION& pi) {
    std::wstring params = L" " + std::to_wstring(start) + L" " + std::to_wstring(end) + L" " + fileName;

    STARTUPINFO si;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    if (!CreateProcess(processName.c_str(), &params[0], NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        MessageBox(NULL, (L"CreateProcess failed (" + std::to_wstring(GetLastError()) + L").").c_str(), L"", MB_OK);
    }
}

 void ParallelSorting(StrVectr& filesData, int sortParam, const int PartsNum)
{
    
    int dataSize = static_cast<int>(filesData.size());
    int partSize = dataSize / PartsNum;

    std::wstring processName = L"..\\..\\SortProcess.exe"; 
    std::vector<std::wstring> fileNames(PartsNum);

    std::vector<PROCESS_INFORMATION> processInfos(PartsNum);
    std::vector<HANDLE> processHandles(PartsNum);

    for (int i = 0; i < PartsNum; i++) {
        fileNames[i] = L"..\\..\\TempFiles" + std::to_wstring(i) + L".txt"; 
        std::wofstream outFile(fileNames[i]);
        outFile.imbue(std::locale(outFile.getloc(), new std::codecvt_utf8<wchar_t>)); // utf8
        int start = i * partSize;
        int end = (i == PartsNum - 1) ? dataSize : (start + partSize);
        for (int j = start; j < end; ++j) {
            outFile << filesData[j].fileData[sortParam] << L"*" << j << L"*" << "\n";
        }
        outFile.close();

        CreateSortProcess(processName, fileNames[i], start, end - 1, processInfos[i]);
        processHandles[i] = processInfos[i].hProcess;
    }

    int tOut = 20000;
    // TRUE - waiting for all processes to complete
    DWORD procRes = WaitForMultipleObjects(PartsNum, processHandles.data(),TRUE, tOut);
    if (procRes == WAIT_TIMEOUT) {
        for (int i = 0; i < PartsNum; i++) {
            if (GetExitCodeProcess(processHandles[i], &procRes) && procRes == STILL_ACTIVE) {
                TerminateProcess(processHandles[i], 1);
            }
        }
    }
    for (int i = 0; i < PartsNum; i++) {
        CloseHandle(processInfos[i].hProcess);
        CloseHandle(processInfos[i].hThread);
    }

    std::vector<std::vector<SortInfo>> sortedParts(PartsNum);
    for (int i = 0; i < PartsNum; i++) {
        sortedParts[i] = ReadFromFile(fileNames[i]);
        _wremove(fileNames[i].c_str());
    }

    std::vector<SortInfo> sortedData =  MergeKSortedLists(sortedParts);

    for (int i = 0; i < dataSize; i++) {
        filesData[i].sortInd = sortedData[i].index;
    }
}

