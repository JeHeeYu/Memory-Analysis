import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts
import QtQuick.Layouts

import "./Components"
import "./Consts"

Window {
    width: Screen.width - 500
    height: Screen.height - 300
    visible: true
    title: qsTr("Hello World")
    color: colors.mainBackgroundColor

    Colors { id: colors }
    Images { id: images }

    property int chartStartTime: 0
    property var charts: []
    property var processIdList: memoryModel.processIdList
    property var processNameList: memoryModel.processNameList

    onProcessNameListChanged: {
        for(let i = 0; i < processIdList.length; i++) {
            processListModel.append({no: i+1, pid: processIdList[i], process: processNameList[i]})
        }
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
            value: memoryModel.memoryTotalUsage / 100.0
            size: 100
            secondaryColor: "#e0e0e0"
            primaryColor: "#ab47bc"
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
                min: 1
                max: 10
                tickCount: 7
                labelFormat: "%.0f"
            }

            ValuesAxis {
                id: axisY
                min: 0
                max: 1000
                tickCount: 6
                labelFormat: "%.0f"
            }

            Row {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 30
                anchors.rightMargin: 30

                Button {
                    width: 40
                    height: 30
                    text: "Test"

                    onClicked: {
                        addChartSeries()
                    }
                }

                Button {
                    width: 40
                    height: 30
                    text: "Test2"
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
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            if (axisX.max < chartStartTime) {
                axisX.max = chartStartTime
            }

            for(let i = 0; i < charts.length; i++) {
                charts[i].append(chartStartTime, memoryModel.processMemoryUsage)
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
                    }
                }
            }
        }
    }

    function addChartSeries(processName) {
        let line = chart.createSeries(ChartView.SeriesTypeLine, processName, axisX, axisY);

        charts.push(line)
    }

    function searchProcessName(keyword) {
        processListModel.clear()
        let number = 0

        if (keyword === "") {
            for (let i = 0; i < processNameList.length; i++) {
                processListModel.append({no: i+1, pid: processIdList[i], process: processNameList[i]})
            }
        } else {
            for (let j = 0; j < processNameList.length; j++) {
                if (processNameList[j].toLowerCase().indexOf(keyword.toLowerCase()) !== -1) {
                    processListModel.append({no: number++, pid: processIdList[j], process: processNameList[j]})
                }
            }
        }
    }
}
