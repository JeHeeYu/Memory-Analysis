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
    QVector<QPair<QString, QString>> getProcessList();
    double getMemoryTotalUsage();

    DWORD GetProcessIdByName(const wchar_t* processName);
    double GetMemoryUsageByProcessName(const wchar_t* processName);

private slots:
    void updateProcessInfo();

private:
    QTimer *timer;
};

#endif // PROCESSMANAGER_H
