#!/usr/bin/env bash

cd "$(dirname "$0")"

INIT_FLAG=".delux_init_done"
LOCAL_VERSION_FILE=".delux_version"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"
DEFAULT_LOCAL_VERSION="0.3.5"

# 讀取版本
function read_local_version() {
  if [[ -f "$LOCAL_VERSION_FILE" ]]; then
    cat "$LOCAL_VERSION_FILE" | tr -d '\r\n %'
  else
    echo "$DEFAULT_LOCAL_VERSION"
  fi
}

# 初始化畫面
function init_loading() {
  {
    echo "10"; echo "Checking dialog..."
    sleep 1

    if ! command -v dialog &> /dev/null; then
      echo "100"; echo "Dialog not installed. Please install it."
      sleep 2
      clear
      echo "❌ 'dialog' is not installed. Please install it first."
      exit 1
    fi

    echo "40"; echo "Setting up..."
    sleep 1

    echo "70"; echo "Preparing Delux..."
    sleep 1

    echo "100"; echo "Initialization complete."
    sleep 1
  } | dialog --title "Delux Installer" --gauge "Initializing, please wait..." 10 60 0

  touch "$INIT_FLAG"
}

# 執行腳本
function run_script() {
  chmod +x "$1"
  clear
  echo "🚀 Running $1..."
  "$1"
}

# 執行 Python 腳本
function run_python() {
  clear
  echo "🚀 Running Python Dev version..."
  python3 "$1"
}

# === 執行 ===

[[ ! -f "$INIT_FLAG" ]] && init_loading

LOCAL_VERSION=$(read_local_version)

while true; do
  CHOICE=$(dialog --clear \
    --title "Delux Installer v$LOCAL_VERSION" \
    --menu "Choose your platform or developer tool:" 18 60 10 \
    1 "macOS" \
    2 "Linux" \
    3 "Termux (Android)" \
    4 "SSH (Remote Login)" \
    5 "Developer (SH)" \
    6 "Exit" \
    3>&1 1>&2 2>&3)

  case "$CHOICE" in
    1) run_script "delux_mac.sh"; break ;;
    2) run_script "delux_linux.sh"; break ;;
    3) run_script "delux_termux.sh"; break ;;
    4) run_script "delux_ssh.sh"; break ;;
    5) run_script "delux_dev.sh"; break ;;
    6|*) clear; echo "Goodbye!"; exit 0 ;;
  esac
done