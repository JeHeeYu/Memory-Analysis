import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts
import QtQuick.Layouts

import "../Consts"
import "../Components"

Rectangle {
    z: 10
    id: root
    visible: false
    width: 250
    height: 300
    radius: 15
    anchors.centerIn: parent
    color: colors.white
    border.color: colors.d8d8d8
    border.width: 1

    signal closeButtonClicked()
    signal okButtonClicked(int startTime, int endTime, int minRange, int maxRange)

    Colors { id: colors }
    Strings { id: strings }

    PretendardText {
        text: "Chart Configuration"
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 15
        color: colors.mainColor
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 10

        Row {
            spacing: 15

            CustomButton {
                id: startTimeInputTitle
                width: 80
                height: 25
                radius: 8
                color: colors.mainColor
                buttonText: strings.startTime
                textSize: 15
                textColor: colors.white
            }

            Rectangle {
                id: startTimeInputBg
                width: 100
                height: 25
                radius: 8
                color: colors.white
                border.color: colors.d8d8d8
                border.width: 1

                TextInput {
                    id: startTimeInput
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: 13
                    validator: IntValidator {}

                    PretendardText {
                        id: startTimeHint
                        text: "Star Time..."
                        font.pixelSize: 13
                        color: colors.d8d8d8
                        visible: !startTimeInput.text && !startTimeInput.activeFocus
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Row {
            spacing: 15

            CustomButton {
                id: endTimeInputTitle
                width: 80
                height: 25
                radius: 8
                color: colors.mainColor
                buttonText: strings.endTime
                textSize: 15
                textColor: colors.white
            }

            Rectangle {
                id: endTimeInputBg
                width: 100
                height: 25
                radius: 8
                color: colors.white
                border.color: colors.d8d8d8
                border.width: 1

                TextInput {
                    id: endTimeInput
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: 13
                    validator: IntValidator {}

                    PretendardText {
                        id: endTimeHint
                        text: "Text"
                        font.pixelSize: 13
                        color: colors.d8d8d8
                        visible: !endTimeInput.text && !endTimeInput.activeFocus
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Row {
            spacing: 15

            CustomButton {
                id: minRangeInputTitle
                width: 80
                height: 25
                radius: 8
                color: colors.mainColor
                buttonText: strings.minRange
                textSize: 15
                textColor: colors.white
            }

            Rectangle {
                id: minRangeInputBg
                width: 100
                height: 25
                radius: 8
                color: colors.white
                border.color: colors.d8d8d8
                border.width: 1

                TextInput {
                    id: minRangeInput
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: 13
                    validator: IntValidator {}

                    PretendardText {
                        id: minRangeHint
                        text: "Text"
                        font.pixelSize: 13
                        color: colors.d8d8d8
                        visible: !minRangeInput.text && !minRangeInput.activeFocus
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Row {
            spacing: 15

            CustomButton {
                id: maxRangeInputTitle
                width: 80
                height: 25
                radius: 8
                color: colors.mainColor
                buttonText: strings.maxRange
                textSize: 15
                textColor: colors.white
            }

            Rectangle {
                id: maxRangeInputBg
                width: 100
                height: 25
                radius: 8
                color: colors.white
                border.color: colors.d8d8d8
                border.width: 1

                TextInput {
                    id: maxRangeInput
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: 13
                    validator: IntValidator {}

                    PretendardText {
                        id: maxRangeHint
                        text: "Text"
                        font.pixelSize: 13
                        color: colors.d8d8d8
                        visible: !maxRangeInput.text && !maxRangeInput.activeFocus
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    CustomButton {
        id: okButton
        width: root.width / 2 - 15
        height: 35
        radius: 8
        color: colors.mainColor
        buttonText: strings.ok
        textSize: 15
        textColor: colors.white
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        onButtonClicked: {
            let startTime = (startTimeInput.text.trim() === "") ? -1 : parseInt(startTimeInput.text)
            let endTime = (endTimeInput.text.trim() === "") ? -1 : parseInt(endTimeInput.text)
            let minRange = (minRangeInput.text.trim() === "") ? -1 : parseInt(minRangeInput.text)
            let maxRange = (maxRangeInput.text.trim() === "") ? -1 : parseInt(maxRangeInput.text)

            okButtonClicked(startTime, endTime, minRange, maxRange)
        }
    }

    CustomButton {
        id: closeButton
        width: root.width / 2 - 15
        height: 35
        radius: 8
        color: colors.white
        border.width: 1
        border.color: colors.mainColor
        buttonText: strings.close
        textColor: colors.mainColor
        textSize: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        onButtonClicked: {
            closeButtonClicked()
        }
    }

    function open() {
        root.visible = true

        inputTextClear()
    }

    function close() {
        root.visible = false

        inputTextClear()
    }

    function inputTextClear() {
        startTimeInput.clear()
        endTimeInput.clear()
        maxRangeInput.clear()
        minRangeInput.clear()
    }
}
