import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1200
    height: 600
    title: "motors' control unit"

    Rectangle {
           anchors.fill: parent
           gradient: Gradient {
               GradientStop { position: 0.0; color: "#000000" }
               GradientStop { position: 1.0; color: "#333333" }
           }
       }

    Image
    {
        id: logo
        source: "file:///home/pi/Downloads/actialogo.png"
        width: 170
        height: 35
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
    }
    GridLayout {
        columns: 2
        anchors.centerIn: parent

        Loader {
            source: "speedometer.qml"
        }

        Loader {
            source: "steering.qml"
        }

        Loader {
            source: "temperature.qml"
        }
        Loader {
            source: "brake.qml"
        }
    }
}
