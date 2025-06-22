#!/usr/bin/env bash

INIT_FLAG=".delux_init_done"
）
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

cd "$(dirname "$0")"

if [[ ! -f "$INIT_FLAG" ]]; then
  init_loading
fi

CHOICE=$(dialog --clear \
  --title "Delux Installer" \
  --menu "Choose your platform:" 12 50 4 \
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