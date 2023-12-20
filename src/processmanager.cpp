#include "processmanager.h"

#include <QTimer>

ProcessManager::ProcessManager(QObject *parent) : QObject(parent)
{
    getProcessList();
    qDebug() << Q_FUNC_INFO;
}

void ProcessManager::getProcessList()
{
    // Create a snapshot of the current processes
    HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE) {
        qDebug() << "Error creating process snapshot";
        return;
    }

    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32);

    if (!Process32First(hProcessSnap, &pe32)) {
        qDebug() << "Error retrieving process information";
        CloseHandle(hProcessSnap);
        return;
    }

    do {
        qDebug() << L"Process ID: " << pe32.th32ProcessID << L"\t";
        qDebug() << L"Executable file: " << pe32.szExeFile;


    } while (Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);
}

double ProcessManager::getMemoryTotalUsage()
{
    qDebug() << Q_FUNC_INFO;
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(memoryStatus);

    if (GlobalMemoryStatusEx(&memoryStatus)) {
        double totalMemory = static_cast<double>(memoryStatus.ullTotalPhys);
        double usedMemory = static_cast<double>(totalMemory - memoryStatus.ullAvailPhys);
        double usagePercentage = (usedMemory / totalMemory) * 100.0;

        emit sendMemoryTotalUsage(usagePercentage);
        return usagePercentage;
    }

    return -1.0;
}
