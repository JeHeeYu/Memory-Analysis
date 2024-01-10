#ifndef PROCESSMANAGER_H
#define PROCESSMANAGER_H

#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <Psapi.h>
#include "pdh.h"

#include <QObject>
#include <QDebug>
#include <QTimer>

class ProcessManager : public QObject
{
    Q_OBJECT

public:
    explicit ProcessManager(QObject *parent = nullptr);
    QVector<QPair<QString, QString>> getProcessList();
    double getMemoryTotalUsage();

    DWORD getProcessIdByName(const wchar_t* processName);
    double getMemoryUsageByProcessName(const wchar_t* processName);
    double getCPUTotalUsage();

private:
    void pdhInit();

private slots:
    void updateProcessInfo();

private:
    QTimer *timer;
    PDH_HQUERY cpuQuery;
    PDH_HCOUNTER cpuTotal;
};

#endif // PROCESSMANAGER_H
