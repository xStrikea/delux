#!/usr/bin/env bash

VERSION="0.3"
AUTHOR="xStrikea"
LICENSE_FILE="LICENSE.txt"

show_info() {
  dialog --msgbox "Delux Terminal File Manager\n\nAuthor: $AUTHOR\nVersion: $VERSION\n\nLicense: GNU General Public License v3.0\n\nVisit: https://fsf.org/" 12 60
}

show_progress_delete() {
  (for i in {1..100}; do echo $i; sleep 0.005; done) | \
    dialog --gauge "Deleting file..." 8 40 0
}

browse_folder() {
  local folder="$1"
  while true; do
    cd "$folder" || exit 1

    local options=()
    options+=(".." "Go back")
    options+=("INFO" "About Delux")

    for item in .* *; do
      [[ "$item" == "." || "$item" == ".." ]] && continue
      options+=("$item" "")
    done

    choice=$(dialog --clear --title "Delux File Manager (macOS)" \
      --menu "Browsing: $folder" 20 60 14 \
      "${options[@]}" \
      3>&1 1>&2 2>&3)

    [ $? -ne 0 ] && break

    case "$choice" in
      "..")
        cd ..
        folder=$(pwd)
        ;;
      "INFO")
        show_info
        ;;
      *)
        if [ -d "$choice" ]; then
          folder="$folder/$choice"
        else
          action=$(dialog --title "$choice" \
            --menu "Choose an action:" 15 50 5 \
            1 "Open (edit or execute)" \
            2 "Rename" \
            3 "Delete" \
            4 "Cancel" \
            3>&1 1>&2 2>&3)

          case "$action" in
            1)
              if [[ "$choice" == *.sh ]]; then
                chmod +x "$choice"
                bash "$choice"
              else
                dialog --textbox "$choice" 20 60
              fi
              ;;
            2)
              new_name=$(dialog --inputbox "Enter new name:" 8 40 "$choice" 3>&1 1>&2 2>&3)
              [ -n "$new_name" ] && mv "$choice" "$new_name"
              ;;
            3)
              show_progress_delete
              rm -rf "$choice"
              ;;
          esac
        fi
        ;;
    esac
  done
}

if ! command -v dialog &> /dev/null; then
  echo "❌ 'dialog' is not installed."
  exit 1
fi

browse_folder "$(pwd)"