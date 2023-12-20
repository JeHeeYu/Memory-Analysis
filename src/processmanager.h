#ifndef PROCESSMANAGER_H
#define PROCESSMANAGER_H

#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <Psapi.h>

#include <QObject>
#include <QDebug>
#include <QTimer>

class ProcessManager : public QObject
{
    Q_OBJECT

public:
    explicit ProcessManager(QObject *parent = nullptr);
    void getProcessList();
    void getMemoryTotalUsage();

    DWORD GetProcessIdByName(const wchar_t* processName);
    void GetMemoryUsageByProcessName(const wchar_t* processName);

signals:
    void sendMemoryTotalUsage(double memory);
    void sendProcessMemoryUsage(double value);

private slots:
    void updateProcessInfo();

private:
    QTimer *timer;
};

#endif // PROCESSMANAGER_H
