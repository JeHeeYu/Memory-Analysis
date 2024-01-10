import QtQuick 2.15

Image {
    id: root

    signal imageClick()

    MouseArea {
        anchors.fill: parent
        hoverEnabled:true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            imageClick()
        }
    }
}
