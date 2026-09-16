import QtQuick
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import "gpu-switcher.js" as GpuSwitcher

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

    property string currentMode: "Detecting..."
    property string statusMessage: ""
    property bool showRestartPrompt: false

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        property var pendingApply: ({})
        readonly property string refreshCmd: "asusctl armoury list"

        function exec(cmd) {
            connectSource(cmd);
        }

        onNewData: (sourceName, data) => {
            var stdout = data["stdout"] || "";
            var stderr = data["stderr"] || "";

            var exitCode = data["exit code"];
            if (exitCode === undefined)
                exitCode = data["exitCode"];
            disconnectSource(sourceName);

            if (sourceName === refreshCmd) {
                // mirrors _refreshMode(): combine stdout+stderr, run detectMode()
                var output = stdout + "\n" + stderr;
                root.currentMode = GpuSwitcher.detectMode(output);
                return;
            }

            var modeName = pendingApply[sourceName];
            console.log("[gpu-switcher] matched pending mode:", modeName, "exitCode:", exitCode);

            if (modeName !== undefined) {
                delete pendingApply[sourceName];
                // mirrors _changeMode()'s try/catch: non-zero exit == failure
                if (exitCode === 0) {
                    root.currentMode = modeName;
                    root.statusMessage = "";
                    root.showRestartPrompt = true;
                } else {
                    root.statusMessage = (stderr || stdout || ("Command failed (exit " + exitCode + ")")).trim();
                    root.showRestartPrompt = false;
                }
            } else {
                console.log("[gpu-switcher] WARNING: no pending mode matched this sourceName!");
            }
        }
    }

    function refreshMode() {
        root.currentMode = "Detecting...";
        executable.exec(executable.refreshCmd);
    }

    function changeMode(modeName) {
        console.log("[gpu-switcher] changeMode called with:", modeName);
        var mode = GpuSwitcher.mode(modeName);
        if (!mode) {
            console.log("[gpu-switcher] WARNING: unknown mode name, aborting:", modeName);
            return;
        }

        root.currentMode = "Applying " + modeName + "...";
        root.statusMessage = "";
        root.showRestartPrompt = false;

        
        var cmd = "asusctl armoury set dgpu_disable " + mode.dgpu +
                  " && asusctl armoury set gpu_mux_mode " + mode.mux;
        console.log("[gpu-switcher] running command:", cmd);
        executable.pendingApply[cmd] = modeName;
        executable.exec(cmd);
    }

    Component.onCompleted: refreshMode()

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
            onClicked: {
                root.changeMode("Integrated");
            }
        }

        Button {
            text: "Hybrid"
            onClicked: {
                root.changeMode("Hybrid");
            }
        }

        Button {
            text: "NVIDIA"
            onClicked: {
                root.changeMode("NVIDIA");
            }
        }

        Label {
            visible: root.statusMessage.length > 0
            color: "red"
            wrapMode: Text.WordWrap
            text: root.statusMessage
        }

        Row {
            visible: root.showRestartPrompt
            spacing: 8

            Label {
                text: "Restart required to apply changes."
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                text: "Restart Now"
                onClicked: {
                    root.showRestartPrompt = false;
                    executable.exec("systemctl reboot");
                }
            }

            Button {
                text: "Later"
                onClicked: root.showRestartPrompt = false
            }
        }
    }
}
