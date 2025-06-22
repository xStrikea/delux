#!/usr/bin/env bash

DEFAULT_LOCAL_VERSION="0.3.2"
LOCAL_VERSION_FILE=".delux_version"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"
INIT_FLAG=".delux_init_done"

# 讀本地版本
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
    cd "$(dirname "$0")" || exit 1

    echo "70"; echo "Preparing Delux..."
    sleep 1

    echo "100"; echo "Initialization complete."
    sleep 1
  } | dialog --title "Delux Installer" --gauge "Initializing, please wait..." 10 60 0

  touch "$INIT_FLAG"
}

# 檢查更新
function check_update() {
  LOCAL_VERSION=$(read_local_version)
  UPDATE_AVAILABLE=0
  UPDATE_MSG=""

  if command -v curl &> /dev/null; then
    REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r\n %')
    if [[ -n "$REMOTE_VERSION" && "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
      UPDATE_MSG="🔔 New version available: $REMOTE_VERSION"
      UPDATE_AVAILABLE=1
    fi
  fi
}

# 更新
function update_now() {
  echo "🚀 Updating Delux..."

  rm -rf delux/bash
  git clone --depth 1 https://github.com/xStrikea/delux.git

  if [[ -d "delux/bash" ]]; then
    echo "✅ Clone completed."
    if command -v curl &> /dev/null; then
      REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r\n %')
      if [[ -n "$REMOTE_VERSION" ]]; then
        echo "$REMOTE_VERSION" > "$LOCAL_VERSION_FILE"
        echo "📦 Updated to version: $REMOTE_VERSION"
      fi
    fi
    dialog --msgbox "✅ Updated to version $REMOTE_VERSION.\nYou may now select your platform again." 8 50
  else
    dialog --msgbox "❌ Failed to clone repository. Update aborted." 8 50
    exit 1
  fi
}

# 顯示 info（作者、版本、GNU GPL 授權）
function show_info() {
  local local_version
  local_version=$(read_local_version)

  dialog --backtitle "Delux Info" --title "About Delux Terminal File Manager" --msgbox "
🧾 Delux Terminal File Manager
Author: xStrikea
Version: $local_version

License: GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

© 2007 Free Software Foundation, Inc.

You are permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.

For full license text, see:
https://www.gnu.org/licenses/gpl-3.0.en.html
" 18 70
}

cd "$(dirname "$0")"
[[ ! -f "$INIT_FLAG" ]] && init_loading

while true; do
  check_update

  OPTIONS=(
    0 "Info"
    1 "macOS"
    2 "Linux"
    3 "Termux (Android)"
    4 "SSH (Remote Login)"
  )

  if [[ $UPDATE_AVAILABLE -eq 1 ]]; then
    OPTIONS+=(5 "Update to $REMOTE_VERSION")
  fi

  CHOICE=$(dialog --clear \
    --title "Delux Installer" \
    --menu "${UPDATE_MSG}\nChoose your platform:" 16 70 7 \
    "${OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

  clear

  case "$CHOICE" in
    0) show_info; continue ;;
    1) SCRIPT="./delux_mac.sh" ;;
    2) SCRIPT="./delux_linux.sh" ;;
    3) SCRIPT="./delux_termux.sh" ;;
    4) SCRIPT="./delux_ssh.sh" ;;
    5) update_now; continue ;;
    *) echo "❌ Invalid selection."; exit 1 ;;
  esac

  if [[ ! -f "$SCRIPT" ]]; then
    echo "❌ File not found: $SCRIPT"
    exit 1
  fi

  chmod +x "$SCRIPT"
  echo "🚀 Running $SCRIPT..."
  "$SCRIPT"
  break
done