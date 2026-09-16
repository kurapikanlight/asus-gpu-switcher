# ASUS GPU Switcher for GNOME and KDE

<p align="center">
  <b>A lightweight GPU switcher for ASUS gaming laptops</b><br>
  Switch between Integrated, Hybrid, and NVIDIA graphics modes directly from your desktop — GNOME Quick Settings or your KDE Plasma panel.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/GNOME-45--50-4A86CF?logo=gnome&logoColor=white" alt="GNOME 45-50">
  <img src="https://img.shields.io/badge/KDE-Plasma%206-1D99F3?logo=kde&logoColor=white" alt="KDE Plasma 6">
  <img src="https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black" alt="Linux">
  <img src="https://img.shields.io/badge/ASUS-Laptops-000000?logo=asus&logoColor=white" alt="ASUS">
  <img src="https://img.shields.io/github/license/kurapikanlight/asus-gpu-switcher" alt="License">
</p>

---

## ✨ Why this project?

GPU switching on ASUS gaming laptops under Linux can be unnecessarily complicated.

The ASUS Linux ecosystem has historically provided tools such as **supergfxctl** for graphics-mode switching. While useful, supergfxctl has had compatibility and switching issues on some hardware and software configurations. Its upstream project is archived, and the ASUS Linux documentation describes it as deprecated/phasing out.

This project provides a simpler desktop experience for switching GPU modes — on both **GNOME** and **KDE Plasma** — directly from the desktop.

---

## 🎯 What does it do?

**ASUS GPU Switcher** adds GPU controls directly to your desktop:

* On **GNOME**, it lives in **GNOME Quick Settings**.
* On **KDE Plasma**, it's a **plasmoid** you can add to your panel or system tray.

Depending on your ASUS laptop, it can provide:

* 🟢 **Integrated** — use the integrated GPU.
* 🔵 **Hybrid** — use the integrated GPU normally while allowing applications to use the NVIDIA GPU.
* 🟠 **NVIDIA** — use the NVIDIA GPU as the primary graphics device.

> **A reboot is required when switching GPU modes** so that the new graphics configuration can be applied correctly.

---

## 👥 Who is this for?

**ASUS gaming laptops (ROG, TUF, etc.) running Linux with GNOME or KDE Plasma.**

---

## 📦 Installation

Pick the section for your desktop environment below.

### 🟣 GNOME

#### Method 1 — Install with `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/kurapikanlight/asus-gpu-switcher/main/install/gnome/install.sh | bash
```

This only installs the GNOME extension files (`src/gnome-extension`) — nothing KDE-related is installed.

Then enable the extension:

```bash
gnome-extensions enable asus-gpu-switcher@kurapikanlight
```

Log out and back in if GNOME does not immediately show the extension.

#### Method 2 — Manual download

Download the repository:

```bash
curl -L -o asus-gpu-switcher.zip https://github.com/kurapikanlight/asus-gpu-switcher/archive/refs/heads/main.zip
unzip asus-gpu-switcher.zip
cd asus-gpu-switcher-main
```

If you'd rather use `git clone` instead:

```bash
git clone https://github.com/kurapikanlight/asus-gpu-switcher.git
cd asus-gpu-switcher
```

Remove the KDE-only files:

```bash
rm -rf src/kde install/kde
```

Install the GNOME extension:

```bash
mkdir -p ~/.local/share/gnome-shell/extensions/asus-gpu-switcher@kurapikanlight

cp -r src/gnome-extension/* \
  ~/.local/share/gnome-shell/extensions/asus-gpu-switcher@kurapikanlight/
```

Enable the extension:

```bash
gnome-extensions enable asus-gpu-switcher@kurapikanlight
```

---

### 🔵 KDE Plasma

#### Method 1 — Install with `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/kurapikanlight/asus-gpu-switcher/main/install/kde/install.sh | bash
```

#### Method 2 — Manual download, keeping only the KDE files

Download the repository:

```bash
curl -L -o asus-gpu-switcher.zip https://github.com/kurapikanlight/asus-gpu-switcher/archive/refs/heads/main.zip
unzip asus-gpu-switcher.zip
cd asus-gpu-switcher-main
```

Remove the GNOME-only files:

```bash
rm -rf src/gnome-extension install/gnome
```

If you'd rather use `git clone` instead:

```bash
git clone https://github.com/kurapikanlight/asus-gpu-switcher.git
cd asus-gpu-switcher
```

Install the plasmoid:

```bash
kpackagetool6 --type Plasma/Applet --install src/kde
```

#### 📌 Making it visible on your panel

Unlike GNOME, KDE Plasma doesn't have a single command to "enable" a widget. Installing it makes it available to Plasma, similar to installing an application.

To add it to your panel:

1. Right-click an empty area of your panel.
2. Choose **Add Widgets...**
3. Search for **ASUS GPU Switcher**.
4. Drag it onto your panel.

This is a one-time step. Plasma remembers the widget across reboots and logins.

---

## 🔧 Requirements

The project requires a supported ASUS gaming laptop with the appropriate ASUS Linux GPU-control functionality, including `asusctl` where required.

* **GNOME:** GNOME Shell versions **45, 46, 47, 48, 49, and 50**
* **KDE Plasma:** **Plasma 6**, with `kpackagetool6` available
* A supported ASUS gaming laptop with compatible firmware and GPU hardware
* Appropriate NVIDIA/AMD graphics drivers

GPU switching depends on the laptop's firmware, drivers, kernel, and hardware configuration.

> **Rebooting after changing the GPU mode is required.**

---

## 🧪 Project status

* [x] GNOME implementation
* [x] KDE Plasma implementation
* [ ] Exploring support for other desktop environments / GUIs

---

## 🧩 Official listings

The GNOME extension is currently being reviewed by **GNOME Extensions**.

Once it passes the review process, the official GNOME Extensions page will be linked here.

> **Official GNOME Extensions page:** Coming soon

Until then, GitHub is the official distribution method for both GNOME and KDE.

---

## 🤝 Contributing

Contributions, testing, bug reports, and ideas are welcome.

You can help by:

* 🐛 Reporting issues
* 🧪 Testing on different ASUS gaming laptops
* 💡 Suggesting features
* 🔧 Submitting fixes
* 📖 Improving documentation

---

## 📬 Contact

**Developer:** kurapikanlight

**GitHub:**
https://github.com/kurapikanlight

**Project:**
https://github.com/kurapikanlight/asus-gpu-switcher

For code contributions, open a **Pull Request**.

---

## 📜 License

See the repository license for the terms under which this project is distributed.

---

## ⭐ Support the project

If ASUS GPU Switcher is useful to you:

* ⭐ Star the repository
* 🧪 Test it on your ASUS gaming laptop (GNOME or KDE)
* 🐛 Report problems
* 💡 Contribute improvements

---

<p align="center">
  <b>ASUS GPU Switcher</b><br>
  Simple GPU switching for ASUS gaming laptops on Linux with GNOME or KDE Plasma.
</p>
