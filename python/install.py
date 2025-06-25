#!/usr/bin/env python3
import platform
import subprocess
import urllib.request

LOCAL_VERSION = "0.3.4"  # 本地固定版本號
REMOTE_VERSION_URL = "https://raw.githubusercontent.com/xStrikea/delux/main/python/version.txt"

def read_remote_version():
    try:
        with urllib.request.urlopen(REMOTE_VERSION_URL) as response:
            return response.read().decode("utf-8").strip()
    except Exception as e:
        print(f"⚠️ Could not fetch remote version: {e}")
        return None

def run_delux():
    try:
        print("🚀 Running Delux File Manager...\n")
        subprocess.run(["python3", "delux_windows.py"], check=True)
    except Exception as e:
        print(f"❌ Error running Delux: {e}")

def main():
    print("=" * 40)
    print("🧾 Delux Terminal File Manager Installer")
    print("=" * 40)

    print(f"📦 Local Version : {LOCAL_VERSION}")

    remote_version = read_remote_version()
    if remote_version:
        print(f"🌐 Remote Version: {remote_version}")
        if LOCAL_VERSION != remote_version:
            print(f"\n🔔 New version available: {remote_version}")
            print("👉 Please update manually from GitHub:")
            print("   https://github.com/xStrikea/delux")
        else:
            print("\n✅ You are using the latest version.")
    else:
        print("\n⚠️ Cannot fetch remote version info.")

    print("\n🖥️ Platform detected:", platform.system())
    print("🔧 Initializing Delux...\n")

    run_delux()

if __name__ == "__main__":
    main()