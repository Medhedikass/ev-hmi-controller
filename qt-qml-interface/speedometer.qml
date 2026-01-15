import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle
{
    property int speed: 0
    property int rpm: 0
    width: 600
    height: 400
    color: "transparent"

    RowLayout
    {
        spacing: 30

        // Speed control slider
        ColumnLayout
        {
            width: 100
            height: parent.height
            spacing: 10

            Slider
            {
            id: speedSlider
            from: 30
            to: 100
            stepSize: 1
            width: 50
            height: 300
            orientation: Qt.Vertical
            Layout.alignment: Qt.AlignVCenter
            enabled: false
            onValueChanged:
            {
                uartHandler.sendData(speedSlider.value);
                if (speedSlider.value < 30)
                {
                    speed = 0;
                }
                else
                {
                    speed = (speedSlider.value - 30) * (45 / 70);
                }
                speedometer.requestPaint();
            }

            Behavior on value
            {
                NumberAnimation
                {
                    duration: 3000
                    easing.type: Easing.InOutQuad
                }
            }

            // Customizing the slider
            Rectangle
            {
                width: 15
                height: speedSlider.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#D3D3D3"
                radius: 7
            }
            Rectangle
            {
                width: 30
                height: 30
                radius: 15
                color: "#5A5A5A"
                border.color: "#D3D3D3"
                border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                y: (1 - speedSlider.position) * (speedSlider.height - 30)
            }
            }
            // Button to set speed
            Button
            {
                text: "Set Speed"
                Layout.alignment: Qt.AlignCenter
                onClicked:
                {
                    var wheelDiameter = 0.276;
                    var wheelCircumference = Math.PI * wheelDiameter;
                    var speedInMPerMin = speedSlider.value * (1000 / 60);
                    var rpm = speedInMPerMin / wheelCircumference;
                    console.log("Speed set to: " + speedSlider.value + " km/h (" + rpm.toFixed(2) + " RPM)")
                }
            }
            }
            // Speedometer box
                    Rectangle
                    {
                        width: 400
                        height: 300
                        color: "black"
                        border.color: "gray"
                        border.width: 2
                        radius: 10

                        ColumnLayout
                        {
                            anchors.fill: parent
                            spacing: 20

                            // Speedometer
                            Item
                            {
                                width: 300
                                height: 300
                                Layout.alignment: Qt.AlignCenter

                                Canvas {
                                    id: speedometer
                                    anchors.fill: parent
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)

                                        // black circle
                                        ctx.beginPath()
                                        ctx.arc(width / 2, height / 2, width / 2 - 20, 0, 2 * Math.PI)
                                        ctx.fillStyle = "#000000"
                                        ctx.fill()

                                        // tick marks
                                        for (var i = 0; i <= 45; i++) {
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

                                            // Speed labels
                                            if (i % 5 == 0) {
                                                var labelX = width / 2 + Math.cos(angle) * (width / 2 - 55)
                                                var labelY = height / 2 - Math.sin(angle) * (height / 2 - 55)
                                                ctx.font = "12px Arial"
                                                ctx.fillStyle = "#FFFFFF"
                                                ctx.textAlign = "center"
                                                ctx.textBaseline = "middle"
                                                ctx.fillText(i, labelX, labelY)
                                            }
                                        }
                                        // needle
                                        var needleAngle = Math.PI * 5 / 4 - (3 * Math.PI / 2) * (speed / 45)
                                        var needleLength = width / 2 - 45
                                        var needleX = width / 2 + Math.cos(needleAngle) * needleLength
                                        var needleY = height / 2 - Math.sin(needleAngle) * needleLength

                                        ctx.beginPath()
                                        ctx.moveTo(width / 2, height / 2)
                                        ctx.lineTo(needleX, needleY)
                                        ctx.strokeStyle = "#FF0000"
                                        ctx.lineWidth = 3
                                        ctx.stroke()

                                        // RPM text
                                        ctx.font = "24px Arial"
                                        ctx.fillStyle = "#FFFFFF"
                                        ctx.textAlign = "center"
                                        ctx.textBaseline = "middle"
                                        ctx.fillText(rpm + " RPM", width / 2, height / 2 + 10)
                                    }
                                }
                            }
                            // Start and Stop buttons
                                            Rectangle
                                            {
                                                width: 280
                                                height: 80
                                                color: "transparent"
                                                border.color: "transparent"
                                                border.width: 2
                                                radius: 10

                                                Row
                                                {
                                                    spacing: 20
                                                    anchors.fill: parent
                                                    anchors.margins: 10

                                                    Button
                                                    {
                                                        id: startButton
                                                        text: "Start"
                                                        width: 120
                                                        height: 60
                                                        font.pointSize: 25
                                                        background: Rectangle
                                                        {
                                                            color: startButtonPressed ? "green" : "lightgray"
                                                            radius: 50
                                                        }
                                                        onClicked:
                                                        {
                                                            startButtonPressed = true
                                                            stopButtonPressed = false
                                                            speedSlider.enabled = true
                                                            gpioHandler.enableStart();
                                                        }
                                                    }
                                                    Button
                                                    {
                                                        id: stopButton
                                                        text: "Stop"
                                                        width: 120
                                                        height: 60
                                                        font.pointSize: 25
                                                        background: Rectangle
                                                        {
                                                            color: stopButtonPressed ? "red" : "lightgray"
                                                            radius: 50
                                                        }
                                                        onClicked:
                                                        {
                                                            stopButtonPressed = true
                                                            startButtonPressed = false
                                                            speedSlider.enabled = false
                                                            speedSlider.value = 0
                                                            gpioHandler.disableStart();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
        Connections
            {
                target: canHandler
                onRpmUpdate:
                {
                    rpm = rpm1
                    speedometer.requestPaint()
                }
            }

            // Button states
            property bool startButtonPressed: false
            property bool stopButtonPressed: false
        }
