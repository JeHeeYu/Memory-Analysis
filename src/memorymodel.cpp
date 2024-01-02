#include "memorymodel.h"

#include <QTimer>

MemoryModel::MemoryModel(QObject *parent) : QObject(parent)
{
    qDebug() << Q_FUNC_INFO;

    processManager = new ProcessManager();

    memoryTotalUsage = 0.0;
    processMemoryUsage = 0.0;
    processIdList.clear();
    processNameList.clear();

    connectInit();
}

void MemoryModel::connectInit()
{
    QObject::connect(processManager, &ProcessManager::sendMemoryTotalUsage,
                     this, &MemoryModel::receiveMemoryTotalUsage);
    QObject::connect(processManager, &ProcessManager::sendProcessMemoryUsage,
                     this, &MemoryModel::receiveProcessMemoryUsage);
    QObject::connect(processManager, &ProcessManager::sendProcessIdList,
                     this, &MemoryModel::receiveProcessIdList);
    QObject::connect(processManager, &ProcessManager::sendProcessNameList,
                     this, &MemoryModel::receiveProcessNameList);
}

void MemoryModel::addProcess(QString processName)
{
    QTimer *processTimer = new QTimer(this);

    connect(processTimer, &QTimer::timeout, this, [=]() {
        std::wstring str = processName.toStdWString();
        const wchar_t* wstr = str.c_str();
        processManager->GetMemoryUsageByProcessName(wstr);
    });

    processTimer->start(1000);

    processTimers.append(processTimer);
}

double MemoryModel::getMemoryTotalUsage() const
{
    return memoryTotalUsage;
}

double MemoryModel::getProcessMemoryUsage() const
{
    return processMemoryUsage;
}

QStringList MemoryModel::getProcessIdList() const
{
    return processIdList;
}

QStringList MemoryModel::getProcessNameList() const
{
    return processNameList;
}

void MemoryModel::setMemoryTotalUsage(const double& memory)
{
    if(memoryTotalUsage != memory) {
        memoryTotalUsage = memory;

        emit memoryTotalUsageChanged();
    }
}

void MemoryModel::setProcessMemoryUsage(const double& value)
{
    if(processMemoryUsage != value) {
        processMemoryUsage = value;

        emit processMemoryUsageChanged();
    }
}

void MemoryModel::setProcessIdList(const QStringList& list)
{
    if(processIdList != list) {
        processIdList = list;

        emit processIdListChanged();
    }
}

void MemoryModel::setProcessNameList(const QStringList& list)
{
    if(processNameList != list) {
        processNameList = list;

        emit processNameListChanged();
    }
}

void MemoryModel::receiveMemoryTotalUsage(const double& memory)
{
    //qDebug() << Q_FUNC_INFO << memory;

    setMemoryTotalUsage(memory);
}

void MemoryModel::receiveProcessMemoryUsage(const double& memory)
{
    //qDebug() << Q_FUNC_INFO << memory;

    setProcessMemoryUsage(memory);
}

void MemoryModel::receiveProcessIdList(const QStringList& list)
{
    setProcessIdList(list);
}

void MemoryModel::receiveProcessNameList(const QStringList& list)
{
    setProcessNameList(list);
}
