#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# ASUS GPU Switcher
# GNOME Installer
#
# Supports GNOME on any Linux distribution.
# Requires:
#   - GNOME Shell
#   - gnome-extensions
#   - asusctl / asusd
#   - ASUS Armoury GPU controls
# ============================================================

REPO="kurapikanlight/asus-gpu-switcher"
UUID="asus-gpu-switcher@kurapikanlight"
ZIP_NAME="asus-gpu-switcher.zip"
DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${ZIP_NAME}"

echo
echo "=========================================="
echo "       ASUS GPU Switcher - GNOME"
echo "=========================================="
echo

# ------------------------------------------------------------
# Check GNOME
# ------------------------------------------------------------

if [[ "${XDG_CURRENT_DESKTOP:-}" != *"GNOME"* ]] &&
   [[ "${XDG_SESSION_DESKTOP:-}" != *"gnome"* ]] &&
   [[ "${DESKTOP_SESSION:-}" != *"gnome"* ]]; then

    echo "ERROR: GNOME was not detected."
    echo
    echo "This installer is for the GNOME frontend."
    exit 1
fi

echo "[OK] GNOME detected."

# ------------------------------------------------------------
# Check gnome-extensions
# ------------------------------------------------------------

if ! command -v gnome-extensions >/dev/null 2>&1; then
    echo
    echo "ERROR: gnome-extensions was not found."
    echo
    echo "Please install the GNOME Shell Extensions tools"
    echo "using your distribution's package manager."
    exit 1
fi

echo "[OK] gnome-extensions found."

# ------------------------------------------------------------
# Check asusctl
# ------------------------------------------------------------

if ! command -v asusctl >/dev/null 2>&1; then
    echo
    echo "ERROR: asusctl was not found."
    echo
    echo "ASUS GPU Switcher requires asusctl/asusd."
    echo "Install ASUS Linux support for your distribution first."
    exit 1
fi

echo "[OK] asusctl found."

# ------------------------------------------------------------
# Check ASUS Armoury
# ------------------------------------------------------------

if ! asusctl armoury list >/dev/null 2>&1; then
    echo
    echo "ERROR: ASUS Armoury controls are not available."
    echo
    echo "Your system may not have the required ASUS"
    echo "driver/asusd support for GPU switching."
    exit 1
fi

echo "[OK] ASUS Armoury controls available."

# ------------------------------------------------------------
# Check required GPU controls
# ------------------------------------------------------------

ARMOURY_OUTPUT="$(asusctl armoury list 2>/dev/null || true)"

if ! grep -q "dgpu_disable" <<< "$ARMOURY_OUTPUT"; then
    echo
    echo "ERROR: GPU control 'dgpu_disable' was not found."
    echo
    echo "Your ASUS laptop may not support the GPU switching"
    echo "interface required by this extension."
    exit 1
fi

if ! grep -q "gpu_mux_mode" <<< "$ARMOURY_OUTPUT"; then
    echo
    echo "ERROR: GPU control 'gpu_mux_mode' was not found."
    echo
    echo "Your ASUS laptop may not support the GPU MUX"
    echo "interface required by this extension."
    exit 1
fi

echo "[OK] GPU switching controls detected."

# ------------------------------------------------------------
# Check curl
# ------------------------------------------------------------

if ! command -v curl >/dev/null 2>&1; then
    echo
    echo "ERROR: curl was not found."
    echo
    echo "Please install curl using your distribution's"
    echo "package manager."
    exit 1
fi

echo "[OK] curl found."

# ------------------------------------------------------------
# Create temporary directory
# ------------------------------------------------------------

TEMP_DIR="$(mktemp -d)"
ZIP_FILE="${TEMP_DIR}/${ZIP_NAME}"

cleanup() {
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

# ------------------------------------------------------------
# Download latest release
# ------------------------------------------------------------

echo
echo "Downloading ASUS GPU Switcher..."
echo

curl -fL --progress-bar "$DOWNLOAD_URL" -o "$ZIP_FILE"

echo
echo "[OK] Download complete."

# ------------------------------------------------------------
# Install extension
# ------------------------------------------------------------

echo
echo "Installing GNOME extension..."

gnome-extensions install --force "$ZIP_FILE"

echo "[OK] Extension installed."

# ------------------------------------------------------------
# Enable extension
# ------------------------------------------------------------

echo
echo "Enabling extension..."

if gnome-extensions enable "$UUID" >/dev/null 2>&1; then
    echo "[OK] Extension enabled."
else
    echo
    echo "WARNING: GNOME could not enable the extension"
    echo "in the current session."
    echo
    echo "Log out and log back in, then run:"
    echo
    echo "    gnome-extensions enable $UUID"
fi

# ------------------------------------------------------------
# Finished
# ------------------------------------------------------------

echo
echo "=========================================="
echo "       Installation complete!"
echo "=========================================="
echo
echo "ASUS GPU Switcher has been installed."
echo
echo "If it does not appear in GNOME Quick Settings,"
echo "log out and log back in."
echo
echo "Check status:"
echo "    gnome-extensions info $UUID"
echo
echo "Disable:"
echo "    gnome-extensions disable $UUID"
echo
echo "Uninstall:"
echo "    gnome-extensions uninstall $UUID"
echo