#!/usr/bin/env bash

echo "Delux SSH Mode"
echo "=================="
echo "Welcome! You are in Delux SSH CLI file manager."
echo "Current directory: $(pwd)"
echo

while true; do
  echo "📁 Files:"
  ls -la --color=auto
  echo
  echo "Choose an action:"
  echo "[1] View file"
  echo "[2] Delete file"
  echo "[3] Rename file"
  echo "[4] Change directory"
  echo "[5] Exit"
  read -p "> " choice

  case "$choice" in
    1)
      read -p "Enter filename to view: " fname
      if [[ -f "$fname" ]]; then
        echo "------ $fname ------"
        less "$fname"
      else
        echo "❌ File not found."
      fi
      ;;
    2)
      read -p "Enter filename to delete: " fname
      if [[ -e "$fname" ]]; then
        read -p "Are you sure you want to delete '$fname'? (y/n) " confirm
        [[ "$confirm" == [Yy] ]] && rm -i "$fname"
      else
        echo "❌ File not found."
      fi
      ;;
    3)
      read -p "Enter filename to rename: " fname
      if [[ -e "$fname" ]]; then
        read -p "Enter new name: " newname
        mv "$fname" "$newname"
        echo "✅ Renamed."
      else
        echo "❌ File not found."
      fi
      ;;
    4)
      read -p "Enter directory to enter: " dir
      if [[ -d "$dir" ]]; then
        cd "$dir" || echo "❌ Cannot enter directory."
      else
        echo "❌ Not a directory."
      fi
      ;;
    5)
      echo "👋 Goodbye!"
      exit 0
      ;;
    *)
      echo "❗ Invalid option."
      ;;
  esac

  echo
done