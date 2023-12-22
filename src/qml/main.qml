import QtQuick 2.15
import QtQuick.Window 2.15
import QtCharts

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

        LineSeries {
            id: chartLine
            name: "Real-time Data"
            axisX: axisX
            axisY: axisY
        }

        ScatterSeries {
            id: chartPoint
            name: "Real-time Data"
            axisX: axisX
            axisY: axisY
            markerSize: 10
            markerShape: ScatterSeries.MarkerShapeCircle
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            let newValue = Math.random() * 100;

            chartLine.append(chartStartTime, newValue)
            chartPoint.append(chartStartTime, newValue)

            if (axisX.max < chartStartTime) {
                axisX.max = chartStartTime
            }

            chartStartTime++
        }
    }
}
