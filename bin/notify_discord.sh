#!/usr/bin/env zsh
set -euo pipefail

# Read webhook URL from environment variables
WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"

if [[ -z "$WEBHOOK_URL" ]]; then
    echo "[-] Discord Webhook URL not set. Skipping notification."
    exit 0
fi

# Only send an alert if there are 500 Critical Errors
if [[ ${ERROR_500_COUNT:-0} -gt 0 ]]; then
    echo "[*] Critical errors detected! Sending Discord alert..."
    
    # Read the first 15 lines of the report to send as the message preview
    REPORT_PREVIEW=$(head -n 15 "$REPORT_FILE")
    
    # Construct the JSON payload using jq to safely escape string characters for curl
    JSON_PAYLOAD=$(jq -n --arg content "🔥 **CRITICAL SERVER ALERT** 🔥\n$REPORT_PREVIEW" '{content: $content}')
    
    # Send the HTTP POST request to Discord via curl
    curl -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"
    echo -e "\n[+] Discord notification sent."
else
    echo "[+] System stable. No Discord alert needed."
fi
