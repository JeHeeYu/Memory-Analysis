#include "processmanager.h"

#include <QTimer>

ProcessManager::ProcessManager(QObject *parent) : QObject(parent)
{
    pdhInit();
    getMemoryTotalUsage();
    getProcessList();

    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &ProcessManager::updateProcessInfo);
    timer->start(1000);
}

QVector<QPair<QString, QString>> ProcessManager::getProcessList()
{
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;

    QVector<QPair<QString, QString>> processList;

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        qDebug() << "Error creating process snapshot";

        return QVector<QPair<QString, QString>>();
    }

    pe32.dwSize = sizeof(PROCESSENTRY32);

    if (!Process32First(hProcessSnap, &pe32))
    {
        qDebug() << "Error getting process information";
        CloseHandle(hProcessSnap);

        return QVector<QPair<QString, QString>>();
    }

    do
    {
        QString processID = QString::number(pe32.th32ProcessID);
        QString processName = QString::fromWCharArray(pe32.szExeFile);

        processList.push_back(QPair<QString, QString>(processID, processName));

    } while (Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);

    return processList;
}

double ProcessManager::getMemoryTotalUsage()
{
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(memoryStatus);

    if (GlobalMemoryStatusEx(&memoryStatus)) {
        double totalMemory = static_cast<double>(memoryStatus.ullTotalPhys);
        double usedMemory = static_cast<double>(totalMemory - memoryStatus.ullAvailPhys);
        double usagePercentage = (usedMemory / totalMemory) * 100.0;

        return usagePercentage;
    }

    return 0.0;
}

DWORD ProcessManager::getProcessIdByName(const wchar_t* processName)
{
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

double ProcessManager::getMemoryUsageByProcessName(const wchar_t* processName)
{
    qDebug() << Q_FUNC_INFO << processName;

    double memoryUsageMB = 0.0;
    DWORD processId = getProcessIdByName(processName);
    if (processId == 0) {
        qDebug() << "Process not found";
        return 0.0;
    }

    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, processId);
    if (hProcess == nullptr) {
        qDebug() << "Error opening process";
        return 0.0;
    }

    PROCESS_MEMORY_COUNTERS_EX pmc;
    if (GetProcessMemoryInfo(hProcess, (PROCESS_MEMORY_COUNTERS*)&pmc, sizeof(pmc))) {
        memoryUsageMB = static_cast<double>(pmc.WorkingSetSize) / (1024 * 1024);
        CloseHandle(hProcess);
    }

    CloseHandle(hProcess);

    return memoryUsageMB;
}

void ProcessManager::updateProcessInfo()
{
    getProcessList();
    getMemoryTotalUsage();
    getCPUTotalUsage();
}

void ProcessManager::pdhInit()
{
    PdhOpenQuery(NULL, NULL, &cpuQuery);
    PdhAddCounter(cpuQuery, L"\\Processor(_Total)\\% Processor Time", NULL, &cpuTotal);
    PdhCollectQueryData(cpuQuery);
}


double ProcessManager::getCPUTotalUsage()
{
    PDH_FMT_COUNTERVALUE counterVal;

    PdhCollectQueryData(cpuQuery);
    PdhGetFormattedCounterValue(cpuTotal, PDH_FMT_DOUBLE, NULL, &counterVal);

    return counterVal.doubleValue;
}
