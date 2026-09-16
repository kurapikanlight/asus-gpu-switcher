#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# ASUS GPU Switcher
# KDE Plasma Installer
# ============================================================

REPO="kurapikanlight/asus-gpu-switcher"
PLASMOID_ID="asus-gpu-switcher"
TAR_URL="https://github.com/${REPO}/archive/refs/heads/main.tar.gz"

echo
echo "=========================================="
echo "       ASUS GPU Switcher - KDE Plasma"
echo "=========================================="
echo

# ------------------------------------------------------------
# System Checks
# ------------------------------------------------------------

if [[ "${XDG_CURRENT_DESKTOP:-}" != *"KDE"* ]] && \
   [[ "${XDG_SESSION_DESKTOP:-}" != *"plasma"* ]] && \
   [[ "${DESKTOP_SESSION:-}" != *"plasma"* ]]; then
    echo "ERROR: KDE Plasma was not detected."
    exit 1
fi

if ! command -v kpackagetool6 >/dev/null 2>&1; then
    echo "ERROR: kpackagetool6 was not found."
    echo "Install the KDE Plasma / Frameworks 6 packages first."
    exit 1
fi

if ! command -v asusctl >/dev/null 2>&1; then
    echo "ERROR: asusctl was not found. Install asusctl first."
    exit 1
fi

if ! asusctl armoury list >/dev/null 2>&1; then
    echo "ERROR: ASUS Armoury controls are not available on this machine."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
    echo "ERROR: curl and tar are required."
    exit 1
fi

echo "[OK] System checks passed."

# ------------------------------------------------------------
# Download Plasmoid (KDE files only)
# ------------------------------------------------------------

TEMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

echo "Downloading latest version from GitHub..."
curl -sSL "$TAR_URL" | tar -xz -C "$TEMP_DIR"

# Only the src/kde folder is used here — the GNOME extension
# in src/gnome-extension is intentionally never touched.
PLASMOID_SRC="${TEMP_DIR}/asus-gpu-switcher-main/src/kde"

if [[ ! -d "$PLASMOID_SRC" ]]; then
    echo "ERROR: KDE plasmoid source not found in downloaded archive."
    exit 1
fi

# ------------------------------------------------------------
# Install / Upgrade Plasmoid
# ------------------------------------------------------------

echo "Installing plasmoid via kpackagetool6..."
if kpackagetool6 --type Plasma/Applet --list 2>/dev/null | grep -q "$PLASMOID_ID"; then
    kpackagetool6 --type Plasma/Applet --upgrade "$PLASMOID_SRC"
else
    kpackagetool6 --type Plasma/Applet --install "$PLASMOID_SRC"
fi

echo "[OK] Plasmoid installed."

echo
echo "=========================================="
echo "       Installation Complete!"
echo "=========================================="
echo
echo "Add it to your panel or system tray:"
echo "  Right-click a panel -> Add Widgets -> search 'ASUS GPU Switcher'"
echo