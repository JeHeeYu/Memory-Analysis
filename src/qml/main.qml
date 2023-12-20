import QtQuick 2.15
import QtQuick.Window 2.15

import "./Components"
import "./Consts"

Window {
    width: 640
    height: 480
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

        CircularProgressBar {
            id: progress2
            lineWidth: 10
            value: memoryModel.memoryTotalUsage / 100.0
            size: 100
            secondaryColor: "#e0e0e0"
            primaryColor: "#ab47bc"
            anchors.centerIn: parent

            Text {
                text: parseInt(progress2.value * 100) + "%"
                anchors.centerIn: parent
                font.pointSize: 20
                color: progress2.primaryColor
            }
        }
    }


}
