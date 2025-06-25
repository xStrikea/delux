# install.py (Windows)

import os import subprocess

OPTIONS = { "1": ("Launch Delux File Manager", "delux_windows.py"), "2": ("Developer Tool (delux_dev)", "dev/delux_dev.py"), "3": ("Exit", None) }

def display_menu(): print("\n===== Delux Installer (Windows) =====") for key, (desc, _) in OPTIONS.items(): print(f"{key}. {desc}")

while True: display_menu() choice = input("Select an option: ").strip() if choice in OPTIONS: _, script_path = OPTIONS[choice] if script_path: full_path = os.path.join("python", script_path) if os.path.isfile(full_path): print(f"\nLaunching {full_path}...\n") subprocess.run(["python", full_path]) else: print(f"❌ File not found: {full_path}") else: print("Exiting.") break else: print("Invalid option. Try again.")

