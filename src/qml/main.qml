import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts
import QtQuick.Layouts

import "./Components"
import "./Consts"

import "./Chart"

Window {
    width: Screen.width - 500
    height: Screen.height - 300
    visible: true
    title: qsTr("Hello World")
    color: colors.mainBackgroundColor

    Colors { id: colors }
    Images { id: images }

    readonly property int defaultaxisXMin: 0
    readonly property int defaultaxisXMax: 7
    readonly property int defaultaxisYMin: 0
    readonly property int defaultaxisYMax: 100

    readonly property int playingStatus: 0
    readonly property int pausingStatus: 1
    readonly property int stoppingStatus: 2

    property int chartStatus: stoppingStatus

    property int chartStartTime: 0
    property var charts: []
    property var scatters: []
    property var usageProcessList: []
    property var processList: memoryModel.processList
    property double memoryTotalUsage: memoryModel.memoryTotalUsage
    property double cpuTotalUsage: memoryModel.cpuTotalUsage

    property int axisXMin: 0
    property int axisXMax: 7
    property int axisYMin: 0
    property int axisYMax: 100

    onProcessListChanged: {
        for(let i = 0; i < processList.length; i++) {
            processListModel.append({no: i+1, pid: processList[i].processId, process: processList[i].processName})
        }
    }

    Component.onCompleted: {
        chartTimer.stop()
    }

    Image {
        id: image
        x: 30
        y: 30
        width: 150
        height: 150
        source: images.bgWhiteRectangle

        PretendardText {
            width: parent.width
            height: parent.height
            text: "Memory"
            font.pointSize: 20
            color: "black"
            horizontalAlignment: Text.AlignHCenter
        }

        CircularProgressBar {
            id: progress2
            lineWidth: 10
            value: memoryTotalUsage / 100.0
            size: 100
            secondaryColor: "#e0e0e0"
            primaryColor: colors.mainColor
            y: parent.height / 2 - height / 2 + 20
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: parseInt(progress2.value * 100) + "%"
                anchors.centerIn: parent
                font.pointSize: 20
                color: progress2.primaryColor
            }
        }
    }

    Image {
        id: image2
        x: 130
        y: 130
        width: 150
        height: 150
        source: images.bgWhiteRectangle

        PretendardText {
            width: parent.width
            height: parent.height
            text: "Memory"
            font.pointSize: 20
            color: colors.mainColor
            horizontalAlignment: Text.AlignHCenter
        }

        CircularProgressBar {
            id: progress3
            lineWidth: 10
            value: cpuTotalUsage / 100.0
            size: 100
            secondaryColor: "#e0e0e0"
            primaryColor: colors.mainColor
            y: parent.height / 2 - height / 2 + 20
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: parseInt(progress3.value * 100) + "%"
                anchors.centerIn: parent
                font.pointSize: 20
                color: progress3.primaryColor
            }
        }
    }

    ChartView {
        id: chart
        title: "Real-time Chart"
        antialiasing: true
        width: 950
        height: 400
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 25
        anchors.rightMargin: 30

        ValuesAxis {
            id: axisX
            min: axisXMin
            max: axisXMax
            tickCount: 7
            labelFormat: "%.0f"
        }

        ValuesAxis {
            id: axisY
            min: axisYMin
            max: axisYMax
            tickCount: 6
            labelFormat: "%.0f"
        }

        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 20
            anchors.rightMargin: 20
            spacing: 5

            Image {
                width: 20
                height: 20
                source: (chartStatus === playingStatus) ? images.playingIndicator : images.disableIndicator
            }

            Image {
                width: 20
                height: 20
                source: (chartStatus === pausingStatus) ? images.pausingIndicator : images.disableIndicator
            }

            Image {
                width: 20
                height: 20
                source: (chartStatus === stoppingStatus) ? images.stoppingIndicator : images.disableIndicator
            }
        }

        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 70
            anchors.rightMargin: 40
            spacing: 5

            ImageButton {
                width: 20
                height: 20
                source: (chartStatus === pausingStatus && memoryModel.processPlayingStatus() === true) ? images.playingEnable : images.playingDisable

                onImageClick: {
                    if(chartStatus === pausingStatus && memoryModel.processPlayingStatus() === true) {
                        chartStatus = playingStatus

                        chartTimer.start()
                    }
                }
            }

            ImageButton {
                width: 20
                height: 20
                source: (chartStatus === playingStatus && memoryModel.processPlayingStatus() === true) ? images.pausingEnable : images.pausingDisable

                onImageClick: {
                    if(chartStatus === playingStatus && memoryModel.processPlayingStatus() === true) {
                        chartStatus = pausingStatus

                        chartTimer.stop()
                    }
                }
            }

            ImageButton {
                width: 20
                height: 20
                source: (chartStatus !== stoppingStatus) ? images.stoppingEnable : images.stoppingDisable

                onImageClick: {
                    if(chartStatus !== stoppingStatus) {
                        chartStatus = stoppingStatus

                        removeChartSeries()
                        chartTimer.stop()
                        memoryModel.allRemoveProcess()
                        usageProcessList = []
                        chartStartTime = 0

                        axisXMax = defaultaxisXMax
                        axisYMax = defaultaxisYMax
                    }
                }
            }

            ImageButton {
                width: 20
                height: 20
                source: (chartStatus !== playingStatus) ? images.settingEnable : images.settingDisable

                onImageClick: {
                    if(chartStatus !== playingStatus) {
                        popup.open()
                    }
                }
            }
        }

        PretendardText {
            text: "(s)"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 32
            anchors.rightMargin: 15
        }
    }

    Timer {
        id: chartTimer
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            if (axisXMax < chartStartTime) {
                axisXMax = chartStartTime
            }

            for(let i = 0; i < charts.length; i++) {
                let usage = memoryModel.getProcessDataList(usageProcessList[i])

                if(axisYMax < usage[usage.length - 1]) {
                    axisYMax = usage[usage.length - 1] + 50
                }

                charts[i].append(chartStartTime, usage[usage.length - 1])
                scatters[i].append(chartStartTime, usage[usage.length - 1])
            }

            chartStartTime++
        }
    }


    Image {
        id: searchImage
        width: 200
        height: 45
        source: images.searchBar
        anchors.bottom: processListView.top
        anchors.left: parent.left
        anchors.bottomMargin: 0
        anchors.leftMargin: 20

        TextEdit {
            anchors.fill: parent

            onTextChanged: {
                searchProcessName(text)
            }
        }
    }

    ListView {
        id: processListView
        model: processListModel
        delegate: processListDelegate
        width: 400
        height: 400
        header: processListHeader
        headerPositioning: ListView.OverlayHeader
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 30
        anchors.leftMargin: 30
        clip: true

        ScrollBar.vertical: ScrollBar {
            width: 20
            policy: ScrollBar.AlwaysOn
        }
    }

    ListModel {
        id: processListModel
    }

    Component {
        id: processListHeader
        Item {
            z: 2
            width: 400
            height: 30

            Rectangle {
                width: parent.width
                height: parent.height
                color: colors.mainColor
                border.width: 1

                Row {
                    width: parent.width
                    height: parent.height

                    PretendardText {
                        width: 100
                        height: parent.height
                        text: "No"
                        font.pixelSize: 16
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    PretendardText {
                        width: 100
                        height: parent.height
                        text: "PID"
                        font.pixelSize: 16
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    PretendardText {
                        width: 200
                        height: parent.height
                        text: "프로세스 이름"
                        font.pixelSize: 16
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    Component {
        id: processListDelegate

        Item {
            width: 400
            height: 30

            Rectangle {
                width: parent.width
                height: parent.height
                color: "white"
                border.width: 1
                border.color: "grey"

                Row {
                    width: parent.width
                    height: parent.height

                    PretendardText {
                        width: 100
                        height: parent.height
                        text: no
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    PretendardText {
                        width: 100
                        height: parent.height
                        text: pid
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    PretendardText {
                        width: 200
                        height: parent.height
                        text: process
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {

                    }

                    onDoubleClicked: {
                        memoryModel.addProcess(process.toString())
                        addChartSeries(process.toString())
                        usageProcessList.push(process.toString())
                        chartTimer.start()
                        chartStatus = playingStatus
                    }
                }
            }
        }
    }

    SettingPopup {
        id: popup

        onOkButtonClicked: (startTime, endTime, minRange, maxRange) =>  {
                               if(startTime !== -1) {
                                   axisXMin = startTime
                               }

                               if(endTime !== -1) {
                                   axisXMax = endTime
                               }

                               if(minRange !== -1) {
                                   axisYMin = minRange
                               }

                               if(maxRange !== -1) {
                                   axisYMax = maxRange
                               }

                               if(startTime !== -1 && endTime !== -1 && minRange !== -1 && maxRange !== 1) {
                                   popup.close()
                               }
                           }

        onCloseButtonClicked: {
            popup.close()
        }
    }

    function addChartSeries(processName) {
        let line = chart.createSeries(ChartView.SeriesTypeLine, processName, axisX, axisY);
        charts.push(line)

        let scatter = chart.createSeries(ChartView.SeriesTypeScatter, processName, axisX, axisY);
        scatter.markerSize = 10
        scatters.push(scatter)
    }

    function removeChartSeries() {
        chart.removeAllSeries()
        charts = []
        scatters = []
    }

    function searchProcessName(keyword) {
        processListModel.clear()
        let number = 0

        if (keyword === "") {
            for (let i = 0; i < processList.length; i++) {
                processListModel.append({no: i+1, pid: processList[i].processId, process: processList[i].processName})
            }
        } else {
            for (let j = 0; j < processList.length; j++) {
                if (processList[j].processName.toLowerCase().indexOf(keyword.toLowerCase()) !== -1) {
                    processListModel.append({no: number++, pid: processList[j].processId, process: processList[j].processName})
                }
            }
        }
    }
}
