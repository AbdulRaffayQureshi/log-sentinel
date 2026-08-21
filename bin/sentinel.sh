#!/usr/bin/env zsh
set -euo pipefail

LOG_DIR="$HOME/projects/log-sentinel/logs"
REPORT_DIR="$HOME/projects/log-sentinel/reports"
TARGET_LOG="$LOG_DIR/app.log"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
REPORT_FILE="$REPORT_DIR/report_$TIMESTAMP.md"

# Grab the dynamic source name, default to "Web Server" if not set
SOURCE_NAME="${DATA_SOURCE_NAME:-Web Server}"

echo "[*] Parsing log file for anomalies..."

TOTAL_LINES=$(wc -l < "$TARGET_LOG")
ERROR_404_COUNT=$(grep -c " 404 " "$TARGET_LOG" || true)
ERROR_500_COUNT=$(grep -c " 500 " "$TARGET_LOG" || true)

TOP_IPS=$(grep " 404 " "$TARGET_LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 3 || true)

cat << EOF > "$REPORT_FILE"
# 🚨 Sentinel Incident Report: $SOURCE_NAME
- **Time:** $(date -u)
- **Total Logs Analyzed:** $TOTAL_LINES
- **404 Errors:** $ERROR_404_COUNT
- **500 Critical Errors:** $ERROR_500_COUNT

## Top IPs Causing 404 Errors
\`\`\`text
$TOP_IPS
\`\`\`
EOF

# Export EVERYTHING for the new Discord Embed
export ERROR_500_COUNT ERROR_404_COUNT TOTAL_LINES TOP_IPS SOURCE_NAME REPORT_FILE

echo "[+] Analysis complete. Report generated at $REPORT_FILE"
