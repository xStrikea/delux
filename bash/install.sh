#!/usr/bin/env bash

# 確保 dialog 已安裝
if ! command -v dialog &> /dev/null; then
  echo "❌ 'dialog' is not installed. Please install it first."
  exit 1
cd "$(dirname "$0")"

CHOICE=$(dialog --clear \
  --title "Delux Installer" \
  --menu "Choose your platform:" 10 40 3 \
  1 "macOS" \
  2 "Linux" \
  3 "Termux" \
  3>&1 1>&2 2>&3)

clear

case "$CHOICE" in
  1) SCRIPT="./delux_mac.sh" ;;
  2) SCRIPT="./delux_linux.sh" ;;
  3) SCRIPT="./delux_termux.sh" ;;
  *) echo "❌ Invalid selection."; exit 1 ;;
esac

if [[ ! -f "$SCRIPT" ]]; then
  echo "❌ File not found: $SCRIPT"
  exit 1
fi

chmod +x "$SCRIPT"
echo "🚀 Running $SCRIPT..."
"$SCRIPT"