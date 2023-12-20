#include "memorymodel.h"

#include <QTimer>

MemoryModel::MemoryModel(QObject *parent) : QObject(parent)
{
    qDebug() << Q_FUNC_INFO;

    processManager = new ProcessManager();

    memoryTotalUsage = 0.0;

    QObject::connect(processManager, &ProcessManager::sendMemoryTotalUsage,
            this, &MemoryModel::memoryTotalUsageSlot);
}

double MemoryModel::getMemoryTotalUsage() const
{
    return memoryTotalUsage;
}

void MemoryModel::setMemoryTotalUsage(const double& memory)
{
    if(memoryTotalUsage != memory) {
        memoryTotalUsage = memory;

        emit memoryTotalUsageChanged();
    }
}

void MemoryModel::memoryTotalUsageSlot(double memory)
{
    qDebug() << Q_FUNC_INFO << memory;

    setMemoryTotalUsage(memory);
}
