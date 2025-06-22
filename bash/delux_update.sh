#!/usr/bin/env bash

REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"
LOCAL_VERSION_FILE=".delux_version"

echo "🚀 Updating Delux repository..."

cd "$(dirname "$0")" || exit 1

if git pull origin main; then
  echo "✅ Repository updated successfully."

  # 清除所有 sh 腳本（只刪除你需要更新的）
  echo "🧹 Cleaning old .sh files..."
  rm -f delux_linux.sh delux_mac.sh delux_termux.sh delux_ssh.sh

  # 還原最新檔案（從 Git）
  echo "📥 Restoring updated .sh files from Git..."
  git checkout origin/main -- delux_linux.sh delux_mac.sh delux_termux.sh delux_ssh.sh

  # 抓遠端版本號
  if command -v curl &> /dev/null; then
    REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r\n %')
    if [[ -n "$REMOTE_VERSION" ]]; then
      echo "$REMOTE_VERSION" > "$LOCAL_VERSION_FILE"
      echo "📦 Updated to version: $REMOTE_VERSION"
    else
      echo "⚠️ Failed to fetch remote version info."
    fi
  else
    echo "⚠️ curl not installed. Skipping version update."
  fi
else
  echo "❌ Failed to update repository. Check network or git config."
  exit 1
fi

echo "🔚 Update process finished."