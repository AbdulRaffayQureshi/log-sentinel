#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="logs/app.log"
REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"

# Parse the data
TOTAL_RECORDS=$(wc -l < "$LOG_FILE" || echo "0")
ERRORS_404=$(grep -E " (404|400|403) " "$LOG_FILE" | wc -l || echo "0")
CRITICAL_500=$(grep -E " (500|502|503) " "$LOG_FILE" | wc -l || echo "0")
TOP_IP=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 1 || echo "None found")

# Generate the Markdown Report for GitHub Actions
REPORT_FILE="$REPORT_DIR/report_$(date +%s).md"
cat << MD > "$REPORT_FILE"
## 🛡️ Sentinel Log Analysis
* **Logs Ingested:** $TOTAL_RECORDS
* **4xx Errors:** $ERRORS_404
* **5xx Crashes:** $CRITICAL_500
* **Top Offending IP:**
\`\`\`text
$TOP_IP
\`\`\`
MD

# Export the variables for the Discord script
export PIPELINE_NAME="E-Commerce / Platform Sentinel"
export METRIC_1_NAME="Logs Ingested"; export METRIC_1_VAL="$TOTAL_RECORDS"
export METRIC_2_NAME="4xx Errors";    export METRIC_2_VAL="$ERRORS_404"
export METRIC_3_NAME="5xx Crashes";   export METRIC_3_VAL="$CRITICAL_500"
export MAIN_CONTENT="Top Offending IP:\n$TOP_IP"
export SEND_ALERT=1

# Fire the notification
./bin/notify_discord.sh
