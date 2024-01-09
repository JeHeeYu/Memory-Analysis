#include "memorymodel.h"

MemoryModel::MemoryModel(QObject *parent) : QObject(parent)
{
    qDebug() << Q_FUNC_INFO;

    processManager = new ProcessManager();
    processTimer = new QTimer(this);
    connectInit();

    QTimer::singleShot(1000, this, &MemoryModel::getProcessData);
    processTimer->start(2000);
}

MemoryModel::~MemoryModel()
{
    delete processManager;
    delete processTimer;
}

void MemoryModel::connectInit()
{
    QObject::connect(processTimer, &QTimer::timeout, this, &MemoryModel::timerTimeout);
}

void MemoryModel::timerTimeout()
{
    setMemoryTotalUsage(processManager->getMemoryTotalUsage());

    for (int i = 0; i < processList.last().checkProcess.length(); i++) {
        memoryMap[processList.last().checkProcess[i]].append(processManager->GetMemoryUsageByProcessName(processList.last().checkProcess[i].toStdWString().c_str()));
    }
}

void MemoryModel::getProcessData()
{
    QList<ProcessInfo> processes;

    QVector<QPair<QString, QString>> processPairs = processManager->getProcessList();

    for (const auto& processPair : processPairs) {

        ProcessInfo processInfo;
        processInfo.processId = processPair.first;
        processInfo.processName = processPair.second;

        processes.append(processInfo);
    }

    if (processes.isEmpty()) {
        qDebug() << "Failed to get process list";
    }
    else {
        setProcessList(processes);
    }
}

void MemoryModel::addProcess(QString processName)
{
    processList.last().checkProcess.push_back(processName);
}

QList<double> MemoryModel::getProcessDataList(QString processName)
{
    QList<double> list;

    for(int i = 0; i < memoryMap[processName].length(); i++) {
        list.append(memoryMap[processName].value(i));
    }

    return list;
}


double MemoryModel::getMemoryTotalUsage() const
{
    return memoryTotalUsage;
}

double MemoryModel::getProcessMemoryUsage() const
{
    return processMemoryUsage;
}

QVector<ProcessInfo> MemoryModel::getProcessList() const
{
    return processList;
}

void MemoryModel::setMemoryTotalUsage(const double& memory)
{
    if (memoryTotalUsage != memory) {
        memoryTotalUsage = memory;

        emit memoryTotalUsageChanged();
    }
}

void MemoryModel::setProcessMemoryUsage(const double& value)
{
    if (processMemoryUsage != value) {
        processMemoryUsage = value;

        emit processMemoryUsageChanged();
    }
}

void MemoryModel::setProcessList(const QVector<ProcessInfo>& list)
{
    processList.clear();
    processList.append(list);

    emit processListChanged();
}
