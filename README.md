# 🧰 LeanBox — Lightweight Linux Development Optimizer

LeanBox is a **dark-themed Tauri-based GUI tool** designed to make your Ubuntu/Debian system faster, cleaner, and more performance-tuned for **software development**. With one click, it disables unnecessary background services and cleans up startup programs that eat up resources.

> 💡 Ideal for developers who want a lightweight and distraction-free environment to code, compile, and create at maximum speed.

---

## ⚙️ Features

- 📉 Disable bloated background services like `snapd`, `bluetooth`, `cups`, and more
- 🔇 Clean autostart apps from `$HOME/.config/autostart`
- 📁 Backup disabled `.desktop` entries automatically
- 💻 Terminal-style feedback in a slick dark GUI
- 🐧 Optimized for Ubuntu/Debian systems
- 🔒 Fully local and secure — no telemetry or network dependencies

---

## 🚀 Getting Started

### 🧱 Prerequisites

- Ubuntu 20.04+ / Debian 11+
- Rust (`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`)
- Node.js & npm
- Tauri dependencies: `libwebkit2gtk`, `build-essential`, `curl`, `pkg-config`, `libssl-dev`, etc.

```bash
# Ubuntu Example:
sudo apt install libwebkit2gtk-4.0-dev build-essential curl wget libssl-dev libgtk-3-dev
📦 Installation (Dev Mode)
bash
Copy
Edit
git clone https://github.com/YOUR_USERNAME/LeanBox.git
cd LeanBox

# Make shell script executable
chmod +x src-tauri/dev_optimize.sh

# Install and run
npm install
npm run tauri dev
🧠 How It Works
Under the hood, LeanBox runs dev_optimize.sh, a shell script that disables selected services via systemctl and moves .desktop autostarts to a backup folder. It's non-destructive and reversible.

Default Services Disabled
bash
Copy
Edit
bluetooth.service
cups.service
avahi-daemon.service
snapd.service
ModemManager.service
ufw.service  # optional — skip if you're not behind a firewall
You can customize this list in dev_optimize.sh.

🧑‍💻 Developer Notes
Frontend (Tauri + Vanilla JS/HTML)
Built with Tauri for secure, native desktop experience.

Simple JS frontend invokes the backend Rust command via @tauri-apps/api.

Backend (Rust)
The script is invoked using std::process::Command.

Output is streamed back to the frontend terminal window.

🌱 Contributing
We welcome contributions! Here’s how to get started:

🔧 Feature Ideas
 Add toggle UI for choosing services to disable

 Add CPU/GPU/RAM monitor widget

 Include GNOME/KDE-specific tweaks

 Restore previously disabled services

 Profile disk I/O or network usage of background processes

📬 Pull Requests
Fork the repo

Create a feature branch: git checkout -b feat/custom-toggles

Commit changes and push: git push origin feat/custom-toggles

Open a PR with clear description and screenshots if needed

📄 License
MIT License. See LICENSE for more details.

✨ Screenshots
Coming soon...

📫 Contact
Maintainer: @Roy Msoli
GitHub: MsoliRoy
