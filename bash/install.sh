#!/usr/bin/env bash

DEFAULT_LOCAL_VERSION="0.3.3"
LOCAL_VERSION_FILE=".delux_version"
INIT_FLAG=".delux_init_done"

# 讀取本地版本
read_local_version() {
  if [[ -f "$LOCAL_VERSION_FILE" ]]; then
    cat "$LOCAL_VERSION_FILE" | tr -d '\r\n %'
  else
    echo "$DEFAULT_LOCAL_VERSION"
  fi
}

# 初始化畫面（只跑一次）
init_loading() {
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
    cd "$(dirname "$0")" || exit 1

    echo "70"; echo "Preparing Delux..."
    sleep 1

    echo "100"; echo "Initialization complete."
    sleep 1
  } | dialog --title "Delux Installer - Version $(read_local_version)" --gauge "Initializing, please wait..." 10 60 0

  touch "$INIT_FLAG"
}

# 選擇平台並執行對應腳本
choose_platform() {
  local version=$(read_local_version)
  OPTIONS=(
    1 "macOS"
    2 "Linux"
    3 "Termux (Android)"
    4 "SSH (Remote Login)"
  )

  CHOICE=$(dialog --clear \
    --title "Delux Installer - Version $version" \
    --menu "Choose your platform:" 14 60 6 \
    "${OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

  clear

  case "$CHOICE" in
    1) SCRIPT="./delux_mac.sh" ;;
    2) SCRIPT="./delux_linux.sh" ;;
    3) SCRIPT="./delux_termux.sh" ;;
    4) SCRIPT="./delux_ssh.sh" ;;
    *) echo "❌ Invalid selection."; exit 1 ;;
  esac

  if [[ ! -f "$SCRIPT" ]]; then
    echo "❌ File not found: $SCRIPT"
    exit 1
  fi

  chmod +x "$SCRIPT"
  echo "🚀 Running $SCRIPT..."
  "$SCRIPT"
}

cd "$(dirname "$0")"

# 只在第一次執行時初始化
if [[ ! -f "$INIT_FLAG" ]]; then
  init_loading
fi

choose_platform