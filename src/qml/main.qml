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
            processListModel.append({pid: processIdList[i], process: processNameList[i]})
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
            width: 600
            height: 400
            anchors.centerIn: parent

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
                max: 100
                tickCount: 6
                labelFormat: "%.0f"
            }

            // 첫 번째 선
            LineSeries {
                id: chartLine1
                name: "Real-time Data 123"
                axisX: axisX
                axisY: axisY
            }

            // 두 번째 선
            LineSeries {
                id: chartLine2
                name: "Real-time Data 456"
                axisX: axisX
                axisY: axisY
            }

            LineSeries {
                id: chartLine3
                name: "Real-time Data 789"
                axisX: axisX
                axisY: axisY
            }

            ScatterSeries {
                id: chartPoint
                name: "Real-time Data 456"
                axisX: axisX
                axisY: axisY
                markerSize: 10
                markerShape: ScatterSeries.MarkerShapeCircle
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
                        add()
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

            for(var i = 0; i < charts.length; i++) {
                charts[i].append(chartStartTime, Math.random() * 100)
            }

            chartStartTime++
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
        anchors.bottomMargin: 20
        anchors.leftMargin: 20
        clip: true
    }

    ListModel {
        id: processListModel

        Component.onCompleted: {
            processListModel.append({pid: "PID", process: "Process"})
        }
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
                color: "grey"
                border.width: 1

                Row {
                    width: parent.width
                    height: parent.height
                    Text {
                        width: 200
                        height: parent.height
                        text: "pid"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        width: 200
                        height: parent.height
                        text: "process"
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
                    Text {
                        width: 200
                        height: parent.height
                        text: pid
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                    }

                    Text {
                        width: 200
                        height: parent.height
                        text: process
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    function add() {
        let line = chart.createSeries(ChartView.SeriesTypeLine, "Line series", axisX, axisY);

        charts.push(line)
    }
}
