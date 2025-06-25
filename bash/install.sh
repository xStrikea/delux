#!/usr/bin/env bash

LOCAL_VERSION="0.3.4"
INIT_FLAG=".delux_init_done"

function init_loading() {
  if [[ ! -f "$INIT_FLAG" ]]; then
    echo "🔧 Initializing..."
    sleep 1
    touch "$INIT_FLAG"
  fi
}

function run_script() {
  case "$1" in
    1) SCRIPT="delux/bash/delux_mac.sh" ;;
    2) SCRIPT="delux/bash/delux_linux.sh" ;;
    3) SCRIPT="delux/bash/delux_termux.sh" ;;
    4) SCRIPT="delux/bash/delux_ssh.sh" ;;
    5) SCRIPT="delux/bash/dev/delux_dev.sh" ;;
    *) echo "❌ Invalid selection."; exit 1 ;;
  esac

  chmod +x "$SCRIPT"
  "$SCRIPT"
}

init_loading

while true; do
  CHOICE=$(dialog --clear --title "Delux Installer (v$LOCAL_VERSION)" --menu "Select platform:" 15 50 8 \
    1 "macOS" \
    2 "Linux" \
    3 "Termux (Android)" \
    4 "SSH" \
    5 "Developer Mode (Bash)" \
    3>&1 1>&2 2>&3)

  clear
  run_script "$CHOICE"
  break
done