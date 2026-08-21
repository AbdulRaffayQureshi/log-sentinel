#!/usr/bin/env zsh
set -euo pipefail
setopt +o nomatch 
LOG_DIR="$HOME/projects/log-sentinel/logs"
rm -rf "$LOG_DIR"/* 2>/dev/null || true

if [[ -n "${KAGGLE_DATASET:-}" ]]; then
  kaggle datasets download -d "$KAGGLE_DATASET" -p "$LOG_DIR" --unzip
  mv $(find "$LOG_DIR" -type f \vert{} head -n 1) "$LOG_DIR/app.log"
elif [[ -n "${API_URL:-}" ]]; then
  # Accepts custom headers for bioinformatics databases
  curl -s -H "${API_HEADER:-Accept: application/json}" "$API_URL" > "$LOG_DIR/app.log"
fi
