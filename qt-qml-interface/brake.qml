import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: 300
    height: 50
    color: "grey"
    border.color: "black"
    border.width: 2
    radius: 50

    anchors.left: parent.left
    anchors.leftMargin: -380
    anchors.bottom: parent.bottom
    anchors.bottomMargin: -10

    Button {
        id: brakeButton
        text: "Brake"
        width: parent.width
        height: parent.height + 15
        font.pixelSize: 20
        font.bold: true
        background: Rectangle {
            color: brakePressed ? "darkred" : "grey"
            border.color: "black"
            border.width: 2
            radius: 50
        }

        onPressed: {
            brakePressed = true
            gpioHandler.enableBrake()
        }

        onReleased: {
            brakePressed = false
            gpioHandler.disableBrake()
        }
    }

    property bool brakePressed: false
}
