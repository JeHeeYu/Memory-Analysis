#ifndef MEMORYMODEL_H
#define MEMORYMODEL_H

#include <QObject>
#include <QDebug>

#include "processmanager.h"

class MemoryModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double memoryTotalUsage READ getMemoryTotalUsage WRITE setMemoryTotalUsage NOTIFY memoryTotalUsageChanged)
    Q_PROPERTY(double processMemoryUsage READ getProcessMemoryUsage WRITE setProcessMemoryUsage NOTIFY processMemoryUsageChanged)

public:
    explicit MemoryModel(QObject *parent = nullptr);

    double getMemoryTotalUsage() const;
    double getProcessMemoryUsage() const;

private:
    void setMemoryTotalUsage(const double& memory);
    void setProcessMemoryUsage(const double& value);

signals:
    void memoryTotalUsageChanged();
    void processMemoryUsageChanged();

public slots:
    void receiveMemoryTotalUsage(double memory);
    void receiveProcessMemoryUsage(double memory);

private:
    ProcessManager *processManager;

    double memoryTotalUsage;
    double processMemoryUsage;
};

#endif // MEMORYMODEL_H
