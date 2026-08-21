#!/usr/bin/env zsh
set -euo pipefail

WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"

if [[ -z "$WEBHOOK_URL" ]]; then
    echo "[-] Discord Webhook URL not set. Skipping notification."
    exit 0
fi

if [[ ${ERROR_500_COUNT:-0} -gt 0 ]]; then
    echo "[*] Critical errors detected! Sending Discord embed..."
    
    # Get current timestamp in ISO 8601 format for Discord
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Build a professional Discord Rich Embed
    JSON_PAYLOAD=$(jq -n \
      --arg source_name "${SOURCE_NAME:-Unknown Source}" \
      --arg total "$TOTAL_LINES" \
      --arg err404 "$ERROR_404_COUNT" \
      --arg err500 "$ERROR_500_COUNT" \
      --arg ips "$TOP_IPS" \
      --arg ts "$TIMESTAMP" \
      '{
        content: "🔥 **CRITICAL SERVER ALERT** 🔥",
        embeds: [{
          title: ("🚨 Sentinel Incident Report: " + $source_name),
          color: 16711680,
          fields: [
            { name: "📊 Total Logs", value: $total, inline: true },
            { name: "⚠️ 404 Errors", value: $err404, inline: true },
            { name: "🛑 500 Errors", value: $err500, inline: true },
            { name: "🕵️ Top IPs Causing 404s", value: ("```text\n" + $ips + "\n```"), inline: false }
          ],
          footer: { text: "Automated Sentinel Agent" },
          timestamp: $ts
        }]
      }')
    
    curl -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"
    echo -e "\n[+] Discord notification sent."
else
    echo "[+] System stable. No Discord alert needed."
fi
