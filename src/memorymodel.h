#ifndef MEMORYMODEL_H
#define MEMORYMODEL_H

#include <QObject>
#include <QList>
#include <QTimer>

#include "processmanager.h"

typedef struct _ProcessInfo
{
    Q_GADGET

public:
    QList<QString> processIdList;
    QList<QString> processNameList;
    QString processId;
    QString processName;
    QList<QString> checkProcess;
    QList<double> memoryUsage;

    Q_PROPERTY(QString processId MEMBER processId)
    Q_PROPERTY(QString processName MEMBER processName)
    Q_PROPERTY(QList<QString> checkProcess MEMBER checkProcess)
    Q_PROPERTY(QList<double> memoryUsage MEMBER memoryUsage)
} ProcessInfo;

class MemoryModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double memoryTotalUsage READ getMemoryTotalUsage WRITE setMemoryTotalUsage NOTIFY memoryTotalUsageChanged)
    Q_PROPERTY(double cpuTotalUsage READ getCPUTotalUsage WRITE setCPUTotalUsage NOTIFY cpuTotalUsageChanged)
    Q_PROPERTY(double processMemoryUsage READ getProcessMemoryUsage WRITE setProcessMemoryUsage NOTIFY processMemoryUsageChanged)
    Q_PROPERTY(QVector<ProcessInfo> processList READ getProcessList WRITE setProcessList NOTIFY processListChanged)

public:
    explicit MemoryModel(QObject *parent = nullptr);
    ~MemoryModel();

    Q_INVOKABLE void addProcess(QString processName);
    Q_INVOKABLE QList<double> getProcessDataList(QString processName);

    double getMemoryTotalUsage() const;
    double getCPUTotalUsage() const;
    double getProcessMemoryUsage() const;
    QVector<ProcessInfo> getProcessList() const;

    void setMemoryTotalUsage(const double& memory);
    void setCPUTotalUsage(const double& cpu);
    void setProcessMemoryUsage(const double& value);
    void setProcessList(const QVector<ProcessInfo>& list);

private:
    void connectInit();
    void timerTimeout();
    void getProcessData();

signals:
    void memoryTotalUsageChanged();
    void cpuTotalUsageChanged();
    void processMemoryUsageChanged();
    void processListChanged();

private:
    ProcessManager *processManager;
    double memoryTotalUsage;
    double cpuTotalUsage;
    double processMemoryUsage;
    QVector<ProcessInfo> processList;
    QTimer *processTimer;
    QMap<QString, QList<double>> memoryMap;
};

#endif // MEMORYMODEL_H
