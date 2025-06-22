#!/usr/bin/env bash

# 本地版本檔案名稱
LOCAL_VERSION_FILE=".delux_version"
# 預設本地版本號（當無本地版本檔時使用）
DEFAULT_LOCAL_VERSION="0.3.2"

# 遠端版本檔案網址
REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"

# 初始化標記檔
INIT_FLAG=".delux_init_done"

# 讀取本地版本，如果沒檔案回傳預設版本號
function read_local_version() {
  if [[ -f "$LOCAL_VERSION_FILE" ]]; then
    cat "$LOCAL_VERSION_FILE" | tr -d '\r\n %'
  else
    echo "$DEFAULT_LOCAL_VERSION"
  fi
}

# 初始化畫面（用 dialog 顯示）
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

# 檢查遠端版本是否有更新
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

# 更新 Delux：刪除原 bash 目錄後重新 clone，並更新版本號
function update_now() {
  echo "🚀 Updating Delux..."

  # 移除舊的 bash 目錄
  rm -rf delux/bash

  # 重新 clone 只取 bash 目錄 (用 --depth 1 節省時間)
  git clone --depth 1 https://github.com/xStrikea/delux.git

  if [[ -d "delux/bash" ]]; then
    echo "✅ Clone completed."

    # 更新版本號檔案
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

# 主腳本開始

cd "$(dirname "$0")"

[[ ! -f "$INIT_FLAG" ]] && init_loading

while true; do
  check_update

  OPTIONS=(
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
    --menu "${UPDATE_MSG}\nChoose your platform:" 14 60 6 \
    "${OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

  clear

  case "$CHOICE" in
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