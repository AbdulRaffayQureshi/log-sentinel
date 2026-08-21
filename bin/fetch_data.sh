#!/usr/bin/env zsh
set -euo pipefail
setopt +o nomatch 

# Find project root dynamically
PROJECT_ROOT="$(pwd)"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$LOG_DIR"
rm -rf "$LOG_DIR"/* 2>/dev/null || true

if [[ -n "${KAGGLE_DATASET:-}" ]]; then
  echo "[*] Fetching Kaggle Dataset: $KAGGLE_DATASET..."
  kaggle datasets download -d "$KAGGLE_DATASET" -p "$LOG_DIR" --unzip
  DOWNLOADED_FILE=$(find "$LOG_DIR" -type f | head -n 1)
  if [[ -n "$DOWNLOADED_FILE" ]]; then
    mv "$DOWNLOADED_FILE" "$LOG_DIR/app.log"
  fi
elif [[ -n "${API_URL:-}" ]]; then
  echo "[*] Fetching Live API Data..."
  if [[ -n "${API_HEADER:-}" ]]; then
    curl -s -H "$API_HEADER" "$API_URL" > "$LOG_DIR/app.log"
  else
    curl -s "$API_URL" > "$LOG_DIR/app.log"
  fi
fi
echo "[+] Data ready at $LOG_DIR/app.log"
