#!/usr/bin/env bash

# ==========================
# Delux Developer File Manager
# ==========================

VERSION="dev-1.0"
CURRENT_DIR="$PWD"

function header() {
  clear
  echo "==============================="
  echo "🛠️  Delux Dev Terminal Manager"
  echo "📦 Version: $VERSION"
  echo "📁 Current: $CURRENT_DIR"
  echo "==============================="
}

function list_files() {
  echo ""
  echo "📂 Directory: $1"
  echo ""
  local i=1
  FILES=()
  for entry in "$1"/*; do
    FILES+=("$entry")
    name=$(basename "$entry")
    if [ -d "$entry" ]; then
      echo "  [$i] 📁 $name/"
    else
      echo "  [$i] 📄 $name"
    fi
    i=$((i + 1))
  done
  echo ""
  echo "  [0] 🔙 Go Back"
}

function prompt_action() {
  echo ""
  echo "Choose a file number (or 0 to go back):"
  read -rp ">> " index

  if ! [[ "$index" =~ ^[0-9]+$ ]]; then
    echo "❌ Invalid input."
    return
  fi

  if [ "$index" -eq 0 ]; then
    cd ..
    return
  fi

  selected="${FILES[$((index - 1))]}"
  if [ -z "$selected" ]; then
    echo "❌ Invalid selection."
    return
  fi

  if [ -d "$selected" ]; then
    cd "$selected" || return
  else
    echo ""
    echo "📄 File: $(basename "$selected")"
    echo "[1] View"
    echo "[2] Rename"
    echo "[3] Delete"
    echo "[4] Back"
    read -rp "Select action: " action

    case "$action" in
      1) less "$selected" ;;
      2)
        read -rp "New name: " newname
        mv "$selected" "$(dirname "$selected")/$newname"
        echo "✅ Renamed."
        ;;
      3)
        read -rp "Are you sure you want to delete it? (y/N): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
          rm "$selected"
          echo "🗑️ Deleted."
        fi
        ;;
      *) ;;
    esac
  fi
}

# Main loop
while true; do
  header
  list_files "$PWD"
  prompt_action
done