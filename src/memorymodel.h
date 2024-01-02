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
    Q_PROPERTY(QStringList processIdList READ getProcessIdList WRITE setProcessIdList NOTIFY processIdListChanged)
    Q_PROPERTY(QStringList processNameList READ getProcessNameList WRITE setProcessNameList NOTIFY processNameListChanged)

public:
    explicit MemoryModel(QObject *parent = nullptr);

    Q_INVOKABLE void addProcess(QString processName);

    double getMemoryTotalUsage() const;
    double getProcessMemoryUsage() const;
    QStringList getProcessIdList() const;
    QStringList getProcessNameList() const;

private:
    void connectInit();
    void setMemoryTotalUsage(const double& memory);
    void setProcessMemoryUsage(const double& value);
    void setProcessIdList(const QStringList& list);
    void setProcessNameList(const QStringList& list);

signals:
    void memoryTotalUsageChanged();
    void processMemoryUsageChanged();
    void processIdListChanged();
    void processNameListChanged();

public slots:
    void receiveMemoryTotalUsage(const double& memory);
    void receiveProcessMemoryUsage(const double& memory);
    void receiveProcessIdList(const QStringList& list);
    void receiveProcessNameList(const QStringList& list);

private:
    ProcessManager *processManager;

    double memoryTotalUsage;
    double processMemoryUsage;
    QStringList processIdList;
    QStringList processNameList;

    QList<QTimer*> processTimers;
};

#endif // MEMORYMODEL_H
