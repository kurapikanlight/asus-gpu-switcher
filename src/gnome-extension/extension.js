import Gio from "gi://Gio";
import GObject from "gi://GObject";
import St from "gi://St";
import Clutter from "gi://Clutter";

import * as Main from "resource:///org/gnome/shell/ui/main.js";
import * as QuickSettings from "resource:///org/gnome/shell/ui/quickSettings.js";
import * as PopupMenu from "resource:///org/gnome/shell/ui/popupMenu.js";
import * as ModalDialog from "resource:///org/gnome/shell/ui/modalDialog.js";

import {Extension} from "resource:///org/gnome/shell/extensions/extension.js";

const GPU_MODES = [
    { name: "Integrated", dgpu: "1", mux: "1" },
    { name: "Hybrid", dgpu: "0", mux: "1" },
    { name: "NVIDIA", dgpu: "0", mux: "0" },
];

const GpuToggle = GObject.registerClass(
    class GpuToggle extends QuickSettings.QuickMenuToggle {
        constructor() {
            super({
                title: "GPU Mode",
                subtitle: "Detecting...",
                iconName: "video-display-symbolic",
                toggleMode: false,
            });

            this._addMode("Integrated");
            this._addMode("Hybrid");
            this._addMode("NVIDIA");

            this._refreshMode();
        }

        _addMode(modeName) {
            const item = new PopupMenu.PopupMenuItem(modeName);
            item.connect("activate", () => this._changeMode(modeName));
            this.menu.addMenuItem(item);
        }

        async _changeMode(modeName) {
            const mode = GPU_MODES.find(m => m.name === modeName);
            if (!mode) return;

            this.subtitle = `Applying ${modeName}...`;

            try {
                await this._runCommand(["asusctl", "armoury", "set", "dgpu_disable", mode.dgpu]);
                await this._runCommand(["asusctl", "armoury", "set", "gpu_mux_mode", mode.mux]);
                this.subtitle = modeName;
                this._showRestartDialog(modeName);
            } catch (error) {
                this.subtitle = "Failed";
                this._showError(modeName, error.message || String(error));
            }
        }

        _runCommand(command) {
            return new Promise((resolve, reject) => {
                try {
                    const process = Gio.Subprocess.new(
                        command,
                        Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE
                    );

                    process.communicate_utf8_async(null, null, (proc, result) => {
                        try {
                            const [, stdout, stderr] = proc.communicate_utf8_finish(result);
                            if (!proc.get_successful()) {
                                const message = (stderr || stdout || "").trim();
                                reject(new Error(message || `Command failed: ${command.join(" ")}`));
                                return;
                            }
                            resolve({ stdout: stdout || "", stderr: stderr || "" });
                        } catch (error) {
                            reject(error);
                        }
                    });
                } catch (error) {
                    reject(error);
                }
            });
        }

        async _refreshMode() {
            try {
                const result = await this._runCommand(["asusctl", "armoury", "list"]);
                const output = `${result.stdout}\n${result.stderr}`;
                const dgpu = this._getCurrentValue(output, "dgpu_disable");
                const mux = this._getCurrentValue(output, "gpu_mux_mode");

                if (dgpu === 1 && mux === 1) {
                    this.subtitle = "Integrated";
                } else if (dgpu === 0 && mux === 1) {
                    this.subtitle = "Hybrid";
                } else if (dgpu === 0 && mux === 0) {
                    this.subtitle = "NVIDIA";
                } else {
                    this.subtitle = "Unknown";
                }
            } catch (error) {
                this.subtitle = "Unknown";
            }
        }

        _getCurrentValue(output, controlName) {
            const lines = output.split("\n");
            let insideControl = false;

            for (const line of lines) {
                if (line.trim() === `${controlName}:`) {
                    insideControl = true;
                    continue;
                }
                if (insideControl && line.trim().endsWith(":") && !line.includes("current:")) {
                    insideControl = false;
                }
                if (insideControl) {
                    const match = line.match(/current:\s*.*\(([-]?\d+)\)/);
                    if (match) return Number.parseInt(match[1], 10);

                    const bracketMatch = line.match(/current:\s*.*\[([-]?\d+)\]/);
                    if (bracketMatch) return Number.parseInt(bracketMatch[1], 10);
                }
            }
            return null;
        }

        _showRestartDialog(modeName) {
            const dialog = new ModalDialog.ModalDialog();
            const title = new St.Label({
                text: `${modeName} Mode`,
                style_class: "headline",
            });
            title.x_align = Clutter.ActorAlign.CENTER;
            dialog.contentLayout.add_child(title);

            const message = new St.Label({
                text: "The GPU mode has been configured.\n\nA restart is required for the change to take effect.",
            });
            message.x_align = Clutter.ActorAlign.CENTER;
            dialog.contentLayout.add_child(message);

            dialog.setButtons([
                {
                    label: "Restart Later",
                    action: () => dialog.close(),
                    key: Clutter.KEY_Escape,
                },
                {
                    label: "Restart Now",
                    action: () => {
                        dialog.close();
                        Gio.Subprocess.new(["systemctl", "reboot"], Gio.SubprocessFlags.NONE);
                    },
                    default: true,
                },
            ]);

            dialog.open();
        }

        _showError(modeName, error) {
            const dialog = new ModalDialog.ModalDialog();
            const title = new St.Label({
                text: `${modeName} Mode Failed`,
                style_class: "headline",
            });
            title.x_align = Clutter.ActorAlign.CENTER;
            dialog.contentLayout.add_child(title);

            const message = new St.Label({ text: error });
            dialog.contentLayout.add_child(message);

            dialog.setButtons([
                {
                    label: "Close",
                    action: () => dialog.close(),
                    key: Clutter.KEY_Escape,
                },
            ]);

            dialog.open();
        }
    }
);

const GpuIndicator = GObject.registerClass(
    class GpuIndicator extends QuickSettings.SystemIndicator {
        constructor() {
            super();
            this._toggle = new GpuToggle();
            this.quickSettingsItems.push(this._toggle);
        }

        destroy() {
            if (this._toggle) {
                this._toggle.destroy();
                this._toggle = null;
            }
            super.destroy();
        }
    }
);

export default class AsusGpuSwitcher extends Extension {
    enable() {
        this._indicator = new GpuIndicator();
        Main.panel.statusArea.quickSettings.addExternalIndicator(this._indicator);
    }

    disable() {
        if (this._indicator) {
            this._indicator.destroy();
            this._indicator = null;
        }
    }
}