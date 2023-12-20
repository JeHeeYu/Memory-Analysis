#ifndef MEMORYMODEL_H
#define MEMORYMODEL_H

#include <QObject>
#include <QDebug>

#include "processmanager.h"

class MemoryModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double memoryTotalUsage READ getMemoryTotalUsage WRITE setMemoryTotalUsage NOTIFY memoryTotalUsageChanged)

public:
    explicit MemoryModel(QObject *parent = nullptr);
    double getMemoryTotalUsage() const;

private:
    void setMemoryTotalUsage(const double& memory);

signals:
    void memoryTotalUsageChanged();

public slots:
    void memoryTotalUsageSlot(double memory);

private:
    ProcessManager *processManager;

    double memoryTotalUsage;
};

#endif // MEMORYMODEL_H
