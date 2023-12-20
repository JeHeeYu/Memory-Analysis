#include "memorymodel.h"

#include <QTimer>

MemoryModel::MemoryModel(QObject *parent) : QObject(parent)
{
    qDebug() << Q_FUNC_INFO;

    processManager = new ProcessManager();

    memoryTotalUsage = 0.0;
    processMemoryUsage = 0.0;

    QObject::connect(processManager, &ProcessManager::sendMemoryTotalUsage,
            this, &MemoryModel::receiveMemoryTotalUsage);
    QObject::connect(processManager, &ProcessManager::sendProcessMemoryUsage,
                     this, &MemoryModel::receiveProcessMemoryUsage);
}

double MemoryModel::getMemoryTotalUsage() const
{
    return memoryTotalUsage;
}

double MemoryModel::getProcessMemoryUsage() const
{
    return processMemoryUsage;
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

void MemoryModel::receiveMemoryTotalUsage(double memory)
{
    qDebug() << Q_FUNC_INFO << memory;

    setMemoryTotalUsage(memory);
}

void MemoryModel::receiveProcessMemoryUsage(double memory)
{
    qDebug() << Q_FUNC_INFO << memory;

    setProcessMemoryUsage(memory);
}
