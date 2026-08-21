#!/usr/bin/env zsh
set -euo pipefail

LOG_DIR="$HOME/projects/log-sentinel/logs"
# Grab dataset from GitHub Actions, default to the big one if empty
DATASET="${KAGGLE_DATASET:-eliasdabbas/web-server-access-logs}"

echo "[*] Fetching logs for $DATASET..."

# Clear out any old logs so pipelines don't mix data
rm -f "$LOG_DIR"/*

# Download and unzip
kaggle datasets download -d $DATASET -p "$LOG_DIR" --unzip

# Automatically find the extracted file and rename it to app.log
DOWNLOADED_FILE=$(ls "$LOG_DIR" | head -n 1)
mv "$LOG_DIR/$DOWNLOADED_FILE" "$LOG_DIR/app.log"

echo "[+] Data successfully downloaded to $LOG_DIR/app.log"
