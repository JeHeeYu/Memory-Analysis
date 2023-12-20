#ifndef PROCESSMANAGER_H
#define PROCESSMANAGER_H

#include <windows.h>
#include <tlhelp32.h>
#include <tchar.h>
#include <Psapi.h>

#include <QObject>
#include <QDebug>

class ProcessManager : public QObject
{
    Q_OBJECT

public:
    explicit ProcessManager(QObject *parent = nullptr);
    void getProcessList();
    double getMemoryTotalUsage();

signals:
    void sendMemoryTotalUsage(double memory);
};

#endif // PROCESSMANAGER_H
