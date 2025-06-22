#!/usr/bin/env bash

INIT_FLAG=".delux_init_done"
LOCAL_VERSION_FILE=".delux_version"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/main/version.txt"

# 初始化版本
LOCAL_VERSION="0.2"
if [[ ! -f "$LOCAL_VERSION_FILE" ]]; then
  echo "$LOCAL_VERSION" > "$LOCAL_VERSION_FILE"
fi

function check_update() {
  if command -v curl &> /dev/null; then
    REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r')

    if [[ "$REMOTE_VERSION" != "$(cat $LOCAL_VERSION_FILE)" ]]; then
      UPDATE_MSG="🔔 New version available: v$REMOTE_VERSION"
    else
      UPDATE_MSG="✔ You are using the latest version: v$LOCAL_VERSION"
    fi
  else
    UPDATE_MSG="ℹ️ Could not check for updates (curl not installed)"
  fi
}

# 初始化畫面（僅第一次）
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

# 切換到 script 所在目錄（bash/）
cd "$(dirname "$0")"

# 檢查更新
check_update

# 執行初始化（僅一次）
if [[ ! -f "$INIT_FLAG" ]]; then
  init_loading
fi

# 顯示選單
CHOICE=$(dialog --clear \
  --title "Delux Installer" \
  --menu "$UPDATE_MSG\nChoose your platform:" 12 60 4 \
  1 "macOS" \
  2 "Linux" \
  3 "Termux (Android)" \
  4 "SSH (Remote Login)" \
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