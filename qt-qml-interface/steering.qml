import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Rectangle {
    width: 300
    height: 200
    color: "black"
    border.color: "gray"
    border.width: 2
    radius: 10

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 20

        // circle box
        Item
        {
            width: 200
            height: 200
            Layout.alignment: Qt.AlignCenter

            Canvas
            {
                id: turnIndicator
                anchors.fill: parent
                onPaint:
                {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    // Circle
                    ctx.beginPath()
                    ctx.arc(width / 2, height / 2, width / 2 - 10, 0, 2 * Math.PI)
                    ctx.fillStyle = "#000000"
                    ctx.fill()

                    // Draw ticks
                    for (var i = 0; i <= 45; i++)
                    {
                        var angle = Math.PI * 5 / 4 - (3 * Math.PI / 2) * (i / 45)
                        var startX = width / 2 + Math.cos(angle) * (width / 2 - 40)
                        var startY = height / 2 - Math.sin(angle) * (height / 2 - 40)
                        var endX = width / 2 + Math.cos(angle) * (width / 2 - (i % 5 == 0 ? 30 : 35))
                        var endY = height / 2 - Math.sin(angle) * (height / 2 - (i % 5 == 0 ? 30 : 35))
                        ctx.beginPath()
                        ctx.moveTo(startX, startY)
                        ctx.lineTo(endX, endY)
                        ctx.strokeStyle = "#FFFFFF"
                        ctx.lineWidth = 2
                        ctx.stroke()
                    }

                    // Left triangle
                    ctx.beginPath()
                    ctx.moveTo(width / 2 - 20, height / 2 - 10)
                    ctx.lineTo(width / 2 - 20, height / 2 + 10)
                    ctx.lineTo(width / 2 - 40, height / 2)
                    ctx.closePath()
                    ctx.fillStyle = leftTurnPressed ? (blinkState ? "green" : "white") : "#FFFFFF"
                    ctx.fill()

                    // Right triangle
                    ctx.beginPath()
                    ctx.moveTo(width / 2 + 20, height / 2 - 10)
                    ctx.lineTo(width / 2 + 20, height / 2 + 10)
                    ctx.lineTo(width / 2 + 40, height / 2)
                    ctx.closePath()
                    ctx.fillStyle = rightTurnPressed ? (blinkState ? "green" : "white") : "#FFFFFF"
                    ctx.fill()

                    // Up triangle
                    ctx.beginPath()
                    ctx.moveTo(width / 2 - 10, height / 2 - 20)
                    ctx.lineTo(width / 2 + 10, height / 2 - 20)
                    ctx.lineTo(width / 2, height / 2 - 40)
                    ctx.closePath()
                    ctx.fillStyle = forwardPressed ? (blinkState ? "blue" : "white") : "#FFFFFF"
                    ctx.fill()

                    // Down triangle
                    ctx.beginPath()
                    ctx.moveTo(width / 2 - 10, height / 2 + 20)
                    ctx.lineTo(width / 2 + 10, height / 2 + 20)
                    ctx.lineTo(width / 2, height / 2 + 40)
                    ctx.closePath()
                    ctx.fillStyle = reversePressed ? (blinkState ? "blue" : "white") : "#FFFFFF"
                    ctx.fill()
                }
            }
        }
        // Forward Button
                Button {
                    text: "Forward"
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    height: 50
                    onClicked: {
                        leftTurnPressed = false
                        rightTurnPressed = false
                        forwardPressed = true
                        reversePressed = false
                        startBlinking()
                        gpioHandler.disableReverse();
                    }
                }
                // Left and Right Turn Buttons
                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true
                    Button {
                        text: "Left Turn"
                        Layout.fillWidth: true
                        font.pixelSize: 20
                        height: 50
                        onClicked: {
                            leftTurnPressed = true
                            rightTurnPressed = false
                            forwardPressed = false
                            reversePressed = false
                            startBlinking()
                        }
                    }

                    Button {
                        text: "Right Turn"
                        Layout.fillWidth: true
                        font.pixelSize: 20
                        height: 50
                        onClicked: {
                            leftTurnPressed = false
                            rightTurnPressed = true
                            forwardPressed = false
                            reversePressed = false
                            startBlinking()
                        }
                    }
                }
                // Reverse Button
                Button {
                    text: "Reverse"
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    height: 50
                    onClicked: {
                        leftTurnPressed = false
                        rightTurnPressed = false
                        forwardPressed = false
                        reversePressed = true
                        startBlinking()
                        gpioHandler.enableReverse();
                    }
                }
            }
            // Blinking
            property bool leftTurnPressed: false
            property bool rightTurnPressed: false
            property bool forwardPressed: false
            property bool reversePressed: false
            property bool blinkState: false

            Timer
            {
                id: blinkTimer
                interval: 350
                running: false
                repeat: true
                onTriggered:
                {
                    blinkState = !blinkState
                    turnIndicator.requestPaint()
                }
            }

            function startBlinking()
            {
                blinkState = true
                blinkTimer.start()
            }

            function stopBlinking()
            {
                blinkState = false
                blinkTimer.stop()
                turnIndicator.requestPaint()
            }
        }
