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
        title: "Line"
        antialiasing: true
        legend.visible: false
        width: 400
        height: 400
        anchors.top: parent.top
        anchors.right: parent.right

        ValuesAxis {
            id: axisX
            min: 0
            max: 1000
            tickCount: 5
        }

        ValuesAxis {
            id: axisY
            min: 0
            max: 1000
            tickCount: 5
        }

        LineSeries {
            id: series1
            name: "LineSeries"
            axisX: axisX
            axisY: axisY
        }

        ScatterSeries {
            id: series2
            axisX: axisX
            axisY: axisY
        }

        Component.onCompleted: {
            for (var i = 0; i <= 10; i++) {
                series1.append(i, 5000);
                series2.append(i, 5000);
            }
        }
    }
}
