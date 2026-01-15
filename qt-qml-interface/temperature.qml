import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: 100
    height: 100

    // Temperature circle
    Rectangle {
        width: 100
        height: 100
        color: "red"
        border.color: "gray"
        border.width: 1
        radius: 50

        Canvas {
            id: temperatureCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                // Circle
                ctx.beginPath()
                ctx.arc(width / 2, height / 2, width / 2 - 10, 0, 2 * Math.PI)
                ctx.fillStyle = "#000000"
                ctx.fill()

                // Temperature text
                ctx.font = "24px Arial"
                ctx.fillStyle = "#FFFFFF"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(temperature + " Â°C", width / 2, height / 2)
            }
        }
    }

    property real temperature: 0

    Connections {
        target: canHandler
        onTemperatureUpdate: {
             console.log("Temperature updated:", temperature1);
            temperature = Math.round((temperature1 - 32) * 5/9)
        }
    }


    onTemperatureChanged: temperatureCanvas.requestPaint()
}
