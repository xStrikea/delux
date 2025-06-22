#!/usr/bin/env bash

INIT_FLAG=".delux_init_done"
LOCAL_VERSION_FILE=".delux_version"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"
DEFAULT_LOCAL_VERSION="0.3.2"
AUTHOR="xSpecter"

# 讀取本地版本
function read_local_version() {
  if [[ -f "$LOCAL_VERSION_FILE" ]]; then
    cat "$LOCAL_VERSION_FILE" | tr -d '\r\n %'
  else
    echo "$DEFAULT_LOCAL_VERSION"
  fi
}

# 顯示 Info 頁面
function show_info() {
  local version
  version=$(read_local_version)
  local info_text="Author: $AUTHOR
Version: $version

License: GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

$(cat ./LICENSE.txt)"

  local tmpfile
  tmpfile=$(mktemp)
  echo "$info_text" > "$tmpfile"
  dialog --title "Delux Info and License" --textbox "$tmpfile" 40 90
  rm -f "$tmpfile"
}

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

function check_update() {
  local local_version
  local_version=$(read_local_version)
  UPDATE_AVAILABLE=0
  UPDATE_MSG=""

  if command -v curl &> /dev/null; then
    local remote_version
    remote_version=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r\n %')
    if [[ -n "$remote_version" && "$remote_version" != "$local_version" ]]; then
      UPDATE_MSG="🔔 New version available: $remote_version"
      UPDATE_AVAILABLE=1
    fi
  fi
}

function update_now() {
  if [[ ! -f ./delux_update.sh ]]; then
    echo "❌ delux_update.sh not found!"
    exit 1
  fi

  chmod +x ./delux_update.sh
  ./delux_update.sh

  echo "$(read_local_version)" > "$LOCAL_VERSION_FILE"

  dialog --msgbox "✅ Updated to version $(read_local_version).\nYou may now select your platform again." 8 50
}

cd "$(dirname "$0")"
[[ ! -f "$INIT_FLAG" ]] && init_loading

while true; do
  check_update

  OPTIONS=(
    i "Info"
    1 "macOS"
    2 "Linux"
    3 "Termux (Android)"
    4 "SSH (Remote Login)"
  )

  if [[ $UPDATE_AVAILABLE -eq 1 ]]; then
    OPTIONS+=(5 "Update to latest version")
  fi

  CHOICE=$(dialog --clear \
    --title "Delux Installer" \
    --menu "${UPDATE_MSG}\nChoose your platform:" 16 70 10 \
    "${OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

  clear

  case "$CHOICE" in
    i)
      show_info
      ;;
    1) SCRIPT="./delux_mac.sh"; break ;;
    2) SCRIPT="./delux_linux.sh"; break ;;
    3) SCRIPT="./delux_termux.sh"; break ;;
    4) SCRIPT="./delux_ssh.sh"; break ;;
    5) update_now; continue ;;
    *) echo "❌ Invalid selection."; exit 1 ;;
  esac
done

if [[ -f "$SCRIPT" ]]; then
  chmod +x "$SCRIPT"
  echo "🚀 Running $SCRIPT..."
  "$SCRIPT"
else
  echo "❌ File not found: $SCRIPT"
  exit 1
fi