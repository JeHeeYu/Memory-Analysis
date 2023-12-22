#include "processmanager.h"

#include <QTimer>

ProcessManager::ProcessManager(QObject *parent) : QObject(parent)
{
    getProcessList();
    getMemoryTotalUsage();
    const wchar_t* processName = L"qtcreator.exe";
    GetMemoryUsageByProcessName(processName);

    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &ProcessManager::updateProcessInfo);
    timer->start(1000);
}

void ProcessManager::getProcessList()
{
    //qDebug() << Q_FUNC_INFO;

    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        qDebug() << "Error creating process snapshot";
        return;
    }

    pe32.dwSize = sizeof(PROCESSENTRY32);

    if (!Process32First(hProcessSnap, &pe32))
    {
        qDebug() << "Error getting process information";
        CloseHandle(hProcessSnap);
        return;
    }

    qDebug() << "PID\tProcess Name";

    do
    {
        qDebug() << pe32.th32ProcessID << "\t" << QString::fromWCharArray(pe32.szExeFile);
    } while (Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);
}

void ProcessManager::getMemoryTotalUsage()
{
    //qDebug() << Q_FUNC_INFO;
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(memoryStatus);

    if (GlobalMemoryStatusEx(&memoryStatus)) {
        double totalMemory = static_cast<double>(memoryStatus.ullTotalPhys);
        double usedMemory = static_cast<double>(totalMemory - memoryStatus.ullAvailPhys);
        double usagePercentage = (usedMemory / totalMemory) * 100.0;

        //qDebug() << Q_FUNC_INFO << usagePercentage;

        emit sendMemoryTotalUsage(usagePercentage);
    }
}

DWORD ProcessManager::GetProcessIdByName(const wchar_t* processName)
{
    //qDebug() << Q_FUNC_INFO;

    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32);

    HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE) {
        qDebug() << "Error creating process snapshot";
        return 0;
    }

    if (Process32First(hProcessSnap, &pe32)) {
        do {
            if (_wcsicmp(pe32.szExeFile, processName) == 0) {
                CloseHandle(hProcessSnap);
                return pe32.th32ProcessID;
            }
        } while (Process32Next(hProcessSnap, &pe32));
    }

    CloseHandle(hProcessSnap);
    return 0;
}

void ProcessManager::GetMemoryUsageByProcessName(const wchar_t* processName)
{
    //qDebug() << Q_FUNC_INFO;

    DWORD processId = GetProcessIdByName(processName);
    if (processId == 0) {
        qDebug() << "Process not found";
        return;
    }

    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, processId);
    if (hProcess == nullptr) {
        qDebug() << "Error opening process";
        return;
    }

    PROCESS_MEMORY_COUNTERS_EX pmc;
    if (GetProcessMemoryInfo(hProcess, (PROCESS_MEMORY_COUNTERS*)&pmc, sizeof(pmc))) {
        // Memory usage in MB
        double memoryUsageMB = static_cast<double>(pmc.WorkingSetSize) / (1024 * 1024);
        CloseHandle(hProcess);
        sendProcessMemoryUsage(memoryUsageMB);

        qDebug() << memoryUsageMB;
    }

    CloseHandle(hProcess);
    return;
}

void ProcessManager::updateProcessInfo()
{
    //qDebug() << Q_FUNC_INFO;
    //getProcessList();
    const wchar_t* processName = L"qtcreator.exe";
    GetMemoryUsageByProcessName(processName);
    getMemoryTotalUsage();
}
