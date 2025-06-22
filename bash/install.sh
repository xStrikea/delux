#!/usr/bin/env bash

# 確保 dialog 已安裝
if ! command -v dialog &> /dev/null; then
  echo "❌ 'dialog' is not installed. Please install it first."
  exit 1
fi

# 切換到此 script 所在目錄（bash 資料夾）
cd "$(dirname "$0")"

# 顯示選單
CHOICE=$(dialog --clear \
  --title "Delux Installer" \
  --menu "Choose your platform:" 10 40 3 \
  1 "macOS" \
  2 "Linux" \
  3 "Termux" \
  3>&1 1>&2 2>&3)

clear

# 根據選擇設定腳本名稱
case "$CHOICE" in
  1) SCRIPT="./delux_mac.sh" ;;
  2) SCRIPT="./delux_linux.sh" ;;
  3) SCRIPT="./delux_termux.sh" ;;
  *)
    echo "❌ Invalid selection."
    exit 1
    ;;
esac

# 檢查腳本是否存在
if [[ ! -f "$SCRIPT" ]]; then
  echo "❌ File not found: $SCRIPT"
  exit 1
fi

# 提升權限並執行
chmod +x "$SCRIPT"
echo "🚀 Running $SCRIPT..."
"$SCRIPT"