#!/usr/bin/env zsh
set -euo pipefail

LOG_DIR="$HOME/projects/log-sentinel/logs"
REPORT_DIR="$HOME/projects/log-sentinel/reports"
TARGET_LOG="$LOG_DIR/app.log"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
REPORT_FILE="$REPORT_DIR/report_$TIMESTAMP.md"

echo "[*] Parsing log file for anomalies..."

# 1. Metric Extraction
# Count total lines in the file
TOTAL_LINES=$(wc -l < "$TARGET_LOG")
# Count occurrences of specific HTTP status codes (404 Not Found, 500 Server Error)
ERROR_404_COUNT=$(grep -c " 404 " "$TARGET_LOG" || true)
ERROR_500_COUNT=$(grep -c " 500 " "$TARGET_LOG" || true)

# 2. Extract Top 3 IPs causing 404 errors using awk and sort
TOP_IPS=$(grep " 404 " "$TARGET_LOG" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 3 || true)

# 3. Generate Markdown Report using a Here-Document
cat << EOF > "$REPORT_FILE"
# 🚨 Sentinel Incident Report
- **Time:** $(date -u)
- **Total Logs Analyzed:** $TOTAL_LINES
- **404 Errors:** $ERROR_404_COUNT
- **500 Critical Errors:** $ERROR_500_COUNT

## Top IPs Causing 404 Errors
\`\`\`text
$TOP_IPS
\`\`\`
EOF

# Export variables so the Discord script can read them
export ERROR_500_COUNT
export REPORT_FILE

echo "[+] Analysis complete. Report generated at $REPORT_FILE"
