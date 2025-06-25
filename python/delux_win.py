import os import sys import shutil import subprocess

VERSION = "0.3.4" AUTHOR = "xStrikea" LICENSE = "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"

START_PATH = os.path.expanduser("~")

def clear(): os.system('cls' if os.name == 'nt' else 'clear')

def list_dir(path): try: entries = os.listdir(path) entries.sort() return entries except Exception as e: print(f"Error: {e}") return []

def display_menu(current_path, entries): clear() print(f"Delux File Manager v{VERSION} - {AUTHOR}") print(f"Current Directory: {current_path}\n") print("0. .. (go back)") print("i. Info") for i, entry in enumerate(entries, 1): print(f"{i}. {entry}")

def show_info(): clear() print(f"Delux - Terminal File Manager\n") print(f"Version: {VERSION}") print(f"Author: {AUTHOR}") print(f"License: {LICENSE}\n") input("Press Enter to return...")

def handle_file(path): while True: print(f"\nSelected: {os.path.basename(path)}") print("1. View") print("2. Rename") print("3. Delete") print("4. Execute (if script)") print("0. Cancel") choice = input("> ")

if choice == "1":
        os.system(f"notepad {path}" if os.name == 'nt' else f"cat '{path}'")
    elif choice == "2":
        new_name = input("New name: ")
        os.rename(path, os.path.join(os.path.dirname(path), new_name))
        break
    elif choice == "3":
        confirm = input("Confirm delete? (y/n): ")
        if confirm.lower() == 'y':
            os.remove(path)
        break
    elif choice == "4":
        if path.endswith(".py"):
            subprocess.call(["python", path])
        elif path.endswith(".bat"):
            os.system(path)
        else:
            print("Not an executable script.")
    elif choice == "0":
        break

def main(): current_path = START_PATH

while True:
    entries = list_dir(current_path)
    display_menu(current_path, entries)

    choice = input("\nSelect: ").strip()

    if choice == "0":
        current_path = os.path.dirname(current_path)
    elif choice == "i":
        show_info()
    elif choice.isdigit():
        idx = int(choice) - 1
        if 0 <= idx < len(entries):
            selected = entries[idx]
            full_path = os.path.join(current_path, selected)
            if os.path.isdir(full_path):
                current_path = full_path
            else:
                handle_file(full_path)
    else:
        print("Invalid choice. Try again.")
        input("Press Enter...")

if name == "main": main()

  