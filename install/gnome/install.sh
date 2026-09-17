#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# ASUS GPU Switcher
# GNOME Installer
# ============================================================

REPO="kurapikanlight/asus-gpu-switcher"
UUID="asus-gpu-switcher@kafeyn_"
TAR_URL="https://github.com/${REPO}/archive/refs/heads/main.tar.gz"
EXT_DIR="${HOME}/.local/share/gnome-shell/extensions/${UUID}"

echo
echo "=========================================="
echo "       ASUS GPU Switcher - GNOME"
echo "=========================================="
echo

# ------------------------------------------------------------
# System Checks
# ------------------------------------------------------------

if [[ "${XDG_CURRENT_DESKTOP:-}" != *"GNOME"* ]] && \
   [[ "${XDG_SESSION_DESKTOP:-}" != *"gnome"* ]] && \
   [[ "${DESKTOP_SESSION:-}" != *"gnome"* ]]; then
    echo "ERROR: GNOME was not detected."
    exit 1
fi

if ! command -v gnome-extensions >/dev/null 2>&1; then
    echo "ERROR: gnome-extensions command not found."
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
# Download & Install Extension
# ------------------------------------------------------------

TEMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

echo "Downloading latest version from GitHub..."
curl -sSL "$TAR_URL" | tar -xz -C "$TEMP_DIR"

# Only the src/gnome-extension folder is used 
EXT_SRC="${TEMP_DIR}/asus-gpu-switcher-main/src/gnome-extension"

if [[ ! -d "$EXT_SRC" ]]; then
    echo "ERROR: GNOME extension source not found in downloaded archive."
    exit 1
fi

echo "Installing extension to ${EXT_DIR}..."
mkdir -p "$EXT_DIR"
cp -r "$EXT_SRC"/* "$EXT_DIR"/

echo "[OK] Files installed."

# ------------------------------------------------------------
# Enable Extension
# ------------------------------------------------------------

echo "Enabling GNOME extension..."
if gnome-extensions enable "$UUID" >/dev/null 2>&1; then
    echo "[OK] Extension enabled successfully!"
else
    echo "WARNING: Could not enable extension in active session."
    echo "Please log out and log back in, then run:"
    echo "    gnome-extensions enable $UUID"
fi

echo
echo "=========================================="
echo "       Installation Complete!"
echo "=========================================="
