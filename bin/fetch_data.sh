#!/usr/bin/env zsh
set -euo pipefail
# Tell Zsh not to crash if a wildcard (*) finds nothing temporarily
setopt +o nomatch 

LOG_DIR="$HOME/projects/log-sentinel/logs"

# Safely clean the directory without crashing if it is already empty
rm -rf "$LOG_DIR"/* 2>/dev/null || true

if [[ -n "${KAGGLE_DATASET:-}" ]]; then
  echo "[*] Fetching Kaggle Dataset: $KAGGLE_DATASET..."
  kaggle datasets download -d "$KAGGLE_DATASET" -p "$LOG_DIR" --unzip
  
  # Intelligently find the downloaded file and rename it
  DOWNLOADED_FILE=$(find "$LOG_DIR" -type f | head -n 1)
  
  if [[ -n "$DOWNLOADED_FILE" ]]; then
      mv "$DOWNLOADED_FILE" "$LOG_DIR/app.log"
      echo "[+] Successfully prepared app.log"
  else
      echo "[-] Error: Kaggle download finished but no files were found."
      exit 1
  fi

elif [[ -n "${API_URL:-}" ]]; then
  echo "[*] Fetching Live API Data..."
  # Download live API data directly to app.log so the parser can read it
  curl -s "$API_URL" > "$LOG_DIR/app.log"
  echo "[+] Live data fetched successfully!"
fi
