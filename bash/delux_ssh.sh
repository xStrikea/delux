#!/usr/bin/env bash

AUTHOR="xStrikea"
VERSION="0.3.4"
GPL_INFO="GNU GENERAL PUBLIC LICENSE v3 (see README or LICENSE file)"

LAST_DIR_FILE="$HOME/.delux_last_dir"

if [[ -f "$LAST_DIR_FILE" ]]; then
  CURRENT_DIR=$(cat "$LAST_DIR_FILE")
  [[ ! -d "$CURRENT_DIR" ]] && CURRENT_DIR="$HOME"
else
  CURRENT_DIR="$HOME"
fi

function show_info() {
  clear
  echo "Author: $AUTHOR"
  echo "Version: $VERSION"
  echo
  echo "$GPL_INFO"
  echo
  read -rp "Press Enter to continue..."
}

function browse_dir() {
  while true; do
    clear
    echo "Delux - Browsing: $CURRENT_DIR"
    echo "-----------------------------------------"
    echo "0) .. (Go Back)"
    echo "i) Info"
    echo

    mapfile -t FILES < <(find "$CURRENT_DIR" -maxdepth 1 -mindepth 1 | sort)
    local index=1
    declare -A FILEMAP=()
    for f in "${FILES[@]}"; do
      basefile=$(basename "$f")
      echo "$index) $basefile"
      FILEMAP[$index]="$f"
      ((index++))
    done

    echo
    read -rp "Select file/folder (q to quit): " choice

    if [[ "$choice" == "q" ]]; then
      break
    elif [[ "$choice" == "0" ]]; then
      CURRENT_DIR=$(dirname "$CURRENT_DIR")
      [[ -z "$CURRENT_DIR" ]] && CURRENT_DIR="/"
    elif [[ "$choice" == "i" ]]; then
      show_info
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [[ -n "${FILEMAP[$choice]}" ]]; then
      selected="${FILEMAP[$choice]}"
      if [[ -d "$selected" ]]; then
        CURRENT_DIR="$selected"
      else
        file_action "$selected"
      fi
    else
      echo "Invalid choice."
      sleep 1
    fi
  done
  echo "$CURRENT_DIR" > "$LAST_DIR_FILE"
}

function file_action() {
  local file="$1"
  local basefile=$(basename "$file")

  echo "File: $basefile"
  echo "1) Delete"
  echo "2) Rename"
  echo "3) Execute (if executable)"
  echo "4) Cancel"
  read -rp "Choose action: " action

  case "$action" in
    1)
      read -rp "Are you sure to delete $basefile? (y/N): " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$file"
        echo "$basefile deleted."
        read -rp "Press Enter to continue..."
      fi
      ;;
    2)
      read -rp "Enter new name for $basefile: " newname
      if [[ -z "$newname" ]]; then
        echo "Rename cancelled."
      elif [[ -e "$(dirname "$file")/$newname" ]]; then
        echo "File $newname already exists!"
      else
        mv "$file" "$(dirname "$file")/$newname"
        echo "Renamed to $newname."
      fi
      read -rp "Press Enter to continue..."
      ;;
    3)
      if [[ -x "$file" ]]; then
        "$file"
      else
        echo "File is not executable."
        read -rp "Press Enter to continue..."
      fi
      ;;
    *)
      ;;
  esac
}

browse_dir