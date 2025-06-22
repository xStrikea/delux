#!/data/data/com.termux/files/usr/bin/bash

CURRENT_DIR="$HOME"
EDITOR_CMD="nano" 

function list_items() {
  CHOICES=(".." "Go back")
  for f in "$CURRENT_DIR"/.* "$CURRENT_DIR"/*; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    [[ "$name" == "." || "$name" == ".." ]] && continue
    CHOICES+=("$name" "")
  done

  dialog --title "delux - $CURRENT_DIR" \
         --menu "Select a file or folder:" 20 60 15 \
         "${CHOICES[@]}" 2>choice.txt

  RESULT=$?
  CHOICE=$(<choice.txt)
  rm -f choice.txt
  [[ $RESULT -ne 0 ]] && exit
}

function file_actions() {
  FILE="$CURRENT_DIR/$1"
  EXT="${1##*.}"

  TYPE="file"
  case "$EXT" in
    mp3|wav|mp4|mov|jpg|png|gif|webp) TYPE="media" ;;
    sh) TYPE="shell" ;;
    bin|exe|run|app) TYPE="executable" ;;
  esac

  case "$TYPE" in
    media)
      dialog --menu "Choose action for $1" 10 40 2 1 "Delete" 2 "Rename" 2>action.txt ;;
    executable)
      dialog --yesno "Are you sure you want to delete $1?" 7 40 || return
      dialog --menu "Choose action for $1" 10 40 2 1 "Delete" 2 "Rename" 2>action.txt ;;
    shell)
      dialog --menu "Choose action for $1" 10 40 4 \
        1 "Delete" 2 "Edit" 3 "Rename" 4 "Open/Run" 2>action.txt ;;
    *)
      dialog --menu "Choose action for $1" 10 40 3 \
        1 "Delete" 2 "Edit" 3 "Rename" 2>action.txt ;;
  esac

  ACTION=$(<action.txt); rm -f action.txt
  case "$ACTION" in
    1) rm "$FILE" ;;
    2) $EDITOR_CMD "$FILE" ;;
    3)
      NEWNAME=$(dialog --inputbox "New name:" 8 40 "$1" 3>&1 1>&2 2>&3)
      [[ -n "$NEWNAME" ]] && mv "$FILE" "$CURRENT_DIR/$NEWNAME"
      ;;
    4)
      chmod +x "$FILE"
      "$FILE"
      ;;
  esac
}

while true; do
  list_items
  TARGET="$CHOICE"
  TARGET_PATH="$CURRENT_DIR/$TARGET"
  if [[ "$TARGET" == ".." || "$TARGET" == "Go back" ]]; then
    CURRENT_DIR=$(dirname "$CURRENT_DIR")
  elif [[ -d "$TARGET_PATH" ]]; then
    CURRENT_DIR="$TARGET_PATH"
  elif [[ -f "$TARGET_PATH" ]]; then
    file_actions "$TARGET"
  fi
done