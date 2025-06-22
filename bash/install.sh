#!/usr/bin/env bash

INIT_FLAG=".delux_init_done"
LOCAL_VERSION_FILE=".delux_version"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"
LOCAL_VERSION="0.2"

# 設定本地版本（第一次使用時）
if [[ ! -f "$LOCAL_VERSION_FILE" ]]; then
  echo "$LOCAL_VERSION" > "$LOCAL_VERSION_FILE"
fi

function check_update() {
  if command -v curl &> /dev/null; then
    REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r')

    if [[ -n "$REMOTE_VERSION" && "$REMOTE_VERSION" != "$(cat $LOCAL_VERSION_FILE)" ]]; then
      UPDATE_MSG="🔔 New version available: v$REMOTE_VERSION"
      UPDATE_AVAILABLE=1
    else
      UPDATE_MSG="✔ You are using the latest version: v$LOCAL_VERSION"
      UPDATE_AVAILABLE=0
    fi
  else
    UPDATE_MSG="ℹ️ Could not check for updates (curl not installed)"
    UPDATE_AVAILABLE=0
  fi
}

function init_loading() {
  {
    echo "10" ; echo "Checking dialog..."
    sleep 1

    if ! command -v dialog &> /dev/null; then
      echo "100" ; echo "Dialog not installed. Please install it."
      sleep 2
      clear
      echo "❌ 'dialog' is not installed. Please install it first."
      exit 1
    fi

    echo "40" ; echo "Setting up..."
    sleep 1
    cd "$(dirname "$0")" || exit 1

    echo "70" ; echo "Preparing Delux..."
    sleep 1

    echo "100" ; echo "Initialization complete."
    sleep 1
  } | dialog --title "Delux Installer" --gauge "Initializing, please wait..." 10 60 0

  touch "$INIT_FLAG"
}

function update_now() {
  echo "🚀 Updating repository..."
  git pull origin main

  # 重新取得遠端版本
  REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r')
  if [[ -n "$REMOTE_VERSION" ]]; then
    echo "$REMOTE_VERSION" > "$LOCAL_VERSION_FILE"
  fi
  echo "✅ Update complete. Please run ./install.sh again."
  exit 0
}

cd "$(dirname "$0")"
check_update
[[ ! -f "$INIT_FLAG" ]] && init_loading

OPTIONS=(
  1 "macOS"
  2 "Linux"
  3 "Termux (Android)"
  4 "SSH (Remote Login)"
)

if [[ $UPDATE_AVAILABLE -eq 1 ]]; then
  OPTIONS+=(5 "Update Now")
fi

CHOICE=$(dialog --clear \
  --title "Delux Installer v$LOCAL_VERSION" \
  --menu "$UPDATE_MSG\nChoose your platform:" 14 60 6 \
  "${OPTIONS[@]}" \
  3>&1 1>&2 2>&3)

clear

case "$CHOICE" in
  1) SCRIPT="./delux_mac.sh" ;;
  2) SCRIPT="./delux_linux.sh" ;;
  3) SCRIPT="./delux_termux.sh" ;;
  4) SCRIPT="./delux_ssh.sh" ;;
  5) update_now ;;
  *) echo "❌ Invalid selection."; exit 1 ;;
esac

if [[ ! -f "$SCRIPT" ]]; then
  echo "❌ File not found: $SCRIPT"
  exit 1
fi

chmod +x "$SCRIPT"
echo "🚀 Running $SCRIPT..."
"$SCRIPT"