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
- 🖧 **SSH Mode**: Lightweight CLI support for remote terminal access

---

## 💻 Supported OS

| OS         | Supported | Notes                                                                 |
|------------|-----------|-----------------------------------------------------------------------|
| 🐧 Linux    | ✅         | Debian/Ubuntu/Fedora/Arch (Kernel 4.15+ recommended)                 |
| 🍎 macOS    | ✅         | macOS 10.13 High Sierra and above (requires [Homebrew](https://brew.sh/)) |
| 📱 Termux   | ✅         | Android 7.0 (Nougat) and above using Termux (v0.118+)               |
| 🔐 SSH      | ✅         | Compatible with any Linux-based SSH terminal                        |
| 🪟 Windows  | ✅         | Python 3.x required; run `install.py` for setup and launch         |

---

## 📦 Installation

### 1. Install Dependencies

#### Linux (Debian/Ubuntu)
```
sudo apt install dialog git
```
macOS (via Homebrew)
```
brew install dialog git
```
Termux
```
pkg install dialog git
```
Windows
```
# Install Python 3.x from https://www.python.org/downloads/
```

---

⚙️ Clone and Run

Linux/macOS/Termux/SSH
```
git clone https://github.com/xStrikea/delux.git
cd delux/bash
chmod +x install.sh
./install.sh
```
Windows
```
git clone https://github.com/xStrikea/delux.git
cd delux/python
python install.py
```
> ℹ️ After first run, install.sh / install.py remembers the initialization and skips it on next run.
You can delete .delux_init_done to re-run the intro.
🔧 A bug was found and the title version was not updated after the update. (Fixed!)




---

🔄 Accidental exit

Execute the following command.

Linux/macOS/Termux/SSH
```
cd
cd delux/bash
chmod +x install.sh
./install.sh

Windows (PowerShell or CMD)

cd %USERPROFILE%\delux
python install.py
```

---

⬆️ Update

Execute the following command.

Linux/macOS/Termux/SSH
```
cd
rm -rf delux
git clone https://github.com/xStrikea/delux.git
cd delux/bash
chmod +x install.sh
./install.sh
```
Windows
```
cd %USERPROFILE%
rm -r delux
git clone https://github.com/xStrikea/delux.git
cd delux/python
python install.py

```
---

🧠 Notes

Designed for bash on Linux/macOS/Termux/SSH with no Python or GUI (x11 or VNC) dependency required.

Windows uses Python 3.x for installation and running.

SSH mode provides a simplified CLI for remote server use.

All platform scripts are in /bash or /python:

delux_linux.sh

delux_mac.sh

delux_termux.sh

delux_ssh.sh

delux_win.sh



---

<p align="center">
Minimum version Bash 3.0 (Linux/macOS/Termux/SSH)  
Python 3.x for Windows
</p>