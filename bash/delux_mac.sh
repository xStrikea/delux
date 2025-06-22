#!/usr/bin/env bash

AUTHOR="xStrikea"
VERSION="0.3.4"
GPL_INFO="GNU GENERAL PUBLIC LICENSE v3 (see README or LICENSE file)"

LAST_DIR_FILE="$HOME/.delux_last_dir"

# 讀取上次目錄，預設家目錄
if [[ -f "$LAST_DIR_FILE" ]]; then
  CURRENT_DIR=$(cat "$LAST_DIR_FILE")
  [[ ! -d "$CURRENT_DIR" ]] && CURRENT_DIR="$HOME"
else
  CURRENT_DIR="$HOME"
fi

function show_info() {
  dialog --title "Delux Info" --msgbox "Author: $AUTHOR\nVersion: $VERSION\n\n$GPL_INFO" 15 60
}

function browse_dir() {
  while true; do
    FILES=()
    # 顯示..和info選項在最前面
    FILES+=(.. "Go Back")
    FILES+=(info "Show Info")

    # 讀取該目錄檔案（包含隱藏檔）
    while IFS= read -r -d '' file; do
      basefile=$(basename "$file")
      FILES+=("$basefile" "")
    done < <(find "$CURRENT_DIR" -maxdepth 1 -mindepth 1 -print0 | sort -z)

    CHOICE=$(dialog --clear --title "Delux - $CURRENT_DIR" --menu "Select file/folder:" 20 60 15 "${FILES[@]}" 3>&1 1>&2 2>&3)
    RET=$?
    clear
    if [[ $RET -ne 0 ]]; then
      # Cancel or ESC pressed, exit
      break
    fi

    if [[ "$CHOICE" == ".." ]]; then
      # 返回上一層
      CURRENT_DIR=$(dirname "$CURRENT_DIR")
      [[ -z "$CURRENT_DIR" ]] && CURRENT_DIR="/"
    elif [[ "$CHOICE" == "info" ]]; then
      show_info
    else
      SELECTED="$CURRENT_DIR/$CHOICE"
      if [[ -d "$SELECTED" ]]; then
        # 進入資料夾
        CURRENT_DIR="$SELECTED"
      else
        # 是檔案，彈選操作
        file_action "$SELECTED"
      fi
    fi
  done

  # 離開前保存目錄
  echo "$CURRENT_DIR" > "$LAST_DIR_FILE"
}

function file_action() {
  local file="$1"
  local basefile=$(basename "$file")

  ACTION=$(dialog --menu "File: $basefile\nSelect action:" 10 50 6 \
    1 "Open" \
    2 "Rename" \
    3 "Delete" \
    4 "Cancel" \
    3>&1 1>&2 2>&3)
  local RET=$?
  clear
  if [[ $RET -ne 0 ]] || [[ "$ACTION" == "4" ]]; then
    return
  fi

  case "$ACTION" in
    1)
      # 開啟檔案 (sh檔自動chmod+x執行，其它用預設指令open或xdg-open)
      if [[ "$file" == *.sh ]]; then
        chmod +x "$file"
        "$file"
      else
        if command -v open &>/dev/null; then
          open "$file"
        elif command -v xdg-open &>/dev/null; then
          xdg-open "$file"
        else
          dialog --msgbox "Cannot open file: no open/xdg-open command" 6 40
        fi
      fi
      ;;
    2)
      rename_file "$file"
      ;;
    3)
      confirm_delete "$file"
      ;;
  esac
}

function rename_file() {
  local file="$1"
  local basefile=$(basename "$file")
  local dirfile=$(dirname "$file")

  NEWNAME=$(dialog --inputbox "Rename $basefile to:" 8 50 "$basefile" 3>&1 1>&2 2>&3)
  local RET=$?
  clear
  if [[ $RET -ne 0 ]] || [[ -z "$NEWNAME" ]]; then
    return
  fi

  if [[ -e "$dirfile/$NEWNAME" ]]; then
    dialog --msgbox "Error: $NEWNAME already exists!" 6 40
  else
    mv "$file" "$dirfile/$NEWNAME"
  fi
}

function confirm_delete() {
  local file="$1"
  local basefile=$(basename "$file")

  dialog --yesno "Are you sure to delete $basefile?" 7 50
  local RET=$?
  clear
  if [[ $RET -eq 0 ]]; then
    rm -rf "$file"
    dialog --msgbox "$basefile deleted." 5 40
  fi
}

# 執行瀏覽
browse_dir