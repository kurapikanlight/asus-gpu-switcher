# ASUS GPU Switcher for GNOME

<p align="center">
  <b>A lightweight GNOME Shell GPU switcher for ASUS gaming laptops</b><br>
  Switch between Integrated, Hybrid, and NVIDIA graphics modes directly from GNOME Quick Settings.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/GNOME-45--50-4A86CF?logo=gnome&logoColor=white" alt="GNOME 45-50">
  <img src="https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black" alt="Linux">
  <img src="https://img.shields.io/badge/ASUS-Laptops-000000?logo=asus&logoColor=white" alt="ASUS">
  <img src="https://img.shields.io/github/license/kurapikanlight/asus-gpu-switcher" alt="License">
</p>

---

## ✨ Why this project?

GPU switching on ASUS gaming laptops under Linux can be unnecessarily complicated.

The ASUS Linux ecosystem has historically provided tools such as **supergfxctl** for graphics-mode switching. While useful, supergfxctl has had compatibility and switching issues on some hardware and software configurations. Its upstream project is archived, and the ASUS Linux documentation describes it as deprecated/phasing out.

This project provides a simpler GNOME experience for switching GPU modes directly from the desktop.

---

## 🎯 What does it do?

**ASUS GPU Switcher** adds GPU controls directly to **GNOME Quick Settings**.

Depending on your ASUS laptop, it can provide:

- 🟢 **Integrated** — use the integrated GPU.
- 🔵 **Hybrid** — use the integrated GPU normally while allowing applications to use the NVIDIA GPU.
- 🟠 **NVIDIA** — use the NVIDIA GPU as the primary graphics device.

**A reboot is required when switching GPU modes** so that the new graphics configuration can be applied correctly.

---

## 👥 Who is this for?

**ASUS gaming laptops (ROG, TUF, etc.) running Linux with GNOME.**

---

## 📦 Installation

There are two ways to install ASUS GPU Switcher.

### Method 1 — Install with `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/kurapikanlight/asus-gpu-switcher/main/install/gnome/install.sh | bash
```

Then enable the extension:

```bash
gnome-extensions enable asus-gpu-switcher@kurapikanlight
```

Log out and back in if GNOME does not immediately show the extension.

---

### Method 2 — Clone the repository manually

```bash
git clone https://github.com/kurapikanlight/asus-gpu-switcher.git
cd asus-gpu-switcher
```

Install `unzip` if needed.

#### Fedora

```bash
sudo dnf install unzip
```

Run the installer:

```bash
chmod +x install/gnome/install.sh
./install/gnome/install.sh
```

Enable the extension:

```bash
gnome-extensions enable asus-gpu-switcher@kurapikanlight
```

---

## 🟢 Enabling the extension

After installation:

```bash
gnome-extensions enable asus-gpu-switcher@kurapikanlight
```

Or:

1. Open **Extensions**
2. Find **ASUS GPU Switcher**
3. Enable it
4. Open **GNOME Quick Settings**
5. Use the GPU switcher

The extension supports GNOME Shell versions **45, 46, 47, 48, 49 and 50**.

---

## 🔧 Requirements

The project requires a supported ASUS gaming laptop with the appropriate ASUS Linux GPU-control functionality, including `asusctl` where required.

GPU switching depends on the laptop's firmware, drivers, kernel, and hardware configuration.

**Rebooting after changing the GPU mode is required.**

---

## 🧪 Project status

- [x] GNOME implementation
- [x] GNOME Quick Settings integration
- [x] Installation script
- [ ] GNOME Extensions official listing
- [ ] KDE Plasma implementation

---

## 🧩 GNOME Extensions listing

The extension is currently being reviewed by **GNOME Extensions**.

Once it passes the review process, the official GNOME Extensions page will be linked here.

> **Official GNOME Extensions page:** Coming soon

Until then, GitHub is the official distribution method.

---

## 🤝 Contributing

Contributions, testing, bug reports, and ideas are welcome.

You can help by:

- 🐛 Reporting issues
- 🧪 Testing on different ASUS gaming laptops
- 💡 Suggesting features
- 🔧 Submitting fixes
- 📖 Improving documentation

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

- ⭐ Star the repository
- 🧪 Test it on your ASUS gaming laptop
- 🐛 Report problems
- 💡 Contribute improvements

---

<p align="center">
  <b>ASUS GPU Switcher</b><br>
  Simple GPU switching for ASUS gaming laptops on Linux with GNOME.
</p>
