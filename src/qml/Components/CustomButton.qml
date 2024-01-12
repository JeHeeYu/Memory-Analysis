import QtQuick 2.15

import "../Consts"

Rectangle {
    id: root

    signal buttonClicked()

    Colors { id: colors }

    property string buttonText: ""
    property int textSize: 12
    property color textColor: "white"

    PretendardText {
        text: buttonText
        font.pixelSize: textSize
        anchors.centerIn: parent
        color: textColor
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            buttonClicked()
        }
    }
}

