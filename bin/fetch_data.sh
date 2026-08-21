#!/usr/bin/env zsh
set -euo pipefail

LOG_DIR="$HOME/projects/log-sentinel/logs"
DATASET="eliasdabbas/web-server-access-logs"

echo "[*] Fetching latest server logs from Kaggle..."

# Download and unzip the dataset directly into the logs folder
kaggle datasets download -d $DATASET -p "$LOG_DIR" --unzip

# The dataset extracts a file named 'access.log'. Rename it for our pipeline.
mv "$LOG_DIR"/access.log "$LOG_DIR/app.log" 2>/dev/null || true

echo "[*] Data successfully downloaded to $LOG_DIR/app.log"

