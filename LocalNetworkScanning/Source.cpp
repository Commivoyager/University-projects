#define TIMEOUT 1000
#define _WINSOCK_DEPRECATED_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS
#include <winsock2.h>
#include <iphlpapi.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <windows.h>
#include <icmpapi.h>
#include<thread>
#include<chrono>
#include <mutex>
#include <vector>
#pragma comment(lib, "IPHLPAPI.lib")
#pragma comment(lib, "Ws2_32.lib")

std::mutex mtx;
int thcount = 0;
int mycount = 0;
const int maxcount = 255;



typedef struct
{
    short addrlen;  // длина ip-адреса
    int addrnum; // кол-во хостовых адресов
    //char** pstr; // указатель на массив ip-адресов в виде ASCII строк
    //unsigned char** pnumb; // указатель на массив ip-фдресов по байтам
    in_addr** pmusk; // указатель на массив масок
    struct in_addr** pin_addr;
    u_long* bordarr;
}hostinfo;
DWORD GetCurentIP(hostinfo* res)
{
    WSADATA wsaData;
    WSAStartup(MAKEWORD(1, 1), &wsaData); // инициализируем socket'ы используя Ws2_32.dll для процесса

    char HostName[1024]; // создаем буфер для имени хоста
    LPHOSTENT lphost;

    if (!gethostname(HostName, 1024)) // получаем имя хоста
    {
        printf("Local host name: %s\n\n", HostName);
        if (lphost = gethostbyname(HostName)) // получаем IP хоста, т.е. нашего компа
        {
            printf("Address type: ");
            switch (lphost->h_addrtype) {
            case AF_INET:
                printf("AF_INET\n");
                break;
            case AF_INET6:
                printf("AF_INET6\n");
                break;
            case AF_NETBIOS:
                printf("AF_NETBIOS\n");
                break;
            default:
                printf(" %d\n", lphost->h_addrtype);
                break;
            }
            printf("Address length: %d\n", res->addrlen = lphost->h_length);
            int i = 0;
            if (lphost->h_addrtype == AF_INET) {
                while (lphost->h_addr_list[i] != 0)
                    i++;
                res->addrnum = i; // кол-во ip-адресов
                char** strarr;
                unsigned char** numarr;
                struct in_addr** structarr;
                //strarr = (char**)malloc(sizeof(char*) * i);
                //numarr = (unsigned char**)malloc(sizeof(unsigned char*) * i);
                structarr = (struct in_addr**)malloc(sizeof(struct in_addr*) * i);
                for (int k = 0; k < i; k++)
                {
                    // *lphost->h_length - чтобы вместились lphost->h_length - 1 цифры в ASCII и разделяющие точки
                    
                    //strarr[k] = (char*)malloc(sizeof(char) * lphost->h_length * lphost->h_length);
                    //numarr[k] = (unsigned char*)malloc(sizeof(unsigned char) * lphost->h_length);
                    structarr[k] = (struct in_addr*)malloc(sizeof(struct in_addr) * lphost->h_length);
                }
                //res->pstr = strarr;
                //res->pnumb = numarr;
                res->pin_addr = structarr;
                i = 0;
                while (lphost->h_addr_list[i] != 0)
                {
                    structarr[i]->s_addr = *(u_long*)lphost->h_addr_list[i];
                    //for (int j = 0; j < lphost->h_length; j++)
                    //{
                       // numarr[i][j] = ((u_char*)(&(structarr[i]->s_addr)))[j];
                    //}
                    printf("\t%d) IPv4 Address: %s\n", i, inet_ntoa(*structarr[i]));
                    i++;
                }
                printf("\n");
            }
        }
    }
    // освобождаем сокеты, т.е. завершаем использование Ws2_32
    WSACleanup(); 
    return 0;
}
int getMask(hostinfo* res)
{
    ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);
    PIP_ADAPTER_INFO pAdapterInfo = (IP_ADAPTER_INFO*)malloc(sizeof(IP_ADAPTER_INFO));
    if (pAdapterInfo == NULL) {
        std::cerr << "Memory allocation error." << std::endl;
        return 1;
    }

    if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == ERROR_BUFFER_OVERFLOW) {
        free(pAdapterInfo);
        pAdapterInfo = (IP_ADAPTER_INFO*)malloc(ulOutBufLen);
        if (pAdapterInfo == NULL) {
            std::cerr << "Memory allocation error." << std::endl;
            return 1;
        }
    }

    if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == NO_ERROR) {
        in_addr** maskarr;
        maskarr = (in_addr**)malloc(sizeof(in_addr*) * res->addrnum);
        for (int i = 0; i < res->addrnum; i++)
        {
            maskarr[i] = (in_addr*)malloc(sizeof(in_addr));
        }
        res->pmusk = maskarr;
        int count = 0;
        for (int k = 0; k < res->addrnum; k++)
        {
            IP_ADAPTER_INFO* pAdapter = pAdapterInfo;
            while (pAdapter)
            {
                char* ip = pAdapter->IpAddressList.IpAddress.String;
                char* mask = pAdapter->IpAddressList.IpMask.String;
                if (!strcmp(inet_ntoa(*res->pin_addr[k])/*res->pstr[k]*/, ip))
                {
                    ((*res).pmusk)[k]->s_addr = inet_addr(mask);
                    printf("\t%d) %s\n", count++, pAdapter->Description);
                }
                //printf("\tAdapter Addr: \t");

                /*for (int i = 0; i < pAdapter->AddressLength; i++) {
                    if (i == (pAdapter->AddressLength - 1))
                        printf("%.2X\n", (int)pAdapter->Address[i]);
                    else
                        printf("%.2X-", (int)pAdapter->Address[i]);
                }*/
                pAdapter = pAdapter->Next;
            }
        }
    }
    else {
        std::cerr << "Failed to retrieve adapter information." << std::endl;
        return 1;
    }

    if (pAdapterInfo)
        free(pAdapterInfo);

    return 0;
}




typedef struct
{
    char str[16];
    u_long time;
}TpingArr;
int ArrMaxSize = 0;
TpingArr* pinginfo = (TpingArr*)malloc(sizeof(TpingArr) * 1);
void pushbyind(TpingArr el, int ind)
{
    TpingArr* TempArr;
    if (ind >= ArrMaxSize)
    {
        int oldsize = ArrMaxSize;
        ArrMaxSize = ind << 2;
        TempArr = (TpingArr*)malloc(sizeof(TpingArr) * ArrMaxSize);
        memset(TempArr, 0, sizeof(TpingArr) * ArrMaxSize);
        for (int i = 0; i < oldsize; i++)
        {
            TempArr[i] = pinginfo[i];
        }
        free(pinginfo);
        pinginfo = TempArr;
    }
    pinginfo[ind] = el;
}
int popbyind(TpingArr& el, int ind)
{
    if (ind >= ArrMaxSize)
    {
        return 0;
    }
    el = pinginfo[ind];
}

int getEnumBorders(hostinfo* res)
{
    res->bordarr = (u_long*)malloc(sizeof(u_long) * 3 * res->addrnum);
    for (int i = 0; i < res->addrnum; i = i++)
    {
        res->bordarr[i] = (res->pin_addr[i]->s_addr) & (res->pmusk[i]->s_addr);
        res->bordarr[i + res->addrnum] = res->bordarr[i] + ~(res->pmusk[i]->s_addr);
    }
    return 0;
}
int echoreq(const char* ipstr)
{
    TpingArr info;
    int ind = 0;
    HANDLE hIcmpFile;
    unsigned long ipaddr = INADDR_NONE;
    DWORD dwRetVal = 0;
    char SendData[32] = "Data Buffer";
    LPVOID ReplyBuffer = NULL;
    DWORD ReplySize = 0;
    ipaddr = inet_addr(ipstr);
    if (ipaddr == INADDR_NONE) {
        printf("INADDR_NONE\n");
        return 1;
    }
    hIcmpFile = IcmpCreateFile();
    if (hIcmpFile == INVALID_HANDLE_VALUE) {
        printf("\tUnable to open handle.\n");
        printf("IcmpCreatefile returned error: %ld\n", GetLastError());
        return 1;
    }
    ReplySize = sizeof(ICMP_ECHO_REPLY) + sizeof(SendData);
    ReplyBuffer = (VOID*)malloc(ReplySize);
    mtx.lock();
    thcount++;
    ind = mycount;
    mycount++;
    mtx.unlock();
    dwRetVal = IcmpSendEcho(hIcmpFile, ipaddr, SendData, sizeof(SendData),
        NULL, ReplyBuffer, ReplySize, TIMEOUT);
    mtx.lock();
    thcount--;
    mtx.unlock();
    if (dwRetVal != 0) {
        PICMP_ECHO_REPLY pEchoReply = (PICMP_ECHO_REPLY)ReplyBuffer;
        if (!pEchoReply->Status)
        {
            strcpy(info.str, ipstr);
            info.time = pEchoReply->RoundTripTime;
            pushbyind(info, ind);
        }
    }
    free(ReplyBuffer);
    return 0;
}
u_long convertAddr(u_long addr)
{
    u_long res = 0;
    for (int i = 0, j = sizeof(u_long) - 1; i < sizeof(u_long); i++, j--)
    {
        ((char*)&res)[j] = ((char*)&addr)[i];
    }
    return res;
}
int pingall(hostinfo* res)
{
    char* ipstr;
    in_addr ip;
    std::vector<std::thread> threads;
    int currcount = 0;
    for (int i = 0; i < res->addrnum; i++)
    {
        u_long lowaddr = convertAddr(res->bordarr[i]);
        u_long highaddr = convertAddr(res->bordarr[i + res->addrnum]);
        for (u_long j = lowaddr; j <= highaddr; j++)
        {
            ip.s_addr = convertAddr(j);
            ipstr = (char*)malloc(sizeof(char) * (res->addrlen + res->addrlen));
            strcpy(ipstr, inet_ntoa(ip));
            do
            {
                mtx.lock();
                currcount = thcount;
                mtx.unlock();
                if (currcount < maxcount)
                {
                    threads.push_back(std::thread(echoreq, ipstr));
                }
                else
                {
                    std::this_thread::sleep_for(std::chrono::milliseconds(100));
                }
            } while (currcount >= maxcount);
            //free(ipstr);
        }

    }
    for (auto& t : threads) {
        t.join();
    }
    return 0;
}

void macoutp(IPAddr* ip)
{
    char macstr[20];
    ULONG  pMacAddr[2];
    ULONG PhyAddrLen;
    u_long err = 0;
    if (NO_ERROR == (err = SendARP(*ip, INADDR_ANY, pMacAddr, &PhyAddrLen)))
    {
        sprintf(macstr, "%02X-%02X-%02X-%02X-%02X-%02X",
            ((u_char*)pMacAddr)[0],
            ((u_char*)pMacAddr)[1],
            ((u_char*)pMacAddr)[2],
            ((u_char*)pMacAddr)[3],
            ((u_char*)pMacAddr)[4],
            ((u_char*)pMacAddr)[5]);
        printf("MAC: %s\n", macstr);
    }
    /*else
    {
        printf("Mac error: %ld\n", err);
    }*/

}
void infooutp()
{
    in_addr ipinf;
    //struct hostent* remoteHost;
    //char* addr;
    int count = 0;
    for (int i = 0; i < ArrMaxSize; i++)
    {
        if (strcmp(pinginfo[i].str, ""))
        {
            printf("\nIP: %s\n", pinginfo[i].str);
            ipinf.s_addr = inet_addr(pinginfo[i].str);
            macoutp(&ipinf.s_addr);
            /*addr = inet_ntoa(ipinf);
            remoteHost = gethostbyaddr(addr, 4, AF_INET);
            if (remoteHost != NULL)
            {
                printf("name: %s\n", remoteHost->h_name);
            }*/
            printf("Ping time: %ldms\n\n", pinginfo[i].time);
            count++;
        }
    }
    printf("Total number: %d", count);
}


void clearinfo(hostinfo* hostinf)
{
    free(hostinf->bordarr);
    for (int i = 0; i < hostinf->addrnum; i++)
    {
        free(hostinf->pin_addr[i]);
    }
    free(hostinf->pin_addr);
    for (int i = 0; i < hostinf->addrnum; i++)
    {
        free(hostinf->pmusk[i]);
    }
    free(hostinf->pmusk);
    free(pinginfo);
}

int main()
{
    hostinfo host;
    GetCurentIP(&host);
    getMask(&host);
    getEnumBorders(&host);
    pingall(&host);
    infooutp();
    clearinfo(&host);
    
    
    return 0;
}