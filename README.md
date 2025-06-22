<p align="center">
  <img src="image/logo.png" alt="logo"/>
</p>

# 🧾 Delux Terminal File Manager

**Delux** is a lightweight, terminal-based file manager that runs on `dialog`.  
It supports interactive folder navigation, file operations, and script execution – all within a simple TUI (text user interface).

---

## ✅ Features

- 📁 Navigate folders (with hidden files support)
- 📝 Edit, delete, or rename any file
- 🖼️ Media files: delete or rename
- 🧨 Executables: confirm before deleting
- 🐚 `.sh` shell scripts: auto `chmod +x` + execute on `Open`
- 🔙 Return to parent folder with `Go back`

---

## 💻 Supported OS

| OS         | Supported | Notes                                                                 |
|------------|-----------|-----------------------------------------------------------------------|
| 🐧 Linux    | ✅         | Debian/Ubuntu/Fedora/Arch (Kernel 4.15+ recommended)                 |
| 🍎 macOS    | ✅         | macOS 10.13 High Sierra and above (requires [Homebrew](https://brew.sh/)) |
| 📱 Termux   | ✅         | Android 7.0 (Nougat) and above using Termux (v0.118+)               |

---

## 📦 Installation

### 1. Install Dependencies

#### Linux (Debian/Ubuntu)
```bash
sudo apt install dialog
```
macOS (via Homebrew)
```bash
brew install dialog
```
Termux
```bash
pkg install dialog
```

---

⚙️ Clone and Run

Linux
```bash
git clone https://github.com/xStrikea/delux.git
cd delux/bash
chmod +x install.sh
./install.sh
```
macOS
```bash
git clone https://github.com/xStrikea/delux.git
cd delux/bash
chmod +x install.sh
./install.sh
```
Termux
```bash
git clone https://github.com/xStrikea/delux.git
cd delux/bash
chmod +x install.sh
./install.sh
```
<p align="center">
V0.2ᴮᵉᵗᵃ
</p>