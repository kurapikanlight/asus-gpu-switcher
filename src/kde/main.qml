import QtQuick
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

    property string currentMode: "Detecting..."

    fullRepresentation: Column {
        spacing: 10
        padding: 15

        Label {
            text: "ASUS GPU Switcher"
            font.bold: true
        }

        Label {
            text: "Current mode: " + root.currentMode
        }

        Button {
            text: "Integrated"
            onClicked: root.currentMode = "Integrated"
        }

        Button {
            text: "Hybrid"
            onClicked: root.currentMode = "Hybrid"
        }

        Button {
            text: "NVIDIA"
            onClicked: root.currentMode = "NVIDIA"
        }
    }
}