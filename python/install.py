#!/usr/bin/env python3
import subprocess
import os

VERSION = "0.3.4"

def run_script(choice):
    scripts = {
        "1": ["python3", "delux/python/delux_win.py"],
        "2": ["python3", "delux/python/dev/delux_dev.py"]
    }

    if choice in scripts:
        cmd = scripts[choice]
        subprocess.run([cmd[0], cmd[1]])
    else:
        print("❌ Invalid selection.")

def main():
    print("=== Delux Installer ===")
    print(f"Version: {VERSION}")
    print("\n1. Windows")
    print("\n2. Developer Mode (Python)")

    choice = input("\nSelect a number: ")
    run_script(choice)

if __name__ == "__main__":
    main()