#!/usr/bin/env bash

REMOTE_VERSION_URL="https://raw.githubusercontent.com/xStrikea/delux/refs/heads/main/bash/version.txt"
LOCAL_VERSION_FILE=".delux_version"

echo "🚀 Updating Delux repository..."

if git pull origin main; then
  echo "✅ Repository updated successfully."

  if command -v curl &> /dev/null; then
    REMOTE_VERSION=$(curl -s "$REMOTE_VERSION_URL" | tr -d '\r')
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